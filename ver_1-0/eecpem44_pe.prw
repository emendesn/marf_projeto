#include "protheus.ch"

/*
==========================================================================================
Programa.:              EECPEM44
Autor....:              Totvs
Data.....:              Jun/2018
Descricao / Objetivo:   Ponto de entrada no linha ok do Pedido de Exportacao 
Pedido Exportacao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
==========================================================================================
*/
User Function EECPEM44()
Local lRet := .T.

// valida a confirmacao do pedido de exportacao
If FindFunction("U_MGFEEC52")
	lRet := U_MGFEEC52()
Endif	

// Verifica se eh possivel realizar a copia do pedido
If lRet // 13/07/18 SERA HABILITADO APOS VALIDACAO DO CLIENTE
	If FindFunction("U_MGFEEC54")
		lRet := U_MGFEEC54()
	Endif	
Endif	

Return(lRet)