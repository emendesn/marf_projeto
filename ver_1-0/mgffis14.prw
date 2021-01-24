#INCLUDE "MSMGADD.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "TOPCONN.CH

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

/*
=====================================================================================
Programa.:              MGFFIS14
Autor....:              Barbieri        
Data.....:              01/2017                                                                                                            
Descricao / Objetivo:   Regime especial de armazém                        
Doc. Origem:            Contrato - GAP FIS47
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Controle de mercadoria/transferencia entre filiais
=====================================================================================
*/

User Function MGFFIS14()

	Local aCores := {}
	Local cAlias := "ZAG"

	Private nLimDias := GETNEWPAR("MGF_LIDIAS",20)

	Private cCadastro := "Regime especial de armazém"
	Private aRotina := {}

	AADD(aRotina,{"Pesquisar","u_APESQZAG()",0,1})
	AADD(aRotina,{"Visualiza","AxVisual"	,0,2})
	AADD(aRotina,{"Consultar NF","u_CNZAGZAL()",0,7})
	AADD(aRotina,{"Incluir NF","AxInclui",0,3})
	AADD(aRotina,{"Relaciona Destino","u_RELNFDES()",0,4})
	AADD(aRotina,{"Excluir Dados NF","u_DLZAGZAL()",0,5})
	AADD(aRotina,{"Legenda" ,"U_BLegenda" ,0,6})

	AADD(aCores,{"ZAG_NFTRAN == 'N' .And. Month(ZAG_DTENT)==Month(dDataBase) .And. dDataBase-ZAG_DTENT <= nLimDias" ,"BR_VERDE" })
	AADD(aCores,{"ZAG_NFTRAN == 'S'" ,"BR_AZUL" })
	AADD(aCores,{"ZAG_NFTRAN == 'N' .And. ( Month(ZAG_DTENT)<>Month(dDataBase) .Or. dDataBase-ZAG_DTENT > nLimDias)" ,"BR_VERMELHO" })

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(6,1,22,75,cAlias,,,,,,aCores)

Return Nil

