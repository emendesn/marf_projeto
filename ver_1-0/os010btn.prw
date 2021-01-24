#Include "Protheus.ch"

/*
================================================================================================
Programa............: OS010BTN
Autor...............: Fl�vio Dentello        
Data................: 21/02/2016 
Descricao / Objetivo: Ponto de entrada para incluir rotina no acoes relacionadas na inclus�o e altera��o da Tabela de Pre�o
Doc. Origem.........: FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=================================================================================================
*/

User Function OS010BTN()
	Local aBotao := {}

	If Findfunction("U_FAT04Menu")
		aBotao := U_FAT04Menu()
	Endif
Return aBotao 

