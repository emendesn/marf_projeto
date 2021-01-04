#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFINCRE29
Autor....:              Flavio Dentello
Data.....:              07/11/2016
Descricao / Objetivo:   AO REALIZAR A BAIXAR DO T�TULO, GRAVAR NO CAMPO E5_HISTOR O;
						NOME DO BANCO SELECIONADO 
Doc. Origem:            GAP FIN_CRE003_V2
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/

User Function SACI008()

If FindFunction ("U_MGFFINX3")
	U_MGFFINX3()
EndIf

If FindFunction("U_xCRE2903")
	U_xCRE2903()
Endif

If FindFunction("U_xMGFFIN50") .And. !cModulo$'EEC/EDC/EIC/ESS'
	U_xMGFFIN50()
Endif

If FindFunction("U_MGFFINB9")
	U_MGFFINB9()
Endif

Return