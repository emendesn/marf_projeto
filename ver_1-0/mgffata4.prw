#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

//------------------------------------------------------------------
// Para ser chamado em JOB
//------------------------------------------------------------------
user function JOBFATA4( cFilJob )

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL cFilJob

		conout('[MGFFATA4] Iniciada Threads para a empresa' + allTrim( cFilJob ) + ' - ' + dToC(dDataBase) + " - " + time())

		U_MGFFATA4()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
// Para execucao via Menu chamar direto MGFFATA4
//-------------------------------------------------------------------
user function MGFFATA4()
	local nI			:= 0
	local nLimXC5		:= superGetMv( "MGF_ECOCOU", , 5 )
	local cIdToProc		:= ""

	private aSalesOrde	:= {}
	private oSalesOrde	:= nil
	private oItem		:= nil

	private __nLimTr	:= superGetMv( "MGF_ECOTHR", , 15 )
	private cOnStart	:= "U_MGFFATA5"
	private cFilaJob	:= "MGFFATA4_EMP"+allTrim( cFilAnt )

	conout( '[MGFFATA4] [ECOM] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Inicio ' + time() )

	ManualJob(	cFilaJob											,;	// [01] Nome da Fila
				GetEnvServer()										,;	// [02] Environment
				"IPC"												,;	// [03] Tipo
				cOnStart											,;	// [04] OnStart - APENAS PREPARA O AMBIENTE
				"u_runFATA5"										,;	// [05] OnConnect - EXECUTA A FUNCIONALIDADE
				""													,;	// [06] OnExit
				" "													,;	// [07]
				60													,;	// [08]
				1													,;	// [09] Num Min Threads
				__nLimTr											,;	// [10] Num Max Threads
				1													,;	// [11] Num Min Threads Livres
				1													)	// [12] IPC

	// Recoloca na Fila - conforme parametrizado
	reQueue()

	getXC5()
	//QRYXC5->( DBGoTop() )
	if !QRYXC5->( EOF() )

		while !QRYXC5->( EOF() )
			nCountXC5	:= 0
			cIdToProc	:= fwTimeStamp(1) // aaaammddhhmmss
			while !QRYXC5->( EOF() ) .AND. nCountXC5 < nLimXC5
				nCountXC5++
				updToProce( cIdToProc )
				QRYXC5->( DBSkip() )
			enddo

			While !IPCGo(cFilaJob /*ID DA FILA*/, cIdToProc /*PARAM1*/, cFilAnt /*PARAM2*/)
				Sleep(1000)
			EndDo

			sleep(1000) // PARA GARANTIR QUE IRA MUDAR O SEGUNDO DA VARIAVEL cIdToProc NA PROXIMA EXECUCAO
		enddo
	endif

	QRYXC5->(DBCloseArea())

	conout( '[MGFFATA4] [ECOM] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Fim ' + time() )

	delClassINTF()
return

//-------------------------------------------------------------------
// Atualizado registro para 2 - Processando
//-------------------------------------------------------------------
static function updToProce( cIdToProc )
	local cUpdXC5 := ""

	cUpdXC5 := "UPDATE " + retSQLName("XC5")								+ CRLF
	cUpdXC5 += " SET XC5_STATUS = '2', XC5_IDPROC = '" + cIdToProc + "'"	+ CRLF
	cUpdXC5 += " WHERE XC5_IDECOM = '" + QRYXC5->XC5_IDECOM + "'"				+ CRLF

	tcSQLExec(cUpdXC5)
return

//-------------------------------------------------------------------
// Selecione pedidos a serem incluidos
//-------------------------------------------------------------------
static function getXC5()
	local cQryXC5	:= ""

	cQryXC5 += "SELECT XC5.R_E_C_N_O_ XC5RECNO, XC5_IDECOM"									+ CRLF
	cQryXC5 += " FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryXC5 += " WHERE"																		+ CRLF
	cQryXC5 += " 		XC5.XC5_STATUS	=	'1'"											+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
	cQryXC5 += " 	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5") + "'"						+ CRLF
	cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryXC5 += " ORDER BY XC5_IDECOM"														+ CRLF

	conout( '[MGFFATA4] [ECOM] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Query - Selecao para processamento: ' + cQryXC5 )

	tcQuery changeQuery(cQryXC5) new Alias "QRYXC5"
return

//-------------------------------------------------------------------
// Coloca novamente na fila pedidos com os minutos parametrizados
// que ainda nao foram processados
//-------------------------------------------------------------------
static function reQueue()
	local cUpdXC5		:= ""
	local cEcomRepos	:= allTrim( str( superGetMv( "MGF_ECOREP", , 60 ) ) )

	cUpdXC5 := "UPDATE " + retSQLName("XC5")																					+ CRLF
	cUpdXC5 += " SET XC5_STATUS = '1'"																							+ CRLF
	cUpdXC5 += " WHERE"																											+ CRLF
	cUpdXC5 += " 	XC5_IDECOM	IN"																								+ CRLF
	cUpdXC5 += " 	("																											+ CRLF
	cUpdXC5 += "		SELECT XC5.XC5_IDECOM"																					+ CRLF
	cUpdXC5 += "		FROM "		+ retSQLName("XC5") + " XC5"																+ CRLF
	cUpdXC5 += "		LEFT JOIN " + retSQLName("SC5") + " SC5"																+ CRLF
	cUpdXC5 += "		ON"																										+ CRLF
	cUpdXC5 += "				XC5.XC5_PVPROT	=	SC5.C5_NUM"																	+ CRLF
	cUpdXC5 += "			AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"													+ CRLF
	cUpdXC5 += "			AND	SC5.D_E_L_E_T_	<>	'*'"																		+ CRLF
	cUpdXC5 += "		WHERE"																									+ CRLF
	cUpdXC5 += " 			SC5.C5_NUM		IS NULL"																			+ CRLF
	cUpdXC5 += " 		AND	XC5.XC5_PVPROT	=		'      '"																	+ CRLF
	cUpdXC5 += "		AND XC5.XC5_STATUS	=		'2'"																		+ CRLF
	cUpdXC5 += " 		AND	XC5.D_E_L_E_T_	<>		'*'"																		+ CRLF
	cUpdXC5 += " 		AND	XC5.XC5_FILIAL	=		'" + xFilial("XC5") + "'"													+ CRLF
	cUpdXC5 += "		AND XC5.XC5_DTRECE	LIKE	'" + dToS( dDataBase ) + "%'"												+ CRLF
	cUpdXC5 += "		AND (sysdate - to_date(substr(XC5.XC5_IDECOM,1,8) || XC5.XC5_hrrece,'yyyymmddhh24:mi:ss')) * 24 * 60"	+ CRLF
	cUpdXC5 += "		>="																										+ CRLF
	cUpdXC5 += "		(SELECT X6_CONTEUD FROM SX6010 X6 WHERE X6_VAR = '" + cEcomRepos + "' AND X6.D_E_L_E_T_ <> '*')"		+ CRLF
	cUpdXC5 += "	)"																											+ CRLF

	if tcSQLExec(cUpdXC5) < 0
		conout("Update: " + cUpdXC5 + CRLF + " Erro: " + tcSqlError())
	endif
return