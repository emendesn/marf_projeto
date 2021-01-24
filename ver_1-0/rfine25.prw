#Include "RwMake.ch"

/*/{Protheus.doc} Rfine25
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Rfine25()








	SetPrvt("_TTABAT,")




















	_TtAbat := 0.00
	_Valor  := 0.00
	
	

	_TtAbat  := somaabat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA)

	_Valor   := (SE1->E1_VALOR - _TtAbat)

Return(_Valor)
