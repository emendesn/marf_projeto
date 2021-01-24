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
/*/{Protheus.doc} eMGFWS16
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS16()

	runInteg16()

Return


User Function jMGFWC16(cFilJob)

	U_MGFWSC16({,"01",cFilJob})

Return

User Function MGFWSC16(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC16] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg16()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg16()
	local cURLPost		:= allTrim(getMv("MGF_SFA16"))
	local oWSSFA		:= nil
	private oVendedor	:= nil

	conout( "[MGFWSC16] [SFA] [EMPRESA] " + allTrim(cEmpAnt) + " [FILIAL] " + allTrim(cFilAnt) + " Inicio " + time() )

	getSA3()

	while !QRYSA3->(EOF())
		oVendedor := nil
		oVendedor := vendedor():new()

		oVendedor:setVendedo()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oVendedor , QRYSA3->A3RECNO , "SA3" , "A3_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA16T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSA3->(DBSkip())
	enddo

	QRYSA3->(DBCloseArea())

	conout( "[MGFWSC16] [SFA] [EMPRESA] " + allTrim(cEmpAnt) + " [FILIAL] " + allTrim(cFilAnt) + " Inicio " + time() )
return




static function getSA3()
	local cQrySA3 := ""

	cQrySA3 := "SELECT "																		+ chr(13) + chr(10)
	cQrySA3 += " SA3.R_E_C_N_O_ A3RECNO, A3_GEREN,A3_SUPER,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_CEP,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_MUN,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_COD,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_EMAIL,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_END,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_EST,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_COD,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_NOME,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_DDDTEL,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_TEL,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_CEL,"							+ chr(13) + chr(10)
	cQrySA3 += " A3_CODUSR,"							+ chr(13) + chr(10)

	cQrySA3 += " ("	+ chr(13) + chr(10)
	cQrySA3 += " 	SELECT YA_DESCR"	+ chr(13) + chr(10)
	cQrySA3 += " 	FROM " + retSQLName("SYA") + " SYA"	+ chr(13) + chr(10)
	cQrySA3 += " 	WHERE"	+ chr(13) + chr(10)
	cQrySA3 += " 		SYA.YA_CODGI = SA3.A3_PAIS"	+ chr(13) + chr(10)
	cQrySA3 += " 	AND SYA.YA_FILIAL	=	'" + xFilial("SYA") + "'"	+ chr(13) + chr(10)
	cQrySA3 += " 	AND SYA.D_E_L_E_T_ <> '*'"	+ chr(13) + chr(10)
	cQrySA3 += " ) A3_PAIS,"	+ chr(13) + chr(10)
	cQrySA3 += " SA3.D_E_L_E_T_ SA3DEL,"							+ chr(13) + chr(10)


	cQrySA3 += " NVL( TRIM( ZBI_DIRETO ), '000000' ) ZBI_DIRETO,"							+ chr(13) + chr(10)
	cQrySA3 += " NVL( TRIM( ZBI_NACION ), '000000' ) ZBI_NACION,"							+ chr(13) + chr(10)
	cQrySA3 += " NVL( TRIM( ZBI_TATICA ), '000000' ) ZBI_TATICA,"							+ chr(13) + chr(10)
	cQrySA3 += " NVL( TRIM( ZBI_REGION ), '000000' ) ZBI_REGION,"							+ chr(13) + chr(10)
	cQrySA3 += " NVL( TRIM( ZBI_SUPERV ), '000000' ) ZBI_SUPERV"							+ chr(13) + chr(10)

	cQrySA3 += " FROM "			+ retSQLName("SA3") + " SA3"								+ chr(13) + chr(10)

	cQrySA3 += " LEFT JOIN " + retSQLName("ZBI") + " ZBI"									+ chr(13) + chr(10)
	cQrySA3 += " ON"							+ chr(13) + chr(10)
	cQrySA3 += " 		ZBI.ZBI_REPRES	=	SA3.A3_COD"							+ chr(13) + chr(10)
	cQrySA3 += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'"							+ chr(13) + chr(10)
	cQrySA3 += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"							+ chr(13) + chr(10)

	cQrySA3 += " WHERE"							+ chr(13) + chr(10)
	cQrySA3 += " 		SA3.A3_XINTEGR	=	'P'"										+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.A3_XSFA		=	'S'"						+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.A3_MSBLQL	=	'2'"						+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.A3_FILIAL		=	'" + xFilial("SA3") + "'"							+ chr(13) + chr(10)

	cQrySA3 += " ORDER BY SA3.R_E_C_N_O_" 										+ chr(13) + chr(10)



	conout( "[MGFWSC16] [SFA] " + cQrySA3 )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySA3)), "QRYSA3" , .F. , .T. )
return




Class vendedor
	Data applicationArea AS ApplicationArea
	Data ccep AS string
	Data ccidade AS string
	Data ncodvended AS int
	Data cdiretoria AS string
	Data cemail AS string
	Data cendereco AS string
	Data cestado AS string
	Data cgerencia AS string
	Data cidvendedo AS string
	Data cnome AS string
	Data corganizac AS string
	Data cpais AS string
	Data csegmentac AS string
	Data csupervisa AS string
	Data ctelefone AS string
	Data ctelefonec AS string
	Data cusuario AS string
	Data isDelete AS string
	Data statusDCN AS string

	Data ORGANIZACAO AS string
	Data SEGMENTACAO AS string
	Data DIRETORIA AS string
	Data GERENCIA AS string
	Data SUPERVISAO AS string

	Method New()
	Method setVendedo()
EndClass




Method new( ) Class vendedor
	self:applicationArea	:= ApplicationArea():new()
return




Method setVendedo( ) Class vendedor
	self:ccep				:= allTrim(QRYSA3->A3_CEP)
	self:ccidade			:= allTrim(QRYSA3->A3_MUN)
	self:ncodvended			:= allTrim(QRYSA3->A3_COD)

	self:cemail				:= allTrim(QRYSA3->A3_EMAIL)
	self:cendereco			:= left(allTrim(QRYSA3->A3_END), 36)
	self:cestado			:= allTrim(QRYSA3->A3_EST)

	self:cidvendedo			:= allTrim(QRYSA3->A3_COD)
	self:cnome				:= allTrim(QRYSA3->A3_NOME)

	self:cpais				:= allTrim(QRYSA3->A3_PAIS)

	self:ctelefone		    := allTrim(QRYSA3->A3_DDDTEL+QRYSA3->A3_TEL)
	self:ctelefonec	    	:= allTrim(QRYSA3->A3_CEL)
	self:cusuario		    := allTrim(QRYSA3->A3_CODUSR)











	self:cdiretoria	:= allTrim(QRYSA3->ZBI_DIRETO)
	self:csegmentac	:= allTrim(QRYSA3->ZBI_NACION)
	self:cgerencia	:= allTrim(QRYSA3->ZBI_TATICA)
	self:corganizac	:= allTrim(QRYSA3->ZBI_REGION)
	self:csupervisa	:= allTrim(QRYSA3->ZBI_SUPERV)

	if QRYSA3->SA3DEL == "*"
		self:isDelete := "S"
		self:statusDCN		:= "D"
	else
		self:isDelete := "N"
		self:statusDCN		:= "U"
	endif
return




static function getZBI(cCodVend)
	local aRetZBI	:= { "", "", "", "", "" }
	local cQryZBI	:= ""

	cQryZBI	:= "SELECT *"
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"
	cQryZBI += " WHERE"
	cQryZBI += " 		ZBI.ZBI_REPRES	=	'" + cCodVend		+ "'"
	cQryZBI += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'"
	cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryZBI), "QRYZBI" , .F. , .T. )

	if !QRYZBI->(EOF())
		aRetZBI	:= { QRYZBI->ZBI_DIRETO, QRYZBI->ZBI_NACION, QRYZBI->ZBI_TATICA, QRYZBI->ZBI_REGION, QRYZBI->ZBI_SUPERV }
	endif

	QRYZBI->(DBCloseArea())
return aRetZBI
