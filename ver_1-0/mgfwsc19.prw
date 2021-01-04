#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
//
/*/{Protheus.doc} eMGFWS19
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS19()

	runInteg19()

Return


User Function jMGFWC19(cFilJob)

	U_MGFWSC19({,"01",cFilJob})

Return

User Function MGFWSC19(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC19] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg19()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg19()
	local cURLPost		:= allTrim(getMv("MGF_SFA19"))
	local oWSSFA		:= nil
	private oCondPgto	:= nil

	getSE4()

	while !QRYSE4->(EOF())
		oCondPgto := nil
		oCondPgto := condpgto():new()

		oCondPgto:setCondPgt()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oCondPgto , QRYSE4->E4RECNO , "SE4" , "E4_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA19T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSE4->(DBSkip())
	enddo

	QRYSE4->(DBCloseArea())
return




static function getSE4()
	local cQrySE4 := ""

	cQrySE4 := "SELECT R_E_C_N_O_ E4RECNO, E4_CODIGO, E4_DESCRI, E4_ACRSFIN, D_E_L_E_T_ E4DEL"																		+ chr(13) + chr(10)
	cQrySE4 += " FROM "			+ retSQLName("SE4") + " SE4"							+ chr(13) + chr(10)
	cQrySE4 += " WHERE"							+ chr(13) + chr(10)
	cQrySE4 += " 		SE4.E4_XINTEGR	=	'P'"										+ chr(13) + chr(10)
	cQrySE4 += " 	AND	SE4.E4_XSFA		=	'S'"						+ chr(13) + chr(10)
	cQrySE4 += " 	AND	SE4.E4_FILIAL		=	'" + xFilial("SE4") + "'"							+ chr(13) + chr(10)
	cQrySE4 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ chr(13) + chr(10)
	cQrySE4 += " ORDER BY SE4.R_E_C_N_O_" 										+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySE4)), "QRYSE4" , .F. , .T. )
return




Class condpgto
	Data applicationArea AS ApplicationArea
	Data nidcondpgto AS string
	Data cnome AS string
	Data ntaxa AS string
	Data isDelete AS string
	Data statusDCN AS string

	Method New()
	Method setCondPgt()
EndClass




Method new( ) Class condpgto
	self:applicationArea	:= ApplicationArea():new()
return




Method setCondPgt( ) Class condpgto

	self:nidcondpgto	:= QRYSE4->E4RECNO
	self:cnome			:= QRYSE4->E4_DESCRI
	self:ntaxa			:= QRYSE4->E4_ACRSFIN

	if QRYSE4->E4DEL == "*"
		self:isDelete := "S"
		self:statusDCN	:= "D"
	else
		self:isDelete := "N"
		self:statusDCN	:= "U"
	endif
return
