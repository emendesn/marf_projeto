#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM76
Autor...............: Totvs
Data................: Fev/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MTALCALT
=====================================================================================
*/
User Function MGFCOM76()

If Alltrim(SCR->CR_TIPO) == "NF"
	If SCR->CR_FILIAL == SF1->F1_FILIAL .and. Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		If "_VALOR_NFE" $ Alltrim(SCR->CR_NUM)
			If !Empty(SF1->F1_ZVLRTOT)
				SCR->(RecLock("SCR",.F.))
				SCR->CR_ZVLRTOT := SF1->F1_ZVLRTOT
				SCR->CR_ZVLTOCL := IIf(IsInCallStack("MATA103"),IIf(MaFisFound(),MaFisRet(,"NF_TOTAL"),0),IIf(IsInCallStack("MATA140"),SF1->F1_ZVLTOCL,0))
				SCR->CR_ZVLDIFC := Abs(SF1->F1_ZVLRTOT-IIf(IsInCallStack("MATA103"),IIf(MaFisFound(),MaFisRet(,"NF_TOTAL"),0),IIf(IsInCallStack("MATA140"),SF1->F1_ZVLTOCL,0)))
				SCR->(MsUnLock())
			Endif
		Endif	
	Endif
Endif			

Return()