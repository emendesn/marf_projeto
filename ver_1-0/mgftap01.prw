#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"                                     
/*
=====================================================================================
Programa.:              MGFTAP01
Autor....:              Atilio Amarilla
Data.....:              27/10/2016
Descricao / Objetivo:   Integração PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Integração de Processos Produtivos do Taura
Componentes da integração:
MGFTAP01-WS Server para Integração de Processos Produtivos do Taura
MGFTAP02-Job para Integração de Processos Produtivos do Taura
MGFTAP03-Chamada de execauto para Mata650 Ordens de Produção
MGFTAP04-Chamada de execautos MATA250
MGFTAP05-Chamada de execautos MATA240 
MGFTAP06-Chamada de execautos MATA685 (Apontamento de Perdas)
MGFTAP07-Chamada de execauto para Mata650 / Mata250 Encerramento OP
MGFTAP08-Chamada de execautos MATA261 (Transf. Mod. 2)
MGFTAP09-Chamada de execautos MATA270 (Inventário)
A250SPRC-Permitir encerramento com saldos (requis.) em processo
MGFTAP10-Chamado por PE A250SPRC. Retorna .T.
MGFTAP11-WS Client para envio de quantidades transferidas a armazém produtivo


Pendente:
MA260D3 -PE chamado após gravação da transferência (MATA260)
MA261D3 -PE chamado após gravação da transferência mod.2 (MATA261)
MGFTAP11-Chamado por PEs MA260D3 e MA261D3
Envia ao Taura os produtos transferidos ao Armazém Produtivo
=====================================================================================
*/

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Apontamento de Produção/Consumo de Insumos
WSSTRUCT MGFTAP01RequisProducao
	WSDATA D3_ACAO  	AS string
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_IDTAURA  	AS string
	WSDATA D3_OPTAURA	AS string
	WSDATA D3_TPOP		AS string
	WSDATA D3_TPMOV		AS string
	WSDATA D3_GERACAO	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_CODPA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS Float
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float  OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float  OPTIONAL
	WSDATA D3_ZPEDLOT	AS String OPTIONAL
	WSDATA D3_LOCAL		AS String OPTIONAL
	WSDATA D3_ChaveUID  As String OPTIONAL
	WSDATA D3_BLOQ      As String OPTIONAL

ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Apontamento de Produção/Consumo de Insumos
WSSTRUCT MGFTAP01RetornoProducao
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Encerramento de Produção
WSSTRUCT MGFTAP01RequisEncerraOP
	WSDATA D3_ACAO  	AS string
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_TPOP		AS string
	WSDATA D3_GERACAO	AS string
	WSDATA D3_CODPA		AS string
	WSDATA D3_OPTAURA	AS string         
	WSDATA D3_ChaveUID  As String OPTIONAL
	WSDATA D3_QUANT		AS Float					  
	//	WSDATA D3_IDTAURA   As String OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Encerramento de OP
WSSTRUCT MGFTAP01RetornoEncerraOP
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Apontamento de Perda
WSSTRUCT MGFTAP01RequisApontamentoPerda
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_IDTAURA  	AS string
	WSDATA D3_OPTAURA  	AS string
	WSDATA D3_TPOP		AS string
	WSDATA D3_GERACAO	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_CODPA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS Float
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Apontamento de Perda
WSSTRUCT MGFTAP01RetornoApontamentoPerda
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Baixa de Estoque
WSSTRUCT MGFTAP01RequisBaixaEstoque
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS Float
	WSDATA D3_OPTAURA	AS string OPTIONAL
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float  OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float  OPTIONAL
	WSDATA D3_CHAVEUID  AS String OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Baixa de Estoque
WSSTRUCT MGFTAP01RetornoBaixaEstoque
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Geração de Estoque
WSSTRUCT MGFTAP01RequisGeracaoEstoque
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS FLoat
	WSDATA D3_OPTAURA	AS string OPTIONAL
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float OPTIONAL
	WSDATA D3_CHAVEUID  AS String OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Geração de Estoque
WSSTRUCT MGFTAP01RetornoGeracaoEstoque
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de requisição. Bloqueio de Estoque
WSSTRUCT MGFTAP01RequisBloqueioEstoque
	WSDATA D3_ACAO  	AS string
	WSDATA D3_FILIAL  	AS string
	WSDATA D3_EMISSAO	AS string
	WSDATA D3_ZHORA		AS string
	WSDATA D3_COD		AS string
	WSDATA D3_QUANT		AS Float
	WSDATA D3_LOTECTL	AS string OPTIONAL
	WSDATA D3_DTVALID	AS string OPTIONAL
	WSDATA D3_ZQTDPCS	AS Float OPTIONAL
	WSDATA D3_ZQTDCXS	AS Float OPTIONAL
ENDWSSTRUCT

// Movimentos de Produção - Estrutura de dados. Montagem do Array de retorno. Bloqueio de Estoque
WSSTRUCT MGFTAP01RetornoBloqueioEstoque
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

