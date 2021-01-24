#include "protheus.ch"

/*
=====================================================================================
Programa............: M020ALT
Autor...............: Adriano Tazava
Data................: 20/10/2016 
Descricao / Objetivo: Ponto de entrada apos a alteração do fornecedor
Doc. Origem.........: Fiscal-FIS13
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M020ALT()

// Atualiza  tabela Clientes / Transportadora pelo CGC.
If FindFunction("U_MGFINT48")
	U_MGFINT48(4)
Endif

// Tratamento Mercado Eletronico  A2_ZPEDME (Foi para o ME) A2_ZINTME (Marcado para ir ao ME )
//
If SA2->A2_ZPEDME <> ' ' .AND. SA2->A2_ZINTME = 'S' 

	Reclock("SA2",.F.)

		SA2->A2_ZPEDME := "A"
 
	Msunlock()

Endif



Return()
