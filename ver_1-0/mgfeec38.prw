#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
	Gatilho GENSET para Pedido de EXP
*/
user function MGFEEC38(cFldAt, xValDef)
	local xRetDef		:= xValDef
	local cSY9Genset	:= ""
	local cSA1Genset	:= ""
	local cSYCGenset	:= ""
	local cSB1Gense		:= ""
	local cSYCGense2	:= ""
	local cMotGenset	:= ""
	local cZBMGenset	:= ""

	local aAreaX		:= getArea()

	M->EE7_ZGENSE := "N"
	M->EE7_ZMTGEN := ""

/*
Importador e Familia
	ou
Porto e Familia
	ou
Produto e Familia
	ou
Produto e Via
*/
	cSY9Genset	:= getAdvFVal( "SY9", "Y9_ZGENSET"	, xFilial("SY9") + M->EE7_DEST						, 2, "" ) // DESTINO
	cSA1Genset	:= getAdvFVal( "SA1", "A1_ZGENSET"	, xFilial("SA1") + M->EE7_IMPORT + M->EE7_IMLOJA	, 1, "" ) // CLIENTE
	cSYCGenset	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + M->EE7_ZTPROD					, 1, "" ) // FAMILIA CABECALHO
	cSYQGenset	:= getAdvFVal( "SYQ", "YQ_ZGENSET"	, xFilial("SYQ") + M->EE7_VIA						, 1, "" ) // VIA CABECALHO
	cZBMGenset	:= getAdvFVal( "ZBM", "ZBM_ZGENSE"	, xFilial("ZBM") + M->EE7_ZCODES					, 1, "" ) // LOCAL ESTUFAGEM

	if cSYCGenset == "S"
		cMotGenset += "Familia " + left( allTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + M->EE7_ZTPROD, 1, "" ) ), 15 )	+ " " 
	endif

	if cSA1Genset == "S" .AND. cSYCGenset == "S" // Importador e Familia
		M->EE7_ZGENSE := "S"
		cMotGenset += "Cliente " + left( allTrim( getAdvFVal( "SA1", "A1_NOME", xFilial("SA1") + M->EE7_IMPORT + M->EE7_IMLOJA	, 1, "" ) ), 15 )	+ " "
	endif

	// Valdir solicitou que o porto seja somente considerado na empresa 01 e retirar regra com familia
	if cSY9Genset == "S" .and. Substr(cFilAnt,1,2) == "01" //.AND. cSYCGenset == "S" // Porto e Familia 
		M->EE7_ZGENSE := "S"
		cMotGenset += "Destino " + left( allTrim( getAdvFVal( "SY9", "Y9_DESCR"	, xFilial("SY9") + M->EE7_DEST, 2, "" ) ) , 15 ) + " "
	endif

	if cZBMGenset == "S" .AND. cSYCGenset == "S" // Local Estufagem e Familia
		M->EE7_ZGENSE := "S"
		cMotGenset += "Local Estufagem " + left( allTrim( getAdvFVal( "ZBM", "ZBM_DESCRI"	, xFilial("ZBM") + M->EE7_ZCODES, 1, "" ) ), 15 )				+ " "
	endif

	if cFldAt == "EE8_COD_I" .OR. cFldAt == "EE8_FPCOD"
		M->EE8_ZGENSE := "N"

		cSB1Gense	:= ""
		cSYCGense2	:= ""

		cSB1Gense	:= getAdvFVal( "SB1", "B1_ZGENSET"	, xFilial("SB1") + M->EE8_COD_I		, 1, "" ) // PRODUTO
		cSYCGense2	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + M->EE8_FPCOD		, 1, "" ) // FAMILIA ITEM

		if cSB1Gense == "S"
			M->EE8_ZGENSE := "S"
		endif
		
		
		if cSB1Gense == "S" .AND. cSYQGenset == "S"
			cMotGenset += "Item " + allTrim( M->EE8_COD_I )
			cMotGenset += " e Via " + left( allTrim( getAdvFVal( "SYQ", "YQ_DESCR"	, xFilial("SYQ") + M->EE7_VIA, 1, "" ) ), 15 ) + " "

			M->EE7_ZGENSE := "S"
		endif

		if cSB1Gense == "S" .AND. cSYCGense2 == "S"

			cMotGenset += "Item " + allTrim( M->EE8_COD_I )
			cMotGenset += " e familia " + left( allTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + M->EE8_FPCOD, 1, "" ) ), 15 ) + " "

			M->EE7_ZGENSE := "S"
		endif
	else
		WORKIT->(DbGoTop())
		while !WORKIT->(EOF())
			WORKIT->EE8_ZGENSE := "N"

			cSB1Gense	:= ""
			cSYCGense2	:= ""

			cSB1Gense	:= getAdvFVal( "SB1", "B1_ZGENSET"	, xFilial("SB1") + WORKIT->EE8_COD_I	, 1, "" ) // PRODUTO
			cSYCGense2	:= getAdvFVal( "SYC", "YC_ZGENSET"	, xFilial("SYC") + WORKIT->EE8_FPCOD	, 1, "" ) // FAMILIA ITEM

			if cSB1Gense == "S"
				WORKIT->EE8_ZGENSE := "S"
			endif

			if cSB1Gense == "S" .AND. cSYQGenset == "S"
				cMotGenset += "Item " + allTrim( WORKIT->EE8_COD_I )
				cMotGenset += " e Via " + left( allTrim( getAdvFVal( "SYQ", "YQ_DESCR"	, xFilial("SYQ") + M->EE7_VIA, 1, "" ) ), 15 ) + " "

				M->EE7_ZGENSE := "S"
			endif

			if cSB1Gense == "S" .AND. cSYCGense2 == "S"
				cMotGenset += "Item " + allTrim( WORKIT->EE8_COD_I )
				cMotGenset += " e familia " + left( allTrim( getAdvFVal( "SYC", "YC_NOME"	, xFilial("SYC") + WORKIT->EE8_FPCOD, 1, "" ) ), 15 ) + " "

				M->EE7_ZGENSE := "S"
			endif

			WORKIT->(DBSkip())
		enddo	
	endif

	if M->EE7_ZGENSE == "S" .AND. !empty(cMotGenset)
		M->EE7_ZMTGEN := left(cMotGenset, TAMSX3("EE7_ZMTGEN")[1])
	endif

	restArea( aAreaX )
return xRetDef