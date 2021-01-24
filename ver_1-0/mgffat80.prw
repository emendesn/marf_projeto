#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT80
Autor...............: Totvs
Data................: Junho/2018 
Descricao / Objetivo: Rotina chamada pelo PE M410VRES
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Validar execucao da rotina de eliminacao de residuos pela tela de pedido de venda
=====================================================================================
*/
User Function MGFFAT80()

Local lRet := .T.
Local cUserRot := GetMv("MGF_FAT801")

If !Alltrim(__cUserId) $ cUserRot
	lRet := .F.
	APMsgAlert("Opção não deve ser usada pela Marfrig."+CRLF+;
	"Resíduo não será eliminado.")
Endif	

// o kleiton pediu em 18/06/18, para que esta rotina nao fosse mais acessado pelos usuarios
// tratamento abaixo eh para estornar o sc9 antes de rodar o elimina residuo
/*
Local aArea := {SC9->(GetArea()),SC6->(GetArea()),SZJ->(GetArea()),GetArea()}
Local lRet := .T.
Local lPula := .F.

SZJ->(dbSetOrder(1))
If SZJ->(dbSeek(xFilial("SZJ")+SC5->C5_ZTIPPED))
	If SZJ->ZJ_TAURA == "S"
		lPula := .T.
		APMsgAlert("Pedido integra com o Taura, será executada rotina sem eliminar reservas da tabela SC9.")
	Endif
Endif

If !lPula		
	SC6->(dbSetOrder(1))
	SC9->(dbSetOrder(1))
	If SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
			If SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
				If !(SC9->C9_BLCRED=="10" .and. SC9->C9_BLEST=="10")
					A460Estorna()
				Endif
			Endif
			SC6->(dbSkip())
		Enddo
	Endif
Endif					

aEval(aArea,{|x| RestArea(x)})
*/

Return(lRet)