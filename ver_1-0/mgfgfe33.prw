#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFGFE33
Autor...............: Totvs
Data................: Setembro/2018
Descricao / Objetivo: GFE
Doc. Origem.........: GFE
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de job de sicronizacao do GFE
=====================================================================================
*/
User Function MGFGFE33(aTab1)
	/*
	Local aMatriz := {"01","010001"}
	Local lIsBlind := IsBlind() .OR. Type("__LocalDriver") == "U"

	if lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])

	MGFGFE33Proc()

	RpcClearEnv()	
	EndIf

	Return()


	Static Function MGFGFE33Proc()
	*/
	//Local aArea := {GetArea()}
	//Local aTab := {"SA1","SA2","SA4","SF1","SF2","CC2","CT1","CTT","DA3","DA4","DAK","DUT"}
	Local aTab := {"SA1","SA2","DA3","DA4","SA4","CC2","DUT","CTT","CT1","DAK","SF2","SF1","GW1","ZBS"}
	Local nCnt := 0

	//Default aTab := {"SA1","SA2","DA3","DA4","SA4","CC2","DUT","CTT","CT1","DAK","SF2","SF1"}

	//IF LEN(ATAB1) > 0
	//	For nCnt:=1 To Len(aTab1)
	//		CONOUT(ATAB[NCNT])
	//	NEXT	
	//ELSE
	//	CONOUT("SEM PARAMENTROS")
	//ENDIF		


	For nCnt:=1 To Len(aTab)
		//IF NCNT != 2
		//	LOOP
		//ENDIF
		//IF NCNT > 9 
		//	EXIT
		//ENDIF	

		StartJob("U_GFE33Proc",GetEnvServer(),.F.,aTab[nCnt])
	Next

	//aEval(aArea,{|x| RestArea(x)})

Return()


