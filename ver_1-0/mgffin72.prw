#Include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MGFFIN72
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFIN72()
	local aArea		:= getArea()
	local cQryFil	:= ""
	local cTpFil	:= ""

	IF !isInCallStack("JURA098") .AND. !isInCallStack("JURA099")
		cQryFil := "SELECT *"
		cQryFil += " FROM " + retSQLName("FIL") + " FIL"
		cQryFil += " WHERE"
		cQryFil += "		FIL.FIL_DVCTA	=	'" + M->E2_FCTADV	+ "'"
		cQryFil += "	AND	FIL.FIL_CONTA	=	'" + M->E2_FORCTA	+ "'"
		cQryFil += "	AND	FIL.FIL_DVAGE	=	'" + M->E2_FAGEDV	+ "'"
		cQryFil += "	AND	FIL.FIL_AGENCI	=	'" + M->E2_FORAGE	+ "'"
		cQryFil += "	AND	FIL.FIL_BANCO	=	'" + M->E2_FORBCO	+ "'"
		cQryFil += "	AND	FIL.FIL_LOJA	=	'" + M->E2_LOJA		+ "'"
		cQryFil += "	AND	FIL.FIL_FORNEC	=	'" + M->E2_FORNECE	+ "'"
		cQryFil += "	AND	FIL.FIL_FILIAL	=	'" + xFilial("FIL") + "'"
		cQryFil += "	AND	FIL.D_E_L_E_T_	<>	'*'"

		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryFil), "QRYFIL" , .F. , .T. )

		if !QRYFIL->(EOF())
			if QRYFIL->FIL_TIPCTA == "1"
				cTpFil := "01"
			elseif QRYFIL->FIL_TIPCTA == "2"
				cTpFil := "11"
			endif
		endif

		QRYFIL->(DBCloseArea())
    Endif
	restArea(aArea)

return cTpFil

User Function MGFFIN79()
	local aArea		:= getArea()
	local cQryFil	:= ""
	local cTpFil	:= ""

	if !empty( M->E2_ZCODFAV )
		cQryFil := "SELECT *"
		cQryFil += " FROM " + retSQLName("FIL") + " FIL"
		cQryFil += " WHERE"
		cQryFil += "		FIL.FIL_DVCTA	=	'" + M->E2_ZDVCFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_CONTA	=	'" + M->E2_ZCTAFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_DVAGE	=	'" + M->E2_ZDVAFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_AGENCI	=	'" + M->E2_ZAGEFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_BANCO	=	'" + M->E2_ZBCOFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_LOJA	=	'" + M->E2_ZLOJFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_FORNEC	=	'" + M->E2_ZCODFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_FILIAL	=	'" + xFilial("FIL") + "'"
		cQryFil += "	AND	FIL.D_E_L_E_T_	<>	'*'"

		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryFil), "QRYFIL" , .F. , .T. )

		if !QRYFIL->(EOF())
			if QRYFIL->FIL_TIPCTA == "1"
				cTpFil := "01"
			elseif QRYFIL->FIL_TIPCTA == "2"
				cTpFil := "11"
			endif
		endif

		QRYFIL->(DBCloseArea())
	else
		cTpFil := U_MGFFIN72()
	endif

	restArea(aArea)
return cTpFil
