#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS14 
Integração PROTHEUS x SERASA

@description
Web Service de integração do Relato Serasa x Protheus.
Consumido pelo Barramento para realizar a persistência (CRUD) do Relato no Protheus

@author Rogerio Almeida de Oliveira
@since 08/10/2019 
@type Function  

@table 
    ZEN - Consulta Relato               

@param
    Não se aplica.

@return
    _lRet - Retorno usado na função W14VLDT, indica se a data é válida.

@menu
    Não se aplica.

@history 
     08/10/2019 - Criação dos métodos de consulta e inclusão.
     21/10/2019 - Criação da função que faz a validação do campo data.
     27/11/2019 - Inclusão do campo DTTIME
/*/ 


/*/ 
Estrutura de Dados para gravacao com WS 
@type property
@author Rogerio Almeida
@since 08/10/2019
@version P12
/*/
WSSTRUCT MGFWSS14_RELATO
    WSDATA ID		        AS STRING	
	WSDATA CNPJ		        AS STRING
    WSDATA RELATO	        AS STRING
    WSDATA REL_DESMEMB   	AS STRING
    WSDATA DATACONS	        AS STRING OPTIONAL
    WSDATA DTTIME	        AS STRING OPTIONAL
ENDWSSTRUCT

/*/
Estrutura de Dados para gravacao com WS - Retorno
@type property
@author Rogerio
@since 08/10/2019
@version P12
/*/
WSSTRUCT MGFWSS14_LRetorna
    WSDATA status   		AS BOOLEAN
    WSDATA Msg				AS String
ENDWSSTRUCT

/*/ 
Estrutura dos Dados para consulta do WS
@type property
@author Rogerio Almeida
@since 10/10/2019
@version P12
/*/
WSSTRUCT MGFWSS14_RELATO_CON
    WSDATA CNPJ		AS STRING 
    WSDATA DATACONS	AS STRING OPTIONAL	
ENDWSSTRUCT

/*/ 
Estrutura dos Dados para consulta do WS -Retorno
@type property
@author Rogerio Almeida
@since 10/10/2019
@version P12
/*/
WSSTRUCT MGFWSS14_RELATO_CON_RET
    WSDATA ID		    AS STRING
	WSDATA CNPJ		    AS STRING
	WSDATA RELATO	    AS STRING
    WSDATA DATACONS	    AS STRING 
    WSDATA status  	    AS BOOLEAN
    WSDATA Msg	        AS STRING
    WSDATA REL_DESMEMB  AS STRING
    WSDATA DTTIME	    AS STRING OPTIONAL
ENDWSSTRUCT


/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS14 
Classe do WS contendo suas propriedades e metodos
@type class
@author Rogerio Almeida
@since 08/10/2019S
@version P12
/*/
WSSERVICE MGFWSS14 DESCRIPTION "Integracao Protheus x Serasa" NameSpace "http://totvs.com.br/MGFWSS14"

    WSDATA WSS14RELATO  AS MGFWSS14_RELATO // Passagem dos parametros de entrada - Gravacao
    WSDATA WSS14RETORNO AS MGFWSS14_LRetorna // Retorno

    WSDATA WSS14CON     AS MGFWSS14_RELATO_CON // Passagem dos parametros de entrada - Consulta
    WSDATA WSS14CONRET  AS MGFWSS14_RELATO_CON_RET // Retorno

    WSMETHOD GravarRelato DESCRIPTION "Integracao Protheus x Serasa - Gravar Relato sem formatacao"
    WSMETHOD ConsultarRelato DESCRIPTION "Integracao Protheus x Serasa - Consultar Relato sem formatacao"

ENDWSSERVICE