// Estrutura de dados. Montagem do Array de requisição. Incentário
WSSTRUCT MGFTAP01RequisInventario
	WSDATA B7_ACAO		AS String
	WSDATA B7_FILIAL	AS String
	WSDATA B7_DATA		AS String
	WSDATA B7_PRODUTO	AS String
	WSDATA B7_SALDO		AS Float
	WSDATA B7_LOTECTL	AS String	OPTIONAL
	WSDATA B7_DOC		AS String	OPTIONAL
ENDWSSTRUCT

// Estrutura de dados. Montagem do Array de retorno. Incentário
WSSTRUCT MGFTAP01RetornoInventario
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT

/***************************************************************************
* Definicao do Web Service. Produção.				                       *
***************************************************************************/
WSSERVICE MGFTAP01 DESCRIPTION "Integração Protheus x TAURA - Produção" NameSpace "http://totvs.com.br/MGFTAP01.apw"

	// Produção - Passagem dos parâmetros de entrada
	WSDATA MGFTAP01RequisProd AS MGFTAP01RequisProducao
	// Produção - Retorno (array)
	WSDATA MGFTAP01RetornoProd AS MGFTAP01RetornoProducao

	// Produção - Passagem dos parâmetros de entrada. Encerramento de OP
	WSDATA MGFTAP01RequisEncOP AS MGFTAP01RequisEncerraOP
	// Produção - Retorno (array). Encerramento de OP
	WSDATA MGFTAP01RetornoEncOP AS MGFTAP01RetornoEncerraOP

	// Produção - Passagem dos parâmetros de entrada. Apontamento de Perda
	WSDATA MGFTAP01RequisPerda AS MGFTAP01RequisApontamentoPerda
	// Produção - Retorno (array). Apontamento de Perda
	WSDATA MGFTAP01RetornoPerda AS MGFTAP01RetornoApontamentoPerda

	// Estoque - Passagem dos parâmetros de entrada. Baixa de Estoque
	WSDATA MGFTAP01RequisBxEst AS MGFTAP01RequisBaixaEstoque
	// Estoeuq - Retorno (array). Baixa de Estoque
	WSDATA MGFTAP01RetornoBxEst AS MGFTAP01RetornoBaixaEstoque

	// Estoque - Passagem dos parâmetros de entrada. Geração de Estoque
	WSDATA MGFTAP01RequisGerEst AS MGFTAP01RequisGeracaoEstoque
	// Estoeuq - Retorno (array). Geração de Estoque
	WSDATA MGFTAP01RetornoGerEst AS MGFTAP01RetornoGeracaoEstoque

	// Estoque - Passagem dos parâmetros de entrada. Bloqueio de Estoque
	WSDATA MGFTAP01RequisBlqEst AS MGFTAP01RequisBloqueioEstoque
	// Estoeuq - Retorno (array). Bloqueio de Estoque
	WSDATA MGFTAP01RetornoBlqEst AS MGFTAP01RetornoBloqueioEstoque

	// Inventário - Passagem dos parâmetros de entrada
	WSDATA MGFTAP01RequisInvent AS MGFTAP01RequisInventario
	// Inventário - Retorno (array)
	WSDATA MGFTAP01RetornoInvent AS MGFTAP01RetornoInventario


	WSMETHOD GerarMovTaura DESCRIPTION "Integração Protheus x Taura - Processos Produtivos"
	WSMETHOD EncerramentodeOP DESCRIPTION "Integração Protheus x Taura - Encerramento de OP"
	WSMETHOD ApontamentoPerda DESCRIPTION "Integração Protheus x Taura - Apontamento de Perda"
	WSMETHOD BaixaEstoque DESCRIPTION "Integração Protheus x Taura - Baixa de Estoque"
	WSMETHOD GeracaoEstoque DESCRIPTION "Integração Protheus x Taura - Geracao de Estoque"
	WSMETHOD BloqueioEstoque DESCRIPTION "Integração Protheus x Taura - Bloqueio de Estoque"
	WSMETHOD GravarInventario DESCRIPTION "Integração Protheus x Taura - Registros de Inventário"

ENDWSSERVICE

