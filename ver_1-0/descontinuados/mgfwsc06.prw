#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC06
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Integracao de Pedidos com SFA
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function eMGFWS06()

StartJob( "U_MGFWSC06", GetEnvServer(), .T., {"01", "010001"} )

Return 
user function MGFWSC06(cEmpX, cFilX)

	PREPARE ENVIRONMENT EMPRESA cEmpX FILIAL cFilX
		runInteg06()
	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function runInteg06()
	local cURLPost		:= allTrim(getMv("MGF_SFA06"))
	local oWSSFA		:= nil
	private oSalesOrde	:= nil

	getSalesOr()

	while !QRYSC5->(EOF())
		oSalesOrde := nil
		oSalesOrde := salesOrder():new()

		oSalesOrde:setSalesOr()

		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oSalesOrde /*oObjToJson*/, QRYSC5->C5RECNO /*nKeyRecord*/, "SC5"/*cTblUpd*/, "C5_XINTEG"/*cFieldUpd*/, allTrim(getMv("MGF_SFACOD")) /*cCodint*/, allTrim(getMv("MGF_SFA06T")) /*cCodtpint*/)
		oWSSFA:sendByHttpPost()

		QRYSC5->(DBSkip())
	enddo

	QRYSC5->(DBCloseArea())
return

//-------------------------------------------------------------------
// Seleciona os pedidos para exportacao
//-------------------------------------------------------------------
static function getSalesOr()
	local cQrySC5 := ""

	cQrySC5 := "SELECT R_E_C_N_O_ C5RECNO,"																		+ CRLF
	cQrySC5 += " C5_FILIAL	, C5_EMISSAO	, C5_CLIENT	, C5_LOJACLI	, C5_VEND1,"	+ CRLF
	cQrySC5 += " C6_FILIAL	, C6_NUM		, C6_PRCVEN	, C6_QTDVEN	,"				+ CRLF
	cQrySC5 += " B1_UM		, A1_END		, A1_CEP		, A1_ESTADO	, A1_MUN"		+ CRLF
	cQrySC5 += " D_E_L_E_T_ SC5DEL"		+ CRLF
	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"							+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SC6") + " SC6"							+ CRLF
	cQrySC5 += " ON"																			+ CRLF
	cQrySC5 += " 		SC5.C5_NUM			=	SC6.C6_NUM"									+ CRLF
	cQrySC5 += " 	AND	SC5.C5_FILIAL		=	SC6.C6_FILIAL"								+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SB1") + " SB1"							+ CRLF
	cQrySC5 += " ON"																			+ CRLF
	cQrySC5 += " 		SC6.C6_PRODUTO	=	SB1.B1_COD"									+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"							+ CRLF
	cQrySC5 += " ON"																			+ CRLF
	cQrySC5 += " 		SC5.C5_CLIENTE	=	SA1.A1_COD"									+ CRLF
	cQrySC5 += " 	AND	SC5.C5_LOJACLI	=	SA1.A1_LOJA"									+ CRLF
	cQrySC5 += " WHERE"
	cQrySC5 += " 		SC5.C5_XINTEG		=	'P'"										+ CRLF
	cQrySC5 += " 	AND	SC5.C5_XSFA			=	'S'"										+ CRLF
	cQrySC5 += " 	AND	SC5.C5_FILIAL		=	'" + xFilial("SC5") + "'"					+ CRLF
	cQrySC5 += " 	AND	SC6.C6_FILIAL		=	'" + xFilial("SC6") + "'"					+ CRLF
	cQrySC5 += " 	AND	SB1.B1_FILIAL		=	'" + xFilial("SB1") + "'"					+ CRLF
	cQrySC5 += " 	AND	SA1.A1_FILIAL		=	'" + xFilial("SA1") + "'"					+ CRLF
//	cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF
//	cQrySC5 += " 	AND	SC6.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQrySC5 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQrySC5 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"											+ CRLF

	TcQuery changeQuery(cQrySC5) New Alias "QRYSC5"
return

/*
	Classe de Sales Order
*/
class salesOrder
	data applicationArea	as ApplicationArea
	data idpedidoli	as string
	data idproduto	as string
	data dtpedido		as string
	data nrpedido		as string
	data centrodist	as string
	data ordemcompr	as string
	data valornorma	as string
	data statuspedi	as string
	data statusfatu	as string
	data dtentrega	as string
	data mensagembl	as string
	data qtditem		as int
	data unidade		as string
	data valorcontr	as float
	data descmanual	as string
	data tipopedido	as string
	data entregaend	as string
	data entregacep	as string
	data entregaest	as string
	data entregacid	as string
	data entregasta	as string
	data qtdpeca		as int
	data idclientes	as string
	data idvendedor	as string
	data bloqueio		as string
	data idnovosped	as string
	data isDelete	as string

	method New()
	method setSalesOr()
return

/*
	Construtor
*/
method new() class salesOrder
	self:applicationArea	:= ApplicationArea():new()
return

/*
	Carrega o objeto
*/
method setSalesOr() Class salesOrder

// VERIFICAR ATRIBUTOS

/*
IDPEDIDOLISTA
IDPRODUTO
DTPEDIDO
NRPEDIDO
CENTRODISTRIBUICAO
ORDEMCOMPRA
VALORNORMAL
STATUSPEDIDO
STATUSFATURAMENTO
DTENTREGA
MENSAGEMBLOQUEIO
QTDITEM
UNIDADE
VALORCONTRATO
DESCONTOMANUAL
TIPOPEDIDO
ENTREGAEND
ENTREGACEP
ENTREGAESTADO
ENTREGACIDADE
ENTREGASTATUS
QTDPECA
IDCLIENTESGERAIS
IDVENDEDOR
BLOQUEIO
IDNOVOSPEDIDOS
*/

	self:ccentrodistribuicao
	self:cdtemissao
	self:cidclientesgerais
	self:nnrnotafiscal
	self:nnrpedido
	self:cparcela
	self:cstatusdcn
	self:cstatusfaturamento
	self:nvalor
	self:cvencimento
	self:cidfaturaslistagem
	self:cidvendedor
return
