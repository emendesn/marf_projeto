#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"                                     

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS22
WS Integração Assincrona de estoque - Processos Produtivos

@author Josué Danich Prestes
@since 02/03/2020 
@type WS  
/*/   


// Estrutura da solicitação de ajuste manual de OP
WSSTRUCT MGFWSS22Ajuste
	WSDATA JSON  	AS string
    WSDATA UUID     AS string
ENDWSSTRUCT

// Retorno de ajuste manual de OP
WSSTRUCT MGFWSS22Retorno
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Produção.				                       *
***************************************************************************/
WSSERVICE MGFWSS22 DESCRIPTION "Ajuste manual de OP Taura - Protheus" NameSpace "http://totvs.com.br/MGFWSS22.apw"

	// Produção - Passagem dos parâmetros de entrada
	WSDATA MGFWSS22Aj AS MGFWSS22Ajuste
	// Produção - Retorno (array)
	WSDATA MGFWSS22Ret AS MGFWSS22Retorno

	WSMETHOD AjManualTaura DESCRIPTION "Ajuste manual de OP Taura - Protheus"

ENDWSSERVICE

/************************************************************************************
** Metodo AjManualTaura
** Grava solicitação de ajustes manuais do Taura
************************************************************************************/
WSMETHOD AjManualTaura WSRECEIVE	MGFWSS22Aj WSSEND MGFWSS22Ret WSSERVICE MGFWSS22

	Local aRetFuncaadmino := {}
	Local lReturn	:= .T.
	Local _cuuid := IIF(::MGFWSS22Aj:UUID<>NIL,::MGFWSS22Aj:UUID,"")

    BEGIN SEQUENCE

    If empty(_cuuid)

        ::MGFWSS22Ret :=  WSClassNew( "MGFWSS22Retorno" )
	    ::MGFWSS22Ret:STATUS	:= "2"
	    ::MGFWSS22Ret:MSG		:= "Registro recusado por UUID invalido"
        U_MFCONOUT('Registro recusado por UUID invalido!') 
        BREAK

    Endif

    //Valida se não tem outra instância gravando mesma UUID
    If mayiusecode(alltrim(_cuuid))

    	U_MFCONOUT('Recebeu AjManualTaura com UUID ' + _cuuid +"...") 

    	aRetFuncao	:= MGFWSS22(		::MGFWSS22Aj:UUID	,;
	                                ::MGFWSS22Aj:JSON	 )	

    	// Cria e alimenta uma nova instancia de retorno do cliente
	    ::MGFWSS22Ret :=  WSClassNew( "MGFWSS22Retorno" )
    	::MGFWSS22Ret:STATUS	:= aRetFuncao[1][1]
    	::MGFWSS22Ret:MSG		:= aRetFuncao[1][2]

    	U_MFCONOUT('Completou AjManualTaura com UUID ' + _cuuid +" e resultado " + aRetFuncao[1][2] + "...") 

    	DelClassINTF()

        Leave1Code(alltrim(_cuuid))

    Else

        ::MGFWSS22Ret :=  WSClassNew( "MGFWSS22Retorno" )
	    ::MGFWSS22Ret:STATUS	:= "2"
	    ::MGFWSS22Ret:MSG		:= "UUID já está em processamento"
        U_MFCONOUT('Recusou AjManualTaura com UUID ' + _cuuid +" pois já está em processamento...") 
        Break

    Endif

    END SEQUENCE

Return lReturn

Static Function MGFWSS22(_cuuid,_cjson)

Local _aret := {}
Local _json := nil

BEGIN SEQUENCE

U_MFCONOUT('Validando json...') 

