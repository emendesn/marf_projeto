#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
{Protheus.doc} WGFINT81
Integração de Fornedores a partir do ZH3

@description
Este programa irá integrar fornecedores a partir do ZH3.
Integração no cadastro de fornecedores

@author Edson Bella Gonçalves
@since 11/11/2020

@version P12.1.017
@country Brasil
@language Português

@type Function
@table
	SA2 - Fornecedores
    ZH3 - controle de Integrações via WS
@param
@return

@menu
@history
ZH3_STATUS  - '0' - não processado
            - '1' - processado com sucesso - produtor bloqueado aguardando grade
            - '2' - recusado com falha
            - '3' - callback feito para o salesforce - produtor/banco cadastrado - produtor bloqueado aguardando grade
            - '4' - aprovado grade - produtor DESbloqueado pronto para enviar ao Salesforce
            - '5' - callback feito para o salesforce - produtor DESbloqueado
            - '6' - callback feito para o salesforce - produtor alterado - produtor bloqueado aguardando grade
            - '7' - callback  com erro feito para o salesforce
            - '8' - callback Salesforce - cadastrado com erro
            - '9' - inclusão rejeitada na grade no Protheus.
            - 'A' - callback Salesforce - inclusão rejeitada na grade no Protheus.
            - 'B' - alteração rejeitada na grade no Protheus.
            - 'C' - callback Salesforce - alteração rejeitada na grade no Protheus.

