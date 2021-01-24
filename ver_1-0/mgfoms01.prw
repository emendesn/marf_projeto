#INCLUDE "PROTHEUS.CH"                   
#INCLUDE "TOPCONN.CH"

/*
=========================================================================================================
Programa.................: MGFOMS01
Autor:...................: Flávio Dentello
Data.....................: 06/09/2016
Descrição / Objetivo.....: Integrar o Tipo de Operação e Classificação de Frete, integrar KM,
Tratamento de veículo Fidelizado e Tratamento de classificação de Frete e tipo de operação na
Carga do OMS.
=========================================================================================================
*/            
User Function MGFOMS01( )

	Local aArea     := GetArea()
	Local aAreaDAK  := DAK->(GetArea())
	Local aAreaZD4  := ZD4->(GetArea())
	Local cCarga    := DAK->DAK_COD
	Local cSeqcar   := DAK->DAK_SEQCAR
	Local cAlias1   := ""
	Local cAlias2   := ""
	Local cAlias3   := ""
	Local cAlias31  := ""
	Local cAlias4   := ""
	Local cAlias5   := ""
	Local cAlias6   := ""
	Local cAlias7   := ""
	Local cAlias8   := ""
	Local aTpop	    := {}
	Local cString   := ""
	Local CQUERYZD3 :=""
	Local lCalcFrete := .F.
	Local lRet := .F.
	Local cRotOrigem := IIf(IsInCallStack("U_MGFGFE32"),"MGFGFE32",IIf(IsInCallStack("U_MGFGFE36"),"MGFGFE36",""))

	Local _cDescTpOp	:= ""
	Local _cExpSimp 	:= ""
	
	Private cTpOperGFE  := GETMV("MV_CDTPOP")
	Private cClassFre	:= GETMV("MV_CDCLFR")
	Private nDistan		:= 0
	
	DbSelectArea("ZD3")   
	DbSetorder(1)                                  
	If ZD3->(MsSeek(xFilial('ZD3')))
		While ZD3->(!eof()) .AND. ZD3->ZD3_FILIAL == xFilial('ZD3')
	
			cQueryZD3 := GetNextAlias()		
				
			cQuerZD3  := " SELECT DISTINCT DAK_FILIAL "
			cQuerZD3  += " FROM " + RetSqlName("DAK")+" DAK " 
					
			// VEICULO DA CARGA
			IF !EMPTY(ZD3->ZD3_ROMANE)
				cQuerZD3 += " INNER JOIN " + RetSqlName("DA3") + " DA3" + " ON   DA3.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND DA3_FILIAL= '" + xFilial('DA3') + "'"
				cQuerZD3 += " AND DAK_CAMINH = DA3_COD "
				cQuerZD3 += " AND ( " + ALLTRIM(ZD3->ZD3_ROMANE)+" ) "
			ENDIF	
	
			//PEDIDOS DA CARGA	
			IF !EMPTY(ZD3->ZD3_PEDIDO)
				cQuerZD3 += " INNER JOIN " + RetSqlName("DAI") + " DAI" + " ON  DAI.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND DAI_FILIAL ='" + xFilial('DAI') + "'"
				cQuerZD3 += " AND DAK_FILIAL = DAI_FILIAL"
				cQuerZD3 += " AND DAK_COD = DAI_COD "
				cQuerZD3 += " AND DAK_SEQCAR = DAI_SEQCAR"
				
				cQuerZD3 += " INNER JOIN " + RetSqlName("SC5") + " SC5" + " ON  SC5.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND C5_FILIAL ='" + xFilial('SC5') + "'"
				cQuerZD3 += " AND C5_NUM = DAI_PEDIDO "
				cQuerZD3 += " AND ( " + ALLTRIM(ZD3->ZD3_PEDIDO)+ " ) "
			ENDIF	

			// NOTA FISCAL
			IF !EMPTY(ZD3->ZD3_NOTA)
				cQuerZD3 += " INNER JOIN " + RetSqlName("SF2") + " SF2" + " ON   SF2.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SF2.F2_FILIAL= '" + xFilial('SF2') + "'"
				cQuerZD3 += " AND DAK_COD = SF2.F2_CARGA "
				cQuerZD3 += " AND ( " + ALLTRIM(ZD3->ZD3_NOTA)+" ) "
			ENDIF
            
			//TRECHO DE ITINERARIO 1
			// Obs: necessario colocar o alias das tabelas dai e gwu, senao a query da erro de coluna com ambiguidade
			IF !EMPTY(ZD3->ZD3_TRECH1)
				cQuerZD3 += " INNER JOIN " + RetSqlName("DAI") + " DAI_1" + " ON  DAI_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND DAI_1.DAI_FILIAL ='" + xFilial('DAI') + "'"
				cQuerZD3 += " AND DAK_FILIAL = DAI_1.DAI_FILIAL"
				cQuerZD3 += " AND DAK_COD = DAI_1.DAI_COD "
				cQuerZD3 += " AND DAK_SEQCAR = DAI_1.DAI_SEQCAR"
				
				cQuerZD3 += " INNER JOIN " + RetSqlName("GWU") + " GWU_1" + " ON  GWU_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND GWU_1.GWU_FILIAL ='" + xFilial('GWU') + "'"
				cQuerZD3 += " AND GWU_1.GWU_CDTPDC = 'NFS' "
				cQuerZD3 += " AND GWU_1.GWU_SEQ = '01' " // somente 1 trecho
				cQuerZD3 += " AND GWU_1.GWU_SERDC = DAI_1.DAI_SERIE "
				cQuerZD3 += " AND GWU_1.GWU_NRDC = DAI_1.DAI_NFISCA "								
				cQuerZD3 += " AND ( " + ALLTRIM(StrTran(ZD3->ZD3_TRECH1,"GWU_","GWU_1.GWU_"))+ " ) "
			ENDIF	

			//TRECHO DE ITINERARIO 2
			IF !EMPTY(ZD3->ZD3_TRECH2)
				cQuerZD3 += " INNER JOIN " + RetSqlName("DAI") + " DAI_2" + " ON  DAI_2.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND DAI_2.DAI_FILIAL ='" + xFilial('DAI') + "'"
				cQuerZD3 += " AND DAK_FILIAL = DAI_2.DAI_FILIAL"
				cQuerZD3 += " AND DAK_COD = DAI_2.DAI_COD "
				cQuerZD3 += " AND DAK_SEQCAR = DAI_2.DAI_SEQCAR"
				
				cQuerZD3 += " INNER JOIN " + RetSqlName("GWU") + " GWU_2" + " ON  GWU_2.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND GWU_2.GWU_FILIAL ='" + xFilial('GWU') + "'"
				cQuerZD3 += " AND GWU_2.GWU_CDTPDC = 'NFS' "
				cQuerZD3 += " AND GWU_2.GWU_SEQ = '02' " // somente 2 trecho
				cQuerZD3 += " AND GWU_2.GWU_SERDC = DAI_2.DAI_SERIE "
				cQuerZD3 += " AND GWU_2.GWU_NRDC = DAI_2.DAI_NFISCA "								
				cQuerZD3 += " AND ( " + ALLTRIM(StrTran(ZD3->ZD3_TRECH2,"GWU_","GWU_2.GWU_"))+ " ) "
			ENDIF	
				
			//Produto
			IF !EMPTY(ZD3->ZD3_PRODUT)
				cQuerZD3 += " INNER JOIN " + RetSqlName("SF2") + " SF2_1" + " ON   SF2_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SF2_1.F2_FILIAL= '" + xFilial('SF2') + "'"
				cQuerZD3 += " AND DAK_COD = SF2_1.F2_CARGA "

				cQuerZD3 += " INNER JOIN " + RetSqlName("SD2") + " SD2_1" + " ON   SD2_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SD2_1.D2_FILIAL = SF2_1.F2_FILIAL "
				cQuerZD3 += " AND SD2_1.D2_DOC = SF2_1.F2_DOC "
				cQuerZD3 += " AND SD2_1.D2_SERIE = SF2_1.F2_SERIE "
				cQuerZD3 += " AND SD2_1.D2_CLIENTE = SF2_1.F2_CLIENTE "
				cQuerZD3 += " AND SD2_1.D2_LOJA = SF2_1.F2_LOJA "

				cQuerZD3 += " INNER JOIN " + RetSqlName("SB1") + " SB1_1" + " ON   SB1_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SB1_1.B1_FILIAL= '" + xFilial('SB1') + "'"
				cQuerZD3 += " AND SB1_1.B1_COD = SD2_1.D2_COD "
				cQuerZD3 += " AND (" + ALLTRIM(StrTran(ZD3->ZD3_PRODUT,"B1_","SB1_1.B1_"))+ ") "
			EndIf

			//Cliente
			IF !EMPTY(ZD3->ZD3_CLIENT)
				cQuerZD3 += " INNER JOIN " + RetSqlName("SF2") + " SF2_2" + " ON   SF2_2.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SF2_2.F2_FILIAL= '" + xFilial('SF2') + "'"
				cQuerZD3 += " AND DAK_COD = SF2_2.F2_CARGA "

				cQuerZD3 += " INNER JOIN " + RetSqlName("SA1") + " SA1_1" + " ON   SA1_1.D_E_L_E_T_= ' '"
				cQuerZD3 += " AND SA1_1.A1_FILIAL= '" + xFilial('SA1') + "'"
				cQuerZD3 += " AND SA1_1.A1_COD = SF2_2.F2_CLIENTE "
				cQuerZD3 += " AND SA1_1.A1_LOJA = SF2_2.F2_LOJA "
				cQuerZD3 += " AND (" + ALLTRIM(StrTran(ZD3->ZD3_CLIENT,"A1_","SA1_1.A1_"))+ ") "
			EndIf
			//TABELA DE CARGA
			cQuerZD3  += " WHERE DAK_FILIAL ='" + XFILIAL("DAK") + "'"
			cQuerZD3  += " AND DAK_COD ='" + cCarga +"'"
			cQuerZD3  += " AND DAK_SEQCAR ='" + cSeqcar +"'"
			IF !EMPTY(ZD3->ZD3_CARGA)
				cQuerZD3 += " AND ( " + ALLTRIM(ZD3->ZD3_CARGA)+" ) "
			ENDIF	
			cQuerZD3  += " AND DAK.D_E_L_E_T_ <>'*' "
				
			cQuerZD3 := ChangeQuery(cQuerZD3)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuerZD3),cQueryZD3, .F., .T.)
	
			If (cQueryZD3)->(!EOF()) 
		   		AADD(aTpop, {ZD3->ZD3_COD, ZD3->ZD3_TPOP, ZD3->ZD3_CALFRR, ZD3->ZD3_EXPRES, ZD3->ZD3_PRIORI, ZD3->ZD3_DESTPO, ZD3->ZD3_EXPSIM })
			EndIf                                          
			
			(cQueryZD3)->(dbCloseArea())
			ZD3->(dbskip())
		Enddo
	EndIf
		
	aSort(aTpop,,,{|x,y| x[5]<y[5]}) // ordena por prioridade
	If len(aTpop)<= 0

		cString 	:= "Não foi encontrado regra para o preenchimento do tipo de operação para a Carga!"
		_cExpSimp 	:= "Não foi encontrado regra para o preenchimento do tipo de operação para a Carga!"

		DAK->(RecLock("DAK",.F.))
		If empty(cTpOperGFE) .and. empty(DAK->DAK_ZCDTPO)
			DAK->DAK_ZCDTPO 	:= "Z.Z"
		Else	
			DAK->DAK_ZCDTPO 	:= cTpOperGFE
		Endif
		DAK->(MsUnlock())

	Else

		cTpOperGFE	:= aTpop[1][2] 
		lCalcFrete	:= aTpop[1][3] == "1" 
		cString 	:= "Regra: "+aTpop[1][1]+" - Expressão: "+aTpop[1][4] 

		_cDescTpOp	:= aTpop[1][6]
		_cExpSimp 	:= "Regra: "+aTpop[1][1]+" - Expressão Simples: "+aTpop[1][7]

	EndIf

	If cTpOperGFE = ""
		cTpOperGFE := GETMV("MV_CDTPOP")
	EndIf

	// Preenchimento das variáveis
	dBselectArea('DAK')
	DAK->(RecLock("DAK",.F.))
	If empty(cTpOperGFE) .and. empty(DAK->DAK_ZCDTPO)
		DAK->DAK_ZCDTPO 	:= "Z.Z"
	Else	
		DAK->DAK_ZCDTPO 	:= cTpOperGFE
	Endif
	DAK->DAK_ZCDCLF := cClassFre    ///CRIADO
	DAK->DAK_ZMSG   := cString

	DAK->DAK_ZDESTP	:= _cDescTpOp
	DAK->DAK_ZEXSIM	:= _cExpSimp

	//GRAVAR OE REFERENCIA QUANDO CRIADO CARGA NO PROTEHUS, PROJETO CTE
	IF EMPTY(DAK->DAK_XOEREF)
		DAK->DAK_XOEREF:=DAK->DAK_COD
	ENDIF

	DAK->(MsUnlock())

	nDistan	:= DAK->DAK_ZDISTA
	dBselectArea('GWN')
	dbSetOrder(1)

	If DbSeek(xFilial('GWN')+DAK->DAK_COD + DAK->DAK_SEQCAR) //GWN->NRROM

		GWN->(RecLock('GWN',.F.))

		GWN->GWN_CDTPOP := cTpOperGFE
		GWN->GWN_CDCLFR := cClassFre
		GWN->GWN_DISTAN	:= nDistan

		GWN->(MsUnlock())
		
		// chamada para calculo do frete do romaneio
		If lCalcFrete .and. GWN->GWN_CALC <> "1" // romaneio jah calculado
			cTime1 := Time()
			ConOut(cRotOrigem+" - Calculando Frete para Romaneio ( início ): "+GWN->GWN_FILIAL+"/"+GWN->GWN_NRROM+" - Data Romaneio: "+dToc(GWN_DTIMPL)+" - Hora Romaneio: "+GWN->GWN_HRIMPL+" - "+Time())
			lRet := GFE050CALC(/*lDatabase*/,/*lHelp*/.F.,/*cMsg*/,/*aRetCalc*/,/*lTstAuto*/.T.,/*cArqLog*/)
			If lRet
				GWN->(RecLock('GWN',.F.))
				GWN->GWN_USUIMP := "CALCULO AUTOMATICO"
				GWN->(MsUnlock())
			Endif	
			cTime2 := Time()
			ConOut(cRotOrigem+" - Calculando Frete para Romaneio ( fim ): "+GWN->GWN_FILIAL+"/"+GWN->GWN_NRROM+" - Data Romaneio: "+dToc(GWN->GWN_DTIMPL)+" - Hora Romaneio: "+GWN->GWN_HRIMPL+" - "+Time()+" - Tempo total: "+ElapTime(cTime1,cTime2))
		Endif	
	EndIf		

	ZD4->(RecLock('ZD4',.T.))

	ZD4->ZD4_FILIAL := XFILIAL("ZD4")
	ZD4->ZD4_OPER   := "1"  
	ZD4->ZD4_CARGA  := DAK->DAK_COD + DAK->DAK_SEQCAR
	ZD4->ZD4_DTCAR  := DAK->DAK_DATA
	ZD4->ZD4_TPOP := cTpOperGFE

	IF !EMPTY(ZD4->ZD4_TPOP)
		ZD4->ZD4_GRAVA := "1"
	ELSE 	
		ZD4->ZD4_GRAVA := "2"
	ENDIF

	ZD4->ZD4_MANUAL := "2"
	ZD4->ZD4_TIPOC  := "2"
	ZD4->ZD4_DATAMV := DDATABASE
	ZD4->ZD4_USUAR  := cUserName

	ZD4->(MsUnlock())

	RestArea(aAreaDAK)
	RestArea(aAreaZD4)
	RestArea(aArea)

