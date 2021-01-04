#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE41
Autor....:              Rafael Garcia
Data.....:              27/03/2010
Descricao / Objetivo:   Integracao PROTHEUS x Multiembarcador - add Carga - Retorno Protocolo
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Integracao PROTHEUS x Multiembarcador - add Carga -  Retorno Protocolo
Componentes da integração:
Integração PROTHEUS x Multiembarcador - add Carga - Retorno
=====================================================================================
*/

WSSTRUCT MGFGFE41RequisCarga
	WSDATA NumeroCarga 	AS string
	WSDATA NumeroPedido AS string
	WSDATA FilialCarga	AS string
	WSDATA MSGRetorno	AS string OPTIONAL
	WSDATA ProtocoloPV	AS string 
	WSDATA ProtocoloOE	AS string 


ENDWSSTRUCT


WSSTRUCT MGFGFE41RetornoCarga
	WSDATA STATUS	AS String
	WSDATA MSG	AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Add Carga multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE41 DESCRIPTION "Integracao Protheus x Multiembarcador - AddCarga  - Retorno Protocolo" NameSpace "http://totvs.com.br/MGFGFE41.apw"

	// Passagem dos parâmetros de entrada
	WSDATA MGFGFE41ReqCarga AS MGFGFE41RequisCarga
	// Retorno (array)
	WSDATA MGFGFE41RetCarga AS MGFGFE41RetornoCarga

	WSMETHOD RetornoCarga DESCRIPTION "Integracao Protheus x Multiembarcador - addCarga  - Retorno Protocolo"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoCarga WSRECEIVE	MGFGFE41ReqCarga WSSEND MGFGFE41RetCarga WSSERVICE MGFGFE41

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= MGFGFE41(	{	::MGFGFE41ReqCarga:NumeroCarga		,;
	::MGFGFE41ReqCarga:NumeroPedido		,;
	::MGFGFE41ReqCarga:FilialCarga		,;
	::MGFGFE41ReqCarga:MSGRetorno		,;
	::MGFGFE41ReqCarga:ProtocoloOE		,;
	::MGFGFE41ReqCarga:ProtocoloPV})	// Passagem de parametros para rotina



	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE41RetCarga :=  WSClassNew( "MGFGFE41RetornoCarga" )
	::MGFGFE41RetCarga:STATUS	:= aRetFuncao[1][1]
	::MGFGFE41RetCarga:MSG	:= aRetFuncao[1][2]

Return lReturn

Static Function MGFGFE41( aParam )

	Local aRetorno := {}
	Local cMsg     := "Carga/Pedido nao localizada: "+AllTrim(aParam[1])+"/"+AllTrim(aParam[2])
	Local cErro    := '2'

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Preparacao do Ambiente.                                                                                  |
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	RpcSetEnv( "01" , aParam[3] , Nil, Nil, "EST", Nil )//, aTables )

	aParam[1]	:= Stuff( Space( TamSX3("DAI_COD")[1] ) , 1 , Len(AllTrim(aParam[1])) , AllTrim(aParam[1]) ) 
	aParam[2]	:= Stuff( Space( TamSX3("DAI_PEDIDO")[1] ) , 1 , Len(AllTrim(aParam[2])) , AllTrim(aParam[2]) )

	dbSelectArea("DAI")
	dbSetOrder(4)
	If DAI->( dbSeek( aParam[3] + aParam[2] + aParam[1]  ) )
		RecLock("DAI",.F.)
		DAI->DAI_XDHRWS := dToC(date()) + Space(1) + Time() 
		DAI->DAI_XRETWS	:= IIF(!Empty(aParam[5]),aParam[5],aParam[4])
		If Empty(aParam[5]) .OR. Empty(aParam[5])// Erro - Sem Protocolo
			DAI->DAI_XINTME	:= "E"
			cErro    := '2'
			cMsg     := SUBSTR(aParam[4],1,TamSX3("Z1_ERRO")[1])
		Else
			cErro    := '1'
			cMsg     := 'Protocolo Registrado com Sucesso'
			DAI->DAI_XPROTO	:= aParam[5] 
			DAI->DAI_XPROPV	:= aParam[6] 
			DAI->DAI_XINTME	:= "I"                  
		EndIf
		DAI->(  msUnlock() )
	endif

	aRetorno	:= {{cErro,cMsg}}

Return aRetorno
