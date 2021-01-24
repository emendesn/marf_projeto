/*
=====================================================================================
Programa.:              EECPEM36
Autor....:              Flávio dos Anjos Dentello
Data.....:              Nov/2016
Descricao / Objetivo:   Impressão do documento Shipping Instructions no Modelo Marfrig
Grava a tabela com o total dos documentos a serem impressos
Doc. Origem:            GAP EEC07
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/

User Function EECPEM36()

Local 	lContinua	:= .T.
Local 	cAlias1
Local 	cEmbarq		:= EEC->EEC_PREEMB
Local 	aDocs		:= {}             
Local   aArea		:= GetArea()
//Local   aAreaZZI	:= ZZI->(GetArea())

cAlias1	:= GetNextAlias()
//cQuery := " SELECT DISTINCT ZZJ_FILIAL, ZZJ_PEDIDO, ZZJ_CODDOC, ZZJ_QTDCOP, ZZJ_QTDORI FROM " + RetSQLName("EE9") + " EE9 " + "," + RetSQLName("ZZJ") + " ZZJ "
cQuery := " SELECT EE9_FILIAL, EE9_PREEMB, ZZJ_CODDOC, SUM(ZZJ_QTDCOP) COPIA, SUM(ZZJ_QTDORI) ORIGINAL  FROM " + RetSQLName("EE9") + " EE9 " + "," + RetSQLName("ZZJ") + " ZZJ "
cQuery += " WHERE ZZJ.ZZJ_FILIAL 	= '" + xFilial("ZZJ") + "' "
cQuery += " AND EE9.EE9_FILIAL 	= '" + xFilial("EE9") + "' "
cQuery += " AND	EE9.EE9_PEDIDO 	= ZZJ.ZZJ_PEDIDO"
cQuery += " AND	EE9.EE9_PREEMB 	= '" + cEmbarq + "' "
cQuery += " AND EE9.D_E_L_E_T_= ' ' "
cQuery += " AND ZZJ.D_E_L_E_T_= ' ' "
cQuery += " GROUP BY EE9_FILIAL, EE9_PREEMB, ZZJ_CODDOC, ZZJ_QTDCOP, ZZJ_QTDORI"

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

////MONTAR A REGRA PARA AGRUPAR AS QUANTIDADES DE DOCUMENTOS, PODE SER ATRAVES DO WHILE OU ENTÃO VERIFICAR A POSSIBILIDADE DE FAZER VIA SUM() NA QUERY
aAreaZZI := ZBA->(GetArea())

DbSelectArea("ZBA")
DbSetOrder(1) 
If DbSeek(xFilial("EE9") + (cAlias1)->EE9_PREEMB)     	     


Else
  
			While (cAlias1)->(!EOF())
		
				RecLock("ZBA",.T.)		
		        ZBA->ZBA_FILIAL := (cAlias1)->EE9_FILIAL
		        ZBA->ZBA_PREEMB := (cAlias1)->EE9_PREEMB
		        ZBA->ZBA_CODDOC := (cAlias1)->ZZJ_CODDOC
		        ZBA->ZBA_QTDCOP := (cAlias1)->COPIA
		        ZBA->ZBA_QTDORI := (cAlias1)->ORIGINAL
				ZBA->(MsUnlock())
		
				(cAlias1)->(DbSkip())
			End
		
		DbCloseArea(cAlias1)      
		RestArea(aArea)		
		
EndIf


Return

