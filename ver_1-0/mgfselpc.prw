#INCLUDE "protheus.ch"
/*
=====================================================================================
Programa............: MGFSELPC
Autor...............: Roberto Sidney / Alterado por Barbieri
Data................: 23/09/2016 / 20/12/2016
Descricao / Objetivo: Markbrose com tabela temporária para seleção dos pedidos de compra 
que serão enviados aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MGFSELPC()
	Local _astru:={}
	Local aCampos:={}
	Local _carq
	Local oMark
	Private arotina := {}
	Private cCadastro
	Private cMark:=GetMark()
	Private aStru := {}
	aRotina   := {{ "Marcar Todos" ,"U_MarkAll" , 0, 1},;
	{ "Desmarcar Todos" ,"U_DesmakAll" , 0, 2},;
	{ "Envia WF" ,"U_EnvWFPC" , 0, 3},;
	{ "Inverter Todos" ,"U_InvertMark" , 0, 4},;
	{ "Re-envia WF" ,"U_ReeWFPC" , 0, 5},;
	{ "Filtra" ,"U_filCOM01()" , 0, 2}}
	cCadastro := "Pedido de Compras - Workflow Fornecedores"

	// Cria tabela temporária
	Cria_TRB()

	U_filCOM01()

	// Alimenta tabela temporária
	//Monta_TRB()
	//fwMsgRun(, {|| Monta_TRB() }, "Selecionando dados", "Aguarde. Selecionando dados..." )

	aCores := {}
	AADD(aCores,{"RB_XWFENV == 'Sim'" ,"BR_VERDE" })
	AADD(aCores,{"RB_XWFENV == 'Não'" ,"BR_VERMELHO" })

	AADD(aCampos,{"RB_OK","","#"})
	AADD(aCampos,{"RB_XWFENV","","WF Enviado?"})
	AADD(aCampos,{"RB_FORNECE","","Fornecedor"})
	AADD(aCampos,{"RB_LOJA","","Loja"})
	AADD(aCampos,{"RB_NREDUZ","","Nome Fornecedor"})
	AADD(aCampos,{"RB_CONTATO","","Contato"})
	AADD(aCampos,{"RB_PEDIDO","","Pedido"})
	
	AADD(aCampos,{"RB_CODCOM","","Cod Comprador"})
	AADD(aCampos,{"RB_NOMCOM","","Nome Comprador"})

	AADD(aCampos,{"RB_EMISSAO","@E9","Emissao"})
	/*	AADD(aCampos,{"RB_COND","","Cond. Pgto"})
	AADD(aCampos,{"RB_ITEM","","Item"})
	AADD(aCampos,{"RB_PRODUTO","","PRODUTO"})
	AADD(aCampos,{"RB_DESC","","Descrição"})
	AADD(aCampos,{"RB_UM","","Un"})
	AADD(aCampos,{"RB_QTDE","","Qtde"})
	AADD(aCampos,{"RB_UNIT","","Unitario"})*/
	AADD(aCampos,{"RB_TOTAL","","Total","@E 999,999,999.99"})
	/*	AADD(aCampos,{"RB_DTPRV","","Dt.Prev"})
	AADD(aCampos,{"RB_ALMOX","","Alm"})
	AADD(aCampos,{"RB_ALMOX","","Observação"})
	AADD(aCampos,{"RB_CCUSTO","","C.Custo"})*/

	DbSelectArea("TRB")
	DbGotop()
	MarkBrow('TRB','RB_OK',,aCampos,, cMark,'u_MarkAll()',,,,'u_Marcar()',{|| u_MarkAll()},,,aCores,,,,.F.)
Return

