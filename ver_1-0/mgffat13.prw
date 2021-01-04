 	//#INCLUDE "MATC070.CH"
#INCLUDE "PROTHEUS.CH"

/*
================================================================================================
Programa............: MGFFAT13
Autor...............: Marcos Andrade
Data................: 14/10/2016
Descricao / Objetivo: Ponto de entrada para trocar a chamada da tela de saldo
Doc. Origem.........: FAT08
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta especifica de saldo
=================================================================================================
*/
User Function MGFFAT13()
Private cTipoPed  := GetMV('MGF_FAT08',.F.,"NN")
Private nPosLocal := aScan(aHeader, {|x| alltrim(x[2]) == "C6_LOCAL"})

If IsInCallStack("U_MGFFATBW")
	Return
EndIf 

If !IsInCallStack("EECFATCP") .And. !IsInCallStack("U_MGFEST01") .and. !IsInCallStack("EECAP100") .And. !IsInCallStack("GRAVARCARGA") .And. ;
	!IsInCallStack("U_TAS02EECPA100") .and. !IsInCallStack("U_GravarCarga") .and. !IsInCallStack("importaPedidoVenda") .and. !IsInCallStack("U_MGFFAT51") .and. ;
	!IsInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5") .and. !IsInCallStack("U_xGravarCarga") .and. !IsInCallStack("U_xTAS02EECPA100") .and. Empty(alltrim(M->C5_PEDEXP)) .AND. ;
	!IsInCallStack("U_MGFEEC24") .and. !IsInCallStack("MATA521") .and. !IsInCallStack("MATA521A") .and. !IsInCallStack("MATA521B") .And. ;
	!IsInCallStack("U_xFAT87PED")
	dbSelectArea('SZJ')
	SZJ->(dbSetOrder(1))
	SZJ->(dbSeek(xFilial('SZJ')+M->C5_ZTIPPED))
	IF SZJ->(!EOF()) .AND. SZJ->ZJ_TAURA='S'
	    FAT13_Saldo()
	Else
	    A440Saldo(.F.,aCols[n][nPosLocal])
	EndIF
EndIF

Return (IIf(__ReadVar=="M->C6_PRODUTO",&__ReadVar,Nil))
********************************************************************************************************************************************************
Static Function FAT13_Saldo()

Local aArea			:= GetArea()
Local nPosProd		:= 0
//Local nPosDtMin		:= 0
//Local nPosDtMax		:= 0
//Local cMGFFEFO		:= SUPERGETMV("MGF_FEFO",,"FF")
Local dDataMin		:= CTOD("  /  /  ")
Local dDataMax		:= CTOD("  /  /  ")
Local lRet			:= .T.
Local bFEFO     	:= .F.
Local aRet      	:= {}
local cB1Cod		:= ""
local cC5TipPed		:= ""
local cC5Cli		:= ""
local cC5LojaCli	:= ""
local cC5Emissao	:= ""

private cC5Num		:= ""
private cC5FILIAL	:= ""
private nMGFDTMIN	:= 0
private nMGFDTMAX	:= 0
//private nMGFDTMIN	:= SUPERGETMV("MGF_DTMIN",,3)
//private nMGFDTMAX	:= SUPERGETMV("MGF_DTMAX",,21)

if !isInCallStack("U_MGFFAT64")
	nPosProd	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_PRODUTO"})
	//nPosDtMin	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_ZDTMIN"})
	//nPosDtMax	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_ZDTMAX"})
	cC5FILIAL	:= M->C5_FILIAL
	cB1Cod		:= aCols[n][nPosProd]
	cC5TipPed	:= M->C5_ZTIPPED
	cC5Cli		:= M->C5_CLIENTE
	cC5LojaCli	:= M->C5_LOJACLI
	cC5Emissao	:= M->C5_EMISSAO
	cC5Num		:= M->C5_NUM

	IF INCLUI
		cC5FILIAL := cFilAnt
	ENDIF
elseif isInCallStack("U_MGFFAT64")
	oModel		:= FWModelActive()
	oMdlTop		:= oModel:GetModel( 'TOP' )
	oMdlCenter	:= oModel:GetModel( 'CENTER' )
	oMdlDown	:= oModel:GetModel( 'DOWN' )

	cB1Cod		:= oMdlDown:getValue("C6_PRODUTO"	, oMdlDown:nLine)
	cC5TipPed	:= GetAdvFVal("SC5", "C5_ZTIPPED", oMdlCenter:getValue("C5_FILIAL", oMdlCenter:nLine) + oMdlCenter:getValue("C5_NUM", oMdlCenter:nLine), 1, "")
	cC5Cli		:= oMdlCenter:getValue("C5_CLIENTE"	, oMdlCenter:nLine)
	cC5LojaCli	:= oMdlCenter:getValue("C5_LOJACLI"	, oMdlCenter:nLine)
	cC5FILIAL	:= oMdlCenter:getValue("C5_FILIAL"	, oMdlCenter:nLine)
	cC5Emissao	:= oMdlCenter:getValue("C5_EMISSAO"	, oMdlCenter:nLine)
	cC5Num		:= oMdlCenter:getValue("C5_NUM"		, oMdlCenter:nLine)
