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
/*/{Protheus.doc} jMGFWC14
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWC14(cFilJob)

	U_MGFWSC14({,"01",cFilJob})

Return

User Function eMGFWS14()

	runInteg14()

Return

User Function MGFWSC14(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC14] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg14()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg14()
	local cURLPost		:= allTrim(getMv("MGF_SFA14"))
	local oWSSFA		:= nil
	private oTypeSales	:= nil

	getTypeSO()

	while !QRYSZJ->(EOF())
		oTypeSales := nil
		oTypeSales := typeSalesO():new()

		oTypeSales:setTypeSal()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oTypeSales , QRYSZJ->SZJREC , "SZJ", "ZJ_XINTEGR", allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA14T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSZJ->(DBSkip())
	enddo

	QRYSZJ->(DBCloseArea())
return




static function getTypeSO()
	local cQrySZJ := ""

	cQrySZJ := "SELECT SZJ.*, SZJ.D_E_L_E_T_ SZJDEL, SZJ.R_E_C_N_O_ SZJREC "										+ chr(13) + chr(10)
	cQrySZJ += " FROM "			+ retSQLName("SZJ") + " SZJ"	+ chr(13) + chr(10)
	cQrySZJ += " WHERE" + chr(13) + chr(10)
	cQrySZJ += " 		SZJ.ZJ_XINTEGR	=	'P'"

	cQrySZJ += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial("SZJ") + "'" + chr(13) + chr(10)

	cQrySZJ += " ORDER BY SZJ.R_E_C_N_O_" 										+ chr(13) + chr(10)

	conout( cQrySZJ )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySZJ)), "QRYSZJ" , .F. , .T. )
return




Class typeSalesO
	Data applicationArea AS ApplicationArea
	Data idEstrutur AS string
	Data nome AS string
	Data statusDCN AS string
	Data isDelete AS string

	Method New()
	Method setTypeSal()
EndClass




Method new( ) Class typeSalesO
	self:applicationArea	:= ApplicationArea():new()
return




Method setTypeSal( ) Class typeSalesO
	self:idEstrutur := QRYSZJ->ZJ_COD
	self:nome		:= QRYSZJ->ZJ_NOME

	if QRYSZJ->SZJDEL == "*" .or.  QRYSZJ->ZJ_XSFA == "N"
		self:isDelete := "S"
		self:statusDCN	:= "D"
	else
		self:isDelete := "N"
		self:statusDCN	:= "U"
	endif
return
