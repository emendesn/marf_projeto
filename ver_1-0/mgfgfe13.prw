#include 'protheus.ch'
#include 'parmtype.ch'

/*
Alterado em: 13/04/2020
Por: Paulo da Mata
Task : RTASK0010971
Objetivo: Modernização do fonte

10/07/2020 - Paulo da Mata - RTASK0010971 - Recriação para PRD em 13/07/2020
*/ 

User Function MGFGFE13()

	Local aArea   := GetArea()
	Local cQuery  := ""
	Local dDtVenc := CtoD(Space(08))
	Local cCRLF   := CHR(13)+CHR(10)

	If Isincallstack('GFEA118') .Or. Isincallstack('GFEA065') .And. (INCLUI .Or. ALTERA)

		If Select("TMPSE2") > 0
			TMPSE2->(dbCloseArea())
		Endif

		cQuery := "SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_EMISSAO,E2_VENCREA "+cCRLF
		cQuery += "FROM "+RetSqlName("SE2")+" "+cCRLF
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+cCRLF
		cQuery += "AND E2_FILIAL  = '"+GW3->GW3_FILIAL+"' "+cCRLF
		cQuery += "AND E2_PREFIXO = '"+SubStr(GW3->GW3_SERDF,1,3)+"' "+cCRLF
		cQuery += "AND E2_NUM     = '"+GW3->GW3_NRDF+"' "+cCRLF
		cQuery += "AND E2_EMISSAO = '"+Dtos(GW3->GW3_DTEMIS)+"' "+cCRLF

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPSE2",.F.,.T.)
		dbSelectArea("TMPSE2")

		dDtVenc := StoD(TMPSE2->E2_VENCREA)

		If (!Empty(dDtVenc))

			GW3->(RecLock("GW3",.F.))
			GW3->GW3_ZVECTO := dDtVenc
			GW3->(MsUnLock())
		
		EndIf
	
	EndIf
    
	RestArea(aArea)

Return