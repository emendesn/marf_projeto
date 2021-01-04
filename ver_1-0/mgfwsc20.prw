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
/*/{Protheus.doc} eMGFWS20
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS20()

	runInteg20()

Return


User Function jMGFWC20(cFilJob)

	U_MGFWSC20({,"01",cFilJob})

Return

User Function MGFWSC20(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC20] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg20()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg20()
	local cURLPost		:= allTrim(getMv("MGF_SFA20"))
	local oWSSFA		:= nil
	private oDescProg	:= nil

	getSZL()

	while !QRYSZL->(EOF())
		oDescProg := nil
		oDescProg := descProgVl():new()

		oDescProg:setDescPro()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oDescProg ,QRYSZL->ZLRECNO , "SZL" , "ZL_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA19T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSZL->(DBSkip())
	enddo

	QRYSZL->(DBCloseArea())
return




static function getSZL()
	local cQRYSZL := ""

	cQRYSZL := " SELECT ZL_VOLUME, ZL_PERDESC, ZL_CODTAB, SZL.D_E_L_E_T_ SZLDEL, SZL.R_E_C_N_O_ ZLRECNO, DA0.R_E_C_N_O_ DA0RECNO "
	cQRYSZL += " FROM "			+ RetSQLName("SZL") + " SZL"		+ chr(13) + chr(10)
	cQRYSZL += " INNER JOIN  "	+ RetSQLName("DA0") + " DA0"		+ chr(13) + chr(10)
	cQRYSZL += " ON" 												+ chr(13) + chr(10)
	cQRYSZL += " 	SZL.ZL_CODTAB = DA0.DA0_CODTAB "				+ chr(13) + chr(10)
	cQRYSZL += " WHERE SZL.ZL_FILIAL = '" + xFilial("SZL") + "' "	+ chr(13) + chr(10)
	cQRYSZL += " 	AND	SZL.ZL_XINTEGR = 'P' "+ chr(13) + chr(10)
	cQRYSZL += " 	AND	SZL.ZL_XSFA = 'S' "+ chr(13) + chr(10)
	cQRYSZL += " ORDER BY SZL.R_E_C_N_O_" 										+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQRYSZL)), "QRYSZL" , .F. , .T. )
return




Class descProgVl
	Data applicationArea AS ApplicationArea
	Data nCodLista AS string
	Data nQtdInicial AS float
	Data nTaxa AS float
	Data nVolInicial AS float
	Data isDelete AS string
	Data statusDCN AS string

	Method New()
	Method setDescPro()
EndClass




Method new( ) Class descProgVl
	self:applicationArea	:= ApplicationArea():new()
return




Method setDescPro( ) Class descProgVl

	self:nCodLista		:= QRYSZL->DA0RECNO
	self:nTaxa			:= QRYSZL->ZL_PERDESC
	self:nVolInicial	:= QRYSZL->ZL_VOLUME
	self:nQtdInicial	:= 0

	if QRYSZL->SZLDEL == "*"
		self:isDelete := "S"
		self:statusDCN	:= "D"
	else
		self:isDelete := "N"
		self:statusDCN	:= "U"
	endif
return
