#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#include "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFWSS01 
Integração PROTHEUS x RH Evolution
@author  Atilio Amarilla
@since 15/08/2016
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

_coper := "inclusão"
//"I/A/B/E" // Inclusão / Alteração / Bloqueio / Exclusão

If alltrim(::aReqColab:ColabOper)="A"
	_coper := "alteração"
Endif

If alltrim(::aReqColab:ColabOper)="B"
	_coper := "bloqueio"
Endif

If alltrim(::aReqColab:ColabOper)="E"
	_coper := "exclusão"
Endif

/*
	ColabTipo
	B - Beneficiário - Fornecedor – pensão judicial / pensão alimentícia;
	F - Funcionário	 - Fornecedor e Cliente
	E - Empresa 	 - Fornecedor
	*/

_ctipo := "funcionário"

If alltrim(::aReqColab:ColabTipo)="B"
	_ctipo := "beneficiário"
Endif

If alltrim(::aReqColab:ColabTipo)="E"
	_ctipo := "empresa"
Endif

U_MFCONOUT("Recebida integração de " + _coper + " do " + _ctipo + "  de cpf/cnpj " + alltrim(::aReqColab:ColabCNPJ) + "...")

//monta hash dos dados da integração recebida
_chash := sha1( iif(type("aReqColab:ColabOper")=="C",::aReqColab:ColabOper," ")			+;
				iif(type("aReqColab:ColabTipo")=="C",::aReqColab:ColabTipo," ")			+;
				iif(type("aReqColab:ColabCNPJ")=="C",::aReqColab:ColabCNPJ," ")			+;
				iif(type("aReqColab:ColabInscEst")=="C",::aReqColab:ColabInscEst," ")		+;
				iif(type("aReqColab:ColabInscMun")=="C",::aReqColab:ColabInscMun," ")		+;
				iif(type("aReqColab:ColabNome")=="C",::aReqColab:ColabNome," ")			+;
				iif(type("aReqColab:ColabNReduz")=="C",::aReqColab:ColabNReduz," ")			+;
				iif(type("aReqColab:ColabContato")=="C",::aReqColab:ColabContato," ")		+;
				iif(type("aReqColab:ColabEndereco")=="C",::aReqColab:ColabEndereco," ")		+;
				iif(type("aReqColab:ColabBairro")=="C",::aReqColab:ColabBairro," ")			+;
				iif(type("aReqColab:ColabCodMun")=="C",::aReqColab:ColabCodMun," ")			+;
				iif(type("aReqColab:ColabCEP")=="C",::aReqColab:ColabCEP," ")			+;
				iif(type("aReqColab:ColabTelefone")=="C",::aReqColab:ColabTelefone," ")		+;
				iif(type("aReqColab:ColabFax")=="C",::aReqColab:ColabFax," ")			+;
				iif(type("aReqColab:ColabMicroEmp")=="C",::aReqColab:ColabMicroEmp," ")		+;
				iif(type("aReqColab:ColabDataME")=="C",::aReqColab:ColabDataME," ")			+;
				iif(type("aReqColab:ColabEmail")=="C",::aReqColab:ColabEmail," ")			+;
				iif(type("aReqColab:ColabOrigem")=="C",::aReqColab:ColabOrigem," ")			+;
				iif(type("aReqColab:ColabObs")=="C",::aReqColab:ColabObs," ")			+;
				iif(type("aReqColab:ColabEst")=="C",::aReqColab:ColabEst," ")			+;
				iif(type("aReqColab:ColabCCusto")=="C",::aReqColab:ColabCCusto," ")			+;
				iif(type("aReqColab:ColabDTNasc")=="C",::aReqColab:ColabDTNasc," ")			+;
				iif(type("aReqColab:ColabCodMGF")=="C",::aReqColab:ColabCodMGF," ")			+;
				iif(type("aReqColab:ColabContDeb")=="C",::aReqColab:ColabContDeb ," ")		+;
				iif(type("aReqColab:ColabPaisBC")=="C",::aReqColab:ColabPaisBC," ")			+;
				iif(type("aReqColab:ColabGrpTrib")=="C",::aReqColab:ColabGrpTrib," ")		+;
				iif(type("aReqColab:ColabContCli")=="C",::aReqColab:ColabContCli," ")		+;
				iif(type("aReqColab:ColabGTrbCli")=="C",::aReqColab:ColabGTrbCli," ")		+;
				iif(type("aReqColab:Natureza_Cliente")=="C",::aReqColab:Natureza_Cliente," ")	+;
				iif(type("aReqColab:Natureza_Fornecedor")=="C",::aReqColab:Natureza_Fornecedor," ")	+;
				iif(type("aReqColab:ColabPais")=="C",::aReqColab:ColabPais," ")			+;
				iif(type("aReqColab:ColabComp")=="C",::aReqColab:ColabComp," ")			+;
				iif(type("aReqColab:ColabDDD")=="C",::aReqColab:ColabDDD," ")			+; 
				iif(type("aReqColab:ColabDDI")=="C",::aReqColab:ColabDDI," ")			+; 
				iif(type("aReqColab:ColabFilial")=="C",::aReqColab:ColabFilial," ")			+;
				iif(type("aReqColab:ColabNacion")=="C",::aReqColab:ColabNacion," ")			+;
				iif(type("aReqColab:ColabSetor")=="C",::aReqColab:ColabSetor," ")			+;
				iif(type("aReqColab:ColabDescSet")=="C",::aReqColab:ColabDescSet," ") 		+;
				iif(type("aReqColab:ColabUnidade")=="C",::aReqColab:ColabUnidade," ")		+;
				iif(type("aReqColab:ColabDtAdmiss")=="C",::aReqColab:ColabDtAdmiss," ")		+;
				iif(type("aReqColab:ColabDtDemiss")=="C",::aReqColab:ColabDtDemiss," "), 1)	

