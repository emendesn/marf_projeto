#Include 'Protheus.ch'
#Include 'topconn.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"





User Function MGFCOM08()

Return

/*
=====================================================================================
Programa............: MC8FilXB
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Realiza Filtro consulta padrão SB1
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Quando chamada pela rotina de solicitação de compra realiza o filtro por Grupo
Alteração 19/03 - Mudança da regra de Produtos Anderson Reis
=====================================================================================
*/
User Function MC8FilXB()

	Local lRet := .T.

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'
		lRet := SB1->B1_GRUPO == _XMGFcGR
	EndIf

Return lRet

/*
=====================================================================================
Programa............: MC8WheP
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Realiza When do campo C1_PRODUTO na solicitação de compra
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza o bloqueio/liberação do campo C1_PRODUTO
=====================================================================================
*/
User Function MC8WheP()

	Local lRet := .T.

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'

		If Type("_XMGFcGR")  <> "U"
			If Empty(_XMGFcGR)
				lRet := .F.
			EndIf
		Else
			lRet := .F.
		EndIf

	EndIf

Return lRet

User Function MC8WheC()

	Local lRet := .T.

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'
		//If Type("_XMGFcCC")  <> "U" .and. !(Empty(_XMGFcCC))
		('ZCUSTGRADE')->(dbGoTop())
		If !(Empty(('ZCUSTGRADE')->CCUSTO))
			lRet := .F.
		EndIf
	EndIf

Return lRet

/*
=====================================================================================
Programa............: MC8ValPo
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Realiza validação do campo C1_PRODUTO na solicitação de compra
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza a validação do campo C1_PRODUTO
=====================================================================================
*/
User Function MC8ValPo()

	Local aArea 	:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaCTT	:= CTT->(GetArea())

	Local lRet  := .T.
	Local cGrp	:= ''
	Local cCC	:= ''
	Local cBlq	:= ''

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'
		('ZCUSTGRADE')->(dbGoTop())
		cGrp := Posicione('SB1',1,xFilial('SB1') + M->C1_PRODUTO, 'B1_GRUPO')

		If Empty(cGrp)
			lRet := .F.
			Alert('Só é Permitido inclusão de produtos na solicitação que possuam Grupo')
		EndIf

		If lRet .and. !(Empty(('ZCUSTGRADE')->GRUPO))

			If lRet .and. ('ZCUSTGRADE')->GRUPO <> cGrp
				lRet := .F.
				Alert('O Produto: ' + AllTrim(M->C1_PRODUTO) + ', pertence ao Grupo: ' + cGrp + ', apenas podem ser selecionados produtos do grupo : ' + ('ZCUSTGRADE')->GRUPO + CRLF +'Obs.: Caso deseje alterar o grupo de produto, cancelar e iniciar novamente a solicitação' )
			EndIf
		EndIf

		If lRet .and. !(Empty(('ZCUSTGRADE')->CCUSTO))//.and. Type("_XMGFcCC") <> "U" .and. !(Empty(_XMGFcCC))

			cCC  := Posicione('SB1',1,xFilial('SB1') + M->C1_PRODUTO, 'B1_CC')
			cBlq := Posicione('CTT',1,xFilial('CTT') + cCC, 'CTT_BLOQ')

			If ('ZCUSTGRADE')->CCUSTO <> cCC .and. cBlq == '2'
				lRet := .F.
				Alert('O Produto: ' + AllTrim(M->C1_PRODUTO) + ', pertence ao Centro de Custo: ' + cCC + ',  apenas podem ser selecionados produtos do centro de custo: ' + ('ZCUSTGRADE')->CCUSTO + CRLF +'Obs.: Caso deseje alterar o centro de custo de produto, cancelar e iniciar novamente a solicitação' )
			EndIf

		EndIf   
		        
		// Validação do Campo B1_ZBLQSC - definido pelo CDM dia 06/08/2019, somente 
		If lRet
            cBloqueia  := Posicione('SB1',1,xFilial('SB1') + M->C1_PRODUTO, 'B1_ZBLQSC')               
            IF cBloqueia == '1'
				lRet := .F.
				Alert('O Produto: ' + AllTrim(M->C1_PRODUTO) + ', está com o campo de bloqueia solicitação ativo no seu cadastro.' )            
            EndIF     
        EndIF
		// 10/08/18
		// tratamento para corrigir erro no padrao, pois na funcao padrao a110produto, chamada no x3_valid do campo c1_produto, o sistema troca a descricao do produto
		// pela descricao do produto da variaval m->c1_produto e como esta funcao eh chamada no x3_vlduser deste campo, ou seja, depois do sistema jah ter trocado a descricao,
		// caso o codigo do produto nao seja validado nesta rotina, a descricao do produto fica alterada para o produto que nao foi validado.
		// foi tentado colocar um gatilho no campo c1_produto contra dominio c1_descri, para tentar resolver via gatilho, mas tambem nao resolveu
		If !lRet
			aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="C1_DESCRI"})] := Posicione('SB1',1,xFilial('SB1') + aCols[n][aScan(aHeader,{|x| Alltrim(x[2])=="C1_PRODUTO"})], 'B1_DESC')
		Endif

	EndIf


	RestArea(aAreaCTT)
	RestArea(aAreaSB1)
	RestArea(aArea)

Return lRet

User Function MC8VLCC(xValue)

	Local lRet := .T.

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'
		If Type("_XMGFcCC") <> "U" .and. !(Empty(_XMGFcCC))
			lRet := AllTrim(xValue) <> AllTrim(_XMGFcCC)
		EndIf
	EndIf

Return lRet

User Function M1C8CCSC1(xValue)

	Local cRet := xValue

	If UPPER(AllTrim(FUNNAME())) == 'MATA110'

		('ZCUSTGRADE')->(dbGoTop())

		If Empty(('ZCUSTGRADE')->CCUSTO)
			RecLock("ZCUSTGRADE",.F.)
			('ZCUSTGRADE')->CCUSTO := cRet
			('ZCUSTGRADE')->(MsUnlock())
		EndIf
	EndIf

Return cRet

User Function MC8GatC1(xValue,cTipo)

	Local aArea 	:= GetArea()
	Local aAreaCTT	:= CTT->(GetArea())
	Local aAreaSBM	:= SBM->(GetArea())

	Local cRet := ''

	Local nPosCC 	 := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_CC' })

	If cTipo == 'CC'

		cRet := Posicione('SB1',1,xFilial('SB1') + xValue, 'B1_CC')
		If !Empty(acols[n,nPosCC])
			If UPPER(AllTrim(FUNNAME())) == 'MATA110'
				dbSelectArea('CTT')
				CTT->(dbSetOrder(1))//CTT_FILIAL+CTT_CUSTO

				If CTT->(DbSeek(xFilial('CTT') + cRet))
					If CTT->CTT_BLOQ == '2'
						('ZCUSTGRADE')->(dbGoTop())
						If Empty(('ZCUSTGRADE')->CCUSTO)
							RecLock("ZCUSTGRADE",.F.)
							('ZCUSTGRADE')->CCUSTO := cRet
							('ZCUSTGRADE')->(MsUnlock())
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	ElseIf cTipo == 'GR'

		cRet := Posicione('SB1',1,xFilial('SB1') + xValue, 'B1_GRUPO')

		If UPPER(AllTrim(FUNNAME())) == 'MATA110'
			('ZCUSTGRADE')->(dbGoTop())
			If Empty(('ZCUSTGRADE')->GRUPO)
				RecLock("ZCUSTGRADE",.F.)
				('ZCUSTGRADE')->GRUPO := cRet
				('ZCUSTGRADE')->(MsUnlock())
			EndIf
		EndIf

	EndIf

	RestArea(aAreaSBM)
	RestArea(aAreaCTT)
	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: MC8M110GET
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de enrada MT110GET
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza aumento do cabeçalho da Solicitação de Compra
=====================================================================================
*/
User Function M110C8GET(aPosObj)

	aPosObj[2][1]	+=	20 //Aumento o Espaçamento
	aPosObj[1][3]	+=	20 //Aumento o Box

Return

/*
=====================================================================================
Programa............: MC8M110TEL
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MT110TEL
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona campos no Ponto de Entrada
=====================================================================================
*/
User Function MC8M110TEL(oDlg,aPosGet,nOpcx,nReg,_XMGFcCC,_XMGFcGR)

	xCriaTab()


	If nOpcx <> 3
		('ZCUSTGRADE')->(dbGoTop())
		RecLock("ZCUSTGRADE",.F.)
		('ZCUSTGRADE')->CCUSTO := SC1->C1_CC
		('ZCUSTGRADE')->GRUPO := SC1->C1_ZGRPPRD
		('ZCUSTGRADE')->APROV := SC1->C1_APROV
		('ZCUSTGRADE')->(MsUnlock())
	EndIf

Return

Static Function xCriaTab()

	Local __aStrut    := { {"CCUSTO","C",TamSX3('C1_CC')[1],0},{"GRUPO","C",TamSX3('B1_GRUPO')[1],0},{"APROV","C",TamSX3('C1_APROV')[1],0} }
	Local cArqThr     := CriaTrab( __aStrut , .T. )

	If Select('ZCUSTGRADE')>0
		('ZCUSTGRADE')->(dbGoTop())
		RecLock("ZCUSTGRADE",.F.)
		('ZCUSTGRADE')->CCUSTO :=''
		('ZCUSTGRADE')->GRUPO :=''
		('ZCUSTGRADE')->APROV :=''
		('ZCUSTGRADE')->(MsUnlock())
	Else

		// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
		dbUseArea( .T., __LocalDriver, cArqThr, "ZCUSTGRADE" , .T. , .F. )

		RecLock("ZCUSTGRADE",.T.)
		('ZCUSTGRADE')->(MsUnlock())
	EndIf

Return

User Function xMG8VGrd()

	Local lRet 	  := .T.

	Local cCC	  := ''
	Local cGrp	  := ''
	Local nPosCC  := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_CC' })
	Local nPosGRP := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_ZGRPPRD' })

	Local cFld	  := StrTran(READVAR(),'M->')
	('ZCUSTGRADE')->(dbGoTop())
	If Empty(('ZCUSTGRADE')->CCUSTO) .OR. Empty(('ZCUSTGRADE')->GRUPO)

		If cFld == 'C1_CC'
			cCC := &(READVAR())
		Else
			cCC := aCols[n,nPosCC]
		EndIf

		If cFld == 'C1_ZGRPPRD'
			cGrp := &(READVAR())
		Else
			cGrp := aCols[n,nPosGRP]
		EndIf

		If !(Empty(cCC)) .AND. !(Empty(cGrp))
			If !(Empty(cCC)) .and. !(Empty(cGrp))
				lRet := U_MC6ExisGA('SC',cCC,cGrp)
				If !lRet
					If IsBlind()
						Help(" ",1,'SEMGRADE',,'Não existe grade técnica cadastrada para este CENTRO DE CUSTO + GRUPO DE PRODUTOS.'+CRLF+;
						'Esta SC não será gravada. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.',1,0)
					Else
						Alert('Não existe grade técnica cadastrada para este CENTRO DE CUSTO (' + Alltrim(cCC) + ') + GRUPO DE PRODUTOS (' + Alltrim(cGrp) + '). Esta SC não será gravada. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.')
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return lRet

User Function MC8VPSC1(cProd)

	Local aArea 	:= GetArea()
	Local aAreaSB1 	:= SB1->(GetArea())
	Local lRet 		:= .T.
	Local cGrp		:= ''

	('ZCUSTGRADE')->(dbGoTop())
	If !Empty(('ZCUSTGRADE')->GRUPO)
		cGrp := POSICIONE('SB1',1,xFilial('SB1') + cProd,'B1_GRUPO')
		lRet := Alltrim(cGrp) == ('ZCUSTGRADE')->GRUPO
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: MC8M110GRV
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MT110GRV
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona grava o cc e adiciona no acols
=====================================================================================
*/
User Function MC8M110GRV()

	Local nPosCC := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_CC' })

	('ZCUSTGRADE')->(dbGoTop())
	//aCols[Val(SC1->C1_ITEM),nPosCC] := ('ZCUSTGRADE')->CCUSTO

	RecLock("SC1",.F.)
	SC1->C1_CC   	:= ('ZCUSTGRADE')->CCUSTO
	SC1->C1_ZBLQFLG := 'S'
	SC1->C1_ZIDINTE := Space(TamSx3('C1_ZIDINTE')[1])
	If lCopia
		SC1->C1_ZCODFLG := ' '
	EndIf
	SC1->(MsUnlock())

Return

User Function xMC8AtBLQ()

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())

	RecLock("SC1",.F.)
	SC1->C1_ZBLQFLG := 'S'
	SC1->C1_ZIDINTE := Space(TamSx3('C1_ZIDINTE')[1])
	SC1->(MsUnlock())

	RestArea(aAreaSC1)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MC8M110FIM
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MTALCFIM
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Após a gravação da alçada de aprovação
=====================================================================================
*/
User Function MC8M110FIM()

	If Alltrim(PARAMIXB[1][2]) == 'SC' .and. UPPER(AllTrim(FUNNAME())) <> 'MGFCOM14' .and. PARAMIXB[3] <> 3//!IsInCallStack('A097Ausente')
		If !IsInCallStack('U_xMC8PosAlc') .and. !IsInCallStack('U_xMC11ASc') .and. !IsInCallStack('U_xMC11BSc') .and. !IsInCallStack('U_xMC11RSc')
			U_xMC8PosAlc()
		EndIf
	EndIf

