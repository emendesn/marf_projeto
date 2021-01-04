#Include "Protheus.ch"

/*
================================================================================================
Programa............: OS010BTN
Autor...............: Flavio Dentello        
Data................: 21/02/2016 
Descricao / Objetivo: Ponto de entrada para incluir rotina no acoes relacionadas na inclusao e alteracao da Tabela de Preco
Doc. Origem.........: FAT01
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=================================================================================================
*/

User Function OS010BTN()
	Local aBotao := {}

	If Findfunction("U_FAT04Menu")
		aBotao := U_FAT04Menu()
	Endif
Return aBotao 