/*
=====================================================================================
Programa............: MarkAll
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: função auxiliar a Markbrowse para seleção de todos os registres
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MarkAll()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
		if TRB->RB_XWFENV <> 'S'
			RecLock( 'TRB', .F. )
			TRB->RB_OK := cMark
			MsUnLock()
		Endif
		TRB->(DbSkip())
	Enddo
	MarkBRefresh()
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
return

/*
=====================================================================================
Programa............: DesmakAll
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: função auxiliar a Markbrowse para cancelar seleção de todos os registros
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function DesmakAll()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
		if TRB->RB_XWFENV <> 'S'
			RecLock( 'TRB', .F. )
			TRB->RB_OK := SPACE(2)
			MsUnLock()
		Endif
		TRB->(DbSkip())
	Enddo
	MarkBRefresh( )
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
Return

/*
=====================================================================================
Programa............: InvertMark
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: função auxiliar a Markbrowse para inverter seleção de registros
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function InvertMark()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
		if TRB->RB_XWFENV <> 'S'
			RecLock( 'TRB', .F. )
			TRB->RB_OK := iif(! Empty(alltrim(TRB->RB_OK)),Space(2),cMark)
			MsUnlock()
		Endif
		TRB->(DbSkip())
	Enddo

	MarkBRefresh()
Return

/*
=====================================================================================
Programa............: Marcar
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: função auxiliar a Markbrowse para marcar e desmarcar unico registro
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function Marcar()

	if TRB->RB_XWFENV <> 'S'
		RecLock( 'TRB', .F. )
		TRB->RB_OK := iif(! Empty(alltrim(TRB->RB_OK)),Space(2),cMark)
		MsUnLock()
	Endif
	MarkBRefresh()
Return

/*
=====================================================================================
Programa............: Cria_TRB
Autor...............: Roberto Sidney / Alterado por Barbieri
Data................: 23/09/2016 / 20/12/2016
Descricao / Objetivo: Criação da tabela temporária - TRB
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static FUNCTION Cria_TRB()

	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif

	aStru := {}
	AADD(aStru,{"RB_OK"     ,"C",02,0})
	AADD(aStru,{"RB_XWFENV" ,"C",03,0})
	AADD(aStru,{"RB_FORNECE","C",06,0})
	AADD(aStru,{"RB_LOJA"   ,"C",02,0})
	AADD(aStru,{"RB_NREDUZ"  ,"C",20,0})
	AADD(aStru,{"RB_CONTATO" ,"C",15,0})
	AADD(aStru,{"RB_PEDIDO"  ,"C",06,0})

	AADD(aStru,{"RB_CODCOM"	,"C",3	,0})
	AADD(aStru,{"RB_NOMCOM"	,"C",30	,0})

	AADD(aStru,{"RB_EMISSAO" ,"D",08,0})
	/*	AADD(aStru,{"RB_COND"    ,"C",03,0})
	AADD(aStru,{"RB_ITEM"   ,"C",04,0})
	AADD(aStru,{"RB_PRODUTO","C",15,0})
	AADD(aStru,{"RB_DESC"   ,"C",40,0})
	AADD(aStru,{"RB_UM"     ,"C",02,0})
	AADD(aStru,{"RB_QTDE"   ,"N",6,0})
	AADD(aStru,{"RB_UNIT"   ,"N",12,2})*/
	AADD(aStru,{"RB_TOTAL"  ,"N",14,2}) 
	/*	AADD(aStru,{"RB_DTPRV"  ,"D",08,0})
	AADD(aStru,{"RB_ALMOX"  ,"C",02,0})
	AADD(aStru,{"RB_OBSERV" ,"C",30,0})
	AADD(aStru,{"RB_CCUSTO" ,"C",06,0})
	AADD(aStru,{"RB_REG" ,"N",10,0})*/
	cArq:=Criatrab(aStru,.T.)
	DBUSEAREA(.t.,,cArq,"TRB")

Return

