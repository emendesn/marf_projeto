#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#include "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFWSS01
Autor....:              Atilio Amarilla
Data.....:              15/08/2016
Descricao / Objetivo:   Integração PROTHEUS x RH Evolution
Doc. Origem:            Contrato - GAP MGFINT01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Importação de Colaboradores (Fornecedores e Clientes)
=====================================================================================
*/

// Estrutura de dados. Montagem do Array de requisição
WSSTRUCT aReqColabData
	WSDATA ColabOper  			AS string
	WSDATA ColabTipo  			AS string
	WSDATA ColabCNPJ  			AS string
	WSDATA ColabInscEst			AS string	OPTIONAL
	WSDATA ColabInscMun			AS string	OPTIONAL
	WSDATA ColabNome			AS string
	WSDATA ColabNReduz			AS string
	WSDATA ColabCCusto			AS string	OPTIONAL
	WSDATA ColabContato			AS string	OPTIONAL
	WSDATA ColabEndereco		AS string
	WSDATA ColabBairro			AS string	OPTIONAL
	WSDATA ColabCodMun			AS string
	WSDATA ColabCEP				AS string	OPTIONAL
	WSDATA ColabTelefone		AS string	OPTIONAL
	WSDATA ColabFax				AS string	OPTIONAL
	WSDATA ColabMicroEmp		AS string	OPTIONAL
	WSDATA ColabDataME			AS string	OPTIONAL
	WSDATA ColabEmail			AS string	OPTIONAL
	WSDATA ColabOrigem			AS string	OPTIONAL
	WSDATA ColabObs				AS string	OPTIONAL
	WSDATA ColabEst				AS string
	WSDATA ColabDTNasc			AS string	OPTIONAL
	WSDATA ColabCodMGF			AS string	OPTIONAL
	WSDATA ColabContDeb			AS string	OPTIONAL
	WSDATA ColabPaisBC			AS string	OPTIONAL
	WSDATA ColabGrpTrib			AS string	OPTIONAL
	WSDATA ColabContCli			AS string	OPTIONAL
	WSDATA ColabGTrbCli			AS string	OPTIONAL
	WSDATA Natureza_Cliente		AS string	OPTIONAL
	WSDATA Natureza_Fornecedor	AS string
	WSDATA ColabPais			AS string
	WSDATA ColabComp			AS string	OPTIONAL
	WSDATA ColabDDD				AS string	OPTIONAL  // RAFAEL 28/12/2018
	WSDATA ColabDDI				AS string	OPTIONAL  // RAFAEL 28/12/2018
	WSDATA ColabFilial			AS string
	WSDATA ColabNacion			AS string
  	WSDATA ColabSetor           AS string	OPTIONAL			 
	WSDATA ColabDescSet         AS string   OPTIONAL
	WSDATA ColabUnidade         AS string   OPTIONAL
	WSDATA ColabDtAdmiss        AS string	OPTIONAL
	WSDATA ColabDtDemiss        AS string	OPTIONAL

ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetColabData
	WSDATA ColabCNPJ	AS String
	WSDATA ColabOper	AS String
	WSDATA ColabStatus	AS String
	WSDATA ColabCodCli	AS String
	WSDATA ColabCodFor	AS String	OPTIONAL
	WSDATA ColabObs		AS String
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetColabArray
	WSDATA ColabArray	AS Array OF aRetColabData
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de requisição
WSSTRUCT aReqPagarData
	WSDATA PagarOper	AS String
	WSDATA PagarCNPJ	AS String
	WSDATA PagarIDPrc	AS String
	WSDATA PagarNatur	AS String
	WSDATA PagarEmiss	AS String	OPTIONAL
	WSDATA PagarVcto	AS String
	WSDATA PagarValor	AS Float
	WSDATA PagarPort	AS String	OPTIONAL
	WSDATA PagarCCont	AS String	OPTIONAL
	WSDATA PagarEmp		AS String
	WSDATA PagarHist	AS String
	WSDATA PagarCCusto	AS String	OPTIONAL
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetPagarData
	WSDATA PagarCNPJ	AS String
	WSDATA PagarOper	AS String
	WSDATA PagarStatus	AS String
	WSDATA PagarIDPrc	AS String
	WSDATA PagarPrfNum	AS String
	WSDATA PagarObs		AS String
ENDWSSTRUCT 

// Estrutura de dados. Montagem do Array de retorno
WSSTRUCT aRetPagarArray
	WSDATA PagarArray	AS Array OF aRetPagarData
ENDWSSTRUCT 


/***************************************************************************
* Definicao do Web Service 							                       *
***************************************************************************/
WSSERVICE MGFWSS01 DESCRIPTION "Integração PROTHEUS x RH Evolution" NameSpace "http://totvs.com.br/MGFWSS01.apw"
	// Passagem dos parâmetros de entrada
	WSDATA aReqColab AS aReqColabData	
       
	// aRetColab - Retorno de um array
	WSDATA aRetColab AS aRetColabArray
	WSDATA aReqPagar AS aReqPagarData
	       
	// aRetPagar - Retorno de um array
	WSDATA aRetPagar AS aRetPagarArray
      
	WSMETHOD IntegraColab DESCRIPTION "Integração PROTHEUS x RH Evolution - Colaboradores"
	WSMETHOD IntegraPagar DESCRIPTION "Integração PROTHEUS x RH Evolution - Contas a Pagar"
      
