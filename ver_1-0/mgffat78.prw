#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10  )

//---------------------------------------------------------------------
// Caso a Nota seja de Pedido do SFA.. Atualiza quantidade Faturada e marca como Pendente para reintegração
//---------------------------------------------------------------------
user function MGFFAT78()
	local cQrySD2	:= ""
	local cUpdSC5	:= ""
	local aArea		:= getArea()
	local aAreaZC5	:= ZC5->( getArea() )
	local aAreaZC6	:= ZC6->( getArea() )

	cQrySD2 += "SELECT DISTINCT F2_DOC, F2_SERIE, D2_PEDIDO, D2_ITEM, D2_COD, D2_QUANT, C5_NUM, C5_XIDSFA, ZC5.R_E_C_N_O_ ZC5RECNO, LPAD(TRIM(ZC6_ITEM), 2, '0'), ZC6_PRODUT, ZC6.R_E_C_N_O_ ZC6RECNO" + CRLF
	cQrySD2 += " FROM       " + retSQLName("SF2") + " SF2" 							+ CRLF
	cQrySD2 += " INNER JOIN " + retSQLName("SD2") + " SD2" 							+ CRLF
	cQrySD2 += " ON" 														+ CRLF
	cQrySD2 += "        SD2.D2_LOJA     =   SF2.F2_LOJA" 					+ CRLF
	cQrySD2 += "	AND SD2.D2_CLIENTE  =   SF2.F2_CLIENTE" 				+ CRLF
	cQrySD2 += "	AND SD2.D2_SERIE    =   SF2.F2_SERIE" 					+ CRLF
	cQrySD2 += "	AND SD2.D2_DOC      =   SF2.F2_DOC" 					+ CRLF
	cQrySD2 += "	AND SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'" 		+ CRLF
	cQrySD2 += "	AND SD2.D_E_L_E_T_	=	' '" 							+ CRLF
	cQrySD2 += " INNER JOIN " + retSQLName("SC5") + " SC5" 							+ CRLF
	cQrySD2 += " ON" 														+ CRLF
	cQrySD2 += "        SC5.C5_LOJACLI  =   SD2.D2_LOJA" 					+ CRLF
	cQrySD2 += "    AND SC5.C5_CLIENTE  =   SD2.D2_CLIENTE" 				+ CRLF
	cQrySD2 += "    AND SC5.C5_NUM      =   SD2.D2_PEDIDO" 					+ CRLF
	cQrySD2 += "    AND SC5.C5_FILIAL   =   '" + xFilial("SC5") + "'" 		+ CRLF
	cQrySD2 += "    AND SC5.D_E_L_E_T_  =   ' '" 							+ CRLF
	cQrySD2 += " INNER JOIN " + retSQLName("ZC5") + " ZC5" 					+ CRLF
	cQrySD2 += " ON" 														+ CRLF
	cQrySD2 += "        ZC5.ZC5_IDSFA   =   SC5.C5_XIDSFA" 					+ CRLF
	cQrySD2 += "    AND ZC5.ZC5_FILIAL  =   '" + xFilial("ZC5") + "'" 		+ CRLF
	cQrySD2 += "    AND ZC5.D_E_L_E_T_  =   ' '" 							+ CRLF
	cQrySD2 += " INNER JOIN " + retSQLName("ZC6") + " ZC6" 					+ CRLF
	cQrySD2 += " ON" 														+ CRLF
	cQrySD2 += "        ZC6.ZC6_PRODUT	=   SD2.D2_COD" 					+ CRLF
	cQrySD2 += "    AND	LPAD(TRIM(ZC6.ZC6_ITEM),2,'0')    =   SD2.D2_ITEM"	+ CRLF
	cQrySD2 += "    AND ZC6.ZC6_IDSFA	=   ZC5.ZC5_IDSFA" 					+ CRLF
	cQrySD2 += "    AND ZC6.ZC6_FILIAL	=   '" + xFilial("ZC6") + "'" 		+ CRLF
	cQrySD2 += "    AND ZC6.D_E_L_E_T_	=   ' '" 							+ CRLF
	cQrySD2 += " WHERE" 													+ CRLF
	cQrySD2 += "    	SF2.R_E_C_N_O_	=   "	+ STR( SF2->(RECNO()) )	+ "" 	+ CRLF
	cQrySD2 += "    AND	SF2.F2_FILIAL	=   '"	+ xFilial("SF2")	+ "'" 	+ CRLF
	cQrySD2 += "    AND SF2.D_E_L_E_T_	=   ' '" 							+ CRLF

	tcQuery cQrySD2 New Alias "QRYSD2"

	DBSelectArea("ZC5")
	DBSelectArea("ZC6")

	if !QRYSD2->(EOF())
		while !QRYSD2->(EOF())
			ZC6->( DBGoTo( QRYSD2->ZC6RECNO ) )

			recLock( "ZC6", .F. )
				ZC6->ZC6_QTDFAT := QRYSD2->D2_QUANT
			ZC6->( msUnlock() )

			QRYSD2->(DBSkip())
		enddo

		QRYSD2->(DBGoTop())

		ZC5->( DBGoTo( QRYSD2->ZC5RECNO ) )

		recLock( "ZC5", .F. )
			ZC5->ZC5_INTEGR := "P"
		ZC5->( msUnlock() )
	endif

	QRYSD2->(DBCloseArea())
	ZC5->(DBCloseArea())
	ZC6->(DBCloseArea())

	// ATUALIZA PEDIDO DE VENDA - SC5
	cUpdSC5 := "UPDATE " + retSQLName("SC5")											+ CRLF
	cUpdSC5 += " SET"																	+ CRLF
	cUpdSC5 += "	C5_XINTEGR = 'P'"													+ CRLF
	cUpdSC5 += " WHERE"																	+ CRLF
	cUpdSC5 += "		D_E_L_E_T_ = ' '"												+ CRLF
	cUpdSC5 += "	AND	C5_FILIAL	||	C5_NUM IN"										+ CRLF
	cUpdSC5 += "	("																	+ CRLF
	cUpdSC5 += " 		SELECT DISTINCT D2_FILIAL || D2_PEDIDO"							+ CRLF
	cUpdSC5 += " 		FROM       " + retSQLName("SF2") + " SF2" 						+ CRLF
	cUpdSC5 += " 		INNER JOIN " + retSQLName("SD2") + " SD2" 						+ CRLF
	cUpdSC5 += " 		ON" 															+ CRLF
	cUpdSC5 += "    	    SD2.D2_LOJA		=   SF2.F2_LOJA" 							+ CRLF
	cUpdSC5 += "		AND SD2.D2_CLIENTE  =   SF2.F2_CLIENTE" 						+ CRLF
	cUpdSC5 += "		AND SD2.D2_SERIE    =   SF2.F2_SERIE" 							+ CRLF
	cUpdSC5 += "		AND SD2.D2_DOC      =   SF2.F2_DOC" 							+ CRLF
	cUpdSC5 += "		AND SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'" 				+ CRLF
	cUpdSC5 += "		AND SD2.D_E_L_E_T_	=	' '" 									+ CRLF
	cUpdSC5 += " 		WHERE" 															+ CRLF
	cUpdSC5 += "    			SF2.R_E_C_N_O_	=   "	+ STR( SF2->(RECNO()) )	+ ""	+ CRLF
	cUpdSC5 += "    	AND	SF2.F2_FILIAL		=   '"	+ xFilial("SF2")		+ "'" 	+ CRLF
	cUpdSC5 += "    	AND	SF2.D_E_L_E_T_		=   ' '" 								+ CRLF
	cUpdSC5 += "	)"

	tcSQLExec( cUpdSC5 )

	if tcSQLExec( cUpdSC5 ) < 0
		conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
	endif

	restArea( aAreaZC6 )
	restArea( aAreaZC5 )
	restArea( aArea )
return