#include 'protheus.ch'
#include 'parmtype.ch'

User Function MGFCTB27()

	Local aArea := GetArea()
	Local aAreaCT2 := CT2->(GetArea())

	Local nReg		:= 0
	//local aOldRotina := aRotina
	Local cFilBkp := cFilAnt
	Local cAlias := oBrowse:Alias()
	
	dbSelectArea("SCR")
	SCR->(DbSetOrder(0))
	SCR->(DbGoTo((cAlias)->RECSCR))

	cFilAnt := (cAlias)->CR_FILIAL

	dbSelectArea("CT2")
	CT2->(DbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC

	If CT2->(dbSeek(SCR->(CR_FILIAL + Alltrim(CR_NUM))))

		dDataLanc	:= CT2->CT2_DATA
		cLote		:= CT2->CT2_LOTE
		cSubLote	:= CT2->CT2_SBLOTE
		cDoc		:= CT2->CT2_DOC
		cPadrao		:= CT2->CT2_LP

		lSubLote 	:= Empty(cSubLote)
		cLoteSub 	:= GetMv("MV_SUBLOTE")
		cCadastro 	:= "Visualização"

		aRotina := {	{"Pesquisar"    ,"AxPesqui"   , 0 , 1,,.F.},; // "Pesquisar"
						{"Visualizar"   ,"Ctba102Cal" , 0 , 2     },; // "Visualizar"
						{"Incluir"      ,"Ctba102Cal" , 0 , 3, 191},; // "Incluir"
						{"Alterar"      ,"Ctba102Cal" , 0 , 4     },; // "Alterar"
						{"Excluir"      ,"Ctba102Cal" , 0 , 5     },; // "Excluir"
						{"Estornar"     ,"Ctba102Cal" , 0 , 4     },; // "Estornar"
						{"Copiar"       ,"Ctba102Cal" , 0 , 3     },; // "Copiar"
						{"Rastrear"     ,"CtbC010Rot" , 0 , 2     },; // "Rastrear"
						{"Cópia Filial" ,"Ctba102Cop" , 0 , 4     } } // "Cópia Filial"

		nReg := CT2->(Recno())
		Ctba102Cal("CT2",nReg,2)

	EndIf
	
	cFilAnt := cFilBkp
	//aRotina := aOldRotina
	RestArea(aAreaCT2)
	RestArea(aArea)

Return