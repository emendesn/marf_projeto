#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
-----------------------------------------------------
	Consulta a solicitação de Estorno

	u_retCanGt - Essa rotina sera substituida por sistema de call back
-----------------------------------------------------
*/
//-------------------------------------------------------------------
// Para ser chamado em JOB
//-------------------------------------------------------------------
user function JOBFATAS( cFilJob )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA left( cFilJob, 2 ) FILIAL cFilJob

		conout('[MGFFATAS] Iniciada Threads para a empresa' + allTrim( cFilJob ) + ' - ' + dToC(dDataBase) + " - " + time())

		U_MGFFATAS()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MGFFATAS()
	local cQrySE1		:= ""
	local aAreaX		:= getArea()
	local aAreaSE1		:= SE1->(getArea())
	local aBaixa		:= {}
	local cMotBx		:= ""
	local cHistBx		:= ""
	local cAccessTok	:= ""
	local cUpdSE1		:= ""
	local aErro			:= {}
	local cErro			:= ""
	local aCancel		:= {}
	local oCancel		:= nil

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	getSE1Baix()

	while !QRYSE1->(EOF())
		cAccessTok := ""
		cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet

		if !empty( cAccessTok )
			oCancel	:= nil
			aCancel	:= {}

			// CONSULTA SOLICITACAO DE CANCELAMENTO
			aCancel := u_retCanPV( cAccessTok, allTrim( QRYSE1->XC5_FILIAL + QRYSE1->XC5_PVPROT ) )
			if aCancel[1]
				oCancel := nil
				if fwJsonDeserialize( aCancel[2], @oCancel )
					if oCancel:status_processing_cancel_code == "100" // verificar status correto de cancelamento
						DBSelectArea("SE1")
						SE1->( DBGoTo( QRYSE1->SE1RECNO ) )
						if SE1->E1_SALDO > 0 .and. empty( SE1->E1_BAIXA )
							SE1->( reclock( "SE1" , .F. ) )
								SE1->E1_SITUACA := '0' //_cSituaca
							SE1->(MsUnlock())

					        cMotBx := ""
					        cHistBx	:= "Estorno via getnet ID Requisição: " + oCancel:cancel_request_id + " ID Adquirente: " + oCancel:acquirer_transaction_id

					        aBaixa := {}
							aadd( aBaixa , { "E1_FILIAL"   , SE1->E1_FILIAL		, nil 		} )
							aadd( aBaixa , { "E1_PREFIXO"  , SE1->E1_PREFIXO	, nil 		} )
							aadd( aBaixa , { "E1_NUM"      , SE1->E1_NUM		, nil 		} )
							aadd( aBaixa , { "E1_TIPO"     , SE1->E1_TIPO		, nil 		} )
							aadd( aBaixa , { "E1_PARCELA"  , SE1->E1_PARCELA	, nil 		} )
							aadd( aBaixa , { "E1_PARCELA"  , SE1->E1_VALOR		, nil 		} )
							aadd( aBaixa , { "AUTMOTBX"    , cMotBx				, nil 		} )
							aadd( aBaixa , { "AUTDTBAIXA"  , dDataBase			, nil 		} )
							aadd( aBaixa , { "AUTDTCREDITO", dDataBase			, nil 		} )
							aadd( aBaixa , { "AUTHIST"     , cHistBx			, nil 		} )
							aadd( aBaixa , { "AUTJUROS"    , 0					, nil , .T.	} )
							aadd( aBaixa , { "AUTNMULTA"   , 0					, nil , .T.	} )
							aadd( aBaixa , { "AUTDESCONT"  , 0					, nil , .T.	} )
							aadd( aBaixa , { "AUTVALREC"   , SE1->E1_VALOR		, nil		} )

							lMsErroAuto := .F.
							msExecAuto( { | x , y | FINA070( x , y ) } , aBaixa , 3 )

							if lMsErroAuto
								aErro := GetAutoGRLog() // Retorna erro em array
								cErro := ""

								for nI := 1 to len(aErro)
									cErro += aErro[nI] + CRLF
								next nI

								conout( " [MGFFATAS] [FINA070] " + cErro )
							else
								cUpdSE1	:= ""

								cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
								cUpdSE1 += "	SET"															+ CRLF
								cUpdSE1 += " 		E1_ZSTEC	=	'1'"										+ CRLF
								cUpdSE1 += " WHERE"																+ CRLF
								cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSE1->SE1RECNO ) ) + ""	+ CRLF

								if tcSQLExec( cUpdSE1 ) < 0
									conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
								endif
							endif
						endif
					endif
				endif
			endif
		endif

		QRYSE1->(DBSkip())
	enddo

	QRYSE1->(DBCloseArea())

	restArea( aAreaSE1 )
	restArea( aAreaX )
return

