#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'

/*
=========================================================================================================
Programa.................: MGFGFE28
Autor:...................: Flávio Dentello
Data.....................: 16/06/2018
Descrição / Objetivo.....: Cadastro de regras para TES
Doc. Origem..............:
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................:
=========================================================================================================
*/

User Function MGFGFE28()

	Local aArea		:= Getarea()
	Local aAreaGW3  := GW3->(Getarea())
	Local aAreaGW4	:= GW4->(Getarea())
	Local aAreaGW1	:= GW1->(Getarea())
	Local aAreaGU3	:= GU3->(Getarea())
	Local aAreaGU7	:= GU7->(Getarea())
	Local aAreaGWN  := GWN->(Getarea())
	Local aAreaZE4  := ZE4->(Getarea())

	Local cGrupo  	:= ""
	Local cTpMov  	:= "" // Frete entrada ou saída
	Local cTribut 	:= GW3->GW3_TRBIMP // Tributação do documento
	Local cModal  	:= ""
	Local cTpDoc  	:= GW3->GW3_TPDF
	Local cRegTRP 	:= ""
	Local cContr  	:= ""
	Local cFornec 	:= ""
	Local cLoja   	:= ""
	Local cUF	  	:= ""
	Local cOri		:= ""
	Local cDest	    := ""
	Local cQuery  	:= ""
	Local cAliasZE5 := ""
	Local cModalPar := GETMV('MGF_MODAL')
	Local cUso		:= GETMV('MGF_COM28')
	Local cUsoMov	:= "1"
	Local cQuery1   := ""
	Local cAliasSB1 := ""
	Local lRet 		:= .F.
	Local lEx		:= .F.
	Local cTes		:= ''
	//Local oMdlBkp	:= fwModelActive()

	local cUpdGW3	:= ""
	Local cGrpTrib := ""

	If IsincallStack("MGFCTB232")
		If !empty(cTesx)
				cTes := cTesx    
			
				cUpdGW3	:= ""
				cUpdGW3 := "UPDATE " + retSQLName("GW3")
				cUpdGW3 += "	SET"													+ CRLF
				cUpdGW3 += " 		GW3_TES		= '" + cTes + "',"		+ CRLF
				cUpdGW3 += " 		GW3_ZTESOR	= '" + cTes + "'"		+ CRLF
				cUpdGW3 += " WHERE"														+ CRLF
				cUpdGW3 += " 		R_E_C_N_O_	=	" + str( GW3->( recno() ) )	+ ""	+ CRLF
			
				if tcSQLExec( cUpdGW3 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif
			
			Return cTes
		EndIf
	EndIf

	//__cInternet := "AUTOMATICO"

	cUso := cUso + GETMV('MGF_COM282')
	///Verifica se documentos transportados possuem produtos do tipo uso/Consumo.
	cAliasSB1 := GetNextAlias()

	cQuery1 += " SELECT DISTINCT B1_GRTRIB FROM " + RetSqlName("GW3") + " GW3 " + CRLF

	cQuery1 += " INNER JOIN " + RetSqlName("GW4") + " GW4 ON GW4.D_E_L_E_T_= ' '" + CRLF

	cQuery1 += " AND GW4_FILIAL = GW3_FILIAL " + CRLF
	cQuery1 += " AND GW4_EMISDF = GW4_EMISDF " + CRLF
	cQuery1 += " AND GW4_NRDF = GW3_NRDF " + CRLF
	cQuery1 += " AND GW4_SERDF = GW3_SERDF " + CRLF
	cQuery1 += " AND GW4_EMISDF = GW3_EMISDF " + CRLF

	cQuery1 += " INNER JOIN " + RetSqlName("GW8") + " GW8 ON GW8.D_E_L_E_T_= ' ' " + CRLF

	cQuery1 += " AND GW8_FILIAL = GW4_FILIAL " + CRLF
	cQuery1 += " AND GW8_EMISDC = GW4_EMISDC " + CRLF
	cQuery1 += " AND GW8_NRDC = GW4_NRDC " + CRLF
	cQuery1 += " AND GW8_SERDC = GW4_SERDC " + CRLF

	cQuery1 += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_= ' ' " + CRLF

	cQuery1 += " AND B1_FILIAL = ' ' " + CRLF
	cQuery1 += " AND B1_COD = GW8_ITEM " + CRLF
	//cQuery1 += " AND B1_GRTRIB IN (" + cUso + ")"

	cQuery1 += " WHERE GW3.D_E_L_E_T_= ' ' " + CRLF

	cQuery1 += " AND GW3_NRDF = '" + GW3->GW3_NRDF + "'" + CRLF
	cQuery1 += " AND GW3_SERDF = '" + GW3->GW3_SERDF + "'" + CRLF
	cQuery1 += " AND GW3_FILIAL =  '" + xFilial('GW3') + "'" + CRLF
	cQuery1 += " AND GW3_EMISDF =  '" + GW3->GW3_EMISDF + "'"

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery1),cAliasSB1, .F., .T.)

	If (cAliasSB1)->(!EOF())
	//	memoWrite("C:\TEMP\dados.TXT", cQuery1)
		While (cAliasSB1)->(!EOF()) .and. !lRet

			If alltrim((cAliasSB1)->B1_GRTRIB) $ cUso
				cUsoMov := "2"
				lRet := .T.
				cGrpTrib := (cAliasSB1)->B1_GRTRIB
			Else
				lRet := .T.
				cGrpTrib := (cAliasSB1)->B1_GRTRIB

			EndIf
			(cAliasSB1)->(DbSkip())
		Enddo

	EndIf
	(cAliasSB1)->(dbCloseArea())
	///Busca os dados do ducmento
	If GW3->(!EOF())

		///Frete entrada ou saída
		If GW3->GW3_SITREC <> '6'
			cTpMov := '1'
		Else
			cTpMov := '2'
		EndIf

		////VERIFICA MODAL

		DbSelectArea('GW4')
		GW4->(DbSetOrder(1))//GW4_FILIAL+GW4_EMISDF+GW4_CDESP+GW4_SERDF+GW4_NRDF+DTOS(GW4_DTEMIS)+GW4_EMISDC+GW4_SERDC+GW4_NRDC+GW4_TPDC
		If GW4->(Msseek(XFILIAL('GW4') + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF ))

			DbSelectArea('GW1')
			GW1->(DbSetOrder(1))//GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC
			If GW1->(Msseek(XFILIAL('GW1') + GW4->GW4_TPDC + GW4->GW4_EMISDC + GW4->GW4_SERDC + GW4->GW4_NRDC  ))

				DbSelectArea('GWU')
				GWU->(DbSetOrder(6))//GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_CDTRP+GWU_FILIAL+GWU_CDTPDC
				If GWU->(Msseek( GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + GW3->GW3_EMISDF + XFILIAL('GWU') + GW4->GW4_TPDC ))

				    // CIDADE DE ORIGEM
					DbSelectArea('GU3')
					GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
					If GU3->(Msseek( xFilial('GU3') + GW1->GW1_CDREM ))

						DbSelectArea('GU7')
						GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
						If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
								cOri := GU7->GU7_CDUF
						EndIf

					EndIf

				    // CIDADE DE DESTINO
					DbSelectArea('GU3')
					GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
					If GU3->(Msseek( xFilial('GU3') + GW1->GW1_CDDEST ))

						DbSelectArea('GU7')
						GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
						If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
								cDest := GU7->GU7_CDUF
						EndIf

					EndIf

					If !'EX' $ cDest + cOri

					
							// CIDADE DE ORIGEM
							DbSelectArea('GU3')
							GU3->(DbSetOrder(1))//GU3_FILIAL+GU3_CDEMIT
							If GU3->(Msseek( xFilial('GU3') + GW1->GW1_EMISDC ))
	
								DbSelectArea('GU7')
								GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
								If GU7->(Msseek( xFilial('GU7') + GU3->GU3_NRCID ))
									 If !GU3->GU3_NATUR  = 'F'        
                       
										If SA2->A2_EST <> cUF
									        cUF := '2'
								        Else
								        	cUF := '1'
							        	EndIf
										cOri := GU7->GU7_CDUF
									 Else
					   
										DbSelectArea('GU7')
										GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
										If GU7->(Msseek( xFilial('GU7') + GWU->GWU_NRCIDO ))									 
											cOri := GU7->GU7_CDUF										
										EndIf			     
								     EndIf
								EndIf
	
							EndIf
	
							//ESTADO DE DESTINO
							DbSelectArea('GU7')
							GU7->(DbSetOrder(1))//GU7_FILIAL+GU7_NRCID
							If GU7->(Msseek( xFilial('GU7') + GWU->GWU_NRCIDD ))
								cDest := GU7->GU7_CDUF
							EndIf
					Else
						lEx := .T.
					EndIf

					DbSelectArea('GWN')
					GWN->(DbSetOrder(1))//GWN_FILIAL+GWN_NRROM
					If GWN->(Msseek(XFILIAL('GWN') + GW1->GW1_NRROM ))

						If !(ALLTRIM(GWN->GWN_CDCLFR) $ ALLTRIM(cModalPar))
							cModal := '1'
						Else
							cModal := '2'
						EndIf

					EndIf

				EndIf

			EndIf

		EndIf
		////Busca dados da transportadora
		DbSelectArea('SA2')
		SA2->(DbSetorder(3))//A2_FILIAL+A2_CGC
		If SA2->(MsSeek(xFilial('SA2') + GW3->GW3_EMISDF ))

			cRegTRP := SA2->A2_SIMPNAC

			cFornec := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
			cUF		:= SA2->A2_EST

			/// Verifica se é contribuinte
			If SA2->A2_INSCR <> 'ISENTO'
				cContr := '1'
			Else
				cContr := '2'
			EndIf
		EndIf

		/// Verifica em que grupo a Filial está vinculada
		DbSelectArea('ZE4')
		ZE4->(DbSetorder(1))//ZE4_FILIAL + ZE4_FIL + ZE4_GRUPO
		If ZE4->(MsSeek(xFilial('ZE4') + GW3->GW3_FILIAL))
			cGrupo := ZE4->ZE4_GRUPO
		EndIf

		////Verifica a UF origem de Transporte
		If cTpMov == '1'

			DbSelectArea('SA2')
			SA2->(DbSetOrder(3))//A2_FILIAL+A2_CGC
			If SA2->(MsSeek(xFilial('SA2') + GW3->GW3_EMISDF ))
				If SA2->A2_EST <> cOri
					cUF := '2'
				Else
					cUF := '1'
				EndIf
			EndIf
		Else
			DbSelectArea('SA1')
			SA1->(DbSetOrder(3))//A1_FILIAL+A1_CGC
			If SA1->(MsSeek(xFilial('SA1') + GW3->GW3_CDREM ))
				If SA1->A1_EST <> cUF
					cUF := '2'
				Else
					cUF := '1'
				EndIf
			EndIf

		EndIf
	Endif

	cAliasZE5 := GetNextAlias()

	//cQuery := " SELECT case when ZE5_GRPTRI = ' ' then 'ZZZZZZ' else ZE5_GRPTRI end ZE5_GRPTRI, ZE5.* " + CRLF
	cQuery := " SELECT ZE5.* " + CRLF
	cQuery += " FROM " + RetSqlName("ZE5") + " ZE5 " + CRLF
	cQuery += " WHERE ZE5_GRUPO  = '" + cGrupo  + "'" + CRLF
	cQuery += " AND   ZE5_TPDOC  = '" + GW3->GW3_CDESP  + "'" + CRLF
	cQuery += " AND   ZE5_TPMOV  = '" + cTpMov  + "'" + CRLF
	cQuery += " AND   ZE5_TPTRIB = '" + cTribut + "'" + CRLF
	cQuery += " AND  (ZE5_UFTRP  = '" + cUF     + "' OR ZE5_UFTRP  = '3') " + CRLF
	cQuery += " AND   ZE5_CONTR  = '" + cContr  + "'" + CRLF
	cQuery += " AND  (ZE5_FORNEC = '" + cFornec + "' OR ZE5_FORNEC = ' ') " + CRLF
	cQuery += " AND  (ZE5_LOJA   = '" + cLoja   + "' OR ZE5_LOJA = ' ' )" + CRLF
	cQuery += " AND   ZE5_TPDF   = '" + cTpDoc  + "'" + CRLF
	cQuery += " AND  (ZE5_REGIME  = '" + cRegTRP + "' OR ZE5_REGIME = ' ')" + CRLF
	cQuery += " AND  (ZE5_TRANSP = '" + cModal  + "' OR ZE5_TRANSP = ' ')" + CRLF
	cQuery += " AND  (ZE5_UFORI  = '" + cOri  + "' OR ZE5_UFORI  = ' ')" + CRLF
	cQuery += " AND  (ZE5_UFDES  = '" + cDest + "' OR ZE5_UFDES  = ' ')" + CRLF
	cQuery += " AND  (ZE5_CONSUM = '" + cUsoMov + "' OR ZE5_CONSUM = ' ')" + CRLF
	If lEx
		cQuery += " AND   ZE5_EXPORT   = '1'" + CRLF
	Else
		cQuery += " AND   ZE5_EXPORT   = '2'" + CRLF
	EndIf
	cQuery += " AND  (ZE5_GRPTRI = '" + cGrpTrib + "' OR ZE5_GRPTRI = ' ')" + CRLF
	cQuery += " AND   ZE5.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY ZE5_FORNEC DESC, ZE5_GRPTRI DESC " // priorizar sempre registros que tem dados nestes campos

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasZE5, .F., .T.)

	memoWrite("C:\TEMP\TES.TXT", cQuery)

	If (cAliasZE5)->(!eof())
		If GW3->GW3_TES == GW3->GW3_ZTESOR
			cTes := (cAliasZE5)->ZE5_TES
			/*
			RecLock("GW3",.F.)
			GW3->GW3_TES    := (cAliasZE5)->ZE5_TES
			GW3->GW3_ZTESOR := (cAliasZE5)->ZE5_TES
			GW3->(MsUnlock())
			*/
		Else
			cTes := GW3->GW3_TES
		EndIf
	EndIf

	cUpdGW3	:= ""
	cUpdGW3 := "UPDATE " + retSQLName("GW3")
	cUpdGW3 += "	SET"													+ CRLF
	cUpdGW3 += " 		GW3_TES		= '" + cTes + "',"		+ CRLF
	cUpdGW3 += " 		GW3_ZTESOR	= '" + cTes + "'"		+ CRLF
	cUpdGW3 += " WHERE"														+ CRLF
	cUpdGW3 += " 		R_E_C_N_O_	=	" + str( GW3->( recno() ) )	+ ""	+ CRLF

	if tcSQLExec( cUpdGW3 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif

	(cAliasZE5)->(dbCloseArea())

	Restarea(aAreaZE4)
	Restarea(aAreaGWN)
	Restarea(aAreaGU7)
	Restarea(aAreaGU3)
	Restarea(aAreaGW1)
	Restarea(aAreaGW4)
	Restarea(aAreaGW3)
	Restarea(aArea)

	//oModel := oMdlBkp

Return cTes