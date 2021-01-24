#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT86
Autor...............: Totvs
Data................: Junho/2018 
Descricao / Objetivo: Rotina chamada pelo PE MSD2520
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Exclusao de tabela ZZR da exportacao
=====================================================================================
*/
User Function MGFFAT86()

Local aArea := {ZZR->(GetArea()),GetArea()}

If !Empty(SF2->F2_CARGA)
	ZZR->(dbSetOrder(1))
	If ZZR->(dbSeek(xFilial("ZZR")+Padr(SD2->D2_PEDIDO,TamSX3("ZZR_PEDIDO")[1])+Padr(SD2->D2_ITEMPV,TamSX3("ZZR_ITEM")[1])))
		While ZZR->(!Eof()) .and. xFilial("ZZR") == ZZR->ZZR_FILIAL .and. Alltrim(SD2->D2_PEDIDO) == Alltrim(ZZR->ZZR_PEDIDO) .and. Alltrim(SD2->D2_ITEMPV) == Alltrim(ZZR->ZZR_ITEM)
			If Alltrim(SF2->F2_CARGA) == Alltrim(ZZR->ZZR_CARGA)
				ZZR->(RecLock("ZZR",.F.))
				ZZR->(dbDelete())
				ZZR->(MsUnLock())
			Endif
			ZZR->(dbSkip())
		Enddo
	Endif
Endif
			
aEval(aArea,{|x| RestArea(x)})	
		
Return()