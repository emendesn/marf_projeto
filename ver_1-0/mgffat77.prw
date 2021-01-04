#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT77
Autor...............: Totvs
Data................: Junho/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada M410STTS
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: 
Obs.................: Forcar o envio do pedido sem regra de bloqueio na fila de envio ao Taura
=====================================================================================
*/
User Function MGFFAT77()

Local aArea := {GetArea()}

If Inclui .or. Altera
	If SC5->C5_ZBLQRGA == 'L'
		If PVSemRegra(SC5->C5_NUM)
			SC5->(recLock('SC5',.F.))
			SC5->C5_ZLIBENV := 'S'
			SC5->C5_ZTAUREE := 'S'
			SC5->(MsunLock())
		Endif	
	Endif
Endif

SC5->( recLock( 'SC5',.F. ) )
	SC5->C5_XINTEGR := 'P'
SC5->( msunLock() )

aEval(aArea,{|x| RestArea(x)})

Return()


// retorna pedidos sem nenhuma regra de bloqueio
Static Function PVSemRegra(cPedido)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local lRet := .F.

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SZV")+" SZV "
cQ += "WHERE ZV_FILIAL = '"+xFilial("SZV")+"' "
cQ += "AND ZV_PEDIDO = '"+cPedido+"' "
cQ += "AND D_E_L_E_T_ = ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.F.,.T.)

If (cAliasTrb)->(Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)
