#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT28
Autor...............: Mauricio Gresele
Data................: 18/11/2016 
Descricao / Objetivo: Desfazer o tratamento executado no fonte MGFFAT11
Doc. Origem.........: Faturamento - GAP FAT19
Solicitante.........: Cliente
Uso.................: 
Obs.................: Desfazer: Gerar residuo dos itens do pedido que nao foram faturados
=====================================================================================
*/

// rotina chamada pelo ponto de entrada M521DNFS(Retirado), MSD2520
User Function MGFFAT28()

Local aArea := {SC5->(GetArea()),SC6->(GetArea()),GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local nCnt := 0
//Local aPedido := ParamIxb[1]
Local cPedido := SD2->D2_PEDIDO
Local cItem	  := SD2->D2_ITEMPV
Local aPedAlt := {}

//If Len(aPedido) > 0
//	aEval(aPedido,{|x| cPedido:=x+"/"})
//	If Len(cPedido) > 0
//		cPedido := Subs(cPedido,1,Len(cPedido)-1)
//	Endif
//Endif		
                         
cQ := "SELECT SC6.R_E_C_N_O_ SC6_RECNO,SC5.R_E_C_N_O_ SC5_RECNO " + CRLF
cQ += "FROM " + RetSqlName("SC6") + " SC6 " + CRLF
cQ += "JOIN " + RetSqlName("SC5") + " SC5 " + CRLF
cQ += "ON SC5.D_E_L_E_T_ = ' ' " + CRLF
cQ += "AND C5_FILIAL = C6_FILIAL " + CRLF
cQ += "AND C5_NUM = C6_NUM " + CRLF
cQ += "WHERE SC6.D_E_L_E_T_ = ' ' " + CRLF
cQ += "AND C6_FILIAL = '" + xFilial("SC6") + "' " + CRLF
cQ += "AND C6_NUM = '" + cPedido + "' " + CRLF
//cQ += "AND C6_ITEM = '" + cItem + "' " + CRLF
//cQ += "AND C6_NUM IN "+FormatIn(cPedido,"/")+" " + CRLF     
cQ += "AND (C6_BLQ = 'R ' " + CRLF
cQ += "OR C6_ZBLQ = 'S') " + CRLF // foi bloqueado pela rotina especifica que bloqueia no momento do faturamento, os itens de pedidos com saldo desta nota
cQ += "ORDER BY C6_FILIAL,C6_NUM "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

Begin Transaction

While (cAliasTrb)->(!Eof())
	SC6->(dbGoto((cAliasTrb)->SC6_RECNO))
	SC5->(dbGoto((cAliasTrb)->SC5_RECNO))
	If SC6->(Recno()) == (cAliasTrb)->SC6_RECNO .and. SC5->(Recno()) == (cAliasTrb)->SC5_RECNO
		If Empty(SC6->C6_NOTA) .or. Alltrim(SC6->C6_NOTA) == Alltrim(SD2->D2_DOC)//Linha Adicionada para caso haja duas notas para o mesmo Pedido de Venda 
			//[2] Estorno  do Pedido de Venda
			MaAvalSC6("SC6"/*cAliasSC6*/,2,"SC5"/*cAliasSC5*/,/*lLiber*/,/*lTransf*/,/*lLiberOk*/,/*lResidOk*/,/*lFaturOk*/,.T./*lAcumulado*/,/*@nVlrCred*/,/*cAliasSD2*/,/*lRemito*/,/*nMoeda*/)
			SC6->(RecLock("SC6",.F.))
			SC6->C6_BLQ := ""
			SC6->C6_ZBLQ := ""
			SC6->(MsUnLock())
			//[1] Implantacao do Pedido de Venda
			MaAvalSC6("SC6"/*cAliasSC6*/,1,"SC5"/*cAliasSC5*/,/*lLiber*/,/*lTransf*/,/*lLiberOk*/,/*lResidOk*/,/*lFaturOk*/,.T./*lAcumulado*/,/*@nVlrCred*/,/*cAliasSD2*/,/*lRemito*/,/*nMoeda*/)
			If aScan(aPedAlt,SC6->C6_NUM) == 0
				aAdd(aPedAlt,SC6->C6_NUM)
			Endif
		EndIf	
	Endif	
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())

If Len(aPedAlt) > 0
	SC5->(dbSetOrder(1))
	For nCnt:=1 To Len(aPedAlt)
		If SC5->(dbSeek(xFilial("SC5")+aPedAlt[nCnt]))
			MaLiberOk({SC5->C5_NUM},.T.)
		Endif
	Next	
Endif

End Transaction				

aEval(aArea,{|x| RestArea(x)})

Return()