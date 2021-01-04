#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER chr(13)+chr(10)

/*
=====================================================================================
Programa.:              MGFINT11
Autor....:              Francis Oliveira
Data.....:              26/09/2016
Descricao / Objetivo:   Integraçao RoadNet
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Tela de Exportação de Pedidos de Venda e Clientes
=====================================================================================
*/

//=============================== Relação das Functions =================================
// 01 - Função Principal - MGFINT11()
// 02 - Funcão que monta o ListBox - SELECSC5()
// 03 - Selecionar os Pedidos de Vendas - MONTASC5()
// 04 - Gera o TXT em Simulação - TXTSIM()
// 05 - Gera o arquivo de Pedidos de Venda Oficial - TXTOFI()
// 06 - Gera o arquivo de todos os clientes sem olhar os Pedidos de Venda - GERACLI()
// 07 - Gera arquivo de Clientes porem com base nos PV selecionados - GERACLIPD()
// 08 - Desmarca todos os registros - DESMBOX01()
// 09 - Marca todos os registros - MARCBOX01()
//=======================================================================================

/* @alterações: RTASK0010480- Henrique Vidal 25/11/2019
           :  Alterado para não considerar funcionários na exportação de clientes do roadnet botão: 'Txt Clientes'
*/

// 01 - Função Principal
User Function MGFINT11()

	SELECSC5()

Return

