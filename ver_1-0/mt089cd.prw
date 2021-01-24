#INCLUDE "PROTHEUS.CH"


/*
=====================================================================================
Programa.:              MT089CD
Autor....:              Rafael Garcia
Data.....:              25/09/2019
Descricao / Objetivo:   Ponto de entrada na TES inteligente 
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/


User Function MT089CD()//As variaveis foram carregada com paramixb somente para verificar o conteudo original.

	Local bCond 	:= PARAMIXB[1] //Condicao que avalia os campos do SFM
	Local bSort 	:= PARAMIXB[2] //Forma de ordenacao do array onde o 1o elemento sera utilizado. Esse array inicialmente possui 9 posicoes
	Local bIRWhile 	:= PARAMIXB[3] //Regra de selecao dos registros do SFM
	Local bAddTes 	:= PARAMIXB[4] //Conteudo a ser acrescentado no array
	Local cTabela 	:= PARAMIXB[5] //Tabela que esta sendo tratada
	Local cTpOper 	:= PARAMIXB[6] //Tipo de Opera��o
//	Local _nProd

	If cTabela == "SD1"
		IF !EMPTY(GDFIELDGET("D1_ZCLASFI",n))
//			_nProd := aScan(aHeader, {|x| AllTrim(x[2])=="C6_PRODUTO"})
			bCond     := {|| GDFIELDGET("D1_ZCLASFI",n) $ alltrim((cAliasSFM)->FM_ZSITRIB) }
			bSort     := {|x,y| x[11] > y[11]}
			bIRWhile:= {||.T.}
			bAddTes :=  {||aAdd(aTes[Len(aTes)],(cAliasSFM)->FM_ZSITRIB)}//Acrescento campo a ser considerado na TES Inteligente.
		ENDIF
	Else
		bCond   := {||.T.}
		bSort   := bSort
		bIRWhile:= {||.T.}
		bAddTes := {||.T.}
	EndIf

	Return({bCond,bSort,bIRWhile,bAddTes,cTpOper})
