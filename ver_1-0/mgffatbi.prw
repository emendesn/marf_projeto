#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

user function MGFFATBI( cCentroDis , cB1Cod , dDataMin , dDataMax , lRefreshX , nC6QtdVen , nC6XUltQtd )
	local aAreaX		:= getArea()
	local cQryZF6		:= ""
	local nLimiteCon	:= superGetMv( "MGFFATBI" , , 3600 )
	local cPictQtd14	:= pesqPict('SB8', 'B8_SALDO',   14)

	default nC6QtdVen	:= 0
	default nC6XUltQtd	:= 0

	aSaldo := { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 }

	cQryZF6 := "SELECT"																			+ CRLF
	cQryZF6 += " AVG( COALESCE( ZF6_PMEDIO , 0 ) ) PMEDIOCAIX,"									+ CRLF
	cQryZF6 += " SUM( COALESCE( ZF6_ESTOQU , 0 ) ) ESTOQUE"										+ CRLF
	cQryZF6 += " FROM " + retSQLName( "ZF6" ) + " ZF6"											+ CRLF
	cQryZF6 += " WHERE"																			+ CRLF
	cQryZF6 += " 		ZF6.ZF6_PRODUT	=	'" + cB1Cod		+ "'"								+ CRLF
	cQryZF6 += " 	AND ZF6.ZF6_FILIAL	=	'" + cCentroDis + "'"								+ CRLF
	cQryZF6 += "	AND	ZF6.ZF6_DTRECE	=	'" + dtos( date() ) + "'"							+ CRLF
	cQryZF6 += "	AND ZF6.ZF6_SECMID	>=	'" + allTrim( str( seconds() - nLimiteCon ) ) + "'"	+ CRLF // LOTE ENVIADO NOS ULTIMOS 60 MIN
	cQryZF6 += " 	AND	ZF6.D_E_L_E_T_	<>	'*'"												+ CRLF
	cQryZF6 += "	AND ZF6_SEQUEN ="															+ CRLF // SOMENTE CONSIDERA O ULTIMO SEQUENCIAL - POIS VAI RECEBER VARIOS LOTES IGUAIS EM 60 MIN
	cQryZF6 += "	("																			+ CRLF
	cQryZF6 += "		SELECT MAX( ZF6_SEQUEN )"												+ CRLF
	cQryZF6 += "		FROM " + retSQLName( "ZF6" ) + " SUBZF6"								+ CRLF
	cQryZF6 += "		WHERE"																	+ CRLF
	cQryZF6 += "			SUBZF6.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryZF6 += "	)"																			+ CRLF

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQryZF6  += " AND ZF6.ZF6_DTVALI BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
	endif

	tcQuery cQryZF6 new alias "QRYZF6"

	if QRYZF6->ESTOQUE > 0
		aSaldo[1] := QRYZF6->ESTOQUE
		aSaldo[2] := 0
		aSaldo[3] := 0
		aSaldo[4] := QRYZF6->ESTOQUE
		aSaldo[5] := QRYZF6->ESTOQUE / QRYZF6->PMEDIOCAIX
		aSaldo[6] := 0
		aSaldo[7] := QRYZF6->PMEDIOCAIX
		aSaldo[8] := 0

		// SE C6_XULTQTD MAIOR QUE ZERO			->	PEDIDO JA INTEGRADO NO TAURA
		// SE C6_QTDVEN MAIOR QUE C6_XULTQTD	->	RECOMPOE SALDO DISPONIVEL
		if nC6XUltQtd > 0 .and. nC6QtdVen > nC6XUltQtd
			aSaldo[4] := nC6XUltQtd + aSaldo[4] - nC6QtdVen
		endif
	else
		aSaldo[1] := -1
		aSaldo[2] := -1
		aSaldo[3] := -1
		aSaldo[4] := -1
		aSaldo[5] := -1
		aSaldo[6] := -1
		aSaldo[7] := -1
		aSaldo[8] := -1
	endif

	// SE CONSULTA EM TELA - CONVERTE STRING FORMATADA
	if isInCallStack("U_MGFFAT13")
		aSaldo[1]  := transform( aSaldo[1] , cPictQtd14 ) // Estoque
		aSaldo[2]  := transform( aSaldo[2] , cPictQtd14 ) // Pedido de Venda
		aSaldo[3]  := transform( aSaldo[3] , cPictQtd14 ) // P.V. Bloqueado
		aSaldo[4]  := transform( aSaldo[4] , cPictQtd14 ) // Saldo - PVs
		aSaldo[5]  := transform( aSaldo[5] , cPictQtd14 ) // Caixas
		aSaldo[6]  := transform( aSaldo[6] , cPictQtd14 ) // Itens p/ caixa
		aSaldo[7]  := transform( aSaldo[7] , cPictQtd14 ) // Peso Médio
		aSaldo[8]  := transform( aSaldo[8] , cPictQtd14 ) // Peças
	endif

	QRYZF6->( DBCloseArea() )

	restArea( aAreaX )
return aSaldo