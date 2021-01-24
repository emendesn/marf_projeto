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
	Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_COMB2R",.F.,'GFEA065;MGFINT09'),";") //Rotinas que não passarão pela validação
	Local _nBloqMSG	:= SuperGetMV("MGF_COMB2B",.T.,2) //Comportamento da rotina: 1-Bloquerá a gravação; 2-Apenas alertará; 0-Nada fara.
	Local _cMsg		:= " "

	//Verifica se as rotinas que não devem passar pela validação estão na pilha de chamada. Se estiver, sai da função. 
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
		_cMsg := "Para espécie 'CTE' é necessário informar os campos na aba 'Informações Adicionais'"+CRLF+;
				"UF Origem do Transporte"+CRLF+;
				"UF Destino do Transporte"+CRLF+;
				"Mun. Origem do Transporte"+CRLF+;
				"Mun. Destino do Transporte"
	EndIf
	
	//Verifica qual o comportamento foi parâmetrizado para a rotina: 1-Bloquerá a gravação; 2-Apenas alertará; 0-Nada fara.
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