#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120BTR
Autor...............: Joni Lima
Data................: 06/11/2016
Descrição / Objetivo: Ponto de entrada utilizado para incluir botões na enchoice do rateio por centro de custo na rotina de pedido de compra.
					  Deve ser utilizado incluindo um elemento no array para cada botão novo, com a mesma estrutura do array recebido.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085818
=====================================================================================
*/
User Function MT120BTR()

	Local aRet := PARAMIXB[1]                             
	
	If Findfunction('U_xMF120BTR')
		aRet := U_xMF120BTR(aRet)
	EndIf
	
Return aRet