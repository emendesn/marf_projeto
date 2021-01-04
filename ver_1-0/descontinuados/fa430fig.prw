#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa.:              FA430FIG
Autor....:              Natanael Filho
Data.....:              26/09/2017
Descricao / Objetivo:   Modificacao no CNPJ no retorno DDA.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINA430.
	http://tdn.totvs.com/pages/releaseview.action?pageId=152802170
	
	
=====================================================================================
*/

User Function FA430FIG()
	Local _cCGC := PARAMIXB[1] //CGC/CNPJ/CPF infomado no arquivo de retorno
	
	//======================================================
	// 11/abril/2019 - Natanael Filho
	// Tratamento do CNPJ/CPF, conforme solicitado pelo Financeiro:
	//		Quando for CNPJ deve retornar apenas a raiz do CNPJ, pois a em alguns casos � realizado a aquisicao de uma loja do fornecedor
	//		mas a cobranca � enviada por uma outra loja / Filial. Dessa forma utilizando apenas a raiz, a tabela FIG sempre sera atualizada
	//		atraves do cadastro da matriz do fornecedor (SA2).
	//		J� quando for CPF, deve retornar o numero completo.
	//======================================================
	
	If Len(_cCGC) >= 11 // Verifica se foi utilizadas pelo menos a quantidade de d�digos de um CPF.
		If SubStr(_cCGC,10,4) <> "0000" // Verifica o trexo referente � filial, caso seja um CNPJ
			_cCGC := SubStr(_cCGC,1,9)  //Retorna apenas a Raiz do CNPJ
		Else
			_cCGC := Left(cCGC,9) + Right(cCGC,2)
		EndIf
	EndIf 

Return _cCGC