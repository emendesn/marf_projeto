#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: CTBGRV
Autor...............: Marcelo Carneiro
Data................: 13/03/2018
Descri��o / Objetivo: O ponto de entrada CTBGRV Para alterar o campo CT2_DTCV3 para os la�amento de tipo de Valor
Doc. Origem.........: Tipo de Valor
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/mp/ANCTB102GR+-+Tratativa+do+temporario+--+10926
=====================================================================================
*/
User Function CTBGRV()
	
	Local nOpc		:= 	PARAMIXB[1]
	Local cProg     := 	PARAMIXB[2]	
	
	If FindFunction("U_MGFFIN87")
		U_MGFFIN87(3,nOpc)
	Endif	
	
Return