/*/

/* FUNÇÃO SOMENTE PARA CHAMADA EM DEBUG*/
User Function M_GFINT81()

	RpcSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); Else; RpcSetEnv( "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); endif

	U_MGFINT81()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return


User Function MGFINT81()

local cChave    :='SA2'
local cStatus   :='1'
local nOpcX     :=''
local cDesc     :=''
local oJsonD    :=''
local nOpcX     :=0
local _lDeucerto:=.f.

U_MFCONOUT( "Início à integração")

setFunName( "SALESFORCE" )

_cRetHash   := GetNextAlias()

BeginSql Alias _cRetHash

SELECT
	R_E_C_N_O_ REGIS
FROM
	%table:ZH3% ZH3
WHERE
	ZH3_CODINT='008' AND ZH3_CODTIN='018' AND ZH3_STATUS='0' AND
	ZH3.%notDel%
EndSql

dbgoTop()

While !Eof()

    DBSelectArea("ZH3")
    DBGoTo((_cRetHash)->REGIS)

    //deserializar
    cDesc   :=ZH3_REQUES
    oJsonD	:= JsonObject():New()
    cDesSer	:= oJsonD:FromJson(cDesc)
/*  
    if ValTypecDesSer) == "U"
        Conout("JsonObject populado com sucesso")
    else
        Conout("Falha ao popular JsonObject. Erro: " + ret)
    endif
*/

    nOpcX := Val(oJsonD:NEWUPD)

    If nOpcX=3 .or. nOpcX=4 //inc / alt

        _lDeucerto 	:= .F.
        INCLUI		:= nOpcx==3
        ALTERA		:= nOpcx==4

        If ALTERA
            DBSelectArea("SA2")
            DBSetOrder(1)
            If !DBSeek(xFilial("SA2")+oJsonD:A2_COD+oJsonD:A2_LOJA)

                ATUZH3('2','FORNECEDOR '+oJsonD:A2_COD+'/'+oJsonD:A2_LOJA+' INEXISTENTE - ALT','')

                dbSelectArea(_cRetHash)
                dbSkip()
                Loop
            EndIF
            RegToMemory("SA2") //gera as variáveis M->
        EndIF

        BEGIN TRANSACTION

            //inclusão do fornecedor modelo MVC
            //Pegando o modelo de dados, setando a operação de inclusão
            oModel	:= FWLoadModel("MATA020")
            oModel	:SetOperation(nOpcx)
            oModel	:Activate()

            dA2_ZDTNASC:=StoD(oJsonD:A2_ZDTNASC)

            oModel:SetValue("SA2MASTER","A2_ZPROPRI",	oJsonD:A2_ZPROPRI	)
            oModel:SetValue("SA2MASTER","A2_TIPO",		oJsonD:A2_TIPO	    )
            oModel:SetValue("SA2MASTER","A2_NOME",		oJsonD:A2_NOME	    )
            oModel:SetValue("SA2MASTER","A2_ZDTNASC",	dA2_ZDTNASC         )
            oModel:SetValue("SA2MASTER","A2_ZNASCIO",	oJsonD:A2_ZNASCIO	)
            oModel:SetValue("SA2MASTER","A2_ZTPENDE",	oJsonD:A2_ZTPENDE	)
            oModel:SetValue("SA2MASTER","A2_CGC",		oJsonD:A2_CGC		)
            oModel:SetValue("SA2MASTER","A2_ZTPFORN",	oJsonD:A2_ZTPFORN	)
            oModel:SetValue("SA2MASTER","A2_NREDUZ",	oJsonD:A2_NREDUZ	)
            oModel:SetValue("SA2MASTER","A2_END",		oJsonD:A2_END		)
            oModel:SetValue("SA2MASTER","A2_BAIRRO",	oJsonD:A2_BAIRRO	)
            oModel:SetValue("SA2MASTER","A2_EST",		oJsonD:A2_EST		)
            oModel:SetValue("SA2MASTER","A2_COD_MUN",	oJsonD:A2_COD_MUN	)
            oModel:SetValue("SA2MASTER","A2_CEP",		oJsonD:A2_CEP		)
            oModel:SetValue("SA2MASTER","A2_ENDCOMP",	oJsonD:A2_ENDCOMP	)
            oModel:SetValue("SA2MASTER","A2_DDD",		oJsonD:A2_DDD		)
            oModel:SetValue("SA2MASTER","A2_DDI",		oJsonD:A2_DDI		)
            oModel:SetValue("SA2MASTER","A2_TEL",		oJsonD:A2_TEL		)
            oModel:SetValue("SA2MASTER","A2_EMAIL",		oJsonD:A2_EMAIL	    )
            oModel:SetValue("SA2MASTER","A2_INSCR",		oJsonD:A2_INSCR	    )
            oModel:SetValue("SA2MASTER","A2_CODPAIS",	oJsonD:A2_CODPAIS	)
            oModel:SetValue("SA2MASTER","A2_CNAE",		oJsonD:A2_CNAE	    )
            oModel:SetValue("SA2MASTER","A2_ZOBSERV",	oJsonD:A2_ZOBSERV	)
            oModel:SetValue("SA2MASTER","A2_TPESSOA",	oJsonD:A2_TPESSOA	)
            oModel:SetValue("SA2MASTER","A2_TIPORUR",	oJsonD:A2_TIPORUR	)
            oModel:SetValue("SA2MASTER","A2_GRPTRIB",	oJsonD:A2_GRPTRIB	)
            oModel:SetValue("SA2MASTER","A2_NATUREZ",	oJsonD:A2_NATUREZ	)
            oModel:SetValue("SA2MASTER","A2_CONTA",		oJsonD:A2_CONTA	    )
            oModel:SetValue("SA2MASTER","A2_ZEMINFE",	oJsonD:A2_ZEMINFE	)
            oModel:SetValue("SA2MASTER","A2_PAIS",		oJsonD:A2_PAIS	    )
            oModel:SetValue("SA2MASTER","A2_ZCCIR",		oJsonD:A2_ZCCIR	    )
            oModel:SetValue("SA2MASTER","A2_ZNIRF",		oJsonD:A2_ZNIRF	    )
            oModel:SetValue("SA2MASTER","A2_ZCAR",		oJsonD:A2_ZCAR	    )
            oModel:SetValue("SA2MASTER","A2_ZDDDCEL",   oJsonD:A2_ZDDDCEL   )
            oModel:SetValue("SA2MASTER","A2_ZCELULA",   oJsonD:A2_ZCELULA   )
            oModel:SetValue("SA2MASTER","A2_BANCO" ,    oJsonD:FIL_BANCO    )
            oModel:SetValue("SA2MASTER","A2_AGENCIA",   oJsonD:FIL_AGENCI  )
            oModel:SetValue("SA2MASTER","A2_NUMCON",    oJsonD:FIL_CONTA   )
            
            If INCLUI
                //If oJsonD:A2_ZTPFORN=='2' //2 - Rural - permite duplicidade de CPF/CNPJ

                aCod    :=U__INT81cgc(oJsonD:A2_CGC)
                cCod    :=aCod[1]
                cLoja   :=aCod[2]
                lPutMv	:=.t.
                oModel:SetValue("SA2MASTER","A2_COD",		cCod)
                oModel:SetValue("SA2MASTER","A2_LOJA",		cLoja)
            EndIf
                    
            loModel:=oModel:VldData()

            _cMsgVinc:=''

            //Se conseguir validar as informações
            If loModel

                _lDeucerto := .t.
           
                //Grava o vínculo 

                _cCGCVINCULO:=oJsonD:CGCVINCULO
                
                If _cCGCVINCULO<>''

                    _cRetA2cod	:= GetNextAlias()
        
                    BeginSql Alias _cRetA2cod //Busca o CNPJ do vínculo

                        SELECT
                            A2_COD, A2_LOJA, A2_NREDUZ
                        FROM
                            %table:SA2% SA2
                        WHERE
                            A2_FILIAL=%xFilial:SA2% AND A2_CGC=%exp:_cCGCVINCULO% AND A2_LOJA='01' AND SA2.%notDel%
                    EndSql
                
                    dbGoTop()
            
                    If Eof()
                        //Se não deu certo, altera a variável para false
                        _lDeucerto := .F.
                        _cMsgVinc:="Não encontrado o CPF "+oJsonD:CGCVINCULO+" para efetuar o vínculo "+ CRLF
                        _cMsgVinc+="com o CNPJ "+oJsonD:A2_CGC+CRLF
                        
                    Else
                        RecLock("SZA",.t.)
                        SZA->ZA_FILIAL	:=xfilial("SZA")
                        SZA->ZA_CODFORN	:=M->A2_COD
                        SZA->ZA_LOJFORN	:=M->A2_LOJA
                        SZA->ZA_CODFAV	:=(_cRetA2cod)->A2_COD
                        SZA->ZA_LOJFAV	:=(_cRetA2cod)->A2_LOJA
                        SZA->ZA_MSBLQL	:="2"
                        SZA->(MSUNLOCK())
                        
                    End

                    (_cRetA2cod)->(dbcloseArea())

                End

                If _lDeucerto

                    If oModel:CommitData()

                        If INCLUI .And. lPutMv
                            PutMv('MGF_A2COD',M->A2_COD)
                        End
                        RecLock("ZH3",.f.)
                        ZH3->ZH3_CHAVE:=xfilial("SA2")+SA2->A2_COD+SA2->A2_LOJA
                        ZH3->(MsUnLock())

                        If ZH3->ZH3_CODINT='008' .AND. ZH3->ZH3_CODTIN='018' // integração de fornecedores do salesforce
                            U__WSS24ID() //Grava o Id do Salesforce na SA2
                        End
                    Else
                        _lDeucerto:=.f.
                    End
                EndIf
            //Se não conseguir validar as informações, altera a variável para false
            Else
                _lDeucerto := .F.
            EndIf

            If !_lDeucerto

                DisarmTransaction()

                //Busca o Erro do Modelo de Dados
                //aErro := oModel:GetresponseMessage()
                aErro := oModel:aerrormessage

                If INCLUI

                    If !loModel

                        cDesc:="Id do formulário de origem:"	+ ' [' + AllToChar(aErro[01]) + ']'+CRLF
                        cDesc+="Id do campo de origem: "		+ ' [' + AllToChar(aErro[02]) + ']'+CRLF
                        cDesc+="Id do formulário de erro: "	    + ' [' + AllToChar(aErro[03]) + ']'+CRLF
                        cDesc+="Id do campo de erro: "		    + ' [' + AllToChar(aErro[04]) + ']'+CRLF
                        cDesc+="Id do erro: "				    + ' [' + AllToChar(aErro[05]) + ']'+CRLF
                        cDesc+="Mensagem do erro: "			    + ' [' + AllToChar(aErro[06]) + ']'+CRLF
                        If aErro[5]="TAURAOBRIGAT"
                            _cMensSoluc				:="Verificar os campos A2_ZDTNASC "+oJsonD:A2_ZDTNASC+", A2_ZPROPRI "+oJsonD:A2_ZPROPRI+" ou A2_INSCR "+oJsonD:A2_INSCR
                        Else
                            _cMensSoluc				:="Mensagem da solução: ' [" + AllToChar(aErro[07]) + "]' para o CPF/CNPJ "+oJsonD:A2_CGC
                        End
                        cDesc+=_cMensSoluc+CRLF
                        cDesc+="Valor atribuído: "			    + ' [' + AllToChar(aErro[08]) + ']'+CRLF
                        cDesc+="Valor anterior: "			    + ' [' + AllToChar(aErro[09]) + ']'+CRLF
                        ATUZH3('2',cDesc)
                    ElseIf _cMsgVinc<>''
                        ATUZH3('2',_cMsgVinc)
                    Else
                        ATUZH3('2',"ERRO NÃO IDENTIFICADO. ENTRE EM CONTATO COM TI")
                    End
                Else

                    _cDesc:="Mensagem do erro: [" + AllToChar(aErro[06]) + "] fornecedor "
                    _cDesc+=oJsonD:A2_COD+"/"+oJsonD:A2_LOJA +CRLF
                    If aErro[5]="TAURAOBRIGAT"
                        _cDesc+="Verificar os campos A2_ZDTNASC "+oJsonD:A2_ZDTNASC+", A2_ZPROPRI "+oJsonD:A2_ZPROPRI+" ou A2_INSCR "+oJsonD:A2_INSCR +CRLF
                    End

                    ATUZH3('2',_cDesc)

                End
                
            Else
                
                If INCLUI

                    _cFIL_AGENCI    :=oJsonD:FIL_AGENCI
                    _cFIL_BANCO     :=oJsonD:FIL_BANCO
                    _cFIL_CONTA     :=oJsonD:FIL_CONTA
                    _cFIL_DVAGE     :=oJsonD:FIL_DVAGE
                    _cFIL_DVCTA     :=oJsonD:FIL_DVCTA
                    _cFIL_TIPCTA	:=oJsonD:FIL_TIPCTA
                    _cFIL_TIPO      :=oJsonD:FIL_TIPO
                    _cFIL_DETRAC    :=oJsonD:FIL_DETRAC
                    _nFIL_MOEDA     :=Val(oJsonD:FIL_MOEDA)
                    _cFIL_MOVCTO    :=oJsonD:FIL_MOVCTO
                
                //grava o BANCO do pecuarista
                    If _cFIL_BANCO<>''

                        If SA2->A2_LOJA=='01' .And. SA2->A2_TIPO=='F' //Só grava banco se for para a loja 01 e PF
                        
                            dbSelectArea("FIL")
                            RecLock("FIL",.t.)
                            FIL->FIL_FILIAL	:=xFilial("FIL")
                            FIL->FIL_FORNEC	:=SA2->A2_COD
                            FIL->FIL_LOJA	:=SA2->A2_LOJA
                            FIL->FIL_AGENCI	:=_cFIL_AGENCI
                            FIL->FIL_BANCO	:=_cFIL_BANCO
                            FIL->FIL_CONTA	:=_cFIL_CONTA
                            FIL->FIL_DVAGE	:=_cFIL_DVAGE
                            FIL->FIL_DVCTA	:=_cFIL_DVCTA
                            FIL->FIL_TIPCTA	:=_cFIL_TIPCTA
                            FIL->FIL_TIPO	:=_cFIL_TIPO
                            FIL->FIL_DETRAC :=_cFIL_DETRAC
                            FIL->FIL_MOEDA	:=_nFIL_MOEDA
                            FIL->FIL_MOVCTO	:=_cFIL_MOVCTO

                            FIL->(MSUNLOCK())
                        End
                    End
                End

                //Verifica se não criou grade

                If SA2->A2_MSBLQL=='1'
                    _cStatus:='1'
                Else
                    _cStatus:='4'
                End

                If INCLUI
                    ATUZH3(_cStatus,'FORNECEDOR ['+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+allTrim(SA2->A2_NREDUZ)+'] CADASTRADO')
                Else
                    ATUZH3(_cStatus,'FORNECEDOR ['+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+allTrim(SA2->A2_NREDUZ)+'] ALTERADO')
                EndIF
                
            Endif

            //Desativa o modelo de dados
            oModel:DeActivate()

        END TRANSACTION
    EndIf

    DBSelectArea(_cRetHash)
    dbSkip()
End

//---Fechando area de trabalho
(_cRetHash)->(dbcloseArea())

U_MFCONOUT( "FIM à integração")

Return .T.
//

/*/{Protheus.doc} ATUZH3
	Cria registro no ZH3
	@type function

	@param		status do registro, resultado, detalhes do resultado
	@return  	.t.

	@author Edson Bella
	@since 11/11/2020
	@version P12
/*/
Static Function ATUZH3(cStatus,cReturn)

RecLock("ZH3",.f.)

    _cReturn:=DtoC(date())+" - "+Time()+CRLF
		
    ZH3->ZH3_DTPROC	:=DtoC(date())
	ZH3->ZH3_HRPROC	:=time()
	ZH3->ZH3_RETURN :=_cReturn+cReturn
	ZH3->ZH3_STATUS	:=cStatus

MSUNLOCK()

Return .t.


/*/
{Protheus.doc} _INT81cgc
Validação do código de fornecedor

@description
Este programa irá verificar na inclusão se o cpf do fornecedor já existe, e retorna o código com nova loja
Integração no cadastro de fornecedores

@author Edson Bella Gonçalves
@since 12/11/2020

@version P12.1.017
@country Brasil
@language Português

@type Function
@table
	SA2 - Fornecedores
@param
@return

@menu
@history
/*/

User Function _INT81cgc(_cCgc)
_cRetMaxLj	:= GetNextAlias()

BeginSql Alias _cRetMaxLj
	SELECT
		Max(SA2.A2_LOJA) LOJA, Max(SA2.A2_COD) COD
	FROM
		%table:SA2% SA2
	WHERE
		SA2.A2_FILIAL=%xFilial:SA2%
		AND SA2.%notDel%
		AND SA2.A2_CGC=%exp:_cCgc%
EndSql

IF Empty((_cRetMaxLj)->LOJA) //novo pecuarista
	_cCod	:=Ret_Max()
	_cLoja 	:='01'
	_lPutMv	:=.t.
Else						//nova fazenda
	_cCod	:= (_cRetMaxLj)->COD
	_cLoja 	:= Soma1((_cRetMaxLj)->LOJA)
Endif

//---Fechando area de trabalho
(_cRetMaxLj)->(dbcloseArea())

_aRet:={_cCod,_cLoja}

Return _aRet

//
Static Function Ret_Max
	Local cCod    := ''

	_cRetMaxSA2	:= GetNextAlias()
	BeginSql Alias _cRetMaxSA2

		SELECT
			Max(SA2.A2_COD) COD
		FROM
			%table:SA2% SA2
		WHERE
			SA2.%notDel%
			AND SA2.A2_COD < 'A'

	EndSql

	IF Empty((_cRetMaxSA2)->COD)
		cCod := '000001'
	Else
		cCod := Soma1((_cRetMaxSA2)->COD)
	EndIF

	//---Fechando area de trabalho
	(_cRetMaxSA2)->(dbcloseArea())

Return cCod