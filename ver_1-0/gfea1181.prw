#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE POS_ALIAS 001
#DEFINE POS_INDIC 002
#DEFINE POS_RECNO 003

/*
Tratamento para não trazer os registros importados marcados para processamento.
*/                                                                                        
User Function GFEA1181()
	Local oCTe     := PARAMIXB[1]
	Local aArea	   := GetArea()
	Local aAreaGXG := GXG->(GetArea())
	Local aAreaSA4 := SA4->(GetArea())
	Local dData    := stod(SuperGetMv("MGF_DGFE46",,"20991231"))

	Local _cTpObs	:= "" 
	Local _nQtdObs	:= 0
	Local _cIntMGF	:= ""
	Local _cTipoOp	:= "0"

	_cTpObs := VALTYPE(oCTE:_INFCTE:_compl:_Obscont)
	If _cTpObs = "O"		//Se é objeto existe apenas uma Observação.
		_nQtdObs := 1
	ElseIf _cTpObs = "A"	//Se é array existe mais de uma Observação - Percorrer todos. 
		_nQtdObs := LEN(oCTE:_INFCTE:_compl:_Obscont)
	EndIf

	For I:=1 To _nQtdObs
		If _cTpObs = "O"
			_cIntMGF := RTRIM(oCTE:_INFCTE:_compl:_Obscont:_xTEXTO:TEXT)
		Else
			If RTRIM(oCTE:_INFCTE:_compl:_Obscont[I]:_xcampo:TEXT) = "TipoOper"
				_cTipoOp := RTRIM(oCTE:_INFCTE:_compl:_Obscont[I]:_xTEXTO:TEXT)
			ElseIf RTRIM(oCTE:_INFCTE:_compl:_Obscont[I]:_xcampo:TEXT) = "ObsContAutomatica"
				_cIntMGF := RTRIM(oCTE:_INFCTE:_compl:_Obscont[I]:_xTEXTO:TEXT)
			EndIf 
		EndIf
	Next I

	If Type("oCTE:_INFCTE:_infRespTec:_CNPJ:TEXT") <> "U" .AND. _cTpObs <> "U"	//MultiEmbarcador
		If ALLTRIM(oCTE:_INFCTE:_infRespTec:_CNPJ:TEXT) = ALLTRIM(GETMV("MGF_GFE45")) .AND. _cIntMGF = "IntMarfrig"	//Verifica se é gerada pelo MultiEmbarcador
			If DATE() >= dData
				DBSELECTAREA("SA4")
				DBSETORDER(3)
				If DBSEEK(XFILIAL("SA4")+GXG->GXG_EMISDF)
					If SA4->A4_ZINTMEM == "1"
						If FindFunction("U_MGFGFE45")
							lRet := U_MGFGFE45(PARAMIXB[1], _cTipoOp)
						EndIf
					EndIf
				EndIf							
			Endif
		EndIf
	EndIf


	If GXG->(!EOF()) .AND. !EMPTY(GXG->GXG_MARKBR)
		RecLock("GXG",.F.)
		GXG->GXG_MARKBR := ' '
		GXG->GXG_USUIMP := cUserName
		GXG->(MsUnlock())
	EndIf

	RestArea(aArea)
	RestArea(aAreaGXG)
Return

