#INCLUDE "protheus.ch"
//#Include "MSMGADD.CH"
#include "totvs.ch"
#include "topconn.ch"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3
#DEFINE nIND3 4
#DEFINE nIND4 5

/*
=====================================================================================
Programa............: MGFFIN16
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Markbrose com tabela temporaria para selecao dos titulos e Ordem de entrega para registro de sinistro
aos fornecedores
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................: Alteracoes realizadas por Barbieri em 01/2017
=====================================================================================
*/
User Function MGFFIN16()
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	Local _astru :={}
	Local _carq
	Local aTRB := {}
	Local oMark
	local I 
	Private _aAux    := {}
	Private aStru    := {}
	Private arotina  := {}
	Private aCampos  := {}
	Private cMark    := GetMark()
	Private cCadastro
	Private nRegLoc  := 0
	Private aSituaca := Strtokarr(GetMv("MGF_SITSIN"),";") // K - Codigo da ocorrencia da situacao de sinistro
	Private aOcorSin := Strtokarr(GetMv("MGF_OCOSIN"),";") // Ocorrencia bancaria utilizada no processo de sinisitro - Nao protesto separadas por ;
	Private _cProcSini:= ''
	Private _cFil		:= ''
	Private _cPrefixo := ''
	Private _cTitulo  := ''
	Private _cParcela := ''
	Private _cTipo    := ''
	Private _cCodCli  := ''
	Private _cLojaCli := ''

	// 1- Ocorrencia de sinistro                                                                                                                                  
	Private _cOcorren := ''
	Private _cSituaca := ''

	//For I := 1 to LEN(aOcorSin) 
	//   aAdd(_aAux,StrToKArr(aOcorSin[I],"/"))
	//Next I

	// Verifica se o codigo de ocorrencia existe
	DbSelectArea("FRV")
	IF ! FRV->(DbSeek(xFilial("FRV")+_cSituaca))
		alert("Ocorrencia da situacao de Sininistro nao informada ou localizada")
		Return(.F.)
	Endif

	cCadastro := "Posicao de Sinistro"

	MsgRun("Criando tela de Posicao de Sinistro...",,{|| aTRB := Cria_TRB() } )	// Barbieri: Alterado comando para alimentar variavel aTRB e criado funcao �nica de tabela temporaria

	aCores := {}
	AADD(aCores,{"RB_ZORDENT == SPACE(10) .and. RB_ZSINIST = 'Nao'","BR_PRETO" })
	AADD(aCores,{"RB_ZORDENT == SPACE(10) .and. RB_ZSINIST = 'Sim'","BR_AMARELO" })
	AADD(aCores,{"RB_ZSINIST == 'Sim'" ,"BR_VERMELHO" })
	AADD(aCores,{"RB_ZSINIST == 'Nao'" ,"BR_VERDE" })

	aCampos := u_CPOSINIS()

	aRotina   := {	{ "O&E - Ordem Embarque" ,"u_MarkProc"      , 0, 4},; //Barbieri: Alterado para 4 no 4o parametro   
					{ "Visualiza"            ,"u_VisuTit"       , 0, 2},; //Barbieri: Alterado para 2 no 4o parametro 
					{ "Pesquisa"             ,"u_APESQSIN()"    , 0, 1},; //Barbieri: Alterado para 1 no 4o parametro 
					{ "Canc.Reg.Sinistro"    ,"u_CancSin()"     , 0, 0},; //Barbieri: Alterado para 0 no 4o parametro 	
					{ "Legenda"              ,"u_LEGSINIS"      , 0, 8}}  //Barbieri: Alterado para 0 no 4o parametro 

	DbSelectArea("TRB")
	DbGotop()

	mBrowse(aCoors[1], aCoors[2], aCoors[3], aCoors[4], "TRB", aCampos	,,,,,aCores,,,,, .F.,,,,,,)
	//mBrowse( 6		,1			,22			,75			,"ZZ2",			,,,,,aCores)
	//MarkBrow('TRB','RB_OK',,aCampos,, cMark,'u_MarkAllSin(1)',,,,'u_MarcarSin()',,,,aCores,,,,.T.)
	//MarkBrow('TRB','RB_OK',,aCampos,, cMark,'u_MarkAllSin(1)',,,,'u_MarcarSin()',{|| u_MarkAllSin(1)},,,aCores,,,,.F.)

	//Barbieri: Criado controles para arquivo temporario
	//Fecha a �rea
	TRB->(dbCloseArea())
	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())
	//Apaga os arquivos de indices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())
	FErase( aTRB[ nIND2 ] + OrdBagExt()) 
	FErase( aTRB[ nIND3 ] + OrdBagExt())
	FErase( aTRB[ nIND4 ] + OrdBagExt())

Return

