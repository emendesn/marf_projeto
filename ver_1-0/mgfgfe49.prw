#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE49
Autor....:              Rafael Garcia
Data.....:              24/06/2019
Descricao / Objetivo:   WS Integracao PROTHEUS x Multiembarcador - dados filial
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              retorno dados da filial 
=====================================================================================
*/

WSSTRUCT MGFGFE49RECfilial
	WSDATA CNPJ				 	AS string OPTIONAL
	WSDATA CodigoERPFilial	    AS string OPTIONAL



ENDWSSTRUCT


WSSTRUCT MGFGFE49RetFILIAL
	WSDATA STATUS				AS String
	WSDATA MSG					AS String
	WSDATA CNPJ				 	AS string 
	WSDATA CodigoERPFilial 	    AS string 	
	WSDATA NomeEmpresa 			AS STRING
	WSDATA NomeFantasia 		AS STRING
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Add Carga multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE49 DESCRIPTION "Integracao Protheus x Multiembarcador -Dados Filial" NameSpace "http://totvs.com.br/MGFGFE49.apw"

	// Passagem dos par�metros de entrada
	WSDATA MGFGFE49RECEBEfilial AS MGFGFE49RECfilial
	// Retorno (array)
	WSDATA MGFGFE49RETORNOFILIAL AS MGFGFE49RetFILIAL

	WSMETHOD RetornoFilial DESCRIPTION "Integracao Protheus x Multiembarcador - Dados Filial"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoFilial
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoFilial WSRECEIVE	MGFGFE49RECEBEfilial WSSEND MGFGFE49RETORNOFILIAL WSSERVICE MGFGFE49

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= MGFGFE49(	{	::MGFGFE49RECEBEfilial:CNPJ		,;
	::MGFGFE49RECEBEfilial:CodigoERPFilial		})	// Passagem de parametros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE49RETORNOFILIAL :=  WSClassNew( "MGFGFE49RetFILIAL" )
	::MGFGFE49RETORNOFILIAL:STATUS				:= aRetFuncao[1][1]
	::MGFGFE49RETORNOFILIAL:MSG					:= aRetFuncao[1][2]
	::MGFGFE49RETORNOFILIAL:CNPJ				:= aRetFuncao[1][3]
	::MGFGFE49RETORNOFILIAL:CodigoERPFilial 	:= aRetFuncao[1][4]
	::MGFGFE49RETORNOFILIAL:NomeEmpresa		 	:= aRetFuncao[1][5]
	::MGFGFE49RETORNOFILIAL:NomeFantasia 		:= aRetFuncao[1][6]


Return lReturn

Static Function MGFGFE49( aParam )

	Local aRetorno := {}
	Local cMsg     := "Cnpj/filial nao localizado "
	Local cErro    := '2'
	local cQuery   := ""
	
	cQuery := " SELECT M0_CGC, M0_CODFIL, M0_FILIAL, M0_NOMECOM FROM SYS_COMPANY "
	if alltrim(aParam[1])<>""
		cQuery += "  WHERE M0_CGC = '" + alltrim(aParam[1]) + "'"
	else
		cQuery += "  WHERE M0_CODFIL = '" +alltrim(aParam[2])  + "'"
	endif	
		
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	TcQuery changeQuery(cQuery) New Alias "cSM0" 	

	IF !cSM0->(eof())
		aRetorno	:= {{"1","localizado com sucesso",cSM0->M0_CGC,cSM0->M0_CODFIL,cSM0->M0_FILIAL,cSM0->M0_NOMECOM}}
	ELSE
		aRetorno	:= {{cErro,cMSG}}
	endif	


Return aRetorno
