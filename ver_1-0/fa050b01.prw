#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA050B01
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descricao / Objetivo: O ponto de apos a confirmacao da Exclusao do CAP
Doc. Origem.........: Tipo de Valor
Solicitante.........: Cliente
Uso.................: 
Obs.................: Para a exclusao da tabela ZDS
=====================================================================================
*/
User Function FA050B01()
	
	If FindFunction("U_MGFFIN87")
		U_MGFFIN87(2)
	Endif	
	
Return .T.