#Include 'Protheus.ch'

/*/{Protheus.doc} MS520DEL
//TODO Descrição Ponto de entrada na exclusão do documento de saida
@author marcelo.moraes
@since 23/04/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MS520DEL()

//Atualiza SZ5 na exclusão do documento de saida (triangulação faturamento)
If FindFunction("u_MGFFAT75")
	u_MGFFAT75()
Endif

If FindFunction("U_MGFFINA2")
	//Verifica se é uma devolução de compras
	If SF2->F2_TIPO = 'D'
		U_MGFFINA2(2) //// 1 - Inclusão; 2 - Exclusão
	EndIf
Endif

//Int. Salesfore - Atualizar flag do titulos ao realizar a esclusão da nota de saída
If FindFunction("u_MGFFINX6")
	u_MGFFINX6()
Endif

Return Nil