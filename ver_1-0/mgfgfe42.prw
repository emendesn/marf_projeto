#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE42
Autor....:              Rafael Garcia
Data.....:              01/04/2019
Descricao / Objetivo:   WS Server Integracao PROTHEUS x Multiembarcador - Retorno Cancelamento
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/

WSSTRUCT MGFGFE42SRETCAN

	WSDATA Filial		 AS string
	WSDATA ORDEMEMBARQUE AS String
	WSDATA PEDIDO 		 as String
	WSDATA Status		 AS string


ENDWSSTRUCT


WSSTRUCT MGFGFE42RET

	WSDATA status   AS string
	WSDATA Msg  	AS string

ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE42 DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno Cancelamento ME" NameSpace "http://totvs.com.br/MGFGFE42.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFGFE42RETCAN AS MGFGFE42SRETCAN

	WSDATA MGFGFE42RETC   AS MGFGFE42RET

	WSMETHOD RetCanc DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno Cancelamento ME"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetCanc WSRECEIVE	MGFGFE42RETCAN WSSEND MGFGFE42RETC WSSERVICE MGFGFE42

	Local aRetFuncao := {}

	Local lReturn	:= .T.
	
	aRetFuncao	:= u_MGFGFE42(	{	;
	::MGFGFE42RETCAN:Filial		,;
	::MGFGFE42RETCAN:ORDEMEMBARQUE			,;	
	::MGFGFE42RETCAN:PEDIDO 		,;
	::MGFGFE42RETCAN:Status })	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE42RETC :=  WSClassNew( "MGFGFE42RET" )
	::MGFGFE42RETC:status		:= aRetFuncao[1]
	::MGFGFE42RETC:Msg			:= aRetFuncao[2]


Return lReturn

user Function MGFGFE42( aEmb )
	local cQ:=""
	Local cErro     := "2"
	Local cMsg	   := "Ordem Embarque/Pedido nao localizado"
	Local aRetorno := {}
	QWSGFE42(aEmb)

	if !QGFE42->(EOF())

		IF aEmb[4] =="1"

			cQ := " UPDATE " + RetSqlname("SF2") + " "
			cQ += " SET 	F2_XSTCANC = 'A'"
			cQ += " WHERE F2_FILIAL = '" + QGFE42->F2_FILIAL + "' "
			cQ += "	AND F2_DOC = '" + QGFE42->F2_DOC + "' "
			cQ += "	AND F2_SERIE = '" + QGFE42->F2_SERIE + "' "
			cQ += "	AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQ)

			cQ := " UPDATE " + RetSqlname("DAK") + " "
			cQ += " SET 	DAK_XINTME = 'I',"
			cQ += " DAK_XOPEME = 'C',"
			cQ += " DAK_XSTCAN = 'A'"			
			cQ += " WHERE DAK_FILIAL = '" + aEmb[1] + "' "
			cQ += "	AND DAK_XOEREF = '" + aEmb[2] + "' "
			cQ += "	AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQ)

			cQ := " UPDATE " + RetSqlname("DAI") + " "
			cQ += " SET 	DAI_XINTME = 'I',"
			cQ += " DAI_XOPEME = 'C',"
			cQ += " DAI_XPROPV = ' ',"
			cQ += " DAI_XPROTO = ' ' "
			cQ += " WHERE DAI_FILIAL = '" + aEmb[1] + "' "
			cQ += " AND DAI_COD IN ( SELECT DISTINCT(DAI.DAI_COD) "	
			cQ += " FROM "+retSQLName("DAI")+" DAI"
			cQ += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
			cQ += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
			cQ += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
			cQ += " AND DAK.D_E_L_E_T_      <>  '*'"					+CRLF	
			cQ += " WHERE DAI.DAI_FILIAL = '" + aEmb[1] + "' "
			cQ += "	AND DAK.DAK_XOEREF = '" +aEmb[2]  + "' "
			cQ += "	AND DAI.D_E_L_E_T_ <> '*' )"
			cQ += "	AND D_E_L_E_T_ <> '*' "			
			TcSqlExec(cQ)

		elseIF aEmb[4] =="3"

			cQ := " UPDATE " + RetSqlname("SF2") + " "
			cQ += " SET 	F2_XSTCANC = 'N'"
			cQ += " WHERE F2_FILIAL = '" + QGFE42->F2_FILIAL + "' "
			cQ += "	AND F2_DOC = '" + QGFE42->F2_DOC + "' "
			cQ += "	AND F2_SERIE = '" + QGFE42->F2_SERIE + "' "
			cQ += "	AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQ)
			cQ := " UPDATE " + RetSqlname("DAK") + " "
			cQ += " SET 	DAK_XINTME = 'I',"
			cQ += " DAK_XOPEME = 'C',"
			cQ += " DAK_XSTCAN = 'N'"					
			cQ += " WHERE DAK_FILIAL = '" + aEmb[1] + "' "
			cQ += "	AND DAK_XOEREF = '" + aEmb[2] + "' "
			cQ += "	AND D_E_L_E_T_ <> '*' "
			TcSqlExec(cQ)

			cQ := " UPDATE " + RetSqlname("DAI") + " "
			cQ += " SET 	DAI_XINTME = 'I',"
			cQ += " DAI_XOPEME = 'C'"
			cQ += " WHERE DAI_FILIAL = '" + aEmb[1] + "' "
			cQ += " AND DAI_COD IN ( SELECT DISTINCT(DAI.DAI_COD) "	
			cQ += " FROM "+retSQLName("DAI")+" DAI"
			cQ += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
			cQ += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
			cQ += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
			cQ += " AND DAK.D_E_L_E_T_      <>  '*'"					+CRLF	
			cQ += " WHERE DAI.DAI_FILIAL = '" + aEmb[1] + "' "
			cQ += "	AND DAK.DAK_XOEREF = '" +aEmb[2]  + "' "
			cQ += "	AND DAI.D_E_L_E_T_ <> '*' )"
			cQ += "	AND D_E_L_E_T_ <> '*' "			
			TcSqlExec(cQ)

			
		endif
		cErro:="1"
		cMsg :="Status Atualizado"
	endif
	aRetorno:={cErro,cMsg}
	