// 02 - Funcão que monta o ListBox
Static Function SELECSC5()

	Private oCodIni
	Private oCodFim
	Private oCodReg
	Private dDTINI := CtoD("  /   /   ")
	Private dDTFIM := CtoD("  /   /   ")
	Private oListBox1
	Private oListBox2
	Private oCodReg
	Private cCodReg := Space(3)
	Private oValTot
	Private nValTot := 0
	Private oDlg
	Private oOk	    := LoadBitmap( GetResources(), "LBOK")
	Private oNo       := LoadBitmap( GetResources(), "LBNO")
	Private aListBox1 := {}
	Private nTotVen := 0
	Private oFont
	Private aItensSC5 := {}
	Private cRoadDir := SuperGetMV("MGF_ROADIR",.F.,"c:\roadnet\")
	Private cRoadCli := SuperGetMV("MGF_ROACLI",.F.,"c:\roadnet\clientes\")
	Private cNomCli := ""
	Private lSimular := .T.
	Private cUserSim := SuperGetMV("MGF_SIMROA",.F.,"000002;000000")
	Private cBmpMgf := SuperGetMV("MGF_BMPMGF",.F.,"c:\roadnet\bmpmgf.bmp")
    Private _oCoddir := nil
	Private _cCoddir := ' '

    //===		S E L E C I O N A	D I R E T O R I A
	//cQryDireto	:= "SELECT ' Não Informado' as ZBD_CODIGO, '" +SPACE(TamSx3("ZBD_DESCRI")[1])+ "' as ZBD_DESCRI FROM DUAL UNION ALL "	// Coloco um espaço no começo de " Não Informado" para este registro aparecer na 1ª linha do Browse
	cQryDireto	:= "  SELECT ZBD_CODIGO, ZBD_DESCRI "
	cQryDireto  += "  FROM "+ RetSqlName("ZBD") + " ZBD "
	cQryDireto	+= "  WHERE ZBD.D_E_L_E_T_ = ' ' "
	cQryDireto	+= "  ORDER BY ZBD_CODIGO, ZBD_DESCRI"
	aCpoDireto	:=	{	{ "ZBD_CODIGO"	,"Código"		,TamSx3("ZBD_CODIGO")[1] + 50	}	,;
						{ "ZBD_DESCRI"	,"Diretoria"	,TamSx3("ZBD_DESCRI")[1] 		}	 }
	cTitDireto	:= "Diretorias a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
	//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa.
	//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro)
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
    //_cCoddir	:=  U_Array_In( U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ) )



	DEFINE FONT oFont NAME "ARIAL" SIZE 8,20 BOLD

	DEFINE MSDIALOG oDlg TITLE "MARFRIG - Processo RoadNet" FROM C(150),C(230) TO C(600),C(1250) PIXEL

	//-------------------- ListBox para Selecionar os Pedidos de Venda ------------------------//
	@ C(004),C(003) TO C(212),C(510) LABEL "Selecionar os Pedidos de Venda" PIXEL OF oDlg
	@ C(015),C(006) SAY "Data de Entrega de...:" OF oDlg PIXEL SIZE 036,020
	@ C(015),C(038) MSGET oCodIni  VAR dDTIni OF oDlg PIXEL SIZE 060,009
	@ C(015),C(093) SAY "Data de Entrega ate..:" OF oDlg PIXEL SIZE 036,020
	@ C(015),C(123) MSGET oCodFim  VAR dDTFim OF oDlg PIXEL SIZE 060,009
	@ C(015),C(180) SAY "Regiao..:" OF oDlg PIXEL SIZE 036,030
	@ C(015),C(200) MSGET oCodReg VAR cCodReg F3 "SZP" OF oDlg PIXEL SIZE 020,009
	@ C(015),C(240) SAY "Diretoria..:" OF oDlg PIXEL SIZE 036,030
	//@ C(015),C(263) MSGET _oCoddir VAR _cCoddir F3 "ZBD" OF oDlg PIXEL SIZE 020,009
	@ C(015),C(263) MSGET _oCoddir VAR _cCoddir valid _cCoddir:=U_Array_In(U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ))  OF oDlg PIXEL SIZE 020,009
	@ C(015),C(320) BUTTON "&Pesquisar" SIZE 40,12 ACTION (Processa( {|| MONTASC5(), oListbox1:Refresh() } )) OF oDlg PIXEL
	@ C(015),C(370) BUTTON "&Marcar" SIZE 40,20 ACTION (Processa( {|| MARCBOX01(), oListbox1:Refresh() } )) OF oDlg PIXEL
	@ C(015),C(410) BUTTON "&Desmarcar" SIZE 40,20 ACTION (Processa( {|| DESMBOX01(), oListbox1:Refresh() } )) OF oDlg PIXEL
	@ C(015),C(450) BUTTON "&TXT Clientes" SIZE 40,20 ACTION (Processa( {|| GERACLI(), oListbox1:Refresh() } )) OF oDlg PIXEL

	@ C(009),C(450) BITMAP oBitmap1 SIZE 052, 052 OF oDlg FILENAME cBmpMgf NOBORDER PIXEL
	@ C(214),C(450) BUTTON "S&air" SIZE 40,12 PIXEL OF oDlg ACTION( oDlg:End() )
	@ C(214),C(375) BUTTON "&Simular" SIZE 40,12 ACTION (Processa( {|| TXTSIM(), oListbox1:Refresh() } )) OF oDlg PIXEL
	@ C(214),C(025) BUTTON "&Oficial" SIZE 40,12 ACTION (Processa( {|| TXTOFI(), oListbox1:Refresh() } )) OF oDlg PIXEL
	@ C(038),C(005) ListBox oListBox1 Fields Header " ","Cod.Cliente","Loja","Nome","Cod.RoadNet PV";
	,"Num Pedido","Peso Liq","Peso Bruto","Dt.Entrega","Valor Total";
	Size C(500),C(172) Of oDlg Pixel ColSizes 20,40,20,200,50,40,60,60,40,60

	oListBox1:SetArray(aListBox1)

	oListBox1:bLine := {|| { If(aListBox1[oListBox1:nAT,01],oOk,oNo),;
	aListBox1[oListBox1:nAT,02],;
	aListBox1[oListBox1:nAT,03],;
	aListBox1[oListBox1:nAT,04],;
	aListBox1[oListBox1:nAT,05],;
	aListBox1[oListBox1:nAT,06],;
	aListBox1[oListBox1:nAT,07],;
	aListBox1[oListBox1:nAT,08],;
	aListBox1[oListBox1:nAT,09],;
	aListBox1[oListBox1:nAT,10]}}

	oListBox1:blDblClick := {||If(oListBox1:ColPos==1,aListBox1[oListbox1:nAT][1] := !aListBox1[oListbox1:nAT][1],nil),;
	oListbox1:Refresh() }

	If Len(aListBox1) == 0
		aAdd(aListBox1,{.F.,"","","","","",0,0,"",0})
		oListbox1:Refresh()
	EndIf

	ACTIVATE MSDIALOG oDlg CENTERED

Return

// 03 - Selecionar os Pedidos de Vendas
Static Function MONTASC5()
LOCAL _cAliazbd := getnextalias()
LOCAL _cRepr    := ' '
Local _cQuezbd  := ' '


    IF !EMPTY(_cCoddir)
		_cCoddir := alltrim(_cCoddir)
   		//_cCoddir := substr(_cCoddir,3,len(_cCoddir))
		//_cCoddir := substr(_cCoddir,1,len(_cCoddir)-2)

		 _cQuezbd  := "	SELECT ZBD.ZBD_CODIGO, ZBI.ZBI_REPRES " + ENTER
		 _cQuezbd  += "	FROM "+RetSqlName("ZBD")+ " ZBD " + ENTER
		 _cQuezbd  += "	INNER JOIN "+RetSqlName("ZBI")+ " ZBI " + ENTER
		 _cQuezbd  += "	ON ZBI.ZBI_FILIAL = '"+XFILIAL('ZBD')+"' AND ZBI.ZBI_DIRETO = ZBD.ZBD_CODIGO AND ZBI.D_E_L_E_T_ = ''"  + ENTER
		 _cQuezbd  += "	WHERE ZBD.ZBD_FILIAL = '"+XFILIAL('ZBD')+"'  AND  " + ENTER
		 _cQuezbd  += "	ZBD.ZBD_CODIGO IN "+_cCoddir+ " AND " + ENTER
		 _cQuezbd  += "	ZBD.D_E_L_E_T_ = ' ' "  + ENTER
		 _cQuezbd  += "	ORDER BY ZBI_REPRES " + ENTER

		 _cQuezbd := Changequery(_cQuezbd)

		If Select(_cAliazbd) > 0
			(_cAliazbd)->(DbClosearea())
		Endif

		dbusearea(.t.,"TOPCONN", TCGENQRY(,,_cQuezbd),_cAliazbd,.F.,.T.)

		DbSelectArea(_cAliazbd)
		(_cAliazbd)->(dbGoTop())


		DO While (_cAliazbd)->(!EOF())

			IF EMPTY(_cRepr)
				_cRepr := ALLTRIM((_cAliazbd)->ZBI_REPRES)

			Else
			    _cRepr  += "','"+ALLTRIM((_cAliazbd)->ZBI_REPRES)
			EndIf

			(_cAliazbd)->(dbSkip())

		ENDDO

 	ENDIF

	If (dDTIni <= dDTFim) .AND. (!Empty(dDTIni) .OR. !Empty(dDTFim)) .AND. !Empty(cCodReg)

		aListBox1 := {}
		aItensSC5 := {}

		cQuery := " SELECT C5_ZIDECOM, C5_CLIENTE, C5_LOJACLI, C5_NUM, C5_PESOL, C5_PBRUTO, C5_FECENT, C5_ZCROAD," + ENTER
		cQuery += " SUM(C6_VALOR) TOTAL, SUM(C6_QTDVEN) QTD, " + ENTER
		cQuery += " A1_NOME  " + ENTER
		cQuery += " FROM "       + RetSqlName("SC5") + " SC5 " + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 " + ENTER
		cQuery += " ON SC6.C6_FILIAL = SC5.C5_FILIAL " + ENTER
		cQuery += " AND SC6.C6_NUM = SC5.C5_NUM " + ENTER
		cQuery += " AND SC6.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 " + ENTER
		cQuery += " ON SA1.A1_COD = SC5.C5_CLIENTE " + ENTER
		cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI " + ENTER
		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " AND SA1.A1_ZCROAD = SC5.C5_ZCROAD " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("ZAP")+ " ZAP " + ENTER
		cQuery += " ON ZAP.ZAP_UF||ZAP.ZAP_CODMUN = SA1.A1_EST||SA1.A1_COD_MUN " + ENTER
		cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("SZJ")+ " SZJ " + ENTER
		cQuery += " ON SC5.C5_ZTIPPED = SZJ.ZJ_COD " + ENTER
		cQuery += " AND SZJ.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " WHERE SC5.C5_ZROAD = 'N' " + ENTER
		cQuery += " AND SC5.C5_FILIAL = '"+cFilAnt+"' " + ENTER
		cQuery += " AND SC5.C5_FECENT >= '" + DtoS(dDTINI) + "' " + ENTER
		cQuery += " AND SC5.C5_FECENT <= '" + DtoS(dDTFIM) + "' " + ENTER
		cQuery += " AND ZAP.ZAP_CODREG = '"+cCodReg+"' "+ ENTER
		cQuery += " AND SC5.C5_ZBLQRGA = 'L' " + ENTER
		cQuery += " AND SC5.C5_MSBLQL = '2' " + ENTER
		cQuery += " AND SC5.C5_TIPO = 'N' " + ENTER
		cQuery += " AND SC5.C5_TPFRETE IN ('C','T') " + ENTER
		cQuery += " AND SC5.C5_NOTA = '         ' " + ENTER
		cQuery += " AND SC5.C5_XREDE <> 'S' " + ENTER

		IF !EMPTY( _cRepr  )
			cQuery += " AND SC5.C5_VEND1 IN ('"+ _cRepr +"')" + ENTER
		ENDIF

		cQuery += " AND SZJ.ZJ_TAURA = 'S' " + ENTER
		cQuery += " AND SC5.C5_CLIENTE <> '000095' " + ENTER
		cQuery += " AND SC5.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " GROUP BY C5_ZIDECOM, C5_CLIENTE, C5_LOJACLI, C5_NUM, C5_PESOL, C5_PBRUTO, C5_FECENT, C5_ZCROAD, A1_NOME  " + ENTER
		cQuery += " UNION ALL " + ENTER
		cQuery += " SELECT C5_ZIDECOM, C5_CLIENTE, C5_LOJACLI, C5_NUM, C5_PESOL, C5_PBRUTO, C5_FECENT, C5_ZCROAD," + ENTER
		cQuery += " SUM(C6_VALOR) TOTAL, SUM(C6_QTDVEN) QTD, " + ENTER
		cQuery += " A1_NOME  " + ENTER
		cQuery += " FROM "       + RetSqlName("SC5") + " SC5 " + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 " + ENTER
		cQuery += " ON SC6.C6_FILIAL = SC5.C5_FILIAL " + ENTER
		cQuery += " AND SC6.C6_NUM = SC5.C5_NUM " + ENTER
		cQuery += " AND SC6.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 " + ENTER
		cQuery += " ON SA1.A1_COD = SC5.C5_CLIENTE " + ENTER
		cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI " + ENTER
		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("SZ9")+ " SZ9 " + ENTER
		cQuery += "	ON SZ9.Z9_ZCLIENT = SC5.C5_CLIENTE " + ENTER
		cQuery += "	AND SZ9.Z9_ZLOJA = SC5.C5_LOJACLI " + ENTER
		cQuery += "	AND SZ9.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += "	AND SZ9.Z9_ZCROAD = SC5.C5_ZCROAD " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("ZAP")+ " ZAP " + ENTER
		cQuery += " ON ZAP.ZAP_UF||ZAP.ZAP_CODMUN = SZ9.Z9_ZEST||SZ9.Z9_ZCODMUN " + ENTER
		cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("SZJ")+ " SZJ " + ENTER
		cQuery += " ON SC5.C5_ZTIPPED = SZJ.ZJ_COD " + ENTER
		cQuery += " AND SZJ.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " WHERE SC5.C5_ZROAD = 'N' " + ENTER
		cQuery += " AND SC5.C5_FILIAL = '"+cFilAnt+"' " + ENTER
		cQuery += " AND SC5.C5_FECENT >= '" + DtoS(dDTINI) + "' " + ENTER
		cQuery += " AND SC5.C5_FECENT <= '" + DtoS(dDTFIM) + "' " + ENTER
		cQuery += " AND ZAP.ZAP_CODREG = '"+cCodReg+"' "+ ENTER
		cQuery += " AND SC5.C5_ZBLQRGA = 'L' " + ENTER
		cQuery += " AND SC5.C5_MSBLQL = '2' " + ENTER
		cQuery += " AND SC5.C5_TIPO = 'N' " + ENTER
		cQuery += " AND SC5.C5_TPFRETE IN ('C','T') " + ENTER
		cQuery += " AND SZJ.ZJ_TAURA = 'S' " + ENTER
		cQuery += " AND SC5.C5_CLIENTE <> '000095' " + ENTER
		cQuery += " AND SC5.C5_NOTA = '         ' " + ENTER
		cQuery += " AND SC5.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " AND SC5.C5_XREDE <> 'S' " + ENTER
		cQuery += " GROUP BY C5_ZIDECOM, C5_CLIENTE, C5_LOJACLI, C5_NUM, C5_PESOL, C5_PBRUTO, C5_FECENT, C5_ZCROAD, A1_NOME  " + ENTER
		cQuery += " ORDER BY C5_NUM "

		conout( "[MGFINT11] " + cQuery )

		If ( Select("TMP1") ) > 0
			DbSelectArea("TMP1")
			TMP1->(DbCloseArea())
		EndIf

		TCQUERY Changequery(cQuery) NEW ALIAS "TMP1"

		DbSelectArea("TMP1")
		DbGoTop()

		While TMP1->(!Eof())
			if !empty( TMP1->C5_ZIDECOM )

				// Se for um Pedido do E-Commerce verifica se o cartao ainda continua Valido
				if chkOrderEc( TMP1->C5_ZIDECOM )
					aAdd(aItensSC5, {.T.,+; // 1
					TMP1->C5_CLIENTE,+; // 2
					TMP1->C5_LOJACLI,+; // 3
					TMP1->A1_NOME,+; // 4
					TMP1->C5_ZCROAD,+; // 5
					TMP1->C5_NUM,+; // 6
					Transform(TMP1->QTD,"@E 99999.9999"),+; // 7			TMP1->C5_PESOL,+; // 7 - ALTERADO POR BARBIERI 29/03/2018
					Transform(TMP1->QTD,"@E 99999.9999"),+; // 8			Transform(TMP1->C5_PBRUTO,"@E 99999.9999"),+; // 8 - ALTERADO POR BARBIERI 29/03/2018
					StoD(TMP1->C5_FECENT),+; // 9
					Transform(TMP1->TOTAL,"@E 999,999,999.99") }) // 10
				else

				endif
			else
				aAdd(aItensSC5, {.T.,+; // 1
				TMP1->C5_CLIENTE,+; // 2
				TMP1->C5_LOJACLI,+; // 3
				TMP1->A1_NOME,+; // 4
				TMP1->C5_ZCROAD,+; // 5
				TMP1->C5_NUM,+; // 6
				Transform(TMP1->QTD,"@E 99999.9999"),+; // 7			TMP1->C5_PESOL,+; // 7 - ALTERADO POR BARBIERI 29/03/2018
				Transform(TMP1->QTD,"@E 99999.9999"),+; // 8			Transform(TMP1->C5_PBRUTO,"@E 99999.9999"),+; // 8 - ALTERADO POR BARBIERI 29/03/2018
				StoD(TMP1->C5_FECENT),+; // 9
				Transform(TMP1->TOTAL,"@E 999,999,999.99") }) // 10
			endif

			TMP1->(DbSkip())
		EndDo

		aListBox1 := aItensSC5

		oListBox1:SetArray(aListBox1)

		If Len(aListBox1) == 0
			MSGALERT("Nao foram encontados registros !!!","MARFRIG")
			aAdd(aListBox1,{.F.,"","","","","",0,0,"",0})
			oListbox1:Refresh()
		EndIf

		oListBox1:SetArray(aListBox1)
		oListBox1:bLine := {|| { If(aListBox1[oListBox1:nAT,01],oOk,oNo),;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03],;
		aListBox1[oListBox1:nAT,04],;
		aListBox1[oListBox1:nAT,05],;
		aListBox1[oListBox1:nAT,06],;
		aListBox1[oListBox1:nAT,07],;
		aListBox1[oListBox1:nAT,08],;
		aListBox1[oListBox1:nAT,09],;
		aListBox1[oListBox1:nAT,10] }}
		oListBox1:Refresh()
	Else
		MSGALERT("Data Invalida ou Regiao em Branco !!","MARFRIG")

		aListBox1 := {}
		aAdd(aListBox1,{.F.,"","","","","",0,0,"",0})

		oListBox1:SetArray(aListBox1)
		oListBox1:bLine := {|| { If(aListBox1[oListBox1:nAT,01],oOk,oNo),;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03],;
		aListBox1[oListBox1:nAT,04],;
		aListBox1[oListBox1:nAT,05],;
		aListBox1[oListBox1:nAT,06],;
		aListBox1[oListBox1:nAT,07],;
		aListBox1[oListBox1:nAT,08],;
		aListBox1[oListBox1:nAT,09],;
		aListBox1[oListBox1:nAT,10] }}
		oListbox1:Refresh()

	EndIf