/************************************************************************************
** Metodo GerarMovTaura
** Grava dados de processos produtivos - apontamentos / requisições referentes a OPs
************************************************************************************/
WSMETHOD GerarMovTaura WSRECEIVE	MGFTAP01RequisProd WSSEND MGFTAP01RetornoProd WSSERVICE MGFTAP01

	Local aRetFuncaadmino := {}
	Local StructTemp
	Local lReturn	:= .T.
	Local oRetProd
	Local cTime :=  'Antes: '+Time()                     

	aRetFuncao	:= MGFTAP01(	{	::MGFTAP01RequisProd:D3_ACAO	,;
	::MGFTAP01RequisProd:D3_FILIAL	,;
	::MGFTAP01RequisProd:D3_IDTAURA	,;
	::MGFTAP01RequisProd:D3_OPTAURA	,;
	::MGFTAP01RequisProd:D3_TPOP	,;
	::MGFTAP01RequisProd:D3_TPMOV	,;
	::MGFTAP01RequisProd:D3_GERACAO	,;
	::MGFTAP01RequisProd:D3_EMISSAO	,;
	::MGFTAP01RequisProd:D3_ZHORA	,;
	::MGFTAP01RequisProd:D3_CODPA	,;
	::MGFTAP01RequisProd:D3_COD		,;
	::MGFTAP01RequisProd:D3_QUANT	,;
	IIF(::MGFTAP01RequisProd:D3_LOTECTL<>NIL,::MGFTAP01RequisProd:D3_LOTECTL,"")	,;
	IIF(::MGFTAP01RequisProd:D3_DTVALID<>NIL,::MGFTAP01RequisProd:D3_DTVALID,"")	,;
	IIF(::MGFTAP01RequisProd:D3_ZQTDPCS<>NIL,::MGFTAP01RequisProd:D3_ZQTDPCS,0)		,;
	IIF(::MGFTAP01RequisProd:D3_ZQTDCXS<>NIL,::MGFTAP01RequisProd:D3_ZQTDCXS,0)		,;
	IIF(::MGFTAP01RequisProd:D3_ZPEDLOT<>NIL,::MGFTAP01RequisProd:D3_ZPEDLOT,"")	,;
	IIF(::MGFTAP01RequisProd:D3_LOCAL<>NIL,::MGFTAP01RequisProd:D3_LOCAL,"")	    ,;
	IIF(::MGFTAP01RequisProd:D3_ChaveUID<>NIL,::MGFTAP01RequisProd:D3_ChaveUID,"") ,;
	IIF(::MGFTAP01RequisProd:D3_BLOQ<>NIL    ,::MGFTAP01RequisProd:D3_BLOQ,"")	  } )	// Passagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoProd :=  WSClassNew( "MGFTAP01RetornoProducao" )
	::MGFTAP01RetornoProd:STATUS	:= aRetFuncao[1][1]
	::MGFTAP01RetornoProd:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisProd := Nil
	DelClassINTF()

	CONOUT('=== DADOS RETORNADOS NA EXECUCAO DO METODO GerarMovTaura =====' )
	for nn = 1 to len(aRetFuncao[1])
		CONOUT("---" + aRetFuncao[1][nn]    )
	next 
	
	//FwLogProfiler(,.T.) 

Return lReturn

/************************************************************************************
** Metodo EncerramentodeOP
** Grava dados de processos produtivos - Encerramento de OPs
************************************************************************************/
WSMETHOD EncerramentodeOP WSRECEIVE	MGFTAP01RequisEncOP WSSEND MGFTAP01RetornoEncOP WSSERVICE MGFTAP01

	Local aRetFuncao := {}
	Local StructTemp
	Local lReturn	:= .T.
	Local oRetProd

	aRetFuncao	:= MGFTAP01(	{	::MGFTAP01RequisEncOP:D3_ACAO		,;
	::MGFTAP01RequisEncOP:D3_FILIAL		,;
	'',;//::MGFTAP01RequisEncOP:D3_IDTAURA	,; //::MGFTAP01RequisEncOP:D3_IDTAURA
	::MGFTAP01RequisEncOP:D3_OPTAURA	,;
	::MGFTAP01RequisEncOP:D3_TPOP		,;
	"04"								,; //::MGFTAP01RequisEncOP:D3_TPMOV
	::MGFTAP01RequisEncOP:D3_GERACAO	,;
	::MGFTAP01RequisEncOP:D3_GERACAO	,; //::MGFTAP01RequisProd:D3_EMISSAO
	""									,; //::MGFTAP01RequisEncOP:D3_ZHORA
	::MGFTAP01RequisEncOP:D3_CODPA		,;
	::MGFTAP01RequisEncOP:D3_CODPA		,; //::MGFTAP01RequisProd:D3_COD
	IIF(::MGFTAP01RequisEncOP:D3_QUANT<>NIL,::MGFTAP01RequisEncOP:D3_QUANT,0)	,;
	""									,; //IIF(::MGFTAP01RequisEncOP:D3_LOTECTL<>NIL,::MGFTAP01RequisEncOP:D3_LOTECTL,"")
	""									,; //IIF(::MGFTAP01RequisEncOP:D3_DTVALID<>NIL,::MGFTAP01RequisEncOP:D3_DTVALID,"")
	0									,; //IIF(::MGFTAP01RequisEncOP:D3_ZQTDPCS<>NIL,::MGFTAP01RequisEncOP:D3_ZQTDPCS,0)
	0									,;	//IIF(::MGFTAP01RequisEncOP:D3_ZQTDCXS<>NIL,::MGFTAP01RequisEncOP:D3_ZQTDCXS,0)
	""									,;
	""									,;
	::MGFTAP01RequisEncOP:D3_ChaveUID , ''} )


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoEncOP :=  WSClassNew( "MGFTAP01RetornoEncerraOP" )
	::MGFTAP01RetornoEncOP:STATUS	:= aRetFuncao[1][1]
	::MGFTAP01RetornoEncOP:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisEncOP := Nil
	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo ApontamentoPerda
