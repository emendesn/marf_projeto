#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFEST34
Autor...............: Gresele
Data................: Nov/2017
Descrição / Objetivo: Rotina chamada pelo ponto de entrada MA650ENOT
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

/*
OBS:*************************************************************
ESTA ROTINA FOI CRIADA APENAS PARA SE RESOLVER UM PROBLEMA INTERMITENTE DO SISTEMA DE NAO DELETAR O REGISTRO DA TABELA SDC APOS DELETAR A OP, FICANDO DESTA FORMA
O EMPENHO GRAVADO INDEVIDAMENTE NA TABELA SBF, SEGUNDO O ANALISTA SEBA.
FOI ABERTO UM CHAMADO PARA SE FAZER A CORRECAO NO PADRAO DO SISTEMA.
ASSIM QUE ESTE CHAMADO FOR RESOLVIDO ESTE PONTO DE ENTRADA DEVE SER DESCOMPILADO E DELETADO DO RPO.
*/

User Function MGFEST34()
//ExecBlock("MA650ENOT",.F.,.F.,{cNum,cItem,cSeq})

Local aArea := {SDC->(GetArea()),SBF->(GetArea()),SC2->(GetArea()),SB8->(GetArea()),GetArea()}
Local cOp := ParamIxb[1]+ParamIxb[2]+ParamIxb[3]
Local cQ := ""
Local cAliasTrb := GetNextAlias()

cQ := "SELECT SDC.R_E_C_N_O_ SDC_RECNO "
cQ += "FROM "+RetSqlName("SDC")+" SDC "
cQ += "WHERE SDC.D_E_L_E_T_ = ' ' "
cQ += "AND DC_FILIAL = '"+xFilial("SDC")+"' "
cQ += "AND DC_ORIGEM = 'SC2' "
cQ += "AND "
cQ += "( "
cQ += "DC_OP = '"+cOp+"' "
cQ += "OR DC_OP = " // op´s excluidas e que tenham ficado empenho
cQ += "		(SELECT C2_NUM || C2_ITEM || C2_SEQUEN "
cQ += "		FROM "+RetSqlName("SC2")+" SC2 "
cQ += "		WHERE SC2.D_E_L_E_T_ = '*' " // OBS: somente op´s excluidas
cQ += "		AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQ += "		AND C2_NUM || C2_ITEM || C2_SEQUEN = DC_OP "
cQ += "		AND ROWNUM = 1) "
cQ += "OR DC_OP = " // op´s encerradas
cQ += "		(SELECT C2_NUM || C2_ITEM || C2_SEQUEN "
cQ += "		FROM "+RetSqlName("SC2")+" SC2 "
cQ += "		WHERE SC2.D_E_L_E_T_ = ' ' "
cQ += "		AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQ += "		AND C2_NUM || C2_ITEM || C2_SEQUEN = DC_OP "
cQ += "		AND C2_DATRF <> ' ') "
cQ += " ) "
cQ += "AND DC_QUANT <> 0 "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

SBF->(dbSetOrder(1)) //BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
SB8->(dbSetOrder(2)) //B8_FILIAL+B8_NUMLOTE+B8_LOTECTL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)
//SC2->(dbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD

While (cAliasTrb)->(!Eof())
	SDC->(dbGoto((cAliasTrb)->SDC_RECNO))
	If SDC->(Recno()) == (cAliasTrb)->SDC_RECNO
		/*
		If SC2->(dbSeek(xFilial("SC2") + SDC->DC_OP))
		If !empty(SC2->C2_DATRF)
		If !Empty(SDC->DC_LOCALIZ)
		If SBF->(dbSeek(xFilial("SBF") + SDC->(DC_LOCAL + DC_LOCALIZ + DC_PRODUTO + DC_NUMSERI + DC_LOTECTL + DC_NUMLOTE)))
		If !Empty(SBF->BF_EMPENHO)
		GravaBFEmp("-",SDC->DC_QUANT,TipoOP(cOp))
		Endif
		Endif
		EndIf
		
		If !Empty(SDC->DC_LOTECTL)
		If SB8->(dbSeek(xFilial("SB8") + SDC->(DC_NUMLOTE + DC_LOTECTL + DC_PRODUTO + DC_LOCAL) ))
		If !Empty(SB8->B8_EMPENHO)
		GravaB8Emp("-",SDC->DC_QUANT,TipoOP(cOp))
		EndIf
		EndIf
		EndIf
		
		RecLock( "SDC", .F. )
		SDC->( dbDelete())
		SDC->( MsUnlock())
		EndIf
		Else
		*/
		If !Empty(SDC->DC_LOCALIZ)
			If SBF->(dbSeek(xFilial("SBF") + SDC->(DC_LOCAL + DC_LOCALIZ + DC_PRODUTO + DC_NUMSERI + DC_LOTECTL + DC_NUMLOTE)))
				If !Empty(SBF->BF_EMPENHO)
					GravaBFEmp("-",SDC->DC_QUANT,TipoOP(cOp))
				Endif
			Endif
		EndIf
		
		If !Empty(SDC->DC_LOTECTL)
			If SB8->(dbSeek(xFilial("SB8") + SDC->(DC_NUMLOTE + DC_LOTECTL + DC_PRODUTO + DC_LOCAL) ))
				If !Empty(SB8->B8_EMPENHO)
					GravaB8Emp("-",SDC->DC_QUANT,TipoOP(cOp))
				EndIf
			EndIf
		EndIf
		
		SDC->(RecLock( "SDC", .F. ))
		SDC->(dbDelete())
		SDC->(MsUnlock())
		//EndIf
	Endif
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return()


Static Function TipoOp(cOP)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cTipoOP := ""

cQ := "SELECT C2_TPOP "
cQ += "FROM "+RetSqlName("SC2")+" SC2 "
//OBS: ler os registros ativos e deletados
//cQ += "WHERE SC2.D_E_L_E_T_ = '*' " // OBS: ESTA OP JAH ESTA DELETADA NESTE PONTO DE ENTRADA
cQ += "WHERE C2_FILIAL = '"+xFilial("SC2")+"' "
cQ += "AND C2_NUM || C2_ITEM || C2_SEQUEN = '"+cOP+"' "
cQ += "AND ROWNUM = 1 "
cQ += "ORDER BY R_E_C_N_O_ DESC "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

If (cAliasTrb)->(!Eof())
	cTipoOP := (cAliasTrb)->C2_TPOP
Endif

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return(cTipoOP)