/*
=====================================================================================
Programa............: MarkAllSin
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: funcao auxiliar a Markbrowse para selecao de todos os registres
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function MarkAllSin(nParMark)
	Local oMark    := GetMarkBrow()
	nRegLoc  := 0
	DbSelectArea("TRB")
	DbGotop()
	if nParMark = 1
		While !Eof()
			if TRB->RB_ZSINIST <> 'Sim' .and. TRB->RB_PREFIXO <> 'SEG'
				RecLock( 'TRB', .F. )
				TRB->RB_OK := cMark
				MsUnLock()
			Endif
			TRB->(DbSkip())
		Enddo
	Else
		While !Eof()
			if alltrim(TRB->RB_ZORDENT) = ALLTRIM(cOrdEntr) .and. TRB->RB_PREFIXO <> 'SEG'
				nRegLoc ++
				RecLock( 'TRB', .F. )
				TRB->RB_OK := cMark
				MsUnLock()
			Endif
			TRB->(DbSkip())
		Enddo
	Endif
	MarkBRefresh()
	// for�a o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()

return

/*
=====================================================================================
Programa............: DesmAllSin
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: funcao auxiliar a Markbrowse para cancelar selecao de todos os registros
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function DesmAllSin()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
		if TRB->RB_ZSINIST <> 'Sim' .and. TRB->RB_PREFIXO <> 'SEG'
			RecLock( 'TRB', .F. )
			TRB->RB_OK := SPACE(2)
			MsUnLock()
		Endif
		TRB->(DbSkip())
	Enddo
	MarkBRefresh( )
	// for�a o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()

Return

/*
=====================================================================================
Programa............: InverSin
Autor...............: Roberto Sidney
Data................: 10/06/2016
Descricao / Objetivo: funcao auxiliar a Markbrowse para inverter selecao de registros
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function InvertSin()
	DbSelectArea("TRB")
	DbGotop()
	While !Eof()
		if TRB->RB_ZSINIST <> 'Sim' .and. TRB->RB_PREFIXO <> 'SEG'
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
Programa............: MarcarSin
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: funcao auxiliar a Markbrowse para marcar e desmarcar unico registro
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function MarcarSin()

	if TRB->RB_ZSINIST <> 'Sim' .and. TRB->RB_PREFIXO <> 'SEG'
		RecLock( 'TRB', .F. )
		TRB->RB_OK := iif(! Empty(alltrim(TRB->RB_OK)),Space(2),cMark)
		MsUnLock()
	Endif
	MarkBRefresh()

Return


/*
=====================================================================================
Programa............: Cria_TRB
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: Criacao da tabela temporaria - TRB
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................: Alterado por Barbieri em 01/2017, criacao e carga dos	dados Static Funtcion
=====================================================================================
*/
Static FUNCTION Cria_TRB()

	Local cArq  := ""
	Local cInd1 := ""
	Local cInd2 := ""
	Local cInd3 := ""
	Local cInd4 := ""
	Local nX	:= 0

	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif

	aStru := {}
	AADD(aStru,{"RB_OK"       ,"C",02,0})
	AADD(aStru,{"RB_FILIAL"   ,"C",06,0}) //Barbieri: Alterar na Marfrig para tamanho 6
	AADD(aStru,{"RB_ZSINIST"  ,"C",03,0})
	AADD(aStru,{"RB_PREFIXO"  ,"C",03,0}) 
	AADD(aStru,{"RB_NUM"      ,"C",09,0})
	AADD(aStru,{"RB_PARCELA"  ,"C",02,0}) //Barbieri: Alterar na Marfrig para tamanho 2
	AADD(aStru,{"RB_TIPO"     ,"C",03,0})
	AADD(aStru,{"RB_ZORDENT"  ,"C",10,0})
	AADD(aStru,{"RB_ZPRCSIN"  ,"C",10,0})
	AADD(aStru,{"RB_NATUREZ"  ,"C",10,0})
	AADD(aStru,{"RB_CLIENTE"  ,"C",06,0})
	AADD(aStru,{"RB_LOJA"     ,"C",02,0})
	AADD(aStru,{"RB_NOMCLI"   ,"C",20,0})
	AADD(aStru,{"RB_PORTADO"  ,"C",03,0})
	AADD(aStru,{"RB_EMISSAO"  ,"D",08,0})
	AADD(aStru,{"RB_VENCTO"   ,"D",08,0}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aStru,{"RB_VENCREA"  ,"D",08,0}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aStru,{"RB_VALOR"    ,"N",16,2})
	AADD(aStru,{"RB_BAIXA"    ,"D",08,0})
	AADD(aStru,{"RB_NUMBOR"   ,"C",06,0})
	AADD(aStru,{"RB_DATABOR"  ,"D",08,2})
	AADD(aStru,{"RB_HIST"     ,"C",25,0})
	AADD(aStru,{"RB_SITUACA"  ,"C",01,0})
	AADD(aStru,{"RB_OCORREN"  ,"C",02,0})
	AADD(aStru,{"RB_SALDO"    ,"N",16,2})
	AADD(aStru,{"RB_PEDIDO"   ,"C",06,0})
	AADD(aStru,{"RB_NUMNOTA"  ,"C",09,0})
	AADD(aStru,{"RB_SERIE"    ,"C",03,0})
	AADD(aStru,{"RB_IDCNAB"   ,"C",10,0})
	//AADD(aStru,{"RB_REGIS"    ,"N",10,0}) Barbieri: retirado do MarkBrowser

	//Barbieri: Criacao de indices para o arquivo temporario
	cArq := Criatrab(aStru,.T.)
	cInd1 := Left( cArq, 5 ) + "1"
	cInd2 := Left( cArq, 5 ) + "2"
	cInd3 := Left( cArq, 5 ) + "3"
	cInd4 := Left( cArq, 5 ) + "4"	
	dbUseArea( .T., __LocalDriver, cArq, "TRB", .F., .F. )
	IndRegua( "TRB", cInd1, "RB_FILIAL+RB_NUM", , , "Criando indices (Numero)...")
	IndRegua( "TRB", cInd2, "RB_FILIAL+RB_ZORDENT", , , "Criando indices (Embarque)...")
	IndRegua( "TRB", cInd3, "RB_FILIAL+RB_PREFIXO+RB_NUM+RB_PARCELA", , , "Criando indices (Prefixo + Numero + Parcela)...")
	IndRegua( "TRB", cInd4, "RB_FILIAL+RB_CLIENTE+RB_LOJA", , , "Criando indices (Cliente + Loja)...")
	dbClearIndex()
	dbSetIndex( cInd1 + OrdBagExt() )
	dbSetIndex( cInd2 + OrdBagExt() )
	dbSetIndex( cInd3 + OrdBagExt() )
	dbSetIndex( cInd4 + OrdBagExt() )

	//Barbieri: User function Monta_TRB foi eliminada, foi colocado junto com a static function Cria_TRB

	cQuery := ""
	cQuery +="SELECT E1_FILIAL RB_FILIAL,"
	cQuery +="E1_ZORDENT RB_ZORDENT,"
	cQuery +="E1_ZSINIST RB_ZSINIST,"
	cQuery +="E1_ZPRCSIN RB_ZPRCSIN,"
	cQuery +="E1_PREFIXO RB_PREFIXO,"
	cQuery +="E1_NUM RB_NUM,"
	cQuery +="E1_PARCELA RB_PARCELA,"
	cQuery +="E1_TIPO RB_TIPO,"
	cQuery +="E1_NATUREZ RB_NATUREZ,"
	cQuery +="E1_CLIENTE RB_CLIENTE,"
	cQuery +="E1_LOJA RB_LOJA,"
	cQuery +="E1_NOMCLI RB_NOMCLI,"
	cQuery +="E1_PORTADO RB_PORTADO,"
	cQuery +="E1_EMISSAO RB_EMISSAO,"
	cQuery +="E1_VENCTO RB_VENCTO,"
	cQuery +="E1_VENCREA RB_VENCREA,"
	cQuery +="E1_VALOR RB_VALOR,"
	cQuery +="E1_NUMBCO RB_NUMBCO,"
	cQuery +="E1_BAIXA RB_BAIXA,"
	cQuery +="E1_NUMBOR RB_NUMBOR,"
	cQuery +="E1_DATABOR RB_DATABOR,"
	cQuery +="E1_HIST RB_HIST,"
	cQuery +="E1_SITUACA RB_SITUACA,"
	cQuery +="E1_OCORREN RB_OCORREN,"
	cQuery +="E1_SALDO RB_SALDO,"
	cQuery +="E1_PEDIDO RB_PEDIDO,"
	cQuery +="E1_NUMNOTA RB_NUMNOTA,"
	cQuery +="E1_SERIE RB_SERIE,"
	cQuery +="E1_IDCNAB RB_IDCNAB "
	//cQuery +="R_E_C_N_O_ RB_REGIS " Barbieri: Retirado do MarkBrowser
	cQuery +="FROM " + RetSqlName("SE1")
	cQuery +="WHERE "
	cQuery +="E1_SALDO > 0 AND E1_TIPO = 'NF '"
	//if cTipoProc = "P" // Protesto, seleciona apenas titulos de sinistro
	//	cQuery +=" AND E1_ZSINIST = 'S' "
	//End
	//cQuery +="E1_EMISSAO BETWEEN  '' AND '20161231' "
	//cQuery +="AND E1_CLIENTE BETWEEN  '' AND '2ZZZZZZ' "
	//cQuery +="AND E1_LOJA BETWEEN  '  ' AND 'ZZ' "
	//cQuery +="AND E1_IDCNAB <> ''
	cQuery +="AND D_E_L_E_T_ = ' ' "
	cQuery +="ORDER BY RB_FILIAL,RB_PREFIXO, RB_NUM, RB_PARCELA "	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)    

	// Compatibiliza compos data
	TcSetField("CAD","RB_EMISSAO","D",8,0)
	TcSetField("CAD","RB_VENCTO","D",8,0)
	TcSetField("CAD","RB_VENCREA","D",8,0)
	TcSetField("CAD","RB_BAIXA","D",8,0)
	TcSetField("CAD","RB_DATABOR","D",8,0)

	Dbselectarea("CAD")
	//_nReg := 1
	While CAD->(!EOF())
		RecLock("TRB",.T.)
		For nX := 1 To Len(aStru)
			If !(aStru[nX,1] $ 'RB_OK')
				If aStru[nX,2] = 'C'
					_cX := 'TRB->'+aStru[nX,1]+' := Alltrim(CAD->'+aStru[nX,1]+')'
				Else 
					_cX := 'TRB->'+aStru[nX,1]+' := CAD->'+aStru[nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		//	TRB->RB_REGIS := _nReg
		TRB->RB_ZSINIST := IIF(alltrim(TRB->RB_ZSINIST) $ "''/N",'Nao','Sim')

		MsUnLock()
		//	_nReg ++
		DbSelectArea('CAD')
		CAD->(dBSkip())
	EndDo

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TRB")
	//DbGoTop()

Return ({cArq,cInd1,cInd2,cInd3,cInd4}) //Barbieri: Inclu�do para abertura do arquivo e MarkBrowser

/*
=====================================================================================
Programa............: LEGSINIS
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Legenda
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function LEGSINIS()

	aLegenda := {{"BR_VERMELHO","Sinistro gerado / Cobranca cancelada"},;
	{"BR_VERDE","Sem sinistro / Cobranca em andamendo"},;
	{"BR_AMARELO","Sem O.E / Sinistro gerado / Cobranca cancelada"},;
	{"BR_PRETO","Sem O.E - Ordem de Embarque"}}

	BRWLEGENDA( "Registro de Sinistro", "Legenda", aLegenda )

Return .T.


/*
=====================================================================================
Programa............: VisuTit
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Visualizacao do registro
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function VisuTit()

	_cAreaTRB := TRB->(GetArea())
	_cChvPes  := TRB->RB_PREFIXO+TRB->RB_NUM+TRB->RB_PARCELA+TRB->RB_TIPO //Barbieri: Alterado chave para funcionar corretamente

	DbSelectarea("SE1")
	DbSetOrder(1)
	IF SE1->(DbSeek(xFilial("SE1")+_cChvPes))
		//AxVisual("SE1",SE1->(RECNO()),6,,,"6",,,.T.)
		AxVisual("SE1",SE1->(RECNO()),2) //Barbieri: Alterado para funcionar a funcao Visualizar
	Else
		alert("Titulo "+TRB->RB_PREFIXO+"-"+TRB->RB_NUM+"-"+TRB->RB_PARCELA+" nao localizado.")
	Endif
	RestArea(_cAreaTRB)
Return(.T.)


/*
=====================================================================================
Programa............: APESQSIN
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Funcao de pesquisa
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: 
Obs.................: Alterado completamente por Barbieri em 01/2017
=====================================================================================
*/
User Function APESQSIN()
	Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
	Local cOrdem
	Local cChave := Space(255)
	Local aOrdens := {}
	Local nOrdem := 1
	Local nOpcao := 0
	//Local nRecTRB := 0

	AAdd( aOrdens, "Numero" )
	AAdd( aOrdens, "Embarque" )
	AAdd( aOrdens, "Prefixo + Numero + Parcela" )
	AAdd( aOrdens, "Cliente + Loja" )

	DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
	@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
	@ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER

	If nOpcao == 1
		cChave := AllTrim(cChave)
		TRB->(dbSetOrder(nOrdem)) 
		TRB->(dbSeek(cChave))
	Endif
Return


/*
=====================================================================================
Programa.:              fExibeTela
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Funcao chamadora da tela principal
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MarkProc()
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local cGet1		:= Space(tamSx3("E1_ZORDENT")[1])

	Local oGetFilial
	Local cGetFilial		:= space(tamSx3("E1_FILIAL")[1])

	Local oGetTitu
	Local cGetEmisDe		:= cToD("  /  /  ")

	local oGetEmisAt
	local cGetEmisAt		:= cToD("  /  /  ")

	Local oSay1
	Local cFields	:= ""
	Local cAliasTMP	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local aDados	:= {}
	Local oWBrowse1
	Local oFont
	Local lOrdEntre	:= .F.

	private cSomaT := ""
	private cQtdeT := ""

	cStrTran	:= "SE1."
	// SE1.E1_PORTADO,
	cFields		:= "'.F.' AS MARK,SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_ZORDENT,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA, SE1.E1_PORTADO, "
	cFields		+= "SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_BAIXA,SE1.E1_NUMBOR,SE1.E1_SITUACA,SE1.E1_OCORREN,SE1.R_E_C_N_O_ REGISTRO"

	cAliasTMP	:= "SE1"

	fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .F.)

	DEFINE FONT oFont NAME "ARIAL" SIZE 6,15 BOLD

	//DEFINE MSDIALOG oDlg TITLE "Localizador de Titulos" FROM 000, 000  TO 430, 1250 COLORS 0, 16777215 PIXEL
	DEFINE MSDIALOG oDlg TITLE "Localizador de Titulos" FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] COLORS 0, 16777215 PIXEL

	//@ 004 , 003 TO 212 , 622 LABEL "Selecao de titulos pela O.E - Ordem de Embarque" PIXEL OF oDlg

	//@ 010, 008 SAY oSay1 PROMPT " Filial:"		SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	//@ 008, 065 MSGET oGetFilial VAR cGetFilial	SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 010, 130 SAY oSay1 PROMPT "Emissao de:"					SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 008, 165 MSGET oGet1 VAR cGetEmisDe		PICTURE "@D"	SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 010, 235 SAY oSay1 PROMPT "Emissao ate:"					SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 008, 270 MSGET oGetEmisAt VAR cGetEmisAt	PICTURE "@D"	SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 025, 008 SAY oSay1 PROMPT " Ordem de Embarque:" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 023, 065 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 025, 250 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION fwMsgRun(, {|| cSomaT := "", cQtdeT := "", fGeraQry(cFields , @aDados , @cGet1, oDlg , oWBrowse1 , @lOrdEntre, cGetEmisDe, cGetEmisAt, cGetFilial) }, "Processando", "Aguarde. Selecionando dados..." )

	@ 026, 300 SAY oSaySoma	PROMPT "Somatoria: " 			+ cSomaT	SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 035, 300 SAY oSayQtd	PROMPT "Qtde selecionada: "		+ cQtdeT	SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont

	@ 015, 400 BUTTON oButton1 PROMPT "Marcar todos" SIZE 037, 015 OF oDlg PIXEL ACTION { || mAllFin16(@aDados, @oWBrowse1), fWBrowse1(aHeader , @aDados , oDlg , oWBrowse1 , .T.), atuSelec(oWBrowse1) }

	fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .F.)
	@ 015, 450 BUTTON oButton2 PROMPT "&Limpa Pesquisa" SIZE 037, 015 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , oWBrowse1 , @cGet1 , .T. , lOrdEntre)
	@ 015, 540 BUTTON oButton3 PROMPT "&Gera Sinistro" SIZE 037, 015 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , oWBrowse1 , @cGet1 , .F. , lOrdEntre)
	@ 015, 580 BUTTON oButton4 PROMPT "&Encerra" SIZE 037, 015 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//--------------------------------------------------
static function mAllFin16(aDados, oWBrowse1)
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")
	local aDadosNew	:= {}
	Local cOrdEmb := ""
	Local lContinua := .T.

	// verifica se marcou mais de uma ordem de embarque diferente
	For nI:=1 To Len(aDados)
		If !Empty(cOrdEmb)
			If cOrdEmb != aDados[nI,7]
				APMsgStop("Ordens de Embarque marcadas com codigos diferentes."+CRLF+;
				"Escolha apenas titulos com ordens de embarque de mesmo codigo.")
				lContinua := .F.
				Exit
			Endif
		Endif	
		cOrdEmb := aDados[nI,7]
	Next

	If lContinua
		aDadosNew := aClone(aDados)
	
		aDados := {}
	
		for nI := 1 to len(aDadosNew)
			//aDadosNew[nI, 1] := iif(aDadosNew[nI, 1], oNO, oOK)
			aDadosNew[nI, 1] := !aDadosNew[nI, 1]
		next
	
		aDados := aClone(aDadosNew)
	Endif	

return

//----------------------------------------------
// Atualiza as variaveis de qtde e somatoria
//----------------------------------------------
static function atuSelec(OWBROWSE1)
	local nI		:= 0
	local nQtdeT	:= 0
	local nSaldo	:= 0

	for nI := 1 to len(OWBROWSE1:AARRAY)
		if OWBROWSE1:AARRAY[nI, 1]
			nQtdeT++
			nSaldo += getSaldoE1(OWBROWSE1:AARRAY[nI])
		endif
	next

	cQtdeT := Transform(nQtdeT ,"@E 999,999,999")
	cSomaT := Transform(nSaldo ,"@E 999,999,999,999.99")

	oSaySoma:refresh()
	oSayQtd:refresh()
return

//----------------------------------------------
// Retorna o E1_SALDO do titulo
//----------------------------------------------
static function getSaldoE1(aTitulo)
	local cQrySE1	:= ""
	local nSaldoE1	:= 0

	cQrySE1 := "SELECT SUM(E1_SALDO) E1_SALDO"
	cQrySE1 += " FROM " + retSQLName("SE1") + " SE1"
	cQrySE1 += " WHERE"
	cQrySE1 += " 		SE1.E1_TIPO		=	'" + allTrim(aTitulo[6]) + "'"
	cQrySE1 += " 	AND	SE1.E1_PARCELA	=	'" + allTrim(aTitulo[5]) + "'"
	cQrySE1 += " 	AND	SE1.E1_NUM		=	'" + allTrim(aTitulo[4]) + "'"
	cQrySE1 += " 	AND	SE1.E1_PREFIXO	=	'" + allTrim(aTitulo[3]) + "'"
	cQrySE1 += " 	AND	SE1.E1_FILIAL	=	'" + allTrim(aTitulo[2]) + "'"
	cQrySE1 += " 	AND	SE1.D_E_L_E_T_	<>	'*'"
	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	TcQuery CHANGEQUERY(cQrySE1) New Alias "QRYSE1"

	if !QRYSE1->(EOF())
		nSaldoE1 := QRYSE1->E1_SALDO
	endif

	QRYSE1->(DBCloseArea())
return nSaldoE1


/*
=====================================================================================
Programa.:              fWBrowse1
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Atualiza o array 'aDados', que sera exibido na MarkBrowse
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fWBrowse1(aHeader , aDados , oDlg, oWBrowse1 , lAtuDados)
	Local aSizeAdv	:= MsAdvSize(.F.)
	Local aSizeWnd	:= {aSizeAdv[7],0,aSizeAdv[6],aSizeAdv[5]}
	Local aSizeFld	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-3,aSizeAdv[4]-13}
	Local aSizeBrw	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-60,aSizeAdv[4]-27}

	Local aBrowse 	:= {}
	Local nX		:= 0
	Local nY		:= 0
	Local nPosArray	:= 0
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")

	aBrowse	:= aClone(aDados)

	If !( lAtuDados )
		// Neste caso, somente o array 'aHeader' deve ser gerado
		// Ordem dos campos contidos em 'aHeader'

		@ aSizeFld[1]+25+15,aSizeFld[2] LISTBOX oWBrowse1 Fields HEADER ;
		aHeader[++nPosArray],; // lMark
		aHeader[++nPosArray],; // Filial
		aHeader[++nPosArray],; // Prefixo
		aHeader[++nPosArray],; // Numero
		aHeader[++nPosArray],; // Parcela
		aHeader[++nPosArray],; // Tipo
		aHeader[++nPosArray],; // Ordem Embarque
		aHeader[++nPosArray],; // Natureza
		aHeader[++nPosArray],; // Cliente
		aHeader[++nPosArray],; // Loja
		aHeader[++nPosArray],; // Portador
		aHeader[++nPosArray],; // Nome Cliente
		aHeader[++nPosArray],; // Emissao
		aHeader[++nPosArray],; // Vencimento
		aHeader[++nPosArray],; // Valor
		aHeader[++nPosArray],; // Saldo
		aHeader[++nPosArray],; // Baixa
		aHeader[++nPosArray],; // Bordero
		aHeader[++nPosArray],; // Situacao
		aHeader[++nPosArray],; // Ocorrencia
		aHeader[++nPosArray];  // Recno
		SIZE aSizeFld[3],aSizeFld[4]-50 OF oDlg PIXEL //ColSizes 20,25,25,30,20,20,20,35,35,30,25,40,40
		//SIZE 610 , 150 OF oDlg PIXEL ColSizes 20,35,25,30,25,40,20,80,40,40,40,40,40

		// aCoors[1], aCoors[2] TO aCoors[3], aCoors[4]

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
		If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
		aBrowse[oWBrowse1:nAt,02],;
		aBrowse[oWBrowse1:nAt,03],;
		aBrowse[oWBrowse1:nAt,04],;
		aBrowse[oWBrowse1:nAt,05],;
		aBrowse[oWBrowse1:nAt,06],;
		aBrowse[oWBrowse1:nAt,07],;
		aBrowse[oWBrowse1:nAt,08],;
		aBrowse[oWBrowse1:nAt,09],;
		aBrowse[oWBrowse1:nAt,10],;
		aBrowse[oWBrowse1:nAt,11],;
		aBrowse[oWBrowse1:nAt,12],;
		aBrowse[oWBrowse1:nAt,13],;
		aBrowse[oWBrowse1:nAt,14],;
		aBrowse[oWBrowse1:nAt,15],;		
		aBrowse[oWBrowse1:nAt,16],;		
		aBrowse[oWBrowse1:nAt,17],;		
		aBrowse[oWBrowse1:nAt,18],;		
		aBrowse[oWBrowse1:nAt,19],;		
		aBrowse[oWBrowse1:nAt,20],;		
		aBrowse[oWBrowse1:nAt,21];		
		}}
		// DoubleClick event
		//oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],oWBrowse1:DrawSelect(),atuSelec(oWBrowse1)}
		oWBrowse1:bLDblClick := {|| IIf(MarkFin16(aBrowse,oWBrowse1),(aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],oWBrowse1:DrawSelect(),atuSelec(oWBrowse1)),Nil)}
		
	Else
		oWBrowse1:SetArray(aBrowse)

		If Len(aBrowse) > 0 .and. Len(aBrowse[1]) >= 16
			oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
			aBrowse[oWBrowse1:nAt,02],;
			aBrowse[oWBrowse1:nAt,03],;
			aBrowse[oWBrowse1:nAt,04],;
			aBrowse[oWBrowse1:nAt,05],;
			aBrowse[oWBrowse1:nAt,06],;
			aBrowse[oWBrowse1:nAt,07],;
			aBrowse[oWBrowse1:nAt,08],;
			aBrowse[oWBrowse1:nAt,09],;
			aBrowse[oWBrowse1:nAt,10],;
			aBrowse[oWBrowse1:nAt,11],;
			aBrowse[oWBrowse1:nAt,12],;
			aBrowse[oWBrowse1:nAt,13],;
			aBrowse[oWBrowse1:nAt,14],;
			aBrowse[oWBrowse1:nAt,15],;
			aBrowse[oWBrowse1:nAt,16],;			
			aBrowse[oWBrowse1:nAt,17],;		
			aBrowse[oWBrowse1:nAt,18],;		
			aBrowse[oWBrowse1:nAt,19],;		
			aBrowse[oWBrowse1:nAt,20],;		
			aBrowse[oWBrowse1:nAt,21];		
			}}
		EndIf
		// DoubleClick event
		//oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],oWBrowse1:DrawSelect(),atuSelec(oWBrowse1)}
		oWBrowse1:bLDblClick := {|| IIf(MarkFin16(aBrowse,oWBrowse1),(aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],oWBrowse1:DrawSelect(),atuSelec(oWBrowse1)),Nil)}

		oWBrowse1:Refresh()

		//EndIf
	Endif

	Return


/*
=====================================================================================
Programa.:              fGeraQry
Autor....:              Roberto Sidney
Data.....:              15/09/2016
Descricao / Objetivo:   Gera a Query para avaliar se ha titulos para o codigo de barras informado
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fGeraQry(	cFields		,; // String contendo os campos que serao utilizados para a query e o aHeader da MarkBrowse
	aDados		,; // Este array sera preenchido com o conteudo da Query, caso exista(m) tituluos para o codigo de barras.
	cOrdEnte	,; // Codigo de barras para pesquisa
	oDlg		,;
	oWBrowse1 	,;
	lOrdEntre 	,; // Retorna se o conteudo digitado e' um codigo de barras ou linha digitavel do titulo
	cGetEmisDe	,;
	cGetEmisAt	,;
	cGetFilial	;
	)
	
	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local lRet		:= .F.
	Local aAreaSE1	:= {}
	Local cAliasSE1	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local lExistCod	:= .F. // Valida se o titulo nao tem codigo de barras gravado anteriormente. Caso positivo, bloqueia a gravacao.
	Local cCodTit	:= ""
	Local aBrowse 	:= {}
	Local cCodTmp	:= ""

	if empty(cOrdEnte) .and. empty(cGetEmisDe) .and. empty(cGetEmisAt)// .and. empty(cGetFilial)
		msgAlert("Nenhum filtro informado.")
		return
	endif

	cAliasSE1	:= "SE1"
	aAreaSE1	:= (cAliasSE1)->(GetArea())
	cQuery		:= "SELECT "
	
	cFrom		:= " FROM " + RetSqlName(cAliasSE1) + " SE1 "
	
	cWhere		:= "WHERE "
	cWhere		+= "SE1.E1_SALDO > 0 "

	if !empty(cOrdEnte)
		cWhere		+= "AND SE1.E1_ZORDENT LIKE '%" + allTrim(cOrdEnte) + "%'"
	endif

	if !empty(cGetEmisDe)
		cWhere		+= "AND SE1.E1_EMISSAO >= '" + dToS(cGetEmisDe) + "'"
	endif

	if !empty(cGetEmisAt)
		cWhere		+= "AND SE1.E1_EMISSAO <= '" + dToS(cGetEmisAt) + "'"
	endif

	//if !empty(cGetFilial)
		//cWhere		+= "AND SE1.E1_FILIAL LIKE '%" + allTrim(cGetFilial) + "%'"
		cWhere		+= "AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
	//endif

	cWhere		+= "AND SE1.E1_ZSINIST <> 'S' "
	cWhere		+=" AND SE1.D_E_L_E_T_ <> '*' "
	cWhere		+=" ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "
	
	//cWhere		+=" AND SE1.E1_FILIAL	= '" + xFilial("SE1") + "' "

	cAliasTMP	:= GetNextAlias()
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery + cFields + cFrom + cWhere) , cAliasTMP , .F. , .T.)

	//Memowrite("C:\TEMP\MGF16.SQL", cQuery + cFields + cFrom + cWhere )	

	lRet	:= (cAliasTMP)->(!EOF())
	
	If ( lRet )
	
		cStrTran	:= "SE1."
		lExistCod	:= fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .T. , @cCodTit)
		fWBrowse1(aHeader , @aDados , oDlg , oWBrowse1 , .T.) //Atualizo o browser conforme resultset gerado pela Query
		//cOrdEnte	:= Space(10)
		aBrowse	:= aClone(aDados)
	
	Else
	
		MsgAlert('Nao existem titulos para o codigo de barras informado')
		aDados	:= Array(1,15)
		//cOrdEnte	:= Space(10)
		fWBrowse1(aHeader , aDados , oDlg , oWBrowse1 , .T.)
	
	EndIf
	
	(cAliasTMP)->(dbCloseArea())
	RestArea(aAreaSE1)

Return lRet                 


	/*
	=====================================================================================
	Programa.:              fMontaDados
	Autor....:              Roberto Sidney
	Data.....:              15/09/2016
	Descricao / Objetivo:   Monta aHeader e aCols para serem exibidos na MarkBrowse
	Doc. Origem:            CRE24 - GAP MGCRE24
	Solicitante:            Cliente
	Uso......:              
	Obs......:
	=====================================================================================
	*/
	Static Function fMontaDados(cFields		,;	//Campos utilizados para montagem do aHeader (Utilizados para montagem da Query)
	cAliasTMP	,;	//Alias temporario utilizado pela Query
	aHeader		,; 	//Neste array, serao salvos os campos com os respectivos titulos, conforme definido em dicionario (SX3)
	aDados		,;	//Neste Array, serao retornados os dados para exibicao na markbrowse
	cStrTran	,;	//Sera utilizado para eliminar o alias temporario contido na variavel 'cFields'
	lGeraDados	,;	//Se gera o array com 'ResultSet' da Query
	cCodTit	)	//Caso o codigo de barras ja tenha sido cadastrado, retorna o titulo e informa ao usuario

	Local nLen		:= 0
	Local nReg		:= 0
	Local nY		:= 0
	Local cNameField:= ""
	Local nX		:= 0
	Local aHeadTMP	:= {}
	Local xConverte	:= NIL
	Local nPosCodBar:= 0
	Local nPosCodDig:= 0
	Local nPosCodTit:= 0
	Local lExistCod	:= .F.

	DEFAULT aHeader	:= {}

	aHeader	:= StrToKarr(StrTran(cFields , cStrTran , "") , ',')
	//Armazena em 'aHeader' os campos contidos em cFields, eliminando o alias gerado para query (ex.: SE1.E1_OK, e' alterado para E1_OK)

	nLen	:= Len(aHeader)
	// Desconsiderar a ultima posicao por tratar-se do RECNO, que sera' utilizado para indicar qual registro sera' gravado.

	nPosCodTit	:= Ascan(aHeader , " E1_NUM")

	If ( lGeraDados )

		If ( Len(aDados) > 0 )

			aDados	:= Array(1,nLen)

		EndIf

		Do While (cAliasTMP)->(!EOF())
			//Grava em aDados o conteudo do alias temporario gerado atraves da query, para exibicao na markbrowse
			++nReg

			aDados[nReg]	:= Array(nLen) // Posicao adicional criada para armazenar '.F.' (exibir no browse como desmarcado)

			For nY := 1 TO nLen

				If ( nY == 1 )

					aDados[nReg , nY] := .F.

				Else

					If !( nY == nLen )
						//A ultima posicao de 'aHeader' refere-se ao Recno, portanto, nao preencher com o titulo (conforme dicionario).

						aDados[nReg , nY] := FieldGet((cAliasTMP)->(FieldPos(AllTrim(aHeader[nY]))))

						if ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'N')

							xConverte	:= Transform(aDados[nReg , nY] ,"@E 999,999,999.99")

							aDados[nReg , nY]	:= xConverte

						elseif ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'D' )

							xConverte	:= sToD(aDados[nReg , nY])

							aDados[nReg , nY]	:= xConverte

						Endif

					Else

						aDados[nReg , nY] := (cAliasTMP)->(REGISTRO)

					EndIf

				EndIf

			Next

			(cAliasTMP)->(dbSkip())

			If ((cAliasTMP)->(!EOF()))

				AADD(aDados , {} )

			EndIf

		EndDo

	Else

		aDados	:= Array(1 , nLen)

	EndIf

	aHeadTMP	:= Array(nLen)

	For nX := 1 TO nLen
		//Substitui o conteudo de aHeader pelo titulo contido no dicionario (SX3). Ex.: E1_PREFIXO e' alterado para 'Prefixo'.

		If ( nX == 1 )

			aHeadTMP[nX] := ''

		Else

			cNameField	:= AllTrim(RetTitle(AllTrim(aHeader[nX])))

			aHeadTMP[nX] := cNameField

		EndIf

	Next nX

	aHeader	:= aClone(aHeadTMP)

