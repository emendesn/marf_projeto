#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/{Protheus.doc} MTA010OK
Integra��o Protheus-ME, Valida��es do usu�rio para exclus�o do produto
@type function
@author Anderson Reis
@since 26/02/2020
@version P12
@history Altera��o 19/03 - Mudan�a da regra de Produtos 
/*/


User Function MTA010OK()
Local lRet:= .T.
// Valida��es do usu�rio para exclus�o do produto

// Tratamento Mercado Eletronico 

If ! SB1->B1_MGFFAM .AND.  SB1->B1_COD >= '500000' .AND. SB1->B1_ZPEDME = 'S' 
	
	Reclock("SB1",.F.)

		SB1->B1_ZPEDME := "D"
 
	Msunlock()

Endif


Return (lRet)