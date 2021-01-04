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
/*/{Protheus.doc} eMGFWS21
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS21()

	runInteg21()

Return


User Function jMGFWC21(cFilJob)

	U_MGFWSC21({,"01",cFilJob})

Return


User Function MGFWSC21(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC21] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg21()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg21()
	local cURLPost		:= allTrim(getMv("MGF_SFA21"))
	local oWSSFA		:= nil
	private oDescProg	:= nil

	getSZM()

	while !QRYSZM->(EOF())
		oDescProg := nil
		oDescProg := descProgIt():new()

		oDescProg:setDcProIt()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oDescProg ,  QRYSZM->ZMRECNO, "SZM" , "ZM_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA19T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()

		QRYSZM->(DBSkip())
	enddo

	QRYSZM->(DBCloseArea())
return




static function getSZM()
	local cQRYSZM := ""

	cQRYSZM := " SELECT ZM_QTDE, ZM_PERDESC, ZM_CODTAB, SZM.D_E_L_E_T_ SZMDEL, SZM.R_E_C_N_O_ ZMRECNO, DA0.R_E_C_N_O_ DA0RECNO"
	cQRYSZM += " FROM  "+RetSQLName("SZM") + " SZM  " + chr(13) + chr(10)
	cQRYSZM += " INNER JOIN  "	+ RetSQLName("DA0") + " DA0"		+ chr(13) + chr(10)
	cQRYSZM += " ON" 												+ chr(13) + chr(10)
	cQRYSZM += " 	SZM.ZM_CODTAB = DA0.DA0_CODTAB "				+ chr(13) + chr(10)
	cQRYSZM += " WHERE SZM.ZM_FILIAL = '" + xFilial("SZM") + "' " + chr(13) + chr(10)
	cQRYSZM += " 	AND	SZM.ZM_XINTEGR = 'P' "+ chr(13) + chr(10)
	cQRYSZM += " 	AND	SZM.ZM_XSFA = 'S' "+ chr(13) + chr(10)
	cQRYSZM += " ORDER BY SZM.R_E_C_N_O_" 										+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQRYSZM)), "QRYSZM" , .F. , .T. )
return




Class descProgIt
	Data applicationArea AS ApplicationArea
	Data nCodLista AS string
	Data nQtdInicial AS float
	Data nTaxa AS float
	Data nVolInicial AS float
	Data isDelete AS string
	Data statusDCN AS string

	Method New()
	Method setDcProIt()
EndClass




Method  new( ) Class descProgIt
	self:applicationArea	:= ApplicationArea():new()
return




Method setDcProIt( ) Class descProgIt

	self:nCodLista		:= QRYSZM->DA0RECNO
	self:nQtdInicial	:= QRYSZM->ZM_QTDE
	self:nTaxa			:= QRYSZM->ZM_PERDESC
	self:nVolInicial	:= 0

	if QRYSZM->SZMDEL == "*"
		self:isDelete := "S"
		self:statusDCN	:= "D"
	else
		self:isDelete := "N"
		self:statusDCN	:= "U"
	endif
return