ENDWSSERVICE

/************************************************************************************
** Metodo IntegraColab
** Grava dados de colaboradores e retorna Código + Loja Protheus
** Parâmetro aReqColab
************************************************************************************/
WSMETHOD IntegraColab WSRECEIVE	aReqColab WSSEND aRetColab WSSERVICE MGFWSS01

Local aRetFuncao := {}
Local StructTemp
Local lReturn	:= .T.
Local oColabRet

aRetFuncao	:= U_MGFINT02(	"C" ,	{	::aReqColab:ColabOper			,;
										::aReqColab:ColabTipo			,;
										::aReqColab:ColabCNPJ			,;
										::aReqColab:ColabInscEst		,;
										::aReqColab:ColabInscMun		,;
										::aReqColab:ColabNome			,;
										::aReqColab:ColabNReduz			,;
										::aReqColab:ColabContato		,;
										::aReqColab:ColabEndereco		,;
										::aReqColab:ColabBairro			,;
										::aReqColab:ColabCodMun			,;
										::aReqColab:ColabCEP			,;
										::aReqColab:ColabTelefone		,;
										::aReqColab:ColabFax			,;
										::aReqColab:ColabMicroEmp		,;
										::aReqColab:ColabDataME			,;
										::aReqColab:ColabEmail			,;
										::aReqColab:ColabOrigem			,;
										::aReqColab:ColabObs			,;
										::aReqColab:ColabEst			,;
										::aReqColab:ColabCCusto			,;
										::aReqColab:ColabDTNasc			,;
										::aReqColab:ColabCodMGF			,;
										::aReqColab:ColabContDeb 		,;
										::aReqColab:ColabPaisBC			,;
										::aReqColab:ColabGrpTrib		,;
										::aReqColab:ColabContCli		,;
										::aReqColab:ColabGTrbCli		,;
										::aReqColab:Natureza_Cliente	,;
										::aReqColab:Natureza_Fornecedor	,;
										::aReqColab:ColabPais			,;
										::aReqColab:ColabComp			,;
										::aReqColab:ColabDDD			,; //RAFAEL 28/12/2018
										::aReqColab:ColabDDI			,; //RAFAEL 28/12/2018
										::aReqColab:ColabFilial			,;
										::aReqColab:ColabNacion			,;
										::aReqColab:ColabSetor			,;
										::aReqColab:ColabDescSet 		,;
										::aReqColab:ColabUnidade		,;
										::aReqColab:ColabDtAdmiss		,;
										::aReqColab:ColabDtDemiss		} )	
										// Passagem de parâmetros para rotina

	// Cria a instância de retorno ( WSDATA aRetColab AS aRetColabArray )
	::aRetColab := WSClassNew( "aRetColabArray")
    
	// inicializa a propriedade da estrutura de retorno
	::aRetColab:ColabArray := {}
	
	// Cria e alimenta uma nova instancia do cliente
	oColabRet :=  WSClassNew( "aRetColabData" )
	oColabRet:ColabCNPJ		:= aRetFuncao[1][1]
	oColabRet:ColabOper		:= aRetFuncao[2][1]
	oColabRet:ColabStatus	:= aRetFuncao[3][1]
	oColabRet:ColabCodCli	:= aRetFuncao[4][1]
	oColabRet:ColabCodFor	:= aRetFuncao[5][1]
	oColabRet:ColabObs		:= aRetFuncao[6][1]

	AAdd( ::aRetColab:ColabArray, oColabRet )
   
Return lReturn

/************************************************************************************
** Metodo IntegraPagar
** Grava Títulos e retorna Prefixo + Num gerados
************************************************************************************/
WSMETHOD IntegraPagar WSRECEIVE	aReqPagar WSSEND aRetPagar WSSERVICE MGFWSS01

Local aRetFuncao := {}

aRetFuncao	:= U_MGFINT02(	"P" ,	{	::aReqPagar:PagarOper	,;
										::aReqPagar:PagarCNPJ	,;
										::aReqPagar:PagarIDPrc	,;
										::aReqPagar:PagarNatur	,;
										::aReqPagar:PagarEmiss	,;
										::aReqPagar:PagarVcto	,;
										::aReqPagar:PagarValor	,;
										::aReqPagar:PagarPort	,;
										::aReqPagar:PagarCCont	,;
										::aReqPagar:PagarEmp	,;
										::aReqPagar:PagarHist	,;
										::aReqPagar:PagarCCusto	} )	// Passagem de parâmetros para rotina

	// Cria a instância de retorno ( WSDATA aRetColab AS aRetColabArray )
	::aRetPagar := WSClassNew( "aRetPagarArray")
    
	// inicializa a propriedade da estrutura de retorno
	::aRetPagar:PagarArray := {}
	
	// Cria e alimenta uma nova instancia do cliente
	oPagarRet :=  WSClassNew( "aRetPagarData" )
	oPagarRet:PagarCNPJ		:= aRetFuncao[1][1]
	oPagarRet:PagarOper		:= aRetFuncao[2][1]
	oPagarRet:PagarStatus	:= aRetFuncao[3][1]
	oPagarRet:PagarIDPrc	:= aRetFuncao[4][1]
	oPagarRet:PagarPrfNum	:= aRetFuncao[5][1]
	oPagarRet:PagarObs		:= aRetFuncao[6][1]

	AAdd( ::aRetPagar:PagarArray, oPagarRet )

Return .T.