#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
	Cancelamento de Pedidos
*/

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MNUFATA0()

	runFATA0()

return 

//-------------------------------------------------------------------
//-------------------------------------------------------------------
user function MGFFATA0( cFilJob )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA left( cFilJob, 2 ) FILIAL cFilJob

		conout('[MGFFATA0] Iniciada Threads para a empresa' + allTrim( cFilJob ) + ' - ' + dToC(dDataBase) + " - " + time())

		runFATA0()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
static function runFATA0()
	local bError		:= ErrorBlock( { |oError| errorFATA0( oError ) } )
	local aErro			:= {}
	local cErro			:= ""
	local cAccessTok	:= ""
	local aCancel		:= {}

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	XC5ToDel()

	while ( QRYXC5->( !EOF() ) )
		aErro		:= {}
		cErro		:= ""
		lMsErroAuto := .F.

		MSExecAuto({|x,y,z| Mata410(x,y,z)},{{"C5_NUM", QRYXC5->XC5_PVPROT, NIL}}, {}, 5)

		if lMsErroAuto
			updXC5( QRYXC5->XC5RECNO, "2" )

			aErro := getAutoGRLog() // Retorna erro em array
			cErro := ""
	
			for nI := 1 to len(aErro)
				cErro += aErro[nI] + CRLF
			next nI

			conout( " [E-COM] [MGFFATA0] Erro no cancelmento: " + cErro )

			//cNameLog := funName() + dToS(dDataBase) + strTran(time(),":")
	
			//memoWrite("\" + cNameLog , cErro)
		else
			updXC5( QRYXC5->XC5RECNO, "1" )

			conout( " [E-COM] [MGFFATA0] Cancelamento ok - Pedido " + QRYXC5->XC5_PVPROT )

			if !empty( QRYXC5->XC5_NSU )

				getSF2Ecom( allTrim( QRYXC5->XC5_NSU ) )

				if QRYSF2->(EOF()) // Somente cancela caso nao tenha sido gerado Nota Fiscal
					cAccessTok := ""
					cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet

					if !empty( cAccessTok )

						aCancel := {}

						if sToD( QRYSF2->XC5_DTRECE ) == dDataBase
							// Mesmo dia - Cancelamento D + 0
							aCancel := u_canGtnt2( cAccessTok, allTrim( QRYSF2->XC5_PAYMID ), int( ( QRYSF2->E1_SALDO * 100 ) ), QRYSF2->XC5_FILIAL + QRYSF2->XC5_PVPROT )
						else
							// Cancelamento D + N
							aCancel := u_canGtnt1( cAccessTok, allTrim( QRYSF2->XC5_PAYMID ), int( ( QRYSF2->E1_SALDO * 100 ) ), QRYSF2->XC5_FILIAL + QRYSF2->XC5_PVPROT )
						endif

						if aPayment[1]
							// cancelado
						else
							// nao cancelado
						endif
					endif
				endif

				QRYSF2->(DBCloseArea())

			endif
		endif
		QRYXC5->(dbSkip())
	enddo

	QRYXC5->(DBCloseArea())

	delClassINTF()
return

static function getSF2Ecom( cXC5NSU )
	local cQrySF2	:= ""

	cQrySF2 := "SELECT DISTINCT XC5_FILIAL, XC5_PVPROT, XC5_NSU, XC5_IDECOM, XC5_IDPROF, XC5_PAYMID, XC5_SOLCAN,"	+ CRLF
	cQrySF2 += " E1_SALDO"																							+ CRLF
	cQrySF2 += " FROM "			+ retSQLName("SF2") + " SF2"							+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SD2") + " SD2"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SD2.D2_SERIE	=	SF2.F2_SERIE"								+ CRLF
	cQrySF2 += "	AND	SD2.D2_DOC		=	SF2.F2_DOC"									+ CRLF
	cQrySF2 += "	AND	SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'"					+ CRLF
	cQrySF2 += "	AND	SD2.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SC5") + " SC5"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	<>	' '"										+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"									+ CRLF
	cQrySF2 += "	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"					+ CRLF
	cQrySF2 += "	AND	SC5.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("XC5") + " XC5"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	=	XC5.XC5_IDECOM"								+ CRLF
	cQrySF2 += "	AND	XC5.XC5_NSU		=	'" + cXC5NSU + "'"							+ CRLF
	cQrySF2 += "	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5") + "'"					+ CRLF
	cQrySF2 += "	AND	XC5.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SE1") + " SE1"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SE1.E1_ZNSU		=	SC5.C5_ZNSU"								+ CRLF
	cQrySF2 += "	AND	SE1.E1_ZPEDIDO	=	SC5.C5_NUM"									+ CRLF
	cQrySF2 += "	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"					+ CRLF
	cQrySF2 += "	AND	SE1.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " WHERE"																	+ CRLF
	cQrySF2 += " 		SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"					+ CRLF
	cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"										+ CRLF

	conout(" [MGFFATA0] [getSF2Ecom] " + cQrySF2)

	tcQuery cQrySF2 New Alias "QRYSF2"
return

//-------------------------------------------------------
//-------------------------------------------------------
static function updXC5( nXC5Recno, cCancelado )
	local cUpdXC5	:= ""

	cUpdXC5 := "UPDATE " + retSQLName("XC5")								+ CRLF
	cUpdXC5 += "	SET"													+ CRLF
	cUpdXC5 += " 		XC5_CANCOK	=	'" + cCancelado + "',"				+ CRLF
	cUpdXC5 += " 		XC5_INTEGR	=	'P'"								+ CRLF
	cUpdXC5 += " WHERE"														+ CRLF
	cUpdXC5 += " 		R_E_C_N_O_ = " + str( nXC5Recno )					+ CRLF

	if tcSQLExec( cUpdXC5 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif
return

//-------------------------------------------------------
//-------------------------------------------------------
static function XC5ToDel()
	local cQryXC5	:= ""

	cQryXC5 := "SELECT XC5_FILIAL, XC5_PVPROT, R_E_C_N_O_ XC5RECNO, XC5_NSU, XC5_SOLCAN"	+ CRLF
	cQryXC5 += " FROM " + retSQLName("XC5") + " XC5"										+ CRLF	
	cQryXC5 += " WHERE"																		+ CRLF
	cQryXC5 += " 		XC5.XC5_CANCEL	=	'1'"											+ CRLF // Solicitacao de Cancelamento	-> N=Nao;1=Sim
	cQryXC5 += " 	AND	XC5.XC5_CANCOK	=	'0'"											+ CRLF // Processamento de Cancelamento	-> 0=Nao;1=Sim;2=Nao permitido
	cQryXC5 += " 	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5")	+ "'"						+ CRLF
	cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	conout( " [E-COM] [MGFFATA0] " + cQryXC5 )

	TcQuery cQryXC5 New Alias "QRYXC5"
return

//-------------------------------------------------------
//-------------------------------------------------------
static function errorFATA0(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	// fwTimeStamp(1) -> aaaammddhhmmss

	//memoWrite("\ECOM_MGFWSC27_" + fwTimeStamp(1) + ".log", cEr)
	conout( cEr )

	_aErr := { '0', cEr }
return .T.