Return

/*
=====================================================================================
Programa............: xMC8PosAlc
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MTALCFIM
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Após a gravação da alçada de aprovação
=====================================================================================
*/
User Function xMC8PosAlc()

	Local aDocto   := PARAMIXB[1]
	Local dDataRef := PARAMIXB[2]
	Local nOper    := PARAMIXB[3]
	Local cDocSF1  := PARAMIXB[4]
	Local lResiduo := PARAMIXB[5]

	Local cDelet   := ''


	If aDocto[2] == "SC"

		//Deleta SCR que acabou de gerar
		MaAlcDoc(aDocto,,3)

		cDelet := "delete " + RetSQLName("SCR") + " SCR " + CRLF
		cDelet += " WHERE  SCR.D_E_L_E_T_ = '*' AND SCR.CR_FILIAL = '" + xFilial('SCR') + "' AND " + CRLF
		cDelet += " SCR.CR_TIPO = 'SC' AND SCR.CR_NUM = '" + cA110Num + "' "

		TcSQLExec(cDelet)

		//Realiza inclusão
		//XMC8CAD("SC1","SCX",cA110Num,"SC",aHeader,aCols,/*aHeadSCX*/,/*aColsSCX*/,1,dA110Data)
		//xGerAlcSC(cA110Num)
	EndIf

Return

User Function xM8GASC(cNum,nOpx)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local cRet := ''

	Local nPosCC 	 := 0//aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_CC' })
	Local nPosPro	 := 0//aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_PRODUTO' })

	Local cCC 		 := ''//aCols[1][nPosCC]
	Local cProd		 := ''//aCols[1][nPosPro]
	Local cGrupo	 := ''//POSICIONE('SB1',1,xFilial('SB1') + cProd , 'B1_GRUPO')

	Local aGrupo 	 :=	''//xEncAlc('SC',cCC,cGrupo,/*cNaturez*/)

	Local cNextAlias 	:= GetNextAlias()

	Local nIt			:= 1

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD

	If SC1->(dbSeek(xFilial('SC1') + cNum))

		If !IsBlind()
			if nOpx == 2 .AND. SC1->C1_ENVGRAD == "N"
				('ZCUSTGRADE')->(dbGoTop())
				While SC1->(!EOF()) .and. SC1->(C1_FILIAL+C1_NUM) == xFilial('SC1') + cNum
					RecLock("SC1",.F.)
					SC1->C1_APROV := ('ZCUSTGRADE')->APROV
					SC1->(MsUnlock())
					SC1->(dbSkip())
				EndDo
				return
			EndIf
		ENdIf

		cCC 		 := SC1->C1_CC
		cProd		 := SC1->C1_PRODUTO
		cGrupo	 	:= POSICIONE('SB1',1,xFilial('SB1') + cProd , 'B1_GRUPO')

		aGrupo 	 :=	xEncAlc('SC',cCC,cGrupo,/*cNaturez*/)

		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

		If SCR->(dbSeek(xFilial('SCR') + 'SC' + PadR(cNum,TamSX3('CR_NUM')[1])))
			While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'SC' + PadR(cNum,TamSX3('CR_NUM')[1])
				RecLock('SCR',.F.)
				SCR->(dbDelete())
				SCR->(MsUnLock())
				SCR->(dbSkip())
			EndDo
		EndIf

		BeginSql Alias cNextAlias

			SELECT
			ZAD_SEQ,
			ZAD_NIVEL,
			ZA2_CODUSU
			FROM %Table:ZAD% ZAD
			INNER JOIN %Table:ZA2% ZA2
			ON ZA2_FILIAL = ZAD_FILIAL AND
			ZA2_NIVEL =  ZAD_NIVEL  AND
			ZA2_EMPFIL = %xFilial:SC1%
			WHERE
			ZAD.%NotDel% AND
			ZA2.%NotDel% AND
			ZA2.ZA2_LOGIN <> ' ' AND
			ZAD_FILIAL = %xFilial:ZAD% AND
			ZAD_CODIGO = %Exp:aGrupo[1]% AND
			ZAD_VERSAO = %Exp:aGrupo[2]% AND
			ZAD_GRPPRD = %Exp:cGrupo%
			ORDER BY ZAD_SEQ

		EndSql

		While (cNextAlias)->(!EOF())

			RecLock('SCR',.T.)

			SCR->CR_FILIAL 	:= xFilial('SCR')
			SCR->CR_NUM 	:= cNum
			SCR->CR_TIPO 	:= 'SC'
			SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU
			SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
			SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ
			SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
			SCR->CR_EMISSAO	:= dDataBase
			SCR->CR_ZCODGRD := aGrupo[1]
			SCR->CR_ZVERSAO := aGrupo[2]
			SCR->CR_ZGRPPRD := cGrupo
			SCR->CR_ZNIVEL  := (cNextAlias)->ZAD_NIVEL

			SCR->(MsUnlock())
			nIt ++

			(cNextAlias)->(dbSkip())
		EndDo
		/*If nOpx == 1
		U_xPrcFluig('P','I','SC1',SC1->(RECNO()),"S",'','')
		ElseIf nOpx == 2
		U_xPrcFluig('P','U','SC1',SC1->(RECNO()),"S",'','')
		EndIf*/

		While SC1->(!EOF()) .and. SC1->(C1_FILIAL+C1_NUM) == xFilial('SC1') + cNum

			RecLock('SC1',.F.)
			SC1->C1_ZCODGRD := aGrupo[1]
			SC1->C1_ZVERSAO := aGrupo[2]
			SC1->C1_APROV	:= "B"
			SC1->(MsUnlock())

			SC1->(dbSkip())
		EndDo

	EndIf

	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

return

/*
=====================================================================================
Programa............: XMC8CAD
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Realiza a gravação do grupo de aprovação correto
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Após a gravação da alçada de aprovação é gravado a alçada correta
=====================================================================================
*/
Static Function XMC8CAD(cAlias,cAlsRat,cDocto,cTpDoc,aHeader,aCols,aHeadRat,aColsRat,nOpcao,dDtDoc)

	Local oModel		:= Nil

	Local aItens  		:= {}
	Local aAglut		:= {}
	Local aEntCtb		:= {}
	Local aAlcDoc		:= {}
	Local aGrpAprov		:= {}
	Local aItensDBM		:= {}
	Local cTpAprCtEc	:= SuperGetMV("MV_CTAPREC",.F.,"0")
	Local cItemPln		:= ""
	Local cItemDoc		:= ""
	Local cItemApr		:= ""
	Local cAlsCpo		:= ""
	Local cGrpAprov 	:= ""
	Local cItAprov		:= ""
	Local cTipcom		:= ""
	Local cCpo	 		:= ""
	Local cNumDoc		:= ""

	Local lContinua		:= .T.
	Local lDelItem		:= .F.
	Local lDeleta		:= Iif( nOpcao == 3, .T. , .F. )
	Local lEstorna	:= Iif( ( (nOpcao == 2) .OR. (nOpcao == 3) ) , .T. , .F. )
	Local lGerouApv	:= .F.
	Local lFirstNiv	:= .F.
	Local lEntCtb		:= .T.
	Local lGravaB		:= .F.
	Local lGravaL		:= .F.
	Local lCtAprEc	:= .F.

	Local nPosIt		:= 0
	Local nPosQtd 	:= 0
	Local nPosVlr		:= 0
	Local nPosPrd		:= 0
	Local nPosPln		:= 0
	Local nPosRev		:= 0
	Local nPosItCtb		:= 0
	Local nPosTipCom	:= 0
	Local nForIt		:= 0
	Local nVlrIt		:= 0
	Local nRateio		:= 0
	Local nX			:= 0
	Local nZ			:= 0

	Default aHeadRat	:= {}
	Default aColsRat	:= {}

	//-- Caso seja alias iniciado com S desconsidera a primeira letra
	If SubStr(cAlias,1,1) == "S"
		cAlsCpo := SubStr(cAlias,2,Len(cAlias) )
	Else
		cAlsCpo := cAlias
	EndIf

	//-- Verifica Planilha do Item caso seja IC, IR ou IM
	If cTpDoc $ "IC|IR|IM"
		cCpo := cAlsCpo + "_NUMERO"
		If lContinua .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
			nPosPln := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
		ElseIf lContinua
			lContinua := .F.
		EndIf
	EndIf

	//-- Verifica Revisão do Item caso seja IC, IR ou IM
	If cTpDoc $ "IC|IR|IM"
		cCpo := cAlsCpo + "_REVISA"
		If lContinua .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
			nPosRev := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
		ElseIf lContinua
			lContinua := .F.
		EndIf
	EndIf

	//-- Verifica posicao do item
	cCpo := cAlsCpo + "_ITEM"
	If lContinua .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
		nPosIt := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
	ElseIf lContinua
		lContinua := .F.
	EndIf

	//-- Verifica posicao da Qtde
	cCpo := cAlsCpo + "_QUANT"
	If lContinua .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
		nPosQtd := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
	ElseIf lContinua
		lContinua := .F.
	EndIf

	//-- Verifica posicao do Produto
	If cTpDoc $ "IC|IR|IM"
		cCpo := cAlsCpo + "_PRODUT"
	Else
		cCpo := cAlsCpo + "_PRODUTO"
	EndIf

	If lContinua .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
		nPosPrd := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
	ElseIf lContinua
		lContinua := .F.
	EndIf

	//-- Verifica posicao do Valor caso seja IP, IC ou IR
	If cTpDoc $ "IC|IR|IM"
		cCpo := cAlsCpo + "_VLUNIT"
	ElseIf cTpDoc == "SC"
		cCpo := cAlsCpo + "_VUNIT"
	Else
		cCpo := cAlsCpo + "_PRECO"
	EndIf

	If lContinua .AND. cTpDoc $ "IP|IC|IR|IM|SC" .AND. !Empty( (cAlias)->( FieldPos(cCpo) ) )
		nPosVlr := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
	ElseIf (cTpDoc == "IP" ) .AND. lContinua
		lContinua := .F.
	EndIf

	//-- Verifica posicao do Tipo de Compra
	If lContinua .And. cTpDoc $ "SC|IP"
		cCpo := cAlsCpo + "_TIPCOM"
		nPosTipCom := aScan(aHeader, {|x| Alltrim(x[2]) == cCpo })
	EndIf

	If lContinua
		//-- Para cada item, preenche o array para aglutinacao
		For nForIt := 1 to Len(aCols)
			//-- Valida item deletado
			If ValType( aCols[nForIt][Len( aCols[nForIt] )] ) == "L"
				lDelItem := aCols[nForIt][Len( aCols[nForIt] ) ]
			EndIf

			If !lDelItem
				cItemDoc	:= aCols[nForIt][nPosIt]
				If nPosTipCom > 0
					cTipCom		:= aCols[nForIt][nPosTipCom]
				EndIf

				//-- Verifica se o item possui rateio
				If cTpDoc $ "IC|IR|IM"
					nPosItCtb := aScan(aHeadRat, {|x| Alltrim(x[2]) == 'CNZ_ITCONT' })
					nRateio := aScan(aColsRat, {|x| x[nPosItCtb] == cItemDoc})
				Else
					nRateio := aScan(aColsRat, {|x| x[1] == cItemDoc .And. !Empty(x[2])} )

					If(nRateio > 0 .And. Empty(aColsRat[nRateio][2][1][2]))
						nRateio := 0 //tratativa para pedido por cotação pois ele cria o aColsRat mesmo sem rateio com os campos da SCH vazios
					EndIf
				EndIf

				If cTpDoc $ "IP|IC|IR|IM|SC"
					nVlrIt := aCols[nForIt][nPosVlr]
				Else
					If cTpDoc $ "SA"
						nVlrIt := MTGetVProd(aCols[nForIt][nPosPrd],cTpDoc)
					EndIf
				EndIf
				If nVlrIt == 0
					nVlrIt := MTGetVProd(aCols[nForIt][nPosPrd],cTpDoc)
				EndIf
				nVlrIt := nVlrIt * aCols[nForIt][nPosQtd]

				If nRateio == 0
					//-- Carrega array com as entidades contabeis
					aEntCtb := MtGetValEC(cAlias, cAlsCpo, aHeader, aCols, nForIt, {} )

					If cTpDoc $ "IC|IR|IM"
						If !(Empty(aEntCtb[1][1]) .AND. Empty(aEntCtb[1][2]) .AND. Empty(aEntCtb[1][3]))
							Aadd(aItens,{cDocto,cItemDoc,"",nVlrIt,aClone(aEntCtb[1]),cTipCom})
						EndIf
					Else
						Aadd(aItens,{cDocto,cItemDoc,"",nVlrIt,aClone(aEntCtb[1]),cTipCom})
					EndIf
				Else
					//-- Rotina para montagem do array de rateio
					If cTpDoc $ "IC|IR|IM"
						lContinua := MaMtRateio(cAlsRat,cDocto,cItemDoc,nVlrIt,@aItens,aHeadRat,aColsRat,cTipCom)
					Else
						lContinua := MaMtRateio(cAlsRat,cDocto,cItemDoc,nVlrIt,@aItens,aHeadRat,aColsRat[nRateio][2],cTipCom)
					EndIf
				EndIf
			EndIf
			If !lContinua
				Exit
			EndIf

			lDelItem := .F.
		Next nForIt
	EndIf

	If lContinua
		//-- Estorna todas as aprovacoes do documento caso necessario
		If lEstorna
			MaEstAlcEC(cDocto,cTpDoc,dDtDoc)
		EndIf

		//-- Funcao para aglutinar os itens por entidade ctb
		aAglut := MaRetAglEC( aItens , cTpDoc )


		//-- Gera SCR para cada entidade contabil
		For nForIt := 1 to Len(aAglut)

			//-- Busca grupo de aprovadores
			aGrpAprov		:= MaGrpApEC( aClone(aAglut[nForIt][4]),@lEntCtb,cTpDoc)
			cGrpAprov 		:= Iif( Len(aGrpAprov) >= 1 , aGrpAprov[1] , "")
			cItAprov		:= Iif( Len(aGrpAprov) >= 2 , aGrpAprov[2] , "")

			If cTpDoc $ "IC|IR|IM"
				If ((cTpDoc == "IC" .And. cTpAprCtEc $ "1|3") .Or. (cTpDoc == "IR" .And. cTpAprCtEc $ "2|3"))
					cGrpAprCt 	:= 	CnGetAprDc(cDocto,,cTpDoc)
					lCtAprEc 	:=	cGrpAprCt == cGrpAprov
				EndIf

				If nForIt <= Len(aCols) .AND. cItemPln <> aCols[nForIt][nPosPln]
					cItemPln	:= aCols[nForIt][nPosPln]
					cItemApr := "000"
				EndIf
				cItemApr := soma1(cItemApr)

				If !lCtAprEc
					cNumDoc := AllTrim(aAglut[nForIt][1])+cItemPln+cItemApr

					aAlcDoc := { cNumDoc		,; 		// Num. Documento
					cTpDoc						,; 		// Tipo Doc.
					aAglut[nForIt][3]			,; 		// Valor aprovac.
					,;		// Aprovador
					,;		// Cod. Usuario
					cGrpAprov					,;		// Grupo Aprovac.
					,;		// Aprov. Superior
					,;		// Moeda Docto
					,;		// Taxa da moeda
					dDtDoc						}		// Data Emissao
				Else
					cItemApr := Tira1(cItemApr)
				EndIf
			Else
				aAlcDoc := { aAglut[nForIt][1]		,; 		// Num. Documento
				cTpDoc				,; 		// Tipo Doc.
				aAglut[nForIt][3]		,; 		// Valor aprovac.
				,;		// Aprovador
				,;		// Cod. Usuario
				cGrpAprov				,;		// Grupo Aprovac.
				,;		// Aprov. Superior
				,;		// Moeda Docto
				,;		// Taxa da moeda
				dDtDoc				}		// Data Emissao
			EndIf

			//-- Chama rotina para controle de alcada da SC
			If !lDeleta .And. !lCtAprEc
				aAlcDoc[6] := xMC8ApGru()//Carrega o Grupo Correto
				lFirstNiv := MaAlcDoc(aAlcDoc,,1,,,cItAprov,aClone(aAglut[nForIt,2]),,@aItensDBM)
				For nX := 1 To Len(aAglut[nForIt,2])
					Do Case
						Case cTpDoc $ "SC|SA|IP"
						If (cAlias)->(dbSeek(xFilial(cAlias)+aAglut[nForIt,1]+aAglut[nForIt,2,nX,1]))
							lGravaB := aScan(aItensDBM , {|x| x == PadR(aAglut[nForIt,2,nX,1],Len(DBM->DBM_ITEM))}) > 0
							lGravaL := MtGLastDBM(cTpDoc,aAglut[nForIt,1],aAglut[nForIt,2,nX,1])

							RecLock(cAlias,.F.)
							Do Case
								Case cTpDoc == "SC"
								SC1->C1_APROV := If(lGravaB,"B",If(lGravaL,"L",	SC1->C1_APROV))
								Case cTpDoc == "SA"
								SCP->CP_STATSA := If(lGravaB,"B",If(lGravaL,"L",SCP->CP_STATSA))
								Case cTpDoc == "IP"
								SC7->C7_CONAPRO := If(lGravaB,"B",If(lGravaL,"L",SC7->C7_CONAPRO))
							EndCase
							(cAlias)->(MsUnlock())
						EndIf
						Case cTpDoc == "IC"
						If CN9->(dbSeek(xFilial('CN9')+aAglut[nForIt,1]+aAglut[nForIt,2,nX,1]))
							RecLock("CN9",.F.)
							CN9->CN9_SITUAC := "04"
							CN9->(MsUnlock())
						EndIf
						Case cTpDoc == "IR"
						CN9->(dbSetOrder(1))
						If CN9->(dbSeek(xFilial('CN9')+aAglut[nForIt,1]))
							RecLock("CN9",.F.)
							CN9->CN9_SITUAC := "A"
							CN9->(MsUnlock())
						Else
							oModel := FwModelActive()
							oModel:LoadValue("CN9MASTER","CN9_SITUAC","A")
						EndIf
						Case cTpDoc $ "MD|IM"
						CND->(dbSetOrder(4))
						If CND->(dbSeek(xFilial('CND')+aAglut[nForIt,1]))
							RecLock("CND",.F.)
							CND->CND_ALCAPR := "B"
							CND->CND_SITUAC := "B"
							CND->(MsUnlock())
						EndIf
					EndCase
				Next nX
			EndIf

			If !lGerouApv .And. !lFirstNiv .And. !lCtAprEc
				lGerouApv := .T.
			EndIf
		Next nForIt
	EndIf