** Grava dados de processos produtivos - apontamento de perda
************************************************************************************/
WSMETHOD ApontamentoPerda WSRECEIVE	MGFTAP01RequisPerda WSSEND MGFTAP01RetornoPerda WSSERVICE MGFTAP01

	Local aRetFuncao := {}
	Local StructTemp
	Local lReturn	:= .T.
	Local oRetProd

	aRetFuncao	:= U_MGFTAP06(	{	::MGFTAP01RequisPerda:D3_FILIAL	,;
	::MGFTAP01RequisPerda:D3_IDTAURA	,;
	::MGFTAP01RequisPerda:D3_TPOP	,;
	::MGFTAP01RequisPerda:D3_GERACAO	,;
	::MGFTAP01RequisPerda:D3_EMISSAO	,;
	::MGFTAP01RequisPerda:D3_ZHORA	,;
	::MGFTAP01RequisPerda:D3_CODPA	,;
	::MGFTAP01RequisPerda:D3_COD		,;
	::MGFTAP01RequisPerda:D3_QUANT	,;
	IIF(::MGFTAP01RequisPerda:D3_LOTECTL<>NIL,::MGFTAP01RequisPerda:D3_LOTECTL,"")	,;
	IIF(::MGFTAP01RequisPerda:D3_DTVALID<>NIL,::MGFTAP01RequisPerda:D3_DTVALID,"")	,;
	IIF(::MGFTAP01RequisPerda:D3_ZQTDPCS<>NIL,::MGFTAP01RequisPerda:D3_ZQTDPCS,0)	,;
	IIF(::MGFTAP01RequisPerda:D3_ZQTDCXS<>NIL,::MGFTAP01RequisPerda:D3_ZQTDCXS,0)	,;
	IIF(::MGFTAP01RequisPerda:D3_OPTAURA<>NIL,::MGFTAP01RequisPerda:D3_OPTAURA,"")} )	// Passagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoPerda :=  WSClassNew( "MGFTAP01RetornoApontamentoPerda" )
	::MGFTAP01RetornoPerda:STATUS	:= aRetFuncao[1][1]	
	::MGFTAP01RetornoPerda:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisPerda := Nil
	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo BaixaEstoque
** Grava dados de processos produtivos - Mov. INternos - Requisições = Ajuste Negativo
************************************************************************************/
WSMETHOD BaixaEstoque WSRECEIVE	MGFTAP01RequisBxEst WSSEND MGFTAP01RetornoBxEst WSSERVICE MGFTAP01

	Local aRetFuncao := {}
	Local StructTemp
	Local lReturn	:= .T.
	Local oRetProd

	aRetFuncao	:= U_MGFTAP12(	{	"1"								,;
	::MGFTAP01RequisBxEst:D3_FILIAL	,;
	::MGFTAP01RequisBxEst:D3_EMISSAO,;
	::MGFTAP01RequisBxEst:D3_ZHORA	,;
	::MGFTAP01RequisBxEst:D3_COD	,;
	::MGFTAP01RequisBxEst:D3_QUANT	,;
	IIF(::MGFTAP01RequisBxEst:D3_LOTECTL<>NIL,::MGFTAP01RequisBxEst:D3_LOTECTL,"")	,;
	IIF(::MGFTAP01RequisBxEst:D3_DTVALID<>NIL,::MGFTAP01RequisBxEst:D3_DTVALID,"")	,;
	IIF(::MGFTAP01RequisBxEst:D3_ZQTDPCS<>NIL,::MGFTAP01RequisBxEst:D3_ZQTDPCS,0)	,;
	IIF(::MGFTAP01RequisBxEst:D3_ZQTDCXS<>NIL,::MGFTAP01RequisBxEst:D3_ZQTDCXS,0)	,;
	IIF(::MGFTAP01RequisBxEst:D3_OPTAURA<>NIL,::MGFTAP01RequisBxEst:D3_OPTAURA,"")	,;
	IIF(::MGFTAP01RequisBxEst:D3_CHAVEUID<>NIL,::MGFTAP01RequisBxEst:D3_CHAVEUID,"")} )	// Passagem de parâmetros para rotinaPassagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoBxEst :=  WSClassNew( "MGFTAP01RetornoBaixaEstoque" )
	::MGFTAP01RetornoBxEst:STATUS	:= aRetFuncao[1][1]
	::MGFTAP01RetornoBxEst:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisBxEst := Nil
	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo GeraEstoque
