/*
=====================================================================================
Programa.:              SF1100I
Autor....:              Rafael Garcia
Data.....:              14/10/2016
Descricao / Objetivo:   PE chamado ao final da geracao de documento de entrada
Doc. Origem:
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function SF1100I()

	Local aArea 	:= GetArea()
	Local aAreaSF1 	:= SF1->(GetArea())
	Local aAreaSD1	:= SD1->(GetArea())
	Local aAreaSF4	:= SF4->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())

	If findfunction("U_MGFFIN21") //GAP FIN_CRE035_V1
		U_MGFFIN21()
	endif

	If findfunction("U_MGFCOM82") // DADOS CD5
		U_MGFCOM82()
	endif

	If cFilAnt == "010065"
		If SF1->F1_TIPO == "N"
			SD1->( dbSetOrder(1) ) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			SF4->( dbSetOrder(1) ) //F4_FILIAL+F4_CODIGO
			SB1->( dbSetOrder(1) ) //B1_FILIAL+B1_COD

			If SD1->( dbSeek( SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ) )
				While !SD1->( eof() ) .And. SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) == 	SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)
					If SF4->(dbSeek(xFilial("SF4",SF1->F1_FILIAL) + SD1->D1_TES ))
						If SF4->F4_ESTOQUE == "S"
							If SB1->(dbSeek(xFilial("SB1",SF1->F1_FILIAL) + SD1->D1_COD ))
								IF Empty(SB1->B1_XLJPROD)
									RecLock("SB1",.F.)
										SB1->B1_XLJPROD := "1"
									SB1->(MSUNLOCK())
								Endif
							EndIf
						EndIf
					EndIf
					SD1->( dbSkip() )
				EndDo
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSF4)
	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)

Return