endif

DbSelectArea("SB1")
DbSetOrder(1)

If !IsInCallStack("U_MGFEST01") .and. SB1->( DbSeek( xFilial("SB1") + cB1Cod ) )
	//------------------------------------------------------
	//Calcula a data minima e maxima para pedido tipo FEFO
	//------------------------------------------------------
	//If cC5TipPed $ cMGFFEFO  //.OR.  !Empty(SA1->A1_ZVIDAUT)
	If SZJ->ZJ_FEFO=="S"

		nMGFDTMIN := SZJ->ZJ_MINIMO
		nMGFDTMAX := SZJ->ZJ_MAXIMO

		If nMGFDTMIN <= 0
			MsgInfo("Na tabela SZJ (Tipo de Pedido) preencher a quantidade de dias a acrescentar a Data MINIMA para a esp�cie de pedido: "+cC5TipPed)
			lRet := .F.
		ElseIf nMGFDTMAX <= 0
			MsgInfo("Na tabela SZJ (Tipo de Pedido) preencher a quantidade de dias a acrescentar a Data MAXIMA para a esp�cie de pedido: "+cC5TipPed)
			lRet:= .F.
		Endif
		If lRet
			//dDataMin	:=	date() + nMGFDTMIN
			dDataMin	:=	dDataBase + nMGFDTMIN
			//dDataMax	:=	date() + nMGFDTMAX
			dDataMax	:=	dDataBase + nMGFDTMAX
		Endif
		bFEFO := .T.

	Else
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		//If DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
		If SA1->( DbSeek(xFilial("SA1") + cC5Cli + cC5LojaCli ) )
			//-----------------------------------------------
	    	//Verifica se cliente valida data util
	    	//-----------------------------------------------
			If SA1->A1_ZVIDAUT > 0
				//Data Minima = Data Emissao + (Vida util Cliente * Vida util Produto)
				dDataMin := cC5Emissao + ( SA1->A1_ZVIDAUT * SB1->B1_ZVLDPR )
				//Data Maxima = Data Emissao + Vida util Produto
				dDataMax := cC5Emissao + ( SB1->B1_ZVLDPR )
			EndIF
		Endif
	Endif

	If lRet
		FAT13_Tela(@dDataMin,@dDataMax,bFEFO,SZJ->ZJ_COD)
	Endif

Endif
RestArea(aArea)

Return

**********************************************************************************************************************************************************
Static Function FAT13_Tela(dDataMin,dDataMax,bFEFO,cTipo)

Local oDlg
Local oBtn
Local oBold
Local oFont2
Local oFont1
Local cTpPed   := GetMV('MGF_FAT13A',.F.,"FG")
Local dVlMin   := dDataMin
Local dVlMax   := dDataMax

Local nPosDtMin		:= 0
Local nPosDtMax		:= 0

local lConfirm	:= .F.

local cFilNewStc	:= allTrim( superGetMv( "MGF_FAT13B" , , "" )  )

Private oSaldo
Private oGrp1
Private oGrp2
Private cPictQtd14 := PesqPict('SB8', 'B8_SALDO',   14)
Private aTotal     := 0
Private cProduto   := ""
Private cDescricao := ""
Private aSaldo     := {}
Private aPV        := {}
Private aPVBloq    := {}
Private aPVBloq2	:= {}
Private bCtrData   :=  .F.

If IsInCallStack("MATA410") .and. Type("aHeader") != "U"
	nPosDtMin	:= aScan( aHeader, { |x| alltrim(x[2]) == "C6_ZDTMIN" } )
	nPosDtMax	:= aScan( aHeader, { |x| alltrim(x[2]) == "C6_ZDTMAX" } )
Endif

IF bFEFO
  IF cTipo $ cTpPed
      bFEFO    := .F.
      bCtrData :=  .T.
  EndIF
EndIF

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oFont1 NAME 'Courier New' SIZE 0, -12 BOLD
oFont2:= TFont():New('Courier New',,-12,.F.)

cProduto   := SB1->B1_COD
cDescricao := SB1->B1_DESC

if cC5FILIAL $ cFilNewStc
	U_MGFFATBI( cC5FILIAL , SB1->B1_COD , dDataMin , dDataMax , .F. )
else
	FAT13_taura(cC5FILIAL,SB1->B1_COD,dDataMin,dDataMax,.F.)
endif