Return

// 04 - Gera o TXT em Simulação
Static Function TXTSIM() // utilizar para gerar o txt

	Local cDados	 := 0
	Local cLista 	 := ""
	Local dHora 	 := StrTran(Time(),":","")
	Local dData    := StrTran(DtoC(Date()),"/","")
	Local cUsuMGF  := cUserName
	Local cDirValid1 := ""
	local cDirValid2 := ""
	Local lValDir := .F.
	Local lGera := .T.

	lSimular := .T.

	If MsgYesNo("Deseja gerar arquivo de PEDIDOS em SIMULAÇÃO?")
		If __cUserID $ cUserSim

			// Valida se o diretorio existe, caso nao cria
			nCria := 0
			cDirValid1 := cRoadDir + cFilAnt + "\"
			cDirValid2 := cRoadDir + cFilAnt + "\" + cCodReg + "\"
			lValDir1 := ExistDir(cDirValid1)
			lValDir2 := ExistDir(cDirValid2)

			If lValDir1 == .F.
				nCria := MAKEDIR(cDirValid1)
				If nCria != 0
					MSGALERT("Nao foi possivel criar o diretorio !!","MARFRIG")
					Return
				EndIf
			EndIf

			If lValDir2 == .F.
				nCria := MAKEDIR(cDirValid2)
				If nCria != 0
					MSGALERT("Nao foi possivel criar o diretorio !!","MARFRIG")
					Return
				EndIf
			EndIf

			//cArqTxt := cRoadDir + dData + dHora + cUsuMGF + ".txt"
			For nH := 1 To Len(aListBox1)
				If 	aListBox1[nH,1] .and. lGera
					cArqTxt := cRoadDir + cFilAnt + "\" + cCodReg + "\" + dData + dHora + cUsuMGF + "_SIM.txt"
					cDados	 := MSFCreate( cArqTxt  )
					lGera := .F.
				EndIf
			Next

			For nI := 1 to Len(aListBox1)
				If aListBox1[nI,01]
					nPeso1 := StrTran(aListBox1[nI,08],".","")
					nPeso2 := StrTran(nPeso1,",",".")
					nPeso3 := PaDL(allTrim(nPeso2),16,"0")

					nVal1 := StrTran(aListBox1[nI,10],".","")
					nVal2 := StrTran(nVal1,",",".")
					nVal3 := PaDL(allTrim(nVal2),16,"0")

					cLista := Space(54) //Código de Importacao
					cLista += PaDL(aListBox1[nI,05],15,"0") // Alterado para o numero do RoadNet
					cLista += PaDR(aListBox1[nI,06],15," ") // Numero do Pedido de Venda
					cLista += "O" // Tipo de Produto
					cLista += nPeso3 // Peso Bruto
					cLista += nVal3 + ENTER // Valor Total NF
					FWrite (cDados,cLista)
				EndIf
			Next nI

			FClose (cDados)

			// Gera o arquivo de roteirização
			GERACLIPD()

			If !Empty(cLista)
				ApMsgInfo(" ARQUIVO DE PEDIDOS DE VENDA ";
				+ ENTER ;
				+ ENTER + " Foram gerados os arquivos de SIMULAÇÃO,  " ;
				+ ENTER + " dos Pedidos de Venda. " ;
				+ ENTER ;
				+ ENTER + " Diretorio Pedidos de Venda...........: " + cRoadDir + cFilAnt + "\" + cCodReg + "\" ; // + ENTER + " Diretorio Roteirização dos Clientes..: " + cRoadCli ;
				+ ENTER ;
				+ ENTER + " Arquivo Ped. Venda.......: " + dData + dHora + cUsuMGF + "_SIM.txt" ; // + ENTER + " Arquivo de Rot. Cliente..: " + cNomCli ;
				+ ENTER ;
				+ ENTER + " ATENÇÃO - Os lançamentos NÃO serão retirados da lista !!" )
			Else
				MSGALERT("Nenhum Registro Selecionado para Simulação !!","MARFRIG")
			EndIf
		Else
			MSGALERT("Usuario Nao Autorizado para Simulação !!","MARFRIG")
		EndIf
	Endif