/*
=====================================================================================
Programa............: Monta_TRB
Autor...............: Roberto Sidney / Alterado por Barbieri
Data................: 23/09/2016 / 20/12/2016
Descricao / Objetivo: Alimenta data da tabela temporária
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

Static Function Monta_TRB()
	Local nX	:= 0

	/*	cQuery := ""
	cQuery += " SELECT  C7_XWFENV RB_XWFENV,"
	cQuery += " 		C7_FORNECE RB_FORNECE, "
	cQuery += " 		C7_LOJA RB_LOJA,     "
	cQuery += " 		C7_NUM RB_PEDIDO,     "
	cQuery += " 		C7_ITEM RB_ITEM,    "
	cQuery += " 		C7_EMISSAO RB_EMISSAO,"
	cQuery += " 		C7_CONTATO RB_CONTATO,"
	cQuery += " 		C7_COND RB_COND,    "
	cQuery += " 	    C7_PRODUTO RB_PRODUTO,"
	cQuery += " 		B1_DESC RB_DESC,    "
	cQuery += " 		B1_UM RB_UM,		"
	cQuery += " 		C7_QUANT RB_QTDE,   "
	cQuery += " 		C7_PRECO RB_UNIT,   "
	cQuery += " 		C7_TOTAL RB_TOTAL,   "
	cQuery += " 		C7_DATPRF RB_DTPRV,  "
	cQuery += " 		C7_LOCAL RB_ALMOX, "
	cQuery += " 		C7_OBS RB_OBSERV, "
	cQuery += " 		C7_CC RB_CCUSTO, "
	cQuery += " 		SC7.R_E_C_N_O_ RB_REG "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND C7_QUANT > C7_QUJE  "
	cQuery += " AND C7_RESIDUO = ' '  "
	cQuery += " AND C7_CONAPRO <> 'B'  "
	cQuery += " AND C7_ENCER = ' ' "
	cQuery += " AND C7_QTDACLA = 0 "
	cQuery += " AND C7_PRODUTO = B1_COD "
	cQuery += " GROUP BY C7_XWFENV, C7_FORNECE, C7_LOJA, C7_NUM, C7_EMISSAO, C7_CONTATO "
	cQuery += " ORDER BY C7_NUM "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
	TcSetField("CAD","RB_EMISSAO","D",8,0)
	TcSetField("CAD","RB_DTPRV","D",8,0)

	cQuery := ""
	cQuery += " SELECT DISTINCT C7_XWFENV RB_XWFENV,"
	cQuery += " 		C7_FORNECE RB_FORNECE, "
	cQuery += " 		C7_LOJA RB_LOJA,     "
	cQuery += " 		C7_NUM RB_PEDIDO,     "
	cQuery += " 		C7_EMISSAO RB_EMISSAO,"
	cQuery += " 		C7_CONTATO RB_CONTATO,"
	cQuery += " 		SUM(C7_TOTAL) RB_TOTAL, C1_CODCOMP RB_CODCOM"
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "

	if !empty(MV_PAR03) .OR. !empty(MV_PAR04)
		cQuery += " INNER JOIN " + RetSqlName("SC1") + " SC1"
	else
		cQuery += " LEFT JOIN " + RetSqlName("SC1") + " SC1"
	endif

	cQuery += " ON"
	cQuery += "			SC1.C1_NUM		=	SC7.C7_NUMSC"
	cQuery += "		AND	SC1.C1_ITEM		=	SC7.C7_ITEMSC"

	if !empty(MV_PAR03)
		cQuery += " AND C1_CODCOMP >= '" + MV_PAR03 + "'"
	endif

	if !empty(MV_PAR04)
		cQuery += " AND C1_CODCOMP <= '" + MV_PAR04 + "'"
	endif

	cQuery += "		AND	SC1.C1_FILIAL	=	'" + xFilial("SC1") + "'"
	cQuery += "		AND	SC1.D_E_L_E_T_	<>	'*'"

	cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " AND C7_QUANT > C7_QUJE  "
	cQuery += " AND C7_RESIDUO = ' '  "
	cQuery += " AND C7_CONAPRO <> 'B'  "
	cQuery += " AND C7_ENCER = ' ' "
	cQuery += " AND C7_QTDACLA = 0 "

	if !empty(MV_PAR01)
		cQuery += " AND C7_NUM >= '" + MV_PAR01 + "'"
	endif

	if !empty(MV_PAR02)
		cQuery += " AND C7_NUM <= '" + MV_PAR02 + "'"
	endif*/

	cQuery := ""
	cQuery += " SELECT DISTINCT C7_XWFENV RB_XWFENV,"
	cQuery += " 		C7_FORNECE RB_FORNECE, "
	cQuery += " 		C7_LOJA RB_LOJA,     "
	cQuery += " 		C7_NUM RB_PEDIDO,     "
	cQuery += " 		C7_EMISSAO RB_EMISSAO,"
	cQuery += " 		C7_CONTATO RB_CONTATO,"
	cQuery += " 		SUM(C7_TOTAL) RB_TOTAL, C7_COMPRA RB_CODCOM"
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "

	if !empty(MV_PAR03) .AND. !empty(MV_PAR04)
		cQuery += " AND C7_COMPRA >= '" + MV_PAR03 + "'"
		cQuery += " AND C7_COMPRA <= '" + MV_PAR04 + "'"
	endif
	
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " AND C7_QUANT > C7_QUJE  "
	cQuery += " AND C7_RESIDUO = ' '  "
	cQuery += " AND C7_CONAPRO <> 'B'  "
	cQuery += " AND C7_ENCER = ' ' "
	cQuery += " AND C7_QTDACLA = 0 "

	If !empty(MV_PAR01) .AND. !empty(MV_PAR02)
		cQuery += " AND C7_NUM >= '" + MV_PAR01 + "'"
		cQuery += " AND C7_NUM <= '" + MV_PAR02 + "'"
	Endif


	cQuery += " GROUP BY C7_XWFENV, C7_FORNECE, C7_LOJA, C7_NUM, C7_EMISSAO, C7_CONTATO, C7_COMPRA "
	cQuery += " ORDER BY C7_NUM "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
	TcSetField("CAD","RB_EMISSAO","D",8,0)
	Dbselectarea("CAD")

	While CAD->(!EOF())
		RecLock("TRB",.T.)
		For nX := 1 To Len(aStru)
			If !(aStru[nX,1] $ 'RB_OK/RB_NREDUZ/RB_NOMCOM')
				If aStru[nX,2] = 'C'
					_cX := 'TRB->'+aStru[nX,1]+' := Alltrim(CAD->'+aStru[nX,1]+')'
				Else
					_cX := 'TRB->'+aStru[nX,1]+' := CAD->'+aStru[nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		TRB->RB_XWFENV := IIF(alltrim(TRB->RB_XWFENV) $ "N" .or. empty(TRB->RB_XWFENV),'Não','Sim')
		TRB->RB_NREDUZ := Posicione("SA2",1,xFilial("SA2")+TRB->RB_FORNECE+TRB->RB_LOJA,"A2_NREDUZ" )

		if !empty( CAD->RB_CODCOM )
			TRB->RB_NOMCOM	:= GetAdvFVal("SY1","Y1_NOME", xFilial("SY1") + CAD->RB_CODCOM, 1, "")
		endif

		MsUnLock()

		DbSelectArea('CAD')
		CAD->(dBSkip())
	EndDo

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TRB")
	DbGoTop()

	_cIndex:=Criatrab(Nil,.F.)
	_cChave:="RB_PEDIDO"
	Indregua("TRB",_cIndex,_cChave,,,"Ordenando registros selecionados...")
	DbSetIndex(_cIndex+ordbagext())
	SysRefresh()
Return

/*
=====================================================================================
Programa............: EnvWFPC
Autor...............: Roberto Sidney / Alterado por Barbieri
Data................: 23/09/2016 / 20/12/2016
Descricao / Objetivo: Envio de WorkFlow dos pedidos selecionados
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function EnvWFPC()
	Local _nWFCP := 0
	Local _cIdxFornPed := ''
	Local _cProxIdxFornPed := ''  
	Local aPedsWF := {}

	if MsgYesNo("Deseja enviar o Workflow de Pedido de Compras?")
		Private _cAreaTRB := TRB->(GetArea())
		DbSelectArea("TRB")
		TRB->(DbGotop())

		WHILE !TRB->(Eof())
			IncProc()
			IF TRB->RB_OK  <> cMark
				TRB->(dbSkip(1)) 
				Loop
			ENDIF

			//aadd(aPedsWF,{TRB->RB_FORNECE,TRB->RB_LOJA,TRB->RB_PEDIDO,TRB->RB_ITEM})
			aadd(aPedsWF,{TRB->RB_FORNECE,TRB->RB_LOJA,TRB->RB_PEDIDO})

			TRB->(dbSkip(1))
		ENDDO

		// Envio de WF
		For _nWFCP := 1 to len(aPedsWF)
			_cFornece := aPedsWF[_nWFCP,1]
			_cLoja    := aPedsWF[_nWFCP,2]
			_cPedCom  := aPedsWF[_nWFCP,3]
			_cIdxFornPed := _cFornece
			_cIdxFornPed += _cLoja
			_cIdxFornPed += _cPedCom
			// Envio do worlflow de entrada do pedido de compras
			If _cIdxFornPed != _cProxIdxFornPed
				U_MGFWFPC(_cFornece,_cLoja,_cPedCom)
				RestArea(_cAreaTRB)
				DbSelectArea("TRB")
			Endif
			_cProxIdxFornPed := _cIdxFornPed
		Next

		// Atualiza flag da tabela de trabalho - Tela
		WHILE !TRB->(Eof())
			IF TRB->RB_OK  <> cMark
				TRB->(dbSkip(1))
				Loop
			Else
				Reclock("TRB",.F.)
				TRB->RB_XWFENV := 'Sim'
				TRB->RB_OK := Space(2)           
				MsUnlock()
			Endif
			TRB->(dbSkip(1))
		ENDDO
	Else
		alert("Workflow cancelado")
	Endif
Return(.T.)

/*
=====================================================================================
Programa............: ReeWFPC
Autor...............: Barbieri
Data................: 20/12/2016
Descricao / Objetivo: Re-Envio de WorkFlow dos pedidos posicionados
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function ReeWFPC()
	local aArea := GetArea()
	If MsgYesNo("Deseja re-enviar o Workflow?") .and. TRB->RB_XWFENV == 'Sim' 
		DbSelectArea("TRB")
		U_MGFWFPC(TRB->RB_FORNECE,TRB->RB_LOJA,TRB->RB_PEDIDO)
	Elseif TRB->RB_XWFENV <> 'Sim'
		alert("Workflow ainda não foi enviado!")
	Else
		alert("Re-envio de Workflow cancelado!")
	Endif
	RestArea(aArea)
Return(.T.)

//-------------------------------------------------
//-------------------------------------------------
user function filCOM01()
	local aRet		:= {}
	local aParambox	:= {}

	aadd(aParamBox, {1, "Pedido de"		, space(TamSx3("C7_NUM")[1])		, 		, , "SC7" ,	, 070	, .F.})
	aadd(aParamBox, {1, "Pedido até"	, space(TamSx3("C7_NUM")[1])		, 		, , "SC7" ,	, 070	, .F.})
	aadd(aParamBox, {1, "Comprador de"	, space(TamSx3("C7_COMPRA")[1])	, 		, , "SY1" ,	, 070	, .F.})
	aadd(aParamBox, {1, "Comprador até"	, space(TamSx3("C7_COMPRA")[1])	, 		, , "SY1" ,	, 070	, .F.})

	if paramBox(aParambox, "Filtro WF"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		TRB->(DBGoTop())
		while !TRB->(EOF())
			TRB->(RecLock("TRB",.F.))
				TRB->(DBDelete())
			TRB->(MsUnLock())
			TRB->(DBSkip())
		enddo
		//TRB->(__dBPack())
		
		fwMsgRun(, {|| Monta_TRB() }, "Selecionando dados", "Aguarde. Selecionando dados..." )
		
	endif
return