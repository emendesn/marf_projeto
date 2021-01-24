#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              MGFGCT07
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Execucao do P.E. para permitir execucao da rotina 'MsDocument"
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFGCT07(aRet)

	AADD( aRet, { "ZZ3", { "ZZ3_COD"}, { || xFilial("ZZ3") + ZZ3->ZZ3_COD+ZZ3_LOJA} } )
	
Return aRet