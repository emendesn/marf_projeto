#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
#Include "XMLXFUN.CH"



/*
=====================================================================================
Programa.:              MGFFATAY
Autor....:              Rafael Garcia
Data.....:              27/03/2010
Descricao / Objetivo:   Integracao PROTHEUS x Multiembarcador - Recebimento XML CTE
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              WS Server para Integracao PROTHEUS x Multiembarcador - - Recebimento XML CTE
Componentes da integracao:
Integracao PROTHEUS x Multiembarcador - Recebimento XML CTE
=====================================================================================
*/

WSSTRUCT MGFFATAYXMLcte
	WSDATA FILIAL	as string
	WSDATA XMLCTE 	AS string
	WSDATA NOMEXML  AS STRING

ENDWSSTRUCT

// Movimentos de Produ��o - Estrutura de dados.
WSSTRUCT MGFFATAYRETXMLCTE
	WSDATA STATUS	AS String
	WSDATA MSG	AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Add Carga multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFFATAY DESCRIPTION "Integracao Protheus x Multiembarcador - Recebimento XML CTE" NameSpace "http://totvs.com.br/MGFFATAY.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFFATAYRXMLcte AS MGFFATAYXMLcte
	// Retorno (array)
	WSDATA  MGFFATAYREXMLCTE AS MGFFATAYRETXMLCTE

	WSMETHOD RetornoXMLCTE DESCRIPTION "Integracao Protheus x Multiembarcador - Recebimento XML CTE"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoXMLCTE WSRECEIVE	MGFFATAYRXMLcte WSSEND MGFFATAYREXMLCTE WSSERVICE MGFFATAY

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFFATAY(	{	::MGFFATAYRXMLcte:Filial	,;
	::MGFFATAYRXMLcte:XMLCTE ,;
	::MGFFATAYRXMLcte:NOMEXML })	// Passagem de parametros para rotina



	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFATAYREXMLCTE :=  WSClassNew( "MGFFATAYRETXMLCTE" )
	::MGFFATAYREXMLCTE:STATUS	:= aRetFuncao[1]
	::MGFFATAYREXMLCTE:MSG	    := aRetFuncao[2]

	//::MGFFAT44ReqRCTRC := Nil
	//DelClassINTF()

Return lReturn

user Function MGFFATAY( aEmb )

	Local aRetorno := {}
	Local cMsg     := "Nao foi possivel salvar o xml"
	Local cErro    := '2'
	Local cWarning := ""
	local cError   := ""
	LOCAL cCaminho := ""
	local oXml	   
	Local cNomArq := ""	
	/*
	����������������������������������������������������������������������������������������������������������Ŀ
	� Preparacao do Ambiente.                                                                                  |
	������������������������������������������������������������������������������������������������������������
	*/
	RpcSetEnv( "01" , aEmb[1] , Nil, Nil, "FAT", Nil )//, aTables )

	//--------------| Verifica existencia de parametros e caso nao exista, cria. |-----
    If !ExisteSx6("MGF_FATAY1")
        CriarSX6("MGF_FATAY1", "C", "Diretorio dos XMLs para importacao de CTe.","\\spdwfapl214\m$\Totvs\Microsiga\protheus_data\xmlCTe\" )
    EndIf
	
	cCaminho:= GetMv("MGF_FATAY1")
	cNomArq:= aEmb[3] +".XML"
	
	//Gera o Objeto XML
	oXml := XmlParser( aEmb[2], "_", @cError, @cWarning )
	If Valtype(oXML) <> 'O'
		cMsg := "Falha ao gerar Objeto XML :" + cError +" / "+ cWarning

	else
		// Tranforma o Objeto XML em arquivo
		SAVE oXml XMLFILE ( cCaminho + cNomArq ) 
	endif
	
	If File( cCaminho + cNomArq)
		cErro:="1"
		cMsg:="Arquivo recebido e xml gerado com sucesso"
	endif	
		
	aRetorno := {cErro,cMsg}

	/*
	����������������������������������������������������������������������������������������������������������Ŀ
	� Finalizacao do Ambiente.                                                                                 |
	������������������������������������������������������������������������������������������������������������
	*/



Return aRetorno