User Function GFE33Proc(cTab)

	Local aMatriz := {"01","010001"}
	Local lIsBlind := IsBlind() .OR. Type("__LocalDriver") == "U"
	Local cAliasTrb := ""
	Local cAliasTrb1 := ""
	Local cQ := ""
	Local nCount := 0
	Local nTotal := 0
	Local cChave := ""
	Local cTime1 := ""
	Local cTime2 := ""
	Local nCnt := 0
	Local nVezes := 0
	Local lCalc := .T.

	If lIsBlind
		RpcSetType(3)
		RpcSetEnv(aMatriz[1],aMatriz[2],,,"GFE")
		//RpcSetEnv(cEmp,cFil,,,/*"FAT"*/,,{"SA2"},,,.T.)

		If !LockByName(ProcName()+"_"+cTab)
			Conout("JOB já em Execução : "+ProcName()+"_"+cTab+" - "+DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()
			Return()
		EndIf
	EndIf

	conOut("********************************************************************************************************************")
	conOut('Inicio do processamento - MGFGFE33 - Sincronização GFE - Tabela: '+cTab+' - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)

	cAliasTrb := GetNextAlias()
	cAliasTrb1 := GetNextAlias()

	If !cTab $ "SF1/SF2/SA2/ZBS"
		nVezes := 1
	Else
		nVezes := 2
	Endif		

	For nCnt:=1 To nVezes
		cQ := GFE33Filtro(cTab,nCnt)
		conout(cq)	
		nCount:=0

		If !Empty(cQ)
			//cQ := ChangeQuery(cQ) // obs: nao usar pois distorce a query
			MemoWrit("c:\temp\mgfgfe33.sql",cQ)

			cTime1 := Time()	
			Conout("mgfgfe33 - inicio query: "+cTab+" - "+DTOC(dDATABASE)+" - "+TIME())
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
			cTime2 := Time()
			Conout("mgfgfe33 - fim query: "+cTab+" - Tempo de processamento da query: "+ElapTime(cTime1,cTime2)+" - "+DTOC(dDATABASE)+" - "+TIME())

			/*
			dbSelectArea(cTab)
			dbSetOrder(1)
			While (cAliasTrb)->(!Eof())
			(cTab)->(dbGoto((cAliasTrb)->RECNO))
			If (cTab)->(Recno()) == (cAliasTrb)->RECNO
			CONOUT("cliente "+STR((cAliasTrb)->RECNO))
			nCount++
			//cEmpAnt := &((cTab)->(Subs(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL",1,2)))
			conout((cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"))
			If !Empty((cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"))
			cEmpAnt := Subs((cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"),1,2)
			conout(cempant)
			//cFilAnt := &((cTab)->(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"))
			cFilAnt := (cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL")
			conout(cfilant)
			Endif	
			OMSM011IPG(cTab)
			Endif	
			(cAliasTrb)->(dbSkip())
			Enddo	
			*/

			(cAliasTrb)->(dbGotop())
			(cAliasTrb)->(dbEval({ || nTotal++ },,{ || (cAliasTrb)->(!Eof()) } ))
			conOut("********************************************************************************************************************")
			Conout("mgfgfe33 - total de registros a processar ( nvez:"+Alltrim(Str(nCnt))+" ) Tabela: "+cTab+" - "+Alltrim(Str(nTotal))+" - "+dToc(dDataBase)+" - "+Time())
			conOut("********************************************************************************************************************")
			(cAliasTrb)->(dbGotop())

			dbSelectArea(cTab)
			dbSetOrder(1)
			While (cAliasTrb)->(!Eof())
				If cTab == "SA1"
					cChave := Alltrim((cAliasTrb)->A1_CGC)
					cQ := "SELECT SA1.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SA1")+" SA1 "
					cQ += "WHERE SA1.D_E_L_E_T_ = ' ' " 
					cQ += "AND A1_FILIAL = '"+(cAliasTrb)->A1_FILIAL+"' "
					If Len(Alltrim((cAliasTrb)->A1_CGC)) <= 8
						cQ += "AND TRIM(A1_COD) || TRIM(A1_LOJA) = '"+Alltrim((cAliasTrb)->A1_CGC)+"' "
					Else
						cQ += "AND TRIM(A1_CGC) = '"+Alltrim((cAliasTrb)->A1_CGC)+"' "
					Endif	
					//cQ += "AND TRIM(REPLACE(A1_NOME,CHR(39),CHR(32))) = '"+Alltrim(StrTran((cAliasTrb)->A1_NOME,"'"," ")) +"' "
					//cQ += "AND TRIM(REPLACE(A1_END,CHR(39),CHR(32))) = '"+Alltrim(StrTran((cAliasTrb)->A1_END,"'"," ")) +"' "
					cQ += "ORDER BY A1_FILIAL,A1_COD,A1_LOJA "
				Endif	

				If cTab == "SA2"
					cChave := Alltrim((cAliasTrb)->A2_CGC)
					cQ := "SELECT SA2.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SA2")+" SA2 "
					cQ += "WHERE SA2.D_E_L_E_T_ = ' ' "
					cQ += "AND A2_FILIAL = '"+(cAliasTrb)->A2_FILIAL+"' "				
					If Len(Alltrim((cAliasTrb)->A2_CGC)) <= 8
						cQ += "AND TRIM(A2_COD) || TRIM(A2_LOJA) = '"+Alltrim((cAliasTrb)->A2_CGC)+"' "
					Else
						cQ += "AND TRIM(A2_CGC) = '"+Alltrim((cAliasTrb)->A2_CGC)+"' "
					Endif	
					//cQ += "AND TRIM(REPLACE(A2_NOME,CHR(39),CHR(32))) = '"+Alltrim(StrTran((cAliasTrb)->A2_NOME,"'"," ")) +"' "
					//cQ += "AND TRIM(REPLACE(A2_END,CHR(39),CHR(32))) = '"+Alltrim(StrTran((cAliasTrb)->A2_END,"'"," ")) +"' "
					cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN (SELECT A2_LOJA FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD AND SA21.A2_LOJA = SA2.A2_LOJA) ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END) "
					//cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN A2_LOJA ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END)	"
					cQ += "ORDER BY A2_FILIAL,A2_COD,A2_LOJA "
				Endif

				If cTab == "DA3"
					cChave := Alltrim((cAliasTrb)->DA3_COD)
					cQ := "SELECT DA3.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("DA3")+" DA3 "
					cQ += "WHERE DA3.D_E_L_E_T_ = ' ' "
					cQ += "AND DA3_FILIAL = '"+(cAliasTrb)->DA3_FILIAL+"' "				
					cQ += "AND TRIM(DA3_COD) = '"+Alltrim((cAliasTrb)->DA3_COD)+"' "
					cQ += "ORDER BY DA3_FILIAL,DA3_COD "
				Endif

				If cTab == "DA4"
					cChave := Alltrim((cAliasTrb)->DA4_COD)
					cQ := "SELECT DA4.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("DA4")+" DA4 "
					cQ += "WHERE DA4.D_E_L_E_T_ = ' ' "
					cQ += "AND DA4_FILIAL = '"+(cAliasTrb)->DA4_FILIAL+"' "				
					cQ += "AND TRIM(DA4_COD) = '"+Alltrim((cAliasTrb)->DA4_COD)+"' "
					cQ += "ORDER BY DA4_FILIAL,DA4_COD "
				Endif

				If cTab == "SA4"
					cChave := Alltrim((cAliasTrb)->A4_CGC)
					cQ := "SELECT SA4.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SA4")+" SA4 "
					cQ += "WHERE SA4.D_E_L_E_T_ = ' ' " 
					cQ += "AND A4_FILIAL = '"+(cAliasTrb)->A4_FILIAL+"' "
					cQ += "AND TRIM(A4_CGC) = '"+Alltrim((cAliasTrb)->A4_CGC)+"' "
					cQ += "ORDER BY A4_FILIAL,A4_COD "
				Endif	

				If cTab == "CC2"
					cChave := Alltrim((cAliasTrb)->CC2_CODMUN)
					cQ := "SELECT CC2.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("CC2")+" CC2 "
					cQ += "WHERE CC2.D_E_L_E_T_ = ' ' "
					cQ += "AND CC2_FILIAL = '"+(cAliasTrb)->CC2_FILIAL+"' "				
					cQ += "AND CC2_EST = "+GFE33UF(Alltrim((cAliasTrb)->CC2_CODMUN))+" "
					cQ += "AND CC2_CODMUN = '"+Alltrim(Subs((cAliasTrb)->CC2_CODMUN,3))+"' "				
					cQ += "ORDER BY CC2_FILIAL,CC2_EST,CC2_CODMUN "
				Endif

				If cTab == "DUT"
					cChave := Alltrim((cAliasTrb)->DUT_TIPVEI)
					cQ := "SELECT DUT.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("DUT")+" DUT "
					cQ += "WHERE DUT.D_E_L_E_T_ = ' ' " 
					cQ += "AND DUT_FILIAL = '"+(cAliasTrb)->DUT_FILIAL+"' "
					cQ += "AND TRIM(DUT_TIPVEI) = '"+Alltrim((cAliasTrb)->DUT_TIPVEI)+"' "
					cQ += "ORDER BY DUT_FILIAL,DUT_TIPVEI "
				Endif	

				If cTab == "CTT"
					cChave := Alltrim((cAliasTrb)->CTT_CUSTO)
					cQ := "SELECT CTT.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("CTT")+" CTT "
					cQ += "WHERE CTT.D_E_L_E_T_ = ' ' " 
					cQ += "AND CTT_FILIAL = '"+(cAliasTrb)->CTT_FILIAL+"' "
					cQ += "AND TRIM(CTT_CUSTO) = '"+Alltrim((cAliasTrb)->CTT_CUSTO)+"' "
					cQ += "ORDER BY CTT_FILIAL,CTT_CUSTO "
				Endif	

				If cTab == "CT1"
					cChave := Alltrim((cAliasTrb)->CT1_CONTA)
					cQ := "SELECT CT1.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("CT1")+" CT1 "
					cQ += "WHERE CT1.D_E_L_E_T_ = ' ' " 
					cQ += "AND CT1_FILIAL = '"+(cAliasTrb)->CT1_FILIAL+"' "
					cQ += "AND TRIM(CT1_CONTA) = '"+Alltrim((cAliasTrb)->CT1_CONTA)+"' "
					cQ += "ORDER BY CT1_FILIAL,CT1_CONTA "
				Endif	

				If cTab == "DAK"
					cChave := Alltrim((cAliasTrb)->DAK_FILIAL)+Alltrim((cAliasTrb)->DAK_COD)
					cQ := "SELECT DAK.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("DAK")+" DAK "
					cQ += "WHERE DAK.D_E_L_E_T_ = ' ' " 
					cQ += "AND DAK_FILIAL = '"+(cAliasTrb)->DAK_FILIAL+"' "
					cQ += "AND TRIM(DAK_COD || DAK_SEQCAR) = '"+Alltrim((cAliasTrb)->DAK_COD)+"' "
					cQ += "ORDER BY DAK_FILIAL,DAK_COD "
				Endif	

				If cTab == "SF2" .and. nCnt == 1
					cChave := Alltrim((cAliasTrb)->F2_FILIAL)+Alltrim((cAliasTrb)->F2_SERIE)+Alltrim((cAliasTrb)->F2_DOC)+Alltrim((cAliasTrb)->F2_CGC)
					cQ := "SELECT SF2.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SF2")+" SF2 "
					cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 "
					cQ += "ON SA2.D_E_L_E_T_ = ' ' "
					cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "
					cQ += "AND F2_CLIENTE = A2_COD "
					cQ += "AND F2_LOJA = A2_LOJA "
					cQ += "WHERE SF2.D_E_L_E_T_ = ' ' "
					cQ += "AND F2_FILIAL = '"+(cAliasTrb)->F2_FILIAL+"' "				
					If Len(Alltrim((cAliasTrb)->F2_CGC)) <= 8
						cQ += "AND TRIM(A2_COD) || TRIM(A2_LOJA) = '"+Alltrim((cAliasTrb)->F2_CGC)+"' "
					Else
						cQ += "AND TRIM(A2_CGC) = '"+Alltrim((cAliasTrb)->F2_CGC)+"' "
					Endif	
					cQ += "AND TRIM(F2_SERIE) = '"+Alltrim((cAliasTrb)->F2_SERIE)+"' "
					cQ += "AND TRIM(F2_DOC) = '"+Alltrim((cAliasTrb)->F2_DOC)+"' "				
					cQ += "AND F2_TIPO IN ('D','B') "
					cQ += "ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,F2_CLIENTE,F2_LOJA "
				Endif

				If cTab == "SF2" .and. nCnt == 2
					cChave := Alltrim((cAliasTrb)->F2_FILIAL)+Alltrim((cAliasTrb)->F2_SERIE)+Alltrim((cAliasTrb)->F2_DOC)+Alltrim((cAliasTrb)->F2_CGC)
					cQ := "SELECT SF2.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SF2")+" SF2 "
					cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 "
					cQ += "ON SA1.D_E_L_E_T_ = ' ' "
					cQ += "AND A1_FILIAL = '"+xFilial("SA1")+"' "
					cQ += "AND F2_CLIENTE = A1_COD "
					cQ += "AND F2_LOJA = A1_LOJA "
					cQ += "WHERE SF2.D_E_L_E_T_ = ' ' "
					cQ += "AND F2_FILIAL = '"+(cAliasTrb)->F2_FILIAL+"' "				
					If Len(Alltrim((cAliasTrb)->F2_CGC)) <= 8
						cQ += "AND TRIM(A1_COD) || TRIM(A1_LOJA) = '"+Alltrim((cAliasTrb)->F2_CGC)+"' "
					Else
						cQ += "AND TRIM(A1_CGC) = '"+Alltrim((cAliasTrb)->F2_CGC)+"' "
					Endif	
					cQ += "AND TRIM(F2_SERIE) = '"+Alltrim((cAliasTrb)->F2_SERIE)+"' "
					cQ += "AND TRIM(F2_DOC) = '"+Alltrim((cAliasTrb)->F2_DOC)+"' "				
					cQ += "AND F2_TIPO NOT IN ('D','B','C','I','P') "
					cQ += "ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,F2_CLIENTE,F2_LOJA "
				Endif

				If cTab == "SF1" .and. nCnt == 1
					cChave := Alltrim((cAliasTrb)->F1_FILIAL)+Alltrim((cAliasTrb)->F1_SERIE)+Alltrim((cAliasTrb)->F1_DOC)+Alltrim((cAliasTrb)->F1_CGC)
					cQ := "SELECT SF1.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SF1")+" SF1 "
					cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 "
					cQ += "ON SA1.D_E_L_E_T_ = ' ' "
					cQ += "AND A1_FILIAL = '"+xFilial("SA1")+"' "
					cQ += "AND F1_FORNECE = A1_COD "
					cQ += "AND F1_LOJA = A1_LOJA "
					cQ += "WHERE SF1.D_E_L_E_T_ = ' ' "
					cQ += "AND F1_FILIAL = '"+(cAliasTrb)->F1_FILIAL+"' "				
					If Len(Alltrim((cAliasTrb)->F1_CGC)) <= 8
						cQ += "AND TRIM(A1_COD) || TRIM(A1_LOJA) = '"+Alltrim((cAliasTrb)->F1_CGC)+"' "
					Else
						cQ += "AND TRIM(A1_CGC) = '"+Alltrim((cAliasTrb)->F1_CGC)+"' "
					Endif	
					cQ += "AND TRIM(F1_SERIE) = '"+Alltrim((cAliasTrb)->F1_SERIE)+"' "
					cQ += "AND TRIM(F1_DOC) = '"+Alltrim((cAliasTrb)->F1_DOC)+"' "				
					cQ += "AND F1_TIPO IN ('D','B') "
					cQ += "ORDER BY F1_FILIAL,F1_SERIE,F1_DOC,F1_FORNECE,F1_LOJA "
				Endif

				If cTab == "SF1" .and. nCnt == 2
					cChave := Alltrim((cAliasTrb)->F1_FILIAL)+Alltrim((cAliasTrb)->F1_SERIE)+Alltrim((cAliasTrb)->F1_DOC)+Alltrim((cAliasTrb)->F1_CGC)
					cQ := "SELECT SF1.R_E_C_N_O_ RECNO "
					cQ += "FROM "+RetSqlName("SF1")+" SF1 "
					cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 "
					cQ += "ON SA2.D_E_L_E_T_ = ' ' "
					cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "
					cQ += "AND F1_FORNECE = A2_COD "
					cQ += "AND F1_LOJA = A2_LOJA "
					cQ += "WHERE SF1.D_E_L_E_T_ = ' ' "
					cQ += "AND F1_FILIAL = '"+(cAliasTrb)->F1_FILIAL+"' "
					If Len(Alltrim((cAliasTrb)->F1_CGC)) <= 8
						cQ += "AND TRIM(A2_COD) || TRIM(A2_LOJA) = '"+Alltrim((cAliasTrb)->F1_CGC)+"' "
					Else
						cQ += "AND TRIM(A2_CGC) = '"+Alltrim((cAliasTrb)->F1_CGC)+"' "
					Endif	
					cQ += "AND TRIM(F1_SERIE) = '"+Alltrim((cAliasTrb)->F1_SERIE)+"' "
					cQ += "AND TRIM(F1_DOC) = '"+Alltrim((cAliasTrb)->F1_DOC)+"' "				
					cQ += "AND F1_TIPO NOT IN ('D','B','C','I','P') "
					cQ += "ORDER BY F1_FILIAL,F1_SERIE,F1_DOC,F1_FORNECE,F1_LOJA "
				Endif

				If cTab == "GW1"
					cChave := Alltrim((cAliasTrb)->TIPO)+Alltrim(STR((cAliasTrb)->RECNO))+Alltrim((cAliasTrb)->GW1CHVNFE)+Alltrim((cAliasTrb)->CHVNFE)
					cQ := "SELECT GW1.R_E_C_N_O_ RECNO FROM "+RetSqlName("GW1")+" GW1 "
					cQ += "WHERE R_E_C_N_O_ ="+Alltrim(STR((cAliasTrb)->RECNO))
				EndIf

				If cTab == "ZBS"
					cChave := Alltrim(STR((cAliasTrb)->RECNO))
					cQ := "SELECT ZBS.R_E_C_N_O_ RECNO FROM "+RetSqlName("ZBS")+" ZBS "
					cQ += "WHERE R_E_C_N_O_ ="+Alltrim(STR((cAliasTrb)->RECNO))
				EndIf

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb1,.T.,.T.)

				(cTab)->(dbGoto((cAliasTrb1)->RECNO))
				If (cTab)->(Recno()) == (cAliasTrb1)->RECNO
					Conout("mgfgfe33 - "+cTab+" - RECNO: "+Alltrim(Str((cAliasTrb1)->RECNO))+" - CHAVE: "+cChave)
					nCount++
					If !Empty((cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"))
						cEmpAnt := Subs((cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL"),1,2)
						If !cTab $ "DAK/SF1/SF2/GW1/ZBS" 
							Conout("mgfgfe33 - cEmpAnt: "+cEmpAnt)
						Endif	
						cFilAnt := (cTab)->&(IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_FILIAL")
						If !cTab $ "DAK/SF1/SF2/GW1/ZBS" 
							Conout("mgfgfe33 - cFilAnt: "+cFilAnt)
						Endif	
					Endif	
					If Empty(cEmpAnt)
						cEmpAnt := "01"
					Endif	
					If !cTab $ "SF1/SF2/GW1/ZBS" 
						OMSM011IPG(cTab)
					Elseif cTab == "SF2" 
						lCalc := .T.
						// nao processa documentos se encontrar o romaneio e estiver calculado
						GWN->(dbSetOrder(1))
						If GWN->(dbSeek(xFilial("GWN")+SF2->F2_CARGA+SF2->F2_SEQCAR))
							If GWN->GWN_CALC == "1" // 1 = romaneio calculado
								lCalc := .F.
							Endif
						Endif
						If lCalc		
							OMSM011NFS("TODOS",,,cTab,"MATA461")
						Endif
					Elseif cTab == "SF1"
						OMSM011NFE("TODOS",,,cTab,"MATA103",,.T.)
					ElseIf cTab == "GW1"
						RecLock(cTab,.F.)
						(cTab)->GW1_DANFE := (cAliasTrb)->CHVNFE
						(cTab)->(MsUnlock())
					ElseIf cTab == "ZBS"
						RecLock(cTab,.F.)
						If nCnt == 1
							(cTab)->ZBS_TRANSP = (cAliasTrb)->A4_CGC
							(cTab)->ZBS_NOMCLI = (cAliasTrb)->NOMCLIFOR
							(cTab)->ZBS_NOMTRN = (cAliasTrb)->A4_NOME
							If (cAliasTrb)->ZBB_VALDES > 0
								(cTab)->ZBS_DESTOT = (cAliasTrb)->ZBB_VALDES 
								(cTab)->ZBS_DESCRA = (cAliasTrb)->CALC
							EndIf
						Else
							(cTab)->ZBS_TRANSP = (cAliasTrb)->A4_CGC
							(cTab)->ZBS_NOMCLI = (cAliasTrb)->NOMCLIFOR
							(cTab)->ZBS_NOMTRN = (cAliasTrb)->A4_NOME
							(cTab)->ZBS_SITUAC = "C" //Cancelado
						EndIf
						(cTab)->(MsUnlock())
					Endif
				Endif	
				(cAliasTrb1)->(dbCloseArea())
				(cAliasTrb)->(dbSkip())

				//IF nCount > 1000
				//EXIT
				//ENDIF	
			Enddo	

			conOut("********************************************************************************************************************")
			Conout("mgfgfe33 - total de registros ( nvez:"+Alltrim(Str(nCnt))+" ) processados: "+cTab+" - "+Alltrim(Str(nCount)))
			conOut("********************************************************************************************************************")		

			(cAliasTrb)->(dbCloseArea())
		Endif	
	Next

	conOut("********************************************************************************************************************")
	conOut('Final do processamento - MGFGFE33 - Sincronização GFE - Tabela: '+cTab+' - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)

	If lIsBlind
		UnLockByName(ProcName()+"_"+cTab)		
		RpcClearEnv()	
	Endif

Return()


Static Function GFE33Filtro(cTab,nVez)

	Local cQ := ""

	If cTab == "SA1"
		// clientes de exportacao e encontrados na gu3
		/*
		cQ := "SELECT SA1.R_E_C_N_O_ RECNO "+CRLF
		cQ += "FROM "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "	WHERE SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "	AND "+CRLF
		cQ += "	( "+CRLF
		cQ += "	A1_TIPO = 'X' "+CRLF
		cQ += "	AND EXISTS "+CRLF
		cQ += "		( "+CRLF
		cQ += "		SELECT 1 "+CRLF
		cQ += "		FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "			WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "			AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF
		cQ += "			AND TRIM(GU3_CDEMIT) = TRIM(A1_COD) || TRIM(A1_LOJA) "+CRLF
		cQ += GFE33CmpSA1()
		cQ += "		) "+CRLF
		cQ += "	) "+CRLF 
		cQ += "ORDER BY SA1.R_E_C_N_O_ "//A1_FILIAL,A1_COD,A1_LOJA "
		*/
		/*
		cQ := "SELECT RECNO FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT SA1.R_E_C_N_O_ RECNO "+CRLF
		cQ += "FROM "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "RIGHT JOIN "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "	ON GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "	AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF
		cQ += GFE33CmpSA1()
		cQ += "	WHERE SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "	AND TRIM(A1_COD) || TRIM(A1_LOJA) = TRIM(GU3_CDEMIT) "+CRLF
		cQ += "	AND A1_TIPO = 'X' "+CRLF
		CQ += "AND SA1.R_E_C_N_O_ = 4820 "

		cQ += "UNION "+CRLF

		cQ += "SELECT SA1.R_E_C_N_O_ RECNO "+CRLF
		cQ += "FROM "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "RIGHT JOIN "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "	ON GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "	AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF
		cQ += GFE33CmpSA1()
		cQ += "	WHERE SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "	AND TRIM(A1_CGC) = TRIM(GU3_CDEMIT) "+CRLF
		cQ += "	AND A1_TIPO <> 'X' "+CRLF
		CQ += "AND SA1.R_E_C_N_O_ = 4820 "

		cQ += ") "+CRLF

		cQ += "ORDER BY RECNO "//A1_FILIAL,A1_COD,A1_LOJA "
		*/

		cQ := "SELECT "+CRLF
		//cQ += "A1_FILIAL,A1_CGC,A1_NOME,A1_END "+CRLF
		cQ += "A1_FILIAL,A1_CGC "+CRLF	
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "A1_FILIAL "+CRLF
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN TRIM(A1_CGC) ELSE TRIM(A1_COD) || TRIM(A1_LOJA) END) A1_CGC "+CRLF
		/*
		cQ += ",TRIM(A1_NOME) A1_NOME "+CRLF
		cQ += ",TRIM(A1_NREDUZ) "+CRLF
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_PESSOA ELSE 'X' END) "+CRLF
		cQ += ",TRIM(A1_DTNASC) "+CRLF
		cQ += ",'1' "+CRLF
		cQ += ",TRIM(A1_END) A1_END "+CRLF
		cQ += ",TRIM(A1_COMPLEM) "+CRLF
		cQ += ",TRIM(A1_BAIRRO) "+CRLF 
		cQ += ",TRIM(A1_CEP) "+CRLF
		cQ += ","+GFE33Cidade("SA1")+CRLF
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_CGC ELSE ' ' END) "+CRLF
		cQ += ",TRIM(A1_INSCR) "+CRLF
		cQ += ",TRIM(A1_INSCRM) "+CRLF
		cQ += ",TRIM(SUBSTR(A1_CXPOSTA,1,10)) "+CRLF
		cQ += ",TRIM(A1_EMAIL) "+CRLF
		cQ += ",TRIM(A1_TEL) "+CRLF
		cQ += ",TRIM(A1_FAX) "+CRLF
		cQ += ",TRIM(A1_HPAGE) "+CRLF
		cQ += ",'2' "+CRLF
		*/
		//cQ += ",TRIM(CASE WHEN A1_MSBLQL = '1' THEN '2' ELSE '1' END) "+CRLF
		cQ += "FROM "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "WHERE SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF	
		//	cQ += "AND A1_TIPO <> 'X' "+CRLF
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU3_FILIAL "+CRLF
		cQ += ",TRIM(GU3_CDEMIT) "+CRLF
		/*
		cQ += ",TRIM(GU3_NMEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMFAN) "+CRLF
		cQ += ",TRIM(GU3_NATUR) "+CRLF
		cQ += ",TRIM(GU3_DTNASC) "+CRLF
		cQ += ",TRIM(GU3_CLIEN) "+CRLF
		cQ += ",TRIM(GU3_ENDER) "+CRLF
		cQ += ",TRIM(GU3_COMPL) "+CRLF
		cQ += ",TRIM(GU3_BAIRRO) "+CRLF
		cQ += ",TRIM(GU3_CEP) "+CRLF
		cQ += ",TRIM(GU3_NRCID) "+CRLF
		cQ += ",TRIM(GU3_IDFED) "+CRLF
		cQ += ",TRIM(GU3_IE) "+CRLF
		cQ += ",TRIM(GU3_IM) "+CRLF
		cQ += ",TRIM(GU3_CXPOS) "+CRLF
		cQ += ",TRIM(GU3_EMAIL) "+CRLF
		cQ += ",TRIM(GU3_FONE1) "+CRLF
		cQ += ",TRIM(GU3_FAX) "+CRLF
		cQ += ",TRIM(GU3_WSITE) "+CRLF
		cQ += ",TRIM(GU3_ORIGEM) "+CRLF
		*/
		//cQ += ",TRIM(GU3_SIT) "+CRLF
		cQ += "FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF	
		cQ += "AND GU3_CLIEN = '1' "+CRLF	
		//	cQ += "AND LENGTH(TRIM(GU3_CDEMIT)) > 8 "+CRLF
		cQ += ") "+CRLF
		/*
		cQ += "UNION "+CRLF

		cQ += "SELECT "+CRLF
		cQ += "A1_CGC,A1_NOME,A1_END "+CRLF
		cQ += "FROM ( "+CRLF
		cQ += "SELECT TRIM(A1_COD) || TRIM(A1_LOJA) A1_CGC "+CRLF	
		cQ += ",TRIM(A1_NOME) A1_NOME "+CRLF
		cQ += ",TRIM(A1_NREDUZ) "+CRLF
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_PESSOA ELSE 'X' END) "+CRLF
		cQ += ",TRIM(A1_DTNASC) "+CRLF
		cQ += ",'1' "+CRLF
		cQ += ",TRIM(A1_END) A1_END "+CRLF
		cQ += ",TRIM(A1_COMPLEM) "+CRLF
		cQ += ",TRIM(A1_BAIRRO) "+CRLF 
		cQ += ",TRIM(A1_CEP) "+CRLF
		cQ += ","+GFE33Cidade("SA1")+CRLF
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_CGC ELSE ' ' END) "+CRLF
		cQ += ",TRIM(A1_INSCR) "+CRLF
		cQ += ",TRIM(A1_INSCRM) "+CRLF
		cQ += ",TRIM(SUBSTR(A1_CXPOSTA,1,10)) "+CRLF
		cQ += ",TRIM(A1_EMAIL) "+CRLF
		cQ += ",TRIM(A1_TEL) "+CRLF
		cQ += ",TRIM(A1_FAX) "+CRLF
		cQ += ",TRIM(A1_HPAGE) "+CRLF
		cQ += ",'2' "+CRLF
		//	cQ += ",TRIM(CASE WHEN A1_MSBLQL = '1' THEN '2' ELSE '1' END) "+CRLF
		cQ += "FROM "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "WHERE SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A1_TIPO = 'X' "+CRLF
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "TRIM(GU3_CDEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMFAN) "+CRLF
		cQ += ",TRIM(GU3_NATUR) "+CRLF
		cQ += ",TRIM(GU3_DTNASC) "+CRLF
		cQ += ",TRIM(GU3_CLIEN) "+CRLF
		cQ += ",TRIM(GU3_ENDER) "+CRLF
		cQ += ",TRIM(GU3_COMPL) "+CRLF
		cQ += ",TRIM(GU3_BAIRRO) "+CRLF
		cQ += ",TRIM(GU3_CEP) "+CRLF
		cQ += ",TRIM(GU3_NRCID) "+CRLF
		cQ += ",TRIM(GU3_IDFED) "+CRLF
		cQ += ",TRIM(GU3_IE) "+CRLF
		cQ += ",TRIM(GU3_IM) "+CRLF
		cQ += ",TRIM(GU3_CXPOS) "+CRLF
		cQ += ",TRIM(GU3_EMAIL) "+CRLF
		cQ += ",TRIM(GU3_FONE1) "+CRLF
		cQ += ",TRIM(GU3_FAX) "+CRLF
		cQ += ",TRIM(GU3_WSITE) "+CRLF
		cQ += ",TRIM(GU3_ORIGEM) "+CRLF
		//	cQ += ",TRIM(GU3_SIT) "+CRLF
		cQ += "FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU3_CLIEN = '1' "+CRLF	
		cQ += "AND LENGTH(TRIM(GU3_CDEMIT)) <= 8 "+CRLF
		cQ += ") "+CRLF
		*/
		//cQ += "ORDER BY A1_FILIAL,A1_CGC,A1_NOME,A1_END "+CRLF
		cQ += "ORDER BY A1_FILIAL,A1_CGC "+CRLF	
	Endif

	If cTab == "SA2" .and. nVez == 1
		cQ := "SELECT "+CRLF
		//cQ += "A2_FILIAL,A2_CGC,A2_NOME,A2_END "+CRLF
		cQ += "A2_FILIAL,A2_CGC "+CRLF	
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "A2_FILIAL "+CRLF
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN TRIM(A2_CGC) ELSE TRIM(A2_COD) || TRIM(A2_LOJA) END) A2_CGC "+CRLF
		/*
		cQ += ",TRIM(A2_NOME) A2_NOME "+CRLF
		cQ += ",TRIM(A2_NREDUZ) "+CRLF
		cQ += ",TRIM(A2_TIPO) "+CRLF
		cQ += ",'1' "+CRLF	
		cQ += ",TRIM(A2_END) A2_END "+CRLF
		cQ += ",TRIM(A2_COMPLEM) "+CRLF
		cQ += ",TRIM(A2_BAIRRO) "+CRLF 
		cQ += ",TRIM(A2_CEP) "+CRLF
		cQ += ","+GFE33Cidade("SA2")+CRLF
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN A2_CGC ELSE ' ' END) "+CRLF
		cQ += ",TRIM(A2_INSCR) "+CRLF
		cQ += ",TRIM(A2_INSCRM) "+CRLF
		cQ += ",TRIM(SUBSTR(A2_CX_POST,1,10)) "+CRLF
		cQ += ",TRIM(A2_EMAIL) "+CRLF
		cQ += ",TRIM(SUBSTR(A2_TEL,1,15)) "+CRLF
		cQ += ",TRIM(A2_FAX) "+CRLF
		cQ += ",TRIM(A2_HPAGE) "+CRLF
		cQ += ",'2' "+CRLF
		cQ += ",TRIM(A2_CONTRIB) "+CRLF
		cQ += ",TRIM(CASE WHEN A2_SIMPNAC = '1' THEN '2' ELSE '1' END) "+CRLF
		*/
		//cQ += ",TRIM(CASE WHEN A2_MSBLQL = '1' THEN '2' ELSE '1' END) "+CRLF	
		cQ += "FROM "+RetSqlName("SA2")+" SA2 "+CRLF
		cQ += "WHERE SA2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "+CRLF	
		//cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN A2_LOJA ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END) "+CRLF
		//cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN (SELECT A2_LOJA FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD AND SA21.A2_LOJA = SA2.A2_LOJA) ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END) "+CRLF
		//CQ += "AND A2_CGC = '00749574577' "
		//cQ += "AND ROWNUM <= 10000 "
		cQ += "AND A2_ZTPFORN <> '2' "
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU3_FILIAL "+CRLF
		cQ += ",TRIM(GU3_CDEMIT) "+CRLF
		/*
		cQ += ",TRIM(GU3_NMEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMFAN) "+CRLF
		cQ += ",TRIM(GU3_NATUR) "+CRLF
		cQ += ",TRIM(GU3_FORN) "+CRLF
		cQ += ",TRIM(GU3_ENDER) "+CRLF
		cQ += ",TRIM(GU3_COMPL) "+CRLF
		cQ += ",TRIM(GU3_BAIRRO) "+CRLF
		cQ += ",TRIM(GU3_CEP) "+CRLF
		cQ += ",TRIM(GU3_NRCID) "+CRLF
		cQ += ",TRIM(GU3_IDFED) "+CRLF
		cQ += ",TRIM(GU3_IE) "+CRLF
		cQ += ",TRIM(GU3_IM) "+CRLF
		cQ += ",TRIM(GU3_CXPOS) "+CRLF
		cQ += ",TRIM(GU3_EMAIL) "+CRLF
		cQ += ",TRIM(GU3_FONE1) "+CRLF
		cQ += ",TRIM(GU3_FAX) "+CRLF
		cQ += ",TRIM(GU3_WSITE) "+CRLF
		cQ += ",TRIM(GU3_ORIGEM) "+CRLF
		cQ += ",TRIM(GU3_CONICM) "+CRLF
		cQ += ",TRIM(GU3_TPTRIB) "+CRLF	
		*/
		//cQ += ",TRIM(GU3_SIT) "+CRLF	
		cQ += "FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF	
		cQ += "AND GU3_FORN = '1' "+CRLF	
		//	CQ += "AND GU3_CDEMIT = '00217160212' "	
		cQ += ") "+CRLF
		//cQ += "ORDER BY A2_FILIAL,A2_CGC,A2_NOME,A2_END "+CRLF
		cQ += "ORDER BY A2_FILIAL,A2_CGC "+CRLF	
	Endif

	If cTab == "SA2" .and. nVez == 2
		cQ := "SELECT "+CRLF
		//cQ += "A2_FILIAL,A2_CGC,A2_NOME,A2_END "+CRLF
		cQ += "A2_FILIAL,A2_CGC "+CRLF	
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "A2_FILIAL "+CRLF
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN TRIM(A2_CGC) ELSE TRIM(A2_COD) || TRIM(A2_LOJA) END) A2_CGC "+CRLF
		/*
		cQ += ",TRIM(A2_NOME) A2_NOME "+CRLF
		cQ += ",TRIM(A2_NREDUZ) "+CRLF
		cQ += ",TRIM(A2_TIPO) "+CRLF
		cQ += ",'1' "+CRLF	
		cQ += ",TRIM(A2_END) A2_END "+CRLF
		cQ += ",TRIM(A2_COMPLEM) "+CRLF
		cQ += ",TRIM(A2_BAIRRO) "+CRLF 
		cQ += ",TRIM(A2_CEP) "+CRLF
		cQ += ","+GFE33Cidade("SA2")+CRLF
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN A2_CGC ELSE ' ' END) "+CRLF
		cQ += ",TRIM(A2_INSCR) "+CRLF
		cQ += ",TRIM(A2_INSCRM) "+CRLF
		cQ += ",TRIM(SUBSTR(A2_CX_POST,1,10)) "+CRLF
		cQ += ",TRIM(A2_EMAIL) "+CRLF
		cQ += ",TRIM(SUBSTR(A2_TEL,1,15)) "+CRLF
		cQ += ",TRIM(A2_FAX) "+CRLF
		cQ += ",TRIM(A2_HPAGE) "+CRLF
		cQ += ",'2' "+CRLF
		cQ += ",TRIM(A2_CONTRIB) "+CRLF
		cQ += ",TRIM(CASE WHEN A2_SIMPNAC = '1' THEN '2' ELSE '1' END) "+CRLF 
		*/
		//cQ += ",TRIM(CASE WHEN A2_MSBLQL = '1' THEN '2' ELSE '1' END) "+CRLF	
		cQ += "FROM "+RetSqlName("SA2")+" SA2 "+CRLF
		cQ += "WHERE SA2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "+CRLF	
		cQ += "AND A2_LOJA = (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) "+CRLF
		//cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN A2_LOJA ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END) "+CRLF
		//cQ += "AND A2_LOJA = (CASE WHEN A2_ZTPFORN <> '2' THEN (SELECT A2_LOJA FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD AND SA21.A2_LOJA = SA2.A2_LOJA) ELSE (SELECT MAX(A2_LOJA) FROM "+RetSqlName("SA2")+" SA21 WHERE SA21.D_E_L_E_T_ = ' ' AND SA21.A2_COD = SA2.A2_COD) END) "+CRLF
		//CQ += "AND A2_CGC = '00749574577' "
		//cQ += "AND ROWNUM <= 10000 "
		cQ += "AND A2_ZTPFORN = '2' "
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU3_FILIAL "+CRLF
		cQ += ",TRIM(GU3_CDEMIT) "+CRLF
		/*
		cQ += ",TRIM(GU3_NMEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMFAN) "+CRLF
		cQ += ",TRIM(GU3_NATUR) "+CRLF
		cQ += ",TRIM(GU3_FORN) "+CRLF
		cQ += ",TRIM(GU3_ENDER) "+CRLF
		cQ += ",TRIM(GU3_COMPL) "+CRLF
		cQ += ",TRIM(GU3_BAIRRO) "+CRLF
		cQ += ",TRIM(GU3_CEP) "+CRLF
		cQ += ",TRIM(GU3_NRCID) "+CRLF
		cQ += ",TRIM(GU3_IDFED) "+CRLF
		cQ += ",TRIM(GU3_IE) "+CRLF
		cQ += ",TRIM(GU3_IM) "+CRLF
		cQ += ",TRIM(GU3_CXPOS) "+CRLF
		cQ += ",TRIM(GU3_EMAIL) "+CRLF
		cQ += ",TRIM(GU3_FONE1) "+CRLF
		cQ += ",TRIM(GU3_FAX) "+CRLF
		cQ += ",TRIM(GU3_WSITE) "+CRLF
		cQ += ",TRIM(GU3_ORIGEM) "+CRLF
		cQ += ",TRIM(GU3_CONICM) "+CRLF
		cQ += ",TRIM(GU3_TPTRIB) "+CRLF	
		*/
		//cQ += ",TRIM(GU3_SIT) "+CRLF	
		cQ += "FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF	
		cQ += "AND GU3_FORN = '1' "+CRLF	
		//	CQ += "AND GU3_CDEMIT = '00217160212' "	
		cQ += ") "+CRLF
		//cQ += "ORDER BY A2_FILIAL,A2_CGC,A2_NOME,A2_END "+CRLF
		cQ += "ORDER BY A2_FILIAL,A2_CGC "+CRLF	
	Endif

	If cTab == "DA3"
		cQ := "SELECT "+CRLF
		cQ += "DA3_FILIAL,DA3_COD "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "DA3_FILIAL "+CRLF
		cQ += ",TRIM(DA3_COD) DA3_COD "+CRLF
		cQ += ",TRIM(DA3_TIPVEI) "+CRLF
		cQ += ",TRIM(DA3_PLACA) "+CRLF
		cQ += ",TRIM(DA3_ESTPLA) "+CRLF
		cQ += ",TRIM(CASE WHEN DA3_FROVEI = '1' THEN '2' ELSE '1' END) "+CRLF	
		cQ += ",TRIM(DA3_ALTEXT) "+CRLF
		cQ += ",TRIM(DA3_LAREXT) "+CRLF
		cQ += ",TRIM(DA3_COMEXT) "+CRLF 
		cQ += ",TRIM(DA3_VOLMAX) "+CRLF
		cQ += ",TRIM(DA3_CAPACM) "+CRLF
		//cQ += ",TRIM(DA3_CAPACN) "+CRLF
		//cQ += ",TRIM(DA3_TARA) "+CRLF
		//cQ += ",TRIM(DA3_DESC) "+CRLF
		//cQ += ",TRIM(DA3_ANOFAB) "+CRLF
		//cQ += ",TRIM(DA3_RENAVA) "+CRLF
		//cQ += ",TRIM(DA3_CIV) "+CRLF
		//cQ += ",TRIM(DA3_CIPP) "+CRLF
		//cQ += ",TRIM(DA3_ATIVO) "+CRLF
		//cQ += ",TRIM(CASE WHEN DA3_ATIVO = '1' THEN 'VEICULO ATIVO' ELSE 'VEICULO INATIVO' END) "+CRLF
		cQ += "FROM "+RetSqlName("DA3")+" DA3 "+CRLF
		cQ += "WHERE DA3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND DA3_FILIAL = '"+xFilial("DA3")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU8_FILIAL "+CRLF
		cQ += ",TRIM(GU8_CDVEIC) "+CRLF
		cQ += ",TRIM(GU8_CDTPVC) "+CRLF
		cQ += ",TRIM(GU8_PLACA) "+CRLF
		cQ += ",TRIM(GU8_UFPLAC) "+CRLF
		cQ += ",TRIM(GU8_TPPROP) "+CRLF
		cQ += ",TRIM(GU8_ALTUR) "+CRLF
		cQ += ",TRIM(GU8_LARGUR) "+CRLF
		cQ += ",TRIM(GU8_COMPRI) "+CRLF
		cQ += ",TRIM(GU8_VOLUT) "+CRLF
		cQ += ",TRIM(GU8_CARGUT) "+CRLF
		//cQ += ",TRIM(GU8_PBT) "+CRLF
		//cQ += ",TRIM(GU8_TARA) "+CRLF
		//cQ += ",TRIM(GU8_MMOD) "+CRLF
		//cQ += ",TRIM(GU8_ANOFAB) "+CRLF
		//cQ += ",TRIM(GU8_RENAVA) "+CRLF
		//cQ += ",TRIM(GU8_CIV) "+CRLF
		//cQ += ",TRIM(GU8_CIPP) "+CRLF
		//cQ += ",TRIM(GU8_SIT) "+CRLF
		//cQ += ",TRIM(GU8_DSSIT) "+CRLF
		cQ += "FROM "+RetSqlName("GU8")+" GU8 "+CRLF
		cQ += "WHERE GU8.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU8_FILIAL = '"+xFilial("GU8")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY DA3_FILIAL,DA3_COD "+CRLF
	Endif

	If cTab == "DA4"
		cQ := "SELECT "+CRLF
		cQ += "DA4_FILIAL,DA4_COD "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "DA4_FILIAL "+CRLF
		cQ += ",TRIM(DA4_COD) DA4_COD "+CRLF
		cQ += ",TRIM(DA4_NOME) "+CRLF
		cQ += ",TRIM(DA4_NREDUZ) "+CRLF
		cQ += ",TRIM(DA4_CGC) "+CRLF
		cQ += ",TRIM(DA4_RG) "+CRLF	
		cQ += ",TRIM(DA4_RGORG) "+CRLF
		//cQ += ",TRIM(DA4_NUMCNH) "+CRLF
		//cQ += ",TRIM(DA4_REGCNH) "+CRLF 
		//cQ += ",TRIM(DA4_DTECNH) "+CRLF
		//cQ += ",TRIM(DA4_DTVCNH) "+CRLF
		//cQ += ",TRIM(DA4_MUNCNH) "+CRLF
		//cQ += ",TRIM(DA4_ESTCNH) "+CRLF
		//cQ += ",TRIM(DA4_CATCNH) "+CRLF
		//cQ += ",TRIM(DA4_CARPER) "+CRLF
		cQ += ",TRIM(CASE WHEN DA4_BLQMOT = '1' THEN '2' ELSE '1' END) "+CRLF
		cQ += "FROM "+RetSqlName("DA4")+" DA4 "+CRLF
		cQ += "WHERE DA4.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND DA4_FILIAL = '"+xFilial("DA4")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GUU_FILIAL "+CRLF
		cQ += ",TRIM(GUU_CDMTR) "+CRLF
		cQ += ",TRIM(GUU_NMMTR) "+CRLF
		cQ += ",TRIM(GUU_PSEUD) "+CRLF
		cQ += ",TRIM(GUU_IDFED) "+CRLF
		cQ += ",TRIM(GUU_RG) "+CRLF
		cQ += ",TRIM(GUU_ORGEXP) "+CRLF
		//cQ += ",TRIM(GUU_NUMCNH) "+CRLF
		//cQ += ",TRIM(GUU_REGCNH) "+CRLF
		//cQ += ",TRIM(GUU_DTECNH) "+CRLF
		//cQ += ",TRIM(GUU_DTVCNH) "+CRLF
		//cQ += ",TRIM(GUU_MUNCNH) "+CRLF
		//cQ += ",TRIM(GUU_ESTCNH) "+CRLF
		//cQ += ",TRIM(GUU_CATCNH) "+CRLF
		//cQ += ",TRIM(GUU_MOPP) "+CRLF
		cQ += ",TRIM(GUU_SIT) "+CRLF
		cQ += "FROM "+RetSqlName("GUU")+" GUU "+CRLF
		cQ += "WHERE GUU.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GUU_FILIAL = '"+xFilial("GUU")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY DA4_FILIAL,DA4_COD "+CRLF
	Endif

	If cTab == "SA4"
		cQ := "SELECT "+CRLF
		cQ += "A4_FILIAL,A4_CGC "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "A4_FILIAL "+CRLF
		cQ += ",TRIM(A4_CGC) A4_CGC "+CRLF
		/*
		cQ += ",TRIM(A4_NOME) "+CRLF
		cQ += ",TRIM(A4_NREDUZ) "+CRLF
		cQ += ",TRIM(CASE WHEN A4_TPTRANS = '3' THEN 'F' ELSE 'J' END) "+CRLF
		cQ += ",TRIM(CASE WHEN A4_TPTRANS = '3' THEN '2' ELSE '1' END) "+CRLF	
		cQ += ",TRIM(CASE WHEN A4_TPTRANS = '3' THEN '1' ELSE '2' END) "+CRLF	
		cQ += ",TRIM(A4_END) "+CRLF	
		cQ += ",TRIM(A4_COMPLEM) "+CRLF
		cQ += ",TRIM(A4_BAIRRO) "+CRLF
		cQ += ",TRIM(A4_CEP) "+CRLF 
		cQ += ","+GFE33Cidade("SA4")+CRLF	
		//cQ += ",TRIM(A4_MUN) "+CRLF
		//cQ += ",TRIM(A4_EST) "+CRLF
		cQ += ",TRIM(A4_CGC) "+CRLF
		cQ += ",TRIM(A4_INSEST) "+CRLF
		cQ += ",TRIM(A4_EMAIL) "+CRLF
		cQ += ",TRIM(A4_TEL) "+CRLF
		cQ += ",TRIM(A4_HPAGE) "+CRLF	
		cQ += ",'2' "+CRLF		
		*/
		cQ += "FROM "+RetSqlName("SA4")+" SA4 "+CRLF
		cQ += "WHERE SA4.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A4_FILIAL = '"+xFilial("SA4")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU3_FILIAL "+CRLF
		cQ += ",TRIM(GU3_CDEMIT) "+CRLF
		/*
		cQ += ",TRIM(GU3_NMEMIT) "+CRLF
		cQ += ",TRIM(GU3_NMFAN) "+CRLF
		cQ += ",TRIM(GU3_NATUR) "+CRLF
		cQ += ",TRIM(GU3_TRANSP) "+CRLF
		cQ += ",TRIM(GU3_AUTON) "+CRLF
		cQ += ",TRIM(GU3_ENDER) "+CRLF
		cQ += ",TRIM(GU3_COMPL) "+CRLF
		cQ += ",TRIM(GU3_BAIRRO) "+CRLF
		cQ += ",TRIM(GU3_CEP) "+CRLF
		cQ += ",TRIM(GU3_NRCID) "+CRLF
		//cQ += ",TRIM(GU3_NMCID) "+CRLF
		//cQ += ",TRIM(GU3_UF) "+CRLF
		cQ += ",TRIM(GU3_IDFED) "+CRLF
		cQ += ",TRIM(GU3_IE) "+CRLF
		cQ += ",TRIM(GU3_EMAIL) "+CRLF
		cQ += ",TRIM(GU3_FONE1) "+CRLF
		cQ += ",TRIM(GU3_WSITE) "+CRLF
		cQ += ",TRIM(GU3_ORIGEM) "+CRLF
		*/
		cQ += "FROM "+RetSqlName("GU3")+" GU3 "+CRLF
		cQ += "WHERE GU3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU3_FILIAL = '"+xFilial("GU3")+"' "+CRLF	
		cQ += "AND (GU3_TRANSP = '1' OR GU3_AUTON = '1') "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY A4_FILIAL,A4_CGC "+CRLF
	Endif

	If cTab == "CC2"
		cQ := "SELECT "+CRLF
		cQ += "CC2_FILIAL,CC2_CODMUN "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "CC2_FILIAL "+CRLF
		cQ += ","+GFE33Cidade("CC2")+" CC2_CODMUN "+CRLF		
		cQ += ",TRIM(SUBSTR(CC2_MUN,1,50)) "+CRLF
		cQ += ",TRIM(CC2_EST) "+CRLF
		cQ += ",'105' "+CRLF
		cQ += "FROM "+RetSqlName("CC2")+" CC2 "+CRLF
		cQ += "WHERE CC2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND CC2_FILIAL = '"+xFilial("CC2")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GU7_FILIAL "+CRLF
		cQ += ",TRIM(GU7_NRCID) "+CRLF
		cQ += ",TRIM(GU7_NMCID) "+CRLF
		cQ += ",TRIM(GU7_CDUF) "+CRLF
		cQ += ",TRIM(GU7_CDPAIS) "+CRLF
		cQ += "FROM "+RetSqlName("GU7")+" GU7 "+CRLF
		cQ += "WHERE GU7.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GU7_FILIAL = '"+xFilial("GU7")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY CC2_FILIAL,CC2_CODMUN "+CRLF
	Endif

	If cTab == "DUT"
		cQ := "SELECT "+CRLF
		cQ += "DUT_FILIAL,DUT_TIPVEI "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "DUT_FILIAL "+CRLF
		cQ += ",TRIM(DUT_TIPVEI) DUT_TIPVEI "+CRLF
		cQ += ",TRIM(DUT_DESCRI) "+CRLF
		cQ += "FROM "+RetSqlName("DUT")+" DUT "+CRLF
		cQ += "WHERE DUT.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND DUT_FILIAL = '"+xFilial("DUT")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GV3_FILIAL "+CRLF
		cQ += ",TRIM(GV3_CDTPVC) "+CRLF
		cQ += ",TRIM(GV3_DSTPVC) "+CRLF
		cQ += "FROM "+RetSqlName("GV3")+" GV3 "+CRLF
		cQ += "WHERE GV3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GV3_FILIAL = '"+xFilial("GV3")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY DUT_FILIAL,DUT_TIPVEI "+CRLF
	Endif

	If cTab == "CTT"
		cQ := "SELECT "+CRLF
		cQ += "CTT_FILIAL,CTT_CUSTO "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "CTT_FILIAL "+CRLF
		cQ += ",TRIM(CTT_CUSTO) CTT_CUSTO "+CRLF
		cQ += ",TRIM(CTT_DESC01) "+CRLF
		cQ += "FROM "+RetSqlName("CTT")+" CTT "+CRLF
		cQ += "WHERE CTT.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND CTT_FILIAL = '"+xFilial("CTT")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GUH_FILIAL "+CRLF
		cQ += ",TRIM(GUH_CCUSTO) "+CRLF
		cQ += ",TRIM(GUH_DESC) "+CRLF
		cQ += "FROM "+RetSqlName("GUH")+" GUH "+CRLF
		cQ += "WHERE GUH.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GUH_FILIAL = '"+xFilial("GUH")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY CTT_FILIAL,CTT_CUSTO "+CRLF
	Endif

	If cTab == "CT1"
		cQ := "SELECT "+CRLF
		cQ += "CT1_FILIAL,CT1_CONTA "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "CT1_FILIAL "+CRLF
		cQ += ",TRIM(CT1_CONTA) CT1_CONTA "+CRLF
		cQ += ",TRIM(CT1_DESC01) "+CRLF
		cQ += "FROM "+RetSqlName("CT1")+" CT1 "+CRLF
		cQ += "WHERE CT1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND CT1_FILIAL = '"+xFilial("CT1")+"' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GUE_FILIAL "+CRLF
		cQ += ",TRIM(GUE_CTACTB) "+CRLF
		cQ += ",TRIM(GUE_TITULO) "+CRLF
		cQ += "FROM "+RetSqlName("GUE")+" GUE "+CRLF
		cQ += "WHERE GUE.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GUE_FILIAL = '"+xFilial("GUE")+"' "+CRLF	
		cQ += ") "+CRLF
		cQ += "ORDER BY CT1_FILIAL,CT1_CONTA "+CRLF
	Endif

	If cTab == "DAK"
		cQ := "SELECT "+CRLF
		cQ += "DAK_FILIAL,DAK_COD "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "DAK_FILIAL "+CRLF
		cQ += ",TRIM(DAK_COD || DAK_SEQCAR) DAK_COD "+CRLF
		/* executar somente para os romaneios que nao tem no gfe, pois a rotina padrao nao altera o romaneio, apenas inclui quando este nao existe
		cQ += ",'2' "+CRLF
		cQ += ",TRIM(DAK_MOTORI) "+CRLF	
		cQ += ",TRIM((SELECT DA3_TIPVEI "+CRLF	
		cQ += "FROM "+RetSqlName("DA3")+" DA3 "+CRLF
		cQ += "WHERE DA3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND DA3_FILIAL = '"+xFilial("DA3")+"' "+CRLF	
		cQ += "AND DA3_COD = DAK_CAMINH)) "+CRLF
		cQ += ",TRIM((SELECT DA3_PLACA "+CRLF	
		cQ += "FROM "+RetSqlName("DA3")+" DA3 "+CRLF
		cQ += "WHERE DA3.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND DA3_FILIAL = '"+xFilial("DA3")+"' "+CRLF	
		cQ += "AND DA3_COD = DAK_CAMINH)) "+CRLF
		cQ += ",TRIM((SELECT X6_CONTEUD "+CRLF	
		cQ += "FROM "+RetSqlName("SX6")+" SX6 "+CRLF
		cQ += "WHERE SX6.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND X6_VAR = 'MV_CDTPOP')) "+CRLF
		cQ += ",TRIM(NVL((SELECT A4_CGC "+CRLF	
		cQ += "FROM "+RetSqlName("SA4")+" SA4 "+CRLF
		cQ += "WHERE SA4.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A4_FILIAL = '"+xFilial("SA4")+"' "+CRLF	
		cQ += "AND A4_COD = DAK_TRANSP),' ')) "+CRLF
		cQ += ",TRIM(DAK_DATA) "+CRLF		
		cQ += ",TRIM(SUBSTR(DAK_HORA,1,5)) "+CRLF		
		*/
		cQ += "FROM "+RetSqlName("DAK")+" DAK "+CRLF
		cQ += "WHERE DAK.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GWN_FILIAL "+CRLF
		cQ += ",TRIM(GWN_NRROM) "+CRLF
		/*
		cQ += ",TRIM(GWN_ORI) "+CRLF
		cQ += ",TRIM(GWN_CDMTR) "+CRLF
		cQ += ",TRIM(GWN_CDTPVC) "+CRLF
		cQ += ",TRIM(GWN_PLACAD) "+CRLF
		cQ += ",TRIM(GWN_CDTPOP) "+CRLF
		cQ += ",TRIM(GWN_CDTRP) "+CRLF
		cQ += ",TRIM(GWN_DTIMPL) "+CRLF
		cQ += ",TRIM(GWN_HRIMPL) "+CRLF
		*/
		cQ += "FROM "+RetSqlName("GWN")+" GWN "+CRLF
		cQ += "WHERE GWN.D_E_L_E_T_ = ' ' "+CRLF
		cQ += ") "+CRLF
		cQ += "ORDER BY DAK_FILIAL,DAK_COD "+CRLF
	Endif

	If cTab == "SF2" .and. nVez == 1
		cQ := "SELECT "+CRLF
		cQ += "F2_FILIAL,F2_SERIE,F2_DOC,F2_CGC "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "F2_FILIAL "+CRLF
		cQ += ",TRIM(F2_SERIE) F2_SERIE "+CRLF
		cQ += ",TRIM(F2_DOC) F2_DOC "+CRLF	
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN TRIM(A2_CGC) ELSE TRIM(A2_COD) || TRIM(A2_LOJA) END) F2_CGC "+CRLF
		cQ += "FROM "+RetSqlName("SF2")+" SF2 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 "+CRLF
		cQ += "ON SA2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "+CRLF
		cQ += "AND F2_CLIENTE = A2_COD "+CRLF
		cQ += "AND F2_LOJA = A2_LOJA "+CRLF
		cQ += "WHERE SF2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND F2_TIPO IN ('D','B') "+CRLF
		cQ += "AND F2_TPFRETE = 'C' "+CRLF
		cQ += "AND F2_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_GFE332",,10))+"' "+CRLF
		cQ += "AND F2_FIMP = 'S' "+CRLF
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GW1_FILIAL "+CRLF
		cQ += ",TRIM(GW1_SERDC) "+CRLF
		cQ += ",TRIM(GW1_NRDC) "+CRLF
		cQ += ",TRIM(GW1_CDDEST) "+CRLF
		cQ += "FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GW1_CDTPDC = 'NFS' "+CRLF 
		cQ += "AND GW1_ORIGEM = '2' "+CRLF // origem ERP
		//cQ += "AND GW1_ORINR <> ' ' "+CRLF // indica que eh tipo B ou D
		//cQ += "AND GW1_ORISER <> ' ' "+CRLF
		cQ += ") "+CRLF
		cQ += "ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,F2_CGC "+CRLF
	Endif

	If cTab == "SF2" .and. nVez == 2
		cQ := "SELECT "+CRLF
		cQ += "F2_FILIAL,F2_SERIE,F2_DOC,F2_CGC "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "F2_FILIAL "+CRLF
		cQ += ",TRIM(F2_SERIE) F2_SERIE "+CRLF
		cQ += ",TRIM(F2_DOC) F2_DOC "+CRLF	
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN TRIM(A1_CGC) ELSE TRIM(A1_COD) || TRIM(A1_LOJA) END) F2_CGC "+CRLF
		cQ += "FROM "+RetSqlName("SF2")+" SF2 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "ON SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
		cQ += "AND F2_CLIENTE = A1_COD "+CRLF
		cQ += "AND F2_LOJA = A1_LOJA "+CRLF
		cQ += "WHERE SF2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND F2_TIPO NOT IN ('D','B','C','I','P') "+CRLF
		cQ += "AND F2_TPFRETE = 'C' "+CRLF
		cQ += "AND F2_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_GFE332",,10))+"' "+CRLF			
		cQ += "AND F2_FIMP = 'S' "+CRLF	
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GW1_FILIAL "+CRLF
		cQ += ",TRIM(GW1_SERDC) "+CRLF
		cQ += ",TRIM(GW1_NRDC) "+CRLF
		cQ += ",TRIM(GW1_CDDEST) "+CRLF
		cQ += "FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GW1_CDTPDC = 'NFS' "+CRLF 
		cQ += "AND GW1_ORIGEM = '2' "+CRLF // origem ERP
		cQ += "AND GW1_ORINR = ' ' "+CRLF // indica que eh tipo B ou D
		cQ += "AND GW1_ORISER = ' ' "+CRLF
		cQ += ") "+CRLF
		cQ += "ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,F2_CGC "+CRLF
	Endif

	If cTab == "SF1" .and. nVez == 1
		cQ := "SELECT "+CRLF
		cQ += "F1_FILIAL,F1_SERIE,F1_DOC,F1_CGC "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "F1_FILIAL "+CRLF
		cQ += ",TRIM(F1_SERIE) F1_SERIE "+CRLF
		cQ += ",TRIM(F1_DOC) F1_DOC "+CRLF	
		cQ += ",TRIM(CASE WHEN A1_TIPO <> 'X' THEN TRIM(A1_CGC) ELSE TRIM(A1_COD) || TRIM(A1_LOJA) END) F1_CGC "+CRLF
		cQ += "FROM "+RetSqlName("SF1")+" SF1 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
		cQ += "ON SA1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
		cQ += "AND F1_FORNECE = A1_COD "+CRLF
		cQ += "AND F1_LOJA = A1_LOJA "+CRLF
		cQ += "WHERE SF1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND F1_STATUS='A' "+CRLF
		cQ += "AND F1_TIPO IN ('D','B') "+CRLF
		//cQ += "AND F1_TPFRETE = 'F' "+CRLF
		If GetMv("MGF_FRSGFE",,.T.)
			cQ += "AND F1_TPFRETE NOT IN (' ','S') "+CRLF	
		Endif	
		cQ += "AND F1_ESPECIE IN ('SPED','NFP') "+CRLF
		cQ += "AND F1_ORIGLAN <> 'LF' "+CRLF
		//cQ += "AND F1_FORMUL <> 'S' "+CRLF
		//cQ += "AND F1_DTDIGIT >= '"+GetMv("MGF_DTSGFE",,"20180901")+"' "+CRLF
		cQ += "AND F1_DTDIGIT >= '"+dTos(dDataBase-GetMv("MGF_GFE331",,10))+"' "+CRLF			
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GW1_FILIAL "+CRLF
		cQ += ",TRIM(GW1_SERDC) "+CRLF
		cQ += ",TRIM(GW1_NRDC) "+CRLF
		cQ += ",TRIM(GW1_CDREM) "+CRLF
		cQ += "FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GW1_CDTPDC = 'NFE' "+CRLF 
		cQ += "AND GW1_ORIGEM = '2' "+CRLF // origem ERP
		//cQ += "AND GW1_ORINR <> ' ' "+CRLF // indica que eh tipo B ou D
		//cQ += "AND GW1_ORISER <> ' ' "+CRLF
		cQ += ") "+CRLF
		cQ += "ORDER BY F1_FILIAL,F1_SERIE,F1_DOC,F1_CGC "+CRLF
	Endif

	If cTab == "SF1" .and. nVez == 2
		cQ := "SELECT "+CRLF
		cQ += "F1_FILIAL,F1_SERIE,F1_DOC,F1_CGC "+CRLF
		cQ += "FROM "+CRLF
		cQ += "( "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "F1_FILIAL "+CRLF
		cQ += ",TRIM(F1_SERIE) F1_SERIE "+CRLF
		cQ += ",TRIM(F1_DOC) F1_DOC "+CRLF	
		cQ += ",TRIM(CASE WHEN A2_TIPO <> 'X' THEN TRIM(A2_CGC) ELSE TRIM(A2_COD) || TRIM(A2_LOJA) END) F1_CGC "+CRLF
		cQ += "FROM "+RetSqlName("SF1")+" SF1 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 "+CRLF
		cQ += "ON SA2.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND A2_FILIAL = '"+xFilial("SA2")+"' "+CRLF
		cQ += "AND F1_FORNECE = A2_COD "+CRLF
		cQ += "AND F1_LOJA = A2_LOJA "+CRLF
		cQ += "WHERE SF1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND F1_STATUS='A' "+CRLF
		cQ += "AND F1_TIPO NOT IN ('D','B','C','I','P') "+CRLF
		//cQ += "AND F1_TPFRETE = 'F' "+CRLF
		If GetMv("MGF_FRSGFE",,.T.)	
			cQ += "AND F1_TPFRETE NOT IN (' ','S') "+CRLF		
		Endif	
		cQ += "AND F1_ESPECIE IN ('SPED','NFP') "+CRLF
		cQ += "AND F1_ORIGLAN <> 'LF' "+CRLF
		//cQ += "AND F1_FORMUL <> 'S' "+CRLF
		//cQ += "AND F1_DTDIGIT >= '"+GetMv("MGF_DTSGFE",,"20180901")+"' "+CRLF	
		cQ += "AND F1_DTDIGIT >= '"+dTos(dDataBase-GetMv("MGF_GFE331",,10))+"' "+CRLF		
		cQ += "MINUS "+CRLF
		cQ += "SELECT "+CRLF
		cQ += "GW1_FILIAL "+CRLF
		cQ += ",TRIM(GW1_SERDC) "+CRLF
		cQ += ",TRIM(GW1_NRDC) "+CRLF
		cQ += ",TRIM(GW1_CDREM) "+CRLF
		cQ += "FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' ' "+CRLF
		cQ += "AND GW1_CDTPDC = 'NFE' "+CRLF 
		cQ += "AND GW1_ORIGEM = '2' "+CRLF // origem ERP
		cQ += "AND GW1_ORINR = ' ' "+CRLF // indica que eh tipo B ou D
		cQ += "AND GW1_ORISER = ' ' "+CRLF
		cQ += ") "+CRLF
		cQ += "ORDER BY F1_FILIAL,F1_SERIE,F1_DOC,F1_CGC "+CRLF
	Endif

	If cTab == "GW1"
		cQ := "WITH TBL AS ("+CRLF
		cQ += "SELECT F2_FILIAL FIL, A1_CGC CGC, F2_DOC NF, F2_SERIE SER, F2_CHVNFE, F2_EMISSAO EMIS  FROM "+RetSqlName("SF2")+" SF2"+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "+CRLF
		cQ += "WHERE SF2.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND F2_TIPO NOT IN ('D','B')"+CRLF
		cQ += "UNION ALL"+CRLF
		cQ += "SELECT F2_FILIAL, A2_CGC CGC, F2_DOC NF, F2_SERIE SER, F2_CHVNFE, F2_EMISSAO EMIS FROM "+RetSqlName("SF2")+" SF2"+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = F2_CLIENTE AND A2_LOJA = F2_LOJA "+CRLF
		cQ += "WHERE SF2.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND F2_TIPO IN ('D','B')"+CRLF
		cQ += "),"+CRLF
		cQ += "TBL1 AS ("+CRLF
		cQ += "SELECT F1_FILIAL FIL, A1_CGC CGC, F1_DOC NF, F1_SERIE SER, F1_CHVNFE, F1_EMISSAO EMIS  FROM "+RetSqlName("SF1")+" SF1"+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA "+CRLF
		cQ += "WHERE SF1.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND F1_TIPO IN ('D','B')"+CRLF
		cQ += "UNION ALL"+CRLF
		cQ += "SELECT F1_FILIAL, A2_CGC CGC, F1_DOC NF, F1_SERIE SER, F1_CHVNFE, F1_EMISSAO EMIS FROM "+RetSqlName("SF1")+" SF1"+CRLF
		cQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA "+CRLF
		cQ += "WHERE SF1.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND F1_TIPO NOT IN ('D','B')"+CRLF
		cQ += ")"+CRLF
		cQ += "select * from (SELECT DISTINCT 'NFS' TIPO, A.* FROM (SELECT TRIM(F2_CHVNFE) CHVNFE,  nvl(TRIM(GW1_DANFE),' ') GW1CHVNFE, GW1.R_E_C_N_O_ RECNO FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("GU3")+" GU3 ON GU3_CDEMIT = GW1_CDDEST AND GU3.D_E_L_E_T_ = ' '"+CRLF
		cQ += "inner JOIN TBL ON TBL.FIL =  GW1_FILIAL AND TBL.NF = gw1_nrdc AND TBL.SER = gw1_serdc AND tbl.EMIS = gw1_dtemis AND GU3_IDFED = TBL.CGC "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND GW1_CDTPDC = 'NFS'"+CRLF
		cQ += ") A"+CRLF
		cQ += "UNION ALL"+CRLF
		cQ += "SELECT DISTINCT 'NFE' TIPO, A.* FROM (SELECT TRIM(F1_CHVNFE) CHVNFE, nvl(TRIM(GW1_DANFE),' ')  GW1CHVNFE, GW1.R_E_C_N_O_ RECNO FROM "+RetSqlName("GW1")+" GW1 "+CRLF
		cQ += "INNER JOIN "+RetSqlName("GU3")+" GU3 ON GU3_CDEMIT = GW1_EMISDC AND GU3.D_E_L_E_T_ = ' '"+CRLF
		cQ += "inner JOIN TBL1 ON TBL1.FIL =  GW1_FILIAL AND TBL1.NF = gw1_nrdc AND TBL1.SER = gw1_serdc AND tbl1.EMIS = gw1_dtemis AND GU3_IDFED = TBL1.CGC "+CRLF
		cQ += "WHERE GW1.D_E_L_E_T_ = ' '"+CRLF
		cQ += "AND GW1_CDTPDC = 'NFE'"+CRLF
		cQ += ") A ) B"+CRLF
		cQ += "WHERE (B.CHVNFE <> B.GW1CHVNFE)"+CRLF
	EndIf

	If cTab == "ZBS"
		CQ := "WITH TBL AS ("+CRLF
		CQ += " SELECT * FROM (SELECT GWN_FILIAL FILIAL, GW1_NRROM ROMAN, GWN_CDTPVC TPVEIC, SUM(GW8_PESOR) PESO  FROM  "+RetSqlName("GWN")+" GWN , "+RetSqlName("GW1")+"  GW1 , "+RetSqlName("GW8")+" GW8 WHERE"+CRLF
		CQ += " GWN_FILIAL = GW1_FILIAL  AND GWN_FILIAL = GW8_FILIAL  AND GWN_NRROM = GW1_NRROM    AND GW1_NRDC = GW8_NRDC   AND GW1_SERDC = GW8_SERDC"+CRLF
		CQ += " AND GWN.D_E_L_E_T_= ' '  AND GW1.D_E_L_E_T_= ' '      AND GW8.D_E_L_E_T_= ' ' GROUP BY GWN_FILIAL , GW1_NRROM, GWN_CDTPVC ) WHERE PESO > 0"+CRLF
		CQ += " )"+CRLF
		
		CQ += "SELECT DISTINCT ZBS_EMISS, A4_CGC, A1_NOME NOMCLIFOR,A4_NOME,nvl(ZBB_VALDES,0) ZBB_VALDES,(nvl(ZBB_VALDES,0) / TBL.PESO * F2_PBRUTO) CALC,ZBS.R_E_C_N_O_ RECNO FROM "+RetSqlName("ZBS")+" ZBS"+CRLF
		If nVez == 1
			CQ += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = ZBS_FILIAL AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE AND ZBS_CODCLI = F2_CLIENTE AND F2_LOJA =ZBS_LOJCLI AND SF2.D_E_L_E_T_ = ' '"+CRLF
		Else
			CQ += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = ZBS_FILIAL AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE AND ZBS_CODCLI = F2_CLIENTE AND F2_LOJA =ZBS_LOJCLI AND SF2.D_E_L_E_T_ = '*'"+CRLF
		EndIf
		CQ += "INNER JOIN "+RetSqlName("SA4")+" SA4 ON A4_COD = F2_TRANSP AND SA4.D_E_L_E_T_ = ' '"+CRLF
		CQ += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = F2_CLIENT AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' '"+CRLF
		CQ += "LEFT JOIN TBL ON TBL.FILIAL = F2_FILIAL AND TBL.ROMAN = F2_CARGA||F2_SEQCAR"+CRLF
		CQ += "LEFT JOIN "+RetSqlName("ZBB")+" ZBB  ON ZBB_TPVEIC = TBL.TPVEIC AND ZBB.D_E_L_E_T_ = ' '"+CRLF
		CQ += "WHERE ZBS.D_E_L_E_T_ = ' '"+CRLF
		CQ += "AND F2_TIPO NOT IN ('D','B')"+CRLF
		CQ += "AND A4_CGC <>  ZBS_TRANSP"+CRLF
		CQ += "UNION ALL "+CRLF
		CQ += "SELECT DISTINCT ZBS_EMISS, A4_CGC, A2_NOME NOMCLIFOR,A4_NOME,nvl(ZBB_VALDES,0) ZBB_VALDES,(nvl(ZBB_VALDES,0) / TBL.PESO * F2_PBRUTO) CALC,ZBS.R_E_C_N_O_ RECNO FROM "+RetSqlName("ZBS")+" ZBS"+CRLF
		If nVez == 1
			CQ += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = ZBS_FILIAL AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE AND ZBS_CODCLI = F2_CLIENTE AND F2_LOJA =ZBS_LOJCLI AND SF2.D_E_L_E_T_ = ' '"+CRLF
		Else
			CQ += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL = ZBS_FILIAL AND F2_DOC = ZBS_NUM AND F2_SERIE = ZBS_SERIE AND ZBS_CODCLI = F2_CLIENTE AND F2_LOJA =ZBS_LOJCLI AND SF2.D_E_L_E_T_ = '*'"+CRLF
		EndIf
		CQ += "INNER JOIN "+RetSqlName("SA4")+" SA4 ON A4_COD = F2_TRANSP AND SA4.D_E_L_E_T_ = ' '"+CRLF
		CQ += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = F2_CLIENT AND F2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' '"+CRLF
		CQ += "LEFT JOIN TBL ON TBL.FILIAL = F2_FILIAL AND TBL.ROMAN = F2_CARGA||F2_SEQCAR"+CRLF
		CQ += "LEFT JOIN "+RetSqlName("ZBB")+" ZBB  ON ZBB_TPVEIC = TBL.TPVEIC AND ZBB.D_E_L_E_T_ = ' '"+CRLF
		CQ += "WHERE ZBS.D_E_L_E_T_ = ' '"+CRLF
		CQ += "AND F2_TIPO IN ('D','B')"+CRLF
		CQ += "AND A4_CGC <>  ZBS_TRANSP"+CRLF
		CQ += "ORDER BY ZBS_EMISS"+CRLF
	EndIf


