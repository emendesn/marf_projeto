#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MA125BUT
Autor...............: Gresele
Data................: Nov/2017
Descricao / Objetivo: Ponto de entrada utilizado para adicionar botoes na tela de manutencao do Contrato de parceria
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MA125BUT()

Local aButtons := {}

If FindFunction("U_MGFCOM56")
	aButtons := U_MGFCOM56()
Endif

Return(aButtons)