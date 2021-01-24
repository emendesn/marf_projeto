#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT49
Autor...............: Mauricio Gresele
Data................: Set/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada M521DNFS. 
					  Desfaz processo do GAP FIS45 no pedido de venda.
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFAT49()

Local aArea	:= {SC5->(GetArea()),SC6->(GetArea()),SC9->(GetArea()),GetArea()}
Local aRet := {}
Local lSifExc := .F.
//Local lProcOff := .F.
//Local cFilAntSav := cFilAnt  

// variaveis criadas para a chamada da funcao AltPVESif no fonte MGFTAS02
Private cMensTime := ""
Private cLogTime := ""

Private lErro := .F.

Private aRegSC5 := {}
Private aRegSA1 := {}
Private aRegSA2 := {}
Private aRegSB2 := {}
Private aRegEE7 := {}
// ate aqui - variaveis criadas para a chamada da funcao AltPVESif no fonte MGFTAS02

If Type("__cCarga") != "U" .and. !Empty(__cCarga) .and. Type("__aPVCarga") != "U" .and. !Empty(__aPVCarga)
	aEval(__aPVCarga,{|x| IIf(x[3],lSifExc:=.T.,Nil)})
	If lSifExc
		// // processa pedidos de exportacao
		aRet := StaticCall(MGFTAS02,AltPVESif,__aPVCarga) //,,,.T.,.F.,@lProcOff,cFilAnt)
		/*
		If aRet[1]
			// se algum pedido for off-shore, processa pedido na filial off-shore
			If lProcOff
				cFilAntSav := cFilAnt 
				cFilAnt := Alltrim(GetMv("MV_AVG0024"))
				aRet := StaticCall(MGFTAS02,AltPVESif,__aPVCarga,,,.T.,.T.,lProcOff,cFilAntSav)
				cFilAnt := cFilAntSav
			Endif
			If aRet[1]
				// processa pedidos de venda
				aRet := StaticCall(MGFTAS02,AltPVESif,__aPVCarga,,,.F.,.F.,lProcOff,cFilAnt)
			Endif	
		Endif	
		*/
		If !aRet[1] // deu erro 
			APMsgAlert("Problemas no estorno do processo do GAP FIS45 ou alteração de quantidades"+CRLF+;
			aRet[2])
		Endif	
		
		// retorna pergunte da mata521, pois a funcao AltPVESif altera o pedido de venda e exportacao usando rotina automatica e troca este pergunte
		Pergunte("MTA521",.F.)
		
	Endif	
Endif

// limpa variavel para garantir integridade
If Type("__cCarga") != "U"
	__cCarga := "" 
Endif

If Type("__aPVCarga") != "U"
	__aPVCarga := {}
Endif	

aEval(aArea,{|x| RestArea(x)})

Return()