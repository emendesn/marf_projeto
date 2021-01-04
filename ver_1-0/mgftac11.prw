#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
//
//
//
//
/*/{Protheus.doc} eMGFTAC11
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function eMGFTAC11()

	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif
	U_MGFTAC11()

Return

User Function MGFTAC11(cEmpX,cFilX)



	runInteg02()



return



static function runInteg02()
	local cURLPost		:= allTrim(getMv("MGF_TAC11"))

	local oWSSFA		:= nil
	Local cCHAVE        := ""

	private oCustomer	:= nil



	cliToSFA()

	while !QRYSA1->(EOF())

		cCHAVE    := allTrim((QRYSA1->A1_COD + "-" +QRYSA1->A1_LOJA))
		oCustomer := nil
		oCustomer := customerTAURA():new()

		oCustomer:setCustome()

		oCustomer:centroDist := "010001"

		oWSSFA := nil
		oWSSFA := MGFINT53():new(cURLPost, oCustomer , QRYSA1->A1RECNO , , ,AllTrim(GetMv("MGF_MONI01")), AllTrim(GetMv("MGF_MONT06")),cChave,,, .T. )
		oWSSFA:sendByHttpPost()

		cQ := "UPDATE "
		cQ += RetSqlName("SA1")+" "
		cQ += "SET "
		If oWSSFA:lOk .And.  oWSSFA:nStatus == 1
			cQ += "A1_XINTEGR = 'I', "
			cQ += "A1_ZTAUVEZ = 0 "
		Else
			cQ += "A1_ZTAUVEZ = A1_ZTAUVEZ+1 "
		Endif
		cQ += " WHERE R_E_C_N_O_ = "+Alltrim(Str(QRYSA1->A1RECNO))

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de cliente, para envio ao Taura.")
			Return()
		EndIf

		QRYSA1->(DBSkip())
	enddo

	QRYSA1->(DBCloseArea())
return




static function cliToSFA()
	local cQrySA1 := ""

	cQrySA1 := "SELECT R_E_C_N_O_ A1RECNO, A1_ZREGIAO, A1_COD_MUN, A1_ZVIDAUT,"										+ chr(13) + chr(10)
	cQrySA1 += " A1_COD		, A1_LOJA	, A1_VEND	, A1_TEL		, A1_DDD, "	+ chr(13) + chr(10)
	cQrySA1 += " A1_NOME	, A1_NREDUZ	, A1_CGC	, A1_FAX		, A1_DDI, "	+ chr(13) + chr(10)
	cQrySA1 += " A1_END		, A1_BAIRRO	, A1_CEP	, A1_PESSOA		, "	+ chr(13) + chr(10)
	cQrySA1 += " A1_MUN		, A1_EST	, A1_XSFA	, A1_COMPLEM	, "	+ chr(13) + chr(10)
	cQrySA1 += " A1_TIPO    , A1_ZCODMGF,                             "	+ chr(13) + chr(10)
	cQrySA1 += " ("	+ chr(13) + chr(10)
	cQrySA1 += " 	SELECT YA_ZSIGLA"	+ chr(13) + chr(10)
	cQrySA1 += " 	FROM " + retSQLName("SYA") + " SYA"	+ chr(13) + chr(10)
	cQrySA1 += " 	WHERE"	+ chr(13) + chr(10)
	cQrySA1 += " 		SYA.YA_CODGI = SA1.A1_PAIS"	+ chr(13) + chr(10)
	cQrySA1 += " 	AND SYA.YA_FILIAL	=	'" + xFilial("SYA") + "'"	+ chr(13) + chr(10)
	cQrySA1 += " 	AND SYA.D_E_L_E_T_ <> '*'"	+ chr(13) + chr(10)
	cQrySA1 += " ) A1_PAIS		,"	+ chr(13) + chr(10)

	cQrySA1 += " A1_COND		, A1_ULTCOM	,"	+ chr(13) + chr(10)

	cQrySA1 += " ("															+ chr(13) + chr(10)
	cQrySA1 += " SELECT E4_COND"											+ chr(13) + chr(10)
	cQrySA1 += " FROM " + retSQLName("SE4") + " SE4"						+ chr(13) + chr(10)
	cQrySA1 += " WHERE"														+ chr(13) + chr(10)
	cQrySA1 += " 		SE4.E4_CODIGO		=	SA1.A1_COND"					+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SE4.E4_FILIAL		=	'" + xFilial("SE4") + "'"	+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ chr(13) + chr(10)
	cQrySA1 += " ) E4_COND,"													+ chr(13) + chr(10)

	cQrySA1 += " A1_SATIV1	, A1_MSBLQL	, A1_LC			,"	+ chr(13) + chr(10)
	cQrySA1 += " A1_SALDUP	, A1_SALPEDL,"					+ chr(13) + chr(10)

	cQrySA1 += " ("											+ chr(13) + chr(10)
	cQrySA1 += " SELECT X5_DESCRI"							+ chr(13) + chr(10)
	cQrySA1 += " FROM " + retSQLName("SX5") + " SX5"		+ chr(13) + chr(10)
	cQrySA1 += " WHERE"										+ chr(13) + chr(10)
	cQrySA1 += " 		SX5.X5_TABELA	= 'T3'"					+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SX5.X5_CHAVE = SA1.A1_SATIV1"		+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SX5.D_E_L_E_T_ <> '*'"				+ chr(13) + chr(10)
	cQrySA1 += " ) DESCSEG,"								+ chr(13) + chr(10)
	cQrySA1 += " (A1_SALDUP+A1_SALPEDL) LIMUTIL,"			+ chr(13) + chr(10)
	cQrySA1 += " (A1_LC-(A1_SALDUP+A1_SALPEDL)) LIMDISPO"	+ chr(13) + chr(10)

	cQrySA1 += " , D_E_L_E_T_ A1DEL"	+ chr(13) + chr(10)

	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ chr(13) + chr(10)
	cQrySA1 += " WHERE"														+ chr(13) + chr(10)
	cQrySA1 += " 		SA1.A1_MSBLQL		<>	'1'"						+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SA1.A1_XINTEGR		=	'P'"						+ chr(13) + chr(10)
	cQrySA1 += " 	AND	SA1.A1_FILIAL		=	'" + xFilial("SA1") + "'"	+ chr(13) + chr(10)
	If SA1->(FieldPos("A1_ZTAUVEZ")) > 0
		cQrySA1 += " 	AND	SA1.A1_ZTAUVEZ		<= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "	+ chr(13) + chr(10)
	Endif

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySA1)), "QRYSA1" , .F. , .T. )

return

Class customerTAURA
	Data applicationArea AS ApplicationArea
	Data bairro AS string
	Data centroDist AS string
	Data cep AS string
	Data cidade AS string
	Data cnpj AS string
	Data condpgto AS string
	Data contrato AS string
	Data dataFatura AS string
	Data dataPedido AS string
	Data descrcentr AS string
	Data descrcondp AS string
	Data descrsegme AS string
	Data descrstatu AS string
	Data endereco AS string
	Data estado AS string
	Data limitecred AS float
	Data limitedisp AS float
	Data limiteutil AS float
	Data nomefantas AS string
	Data pais AS string
	Data proximafat AS string
	Data razaosocia AS string
	Data segmentocl AS int
	Data statusclie AS int
	Data statusdcn AS string
	Data statusfatu AS int
	Data statuspedi AS int
	Data ultimaatua AS string
	Data ultimopedi AS string
	Data validadex AS float
	Data valorfatur AS float
	Data valorpedid AS float
	Data idCliente AS string
	Data idVendedor AS string
	Data isDelete AS string

	Data SFA AS boolean
	Data codERP AS string
	Data cpftaura AS string
	Data cnpjtaura AS string
	Data nome AS string
	Data nomeReduzido AS string
	Data listaEndereco AS array
	Data listaTelefone AS array
	Data ativo AS string
	Data cAcao AS string
	Data NumeroExportacao AS String

	Method New()
	Method setCustome()
EndClass




Method new( ) Class customerTAURA
	self:applicationArea	:= ApplicationArea():new()
	self:listaEndereco		:= {}
	self:listaTelefone		:= {}
return


Class listaEndereco	
	Data codERP AS string
	Data cpf AS string
	Data cnpj AS string
	Data cidade AS string
	Data bairro AS string
	Data logradouro AS string
	Data numero AS string
	Data complemento AS string
	Data cep AS string

	Method new()
EndClass

Method new( ) Class listaEndereco
	self:cpf		:= ""
return


Class listaTelefone
	Data tipoTelefone AS string
	Data ddi AS string
	Data ddd AS string
	Data numeroTelefone AS string

	Method new()
EndClass

Method new( ) Class listaTelefone
	self:tipoTelefone	:= ""
return




Method setCustome( ) Class customerTAURA
	Local nAt := 0
	Local cCidade := ""

	self:bairro						:= allTrim(QRYSA1->A1_BAIRRO)

	self:centroDist					:= allTrim(QRYSA1->A1_ZREGIAO)

	self:descrcentr					:= getDescSZP(QRYSA1->A1_ZREGIAO)
	self:cep						:= allTrim(QRYSA1->A1_CEP)
	self:cidade						:= allTrim(QRYSA1->A1_MUN)

	self:cnpj						:= allTrim( QRYSA1->A1_CGC )
	self:condpgto					:= allTrim(QRYSA1->A1_COND)
	self:descrcondp					:= allTrim(QRYSA1->E4_COND)
	self:dataFatura					:= iif(!empty(QRYSA1->A1_ULTCOM), substr(QRYSA1->A1_ULTCOM,1,4)+"-"+substr(QRYSA1->A1_ULTCOM,5,2)+"-"+substr(QRYSA1->A1_ULTCOM,7,2),"")
	self:descrsegme					:= allTrim(QRYSA1->DESCSEG)
	self:descrstatu					:= iif(QRYSA1->A1_MSBLQL == "1", "0","1")
	self:endereco					:= allTrim(QRYSA1->A1_END)
	self:estado						:= allTrim(QRYSA1->A1_EST)
	self:limitecred					:= QRYSA1->A1_LC
	self:limitedisp					:= QRYSA1->LIMDISPO
	self:limiteutil					:= QRYSA1->LIMUTIL
	self:nomefantas					:= allTrim(QRYSA1->A1_NREDUZ)
	self:pais						:= allTrim(QRYSA1->A1_PAIS)
	self:razaosocia					:= subStr( allTrim( QRYSA1->A1_NOME ), 1, 36 )
	self:segmentocl					:= QRYSA1->A1_SATIV1
	self:statusclie					:= QRYSA1->A1_MSBLQL
	self:idCliente					:= allTrim((QRYSA1->A1_COD + QRYSA1->A1_LOJA))
	self:idVendedor					:= allTrim(QRYSA1->A1_VEND)


	aLastSO := {}
	aLastSO := getLastSO(QRYSA1->A1_COD, QRYSA1->A1_LOJA)
	self:dataPedido					:= aLastSO[1]
	self:ultimopedi					:= aLastSO[2]
	self:ultimaatua					:= ""
	self:validadex					:=  allTrim( str( QRYSA1->A1_ZVIDAUT ) )


	self:valorpedid					:= 0
	self:statuspedi					:= 0
	self:proximafat					:= ""
	self:valorfatur					:= 0
	self:statusfatu					:= 0
	self:contrato					:= ""
	self:statusdcn					:= "U"


	self:SFA					    := QRYSA1->A1_XSFA == "S"
	self:codERP					    := Alltrim(IIf(!Empty(QRYSA1->A1_ZCODMGF),QRYSA1->A1_ZCODMGF,QRYSA1->A1_COD))
	self:cpftaura				    := Alltrim(IIF(QRYSA1->A1_PESSOA=="F",QRYSA1->A1_CGC,""))
	IF QRYSA1->A1_TIPO == "X"
		self:cnpjtaura		    := ""
		self:NumeroExportacao   := Alltrim(IIf(!Empty(QRYSA1->A1_ZCODMGF),QRYSA1->A1_ZCODMGF,QRYSA1->A1_COD))
	Else
		self:cnpjtaura		    := IIF(QRYSA1->A1_PESSOA=="J",QRYSA1->A1_CGC,"")
		self:NumeroExportacao   := ""
	EndIF
	self:nome					    := ALLTRIM(QRYSA1->A1_NOME)
	self:nomeReduzido			    := ALLTRIM(QRYSA1->A1_NREDUZ)

	aAdd(self:listaEndereco, listaEndereco():new() )


	self:listaEndereco[Len(self:listaEndereco)]:codERP		:= Alltrim(IIf(!Empty(QRYSA1->A1_ZCODMGF),QRYSA1->A1_ZCODMGF,QRYSA1->A1_COD))+"0"
	self:listaEndereco[Len(self:listaEndereco)]:cpf			:= IIF(QRYSA1->A1_PESSOA=="F",QRYSA1->A1_CGC,"")
	self:listaEndereco[Len(self:listaEndereco)]:cnpj		:= IIF(QRYSA1->A1_PESSOA=="J",QRYSA1->A1_CGC,"")
	cCidade := StaticCall(MGFTAC01,PesqCidade,QRYSA1->A1_COD_MUN,QRYSA1->A1_EST)
	IF Empty(cCidade)
		cCidade := "0"
	EndIF
	self:listaEndereco[Len(self:listaEndereco)]:cidade		:= cCidade

	self:listaEndereco[Len(self:listaEndereco)]:bairro		:= allTrim(QRYSA1->A1_BAIRRO)
	self:listaEndereco[Len(self:listaEndereco)]:logradouro	:= Alltrim(Subs(QRYSA1->A1_END,1,IIf(At(",",QRYSA1->A1_END)>0,At(",",QRYSA1->A1_END)-1,Len(SA1->A1_END))))
	nAt := At(",",allTrim(QRYSA1->A1_END))
	self:listaEndereco[Len(self:listaEndereco)]:numero		:= iif(nAt > 0, Substr(allTrim(QRYSA1->A1_END),nAt+1,Len(allTrim(QRYSA1->A1_END))-nAt),"")
	self:listaEndereco[Len(self:listaEndereco)]:complemento	:= allTrim(QRYSA1->A1_COMPLEM)
	self:listaEndereco[Len(self:listaEndereco)]:cep			:= allTrim(QRYSA1->A1_CEP)

	If !Empty(allTrim(QRYSA1->A1_TEL))
		aAdd(self:listaTelefone, listaTelefone():new() )
		self:listaTelefone[Len(self:listaTelefone)]:tipoTelefone	:= IIF(QRYSA1->A1_PESSOA=="F","RESIDENCIAL","COMERCIAL")
		self:listaTelefone[Len(self:listaTelefone)]:ddi			  	:= allTrim(QRYSA1->A1_DDI)
		self:listaTelefone[Len(self:listaTelefone)]:ddd			  	:= allTrim(QRYSA1->A1_DDD)
		self:listaTelefone[Len(self:listaTelefone)]:numeroTelefone 	:= allTrim(QRYSA1->A1_TEL)
	EndIf
	If !Empty(allTrim(QRYSA1->A1_FAX))
		aAdd(self:listaTelefone, listaTelefone():new() )
		self:listaTelefone[Len(self:listaTelefone)]:tipoTelefone	:= "Fax"
		self:listaTelefone[Len(self:listaTelefone)]:ddi			  	:= allTrim(QRYSA1->A1_DDI)
		self:listaTelefone[Len(self:listaTelefone)]:ddd			  	:= allTrim(QRYSA1->A1_DDD)
		self:listaTelefone[Len(self:listaTelefone)]:numeroTelefone 	:= allTrim(QRYSA1->A1_FAX)
	EndIf

	self:ativo						:= iif(QRYSA1->A1_MSBLQL == "1", "0","1")

	if QRYSA1->A1DEL == "*"
		self:isDelete := "S"
		self:cAcao := "1"
	else
		self:isDelete := "N"
		self:cAcao := "1"
	endif
return




static function getDescSZP(cCodRegiao)
	local cQrySZP	:= ""
	local cRetDesc	:= ""

	cQrySZP := "SELECT ZP_DESCREG"
	cQrySZP += " FROM " + retSQLName("SZP") + " SZP"
	cQrySZP += " WHERE"
	cQrySZP += "		SZP.ZP_CODREG	=	'" + cCodRegiao		+ "'"
	cQrySZP += "	AND	SZP.ZP_ATIVO	=	'S'"
	cQrySZP += "	AND	SZP.ZP_FILIAL	=	'" + xFilial("SZP") + "'"
	cQrySZP += "	AND	SZP.D_E_L_E_T_	<> '*'"

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySZP)), "QRYSZP" , .F. , .T. )

	if !QRYSZP->(EOF())
		cRetDesc := allTrim(QRYSZP->ZP_DESCREG)
	endif

	QRYSZP->(DBCloseArea())
return cRetDesc




static function getLastSO(cCodCli, cLjCli)
	local aRetSO	:= {"", ""}
	local cQrySC5	:= ""

	cQrySC5 := "SELECT MAX(C5_EMISSAO) C5_EMISSAO, C5_NUM"
	cQrySC5 += " FROM " + retSQLName("SC5") + " SC5"
	cQrySC5 += " WHERE"
	cQrySC5 += "		SC5.C5_LOJACLI	=	'" + cLjCli			+ "'"
	cQrySC5 += "	AND	SC5.C5_CLIENTE	=	'" + cCodCli		+ "'"
	cQrySC5 += "	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"
	cQrySC5 += "	AND	SC5.D_E_L_E_T_	<> '*'"
	cQrySC5 += " GROUP BY C5_NUM"
	cQrySC5 += " ORDER BY C5_EMISSAO DESC"

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,changeQuery(cQrySC5)), "QRYSC5" , .F. , .T. )

	if !QRYSC5->(EOF())
		aRetSO := { dToC(sToD(QRYSC5->C5_EMISSAO)), QRYSC5->C5_NUM }
	endif

	QRYSC5->(DBCloseArea())
return aRetSO
