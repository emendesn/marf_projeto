#include 'protheus.ch'
#include 'parmtype.ch'

user function DEPCTBGRV()
	
	Local aArea 	:= GetArea()
	Local aAreaCT2	:= CT2->(GetArea())
	
	Local nOpcx 	:= PARAMIXB[1] 
	Local dDataLanc := PARAMIXB[2]
	Local cLote 	:= PARAMIXB[3] 
	Local cSubLote	:= PARAMIXB[4]
	Local cDoc 		:= PARAMIXB[5]
	
	If FindFunction("U_MGFCTB25") .and. IsInCallStack("CTBA500")//Rotina Lançamento Contabil Off-line TXT
		
		dbSelectArea("CT2")
		CT2->(dbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
		If CT2->(dbSeek(xFilial('CT2') + DTOS(dDataLanc) + cLote + cSubLote + cDoc ))
			U_MGFCTB25()
		EndIf
	EndIf
	
	RestArea(aAreaCT2)
	RestArea(aArea)
	
return