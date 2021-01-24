#Include 'Protheus.ch'

/*/{Protheus.doc} MS520DEL
//TODO Descri��o Ponto de entrada na exclus�o do documento de saida
@author marcelo.moraes
@since 23/04/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MS520DEL()

//Atualiza SZ5 na exclus�o do documento de saida (triangula��o faturamento)
If FindFunction("u_MGFFAT75")
	u_MGFFAT75()
Endif

If FindFunction("U_MGFFINA2")
	//Verifica se � uma devolu��o de compras
	If SF2->F2_TIPO = 'D'
		U_MGFFINA2(2) //// 1 - Inclus�o; 2 - Exclus�o
	EndIf
Endif

//Int. Salesfore - Atualizar flag do titulos ao realizar a esclus�o da nota de sa�da
If FindFunction("u_MGFFINX6")
	u_MGFFINX6()
Endif

Return Nil