return aRetorno


static function QWSGFE42(aEmb)

	local cQ :=""

	IF SELECT("QGFE42") > 0
		QGFE42->( dbCloseArea() )
	ENDIF   

	cQ := " SELECT  "
	cQ += " SF2.F2_FILIAL,"						+CRLF
	cQ += " SF2.F2_DOC,"						+CRLF
	cQ += " SF2.F2_SERIE"						+CRLF
	cQ += " FROM "+ retSQLName("SF2") +" SF2"	+CRLF
	cQ += " INNER JOIN "+retSQLName("DAI")+" DAI"+CRLF
	cQ += " ON DAI.DAI_NFISCA=SF2.F2_DOC"		+CRLF
	cQ += " AND DAI.DAI_SERIE= SF2.F2_SERIE"	+CRLF
	cQ += " AND DAI.D_E_L_E_T_ <>  '*'"			+CRLF
	cQ += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"	+CRLF
	cQ += " WHERE "								+CRLF 
	cQ += " DAI.DAI_XPROTO <> ' '"				+CRLF
	cQ += " AND (SF2.F2_XSTCANC='S'" 			+CRLF
	cQ += " or SF2.F2_XSTCANC='N')" 			+CRLF
	cQ += " AND SF2.D_E_L_E_T_<>'*'"			+CRLF
	cQ += " AND SF2.F2_CHVNFE <>' '"			+CRLF
	cQ += " AND DAI.DAI_PEDIDO ='"+aEmb[3]+"'"	+CRLF
	cQ += " AND DAI.DAI_COD ='"+aEmb[2]+"'"		+CRLF
	cQ += " AND DAI.DAI_FILIAL ='"+aEmb[1]+"'"	+CRLF

	TcQuery changeQuery(cQ) New Alias "QGFE42"



return
