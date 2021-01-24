#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFFATAZ	
Autor....:              Rafael Garcia
Data.....:              31/05/2019
Descricao / Objetivo:   Integracao PROTHEUS x MultiEmbarcador
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para validacao se todos os pedidos da Carga tem protocolo
=====================================================================================
*/

WSSTRUCT MGFFATAZPROTO

	WSDATA Filial		 AS string
	WSDATA OEReferencia	 AS string
	WSDATA PV			 AS string


ENDWSSTRUCT


WSSTRUCT MGFFATAZRetProto
	WSDATA Filial		 AS string
	WSDATA OEReferencia	 AS string
	WSDATA PV			 AS string
	WSDATA ProtocolosRecebidos  as string
	WSDATA Status		  as string

ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFFATAZ DESCRIPTION "Integracao Protheus x Multiembarcador - validacao protocolos" NameSpace "http://totvs.com.br/MGFFATAZ.apw"

	// Passagem dos parâmetros de entrada
	WSDATA MGFFATAZPROTOCOLO AS MGFFATAZPROTO
	// Retorno (array)
	WSDATA MGFFATAZRetProtocolo  AS MGFFATAZRetProto

	WSMETHOD RetVerifProto DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno Verificacao Protocolo"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoProtocolo
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetVerifProto WSRECEIVE	MGFFATAZPROTOCOLO WSSEND MGFFATAZRetProtocolo WSSERVICE MGFFATAZ

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFFATAZ(	{	;
	::MGFFATAZPROTOCOLO:Filial		,;
	::MGFFATAZPROTOCOLO:OEReferencia	,;	
	::MGFFATAZPROTOCOLO:PV		})	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFATAZRetProtocolo                    :=  WSClassNew( "MGFFATAZRetProto" )
	::MGFFATAZRetProtocolo:Filial		      := aRetFuncao[1]
	::MGFFATAZRetProtocolo:OEReferencia		  := aRetFuncao[2]
	::MGFFATAZRetProtocolo:PV			      := aRetFuncao[3]
	::MGFFATAZRetProtocolo:ProtocolosRecebidos:= aRetFuncao[4]
	::MGFFATAZRetProtocolo:Status			  := aRetFuncao[5]

Return lReturn


user function MGFFATAZ( aEmb )
	local cQuery:=""
	LOCAL aRet	:={}
	RpcSetEnv( "01" , aEmb[1] , Nil, Nil, "EST", Nil )//, aTables )
	//verifica se a OE/pv existe existe
	cQuery := "	SELECT DAI_PEDIDO "
	cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
	cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
	cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
	cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF	  
	cQuery += " WHERE DAI.DAI_FILIAL='"+aEmb[1]+"' " 			+CRLF	
	cQuery += " AND DAK.DAK_XOEREF='"+aEmb[2]+"' "				+CRLF
	cQuery += " AND DAI.DAI_PEDIDO='"+aEmb[3]+"' AND DAI.D_E_L_E_T_<>'*'" +CRLF	
	IF SELECT("QRYPED") > 0
		QRYPED->( dbCloseArea() )
	ENDIF   

	TcQuery changeQuery(cQuery) New Alias "QRYPED"

	IF QRYPED->(eof())
		aRet:={aEmb[1],aEmb[2],aEmb[3],"false","2"}
	else	
		//Query para verificar se e o ultimo
		cQuery := "	SELECT DAI_PEDIDO "
		cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
		cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF	
		cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
		cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
		cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF	  
		cQuery += " WHERE DAI.DAI_FILIAL='"+aEmb[1]+"' " 			+CRLF	
		cQuery += " AND DAK.DAK_XOEREF='"+aEmb[2]+"' "				+CRLF
		cQuery += " AND DAI.DAI_PEDIDO<>'"+aEmb[3]+"' AND DAI.D_E_L_E_T_<>'*'" +CRLF
		cQuery += " AND DAI_XPROPV =' '"							+CRLF

		IF SELECT("QRYPED") > 0
			QRYPED->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQuery) New Alias "QRYPED"

		IF QRYPED->(eof())
			aRet:={aEmb[1],aEmb[2],aEmb[3],"true","1"}
		ELSE
			aRet:={aEmb[1],aEmb[2],aEmb[3],"false","1"}
		endif
	endif
	IF SELECT("QRYPED") > 0
		QRYPED->( dbCloseArea() )
	ENDIF

Return aRet