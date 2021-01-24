#Include "Protheus.ch"
//#Include "ApWizard.ch"
#Include "FWMVCDef.ch"
#Include "FWMBROWSE.CH"
#Include "ATFA012.ch"

//
//
User Function AF012ROT(aRot1)
	Local lMarkBrw
	Local aRotina 	:= {}
	lMarkBrw := If( lMarkBrw == nil, .F. , lMarkBrw )

	Aadd( aRotina, { "Pesquisar", "PesqBrw", 0, 1, 0,,, })
	Aadd( aRotina, { "Visualizar", "VIEWDEF.ATFA012", 0, 2, 0,,, })
	Aadd( aRotina, { "Incluir", "AF012Inclu", 0, 3, 0,,, })
	Aadd( aRotina, { "Alterar", "AF012AltEx", 0, 4, 0,,, })
	Aadd( aRotina, { "Excluir", "AF012AltEx", 0, 5, 0,,, })
	Aadd( aRotina, { "Excluir Lote", "AF012EXCLT", 0, 5, 0,,, })
	Aadd( aRotina, { "Copia", "AF012Cpy", 0, 9, 0,,, })
	Aadd( aRotina, { "Conhecimento", "MSDOCUMENT", 0, 4, 0,,, })
	Aadd( aRotina, { "Laudo", "AF012LAUDO", 0, 4, 0,,, })
	Aadd( aRotina, { "Legenda", "ATFLEGENDA", 0, 5, 0,,, })
	Aadd( aRotina, { "Tracker Contábil", "CTBC662", 0, 8, 0,,, })

	If cPaisLoc == "BRA"
		Aadd( aRotina, { "Converte Método", "AF012CVMET", 0, 4, 0,,, })
		Aadd( aRotina, { "Canc.Método", "AF012CVMET", 0, 5, 0,,, })
	ElseIf cPaisLoc == "COL"
		Aadd( aRotina, { "Converte Dep.", "AF012ACVCL", 0, 4, 0,,, })
		Aadd( aRotina, { "Cancela Dep.", "AF012ACVCL", 0, 5, 0,,, })
	EndIf

	Aadd( aRotina, { "Bloquear/Desb", "Af012BlqDesb", 0, 3, 0,,, })
	Aadd( aRotina, { "Contr. Terceiros", "ATFA320", 0, 3, 0,,, })
	Aadd( aRotina, { "Contr.em Terceiros", "ATFA321", 0, 3, 0,,, })
	Aadd( aRotina, { "Import. Classificação", "AF012IMPCL", 0, 3, 0,,, })
	Aadd( aRotina, { "Log Proc", "AFA012LOG", 0, 3, 0,,, })

	If lMarkBrw
		aRot := {}
		Aadd( aRot, { "Confirmar", "AF012ExcMa(1)", 0, 4, 0,,, })

		aRotina := aClone(aRot)
	Endif

	Aadd( aRotina, { "Alt. Plaqueta", "u_MGFALTPLQ", 0, 4, 0,,, })

Return aRotina
