#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/{Protheus.doc} MTA010OK
Integração Protheus-ME, Validações do usuário para exclusão do produto
@type function
@author Anderson Reis
@since 26/02/2020
@version P12
@history Alteração 19/03 - Mudança da regra de Produtos 
/*/


User Function MTA010OK()
Local lRet:= .T.
// Validações do usuário para exclusão do produto

// Tratamento Mercado Eletronico 

If ! SB1->B1_MGFFAM .AND.  SB1->B1_COD >= '500000' .AND. SB1->B1_ZPEDME = 'S' 
	
	Reclock("SB1",.F.)

		SB1->B1_ZPEDME := "D"
 
	Msunlock()

Endif


Return (lRet)