** Grava dados de processos produtivos - Mov. INternos - Devoluções = Ajuste Positivo
************************************************************************************/
WSMETHOD GeracaoEstoque WSRECEIVE	MGFTAP01RequisGerEst WSSEND MGFTAP01RetornoGerEst WSSERVICE MGFTAP01

	Local aRetFuncao := {}
	Local StructTemp
	Local lReturn	:= .T.

	aRetFuncao	:= U_MGFTAP12(	{	"2"								,;
	::MGFTAP01RequisGerEst:D3_FILIAL	,;
	::MGFTAP01RequisGerEst:D3_EMISSAO,;
	::MGFTAP01RequisGerEst:D3_ZHORA	,;
	::MGFTAP01RequisGerEst:D3_COD	,;
	::MGFTAP01RequisGerEst:D3_QUANT	,;
	IIF(::MGFTAP01RequisGerEst:D3_LOTECTL  <> NIL,::MGFTAP01RequisGerEst:D3_LOTECTL,"")	,;
	IIF(::MGFTAP01RequisGerEst:D3_DTVALID  <> NIL,::MGFTAP01RequisGerEst:D3_DTVALID,"")	,;
	IIF(::MGFTAP01RequisGerEst:D3_ZQTDPCS  <> NIL,::MGFTAP01RequisGerEst:D3_ZQTDPCS,0)		,;
	IIF(::MGFTAP01RequisGerEst:D3_ZQTDCXS  <> NIL,::MGFTAP01RequisGerEst:D3_ZQTDCXS,0)		,;
	IIF(::MGFTAP01RequisGerEst:D3_OPTAURA  <> NIL,::MGFTAP01RequisGerEst:D3_OPTAURA,"")	,;
	IIF(::MGFTAP01RequisGerEst:D3_CHAVEUID <> NIL,::MGFTAP01RequisGerEst:D3_CHAVEUID,"")} )	// Passagem de parâmetros para rotinaPassagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoGerEst :=  WSClassNew( "MGFTAP01RetornoGeracaoEstoque" )
	::MGFTAP01RetornoGerEst:STATUS	:= aRetFuncao[1][1]
	::MGFTAP01RetornoGerEst:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisGerEst := Nil
	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo BloqueioEstoque
** Grava dados de processos produtivos - Mov. INternos - Devoluções = Ajuste Positivo
************************************************************************************/
WSMETHOD BloqueioEstoque WSRECEIVE	MGFTAP01RequisBlqEst WSSEND MGFTAP01RetornoBlqEst WSSERVICE MGFTAP01

	Local aRetFuncao := {}
	Local StructTemp
	Local lReturn	:= .T.

	aRetFuncao	:= U_MGFTAP08(	{	::MGFTAP01RequisBlqEst:D3_ACAO														,;
	::MGFTAP01RequisBlqEst:D3_FILIAL													,;
	::MGFTAP01RequisBlqEst:D3_EMISSAO													,;
	::MGFTAP01RequisBlqEst:D3_ZHORA														,;
	::MGFTAP01RequisBlqEst:D3_COD														,;
	::MGFTAP01RequisBlqEst:D3_QUANT														,;
	IIF(::MGFTAP01RequisBlqEst:D3_LOTECTL<>NIL,::MGFTAP01RequisBlqEst:D3_LOTECTL,"")	,;
	IIF(::MGFTAP01RequisBlqEst:D3_DTVALID<>NIL,::MGFTAP01RequisBlqEst:D3_DTVALID,"")	,;
	IIF(::MGFTAP01RequisBlqEst:D3_ZQTDPCS<>NIL,::MGFTAP01RequisBlqEst:D3_ZQTDPCS,0)		,;
	IIF(::MGFTAP01RequisBlqEst:D3_ZQTDCXS<>NIL,::MGFTAP01RequisBlqEst:D3_ZQTDCXS,0)		} )	// Passagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoBlqEst :=  WSClassNew( "MGFTAP01RetornoBloqueioEstoque" )
	::MGFTAP01RetornoBlqEst:STATUS	:= aRetFuncao[1][1]
	::MGFTAP01RetornoBlqEst:MSG		:= aRetFuncao[1][2]

	::MGFTAP01RequisBlqEst := Nil
	DelClassINTF()

Return lReturn

