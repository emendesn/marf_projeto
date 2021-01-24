#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC07
Autor....:              Gustavo Ananias Afonso
Data.....:              27/09/2016
Descricao / Objetivo:   Integracao de Clientes Entrega com SFA
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFWSC07(  )
	//	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001'

	runInteg07()

	RESET ENVIRONMENT
return
user function eMGFWS07(cCodCli, cCodLj)

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001'

	runInteg07(cCodCli, cCodLj)

Return 

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function runInteg07(cCodCli, cCodLj)
	local cURLPost		:= Alltrim(GetMV('MGF_TAU01C',.F.,""))       
	local oWSSFA		:= nil
	private oAddress	:= nil

	default cCodCli		:= ""
	default cCodLj		:= ""

	conout( '[MGFWSC07] [SFA] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Inicio ' + time() )

	getAddress(cCodCli, cCodLj)

	while !QRYSZ9->(EOF())
		oAddress := nil
		oAddress := AddressDeliverySFA():new()

		oAddress:setAddress()
		oWSSFA := nil
		oWSSFA := MGFINT53():new(cURLPost, oAddress ,0 , "", "",allTrim(getMv("MGF_MONI01")) /*cCodint*/, allTrim(getMv("MGF_MONT11")),QRYSZ9->A1_COD+QRYSZ9->A1_LOJA+QRYSZ9->Z9_ZIDEND,.F.,.F.,.T.,.T.,.F.,.F.,.T.)
		oWSSFA:lLogInCons := .T. //Se informado .T. exibe mensagens de log de integraÁ„o no console quando executado o mÈtodo sendByHttpPost. N„o obrigatÛrio. DEFAULT .F.
		oWSSFA:sendByHttpPost()

		//MemoWrite("c:\temp\"+FunName()+"_Result_"+StrTran(Time(),":","")+".txt",oWSSFA:CDETAILINT)
		//MemoWrite("c:\temp\"+FunName()+"_json_"+StrTran(Time(),":","")+".txt",oWSSFA:CJSON)

		If oWSSFA:lOk
			cQuery := " Update "+RetSqlName("SZ9")
			cQuery += " Set Z9_XINTEGR = 'I'"
			cQuery += " Where R_E_C_N_O_  = '"+Alltrim(STR(QRYSZ9->Z9RECNO))+"'"
			IF (TcSQLExec(cQuery) < 0)
				conout( TcSQLError())
			EndIF
		EndIF
		QRYSZ9->(DBSkip())
	enddo

	QRYSZ9->(DBCloseArea())

	conout( '[MGFWSC07] [SFA] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Inicio ' + time() )

return