Return(lRet)


/// Alteração do Tipo de Operação
User Function ALTFRE()

	Local cClassfre := ""
	Local cTpOper := ""
	Local aRetorno := {}

	If DAK->DAK_FEZNF == '2'

		aRetorno := U_XTELA()

		cClassfre := aRetorno[1][1]
		cTpOper := aRetorno[1][2]

		DAK->(RecLock("DAK",.F.))
		DAK->DAK_ZCDTPO := cTpOper
		DAK->(MsUnlock())

		dBselectArea('GWN')
		dbSetOrder(1)
		If DbSeek(xFilial('GWN')+DAK->DAK_COD + DAK->DAK_SEQCAR) //GWN->NRROM
			GWN->(RecLock("GWN",.F.))
			GWN->GWN_CDTPOP := cTpOper
			GWN->(MsUnlock())
		EndIf

		ZD4->(RecLock('ZD4',.T.))
		ZD4->ZD4_FILIAL := XFILIAL("ZD4")
		ZD4->ZD4_OPER   := "2"  
		ZD4->ZD4_CARGA  := DAK->DAK_COD + DAK->DAK_SEQCAR
		ZD4->ZD4_DTCAR  := DAK->DAK_DATA
		ZD4->ZD4_TPOP   := cTpOper
		IF !EMPTY(cTpOper)
			ZD4->ZD4_GRAVA := "1"
		ENDIF
		ZD4->ZD4_MANUAL := "1"
		ZD4->ZD4_TIPOC  := "2"
		ZD4->ZD4_DATAMV := DDATABASE
		ZD4->ZD4_USUAR  := cUserName
		ZD4->(MsUnlock())

	Else

		MsgAlert('ATENÇÃO!! Somente será possível fazer essa alteração para cargas que estiverem com o status Totalmente em aberto!')

	EndIf


