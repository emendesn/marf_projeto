#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE47	
Autor....:              Rafael Garcia
Data.....:              04/06/2019
Descricao / Objetivo:   WS Integracao PROTHEUS x MultiEmbarcador - devolver os pedidos da carga 
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS para devolver os pedidos da carga 
=====================================================================================
*/

WSSTRUCT MGFGFE47REC

	WSDATA Filial		 AS string
	WSDATA OEReferencia	 AS string
	


ENDWSSTRUCT

WSSTRUCT Pvprot
	WSDATA PV            as String
	WSDATA ProtPV        as String
	WSDATA OE			 as string	
	
ENDWSSTRUCT

WSSTRUCT MGFGFE47Ret
	WSDATA status   		AS string
	WSDATA Filial		  	AS string
	WSDATA OEReferencia  	AS string
	WSDATA PROtOCarga		AS String
	WSDATA Msg				AS String
	WSDATA PvProt			as array of Pvprot


ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE47 DESCRIPTION "Integracao Protheus x Multiembarcador - PV/Prot" NameSpace "http://totvs.com.br/MGFGFE47.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFGFE47RECEBER AS MGFGFE47REC
	// Retorno (array)
	WSDATA MGFGFE47RETORNO  AS MGFGFE47Ret

	WSMETHOD RetPV DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno PV/Prot"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetPV WSRECEIVE MGFGFE47RECEBER WSSEND MGFGFE47RETORNO WSSERVICE MGFGFE47

	Local aRetFuncao := {}

	Local lReturn	:= .T.
	local nI:=1

	aRetFuncao	:= u_MGFGFE47(	{	;
	::MGFGFE47RECEBER:Filial		,;
	::MGFGFE47RECEBER:OEReferencia	})	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE47RETORNO :=  WSClassNew( "MGFGFE47Ret" )
	::MGFGFE47RETORNO:status		:= aRetFuncao[1,1]
	::MGFGFE47RETORNO:Filial		:= aRetFuncao[1,2]
	::MGFGFE47RETORNO:OEReferencia	:= aRetFuncao[1,3]
	::MGFGFE47RETORNO:PROtOCarga	:= aRetFuncao[1,4]
	::MGFGFE47RETORNO:Msg			:= aRetFuncao[1,5]
//	::MGFGFE47RETORNO:PvProt:= WSClassNew( "Pvprot")
	::MGFGFE47RETORNO:PvProt:= {}
	For nI := 1 To Len(aRetFuncao)
		aAdd(::MGFGFE47RETORNO:PvProt,WSClassNew( "Pvprot"))
		::MGFGFE47RETORNO:PvProt[nI]:PV            := aRetFuncao[nI,6]
		::MGFGFE47RETORNO:PvProt[nI]:PROTPV        := aRetFuncao[nI,7]
		::MGFGFE47RETORNO:PvProt[nI]:OE        	   := aRetFuncao[nI,8]
	Next nI

Return lReturn


user function MGFGFE47( aEmb )
	local cQuery := " "
	LOCAL aRet  :={} 
	LOCAL cProtCarga:=""
	local nI	:= 1	 

	RpcSetEnv( "01" , aEmb[1] , Nil, Nil, "EST", Nil )//, aTables )
	//SELECT PARA LISTAR OS PEDIDOS DA ORDEM DE EMBARQUE
	cQuery := "	SELECT DAI_PEDIDO, DAI_XPROPV,DAI_XPROTO,DAI_COD "
	cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
	cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
	cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
	cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF	  
	cQuery += " WHERE DAI.DAI_FILIAL='"+aEmb[1]+"' " 			+CRLF	
	cQuery += " AND DAK.DAK_XOEREF='"+aEmb[2]+"' "				+CRLF
	cQuery += " AND DAI.D_E_L_E_T_<>'*'" 						+CRLF	
	IF SELECT("QRYPED") > 0
		QRYPED->( dbCloseArea() )
	ENDIF   

	TcQuery changeQuery(cQuery) New Alias "QRYPED"

	IF QRYPED->(EOF()) 
		AADD( aRet, {"2",aEmb[1],aEmb[2],"","A Carga nao foi localizada","","","" })	
	else 
		cProtCarga:=QRYPED->DAI_XPROTO
		while !QRYPED->(EOF())			
			AADD( aRet, {"1",aEmb[1],aEmb[2],cProtCarga,"A Carga foi localizada",QRYPED->DAI_PEDIDO,QRYPED->DAI_XPROPV,QRYPED->DAI_COD })			
			QRYPED->(DBSKIP())			
		end		
	ENDIF
	IF SELECT("QRYPED") > 0
		QRYPED->( dbCloseArea() )
	ENDIF   

RETURN aRet