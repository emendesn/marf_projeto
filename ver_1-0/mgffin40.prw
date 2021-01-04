#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN40
Autor...............: Barbieri
Data................: 30/11/2016
Descricao / Objetivo: Validacao para o fornecedor funcion�rio utilizado no caixinha 
Doc. Origem.........: Contrato - GAP TS001
Solicitante.........: Cliente
Uso.................: 
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
				MSGALERT("Fornecedor nao � funcion�rio!","Atencao")
				lRet := .F.
			EndIf
		Else
			MSGALERT("Fornecedor nao cadastrado.","Atencao")
			lRet := .F.
		EndIf
	EndIf

	RestArea(aAreaSA2)
	RestArea(aArea)

Return lRet
