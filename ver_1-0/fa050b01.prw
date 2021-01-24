#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA050B01
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descri��o / Objetivo: O ponto de ap�s a confirma��o da Exclus�o do CAP
Doc. Origem.........: Tipo de Valor
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Para a exclus�o da tabela ZDS
=====================================================================================
*/
User Function FA050B01()
	
	If FindFunction("U_MGFFIN87")
		U_MGFFIN87(2)
	Endif	
	
Return .T.