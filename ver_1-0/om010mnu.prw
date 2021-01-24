#Include "Protheus.ch"

/*
================================================================================================
Programa............: OM010MNU
Autor...............: Marcos Andrade         
Data................: 14/09/2016 
Descricao / Objetivo: Ponto de entrada para incluir rotina no acoes relacionadas Tabela de Preço
Doc. Origem.........: FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=================================================================================================
*/

User Function OM010MNU()

	//Inclui opcao dados adicionais na tabela de preco

	If findfunction("u_FAT04Menu")
		u_FAT04Menu()
	Endif

	If findfunction("u_MNUFAT94")
		u_MNUFAT94()
	Endif

Return()             
