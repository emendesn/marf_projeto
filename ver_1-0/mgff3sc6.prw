#Include "Protheus.ch"

/*/{Protheus.doc} MGFF3SC6
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFF3SC6()
	Local cRet := ""

	If Inclui
		If !Empty(M->C5_TABELA)
			aTrocaF3 := {{"C6_PRODUTO","DA1SC6"}}
		Else
			aTrocaF3 := {}
		Endif
	Else
		If !Empty(SC5->C5_TABELA)
			aTrocaF3 := {{"C6_PRODUTO","DA1SC6"}}
		Else

			aTrocaF3 := {}
		Endif
	Endif


Return .T.


User Function xF3SC6ALT()
	Local cRet := ""

	If !Inclui
		cRet := SC5->C5_TABELA
		If !Empty(SC5->C5_TABELA)
			aTrocaF3 := {{"C6_PRODUTO","DA1SC6"}}
		Else
			aTrocaF3 := {}
		Endif
	Endif

Return cRet


User Function MGFVLDTB()

	Local aAliasAtu := GetArea()
	Local aAliasDA1 := DA1->(GetArea())
	Local lRet := .T.

	If M->C5_TABELA <> " "
		DbSelectArea("DA1")
		DbSetOrder(1)
		If !DA1->(dBSeek(xFilial("DA1")+M->C5_TABELA+M->C6_PRODUTO))


			Help(" ",1,"SEMTABELA",,"O produto não foi encontrado na tabela de preço "+M->C5_TABELA+Chr(13)+Chr(10)+ "Entre em contato com o responsável pelo cadastramento da tabela de preço e informe esta mensagem.",1,0)


			lRet := .F.

		Endif
	Endif

	RestArea(aAliasDA1)
	RestArea(aAliasAtu)

return lRet