/*
========================================================
Relaciona CTRC e empresa destino
========================================================
*/
User Function RELNFDES()
	Local oNFNtrans  := LoadBitmap(GetResources(),'br_verde')
	Local oNFTrans   := LoadBitmap(GetResources(),'br_vermelho')
	Local oConfirmar
	Local oCancelar
	Local dDatEmiss := dDataBase
	Local dDatSai := dDataBase
	Local oCnpjEmpD
	Local cCnpjEmpD := Space(Len(RetField('SM0',1,cCodEmpZag+cFilAnt,'M0_CGC')))
	Local oCTRC
	Local cCTRC := Space(9)
	Local oEmpDest
	Local cEmpDest := Space(Len(cFilAnt))
	Local oFontNeg := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	Local oGroup1
	Local oGroup2
	Local oIeEmpDes
	Local cIeEmpDes := Space(Len(RetField('SM0',1,cCodEmpZag+cFilAnt,'M0_INSC')))
	Local oRazEmpD
	Local cRazEmpD := Space(Len(RetField('SM0',1,cCodEmpZag+cFilAnt,'M0_NOMECOM')))
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSerieCtrc
	Local cSerieCtrc := Space(3)
	Local oUfEmpDes
	Local cUfEmpDes := Space(Len(RetField('SM0',1,cCodEmpZag+cFilAnt,'M0_ESTENT')))
	Static oDlg
	Static cCodEmpZag := FWCodEmp()

	DEFINE MSDIALOG oDlg TITLE "Relaciona NF/CTRC Destino" FROM 000, 000  TO 230, 800 COLORS 0, 16777215 PIXEL

	@ 003, 003 GROUP oGroup1 TO 060, 396 PROMPT "Empresa Destino" OF oDlg COLOR CLR_BLUE, 16777215 PIXEL
	oGroup1:oFont := oFontNeg
	@ 012, 006 SAY oSay1 PROMPT "Código Empresa" SIZE 042, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 012, 059 SAY oSay3 PROMPT "Razão Social Empresa" SIZE 058, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 012, 247 SAY oSay2 PROMPT "I.E. Empresa Destino" SIZE 058, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 012, 320 SAY oSay4 PROMPT "CNPJ Empresa Destino" SIZE 058, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 021, 006 MSGET oEmpDest  VAR cEmpDest SIZE 037, 010 OF oDlg PICTURE "@!" VALID VlEmpDes(cEmpDest,@cRazEmpD,@cIeEmpDes,@cCnpjEmpD,@cUfEmpDes) COLORS 0, 16777215 F3 "SM0" PIXEL
	@ 021, 059 MSGET oRazEmpD  VAR cRazEmpD SIZE 180, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 READONLY PIXEL
	@ 021, 247 MSGET oIeEmpDes VAR cIeEmpDes SIZE 066, 010 OF oDlg PICTURE "@E 999999999999999999" COLORS 0, 16777215 READONLY PIXEL
	@ 021, 320 MSGET oCnpjEmpD VAR cCnpjEmpD SIZE 066, 010 OF oDlg PICTURE "@R 99.999.999/9999-99" COLORS 0, 16777215 READONLY PIXEL
	@ 060, 003 GROUP oGroup2 TO 094, 396 PROMPT "CTRC Destino" OF oDlg COLOR CLR_BLUE, 16777215 PIXEL
	oGroup2:oFont := oFontNeg
	@ 036, 006 SAY oSay5 PROMPT "UF Empresa" SIZE 038, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 036, 059 SAY oSay6 PROMPT "Data de Saída" SIZE 046, 011 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 006 SAY oSay7 PROMPT "Nro CTRC " SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 059 SAY oSay8 PROMPT "Data Emissão" SIZE 037, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 121 SAY oSay9 PROMPT "Série CTRC" SIZE 033, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 045, 006 MSGET oUfEmpDes VAR cUfEmpDes SIZE 023, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 045, 059 MSGET dDatSai SIZE 050, 010 OF oDlg VALID !Empty(dDatSai) COLORS 0, 16777215 PIXEL
	@ 079, 006 MSGET oCTRC VAR cCTRC SIZE 037, 010 OF oDlg VALID VldObrig(cCTRC) COLORS 0, 16777215 PIXEL
	@ 079, 059 MSGET dDatEmiss SIZE 050, 010 OF oDlg VALID !Empty(dDatEmiss) COLORS 0, 16777215 PIXEL
	@ 079, 121 MSGET oSerieCtrc VAR cSerieCtrc SIZE 037, 010 OF oDlg VALID VldObrig(cSerieCtrc) COLORS 0, 16777215 PIXEL
	@ 097, 340 BUTTON oConfirmar PROMPT "OK" Action(IIF(GRVZAL(cEmpDest,cRazEmpD,cIeEmpDes,cCnpjEmpD,dDatEmiss,dDatSai,cUfEmpDes,cCTRC,cSerieCtrc,cRazEmpD,cIeEmpDes,cCnpjEmpD),oDlg:End(),)) SIZE 055, 014 OF oDlg PIXEL
	@ 097, 280 BUTTON oCancelar PROMPT "Cancelar" ACTION(oDlg:End()) SIZE 055, 014 OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
========================================================
Valida campos de empresa do msGET
========================================================
*/
Static Function VlEmpDes(xEmpDest,xRazEmpD,xIeEmpDes,xCnpjEmpD,xUfEmpDes)

	xRazEmpD  := RetField('SM0',1,cCodEmpZag+xEmpDest,'M0_NOMECOM')
	xIeEmpDes := RetField('SM0',1,cCodEmpZag+xEmpDest,'M0_INSC')
	xCnpjEmpD := RetField('SM0',1,cCodEmpZag+xEmpDest,'M0_CGC')
	xUfEmpDes := RetField('SM0',1,cCodEmpZag+xEmpDest,'M0_ESTENT')

Return

/*
========================================================
Valida campos de empresa do msGET
========================================================
*/
Static Function VldObrig(cObrg)

	Local lObrg := .T.

	If Empty(cObrg)
		Alert("Campo obrigatório, favor preencher seu conteúdo!")
		lObrg := .F.
	Endif

Return lObrg