DEFINE MSDIALOG oDlg TITLE "Consulta de Estoque"  FROM 000, 000  TO 345, 585 COLORS 0, 16777215 PIXEL

	oGrp1      := TGroup():New( 003,003,044,290,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrp2      := TGroup():New( 045,003,164,290,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

	@ 012, 006 SAY "Dt. Minima" 	SIZE 040, 009 OF oGrp1 COLORS 0, 16777215 PIXEL
	@ 008, 050 MSGET dDataMin 		SIZE 060, 010 OF oGrp1 PICTURE "@99/99/9999"   COLORS 0, 16777215 PIXEL WHEN !bFEFO  VALID IIF(bCtrData,Val_DT(dDataMin >= dVlMin,dVlMin,dVlMax), .T.)
	@ 012, 116 SAY "Dt. Maxima" 	SIZE 040, 009 OF oGrp1 COLORS 0, 16777215 PIXEL
	@ 008, 150 MSGET dDataMax 		SIZE 060, 010 OF oGrp1  PICTURE "@99/99/9999"  COLORS 0, 16777215 PIXEL WHEN !bFEFO  VALID IIF(bCtrData,Val_DT(dDataMax <= dVlMax,dVlMin,dVlMax) , .T.)

	@ 027, 006 SAY "Produto" 		SIZE 025, 009 OF oGrp1 COLORS 0, 16777215 PIXEL
	@ 023, 050 MSGET cProduto 		SIZE 060, 010 OF oGrp1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right
	@ 023, 112 MSGET cDescricao 	SIZE 174, 010 OF oGrp1 COLORS 0, 16777215 PIXEL RIGHT When .F. Right

	if cC5FILIAL $ cFilNewStc
		oBtn := TButton():New( 009,235,'Consultar',oGrp1,{|| U_MGFFATBI( cC5FILIAL , SB1->B1_COD , dDataMin , dDataMax , .T. ) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	else
		oBtn := TButton():New( 009,235,'Consultar',oGrp1,{|| FAT13_taura(cC5FILIAL,SB1->B1_COD,dDataMin,dDataMax,.T.) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	endif

	@ 066,016  SAY "Estoque"   	      SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 062,060  MSGET   aSaldo[1]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL When .F.
	@ 080,016  SAY "Pedido de Venda"  SIZE 060, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 076,060  MSGET   aSaldo[2]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right
	@ 094,016  SAY "P.V. Bloqueado"   SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 090,060  MSGET   aSaldo[3]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right

	oBtn := TButton():New( 076,121,"...",oGrp2,{|| FAT13_PV(1) }  ,10, 012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn := TButton():New( 090,121,"...",oGrp2,{|| FAT13_PV(2)}  ,10, 012,,,.F.,.T.,.F.,,.F.,,,.F. )


	@ 122,016  SAY "Saldo"  		  SIZE 040, 009 OF oGrp2 COLOR CLR_BLUE PIXEL FONT oBold
	@ 118,060  MSGET  oSaldo VAR aSaldo[4]		  SIZE 060, 010 OF oGrp2 COLOR CLR_BLUE PIXEL RIGHT FONT oFont1 When .F. Right

	@ 049,157 SAY "Informacoes do Produto"    SIZE 120, 009 OF oGrp2 PIXEL FONT oBold COLOR CLR_RED
	@ 060,145 TO 132,146  OF oGrp2 PIXEL


	@ 066,162  SAY "Caixas"    	      SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 062,204  MSGET   aSaldo[5] 	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right
	@ 080,162  SAY "Itens p/ Caixa"   SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 076,204  MSGET   aSaldo[6]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right
	@ 094,162  SAY "Peso M�dio"       SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 090,204  MSGET   aSaldo[7]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right
	@ 108,162  SAY "Pe�as"            SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 104,204  MSGET   aSaldo[8]	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 FONT oFont2 PIXEL RIGHT When .F. Right
	@ 122,162  SAY "Unidade Medida"   SIZE 040, 009 OF oGrp2 COLORS 0, 16777215 PIXEL
	@ 118,204  MSGET   SB1->B1_UM 	  SIZE 060, 010 OF oGrp2 COLORS 0, 16777215 PIXEL RIGHT When .F. Right

	oBtn := TButton():New( 145,226,"Confirmar",oGrp2,{ || lConfirm := .T., oDLG:End() }, 50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

	if lConfirm
		If IsInCallStack("MATA410") .and. Type("aCols") != "U"
			aCols[n][nPosDtMin]	:= dDataMin
			aCols[n][nPosDtMax]	:= dDataMax
		Endif
	endif

Return
******************************************************************************************************************************************************8
Static Function FAT13_Taura(cC5FILIAL,cB1COD,dDataMin,dDataMax, bRefresh)

Local aRet     := {}
Local nEstoque := Randomize(0,1000)
Local nPV      := 0
Local nPVBloq  := 0
Local cQuery   := ''
Local aRec     := {}

Local aRet2		:= {}
Local nPV2		:= 0
Local nPVBloq2	:= 0

if !isInCallStack("U_MGFFAT64")
	IF INCLUI
	    cC5FILIAL := cFilAnt
	ENDIF
endif

aPV        := {}
aPVBloq    := {}


//if M->C5_ZTIPPED == "VE" .OR. M->C5_ZTIPPED == "MI"
if SZJ->ZJ_FEFO <> 'S'
	// Primeiro consulta saldo em VE

	if !empty( dDataMin ) .and. !empty( dDataMax )
		Processa( { || U_MGFTAE21( @aRet, cC5FILIAL, SB1->B1_COD, .T., dDataMin, dDataMax ) }, "Processando Consulta...", "Consultando Saldo no Taura...", .F. )
	else
		Processa( { || U_MGFTAE21( @aRet, cC5FILIAL, SB1->B1_COD, .F., dDataMin, dDataMax ) }, "Processando Consulta...", "Consultando Saldo no Taura...", .F. )
	endif

	aPV        := {}
	aPVBloq    := {}
	cQuery  := " Select C6_QTDVEN,C6_QTDENT,C6_NUM,C6_ITEM,C6_CLI,C6_LOJA,A1_NOME,C6_TES,C5_FECENT, C5_ZBLQRGA"
	cQuery  += " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SA1") + " A1, " + RetSqlName("SC5") + " C5," + RetSqlName("SF4") + "  F4"
	cQuery  += " WHERE"
	cQuery  += "	  C5.D_E_L_E_T_ =' '"
	cQuery  += "  AND A1.D_E_L_E_T_ =' '"
	cQuery  += "  AND C6.D_E_L_E_T_ =' '"
	cQuery  += "  AND F4.D_E_L_E_T_ =' '"
	cQuery	+= "  AND C6_TES = F4_CODIGO"
	cQuery	+= "  AND C6_QTDENT =0 " // Alteracao Carneiro 05/09 s� pedidos ainda nao entregues
	cQuery	+= "  AND F4.F4_ESTOQUE = 'S'"
	cQuery  += "  AND C6.C6_FILIAL = C5.C5_FILIAL"
	cQuery  += "  AND C6.C6_NUM = C5.C5_NUM"
	cQuery  += "  AND C6.C6_CLI = A1.A1_COD"
	cQuery  += "  AND C6.C6_LOJA = A1.A1_LOJA"
	cQuery  += "  AND C6_PRODUTO='"+cB1COD+"'"
	cQuery  += "  AND C6_FILIAL='"+cC5FILIAL+"'"
	cQuery  += "  AND C6_NUM <>'"+cC5Num+"'"

	cQuery  += "  AND C6_NOTA	=	'         '"
	cQuery  += "  AND C6_BLQ	<>	'R'"

	IF !Empty( dDataMin ) .And. !Empty( dDataMax )
		cQuery  += " AND"
		cQuery  += "     ("
		cQuery  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQuery  += "         OR"
		cQuery  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQuery  += "     )"
	endif

	cQuery  += "  ORDER BY  C6_NUM,C6_ITEM "

	//Memowrite("C:\TEMP\MGFFAT13.sql",cQuery)

	If Select("QRY_SC6") > 0
		QRY_SC6->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SC6",.T.,.F.)

	dbSelectArea("QRY_SC6")
	QRY_SC6->(dbGoTop())
	nPV := 0
	nPVBloq := 0
	While  !QRY_SC6->(EOF())
	    aRec     := {}
	    AAdd(aRec,QRY_SC6->C6_NUM)
	    AAdd(aRec,QRY_SC6->C6_ITEM)
	    AAdd(aRec,QRY_SC6->C6_CLI)
	    AAdd(aRec,QRY_SC6->C6_LOJA)
	    AAdd(aRec,QRY_SC6->A1_NOME)
	    AAdd(aRec,QRY_SC6->C6_TES)
	    AAdd(aRec,STOD(QRY_SC6->C5_FECENT))
	    AAdd(aRec,QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    nPV += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    AAdd(aPV,aRec)
	    IF QRY_SC6->C5_ZBLQRGA == 'B'
	       nPVBloq  += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	       AAdd(aPVBloq,aRec)
	    ENDIF
	    QRY_SC6->(dbSkip())
	End

	If Select("QRY_SC6") > 0      //Incluido condicao de data de emissao
		QRY_SC6->(dbCloseArea())
	EndIf

	aSaldo := {0,0,0,0,0,0,0,0}
	aSaldo[1]  := Transform( aRet[1]  			, cPictQtd14 )
	aSaldo[2]  := Transform( nPV      			, cPictQtd14 )
	aSaldo[3]  := Transform( nPVBloq  			, cPictQtd14 )
	aSaldo[4]  := Transform( aRet[1] - nPV		, cPictQtd14 )
	aSaldo[5]  := Transform( aRet[2]			, cPictQtd14 )
	aSaldo[6]  := Transform( aRet[3] / aRet[2]	, cPictQtd14 )
	aSaldo[7]  := Transform( aRet[1] / aRet[2]	, cPictQtd14 )
	aSaldo[8]  := Transform( aRet[3]			, cPictQtd14 )

	// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
	IF !Empty( dDataMin ) .And. !Empty( dDataMax )
		aRet2 := {}
		Processa( { || U_MGFTAE21( @aRet2, cC5FILIAL, SB1->B1_COD, .F., dDataMin, dDataMax ) }, "Processando Consulta...", "Consultando Saldo no Taura...", .F. )

		aPV			:= {}
		//aPVBloq		:= {}
		aPVBloq2	:= {}

		cQuery  := " Select C6_QTDVEN,C6_QTDENT,C6_NUM,C6_ITEM,C6_CLI,C6_LOJA,A1_NOME,C6_TES,C5_FECENT, C5_ZBLQRGA"
		cQuery  += " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SA1") + " A1, " + RetSqlName("SC5") + " C5," + RetSqlName("SF4") + "  F4"
		cQuery  += " WHERE"
		cQuery  += "	  C5.D_E_L_E_T_ =' '"
		cQuery  += "  AND A1.D_E_L_E_T_ =' '"
		cQuery  += "  AND C6.D_E_L_E_T_ =' '"
		cQuery  += "  AND F4.D_E_L_E_T_ =' '"
		cQuery	+= "  AND C6_TES = F4_CODIGO"
		cQuery	+= "  AND F4.F4_ESTOQUE = 'S'"
		cQuery  += "  AND C6.C6_FILIAL = C5.C5_FILIAL"
		cQuery  += "  AND C6.C6_NUM = C5.C5_NUM"
		cQuery  += "  AND C6.C6_CLI = A1.A1_COD"
		cQuery  += "  AND C6.C6_LOJA = A1.A1_LOJA"
		cQuery  += "  AND C6_PRODUTO='"+cB1COD+"'"
		cQuery  += "  AND C6_FILIAL='"+cC5FILIAL+"'"
		cQuery  += "  AND C6_NUM <>'"+cC5Num+"'"
		cQuery	+= "  AND C6_QTDENT =0 " // Alteracao Carneiro 05/09 s� pedidos ainda nao entregues


		cQuery  += "  AND C6_NOTA	=	'         '"
		cQuery  += "  AND C6_BLQ	<>	'R'"

		cQuery  += "  ORDER BY  C6_NUM,C6_ITEM "

		//Memowrite("C:\TEMP\MGFFAT13.sql",cQuery)

		If Select("QRY_SC6") > 0
			QRY_SC6->(dbCloseArea())
		EndIf

		//cQuery  := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SC6",.T.,.F.)

		dbSelectArea("QRY_SC6")
		QRY_SC6->(dbGoTop())
		nPV2 := 0
		nPVBloq2 := 0
		While  !QRY_SC6->(EOF())
		    aRec     := {}
		    AAdd(aRec,QRY_SC6->C6_NUM)
		    AAdd(aRec,QRY_SC6->C6_ITEM)
		    AAdd(aRec,QRY_SC6->C6_CLI)
		    AAdd(aRec,QRY_SC6->C6_LOJA)
		    AAdd(aRec,QRY_SC6->A1_NOME)
		    AAdd(aRec,QRY_SC6->C6_TES)
		    AAdd(aRec,STOD(QRY_SC6->C5_FECENT))
		    AAdd(aRec,QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
		    nPV2 += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
		    AAdd(aPV,aRec)
		    IF QRY_SC6->C5_ZBLQRGA == 'B'
		       nPVBloq2  += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
		       AAdd(aPVBloq2,aRec)
		    ENDIF
		    QRY_SC6->(dbSkip())
		End

		If Select("QRY_SC6") > 0      //Incluido condicao de data de emissao
			QRY_SC6->(dbCloseArea())
		EndIf

		/*
		aRet	- VE com Data
		aRet2	- VE sem Data
		*/

		// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
		if ( aRet[1] - nPV ) > ( aRet2[1] - nPV2 )
			aSaldo := {0,0,0,0,0,0,0,0}
			aSaldo[1]  := Transform( aRet2[1]  				, cPictQtd14 )
			aSaldo[2]  := Transform( nPV2      				, cPictQtd14 )
			aSaldo[3]  := Transform( nPVBloq2 				, cPictQtd14 )
			aSaldo[4]  := Transform( aRet2[1] - nPV2		, cPictQtd14 )
			aSaldo[5]  := Transform( aRet2[2]				, cPictQtd14 )
			aSaldo[6]  := Transform( aRet2[3] / aRet2[2]	, cPictQtd14 )
			aSaldo[7]  := Transform( aRet2[1] / aRet2[2]	, cPictQtd14 )
			aSaldo[8]  := Transform( aRet2[3]				, cPictQtd14 )

			aPVBloq		:= {}
			aPVBloq		:= aClone( aPVBloq2 )
			aPVBloq2	:= {}
		else
			aSaldo := {0,0,0,0,0,0,0,0}
			aSaldo[1]  := Transform( aRet[1]  			, cPictQtd14 )
			aSaldo[2]  := Transform( nPV      			, cPictQtd14 )
			aSaldo[3]  := Transform( nPVBloq  			, cPictQtd14 )
			aSaldo[4]  := Transform( aRet[1] - nPV		, cPictQtd14 )
			aSaldo[5]  := Transform( aRet[2]			, cPictQtd14 )
			aSaldo[6]  := Transform( aRet[3] / aRet[2]	, cPictQtd14 )
			aSaldo[7]  := Transform( aRet[1] / aRet[2]	, cPictQtd14 )
			aSaldo[8]  := Transform( aRet[3]			, cPictQtd14 )

			aPVBloq2	:= {}
		endif

	ENDIF
else
	// Primeiro consulta saldo em VE
	Processa( { || U_MGFTAE21( @aRet, cC5FILIAL, SB1->B1_COD, .F., dDataMin, dDataMax ) }, "Processando Consulta...", "Consultando Saldo no Taura...", .F. )

	// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
	// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

	aPV        := {}
	aPVBloq    := {}
	cQuery  := " Select C6_QTDVEN,C6_QTDENT,C6_NUM,C6_ITEM,C6_CLI,C6_LOJA,A1_NOME,C6_TES,C5_FECENT, C5_ZBLQRGA"
	cQuery  += " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SA1") + " A1, " + RetSqlName("SC5") + " C5," + RetSqlName("SF4") + "  F4"
	cQuery  += " WHERE"
	cQuery  += "	  C5.D_E_L_E_T_ =' '"
	cQuery  += "  AND A1.D_E_L_E_T_ =' '"
	cQuery  += "  AND C6.D_E_L_E_T_ =' '"
	cQuery  += "  AND F4.D_E_L_E_T_ =' '"
	cQuery	+= "  AND C6_TES = F4_CODIGO"
	cQuery	+= "  AND F4.F4_ESTOQUE = 'S'"
	cQuery  += "  AND C6.C6_FILIAL = C5.C5_FILIAL"
	cQuery  += "  AND C6.C6_NUM = C5.C5_NUM"
	cQuery  += "  AND C6.C6_CLI = A1.A1_COD"
	cQuery  += "  AND C6.C6_LOJA = A1.A1_LOJA"
	cQuery  += "  AND C6_PRODUTO='"+cB1COD+"'"
	cQuery  += "  AND C6_FILIAL='"+cC5FILIAL+"'"
	cQuery  += "  AND C6_NUM <>'"+cC5Num+"'"
	cQuery	+= "  AND C6_QTDENT =0 " // Alteracao Carneiro 05/09 s� pedidos ainda nao entregues


	cQuery  += "  AND C6_NOTA	=	'         '"
	cQuery  += "  AND C6_BLQ	<>	'R'"

	cQuery  += "  ORDER BY  C6_NUM,C6_ITEM "

	//Memowrite("C:\TEMP\MGFFAT13.sql",cQuery)

	If Select("QRY_SC6") > 0
		QRY_SC6->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SC6",.T.,.F.)

	dbSelectArea("QRY_SC6")
	QRY_SC6->(dbGoTop())
	nPV := 0
	nPVBloq := 0
	While  !QRY_SC6->(EOF())
	    aRec     := {}
	    AAdd(aRec,QRY_SC6->C6_NUM)
	    AAdd(aRec,QRY_SC6->C6_ITEM)
	    AAdd(aRec,QRY_SC6->C6_CLI)
	    AAdd(aRec,QRY_SC6->C6_LOJA)
	    AAdd(aRec,QRY_SC6->A1_NOME)
	    AAdd(aRec,QRY_SC6->C6_TES)
	    AAdd(aRec,STOD(QRY_SC6->C5_FECENT))
	    AAdd(aRec,QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    nPV += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    AAdd(aPV,aRec)
	    IF QRY_SC6->C5_ZBLQRGA == 'B'
	       nPVBloq  += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	       AAdd(aPVBloq,aRec)
	    ENDIF
	    QRY_SC6->(dbSkip())
	End

	If Select("QRY_SC6") > 0      //Incluido condicao de data de emissao
		QRY_SC6->(dbCloseArea())
	EndIf

	aSaldo := {0,0,0,0,0,0,0,0}
	aSaldo[1]  := Transform( aRet[1]  			, cPictQtd14 )
	aSaldo[2]  := Transform( nPV      			, cPictQtd14 )
	aSaldo[3]  := Transform( nPVBloq  			, cPictQtd14 )
	aSaldo[4]  := Transform( aRet[1] - nPV		, cPictQtd14 )
	aSaldo[5]  := Transform( aRet[2]			, cPictQtd14 )
	aSaldo[6]  := Transform( aRet[3] / aRet[2]	, cPictQtd14 )
	aSaldo[7]  := Transform( aRet[1] / aRet[2]	, cPictQtd14 )
	aSaldo[8]  := Transform( aRet[3]			, cPictQtd14 )

	// DEPOIS CONSULTA FF
	aRet2 := {}
	Processa( { || U_MGFTAE21( @aRet2, cC5FILIAL, SB1->B1_COD, .T., dDataMin, dDataMax ) }, "Processando Consulta...", "Consultando Saldo no Taura...", .F. )

	aPV        := {}
	aPVBloq    := {}
	cQuery  := " Select C6_QTDVEN,C6_QTDENT,C6_NUM,C6_ITEM,C6_CLI,C6_LOJA,A1_NOME,C6_TES,C5_FECENT, C5_ZBLQRGA"
	cQuery  += " FROM " + RetSqlName("SC6") + " C6, " + RetSqlName("SA1") + " A1, " + RetSqlName("SC5") + " C5," + RetSqlName("SF4") + "  F4"
	cQuery  += " WHERE"
	cQuery  += "	  C5.D_E_L_E_T_ =' '"
	cQuery  += "  AND A1.D_E_L_E_T_ =' '"
	cQuery  += "  AND C6.D_E_L_E_T_ =' '"
	cQuery  += "  AND F4.D_E_L_E_T_ =' '"
	cQuery	+= "  AND C6_TES = F4_CODIGO"
	cQuery	+= "  AND F4.F4_ESTOQUE = 'S'"
	cQuery  += "  AND C6.C6_FILIAL = C5.C5_FILIAL"
	cQuery  += "  AND C6.C6_NUM = C5.C5_NUM"
	cQuery  += "  AND C6.C6_CLI = A1.A1_COD"
	cQuery  += "  AND C6.C6_LOJA = A1.A1_LOJA"
	cQuery  += "  AND C6_PRODUTO='"+cB1COD+"'"
	cQuery  += "  AND C6_FILIAL='"+cC5FILIAL+"'"
	cQuery  += "  AND C6_NUM <>'"+cC5Num+"'"
	cQuery	+= "  AND C6_QTDENT =0 " // Alteracao Carneiro 05/09 s� pedidos ainda nao entregues

	cQuery  += "  AND C6_NOTA	=	'         '"
	cQuery  += "  AND C6_BLQ	<>	'R'"

	IF !Empty( dDataMin ) .And. !Empty( dDataMax )
		cQuery  += " AND"
		cQuery  += "     ("
		cQuery  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQuery  += "         OR"
		cQuery  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQuery  += "     )"
	endif

	cQuery  += "  ORDER BY  C6_NUM,C6_ITEM "

	//Memowrite("C:\TEMP\MGFFAT13.sql",cQuery)

	If Select("QRY_SC6") > 0
		QRY_SC6->(dbCloseArea())
	EndIf

	//cQuery  := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SC6",.T.,.F.)

	dbSelectArea("QRY_SC6")
	QRY_SC6->(dbGoTop())
	nPV2 := 0
	nPVBloq2 := 0
	aPVBloq2 := {}

	While  !QRY_SC6->(EOF())
	    aRec     := {}
	    AAdd(aRec,QRY_SC6->C6_NUM)
	    AAdd(aRec,QRY_SC6->C6_ITEM)
	    AAdd(aRec,QRY_SC6->C6_CLI)
	    AAdd(aRec,QRY_SC6->C6_LOJA)
	    AAdd(aRec,QRY_SC6->A1_NOME)
	    AAdd(aRec,QRY_SC6->C6_TES)
	    AAdd(aRec,STOD(QRY_SC6->C5_FECENT))
	    AAdd(aRec,QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    nPV2 += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	    AAdd(aPV,aRec)
	    IF QRY_SC6->C5_ZBLQRGA == 'B'
	       nPVBloq2  += (QRY_SC6->C6_QTDVEN - QRY_SC6->C6_QTDENT)
	       AAdd(aPVBloq2,aRec)
	    ENDIF
	    QRY_SC6->(dbSkip())
	End

	If Select("QRY_SC6") > 0      //Incluido condicao de data de emissao
		QRY_SC6->(dbCloseArea())
	EndIf

	//endif

	// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
	//( aRet[1] - nPV ) > 0
	if ( aRet2[1] - nPV2 ) > ( aRet[1] - nPV )
		aSaldo := {0,0,0,0,0,0,0,0}
		aSaldo[1]  := Transform( aRet[1]  			, cPictQtd14 )
		aSaldo[2]  := Transform( nPV      			, cPictQtd14 )
		aSaldo[3]  := Transform( nPVBloq  			, cPictQtd14 )
		aSaldo[4]  := Transform( aRet[1] - nPV		, cPictQtd14 )
		aSaldo[5]  := Transform( aRet[2]			, cPictQtd14 )
		aSaldo[6]  := Transform( aRet[3] / aRet[2]	, cPictQtd14 )
		aSaldo[7]  := Transform( aRet[1] / aRet[2]	, cPictQtd14 )
		aSaldo[8]  := Transform( aRet[3]			, cPictQtd14 )

		aPVBloq2	:= {}
	else
		aSaldo := {0,0,0,0,0,0,0,0}
		aSaldo[1]  := Transform( aRet2[1]  				, cPictQtd14 )
		aSaldo[2]  := Transform( nPV2      				, cPictQtd14 )
		aSaldo[3]  := Transform( nPVBloq2 				, cPictQtd14 )
		aSaldo[4]  := Transform( aRet2[1] - nPV2		, cPictQtd14 )
		aSaldo[5]  := Transform( aRet2[2]				, cPictQtd14 )
		aSaldo[6]  := Transform( aRet2[3] / aRet2[2]	, cPictQtd14 )
		aSaldo[7]  := Transform( aRet2[1] / aRet2[2]	, cPictQtd14 )
		aSaldo[8]  := Transform( aRet2[3]				, cPictQtd14 )

		aPVBloq		:= {}
		aPVBloq		:= aClone( aPVBloq2 )
		aPVBloq2	:= {}
	endif
endif

IF bRefresh
	nPV		:= 0
	nPVBloq	:= 0

     nPV     := Val(aSaldo[2])
     nPVBloq := Val(aSaldo[3])
ENDIF

IF bRefresh
	oSaldo:SetFocus()
	oSaldo:Refresh()
EndIF

Return
**********************************************************************************************************************************************
Static Function FAT13_PV(nTipo)

Local aListPV := {}
Local oBrowseDados
Local oDLG2
Local cbLine := ""

IF nTipo == 1
  aListPV := aPV
ElseIF nTipo == 2
  aListPV := aPVBloq
EndIF


IF Len(aListPV) == 0
    MsgAlert('Nao h� Pedidos de Vendas'+IIF(nTipo==1,'!!',' Bloqueado !!'))
    Return
EndIF

DEFINE MSDIALOG oDlg2 TITLE 'Pedidos de Vendas'+IIF(nTipo==1,'',' Bloqueados') FROM 000, 000  TO 500, 620 COLORS 0, 16777215 PIXEL

	oBrowseDados := TWBrowse():New( 004, 004,305,240,,,,oDlg2, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowseDados:SetArray(aListPV)
	cbLine := "{||{ aListPV[oBrowseDados:nAt,01],"+;
	"aListPV[oBrowseDados:nAt,02],"+;
	"aListPV[oBrowseDados:nAt,03],"+;
	"aListPV[oBrowseDados:nAt,04],"+;
	"aListPV[oBrowseDados:nAt,05],"+;
	"aListPV[oBrowseDados:nAt,06],"+;
	"aListPV[oBrowseDados:nAt,07],"+;
	"aListPV[oBrowseDados:nAt,08]  } }"
	oBrowseDados:bLine       := &cbLine
	oBrowseDados:addColumn(TCColumn():new("Pedido"        ,{||aListPV[oBrowseDados:nAt][01]},"@!",,,"LEFT"  ,30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Item"          ,{||aListPV[oBrowseDados:nAt][02]},"@!",,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Cliente"       ,{||aListPV[oBrowseDados:nAt][03]},"@!",,,"LEFT"  ,30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Loja"          ,{||aListPV[oBrowseDados:nAt][04]},"@!",,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Razao Social"  ,{||aListPV[oBrowseDados:nAt][05]},"@!",,,"LEFT"  ,100,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("TES"           ,{||aListPV[oBrowseDados:nAt][06]},"@!",,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Entrega"       ,{||aListPV[oBrowseDados:nAt][07]},"@!",,,"LEFT"  ,30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Quantidade"    ,{||aListPV[oBrowseDados:nAt][08]},"@E 9,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
	oBrowseDados:Setfocus()
ACTIVATE MSDIALOG oDlg2 CENTERED


Return
**************************************************************************************************************************************************************
Static Function Val_DT(bFlag,dVlMin,dVlMax)

IF !bFlag
      MsgAlert('Pedido Tipo FEFO Atacado, nao � possivel alterar a data fora dos limites: '+DTOC(dVlMin)+' a '+DTOC(dVlMax))
EndIF

Return bFlag