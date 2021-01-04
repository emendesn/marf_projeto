#include "protheus.ch"

/*
=====================================================================================
Programa............: M020EXC
Autor...............: Mauricio Gresele
Data................: 20/10/2016 
Descricao / Objetivo: Ponto de entrada apos a exclusao do fornecedor
Doc. Origem.........: Fiscal-FIS13
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================

@alteracoes 17/10/2019 - Henrique Vidal
	Alterada chamada da funcao MGFCOM88 
    RTASK0010137 - Apaga fornecedores vinculados da grade de aprovacao, apos exclusao do cadastro.
*/
User Function M020EXC()

// exclui tabela de amarracao de fornecedor x serie NFE talonario
If FindFunction("U_Fis03Grava")
	U_Fis03Grava(SA2->A2_COD,SA2->A2_LOJA,.T.)
Endif

// envia fornecedor para Taura
If FindFunction("U_TAC01M020EXC")
	U_TAC01M020EXC()
Endif		

If FindFunction("U_MGFCOM88") 
	U_MGFCOM88('SA2')
Endif	

If SA2->A2_ZPEDME <> ' ' .AND. SA2->A2_ZINTME = 'S' 
	Reclock("SA2",.F.)

		SA2->A2_ZPEDME := "D"
 
		Msunlock()
endif


Return()