//Verifica se já existe na tabela intermediária
ZH3->(Dbsetorder(4)) //ZH3_HASH

If ZH3->(Dbseek(_chash)) //Já possui registro da integracao na tabela intermediaria

	If alltrim(ZH3->ZH3_STATUS) = '3' //Integracao completada com sucesso

		U_MFCONOUT("Retornando integração completada com sucesso para o cpf/cnpj " + alltrim(ZH3->ZH3_CNPJ) + "!")

		aRetDados := {}
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CNPJ)})								// 1
		aAdd(aRetDados ,{::aReqColab:ColabOper})								// 2
		aAdd(aRetDados ,{"S"})													// 3
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CLIENT)+ALLTRIM(ZH3->ZH3_LOJAC)})		// 4
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_FORNEC)+ALLTRIM(ZH3->ZH3_LOJAF)})  	// 5
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_RESULT)})								// 6


	Elseif  alltrim(ZH3->ZH3_STATUS) == '4' // com erro

		U_MFCONOUT("Retornando erro no processamento para o cpf/cnpj " + alltrim(ZH3->ZH3_CNPJ) + "!")

		aRetDados := {}
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CNPJ)})								// 1
		aAdd(aRetDados ,{::aReqColab:ColabOper})								// 2
		aAdd(aRetDados ,{"N"})													// 3
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CLIENT)+ALLTRIM(ZH3->ZH3_LOJAC)})		// 4
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_FORNEC)+ALLTRIM(ZH3->ZH3_LOJAF)})  	// 5
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_RESULT)})					

	Else //Aguardando processamento

		U_MFCONOUT("Retornando aguardando processamento para o cpf/cnpj " + alltrim(ZH3->ZH3_CNPJ) + "!")

		aRetDados := {}
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CNPJ)})								// 1
		aAdd(aRetDados ,{::aReqColab:ColabOper})								// 2
		aAdd(aRetDados ,{"S"})													// 3
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_CLIENT)+ALLTRIM(ZH3->ZH3_LOJAC)})		// 4
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_FORNEC)+ALLTRIM(ZH3->ZH3_LOJAF)})  	// 5
		aAdd(aRetDados ,{alltrim(ZH3->ZH3_RESULT)})								// 6

	
	Endif