WSMETHOD GravarRelato WSRECEIVE WSS14RELATO WSSEND WSS14RETORNO WSSERVICE MGFWSS14
    Local cId     :=  padr(allTrim( ::WSS14RELATO:ID ),tamSX3("ZEN_ID")[1] )
    Local cCNPJ   :=  padr(allTrim( ::WSS14RELATO:CNPJ ),tamSX3("ZEN_CNPJ")[1] )
    Local cData   :=  padr(allTrim( ::WSS14RELATO:DATACONS),tamSX3("ZEN_DTCONS")[1])
    Local cDtTime :=  padr(allTrim( ::WSS14RELATO:DTTIME),tamSX3("ZEN_DTTIME")[1])

    DBSelectArea("ZEN")
    ZEN->(DBSetOrder(2))
	ZEN->(DBGoTop())

    // Cria e alimenta uma nova instancia de retorno do cliente
	::WSS14RETORNO 				:=  WSClassNew( "MGFWSS14_LRetorna" )
   
    if(W14VLDT(cData)) //Validar se a data está no formato AAAAMMDD
        if !ZEN->( DBSeek( xFilial('ZEN') + cId))
                if recLock("ZEN", .T.)
                    ZEN->ZEN_FILIAL   := xFilial('ZEN')
                    ZEN->ZEN_ID       := cId
                    ZEN->ZEN_CNPJ     := cCNPJ
                    ZEN->ZEN_DTCONS   := IIF(EMPTY(cData),dDataBase,sTod(cData))
                    ZEN->ZEN_RELATO   := alltrim( ::WSS14RELATO:RELATO)
                    ZEN->ZEN_RELDES   := alltrim( ::WSS14RELATO:REL_DESMEMB)
                    ZEN->ZEN_DTTIME   := IIF(EMPTY(cDtTime),FWTimeStamp(2),cDtTime)//2 - Formato dd/mm/aaaa-hh:mm:ss (19 caracteres)
                    ZEN->(MsUnlock())
                endif  
                ::WSS14RETORNO:status		:= .T.
                ::WSS14RETORNO:Msg			:= 'Gravado com sucesso!'
        else
            if recLock("ZEN", .F.)                
                ZEN->ZEN_FILIAL   := xFilial('ZEN')
                ZEN->ZEN_ID       := cId
                ZEN->ZEN_CNPJ     := cCNPJ
                ZEN->ZEN_DTCONS   := IIF(EMPTY(cData),dDataBase,sTod(cData))
                ZEN->ZEN_RELATO   := alltrim( ::WSS14RELATO:RELATO)
                ZEN->ZEN_RELDES   := alltrim( ::WSS14RELATO:REL_DESMEMB)
                ZEN->ZEN_DTTIME   := IIF(EMPTY(cDtTime),FWTimeStamp(2),cDtTime)//2 - Formato dd/mm/aaaa-hh:mm:ss (19 caracteres)
                ZEN->(MsUnlock())                
            endif
            ::WSS14RETORNO:status		:= .T.
            ::WSS14RETORNO:Msg			:= 'Atualizado com sucesso!'
        endif
            
    else
        ::WSS14RETORNO:status		:= .F.
        ::WSS14RETORNO:Msg			:= 'A data deve seguir o formato AAAAMMDD.'   
    endif     
      
return .T.


