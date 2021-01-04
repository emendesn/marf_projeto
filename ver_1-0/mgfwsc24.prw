#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24
INTEGRACAO E-COMMERCE - Envio de produtos

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/   
user function MGFWSC24()
	
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

	U_MFCONOUT('Iniciando ambiente para exportação de produtos para o Commerce...')

	MGFWSC24E()

	RESET ENVIRONMENT

return

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24E
Execução de integração de produtos

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/  
Static function MGFWSC24E()
	local cURLInteg		:= allTrim( superGetMv( "MGFECOM24A" , , "http://spdwvapl219:8200/protheus-produto/api/v1/products" ) ) //http://spdwvapl203:8200/protheus-produto/console/
	local cURLUse		:= ""
	local oInteg		:= nil
	local cUpdTbl		:= ""
	local nTotalSB1		:= 0
	local nCountSB1		:= 0

	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpMetho	:= ""

	aadd( aHeadStr, 'Content-Type: application/json')

	U_MFCONOUT("Selecionando produtos aptos a integrar com E-Commerce...")

	MGFWSC24Q() //Execução de query de produtos para envio de exportação

	If QRYSB1->(EOF())

		U_MFCONOUT("Não foram localizados produtos pendentes de exportação!")
		Return

	Endif

	nCountSB1	:= 0
	nTotalSB1	:= 0
	Count to nTotalSB1

	QRYSB1->(DBGoTop())

	while !QRYSB1->(EOF())
		nCountSB1++

		_CUUID := FWUUIDV4() //Identificador único da integração

		_lcommit := .F.
		if nCountSB1 == nTotalSB1 //Verifica se é o último para fazer a publicação dos produtos
			_lcommit := .T.
		endif

		//Se é o último produto aguarda 10 minutos para finalizar processo
		//Essa rotina será melhorada para aguardar resposta de todos os envios
		If _lcommit .and. nCountSB1 > 5
			For _nnj := 1 to int(nCountSB1/5)
				Sleep(2000)
				U_MFCONOUT("Aguardando completar exportação para publicar...")
			Next
		Endif

		U_MFCONOUT("Exportando produto " + allTrim( QRYSB1->B1_COD) + " - " + strzero(nCountSB1,6) + " de " + strzero(nTotalSB1,6) + "...")

		U_MFCONOUT("Consultando peso médio do produto " + alltrim(QRYSB1->B1_COD)  + " no Taura...")

		_npesom := 0

		cURLPostori	:= allTrim( superGetMv( "MGFECOM24C" , , "http://spdwvapl240:1337/taura-produto/api/v1/PesoMedio?idProduto=" ) )
		cURLPost := cURLPostori +  allTrim( QRYSB1->B1_COD				)

		cTimeIni	:= time()
		cHeaderRet	:= ""
		aHeadStr := {}
		aadd( aHeadStr, 'Content-Type: application/json')
		_cret := httpQuote( cURLPost /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, "" /*[cPOSTParms]*/, 120 /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

		nStatuHttp	:= httpGetStatus()
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		conout(" [E-COM] [MGFWSC24] * * * * * Status da integracao * * * * *")
		conout(" [E-COM] [MGFWSC24] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
		conout(" [E-COM] [MGFWSC24] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
		conout(" [E-COM] [MGFWSC24] Tempo de Processamento.......: " + cTimeProc)
		conout(" [E-COM] [MGFWSC24] URL..........................: " + cURLPost)
		conout(" [E-COM] [MGFWSC24] HTTP Method..................: " + "GET")
		conout(" [E-COM] [MGFWSC24] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [E-COM] [MGFWSC24] Retorno........................: " + _cret)
		conout(" [E-COM] [MGFWSC24] * * * * * * * * * * * * * * * * * * * * ")

		_oObjRet := nil

		fwJsonDeserialize(_cret, @_oObjRet)

		If len(_oObjRet) > 0 .and. VALTYPE(_oObjRet[1]:PesoMedio) == 'N'
			_npesom := _oObjRet[1]:PesoMedio
		Endif

		If _npesom > 0 .and. _npesom != QRYSB1->B1_ZPESMED

			U_MFCONOUT("Atualizando peso médio do produto " + alltrim(QRYSB1->B1_COD)  + " no Protheus...")
			SB1->(dBSETORDER())
			If SB1->(Dbseek(xfilial("SB1")+allTrim( QRYSB1->B1_COD )))
				Reclock("SB1",.F.)
				SB1->B1_ZPESMED := _npesom
				SB1->(Msunlock())
			Endif

		Else
			_npesom := QRYSB1->B1_ZPESMED
		Endif

		//Se for peso médio 0 não envia
		If _npesom == 0
			U_MFCONOUT("Produto " + alltrim(QRYSB1->B1_COD)  + " por estar com peso médio zerado...")
			QRYSB1->(DBSkip())
			Loop
		Endif

		oJson				:= JsonObject():new()
		oJson['b1cod']		:= allTrim( QRYSB1->B1_COD				)
		oJson['b1zccateg']	:= IIF(allTrim(QRYSB1->ZA4_CODIGO)=='008','promocao',allTrim(QRYSB1->ZA4_CODIGO))
		oJson['b1desc']		:= allTrim( QRYSB1->B1_DESC				)
		oJson['b1codsku']	:= allTrim( QRYSB1->B1_COD				)
		oJson['zzudescri']	:= allTrim( QRYSB1->ZZU_DESCRI			)
		oJson['zdadescri']	:= allTrim( QRYSB1->ZDA_DESCR			)
		oJson['b1zconser']	:= allTrim(MGFWSC24T(allTrim( QRYSB1->B1_ZCONSER),"B1_ZCONSER",""))
		oJson['b1posipi']	:= allTrim( QRYSB1->B1_POSIPI			)
		oJson['b1zean13']	:= alltrim(str(QRYSB1->B1_ZEAN13)       )
		oJson['pesoMedio']	:= alltrim(str(_npesom)       )
		oJson['uuid']	    := _CUUID
		oJson['b1zuldpr'] 	:= alltrim(str(QRYSB1->B1_ZVLDPR))
		oJson['b1zmeses']	:= allTrim(MGFWSC24T(allTrim(QRYSB1->B1_ZMESES),"B1_ZMESES",""))
		oJson['b5emb1']		:= allTrim( QRYSB1->B5_EMB1				)
		oJson['da1prcven']	:= allTrim( str( QRYSB1->DA1_PRCVEN )	)
		oJson['b1msblql']	:= allTrim( QRYSB1->B1_MSBLQL			)
		oJson['linha']		:= allTrim( QRYSB1->LINHA				)

		cfilold := cfilant

		cfilant := '010015'
		oestoque := nil
		oestoque := JsonObject():new()
		setStock()
		oJson['_estoque_010015'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010016'
		setStock()
		oJson['_estoque_010016'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010041'
		setStock()
		oJson['_estoque_010041'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010044'
		setStock()
		oJson['_estoque_010044'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010050'
		setStock()
		oJson['_estoque_010050'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010059'
		setStock()
		oJson['_estoque_010059'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")
		cfilant := '010066'
		setStock()
		oJson['_estoque_010066'] := IIF(oestoque['bqtdeestoque'] == 0, "INDISPONIVEL","DISPONIVEL")

		cfilant := cfilold

		oJson['flgcommit']	:= _lcommit

		nStatuHttp	:= 0
		cHeaderRet	:= ""
		cJson		:= ""
		cJson		:= oJson:toJson()

		cHttpMetho	:= ""

		if !empty( cJson )

			cTimeIni := time()

			_cretorno := ""

			cHttpMetho	:= "PUT"
			cURLUse		:= ""
			cURLUse		:= cURLInteg + "/" + oJson['b1cod']

			_cretorno := httpQuote( cURLUse /*<cUrl>*/, cHttpMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

			nStatuHttp	:= httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [E-COM] [MGFWSC24] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC24] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC24] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC24] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC24] URL..........................: " + cURLUse)
			conout(" [E-COM] [MGFWSC24] HTTP Method..................: " + cHttpMetho)
			conout(" [E-COM] [MGFWSC24] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC24] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC24] * * * * * * * * * * * * * * * * * * * * ")
		endif

		//Grava log de envio da integração de produto
		Reclock("ZFU",.T.)
		ZFU->ZFU_PROD   := allTrim( QRYSB1->B1_COD				)
		ZFU->ZFU_CATEGO := allTrim( QRYSB1->ZA4_CODIGO			)
		ZFU->ZFU_EAN13  := alltrim(str(QRYSB1->B1_ZEAN13)       )
		ZFU->ZFU_THREAD := Threadid()
		ZFU->ZFU_COMMIT := _lcommit
		ZFU->ZFU_MESES  := allTrim(MGFWSC24T(allTrim(QRYSB1->B1_ZMESES),"B1_ZMESES",""))
		ZFU->ZFU_LINHA  := allTrim( QRYSB1->LINHA				)
		ZFU->ZFU_VLDPR  := alltrim(str(QRYSB1->B1_ZVLDPR))
		ZFU->ZFU_ZZCATE := allTrim( QRYSB1->ZA4_CODIGO			)
		ZFU->ZFU_ZZUDES := allTrim( QRYSB1->ZZU_DESCRI			)
		ZFU->ZFU_POSIPI := allTrim( QRYSB1->B1_POSIPI			)
		ZFU->ZFU_CODSKU := allTrim( QRYSB1->B1_COD				)
		ZFU->ZFU_DESC   := allTrim( QRYSB1->B1_DESC				)
		ZFU->ZFU_ZDADES := allTrim( QRYSB1->ZDA_DESCR			)
		ZFU->ZFU_CONSER := allTrim(MGFWSC24T(allTrim( QRYSB1->B1_ZCONSER),"B1_ZCONSER",""))
		ZFU->ZFU_PESOME := QRYSB1->B1_ZPESMED
		ZFU->ZFU_PRODBL := allTrim( QRYSB1->B1_MSBLQL			)
		ZFU->ZFU_PRCVEN := QRYSB1->DA1_PRCVEN 
		ZFU->ZFU_EMBALA := allTrim( QRYSB1->B5_EMB1				)
		ZFU->ZFU_JSONEN := ALLTRIM(cJson)
		ZFU->ZFU_JSONRE := _cretorno
		ZFU->ZFU_URL    := cURLUse
		ZFU->ZFU_METODO := cHttpMetho
		ZFU->ZFU_DATA1  := date()
		ZFU->ZFU_HORA1  := time()
		If nStatuHttp >= 200 .and. nStatuHttp <= 299
			ZFU->ZFU_STATUS := "1 - ENVIADO PARA API PROTHEUS-CLIENTE"
		Else
			ZFU->ZFU_STATUS := "0 - FALHA DE ENVIO  PARA API PROTHEUS-CLIENTE"
		Endif	
		ZFU->ZFU_UUID   := _CUUID
		ZFU->ZFU_HTTRET := nStatuHttp

		ZFU->(Msunlock())

		QRYSB1->(DBSkip())

		FreeObj(oJson)

	enddo

	U_MFCONOUT("Completou exportação de produtos para o E-Commerce")

	QRYSB1->(DBCloseArea())

return

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24Q
Seleciona os produtos para exportação

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/  
static function MGFWSC24Q()

	local cQrySB1 := ""

	cQrySB1 := "SELECT"															+ CRLF
	cQrySB1 += " B1_ZSTATEC,"													+ CRLF
	cQrySB1 += " B1_COD,"														+ CRLF
	cQrySB1 += " ZA4_DESCR,"													+ CRLF
	cQrySB1 += " B1_DESC,"														+ CRLF
	cQrySB1 += " ZZU_DESCRI,"													+ CRLF
	cQrySB1 += " ZA4_CODIGO,"													+ CRLF
	cQrySB1 += " ZDA_DESCR,"													+ CRLF
	cQrySB1 += " B1_ZCONSER,"													+ CRLF
	cQrySB1 += " B1_POSIPI ,"													+ CRLF
	cQrySB1 += " 'N' ZJ_FEFO,"													+ CRLF
	cQrySB1 += " COALESCE( B1_ZPESMED, 0 ) B1_ZPESMED," 						+ CRLF
	cQrySB1 += " B1_ZMESES,"													+ CRLF
	cQrySB1 += " B1_ZEAN13,"													+ CRLF
	cQrySB1 += " B5_EMB1,"														+ CRLF
	cQrySB1 += " B1_ZVLDPR, "													+ CRLF
	cQrySB1 += " ("																+ CRLF
	cQrySB1 += " SELECT MIN( DA1_PRCVEN )"										+ CRLF
	cQrySB1 += " FROM "	+ retSQLName("DA1") + " DA1"							+ CRLF

	cQrySB1 += " INNER JOIN "	+ retSQLName("DA0") + " DA0"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		DA0.DA0_XENVEC	=	'1'"								+ CRLF
	cQrySB1 += " 	AND	DA0.DA0_ATIVO	=	'1'"								+ CRLF // 1=Sim;2=Nao
	cQrySB1 += " 	AND	DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
	cQrySB1 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'"			+ CRLF
	cQrySB1 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " WHERE"															+ CRLF
	cQrySB1 += " 		DA1.DA1_CODPRO	=	SB1.B1_COD"							+ CRLF
	cQrySB1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'"			+ CRLF
	cQrySB1 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQrySB1 += " ) DA1_PRCVEN,"													+ CRLF

	cQrySB1 += " ZC4_DESCRI LINHA,"												+ CRLF
	cQrySB1 += " B1_MSBLQL,"													+ CRLF
	cQrySB1 += " SB1.R_E_C_N_O_ SB1RECNO"										+ CRLF
	cQrySB1 += " FROM "			+ retSQLName("SB1") + " SB1"					+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZC4") + " ZC4"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZC4.ZC4_CODIGO	=	SB1.B1_ZLINHA"						+ CRLF
	cQrySB1 += " 	AND	ZC4.ZC4_FILIAL	=	'" + xFilial("ZC4") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZC4.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZZU") + " ZZU"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZZU.ZZU_CODIGO	=	SB1.B1_ZMARCAC"						+ CRLF
	cQrySB1 += " 	AND	ZZU.ZZU_FILIAL	=	'" + xFilial("ZZU") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZZU.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZA4") + " ZA4"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZA4.ZA4_CODIGO	=	SB1.B1_ZCCATEG"						+ CRLF
	cQrySB1 += " 	AND	ZA4.ZA4_FILIAL	=	'" + xFilial("ZA4") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZA4.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("ZDA") + " ZDA"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		ZDA.ZDA_COD		=	SB1.B1_ZORIGEM"						+ CRLF
	cQrySB1 += " 	AND	ZDA.ZDA_FILIAL	=	'" + xFilial("ZDA") + "'"			+ CRLF
	cQrySB1 += " 	AND	ZDA.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " LEFT JOIN "	+ retSQLName("SB5") + " SB5"					+ CRLF
	cQrySB1 += " ON"															+ CRLF
	cQrySB1 += " 		SB5.B5_COD		=	SB1.B1_COD"							+ CRLF
	cQrySB1 += " 	AND	SB5.B5_FILIAL	=	'" + xFilial("SB5") + "'"			+ CRLF
	cQrySB1 += " 	AND	SB5.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQrySB1 += " WHERE"															+ CRLF
	cQrySB1 += " 		SB1.B1_ZLINHA	>	' '"								+ CRLF // Só envia com linha preenchida
	cQrySB1 += " 	AND	ZA4.ZA4_CODIGO	>	' '"								+ CRLF // Só envia categoria definida
	cQrySB1 += " 	AND	SB1.B1_COD		<	'500000'   "						+ CRLF // Produtos acima de 500mil nao serao integrados
	cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"			+ CRLF
	cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"								+ CRLF


	//Só atualiza o que tem tabela de preço ativa
	cQrySB1 += "	AND ( SELECT MIN( DA1_PRCVEN )"								+ CRLF
 	cQrySB1 += "	FROM DA1010 DA1"											+ CRLF
 	cQrySB1 += "	INNER JOIN DA0010 DA0"										+ CRLF
 	cQrySB1 += "	ON"															+ CRLF
 	cQrySB1 += "	DA0.DA0_XENVEC	=	'1'"									+ CRLF
 	cQrySB1 += "	AND	DA0.DA0_ATIVO	=	'1'"								+ CRLF
 	cQrySB1 += "	AND	DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
 	cQrySB1 += "	AND	DA0.DA0_FILIAL	=	'01    '"							+ CRLF
 	cQrySB1 += "	AND	DA0.D_E_L_E_T_	<>	'*'"								+ CRLF
 	cQrySB1 += "	WHERE"														+ CRLF
 	cQrySB1 += "		DA1.DA1_CODPRO	=	SB1.B1_COD"							+ CRLF
 	cQrySB1 += "	AND	DA1.DA1_FILIAL	=	'01    '"							+ CRLF
 	cQrySB1 += "	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
 	cQrySB1 += "	) > 1"														+ CRLF

	cQrySB1 += " ORDER BY SB1.B1_COD"											+ CRLF

	tcQuery cQrySB1 New Alias "QRYSB1"

return

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24Q
Carrega descrição do item selecionado

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/  
Static Function MGFWSC24T(cChave, cCampo, cConteudo)
    Local aArea       := GetArea()
    Local aCombo      := {}
    Local nAtual      := 1
    Local cDescri     := ""
    Default cChave    := ""
    Default cCampo    := ""
    Default cConteudo := ""

    //Se o campo e o conteúdo estiverem em branco, ou a chave estiver em branco, não há descrição a retornar
    If (Empty(cCampo) .And. Empty(cConteudo)) .Or. Empty(cChave)
        cDescri := ""
    Else
        //Se tiver campo
        If !Empty(cCampo)
            aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

            //Percorre as posições do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descrição
                If cChave == aCombo[nAtual][2]
                    cDescri := aCombo[nAtual][3]
                EndIf
            Next

        //Se tiver conteúdo
        ElseIf !Empty(cConteudo)
            aCombo := StrTokArr(cConteudo, ';')

            //Percorre as posições do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descrição
                If cChave == SubStr(aCombo[nAtual], 1, At('=', aCombo[nAtual])-1)
                    cDescri := SubStr(aCombo[nAtual], At('=', aCombo[nAtual])+1, Len(aCombo[nAtual]))
                EndIf
            Next
        EndIf
    EndIf

    RestArea(aArea)
Return cDescri


//----------------------------------------------------------------
// Carrega saldo no objeto
//----------------------------------------------------------------
static function setStock()
	local aRetSaldo	:= {}
	local nPorcEcom	:= superGetMv( "MGFECOM27B" , , 10 )
 
	oestoque['bfilial']		:= allTrim( cFilAnt )
	oestoque['produto']		:= allTrim( QRYSB1->B1_COD	)
	oestoque['bqtdeestoque']	:= 0

	aRetSaldo := {0,0}
	aRetSaldo := getSalProt(oestoque['produto'], "", cFilAnt, .T.)

	if aRetSaldo[1] > 0
		oestoque['bqtdeestoque'] := ( ( nPorcEcom / 100 ) * aRetSaldo[1] / QRYSB1->B1_ZPESMED )
	endif

	if oestoque['bqtdeestoque'] < 1
		oestoque['bqtdeestoque'] := 0
	else
		oestoque['bqtdeestoque'] := round( oestoque['bqtdeestoque'], 0 )
	endif
return

//------------------------------------------------------
// Retorna saldo do Produto apos consulta com Taura - Pedido deve estar posicionado
// [1] = Saldo (Taura - Protheus)
// [2] = Peso Medio
//------------------------------------------------------
static function getSalProt( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB1->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB1->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB1->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB1->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB1->ZJ_FEFO <> 'S'
			MFWSC24D( @aRet, cStockFil, QRYSB1->B1_COD, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			MFWSC24D( @aRet, cStockFil, QRYSB1->B1_COD, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB1->B1_COD, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			MFWSC24D( @aRet2, cStockFil, QRYSB1->B1_COD, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( QRYSB1->B1_COD, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				MFWSC24D( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				MFWSC24D( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

				nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				//if nSalProt2 > nSalProt
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				MFWSC24D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			MFWSC24D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			MFWSC24D( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	Conout("Parametros enviado para a função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
	Conout("[MGFWSC24] - Resuldado da funcao getSalProt: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock

//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	Conout("[MGFWSC24] - Roda Query funcao getSaldoPv: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFWSC24] - Resuldado da Query funcao getSaldoPv saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		Conout("[MGFWSC24] - Roda Query funcao getSaldoPv: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		Conout("[MGFWSC24] - Resuldado da Query funcao getSaldoPv - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV

/*
=====================================================================================
Programa.:              MFWSC24D
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Consulta de resposta de estoque assincrono na tabela ZFP
=====================================================================================
*/
Static Function MFWSC24D(xRet,xFilProd,xProd,xFEFO,xDTInicial,xDTFinal)
              //MFWSC24D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

Local _aRet  := {0,0,0,0,0,"","",""}
Local _lret := .T.

If xFEFO
	_ctipo := "F"
Else
	_ctipo := "N"
Endif

//Verifica se tem resposta válida nos últimos 60 minutos
cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
cQryZFQ += " ZFQ_PROD = '" + alltrim(xProd) + "' AND ZFQ_FILIAL = '" + xFilProd + "' and "
cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + _ctipo + "' and " 
cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 3600)) 

If xFEFO

    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(xDTInicial) + "' AND ZFQ_DTVALF = '" + dtos(xDTFinal) + "'"

Endif

cQryZFQ += " ORDER BY  ZFQ_DTRESP,ZFQ_HRRESP DESC"

TcQuery cQryZFQ New Alias "QRYZFQ"


If !(QRYZFQ->(EOF()))

    //Retorna resposta válida
	ZFQ->(Dbgoto(QRYZFQ->REC))
	_aRet  := {ZFQ->ZFQ_ESTOQU,ZFQ->ZFQ_CAIXAS,ZFQ->ZFQ_PECAS ,0,ZFQ->ZFQ_PESO,ZFQ->ZFQ_SOLENV,ZFQ->ZFQ_UUID,ZFQ->ZFQ_RESREC}

Else

    //Retorna erro de consulta
	_aRet  := {0,0,0,0,0,"","",""}
	_lret := .F.

Endif

Dbselectarea("QRYZFQ")
Dbclosearea()

xret := _aret

Return _lret