/************************************************************************************
** Metodo GravarInventario
** Grava registros de inventário. Tabela SB7
************************************************************************************/
WSMETHOD GravarInventario WSRECEIVE	MGFTAP01RequisInvent WSSEND MGFTAP01RetornoInvent WSSERVICE MGFTAP01

	Local aRetorno	:= {}

	aRetorno	:= U_MGFTAP09(	{	::MGFTAP01RequisInvent:B7_ACAO		,;
	::MGFTAP01RequisInvent:B7_FILIAL	,;
	::MGFTAP01RequisInvent:B7_DATA		,;
	::MGFTAP01RequisInvent:B7_PRODUTO	,;
	::MGFTAP01RequisInvent:B7_SALDO		,;
	IIF(::MGFTAP01RequisInvent:B7_LOTECTL<>NIL,::MGFTAP01RequisInvent:B7_LOTECTL,"")	,;	
	IIF(::MGFTAP01RequisInvent:B7_DOC<>NIL,::MGFTAP01RequisInvent:B7_DOC,"")	} )	// Passagem de parâmetros para rotina

	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFTAP01RetornoInvent :=  WSClassNew( "MGFTAP01RetornoInventario" )
	::MGFTAP01RetornoInvent:STATUS	:= aRetorno[1]
	::MGFTAP01RetornoInvent:MSG		:= aRetorno[2]

Return .T.

