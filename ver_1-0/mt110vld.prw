#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT110VLD
Autor...............: Joni Lima
Data................: 11/04/2017
Descri��o / Objetivo: Localizado na Solicita��o de Compras, este ponto de entrada � respons�vel em validar o registro posicionado da Solicita��o de Compras antes de executar as opera��es de inclus�o, altera��o, exclus�o e c�pia. Se retornar .T., deve executar as opera��es de inclus�o, altera��o, exclus�o e c�pia ou .F. para interromper o processo.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085449
=====================================================================================
*/
User Function MT110VLD()
	
	Local lRet := .T.
	Local nOpx := PARAMIXB[1] //3- Inclus�o, 4- Altera��o, 8- Copia, 6- Exclus�o.
	Local nOpexc := PARAMIXB[1] //3- Inclus�o, 4- Altera��o, 8- Copia, 6- Exclus�o.

	If FindFunction("U_MGFC8SC") .and. nOpx == 4
		lRet := U_MGFC8SC()
		If !lRet
			If !IsBlind()
				Alert("N�o � poss�vel alterar, pois a SC tem itens em andamento.")
			Else
				Conout("N�o � poss�vel alterar, pois a SC tem itens em andamento.")
			EndIf
		EndIf
	Endif

	If lRet .and. FindFunction("U_MC8M110TEL")
		U_MC8M110TEL( nil, nil, nOpx, nil, nil, nil)
	Endif
	                                     
    IF nOpexc
       If SC1->C1_ZCANCEL=='S'
				Alert("N�o � poss�vel excluir uma SC cancelada pelo usuario.")
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