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
/*/{Protheus.doc} jMGFWC09
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWC09(cFilJob)

	U_MGFWSC09({,"01",cFilJob})

Return

User Function eMGFWS09()

	runInteg09()

Return


User Function MGFWSC09(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC09] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg09()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return

static function runInteg09()
	local cURLPost		:= allTrim(getMv("MGF_SFA09"))
	local oWSSFA		:= nil
	private oCategory		:= nil

	categoryToSFA()

	while !QRYZA4->(EOF())
		oCategory := nil
		oCategory := CategorySFA():new()

		oCategory:setCategory()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oCategory , , "", "", allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA09T")))
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYZA4->(DBSkip())
	enddo

	QRYZA4->(DBCloseArea())
return




static function categoryToSFA()
	local cQryZA4 := ""

	cQryZA4 := "SELECT"												+ chr(13) + chr(10)
	cQryZA4 += " ZA4_CODIGO, ZA4_DESCR,"	+ chr(13) + chr(10)
	cQryZA4 += " ZA4.D_E_L_E_T_ ZA4DEL, R_E_C_N_O_ ZA4REC"	+ chr(13) + chr(10)
	cQryZA4 += " FROM "	+ retSQLName("ZA4") + " ZA4" + chr(13) + chr(10)
	cQryZA4 += " WHERE" + chr(13) + chr(10)


	cQryZA4 += " 	ZA4.ZA4_FILIAL	=	'" + xFilial("ZA4") + "'" + chr(13) + chr(10)
	cQryZA4 += " ORDER BY ZA4.R_E_C_N_O_" 														+ chr(13) + chr(10)

	conout( cQryZA4 )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQryZA4)), "QRYZA4" , .F. , .T. )
return




Class categorySFA
	Data applicationArea AS ApplicationArea
	Data nidestrutu AS string
	Data nome AS string
	Data isDelete AS string
	Data statusDCN AS string

	Method New()
	Method setCategory()
EndClass




Method new( ) Class categorySFA
	self:applicationArea	:= ApplicationArea():new()
return




Method setCategory( ) Class categorySFA
	self:nidestrutu := QRYZA4->ZA4_CODIGO
	self:nome		:= QRYZA4->ZA4_DESCR
	if QRYZA4->ZA4DEL == "*"
		self:isDelete := "S"
		self:statusdcn					:= "D"
	else
		self:isDelete := "N"
		self:statusdcn					:= "U"
	endif
return
