#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: F050BUT
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descri��o / Objetivo: O ponto de entrada para criar um bot�o na chamada na altera��o
Doc. Origem.........: Tipo de Valor - CAP
Solicitante.........: Cliente
Uso.................: Marfrig
=====================================================================================
*/
User Function F050BUT           	                    
Local aButton := {}

IF !INCLUI
	aAdd( aButton, { "MGFFIN88", { || U_MGFFIN88(.T.)}, "Tipo de Valor"} )  
EndIF

Return aButton                                        