Return(cQ)

/*	
Static Function GFE33CmpSA1()

Local cQ := ""
/*
cQ := "			AND "+CRLF
cQ += "			( "+CRLF
cQ += "			TRIM(GU3_NMEMIT) <> TRIM(A1_NOME) "+CRLF
cQ += "			OR TRIM(GU3_NMFAN) <> TRIM(A1_NREDUZ) "+CRLF
cQ += "			OR TRIM(GU3_NATUR) <> TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_PESSOA ELSE 'X' END) "+CRLF
cQ += "			OR TRIM(GU3_DTNASC) <> TRIM(A1_DTNASC) "+CRLF
cQ += "			OR TRIM(GU3_CLIEN) <> '1' "+CRLF
cQ += "			OR TRIM(GU3_ENDER) <> TRIM(A1_END) "+CRLF
cQ += "			OR TRIM(GU3_COMPL) <> TRIM(A1_COMPLEM) "+CRLF
cQ += "			OR TRIM(GU3_BAIRRO) <> TRIM(A1_BAIRRO) "+CRLF
cQ += "			OR TRIM(GU3_CEP) <> TRIM(A1_CEP) "+CRLF
cQ += "			OR TRIM(GU3_NRCID) <> "+GFE33Cidade("SA1")+" "+CRLF
cQ += "			OR TRIM(GU3_IDFED) <> TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_CGC ELSE ' ' END) "+CRLF
cQ += "			OR TRIM(GU3_IE) <> TRIM(A1_INSCR) "+CRLF
cQ += "			OR TRIM(GU3_IM) <> TRIM(A1_INSCRM) "+CRLF
cQ += "			OR TRIM(GU3_CXPOS) <> TRIM(SUBSTR(A1_CXPOSTA,1,10)) "+CRLF
cQ += "			OR TRIM(GU3_EMAIL) <> TRIM(A1_EMAIL) "+CRLF
cQ += "			OR TRIM(GU3_FONE1) <> TRIM(A1_TEL) "+CRLF
cQ += "			OR TRIM(GU3_FAX) <> TRIM(A1_FAX) "+CRLF
cQ += "			OR TRIM(GU3_WSITE) <> TRIM(A1_HPAGE) "+CRLF
cQ += "			OR TRIM(GU3_ORIGEM) <> '2' "+CRLF
cQ += "			OR TRIM(GU3_SIT) <> TRIM(CASE WHEN A1_MSBLQL = '1' THEN '2' ELSE '1' END) "+CRLF
cQ += "			) "+CRLF
*/
/*
cQ := "			AND NOT "+CRLF
cQ += "			( "+CRLF
cQ += "			TRIM(A1_NOME) = TRIM(GU3_NMEMIT) "+CRLF
cQ += "			AND TRIM(A1_NREDUZ) = TRIM(GU3_NMFAN) "+CRLF
cQ += "			AND TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_PESSOA ELSE 'X' END) = TRIM(GU3_NATUR) "+CRLF
cQ += "			AND TRIM(A1_DTNASC) = TRIM(GU3_DTNASC) "+CRLF
cQ += "			AND '1' = TRIM(GU3_CLIEN) "+CRLF
cQ += "			AND TRIM(A1_END) = TRIM(GU3_ENDER) "+CRLF
cQ += "			AND TRIM(A1_COMPLEM) = TRIM(GU3_COMPL) "+CRLF
cQ += "			AND TRIM(A1_BAIRRO) = TRIM(GU3_BAIRRO) "+CRLF
cQ += "			AND TRIM(A1_CEP) = TRIM(GU3_CEP) "+CRLF
cQ += "			AND "+GFE33Cidade("SA1")+" = TRIM(GU3_NRCID) "+CRLF
cQ += "			AND TRIM(CASE WHEN A1_TIPO <> 'X' THEN A1_CGC ELSE ' ' END) = TRIM(GU3_IDFED) "+CRLF
cQ += "			AND TRIM(A1_INSCR) = TRIM(GU3_IE) "+CRLF
cQ += "			AND TRIM(A1_INSCRM) = TRIM(GU3_IM) "+CRLF
cQ += "			AND TRIM(SUBSTR(A1_CXPOSTA,1,10)) = TRIM(GU3_CXPOS) "+CRLF
cQ += "			AND TRIM(A1_EMAIL) = TRIM(GU3_EMAIL) "+CRLF
cQ += "			AND TRIM(A1_TEL) = TRIM(GU3_FONE1) "+CRLF
cQ += "			AND TRIM(A1_FAX) = TRIM(GU3_FAX) "+CRLF
cQ += "			AND TRIM(A1_HPAGE) = TRIM(GU3_WSITE) "+CRLF
cQ += "			AND '2' = TRIM(GU3_ORIGEM) "+CRLF
cQ += "			AND TRIM(CASE WHEN A1_MSBLQL = '1' THEN '2' ELSE '1' END) = TRIM(GU3_SIT) "+CRLF
cQ += "			) "+CRLF

Return(cQ)
*/

