#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC11
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Integracao de Marca com SFA
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/


user function jMGFWC11(cFilJob)

	U_MGFWSC11({,"01",cFilJob})

Return 

user function eMGFWS11()

	runInteg11()

Return

user function MGFWSC11( aEmpX )
	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

		conout('[MGFWSC11] Iniciada Threads para a empresa' + allTrim( aEmpX[3] ) + ' - ' + dToC(dDataBase) + " - " + time())

		runInteg11()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function runInteg11()
	local cURLPost		:= allTrim(getMv("MGF_SFA11"))
	local oWSSFA		:= nil
	private oBrand		:= nil

	getBrand()

	while !QRYZZU->(EOF())
		oBrand := nil
		oBrand := brand():new()

		oBrand:setBrand()
		oWSSFA := nil
		oWSSFA := MGFINT23():new(cURLPost, oBrand /*oObjToJson*/, QRYZZU->ZZUREC /*nKeyRecord*/, "ZZU" /*cTblUpd*/, "ZZU_XINTEG"/*cFieldUpd*/, allTrim(getMv("MGF_SFACOD")) /*cCodint*/, allTrim(getMv("MGF_SFA08T")) /*cCodtpint*/)
		oWSSFA:lLogInCons := .T. //Se informado .T. exibe mensagens de log de integraÁ„o no console quando executado o mÈtodo sendByHttpPost. N„o obrigatÛrio. DEFAULT .F.
		oWSSFA:sendByHttpPost()

		// Grava json
		memoWrite("C:\TEMP\MARCA.JSON", oWSSFA:cJson)

		QRYZZU->(DBSkip())
	enddo

	QRYZZU->(DBCloseArea())
return

//-------------------------------------------------------------------
// Seleciona os produtos para exporta√ß√£o
//-------------------------------------------------------------------
static function getBrand()
	local cQRYZZU := ""

	cQRYZZU := "SELECT ZZU.*, ZZU.D_E_L_E_T_ ZZUDEL, ZZU.R_E_C_N_O_ ZZUREC "												+ CRLF
	cQRYZZU += " FROM "			+ retSQLName("ZZU") + " ZZU" + CRLF
	cQRYZZU += " WHERE" + CRLF
	cQRYZZU += " 		ZZU.ZZU_XINTEG	=	'P'"
	cQRYZZU += " 	AND	ZZU.ZZU_XSFA	=	'S'"
	cQRYZZU += " 	AND	ZZU.ZZU_FILIAL	=	'" + xFilial("ZZU") + "'" + CRLF
	//cQRYZZU += " 	AND	ZZU.D_E_L_E_T_	<>	'*'" + CRLF
	cQRYZZU += " ORDER BY ZZU.R_E_C_N_O_" 										+ CRLF

	conout( cQRYZZU )

	TcQuery changeQuery(cQRYZZU) New Alias "QRYZZU"
return

/*
	Classe de Produto
*/
class brand
	data applicationArea	as ApplicationArea
	data idEstrutur	as string
	data nome		as string
	data statusDCN	as string
	data isDelete		as string // S ou N

	method New()
	method setBrand()
//return
EndClass

/*
	Construtor
*/
method new() class brand
	self:applicationArea	:= ApplicationArea():new()
return

/*
	Carrega o objeto
*/
Method setBrand() Class brand
	self:idEstrutur := QRYZZU->ZZU_CODIGO
	//self:idEstrutur := QRYZZU->ZZUREC
	self:nome		:= QRYZZU->ZZU_DESCRI

	if QRYZZU->ZZUDEL == "*"
		self:isDelete := "S"
		self:statusdcn					:= "D"//
	else
		self:isDelete := "N"
		self:statusdcn					:= "U"//
	endif
return