Return lExistCod


/*
=====================================================================================
Programa.:              fVldGrava
Autor....:              Roberto Sidney
Data.....:              19/09/2016
Descricao / Objetivo:   Verifica a quantidade de titulos selecionados.
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fVldGrava(aHeader , aDados , oDlg , oWBrowse1 , cOrdEnte , lLimpaSel , lOrdEntre)

	Local lContinua	 := .F.
	Local nLen		 := 0
	Local nReg		 := 0
	Local nPos       := 0
	Local nGrv       := 0
	Private _nRegTit := 0
	Private aTitulos := {}

	_cProcSini := strzero(val(Soma1(GetMv("MGF_PROSIN"))),TAMSX3("E1_ZPRCSIN")[1]) // Sequencial no numero de processo de sinistro

	cSomaT := ""
	cQtdeT := ""

	If !(lLimpaSel)

		aTitulos	:= aClone(OWBROWSE1:AARRAY)

		If ( MsgYesNo("Confirma geracao ?" , "Geracao de sinistro") )

			lContinua	:= fVldSel(aTitulos , @nReg, cOrdEnte )

			If ( lContinua )
				For nPos := 1 to len(aTitulos)
					if aTitulos[nPos,1] = .T.
						_nRegTit  := nPos
						_cChvPesq := aTitulos[nPos,2]+aTitulos[nPos,3]+aTitulos[nPos,4]+aTitulos[nPos,5]+aTitulos[nPos,6]+aTitulos[nPos,9]+aTitulos[nPos,10]
						// Carrega variaveis
						_cFil	  := aTitulos[_nRegTit,2]
						_cPrefixo := aTitulos[_nRegTit,3]
						_cTitulo  := aTitulos[_nRegTit,4]
						_cParcela := aTitulos[_nRegTit,5]
						_cTipo    := aTitulos[_nRegTit,6]
						_cCodCli  := aTitulos[_nRegTit,9]
						_cLojaCli := aTitulos[_nRegTit,10]
                              
						Begin Transaction // gresele 19/05/17
						
						// Atualiza o titulo com as informacoes referentes ao sinistro
						fGrava(_cChvPesq , lOrdEntre)
						
						End Transaction
						
					Endif
				Next nPos

				//u_Cria_TRB()
				//u_Monta_TRB("S")
				Cria_TRB()

				PutMv("MGF_PROSIN",_cProcSini)
				MsgInfo("Processo de sinistro: "+alltrim(_cProcSini),"Atencao")

				//- Limpa e reinicia o browse para as proximas pesquisas
				cOrdEnte	:= Space(10)
				nLen		:= Len(aHeader)
				aDados		:= Array(1 , 15)

				fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

			EndIf

		Else

			nLen		:= Len(aHeader)
			aDados		:= Array(1 , 15)
			cOrdEnte	:= Space(10)

			fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

		EndIf

	Else

		nLen		:= Len(aHeader)
		aDados		:= Array(1 , 15)
		cOrdEnte	:= Space(10)

		fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

	EndIf

Return              

//----------------------------------------------------
// Executa gravacao na ZZ8 - CADASTRO DE INTERACAO
//----------------------------------------------------
static function recZZB()
	local aArea		:= getArea()
	local aAreaZZB	:= ZZB->(getArea())
	Local cCodPos := GetMv("MGF_CODPOS",,"")
	Local lGrvPos := .F.
	
	ZZ9->(dbSetOrder(1))
	ZZ9->(dbSeek(xFilial("ZZ9")+cCodPos))
	If ZZ9->(Found())
		lGrvPos := .T.
	Else
		APMsgStop("Codigo da Posicao do Cliente cadastrado no parametro 'MGF_CODPOS' nao esta cadastrado no sistema."+CRLF+;
		"Codigo cadastrado no parametro: "+cCodPos)	
	Endif	
	
	DBSelectArea("ZZB")

	recLock("ZZB", .T.)
		ZZB->ZZB_FILIAL := xFilial("ZZB") //iif(!empty(xFilial("ZZB")), _cFil, xFilial("ZZB")) // gresele 19/05/17
		ZZB->ZZB_FILORI	:= SE1->E1_FILIAL
		ZZB->ZZB_PREFIX	:= SE1->E1_PREFIXO
		ZZB->ZZB_NUM   	:= SE1->E1_NUM
		ZZB->ZZB_PARCEL	:= SE1->E1_PARCELA
		ZZB->ZZB_TIPO  	:= SE1->E1_TIPO
		ZZB->ZZB_USUARI	:= allTrim(retCodUsr())
		ZZB->ZZB_VALCAR := SE1->E1_VALOR
		ZZB->ZZB_DATA	:= dDataBase // gresele 17/05/19
		ZZB->ZZB_HORA 	:= Time() // gresele 17/05/19
		If lGrvPos
			ZZB->ZZB_CODPOS := cCodPos
		Endif	
	ZZB->(MSUnlock())

	ZZB->(DBCloseArea())

	restArea(aAreaZZB)
	restArea(aArea)
return

/*
=====================================================================================
Programa.:              fVldSel
Autor....:              Roberto Sidney
Data.....:              19/09/2016
Descricao / Objetivo:   Verifica a quantidade de titulos selecionados.
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fVldSel(aDados,nReg,cOrdEnte)

	Local nX		:= 0
	Local nLen		:= 0
	Local nCount	:= 0
	Local lRet		:= .F.
	Local nPosReg	:= 0

	nLen	:= Len(aDados)

	nPosReg	:= Len(aDados[1]) //Retorna posicao referente ao Recno

	Do While ( ++nX <= nLen .AND. (nCount <= 2) )

		If ( (aDados[nX , 1]) .AND. !(ValType(aDados[nX , 2]) == "U") ) // Item selecionado sem pesquisa do codigo de barras. Prevencao de gravacao incorreta.

			++nCount

			nReg		:= aDados[nX , nPosReg]

		EndIf

	EndDo

	if ( nCount == 0 )

		ShowHelpDlg("NOTIT", {"Nao localizado titulos para O.E:"+cOrdEnte,""},3,;
		{"Informe uma O.E valida.",""},3)

	Else
		lRet	:= .T.
	Endif

Return lRet

/*
=====================================================================================
Programa.:              fGrava
Autor....:              Roberto Sidney
Data.....:              19/09/2016
Descricao / Objetivo:   Atualiza o campo E1_CODBAR
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fGrava(_cChaveSE1 , lOrdEntre)

	Local cAliasSE1	:= ""
	Local aAreaSE1	:= {}    
	Local nPosCods  := 0
	Local _cChave2  := _cCodCli+_cLojaCli+_cPrefixo+_cTitulo+_cParcela+_cTipo 

	aAreaSE1 := SE1->(GetArea())

	DbSelectArea("SE1")
	DbSetOrder(2) 

	IF SE1->(DbSeek(_cFil+_cChave2))

		//nPosCods := Ascan(_aAux,{|x| x[1]==SE1->E1_PORTADO})  //pesquisar por portador BCO
		//IF nPosCods <> 0
		//   _cOcorren := _aAux[3]    // 2-  10 - Sinistro
		//ENDIF
		IF SE1->E1_NUMBOR <> ''
			DbSelectArea("ZA6")
			DbSetOrder(1)
			IF ZA6->(DbSeek(xFilial("ZA6")+SE1->E1_PORTADO+"S"))  
				_cOcorren := ZA6->ZA6_OCOR 
				//ELSE    
				//   alert("Ocorrencia nao encontrada. ")
			ENDIF
		ENDIF

		_cSituaca := aSituaca[2] // 2 - K  - Sinistro	

		If (RecLock("SE1" , .F.))

			//_cBordero := ''
			//IF SE1->(DbSeek(_cChaveSE1))
			_cBordero  := IIF(!Empty(SE1->E1_NUMBOR),SE1->E1_NUMBOR,'')
			_cIDCNAB   := IIF(!Empty(SE1->E1_IDCNAB),SE1->E1_IDCNAB,'')
			_cChaveSEA := 	SE1->E1_NUMBOR+"R"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO//+SE1->E1_CLIENTE+SE1->E1_LOJA
			IF _cBordero = ' '
				SE1->E1_OCORREN := '01'
				SE1->E1_INSTR1  := '01'
			ELSE
				Reclock("SE1",.F.)
				SE1->E1_ZSINIST := 'S'
				SE1->E1_ZPRCSIN := _cProcSini
				SE1->E1_SITUACA := _cSituaca
				SE1->E1_OCORREN := _cOcorren
				SE1->(MsUnlock())
			ENDIF
			//Endif

			// Atualiza situacao de cobranca do bordero
			u_JusInstCob(_cOcorren,_cBordero,.T.)

			// Ajusta a instru��o de cobra�a do titulo
			// Gera uma nova ocorrencia de cobranca caso o envio ja tenha ocorrido
			IF _cIDCNAB <> ''
				u_JusInstCob(_cOcorren,_cBordero,.F.)
			Endif

			recZZB()
		Endif
		// Atualiza parametro de controle do numero do sinistro
	Endif

	RestArea(aAreaSE1)

Return

/*
=====================================================================================
Programa.:              CancSin
Autor....:              Barbieri
Data.....:              23/12/2016
Descricao / Objetivo:   Cancela Registro do Sinistro
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function CancSin()

	Local aAreaSE1	:= GetArea()
	Local lCancRegS  := .F.    

	DbSelectArea("SE1")
	DbSetOrder(1)
	If SE1->(MsSeek(xFilial("SE1") + TRB->RB_PREFIXO + TRB->RB_NUM + TRB->RB_PARCELA + TRB->RB_TIPO))
		If !MsgYesNo("Deseja confirmar o cancelamento do registro de sinistro?")
			lCancRegS := .T.
			MsgInfo("Cancelamento de Registro de Sinistro nao efetuado!","Atencao")
		Endif
		If !lCancRegS 	
			SE1->(RecLock("SE1" , .F.))
			SE1->E1_ZSINIST := 'N'
			SE1->E1_ZPRCSIN := Space(10)
			SE1->E1_SITUACA := '0'
			SE1->E1_OCORREN := '01'
			SE1->(Msunlock())
			SE1->(DbSkip())
			
			ZZB->(dbSetOrder(1))
			If ZZB->(dbSeek(xFilial("ZZB")+xFilial("ZZB")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
				ZZB->(RecLock("ZZB",.F.))
				ZZB->(dbDelete())
				ZZB->(MsUnLock())
			Endif
				
			MsgInfo("Registro de Sinistro Cancelado para o titulo "+TRB->RB_NUM+TRB->RB_PARCELA+"!","Atencao")
		Endif
	Endif
	RestArea(aAreaSE1)
	Cria_TRB()

Return

/*
=====================================================================================
Programa.:              CPOSINIS
Autor....:              Roberto Sidney
Data.....:              19/09/2016
Descricao / Objetivo:   Cria estrutura de campos para o browse
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function CPOSINIS()
	aCampos := {}

	AADD(aCampos,{"Sinistro"		, "RB_FILIAL"   ,"C",06,0,}) //Barbieri: Alterar na Marfrig para tamanho 6
	AADD(aCampos,{"Filial"			, "RB_ZSINIST"  ,"C",03,0,})
	AADD(aCampos,{"Prefixo"			, "RB_PREFIXO"  ,"C",03,0,}) 
	AADD(aCampos,{"Numero"			, "RB_NUM"      ,"C",09,0,})
	AADD(aCampos,{"Parcela"			, "RB_PARCELA"  ,"C",02,0,}) //Barbieri: Alterar na Marfrig para tamanho 2
	AADD(aCampos,{"Tipo"			, "RB_TIPO"     ,"C",03,0,})
	AADD(aCampos,{"Ord. Embarque"	, "RB_ZORDENT"  ,"C",10,0,})
	AADD(aCampos,{"Proc. Sinistro"	, "RB_ZPRCSIN"  ,"C",10,0,})
	AADD(aCampos,{"Natureza"		, "RB_NATUREZ"  ,"C",10,0,})
	AADD(aCampos,{"Cliente"			, "RB_CLIENTE"  ,"C",06,0,})
	AADD(aCampos,{"Loja"			, "RB_LOJA"     ,"C",02,0,})
	AADD(aCampos,{"Nome"			, "RB_NOMCLI"   ,"C",20,0,})
	AADD(aCampos,{"Banco"			, "RB_PORTADO"  ,"C",03,0,})
	AADD(aCampos,{"Emisss�o"		, "RB_EMISSAO"  ,"D",08,0,})
	AADD(aCampos,{"Vencimento"		, "RB_VENCTO"   ,"D",08,0,}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aCampos,{"Venc. Real"		, "RB_VENCREA"  ,"D",08,0,}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aCampos,{"Valor"			, "RB_VALOR"    ,"N",16,2,})
	AADD(aCampos,{"Dt. Baixa"		, "RB_BAIXA"    ,"D",08,0,})
	AADD(aCampos,{"Bordero"			, "RB_NUMBOR"   ,"C",06,0,})
	AADD(aCampos,{"Dt. Bordero"		, "RB_DATABOR"  ,"D",08,2,})
	AADD(aCampos,{"Historico"		, "RB_HIST"     ,"C",25,0,})
	AADD(aCampos,{"Situa��o"		, "RB_SITUACA"  ,"C",01,0,})
	AADD(aCampos,{"Ocor. Bancaria"	, "RB_OCORREN"  ,"C",02,0,})
	AADD(aCampos,{"Saldo"			, "RB_SALDO"    ,"N",16,2,})
	AADD(aCampos,{"Pedido"			, "RB_PEDIDO"   ,"C",06,0,})
	AADD(aCampos,{"Nota Fiscal"		, "RB_NUMNOTA"  ,"C",09,0,})
	AADD(aCampos,{"Serie"			, "RB_SERIE"    ,"C",03,0,})
	AADD(aCampos,{"ID CNAB"			, "RB_IDCNAB"   ,"C",10,0,})
	/*
[n][1]=>Descricao do campo
[n][2]=>Nome do campo
[n][3]=>Tipo
[n][4]=>Tamanho
[n][5]=>Decimal
[n][6]=>Picture
	*/
