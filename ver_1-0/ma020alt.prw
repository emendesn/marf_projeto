#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA020ALT
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Fornecedores
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Fornecedores
=====================================================================================
*/
User Function MA020ALT

Local lRet := .T.

If FindFunction("U_TAC01VldMnt")
	lRet := U_TAC01VldMnt({SA2->A2_COD,SA2->A2_LOJA})
Endif

If lRet
	IF findfunction("U_MGFINT38") 
		lRet := U_MGFINT38('SA2','A2')           
	EndIF
Endif

Return(lRet)