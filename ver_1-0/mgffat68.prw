#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

user function MGFFAT68()
	local cQrySC5		:= ""
	local aRet			:= {}
	local nPVBloq		:= 0
	local aItemLib		:= {}
	local nSaldoProd	:= 0
	local aArea			:= getArea()
	local aAreaSC5		:= SC5->(getArea())
	local cStockUsr		:= allTrim(getMv("MGF_FAT68A"))

	if !( retCodUsr() $ cStockUsr )
		msgAlert("Usuário sem permissão para liberar estoque!")
		return
	endif

	DBSelectArea("SC5")

	cQrySC5 += " SELECT"																						+ CRLF
	cQrySC5 += " SC5.R_E_C_N_O_ C5RECNO, C5_FILIAL, C5_NUM, C5_ZTIPPED, C6_PRODUTO, C6_ZDTMIN, C6_ZDTMAX, C6_QTDVEN, C6_QTDENT, ZV_CODRGA, C6_ITEM"	+ CRLF
	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"													+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SC6") + " SC6"													+ CRLF
	cQrySC5 += " ON"																							+ CRLF
	cQrySC5 += "		SC6.C6_NUM		=	SC5.C5_NUM"															+ CRLF
	cQrySC5 += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"														+ CRLF
	cQrySC5 += " 	AND	SC6.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SZV") + " SZV"													+ CRLF
	cQrySC5 += " ON"																							+ CRLF
	cQrySC5 += "		SZV.ZV_CODRJC	=	'      '"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_CODAPR	=	'      '"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_CODRGA	=	'000011'"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_ITEMPED	=	SC6.C6_ITEM"														+ CRLF
	cQrySC5 += "	AND	SZV.ZV_PEDIDO	=	SC5.C5_NUM"															+ CRLF
	cQrySC5 += " 	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"														+ CRLF
	cQrySC5 += " 	AND	SZV.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " WHERE"																							+ CRLF
	cQrySC5 += " "																								+ CRLF
	cQrySC5 += " 		SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"											+ CRLF
	cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " ORDER BY C5_NUM, C6_ITEM"																		+ CRLF

	memoWrite( "C:\TEMP\MGFCRM68.SQL", cQrySC5 )

	tcQuery cQrySC5 New Alias "QRYSC5"

	if !QRYSC5->(EOF())
		while !QRYSC5->(EOF())
			SC5->( DBGoTo( QRYSC5->C5RECNO ) )

			aRetSaldo := { 0 , 0 }
			aRetSaldo := staticCall( MGFWSC05, getSalProt, QRYSC5->C6_PRODUTO, SC5->C5_NUM, SC5->C5_FILIAL, .F., QRYSC5->C6_ZDTMIN, QRYSC5->C6_ZDTMAX )

			if aRetSaldo[1] >= ( QRYSC5->C6_QTDVEN - QRYSC5->C6_QTDENT )
				aItemLib := { { QRYSC5->C5_FILIAL, QRYSC5->C5_NUM, QRYSC5->C6_ITEM, QRYSC5->ZV_CODRGA } }

				staticCall( MGFFAT64, aprovaPv, .T., aItemLib )
			endif

			QRYSC5->(DBSkip())
		enddo

		QRYSC5->(DBCloseArea())

		staticCall( MGFFAT64, buscaPV )
	else
		msgAlert("Nenhum Pedido com bloqueio de estoque encontrado!")
	endif

	if select("QRYSC5") > 0
		QRYSC5->(DBCloseArea())
	endif

	restArea(aAreaSC5)
	restArea(aArea)
return