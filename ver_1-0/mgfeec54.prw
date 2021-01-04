#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC54
Autor...............: Totvs
Data................: Junho/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada EECPEM44
Doc. Origem.........: Comex
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verificar se eh possivel realizar a copia do pedido
=====================================================================================
*/
User Function MGFEEC54()

Local lRet := .T.
Local aAreaWorkIt := {}
Local aProd := {}	

If lRet
	// rotina de importacao de ordem de embarque
	If !(IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP"))
		// rotina de exclusao de nota de saida, desfaz fis45
		If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
			// verifica se integra com taura	
			If GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+M->EE7_ZTIPPE,1,"") == "S"
				aAreaWorkIt := WorkIt->(GetArea())
				WorkIt->(dbGotop())
				While WorkIt->(!Eof())
					If !Empty(WorkIt->EE8_ZTESSI) .or. !Empty(WorkIt->EE8_ZQTDSI) .or. WorkIt->EE8_ZGERSI == "S" 
						lRet := .F.
						APMsgAlert("Pedido tem produtos iguais em itens diferentes."+CRLF+;
						"Nao sera possivel copiar este pedido."+CRLF+;
						"Favor cancelar este pedido e escolher outro pedido para copia.")
						Exit
					Endif	
					// valida produtos iguais no pedido que integra com o taura, nao pode ocorrer esta situacao
					If aScan(aProd,WorkIt->EE8_COD_I) > 0
						lRet := .F.
						APMsgAlert("Pedido tem produtos iguais em itens diferentes."+CRLF+;
						"Nao sera possivel copiar este pedido."+CRLF+;
						"Favor cancelar este pedido e escolher outro pedido para copia.")
						Exit
					Endif
					aAdd(aProd,WorkIt->EE8_COD_I)
					WorkIt->(dbSkip())
				Enddo
				WorkIt->(RestArea(aAreaWorkIt))
			Endif
		Endif		
	Endif
Endif		

Return(lRet)