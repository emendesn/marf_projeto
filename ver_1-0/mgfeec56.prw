#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC56
Autor...............: Totvs
Data................: Junho/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada EECAP100
Doc. Origem.........: Comex
Solicitante.........: Cliente
Uso.................: 
Obs.................: Valida exclusao de pedido de exportacao
=====================================================================================
*/
User Function MGFEEC56()

Local aArea := {GetArea()}
Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
Local lRet := .T.
Local cQ := ""
Local cAliasTrb := GetNextAlias()

// rotina de importacao de ordem de embarque
If !(IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP"))
	// rotina de exclusao de nota de saida, desfaz fis45
	If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
		// verifica se o pedido tem carga gerada
		If IsInCallStack("EECAP100") .and. cParam == "AP100MAN_INICIO"
			If nOpcAux == 5 .or. nOpcAux == 4
				// status faturado ou faturado parcial faz a validacao pelo padrao, pois nestes cenarios a solucao de excluir a carga via taura nao eh a correta, pois quando
				// o taura enviar a exclusao da carga, o protheus vai retornar que nao pode excluir a carga pois jah existem notas geradas para esta carga.
				// o correto nestes cenarios eh o padrao fazer as validacoes
				If !(EE7->EE7_STATUS == "C" .or. EE7->EE7_STATUS == "D") // faturado parcialmente / faturado
					cQ := "SELECT DAI_COD "
					cQ += "FROM "+RetSqlName("DAI")+" DAI, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZJ")+" SZJ "
					cQ += "WHERE DAI.D_E_L_E_T_ = ' ' "
					cQ += "AND SC5.D_E_L_E_T_ =	' ' "
					cQ += "AND SZJ.D_E_L_E_T_ =	' ' "
					cQ += "AND DAI_FILIAL = '"+EE7->EE7_FILIAL+"' "
					cQ += "AND DAI_FILIAL = C5_FILIAL "
					cQ += "AND ZJ_FILIAL = '"+xFilial("SZJ")+"' "
					cQ += "AND DAI_PEDIDO = C5_NUM "
					cQ += "AND C5_ZTIPPED = ZJ_COD "
					cQ += "AND ZJ_TAURA = 'S' "
					cQ += "AND C5_NUM = '"+EE7->EE7_PEDFAT+"' "		
				
					cQ := ChangeQuery(cQ)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)
				
					If (cAliasTrb)->(!Eof())
						lRet := .F.
						APMsgStop("Pedido integra com Taura e tem Carga gerada (Ordem de Embarque)."+CRLF+;
						"Carga: "+(cAliasTrb)->DAI_COD+CRLF+;
						"Solicite a exclusao da Ordem de Embarque pelo sistema Taura.")
					Endif		
					
					(cAliasTrb)->(dbCloseArea())	
				Endif
			Endif	
		Endif		
	Endif
Endif		
		
aEval(aArea,{|x| RestArea(x)})

Return(lRet)