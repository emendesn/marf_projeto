#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"


/*/{Protheus.doc} MGFFIN76
//TODO Valida o tipo de conta que esta no cadastro de fornecedores do banco tabela FIL.
@author Eugenio Arcanjo.
@since 19/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function MGFFIN76()
	Local aArea		:= getArea()
	Local cQryFil	:= ""
	Local cTpFil	:= ""

	cQryFil := "SELECT *"
	cQryFil += " FROM " + retSQLName("FIL") + " FIL"
	cQryFil += " WHERE"

	if !empty( M->E2_ZCODFAV )
		cQryFil += "		FIL.FIL_DVCTA	=	'" + M->E2_ZDVCFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_CONTA	=	'" + M->E2_ZCTAFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_DVAGE	=	'" + M->E2_ZDVAFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_AGENCI	=	'" + M->E2_ZAGEFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_BANCO	=	'" + M->E2_ZBCOFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_LOJA	=	'" + M->E2_ZLOJFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_FORNEC	=	'" + M->E2_ZCODFAV	+ "'"
		cQryFil += "	AND	FIL.FIL_FILIAL	=	'" + xFilial("FIL") + "'"
		cQryFil += "	AND	FIL.D_E_L_E_T_	<>	'*'"	
	else
		cQryFil += "		FIL.FIL_DVCTA	=	'" + SE2->E2_FCTADV		+ "'"
		cQryFil += "	AND	FIL.FIL_CONTA	=	'" + SE2->E2_FORCTA		+ "'"
		cQryFil += "	AND	FIL.FIL_DVAGE	=	'" + SE2->E2_FAGEDV		+ "'"
		cQryFil += "	AND	FIL.FIL_AGENCI	=	'" + SE2->E2_FORAGE		+ "'"
		cQryFil += "	AND	FIL.FIL_BANCO	=	'" + SE2->E2_FORBCO		+ "'"
		cQryFil += "	AND	FIL.FIL_LOJA	=	'" + SE2->E2_LOJA		+ "'"
		cQryFil += "	AND	FIL.FIL_FORNEC	=	'" + SE2->E2_FORNECE	+ "'"
		cQryFil += "	AND	FIL.FIL_FILIAL	=	'" + xFilial("FIL") 	+ "'"
		cQryFil += "	AND	FIL.D_E_L_E_T_	<>	'*'"
	endif

	TcQuery cQryFil New Alias "QRYFIL"

	if !QRYFIL->(EOF())
		if QRYFIL->FIL_TIPCTA == '1' // 1=Conta Corrente;2=Conta Poupanca;
			cTpFil := '01' // 01 - Conta Corrente
		elseif QRYFIL->FIL_TIPCTA == '2'
			cTpFil := '11' // 11 - Conta Poupanca
		endif
	endif

	QRYFIL->(DBCloseArea())

	DbSelectArea("SE2")
	SE2->(DbSetOrder(6))//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->(DbSeek(xFilial("SE2") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM ))
		Reclock("SE2",.F.)
		SE2->E2_XFINALI	:=	cTpFil
		SE2->(MsUnlock())
	EndIf
		
	restArea(aArea)

return

