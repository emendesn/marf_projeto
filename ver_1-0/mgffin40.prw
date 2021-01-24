#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN40
Autor...............: Barbieri
Data................: 30/11/2016
Descrição / Objetivo: Validação para o fornecedor funcionário utilizado no caixinha 
Doc. Origem.........: Contrato - GAP TS001
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN40()

	Local aArea		:= GetArea()
	Local aAreaSA2  := SA2->(GetArea())

	Local lRet := .T.

	If !Empty(M->EU_ZCODF) .and. !Empty(M->EU_ZLOJF)
		dbSelectArea('SA2')
		dbSetOrder(1)//A2_FILIAl + A2_COD + A2_LOJA

		If SA2->(dbSeek(xFilial('SA2') + M->EU_ZCODF + M->EU_ZLOJF))
			If (SA2->A2_ZTPRHE) == "F"
				lRet := .T.
			Else
				MSGALERT("Fornecedor não é funcionário!","Atenção")
				lRet := .F.
			EndIf
		Else
			MSGALERT("Fornecedor não cadastrado.","Atenção")
			lRet := .F.
		EndIf
	EndIf

	RestArea(aAreaSA2)
	RestArea(aArea)

Return lRet