Static Function MGFTAP01( aMovTaura )

	Local aRetorno := {}
	Local cCodPro, cCodPa, cCodDes, cCodRep
	Local cDBStr, cDBSrv, nDBPrt, nDBHnd
	Local aDBRet 	:= {}                  
	Local cLocBlq	:= GetMv("MGF_TAPBLQ",,"66")		// Almoxarifado Boqueio
	Local cLineF	:= (Chr(13)+Chr(10))

	
	cLocBlq		:= Stuff( Space(TamSX3("B1_LOCPAD")[1]) , 1 , Len(cLocBlq) , cLocBlq )
	cLocBlq		:= Subs( cLocBlq , 1 , TamSX3("B1_LOCPAD")[1] )
	
	If Empty( aMovTaura[12] )
		aAdd( aRetorno , {"2","[ZZE] Quantidade 0 (Zero)"} )
		Return( aRetorno )
	EndIf

	conout("-----------------------------------------------------------------")
	conout("======== RECEBIDO NO XML DO TAURA ")

	cMsgRec := ""
	for nII = 1 to len(aMovTaura)
		if nII=1
			cMsgRec += "MGFTAP01RequisProd:D3_ACAO = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=2
			cMsgRec += "MGFTAP01RequisProd:D3_FILIAL = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=3
			cMsgRec += "MGFTAP01RequisProd:D3_IDTAURA = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=4
			cMsgRec += "MGFTAP01RequisProd:D3_OPTAURA = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=5
			cMsgRec += "MGFTAP01RequisProd:D3_TPOP = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=6
			cMsgRec += "MGFTAP01RequisProd:D3_TPMOV = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=7
			cMsgRec += "MGFTAP01RequisProd:D3_GERACAO = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=8
			cMsgRec += "MGFTAP01RequisProd:D3_EMISSAO = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=9
			cMsgRec += "MGFTAP01RequisProd:D3_ZHORA = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=10		
			cMsgRec += "MGFTAP01RequisProd:D3_CODPA = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=11
			cMsgRec += "MGFTAP01RequisProd:D3_COD = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=12
			cMsgRec += "MGFTAP01RequisProd:D3_QUANT = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=13
			cMsgRec += "MGFTAP01RequisProd:D3_LOTECTL = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=14
			cMsgRec += "MGFTAP01RequisProd:D3_DTVALID = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=15
			cMsgRec += "MGFTAP01RequisProd:D3_ZQTDPCS = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=16
			cMsgRec += "MGFTAP01RequisProd:D3_ZQTDCXS = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=17
			cMsgRec += "MGFTAP01RequisProd:D3_ZPEDLOT = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=18
			cMsgRec += "MGFTAP01RequisProd:D3_LOCAL = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=19
			cMsgRec += "MGFTAP01RequisProd:D3_ChaveUID = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		elseif nII=20
			cMsgRec += "MGFTAP01RequisProd:D3_BLOQ = "
			cMsgRec += iif(valtype(aMovTaura[nII])="C", aMovTaura[nII]  ,alltrim(str(aMovTaura[nII]) )   )
			cMsgRec += cLineF
		endif 		
	next 

	conout( cMsgRec  )
	conout("======== RECEBIDO NO XML DO TAURA ")


	If Select("SX3") == 0
		aDBRet := LerStrConn()
		cDBSrv := aDBRet[1]
		cDBStr := aDBRet[2]
		nDBPrt := Val( aDBRet[3] )
		nDBHnd := TCLink(cDBStr,cDBSrv,nDBPrt)

		DEFAULT __TTSINUSE	:= .F.
		DEFAULT __CLOGSIGA	:= GetSrvProfString("RootPath","")+GetSrvProfString("StartPath","")+"wserror.log"

		If nDBHnd < 0
			ConOut("Erro ("+AllTrm(Str(nDBHnd,4))+") ao conectar com "+cDbStr+" em "+cDBSrv)
			aAdd( aRetorno , {"2","[ZZE] Erro de Conexão"} )
		Else

			dbUseArea(.T., "TOPCONN", "ZZE010", "ZZE", .T., .F.)

			dbSelectArea("ZZE")
			If RecLock("ZZE",.T.)
				ZZE->ZZE_FILIAL	:=	aMovTaura[02]
				ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
				ZZE->ZZE_IDTAUR	:=	aMovTaura[03]
				ZZE->ZZE_ACAO	:=	aMovTaura[01]
				ZZE->ZZE_OPTAUR	:=	aMovTaura[04]
				ZZE->ZZE_TPOP	:=	aMovTaura[05]
				ZZE->ZZE_TPMOV	:=	IIF(aMovTaura[05] == '15','06',aMovTaura[06])
				//Quando a Data de emissão e geração for diferente, mantem a data de geração.
				//O valor original dos campos enviados está gravado no campo ZZE_MSGREQ
				If aMovTaura[07] = aMovTaura[08] .or. aMovTaura[02] $ getmv("MGF_TAP01FL",,"010003,010042,020001")
					ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
					ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[08],"-")
				else 
					ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
					ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[07],"-")
				endif 	

				ZZE->ZZE_HORA	:=	aMovTaura[09]
				ZZE->ZZE_CODPA	:=	aMovTaura[10]
				ZZE->ZZE_COD	:=	aMovTaura[11]
				ZZE->ZZE_QUANT	:=	aMovTaura[12]
				ZZE->ZZE_LOTECT	:=	aMovTaura[13]
				ZZE->ZZE_DTVALI	:=	StrTran(aMovTaura[14],"-")
				ZZE->ZZE_QTDPCS	:=	aMovTaura[15]
				ZZE->ZZE_QTDCXS	:=	aMovTaura[16]
				ZZE->ZZE_PEDLOT	:=	aMovTaura[17]
				ZZE->ZZE_LOCAL	:=	IIF(Upper(SUBSTR(aMovTaura[20],1,1))=='S',cLocBlq,aMovTaura[18])
				ZZE->ZZE_CHAVEU :=	aMovTaura[19]
				ZZE->ZZE_STATUS :=	Ret_Status(aMovTaura[19])
				ZZE->ZZE_DTREC  := Date()
				ZZE->ZZE_HRREC  := Time()

				ZZE->ZZE_MSGREQ  := cMsgRec


				ZZE->( msUnlock() )
				aAdd( aRetorno , {"1",ZZE->ZZE_ID} )
			Else
				aAdd( aRetorno , {"2","[ZZE] Erro de Gravação"} )
			EndIf

			TcUnlink(nDBHnd)
			//conout("DB desconectado. "+Time())
		Endif
	Else

		aSM0 := FWLoadSM0()

		nPos      := ASCAN(aSM0,{|x| Alltrim(x[01])+Alltrim(x[02]) == "01"+Alltrim(aMovTaura[02])})

		IF nPos > 0
			cCodPro	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(aMovTaura[11]) , aMovTaura[11] )
			cCodPA	:= Stuff( Space(TamSX3("B1_COD")[1]) , 1 , Len(aMovTaura[10]) , aMovTaura[10] )

			cFilAnt := aMovTaura[02]

			lCodAgr	:= GetMV("MGF_TAP01A",,.F.) // ExistField("SB1","B1_ZCODAGR")
			cCodRep	:= GetMV("MGF_TAP01B",,"XX/")
			cCodDes	:= GetMV("MGF_TAP01C",,"05/06/07/08/09/")

			dbSelectArea("SB1")
			dbSelectArea("ZZE")
			If SB1->( dbSeek( xFilial("SB1")+cCodPA ) )
				cMsgDes	:= ""
				If lCodAgr
					If !Empty( SB1->B1_ZCODAGR ) .And. aMovTaura[05] $ cCodRep
						aMovTaura[10]	:= SB1->B1_ZCODAGR
						If aMovTaura[06] $ GetMv("MGF_TAP02E",,"01/")
							aMovTaura[11]	:= SB1->B1_ZCODAGR
						EndIf
					ElseIf aMovTaura[05] $ cCodRep
						cMsgDes += "[MGFTAP01] Produto Intermediário não cadastrado para PA: "+aMovTaura[10]
					Endif
				EndIf
				//If lCodPA
					If SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
						If lCodAgr
							If !Empty( SB1->B1_ZCODAGR ) .And. aMovTaura[05] $ cCodDes
								If !aMovTaura[06] $ GetMv("MGF_TAP02E",,"01/")
									aMovTaura[11]	:= SB1->B1_ZCODAGR
								EndIf
							ElseIf aMovTaura[05] $ cCodDes .And. Empty(cMsgDes)
								cMsgDes += "[MGFTAP01] Produto Intermediário não cadastrado para produto: "+aMovTaura[11]
							Endif 
						EndIf
						//If lCodPA
							If RecLock("ZZE",.T.)
								ZZE->ZZE_FILIAL	:=	aMovTaura[02]
								ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
								ZZE->ZZE_IDTAUR	:=	aMovTaura[03]
								ZZE->ZZE_ACAO	:=	aMovTaura[01]
								ZZE->ZZE_OPTAUR	:=	aMovTaura[04]
								ZZE->ZZE_TPOP	:=	aMovTaura[05]
								ZZE->ZZE_TPMOV	:=	IIF(aMovTaura[05] == '15','06',aMovTaura[06])

								//Quando a Data de emissão e geração for diferente, mantem a data de geração.
								//O valor original dos campos enviados está gravado no campo ZZE_MSGREQ

								If aMovTaura[07] = aMovTaura[08] .or. aMovTaura[02] $ getmv("MGF_TAP01FL",,"010003,010042,020001")
									ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
									ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[08],"-")
								else 
									ZZE->ZZE_GERACA	:=	StrTran(aMovTaura[07],"-")
									ZZE->ZZE_EMISSA	:=	StrTran(aMovTaura[07],"-")
								endif 	
				
								ZZE->ZZE_HORA	:=	aMovTaura[09]
								ZZE->ZZE_CODPA	:=	aMovTaura[10]
								ZZE->ZZE_COD	:=	aMovTaura[11]
								ZZE->ZZE_QUANT	:=	aMovTaura[12]
								If SB1->B1_RASTRO $ "LS"
									ZZE->ZZE_LOTECT	:=	aMovTaura[13]
									ZZE->ZZE_DTVALI	:=	StrTran(aMovTaura[14],"-")
								EndIf
								ZZE->ZZE_QTDPCS	:=	aMovTaura[15]
								ZZE->ZZE_QTDCXS	:=	aMovTaura[16]
								ZZE->ZZE_PEDLOT	:=	aMovTaura[17]
								ZZE->ZZE_LOCAL	:=	IIF(Upper(SUBSTR(aMovTaura[20],1,1))=='S',cLocBlq,aMovTaura[18])
								ZZE->ZZE_CHAVEU :=	aMovTaura[19]
								ZZE->ZZE_STATUS :=	Ret_Status(aMovTaura[19])
								ZZE->ZZE_DTREC  := Date()
								ZZE->ZZE_HRREC  := Time()
								If !Empty(cMsgDes)
									ZZE->ZZE_STATUS	:= '2'
									ZZE->ZZE_DESCER	:= cMsgDes 
									ZZE->ZZE_DTPROC	:= Date()
									ZZE->ZZE_HRPROC	:= Time()
								EndIf

								ZZE->( msUnlock() )
								aAdd( aRetorno , {"1",ZZE->ZZE_ID} )

							Else
								aAdd( aRetorno , {"2","[ZZE] Erro de Gravação"} )
							EndIf
	
						Else
						aAdd( aRetorno , {"2","[ZZE] Produto não cadastrado: "+aMovTaura[11]} )
					EndIf

			Else
				aAdd( aRetorno , {"2","[ZZE] Produto (PA) não cadastrado: "+aMovTaura[10]} )
			EndIf
		Else
			aAdd( aRetorno , {"2","[ZZE] Filial inválida: "+aMovTaura[02]} )
		EndIf

	EndIf

