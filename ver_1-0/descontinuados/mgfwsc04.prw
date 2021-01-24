#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#include "rwmake.ch"

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC04
Job de envio de preços para o SFA

@author thiago.queiroz
@since 02/10/2019 
@type Job  
/*/   
User Function MGFWSC04(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC04] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg04()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return

/*
===========================================================================================================================
/{Protheus.doc} jMGFWC04
Chamada via Job
*/
User Function jMGFWC04(cFilJob)

	U_MGFWSC04({,"01",cFilJob})

Return

/*
===========================================================================================================================
{Protheus.doc} eMGFWS04
Chamada via tela
*/
User Function eMGFWS04()

	If MsgYesNo("Deseja iniciar integrações de tabelas de preço com SFA?")
		fwmsgrun(,{|| runInteg04()},"Aguarde processamento...","Aguarde processamento...")
	Else
		msgbox("Processo Cancelado")
	Endif

Return

/*
===========================================================================================================================
{Protheus.doc} runInteg04
Execução da integração
*/
static function runInteg04()
	local cURLPost		:= allTrim(getMv("MGF_SFA04"))
	local oWSSFA		:= nil
	local lRet			:= .T.
	local nI			:= 0
	local nLimThread	:= 50
	local cFilSFA		:= allTrim( getMv( "MGF_SFAFIL" ) )
	local aFilSFA		:= {}
	private oPrice		:= nil
	private nPrice		:= nil

	cFilSFA := STRTRAN ( cFilSFA	, "'" )
	aFilSFA := strTokArr( cFilSFA	, "," )

	//Valida itens duplicados em tabelas de preços
	_cQuery := " select COUNT (DA1_CODPRO),DA1_CODPRO,DA1_CODTAB,DA1_FILIAL FROM  " + Retsqlname("DA1")

	_cQuery += " WHERE DA1_CODTAB IN (SELECT DA0_CODTAB FROM " + Retsqlname("DA0") + " WHERE DA0_XSFA ='S' AND D_E_L_E_T_ =' ' "
    _cQuery += "       	AND DA0_DATATE >=TO_CHAR(TO_DATE(SYSDATE),'YYYYMMDD') AND DA0_DATDE <=TO_CHAR(TO_DATE(SYSDATE),'YYYYMMDD')) "
	_cQuery += "		AND D_E_L_E_T_ =' ' "
	_cQuery += " HAVING COUNT (DA1_CODPRO) > 1 "
	_cQuery += " GROUP BY DA1_CODPRO,DA1_CODTAB,DA1_FILIAL "

	If select("TMPDUP") > 0
		TMPDUP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TMPDUP", .F., .T.)

	If TMPDUP->(!eof())

		_adups := {}
		_cdups := ""

		Do while TMPDUP->(!eof())
			aadd(_adups,{TMPDUP->DA1_CODTAB,TMPDUP->DA1_CODPRO})
			_cdups += TMPDUP->DA1_CODTAB + " - " +  TMPDUP->DA1_CODPRO + " / "
			TMPDUP->(Dbskip())
		EndDo

		If isInCallStack("U_eMGFWS04") //Chamada via tela

			_aheader := {"Tabela","Produto"}
			msgalert("Produtos duplicados na tabela de preço, integração não será realizada!")
			U_MGListBox( "Produtos duplicados na tabela de preço, integração não será realizada:" , _aheader , _Adups , .T. , 1 )
			
		Endif

		conout("[MGFWSC04] Produtos duplicados, integração não será realizada: " + _cdups )
		Return

	Endif

	TMPDUP->(Dbclosearea())

	for nI := 1 to len(aFilSFA)
		conout("[MGFWSC04] Enviando lista de Preço - Empresa " + aFilSFA[nI] + dToC(dDataBase) + " - " + time())

		oPrice := nil
		oPrice := priceSFA():new()

		oPrice:centroDistribuicao := aFilSFA[nI]

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oPrice ,,, , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA04T")) ,,,, .T.  , .T.  )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()

	next

	If isInCallStack("U_eMGFWS04") //Chamada via tela
		msgbox("Iniciada integração de tabelas de preço com SFA!")
	Else
		conout("[MGFWSC04] Completado envio de listas de Preços")
	Endif

return

Class priceSFA
	Data centroDistribuicao AS string

	Method New()
	Method setPrice()
EndClass

Method new( ) Class priceSFA
	self:centroDistribuicao	:= ""
return

Method setPrice( ) Class priceSFA
	self:centroDistribuicao	:= allTrim(cFilAnt)
return
