#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
//
//
//
/*/{Protheus.doc} eMGFWS15
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFWS15()

	runInteg15()

Return


User Function jMGFWC15(cFilJob)

	U_MGFWSC15({,"01",cFilJob})

Return

User Function MGFWSC15(aEmpX)
	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", aEmpX[2], aEmpX[3],,,,, { } ); Else; RpcSetEnv( aEmpX[2], aEmpX[3],,,,, { } ); endif

	conout("[MGFWSC15] Iniciada Threads para a empresa" + allTrim( aEmpX[3] ) + " - " + dToC(dDataBase) + " - " + time())

	runInteg15()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
return



static function runInteg15()

	local cURLPost		:= allTrim(getMv("MGF_SFA15"))
	local oWSSFA		:= nil

	oWSSFA := nil
	oWSSFA := MGFINT23():new(cURLPost, , , , , allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA15T")) )
	oWSSFA:lLogInCons	:= .T.
	oWSSFA:lUseJson		:= .F.
	oWSSFA:sendByHttpPost()

	delClassINTF()
return




static function getSE1()
	local cQrySE1 := ""

	cQrySE1 := "SELECT "																		+ chr(13) + chr(10)
	cQrySE1 += " SE1.R_E_C_N_O_ E1RECNO,"	+ chr(13) + chr(10)
	cQrySE1 += " E1_NUM,"				+ chr(13) + chr(10)
	cQrySE1 += " E1_VEND1,"				+ chr(13) + chr(10)
	cQrySE1 += " E1_FILIAL,"			+ chr(13) + chr(10)
	cQrySE1 += " E1_EMISSAO,"			+ chr(13) + chr(10)
	cQrySE1 += " E1_CLIENTE,"			+ chr(13) + chr(10)
	cQrySE1 += " E1_LOJA,"				+ chr(13) + chr(10)
	cQrySE1 += " E1_PEDIDO,"			+ chr(13) + chr(10)
	cQrySE1 += " E1_PARCELA,"			+ chr(13) + chr(10)
	cQrySE1 += " TRUNC(E1_VALOR, 2) E1_VALOR,"				+ chr(13) + chr(10)
	cQrySE1 += " E1_VENCREA,"			+ chr(13) + chr(10)
	cQrySE1 += " SE1.D_E_L_E_T_ SE1DEL,"			+ chr(13) + chr(10)
	cQrySE1 += " A1_CGC"			+ chr(13) + chr(10)
	cQrySE1 += " FROM "			+ retSQLName("SE1") + " SE1"							+ chr(13) + chr(10)

	cQrySE1 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"							+ chr(13) + chr(10)
	cQrySE1 += " ON"												+ chr(13) + chr(10)
	cQrySE1 += " 		SA1.A1_LOJA		=	SE1.E1_LOJA"							+ chr(13) + chr(10)
	cQrySE1 += " 	AND	SA1.A1_COD		=	SE1.E1_CLIENTE"							+ chr(13) + chr(10)
	cQrySE1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"							+ chr(13) + chr(10)

	cQrySE1 += " WHERE"							+ chr(13) + chr(10)





	cQrySE1 += " 		SE1.E1_SALDO	>	0"							+ chr(13) + chr(10)
	cQrySE1 += "	AND	SE1.E1_TIPO		IN	( 'NF', 'JR', 'DP' )" 				+ chr(13) + chr(10)
	cQrySE1 += " 	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"							+ chr(13) + chr(10)


	cQrySE1 += " AND (E1_CLIENTE, E1_LOJA)"
	cQrySE1 += " IN"
	cQrySE1 += " ("
	cQrySE1 += " SELECT DISTINCT A1_COD, A1_LOJA FROM V_CLIENTESGERAIS WHERE CENTRODISTRIBUICAO = '" + xFilial("SE1") + "'"
	cQrySE1 += " )"

	cQrySE1 += " ORDER BY SE1.R_E_C_N_O_" 										+ chr(13) + chr(10)

	conout( "[MGFWSC15] " + cQrySE1 )

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySE1), "QRYSE1" , .F. , .T. )
return




Class fatura
	Data applicationArea AS ApplicationArea
	Data ccentrodis AS string
	Data cdtemissao AS string
	Data cidcliente AS string
	Data cnrnotafis AS string
	Data cnrpedido AS string
	Data cparcela AS string
	Data cstatusdcn AS string
	Data cstatusfat AS string
	Data nvalor AS float
	Data cvenciment AS string
	Data cidfaturas AS string
	Data cidvendedo AS string
	Data isDelete AS string

	Method New()
	Method setFatura()
EndClass




Method new( ) Class fatura
	self:applicationArea	:= ApplicationArea():new()
return




Method setFatura( ) Class fatura


	self:cidfaturas		:= subStr( QRYSE1->E1_FILIAL, 2, 1 ) + right( QRYSE1->E1_FILIAL, 2 ) + alltrim( QRYSE1->E1_NUM ) + alltrim( QRYSE1->E1_PARCELA )

	self:cidvendedo		:= ALLTRIM(QRYSE1->E1_VEND1)
	self:ccentrodis		:= ALLTRIM(QRYSE1->E1_FILIAL)
	self:cdtemissao		:= substr(QRYSE1->E1_EMISSAO,1,4)+"-"+substr(QRYSE1->E1_EMISSAO,5,2)+"-"+substr(QRYSE1->E1_EMISSAO,7,2)

	self:cidcliente		:= QRYSE1->A1_CGC
	self:cnrnotafis		:= alltrim(str(val(QRYSE1->E1_NUM)))
	self:cnrpedido		:= IIF(!empty(QRYSE1->E1_PEDIDO),ALLTRIM(QRYSE1->E1_PEDIDO),"0")
	self:cparcela		:= QRYSE1->E1_PARCELA
	self:cstatusfat		:= ""
	self:nvalor			:= QRYSE1->E1_VALOR
	self:cvenciment		:= substr(QRYSE1->E1_VENCREA,1,4)+"-"+substr(QRYSE1->E1_VENCREA,5,2)+"-"+substr(QRYSE1->E1_VENCREA,7,2)

	if QRYSE1->SE1DEL == "*"
		self:isDelete := "S"
		self:cstatusdcn		:= "D"
	else
		self:isDelete := "N"
		self:cstatusdcn		:= "U"
	endif
return
