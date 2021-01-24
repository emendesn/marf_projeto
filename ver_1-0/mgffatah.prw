#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
===========================================================================================================================
{Protheus.doc} MGFFATAH
INTEGRACAO E-COMMERCE - EFETIVACAO DE PAGAMENTO NA GETNET

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
User function MGFFATAH( )

	U_MFCONOUT('Iniciando ambiente para efetivação de pagamento da GetNet para E-Commerce...')


	RPCSetType( 3 )


	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'


	MGFFATHE()

	U_MFCONOUT('Completou exportação de faturamento para o E-Commerce...')

	RESET ENVIRONMENT

	RPCSetType(3)

return

/*/
===========================================================================================================================
{Protheus.doc} MGFFATHE
Execução de efetivação de pagamento na GetNet

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFFATHE()
	local cAccessTok	:= ""
	local cCard			:= ""
	local oCard			:= nil
	local oPayment		:= nil
	local aPayment		:= {}
	local cUpdXC5		:= ""
	local cUpdSF2		:= ""
	local aSE1			:= {}
	local aSE1Baixa		:= {}
	local cUpdSC5		:= ""
	local _ntot         := 0
	local _nni          := 0
	local aArea			:= getArea()
	local aAreaSZV		:= SZV->( getArea() )
	local aAreaSC5		:= SC5->( getArea() )
	local aAreaSE1		:= SE1->( getArea() )

	U_MFCONOUT("Carregando pedidos pendentes de envio de confirmação de pagamento...")
	MGFFATHQ() //Query para buscar notas pendentes de confirmação

	If QRYSF2->(EOF())

		U_MFCONOUT("Não foram localizados faturamentos pendentes de confirmação de pagamento!")
		Return

	Endif

	while !QRYSF2->(EOF())
		_ntot++
		QRYSF2->(Dbskip())
	Enddo
	
	QRYSF2->(Dbgotop())

	while !QRYSF2->(EOF())

		_nni++
		U_MFCONOUT("Confirmando pagamento " + allTrim( QRYSF2->F2_FILIAL + '/' + QRYSF2->C5_NUM) + " - " + strzero(_nni,6) + " de " + strzero(_nTot,6) + "...")

		_cfilori := cfilant
		cfilant := alltrim(QRYSF2->F2_FILIAL)
		cAccessTok := ""
		cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet

		if !empty( cAccessTok )

				aPayment := {}
				aPayment := u_paymGtnt( cAccessTok, allTrim( QRYSF2->XC5_PAYMID ), int( ( QRYSF2->E1_SALDO * 100 ) ) ) // Efetua o Pagamento - Valor da Compra deve ser enviado em Centavos

				if aPayment[1]
						oPayment := nil
						if fwJsonDeserialize( aPayment[2], @oPayment )
							if oPayment:status == "CONFIRMED"
	
								cUpdXC5	:= ""
								_lerro := .F.

								cUpdXC5 := "UPDATE " + retSQLName("XC5")											+ CRLF
								cUpdXC5 += "	SET"																+ CRLF
								cUpdXC5 += " 		XC5_DTPAYM = '" + oPayment:credit_confirm:confirm_date	+ "',"	+ CRLF
								cUpdXC5 += " 		XC5_PAYMEN = '" + oPayment:credit_confirm:message		+ "',"	+ CRLF
								cUpdXC5 += " 		XC5_INTEGR = 'P'"												+ CRLF
								cUpdXC5 += " WHERE"																	+ CRLF
								cUpdXC5 += " 		R_E_C_N_O_	=	" + allTrim( str( QRYSF2->XC5RECNO ) )	+ ""	+ CRLF

								if tcSQLExec( cUpdXC5 ) < 0
									U_MFCONOUT("Falha na gravação de confirmação de pagamento, será enviada novamente!")
									_lerro := .T.
								endif

								cUpdSF2	:= ""

								cUpdSF2 := "UPDATE " + retSQLName("SF2")											+ CRLF
								cUpdSF2 += "	SET"																+ CRLF
								cUpdSF2 += " 		F2_XINTECO = '1'"												+ CRLF
								cUpdSF2 += " WHERE"																	+ CRLF
								cUpdSF2 += " 		R_E_C_N_O_	=	" + allTrim( str( QRYSF2->F2RECNO ) )	+ ""	+ CRLF

								if !_lerro .and. tcSQLExec( cUpdSF2 ) < 0
									U_MFCONOUT("Falha na gravação de confirmação de pagamento, será enviada novamente!")
									_lerro := .T.
								endif


								cUpdZE6	:= ""

								cUpdZE6 := "UPDATE " + retSQLName("ZE6")								+ CRLF
								cUpdZE6 += "	SET"													+ CRLF
								cUpdZE6 += " 		ZE6_STATUS = '4',"									+ CRLF
								cUpdZE6 += " 		ZE6_OBS = '" + ALLTRIM(oPayment:credit_confirm:confirm_date) + " - " + ALLTRIM(oPayment:credit_confirm:message) + "'"			+ CRLF
								cUpdZE6 += " WHERE"														+ CRLF
								cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( QRYSF2->XC5_NSU )	+ "'"	+ CRLF

								if !_lerro .and. tcSQLExec( cUpdZE6 ) < 0
									U_MFCONOUT("Falha na gravação de confirmação de pagamento, será enviada novamente!")
									_lerro := .T.
								endif

								If !_lerro
									U_MFCONOUT("Pagamento confirmado na GetNet!")
								Endif

							else

								MGFFATAHB() //Bloqueia pedido por pagamento não autorizado
							
							endif
						else

							MGFFATAHB() //Bloqueia pedido por pagamento não autorizado
						
						endif
	
				else

					MGFFATAHB() //Bloqueia pedido por pagamento não autorizado	

				endif
		endif

		QRYSF2->(DBSkip())

		cfilant := _cfilori

	enddo

	restArea( aArea )
	restArea( aAreaSZV )
	restArea( aAreaSC5 )
	restArea( aAreaSE1 )

	QRYSF2->(DBCloseArea())
return

/*/
===========================================================================================================================
{Protheus.doc} MGFFATHQ
Busca de notas pendentes de confirmar pagamento na GetNet

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFFATHQ()

	local cQrySF2	:= ""

	cQrySF2 := "SELECT DISTINCT"														+ CRLF

	cQrySF2 += " XC5_IDPROF	,"															+ CRLF
	cQrySF2 += " XC5_PAYMID	,"															+ CRLF
	cQrySF2 += " E1_SALDO	,"															+ CRLF
	cQrySF2 += " XC5.R_E_C_N_O_ XC5RECNO	,"											+ CRLF
	cQrySF2 += " SF2.R_E_C_N_O_ F2RECNO		,"											+ CRLF
	cQrySF2 += " XC5_NSU	,"															+ CRLF
	cQrySF2 += " F2_FILIAL	,"															+ CRLF
	cQrySF2 += " C5_NUM	,"																+ CRLF
	cQrySF2 += " XC5_PVPROT	,"															+ CRLF
	cQrySF2 += " XC5_FILIAL	,"															+ CRLF
	cQrySF2 += " XC5_PVPROT"															+ CRLF

	cQrySF2 += " FROM "			+ retSQLName("SF2") + " SF2"							+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SD2") + " SD2"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SD2.D2_SERIE	=	SF2.F2_SERIE"								+ CRLF
	cQrySF2 += "	AND	SD2.D2_DOC		=	SF2.F2_DOC"									+ CRLF
	cQrySF2 += "	AND	SD2.D2_FILIAL	=	SF2.F2_FILIAL"								+ CRLF
	cQrySF2 += "	AND	SD2.D2_CLIENTE	=	SF2.F2_CLIENTE"								+ CRLF
	cQrySF2 += "	AND SD2.D2_LOJA     =   SF2.F2_LOJA"								+ CRLF
	cQrySF2 += "	AND SD2.D2_ITEM     =   '01'"										+ CRLF
	cQrySF2 += "	AND	SD2.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SC5") + " SC5"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	<>	' '"										+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"									+ CRLF
	cQrySF2 += "	AND	SC5.C5_FILIAL	=	SF2.F2_FILIAL"								+ CRLF
	cQrySF2 += "	AND	SC5.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN ZE6010 ZE6 "												+ CRLF
 	cQrySF2 += " ON "																	+ CRLF
 	cQrySF2 += " ZE6.ZE6_FILIAL = SC5.C5_FILIAL "										+ CRLF
 	cQrySF2 += " AND ZE6.ZE6_PEDIDO = SC5.C5_NUM "										+ CRLF
 	cQrySF2 += " AND	ZE6.D_E_L_E_T_	<>	'*' "										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("XC5") + " XC5"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	=	XC5.XC5_IDECOM"								+ CRLF
	cQrySF2 += "	AND	XC5.XC5_NSU		<>	' '"										+ CRLF
	cQrySF2 += "	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"								+ CRLF
	cQrySF2 += "	AND	XC5.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SE1") + " SE1"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SE1.E1_ZNSU		=	SC5.C5_ZNSU"								+ CRLF
	cQrySF2 += "	AND	SE1.E1_NUM		=	SF2.F2_DOC"									+ CRLF
	cQrySF2 += "	AND	SE1.E1_FILIAL	=	SC5.C5_FILIAL"								+ CRLF
	cQrySF2 += "	AND SE1.E1_PREFIXO  =   SF2.F2_SERIE
	cQrySF2 += "	AND	SE1.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " WHERE"																	+ CRLF
	cQrySF2 += " 	SF2.F2_CHVNFE	<>	' '"										+ CRLF
	cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQrySF2 += " 	AND	SF2.F2_EMISSAO 	> '" + DTOS(DATE()-GETMV("MGFFATAHP",,30)) + "'"	+ CRLF
	cQrySF2 += "    AND   ( ZE6.ZE6_STATUS = '3' OR ZE6.ZE6_STATUS = '0' OR ZE6.ZE6_STATUS = '1' )" 										+ CRLF

	tcQuery cQrySF2 New Alias "QRYSF2"