Return lGerouApv

Static Function xEncAlc(cTipo,cCC,cGrupo,cNaturez)

	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()
	Local aRet			:= {'','',''}

	Local cGrdAvRec		:= GETMV("MGF_GRDAR")//Grade Aviso de Recebimento

	Default cGrupo   := ''
	Default cNaturez := ''

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If cTipo = 'SC'

		BeginSql Alias cNextAlias
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAC.ZAC_GRPPRD
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAC% ZAC
			ON ZAC.ZAC_FILIAL = ZAB.ZAB_FILIAL
			AND ZAC.ZAC_CODIGO = ZAB.ZAB_CODIGO
			AND ZAC.ZAC_VERSAO = ZAB.ZAB_VERSAO
			WHERE
			ZAB.%NotDel% AND
			ZAC.%NotDel% AND
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAB.ZAB_TIPO = 'T' AND
			ZAB.ZAB_CC = %Exp:cCC% AND
			ZAB.ZAB_HOMOLO = 'S' AND
			ZAC.ZAC_GRPPRD = %Exp:cGrupo%
		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,(cNextAlias)->ZAC_GRPPRD }
			(cNextAlias)->(dbSkip())
		EndDo

	ElseIf cTipo = 'PC'

		If SC7->C7_TIPO = 1
			BeginSql Alias cNextAlias
				SELECT
				ZAB.ZAB_CODIGO,
				ZAB.ZAB_VERSAO
				FROM
				%Table:ZAB% ZAB
				WHERE
				ZAB.%NotDel% AND
				ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
				ZAB.ZAB_TIPO = 'P' AND
				ZAB.ZAB_CC = %Exp:cCC% AND
				ZAB.ZAB_HOMOLO = 'S'
			EndSql
		Else
			BeginSql Alias cNextAlias
				SELECT
				ZAB.ZAB_CODIGO,
				ZAB.ZAB_VERSAO
				FROM
				%Table:ZAB% ZAB
				WHERE
				ZAB.%NotDel% AND
				ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
				ZAB.ZAB_TIPO = 'P' AND
				ZAB.ZAB_CODIGO = %Exp:cGrdAvRec% AND
				ZAB.ZAB_HOMOLO = 'S'
			EndSql
		EndIf
		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,' '}
			(cNextAlias)->(dbSkip())
		EndDo

	ElseIf cTipo = 'ZC'

		BeginSql Alias cNextAlias
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAE.ZAE_NATURE
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAE% ZAE
			ON ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL
			AND ZAE.ZAE_CODIGO = ZAB.ZAB_CODIGO
			AND ZAE.ZAE_VERSAO = ZAB.ZAB_VERSAO
			WHERE
			ZAB.%NotDel% AND
			ZAE.%NotDel% AND
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAB.ZAB_TIPO = 'T' AND
			ZAB.ZAB_CC = %Exp:cCC% AND
			ZAB.ZAB_HOMOLO = 'S' AND
			ZAE.ZAE_NATURE = %Exp:cNaturez%
		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,(cNextAlias)->ZAE_NATURE}
			(cNextAlias)->(dbSkip())
		EndDo

	EndIf

	RestArea(aArea)

return aRet

/*
=====================================================================================
Programa............: xMC8ApGru
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Encontra o Grupo de Aprovação correto
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Busca o Grupo de aprovação com a alçada correta
=====================================================================================
*/
Static Function xMC8ApGru()

	Local aArea := GetArea()

	Local nPosCC 	 := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_CC' })
	Local nPosPro	 := aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_PRODUTO' })

	Local cRet 		 := ''
	Local cCC 		 := aCols[1][nPosCC]
	Local cProd		 := aCols[1][nPosPro]
	Local cGrup		 := POSICIONE('SB1',1,xFilial('SB1') + cProd , 'B1_GRUPO')
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
		DBL_GRUPO,
		AL_ZCODGRD,
		AL_ZVERSAO
		FROM
		%Table:DBL% DBL
		INNER JOIN %Table:SAL% SAL
		ON DBL.DBL_FILIAL = SAL.AL_FILIAL
		AND DBL.DBL_GRUPO = SAL.AL_COD
		INNER JOIN %Table:ZAB% ZAB
		ON SAL.AL_ZCODGRD = ZAB.ZAB_CODIGO
		AND SAL.AL_ZVERSAO = ZAB.ZAB_VERSAO
		WHERE
		DBL.DBL_FILIAL = %xFilial:DBL% AND
		ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
		DBL.%NotDel% AND
		SAL.%NotDel% AND
		ZAB.%NotDel% AND
		SUBSTRING(SAL.AL_ZCODGRD,1,1) = 'T' AND
		DBL.DBL_CC = %Exp:cCC% AND
		DBL.DBL_ZGRUPO = %Exp:cGrup% AND
		ZAB.ZAB_HOMOLO = 'S'

		ORDER BY DBL_GRUPO, AL_ZCODGRD, AL_ZVERSAO

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->DBL_GRUPO
		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: MC8M140GET
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MT120TEL
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona campos no Ponto de Entrada
=====================================================================================
*/
User Function MC8MGET120(aPosObj)

	aPosObj[2][1]	+=	20 //Aumento o Espaçamento
	aPosObj[1][3]	+=	20 //Aumento o Box

Return

/*
=====================================================================================
Programa............: MC8M120TEL
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada MT120TEL
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Adiciona campos no Ponto de Entrada
=====================================================================================
*/
User Function MC8MTEL120()

	Local oDlg		 := PARAMIXB[1]
	Local oC7XCC	 := nil

	Local aPosGet	 := PARAMIXB[2]
	Local aObj		 := PARAMIXB[3]
	Local nOpcx		 := PARAMIXB[4]
	Local nReg		 := PARAMIXB[5]

	Local lEditCC	 := .T.

	If Type("_XMGFcCC")  == "U"
		Public _XMGFcCC	 := ''
	Else
		_XMGFcCC := ''
	EndIf

	If Type("_XMGFcCON")  == "U"
		Public _XMGFcCON	 := ''
	Else
		_XMGFcCON := ''
	EndIf

	If Type("_XMGFcCON")  == "U"
		Public _XMGFcCON	 := ''
	Else
		_XMGFcCON := ''
	EndIf

	If Type("_XMGFASCR")  == "U"
		Public _XMGFASCR	 := {}
	Else
		_XMGFASCR := {}
	EndIf

	If nOpcx == 3
		_XMGFcCC := Space(TamSX3('C7_CC')[1])
		//_XMGFcGR := Space(TamSX3('B1_GRUPO')[1])
	Else
		_XMGFcCON := SC7->C7_CONAPRO
		_XMGFASCR := xEncGrade()
		If !Empty(SC7->C7_CC)
			_XMGFcCC := SC7->C7_CC
		Else
			_XMGFcCC := SC7->C7_ZCC
		EndIf
		//_XMGFcGR := POSICIONE('SB1',1,xFilial('SB1') + SC7->C7_PRODUTO,'B1_GRUPO')
		lEditCC  := .F.
	EndIf

	@ 74,aPosGet[1,1] SAY GetSx3Cache("C7_CC" , "X3_TITULO") OF oDlg PIXEL SIZE 045,009
	@ 73,aPosGet[1,2] MSGET oC7XCC VAR _XMGFcCC F3 CpoRetF3("C7_CC") VALID Vazio().or.ExistCpo("CTT",_XMGFcCC) WHEN lEditCC OF oDlg PIXEL SIZE 045,010 /*Eval( bXDTPPAGVld ) 	WHEN Eval( bXDTPPAGWhen )*/

Return