/*
========================================================
Grava dados na ZAL
========================================================
*/
Static Function GRVZAL(cEmpDest,cRazEmpD,cIeEmpDes,cCnpjEmpD,dDatEmiss,dDatSai,cUfEmpDes,cCTRC,cSerieCtrc,cRazEmpD,cIeEmpDes,cCnpjEmpD)
	Local aAreaZAL	:= GetArea()
	Local lRet	:= .T.
	Local nLimDias := GETNEWPAR("MGF_LIDIAS",20)
	Local nDifDias := 0 

	If Empty(cEmpDest) .OR. !ExistCpo("SM0",cCodEmpZag+cEmpDest)
		Alert("Informe um código de empresa válido!")
		lRet	:= .F.
	ElseIf xFilial("ZAL") != ZAG->ZAG_FILIAL
		Alert("Filial de origem do relacionamento inválida!")
		lRet	:= .F.
	ElseIf xFilial("ZAL") == cEmpDest
		Alert("Não é permitido transferir para a mesma filial de ORIGEM!")
		lRet := .F.
	ElseIf Empty(cCTRC) .OR. Empty(cSerieCtrc)
		Alert("CTRC ou Série destino não preenchido, favor preencher seu conteúdo!")
		lRet := .F. 
	Else
		//---------------------------------------------------------------      
		//Grava os dados na tabela ZAL
		//---------------------------------------------------------------
		DbSelectArea("ZAL")
		DbSetOrder(1)
		If !ZAL->(MsSeek(xFilial("ZAL")+ZAG->ZAG_DOC+ZAG->ZAG_SERIE+ZAG->ZAG_CODFOR+ZAG->ZAG_LOJFOR))
			If !MsgYesNo("Deseja relacionar a filial destino na nota fiscal?")
				lRet := .F.
				MsgInfo("Relacionamento de filial não efetuado!","Atenção")
			Endif
			nDifDias := DateDiffDay(ZAG->ZAG_DTENT,dDatSai)
			If nDifDias > nLimDias .Or. ;
			( Month(ZAG->ZAG_DTENT) <> Month(dDatSai) .And. Year(ZAG->ZAG_DTENT) <> Year(dDatSai) ) 
				If !MsgYesNo("Limite de dias para transferência excedido! Deseja transferir?","Atenção")
					lRet := .F.
				Endif
			Endif
			If lRet
				RecLock("ZAL",.T.)
				ZAL->ZAL_FILIAL := xFilial("ZAL")
				ZAL->ZAL_TRANS  := ZAG->ZAG_TRANS 
				ZAL->ZAL_DOCORI := ZAG->ZAG_DOC   
				ZAL->ZAL_SERORI := ZAG->ZAG_SERIE 
				ZAL->ZAL_FORORI := ZAG->ZAG_CODFOR
				ZAL->ZAL_LOJORI := ZAG->ZAG_LOJFOR
				ZAL->ZAL_CTRDES := cCTRC
				ZAL->ZAL_SCTDES := cSerieCtrc
				ZAL->ZAL_ECTDES := dDatEmiss
				ZAL->ZAL_FILDES := cEmpDest
				ZAL->ZAL_NFILDE := cRazEmpD
				ZAL->ZAL_IEFILD := cIeEmpDes
				ZAL->ZAL_CGCFDE := cCnpjEmpD
				ZAL->ZAL_UFFILD := cUfEmpDes
				ZAL->ZAL_DTSAI  := dDatSai
				ZAL->ZAL_MESMNF := "S"
				ZAL->ZAL_NFTRAN := Space(TamSx3("ZAG_DOC")[1])
				ZAL->ZAL_SERNFT := Space(TamSx3("ZAG_SERIE")[1])
				ZAL->ZAL_FORNFT := Space(TamSx3("ZAG_CODFOR")[1])
				ZAL->ZAL_LOJNFT := Space(TamSx3("ZAG_LOJFOR")[1])
				ZAL->(MsUnlock())
				ZAL->(DbSkip())
				RecLock("ZAG",.F.)
				ZAG->ZAG_DIAS   := nDifDias
				ZAG->ZAG_NFTRAN := "S"
				ZAG->(MsUnlock())
				MsgInfo("Relacionamento de CTRC Destino efetuado para a nota fiscal "+AllTrim(ZAG->ZAG_DOC)+"-"+AllTrim(ZAG->ZAG_SERIE)+"!","Atenção")
			Endif
		Else
			Alert("Nota fiscal "+AllTrim(ZAL->ZAL_DOCORI)+"-"+AllTrim(ZAL->ZAL_SERORI)+" já transferida!")
			lRet := .F.
		Endif
	Endif
	RestArea(aAreaZAL)