Return

// 05 - Gera o arquivo de Pedidos de Venda Oficial
Static Function TXTOFI() // utilizar para gerar o txt

	Local cDados	 := 0
	Local cLista 	 := ""
	Local dHora 	 := StrTran(Time(),":","")
	Local dData    	 := StrTran(DtoC(Date()),"/","")
	Local cUsuMGF    := cUserName
	Local aListOFI   := {}
	Local cDirValid1 := ""
	local cDirValid2 := ""
	Local lValDir    := .F.
	Local lGera      := .T.

	lSimular := .F.

	// Valida se o diretorio existe, caso nao cria
	nCria := 0
	cDirValid1 := cRoadDir + cFilAnt + "\"
	cDirValid2 := cRoadDir + cFilAnt + "\" + cCodReg + "\"
	lValDir1 := ExistDir(cDirValid1)
	lValDir2 := ExistDir(cDirValid2)

	If MsgYesNo("Deseja gerar arquivo de PEDIDOS OFICIAL?")
		If lValDir1 == .F.
			nCria := MAKEDIR(cDirValid1)
			If nCria != 0
				MSGALERT("Nao foi possivel criar o diretorio !!","MARFRIG")
				Return
			EndIf
		EndIf

		If lValDir2 == .F.
			nCria := MAKEDIR(cDirValid2)
			If nCria != 0
				MSGALERT("Nao foi possivel criar o diretorio !!","MARFRIG")
				Return
			EndIf
		EndIf

		For nH := 1 To Len(aListBox1)
			If 	aListBox1[nH,1] .and. lGera
				cArqTxt := cRoadDir + cFilAnt + "\" + cCodReg + "\" + dData + dHora + cUsuMGF + ".txt"
				cDados	 := MSFCreate( cArqTxt  )
				lGera := .F.
			EndIf
		Next

		For nI := 1 to Len(aListBox1)
			If aListBox1[nI,01]
				nPeso1 := StrTran(aListBox1[nI,08],".","")
				nPeso2 := StrTran(nPeso1,",",".")
				nPeso3 := PaDL(allTrim(nPeso2),16,"0")

				nVal1 := StrTran(aListBox1[nI,10],".","")
				nVal2 := StrTran(nVal1,",",".")
				nVal3 := PaDL(allTrim(nVal2),16,"0")

				cLista := Space(54) //Código de Importacao
				cLista += PaDL(aListBox1[nI,05],15,"0") // Alterado para o numero do RoadNet
				cLista += PaDR(aListBox1[nI,06],15," ") // Numero do Pedido de Venda
				cLista += "O" // Tipo de Produto
				cLista += nPeso3 // Peso Bruto
				cLista += nVal3 + ENTER // Valor Total NF
				FWrite (cDados,cLista)

				DbSelectArea("SC5")
				DbSetOrder(1) // C5_FILIAL+C5_NUM
				DbGoTop()
				If SC5->(DbSeek(xFilial("SC5") + aListBox1[nI,06]))
					RecLock("SC5",.F.)
					SC5->C5_ZROAD := "S"
					MsUnlock()

					ecomXC5( xFilial("SC5"), aListBox1[nI,06] )
				EndIf
			Else
				aAdd(aListOFI,{aListBox1[nI,01],aListBox1[nI,02],aListBox1[nI,03],aListBox1[nI,04],;
				aListBox1[nI,05],aListBox1[nI,06],aListBox1[nI,07],aListBox1[nI,08],aListBox1[nI,09],;
				aListBox1[nI,10] })
			EndIf
		Next nI

		FClose (cDados)

		// Gera o arquivo de roteirização
		GERACLIPD()

		If !Empty(cLista)
			ApMsgInfo(" ARQUIVO DE PEDIDOS DE VENDA ";
			+ ENTER ;
			+ ENTER + " Foram gerados os arquivos OFICIAIS,  " ;
			+ ENTER + " dos Pedidos de Venda. " ;
			+ ENTER ;
			+ ENTER + " Diretorio Pedidos de Venda...........: " + cRoadDir + cFilAnt + "\" + cCodReg + "\" ; // + ENTER + " Diretorio Roteirização dos Clientes..: " + cRoadCli ;
			+ ENTER ;
			+ ENTER + " Arquivo Ped. Venda.......: " + dData + dHora + cUsuMGF + ".txt" ; // + ENTER + " Arquivo de Rot. Cliente..: " + cNomCli ;
			+ ENTER ;
			+ ENTER + " ATENÇÃO - Os lançamentos serão retirados da lista !!" )
		Else
			MSGALERT("Nenhum Registro Selecionado !!","MARFRIG")
		EndIf

		aListBox1 := aListOFI

		If Len(aListBox1) == 0
			//aAdd(aListBox1,{.F.,"","","","","",0,0,"",0})
			//oListbox1:Refresh()
		EndIf

		oListBox1:SetArray(aListBox1)
		oListBox1:bLine := {|| { If(aListBox1[oListBox1:nAT,01],oOk,oNo),;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03],;
		aListBox1[oListBox1:nAT,04],;
		aListBox1[oListBox1:nAT,05],;
		aListBox1[oListBox1:nAT,06],;
		aListBox1[oListBox1:nAT,07],;
		aListBox1[oListBox1:nAT,08],;
		aListBox1[oListBox1:nAT,09],;
		aListBox1[oListBox1:nAT,10] }}
		oListbox1:Refresh()
	ENDIF
