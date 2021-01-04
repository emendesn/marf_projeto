#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT110VLD
Autor...............: Joni Lima
Data................: 11/04/2017
Descrição / Objetivo: Localizado na Solicitação de Compras, este ponto de entrada é responsável em validar o registro posicionado da Solicitação de Compras antes de executar as operações de inclusão, alteração, exclusão e cópia. Se retornar .T., deve executar as operações de inclusão, alteração, exclusão e cópia ou .F. para interromper o processo.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085449
=====================================================================================
*/
User Function MT110VLD()
	
	Local lRet := .T.
	Local nOpx := PARAMIXB[1] //3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusão.
	Local nOpexc := PARAMIXB[1] //3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusão.

	If FindFunction("U_MGFC8SC") .and. nOpx == 4
		lRet := U_MGFC8SC()
		If !lRet
			If !IsBlind()
				Alert("Não é possível alterar, pois a SC tem itens em andamento.")
			Else
				Conout("Não é possível alterar, pois a SC tem itens em andamento.")
			EndIf
		EndIf
	Endif

	If lRet .and. FindFunction("U_MC8M110TEL")
		U_MC8M110TEL( nil, nil, nOpx, nil, nil, nil)
	Endif
	                                     
    IF nOpexc
       If SC1->C1_ZCANCEL=='S'
				Alert("Não é possível excluir uma SC cancelada pelo usuario.")
    	lRet := .F.
       endif
    ENDIF

	//If FindFunction("U_MGF99GRV") .and. nOpx == 3
	//	lRet := U_MGF99GRV()
	//Endif

	If FindFunction("U_MGFEST56") .and. (nOpx == 4 .OR. nOpx == 6) 
		lRet := U_MGFEST56()
	Endif


	
Return lRet