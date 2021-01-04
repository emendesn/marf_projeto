#INCLUDE 'PROTHEUS.CH'

/*
===========================================================================================
Programa.:              MGFFATAD
Autor....:              Totvs
Data.....:              Out/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada M410STTS
Doc. Origem:            MIT044
Solicitante:            
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFFATAD()

// rotina feita para contornar um problema do sistema estar deletando o registro da sc5 sem explicacao
// qdo este problema for solucionado, esta rotina deverah ser descompilada do RPO
// caso nao exista sc5 para o item em questao, todos os itens do pedido serao deletados.
Local aArea := {SC5->(GetArea()),SC6->(GetArea()),GetArea()}
Local cPed := SC6->C6_NUM
Local cAliasTrb := GetNextAlias()

If !GetMv("MGF_FATAD1",,.F.)
	Return()
Endif

// OBS: NAO COLOCAR O CAMPO D_E_L_E_T_ = ' ' NESTA QUERY, POIS NESTA SITUACAO ESPECIFICAMENTE DESTE FONTE, O SC5 NAO EXISTE MESMO, ELE NAO ESTAH DELETADO, SIMPLESMENTE NAO EXISTE
cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SC5")+" SC5 "
cQ += "WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
cQ += "AND C5_NUM = '"+SC6->C6_NUM+"' "

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQ),cAliasTrb,.F.,.T.)
If (cAliasTrb)->(Eof())

	SC6->(dbSetOrder(1))	
	If SC6->(dbSeek(xFilial("SC6")+cPed))
		While SC6->(!Eof()) .and. xFilial("SC6")+cPed == SC6->C6_FILIAL+SC6->C6_NUM
			MaAvalSC6("SC6",2,"SC5") // estorno do item do pv
			SC6->(RecLock("SC6",.F.))
			SC6->C6_OPC := "MGFFATAD" // marca este campo para indicar que foi deletado nesta rotina    
			SC6->(dbDelete())
			SC6->(MsUnLock())
			
			SC6->(dbSkip())
		Enddo	
		APMsgStop("Nao foi localizado o cabecalho deste pedido."+CRLF+;
		"Todos os itens do pedido serao excluidos."+CRLF+;
		"O Pedido deve ser redigitado."+CRLF+;
		"Informe o TI da Marfrig desta ocorrencia.")
	Endif	
Endif	

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})
	
Return()