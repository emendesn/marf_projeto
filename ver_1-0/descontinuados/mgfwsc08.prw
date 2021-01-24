#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
//
//
/*/{Protheus.doc} jMGFWS08
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cFilJob, characters, descricao
@type function
/*/
User Function jMGFWS08(cFilJob)

	U_MGFWSC08({,"01",cFilJob})

Return

User Function eMGFWS08()

	runInteg08()

Return

User Function MGFWSC08(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC08] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg08()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return




static function runInteg08()
	local cURLPost		:= allTrim(getMv("MGF_SFA08"))
	local oWSSFA		:= nil
	private oCenter		:= nil
	private aCD			:= {}
	private nI			:= 0

	getSM0()

	for nI := 1 to len(aCD)
		oCenter := nil
		oCenter := centerDis():new()

		oCenter:setCenter()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oCenter , , "", "", allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA08T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()



	next
return




static function getSM0()
	local aArea		:= getArea()
	local cQrySM0	:= "SELECT M0_CODFIL, M0_FILIAL, M0_CGC, D_E_L_E_T_ SMODEL FROM SYS_COMPANY WHERE M0_CODFIL IN (" + allTrim( getMv( "MGF_SFAFIL" ) ) + ")"

	conout("[MGFWSC08]" + cQrySM0)



	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySM0), "QRYSM0" , .F. , .T. )

	while !QRYSM0->(EOF())
		aadd(aCD, { QRYSM0->M0_CODFIL, QRYSM0->M0_FILIAL, QRYSM0->M0_CGC, QRYSM0->SMODEL })
		QRYSM0->(DBSkip())
	enddo

	QRYSM0->(DBCloseArea())

	restArea(aArea)
return




Class centerDis
	Data applicationArea AS ApplicationArea
	Data cIdCentro AS string
	Data cNome AS string
	Data cCNPJ AS string
	Data statusDCN AS string
	Data isDelete AS string

	Method New()
	Method setCenter()
EndClass




Method new( ) Class centerDis
	self:applicationArea	:= ApplicationArea():new()
return




Method setCenter( ) Class centerDis
	self:cIdCentro			:= alltrim(aCD[nI, 1])
	self:cNome				:= alltrim(aCD[nI, 2])
	self:cCNPJ				:= alltrim(aCD[nI, 3])
	self:statusDCN			:= "U"

	if alltrim( aCD[ nI, 4 ] ) == "*"
		self:isDelete	:= "S"
		self:statusDCN	:= "D"
	else
		self:isDelete	:= "N"
		self:statusDCN	:= "U"
	endif

return
