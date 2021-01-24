#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM33
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              18/04/2017
Descricao / Objetivo:   Estrutura de Vendas Transferencia
Doc. Origem:            GAP CRM20
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM33()

	private aSizeAdv	:= MsAdvSize(.F.)
	private aSizeWnd	:= {aSizeAdv[7],0,aSizeAdv[6],aSizeAdv[5]}
	private oDlg1
	private oFWLayer
	private oPanel1
	private oPanel2
	private oPanel3
	private oPanel4

	private oList1
	private oList2

	private aOri	:= {}
	private aDest	:= {}

	private nRadio	:= 0

	DEFINE FONT oFont Name "Arial" Size 012,016 //BOLD

	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Transferencia - Estrutura de Vendas") FROM aSizeWnd[1]/2,aSizeWnd[2]/5 TO aSizeWnd[3]/2,aSizeWnd[4]/5 PIXEL

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlg1 /*oOwner*/, .F. /*lCloseBtn*/)

		oFWLayer:AddLine( 'DIV1'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DIV2'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DIV3'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DIV4'	/*cID*/, 25 /*nPercHeight*/, .F. /*lFixed*/)

		oFWLayer:AddCollumn( 'ALLDIV1'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DIV1'	/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLDIV2'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DIV2'	/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLDIV3'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DIV3'/*cIDLine*/)	
		oFWLayer:AddCollumn( 'ALLDIV4'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DIV4'/*cIDLine*/)

		oPanel1	:= oFWLayer:GetColPanel( 'ALLDIV1', 'DIV1'	)
		oPanel2	:= oFWLayer:GetColPanel( 'ALLDIV2', 'DIV2'	)
		oPanel3	:= oFWLayer:GetColPanel( 'ALLDIV3', 'DIV3'	)
		oPanel4	:= oFWLayer:GetColPanel( 'ALLDIV4', 'DIV4'	)

		@ 015, 005 SAY oSay1 PROMPT "Estrutura atual:"		SIZE 150, 015 OF oPanel1	COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGetCdArma VAR cEstruAtu			SIZE 060, 010 OF oPanel1	COLORS 0, 16777215 PIXEL READONLY

		@ 015, 005 SAY oSay2 PROMPT "Estrutura destino:"	SIZE 150, 015 OF oPanel2	COLORS 0, 16777215 PIXEL
		@ 013, 050 MSGET oGetCdArma VAR cEstruDes			SIZE 060, 010 OF oPanel2 F3 "U_MGFCRM31()"	COLORS 0, 16777215 PIXEL

		aRadio := {}
		aadd(aRadio, "Duplicar")
		aadd(aRadio, "Apagar Origem")

		@ 015, 050 RADIO oRadio VAR nRadio 3D ITEMS aRadio[1],aRadio[2] SIZE 65,8 PIXEL OF oPanel3

		@ 015, 030 BUTTON oBtnPesq1 PROMPT "Transferir"		SIZE 060, 015 OF oPanel4 PIXEL ACTION ( execTransf(cA1Cod, cA1Loj, aDest[oGrid2:nAt,17], aDest[oGrid2:nAt,19]), oDlg1:end() )
	ACTIVATE MSDIALOG oDlg1
return