Return( aRetorno )

Static Function LerStrConn()

	Local aRet  := {}
	Local cFile := "MGFTAP01.INI"
	Local cAux  := ""

	FT_FUSE( cFile )
	FT_FGOTOP()

	While !FT_FEOF()

		cAux := FT_FREADLN()

		aAdd( aRet , AllTrim(cAux) )

		FT_FSKIP()
	End

	FT_FUSE()

	Return aRet
	****************************************************************************************************************
Static Function Ret_Status(cChave)
	Local cQuery    := ''
	Local cRet      := ' '
	Local cUpd		:= ''  

	cQuery  := " SELECT ZZE_CHAVEU "
	cQuery  += " FROM "+RetSqlName("ZZE")
	cQuery  += " WHERE D_E_L_E_T_ = ' ' "
	cQuery  += "  AND ZZE_CHAVEU='"+Alltrim(cChave)+"' "
	cQuery  += "  AND ZZE_STATUS NOT IN ('2','9') "

	If Select("QRY_CHAVE") > 0
		QRY_CHAVE->(dbCloseArea())
	EndIf

	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CHAVE",.T.,.F.)

	dbSelectArea("QRY_CHAVE")
	QRY_CHAVE->(dbGoTop())

	If QRY_CHAVE->(!EOF()) 
		cRet := '9'
	Else

		cUpd := "UPDATE "+RetSqlName("ZZE")+" " + CRLF
		cUpd += "SET ZZE_STATUS = '9' " + CRLF
		cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cUpd += "	AND ZZE_CHAVEU='"+Alltrim(cChave)+"' "+CRLF
		cUpd += "	AND ZZE_STATUS = '2' "+CRLF

		If TcSqlExec( cUpd ) == 0
			If "ORACLE" $ TcGetDB()
				TcSqlExec( "COMMIT" )
			EndIf
		EndIf

	EndIf

	Return cRet 
