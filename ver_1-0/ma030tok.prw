#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA030TOK
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada no final do cadastro de Cliente
=====================================================================================
*/

User Function MA030TOK
Local lRet := .T.           

IF findfunction("U_MGFFINB5") 
	lRet := U_MGFFINB5()
	If !lRet
	   Return lRet
	EndIf          
EndIF                  

IF findfunction("U_MGFINT38") 
	lRet := U_MGFINT38('SA1','A1')           
EndIF                  

// Executa funcao para definicao do Codigo/Loja
//Esta funcao devera ser executada por ultimo
If lRet .And. FindFunction("U_MGFINT46")
	lRet := U_MGFINT46(1) // 1 valida e 2 altera o codigo
Endif		


IF findfunction("U_MGFFIN65") 
		U_MGFFIN65()
EndIF

IF findfunction("U_MGFFIN67") 
		U_MGFFIN67()
EndIF

// validacao no campo endereco
If lRet
	If FindFunction("U_MGFFAT69")
		lRet := U_MGFFAT69()
	Endif
Endif

If lRet
	if findFunction("U_MGFFATA6")
		U_MGFFATA6()
	endif
endif

Return lRet