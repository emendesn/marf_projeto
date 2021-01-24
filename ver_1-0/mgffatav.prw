#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFFATAV
Autor....:              Rafael Garcia
Data.....:              27/03/2019
Descricao / Objetivo:   Integracao PROTHEUS x Multiembarcador - XML NF - Retorno
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Integracao PROTHEUS x Multiembarcador - xml NF - RETORNO
Componentes da integracao:
Integracao PROTHEUS x Multiembarcador - XML NF - Retorno
=====================================================================================
*/

WSSTRUCT MGFFATAVRequisXML
	WSDATA Filial		 AS string
	WSDATA OrdemEmbarque AS string
	WSDATA Pv 			 AS string
	WSDATA Token	     AS string
	WSDATA MSGRetorno	 AS string OPTIONAL 

ENDWSSTRUCT


WSSTRUCT MGFFATAVRetornoXML
	WSDATA STATUS	AS String
	WSDATA MSG	AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Add Carga multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFFATAV DESCRIPTION "Integracao Protheus x Multiembarcador - XML NF - RETORNO" NameSpace "http://totvs.com.br/MGFFATAV.apw"

	// Passagem dos par�metros de entrada
	WSDATA MGFFATAVReqXML AS MGFFATAVRequisXML
	// Retorno (array)
	WSDATA MGFFATAVRetXML AS MGFFATAVRetornoXML

	WSMETHOD RetornoXML DESCRIPTION "Integracao Protheus x Multiembarcador - XML NF - RETORNO"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoXML WSRECEIVE	MGFFATAVReqXML WSSEND MGFFATAVRetXML WSSERVICE MGFFATAV

	Local aRetFuncao := {}
	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFFATAV(	{	::MGFFATAVReqXML:Filial		,;
	::MGFFATAVReqXML:OrdemEmbarque,;
	::MGFFATAVReqXML:PV			,;
	::MGFFATAVReqXML:MSGRetorno		,;
	::MGFFATAVReqXML:Token			})	// Passagem de par�metros para rotina



	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFATAVRetXML :=  WSClassNew( "MGFFATAVRetornoXML" )
	::MGFFATAVRetXML:STATUS	:= aRetFuncao[1]
	::MGFFATAVRetXML:MSG	:= aRetFuncao[2]


Return lReturn

user Function MGFFATAV( aEmb)

	Local aRetorno := {}
	Local cMsg     := "Ordem de embarque/Pedido nao localizada: "+AllTrim(aEmb[2])+"/"+AllTrim(aEmb[3])
	Local cErro    := "2"

	/*
	����������������������������������������������������������������������������������������������������������Ŀ
	� Preparaca do Ambiente.                                                                                  |
	������������������������������������������������������������������������������������������������������������
	*/
	
	RpcSetEnv( "01" , aEmb[1] , Nil, Nil, "EST", Nil )
	
	XQSF2(aEmb)

	dbSelectArea("SF2")
	dbSetOrder(1)
	If SF2->( dbSeek( QSF2->F2_FILIAL + QSF2->F2_DOC + QSF2->F2_SERIE  ) )
		RecLock("SF2",.F.)
		SF2->F2_XDHXML := dToC(date()) + Space(1) + Time() 
		SF2->F2_XRETWS :=aEmb[4]
		If Empty(aEmb[5]) // Erro - Sem Protocolo
			SF2->F2_XENVMEM	:= "E"
			cErro    := "2"
		Else
			cErro    := "1"
			cMsg     := "Token Gravado com sucesso"
			SF2->F2_XTOKEN 	:= aEmb[5] 
			SF2->F2_XENVMEM	:= "I"                  
		EndIf
		SF2->(  msUnlock() )

	EndIf
	aRetorno	:= {cErro,cMsg}

	/*
	����������������������������������������������������������������������������������������������������������Ŀ
	� Finalizacao do Ambiente.                                                                                 |
	������������������������������������������������������������������������������������������������������������
	*/


Return aRetorno


STATIC FUNCTION XQSF2(aEmb)
	Local cQ	 := ""


	IF SELECT("QSF2") > 0
		QSF2->( dbCloseArea() )
	ENDIF  

	cQ := " SELECT  "
	cQ += " SF2.F2_FILIAL,"+CRLF
	cQ += " SF2.F2_DOC,"+CRLF
	cQ += " SF2.F2_SERIE,"+CRLF
	cQ += " SF2.R_E_C_N_O_,"+CRLF
	cQ += " DAI.DAI_COD"+CRLF
	cQ += " FROM "+ retSQLName("SF2") +" SF2"	+CRLF
	cQ += " INNER JOIN DAI010 DAI"+CRLF
	cQ += " ON DAI.DAI_NFISCA=SF2.F2_DOC"+CRLF
	cQ += " AND DAI.DAI_SERIE= SF2.F2_SERIE"+CRLF
	cQ += " AND DAI.D_E_L_E_T_ <>  '*'"+CRLF
	cQ += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"+CRLF
	cQ += " WHERE "
	cQ += " SF2.D_E_L_E_T_<>'*'"+CRLF
	cQ += " AND SF2.F2_CHVNFE <> ' '"+CRLF
	cQ += " AND SF2.F2_FILIAL ='"+ aEmb[1]+"'"+CRLF
	cQ += " AND DAI.DAI_COD = '" + aEmb[2] + "' "+CRLF
	cQ += " AND DAI.DAI_PEDIDO = '"+ aEmb[3] +"' "+CRLF

	TcQuery changeQuery(cQ) New Alias "QSF2"

Return