Return

// 06 - Gera o arquivo de todos os clientes sem olhar os Pedidos de Venda
Static Function GERACLI()

	Local aCliSA1   := {}
	Local aCliSZ9   := {}
	Local aCliFull  := {}
	Local cPerg	    := 'MGFINT11'
	Local cDados    := 0
	Local cLista    := ""
	Local dHora     := StrTran(Time(),":","")
	Local dData     := StrTran(DtoC(Date()),"/","")
	Local cUsuMGF   := cUserName
	Local lGera 	:= .T.

	lSimular := .F.

	If __cUserID $ cUserSim


		// Apenas Tabela SA1
		cQuery := " SELECT A1_ZCROAD, A1_CGC, A1_COD, A1_NOME, A1_LOJA, A1_END, A1_BAIRRO, A1_MUN,  " + ENTER
		cQuery += " A1_EST, A1_CEP, A1_PESSOA " + ENTER
		cQuery += " FROM "       + RetSqlName("SA1") + " SA1 " + ENTER
		cQuery += " , " + RetSqlName("ZAP") + " ZAP" + ENTER
		cQuery += " WHERE SA1.A1_EST||SA1.A1_COD_MUN = ZAP.ZAP_UF||ZAP.ZAP_CODMUN " + ENTER
		cQuery += " AND SA1.A1_ZITROAD = 'S' " + ENTER // Roteiriza s/n
		cQuery += " AND SA1.A1_ZCROAD <> ' ' " + ENTER // Codigo do Roteiro
		cQuery += " AND SA1.A1_ZALTROA <> 'S' " + ENTER // Alterado S/N
		cQuery += " AND SA1.A1_TIPO <> 'X' "   	+ ENTER // Exceto estrangeiros
		cQuery += " AND A1_ZTPRHE  <> 'F' "		+ ENTER // Exceto funcionarios
		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
		If !empty(cCodReg)
			cQuery += " AND ZAP.ZAP_CODREG = '" + cCodReg +"'" + ENTER
		EndIf
		cQuery += " GROUP BY A1_ZCROAD, A1_CGC, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_PESSOA" + ENTER
		cQuery += " ORDER BY A1_ZCROAD "

		If ( Select("TMP2") ) > 0
			DbSelectArea("TMP2")
			TMP2->(DbCloseArea())
		EndIf

		TCQUERY Changequery(cQuery) NEW ALIAS "TMP2"

		DbSelectArea("TMP2")
		DbGoTop()

		While TMP2->(!Eof())
			aAdd(aCliSA1, {TMP2->A1_ZCROAD,+; // 1
			IIf(TMP2->A1_PESSOA == 'J','0' + TMP2->A1_CGC,substr(TMP2->A1_CGC,1,9) + '0000'+ substr(TMP2->A1_CGC,10,2)),+; // 2
			TMP2->A1_NOME,+; // 3
			TMP2->A1_END,+; // 4
			TMP2->A1_BAIRRO,+; // 5
			TMP2->A1_MUN,+; // 6
			TMP2->A1_EST,+; // 7
			TMP2->A1_CEP,+; // 8
			TMP2->A1_LOJA,+; // 9 Campo utilizado apenas para atualiza o A1_ZALTROA
			TMP2->A1_COD}) // 10
			TMP2->(DbSkip())
		EndDo

		For nB := 1 To Len(aCliSA1)
			aAdd(aCliFull,{aCliSA1[nB,1],aCliSA1[nB,2],aCliSA1[nB,3],aCliSA1[nB,4],aCliSA1[nB,5],;
			aCliSA1[nB,6],aCliSA1[nB,7],aCliSA1[nB,8],aCliSA1[nB,10]})
		Next

		// Apenas Tabela SZ9
		cQuery := " SELECT Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC,  " + ENTER
		cQuery += " Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA " + ENTER
		cQuery += " FROM "       + RetSqlName("SZ9") + " SZ9 " + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 " + ENTER
		cQuery += " ON SA1.A1_COD = SZ9.Z9_ZCLIENT " + ENTER
		cQuery += " AND SA1.A1_LOJA = SZ9.Z9_ZLOJA " + ENTER
		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " INNER JOIN " + RetSqlName("ZAP") + " ZAP" + ENTER
		cQuery += " ON ZAP.ZAP_UF||ZAP.ZAP_CODMUN = SZ9.Z9_ZEST||SZ9.Z9_ZCODMUN " + ENTER
		cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " WHERE SZ9.Z9_ZROTEIR = 'S' " + ENTER // Roteiriza s/n
		cQuery += " AND SZ9.Z9_ZCROAD  <> ' ' " + ENTER  // Codigo do Roteiro
		cQuery += " AND SZ9.Z9_ALROAD <> 'S' " + ENTER // Alterado S/N
		If !empty(cCodReg)
			cQuery += " AND ZAP.ZAP_CODREG = '" + cCodReg +"'" + ENTER
		EndIf
		cQuery += " AND SZ9.D_E_L_E_T_ = ' ' " + ENTER
		cQuery += " GROUP BY Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC, Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA" + ENTER
		cQuery += " ORDER BY Z9_ZCROAD "

		If ( Select("TMP3") ) > 0
			DbSelectArea("TMP3")
			TMP3->(DbCloseArea())
		EndIf

		TCQUERY Changequery(cQuery) NEW ALIAS "TMP3"

		DbSelectArea("TMP3")
		DbGoTop()

		While TMP3->(!Eof())
			aAdd(aCliSZ9, {TMP3->Z9_ZCROAD,+; // 1
			IIf(TMP3->A1_PESSOA == 'J','0' + TMP3->A1_CGC,substr(TMP3->A1_CGC,1,9) + '0000'+ substr(TMP3->A1_CGC,10,2)),+; // 2 TMP3->A1_CGC,+; // 2
			TMP3->A1_NOME,+; // 3
			TMP3->Z9_ZENDER,+; // 4
			TMP3->Z9_ZBAIRRO,+; // 5
			TMP3->Z9_ZMUNIC,+; // 6
			TMP3->Z9_ZEST,+; // 7
			TMP3->Z9_ZCEP,+; // 8
			TMP3->Z9_ZLOJA,+; // 9 Campo utilizado apenas para atualiza o Z9_ALROAD
			TMP3->Z9_ZIDEND,+; // 10 Campo utilizado apenas para atualiza o Z9_ZIDEND
			TMP3->Z9_ZCLIENT }) // 11
			TMP3->(DbSkip())
		EndDo

		For nA := 1 To Len(aCliSZ9)
			aAdd(aCliFull,{aCliSZ9[nA,1],aCliSZ9[nA,2],aCliSZ9[nA,3],aCliSZ9[nA,4],aCliSZ9[nA,5],;
			aCliSZ9[nA,6],aCliSZ9[nA,7],aCliSZ9[nA,8],aCliSZ9[nA,11]})
		Next

		// Gera o arquivo TXT
		If Len(aCliFull) > 0
			cArqTxt := cRoadCli + dData + dHora + cUsuMGF + ".txt"
			cDados	 := MSFCreate( cArqTxt  )
		EndIf

		For nI := 1 to Len(aCliFull)
			cLista := PaDL(aCliFull[nI,01],15,"0")// Código RoadNet
			cLista += PaDL(aCliFull[nI,02],15,"0") // Codigo do Cliente
			cLista += Space(20) // Brancos
			cLista += PaDR(aCliFull[nI,03],60," ") // Nome Cliente
			cLista += PaDR(aCliFull[nI,04],50," ")  // Endereco
			cLista += Space(20) // Brancos
			cLista += PaDR(aCliFull[nI,05],30," ") // Bairro
			cLista += PaDR(aCliFull[nI,06],30," ") // Cidade
			cLista += PaDR(aCliFull[nI,07],02," ") // Estado
			cLista += PaDR(aCliFull[nI,08],10," ") // CEP
			cLista += Space(05) // Tipo de Cliente
			cLista += Space(44) // Brancos
			cLista += "23456SD" + ENTER // Dias da Semana
			FWrite (cDados,cLista)

		Next nI

		FClose (cDados)

		// Tabela SA1
		For nP := 1 To Len(aCliSA1)
			If lSimular = .F.	 .AND. Len(aCliSA1) > 0
				DbSelectArea("SA1")
				DbSetOrder(1) // A1_FILIAL+A1_COD+A1_LOJA
				DbGoTop()
				If SA1->(DbSeek(xFilial("SA1") + aCliSA1[nP,10] + aCliSA1[nP,9]))
					RecLock("SA1",.F.)
					SA1->A1_ZALTROA := "S"
					MsUnLock()
				EndIf
			EndIf
		Next

		// Tabela Clientes x Enderecos
		For nQ := 1 To Len(aCliSZ9)
			If lSimular = .F. .AND. Len(aCliSZ9) > 0
				DbSelectArea("SZ9")
				DbSetOrder(1) // Z9_FILIAL+Z9_ZCLIENT+Z9_ZLOJA+Z9_ZIDEND
				DbGoTop()
				If SZ9->(DbSeek(xFilial("SZ9") + aCliSZ9[nQ,11] + aCliSZ9[nQ,9] + aCliSZ9[nQ,10]))
					RecLock("SZ9",.F.)
					SZ9->Z9_ALROAD := "S"
					MsUnLock()
				EndIf
			EndIf
		Next

		ApMsgInfo(" ARQUIVO DE CLIENTES ";
		+ ENTER ;
		+ ENTER + " Foi gerado o arquivo de CLIENTES sem a referencia " ;
		+ ENTER + " dos Pedidos de Venda selecionados. ";
		+ ENTER ;
		+ ENTER + " Exportado todos os clientes com os critérios abaixo : ";
		+ ENTER + " 1 - Roteiriza igual a SIM ";
		+ ENTER + " 2 - Cod. de Roteirização diferente de VAZIO ";
		+ ENTER + " 3 - RoadNet Integrado igual a NAO ";
		+ ENTER ;
		+ ENTER + " Diretorio .......: " + cRoadCli ;
		+ ENTER + " Nome do arquivo..: " + dData + dHora + cUsuMGF + ".txt" )
	Else
		MSGALERT("Usuario Nao Autorizado !!","MARFRIG")
	EndIf

