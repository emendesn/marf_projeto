#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFFINA6

Relatório de detalhamento de faturas

@type function
@author TOTVS
@since JUNHO/2019
@version P12
/*/
user function MGFFINA6()
	if getParam()
		//genArq()
		fwMsgRun( , { | oSay | genArq( oSay ) } , "Processando" , "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Salvar arquivo Excel em"	, space(200)		, "@!"	, ""	, ""	, 100	, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})
	aadd(aParamBox, {1, "Vencimento Fatura de"			, cToD(space(8))	, 		, , 		,	, 100	, .F.	})
	aadd(aParamBox, {1, "Vencimento Fatura até"			, cToD(space(8))	, 		, , 		,	, 100	, .F.	})
	aadd(aParamBox, {1, "Vencimento Título de"			, cToD(space(8))	, 		, , 		,	, 100	, .F.	})
	aadd(aParamBox, {1, "Vencimento Título até"			, cToD(space(8))	, 		, , 		,	, 100	, .F.	})

return paramBox(aParambox, "Faturas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq( oSay )
	local aAreaX	:= getArea()
	local oExcel	:= fwMsExcel():New()
	local oExcelApp := msExcel():New()
	local aLinhaAux := {}
	local cArq		:= ""
	local cLocArq	:= allTrim( MV_PAR01 )

	getSE2()

	if !QRYSE2->( EOF() )
		oExcel:AddworkSheet("Faturas")
		oExcel:AddTable ( "Faturas" , "Títulos por Fatura" )
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Filial da Fatura" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Número da Fatura" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Vencimento da Fatura" /*cColumn*/ 	, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Filial do Título" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Número do Título" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Prefixo" /*cColumn*/ 				, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Tipo" /*cColumn*/ 					, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Código Fornecedor" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Loja Fornecedor" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Fornecedor" /*cColumn*/ 			, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Valor do Título" /*cColumn*/ 		, 3 /*nAlign*/, 3 /*nFormat*/, .T. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Vencimento do Título" /*cColumn*/ 	, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)
		oExcel:AddColumn( "Faturas" /*cWorkSheet*/, "Títulos por Fatura" /*cTable*/, "Borderô da Fatura" /*cColumn*/ 		, 1 /*nAlign*/, 1 /*nFormat*/, .F. /*lTotal*/)

		while !QRYSE2->( EOF() )
			aLinhaAux := {}

			aadd( aLinhaAux , QRYSE2->FILFAT						)
			aadd( aLinhaAux , QRYSE2->E2_FATURA						)
			aadd( aLinhaAux , dToC( sToD( QRYSE2->VENCFAT ) ) 		)
			aadd( aLinhaAux , QRYSE2->FILTIT 						)
			aadd( aLinhaAux , QRYSE2->E2_NUM 						)
			aadd( aLinhaAux , QRYSE2->E2_PREFIXO 					)
			aadd( aLinhaAux , QRYSE2->E2_TIPO						)
			aadd( aLinhaAux , QRYSE2->E2_FORNECE					)
			aadd( aLinhaAux , QRYSE2->E2_LOJA						)
			aadd( aLinhaAux , QRYSE2->A2_NOME						)
			aadd( aLinhaAux , QRYSE2->E2_VALOR						)
			aadd( aLinhaAux , dToC( sToD( QRYSE2->VENCTIT ) ) 		)
			aadd( aLinhaAux , QRYSE2->EA_NUMBOR						)

			oExcel:AddRow( "Faturas" , "Títulos por Fatura" , aLinhaAux )

			QRYSE2->( DBSkip() )
		enddo

		// Local oExcel := FWMSEXCEL():New()
		// oExcel:AddworkSheet("Teste - 1")
		// oExcel:AddTable ("Teste - 1","Titulo de teste 1")
		// oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col1",1,1)
		// oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col2",2,2)
		// oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col3",3,3)
		// oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col4",1,1)
		// oExcel:AddRow("Teste - 1","Titulo de teste 1",{11,12,13,14})
		// oExcel:AddRow("Teste - 1","Titulo de teste 1",{21,22,23,24})
		// oExcel:AddRow("Teste - 1","Titulo de teste 1",{31,32,33,34})
		// oExcel:AddRow("Teste - 1","Titulo de teste 1",{41,42,43,44})
		// oExcel:AddworkSheet("Teste - 2")
		// oExcel:AddTable("Teste - 2","Titulo de teste 1")
		// oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col1",1)
		// oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col2",2)
		// oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col3",3)
		// oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col4",1)
		// oExcel:AddRow("Teste - 2","Titulo de teste 1",{11,12,13,stod("20121212")})
		// oExcel:AddRow("Teste - 2","Titulo de teste 1",{21,22,23,stod("20121212")})
		// oExcel:AddRow("Teste - 2","Titulo de teste 1",{31,32,33,stod("20121212")})
		// oExcel:AddRow("Teste - 2","Titulo de teste 1",{41,42,43,stod("20121212")})
		// oExcel:AddRow("Teste - 2","Titulo de teste 1",{51,52,53,stod("20121212")})
		// oExcel:Activate()
		// oExcel:GetXMLFile("TESTE.xml")

		// Gera arquivo
		oExcel:Activate()
		cArq := CriaTrab(NIL, .F.) + ".xml"
		oExcel:GetXMLFile( cArq )

		if __CopyFile(cArq, cLocArq + cArq)
			MsgInfo("Relatório gerado em: " + cLocArq + cArq)
		else
			msgAlert("Arquivo não copiado para o Diretorio " + cLocArq + cArq)
		endif
	else
		msgAlert("Não foram encontrados dados com os parâmetros informados.")
	endif

	QRYSE2->( DBCloseArea() )

	restArea( aAreaX )
