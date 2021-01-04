#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
//
//
//
/*/{Protheus.doc} jMGFWC13
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWC13(cFilJob)

	U_MGFWSC13({,"01",cFilJob})

Return

User Function eMGFWS13()

	runInteg13()

Return

User Function MGFWSC13(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC13] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg13()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg13()
	local cURLPost		:= allTrim(getMv("MGF_SFA13"))
	local oWSSFA		:= nil
	private oTypeSFA	:= nil

	getTypeSFA()

	while !QRYZZV->(EOF())
		oTypeSFA := nil
		oTypeSFA := typeSFA():new()

		oTypeSFA:setTypeSFA()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oTypeSFA , QRYZZV->ZZVREC , "ZZV", "ZZV_XINTEG", allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA02T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYZZV->(DBSkip())
	enddo

	QRYZZV->(DBCloseArea())
return




static function getTypeSFA()
	local cQRYZZV := ""

	cQryZZV := "SELECT ZZV.*, ZZV.D_E_L_E_T_ ZZVDEL, ZZV.R_E_C_N_O_ ZZVREC "												+ chr(13) + chr(10)
	cQryZZV += " FROM "			+ retSQLName("ZZV") + " ZZV" + chr(13) + chr(10)
	cQryZZV += " WHERE" + chr(13) + chr(10)
	cQryZZV += " 		ZZV.ZZV_XINTEG	=	'P'"
	cQryZZV += " 	AND	ZZV.ZZV_XSFA	=	'S'"
	cQryZZV += " 	AND	ZZV.ZZV_FILIAL	=	'" + xFilial("ZZV") + "'" + chr(13) + chr(10)

	cQryZZV += " ORDER BY ZZV.R_E_C_N_O_" 										+ chr(13) + chr(10)

	conout(cQRYZZV)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQRYZZV)), "QRYZZV" , .F. , .T. )
return




Class typeSFA
	Data applicationArea AS ApplicationArea
	Data idEstrutur AS string
	Data nome AS string
	Data statusDCN AS string
	Data isDelete AS string

	Method New()
	Method setTypeSFA()
EndClass




Method new( ) Class typeSFA
	self:applicationArea	:= ApplicationArea():new()
return




Method setTypeSFA( ) Class typeSFA

	self:idEstrutur := QRYZZV->ZZVREC
	self:nome		:= allTrim(QRYZZV->ZZV_DESCRI)

	if QRYZZV->ZZVDEL == "*"
		self:isDelete := "S"
		self:statusdcn					:= "D"
	else
		self:isDelete := "N"
		self:statusdcn					:= "U"
	endif
return