//Valida e abre json em array
if fwJsonDeserialize( _cjson, @_json )

    U_MFCONOUT('Validando Tags...') 
    //Valida se a op tem ZZE pendente ou com erro
    If AttIsMemberOf( _json, "FILIAL") 

        If AttIsMemberOf( _json, "OrdemProducao") 

            ZZE->(Dbsetorder(9)) //ZZE_FILIAL+ZZE_OPTAUR

            U_MFCONOUT('Validando registros na ZZE com erro ou pendentes...') 
            If ZZE->(Dbseek(alltrim(_json:FILIAL)+ALLTRIM(str(_json:OrdemProducao))))

                _lachou := .F.

                Do while alltrim(ZZE->ZZE_FILIAL)+alltrim(ZZE->ZZE_OPTAUR) == alltrim(_json:FILIAL)+ALLTRIM(str(_json:OrdemProducao))

                    //Trata erros tipo 2
                    If ZZE->ZZE_STATUS == '2'
                        Reclock("ZZE",.F.)
                        ZZE->ZZE_STATUS := '1'
                        ZZE->ZZE_DTPROC := DATE()
                        ZZE->ZZE_HRPROC := TIME()
                        ZZE->ZZE_DESCER := "Ignorada por ajuste automatico de OP vindo do Taura"
                        ZZE->(Msunlock())
                    Endif

                    If ZZE->ZZE_STATUS = ' ' .OR. ZZE->ZZE_STATUS = '2' .OR. ZZE->ZZE_STATUS = '6' .OR. ZZE->ZZE_STATUS = 'W'
                        _lachou := .T.
                        Exit
                    Endif

                    ZZE->(Dbskip())

                Enddo

                If _lachou
                    aadd(_aret,{"2","Existem registros pendentes ou com erro, consulte a tela de analise de OPs do Protheus!"})
                    U_MFCONOUT('Existem registros pendentes ou com erro, consulte a tela de analise de OPs do Protheus!') 
                    BREAK
                Endif

            Endif

        else

            aadd(_aret,{"2","Tag OrdemProducao inexistente!"})   
            U_MFCONOUT('Tag FILIAL inexistente!') 
            BREAK

        Endif    

    Else

        aadd(_aret,{"2","Tag FILIAL inexistente!"})
        U_MFCONOUT('Tag OrdemProducao inexistente!') 
        BREAK

    Endif

    //Puxa os dados da op da D3
    _aRetorno := u_MTAP15C(alltrim(_json:FILIAL),ALLTRIM(str(_json:OrdemProducao))) //Contido no fonte MGFTAP15

    _azze := {}

    //Compara os dados da op da D3 com json e gera registros na ZZE se necessário
    For _nni := 1 to len(_json:PRODUTOS)

        _np := ascan(_aretorno, {|x| alltrim(x[1]) == strzero(val(alltrim(_json:PRODUTOS[_nni]:PRODUTO)),6);
                                        .AND. alltrim(x[2]) == alltrim(_json:PRODUTOS[_nni]:TIPO) })

        If _np > 0 .and. _aretorno[_np][3] != VAL(alltrim(_json:PRODUTOS[_nni]:QUANTIDADE))

            aadd(_azze,{    strzero(val(alltrim(_json:PRODUTOS[_nni]:PRODUTO)),6),;
                            alltrim(_json:PRODUTOS[_nni]:TIPO),;
                            VAL(alltrim(_json:PRODUTOS[_nni]:QUANTIDADE)) - _aretorno[_np][3] })

        Elseif _np == 0

            aadd(_azze,{    strzero(val(alltrim(_json:PRODUTOS[_nni]:PRODUTO)),6),;
                            alltrim(_json:PRODUTOS[_nni]:TIPO),;
                            VAL(alltrim(_json:PRODUTOS[_nni]:QUANTIDADE))  })

        Endif

    Next

    //Monta resposta com aguardando processamento ou OP pronta para fechamento
    If len(_azze) > 0

        BEGIN TRANSACTION

        For _njk := 1 to len(_azze)

            If _azze[_njk][3] != 0

                //Grava ZZE
                RecLock("ZZE",.T.)
     
                ZZE->ZZE_FILIAL	:=	alltrim(_json:FILIAL)
                ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
                ZZE->ZZE_IDTAUR	:=	"MAN-WS-" + alltrim(_cuuid)
                ZZE->ZZE_ACAO	:=	Iif(_azze[_njk][3]>0,'1','2')
                ZZE->ZZE_OPTAUR	:=	ALLTRIM(str(_json:OrdemProducao))
                ZZE->ZZE_TPOP	:=	'01'
                ZZE->ZZE_TPMOV	:=	iif(_azze[_njk][2]='PR','01','02')
                ZZE->ZZE_GERACA	:=	DTOS(date())
                ZZE->ZZE_EMISSA	:=	DTOS(date())
                ZZE->ZZE_HORA	:=	time()
                ZZE->ZZE_CODPA	:=	_azze[_njk][1]
                ZZE->ZZE_COD	:=	_azze[_njk][1]
                ZZE->ZZE_QUANT	:=	iif(_azze[_njk][3]>0,_azze[_njk][3],-1*_azze[_njk][3])
                ZZE->ZZE_QTDPCS	:=	0
                ZZE->ZZE_QTDCXS	:=	0
                ZZE->ZZE_PEDLOT	:=	" "
                ZZE->ZZE_LOCAL	:=	'05'
                ZZE->ZZE_CHAVEU :=	FWUUIDV4()
                ZZE->ZZE_DTREC  := Date()
                ZZE->ZZE_HRREC  := Time()
                ZZE->ZZE_STATUS := 'W'

                ZZE->( msUnlock() )

            Endif

        Next

        END TRANSACTION


        aadd(_aret,{"1","Ajuste manual salvo na fila de processamento."})


    Else

        aadd(_aret,{"1","Op pronta para fechamento"})

    Endif

else
    
    aadd(_aret,{"2","Json Invalido!"})
    U_MFCONOUT('Json Invalido!') 
    BREAK

Endif

END SEQUENCE

Return _aret


