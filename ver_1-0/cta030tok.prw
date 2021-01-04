#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CTA030TOK
Integração Protheus-ME, para envio do Cadastro de Centro de Custo (Alteraçao)
CTT_ZPEDME = "A"
@type function
@author Anderson Reis
@since 18/07/2019
@version P12
/*/


User function CTA030TOK()

If CTT->CTT_BLOQ <> '1'

	Reclock("CTT",.f.)
		CTT->CTT_ZPEDME := 'A'

		Msunlock()

Endif
	
	
Return .F.