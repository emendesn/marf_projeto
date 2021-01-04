#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              M030INC
Autor....:              Gustavo Ananias Afonso
Data.....:              26/10/2016
Descricao / Objetivo:
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6784136
=====================================================================================
*/
user function M030INC()

	IF PARAMIXB <> 3 //cancelou a operacao
		// tem que deixar esta funcao  primeiro pois
		// altera o codigo e loja
		If FindFunction("U_MGFINT46")
			U_MGFINT46(2) // 1 valida e 2 altera o codigo
		Endif

		//GAP387 - Criar inteligencia no campo Cnae do cliente x Grupo de Tributacao - 25/OUT/2018 - Natanael Filho
		//Essa funcao deve ser chamada antes das funcoes de grade de aprovacao.
		If findFunction("U_MGFFIS40")
				U_MGFFIS40(2) //1: Fornecedor / 2:Cliente
		EndIf

		If FindFunction("U_MGFFAT25")
			U_MGFFAT25("I")
		Endif
		If FindFunction("U_MGFINT17")
			U_MGFINT17()
		Endif
		If PARAMIXB <> 3
			IF findfunction("U_MGFINT39")
				U_MGFINT39(2,'SA1','A1_MSBLQL')
			EndIF
		EndIF
		If FindFunction("U_MGFFAT37")
			U_MGFFAT37()
		Endif

		if findFunction("U_MGFINT68")
			U_MGFINT68()
		endif

		if findFunction("U_MGFFATBE")
			U_MGFFATBE()
		endif
	endif
return