Return(aCampos)


/*
=====================================================================================
Programa.:              JusInstCob
Autor....:              Roberto Sidney
Data.....:              10/10/201
Descricao / Objetivo:   Ajusta a situacao de cobran do titulo
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function JusInstCob(_cOcorren,_cBordero,lBord)
	LOCAL _cVALANT 

	if lBord
		// Verifica se h� bordero
		//IF _cBordero <> ''
		IF SE1->E1_NUMBOR <> ' '	
			// Atualiza caso tenha bordero as informacoes referentes ao sinistro
			DbSelectarea("SEA")
			DbSetOrder(2)
			//IF ! SEA->(DbSeek(iif(!empty(xFilial("SEA")), _cFil, xFilial("SEA"))+_cChaveSEA)) // retirado por gresele em 18/05/17, pois compartilhamento da tabela SE1 e SEA sao
			// diferentes, desta forma, nao funciona fazer o seek na SEA pela variavel _cfil, que eh a filial da se1.
			IF ! SEA->(DbSeek(xFilial("SEA")+_cChaveSEA))			
				alert("Bordero "+alltrim(_cBordero) + " nao localizado")
			Else
				_cVALANT := SEA->EA_OCORR
				_cSitAnt := SEA->EA_SITUACA // Situa��o atual sera a anterior
				Reclock("SEA",.F.)
				SEA->EA_OCORR   := _cOcorren
				SEA->EA_SITUACA := _cSituaca
				SEA->EA_SITUANT := _cSitAnt
				MsUnlock()
			Endif
		Endif

	Else                  
		IF FUNNAME() <> "MGFFIN16"                       
			DbSelectArea("ZA6")
			DbSetOrder(1)
			IF ZA6->(DbSeek(iif(!empty(xFilial("ZA6")), _cFil, xFilial("ZA6"))+SE1->E1_PORTADO+"P"))  
				_cOcorren := ZA6->ZA6_OCOR
				_cBordero := SE1->E1_NUMBOR 
			ENDIF    
		ENDIF
		// Atualiza situacao de cobranca
		DBSELECTAREA("FI2")
		DBSETORDER(1) //FILIAL+CARTEIRA+BORDERO+PREFIXO+TITULO+PARCELA+TIPO+CLIENTE+LOJA 
		DBSEEK(iif(!empty(xFilial("FI2")), _cFil, xFilial("FI2"))+SE1->E1_NUMCART+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)                
		//_cVALANT := 	FI2->FI2_VALNOV

		DbSelectArea("FI2")
		RecLock("FI2",.T.)
		FI2->FI2_FILIAL  := iif(!empty(xFilial("FI2")), _cFil, xFilial("FI2"))
		FI2->FI2_CARTEI := _cSituaca
		FI2->FI2_NUMBOR := _cBordero
		FI2->FI2_PREFIX := SE1->E1_PREFIXO //_cPrefixo
		FI2->FI2_TITULO := SE1->E1_NUM     //_cTitulo
		FI2->FI2_PARCEL := SE1->E1_PARCELA //_cParcela
		FI2->FI2_TIPO   := SE1->E1_TIPO    //_cTipo
		FI2->FI2_CODCLI := SE1->E1_CLIENTE //_cCodCli
		FI2->FI2_LOJCLI := SE1->E1_LOJA    //_cLojaCli
		FI2->FI2_DTOCOR := Date()
		FI2->FI2_DTGER  := Date()
		FI2->FI2_OCORR  := ZA6->ZA6_OCOR        // Codigo da ocorrencia 
		FI2->FI2_DESCOC := ZA6->ZA6_DESCR  //- Descricao da Ocorrencia do Sinistro
		FI2->FI2_GERADO := '2'             // Ocorrencia nao enviada ao banco 
		FI2->FI2_VALANT := _cVALANT        // SE1->E1_OCORREN
		FI2->FI2_VALNOV := _cOcorren
		FI2->FI2_CAMPO  := "E1_OCORREN"
		FI2->(MsUnlock())
	Endif

Return


// valida marcacao da linha
Static Function MarkFin16(aBrowse,oWBrowse1)

Local lRet := .T.
Local cOrdEmb := ""
Local nI := 0
Local nLinha := oWBrowse1:nAt

// verifica se marcou mais de uma ordem de embarque diferente
For nI:=1 To Len(aBrowse)
	If aBrowse[nI,1] .or. (nI == nLinha .and. !aBrowse[nI,1])/*linha estah sendo marcada agora*/
		If cOrdEmb != aBrowse[nI,7] .and. !Empty(cOrdEmb)
			APMsgStop("Ordens de Embarque marcadas com codigos diferentes."+CRLF+;
			"Escolha apenas titulos com ordens de embarque de mesmo codigo.")
			lRet := .F.
			Exit
		Endif
		cOrdEmb := aBrowse[nI,7]
	Endif	
Next

Return(lRet)