return

//******************************************************
//******************************************************
static function getSE2()
	local cQrySE2 := ""

	cQrySE2 := " SELECT"																+ CRLF
	cQrySE2 += " SE2FAT.E2_FILIAL FILFAT	," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_FATURA			," 											+ CRLF
	cQrySE2 += " SE2FAT.E2_VENCREA VENCFAT 	," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_VENCREA VENCTIT 	," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_FILIAL FILTIT 	," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_NUM 				," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_PREFIXO 			," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_TIPO				," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_FORNECE			," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_LOJA				," 											+ CRLF
	cQrySE2 += " SA2.A2_NOME				," 											+ CRLF
	cQrySE2 += " SE2TIT.E2_VALOR			,"											+ CRLF
	cQrySE2 += " SEA.EA_NUMBOR"															+ CRLF
	cQrySE2 += " FROM "			+ retSQLName("SE2") + " SE2TIT" 						+ CRLF
	cQrySE2 += " INNER JOIN "	+ retSQLName("SE2") + " SE2FAT" 						+ CRLF
	cQrySE2 += " ON" 																	+ CRLF
	cQrySE2 += " 		SE2FAT.E2_FATURA    =   'NOTFAT'" 								+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_TIPO      =   'FT'" 									+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_PREFIXO   =   'FAT'" 									+ CRLF

	// Loja nao sera considerada devido dados bancarios estarem na loja 01
	//cQrySE2 += " 	AND SE2FAT.E2_LOJA      =   SE2TIT.E2_LOJA" 						+ CRLF

	cQrySE2 += " 	AND SE2FAT.E2_FORNECE   =   SE2TIT.E2_FORNECE" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_NUM       =   SE2TIT.E2_FATURA" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.D_E_L_E_T_   <>  '*'" 									+ CRLF

	if !empty( MV_PAR02 )
		cQrySE2 += " 	AND SE2FAT.E2_VENCREA	>=	'" + dToS( MV_PAR02 ) + "'" 				+ CRLF
	endif

	if !empty( MV_PAR03 )
		cQrySE2 += " 	AND SE2FAT.E2_VENCREA	<=	'" + dToS( MV_PAR03 ) + "'" 				+ CRLF
	endif

	cQrySE2 += " INNER JOIN "	+ retSQLName("SA2") + " SA2"	 						+ CRLF
	cQrySE2 += " ON" 																	+ CRLF
	cQrySE2 += " 		SE2TIT.E2_LOJA      =   SA2.A2_LOJA" 							+ CRLF
	cQrySE2 += " 	AND SE2TIT.E2_FORNECE   =   SA2.A2_COD" 							+ CRLF
	cQrySE2 += " 	AND SA2.D_E_L_E_T_   	<>  '*'" 									+ CRLF

	cQrySE2 += " LEFT JOIN "	+ retSQLName("SEA") + " SEA" 							+ CRLF
	cQrySE2 += " ON" 																	+ CRLF
	cQrySE2 += " 		SE2FAT.E2_LOJA		=   SEA.EA_LOJA" 							+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_FORNECE	=   SEA.EA_FORNECE" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_TIPO		=   SEA.EA_TIPO" 							+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_PARCELA	=   SEA.EA_PARCELA" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_NUM		=   SEA.EA_NUM" 							+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_PREFIXO	=   SEA.EA_PREFIXO" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_FILIAL	=   SEA.EA_FILORIG" 						+ CRLF
	cQrySE2 += " 	AND SE2FAT.E2_NUMBOR	=   SEA.EA_NUMBOR" 							+ CRLF
	cQrySE2 += " 	AND SEA.EA_FILIAL		=	'" + xFilial("SEA") + "'" 				+ CRLF
	cQrySE2 += " 	AND SEA.D_E_L_E_T_		<>   '*'" 									+ CRLF

	// EA_NUMBOR	+EA_FILORIG	+EA_PREFIXO	+EA_NUM	+EA_PARCELA	+EA_TIPO	+EA_FORNECE	+EA_LOJA
	// E2_NUMBOR	+E2_FILIAL	+E2_PREFIXO	+E2_NUM	+E2_PARCELA	+E2_TIPO	+E2_FORNECE	+E2_LOJA

	cQrySE2 += " WHERE" 																+ CRLF
	cQrySE2 += " 		SE2TIT.D_E_L_E_T_  <>   '*'" 									+ CRLF

	if !empty( MV_PAR04 )
		cQrySE2 += " 	AND SE2TIT.E2_VENCREA	>=	'" + dToS( MV_PAR04 ) + "'" 				+ CRLF
	endif

	if !empty( MV_PAR05 )
		cQrySE2 += " 	AND SE2TIT.E2_VENCREA	<=	'" + dToS( MV_PAR05 ) + "'" 				+ CRLF
	endif

	cQrySE2 += " ORDER BY SE2TIT.E2_FATURA" 											+ CRLF

	memoWrite( "C:\TEMP\" + funName() + ".sqL" , cQrySE2 )

	tcQuery cQrySE2 New Alias "QRYSE2"
return