#include "protheus.ch"

/*
=====================================================================================
Programa............: MT103ISS
Autor...............: Natanael Filho
Data................: 13/03/2019
Descricao / Objetivo: LOCALIZA��O : Function A103AtuSE2() - Rotina de integra��o com o m�dulo financeiro.
						EM QUE PONTO : Este PE � chamado no momento de grava��o do t�tulo da nota fiscal,
						onde seu retorno atribui valores a serem alterados nas vari�veis CFORNISS, CLOJAISS,
						CDIRF, CCODRET e DVENCISS que ser�o transportados no t�tulo de ISS caso exista para 
						esta NF.Eventos
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MT103ISS()
	
	/*
	aRet[1] = Novo c�digo do fornecedor de ISS.
	aRet[2] = Nova loja do fornecedor de ISS.
	aRet[3] = Novo indicador de gera dirf.
	aRet[4] = Novo c�digo de reten��o do t�tulo de ISS.
	aRet[5] = Nova data de vencimento do t�tulo de ISS.
	*/
	Local aRet := ParamIxb
	Local aArea := GetArea()
	
	//Fun��o para altera��o do fornecedor do t�tulo de reten��o do ISS, conforme tabela CE1 - Al�quotas de ISS
	If FindFunction("U_MGFGFE40")
		aRet := U_MGFGFE40(aRet)
	EndIf	
		
	RestArea(aArea)
Return(aRet)