return

/*/
===========================================================================================================================
{Protheus.doc} MGFFATAHB
Bloqueia pedido por falta de autorização de pagamento

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
Static Function MGFFATAHB()

Local 	_lerro := .F.
Local	cUpdSC5	:= ""

cUpdSC5 := "UPDATE " + retSQLName("SC5")							+ CRLF	
cUpdSC5 += "	SET"												+ CRLF
cUpdSC5 += " 		C5_ZBLQRGA = 'B'"								+ CRLF
cUpdSC5 += " WHERE"													+ CRLF
cUpdSC5 += " 		C5_NUM		=	'" + QRYSF2->XC5_PVPROT	+ "'"	+ CRLF
cUpdSC5 += " 	AND	C5_FILIAL	=	'" + QRYSF2->XC5_FILIAL	+ "'"	+ CRLF
cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

if tcSQLExec( cUpdSC5 ) < 0
	_lerro := .T.
	U_MFCONOUT("Não foi possível atualizar o pedido, autorização será reenviada!")
endif

DBSelectArea( 'SZV' )
SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
if !SZV->( DBSeek( xFilial('SZV') + QRYSF2->XC5_PVPROT + "01" + "999999" ) )
	recLock("SZV", .T.)
	SZV->ZV_FILIAL	:= xFilial("SZV")
	SZV->ZV_PEDIDO	:= QRYSF2->XC5_PVPROT
	SZV->ZV_ITEMPED	:= "01"
	SZV->ZV_CODRGA	:= "999999"
	SZV->ZV_CODRJC	:= "000000"
	SZV->ZV_DTRJC	:= dDataBase
	SZV->ZV_HRRJC	:= left( time() , 5 )
	SZV->(msUnlock())
endif

// ZE6_STATUS = '3' -> Erro
cUpdZE6	:= ""
cUpdZE6 := "UPDATE " + retSQLName("ZE6")											+ CRLF
cUpdZE6 += "	SET"																+ CRLF
cUpdZE6 += " 		ZE6_STATUS	=	'3',"											+ CRLF
cUpdZE6 += " 		ZE6_OBS		=	'Pagamento não autorizado. Pedido Bloqueado.'"	+ CRLF
cUpdZE6 += " WHERE"																	+ CRLF
cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( QRYSF2->XC5_NSU )	+ "'"				+ CRLF

if !_lerro .and. tcSQLExec( cUpdZE6 ) < 0
	_lerro := .T.
	U_MFCONOUT("Não foi possível atualizar o pedido, autorização será reenviada!")
endif

cUpdSF2 := "UPDATE " + retSQLName("SF2")											+ CRLF
cUpdSF2 += "	SET"																+ CRLF
cUpdSF2 += " 		F2_XINTECO = '1'"												+ CRLF
cUpdSF2 += " WHERE"																	+ CRLF
cUpdSF2 += " 		R_E_C_N_O_	=	" + allTrim( str( QRYSF2->F2RECNO ) )	+ ""	+ CRLF
		
if !_lerro .and. tcSQLExec( cUpdSF2 ) < 0
	U_MFCONOUT("Falha na gravação de confirmação de pagamento, será enviada novamente!")
	_lerro := .T.
endif

If !_lerro
	U_MFCONOUT("Pagamento não autorizado. Pedido Bloqueado!")
Endif

Return
