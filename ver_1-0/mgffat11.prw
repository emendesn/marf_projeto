#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT11
Autor...............: Mauricio Gresele
Data................: 06/10/2016 
Descricao / Objetivo: Eliminar residuos de itens de pedidos nao entregues.
Doc. Origem.........: Faturamento - GAP FAT19
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gerar residuo dos itens do pedido que nao foram faturados
=====================================================================================
*/

// rotina chamada pelo ponto de entrada M460FIM
User Function MGFFAT11()

Local aArea := {SC9->(GetArea()),SC5->(GetArea()),SC6->(GetArea()),GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local aRecno := {}
Local nCnt := 0
Local aPedido := {}
                          
cQ := "SELECT DISTINCT(C6_NUM) C6_NUM "
cQ += "FROM "+RetSqlName("SC6")+" SC6 "
cQ += "INNER JOIN "+RetSqlName("SD2")+" SD2 "
cQ += "ON  C6_FILIAL = D2_FILIAL "
cQ += "AND C6_NUM = D2_PEDIDO "
cQ += "AND C6_ITEM = D2_ITEMPV "
cQ += "AND D2_FILIAL = '"+SF2->F2_FILIAL+"' "
cQ += "AND D2_SERIE = '"+SF2->F2_SERIE+"' "
cQ += "AND D2_DOC = '"+SF2->F2_DOC+"' "
cQ += "AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
cQ += "AND D2_LOJA = '"+SF2->F2_LOJA+"' "
cQ += "AND D2_TIPO = '"+SF2->F2_TIPO+"' "
cQ += "AND D2_EMISSAO = '"+dTos(SF2->F2_EMISSAO)+"' "
cQ += "AND D2_TIPO NOT IN ('D','B') "
cQ += "AND SD2.D_E_L_E_T_ = ' ' "
cQ += "INNER JOIN "+RetSqlName("SC5")+" SC5 "
cQ += "ON  C5_FILIAL = C6_FILIAL "
cQ += "AND C5_NUM = C6_NUM "
cQ += "AND SC5.D_E_L_E_T_ = ' ' "
cQ += "WHERE SC6.D_E_L_E_T_ = ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

While (cAliasTrb)->(!Eof())
	If aScan(aPedido,(cAliasTrb)->C6_NUM) == 0
		aAdd(aPedido,(cAliasTrb)->C6_NUM)
	Endif	
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())

SC6->(dbSetOrder(1))
SC9->(dbSetOrder(1))
For nCnt:=1 To Len(aPedido)
	If SC6->(dbSeek(xFilial("SC6")+aPedido[nCnt]))
		While SC6->(!Eof()) .and. xFilial("SC6")+aPedido[nCnt] == SC6->C6_FILIAL+SC6->C6_NUM
			// estorna sc9 caso tenha ficado algum registro
			If SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
				If !(SC9->C9_BLCRED=="10" .and. SC9->C9_BLEST=="10") .and. Empty(SC9->C9_NFISCAL)
					SC9->(A460Estorna())
				Endif
			Endif		

			If SC6->C6_QTDVEN > (SC6->C6_QTDEMP+SC6->C6_QTDENT) .and. (SC6->C6_BLQ <> 'R ' .or. SC6->C6_BLQ <> 'S ') // ficou saldo no pedido
				If aScan(aRecno,SC6->(Recno())) == 0 
					aAdd(aRecno,SC6->(Recno()))			
				Endif
			Endif	
			SC6->(dbSkip())
		Enddo
	Endif
Next				
	
Begin Transaction

For nCnt:=1 To Len(aRecno)
	SC6->(dbGoto(aRecno[nCnt]))
	If SC6->(Recno()) == aRecno[nCnt]
		If MaResDoFat(aRecno[nCnt],.F.,.F.,)
			SC6->(RecLock("SC6",.F.))
			SC6->C6_ZBLQ := "S"
			SC6->(MsUnLock())
		Endif	
	Endif
Next

If Len(aPedido) > 0
	SC5->(dbSetOrder(1))
	For nCnt:=1 To Len(aPedido)
		If SC5->(dbSeek(xFilial("SC5")+aPedido[nCnt]))
			MaLiberOk({SC5->C5_NUM},.T.)
		Endif
	Next	
Endif

End Transaction				

aEval(aArea,{|x| RestArea(x)})

Return()