WSMETHOD ConsultarRelato WSRECEIVE WSS14CON WSSEND WSS14CONRET WSSERVICE MGFWSS14
    Local aArea		:= getArea()
    Local aAreaZEN	:= ZEN->( getArea() )
    Local cCNPJ   :=  padr(allTrim( ::WSS14CON:CNPJ ),tamSX3("ZEN_CNPJ")[1] )
    Local cData   :=  padr(allTrim( ::WSS14CON:DATACONS),tamSX3("ZEN_DTCONS")[1])

    //Relato
    Local nY := 0
    Local cRelato := ' '
    Local nQtd := 0
    //Relato JSON
    Local nX := 0
    Local cRelDes := ' '
    Local nQtX := 0
    Local cQuery := ' '
    
    DBSelectArea("ZEN")
    ZEN->(DBSetOrder(1))

    // Cria e alimenta uma nova instancia de retorno do cliente
    ::WSS14CONRET 	:=  WSClassNew( "MGFWSS14_RELATO_CON_RET" )

    if(W14VLDT(cData)) //Validar se a data está no formato AAAAMMDD
        cQuery := " SELECT MAX(R_E_C_N_O_) ZENRECNO "          + CRLF //Retornar maior R_E_C_N_O_
        cQuery += " FROM " + retSQLName( "ZEN" ) + " ZEN"	   + CRLF
        cQuery += " WHERE ZEN_CNPJ = '"+cCNPJ+"'"              + CRLF //Filtrar CNPJ informado
        if(!EMPTY(cData))
            cQuery += " AND ZEN_DTCONS = '"+cData+"'"          + CRLF //Filtrar data caso enviada
        endif  
        cQuery += " AND ZEN_FILIAL = '"+xFilial('ZEN')+ "'"    + CRLF
        cQuery += " AND D_E_L_E_T_ = ' ' " 	                   + CRLF
        

        If Select("QRYZEN") <> 0  
            QRYZEN->(DBCLOSEAREA( ))
        endIf

        tcQuery cQuery new alias "QRYZEN"

        if (QRYZEN->ZENRECNO <> 0 .And. !QRYZEN->( EOF() ))
            ZEN->( DBGoTo( QRYZEN->ZENRECNO ) )

                nQtd := MlCount(ZEN->ZEN_RELATO)

                For nY:=1 to nQtd
                cRelato += MemoLine(ZEN->ZEN_RELATO,,nY)
                Next nY
                
                nQtX := MlCount(ZEN->ZEN_RELDES)

                For nX:=1 to nQtX
                cRelDes += MemoLine(ZEN->ZEN_RELDES,,nX)
                Next nX

                //Dados de Retorno
                ::WSS14CONRET:ID            := ZEN->ZEN_ID    
                ::WSS14CONRET:CNPJ          := ZEN->ZEN_CNPJ          
                ::WSS14CONRET:DATACONS      := dToC(ZEN->ZEN_DTCONS)  
                ::WSS14CONRET:RELATO        := cRelato  
                ::WSS14CONRET:REL_DESMEMB   := cRelDes
                ::WSS14CONRET:DTTIME        := ZEN->ZEN_DTTIME
                ::WSS14CONRET:status        := .T.
                ::WSS14CONRET:Msg           := 'Dados encontrados!'   
        else
            ::WSS14CONRET:ID            := ' '
            ::WSS14CONRET:CNPJ          := ' '
            ::WSS14CONRET:DATACONS      := ' '
            ::WSS14CONRET:RELATO        := ' ' 
            ::WSS14CONRET:REL_DESMEMB   := ' '
            ::WSS14CONRET:DTTIME        := ' '  
            ::WSS14CONRET:status        := .T.
            ::WSS14CONRET:Msg           := 'Dados nao encontrados!'
        endIf
        QRYZEN->( DBCloseArea() ) //Fechar a temporaria

    else
        ::WSS14CONRET:ID            := ' '
        ::WSS14CONRET:CNPJ          := ' '
        ::WSS14CONRET:DATACONS      := ' '
        ::WSS14CONRET:RELATO        := ' ' 
        ::WSS14CONRET:REL_DESMEMB   := ' '
        ::WSS14CONRET:DTTIME        := ' '  
        ::WSS14CONRET:status        := .F.
        ::WSS14CONRET:Msg           := 'A data deve seguir o formato AAAAMMDD.'       
    endIf

restArea( aAreaZEN )
restArea( aArea )   

return .T.


/*/
==============================================================================================================================================================================
{Protheus.doc} W14VLDT()
Função que realiza a validação do campo data
@type function
@author Rogerio Almeida
@since 21/10/2019
@version P12
/*/
static function W14VLDT(cData)
    Local _lRet    := .T.
    Local nMes    := 0
    Local nDia    := 0

    //Validar se a data estÃ¡ no formato AAAAMMDD
    if(!EMPTY(cData))   
        if(len(cData) == 8)   
            nMes    := val(SUBSTR(cData,5,2))
            nDia    := val(SUBSTR(cData,7,2))    
            _lRet    := Iif(nMes > 12 .OR. nDia > 31 .OR. nMes == 0 .OR. nDia == 0, .F., .T.) 
        else                                
            _lRet := .F.
        endif    
    endif
return _lRet

