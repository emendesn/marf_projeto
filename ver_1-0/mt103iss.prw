#include "protheus.ch"

/*
=====================================================================================
Programa............: MT103ISS
Autor...............: Natanael Filho
Data................: 13/03/2019
Descricao / Objetivo: LOCALIZAÇÃO : Function A103AtuSE2() - Rotina de integração com o módulo financeiro.
						EM QUE PONTO : Este PE é chamado no momento de gravação do título da nota fiscal,
						onde seu retorno atribui valores a serem alterados nas variáveis CFORNISS, CLOJAISS,
						CDIRF, CCODRET e DVENCISS que serão transportados no título de ISS caso exista para 
						esta NF.Eventos
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MT103ISS()
	
	/*
	aRet[1] = Novo código do fornecedor de ISS.
	aRet[2] = Nova loja do fornecedor de ISS.
	aRet[3] = Novo indicador de gera dirf.
	aRet[4] = Novo código de retenção do título de ISS.
	aRet[5] = Nova data de vencimento do título de ISS.
	*/
	Local aRet := ParamIxb
	Local aArea := GetArea()
	
	//Função para alteração do fornecedor do título de retenção do ISS, conforme tabela CE1 - Alíquotas de ISS
	If FindFunction("U_MGFGFE40")
		aRet := U_MGFGFE40(aRet)
	EndIf	
		
	RestArea(aArea)
Return(aRet)
