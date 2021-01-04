#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM88
Autor...............: Totvs
Data................: Junho/2018 
Descricao / Objetivo: Rotina chamada pelo PE M020EXC
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Exclusao dos dados da grade de aprovacao
=====================================================================================
@alteracoes 17/10/2019 - Henrique Vidal
	Alterada funcao MGFCOM88 
	RTASK0010137 - Apaga grade de aprovacao, apos exclusao do cadastro.
	Cenario anterior:
	 - Apaga quando a grade estiver pendente.
	 - S� apagava cadastro de fornecedor. 

	Cenario atual: Cenario anr
	 - S� devera apagar quando a grade estiver pendente e for do tipo inclusao. (Cadastro tiver acabdo de ser incluso e nao aprovado.)
     - Alterado chamada para todos os tipos de cadastro, recebe a ctab como referencia. 
*/
User Function MGFCOM88(cTab)

Local aArea := {GetArea()}
Local cQ := ""
Local cAliasTrb := GetNextAlias()

cCad   := U_INT38_CAD(cTab)
// busca aprovacoes pendentes para o fornecedor que foi deletado
cQ := "SELECT ZB1_ID "
cQ += "FROM "+RetSqlName("ZB1")+" ZB1 "
cQ += "WHERE ZB1_FILIAL = '"+xFilial("ZB1")+"' "
cQ += "AND ZB1_STATUS = '3' " // pendente
cQ += "AND ZB1_CAD    = '"+cCad+"' "
cQ += "AND ZB1_RECNO  = "+Alltrim(STR(&(cTab+'->(Recno())')))+" "
cQ += "AND D_E_L_E_T_ = ' ' "
cQ += "AND ZB1_TIPO = '1' "    
cQ += "GROUP BY ZB1_ID "
			
cQ := ChangeQuery(cQ)
			
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasTrb, .F., .T.)

ZB1->(dbSetOrder(1))
ZB2->(dbSetOrder(1))
ZB3->(dbSetOrder(1))
While (cAliasTrb)->(!Eof())
	If ZB1->(dbSeek((cAliasTrb)->ZB1_ID))
		While ZB1->(!Eof()) .and. (cAliasTrb)->ZB1_ID == ZB1->ZB1_ID
			ZB1->(RecLock("ZB1",.F.))
			ZB1->(dbDelete())
			ZB1->(MsUnLock())
			ZB1->(dbSkip())
		Enddo	
	Endif	
	If ZB2->(dbSeek((cAliasTrb)->ZB1_ID))
		While ZB2->(!Eof()) .and. (cAliasTrb)->ZB1_ID == ZB2->ZB2_ID
			ZB2->(RecLock("ZB2",.F.))
			ZB2->(dbDelete())
			ZB2->(MsUnLock())
			ZB2->(dbSkip())
		Enddo	
	Endif	
	If ZB3->(dbSeek((cAliasTrb)->ZB1_ID))
		While ZB3->(!Eof()) .and. (cAliasTrb)->ZB1_ID == ZB3->ZB3_ID
			ZB3->(RecLock("ZB3",.F.))
			ZB3->(dbDelete())
			ZB3->(MsUnLock())
			ZB3->(dbSkip())
		Enddo	
	Endif	
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())	
			
aEval(aArea,{|x| RestArea(x)})	

Return()