Static Function xEncGrade()

	Local aArea		 := GetArea()
	Local aAreaSX3 	 := SX3->(GetArea())
	Local cNextAlias := GetNextAlias()
	Local cFld		 := ""
	Local aCampo	:= {}
	Local aCont		:={}

	SX3->(dbSetOrder(1))//X3_ARQUIVO+X3_ORDER

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT R_E_C_N_O_
		FROM %Table:SCR% SCR
		WHERE
		SCR.%NotDel% AND
		SCR.CR_FILIAL = %xFilial:SCR% AND
		SCR.CR_NUM = %Exp:SC7->C7_NUM% AND
		SCR.CR_TIPO = 'PC'

	EndSQL

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		SCR->(dbGoTo((cNextAlias)->R_E_C_N_O_))
		aCont		:={}
		If SX3->(dbSeek("SCR"))
			While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == "SCR"
				If SX3->X3_CONTEXT <> "V"
					dbSelectArea(cNextAlias)
					cFld := 'SCR->' + SX3->X3_CAMPO
					AADD(aCont,{SX3->X3_CAMPO, &(cFld)})
				EndIf
				SX3->(DbSkip())
			EndDo
			AADD(aCampo,aCont)
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaSX3)
	RestArea(aArea)

Return aCampo

/*
=====================================================================================
Programa............: xMC8TSSC
Autor...............: Joni Lima
Data................: 25/01/2016
Descrição / Objetivo: Utilizado no Ponto de Entrada M110STTS
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Carrega os dados e envia ao Fluig
=====================================================================================
*/
User Function xMC8TSSC(cSC,nOpx)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local aDados	:= {}

	//Inclui SC de Compra
	If nOpx <> 3
		aDados := xPreDadSC(cSC)//Preparada Array com os Dados
		If Len(aDados) > 0
			U_xMC10GerSol(aDados)//Envia Dados para o Fluig
		EndIf
	EndIf

	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xPreDadSC
Autor...............: Joni Lima
Data................: 25/01/2016
Descrição / Objetivo: Realiza a preparação dos dados para envio ao Fluig
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Prepara Array com Cabeçalho, Itens e Alçada de Aprovação
=====================================================================================
*/
Static Function xPreDadSC(cSC)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}

	Local cChvSCR	:= ''
	Local cRateio	:= ''

	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf

	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD

	If SC1->(DbSeek( xFilial('SC1') + cSC))

		//Cabeçalho
		AADD(aCabSol,SC1->C1_FILIAL)
		AADD(aCabSol,SC1->C1_NUM)
		AADD(aCabSol,SC1->C1_SOLICIT)
		AADD(aCabSol,DtoC(SC1->C1_EMISSAO))
		AADD(aCabSol,SC1->C1_UNIDREQ)
		AADD(aCabSol,FWFilialName())
		AADD(aCabSol,UsrRetMail(RetCodUsr()))

		AADD(aDados,aCabSol)

		//Itens da Solicitação de Compra
		While SC1->(!Eof()) .and. xFilial('SC1') + cSC == SC1->(C1_FILIAL + C1_NUM)

			aItemSol  := {}

			cRateio := IIF(SC1->C1_RATEIO=='1','Sim','Não')

			AADD(aItemSol,SC1->C1_ITEM)
			AADD(aItemSol,SC1->C1_PRODUTO)
			AADD(aItemSol,POSICIONE('SB1',1,xFilial('SB1') + SC1->C1_PRODUTO,'B1_GRUPO'))
			AADD(aItemSol,SC1->C1_UM)
			AADD(aItemSol,SC1->C1_DESCRI)
			AADD(aItemSol,TRANSFORM(SC1->C1_QUANT,'@E 999999999.99'))
			AADD(aItemSol,DtoC(SC1->C1_DATPRF))
			AADD(aItemSol,SC1->C1_OBS)
			AADD(aItemSol,SC1->C1_CC)
			AADD(aItemSol,SC1->C1_CONTA)
			AADD(aItemSol,SC1->C1_ITEMCTA)
			AADD(aItemSol,SC1->C1_CLVL)
			AADD(aItemSol,TRANSFORM(SC1->C1_VUNIT,'@E 999,999,999.99'))
			AADD(aItemSol,SC1->C1_FLAGGCT)
			AADD(aItemSol,cRateio)

			AADD(aGrpSol,aItemSol)

			SC1->(dbSkip())
		EndDo

		AADD(aDados,aGrpSol)

		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR') + 'SC' + cSC
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,6)

				aAprov := {}

				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])

				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo

			AADD(aDados,aGrpAprov)

		EndIf

	EndIf

	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return aDados

User Function MGFc8USER(cCodUsu)

	Local 	cRet 	:= ''//IIF(INCLUI,'',)
	Local 	nPos 	:= 0

	If ValType(__aXAllUser) == 'A'
		nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(cCodUsu)})
		If nPos > 0
			cRet := Alltrim(__aXAllUser[nPos][4])
		EndIf
	Else
		cRet := AllTrim(UsrFullName(__aXAllUser))
	EndIf

Return cRet

User Function xMG8FIM(cPed,nOpx,nOpca)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())

	Local cRet := ''
	Local cChavSC7  := xFilial('SC7') + cPed
	Local cCC 		 := ''

	Local cNextAlias 	:= GetNextAlias()

	Local nIt			:= 1
	Local nTotal		:= xTotPed(cPed)
	Local cNome			:= xNomFoPC(cPed)

	Local cConaPro		:= ''

	local cQryEET		:= ""
	local lGradeExp		:= .T.

	Default nOpca		:= 1

	if isInCallStack("U_MGFEEC68") .or. isInCallStack("U_MGFEEC73")
		// SE PRE CALCULO ESTIVER OK - NAO GERA GRADE PARA O PEDIDO
		lGradeExp := lGradeSC7
	endif

	// Mercado Eletronico 28/02/2020. Não deve gerar grade de aprovação para o ME.
	If isInCallStack("U_MGFWSC48")	
		Return
	Endif

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If !(IsBlind())
		//Ponto para não enviar para Grade novamente
		If SC7->(dbSeek(cChavSC7))
			if nOpx == 4 .AND. SC7->C7_ENVGRAD == "N"

				cConaPro := _XMGFcCON//xAprSC7(SC7->C7_NUM)
				While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cChavSC7
					Reclock('SC7',.F.)
					SC7->C7_CONAPRO := cConaPro
					SC7->(MsUnLock())
					SC7->(dbSkip())
				EndDo

				xCriGRDT(cPed)

				Return
			Endif
		EndIf
	EndIf

	//Inclui PC
	If (nOpx == 4 .or. nOpx == 3 .or. nOpx == 9) .and. nOpca == 1 .and. lGradeExp
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

		//Bloquar Pedido
		If SC7->(dbSeek(cChavSC7))

			If !Empty(SC7->C7_CC)
				cCC := SC7->C7_CC
			Else
				cCC := SC7->C7_ZCC
			EndIf

			aGrupo 	 :=	xEncAlc('PC',cCC,/*cGrupo*/,/*cNaturez*/)

			dbSelectArea('SCR')
			SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

			If SCR->(dbSeek(xFilial('SCR') + 'PC' + PadR(cPed,TamSX3('CR_NUM')[1])))
				While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'PC' + PadR(cPed,TamSX3('CR_NUM')[1])
					RecLock('SCR',.F.)
					SCR->(dbDelete())
					SCR->(MsUnLock())
					SCR->(dbSkip())
				EndDo
			EndIf

			BeginSql Alias cNextAlias

				SELECT
				ZAD_SEQ,
				ZAD_NIVEL,
				ZA2_CODUSU,
				ZAD_VALINI,
				ZAD_VALFIM
				FROM %Table:ZAD% ZAD
				INNER JOIN %Table:ZA2% ZA2
				ON ZA2_FILIAL = ZAD_FILIAL AND
				ZA2_NIVEL =  ZAD_NIVEL  AND
				ZA2_EMPFIL = %xFilial:SC1%
				WHERE
				ZAD.%NotDel% AND
				ZA2.%NotDel% AND
				ZA2.ZA2_LOGIN <> ' ' AND
				ZAD_FILIAL = %xFilial:ZAD% AND
				ZAD_CODIGO = %Exp:aGrupo[1]% AND
				ZAD_VERSAO = %Exp:aGrupo[2]%
				ORDER BY ZAD_SEQ

			EndSql

			(cNextAlias)->(dbGoTop())

			While (cNextAlias)->(!EOF())

				If nTotal >= (cNextAlias)->ZAD_VALINI .And. nTotal <= (cNextAlias)->ZAD_VALFIM

					RecLock('SCR',.T.)

					SCR->CR_FILIAL 	:= xFilial('SCR')
					SCR->CR_NUM 	:= cPed
					SCR->CR_TIPO 	:= 'PC'
					SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU
					SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
					SCR->CR_EMISSAO	:= dDataBase
					SCR->CR_TOTAL 	:= nTotal
					SCR->CR_MOEDA 	:= SC7->C7_MOEDA
					SCR->CR_TXMOEDA	:= SC7->C7_TXMOEDA
					SCR->CR_ZCODGRD := %Exp:aGrupo[1]%
					SCR->CR_ZVERSAO := %Exp:aGrupo[2]%
					SCR->CR_ZNOMFOR := cNome
					SCR->CR_ZNIVEL  := (cNextAlias)->ZAD_NIVEL

					SCR->(MsUnlock())
					nIt ++
				EndIf

				(cNextAlias)->(dbSkip())

			EndDo

			/*If (nOpx == 3 .or. nOpx == 9)
			U_xPrcFluig('P','I','SC7',SC7->(RECNO()),"P",'','')
			ElseIf nOpx == 4
			U_xPrcFluig('P','U','SC7',SC7->(RECNO()),"P",'','')
			EndIf*/


			While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cChavSC7
				Reclock('SC7',.F.)
				SC7->C7_CONAPRO := 'B'
				SC7->C7_ZIDINTE := ''
				SC7->C7_ZBLQFLG := 'S'
				SC7->C7_ZCODGRD := aGrupo[1]
				SC7->C7_ZVERSAO := aGrupo[2]
				SC7->C7_ENVGRAD := "N"

				If nOpx == 9
					SC7->C7_ZCODFLG := ' '
				Endif

				SC7->(MsUnLock())

				SC7->(dbSkip())
			EndDo

		EndIf

	EndIf

	RestArea(aAreaSC7)
	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return

User Function xOldMG8FIM(cPed,nOpx,nOpca)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())

	Local aDados	:= {}

	Local cChavSC7  := xFilial('SC7') + cPed
	Local cCC		:= ''
	Local cGrupo	:= ''

	Default nOpca := 1

	//Exclui PC de Compra
	/*If nOpx <> 3
	U_xM10PedEx(cPed)
	EndIf*/

	//Inclui PC
	If (nOpx == 4 .or. nOpx == 3 .or. nOpx == 9) .and. nOpca == 1
		/*aDados := xPreDadPC(cPed)//Preparada Array com os Dados
		If Len(aDados) > 0
		U_xM10PedGer(aDados)//Envia Dados para o Fluig
		EndIf*/

		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

		//Bloquar Pedido
		If SC7->(dbSeek(cChavSC7))

			If !Empty(SC7->C7_CC)
				cCC := SC7->C7_CC
			Else
				cCC := SC7->C7_ZCC
			EndIf

			cGrupo := xMC8GrAp(cCC)

			If !Empty(cGrupo)
				xMC8PedSCR(cPed,cGrupo)
				While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cChavSC7

					Reclock('SC7',.F.)
					SC7->C7_CONAPRO := 'B'
					SC7->C7_ZIDINTE := ''
					SC7->C7_ZBLQFLG := 'S'
					If nOpx == 9
						SC7->C7_ZCODFLG := ' '
					Endif
					SC7->(MsUnLock())

					SC7->(dbSkip())
				EndDo
			EndIf
		EndIf

		/*dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

		If SCR->(dbSeek(xFilial('SCR') + 'PC' + cPed))
		While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) == xFilial('SCR') + 'PC' + PadR(cPed,Len(SCR->CR_NUM))
		RecLock('SCR',.F.)
		SCR->CR_ITGRP := '01'
		SCR->(MsUnlock())
		SCR->(dbSkip())
		EndDo
		EndIf*/

	EndIf

	RestArea(aAreaSC7)
	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return

