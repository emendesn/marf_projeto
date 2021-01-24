#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"

/*
=====================================================================================
Programa............: MGFCOMB2
Autor...............: Jucelino
Data................: 20/10/2016 
Descricao / Objetivo: 
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/

User Function MGFCOMB2()

	Local lRet		:= .T.
	Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_COMB2R",.F.,'GFEA065;MGFINT09'),";") //Rotinas que n�o passar�o pela valida��o
	Local _nBloqMSG	:= SuperGetMV("MGF_COMB2B",.T.,2) //Comportamento da rotina: 1-Bloquer� a grava��o; 2-Apenas alertar�; 0-Nada fara.
	Local _cMsg		:= " "

	//Verifica se as rotinas que n�o devem passar pela valida��o est�o na pilha de chamada. Se estiver, sai da fun��o. 
	For nCnt := 1 To Len(_aRotExc)
		If IsInCallStack(Alltrim(_aRotExc[nCnt]))
			Return .T.
		EndIf
	Next

	/*
	aInfAdic[10]	UF origem do transporte
	aInfAdic[11]	Mun. Origem do Transporte
	aInfAdic[12]	UF Origem do Transporte
	aInfAdic[13]	Mun. Destino do Transporte
	*/
	
	If ((Empty(aInfAdic[10]) .Or. Empty(aInfAdic[11]) .Or. Empty(aInfAdic[12]) .Or. Empty(aInfAdic[13])) .And. l103Class)
		
		lRet :=.F.
		_cMsg := "Para esp�cie 'CTE' � necess�rio informar os campos na aba 'Informa��es Adicionais'"+CRLF+;
				"UF Origem do Transporte"+CRLF+;
				"UF Destino do Transporte"+CRLF+;
				"Mun. Origem do Transporte"+CRLF+;
				"Mun. Destino do Transporte"
	EndIf
	
	//Verifica qual o comportamento foi par�metrizado para a rotina: 1-Bloquer� a grava��o; 2-Apenas alertar�; 0-Nada fara.
	If !lRet
		If _nBloqMSG = 0
			lRet := .T.

		ElseIf _nBloqMSG = 1
			MsgAlert(_cMsg)

		ElseIf MsgYesNo(_cMsg + "." + CRLF + CRLF + "Deseja continuar?","MGFCOMB2")
				lRet := .T.
				
		EndIf
	EndIf
	
return lRet