Return

// 07 - Gera arquivo de Clientes porem com base nos PV selecionados
Static Function GERACLIPD()

	Local aCliSA1  := {}
	Local aCliSZ9  := {}
	Local aCliFull := {}
	Local cDados	 := 0
	Local cLista 	 := ""
	Local dHora 	 := StrTran(Time(),":","")
	Local dData    := StrTran(DtoC(Date()),"/","")
	Local cUsuMGF  := cUserName
	Local cCliRoad := ""
	Local cLojRoad := ""
	Local aListBox2 := {}
	Local aListBox3 := {}
	Local lGera := .T.

	// Array sem repeticao de clientes com o mesmo Roteiro
	For nA := 1 To Len(aListBox1)
		If aListBox1[nA,1]
			If aScan( aListBox2, { |x| x[1] == aListBox1[nA,2] }) = 0 // Codigo do Cliente
				aAdd(aListBox2,{aListBox1[nA,2],aListBox1[nA,3],aListBox1[nA,5]})
			ElseIf aScan( aListBox2, { |x| x[2] == aListBox1[nA,3] }) = 0 // Loja do Cliente
				aAdd(aListBox2,{aListBox1[nA,2],aListBox1[nA,3],aListBox1[nA,5]})
			ElseIf aScan( aListBox2, { |x| x[3] == aListBox1[nA,5] }) = 0  // Codigo da Roteirização
				aAdd(aListBox2,{aListBox1[nA,2],aListBox1[nA,3],aListBox1[nA,5]})
			EndIf
		EndIf
	Next

	For nB := 1 To Len(aListBox2)
		If Empty(aListBox2[nB,3])
/*			cQuery := " SELECT A1_ZCROAD, A1_CGC, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_BAIRRO, A1_MUN,  " + ENTER
			cQuery += " A1_EST, A1_CEP, A1_PESSOA " + ENTER
			cQuery += " FROM "       + RetSqlName("SA1") + " SA1 " + ENTER
			cQuery += " WHERE SA1.A1_ZITROAD = 'S' " + ENTER // Roteiriza s/n
			cQuery += " AND SA1.A1_ZCROAD <> '' " + ENTER  // Codigo do Roteiro
			cQuery += " AND SA1.A1_ZALTROA = 'N' " + ENTER // Alterado s/n
			cQuery += " AND SA1.A1_COD = '"+ aListBox2[nB,1] + "' " + ENTER
			cQuery += " AND SA1.A1_LOJA = '"+ aListBox2[nB,2] + "' " + ENTER
			cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
			cQuery += " GROUP BY A1_ZCROAD, A1_CGC, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_PESSOA" + ENTER
			cQuery += " ORDER BY A1_ZCROAD "
*/
		    cQuery := " SELECT A1_ZCROAD, A1_CGC, A1_COD, A1_NOME, A1_LOJA, A1_END, A1_BAIRRO, A1_MUN,  " + ENTER
		    cQuery += " A1_EST, A1_CEP, A1_PESSOA " + ENTER
		    cQuery += " FROM "       + RetSqlName("SA1") + " SA1 " + ENTER
		    cQuery += " , " + RetSqlName("ZAP") + " ZAP" + ENTER
		    cQuery += " WHERE SA1.A1_EST||SA1.A1_COD_MUN = ZAP.ZAP_UF||ZAP.ZAP_CODMUN " + ENTER
		    cQuery += " AND SA1.A1_ZITROAD = 'S' " + ENTER // Roteiriza s/n
		    cQuery += " AND SA1.A1_ZCROAD <> ' ' " + ENTER  // Codigo do Roteiro
		    cQuery += " AND SA1.A1_ZALTROA <> 'S' " + ENTER // Alterado s/n
		    cQuery += " AND SA1.A1_TIPO <> 'X' " + ENTER // Exceto estrangeiros
		    cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
		    cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
		    If !empty(cCodReg)
		    	cQuery += " AND ZAP.ZAP_CODREG = '" + cCodReg +"'" + ENTER
		    EndIf
		    cQuery += " GROUP BY A1_ZCROAD, A1_CGC, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_PESSOA" + ENTER
		    cQuery += " ORDER BY A1_ZCROAD "

			If ( Select("TMP2") ) > 0
				DbSelectArea("TMP2")
				TMP2->(DbCloseArea())
			EndIf

			TCQUERY Changequery(cQuery) NEW ALIAS "TMP2"

			DbSelectArea("TMP2")
			DbGoTop()

			While TMP2->(!Eof())
				aAdd(aCliSA1, {TMP2->A1_ZCROAD,+; // 1
				IIf(TMP2->A1_PESSOA == 'J','0' + TMP2->A1_CGC,substr(TMP2->A1_CGC,1,9) + '0000'+ substr(TMP2->A1_CGC,10,2)),+; // 2 TMP2->A1_COD,+; // 2
				TMP2->A1_NOME,+; // 3
				TMP2->A1_END,+; // 4
				TMP2->A1_BAIRRO,+; // 5
				TMP2->A1_MUN,+; // 6
				TMP2->A1_EST,+; // 7
				TMP2->A1_CEP,+; // 8
				TMP2->A1_LOJA,+; // 9 Campo utilizado apenas para atualiza o A1_ZALTROA
				TMP2->A1_COD }) //10
				TMP2->(DbSkip())
			EndDo
		EndIf
	Next

	For nC:= 1 To Len(aCliSA1)
		aAdd(aCliFull,{aCliSA1[nC,1],aCliSA1[nC,2],aCliSA1[nC,3],aCliSA1[nC,4],aCliSA1[nC,5],;
		aCliSA1[nC,6],aCliSA1[nC,7],aCliSA1[nC,8],aCliSA1[nC,10]})
	Next

	// Apenas Tabela SZ9
	For nD := 1 To Len(aListBox2)
		If !Empty(aListBox2[nD,3])
