#include "protheus.ch"

/*
=====================================================================================
Programa............: MA020TDOK
Autor...............: Mauricio Gresele
Data................: 29/11/2016 
Descricao / Objetivo: Ponto de entrada na validacao do Fornecedor
Doc. Origem.........: Protheus-Taura Cadastro
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MA020TDOK()

Local lRet := .T.
                            
// valida campos para integracao do Taura
If FindFunction("U_TAC01MA020TDOK")
	lRet := U_TAC01MA020TDOK()
Endif		

If lRet .And. FindFunction("U_INT39_EMAIL")
	lRet := U_INT39_EMAIL()
Endif		

// Executa funcao para definicao do Codigo/Loja
//Esta funcao devera ser executada por ultimo
If lRet .And. FindFunction("U_MGFINT45")
	lRet := U_MGFINT45()
Endif		



Return(lRet)