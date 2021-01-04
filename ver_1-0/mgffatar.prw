#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
-----------------------------------------------------
	Chamado pelo PE MT103FIM

	Solicita o cancelamento de compras de Cartão de Crédito
-----------------------------------------------------
*/
user function MGFFATAR()
	local cQrySE1		:= ""
	local aAreaX		:= getArea()
	local aAreaSE1		:= SE1->(getArea())
	local nOpcao 		:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
	local nConfirma 	:= PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO.....
	local aBaixa		:= {}
	local cMotBx		:= ""
	local cHistBx		:= ""
	local cAccessTok	:= ""
	local cUpdSE1		:= ""
	local cUpdXC5		:= ""
	local oCancel		:= nil
	local cHist			:= ""
	local lCredEcom		:= .F.
	local cUpdTbl		:= ""

	if ( nOpcao == 3 .or. nOpcao == 4 ) .and. nConfirma == 1 .and. SF1->F1_TIPO == "D"
		getSF2Ecom()

		if !QRYSF2->(EOF())
			cQrySE1	:= ""

			cQrySE1 := "SELECT SE1.R_E_C_N_O_ SE1RECNO"								+ CRLF
			cQrySE1 += " FROM " + retSQLName("SE1") + " SE1"						+ CRLF	
			cQrySE1 += " WHERE"														+ CRLF
			cQrySE1 += " 		SE1.E1_TIPO     =   'NCC'"							+ CRLF
			cQrySE1 += "	AND	SE1.E1_PREFIXO	=	'" + SF1->F1_SERIE		+ "'"	+ CRLF
			cQrySE1 += "	AND	SE1.E1_NUM		=	'" + SF1->F1_DOC		+ "'"	+ CRLF
			cQrySE1 += "	AND	SE1.E1_LOJA		=	'" + SF1->F1_LOJA		+ "'"	+ CRLF
			cQrySE1 += "	AND	SE1.E1_CLIENTE	=	'" + SF1->F1_FORNECE	+ "'"	+ CRLF
			cQrySE1 += "	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1")		+ "'"	+ CRLF
			cQrySE1 += " 	AND	SE1.D_E_L_E_T_	<>	'*'"							+ CRLF

			tcQuery cQrySE1 New Alias "QRYSE1"

			if !QRYSE1->(EOF())
				if !empty( QRYSF2->XC5_PAYMID ) // Pedidos com Cartão - Devolve apenas em cartão	
					cAccessTok := ""
					cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet
	
					if !empty( cAccessTok )
						aCancel := {}
	
						if sToD( QRYSF2->XC5_DTRECE ) == dDataBase
							// Mesmo dia - Cancelamento D + 0
							aCancel := u_canGtnt0( cAccessTok, allTrim( QRYSF2->XC5_PAYMID ), int( ( QRYSF2->VALORDEV * 100 ) ), QRYSF2->XC5_FILIAL + QRYSF2->XC5_PVPROT )

							if aCancel[1]
								oCancel := nil
								if fwJsonDeserialize( aCancel[2], @oCancel )
									cUpdSE1	:= ""

									cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
									cUpdSE1 += "	SET"															+ CRLF
									cUpdSE1 += " 		E1_ZSTEC	=	'1',"										+ CRLF
									cUpdSE1 += " 		E1_ZNSU		=	'" + allTrim( QRYSF2->XC5_NSU ) + "'"					+ CRLF
									cUpdSE1 += " WHERE"																+ CRLF
									cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSE1->SE1RECNO ) ) + ""	+ CRLF

									if tcSQLExec( cUpdSE1 ) < 0
										conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
									endif

									cUpdZE6	:= ""

									cUpdZE6 := "UPDATE " + retSQLName("ZE6")								+ CRLF
									cUpdZE6 += "	SET"													+ CRLF
									cUpdZE6 += " 		ZE6_STATUS = '5'"									+ CRLF
									cUpdZE6 += " WHERE"														+ CRLF
									cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( QRYSF2->XC5_NSU )	+ "'"	+ CRLF

									if tcSQLExec( cUpdZE6 ) < 0
										conout(" [MGFFATAR] [ZE6] Não foi possível executar UPDATE." + CRLF + tcSqlError())
									endif
								endif
							endif
						else
							// SOLICITA - Cancelamento D + N
							aCancel := u_canGtntN( cAccessTok, allTrim( QRYSF2->XC5_PAYMID ), int( ( QRYSF2->VALORDEV * 100 ) ), QRYSF2->XC5_FILIAL + QRYSF2->XC5_PVPROT )
	
							if aCancel[1]
								cUpdSE1	:= ""

								cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
								cUpdSE1 += "	SET"															+ CRLF
								cUpdSE1 += " 		E1_ZSTEC	=	'0',"										+ CRLF
								cUpdSE1 += " 		E1_ZNSU		=	'" + allTrim( QRYSF2->XC5_NSU ) + "'"					+ CRLF
								cUpdSE1 += " WHERE"																+ CRLF
								cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSE1->SE1RECNO ) ) + ""	+ CRLF

								if tcSQLExec( cUpdSE1 ) < 0
									conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
								endif
							endif
						endif
					endif
				else // Pedidos em Boleto - Informa no Título se devolve Em Depósito ou em Crédito
					lCredEcom := RAMICrdEco( QRYSF2->SF2RECNO )

					// Depósito em Conta
					cUpdSE1	:= ""

					cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
					cUpdSE1 += "	SET"															+ CRLF

					if lCredEcom
						cUpdSE1 += " 		E1_ZCREDEC	= 'S'"											+ CRLF
					else
						cUpdSE1 += " 		E1_HIST		= 'Cliente solicita devolução em Conta',"		+ CRLF
						cUpdSE1 += " 		E1_ZCREDEC	= 'N'"											+ CRLF
					endif

					cUpdSE1 += " WHERE"																+ CRLF
					cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSE1->SE1RECNO ) ) + ""	+ CRLF

					if tcSQLExec( cUpdSE1 ) < 0
						conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
					endif

					if lCredEcom
						// Atualiza cliente para Credito ser enviado ao e-commerce
						cUpdTbl	:= ""

						cUpdTbl := "UPDATE " + retSQLName("SA1")							+ CRLF
						cUpdTbl += "	SET"												+ CRLF
						cUpdTbl += " 		A1_XINTECO = '0',"								+ CRLF
						cUpdTbl += " 		A1_XENVECO = '1'"								+ CRLF
						cUpdTbl += " WHERE"													+ CRLF
						cUpdTbl += "		A1_LOJA		=	'" + SF1->F1_LOJA		+ "'"	+ CRLF
						cUpdTbl += "	AND	A1_COD		=	'" + SF1->F1_FORNECE	+ "'"	+ CRLF
						cUpdTbl += "	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

						if tcSQLExec( cUpdTbl ) < 0
							conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						endif
					endif
				endif
			endif
			QRYSE1->(DBCloseArea())
		endif

		QRYSF2->(DBCloseArea())
	endif

	restArea( aAreaSE1 )
	restArea( aAreaX )