Static Function xPreDadPC(cPed)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSE4	:= SE4->(GetArea())

	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}

	Local cChvSCR	:= ''
	Local cRateio	:= ''

	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(DbSeek( xFilial('SC7') + cPed))

		//Cabeçalho C7_FORNECE,C7_LOJA
		AADD(aCabSol,SC7->C7_FORNECE)
		AADD(aCabSol,SC7->C7_LOJA)
		AADD(aCabSol,SC7->C7_COND + ' - ' + POSICIONE('SE4',1,xFilial('SE4') + SC7->C7_COND ,'E4_COND') )
		AADD(aCabSol,SC7->C7_FILIAL)
		AADD(aCabSol,SC7->C7_FILENT)
		AADD(aCabSol,DtoC(SC7->C7_EMISSAO))
		AADD(aCabSol,SC7->C7_NUM)
		AADD(aCabSol,TRANSFORM(SC7->C7_MOEDA,PesqPict('SC7','C7_MOEDA')) + ' - ' + GetMv('MV_MOEDA' + Alltrim(Str(SC7->C7_MOEDA))))
		AADD(aCabSol,TRANSFORM(SC7->C7_TXMOEDA,PesqPict('SC7','C7_TXMOEDA')))
		AADD(aCabSol,UsrRetMail(RetCodUsr()))
		AADD(aCabSol,Posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE + SC7->C7_LOJA,'A2_NREDUZ'))
		AADD(aCabSol,FWFilialName())
		AADD(aCabSol,FWFilialName(cEmpAnt,SC7->C7_FILENT))

		AADD(aDados,aCabSol)

		//Itens da Solicitação de Compra
		While SC7->(!Eof()) .and. xFilial('SC7') + cPed == SC7->(C7_FILIAL + C7_NUM)

			aItemSol  := {}

			AADD(aItemSol,SC7->C7_ITEM)
			AADD(aItemSol,SC7->C7_PRODUTO)
			AADD(aItemSol,SC7->C7_DESCRI)
			AADD(aItemSol,SC7->C7_UM)
			AADD(aItemSol,TRANSFORM(SC7->C7_QUANT,PesqPict('SC7','C7_QUANT')))
			AADD(aItemSol,TRANSFORM(SC7->C7_PRECO,PesqPict('SC7','C7_PRECO')))
			AADD(aItemSol,TRANSFORM(SC7->C7_TOTAL,PesqPict('SC7','C7_TOTAL')))
			AADD(aItemSol,DtoC(SC7->C7_DATPRF))
			AADD(aItemSol,SC7->C7_OBS)
			AADD(aItemSol,TRANSFORM(SC7->C7_VLDESC,PesqPict('SC7','C7_VLDESC')))
			AADD(aItemSol,TRANSFORM(SC7->C7_DESC,PesqPict('SC7','C7_DESC')))
			AADD(aItemSol,TRANSFORM(SC7->C7_SEGURO,PesqPict('SC7','C7_SEGURO')))
			AADD(aItemSol,TRANSFORM(SC7->C7_DESPESA,PesqPict('SC7','C7_DESPESA')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALFRE,PesqPict('SC7','C7_VALFRE')) )
			AADD(aItemSol,TRANSFORM(SC7->C7_TPFRETE,PesqPict('SC7','C7_TPFRETE')))
			AADD(aItemSol,TRANSFORM(SC7->C7_IPI,PesqPict('SC7','C7_IPI')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALIPI,PesqPict('SC7','C7_VALIPI')))
			AADD(aItemSol,TRANSFORM(SC7->C7_PICM,PesqPict('SC7','C7_PICM')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALICM,PesqPict('SC7','C7_VALICM')))
			AADD(aItemSol,SC7->C7_CONTRA)
			If SC7->C7_BASIMP5 > 0 .and. SC7->C7_VALIMP5 > 0
				AADD(aItemSol,TRANSFORM((SC7->C7_VALIMP5 / SC7->C7_BASIMP5) * 100,PesqPict('SC7','C7_PICM')))
			Else
				AADD(aItemSol,TRANSFORM(0,PesqPict('SC7','C7_PICM')))
			EndIf
			AADD(aItemSol,TRANSFORM(SC7->C7_VALIMP5,PesqPict('SC7','C7_VALIMP5')))

			If !Empty(SC7->C7_CC)
				AADD(aItemSol,SC7->C7_CC)
			Else
				AADD(aItemSol,SC7->C7_ZCC)
			EndIf

			AADD(aGrpSol,aItemSol)

			SC7->(dbSkip())
		EndDo

		AADD(aDados,aGrpSol)

		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR') + 'PC' + cPed
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,6)

				aAprov := {}

				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])

				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo

			AADD(aDados,aGrpAprov)

		EndIf

	EndIf

	RestArea(aAreaSE4)
	RestArea(aAreaSA2)
	RestArea(aAreaSCR)
	RestArea(aAreaSC7)
	RestArea(aArea)

Return aDados


User Function xMG8Inc5(cTit,nOpx)

	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local aDados	:= {}
	Local cGrupo	:= ''
	Local cNatur 	:= Alltrim(GetMv('MV_ZMF15AD',,"22704|22706|22707|22708|30110|30111|30112|30113"))

	IF (Alltrim(SE2->E2_TIPO) == 'PR' .OR. Alltrim(SE2->E2_TIPO) == 'PRE')  .and. !(Alltrim(SE2->E2_NATUREZ) $ cNatur)

		RecLock('SE2',.F.)
		SE2->E2_ZCODGRD := 'ZZZZZZZZZZ'
		SE2->E2_ZBLQFLG := 'S'
		SE2->E2_DATALIB := dDataBase
		SE2->E2_ZIDINTE := 'ZZZZZZZZZ'
		SE2->E2_ZIDGRD  := 'ZZZZZZZZZ'
		SE2->E2_ZNEXGRD := ''
		SE2->(MsUnlock())
		Return
	EndIF

	dbSelectArea('SE2')
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA

	If SE2->(DbSeek(xFilial('SE2') + cTit))
		If Alltrim(SE2->E2_TIPO) <> 'FT'
			If nOpx == 4 .or. nOpx == 3
				If !IsInCallStack('U_MGFCOM15')	//.AND. !IsInCallStack('U_MyExec')

					RecLock('SE2',.F.)
					SE2->E2_ZBLQFLG := 'N'
					SE2->E2_ZNEXGRD := ''
					SE2->E2_ZGRPAPR := ''
					SE2->E2_ZCODGRD := ''
					SE2->E2_ZIDGRD  := ''
					SE2->E2_DATALIB := cToD('//')
					SE2->(MsUnlock())
				EndIf
				/*	cGrupo := xMC8GrpTit(SE2->E2_CCUSTO,SE2->E2_NATUREZ)
				If !Empty(cGrupo)
				xMC8SCRTit(cTit,cGrupo)
				RecLock('SE2',.F.)
				SE2->E2_ZIDINTE := ''
				SE2->E2_ZBLQFLG := 'S'
				SE2->E2_ZNEXGRD := ''
				SE2->(MsUnlock())
				Else
				RecLock('SE2',.F.)
				SE2->E2_ZBLQFLG := 'N'
				SE2->E2_ZNEXGRD := 'S'
				SE2->(MsUnlock())
				EndIf*/
				//				Else
				//					RecLock('SE2',.F.)
				//					SE2->E2_ZIDINTE := ''
				//					SE2->E2_ZBLQFLG := 'N'
				//					SE2->E2_ZNEXGRD := ''
				//					SE2->E2_DATALIB := dDataBase
				//					SE2->(MsUnlock())
				//				EndIf
			EndIf
		EndIf
	EndIf

	//Excli Tit a pagar
	/*If nOpx <> 3
	U_xM10TitEx(cPed)
	EndIf*/

	//Inclui Tit a pagar
	/*If nOpx <> 5
	aDados := xPreDadTi(cTit)//Preparada Array com os Dados
	If Len(aDados) > 0
	U_xjM10TitGer(aDados)//Envia Dados para o Fluig
	EndIf
	EndIf*/

	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return

/*
- Encontrar Grupo OK
- Gerar SCR OK
- Atualizar o Titulo //campo E2_DATALIB
- Preparar dados para o FLuig  ok
- Enviar dados para o FLuig

*/

Static Function xMC8SCRTit(cChav,cGrupo)

	Local aArea 		:= GetArea()
	Local aAreaSE2		:= SE2->(GetArea())

	Local cNextAlias 	:= GetNextAlias()
	Local nIt			:= 1

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

	If SCR->(dbSeek(xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])))
		While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])
			RecLock('SCR',.F.)
			SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf

	BeginSql Alias cNextAlias

		SELECT SAL.*
		FROM
		%Table:SAL% SAL
		WHERE
		SAL.%NotDel% AND
		SAL.AL_FILIAL = %xFilial:SAL% AND
		SAL.AL_COD = %Exp:cGrupo%
		ORDER BY AL_FILIAL,AL_COD,AL_NIVEL

	EndSql

	(cNextAlias)->(DbGoTop())

	dbSelectArea('SE2')
	SE2->(dbSetOrder(1)) //E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA

	If SE2->(dbSeek(xFilial('SE2') + cChav))
		While (cNextAlias)->(!EOF())

			If SE2->E2_VALOR >= (cNextAlias)->AL_ZVALINI .And. SE2->E2_VALOR <= (cNextAlias)->AL_ZVALFIM
				RecLock('SCR',.T.)

				SCR->CR_FILIAL 	:= xFilial('SCR')
				SCR->CR_NUM 	:= cChav
				SCR->CR_TIPO 	:= 'ZC'
				SCR->CR_USER 	:= (cNextAlias)->AL_USER
				SCR->CR_APROV 	:= (cNextAlias)->AL_APROV
				SCR->CR_GRUPO 	:= cGrupo
				SCR->CR_ITGRP 	:= (cNextAlias)->AL_ITEM
				SCR->CR_NIVEL 	:= (cNextAlias)->AL_NIVEL
				SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
				SCR->CR_EMISSAO	:= dDataBase
				SCR->CR_TOTAL 	:= SE2->E2_VALOR
				SCR->CR_MOEDA 	:= SE2->E2_MOEDA
				SCR->CR_TXMOEDA	:= SE2->E2_TXMOEDA

				SCR->(MsUnlock())
				nIt ++
			EndIf

			(cNextAlias)->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSE2)
	RestArea(aArea)

Return

User Function xMC8GSCR()

	Local aArea	 := GetArea()
	Local cGrupo := ''//xMC8GrpTit(SE2->E2_CC,SE2->E2_CCUSTO)
	Local cTit	 := '' //SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)
	If SE2->E2_ZNEXGRD == 'S'

		cGrupo 	:= xMC8GrpTit(SE2->E2_CCUSTO,SE2->E2_NATUREZ)
		cTit	:= SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)

		If !Empty(cGrupo)
			xMC8SCRTit(cTit,cGrupo)
			RecLock('SE2',.F.)
			SE2->E2_ZNEXGRD := ''
			SE2->E2_ZIDINTE := ''
			SE2->E2_ZBLQFLG := 'S'
			SE2->(MsUnlock())
		Else
			Alert('Não Existe Grade de Aprovação para essa Natureza : ' + Alltrim(SE2->E2_NATUREZ) + ' , CC: ' + Alltrim(SE2->E2_CCUSTO))
		EndIf
	Else
		Alert('Só é possivel utilizar essa rotina para titulos que em sua geração/alteração não possuíam grade de aprovação.')
	EndIf

	RestArea(aArea)

Return

Static Function xMC8GrpTit(cCC,cNatur)

	Local aArea := GetArea()

	Local cRet 		 := ''
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
		DBL_GRUPO,
		AL_ZCODGRD,
		AL_ZVERSAO
		FROM
		%Table:DBL% DBL
		INNER JOIN %Table:SAL% SAL
		ON DBL.DBL_FILIAL = SAL.AL_FILIAL
		AND DBL.DBL_GRUPO = SAL.AL_COD
		INNER JOIN %Table:ZAB% ZAB
		ON SAL.AL_ZCODGRD = ZAB.ZAB_CODIGO
		AND SAL.AL_ZVERSAO = ZAB.ZAB_VERSAO
		WHERE
		DBL.DBL_FILIAL = %xFilial:DBL% AND
		ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
		DBL.%NotDel% AND
		SAL.%NotDel% AND
		ZAB.%NotDel% AND
		SUBSTRING(SAL.AL_ZCODGRD,1,1) = 'C' AND
		DBL.DBL_CC = %Exp:cCC% AND
		DBL.DBL_ZNATUR = %Exp:cNatur% AND
		ZAB.ZAB_HOMOLO = 'S'

		ORDER BY DBL_GRUPO, AL_ZCODGRD, AL_ZVERSAO

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->DBL_GRUPO
		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aArea)

Return cRet

