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
//
/*/{Protheus.doc} eMGFWS18
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS18()

	runInteg18()

Return


User Function jMGFWC18(cFilJob)

	U_MGFWSC18({,"01",cFilJob})

Return

User Function MGFWSC18(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC18] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg18()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg18()
	local cURLPost		:= allTrim(getMv("MGF_SFA18"))
	local oWSSFA		:= nil
	private oNota		:= nil

	getSF2()

	while !QRYSF2->(EOF())
		oNota := nil
		oNota := nota():new()

		oNota:setNota()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oNota , QRYSF2->F2RECNO , "SF2" , "F2_XINTEGR" , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA18T")) )
		oWSSFA:lLogInCons := .T.
		oWSSFA:sendByHttpPost()




		QRYSF2->(DBSkip())
	enddo

	QRYSF2->(DBCloseArea())
return




static function getSF2()
	local cQrySF2 := ""

	cQrySF2 := "SELECT SF2.R_E_C_N_O_ F2RECNO, F2_DOC, F2_FILIAL, F2_EMISSAO, F2_TRANSP, F2_CLIENTE, F2_LOJA, F2_VALMERC, SF2.D_E_L_E_T_ F2DEL, MAX(D2_PEDIDO) PEDIDO"																		+ chr(13) + chr(10)
	cQrySF2 += " FROM "			+ retSQLName("SF2") + " SF2"							+ chr(13) + chr(10)
	cQrySF2 += " INNER JOIN "	+ retSQLName("SD2") + " SD2"							+ chr(13) + chr(10)
	cQrySF2 += " ON SD2.D2_FILIAL		=	'" + xFilial("SD2") + "' AND "						+ chr(13) + chr(10)
	cQrySF2 += " 	SD2.D_E_L_E_T_		=	SF2.D_E_L_E_T_ AND "						+ chr(13) + chr(10)
	cQrySF2 += " 	SD2.D2_DOC		=	SF2.F2_DOC AND "						+ chr(13) + chr(10)
	cQrySF2 += " 	SD2.D2_SERIE	=	SF2.F2_SERIE  "						+ chr(13) + chr(10)
	cQrySF2 += " WHERE"							+ chr(13) + chr(10)
	cQrySF2 += " 		SF2.F2_FILIAL		=	'" + xFilial("SF2") + "' AND "						+ chr(13) + chr(10)
	cQrySF2 += " 		SF2.F2_XSFA			=	'S'  AND "							+ chr(13) + chr(10)
	cQrySF2 += " 		SF2.F2_XINTEGR		=	'P' "							+ chr(13) + chr(10)
	cQrySF2 += " GROUP BY SF2.R_E_C_N_O_, F2_DOC, F2_FILIAL, F2_EMISSAO, F2_TRANSP, F2_CLIENTE, F2_LOJA, F2_VALMERC, SF2.D_E_L_E_T_ "							+ chr(13) + chr(10)
	cQrySF2 += " ORDER BY SF2.R_E_C_N_O_" 										+ chr(13) + chr(10)





	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySF2)), "QRYSF2" , .F. , .T. )
return




Class nota
	Data applicationArea AS ApplicationArea
	Data cnrnotafis AS string
	Data ccentrodis AS string
	Data cdatanf AS string
	Data ctransport AS string
	Data cidcliente AS string
	Data cnrpedido AS string
	Data nvalor AS float
	Data isDelete AS string
	Data statusDCN AS string

	Method New()
	Method setNota()
EndClass




Method new( ) Class nota
	self:applicationArea	:= ApplicationArea():new()
return




Method setNota( ) Class nota
	local aArea			:= getArea()
	local aAreaSA1		:= SA1->(getArea())

	self:cnrnotafis		:= alltrim(STR(VAL(QRYSF2->F2_DOC)))
	self:ccentrodis		:= allTrim(QRYSF2->F2_FILIAL)
	self:cdatanf 		:= Substr(fwTimeStamp(5, sToD(QRYSF2->F2_EMISSAO)),1,10)
	self:ctransport		:= allTrim(Padr(GetAdvFVal("SA4","A4_NOME",xFilial("SA4")+QRYSF2->F2_TRANSP,1,""),36))


	self:cidcliente		:= padR( QRYSF2->(F2_CLIENTE+F2_LOJA) , 15)

	self:cnrpedido		:= QRYSF2->PEDIDO
	self:nvalor			:= QRYSF2->F2_VALMERC

	if QRYSF2->F2DEL == "*"
		self:isDelete := "S"
		self:statusDCN	:= "D"
	else
		self:isDelete := "N"
		self:statusDCN	:= "U"
	endif

	restArea(aAreaSA1)
	restArea(aArea)
return
