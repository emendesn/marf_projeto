#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM16
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              06/03/2017
Descricao / Objetivo:   Estrutura de Vendas
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM16()
	local	cFilTbl		:= ""

	private aSizeAdv	:= MsAdvSize(.F.)
	private aSizeWnd	:= {aSizeAdv[7],0,aSizeAdv[6],aSizeAdv[5]}
	private aSizeFld	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-3,aSizeAdv[4]-13}
	private aSizeBrw	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-60,aSizeAdv[4]-27}

	private aTFolder
	private oTFolder
	private oLbx1
	private oLbx2
	private oLbx3
	private oLbx4
	private oLbx5
	private oLbx6
	private oLbx7

	private aCols1 := {}
	private aCols2 := {}
	private aCols3 := {}
	private aCols4 := {}
	private aCols5 := {}
	private aCols6 := {}
	private aCols7 := {}

	private aPosButton	:= { aSizeFld[3]-50 , aSizeFld[4]-35 , aSizeFld[1] , aSizeFld[1]+15 , aSizeFld[1]+40 , aSizeFld[1]+55 , aSizeFld[1]+70 }

	// pesquisa aba 1
	private oSay11
	private oGet11
	private cGet11	:= space(100)

	private oSay12
	private oGet12
	private cGet12	:= space(40)

	private oBtnPesq1

	// pesquisa aba 2
	private oSay21
	private oGet21
	private cGet21 := space(100)

	private oSay22
	private oGet22
	private cGet22 := space(40)

	private oBtnPesq2

	// pesquisa aba 3
	private oSay31
	private oGet31
	private cGet31 := space(100)

	private oSay32
	private oGet32
	private cGet32 := space(40)

	private oBtnPesq3

	// pesquisa aba 4
	private oSay41
	private oGet41
	private cGet41 := space(100)

	private oSay42
	private oGet42
	private cGet42 := space(40)

	private oBtnPesq4

	// pesquisa aba 5
	private oSay51
	private oGet51
	private cGet51 := space(100)

	private oSay52
	private oGet52
	private cGet52 := space(40)

	private oBtnPesq5

	// pesquisa aba 6
	private oSay61
	private oGet61
	private cGet61 := space(100)

	private oSay62
	private oGet62
	private cGet62 := space(40)

	private oBtnPesq6

	// pesquisa aba 7
	private oSay71
	private oGet71
	private cGet71 := space(14)

	private oSay72
	private oGet72
	private cGet72 := space(100)

	private oGet701
	private cGet701 := space( tamSx3("A3_NOME")[1] )

	private oSay74
	private oGet74
	private cGet74  := space( tamSx3("ZBI_CODIGO")[1] )

	private cGet742  := space( tamSx3("ZBI_DESCRI")[1] )

	Private oSay73

	private oBtnPesq7

	private oCombo7
	private aCombo7 := {}
	private cCombo7 := ""
	private cGet70	:= space( tamSx3("A3_COD")[1] )

	DEFINE MSDIALOG oDlg0 TITLE OemToAnsi("Estrutura de Vendas") FROM aSizeWnd[1],aSizeWnd[2] TO aSizeWnd[3],aSizeWnd[4] PIXEL

		aTFolder := { '1. Diretoria', '2. Nacional', '3. Tetica', '4. Regional', '5. Supervis�o', '6. Roteiro', 'Clientes' }
		oTFolder := TFolder():New( aSizeFld[1],aSizeFld[2],aTFolder,,oDlg0,,,,.T.,,aSizeFld[3],aSizeFld[4])

		oTFolder:bchange := { || fwMsgRun(, {|| loadTabs(oTFolder:nOption) }, "Processando", "Aguarde. Selecionando dados..." ) }

		//**************************************************************
		//**************************************************************

		@ 015, 005 SAY oSay11 PROMPT "N�vel 1:"				SIZE 045, 007 OF oTFolder:aDialogs[1]			 	COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet11 VAR cGet11 					SIZE 150, 010 OF oTFolder:aDialogs[1]	F3 "ZBD"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay12 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[1] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet12 VAR cGet12					SIZE 130, 010 OF oTFolder:aDialogs[1]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq1 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[1] PIXEL ACTION (aCols1 := {}, fwMsgRun(, {|| getZBD(@aCols1) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx1:setArray(aCols1), oLbx1:Refresh())

		@ 040,000 LISTBOX oLbx1 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[1]
		oLbx1:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui1	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[1] Pixel Action ( U_MGFCRM18(3), getZBD(@aCols1), oLbx1:SetArray(aCols1), oLbx1:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera1	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[1] Pixel Action ( U_MGFCRM18(4, aCols1[oLbx1:nAt,01]), getZBD(@aCols1), oLbx1:SetArray(aCols1), oLbx1:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui1	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[1] Pixel Action ( U_MGFCRM18(5, aCols1[oLbx1:nAt,01]), getZBD(@aCols1), oLbx1:SetArray(aCols1), oLbx1:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[1] Pixel Action ( oDlg0:End() )

		aCols1 := { { "", "", "", ""} }

		oLbx1:AddColumn( TcColumn():New( "C�d. N�vel 1"			, { || aCols1[oLbx1:nAt,01] },  ,,,"LEFT"	,035,.f.,.f.,,,,.f.,) )
		oLbx1:AddColumn( TcColumn():New( "Descricao N�vel 1"	, { || aCols1[oLbx1:nAt,02] },  ,,,"LEFT"	,100,.f.,.f.,,,,.f.,) )
		oLbx1:AddColumn( TcColumn():New( "C�d. Repres."			, { || aCols1[oLbx1:nAt,03] },  ,,,"LEFT"	,035,.f.,.f.,,,,.f.,) )
		oLbx1:AddColumn( TcColumn():New( "Representante"		, { || aCols1[oLbx1:nAt,04] },  ,,,"LEFT"	,100,.f.,.f.,,,,.f.,) )

		oLbx1:SetArray(aCols1)

		//**************************************************************
		//**************************************************************
		@ 015, 005 SAY oSay21 PROMPT "N�vel 1:" 			SIZE 045, 007 OF oTFolder:aDialogs[2] 				COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet21 VAR cGet21					SIZE 150, 010 OF oTFolder:aDialogs[2]	F3 "ZBE"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay22 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[2] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet23 VAR cGet22					SIZE 130, 010 OF oTFolder:aDialogs[2]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq2 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[2] PIXEL ACTION (aCols2 := {}, fwMsgRun(, {|| getZBE(@aCols2, aCols1[oLbx1:nAt,01]) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx2:setArray(aCols2), oLbx2:Refresh())

		@ 040,000 LISTBOX oLbx2 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[2] //FONT oFont2 OF oDlg0
		//oLbx2:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui2	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[2] Pixel Action ( U_MGFCRM20(3), getZBE(@aCols2), oLbx2:SetArray(aCols2), oLbx2:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera2	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[2] Pixel Action ( U_MGFCRM20(4, aCols2[oLbx2:nAt,03]+aCols2[oLbx2:nAt,01], aCols2[oLbx2:nAt,07]), getZBE(@aCols2), oLbx2:SetArray(aCols2), oLbx2:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui2	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[2] Pixel Action ( U_MGFCRM20(5, aCols2[oLbx2:nAt,03]+aCols2[oLbx2:nAt,01], aCols2[oLbx2:nAt,07]), getZBE(@aCols2), oLbx2:SetArray(aCols2), oLbx2:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[2] Pixel Action ( oDlg0:End() )

		aCols2 := { {"", "", "", "", "", "", 0} }

		oLbx2:AddColumn( TcColumn():New( "C�d. N�vel 1"		, { || aCols2[oLbx2:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx2:AddColumn( TcColumn():New( "Descricao N�vel 1", { || aCols2[oLbx2:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx2:AddColumn( TcColumn():New( "C�d. N�vel 2"		, { || aCols2[oLbx2:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx2:AddColumn( TcColumn():New( "Descricao N�vel 2", { || aCols2[oLbx2:nAt,04] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )
		oLbx2:AddColumn( TcColumn():New( "C�d. Repres"		, { || aCols2[oLbx2:nAt,05] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx2:AddColumn( TcColumn():New( "Representante"	, { || aCols2[oLbx2:nAt,06] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )

		oLbx2:SetArray(aCols2)

		//**************************************************************
		//**************************************************************
		@ 015, 005 SAY oSay31 PROMPT "N�vel 2:"				SIZE 045, 007 OF oTFolder:aDialogs[3] 				COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet31 VAR cGet31 					SIZE 150, 010 OF oTFolder:aDialogs[3]	F3 "ZBF"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay32 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[3] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet32 VAR cGet32					SIZE 130, 010 OF oTFolder:aDialogs[3]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq3 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[3] PIXEL ACTION (aCols3 := {}, fwMsgRun(, {|| getZBF(@aCols3, aCols2[oLbx2:nAt,03]) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx3:setArray(aCols3), oLbx3:Refresh())

		@ 040,000 LISTBOX oLbx3 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[3] //FONT oFont2 OF oDlg0
		oLbx3:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui3	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[3] Pixel Action ( U_MGFCRM22(3), getZBF(@aCols3), oLbx3:SetArray(aCols3), oLbx3:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera3	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[3] Pixel Action ( U_MGFCRM22(4, aCols3[oLbx3:nAt,03]+aCols3[oLbx3:nAt,01], aCols3[oLbx3:nAt,07]), getZBF(@aCols3), oLbx3:SetArray(aCols3), oLbx3:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui3	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[3] Pixel Action ( U_MGFCRM22(5, aCols3[oLbx3:nAt,03]+aCols3[oLbx3:nAt,01], aCols3[oLbx3:nAt,07]), getZBF(@aCols3), oLbx3:SetArray(aCols3), oLbx3:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[3] Pixel Action ( oDlg0:End() )

		aCols3 := { {"", "", "", "", "", "", 0} }

		oLbx3:AddColumn( TcColumn():New( "C�d. N�vel 2"		, { || aCols3[oLbx3:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx3:AddColumn( TcColumn():New( "Descricao N�vel 2", { || aCols3[oLbx3:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx3:AddColumn( TcColumn():New( "C�d. N�vel 3"		, { || aCols3[oLbx3:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx3:AddColumn( TcColumn():New( "Descricao N�vel 3", { || aCols3[oLbx3:nAt,04] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )
		oLbx3:AddColumn( TcColumn():New( "C�d. Repres"		, { || aCols3[oLbx3:nAt,05] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx3:AddColumn( TcColumn():New( "Representante"	, { || aCols3[oLbx3:nAt,06] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )

		oLbx3:SetArray(aCols3)

		//**************************************************************
		//**************************************************************
		@ 015, 005 SAY oSay41 PROMPT "N�vel 3:"				SIZE 045, 007 OF oTFolder:aDialogs[4] 				COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet41 VAR cGet41 					SIZE 150, 010 OF oTFolder:aDialogs[4]	F3 "ZBG"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay42 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[4] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet42 VAR cGet42					SIZE 130, 010 OF oTFolder:aDialogs[4]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq4 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[4] PIXEL ACTION (aCols4 := {}, fwMsgRun(, {|| getZBG(@aCols4, aCols3[oLbx3:nAt,03]) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx4:setArray(aCols4), oLbx4:Refresh())

		@ 040,000 LISTBOX oLbx4 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[4] //FONT oFont2 OF oDlg0
		oLbx4:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui4	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[4] Pixel Action ( U_MGFCRM24(3), getZBG(@aCols4), oLbx4:SetArray(aCols4), oLbx4:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera4	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[4] Pixel Action ( U_MGFCRM24(4, aCols4[oLbx4:nAt,03]+aCols4[oLbx4:nAt,01], aCols4[oLbx4:nAt,07]), getZBG(@aCols4), oLbx4:SetArray(aCols4), oLbx4:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui4	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[4] Pixel Action ( U_MGFCRM24(5, aCols4[oLbx4:nAt,03]+aCols4[oLbx4:nAt,01], aCols4[oLbx4:nAt,07]), getZBG(@aCols4), oLbx4:SetArray(aCols4), oLbx4:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[4] Pixel Action ( oDlg0:End() )

		aCols4 := { {"", "", "", "", "", "", 0} }

		oLbx4:AddColumn( TcColumn():New( "C�d. N�vel 3"		, { || aCols4[oLbx4:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx4:AddColumn( TcColumn():New( "Descricao N�vel 3", { || aCols4[oLbx4:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx4:AddColumn( TcColumn():New( "C�d. N�vel 4"		, { || aCols4[oLbx4:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx4:AddColumn( TcColumn():New( "Descricao N�vel 4", { || aCols4[oLbx4:nAt,04] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )
		oLbx4:AddColumn( TcColumn():New( "C�d. Repres"		, { || aCols4[oLbx4:nAt,05] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx4:AddColumn( TcColumn():New( "Representante"	, { || aCols4[oLbx4:nAt,06] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )

		oLbx4:SetArray(aCols4)

		//**************************************************************
		//**************************************************************
		@ 015, 005 SAY oSay51 PROMPT "N�vel 4:"				SIZE 045, 007 OF oTFolder:aDialogs[5] 				COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet51 VAR cGet51 					SIZE 150, 010 OF oTFolder:aDialogs[5]	F3 "ZBH"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay52 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[5] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet52 VAR cGet52					SIZE 130, 010 OF oTFolder:aDialogs[5]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq5 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[5] PIXEL ACTION (aCols5 := {}, fwMsgRun(, {|| getZBH(@aCols5, aCols4[oLbx4:nAt,03]) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx5:setArray(aCols5), oLbx5:Refresh())

		@ 040,000 LISTBOX oLbx5 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[5] //FONT oFont2 OF oDlg0
		oLbx5:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui5	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[5] Pixel Action ( U_MGFCRM26(3), getZBH(@aCols5), oLbx5:SetArray(aCols5), oLbx5:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera5	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[5] Pixel Action ( U_MGFCRM26(4, aCols5[oLbx5:nAt,03]+aCols5[oLbx5:nAt,01], aCols5[oLbx5:nAt,07]), getZBH(@aCols5), oLbx5:SetArray(aCols5), oLbx5:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui5	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[5] Pixel Action ( U_MGFCRM26(5, aCols5[oLbx5:nAt,03]+aCols5[oLbx5:nAt,01], aCols5[oLbx5:nAt,07]), getZBH(@aCols5), oLbx5:SetArray(aCols5), oLbx5:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[5] Pixel Action ( oDlg0:End() )

		aCols5 := { {"", "", "", "", "", "", 0} }

		oLbx5:AddColumn( TcColumn():New( "C�d. N�vel 4"		, { ||  aCols5[oLbx5:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx5:AddColumn( TcColumn():New( "Descricao N�vel 4", { ||  aCols5[oLbx5:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx5:AddColumn( TcColumn():New( "C�d. N�vel 5"		, { ||  aCols5[oLbx5:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx5:AddColumn( TcColumn():New( "Descricao N�vel 5", { ||  aCols5[oLbx5:nAt,04] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )
		oLbx5:AddColumn( TcColumn():New( "C�d. Repres"		, { ||  aCols5[oLbx5:nAt,05] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx5:AddColumn( TcColumn():New( "Representante"	, { ||  aCols5[oLbx5:nAt,06] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )

		oLbx5:SetArray(aCols5)

		//**************************************************************
		//**************************************************************
		@ 015, 005 SAY oSay61 PROMPT "N�vel 5:"				SIZE 045, 007 OF oTFolder:aDialogs[6] 				COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGet61 VAR cGet61 					SIZE 150, 010 OF oTFolder:aDialogs[6]	F3 "ZBI"	COLORS 0, 16777215 PIXEL

		@ 015, 240 SAY oSay62 PROMPT "Representan.:" 		SIZE 045, 007 OF oTFolder:aDialogs[6] 				COLORS 0, 16777215 PIXEL
		@ 013, 285 MSGET oGet62 VAR cGet62					SIZE 130, 010 OF oTFolder:aDialogs[6]	F3 "SA3"	COLORS 0, 16777215 PIXEL

		@ 012, 455 BUTTON oBtnPesq6 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[6] PIXEL ACTION (aCols6 := {}, fwMsgRun(, {|| getZBI(@aCols6) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx6:setArray(aCols6), oLbx6:Refresh())

		@ 040,000 LISTBOX oLbx6 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[6] //FONT oFont2 OF oDlg0
		oLbx6:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui6	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[6] Pixel Action ( U_MGFCRM28(3), getZBI(@aCols6), oLbx6:SetArray(aCols6), oLbx6:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera6	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[6] Pixel Action ( U_MGFCRM28(4, aCols6[oLbx6:nAt,03]+aCols6[oLbx6:nAt,01], aCols6[oLbx6:nAt,07]), getZBI(@aCols6), oLbx6:SetArray(aCols6), oLbx6:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui6	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[6] Pixel Action ( U_MGFCRM28(5, aCols6[oLbx6:nAt,03]+aCols6[oLbx6:nAt,01], aCols6[oLbx6:nAt,07]), getZBI(@aCols6), oLbx6:SetArray(aCols6), oLbx6:Refresh() )

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[6] Pixel Action ( oDlg0:End() )

		aCols6 := { {"", "", "", "", "", "", 0} }

		oLbx6:AddColumn( TcColumn():New( "C�d. N�vel 5"		, { ||  aCols6[oLbx6:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx6:AddColumn( TcColumn():New( "Descricao N�vel 5", { ||  aCols6[oLbx6:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx6:AddColumn( TcColumn():New( "C�d. N�vel 6"		, { ||  aCols6[oLbx6:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx6:AddColumn( TcColumn():New( "Descricao N�vel 6", { ||  aCols6[oLbx6:nAt,04] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )
		oLbx6:AddColumn( TcColumn():New( "C�d. Repres"		, { ||  aCols6[oLbx6:nAt,05] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx6:AddColumn( TcColumn():New( "Representante"	, { ||  aCols6[oLbx6:nAt,06] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )

		oLbx6:SetArray(aCols6)

		//**************************************************************
		//**************************************************************

		@ 010, 005 SAY oSay70 PROMPT "Represent:"			SIZE 055, 007 OF oTFolder:aDialogs[7] 								COLORS 0, 16777215 PIXEL
		@ 007, 040 MSGET oGet70		VAR cGet70  			SIZE 030, 010 OF oTFolder:aDialogs[7]	F3 "ZBI4" VALID chkRepres()	COLORS 0, 16777215 PIXEL
		@ 007, 080 MSGET oGet701	VAR cGet701  			SIZE 160, 010 OF oTFolder:aDialogs[7]	WHEN .F.					COLORS 0, 16777215 PIXEL

		@ 025, 005 SAY oSay74 PROMPT "Roteiro:"				SIZE 055, 007 OF oTFolder:aDialogs[7] 								COLORS 0, 16777215 PIXEL
		@ 025, 040 MSGET oGet74		VAR cGet74  			SIZE 030, 010 OF oTFolder:aDialogs[7]	WHEN .F. VALID chkRoteir()	COLORS 0, 16777215 PIXEL
		@ 025, 080 MSGET oGet742	VAR cGet742  			SIZE 160, 010 OF oTFolder:aDialogs[7]	WHEN .F.					COLORS 0, 16777215 PIXEL

/*
		@ 025, 005 SAY oSay70 PROMPT "Reprentante:"			SIZE 055, 007 OF oTFolder:aDialogs[7] 								COLORS 0, 16777215 PIXEL
		@ 022, 040 MSGET oGet70		VAR cGet70  			SIZE 030, 010 OF oTFolder:aDialogs[7]	F3 "ZBI4" VALID chkRepres()	COLORS 0, 16777215 PIXEL
		@ 022, 080 MSGET oGet701	VAR cGet701  			SIZE 160, 010 OF oTFolder:aDialogs[7]	WHEN .F.					COLORS 0, 16777215 PIXEL
*/

		@ 015, 285 SAY oSay71 PROMPT "CNPJ:"								SIZE 045, 007 OF oTFolder:aDialogs[7] 				COLORS 0, 16777215 PIXEL
		@ 013, 305 MSGET oGet71 VAR cGet71 Picture "@R 99.999.999/9999-99" 	SIZE 070, 010 OF oTFolder:aDialogs[7]	F3 "SA1CNP"	COLORS 0, 16777215 PIXEL

		@ 015, 450 SAY oSay72 PROMPT "Cliente:"	 			SIZE 045, 007 OF oTFolder:aDialogs[7] 				COLORS 0, 16777215 PIXEL
		@ 013, 475 MSGET oGet72 VAR cGet72					SIZE 100, 010 OF oTFolder:aDialogs[7]	F3 "VSD"	COLORS 0, 16777215 PIXEL

		@ 012, 600 BUTTON oBtnPesq7 PROMPT "Pesquisar"		SIZE 060, 015 OF oTFolder:aDialogs[7] PIXEL ACTION (aCols7 := {}, fwMsgRun(, {|| getZBJ(@aCols7) }, "Processando", "Aguarde. Selecionando dados..." ), oLbx7:setArray(aCols7), oLbx7:Refresh())

		@ 040,000 LISTBOX oLbx7 Fields COLOR CLR_BLACK,CLR_BLUE SIZE aSizeBrw[3],aSizeBrw[4]-50 PIXEL OF oTFolder:aDialogs[7] //FONT oFont2 OF oDlg0
		oLbx7:lUseDefaultColors:=.F.

		@ aPosButton[03]+40		,aPosButton[01] BUTTON oInclui7	Prompt "Incluir" 		Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( U_MGFCRM36(3, nil, aCols7[oLbx7:nAt,07]), getZBJ(@aCols7), oLbx7:SetArray(aCols7), oLbx7:Refresh() )

		@ aPosButton[04]+40		,aPosButton[01] BUTTON oAltera7	Prompt "Alterar" 		Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( U_MGFCRM36(4, aCols7[oLbx7:nAt,01] + Padr(getZBIRep(),TamSX3("ZBJ_REPRES")[1]) + aCols7[oLbx7:nAt,03] + aCols7[oLbx7:nAt,04], aCols7[oLbx7:nAt,07]), getZBJ(@aCols7), oLbx7:SetArray(aCols7), oLbx7:Refresh() )

		@ aPosButton[04]+40+15	,aPosButton[01] BUTTON oExclui7	Prompt "Exclui" 		Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( U_MGFCRM36(5, aCols7[oLbx7:nAt,01] + Padr(getZBIRep(),TamSX3("ZBJ_REPRES")[1]) + aCols7[oLbx7:nAt,03] + aCols7[oLbx7:nAt,04], aCols7[oLbx7:nAt,07]), getZBJ(@aCols7), oLbx7:SetArray(aCols7), oLbx7:Refresh() )

		@ aPosButton[04]+40+45	,aPosButton[01] BUTTON oExport	Prompt "Exportar" 		Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( U_MGFCRM29() )

		@ aPosButton[04]+40+60	,aPosButton[01] BUTTON oImport	Prompt "Importar" 		Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( aCols7 :={}, U_MGFCRM30(), getZBJ(), oLbx7:SetArray(aCols7), oLbx7:Refresh())

		@ aPosButton[02],aPosButton[01] BUTTON oSair 		Prompt "Sair" 			Size 40,12 Of oTFolder:aDialogs[7] Pixel Action ( oDlg0:End() )

		aCols7 := { {"", "", "", "", "", "", 0} }

		oLbx7:AddColumn( TcColumn():New( "C�d. N�vel 6"		, { ||  aCols7[oLbx7:nAt,01] },  ,,,"LEFT"      ,035,.f.,.f.,,,,.f.,) )
		oLbx7:AddColumn( TcColumn():New( "Descricao N�vel 6", { ||  aCols7[oLbx7:nAt,02] },  ,,,"LEFT"      ,100,.f.,.f.,,,,.f.,) )
		oLbx7:AddColumn( TcColumn():New( "C�d. Cliente"		, { ||  aCols7[oLbx7:nAt,03] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx7:AddColumn( TcColumn():New( "Loja Cliente"		, { ||  aCols7[oLbx7:nAt,04] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx7:AddColumn( TcColumn():New( "CNPJ"				, { ||  aCols7[oLbx7:nAt,05] },  ,,,"LEFT"      ,035,.F.,.f.,,,,.f.,) )
		oLbx7:AddColumn( TcColumn():New( "Cliente"			, { ||  aCols7[oLbx7:nAt,06] },  ,,,"LEFT"      ,100,.F.,.f.,,,,.f.,) )

		oLbx7:SetArray(aCols7)

		fwMsgRun(, {|| getZBD(), oLbx1:SetArray(aCols1), oLbx1:Refresh() }, "Processando", "Aguarde. Selecionando dados..." )
	ACTIVATE MSDIALOG oDlg0
return

//---------------------------------------------
// Verifica se representante existe e dispara outros campos
//---------------------------------------------
static function chkRepres()
	local lRet		:= .T.
	local cQrySA3	:= ""

	if !empty(cGet70)
		cQrySA3 := "SELECT ZBI_CODIGO, ZBI_DESCRI, ZBI_REPRES, A3_NOME"		+ CRLF
		cQrySA3 += " FROM " + retSQLName("ZBI") + " ZBI"					+ CRLF
		cQrySA3 += " INNER JOIN " + retSQLName("SA3") + " SA3"				+ CRLF
		cQrySA3 += " ON"													+ CRLF
		cQrySA3 += " 		ZBI.ZBI_REPRES	=	SA3.A3_COD"					+ CRLF
		cQrySA3 += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"	+ CRLF
		cQrySA3 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"						+ CRLF
		cQrySA3 += " WHERE"													+ CRLF
		cQrySA3 += " 		ZBI.ZBI_REPRES	=	'" + cGet70 + "'"			+ CRLF
		cQrySA3 += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'"	+ CRLF
		cQrySA3 += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"						+ CRLF

		tcQuery cQrySA3 New Alias "QRYSA3"

		if !QRYSA3->(EOF())
			lRet := .T.

			cGet701 := QRYSA3->A3_NOME
			cGet74	:= QRYSA3->ZBI_CODIGO
			cGet742	:= QRYSA3->ZBI_DESCRI

			oGet701:refresh()
			oGet74:refresh()
			oGet742:refresh()
		else
			lRet := .F.
			cGet701 := space(tamSx3("A3_NOME")[1])
			cGet74	:= space(tamSx3("ZBI_CODIGO")[1])
			cGet742	:= space(tamSx3("ZBI_DESCRI")[1])

			oGet701:refresh()
			oGet74:refresh()
			oGet742:refresh()

			msgAlert("Representante nao encontrado na Estrutura de Vendas")
		endif

		QRYSA3->(DBCloseArea())
	else
		cGet701 := space(tamSx3("A3_NOME")[1])
		cGet74	:= space(tamSx3("ZBI_CODIGO")[1])
		cGet742	:= space(tamSx3("ZBI_DESCRI")[1])

		oGet701:refresh()
		oGet74:refresh()
		oGet742:refresh()
	endif
return lRet

//---------------------------------------------
// Verifica se roteiro existe e dispara outros campos
//---------------------------------------------
static function chkRoteir()
	local lRet		:= .T.
	local cQryZBI	:= ""

	if !empty(cGet74)
		cQryZBI := "SELECT ZBI_CODIGO, ZBI_DESCRI, ZBI_REPRES, A3_NOME"		+ CRLF
		cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"					+ CRLF
		cQryZBI += " INNER JOIN " + retSQLName("SA3") + " SA3"				+ CRLF
		cQryZBI += " ON"													+ CRLF
		cQryZBI += " 		ZBI.ZBI_REPRES	=	SA3.A3_COD"					+ CRLF
		cQryZBI += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"	+ CRLF
		cQryZBI += " 	AND	SA3.D_E_L_E_T_	<>	'*'"						+ CRLF
		cQryZBI += " WHERE"													+ CRLF
		cQryZBI += " 		ZBI.ZBI_CODIGO	=	'" + cGet74 + "'"			+ CRLF
		cQryZBI += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'"	+ CRLF
		cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"						+ CRLF

		tcQuery cQryZBI New Alias "QRYZBI"

		if !QRYZBI->(EOF())
			lRet := .T.

			cGet70	:= QRYZBI->ZBI_REPRES
			cGet701 := QRYZBI->A3_NOME
			//cGet742	:= QRYZBI->ZBI_DESCRI

			oGet70:refresh()
			oGet701:refresh()
			//oGet742:refresh()
		else
			lRet := .F.
			cGet70	:= space(tamSx3("ZBI_REPRES")[1])
			cGet701 := space(tamSx3("A3_NOME")[1])
			//cGet742	:= space(tamSx3("ZBI_DESCRI")[1])

			oGet70:refresh()
			oGet701:refresh()
			//oGet742:refresh()

			msgAlert("Roteiro nao encontrado na Estrutura de Vendas")
		endif

		QRYZBI->(DBCloseArea())
	else
		cGet70	:= space(tamSx3("ZBI_REPRES")[1])
		cGet701 := space(tamSx3("A3_NOME")[1])
		//cGet742	:= space(tamSx3("ZBI_DESCRI")[1])

		oGet70:refresh()
		oGet701:refresh()
		//oGet742:refresh()
	endif
return lRet


//---------------------------------------------
// Seleciona diretorias - ZBD
//---------------------------------------------
static function getZBD()
	local cQryZBD := ""

	aCols1 := {}

	cQryZBD := "SELECT ZBD_CODIGO, ZBD_DESCRI, A3_COD, A3_NOME" + CRLF
	cQryZBD += " FROM " + retSQLName("ZBD") + " ZBD" + CRLF

	cQryZBD += " LEFT JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBD += " ON" + CRLF
	cQryZBD += " 		ZBD.ZBD_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBD += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBD += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBD += " WHERE" + CRLF
	cQryZBD += " 		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" + CRLF
	cQryZBD += " 	AND	ZBD.D_E_L_E_T_	<>	'*'" + CRLF

	if !empty(cGet11)
		cQryZBD += " 	AND	(ZBD.ZBD_DESCRI LIKE '%" + upper(allTrim(cGet11)) + "%' OR ZBD.ZBD_CODIGO LIKE '%" + allTrim(cGet11) + "%')" + CRLF
	endif

	if !empty(cGet12)
		cQryZBD += " 	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet12)) + "%'" + CRLF
	endif

	cQryZBD += " ORDER BY ZBD_FILIAL,ZBD_CODIGO,ZBD_REPRES " + CRLF

	TcQuery cQryZBD New Alias "QRYZBD"

	while !QRYZBD->(EOF())
		aadd(aCols1, { QRYZBD->ZBD_CODIGO, QRYZBD->ZBD_DESCRI, QRYZBD->A3_COD, QRYZBD->A3_NOME })
		QRYZBD->(DBSkip())
	enddo

	if empty(aCols1)
		aCols1 := { {"", "", "", ""} }
	endif

	QRYZBD->(DBCloseArea())
return

//---------------------------------------------
// Seleciona nacional - ZBE
//---------------------------------------------
static function getZBE(aCols2, cFilTbl)
	local cQryZBE := ""

	aCols2 := {}

	cQryZBE := "SELECT ZBD_CODIGO, ZBD_DESCRI, ZBE_CODIGO, ZBE_DESCRI, A3_COD, A3_NOME, ZBE.R_E_C_N_O_ ZBE_RECNO" + CRLF
	cQryZBE += " FROM " + retSQLName("ZBE") + " ZBE" + CRLF

	cQryZBE += " INNER JOIN " + retSQLName("ZBD") + " ZBD" + CRLF
	cQryZBE += " ON" + CRLF
	cQryZBE += " 		ZBE.ZBE_DIRETO	=	ZBD.ZBD_CODIGO" + CRLF

	cQryZBE += " LEFT JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBE += " ON" + CRLF
	cQryZBE += " 		ZBE.ZBE_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBE += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBE += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBE += " WHERE" + CRLF
	cQryZBE += " 		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD")	+ "'" + CRLF
	cQryZBE += " 	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE")	+ "'" + CRLF
	cQryZBE += " 	AND	ZBD.D_E_L_E_T_	<>	'*'" + CRLF
	cQryZBE += " 	AND	ZBE.D_E_L_E_T_	<>	'*'" + CRLF

	//cQryZBE += " 	AND	ZBE.ZBE_DIRETO	=	'" + cFilTbl		+ "'"

	if !empty(cGet21)
		///cQryZBE += " 	AND	(ZBE.ZBE_DESCRI LIKE '%" + allTrim(cGet21) + "%' OR ZBE.ZBE_CODIGO LIKE '%" + allTrim(cGet21) + "%')" + CRLF
		cQryZBE += " 	AND	(ZBD.ZBD_DESCRI LIKE '%" + upper(allTrim(cGet21)) + "%' OR ZBE.ZBE_CODIGO LIKE '%" + allTrim(cGet21) + "%')" + CRLF
	endif

	if !empty(cGet22)
		cQryZBE += " 	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet22)) + "%'" + CRLF
	endif

	cQryZBE += " ORDER BY ZBE_FILIAL,ZBE_DIRETO,ZBE_CODIGO,ZBE_REPRES " + CRLF

	memoWrite("C:\TEMP\GETZBE.sql", cQryZBE)

	TcQuery cQryZBE New Alias "QRYZBE"

	while !QRYZBE->(EOF())
		aadd(aCols2, { QRYZBE->ZBD_CODIGO, QRYZBE->ZBD_DESCRI, QRYZBE->ZBE_CODIGO, QRYZBE->ZBE_DESCRI, QRYZBE->A3_COD, QRYZBE->A3_NOME, QRYZBE->ZBE_RECNO })
		QRYZBE->(DBSkip())
	enddo

	if empty(aCols2)
		aCols2 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBE->(DBCloseArea())
return

//---------------------------------------------
// Seleciona TATICA - ZBF
//---------------------------------------------
static function getZBF(aCols3, cFilTbl)
	local cQryZBF := ""

	aCols3 := {}

	cQryZBF := "SELECT ZBE_CODIGO, ZBE_DESCRI, ZBF_CODIGO, ZBF_DESCRI, A3_COD, A3_NOME, ZBF.R_E_C_N_O_ ZBF_RECNO" + CRLF
	cQryZBF += " FROM " + retSQLName("ZBF") + " ZBF" + CRLF

	cQryZBF += " INNER JOIN " + retSQLName("ZBE") + " ZBE" + CRLF
	cQryZBF += " ON" + CRLF
	cQryZBF += " 		ZBF.ZBF_NACION	=	ZBE.ZBE_CODIGO" + CRLF
	cQryZBF += " 	AND	ZBF.ZBF_DIRETO = ZBE.ZBE_DIRETO" + CRLF

	cQryZBF += " LEFT JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBF += " ON" + CRLF
	cQryZBF += " 		ZBF.ZBF_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBF += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBF += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBF += " WHERE" + CRLF
	cQryZBF += " 		ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF")	+ "'" + CRLF
	cQryZBF += " 	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE")	+ "'" + CRLF
	cQryZBF += " 	AND	ZBE.D_E_L_E_T_	<>	'*'" + CRLF
	cQryZBF += " 	AND	ZBF.D_E_L_E_T_	<>	'*'" + CRLF

	//cQryZBF += " 	AND	ZBF.ZBF_NACION	=	'" + cFilTbl		+ "'"

	if !empty(cGet31)
		cQryZBF += "	AND	(ZBE.ZBE_DESCRI LIKE '%" + upper(allTrim(cGet31)) + "%' OR ZBF.ZBF_CODIGO LIKE '%" + allTrim(cGet31) + "%')" + CRLF
	endif

	if !empty(cGet32)
		cQryZBF += "	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet32)) + "%'" + CRLF
	endif

	cQryZBF += " ORDER BY ZBF_FILIAL,ZBF_DIRETO,ZBF_NACION,ZBF_CODIGO,ZBF_REPRES " + CRLF

	TcQuery cQryZBF New Alias "QRYZBF"

	while !QRYZBF->(EOF())
		aadd(aCols3, { QRYZBF->ZBE_CODIGO, QRYZBF->ZBE_DESCRI, QRYZBF->ZBF_CODIGO, QRYZBF->ZBF_DESCRI, QRYZBF->A3_COD, QRYZBF->A3_NOME, QRYZBF->ZBF_RECNO })
		QRYZBF->(DBSkip())
	enddo

	if empty(aCols3)
		aCols3 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBF->(DBCloseArea())
return

//---------------------------------------------
// Seleciona REGIONAL - ZBG
//---------------------------------------------
static function getZBG(aCols4, cFilTbl)
	local cQryZBG := ""

	aCols4 := {}

	cQryZBG := "SELECT ZBF_CODIGO, ZBF_DESCRI, ZBG_CODIGO, ZBG_DESCRI, A3_COD, A3_NOME, ZBG.R_E_C_N_O_ ZBG_RECNO" + CRLF
	cQryZBG += " FROM " + retSQLName("ZBG") + " ZBG" + CRLF

	cQryZBG += " INNER JOIN " + retSQLName("ZBF") + " ZBF" + CRLF
	cQryZBG += " ON" + CRLF
	cQryZBG += " 		ZBG.ZBG_TATICA	=	ZBF.ZBF_CODIGO" + CRLF
	cQryZBG += " 	AND	ZBG.ZBG_NACION = ZBF.ZBF_NACION" + CRLF
	cQryZBG += " 	AND	ZBG.ZBG_DIRETO = ZBF.ZBF_DIRETO" + CRLF

	cQryZBG += " LEFT JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBG += " ON" + CRLF
	cQryZBG += " 		ZBG.ZBG_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBG += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBG += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBG += " WHERE"
	cQryZBG += " 		ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG")	+ "'" + CRLF
	cQryZBG += " 	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF")	+ "'" + CRLF
	cQryZBG += " 	AND	ZBG.D_E_L_E_T_	<>	'*'" + CRLF
	cQryZBG += " 	AND	ZBF.D_E_L_E_T_	<>	'*'" + CRLF

	//cQryZBG += " 	AND	ZBG.ZBG_TATICA	=	'" + cFilTbl		+ "'"

	if !empty(cGet41)
		cQryZBG += "	AND	(ZBF.ZBF_DESCRI LIKE '%" + upper(allTrim(cGet41)) + "%' OR ZBG.ZBG_CODIGO LIKE '%" + allTrim(cGet41) + "%')" + CRLF
	endif

	if !empty(cGet42)
		cQryZBG += "	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet42)) + "%'" + CRLF
	endif

	cQryZBG += " ORDER BY ZBG_FILIAL,ZBG_DIRETO,ZBG_NACION,ZBG_TATICA,ZBG_CODIGO,ZBG_REPRES " + CRLF

	TcQuery cQryZBG New Alias "QRYZBG"

	while !QRYZBG->(EOF())
		aadd(aCols4, { QRYZBG->ZBF_CODIGO, QRYZBG->ZBF_DESCRI, QRYZBG->ZBG_CODIGO, QRYZBG->ZBG_DESCRI, QRYZBG->A3_COD, QRYZBG->A3_NOME, QRYZBG->ZBG_RECNO })
		QRYZBG->(DBSkip())
	enddo

	if empty(aCols4)
		aCols4 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBG->(DBCloseArea())
return

//---------------------------------------------
// Seleciona SUPERVISAO - ZBH
//---------------------------------------------
static function getZBH(aCols5, cFilTbl)
	local cQryZBH := ""

	aCols5 := {}

	cQryZBH := "SELECT ZBG_CODIGO, ZBG_DESCRI, ZBH_CODIGO, ZBH_DESCRI, A3_COD, A3_NOME, ZBH.R_E_C_N_O_ ZBH_RECNO" + CRLF
	cQryZBH += " FROM " + retSQLName("ZBH") + " ZBH" + CRLF

	cQryZBH += " INNER JOIN " + retSQLName("ZBG") + " ZBG" + CRLF
	cQryZBH += " ON" + CRLF
	cQryZBH += " 		ZBH.ZBH_REGION	=	ZBG.ZBG_CODIGO" + CRLF
	cQryZBH += "	AND	ZBH.ZBH_TATICA = ZBG.ZBG_TATICA"		+ CRLF
	cQryZBH += " 	AND	ZBH.ZBH_NACION = ZBG.ZBG_NACION" + CRLF
	cQryZBH += " 	AND	ZBH.ZBH_DIRETO = ZBG.ZBG_DIRETO" + CRLF

	cQryZBH += " LEFT JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBH += " ON" + CRLF
	cQryZBH += " 		ZBH.ZBH_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBH += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBH += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBH += " WHERE" + CRLF
	cQryZBH += " 		ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH")	+ "'" + CRLF
	cQryZBH += " 	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG")	+ "'" + CRLF
	cQryZBH += " 	AND	ZBH.D_E_L_E_T_	<>	'*'" + CRLF
	cQryZBH += " 	AND	ZBG.D_E_L_E_T_	<>	'*'" + CRLF

	//cQryZBH += " 	AND	ZBH.ZBH_REGION	=	'" + cFilTbl		+ "'"

	if !empty(cGet51)
		cQryZBH += "	AND	(ZBG.ZBG_DESCRI LIKE '%" + upper(allTrim(cGet51)) + "%' OR ZBH.ZBH_CODIGO LIKE '%" + allTrim(cGet51) + "%')" + CRLF
	endif

	if !empty(cGet52)
		cQryZBH += "	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet52)) + "%'" + CRLF
	endif

	cQryZBH += " ORDER BY ZBH_FILIAL,ZBH_DIRETO,ZBH_NACION,ZBH_TATICA,ZBH_REGION,ZBH_CODIGO,ZBH_REPRES " + CRLF

	TcQuery cQryZBH New Alias "QRYZBH"

	while !QRYZBH->(EOF())
		aadd(aCols5, { QRYZBH->ZBG_CODIGO, QRYZBH->ZBG_DESCRI, QRYZBH->ZBH_CODIGO, QRYZBH->ZBH_DESCRI, QRYZBH->A3_COD, QRYZBH->A3_NOME, QRYZBH->ZBH_RECNO })
		QRYZBH->(DBSkip())
	enddo

	if empty(aCols5)
		aCols5 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBH->(DBCloseArea())
return

//---------------------------------------------
// Seleciona Roteiro - ZBI
//---------------------------------------------
static function getZBI(aCols6)
	local cQryZBI := ""

	aCols6 := {}

	cQryZBI := "SELECT ZBH_CODIGO, ZBH_DESCRI, ZBI_CODIGO, ZBI_DESCRI, A3_COD, A3_NOME, ZBI.R_E_C_N_O_ ZBI_RECNO" + CRLF
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI" + CRLF

	cQryZBI += " INNER JOIN " + retSQLName("ZBH") + " ZBH" + CRLF
	cQryZBI += " ON" + CRLF
	cQryZBI += " 		ZBI.ZBI_SUPERV	=	ZBH.ZBH_CODIGO" + CRLF
	cQryZBI += "	AND	ZBI.ZBI_REGION = ZBH.ZBH_REGION"	+ CRLF
	cQryZBI += "	AND	ZBI.ZBI_TATICA = ZBH.ZBH_TATICA"		+ CRLF
	cQryZBI += " 	AND	ZBI.ZBI_NACION = ZBH.ZBH_NACION" + CRLF
	cQryZBI += " 	AND	ZBI.ZBI_DIRETO = ZBH.ZBH_DIRETO" + CRLF
	cQryZBI += " 	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" + CRLF
	cQryZBI += " 	AND	ZBH.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBI += " INNER JOIN " + retSQLName("SA3") + " SA3" + CRLF
	cQryZBI += " ON" + CRLF
	cQryZBI += " 		ZBI.ZBI_REPRES	=	SA3.A3_COD" + CRLF
	cQryZBI += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" + CRLF
	cQryZBI += " 	AND	SA3.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBI += " WHERE" + CRLF
	cQryZBI += " 		ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'" + CRLF
	cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF

	//cQryZBI += " 	AND	ZBH.ZBH_REGION	=	'" + cFilTbl		+ "'"

	if !empty(cGet61)
		cQryZBI += "	AND	(ZBH.ZBH_DESCRI LIKE '%" + upper(allTrim(cGet61)) + "%' OR ZBI.ZBI_CODIGO LIKE '%" + allTrim(cGet61) + "%')" + CRLF
	endif

	if !empty(cGet62)
		cQryZBI += "	AND	SA3.A3_NOME LIKE '%" + upper(allTrim(cGet62)) + "%'" + CRLF
	endif

	cQryZBI += " ORDER BY ZBI_FILIAL,ZBI_DIRETO,ZBI_NACION,ZBI_TATICA,ZBI_REGION,ZBI_SUPERV,ZBI_CODIGO,ZBI_REPRES " + CRLF

	TcQuery cQryZBI New Alias "QRYZBI"

	while !QRYZBI->(EOF())
		aadd(aCols6, { QRYZBI->ZBH_CODIGO, QRYZBI->ZBH_DESCRI, QRYZBI->ZBI_CODIGO, QRYZBI->ZBI_DESCRI, QRYZBI->A3_COD, QRYZBI->A3_NOME, QRYZBI->ZBI_RECNO })
		QRYZBI->(DBSkip())
	enddo

	if empty(aCols6)
		aCols6 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBI->(DBCloseArea())
return

//---------------------------------------------
// Seleciona clientes
//---------------------------------------------
static function getZBJ(aCols7)
	local cQryZBJ := ""

	aCols7 := {}

	cQryZBJ := "SELECT ZBI_CODIGO, ZBI_DESCRI, A1_COD, A1_LOJA, A1_CGC, A1_NOME, ZBJ.R_E_C_N_O_ ZBJ_RECNO" + CRLF
	cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ" + CRLF

	cQryZBJ += " INNER JOIN " + retSQLName("ZBI") + " ZBI" + CRLF
	cQryZBJ += " ON" + CRLF
	cQryZBJ += " 		ZBJ.ZBJ_REPRES	= ZBI.ZBI_REPRES" + CRLF
	cQryZBJ += " 	AND ZBJ.ZBJ_ROTEIR  = ZBI.ZBI_CODIGO" + CRLF
	cQryZBJ += " 	AND	ZBJ.ZBJ_SUPERV	= ZBI.ZBI_SUPERV" + CRLF
	cQryZBJ += "	AND	ZBJ.ZBJ_REGION  = ZBI.ZBI_REGION"	+ CRLF
	cQryZBJ += "	AND	ZBJ.ZBJ_TATICA  = ZBI.ZBI_TATICA"		+ CRLF
	cQryZBJ += " 	AND	ZBJ.ZBJ_NACION  = ZBI.ZBI_NACION" + CRLF
	cQryZBJ += " 	AND	ZBJ.ZBJ_DIRETO  = ZBI.ZBI_DIRETO" + CRLF
	cQryZBJ += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'" + CRLF
	cQryZBJ += " 	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBJ += " INNER JOIN " + retSQLName("SA1") + " SA1" + CRLF
	cQryZBJ += " ON" + CRLF
	cQryZBJ += " 		ZBJ.ZBJ_LOJA	=	SA1.A1_LOJA" + CRLF
	cQryZBJ += " 	AND	ZBJ.ZBJ_CLIENT	=	SA1.A1_COD"
	cQryZBJ += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'" + CRLF
	cQryZBJ += " 	AND	SA1.D_E_L_E_T_	<>	'*'" + CRLF

	cQryZBJ += " WHERE" + CRLF
	cQryZBJ += " 		ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ")	+ "'" + CRLF
	cQryZBJ += " 	AND ZBJ.D_E_L_E_T_ <>	'*'" + CRLF

	if !empty(cGet71)
		cQryZBJ += "	AND	SA1.A1_CGC LIKE '%" + allTrim(cGet71) + "%'" + CRLF
	endif

	if !empty(cGet72)
		cQryZBJ += "	AND	SA1.A1_NOME LIKE '%" + upper(allTrim(cGet72)) + "%'" + CRLF
	endif

	if !empty(cGet70)
		//cQryZBJ += " 	AND	ZBJ.ZBJ_REPRES	=	'" + subStr(cCombo7,At("/",cCombo7)+2,6) + "'" + CRLF
		//cQryZBJ += " 	AND	ZBJ.ZBJ_ROTEIR	=	'" + subStr(cCombo7,1,6) + "'" + CRLF
		cQryZBJ += " 	AND	ZBJ.ZBJ_REPRES	=	'" + cGet70 + "'" + CRLF
	endif

	if !empty(cGet74)
		cQryZBJ += " 	AND ZBJ.ZBJ_ROTEIR  = '" + cGet74 + "'" + CRLF
	endif

	cQryZBJ += " ORDER BY ZBJ_FILIAL,ZBJ_DIRETO,ZBJ_NACION,ZBJ_TATICA,ZBJ_REGION,ZBJ_SUPERV,ZBJ_ROTEIR,ZBJ_CLIENT,ZBJ_LOJA,ZBJ_REPRES " + CRLF

	memoWrite("C:\TEMP\GETZBJ.sql", cQryZBJ)

	TcQuery cQryZBJ New Alias "QRYZBJ"

	while !QRYZBJ->(EOF())
		aadd(aCols7, { QRYZBJ->ZBI_CODIGO, QRYZBJ->ZBI_DESCRI, QRYZBJ->A1_COD, QRYZBJ->A1_LOJA, QRYZBJ->A1_CGC, QRYZBJ->A1_NOME, QRYZBJ->ZBJ_RECNO })
		QRYZBJ->(DBSkip())
	enddo

	if empty(aCols7)
		aCols7 := { {"", "", "", "", "", "", 0} }
	endif

	QRYZBJ->(DBCloseArea())
return

//---------------------------------------------
//
//---------------------------------------------
static function loadTabs(nTab)
	if nTab == 1
		// Aba 1
		getZBD(aCols1)
		oLbx1:SetArray(aCols1)
		oLbx1:Refresh()
	elseif nTab == 2
		// Aba 2
		getZBE(aCols2)
		oLbx2:SetArray(aCols2)
		oLbx2:Refresh()
	elseif nTab == 3
		// Aba 3
		getZBF(aCols3)
		oLbx3:SetArray(aCols3)
		oLbx3:Refresh()
	elseif nTab == 4
		// Aba 4
		getZBG(aCols4)
		oLbx4:SetArray(aCols4)
		oLbx4:Refresh()
	elseif nTab == 5
		// Aba 5
		getZBH(aCols5)
		oLbx5:SetArray(aCols5)
		oLbx5:Refresh()
	elseif nTab == 6
		// Aba 6
		getZBI(aCols6)
		oLbx6:SetArray(aCols6)
		oLbx6:Refresh()
	elseif nTab == 7
		//oCombo7:aItems := getZBICom()
		//oCombo7:Refresh()
		// Aba 7
		//getZBJ(aCols7)
		oLbx7:SetArray(aCols7)
		oLbx7:Refresh()
	endif
return

//---------------------------------------------
//
//---------------------------------------------
static function getZBIRep()
	local cRepres	:= ""
	//local cQryZBI	:= ""

	/*
	cQryZBI := "SELECT ZBI_REPRES"												+ CRLF
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"							+ CRLF
	cQryZBI += " WHERE"															+ CRLF
	cQryZBI += " 		ZBI.ZBI_CODIGO	=	'" + aCols7[oLbx7:nAt,01]	+ "'"	+ CRLF
	cQryZBI += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")			+ "'"	+ CRLF
	cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"								+ CRLF

	TcQuery cQryZBI New Alias "QRYZBI"

	if !QRYZBI->(EOF())
		cRepres := QRYZBI->ZBI_REPRES
	endif

	QRYZBI->(DBCloseArea())
	*/

	/*
	If !Empty(cCombo7)
		cRepres := Subs(cCombo7,At("/",cCombo7)+2,6)
	Endif
	*/

	If !Empty(cGet70)
		cRepres := cGet70
	Endif
return cRepres


//---------------------------------------------
// Seleciona Roteiro - ZBI para o combo
//---------------------------------------------
static function getZBICom()
	local cQryZBI := ""

	aRet := {}

	aadd(aRet, "")

	cQryZBI := "SELECT ZBI_CODIGO, ZBI_DESCRI, ZBI_REPRES" + CRLF
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI" + CRLF
	cQryZBI += " WHERE" + CRLF
	cQryZBI += " 		ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'" + CRLF
	cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF

	TcQuery cQryZBI New Alias "QRYZBI"

	while !QRYZBI->(EOF())
		//aadd(aCombo7, QRYZBI->ZBI_CODIGO + " - " + QRYZBI->ZBI_DESCRI)
		aadd(aRet, QRYZBI->ZBI_CODIGO + " - " + Alltrim(QRYZBI->ZBI_DESCRI) + " / " + QRYZBI->ZBI_REPRES + " - " + Alltrim(Posicione("SA3",1,xFilial("SA3")+QRYZBI->ZBI_REPRES,"A3_NOME")))
		QRYZBI->(DBSkip())
	enddo

	QRYZBI->(DBCloseArea())

	oCombo7:refresh()
return aRet

// valida codigos de cada estrutura
User Function CMR16VldCod(cTab,cCod,cNivel1,cNivel2,cNivel3,cNivel4,cNivel5,cNivel6)

Local cAliasTrb := GetNextAlias()
Local lRet := .T.
Local cQ := ""

if len(allTrim(cCod)) < 6
	Help( ,, 'Atencao',, 'O codigo deve ter 6 caracteres', 1, 0 )
	lRet := .F.
	return lRet
endif

cQ := "SELECT 1 "
cQ += "FROM " + retSQLName(cTab) + " "+cTab+" "
cQ += "WHERE "+cTab+".D_E_L_E_T_ <> '*'"
cQ += "AND "+cTab+"_FILIAL = '"+xFilial(cTab)+"' "
cQ += "AND "+cTab+"_CODIGO = '"+cCod+"' "
If Altera
	cQ += "AND R_E_C_N_O_ <> "+Alltrim(Str((cTab)->(Recno())))+" "
Endif
If cTab == "ZBE"
	cQ += "AND ZBE_DIRETO = '"+cNivel1+"' "
Endif
If cTab == "ZBF"
	cQ += "AND ZBF_NACION = '"+cNivel2+"' "
	cQ += "AND ZBF_DIRETO = '"+cNivel1+"' "
Endif
If cTab == "ZBG"
	cQ += "AND ZBG_TATICA = '"+cNivel3+"' "
	cQ += "AND ZBG_NACION = '"+cNivel2+"' "
	cQ += "AND ZBG_DIRETO = '"+cNivel1+"' "
Endif
If cTab == "ZBH"
	cQ += "AND ZBH_REGION = '"+cNivel4+"' "
	cQ += "AND ZBH_TATICA = '"+cNivel3+"' "
	cQ += "AND ZBH_NACION = '"+cNivel2+"' "
	cQ += "AND ZBH_DIRETO = '"+cNivel1+"' "
Endif
If cTab == "ZBI"
	cQ += "AND ZBI_SUPERV = '"+cNivel5+"' "
	cQ += "AND ZBI_REGION = '"+cNivel4+"' "
	cQ += "AND ZBI_TATICA = '"+cNivel3+"' "
	cQ += "AND ZBI_NACION = '"+cNivel2+"' "
	cQ += "AND ZBI_DIRETO = '"+cNivel1+"' "
Endif

dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	Help( ,, 'Atencao',, 'Este codigo j� foi usado nesta mesma estrutura', 1, 0 )
	lRet := .F.
Endif

(cAliasTrb)->(dbCloseArea())

Return(lRet)


User function F3Roteiro()

local nI			:= 0
local nJ			:= 0

Private aF3 := {}

aF3	:= {}

fwMsgRun(, {|| getRoteiro( )}, "Verificando Estruturas", "Aguarde. Verificando estruturas criadas..." )

while !QRYESTR->(EOF())
	aadd(aF3, {QRYESTR->CODIGO6,QRYESTR->NIVEL6,QRYESTR->CODREPRES6,QRYESTR->REPRES6,QRYESTR->CODIGO5,QRYESTR->NIVEL5,QRYESTR->CODIGO4,QRYESTR->NIVEL4,QRYESTR->CODIGO3,QRYESTR->NIVEL3,QRYESTR->CODIGO2,QRYESTR->NIVEL2,QRYESTR->CODIGO1,QRYESTR->NIVEL1})
	QRYESTR->(DBSkip())
Enddo

QRYESTR->(DBCloseArea())

if !empty(aF3)
	TelaRoteiro()
else
	msgAlert("Nao  foram encontradas Estruturas dispon�veis para este Roteiro.")
endif

return(.T.)


static function GetRoteiro()

local cQryArq		:= ""

cQryArq += "SELECT" + CRLF
cQryArq += "	ZBD_CODIGO CODIGO1, ZBD_DESCRI NIVEL1, ZBD_REPRES CODREPRES1," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES1," + CRLF
cQryArq += "	ZBE_CODIGO CODIGO2, ZBE_DESCRI NIVEL2, ZBE_REPRES CODREPRES2," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBE.ZBE_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES2," + CRLF
cQryArq += "	ZBF_CODIGO CODIGO3, ZBF_DESCRI NIVEL3, ZBF_REPRES CODREPRES3," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBF.ZBF_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES3," + CRLF
cQryArq += "	ZBG_CODIGO CODIGO4, ZBG_DESCRI NIVEL4, ZBG_REPRES CODREPRES4," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBG.ZBG_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES4," + CRLF
cQryArq += "	ZBH_CODIGO CODIGO5, ZBH_DESCRI NIVEL5, ZBH_REPRES CODREPRES5," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBH.ZBH_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES5," + CRLF
cQryArq += "	ZBI_CODIGO CODIGO6, ZBI_DESCRI NIVEL6, ZBI_REPRES CODREPRES6," + CRLF
cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBI.ZBI_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES6" + CRLF
/*
cQryArq += "FROM " + retSQLName("ZBD") + " ZBD" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBE") + " ZBE" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBF") + " ZBF" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 		+ CRLF
cQryArq += "AND	ZBE.ZBE_DIRETO = ZBF.ZBF_DIRETO" 								+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 		+ CRLF
cQryArq += "AND	ZBF.ZBF_NACION = ZBG.ZBG_NACION" 								+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 	+ CRLF
cQryArq += "ON"											+ CRLF
cQryArq += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION"		+ CRLF
cQryArq += "AND	ZBG.ZBG_TATICA = ZBH.ZBH_TATICA"								+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBI") + " ZBI"	+ CRLF
cQryArq += "ON"											+ CRLF
cQryArq += "	ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV"		+ CRLF
cQryArq += "AND	ZBH.ZBH_REGION = ZBI.ZBI_REGION"								+ CRLF
cQryArq += "WHERE" + CRLF
cQryArq += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" + CRLF
cQryArq += "	AND	ZBD.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" + CRLF
cQryArq += "	AND	ZBE.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" + CRLF
cQryArq += "	AND	ZBF.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" + CRLF
cQryArq += "	AND	ZBG.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" + CRLF
cQryArq += "	AND	ZBH.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'" + CRLF
cQryArq += "	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF
*/

cQryArq += QryNivSelEV(.F.)
cQryArq += QryNivWheEV(.F.)

cQryArq += "	ORDER BY ZBI_CODIGO,ZBH_CODIGO,ZBG_CODIGO,ZBF_CODIGO,ZBE_CODIGO,ZBD_CODIGO "

//memoWrite("\" + funName() + ".sql", cQrySB2)

TcQuery ChangeQuery(cQryArq) New Alias "QRYESTR"

Return()


// monta amarracao para a query da estrutura de vendas, parte da select
Static Function QryNivSelEV(lZBJ)

Local cQryArq := ""

cQryArq += "FROM " + retSQLName("ZBD") + " ZBD" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBE") + " ZBE" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBF") + " ZBF" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 		+ CRLF
cQryArq += "AND	ZBE.ZBE_DIRETO = ZBF.ZBF_DIRETO" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 	+ CRLF
cQryArq += "ON" 										+ CRLF
cQryArq += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 		+ CRLF
cQryArq += "AND	ZBF.ZBF_NACION = ZBG.ZBG_NACION" 		+ CRLF
cQryArq += "AND	ZBF.ZBF_DIRETO = ZBG.ZBG_DIRETO"		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 	+ CRLF
cQryArq += "ON"											+ CRLF
cQryArq += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION"		+ CRLF
cQryArq += "AND	ZBG.ZBG_TATICA = ZBH.ZBH_TATICA"		+ CRLF
cQryArq += "AND	ZBG.ZBG_NACION = ZBH.ZBH_NACION"		+ CRLF
cQryArq += "AND	ZBG.ZBG_DIRETO = ZBH.ZBH_DIRETO" 		+ CRLF
cQryArq += "INNER JOIN " + retSQLName("ZBI") + " ZBI"	+ CRLF
cQryArq += "ON"											+ CRLF
cQryArq += "	ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV"		+ CRLF
cQryArq += "AND	ZBH.ZBH_REGION = ZBI.ZBI_REGION"		+ CRLF
cQryArq += "AND	ZBH.ZBH_TATICA = ZBI.ZBI_TATICA"		+ CRLF
cQryArq += "AND	ZBH.ZBH_NACION = ZBI.ZBI_NACION" 		+ CRLF
cQryArq += "AND	ZBH.ZBH_DIRETO = ZBI.ZBI_DIRETO" 		+ CRLF
If lZBJ
	cQryArq += "INNER JOIN " + retSQLName("ZBJ") + " ZBJ"	+ CRLF
	cQryArq += "ON"											+ CRLF
	cQryArq += "AND ZBI.ZBI_CODIGO = ZBJ.ZBJ_ROTEIR" 		+ CRLF
	cQryArq += "AND	ZBI.ZBI_SUPERV = ZBJ.ZBJ_SUPERV" 		+ CRLF
	cQryArq += "AND	ZBI.ZBI_REGION = ZBJ.ZBJ_REGION"		+ CRLF
	cQryArq += "AND	ZBI.ZBI_TATICA = ZBJ.ZBJ_TATICA"		+ CRLF
	cQryArq += "AND	ZBI.ZBI_NACION = ZBJ.ZBJ_NACION" 		+ CRLF
	cQryArq += "AND	ZBI.ZBI_DIRETO = ZBJ.ZBJ_DIRETO" 		+ CRLF
Endif

Return(cQryArq)


// monta amarracao para a query da estrutura de vendas, parte da where
Static Function QryNivWheEV(lZBJ)

Local cQryArq := ""

cQryArq += "WHERE" + CRLF
cQryArq += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" + CRLF
cQryArq += "	AND	ZBD.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" + CRLF
cQryArq += "	AND	ZBE.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" + CRLF
cQryArq += "	AND	ZBF.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" + CRLF
cQryArq += "	AND	ZBG.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" + CRLF
cQryArq += "	AND	ZBH.D_E_L_E_T_	<>	'*'" + CRLF
cQryArq += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'" + CRLF
cQryArq += "	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF
If lZBJ
	cQryArq += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" + CRLF
	cQryArq += "	AND	ZBJ.D_E_L_E_T_	<>	'*'" + CRLF
Endif

Return(cQryArq)


//------------------------------------------------------
// Marca os produtos para venda ou transferencia
//------------------------------------------------------
static function TelaRoteiro()

local aSeek		:= {}
local oDlg	:= nil
local aCoors		:= 	FWGetDialogSize( oMainWnd )
//local bMark		:= { || iif(aProd[oMark:nAt][1], 'LBOK', 'LBNO')			}
//local bDblClick	:= { || clickMark(oMark, aProd)								}
//local bMarkAll	:= { || markAll(oMark, aProd)								}
local bOk			:= { || setVars(), oDlg:end() }
local bClose		:= { || oDlg:end() }
//local nTamSD1		:= (tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_COD")[1] + tamSx3("D1_ITEM")[1])

//Pesquisa que sera exibido
aadd(aSeek,{"Roteiro"		, { {"","C",tamSx3("ZBI_CODIGO")[1],0,"Codigo"		,,} }})
aadd(aSeek,{"Desc.Roteiro"	, { {"","C",tamSx3("ZBI_DESCRI")[1],0,"Descricao"	,,} }})

DEFINE MSDIALOG oDlg TITLE 'Estrutura de Vendas' FROM aCoors[1]/1.5, aCoors[2]/1.5 TO aCoors[3]/1.5, aCoors[4]/1.5 PIXEL STYLE DS_MODALFRAME
oMark := fwBrowse():New()
oMark:setDataArray()
oMark:setArray(aF3)
oMark:disableConfig()
oMark:disableReport()
oMark:setOwner(oDlg)
oMark:setSeek(,aSeek)

/*
		SetSeek
		Habilita a utiliza��o da pesquisa de registros no Browse

		@param   bAction Code-Block executado para a pesquisa de registros, caso nao seja informado sera utilizado o padrao
		@param   aOrder  Estrutura do array
						[n,1] Titulo da pesquisa
						[n,2,n,1] LookUp
						[n,2,n,2] Tipo de dados
						[n,2,n,3] Tamanho
						[n,2,n,4] Decimal
						[n,2,n,5] Titulo do campo
						[n,2,n,6] Mascara
						[n,2,n,7] Nome Fisico do campo - Opcional - � ajustado no programa
						[n,3] Ordem da pesquisa
						[n,4] Exibe na pesquisa
*/

		//oMark:addMarkColumns(bMark, bDblClick, bMarkAll)

oMark:addColumn({"Roteiro"		   				, {||aF3[oMark:nAt,1]}		, "C", "@!"	, 1, tamSx3("ZBI_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Roteiro"					, {||aF3[oMark:nAt,2]}		, "C", "@!"	, 1, 15							,, .F.})
oMark:addColumn({"Representante Roteiro"		, {||aF3[oMark:nAt,3]}		, "C", "@!"	, 1, tamSx3("ZBI_REPRES")[1]	,, .F.})
oMark:addColumn({"Desc.Representante Roteiro"	, {||aF3[oMark:nAt,4]}		, "C", "@!"	, 1, 30							,, .F.})
oMark:addColumn({"Supervis�o"					, {||aF3[oMark:nAt,5]}		, "C", "@!"	, 1, tamSx3("ZBH_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Supervis�o"				, {||aF3[oMark:nAt,6]}		, "C", "@!"	, 1, 15							,, .F.})
oMark:addColumn({"Regional"						, {||aF3[oMark:nAt,7]}		, "C", "@!"	, 1, tamSx3("ZBG_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Regional"				, {||aF3[oMark:nAt,8]}		, "C", "@!"	, 1, 15							,, .F.})
oMark:addColumn({"Tatica"						, {||aF3[oMark:nAt,9]}		, "C", "@!"	, 1, tamSx3("ZBF_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Tatica"					, {||aF3[oMark:nAt,10]}		, "C", "@!"	, 1, 15							,, .F.})
oMark:addColumn({"Nacional"						, {||aF3[oMark:nAt,11]}		, "C", "@!"	, 1, tamSx3("ZBE_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Nacional"				, {||aF3[oMark:nAt,12]}		, "C", "@!"	, 1, 15							,, .F.})
oMark:addColumn({"Diretoria"					, {||aF3[oMark:nAt,13]}		, "C", "@!"	, 1, tamSx3("ZBD_CODIGO")[1]	,, .F.})
oMark:addColumn({"Desc.Diretoria"				, {||aF3[oMark:nAt,14]}		, "C", "@!"	, 1, 15							,, .F.})

//oMark:setEditCell(.T., {|| u_valFields() })

/*
		Sintaxe
		FWBrowse(): SetEditCell ( [ lEditCell], [ bValidEdit] ) -->

		Parametros
		Nome		Tipo	Descricao	Obrigatorio	Referencia
		lEditCell	Logico	Indica se permite a edicao de c�lulas.
		bValidEdit	Bloco de codigo	Code-Block executado para validar a edicao da c�lula.
*/
//oMark:addColumn({"NF Origem"		, {||aProd[oMark:nAt,11]}	, "C", "@!"							, 1	, nTamSD1						,,	 .T.,, .F.,, "cNFOri"		,, .F., .T.,})
//oMark:setEditCell(.T., {|| u_valFields() })

//oMark:aColumns[11]:XF3 := 'XSD1'

/* add(Column
		[n][01] Titulo da coluna
		[n][02] Code-Block de carga dos dados
		[n][03] Tipo de dados
		[n][04] Mascara
		[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
		[n][06] Tamanho
		[n][07] Decimal
		[n][08] Indica se permite a edicao
		[n][09] Code-Block de validacao da coluna apos a edicao
		[n][10] Indica se exibe imagem
		[n][11] Code-Block de execucao do duplo clique
		[n][12] Variavel a ser utilizada na edicao (ReadVar)
		[n][13] Code-Block de execucao do clique no header
		[n][14] Indica se a coluna esta deletada
		[n][15] Indica se a coluna sera exibida nos detalhes do Browse
		[n][16] Opcoes de carga dos dados (Ex: 1=Sim, 2=Nao )
		[n][17] Id da coluna
		[n][18] Indica se a coluna � virtual
*/

oMark:setDoubleClick( { || setVars(), oDlg:end() } )
oMark:activate(.T.)

enchoiceBar(oDlg, bOk , bClose)
ACTIVATE MSDIALOG oDlg CENTER

return()

static function setVars()

M->ZBJ_ROTEIR := allTrim(aF3[oMark:nAt,1])
M->ZBJ_DESROT := allTrim(aF3[oMark:nAt,2])
M->ZBJ_DIRETO := allTrim(aF3[oMark:nAt,13])
M->ZBJ_DESDIR := allTrim(aF3[oMark:nAt,14])
M->ZBJ_NACION := allTrim(aF3[oMark:nAt,11])
M->ZBJ_DESNAC := allTrim(aF3[oMark:nAt,12])
M->ZBJ_TATICA := allTrim(aF3[oMark:nAt,9])
M->ZBJ_DESTAT := allTrim(aF3[oMark:nAt,10])
M->ZBJ_REGION := allTrim(aF3[oMark:nAt,7])
M->ZBJ_DESREG := allTrim(aF3[oMark:nAt,8])
M->ZBJ_SUPERV := allTrim(aF3[oMark:nAt,5])
M->ZBJ_DESSUP := allTrim(aF3[oMark:nAt,6])
M->ZBJ_REPRES := allTrim(aF3[oMark:nAt,3])
M->ZBJ_DESREP := allTrim(aF3[oMark:nAt,4])

return

/*
Static Function ZBFCpos()

local oModel := FWModelActive()
local oModel := oModel:GetModel('ZBFMASTER')
local nOper := oModel:getOperation()

If !Empty(ZBE->ZBE_DIRETO)
	if nOper == MODEL_OPERATION_INSERT
		oModel:SetValue("ZBF_DIRETO",ZBE->ZBE_DIRETO)
	Endif
Endif

Return(oModel:GetValue("ZBF_CODIGO"))
*/

//-------------------------------------------------------------------------------
// Atualiza clientes amarrados ao nivel atualizado
//-------------------------------------------------------------------------------
user function MGFUPZBJ( cCodHierar , nTabela )
	local cUpdZBJ	:= ""

	cUpdZBJ	:= ""

	cUpdZBJ := "UPDATE " + retSQLName( "ZBJ" )							+ CRLF
	cUpdZBJ += "	SET"												+ CRLF
	cUpdZBJ += "	ZBJ_INTSFO = 'P' "									+ CRLF
	cUpdZBJ += " WHERE"													+ CRLF
	cUpdZBJ += " 		ZBJ_FILIAL	=	'" + xFilial( "ZBJ" ) + "'"		+ CRLF
	cUpdZBJ += "	AND D_E_L_E_T_	=	' '"							+ CRLF

	do case
		case nTabela == 1 // ZBD - Diretoria
			cUpdZBJ += "	AND ZBJ_DIRETO 																			= '" + cCodHierar + "'"
		case nTabela == 2 // ZBE - Nacional
			cUpdZBJ += "	AND ZBJ_DIRETO || ZBJ_NACION 															= '" + cCodHierar + "'"
		case nTabela == 3 // ZBF - Tatica
			cUpdZBJ += "	AND ZBJ_DIRETO || ZBJ_NACION || ZBJ_TATICA												= '" + cCodHierar + "'"
		case nTabela == 4 // ZBG - Regional
			cUpdZBJ += "	AND ZBJ_DIRETO || ZBJ_NACION || ZBJ_TATICA || ZBJ_REGION								= '" + cCodHierar + "'"
		case nTabela == 5 // ZBH - Supervisao
			cUpdZBJ += "	AND ZBJ_DIRETO || ZBJ_NACION || ZBJ_TATICA || ZBJ_REGION || ZBJ_SUPERV					= '" + cCodHierar + "'"
		case nTabela == 6 // ZBI - Roteiro
			cUpdZBJ += "	AND ZBJ_DIRETO || ZBJ_NACION || ZBJ_TATICA || ZBJ_REGION || ZBJ_SUPERV || ZBJ_ROTEIR	= '" + cCodHierar + "'"
	endcase

	if tcSQLExec( cUpdZBJ ) < 0
		conout( "Nao  foi possivel executar UPDATE." + CRLF + tcSqlError() )
	endif
return