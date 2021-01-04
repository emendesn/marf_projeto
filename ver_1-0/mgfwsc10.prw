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
/*/{Protheus.doc} jMGFWC10
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWC10(cFilJob)

	U_MGFWSC10({,"01",cFilJob})

Return
User Function eMGFWS10()

	runInteg10()

Return


User Function MGFWSC10(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC10] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg10()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg10()
	local cURLPost		:= allTrim(getMv("MGF_SFA10"))
	local oWSSFA		:= nil
	local aSX3Box		:= {}
	private oConserv	:= nil









	aSX3Box := retSx3Box(posicione("SX3", 2, "B1_ZCONSER", "X3_CBOX"), , , 1)

	if len(aSX3Box) > 0
		for nI := 1 to len(aSX3Box)
			if !empty( aSX3Box[ nI, 2 ] )
				oConserv := nil
				oConserv := conserv():new()

				oConserv:idEstrutur := aSX3Box[ nI, 2 ]
				oConserv:nome		:= aSX3Box[ nI, 3 ]

				oConserv:isDelete	:= "N"
				oConserv:statusdcn	:= "U"

				oWSSFA := nil
				oWSSFA := MGFINT23():new(cURLPost, oConserv , , , , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA08T")))
				oWSSFA:lLogInCons := .T.
				oWSSFA:sendByHttpPost()



			endif
		next

	endif





















return




static function getConserv()
	local cQRYZZW := ""

	cQryZZW := "SELECT ZZW.*, ZZW.D_E_L_E_T_ ZZWDEL , ZZW.R_E_C_N_O_ ZZWREC"												+ chr(13) + chr(10)
	cQryZZW += " FROM "			+ retSQLName("ZZW") + " ZZW" + chr(13) + chr(10)
	cQryZZW += " WHERE" + chr(13) + chr(10)
	cQryZZW += " 		ZZW.ZZW_XINTEG	=	'P'"
	cQryZZW += " 	AND	ZZW.ZZW_XSFA	=	'S'"
	cQryZZW += " 	AND	ZZW.ZZW_FILIAL	=	'" + xFilial("ZZW") + "'" + chr(13) + chr(10)

	cQryZZW += " ORDER BY ZZW.R_E_C_N_O_" 										+ chr(13) + chr(10)

	conout( cQryZZW )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQryZZW)), "QRYZZW" , .F. , .T. )
return




Class conserv
	Data applicationArea AS ApplicationArea
	Data idEstrutur AS string
	Data nome AS string
	Data statusDCN AS string
	Data isDelete AS string

	Method New()
	Method setConserv()
EndClass




Method new( ) Class conserv
	self:applicationArea	:= ApplicationArea():new()
return




Method setConserv( ) Class conserv
	self:idEstrutur := QRYZZW->ZZW_CODIGO
	self:nome		:= QRYZZW->ZZW_DESCRI

	if QRYZZW->ZZWDEL == "*"
		self:isDelete := "S"
		self:statusdcn					:= "D"
	else
		self:isDelete := "N"
		self:statusdcn					:= "U"
	endif
return