Static Function xPreDadTi(cTit)

	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}

	Local cChvSCR	:= ''
	Local cRateio	:= ''

	Local nTamChav	:= TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]

	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf

	dbSelectArea('SE2')
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA

	If SE2->(DbSeek(xFilial('SE2') + cTit))

		AADD(aCabSol,SE2->E2_FILIAL)											//01
		AADD(aCabSol,SE2->E2_PREFIXO)											//02
		AADD(aCabSol,SE2->E2_PARCELA)											//03
		AADD(aCabSol,SE2->E2_TIPO)												//04
		AADD(aCabSol,SE2->E2_NATUREZ)											//05
		AADD(aCabSol,SE2->E2_FORNECE)											//06
		AADD(aCabSol,SE2->E2_LOJA)												//07
		AADD(aCabSol,SE2->E2_NOMFOR)											//08
		AADD(aCabSol,DtoC(SE2->E2_EMISSAO))										//09
		AADD(aCabSol,DtoC(SE2->E2_VENCTO))										//10
		AADD(aCabSol,DtoC(SE2->E2_VENCREA))										//11
		AADD(aCabSol,TRANSFORM(SE2->E2_VALOR,PesqPict('SE2','E2_VALOR')))		//12
		AADD(aCabSol,TRANSFORM(SE2->E2_ISS,PesqPict('SE2','E2_ISS')))			//13
		AADD(aCabSol,TRANSFORM(SE2->E2_IRRF,PesqPict('SE2','E2_IRRF')))			//14
		AADD(aCabSol,SE2->E2_HIST)												//15
		AADD(aCabSol,TRANSFORM(SE2->E2_SALDO,PesqPict('SE2','E2_SALDO')))		//16
		AADD(aCabSol,TRANSFORM(SE2->E2_VALJUR,PesqPict('SE2','E2_VALJUR')))		//17
		AADD(aCabSol,TRANSFORM(SE2->E2_PORCJUR,PesqPict('SE2','E2_PORCJUR')))	//18
		AADD(aCabSol,TRANSFORM(SE2->E2_MOEDA,PesqPict('SE2','E2_MOEDA')))		//19
		AADD(aCabSol,SE2->E2_RATEIO)											//20
		AADD(aCabSol,TRANSFORM(SE2->E2_VALOR,PesqPict('SE2','E2_VALOR')))		//21
		AADD(aCabSol,TRANSFORM(SE2->E2_ACRESC,PesqPict('SE2','E2_ACRESC')))		//22
		AADD(aCabSol,SE2->E2_FLUXO)												//23
		AADD(aCabSol,TRANSFORM(SE2->E2_INSS,PesqPict('SE2','E2_INSS')))			//24
		AADD(aCabSol,TRANSFORM(SE2->E2_TXMOEDA,PesqPict('SE2','E2_TXMOEDA')))	//25
		AADD(aCabSol,TRANSFORM(SE2->E2_DECRESC,PesqPict('SE2','E2_DECRESC')))	//26
		AADD(aCabSol,SE2->E2_CODRET)											//27
		AADD(aCabSol,TRANSFORM(SE2->E2_SEST,PesqPict('SE2','E2_SEST')))			//28
		AADD(aCabSol,TRANSFORM(SE2->E2_COFINS,PesqPict('SE2','E2_COFINS')))		//29
		AADD(aCabSol,TRANSFORM(SE2->E2_PIS,PesqPict('SE2','E2_PIS')))			//30
		AADD(aCabSol,TRANSFORM(SE2->E2_CSLL,PesqPict('SE2','E2_CSLL')))			//31
		AADD(aCabSol,DtoC(SE2->E2_VENCISS))										//32
		AADD(aCabSol,TRANSFORM(SE2->E2_VBASISS,PesqPict('SE2','E2_VBASISS')))	//33
		AADD(aCabSol,SE2->E2_MDCONTR)											//34
		AADD(aCabSol,TRANSFORM(SE2->E2_TXMDCOR,PesqPict('SE2','E2_TXMDCOR')))	//35
		AADD(aCabSol,TRANSFORM(SE2->E2_ISS,PesqPict('SE2','E2_ISS')))			//36
		AADD(aCabSol,TRANSFORM(SE2->E2_RETCNTR,PesqPict('SE2','E2_RETCNTR')))	//37
		AADD(aCabSol,TRANSFORM(SE2->E2_MDDESC,PesqPict('SE2','E2_MDDESC')))		//38
		AADD(aCabSol,TRANSFORM(SE2->E2_MDBONI,PesqPict('SE2','E2_MDBONI')))		//39
		AADD(aCabSol,TRANSFORM(SE2->E2_MDMULT,PesqPict('SE2','E2_MDMULT')))		//40
		AADD(aCabSol,SE2->E2_CCUSTO)											//41
		AADD(aCabSol,SE2->E2_TPESOC)											//42
		AADD(aCabSol,SE2->E2_NUM)												//43

		AADD(aDados,aCabSol)

		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR') + 'ZC' + cTit
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,nTamChav)
				aAprov := {}
				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])
				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo
			AADD(aDados,aGrpAprov)
		EndIf
	EndIf

	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return aDados

User function xMg8VlTT()

	Local lRet 		:= .T.
	Local lOp05MV	:= MV_PAR05 <> 2 //Gerar Chq.p/Adiant. ?
	Local lOp09MV	:= MV_PAR09 <> 2//Mov.Banc.sem Cheque ?

	If Alltrim(M->E2_TIPO) = 'PA'
		If lOp05MV .Or. lOp09MV
			lRet := .F.
			Alert('Não é Possivel gerar um titulo do Tipo PA, para incluir um titulo do Tipo PA, sera necessario alterar o Prefixo(E2_PREFIXO) para "PAM" e o Tipo para "PR"')
		EndIf
	EndIf

return lRet

/*
=====================================================================================
Programa............: xMG8When
Autor...............: Joni Lima
Data................: 17/01/2018
Descrição / Objetivo: Utilizado no WHEN dos campos E2_ZBCOAD,E2_ZAGAD,E2_ZCNTAD
Obs.................: Valida se o campo tipo é igual ao MPA
=====================================================================================
*/
User Function xMG8When()

	Local lRet := .F.

	//If ALLTRIM(M->E2_PREFIXO) == 'PAM' .and. ALLTRIM(M->E2_TIPO) == 'PR'
	If ALLTRIM(M->E2_TIPO) == 'MPA'
		lRet := .T.
	EndIf

Return lRet

Static Function xMC8PedSCR(cChav,cGrupo)

	Local aArea 		:= GetArea()
	Local aAreaSC7		:= SC7->(GetArea())

	Local cNextAlias 	:= GetNextAlias()
	Local nIt			:= 1
	Local nTotal		:= xTotPed(cChav)
	Local cNome			:= xNomFoPC(cChav)

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

	If SCR->(dbSeek(xFilial('SCR') + 'PC' + PadR(cChav,TamSX3('CR_NUM')[1])))
		While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'PC' + PadR(cChav,TamSX3('CR_NUM')[1])
			RecLock('SCR',.F.)
			SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf

	BeginSql Alias cNextAlias

		SELECT SAL.*
		FROM
		%Table:SAL% SAL
		WHERE
		SAL.%NotDel% AND
		SAL.AL_FILIAL = %xFilial:SAL% AND
		SAL.AL_COD = %Exp:cGrupo%
		ORDER BY AL_FILIAL,AL_COD,AL_NIVEL

	EndSql

	(cNextAlias)->(DbGoTop())

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(dbSeek(xFilial('SC7') + cChav))
		While (cNextAlias)->(!EOF())

			If nTotal >= (cNextAlias)->AL_ZVALINI .And. nTotal <= (cNextAlias)->AL_ZVALFIM
				RecLock('SCR',.T.)

				SCR->CR_FILIAL 	:= xFilial('SCR')
				SCR->CR_NUM 	:= cChav
				SCR->CR_TIPO 	:= 'PC'
				SCR->CR_USER 	:= (cNextAlias)->AL_USER
				SCR->CR_APROV 	:= (cNextAlias)->AL_APROV
				SCR->CR_GRUPO 	:= cGrupo
				SCR->CR_ITGRP 	:= (cNextAlias)->AL_ITEM
				SCR->CR_NIVEL 	:= (cNextAlias)->AL_NIVEL
				SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
				SCR->CR_EMISSAO	:= dDataBase
				SCR->CR_TOTAL 	:= nTotal
				SCR->CR_MOEDA 	:= SC7->C7_MOEDA
				SCR->CR_TXMOEDA	:= SC7->C7_TXMOEDA
				SCR->CR_ZNOMFOR := cNome

				SCR->(MsUnlock())
				nIt ++
			EndIf

			(cNextAlias)->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return

Static Function xTotPed(cChav)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())

	Local nRet := 0

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(dbSeek(xFilial('SC7') + cChav))
		While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == xFilial('SC7') + cChav
			nRet += SC7->C7_TOTAL
			SC7->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return nRet

Static Function xNomFoPC(cChav)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())

	Local cRet := ' '

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(dbSeek(xFilial('SC7') + cChav))

		dbSelectArea('SA2')
		SA2->(dbSetOrder(1))//A2_FILIAL, A2_COD, A2_LOJA

		If SA2->(dbSeek(xFilial('SA2',SC7->C7_FILIAL) + SC7->(C7_FORNECE + C7_LOJA) ))
			cRet := SA2->A2_NOME
		EndIf

	EndIf

	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: xMC8GrAp
Autor...............: Joni Lima
Data................: 01/02/2016
Descrição / Objetivo: Encontra o Grupo de Aprovação correto
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Busca o Grupo de aprovação com a alçada correta
=====================================================================================
*/
Static Function xMC8GrAp(cCC)

	Local aArea := GetArea()
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT DISTINCT
		DBL_GRUPO,
		AL_ZCODGRD,
		AL_ZVERSAO
		FROM
		%Table:DBL% DBL
		INNER JOIN %Table:SAL% SAL
		ON SAL.AL_FILIAL = DBL.DBL_FILIAL
		AND SAL.AL_COD = DBL.DBL_GRUPO
		INNER JOIN %Table:ZAB% ZAB
		ON ZAB.ZAB_CODIGO = SAL.AL_ZCODGRD
		AND ZAB.ZAB_VERSAO = SAL.AL_ZVERSAO
		WHERE
		DBL.DBL_FILIAL = %xFilial:DBL% AND
		DBL.%NotDel% AND
		SAL.%NotDel% AND
		ZAB.%NotDel% AND
		SUBSTRING(SAL.AL_ZCODGRD,1,1) = 'P' AND
		DBL.DBL_CC = %Exp:cCC% AND
		ZAB.ZAB_HOMOLO = 'S'

		ORDER BY DBL_GRUPO, AL_ZCODGRD, AL_ZVERSAO

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->DBL_GRUPO
		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aArea)

Return cRet

User Function xMC8GSE2()

	Local aCols   := PARAMIXB[1]
	Local nxxOpc  := PARAMIXB[2] //1=inclusão de títulos, 2=exclusão de títulos
	Local aHeadSE2:= PARAMIXB[3]

	Local cCC 	  := SD1->D1_CC
	Local cGrupo  := ''
	Local cTit	  := SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)


	If nxxOpc == 1 //Inclusão
		SE2->E2_CCUSTO	:= SD1->D1_CC
		//cGrupo := xMC8GrpTit(SD1->D1_CC,SE2->E2_NATUREZ)
		/*If !Empty(cGrupo)
		//xMC8DTSCRT(cTit,cGrupo)
		//SE2->E2_ZIDINTE := ''
		//SE2->E2_ZBLQFLG := 'S'
		//SE2->E2_ZNEXGRD := ''
		SE2->E2_CCUSTO	:= SD1->D1_CC
		Else
		//SE2->E2_ZBLQFLG := 'N'
		//SE2->E2_ZNEXGRD := 'S'
		SE2->E2_CCUSTO	:= SD1->D1_CC
		EndIf*/
	EndIF
Return

Static Function xMC8DTSCRT(cChav,cGrupo)

	Local aArea 		:= GetArea()
	Local aAreaSE2		:= SE2->(GetArea())

	Local cNextAlias 	:= GetNextAlias()
	Local nIt			:= 1

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

	If SCR->(dbSeek(xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])))
		While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])
			RecLock('SCR',.F.)
			SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf

	BeginSql Alias cNextAlias

		SELECT SAL.*
		FROM
		%Table:SAL% SAL
		WHERE
		SAL.%NotDel% AND
		SAL.AL_FILIAL = %xFilial:SAL% AND
		SAL.AL_COD = %Exp:cGrupo%
		ORDER BY AL_FILIAL,AL_COD,AL_NIVEL

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())

		If SE2->E2_VALOR >= (cNextAlias)->AL_ZVALINI .And. SE2->E2_VALOR <= (cNextAlias)->AL_ZVALFIM
			RecLock('SCR',.T.)

			SCR->CR_FILIAL 	:= xFilial('SCR')
			SCR->CR_NUM 	:= cChav
			SCR->CR_TIPO 	:= 'ZC'
			SCR->CR_USER 	:= (cNextAlias)->AL_USER
			SCR->CR_APROV 	:= (cNextAlias)->AL_APROV
			SCR->CR_GRUPO 	:= cGrupo
			SCR->CR_ITGRP 	:= (cNextAlias)->AL_ITEM
			SCR->CR_NIVEL 	:= (cNextAlias)->AL_NIVEL
			SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
			SCR->CR_EMISSAO	:= dDataBase
			SCR->CR_TOTAL 	:= SE2->E2_VALOR
			SCR->CR_MOEDA 	:= SE2->E2_MOEDA
			SCR->CR_TXMOEDA	:= SE2->E2_TXMOEDA

			SCR->(MsUnlock())
			nIt ++
		EndIf

		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aAreaSE2)
	RestArea(aArea)

Return

User Function xF050Del()

	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local cChav		:= SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)

	If Alltrim(SE2->E2_TIPO) <> 'FT'

		RecLock('SE2',.F.)
		SE2->E2_ZIDINTE := ''
		SE2->E2_ZBLQFLG := 'S'
		SE2->E2_ZNEXGRD := ''
		SE2->E2_ZGRPAPR := ''
		SE2->E2_ZCODGRD := ''
		SE2->E2_ZIDGRD  := ''
		SE2->(MsUnlock())

		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

		If SCR->(dbSeek(xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])))
			While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])
				RecLock('SCR',.F.)
				SCR->(dbDelete())
				SCR->(MsUnLock())
				SCR->(dbSkip())
			EndDo
		EndIf

	EndIf

	RestArea(aAreaSE2)
	RestArea(aArea)

Return


User Function xMC8750M()

	U_MGFCOM17('ZC')

Return

User Function xMC8PAM()

	Local cPerg 	:= 'XMGF15'
	Local dOldData	:= dDataBase
	Local cNatur 	:= Alltrim(GetMv('MV_ZMF15AD',,"22704|22706|22707|22708|30110|30111|30112|30113"))

	//If SE2->E2_TIPO == 'MPA' .and. !(Empty(SE2->E2_DATALIB))
	If (Alltrim(SE2->E2_TIPO) == 'PR' .and. (Alltrim(SE2->E2_NATUREZ) $ cNatur)) .and. !(Empty(SE2->E2_DATALIB))
		If Pergunte(cPerg,.T.)
			If MV_PAR04 >= SE2->E2_EMISSAO
				dDataBase := MV_PAR04
				U_MGFCOM15(SE2->(Recno()))
			Else
				Alert("Data deve ser maior ou igual a emissão para geração do PA")
			EndIf
		EndIf

		dDataBase := dOldData

	Else
		//Alert('Opção disponivel para titulos de Tipo "MPA" que estejam Liberados')
		Alert('Opção disponivel para titulos de Tipo "MPA" e Naturezas: ' + cNatur + ' , Parametro "MV_ZMF15AD" ')
	EndIf

