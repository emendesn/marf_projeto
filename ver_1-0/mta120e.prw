#Include 'Protheus.ch'
/*
=====================================================================================
Programa............: MTA120E
Autor...............: Joni Lima
Data................: 06/01/2016
Descri��o / Objetivo:  Ap�s a montagem da dialog do pedido de compras. � acionado quando o usu�rio clicar nos bot�es OK (Ctrl O) ou CANCELAR (Ctrl X) na exclus�o de um PC ou AE. Deve ser utilizado para validar se o PC ou AE ser� exclu�do ('retorno .T.') ou n�o ('retorno .F.') , ap�s a confirma��o do sistema.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085570
=====================================================================================
*/
User Function MTA120E()
	
	Local nOpx 		:= PARAMIXB[1]
	Local cNumPc	:= PARAMIXB[2]

	If FindFunction("U_xMC8120E")	
		U_xMC8120E(cNumPc)
	EndIf
	
Return .T.