Return(lRet)

/*
========================================================
Exclui registros da ZAG e ZAL
========================================================
*/
User Function DLZAGZAL()

	Local aAreaZAG := GetArea()
	Local aAreaZAL := GetArea()
	Local cZAGTrans

	If MsgYesNo("Deseja excluir a nota fiscal e seu relacionamento?")
		DbSelectArea("ZAL")
		DbSetOrder(4)
		If ZAL->(MsSeek(xFilial("ZAL")+ZAG->ZAG_TRANS))
			RecLock("ZAL",.F.)
			ZAL->(DbDelete())
			ZAL->(MsUnlock())
			ZAL->(DbSkip())
		Endif
		DbSelectArea("ZAG")
		DbSetOrder(4)
		If ZAG->(MsSeek(xFilial("ZAG")+ZAG->ZAG_TRANS))
			RecLock("ZAG",.F.)
			ZAG->(DbDelete())
			ZAG->(MsUnlock())
			ZAG->(DbSkip())
		Endif
		RestArea(aAreaZAL)
		RestArea(aAreaZAG)			
	EndIf

Return

/*
========================================================
Filtro da consulta de notas fiscais
========================================================
*/
User Function CNZAGZAL()
	private cPerg     := Padr("MGFFIS14",Len(SX1->X1_GRUPO))

	If !Pergunte(cPerg,.T.)
		return
	EndIf

	TelaConsNF()

Return

/*
========================================================
Tela da consulta de notas fiscais
========================================================
*/
Static Function TelaConsNF()

	Local aTRB := {}
	Local aHeadMBrow := {}

	Private cCadastro := "Consulta Notas Fiscais - "+IIF(MV_PAR03==1,"Com transferencias efetuadas",IIF(MV_PAR03==2,"Sem transferencias efetuadas","Todas"))
	Private aRotina := {}

	//aTRB[1] -> Nome físico do arquivo
	//aTRB[2] -> Nome do índice 1
	//aTRB[3] -> Nome do índice 2
	MsgRun("Criando estrutura e carregando dados ...",,{|| aTRB := FileTRB() } )

	//aHeadMBrow[1] -> Título 
	//aHeadMBrow[2] -> Campo
	//aHeadMBRow[3] -> Tipo
	//aHeadMBrow[4] -> Tamanho
	//aHeadMBRow[5] -> Decimal
	//aHeadMBrow[6] -> Picture
	MsgRun("Ativando a tela de consulta...",,{|| aHeadMBrow := HeadBrow() } )

	AAdd( aRotina, { "","" , 0, 2 } )

	dbSelectArea("TRB")
	dbSetOrder(1)
	MBrowse(,,,,"TRB",aHeadMBrow,,,,,,"","") 

	//Fecha a área
	TRB->(dbCloseArea())
	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())
	//Apaga os arquivos de índices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())
	FErase( aTRB[ nIND2 ] + OrdBagExt()) 
Return

/*
========================================================
Campos da tela de consulta de notas fiscais
========================================================
*/
Static Function HeadBrow()
	Local aHead := {}
	//Campos que aparecerão na MBrowse, como não é baseado no SX3 deve ser criado.
	//Sequência do vetor: Título, Campo, Tipo, Tamanho, Decimal, Picture
	AAdd( aHead, { "Data de entrada CD" , {|| TRB->ZAG_DTENT}  ,"D", 8, 0, "" } )
	AAdd( aHead, { "Dias"       	    , {|| TRB->ZAG_DIAS }  ,"N", 3, 0, "" } )
	AAdd( aHead, { "Número NF"   	    , {|| TRB->ZAG_DOC  }  ,"C", 9, 0, "" } )
	AAdd( aHead, { "Série NF"	        , {|| TRB->ZAG_SERIE}  ,"C", 3, 0, "" } )
	AAdd( aHead, { "Data Emissão" 	    , {|| TRB->ZAG_EMIS }  ,"D", 8, 0, "" } )
	AAdd( aHead, { "Valor Total NF"     , {|| TRB->ZAG_VALNF}  ,"N",14, 2, "" } )
	AAdd( aHead, { "Fornecedor"         , {|| TRB->ZAG_NOMFOR} ,"C",40, 0, "" } )
	AAdd( aHead, { "Filial Dest."       , {|| TRB->ZAL_FILDES} ,"C", 2, 0, "" } )
	AAdd( aHead, { "Nome da Filial"     , {|| TRB->ZAL_NFILDE} ,"C",40, 0, "" } )
	AAdd( aHead, { "CNPJ"               , {|| TRB->ZAL_CGCFDE} ,"C",14, 0, "@R 99.999.999/9999-99" } )
	AAdd( aHead, { "CTRC Dest."         , {|| TRB->ZAL_CTRDES} ,"C", 9, 0, "" } )
	AAdd( aHead, { "Série CTRC Dest."   , {|| TRB->ZAL_SCTDES} ,"C", 3, 0, "" } )
	AAdd( aHead, { "Transferida?" 		, {|| TRB->ZAG_NFTRAN} ,"C", 1, 0, "" } )

