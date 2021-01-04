#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CT030GRE
Integração Protheus-ME, para envio do Cadastro de Centro de Custo (Deletados)
CTT_ZPEDME = "D"
@type function
@author Anderson Reis
@since 18/07/2019
@version P12
/*/

User function CT030GRE()

		Reclock("CTT",.F.)
			
			CTT->CTT_ZPEDME := "D" // Deletado
	
		Msunlock()

Return 

