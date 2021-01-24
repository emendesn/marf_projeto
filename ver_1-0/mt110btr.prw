#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT110BTR
Autor...............: Joni Lima
Data................: 06/11/2016
Descrição / Objetivo: Adiciona botões na Enchoice do rateio - Solicitação de Compras
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=185751191
=====================================================================================
*/
User Function MT110BTR()
	
	Local aRet := PARAMIXB[1]
	
	If Findfunction('U_xMF110BTR')
		aRet := U_xMF110BTR(aRet)
	EndIf
	
RETURN aRet