#include 'protheus.ch'
#include 'parmtype.ch'
/*---------------------------------------------------------------------------------------------------------------------------*
| Desenvolvedor: Caroline Cazela					Data: 11/12/2018														|
| P.E.:  MGFCOMB6																											|                                                                                                            |
| Desc:  Chamado pelo ponto de entrada MTA103OK E MT140LOK                                                                  |
| Obs.:  Validação de campos para regra contábil (conta contábil e classe valor)-> MIT 157									|
*---------------------------------------------------------------------------------------------------------------------------*/
User Function MGFCOMB6() 
	
	Local lRet := .T.

	Local nPosConta := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CONTA"}) // Para saber a posição do campo no Acols   
	Local nPosClvl := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CLVL"}) // Para saber a posição do campo no Acols
	//Tarcisio Galeano 11/01/19
	Local nPosCc := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_CC"}) // Para saber a posição do campo no Acols

	/*If Empty(aCols[n][nPosClvl]) 
		If Substr(aCols[n][nPosConta],1,3) == "123" .OR. Substr(aCols[n][nPosConta],1,3) == "124"
			MsgAlert("O produto selecionado no item " + SD1->D1_ITEM + " é um ativo imobilizado! Informar Cod Cl Vl com valor iniciado por 201 conforme Capex.","Atenção") 
			lRet := .F.
		Else
	   		lRet := .T.
		EndIf
	EndIf*/

//Tarcisio Galeano 11/01/19
	If  Substr(aCols[n][nPosConta],1,1) == "5" .and. Empty(aCols[n][nPosCC]) 
		MsgAlert("Para a conta contábil " + aCols[n][nPosConta] + " é obrigatorio o preenchimento do centro de custos.","Atenção") 
		lRet := .F.
	EndIf
	
return lRet