Return( aHead )

/*
========================================================
Arquivo temporário da consulta de notas fiscais
========================================================
*/
Static Function FileTRB()
	Local aStruct := {}

	Local cArqTRB := ""
	Local cInd1 := ""
	Local cInd2 := ""

	Local nI := 0
	Local cMGF := GetNextAlias()
	Local nVez := 0
	Local cIntegr := ""

	//Pode ser feito de duas maneiras a criação do arquivo temporário, porém como isto será
	//feito com base em um arquivo que já existe será mais fácil utilizar a primeira maneira.

	//Primeira maneira
	//aStruct := ZAG->( dbStruct() ) 
	//Segunda maneira
	AAdd( aStruct, { "ZAG_DTENT"  ,"D",  8, 0 } )
	AAdd( aStruct, { "ZAG_DIAS "  ,"N",  3, 0 } )
	AAdd( aStruct, { "ZAG_DOC  "  ,"C",  9, 0 } )
	AAdd( aStruct, { "ZAG_SERIE"  ,"C",  3, 0 } )
	AAdd( aStruct, { "ZAG_EMIS "  ,"D",  8, 0 } )
	AAdd( aStruct, { "ZAG_VALNF"  ,"N", 14, 2 } )
	AAdd( aStruct, { "ZAG_NOMFOR" ,"C", 40, 0 } )
	AAdd( aStruct, { "ZAL_FILDES" ,"C",  2, 0 } )
	AAdd( aStruct, { "ZAL_NFILDE" ,"C", 40, 0 } )
	AAdd( aStruct, { "ZAL_CGCFDE" ,"C", 14, 0 } )
	AAdd( aStruct, { "ZAL_CTRDES" ,"C",  9, 0 } )
	AAdd( aStruct, { "ZAL_SCTDES" ,"C",  3, 0 } )
	AAdd( aStruct, { "ZAG_NFTRAN" ,"C",  1, 0 } )

	// Ambas as maneiras devem proceder estes comandos abaixo:
	// Criar fisicamente o arquivo.
	cArqTRB := CriaTrab( aStruct, .T. )
	cInd1 := Left( cArqTRB, 7 ) + "1"
	cInd2 := Left( cArqTRB, 7 ) + "2"
	// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
	dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )
	// Criar os índices.
	IndRegua( "TRB", cInd1, "ZAG_DTENT", , , "Criando índices (Data Entrada)...")
	IndRegua( "TRB", cInd2, "ZAG_DOC+ZAG_SERIE", , , "Criando índices (NF + Série)...")

	// Libera os índices.
	dbClearIndex()
	// Agrega a lista dos índices da tabela (arquivo).
	dbSetIndex( cInd1 + OrdBagExt() )
	dbSetIndex( cInd2 + OrdBagExt() )

	// Carregar os dados de ZAG e ZAL em TRB.
	If Select(cMGF) > 0
		(cMGF)->(DbClosearea())
	Endif

	If MV_PAR03 == 1
		cIntegr := "S"
	ElseIf MV_PAR03 == 2
		cIntegr := "N"
	Else
		cIntegr := "S','N"
	Endif

	BeginSql Alias cMGF	

	SELECT DISTINCT ZAG.ZAG_DTENT, ZAG.ZAG_DIAS, ZAG.ZAG_DOC, ZAG.ZAG_SERIE, ZAG.ZAG_EMIS, ZAG.ZAG_VALNF, ZAG.ZAG_NOMFOR, ZAL.ZAL_FILDES, 
	ZAL.ZAL_NFILDE, ZAL.ZAL_CGCFDE, ZAL.ZAL_CTRDES, ZAL.ZAL_SCTDES, ZAG_NFTRAN
	FROM %Table:ZAG% ZAG, %Table:ZAL% ZAL
	WHERE ZAG.%NotDel%
	AND ZAL.%NotDel%
	AND ZAG.ZAG_FILIAL = %xFilial:ZAG%
	AND ZAL.ZAL_FILIAL = %xFilial:ZAL%
	AND ZAG.ZAG_TRANS = ZAL.ZAL_TRANS 
	AND ZAG.ZAG_DTENT BETWEEN	%Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND ZAG.ZAG_NFTRAN IN (%Exp:cIntegr%)
	UNION ALL
	SELECT DISTINCT ZAG.ZAG_DTENT, ZAG.ZAG_DIAS, ZAG.ZAG_DOC, ZAG.ZAG_SERIE, ZAG.ZAG_EMIS, ZAG.ZAG_VALNF, ZAG.ZAG_NOMFOR, '      ' ZAL_FILDES,
	'      ' ZAL_NFILDE, ' ' ZAL_CGCFDE, ' ' ZAL_CTRDES, ' ' ZAL_SCTDES, ZAG_NFTRAN
	FROM %Table:ZAG% ZAG
	WHERE ZAG.%NotDel%
	AND ZAG.ZAG_FILIAL = %xFilial:ZAG%
	AND ZAG.ZAG_DTENT BETWEEN	%Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND ZAG.ZAG_NFTRAN = 'N'
	AND ZAG.ZAG_NFTRAN IN (%Exp:cIntegr%)
	ORDER BY 1

	EndSql	

	aQuery := GetLastQuery()

	MemoWrit( "C:\00\MGFFIS14.SQL" , aQuery[2] )
	//[1] Tabela temp
	//[2] Query
	//..[5]	

	nVez := (cMGF)->( FCount() )

	While ! (cMGF)->( EOF() )
		TRB->(RecLock("TRB",.T.))
		For nI := 1 To nVez
			TRB->( FieldPut( nI, (cMGF)->(FieldGet( nI ) ) ) )
		Next nI
		TRB->(MsUnLock())
		(cMGF)->( dbSkip() )
	EndDo
	(cMGF)->(dbCloseArea())

