#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
//-------------------------------------------------------------------
User Function MGFCOM43()
	local cQrySC7 := ""
	local oDlg
	local oFWLayer
	local oPanel1
	local aCoors	:= 	FWGetDialogSize( oMainWnd )

	local aArea		:= getArea()

	cQrySC7 := "SELECT C1_NUM, C3_NUM, C7_NUM, C7_OBS, B1_COD, B1_CONTRAT"		+ CRLF
	cQrySC7 += " FROM "			+ retSQLName("SC7") + " SC7"			+ CRLF
	cQrySC7 += " INNER JOIN "	+ retSQLName("SC1") + " SC1"			+ CRLF
	cQrySC7 += " ON"													+ CRLF
	cQrySC7 += "		INSTR(SC7.C7_OBS,'SC - ' || SC1.C1_NUM) > 0"	+ CRLF
	cQrySC7 += "	AND	SC1.C1_FILIAL   =	'" + xFilial("SC1") + "'"	+ CRLF
	cQrySC7 += "	AND SC1.D_E_L_E_T_  <>	'*'"						+ CRLF
	cQrySC7 += " INNER JOIN "	+ retSQLName("SC3") + " SC3"			+ CRLF
	cQrySC7 += " ON"													+ CRLF
	cQrySC7 += " 		SC7.C7_NUMSC	=	SC3.C3_NUM"					+ CRLF
	cQrySC7 += " 	AND SC3.C3_FILIAL	=	'" + xFilial("SC3") + "'"	+ CRLF
	cQrySC7 += " 	AND SC3.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySC7 += " INNER JOIN "	+ retSQLName("SB1") + " SB1"			+ CRLF
	cQrySC7 += " ON"													+ CRLF
	cQrySC7 += "		SB1.B1_CONTRAT	IN	('A', 'S')"					+ CRLF
	cQrySC7 += "	AND	SB1.B1_COD		=	SC7.C7_PRODUTO"				+ CRLF
	cQrySC7 += " 	AND SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"	+ CRLF
	cQrySC7 += " 	AND SB1.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySC7 += " WHERE"													+ CRLF
	cQrySC7 += " 		SC7.C7_OBS		<>	' '"						+ CRLF
	cQrySC7 += " 	AND SC7.C7_TIPO		=	'2'"						+ CRLF
	cQrySC7 += " 	AND SC7.C7_NUM		=	'" + SC7->C7_NUM + "'"		+ CRLF
	cQrySC7 += " 	AND SC7.C7_FILIAL	=	'" + xFilial("SC7") + "'"	+ CRLF
	cQrySC7 += " 	AND SC7.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySC7 += " ORDER BY C1_NUM, C3_NUM, C7_NUM"						+ CRLF

	//MemoWrite( "C:\temp\mgfcom43.sql", cQrySC7 )

	tcQuery cQrySC7 New Alias "QRYSC7"

	if QRYSC7->( EOF() )
		msgAlert("Este Pedido de Venda nao foi gerado com Contrato de Parceria")
	elseif !QRYSC7->( EOF() )

		DEFINE MSDIALOG oDlg TITLE 'Tracker AE' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL
			// Cria a Tree
			//oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)
			oTree := DbTree():New(aCoors[1]/2+5, aCoors[2]/2+5, aCoors[3]/2-15, aCoors[4]/2-15,oDlg,,,.T.)

			// Insere itens
			oTree:AddItem("Solicitação de Compra "  + allTrim( QRYSC7->C1_NUM )	, "001", "FOLDER5" ,,,,1)
			oTree:AddItem("Contrato de Parceria " + allTrim( QRYSC7->C3_NUM )	, "002", "FOLDER5" ,,,,1)

			If oTree:TreeSeek("002")
				oTree:AddItem("Pedido de Compra " + allTrim( QRYSC7->C7_NUM ),"003", "FOLDER10",,,,2)
			endif

			// Retorna ao primeiro nível
			oTree:TreeSeek("001")

			// Indica o término da contrução da Tree    
			oTree:EndTree()
		ACTIVATE MSDIALOG oDlg CENTER

	endif

	QRYSC7->( DBCloseArea() )

	restArea(aArea)
return
