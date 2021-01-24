#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa.:              MGFFIN99
Param....:				_cCGC: CNPJ/CPF retornado do CNAB
Autor....:              Natanael Filho/Marcos Vieira
Data.....:              06/06/2019
Descricao / Objetivo:   Modificação no CNPJ no retorno DDA.
Doc. Origem:            
Solicitante:            Mauricio Ferreira
Uso......:              Marfrig
Obs......:              Chamado pelo PE F430VAR
=====================================================================================
*/

User Function MGFFIN99(_cCGC)

	//======================================================
	// 11/abril/2019 - Natanael Filho
	// Tratamento do CNPJ/CPF, conforme solicitado pelo Financeiro:
	//		Quando for CNPJ deve retornar apenas a raiz do CNPJ, pois a em alguns casos é realizado a aquisição de uma loja do fornecedor
	//		mas a cobrança é enviada por uma outra loja / Filial. Dessa forma utilizando apenas a raiz, a tabela FIG sempre será atualizada
	//		através do cadastro da matriz do fornecedor (SA2).
	//		Já quando for CPF, deve retornar o número completo.
	//======================================================
	
	If Len(_cCGC) >= 11 // Verifica se foi utilizadas pelo menos a quantidade de dídigos de um CPF.
		If SubStr(_cCGC,10,4) <> "0000" // Verifica o trexo referente à filial, caso seja um CNPJ
			If Len(_cCGC) = 14
				_cCGC := SubStr(_cCGC,1,9)  //Retorna apenas a Raiz do CNPJ
			Else
				_cCGC := SubStr(_cCGC,2,9)  //Retorna apenas a Raiz do CNPJ	
			EndIf	
		Else
			_cCGC := Left(_cCGC,9) + Right(_cCGC,2)
		EndIf
	EndIf 

Return _cCGC