return

//-----------------------------------------------------------
// Verifica se a Nota de SAIDA é de E-Commerce com Cartao de Crédito
//-----------------------------------------------------------
static function getSF2Ecom()
	local cQrySF2	:= ""

	cQrySF2 := "SELECT"																						+ CRLF
	cQrySF2 += " XC5_DTRECE					, XC5_PAYMID, XC5_FILIAL, XC5_PVPROT, XC5.R_E_C_N_O_ XC5RECNO,"	+ CRLF
	cQrySF2 += " XC5_NSU					,"																+ CRLF
	cQrySF2 += " SF2.R_E_C_N_O_	SF2RECNO	,"																+ CRLF
	cQrySF2 += " SE1.R_E_C_N_O_	SE1RECNO	,"																+ CRLF
	cQrySF2 += " SUM(D1_TOTAL)	VALORDEV"																	+ CRLF

	cQrySF2 += " FROM SF1010 SF1"																			+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("SD1") + " SD1"					+ CRLF
	cQrySF2 += " ON
	cQrySF2 += "		SD1.D1_FORNECE	=	SF1.F1_FORNECE"					+ CRLF
	cQrySF2 += "	AND	SD1.D1_LOJA		=	SF1.F1_LOJA"					+ CRLF
	cQrySF2 += "	AND	SD1.D1_SERIE	=	SF1.F1_SERIE"					+ CRLF
	cQrySF2 += "	AND	SD1.D1_DOC		=	SF1.F1_DOC"						+ CRLF
	cQrySF2 += "	AND	SD1.D1_FILIAL	=	'" + xFilial("SD1") + "'"		+ CRLF
	cQrySF2 += "	AND	SD1.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("SD2") + " SD2"					+ CRLF
	cQrySF2 += " ON"														+ CRLF
	cQrySF2 += "		SD2.D2_ITEM     =	SD1.D1_ITEMORI"					+ CRLF
	cQrySF2 += "	AND	SD2.D2_SERIE    =	SD1.D1_SERIORI"					+ CRLF
	cQrySF2 += "	AND	SD2.D2_DOC		=	SD1.D1_NFORI"					+ CRLF
	cQrySF2 += "	AND	SD2.D2_FILIAL 	=	'" + xFilial("SD2") + "'"		+ CRLF
	cQrySF2 += "	AND	SD2.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("SF2") + " SF2"					+ CRLF
	cQrySF2 += " ON"														+ CRLF
	cQrySF2 += "		SF2.F2_LOJA   	=	SD2.D2_LOJA"					+ CRLF
	cQrySF2 += "	AND	SF2.F2_CLIENTE	=	SD2.D2_CLIENTE"					+ CRLF
	cQrySF2 += "	AND	SF2.F2_SERIE	=	SD2.D2_SERIE"					+ CRLF
	cQrySF2 += "	AND	SF2.F2_DOC		=	SD2.D2_DOC"						+ CRLF
	cQrySF2 += "	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"		+ CRLF
	cQrySF2 += "	AND	SF2.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("SC5") + " SC5"					+ CRLF
	cQrySF2 += " ON"														+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	<>	' '"							+ CRLF
	//cQrySF2 += "	AND	SC5.C5_ZNSU		<>	' '"							+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"						+ CRLF
	cQrySF2 += "	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"		+ CRLF
	cQrySF2 += "	AND	SC5.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("XC5") + " XC5"					+ CRLF
	cQrySF2 += " ON"														+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	=	XC5.XC5_IDECOM"					+ CRLF
	//cQrySF2 += "	AND	XC5.XC5_NSU		<>	' '"							+ CRLF
	cQrySF2 += "	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5") + "'"		+ CRLF
	cQrySF2 += "	AND	XC5.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " INNER JOIN " + retSQLName("SE1") + " SE1"					+ CRLF
	cQrySF2 += " ON"														+ CRLF
	//cQrySF2 += "		SE1.E1_ZNSU		=	SC5.C5_ZNSU"					+ CRLF
	//cQrySF2 += "	AND	SE1.E1_ZPEDIDO	=	SC5.C5_NUM"						+ CRLF
	cQrySF2 += "		SE1.E1_ZPEDIDO	=	SC5.C5_NUM"						+ CRLF
	cQrySF2 += "	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"		+ CRLF
	cQrySF2 += "	AND	SE1.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " WHERE"														+ CRLF
	cQrySF2 += "		SF1.F1_SERIE	=	'" + SF1->F1_SERIE		+ "'"	+ CRLF
	cQrySF2 += "	AND	SF1.F1_DOC		=	'" + SF1->F1_DOC		+ "'"	+ CRLF
	cQrySF2 += "	AND	SF1.F1_LOJA		=	'" + SF1->F1_LOJA		+ "'"	+ CRLF
	cQrySF2 += "	AND	SF1.F1_FORNECE	=	'" + SF1->F1_FORNECE	+ "'"	+ CRLF
	cQrySF2 += " 	AND	SF1.F1_FILIAL	=	'" + xFilial("SF1") 	+ "'"	+ CRLF
	cQrySF2 += " 	AND	SF1.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySF2 += " GROUP BY"													+ CRLF

	cQrySF2 += " XC5_DTRECE		, XC5_PAYMID, XC5_FILIAL, XC5_PVPROT, XC5.R_E_C_N_O_,"			+ CRLF
	cQrySF2 += " XC5_NSU		,"																+ CRLF
	cQrySF2 += " SF2.R_E_C_N_O_	,"																+ CRLF
	cQrySF2 += " SE1.R_E_C_N_O_"																+ CRLF

	conout(" [MGFFATAR] [getSF2Ecom] " + cQrySF2)

	tcQuery cQrySF2 New Alias "QRYSF2"