Static Function GFE33Cidade(cTab)

	Local cQ := ""

	cQ := "TRIM(NVL( "+CRLF
	cQ += "(SELECT GU7_NRCID "+CRLF
	cQ += "FROM "+RetSqlName("GU7")+" GU7 "+CRLF
	cQ += "WHERE "+CRLF
	cQ += "GU7.D_E_L_E_T_ = ' ' "+CRLF
	cQ += "AND GU7_FILIAL = '"+xFilial("GU7")+"' "+CRLF
	cQ += "AND TRIM(GU7_CDUF) = TRIM("+IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+"_EST) "+CRLF
	cQ += "AND TRIM(SUBSTR(GU7_NRCID,3,5)) = TRIM("+IIf(Subs(cTab,1,1)=="S",Subs(cTab,2,2),cTab)+IIf(cTab$"CC2","_CODMUN","_COD_MUN")+")), "+CRLF
	cQ += "'9999999')) "

Return(cQ)


Static Function GFE33UF(cCidade)

	Local cQ := ""

	cQ += "(SELECT GU7_CDUF "+CRLF
	cQ += "FROM "+RetSqlName("GU7")+" GU7 "+CRLF
	cQ += "WHERE "+CRLF
	cQ += "GU7.D_E_L_E_T_ = ' ' "+CRLF
	cQ += "AND GU7_FILIAL = '"+xFilial("GU7")+"' "+CRLF
	cQ += "AND TRIM(GU7_NRCID) = TRIM("+cCidade+")) "

Return(cQ)	