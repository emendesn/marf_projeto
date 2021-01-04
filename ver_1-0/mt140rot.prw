#Include "Protheus.ch"

/*
================================================================================================
Programa............: MT140ROT
Autor...............: Mauricio Gresele        
Data................: 17/05/2017 
Descricao / Objetivo: Ponto de entrada para incluir rotina no acoes relacionadas da pre-nota de entrada
Doc. Origem.........: FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=================================================================================================
*/
User Function MT140ROT()
	
Local aBotao := {}

If Findfunction("U_ImpRelAR")
	aBotao := U_ImpRelAR()
Endif

Return(aBotao) 