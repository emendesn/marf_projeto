#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFWSS13
Autor....:              Rafael Garcia
Data.....:              30/09/2019
Descricao / Objetivo:   WS Server LogCte
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/

WSSTRUCT MGFWSS13RECCTE

	WSDATA Filial		 		AS string OPTIONAL
	WSDATA OEREFERENCIA 		AS String OPTIONAL
	WSDATA Protocolo_carga		as String OPTIONAL
	WSDATA LOG					as string



ENDWSSTRUCT


WSSTRUCT MGFWSS13RETCTE

	WSDATA status   AS string
	WSDATA Msg  	AS string

ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFWSS13 DESCRIPTION "Integracao Protheus x Multiembarcador - Log CTE" NameSpace "http://totvs.com.br/MGFWSS13.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFWSS13REC AS MGFWSS13RECCTE

	WSDATA MGFWSS13RET   AS MGFWSS13RETCTE

	WSMETHOD RetlOGCTE DESCRIPTION "Integracao Protheus x Multiembarcador - LOG CTE"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetlOGCTE WSRECEIVE MGFWSS13REC WSSEND MGFWSS13RET WSSERVICE MGFWSS13

	Local aRetFuncao := {}

	Local lReturn	:= .T.
	
	aRetFuncao	:= u_MGFWSS13(::MGFWSS13REC)	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFWSS13RET :=  WSClassNew( "MGFWSS13RETCTE" )
	::MGFWSS13RET:status		:= aRetFuncao[1]
	::MGFWSS13RET:Msg			:= aRetFuncao[2]


Return lReturn

user Function MGFWSS13( OOE )
	local cQ:=""
	Local cErro     := "2"
	Local cMsg	   := "Ordem Embarque/Protocolo nao localizado"
	Local aRetorno := {}
	QWSWSS13(OOE)

	WHILE QWSS13->(!EOF())

		dbSelectArea("DAK")
		dbSetOrder(1)
		IF DBSEEK(QWSS13->DAK_FILIAL+QWSS13->DAK_COD)
			RecLock("DAK",.F.)
			DAK->DAK_XRETWS:=ALLTRIM(OOE:LOG)
			DAK->(  msUnlock() )
			cErro:="1"	
			cMsg :="LOG Atualizado"
		ENDIF	
		QWSS13->(DBSKIP())
	ENDDO

	IF SELECT("QWSS13") > 0
		QWSS13->( dbCloseArea() )
	ENDIF
	aRetorno:={cErro,cMsg}
return aRetorno


static function QWSWSS13(OOE)

	local cQ :=""

	IF SELECT("QWSS13") > 0
		WSS13->( dbCloseArea() )
	ENDIF

	cQ := " SELECT  DAK.DAK_FILIAL,"
	cQ += " DAK.DAK_COD "							+CRLF
	cQ += " FROM "+ retSQLName("DAK")+" DAK"    	+CRLF
	cQ += " INNER JOIN  "+retSQLName("DAI")+" DAI"	+CRLF	
	cQ += " ON DAK.DAK_COD=DAI.DAI_COD"				+CRLF
	cQ += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 		+CRLF
	cQ += " AND DAI.D_E_L_E_T_      <>  '*'"		+CRLF	
	cQ += " WHERE "									+CRLF 
	IF ALLTRIM(OOE:Protocolo_carga)<>''
		cQ += " DAI.DAI_XPROTO = '"+OOE:Protocolo_carga+"'"+CRLF
	ELSE
		cQ += " DAK.DAK_XOEREF = '"+OOE:OEREFERENCIA+"'"+CRLF
		cQ += " AND DAK.DAK_FILIAL ='"+OOE:FILIAL+"'"	+CRLF
	ENDIF
	cQ += " AND DAK.D_E_L_E_T_      <>  '*'"		+CRLF

	TcQuery changeQuery(cQ) New Alias "QWSS13"

 

return