/*			cQuery := " SELECT Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC, " + ENTER
			cQuery += " Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA " + ENTER
			cQuery += " FROM "       + RetSqlName("SZ9") + " SZ9 " + ENTER
			cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 " + ENTER
			cQuery += " ON SA1.A1_COD = SZ9.Z9_ZCLIENT " + ENTER
			cQuery += " AND SA1.A1_LOJA = SZ9.Z9_ZLOJA " + ENTER
			cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
			cQuery += " WHERE SZ9.Z9_ZROTEIR = 'S' " + ENTER // Roteiriza s/n
			cQuery += " AND SZ9.Z9_ZCROAD  = '"+aListBox2[nD,3]+"' " + ENTER  // Codigo do Roteiro
			cQuery += " AND SZ9.Z9_ALROAD = 'N' " + ENTER // Alterado s/n
			cQuery += " AND SZ9.D_E_L_E_T_ = ' ' " + ENTER
			cQuery += " GROUP BY Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC, Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA" + ENTER
			cQuery += " ORDER BY Z9_ZCROAD "
*/
    		cQuery := " SELECT Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC,  " + ENTER
    		cQuery += " Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA " + ENTER
    		cQuery += " FROM "       + RetSqlName("SZ9") + " SZ9 " + ENTER
    		cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 " + ENTER
    		cQuery += " ON SA1.A1_COD = SZ9.Z9_ZCLIENT " + ENTER
    		cQuery += " AND SA1.A1_LOJA = SZ9.Z9_ZLOJA " + ENTER
    		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " + ENTER
    		cQuery += " INNER JOIN " + RetSqlName("ZAP") + " ZAP" + ENTER
    		cQuery += " ON ZAP.ZAP_UF||ZAP.ZAP_CODMUN = SZ9.Z9_ZEST||SZ9.Z9_ZCODMUN " + ENTER
    		cQuery += " AND ZAP.D_E_L_E_T_ = ' ' " + ENTER
    		cQuery += " WHERE SZ9.Z9_ZROTEIR = 'S' " + ENTER // Roteiriza s/n
    		cQuery += " AND SZ9.Z9_ZCROAD  <> ' ' " + ENTER  // Codigo do Roteiro
    		cQuery += " AND SZ9.Z9_ALROAD <> 'S' " + ENTER // Alterado s/n
    		If !empty(cCodReg)
    			cQuery += " AND ZAP.ZAP_CODREG = '" + cCodReg +"'" + ENTER
    		EndIf
    		cQuery += " AND SZ9.D_E_L_E_T_ = ' ' " + ENTER
    		cQuery += " GROUP BY Z9_ZCROAD, A1_CGC, Z9_ZCLIENT, Z9_ZLOJA, A1_NOME, Z9_ZENDER, Z9_ZBAIRRO, Z9_ZMUNIC, Z9_ZEST, Z9_ZCEP, Z9_ZIDEND, A1_PESSOA" + ENTER
    		cQuery += " ORDER BY Z9_ZCROAD "

			If ( Select("TMP3") ) > 0
				DbSelectArea("TMP3")
				TMP3->(DbCloseArea())
			EndIf

			TCQUERY Changequery(cQuery) NEW ALIAS "TMP3"

			DbSelectArea("TMP3")
			DbGoTop()

			While TMP3->(!Eof())
				aAdd(aCliSZ9, {TMP3->Z9_ZCROAD,+; // 1
				IIf(TMP3->A1_PESSOA == 'J','0' + TMP3->A1_CGC,substr(TMP3->A1_CGC,1,9) + '0000'+ substr(TMP3->A1_CGC,10,2)),+; // 2 TMP3->Z9_ZCLIENT,+; // 2
				TMP3->A1_NOME,+; // 3
				TMP3->Z9_ZENDER,+; // 4
				TMP3->Z9_ZBAIRRO,+; // 5
				TMP3->Z9_ZMUNIC,+; // 6
				TMP3->Z9_ZEST,+; // 7
				TMP3->Z9_ZCEP,+; // 8
				TMP3->Z9_ZLOJA,+; // 9 Campo utilizado apenas para atualiza o Z9_ZALROA
				TMP3->Z9_ZIDEND,+; // 10 Campo utilizado apenas para atualiza o Z9_ZIDEND
				TMP3->Z9_ZCLIENT }) //11
				TMP3->(DbSkip())
			EndDo
		EndIf
	Next

	For nE := 1 To Len(aCliSZ9)
		aAdd(aCliFull,{aCliSZ9[nE,1],aCliSZ9[nE,2],aCliSZ9[nE,3],aCliSZ9[nE,4],aCliSZ9[nE,5],;
		aCliSZ9[nE,6],aCliSZ9[nE,7],aCliSZ9[nE,8],aCliSZ9[nE,11]})
	Next

	// Gera o arquivo TXT
	If Len(aCliFull) > 0
		cArqTxt := cRoadCli + dData + dHora + cUsuMGF + ".txt"
		cDados	 := MSFCreate( cArqTxt  )
	EndIf

	// Nome apenas para a mensagem
	cNomCli := dData + dHora + cUsuMGF + ".txt"

	For nI := 1 to Len(aCliFull)
		cLista := PaDL(aCliFull[nI,01],15,"0")// Código RoadNet
		cLista += PaDL(aCliFull[nI,02],15,"0") // Codigo do Cliente
		cLista += Space(20) // Brancos
		cLista += PaDR(aCliFull[nI,03],60," ") // Nome Cliente
		cLista += PaDR(aCliFull[nI,04],50," ")  // Endereco
		cLista += Space(20) // Brancos
		cLista += PaDR(aCliFull[nI,05],30," ") // Bairro
		cLista += PaDR(aCliFull[nI,06],30," ") // Cidade
		cLista += PaDR(aCliFull[nI,07],02," ") // Estado
		cLista += PaDR(aCliFull[nI,08],10," ") // CEP
		cLista += Space(5) // Tipo de Cliente
		cLista += Space(44) // Brancos
		cLista += "23456SD" + ENTER // Dias da Semana
		FWrite (cDados,cLista)
	Next nI

	FClose (cDados)

	// Tabela SA1
	For nP := 1 To Len(aCliSA1)
		If lSimular = .F.	 .AND. Len(aCliSA1) > 0
			DbSelectArea("SA1")
			DbSetOrder(1) // A1_FILIAL+A1_COD+A1_LOJA
			DbGoTop()
			If SA1->(DbSeek(xFilial("SA1") + aCliSA1[nP,10] + aCliSA1[nP,9]))
				RecLock("SA1",.F.)
				SA1->A1_ZALTROA := "S"
				MsUnLock()
			EndIf
		EndIf
	Next

	// Tabela Clientes x Enderecos
	For nQ := 1 To Len(aCliSZ9)
		If lSimular = .F. .AND. Len(aCliSZ9) > 0
			DbSelectArea("SZ9")
			DbSetOrder(1) // Z9_FILIAL+Z9_ZCLIENT+Z9_ZLOJA+Z9_ZIDEND
			DbGoTop()
			If SZ9->(DbSeek(xFilial("SZ9") + aCliSZ9[nQ,11] + aCliSZ9[nQ,9] + aCliSZ9[nQ,10]))
				RecLock("SZ9",.F.)
				SZ9->Z9_ALROAD := "S"
				MsUnLock()
			EndIf
		EndIf
	Next