//-------------------------------------------------------------------
// Seleciona os clientes para exporta√ß√£o
//-------------------------------------------------------------------
static function getAddress(cCodCli, cCodLj)
	local cQrySZ9 := ""

	// UNION ALL realizado para levar o endereco zero (cadastro SA1)
	// Retirado isto , Carneiro 2018
	/*
	cQrySZ9 := " SELECT 0 AS Z9RECNO, YA_DESCR, YA_ZSIGLA, GU7_NRCID,"			+ CRLF
	cQrySZ9 += "  A1_END AS Z9_ZENDER, A1_BAIRRO AS Z9_ZBAIRRO, A1_CEP AS Z9_ZCEP, A1_EST AS Z9_ZEST, A1_COD_MUN AS Z9_ZCODMUN, A1_MUN AS Z9_ZMUNIC, '000000000' AS Z9_ZIDEND, '' AS Z9_ALROAD, '' AS Z9_ZCROAD,"			+ CRLF
	cQrySZ9 += "  A1_NREDUZ, A1_NOME, A1_CGC, A1_COD, A1_LOJA, A1_VEND, '' AS A1_ZCROAD, A1_NOME AS Z9_ZRAZEND, A1_CGC AS Z9_ZCGC, A1_XSFA AS Z9_XSFA,"			+ CRLF 
	cQrySZ9 += "  SA1.D_E_L_E_T_ SZ9DEL"			+ CRLF
	cQrySZ9 += " FROM "	+ retSQLName("SA1") + " SA1"			+ CRLF
	cQrySZ9 += "  LEFT JOIN "	+ retSQLName("SYA") + " SYA"			+ CRLF
	cQrySZ9 += "  ON		SYA.YA_CODGI	=	SA1.A1_PAIS"			+ CRLF
	cQrySZ9 += "  	AND SYA.YA_FILIAL	=	'" + xFilial("SYA") + "'"			+ CRLF
	cQrySZ9 += "  	AND SYA.D_E_L_E_T_	<>	'*'"			+ CRLF
	cQrySZ9 += "  LEFT JOIN "	+ retSQLName("GU7") + " GU7"			+ CRLF
	cQrySZ9 += "  ON		SUBSTR(GU7.GU7_NRCID, 3, 5) 	=	SA1.A1_COD_MUN"			+ CRLF
	cQrySZ9 += "  	AND GU7.GU7_CDUF					=	SA1.A1_EST"			+ CRLF
	cQrySZ9 += "  	AND GU7.GU7_FILIAL					=	'" + xFilial("GU7") + "'"			+ CRLF
	cQrySZ9 += "  	AND GU7.D_E_L_E_T_					<>	'*'"			+ CRLF
	cQrySZ9 += "  WHERE"			+ CRLF
	cQrySZ9 += "  		SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"			+ CRLF

	if !empty(cCodCli) .AND. !empty(cCodLj)
	cQrySZ9 += "	AND SA1.A1_COD	= '" + cCodCli + "'"					+ CRLF
	cQrySZ9 += " 	AND	SA1.A1_LOJA	= '" + cCodLj + "'"						+ CRLF
	endif

	cQrySZ9 += " 
	cQrySZ9 += " UNION ALL"			+ CRLF
	*/
	cQrySZ9 += " SELECT SZ9.R_E_C_N_O_ AS Z9RECNO, YA_DESCR, YA_ZSIGLA, GU7_NRCID,"										+ CRLF
	cQrySZ9 += " Z9_ZENDER, Z9_ZBAIRRO, Z9_ZCEP, Z9_ZEST, Z9_ZCODMUN, Z9_ZMUNIC, Z9_ZIDEND, Z9_ALROAD, Z9_ZCROAD," + CRLF
	cQrySZ9 += " A1_NREDUZ, A1_NOME, A1_CGC, A1_COD, A1_LOJA, A1_VEND, A1_ZCROAD, Z9_ZRAZEND, A1_ZCODMGF,Z9_ZCGC, Z9_XSFA, " + CRLF
	cQrySZ9 += " SZ9.D_E_L_E_T_ SZ9DEL"										+ CRLF
	cQrySZ9 += " FROM "			+ retSQLName("SZ9") + " SZ9"			+ CRLF

	cQrySZ9 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"			+ CRLF
	cQrySZ9 += " ON		SZ9.Z9_ZCLIENT	= SA1.A1_COD"					+ CRLF
	cQrySZ9 += " 	AND	SZ9.Z9_ZLOJA	= SA1.A1_LOJA"					+ CRLF

	cQrySZ9 += " LEFT JOIN "	+ retSQLName("SYA") + " SYA"			+ CRLF
	cQrySZ9 += " ON		SYA.YA_CODGI	=	SA1.A1_PAIS"				+ CRLF
	cQrySZ9 += " 	AND SYA.YA_FILIAL	=	'" + xFilial("SYA") + "'"	+ CRLF
	cQrySZ9 += " 	AND SYA.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQrySZ9 += " LEFT JOIN "	+ retSQLName("GU7") + " GU7"			+ CRLF

	cQrySZ9 += " ON		SUBSTR(GU7.GU7_NRCID, 3, 5) 	=	SZ9.Z9_ZCODMUN"				+ CRLF // EX. 1600303
	cQrySZ9 += " 	AND GU7.GU7_CDUF					=	SZ9.Z9_ZEST"					+ CRLF
	cQrySZ9 += " 	AND GU7.GU7_FILIAL					=	'" + xFilial("GU7") + "'"	+ CRLF
	cQrySZ9 += " 	AND GU7.D_E_L_E_T_					<>	'*'"						+ CRLF

	cQrySZ9 += " WHERE"													+ CRLF
	cQrySZ9 += " 		SZ9.Z9_XSFA		=	'S'"						+ CRLF //S SIM, N NAO
	cQrySZ9 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"	+ CRLF
	cQrySZ9 += " 	AND	SZ9.Z9_FILIAL	=	'" + xFilial("SZ9") + "'"	+ CRLF
	cQrySZ9 += " 	AND	SZ9.D_E_L_E_T_	= SA1.D_E_L_E_T_ "						+ CRLF

	if !empty(cCodCli) .AND. !empty(cCodLj)
		cQrySZ9 += "	AND SZ9.Z9_ZCLIENT	= '" + cCodCli + "'"					+ CRLF
		cQrySZ9 += " 	AND	SZ9.Z9_ZLOJA	= '" + cCodLj + "'"						+ CRLF
	else
		cQrySZ9 += " 	AND SZ9.Z9_XINTEGR	=	'P'"						+ CRLF // P - PENDENTE, I INTEGRADO
	endif
	//cQrySZ9 += "	AND SZ9.R_E_C_N_O_	= 128573"					+ CRLF

	cQrySZ9 += " 	ORDER BY 1"						+ CRLF

	//MemoWrite("c:\temp\SZ9.SQL",changeQuery(cQrySZ9))

	conout( '[MGFWSC07] [SFA] ' + cQrySZ9 )

	TcQuery changeQuery(cQrySZ9) New Alias "QRYSZ9"