Return

Static Function xAltSCR(cChav)

	Local aArea 	:= GetArea()
	Local cNewChv	:= SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + 'PA ' + E2_FORNECE + E2_LOJA)

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

	If SCR->(dbSeek(xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])))
		While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'ZC' + PadR(cChav,TamSX3('CR_NUM')[1])

			RecLock('SCR',.F.)
			SCR->(dbDelete())
			SCR->(MsUnLock())

			SCR->(DbSkip())
		EndDo
	EndIf

	RestArea(aArea)

Return

User Function xM10vGrd(cCC)

	Local lRet := .F.

	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()

	Default cCC := ''

	If !Empty(cCC)

		BeginSql Alias cNextAlias

			SELECT
			ZAB_CODIGO,
			ZAB_VERSAO
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAD% ZAD
			ON ZAD.ZAD_FILIAL = ZAB.ZAB_FILIAL
			AND ZAD.ZAD_CODIGO = ZAB.ZAB_CODIGO
			AND ZAD.ZAD_VERSAO = ZAB.ZAB_VERSAO
			WHERE
			ZAB.%NotDel% AND
			ZAD.%NotDel% AND
			ZAD.ZAD_FILIAL  =  %xFilial:ZAD% AND
			ZAB.ZAB_TIPO = 'P' AND
			ZAB.ZAB_HOMOLO = 'S' AND
			ZAB.ZAB_CC = %Exp:cCC%

		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			lRet := .T.
			If lRet
				Exit
			EndIf
			(cNextAlias)->(dbSkip())
		EndDo

		(cNextAlias)->(DBCloseArea())
	EndIf

	RestArea(aArea)

Return lRet

User Function xM8verCC()

	Local lRet 		:= .T.
	Local nPosCC  	:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_CC' })
	Local nPosZCC  	:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_ZCC' })
	Local cCCPDR	:= ''//Alltrim(_XMGFcCC)
	Local lDelItem	:= .F.
	Local ni

	If Type('_XMGFcCC') <> 'U'
		cCCPDR := _XMGFcCC
	EndIf

	For ni := 1 to len(aCols)
		If ValType(aCols[ni,Len(aCols[ni])]) == "L"
			lDelItem := aCols[ni,Len(aCols[ni])]
			If lDelItem
				Loop
			EndIf
		EndIf

		If Empty(cCCPDR)
			If !Empty(aCols[ni,nPosCC])
				cCCPDR := aCols[ni,nPosCC]
			Else
				cCCPDR := aCols[ni,nPosZCC]
			EndIf
		EndIf

		If !Empty(aCols[ni,nPosCC])
			If aCols[ni,nPosCC] <> cCCPDR
				lRet := .F.
				Exit
			EndIf
		Else
			If aCols[ni,nPosZCC] <> cCCPDR
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next ni

Return lRet

//---------------------------------
// Valida se os itens do contrato estão com o mesmo CC
// Faz a mesma função que a u_xM8verCC para as medições de contrato
//---------------------------------
user function cntVerCC()
	local lRet		:= .T.
	local cQryCNE	:= ""
	local cCCAtu	:= ""

	cQryCNE := "SELECT CNE_CC"
	cQryCNE += " FROM " + retSQLName("CNE") + " CNE"
	cQryCNE += " WHERE"
	cQryCNE += " 		CNE.CNE_NUMMED	=	'" + CND->CND_NUMMED	+ "'"
	cQryCNE += " 	AND	CNE.CNE_FILIAL	=	'" + xFilial("CNE")		+ "'"
	cQryCNE += " 	AND CNE.D_E_L_E_T_	<>	'*'"

	TcQuery cQryCNE New Alias "QRYCNE"

	if !QRYCNE->(EOF())
		cCCAtu := QRYCNE->CNE_CC
		while !QRYCNE->(EOF())
			if cCCAtu <> QRYCNE->CNE_CC
				lRet := .F.
				If IsBlind()
					Help(" ",1,'DIFFCCUSTO',,'Itens do Pedido com diferentes CENTROS DE CUSTOS.'+CRLF+;
					'Não é possível conter centros de custos diferentes no mesmo pedido.',1,0)
				Else
					msgAlert("Itens do Pedido com diferentes CENTROS DE CUSTOS. Não é possível conter centros de custos diferentes no mesmo pedido.")
				EndIf
				exit
			endif
			QRYCNE->(DBSkip())
		enddo
	else
		msgAlert("Não foram encontrados itens para a medição " + CND->CND_NUMMED)
		lRet := .F.
	endif

	QRYCNE->(DBCloseArea())
return lRet

//---------------------------------
// Retorna CC da Medição posicionada
//---------------------------------
user function getCCCnt()
	local cQryCNE	:= ""
	local cRetCC	:= ""

	cQryCNE := "SELECT CNE_CC"
	cQryCNE += " FROM " + retSQLName("CNE") + " CNE"
	cQryCNE += " WHERE"
	cQryCNE += " 		CNE.CNE_NUMMED	=	'" + CND->CND_NUMMED	+ "'"
	cQryCNE += " 	AND	CNE.CNE_FILIAL	=	'" + xFilial("CNE")		+ "'"
	cQryCNE += " 	AND	CNE.D_E_L_E_T_	<>	'*'"

	TcQuery cQryCNE New Alias "QRYCNE"

	if !QRYCNE->(EOF())
		cRetCC := QRYCNE->CNE_CC
	endif

	QRYCNE->(DBCloseArea())
return cRetCC


User Function MG8110VLD(nOpx)

	Local lRet := .T.//IIF(!(IsInCallStack('a110Inclui')),SC1->C1_APROV <> 'R',.T.)

	If (nOpx == 4 .or. nOpx == 5) .and. !lCopia
		If SC1->C1_APROV == 'R'
			Alert('SC está rejeitada, favor incluir uma nova SC.')
			lRet := .F.
			/*
			ElseIf SC1->C1_APROV <> 'R' .and. SC1->C1_ZBLQFLG <> 'N'
			Alert('SC está Aguardando Integração com o Fluig, favor aguardar cerca de 2 minutos para integração.')
			lRet := .F.
			*/
		Endif
	EndIf

Return lRet

User Function xM10GVCC(cChav,cCC)

	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(DbSeek(cChav))
		While SC7->(!EOF()) .and. SC7->(C7_FILIAL+C7_NUM) == cChav
			RecLock('SC7',.F.)
			SC7->C7_CC := cCC
			SC7->C7_ZCC := cCC
			SC7->(MsUnlock())
			SC7->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return

User Function xMC8120M()

	U_MGFCOM17('PC')

Return

User Function xMC8110M()

	U_MGFCOM17('SC')

Return

User Function xMC8122M()

	U_MGFCOM17('PC')

Return


User Function MC8110OK(cNumSc)

	Local aArea	:= GetArea()
	Local lRet	:= .F.
	Local cTp	:= 'SC'
	Local cCC	:= ''
	Local cGR	:= ''

	If select ('ZCUSTGRADE') > 0
		('ZCUSTGRADE')->(dbGoTop())
		If !(Empty(('ZCUSTGRADE')->CCUSTO))
			cCC := ('ZCUSTGRADE')->CCUSTO
		EndIf

		If !(Empty(('ZCUSTGRADE')->GRUPO))
			cGR := ('ZCUSTGRADE')->GRUPO
		EndIf

		lRet := U_MC6ExisGA('SC',cCC,cGR)

		If !lRet
			If IsBlind()
				Help(" ",1,'SEMGRADE',,'Não existe grade técnica cadastrada para este CENTRO DE CUSTO + GRUPO DE PRODUTOS.'+CRLF+;
				'Esta SC não será gravada. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.',1,0)
			Else
				Alert('Não existe grade técnica cadastrada para este CENTRO DE CUSTO (' + Alltrim(cCC) + ') + GRUPO DE PRODUTOS(' + Alltrim(cGR) + ').Esta SC não será gravada. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.')
			EndIf
		EndIf
	else
		lRet := .T.
	endif

	RestArea(aArea)

Return lRet

User Function MC6ExisGA(cTp,cCC,cGR,cNA)

	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()

	Local lRet			:= .F.

	Default cCC	:= ''
	Default cGR	:= ''
	Default cNA	:= ''

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If cTp == 'SC'

		BeginSql Alias cNextAlias

			Select *
			FROM
			%Table:ZAB% ZAB
			INNER JOIN
			%Table:ZAC% ZAC
			ON ZAC.ZAC_FILIAL = ZAB.ZAB_FILIAL
			AND ZAC.ZAC_CODIGO = ZAB.ZAB_CODIGO
			AND ZAC.ZAC_VERSAO = ZAB.ZAB_VERSAO
			WHERE
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAB.%NotDel% AND
			ZAC.%NotDel% AND
			ZAB.ZAB_CC = %Exp:cCC% AND
			ZAC.ZAC_GRPPRD = %Exp:cGR%

		EndSql

	EndIf

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		lRet := .T.
		If lRet
			Exit
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo

	RestArea(aArea)

Return lRet

User Function xM8120ALT()

	Local nxOpc := PARAMIXB[1]
	Local lRet := .T.

	If lRet .and. (nxOpc == 4 .or. nxOpc == 5)

		If lRet .and. SC7->C7_ZREJAPR == 'S'
			Alert('Pedido Encontra-se Rejeitado.')
			lRet := .F.
		EndIf

		/*
		If lRet .and. SC7->C7_ZBLQFLG <> 'N'
		Alert('PC está Aguardando Integração com o Fluig, favor aguardar cerca de 2 minutos para integração.')
		lRet := .F.
		EndIf
		*/

	EndIf

Return lRet

User Function xMC8120E(cNumPc)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
	If SC7->(dbSeek(xFilial('SE2') + cNumPc))
		While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == xFilial('SE2') + cNumPc

			RecLock('SC7',.F.)
			SC7->C7_ZIDINTE := ''
			SC7->C7_ZBLQFLG := 'S'
			SC7->(MsUnlock())

			SC7->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

return

User Function xMC8E2VL()

	Local lRet 		:= .F.
	Local aCpos 	:= StrTokArr(SuperGetMV("MGF_CPOAE2",.F.,"E2_VALOR;E2_VENCTO;E2_VENCREA"),";")

	Local cMFld 	:= ""
	Local cE2Fld	:= ""

	Local ni

	For ni := 1 to len(aCpos)
		If SE2->(FieldPos(aCpos[ni])) > 0

			cMFld  := 'M->' + aCpos[ni]
			cE2Fld := 'SE2->' + aCpos[ni]

			If &(cMFld) <> &(cE2Fld)
				lRet := .T.
				Exit
			EndIf

		EndIf
	next ni

return lRet

User Function xMC8CntG(xValue)

	Local oModel300 	:= FwModelActive()
	Local aSaveLines	:= FWSaveRows()
	Local nFor	  		:= 0

	Local oCNBDetail	:= oModel300:GetModel('CNBDETAIL')

	For nFor := 1 To oCNBDetail:Length()
		oCNBDetail:GoLine(nFor)
		oCNBDetail:SetValue('CNB_CC',xValue)
	next nFor

	FWRestRows(aSaveLines)

return xValue

User Function MGF8xNomU(cUser)

	Local aArea 	:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cRet		:= ''

	BeginSQL Alias cAlias

		SELECT USR_NOME
		FROM SYS_USR
		WHERE D_E_L_E_T_ = ' '
		AND USR_ID = %Exp:cUser%

	EndSQL

	cRet	:= 	( cAlias )->USR_NOME

	dbSelectArea(cAlias)
	dbCloseArea()

	RestArea( aArea )
Return cRet

User Function MGF8FNom()

	Local aArea	:= GetArea()
	Local cRet	:= ''

	If SCR->CR_TIPO == 'ZC'
		cRet := POSICIONE('SE2',1,SCR->CR_FILIAL + AllTrim(SCR->CR_NUM) ,'E2_NOMFOR')
	ElseIf SCR->CR_TIPO == 'PC'
		DbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		If SC7->(dbSeek(SCR->CR_FILIAL + ALLTRIM(SCR->CR_NUM)))
			cRet := POSICIONE('SA2',1,xFilial('SA2') + SC7->(C7_FORNECE + C7_LOJA) ,'A2_NOME')
		EndIf
	EndIf

	RestArea(aArea)

return cRet