Return

// 08 - Desmarca todos os registros
Static Function DESMBOX01()

	For nM := 1 To Len(aListBox1)
		If aListBox1[nM,1]
			aListBox1[nM,1] := .F.
		EndIf
	Next

Return

// 09 - Marca todos os registros
Static Function MARCBOX01()

	For nM := 1 To Len(aListBox1)
		If aListBox1[nM,1] == .F.
			aListBox1[nM,1] := .T.
		EndIf
	Next

Return

// 10 - Cadastro de Regiões
//User Function MGFSZP()
//
//Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
//Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
//
//Private cString := "SZP"
//
//dbSelectArea("SZP")
//dbSetOrder(1)
//
//AxCadastro(cString,"Cadastro de . . .",cVldExc,cVldAlt)
//
//Return

//----------------------------------------------------------------------
// Se for Pedido do E-Commerce com Cartão de Crédito verifica se cartão ainda está válido
//----------------------------------------------------------------------
static function chkOrderEc( cIDEcom )
	local cQryXC5		:= ""
	local lRetXC5		:= .T.
	local cAccessTok	:= ""
	local cCard			:= nil
	local oCard			:= nil

	local cUpdSC5		:= ""
	local aArea			:= getArea()
	local aAreaSZV		:= SZV->( getArea() )
	local aAreaSC5		:= SC5->( getArea() )

	cQryXC5 := "SELECT XC5_FILIAL, XC5_PVPROT, XC5_IDECOM, XC5_IDPROF, XC5_NSU"				+ CRLF
	cQryXC5 += " FROM " + retSQLName("XC5") + " XC5"					+ CRLF
	cQryXC5 += " WHERE"													+ CRLF
	cQryXC5 += " 		XC5.XC5_NSU		<>	' '"						+ CRLF
	cQryXC5 += " 	AND	XC5.XC5_IDECOM	=	'" + cIDEcom		+ "'"	+ CRLF
	cQryXC5 += " 	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5")	+ "'"	+ CRLF
	cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryXC5 New Alias "QRYXC5"

	if !QRYXC5->(EOF())

		cAccessTok := u_authGtnt()

		if !empty( cAccessTok )
			cCard := u_recoCard( cAccessTok, QRYXC5->XC5_IDPROF )

			if fwJsonDeserialize( cCard, @oCard )
				//chkCard( cAccessTok, cCardName, cExpiMonth, cExpiYear, cNumberTok )
				if u_chkCard( cAccessTok, oCard:CARDHOLDER_NAME, oCard:EXPIRATION_MONTH, oCard:EXPIRATION_YEAR, oCard:NUMBER_TOKEN )
					lRetXC5 := .T.
				else
					cUpdZE6	:= ""

					cUpdZE6 := "UPDATE " + retSQLName("ZE6")											+ CRLF
					cUpdZE6 += "	SET"																+ CRLF
					cUpdZE6 += " 		ZE6_STATUS	=	'3',"											+ CRLF
					cUpdZE6 += " 		ZE6_OBS		=	'Cartão não verificado. Pedido Bloqueado.'"		+ CRLF
					cUpdZE6 += " WHERE"																	+ CRLF
					cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( QRYXC5->XC5_NSU )	+ "'"				+ CRLF

					if tcSQLExec( cUpdZE6 ) < 0
						conout(" [MGFINT11] [ZE6] Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

					conout(" [MGFINT11] Cartão não verificado. Pedido Bloqueado.")

					lRetXC5 := .F.

					cUpdSC5	:= ""

					cUpdSC5 := "UPDATE " + retSQLName("SC5")							+ CRLF
					cUpdSC5 += "	SET"												+ CRLF
					cUpdSC5 += " 		C5_ZBLQRGA = 'B'"								+ CRLF
					cUpdSC5 += " WHERE"													+ CRLF
					cUpdSC5 += " 		C5_NUM		=	'" + QRYXC5->XC5_PVPROT	+ "'"	+ CRLF
					cUpdSC5 += " 	AND	C5_FILIAL	=	'" + QRYXC5->XC5_FILIAL	+ "'"	+ CRLF
					cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

					if tcSQLExec( cUpdSC5 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

					DBSelectArea( 'SZV' )
					SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
					if !SZV->( DBSeek( xFilial('SZV') + QRYXC5->XC5_PVPROT + "01" + "999999" ) )
						recLock("SZV", .T.)
							SZV->ZV_FILIAL	:= xFilial("SZV")
							SZV->ZV_PEDIDO	:= QRYXC5->XC5_PVPROT
							SZV->ZV_ITEMPED	:= "01"
							SZV->ZV_CODRGA	:= "999999"
							SZV->ZV_CODRJC	:= "000000"
							SZV->ZV_DTRJC	:= dDataBase
							SZV->ZV_HRRJC	:= left( time() , 5 )
						SZV->(msUnlock())
					endif
				endif
			endif
		endif

	endif

	QRYXC5->(DBCloseArea())

	restArea( aArea )
	restArea( aAreaSZV )
	restArea( aAreaSC5 )
return lRetXC5

//-----------------------------------------------------------------
// Atualiza XC5 para Tracking do E-Commerce
//-----------------------------------------------------------------
static function ecomXC5( cFilPed, cPedidoXC5 )
	local cUpdXC5 := ""

	cUpdXC5 := "UPDATE " + retSQLName("XC5")
	cUpdXC5 += " SET "
	cUpdXC5 += "	XC5_INTEGR = 'P'"
	cUpdXC5 += " WHERE"
	cUpdXC5 += "		XC5_FILIAL	=	'" + cFilPed	+ "'"
	cUpdXC5 += "	AND	XC5_PVPROT	=	'" + cPedidoXC5	+ "'"
	cUpdXC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec( cUpdXC5 )
return