Return


//// TELA PARA ALTERAÇÃO DE TIPO DE OPERAÇÃO E CLASSIFICAÇÃO DE FRETE

User Function XTELA()

	Local 	cClassFre  := Space(04)
	Local 	cTpop := Space(10)
	Local	Odlg
	Local 	cDescrC := ""
	Local 	aRetorno := {}
	Private lOk,lCancel


	DEFINE DIALOG oDlg TITLE "Alterando Tipo de Operação " FROM 180,180 TO 350,500 PIXEL

	@ 40,58 MSGET cTpop  F3 "GV4" SIZE 90,10 OF oDlg PIXEL PICTURE '@!'
	@ 41,08 SAY "Tipo de Operação" SIZE  50,10 OF oDlg PIXEL

	oTButton := TButton():New( 70, 120, "&OK",oDlg	,{|| lOk:= .T., oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	aAdd (aRetorno, {cClassFre, cTpop})

Return aRetorno



User Function VLFRETE()

	Local cTpop    := Space(10)
	Local Odlg
	Local nPeso    := 0
	Local nValkg   := 0
	Local cEstPres  := SM0->M0_ESTENT
	Local cMunPres  := SUBSTR(SM0->M0_CODMUN,3,LEN(ALLTRIM(SM0->M0_CODMUN)))
	Local cCFFrete  := SPACE(TAMSX3("C5_FRTCFOP")[1])
	//wvn
	Local cCFFrAut  := SPACE(TAMSX3("C5_RECFAUT")[1])
	Local aCFAuton  := Separa("1-Emitente,2-Transportador")
	//
	Local aCFCombo  := Separa(SuperGetMV("MGF_OMS01C",.T.,"5353,6353,5352,6352"),",",.F.)
	Local oComboBox
	Local nValFre
	Local lUFFretAut  //Frete autonomo: Unidades que levam o valor do Frete autonomo para o SPED
	
	Private lOk,lCancel

	
	lUFFretAut := cEstPres $ SuperGetMV("MGF_FIS34E",.T.," ")
	nValFre    := DAK->DAK_ZVLFRE

	
	If DAK->DAK_FEZNF == '2'
		
			//------------------------------------------------------------
			nLinDlg := 26   //Primeira linha
			nLesp   := 16   //Espaçamento
			
			DEFINE DIALOG oDlg TITLE "Informações sobre o frete da carga" FROM 0,0 TO 350,500 PIXEL
			
			@ nLinDlg,10 SAY "Valor Frete:" SIZE  80,10 OF oDlg PIXEL
			@ nLinDlg,60 MSGET nValFre SIZE 90,10 OF oDlg PIXEL PICTURE '@E 999,999,999.99' VALID Positivo(nValFre)
			nLinDlg += nLesp
			
			If lUFFretAut
				@ 42,10 SAY "UF Prestador:" SIZE  80,10 OF oDlg PIXEL
				@ 42,60 MSGET cEstPres SIZE 90,10 OF oDlg PIXEL PICTURE '@!'  VALID ExistCpo("SX5","12"+cEstPres) F3 "12"
				nLinDlg += nLesp
			
				@ 58,10 SAY "Cod Mun.:" SIZE  80,10 OF oDlg PIXEL
				@ 58,60 MSGET cMunPres SIZE 90,10 OF oDlg PIXEL VALID ExistCpo("CC2",cEstPres+cMunPres)  F3 "CC2"
				nLinDlg += nLesp

				@ 74,10 SAY "CFOP Frete:" SIZE  80,10 OF oDlg PIXEL
				@ 74,60 MSCOMBOBOX oComboBox VAR cCFFrete SIZE 90,10 ITEMS aCFCombo OF oDlg PIXEL
				nLinDlg += nLesp
//wvn
				@ 90,10 SAY "Resp.Recolhimento:" SIZE  80,10 OF oDlg PIXEL
				@ 90,60 MSCOMBOBOX oComboBox VAR cCFFrAut SIZE 90,10 ITEMS aCFAuton OF oDlg PIXEL
				nLinDlg += nLesp			
//
			EndIf
			
			oTButton := TButton():New( nLinDlg, 150, "&OK",oDlg	,{||AtualValc(lUFFretAut,nValFre,cEstPres,cMunPres,cCFFrete,cCffrAut), oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			
			ACTIVATE DIALOG oDlg CENTERED
	Else
		MsgInfo("Somente é possível incluir valores de frete para cargas não faturadas!")
	EndIf
Return

Static Function AtualValc(lUFFretAut,nValFre,cEstPres,cMunPres,cCFFrete,cCffrAut)
	Local cDescrC  := ""
	Local aRetorno := {}
	Local cAlias1  := ""
	Local cQuery   := ""
	Local cCarga   := DAK->DAK_COD
	Local cSeq     := DAK->DAK_SEQCAR
//wvn	
    If cCffrAut = "1-Emitente"
		cCffrAut := "1"
	else
		cCffrAut := "2"
	EndIf
//
	If nValFre > 0
		DAK->(RecLock("DAK",.F.))
		DAK->DAK_ZVLFRE := nValFre
		DAK->(MsUnlock())
	EndIf
	
	If DAK->DAK_ZVLFRE > 0
		MsgInfo('Valor de Frete Gravado com sucesso!!!')
	EndIf
	
	cAlias1	:= GetNextAlias()
	
	cQuery := " SELECT SUM(DAI_PESO) PESO "
	cQuery += " FROM " +RetSqlName("DAK") + " DAK " +", " +RetSqlName("DAI") + " DAI "
	cQuery += " WHERE DAK.DAK_FILIAL = '" + xFilial("DAK") + "' "
	cQuery += " AND DAI.DAI_FILIAL = '" + xFilial("DAI") + "' "
	cQuery += " AND DAK.DAK_COD = DAI.DAI_COD "
	cQuery += " AND DAK.DAK_SEQCAR = DAI.DAI_SEQCAR "
	cQuery += " AND DAK.DAK_COD = '" + cCarga + "'
	cQuery += " AND DAK.D_E_L_E_T_=''
	cQuery += " AND DAI.D_E_L_E_T_=''
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
	
	If (cAlias1)->(!Eof())
		nPeso := (cAlias1)->PESO
		nValkg := nValFre / (cAlias1)->PESO
	Endif	
	                                   
	(cAlias1)->(dbCloseArea())
	
	dbSelectArea("DAI")
	dBsetOrder(1)//DAI_FILIAL+DAI_COD+DAI_SEQCAR+DAI_SEQUEN+DAI_PEDIDO
	DbSeek(xFilial('DAI')+cCarga+cSeq)
	
	While !DAI->(eof()) .AND. xFilial("DAI") == xFilial("DAK") .AND. cCarga == DAI->DAI_COD .AND. cSeq==DAI->DAI_SEQCAR
		
		nFrete := DAI->DAI_PESO * nValkg
		
		
		DAI->(RecLock("DAI",.F.))
		DAI->DAI_ZFRESI := nFrete
		DAI->(MsUnlock())
				
		dbSelectArea("SC5")
		dBsetOrder(1)//C5_FILIAL+C5_NUM
		If nFrete > 0
			If DbSeek(xFilial('SC5')+DAI->DAI_PEDIDO)
				SC5->(RecLock("SC5",.F.))
				IF lUFFretAut
					SC5->C5_FRETAUT := nFrete
					SC5->C5_FRTCFOP := cCFFrete
					SC5->C5_ESTPRES := cEstPres
					SC5->C5_MUNPRES := cMunPres
					SC5->C5_RECFAUT := cCffrAut
				ELSE
					SC5->C5_ZVLFRET := nFrete
				EndIf
				SC5->(MsUnlock())
			EndIf
		EndIf
		
		DAI->(DBSKIP())
	Enddo

Return


User Function ALIQICMS()

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "ZBN"

	dbSelectArea("ZBN")
	dbSetOrder(1)

	AxCadastro(cString,"Alíquotas de ICMS Sobre o Frete",cVldExc,cVldAlt)

Return

// Função que grava log de estorno da carga
User Function MGFGFE19()

	ZD4->(RecLock('ZD4',.T.))
	ZD4->ZD4_FILIAL := XFILIAL("ZD4")
	ZD4->ZD4_OPER   := "3"  
	ZD4->ZD4_CARGA  := DAK->DAK_COD + DAK->DAK_SEQCAR
	ZD4->ZD4_DTCAR  := DAK->DAK_DATA
	ZD4->ZD4_TPOP   := DAK->DAK_ZCDTPO
	IF !EMPTY(DAK->DAK_ZCDTPO)
		ZD4->ZD4_GRAVA := "1"
	ENDIF
	ZD4->ZD4_MANUAL := "1"
	ZD4->ZD4_TIPOC  := "2"
	ZD4->ZD4_DATAMV := DDATABASE
	ZD4->ZD4_USUAR  := cUserName
	ZD4->(MsUnlock())

Return

/*-------------------------------------------------
// Verifica se as notas fiscais possuem valor de Frete Informado.
// Tornar obrigatório apenas o preenchimento para unidades de UF informados no parâmetro MGF_FIS34E
*/
User Function xBlqFrete()

	Local lRet   := .T.
	Local lFrete := .T.
	Local cAliqFre		:= SuperGetMV("MV_ALIQFRE",.T.," ")
	Local lMGFFIS34		:= SuperGetMV('MGF_FIS34L',.T.,.F.)	//Habilita a rotina de valor do frete no pedido ou carga
	Local cEstPres  := SM0->M0_ESTENT
	Local lUFFretAut := cEstPres $ SuperGetMV("MGF_FIS34E",.T.," ") //Unidades federativas que terão valor de Frete Autônomo.

	If lMGFFIS34
		If IsInCallStack("MATA460B")
			
			// wvn - Inclusão dessa pesquisa pois não estava posicionado no DAI
			DAK->(DbSeek(xFilial('DAK') + SC9->(C9_CARGA + C9_SEQCAR)))
			// eof
			//DAI->(DbSelectArea('DAI'))
			DAI->(DbGotop('DAI'))
			DAI->(DbSetOrder(1))
			DAI->(DbSeek(XFILIAL('DAI') + DAK->DAK_COD + DAK->DAK_SEQCAR))
			
			WHILE !DAI->(EOf()) .AND. lFrete == .T. .AND. DAK->DAK_COD + DAK->DAK_SEQCAR == DAI->DAI_COD + DAI->DAI_SEQCAR
			
				dBselectArea('SC5')
				dbSetOrder(1) 
				If DbSeek(xFilial('SC5')+DAI->DAI_PEDIDO)
								
					IF SC5->C5_TPFRETE = 'C'
					
						dbSelectArea("SA1")
						dBsetOrder(1)//A1_FILIAL+A1_COD+A1_LOJA
						If DbSeek(xFilial('SA1')+DAI->DAI_CLIENT + DAI->DAI_LOJA)
							dBselectArea('SA4')
							dbSetOrder(1)
							If DbSeek(xFilial('SA4') + DAK->DAK_TRANSP)
								If SM0->M0_ESTENT <> SA4->A4_EST
									If DAK->DAK_ZVLFRE > 0
										nAliqFre := Val(Subs(cAliqFre,AT(SA1->A1_EST,cAliqFre)+2,2))
										If nAliqFre > 0
											lRet := .T.	
										Else
											MsgAlert('Informe no parâmetro MV_ALIQFRE a alíquota de ICMS para a UF de destino.')
											lRet := .F.
											lFrete := .F.
										EndIf
									ElseIf lUFFretAut //Obrigatório o preenchimento do valor do Frete.
										MsgAlert('Notas Fiscais não geradas!!! Informe o valor do frete para a carga '+ Alltrim(DAK->DAK_COD) +' antes da emissão das Notas Fiscais.','Valor do FRETE não informado')
										lRet := .F. //Aborta a emissão dos doc de saída.
										lFrete := .F. //Finaliza a looping para leitura da DAI
									ElseIf ApMsgYesNo(;
										'Não foi informado o valor do frete da carga'+ Alltrim(DAK->DAK_COD) +'. Deseja prosseguir com a emissão das Notas Fiscais?',;
										'VALOR DO FRETE NÃO INFORMADO!')
										lRet := .T. //Continua com a geração dos documentos de saída.
										lFrete := .F. //Finaliza a looping para leitura da DAI
									Else
										lRet := .F. //Aborta a emissão dos doc de saída.
										lFrete := .F. //Finaliza a looping para leitura da DAI
									EndIf	
								EndIf	
							EndIf
						EndIf	
					EndIf
				Endif	
					DAI->(DBSKIP())
			ENDDO
		Else
			dBselectArea('SC5')
			dbSetOrder(1) 
			If DbSeek(xFilial('SC5')+ SC9->C9_PEDIDO)
				If SC5->C5_TPFRETE = 'C'
					dBselectArea('SA4')
					dbSetOrder(1) 
					If DbSeek(xFilial('SA4')+SC5->C5_TRANSP)
						dBselectArea('SA1')
						dbSetOrder(1) 
						If DbSeek(xFilial('SA1') + SC5->C5_CLIENT + SC5->C5_LOJACLI )
							nAliqFre := Val(Subs(cAliqFre,AT(SA1->A1_EST,cAliqFre)+2,2))
							If SM0->M0_ESTENT <> alltrim(SA4->A4_EST)
								If nAliqFre > 0
									If SC5->(C5_FRETAUT+C5_ZVLFRET) > 0
										lRet := .T.
									ElseIf lUFFretAut //Obrigatório o preenchimento do valor do Frete.
										MsgAlert('Nota Fiscal não gerada: Informe o valor do frete para o pedido antes da emissão da Nota Fiscal.')
										lRet := .F. //Aborta a emissão dos doc de saída.
									ElseIf ApMsgYesNo(;
										'Não foi informado o valor do frete no pedido '+ Alltrim(SC5->C5_NUM) +'. Deseja prosseguir com a emissão da Nota Fiscal?',;
										'VALOR DO FRETE NÃO INFORMADO!')
										lRet := .T. //Continua com a geração dos documentos de saída.
									Else
										lRet := .F. //Aborta a emissão dos doc de saída.
										MsgAlert(' A Nota Fiscal não foi gerada. Através da rotina Pedido de Venda, informe o valor do Frete para o pedido antes da emissão da Nota Fiscal.')
									EndIf	
								Else
									MsgAlert('Informe no cadastro de alíquotas o percentual de ICMS do frete para essa operação!')
									lRet := .F. 
								EndIf
							EndIf	
						EndIf	
					EndIf			
				EndIf
			EndIf
		EndIf	
	EndIf	
Return lRet


////INFORMAR VALOR DO FRETE NO PEDIDO
User Function FRETEPED()

	Local cEstPres  := SM0->M0_ESTENT
	Local lUFFretAut := cEstPres $ SuperGetMV("MGF_FIS34E",.T.," ") //Unidades federativas que terão valor de Frete Autônomo.
	Local nValFre    := IIF(lUFFretAut,SC5->C5_FRETAUT,SC5->C5_ZVLFRET)
	Local cMunPres  := SUBSTR(SM0->M0_CODMUN,3,LEN(ALLTRIM(SM0->M0_CODMUN)))
	Local cCFFrete := SPACE(TAMSX3("C5_FRTCFOP")[1])
	Local cTpop    := Space(10)
	Local Odlg
	Local cDescrC  := ""
	Local aRetorno := {}
	Local cAlias1  := ""
	Local cQuery   := ""
	Local aCFCombo :=  Separa(SuperGetMV("MGF_OMS01CF",.T.,"5353,6353,5352,6352"),",",.F.) 
	Local oComboBox
	Private lOk,lCancel
	
	
	If EMPTY(SC5->C5_NOTA) 
	
		nLinDlg := 26   //Primeira linha
		nLesp   := 16   //Espaçamento
		
		DEFINE DIALOG oDlg TITLE "Informações sobre o frete do pedido" FROM 0,0 TO 350,500 PIXEL
		
		@ nLinDlg,08 SAY "Valor Frete:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET nValFre SIZE 90,10 OF oDlg PIXEL PICTURE '@E 999,999,999.99' VALID Positivo(nValFre)
		nLinDlg += nLesp
		
		If lUFFretAut
			@ nLinDlg,08 SAY "UF Frestador:" SIZE  50,10 OF oDlg PIXEL
			@ nLinDlg,58 MSGET cEstPres SIZE 90,10 OF oDlg PIXEL PICTURE '@!'  VALID ExistCpo("SX5","12"+cEstPres) F3 "12"
			nLinDlg += nLesp
			
			@ nLinDlg,08 SAY "Cod Mun.:" SIZE  50,10 OF oDlg PIXEL
			@ nLinDlg,58 MSGET cMunPres SIZE 90,10 OF oDlg PIXEL VALID ExistCpo("CC2",cEstPres+cMunPres)  F3 "CC2"
			nLinDlg += nLesp
			
			@ nLinDlg,08 SAY "CFOP Frete:" SIZE  50,10 OF oDlg PIXEL
			@ nLinDlg,58 MSCOMBOBOX oComboBox VAR cCFFrete SIZE 90,10 ITEMS aCFCombo OF oDlg PIXEL
			nLinDlg += nLesp
		EndIf
		
		
		oTButton := TButton():New( nLinDlg, 120, "&OK",oDlg	,{||AtualValp(lUFFretAut,nValFre,cEstPres,cMunPres,cCFFrete), oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		nLinDlg += nLesp
		
		ACTIVATE DIALOG oDlg CENTERED
		

		
	Else
		MsgAlert('Não é possível informar valor de frete para um pedido já faturado!')
	EndIf
Return

Static Function AtualValp(lUFFretAut,nValFre,cEstPres,cMunPres,cCFFrete)
	
	SC5->(RecLock("SC5",.F.))
		If lUFFretAut
			SC5->C5_FRETAUT := nValFre
			SC5->C5_FRTCFOP := cCFFrete
			SC5->C5_ESTPRES := cEstPres
			SC5->C5_MUNPRES := cMunPres
		Else
			SC5->C5_ZVLFRET := nValFre
		EndIf
	SC5->(MsUnlock())
	
	If SC5->C5_FRETAUT > 0
		MsgInfo('Valor de frete gravado com sucesso!!!')
	EndIf
	
Return


/// Bloqueia faturamento de pedidos que possuem carga

User Function xBlqNota()

Local lRet := .T.

If !IsInCallStack("MATA460B")

	dBselectArea('DAI')
	dbSetOrder(1) 
	If DbSeek(xFilial('DAI')+SC5->C5_NUM)
	
		lRet := .F.
		
		MsgAlert('Não é possível faturar esse pedido, o mesmo está vinculado a uma carga! O pedido somente será faturado pela rotina de faturamento de Cargas!')
	
	EndIf
EndIf	

Return lRet



//=========================================================================
// Função: GetCFFRE
// Descrição: Retorna o CFOP automaticamente, conforme segmento e tipo de operação
// Autor: Natanael Filho
// Data: 10/04/2018
//=========================================================================

Static Function GetCFFRE()
	Local aArea := GetArea()
	Local aAreaZE2 := GetArea("ZE2")
	Local aAreaSC6 := GetArea("SC6")
	Local cCFFre    := ''   //CFOP Frete
	Local cSegUni   := ''   //Segmento da unidade
	Local cCFIni    := ''   //Primeiro dígito da CFOP do Pedido de Venda
	
	//Retorna o CFOP do Pedido de Venda
	DBSelectArea("SC6")
	SC6->(DBSetOrder(1))
	If dbSeek(xFilial("SC6")+SC5->NUM)
		cCFIni := SubSTR(SC6->C6_CF,1,1)
	EndIf
	
	//Retorna o segmento da unidade
	DBSelectArea("ZE2")
	ZE2->(DBSetOrder(1))
	If DBSeek(xFilial("ZE2") + cFilAnt)
		cSegUni := ZE2->ZE2_SEGMEN
	Else
		Help( ,, 'MFGOMS01',, 'Informe o segmento da unidade (ZE2)', 1, 0)
	EndIf
	
	If cSegUni = '1' //Industria
		cCFFre := IIf(cCFIni='5','5352','6352')
	ElseIf cSegUni = '2' //Distribuição
		cCFFre := IIf(cCFIni='5','5353','6353')
	EndIf
	
	RestArea(aAreaZE2)
	RestArea(aAreaSC6)
	RestArea(aArea)
Return cCFFre


/*/
======================================================================================
{Protheus.doc} OMS01A()
Possibilitar limpar o campo tipo de operação da carga na Montagem de Carga Protheus OMS.
@author Antonio Florêncio
@since 15/09/2020
@type Function 
@param 
@return
/*/
User Function OMS01A()
	Local _aGetArea := GetArea()
	If MsgYesNo("Confirma o Reset do tipo de operação da carga?")
		begin transaction
			DAK->(RecLock("DAK",.F.))
			DAK->DAK_ZCDTPO := ' '
			DAK->DAK_ZDESTP := ' '
			DAK->DAK_ZMSG   := " "
			DAK->DAK_ZEXSIM := " "
			DAK->(MsUnlock())
		
			dbSelectArea('GWN')
			dbSetOrder(1)

			If DbSeek(xFilial('GWN')+DAK->DAK_COD + DAK->DAK_SEQCAR) //GWN->NRROM
				GWN->(RecLock('GWN',.F.))
					GWN->GWN_CALC   := "3"
					GWN->GWN_CDTPOP := "**"
				GWN->(MsUnlock())
			EndIf
			U_MGFOMS01()
			MsgAlert('ATENÇÃO!! Reset efetuado com sucesso!')
		End transaction
	EndIf
	RestArea(_aGetArea)
Return
