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
/*/{Protheus.doc} eMGFWS17
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS17()

	StartJob( "U_MGFWSC17", GetEnvServer(), .T. , {"01", "010001"} )

Return
User Function MGFWSC17(cEmpX,cFilX)

	If (.F. );CallProc( "RpcSetEnv", cEmpX, cFilX,,,,, { } ); Else; RpcSetEnv( cEmpX, cFilX,,,,, { } ); endif
	runInteg17()
	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg17()
	local cURLPost		:= allTrim(getMv("MGF_SFA17"))
	local oWSSFA		:= nil
	private oMeta		:= nil

	getSA3()

	while !QRYSA3->(EOF())
		oMeta := nil
		oMeta := meta():new()

		oMeta:setMeta()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oVendedor , QRYSA3->A3RECNO , "SA3" , "A3_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA16T")) )
		oWSSFA:sendByHttpPost()

		QRYSA3->(DBSkip())
	enddo

	QRYSA3->(DBCloseArea())
return




static function getSA3()
	local cQrySA3 := ""

	cQrySA3 := "SELECT *"																		+ chr(13) + chr(10)
	cQrySA3 += " FROM "			+ retSQLName("SA3") + " SA3"							+ chr(13) + chr(10)
	cQrySA3 += " WHERE"							+ chr(13) + chr(10)
	cQrySA3 += " 		SA3.A3_XINTEGR	=	'P'"										+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.A3_XSFA		=	'S'"						+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.A3_FILIAL		=	'" + xFilial("SA3") + "'"							+ chr(13) + chr(10)
	cQrySA3 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"							+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySA3)), "QRYSA3" , .F. , .T. )
return




Class meta
	Data applicationArea AS ApplicationArea
	Data idvendedor AS string
	Data mes AS string
	Data ano AS string
	Data standard AS string
	Data especial AS string
	Data sku AS string
	Data positivacao AS string
	Data prazomedio AS string
	Data isDelete AS string

	Method New()
	Method setMeta()
EndClass




Method new( ) Class Meta
	self:applicationArea	:= ApplicationArea():new()
return




Method setMeta( ) Class Meta
	self:idvendedor		:= ""
	self:mes			:= ""
	self:ano			:= ""
	self:standard		:= ""
	self:especial		:= ""
	self:sku			:= ""
	self:positivacao	:= ""
	self:prazomedio		:= ""
	self:isDelet		:= ""
return