return

class AddressDeliverySFA
data applicationArea	as ApplicationArea
data endereco			as string
data bairro				as string
data cep				as string
data estado				as string
data cidade				as string
data idCidade			as string	
data pais				as string
data nomefantas			as string
data razaosocia			as string
data idCliente			as string
data idVendedor			as string
data statusdcn			as string
data idEntrega			as string
data idRota				as string
data isDelete			as string // S ou N

//campos necess·rios para o TAURA
data codERP				as string
data cpf				as string
data cnpj				as string
data logradouro			as string
data numero				as string
data complemento		as string
data SFA				as boolean

data siglapais			as string
data acao				as string


method New()
method setAddress()
//return
EndClass

/*
Construtor
*/
method new() class AddressDeliverySFA
self:applicationArea	:= ApplicationArea():new()
return

/*
Carrega o objeto
*/
Method setAddress() Class AddressDeliverySFA
Local nAt := 0
self:endereco			:= allTrim(QRYSZ9->Z9_ZENDER)
self:bairro				:= allTrim(QRYSZ9->Z9_ZBAIRRO)
self:cep				:= allTrim(QRYSZ9->Z9_ZCEP)
self:estado				:= allTrim(QRYSZ9->Z9_ZEST)
self:cidade				:= allTrim(QRYSZ9->Z9_ZMUNIC)
self:idCidade			:= allTrim(QRYSZ9->GU7_NRCID)
self:pais				:= allTrim(QRYSZ9->YA_DESCR)
self:nomefantas			:= allTrim(QRYSZ9->Z9_ZRAZEND)
self:razaosocia			:= allTrim(QRYSZ9->Z9_ZRAZEND)
self:idCliente			:= padR( allTrim( QRYSZ9->A1_CGC ), 15 )
self:idVendedor			:= allTrim(QRYSZ9->A1_VEND)
self:idEntrega			:= QRYSZ9->Z9_ZIDEND
self:idRota				:= QRYSZ9->Z9_ZCROAD

self:siglapais			:= allTrim(QRYSZ9->YA_ZSIGLA)
self:Acao				:= "2"
self:codERP				:= Alltrim(IIf(!Empty(QRYSZ9->A1_ZCODMGF),QRYSZ9->A1_ZCODMGF,QRYSZ9->A1_COD))+Alltrim(STR(VAL(QRYSZ9->Z9_ZIDEND)))
self:cpf				:= IIF(LEN(Alltrim(QRYSZ9->Z9_ZCGC)) == 11,ALLTRIM(QRYSZ9->Z9_ZCGC),"")
self:cnpj				:= IIF(LEN(Alltrim(QRYSZ9->Z9_ZCGC)) == 14,ALLTRIM(QRYSZ9->Z9_ZCGC),"")
self:logradouro			:= allTrim(QRYSZ9->Z9_ZENDER)
nAt := At(",",allTrim(QRYSZ9->Z9_ZENDER))
self:numero				:= iif(nAt > 0, Substr(allTrim(QRYSZ9->Z9_ZENDER),nAt,Len(allTrim(QRYSZ9->Z9_ZENDER))-nAt),"")
self:complemento		:= ""
self:SFA				:= QRYSZ9->Z9_XSFA == "S"

if QRYSZ9->SZ9DEL == "*"
self:isDelete := "S"
self:statusdcn					:= "D"//
else
self:isDelete := "N"
self:statusdcn					:= "U"//
endif

return