//-----------------------------------------------------------
// Verifica se a Nota de SAIDA é de E-Commerce com Cartao de Crédito
//-----------------------------------------------------------
static function getSE1Baix()
	local cQrySE1	:= ""

	cQrySE1 := " SELECT DISTINCT SE1.R_E_C_N_O_ SE1RECNO, XC5_FILIAL, XC5_PVPROT"	+ CRLF
	cQrySE1 += " FROM " + retSQLName("SE1") + " SE1"								+ CRLF
	cQrySE1 += " INNER JOIN " + retSQLName("SF1") + " SF1"					+ CRLF
	cQrySE1 += " ON"														+ CRLF
	cQrySE1 += "		SF1.F1_TIPO		=	'D'"							+ CRLF
	cQrySE1 += "	AND	SE1.E1_LOJA		=	SF1.F1_LOJA"					+ CRLF
	cQrySE1 += "	AND	SE1.E1_CLIENTE	=	SF1.F1_FORNECE"					+ CRLF
	cQrySE1 += "	AND	SE1.E1_NUM		=	SF1.F1_DOC"						+ CRLF
	cQrySE1 += "	AND	SE1.E1_PREFIXO	=	SF1.F1_SERIE"					+ CRLF
	cQrySE1 += "	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"		+ CRLF
	cQrySE1 += "	AND	SE1.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySE1 += " INNER JOIN " + retSQLName("SD1") + " SD1"					+ CRLF
	cQrySE1 += " ON
	cQrySE1 += "		SD1.D1_FORNECE	=	SF1.F1_FORNECE"					+ CRLF
	cQrySE1 += "	AND	SD1.D1_LOJA		=	SF1.F1_LOJA"					+ CRLF
	cQrySE1 += "	AND	SD1.D1_SERIE	=	SF1.F1_SERIE"					+ CRLF
	cQrySE1 += "	AND	SD1.D1_DOC		=	SF1.F1_DOC"						+ CRLF
	cQrySE1 += "	AND	SD1.D1_FILIAL	=	'" + xFilial("SD1") + "'"		+ CRLF
	cQrySE1 += "	AND	SD1.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySE1 += " INNER JOIN " + retSQLName("SD2") + " SD2"					+ CRLF
	cQrySE1 += " ON"														+ CRLF
	cQrySE1 += "		SD2.D2_ITEM     =	SD1.D1_ITEMORI"					+ CRLF
	cQrySE1 += "	AND	SD2.D2_SERIE    =	SD1.D1_SERIORI"					+ CRLF
	cQrySE1 += "	AND	SD2.D2_DOC		=	SD1.D1_NFORI"					+ CRLF
	cQrySE1 += "	AND	SD2.D2_FILIAL 	=	'" + xFilial("SD2") + "'"		+ CRLF
	cQrySE1 += "	AND	SD2.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySE1 += " INNER JOIN " + retSQLName("SF2") + " SF2"					+ CRLF
	cQrySE1 += " ON"														+ CRLF
	cQrySE1 += "		SF2.F2_LOJA   	=	SD2.D2_LOJA"					+ CRLF
	cQrySE1 += "	AND	SF2.F2_CLIENTE	=	SD2.D2_CLIENTE"					+ CRLF
	cQrySE1 += "	AND	SF2.F2_SERIE	=	SD2.D2_SERIE"					+ CRLF
	cQrySE1 += "	AND	SF2.F2_DOC		=	SD2.D2_DOC"						+ CRLF
	cQrySE1 += "	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"		+ CRLF
	cQrySE1 += "	AND	SF2.D_E_L_E_T_	<>	'*'"							+ CRLF

	cQrySE1 += " INNER JOIN " + retSQLName("SC5") + " SC5"						+ CRLF
	cQrySE1 += " ON"															+ CRLF
	cQrySE1 += "		SC5.C5_ZIDECOM	<>	' '"								+ CRLF
	cQrySE1 += "	AND	SC5.C5_ZNSU		<>	' '"								+ CRLF
	cQrySE1 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"							+ CRLF
	cQrySE1 += "	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"			+ CRLF
	cQrySE1 += "	AND	SC5.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySE1 += " INNER JOIN " + retSQLName("XC5") + " XC5"						+ CRLF
	cQrySE1 += " ON"															+ CRLF
	cQrySE1 += "		SC5.C5_ZIDECOM	=	XC5.XC5_IDECOM"						+ CRLF
	cQrySE1 += "	AND	XC5.XC5_NSU		<>	' '"								+ CRLF
	cQrySE1 += "	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5") + "'"			+ CRLF
	cQrySE1 += "	AND	XC5.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySE1 += " WHERE"															+ CRLF
	cQrySE1 += "		SE1.E1_ZSTEC	=	'0'"								+ CRLF
	cQrySE1 += " 	AND	SE1.E1_BAIXA	=	' '"								+ CRLF
	cQrySE1 += " 	AND	SE1.E1_SALDO	>	0"									+ CRLF
	cQrySE1 += " 	AND	SE1.E1_TIPO		=	'NCC'"								+ CRLF
	cQrySE1 += " 	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"			+ CRLF
	cQrySE1 += " 	AND	SE1.D_E_L_E_T_	<>	'*'"								+ CRLF

	conout( " [MGFFATAR] [getSE1Baix] " + cQrySE1 )

	tcQuery cQrySE1 New Alias "QRYSE1"
return