Else //Ainda não tem registro na tabela intermediaria

	U_MFCONOUT("Incluindo registro e Retornando aguardando processamento para o cpf/cnpj " + alltrim(ZH3->ZH3_CNPJ) + "!")

	Reclock("ZH3", .T.)

	ZH3->ZH3_DTRECE		:= alltrim(DTOC(DATE()))
	ZH3->ZH3_HRRECE		:= alltrim(TIME())
	ZH3->ZH3_STATUS		:= " "
	ZH3->ZH3_RESULT		:= "AGUARDANDO PROCESSAMENTO"
	ZH3->ZH3_TIPO 		:= alltrim(::aReqColab:ColabTipo)
	ZH3->ZH3_OPER 		:= alltrim(::aReqColab:ColabOper)
	ZH3->ZH3_CNPJ		:= alltrim(::aReqColab:ColabCNPJ)	  
	ZH3->ZH3_IE 		:= alltrim(::aReqColab:ColabInscEst)	   
	ZH3->ZH3_IM 		:= alltrim(::aReqColab:ColabInscMun )  
	ZH3->ZH3_NOME		:= alltrim(::aReqColab:ColabNome  )
	ZH3->ZH3_NREDUZ		:= alltrim(::aReqColab:ColabNReduz	)
	ZH3->ZH3_CONTAT		:= alltrim(::aReqColab:ColabContato)
	ZH3->ZH3_ENDERE		:= alltrim(::aReqColab:ColabEndereco)
	ZH3->ZH3_BAIRRO		:= alltrim(::aReqColab:ColabBairro	)
	ZH3->ZH3_CODMUN		:= alltrim(::aReqColab:ColabCodMun	)
	ZH3->ZH3_CEP  		:= alltrim(::aReqColab:ColabCEP )
	ZH3->ZH3_TELEFO		:= alltrim(::aReqColab:ColabTelefone)
	ZH3->ZH3_FAX  		:= alltrim(::aReqColab:ColabFax )
	ZH3->ZH3_MICROE		:= alltrim(::aReqColab:ColabMicroEmp)
	ZH3->ZH3_DATAME		:= alltrim(::aReqColab:ColabDataME	)
	ZH3->ZH3_EMAIL 		:= alltrim(::aReqColab:ColabEmail	)
	ZH3->ZH3_ORIGEM		:= alltrim(::aReqColab:ColabOrigem)
	ZH3->ZH3_OBS   		:= alltrim(::aReqColab:ColabObs)
	ZH3->ZH3_ESTADO		:= alltrim(::aReqColab:ColabEst)
	ZH3->ZH3_CCUSTO		:= alltrim(::aReqColab:ColabCCusto)	
	ZH3->ZH3_DTNASC		:= alltrim(::aReqColab:ColabDTNasc)
	ZH3->ZH3_CODMGF		:= alltrim(::aReqColab:ColabCodMGF)
	ZH3->ZH3_CONTDE		:= alltrim(::aReqColab:ColabContDeb)
	ZH3->ZH3_PAISBC		:= alltrim(::aReqColab:ColabPaisBC)
	ZH3->ZH3_GRPTRI		:= alltrim(::aReqColab:ColabGrpTrib)
	ZH3->ZH3_GRPTRC		:= alltrim(::aReqColab:ColabGTrbCli)
	ZH3->ZH3_CONTCL		:= alltrim(::aReqColab:ColabContCli)
	ZH3->ZH3_NATCLI		:= alltrim(::aReqColab:Natureza_Cliente)
	ZH3->ZH3_NATFOR		:= alltrim(::aReqColab:Natureza_Fornecedor)	
	ZH3->ZH3_PAIS  		:= alltrim(::aReqColab:ColabPais)
	ZH3->ZH3_COMP  		:= alltrim(::aReqColab:ColabComp)
	ZH3->ZH3_DDD   		:= alltrim(::aReqColab:ColabDDD)
	ZH3->ZH3_DDI   		:= alltrim(::aReqColab:ColabDDI)
	ZH3->ZH3_CFILIA		:= alltrim(::aReqColab:ColabFilial)	
	ZH3->ZH3_NACION		:= alltrim(::aReqColab:ColabNacion)	
	ZH3->ZH3_SETOR 		:= alltrim(::aReqColab:ColabSetor)
	ZH3->ZH3_DSETOR		:= alltrim(::aReqColab:ColabDescSet)
	ZH3->ZH3_UNIDAD		:= alltrim(::aReqColab:ColabUnidade)
	ZH3->ZH3_DTADMI		:= alltrim(::aReqColab:ColabDtAdmiss)
	ZH3->ZH3_DTDEMI		:= alltrim(::aReqColab:ColabDtDemiss)	
	ZH3->ZH3_UUID  		:= alltrim(fwUUIDv4( .T. ))
	ZH3->ZH3_ORIGEM		:= alltrim("RHEVOLUTION")
	ZH3->ZH3_HASH  		:= alltrim(_chash)

	ZH3->(MsUnLock())

	aRetDados := {}
	aAdd(aRetDados ,{alltrim(ZH3->ZH3_CNPJ)})								// 1
	aAdd(aRetDados ,{::aReqColab:ColabOper})								// 2
	aAdd(aRetDados ,{"S"})													// 3
	aAdd(aRetDados ,{alltrim(ZH3->ZH3_CLIENT)+ALLTRIM(ZH3->ZH3_LOJAC)})		// 4
	aAdd(aRetDados ,{alltrim(ZH3->ZH3_FORNEC)+ALLTRIM(ZH3->ZH3_LOJAF)})  	// 5
	aAdd(aRetDados ,{alltrim(ZH3->ZH3_RESULT)})								// 6

Endif


// Cria a instância de retorno ( WSDATA aRetColab AS aRetColabArray )
::aRetColab := WSClassNew( "aRetColabArray")
    
// inicializa a propriedade da estrutura de retorno
::aRetColab:ColabArray := {}
	
// Cria e alimenta uma nova instancia do cliente
oColabRet :=  WSClassNew( "aRetColabData" )
oColabRet:ColabCNPJ		:= aRetDados[1][1]
oColabRet:ColabOper		:= aRetDados[2][1]
oColabRet:ColabStatus	:= aRetDados[3][1]
oColabRet:ColabCodCli	:= aRetDados[4][1]
oColabRet:ColabCodFor	:= aRetDados[5][1]
oColabRet:ColabObs		:= aRetDados[6][1]

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
