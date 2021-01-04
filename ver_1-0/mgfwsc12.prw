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
//
/*/{Protheus.doc} jMGFWC12
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWC12(cFilJob)

	U_MGFWSC12({,"01",cFilJob})

Return

User Function eMGFWS12()

	runInteg12()

Return

User Function MGFWSC12(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC12] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg12()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg12()
	local cURLPost		:= allTrim(getMv("MGF_SFA12"))
	local oWSSFA		:= nil
	private oSource		:= nil

	getBrand()

	while !QRYSZ5S0->(EOF())
		oSource := nil
		oSource := source():new()

		oSource:setSource()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oSource , , , , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA08T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSZ5S0->(DBSkip())
	enddo

	QRYSZ5S0->(DBCloseArea())
return




static function getBrand()
	local cQrySX5S0 := ""

	cQrySX5S0 := "SELECT *"												+ chr(13) + chr(10)
	cQrySX5S0 += " FROM "+ retSQLName("SX5") + " SX5"					+ chr(13) + chr(10)
	cQrySX5S0 += " WHERE" 												+ chr(13) + chr(10)
	cQrySX5S0 += " 		SX5.X5_TABELA	=	'S0'"						+ chr(13) + chr(10)
	cQrySX5S0 += " 	AND	SX5.X5_FILIAL	=	'" + xFilial("SX5") + "'"	+ chr(13) + chr(10)


	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySX5S0)), "QRYSZ5S0" , .F. , .T. )
return




Class source
	Data applicationArea AS ApplicationArea
	Data idEstrutur AS string
	Data nome AS string
	Data statusDCN AS string
	Data isDelete AS string

	Method New()
	Method setSource()
EndClass




Method new( ) Class source
	self:applicationArea	:= ApplicationArea():new()
return




Method setSource( ) Class source
	self:idEstrutur := allTrim(QRYSZ5S0->X5_CHAVE)
	self:nome		:= allTrim(QRYSZ5S0->X5_DESCRI)
	self:statusDCN	:= "U"
return