return

//-----------------------------------------------------------
// Retorna o tipo de devolução solicitado eplo cliente na RAMI
// Crédito ou Depósito
// ZAV_DEVECO
// ZAV_CREDEC
// 1 - Credito no E-Commerce
// 0 - Depósito em conta
//-----------------------------------------------------------
static function RAMICrdEco( nSF2Recno )
	local cQryZAV	:= ""
	local lCredEcom	:= .F.

	//cQryZAV := "SELECT ZAV_CLIENT, ZAV_LOJA, ZAV_NOTA, ZAV_SERIE, ZAV_DEVECO"	+ CRLF
	cQryZAV := "SELECT ZAV_CLIENT, ZAV_LOJA, ZAV_NOTA, ZAV_SERIE, ZAV_CREDEC"	+ CRLF
	cQryZAV += " FROM "			+ retSQLName("ZAV") + " ZAV"					+ CRLF
	cQryZAV += " INNER JOIN "	+ retSQLName("SF2") + " SF2"					+ CRLF
	cQryZAV += " ON"															+ CRLF
	cQryZAV += "		ZAV.ZAV_SERIE 	=	SF2.F2_SERIE"						+ CRLF
	cQryZAV += "	AND	ZAV.ZAV_NOTA  	=	SF2.F2_DOC"							+ CRLF
	cQryZAV += "	AND	ZAV.ZAV_LOJA  	=	SF2.F2_LOJA"						+ CRLF
	cQryZAV += "	AND	ZAV.ZAV_CLIENT	=	SF2.F2_CLIENTE"						+ CRLF
	cQryZAV += " 	AND	ZAV.ZAV_FILIAL	=	SF2.F2_FILIAL"						+ CRLF
	cQryZAV += " 	AND	SF2.R_E_C_N_O_	=	" + allTrim( str( nSF2Recno ) )		+ CRLF
	cQryZAV += " 	AND	SF2.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryZAV += " WHERE"															+ CRLF
	cQryZAV += "		ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV")		+ "'"		+ CRLF
	cQryZAV += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"								+ CRLF

	conout( " [MGFFATAR] [RAMICrdEco] " + cQryZAV )

	tcQuery cQryZAV New Alias "QRYZAV"

	if !QRYZAV->(EOF())
		lCredEcom := ( QRYZAV->ZAV_CREDEC == "S" )
	endif

	QRYZAV->(DBCloseArea())
return lCredEcom