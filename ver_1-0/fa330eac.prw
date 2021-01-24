#include "protheus.ch"
/*
=====================================================================================
Programa.:              FA330EAC 
Autor....:              Totvs
Data.....:              31/01/2020
Descricao / Objetivo:   O ponto � utilizado na exclus�o/estorno de compensa��o de contas a receber, antes da contabiliza��o.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              TDN - https://tdn.totvs.com/pages/releaseview.action?pageId=6071207
=====================================================================================
*/

User Function FA330EAC()

    If FindFunction("U_MGFFINX5")
        U_MGFFINX5()
    Endif	

Return 