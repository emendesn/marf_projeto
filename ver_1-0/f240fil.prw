#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              F240FIL
Autor....:              Luis Artuso
Data.....:              20/09/2016
Descricao / Objetivo:   Chamada do P.E. F240FIL - permitir filtro por tipo de titulo, na geracao do bordero
Doc. Origem:            Contrato - GAP MGFFIN05
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function F240FIL
Local _aAreaatu   := GetArea() 
Local cFiltro := ""

If findfunction("U_MGFFIN05")
	cFiltro := U_MGFFIN05()
Endif
Restarea(_aAreaatu)
return cFiltro