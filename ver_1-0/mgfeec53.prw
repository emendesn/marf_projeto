#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC53
Autor...............: Totvs
Data................: Junho/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada EECAP100
Doc. Origem.........: Comex
Solicitante.........: Cliente
Uso.................: 
Obs.................: Limpar campos usados no GAP FIS45 durante a copia do pedido e setar variavel public para uso no PE EECPEM44
=====================================================================================
*/
User Function MGFEEC53()

Local aArea := {GetArea()}
Local lRet := .T.
Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
Local lCapa := .F.
Local lItens := .F.
Local aAreaWorkIt := {}
Local aProd := {}

If IsInCallStack("EECAP100") .and. IsInCallStack("AP100CopyFrom") .and. cParam == "PE_COPYPED"// .and. Type("__lVldCopia") != "U"
	If nOpcAux == 3 // incluir
		lCapa := ParamIxb[2]
		lItens := ParamIxb[3]
		If lItens
			aAreaWorkIt := WorkIt->(GetArea())
			// verifica se integra com taura	
			If GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+M->EE7_ZTIPPE,1,"") == "S"
				WorkIt->(dbGotop())
				While WorkIt->(!Eof())
					If !Empty(WorkIt->EE8_ZTESSI) .or. !Empty(WorkIt->EE8_ZQTDSI) .or. WorkIt->EE8_ZGERSI == "S" 
						//__lVldCopia := .F.
						APMsgAlert("Pedido tem produtos iguais em itens diferentes."+CRLF+;
						"Nao sera possivel copiar este pedido."+CRLF+;
						"Favor cancelar este pedido e escolher outro pedido para copia.")
						Exit
					Endif	
					// valida produtos iguais no pedido que integra com o taura, nao pode ocorrer esta situacao
					If aScan(aProd,WorkIt->EE8_COD_I) > 0
						APMsgAlert("Pedido tem produtos iguais em itens diferentes."+CRLF+;
						"Nao sera possivel copiar este pedido."+CRLF+;
						"Favor cancelar este pedido e escolher outro pedido para copia.")
						Exit
					Endif
					aAdd(aProd,WorkIt->EE8_COD_I)
					WorkIt->(dbSkip())
				Enddo
			Endif	
			
			//If __lVldCopia
				WorkIt->(dbGotop())
				While WorkIt->(!Eof())
					If !Empty(WorkIt->EE8_ZTESSI) .or. !Empty(WorkIt->EE8_ZCFOSI) .or. !Empty(WorkIt->EE8_ZQTDSI) .or. !Empty(WorkIt->EE8_ZGERSI) .or. !Empty(WorkIt->EE8_ZQTDHI)
						WorkIt->(RecLock("Workit",.F.))
				 		WorkIt->EE8_ZTESSI := ""
				 		WorkIt->EE8_ZCFOSI := ""
				 		WorkIt->EE8_ZQTDSI := 0
				 		WorkIt->EE8_ZGERSI := "" 
				 		WorkIt->EE8_ZQTDHI := 0
			 			WorkIt->(MsUnLock())
			 		Endif	
					WorkIt->(dbSkip())
				Enddo
			//Endif
			WorkIt->(RestArea(aAreaWorkIt))
		Endif			
	Endif
Endif		
				
aEval(aArea,{|x| RestArea(x)})

Return(lRet)