Return({cArqTRB,cInd1,cInd2})

/*
========================================================
Legenda
========================================================
*/
User Function BLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE" ,"Nota Fiscal Pendente de Transferência." })
	AADD(aLegenda,{"BR_AZUL" ,"Nota Fiscal Transferida." })
	AADD(aLegenda,{"BR_VERMELHO" ,"NF Pendente - Fora do Prazo de Transferência." })
	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
========================================================
Função de pesquisa
========================================================
*/
User Function APESQZAG()
	Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
	Local cOrdem
	Local cChave := Space(255)
	Local aOrdens := {}
	Local nOrdem := 1
	Local nOpcao := 0

	AAdd( aOrdens, "Nota Fiscal + Série + Cod.Fornec. + Loja Fornec." )
	AAdd( aOrdens, "Cod.Fornec. + Loja Fornec." )
	AAdd( aOrdens, "CNPJ/CPF" )

	DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
	@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
	@ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER

	If nOpcao == 1
		cChave := xFilial("ZAG") + AllTrim(cChave)
		ZAG->(dbSetOrder(nOrdem)) 
		ZAG->(dbSeek(cChave))
	Endif
Return

/*
========================================================
Valida campo de documento fiscal na inclusão
========================================================
*/
User Function VLZAGDOC()

	Local lRet
	/*
	If !SF1->(DbSeek(xFilial("SF1")+M->ZAG_DOC+M->ZAG_SERIE+M->ZAG_CODFOR+M->ZAG_LOJFOR+"N")) 
	Alert("Nota fiscal inexistente, favor informar um número válido!")
	lRet := .F.
	Else*/
	If ZAG->(DbSeek(xFilial("ZAG")+M->ZAG_DOC+M->ZAG_SERIE+M->ZAG_CODFOR+M->ZAG_LOJFOR))
		Alert("Nota fiscal já inserida no controle!")
		lRet := .F.
	Else
		lRet := .T.
	Endif

Return lRet