//----------------------------------------------------------------------------------------------------------
// Verifica se a alteracao do Pedido de Compra vai para Grade de Aprovacao
//----------------------------------------------------------------------------------------------------------
user function mgf8CkGd()
	local nI			:= 0
	local nJ			:= 0
	local aArea			:= getArea()
	local aAreaSC7		:= SC7->( getArea() )
	local nPosC7Num		:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_NUM'	})
	local nPosC7Item	:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_ITEM'	})
	local nPosC7Seq		:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_SEQUEN'	})
	local lEnvGrade		:= .F.
	local cC7Num		:= SC7->C7_NUM
	local cUpdSC7		:= ""
	Local cCampos		:= GETMV("MGF_COM131")
	Local cxFil			:= SC7->C7_FILIAL

	//VALIDA CABECALHO
	If	SC7->C7_COND <> cCondicao .OR.;
	SC7->C7_CONTATO <> cContato .OR.;
	SC7->C7_FILENT <> cFilialEnt .OR.;
	SC7->C7_TXMOEDA <> nTxMoeda .OR.;
	SC7->C7_MOEDA <> nMoedaPed
		lEnvGrade := .T.
	EndIf

	If !lEnvGrade
		// VALIDA ITENS
		For nI := 1 to len(aCols)
			SC7->( DBGoTop() )
			SC7->( DBSetOrder( 1 ) ) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
			If SC7->( DBSeek( cxFil + cC7Num + aCols[ nI, nPosC7Item ] ) )

				For nJ := 1 to len( aHeader )
					If aHeader[ nJ, 10 ] <> "V" .AND. !(allTrim( aHeader[ nJ, 2 ] ) $ cCampos)
						If aCols[ nI, nJ ] <> &( "SC7->" + aHeader[ nJ, 2 ] )
							lEnvGrade := .T.
							exit
						EndIf
					EndIf
				Next

			Else
				lEnvGrade := .T.
				exit
			Endif
			If lEnvGrade
				exit
			EndIf
		Next
	Endif

	If lEnvGrade
		cUpdSC7 := "UPDATE " + retSQLName("SC7") + " SET C7_ENVGRAD = 'S' WHERE C7_FILIAL = '" + cxFil + "' AND C7_NUM = '" + cC7Num + "'"
	Else
		cUpdSC7 := "UPDATE " + retSQLName("SC7") + " SET C7_ENVGRAD = 'N' WHERE C7_FILIAL = '" + cxFil + "' AND C7_NUM = '" + cC7Num + "'"
	EndIf

	nRet := tcSqlExec(cUpdSC7)

	If nRet == 0
		If "ORACLE" $ tcGetDB()
			tcSqlExec( "COMMIT" )
		EndIf
	Else
		ConOut("Problema no update u_mgf8CkGd")
	EndIf

	restArea(aAreaSC7)
	restArea(aArea)
return

//----------------------------------------------------------------------------------------------------------
// Verifica se a alteracao do Solicitação de Compra vai para Grade de Aprovacao
//----------------------------------------------------------------------------------------------------------
user function mgf8GdC1()

	local nI			:= 0
	local nJ			:= 0
	local aArea			:= getArea()
	local aAreaSC1		:= SC1->( getArea() )
	local nPosC1Num		:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_NUM'	})
	local nPosC1Item	:= aScan(aHeader, {|x| Alltrim(x[2]) == 'C1_ITEM'	})

	Local nPosFld		:= 0

	local lEnvGrade		:= .F.
	local cC1Num		:= SC1->C1_NUM
	local cUpdSC1		:= ""
	Local cCampos		:= GETMV("MGF_COM13")

	Local aCampos		:= SEPARA(cCampos,",")

	// VALIDA ITENS
	For nI := 1 to Len(aCols)
		SC1->( DBGoTop() )
		SC1->( DBSetOrder( 1 ) )//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
		If SC1->( DBSeek( xFilial("SC1") + cC1Num + aCols[ nI, nPosC1Item ] ) )

			For nJ := 1 to len( aHeader )
				If aHeader[ nJ, 10 ] <> "V" .and. !(allTrim( aHeader[ nJ, 2 ] ) $ cCampos)
					If aCols[ nI, nJ ] <> &( "SC1->" + aHeader[ nJ, 2 ] )
						lEnvGrade := .T.
						exit
					Endif
				EndIf
			Next nJ

		Else
			lEnvGrade := .T.
			exit
		EndIf

		If lEnvGrade
			exit
		Endif
	Next nI

	If lEnvGrade
		cUpdSC1 := "UPDATE " + retSQLName("SC1") + " SET C1_ENVGRAD = 'S' WHERE C1_FILIAL = '" + xFilial("SC1") + "' AND C1_NUM = '" + cC1Num + "'"
	Else
		cUpdSC1 := "UPDATE " + retSQLName("SC1") + " SET C1_ENVGRAD = 'N' WHERE C1_FILIAL = '" + xFilial("SC1") + "' AND C1_NUM = '" + cC1Num + "'"
	Endif

	nRet := tcSqlExec(cUpdSC1)

	If nRet == 0
		If "ORACLE" $ tcGetDB()
			tcSqlExec( "COMMIT" )
		EndIf
	Else
		ConOut("Problema no update u_mgf8GdC1")
	EndIf

	restArea(aAreaSC1)
	restArea(aArea)
return

Static Function xAprSC7(cNum)

	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()

	Local cConaPro := "L"

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT *
		FROM %Table:SCR% SCR
		WHERE
		SCR.%NotDel% AND
		SCR.CR_FILIAL = %xFilial:SCR% AND
		SCR.CR_NUM = %Exp:cNum% AND
		SCR.CR_DATALIB = ' '

	EndSQL

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		cConaPro := "B"
		Exit
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

Return cConaPro

Static Function xCriGRDT(cPed)

	Local aArea 	:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	Local cFld		:= ""
	Local ni
	Local nj

	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL

	If !(SCR->(dbSeek(xFilial("SCR") + "PC" + cPed)))
		If Len(_XMGFASCR) > 0
			For ni := 1 to Len(_XMGFASCR)
				RecLock("SCR",.T.)
				For nj := 1 to Len(_XMGFASCR[ni])
					cFld := "SCR->" + _XMGFASCR[ni,nj,1]
					&(cFld) := _XMGFASCR[ni,nj,2]
				next nj
				SCR->(MsUnLock())
			Next ni
		EndIf
	EndIf

	RestArea(aAreaSCR)
	RestArea(aArea)

return

User Function MGFC8SC()

	Local aArea 	 := GetArea()
	Local aAreaSC1	 := SC1->(GetArea())

	Local cNextAlias := GetNextAlias()
	Local lRet		 := .T.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT *
		FROM
		%Table:SC1% SC1
		WHERE
		SC1.%NotDel% AND
		SC1.C1_FILIAL = %Exp:SC1->C1_FILIAL% AND
		SC1.C1_NUM = %Exp:SC1->C1_NUM%  AND
		( SC1.C1_PEDIDO <> ' ' OR SC1.C1_COTACAO <> ' ')

	EndSQL

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		lRet := .F.
		Exit
		(cNextAlias)->(dbSkip())
	EndDo


	(cNextAlias)->(DbClosearea())

	RestArea(aAreaSC1)
	RestArea(aArea)

Return lRet

/*/{Protheus.doc} xPAEIC
//Descrição : Função Para Alteração de campos de Vencimentos em SE2 através do Ponto de Entrada FA750BRW() em FINA750
// 			  Regra de Permissão E2_TIPO=="PA" | E2_PREFIXO == "EIC" | E2_ORIGEM == "SIGAEIC" | A2_EST do Fornecedor <> "EX" |
//            Atualizando a Tabela SWB
@author Andy Pudja
@since 08/11/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function xPAEIC()

	Local _aArea	:= GetArea()
	Local _aArSE2	:= GetArea("SE2")

	Local _cMsg    	:= " "
	Local _dVenCto	:= dDataBase
	Local _dVenRea	:= DataValida(dDataBase)
	Local lBxTxa 	:= SuperGetMv("MV_BXTXA",.F.,"1") == "1"

	IF (SE2->E2_SALDO + SE2->E2_SDACRES == 0) .or. (!lBxTxa .and. SE2->E2_OK == 'TA' .and. !SE2->E2_TIPO $ MVPAGANT)
		*----------- Título Baixado ----------*
		Help(" ",1,"TITBAIXADO") // Regra do Padrão, vide FINA080
		*-------------------------------------*
	Else
		_cNome   := Posicione('SA2', 1, xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA, 'A2_NOME')
		If (Alltrim(SE2->E2_TIPO) == "PA") .And. (Alltrim(SE2->E2_PREFIXO) == "EIC") .And. (Alltrim(SE2->E2_ORIGEM) == "SIGAEIC") // .And. (Alltrim(_cEstado)=="EX")

			@ 0,0 TO 200,500 DIALOG oDlg1 TITLE "Altera Vencimento PA-EIC" 			// DIALOG oDlg para Formar a Janela de Informações e Entrada de Dados

			*------------------------- Dados do Título --------------------------------------*
			@ 05,010 Say "Fornecedor: "	+ SE2->E2_FORNECE + "/" + SE2->E2_LOJA + " - " + Alltrim(_cNome)
			@ 15,010 Say "Título: "		+ SE2->E2_NUM + "/" + Alltrim(SE2->E2_PREFIXO)
			@ 25,010 Say "Tipo: " 		+ Alltrim(SE2->E2_TIPO)
			@ 35,010 Say "Parcela: " 	+ Alltrim(SE2->E2_PARCELA)

			@ 50,010 Say "Valor: " 		+ Alltrim(Transform(SE2->E2_VALOR,'@E 99,999,999.99'))
			@ 60,010 Say "Vencimento: " 	+ DTOC(SE2->E2_VENCTO)
			@ 70,010 Say "Venc. Real:  " 	+ DTOC(SE2->E2_VENCREA)

			@ 60,080 Say "Novo Vencimento: "
			@ 60,130 GET _dVenCto Picture PesqPict("SE2","E2_VENCTO") 	Valid _dVenCto >= dDataBase  			SIZE 45,15
			@ 70,080 Say "Novo Venc. Real: "
			@ 70,130 GET _dVenRea Picture PesqPict("SE2","E2_VENCREA") 	Valid _dVenRea >= DataValida(_dVenCto) 	SIZE 45,15
			*---------------------------------------------------------------------------------*

			*------------------------ Botões -------------------------------------------------*
			@ 045,200 BUTTON "Processar" SIZE 35,15 ACTION (AltVenc(_dVenCto, _dVenRea), Close(oDlg1))	// Botão ativando Função que irá gravar os Vencimentos Informados
			@ 065,200 BUTTON "Sair"      SIZE 35,15 ACTION Close(oDlg1)									// Botão Fechando a Janela
			*---------------------------------------------------------------------------------*

			ACTIVATE DIALOG oDlg1 CENTER 											// Ativando Janela para Informe das Datas de Vencimento

		Else
			*----------------- Não Condiz com a Regra de Permissão PA-EIC --------------------*
			If (Alltrim(SE2->E2_TIPO) 		<> "PA")
				_cMsg:= "pois o Tipo é: " 		+ Alltrim(SE2->E2_TIPO)
			EndIf
			If (Alltrim(SE2->E2_PREFIXO) 	<> "EIC")
				_cMsg:= "pois o Prefixo é: " 	+ Alltrim(E2_PREFIXO)
			EndIf
			If Alltrim(SE2->E2_ORIGEM) 		<> "SIGAEIC"
				_cMsg:= "pois a Origem é: " 	+ Alltrim(E2_ORIGEM)
			EndIf
			Alert('Não Pode Alterar os Vencimentos!!!, '+_cMsg)
			*----------------------------------------------------------------------------------*
		EndIf
	EndIf
	*-------- Restaurando Área -----------*
	RestArea(_aArSE2)
	RestArea(_aArea)
	*-------------------------------------*
Return


/*/{Protheus.doc} AltVenc
//Descrição : Função Para Gravação dos campos de Vencimentos em SE2 e em SWB, chamada pela função xPAEIC()
//			  Botão Processar do Dialog em xPAEIC().
@author Andy Pudja
@since 08/11/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
Static Function AltVenc(_dVenCto, _dVenRea)
Local _aArSWB	:= GetArea("SWB")
Local _lGraSE2	:= .F.
Local _lGraSWB	:= .F.
		*--------------- SE2 ------------------*
		RecLock("SE2")
			SE2->E2_VENCTO	:= _dVenCto
			SE2->E2_VENCREA := _dVenRea
			_lGraSE2			:= .T.
		MsUnlock()
		*--------------------------------------*

		*--------------- SWB ------------------*
		DbSelectArea('SWB')
		DbOrderNickName("SWBSE2") 	// SWB->WB_FILIAL + SWB->WB_PREFIXO + SWB->WB_NUMDUP + SWB->WB_PARCELA + SWB->WB_TIPOTIT + SWB->WB_FORN + SWB->WB_LOJA
		If dbSeek(xFilial("SWB") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA )
			RecLock("SWB")
				SWB->WB_DT_VEN	:= _dVenRea
				_lGraSWB			:= .T.
			MsUnlock()
		Else
			_lGraSWB	:= .F.
		EndIf
		*--------------------------------------*

		*--------- Aviso do Processo ----------*
		If _lGraSE2 .And. _lGraSWB
			Alert('Todos os Vencimentos Atualizados!!! ')
		Else
			If _lGraSE2
				Alert('Vencimentos dos Títulos Foram Atualizados, Exceto Registro de Ítem de Câmbio (SWB) !!! ')
			Else
				If !_lGraSWB
					Alert('Os Vencimentos Não Foram Atualizados!!! ')
					// Nunca vai acontecer, pois a principio nem precisamos controlar a gravação do SE2,
					// pois o título sempre existirá e a rotina está posicionada!
					// No entanto vamos deixar a estutura da consistência como está para a questão de entendimento da possibilidade dos cenários.
				EndIf
			EndIf
		EndIf
		*--------------------------------------*

RestArea(_aArSWB)
Return