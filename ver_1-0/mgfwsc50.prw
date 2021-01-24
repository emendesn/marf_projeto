#include "totvs.ch"
#include "RWMAKE.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC50	
Integração Protheus-ME, cancelamento Pedido  
@type function

@author Anderson Reis
@since 09/03/2020
@version P12
@history Ajuste Interno  17/04/2020
/*/


User Function MGFWSC50()

local cURLInteg		:= " "
local nStatuHttp	:= 0
local aHeadStr		:= {}	
local cHeaderRet	:= ""
local nTimeOut		:= 600
local cTimeIni		:= ""
local cTimeFin		:= ""
local cTimeProc		:= ""
local cHttpRet		:= ""
local jCustomer		:= nil
local cJsonRet		:= ""
Local aCabec := {}
Local aItens := {}
Local alinha := {}  
Local Ccancela := "N" // cabe?ho
	
Private lMsErroAuto := .F.	
Private lMsHelpAuto := .T.
Private lAutoErrNoFile := .T.
private aLog := {}
Private cvar := " "

U_MFCONOUT('Iniciando integracao de cancelamento de pedidos de compra do Mercado Eletronico...') 

U_MFCONOUT('Iniciando integracao de pedidos de compra do Mercado Eletronico...') 
	
	//Leitura dos pre pedidos para a tabela ZGV
	U_MFCONOUT('Iniciando leitura de pedidos de compra do Mercado Eletronico...') 
	MGFWSC50L()
	U_MFCONOUT('Completou leitura de pedidos de compra do Mercado Eletronico...') 

	//Execução da integração dos pedidos
	U_MFCONOUT('Iniciando integracao de pedidos de compra do Mercado Eletronico...') 
	MGFWSC50E()
	U_MFCONOUT('Completou integracao de pedidos de compra do Mercado Eletronico...') 

	//Retorno de status
	U_MFCONOUT('Iniciando retorno de status para o Mercado Eletronico...')
	MGFWSC50S()
	U_MFCONOUT('Completou retorno de status para o Mercado Eletronico...')

	//Retorno de tokens
	U_MFCONOUT('Iniciando retorno de tokens para o Mercado Eletronico...')
	MGFWSC50T()
	U_MFCONOUT('Completou retorno de tokens para o Mercado Eletronico...')

Return

/*/{Protheus.doc} MGFWSC50L 
Leitura dos cancelamentos de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC50L()

Local cURLInteg := Alltrim(GetMv("MGF_WSC50")) 
Local aHeadstr 		:= {}
Local cTimeIni		:= time()
Local ctimeproc 	:= ""
Local ctimefin 		:= time()
Local cHeaderRet	:= ""
Local nStatuHttp 	:= 0
local nTimeOut		:= 600

aadd( aHeadStr, 'Content-Type: application/json')

U_MFCONOUT('Lendo pedidos para cancelamento...') 
U_MFCONOUT('URL...: ' +  cURLInteg)

cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
cTimeFin	:= time()
cTimeProc	:= elapTime(cTimeIni, cTimeFin)

nStatuHttp := httpGetStatus()

U_MFCONOUT('Status http...:' + alltrim(str(nStatuHttp))) 

If nStatuHttp < 200 .or. nStatuHttp > 299
	U_MFCONOUT('Erro na leitura de pedidos para cancelamento!')	
	Return
Endif
	
If len(cHttpRet) = 6 
	U_MFCONOUT('Não há pedidos pendentes!')	
	Return
Endif
	
If nStatuHttp >= 200 .and. nStatuHttp <= 299

	jCustomer := nil
	if fwJsonDeserialize( cHttpRet, @jCustomer )
	
		//Verifica se já tem integração com mesmo Token gravada na ZGV
		ZGV->(Dbsetorder(3)) //ZGV_TOKEN
		If ZGV->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))
			
			U_MFCONOUT('Token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o cancelamento do pre pedido ' + JCUSTOMER:ITEN:PREPEDIDO + ' já gravado na tabela intermediária!')	

			//Se o token está com status T mas ainda na lista marca para reenviar token para que saia da lista
			If ZGV->ZGV_STATUS = "T"
				Reclock("ZGV",.F.)
				ZGV->ZGV_STATUS := "S"
				ZGV->(Msunlock())
			Endif

			Return
		
		Else
		
			U_MFCONOUT('Gravando token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o cancelamento do pre pedido ' + JCUSTOMER:ITEN:PREPEDIDO + ' na tabela intermediária...')	

			// Para buscar a Empresa e Filial
			If Len(JCUSTOMER:ITEN:BORGS) = 2
				For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

					cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN:BORGS)  + 1
				Next
			Else
				For N := 1 to Len(JCUSTOMER:ITEN:RequisicoesPrePedido[1]:BORGS)
						
					cfilant := JCUSTOMER:ITEN:RequisicoesPrePedido[1]:BORGS[N+1]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN:RequisicoesPrePedido[1]:BORGS)  + 1
				Next N
			Endif

			_cpcprot := " "

			If AttIsMemberOf( JCUSTOMER:ITEN, "IDENTIFIC") 
				_cpcprot := JCUSTOMER:ITEN:IDENTIFIC
			Endif

			BEGIN TRANSACTION

			Reclock("ZGV",.T.)
			ZGV->ZGV_FILIAL := cfilant
			ZGV->ZGV_PREPED := JCUSTOMER:ITEN:PREPEDIDO
			ZGV->ZGV_PCPROT := _cpcprot
			ZGV->ZGV_JSONE := cHttpRet
			ZGV->ZGV_DATAE := date()
			ZGV->ZGV_HORAE := time()
			ZGV->ZGV_TOKEN := Alltrim(JCUSTOMER:TOKEN) 
			ZGV->ZGV_URLE := cURLInteg
			ZGV->(Msunlock())

			END TRANSACTION

			U_MFCONOUT('Completou gravação do token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o cancelamento do pre pedido ' + JCUSTOMER:ITEN:PREPEDIDO + ' na tabela intermediária...')	

		Endif

	Else

		U_MFCONOUT('Erro na leitura de pedidos!')	
		Return

	Endif

Else

	U_MFCONOUT('Erro na leitura de pedidos!')	
	Return

Endif

Return

/*/{Protheus.doc} MGFWSC50E	 
Execução da integracao de Cancelamento de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC50E()

	local cURLInteg		:= " "
	local cURLUse		:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}	
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""

	Local aCabec := {}
	Local aItens := {}
	Local alinha := {}  
	lOCAL oModelCtb := NIL
	local xprod  := " "
	local xforn   := " "
	Local ntot    := 0
	Local lNprc    := .f.
	Local _cNumPed := " "

	Local aratCC    := {} // Rateio CC
	Local aItemCC   := {} // Item CC
	Local cCusto    := " "
	Local lrateio   := .F.
	Local cItem      := " "
	Local cont     := 1
	Local lAltera  := .f.
	Local nOper    := 3
	Local nPerc   := 0
	Local cigual  := " "
	Local arats   := {}
	Local litem   := .f.
	Local abkp    := {}
	Local abkpdt  := {}
	Local nrets   := 0
	Local aAreaBKP  := GetArea()  
	Local cpederp := " "
	local cQryUsr	:= " "
	local cretusr   := " "  
	local _carma    := ""

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lAutoErrNoFile := .T.
	private aLog  := {}
	Private cvar  := " "
	Private nrats := 0 
	Private crats := 0
	Private cXrat  :=  "2" // Nao rateio

	cQuery := " SELECT ZGV_FILIAL,ZGV_PREPED, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZGV")
	cQuery += "  WHERE ZGV_STATUS  = ' '"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZGVTMP") > 0
		ZGVTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGVTMP", .F., .T.)
	
	If ZGVTMP->(eof())	
		U_MFCONOUT("Não existem pre pedidos pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando pre pedidos pendentes de processamento...")
		_ntot := 0
		Do while ZGVTMP->(!eof())
			_ntot++
			ZGVTMP->(Dbskip())
		Enddo
		ZGVTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZGVTMP->(!eof())	

		U_MFCONOUT("Processando cancelamento do pre pedido " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZGV->(Dbgoto(ZGVTMP->RECN))

		BEGIN TRANSACTION
		BEGIN SEQUENCE

		jCustomer := nil

		if fwJsonDeserialize( ZGV->ZGV_JSONE, @jCustomer )

			cJsonRet := ZGV->ZGV_JSONE

			lMSErroAuto := .T.
			_lachou := .F.
			_cerros := ""
			_cnumped := ""

			// Para buscar a Empresa e Filial
			For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

				cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG // retirado n + 1
				cEmpant := SUBSTR(JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG,1,2) //01
				n := Len(JCUSTOMER:ITEN:BORGS)  + 1
				_lachou := .T.

			Next

			If !(_lachou)
				lMSErroAuto := .T.
				_cerros := "Tag de filial não existe na integração!"
				BREAK
			Else
				lMSErroAuto := .F.
			Endif

			For X := 1 to 1

				dbSelectArea("SC7")
				SC7->(dbSetOrder(1)) //C7_FILIAL+C7_NUM+C7_ITEM

				//Valida existência e possibilidade de alteração do pedido
				SC7->(Dbsetorder(1)) //C7_FILIAL+C7_NUM
				
				If SC7->(dbseek(cfilant+alltrim(JCUSTOMER:ITEN:IDENTIFIC)))
			
					_lentrega := .F.
					_lresiduo := .F.
					_lcancela := .F.
					_lencer   := .F.
					_cnumped := alltrim(JCUSTOMER:ITEN:IDENTIFIC)
							
					Do while SC7->C7_FILIAL + ALLTRIM(SC7->C7_NUM) == cfilant + alltrim(JCUSTOMER:ITEN:IDENTIFIC)

						If SC7->C7_QUJE > 0
							_lentrega := .T.
						Endif

						If SC7->C7_RESIDUO = 'S'
							_lresiduo := .T.
						Endif

						If SC7->C7_ENCER = 'E'
							_lencer := .T.
						Endif

						SC7->(Dbskip())

					Enddo

					If _lresiduo .and. !lMSErroAuto 
						lMSErroAuto := .T.
						_cerros := "Pedido " +cfilant + "/" + alltrim(JCUSTOMER:ITEN:IDENTIFIC) 
						_cerros += " não pode ser alterado pois foi eliminado por resíduo!"
						nrets := 99
						BREAK
					Endif

					If _lencer  .and. !lMSErroAuto 
						lMSErroAuto := .T.
						_cerros := "Pedido " +cfilant + "/" + alltrim(JCUSTOMER:ITEN:IDENTIFIC) 
						_cerros += " não pode ser alterado pois foi encerrado!"
						nrets := 99
						BREAK
					Endif 

					If _lentrega .and. !lMSErroAuto 
						lMSErroAuto := .T.
						_cerros := "Pedido " +cfilant + "/" + alltrim(JCUSTOMER:ITEN:IDENTIFIC) 
						_cerros += " não pode ser alterado pois já possui entregas!"
						nrets := 99
						BREAK
					Endif

				Else
	
						lMSErroAuto := .T.
						_cerros := "Pedido " +cfilant + "/" + alltrim(JCUSTOMER:ITEN:IDENTIFIC)
						_cerros += " não pode ser alterado pois não foi localizado no Protheus!"
						nrets := 99
						BREAK

				Endif

				For nX := 1 To Len(JCUSTOMER:ITEN:ITENS)

					_lexclui := .F.

					If (AttIsMemberOf( JCUSTOMER:ITEN:ITENS[NX], "ACAO"))

						If JCUSTOMER:ITEN:ITENS[NX]:ACAO = "E"

							_lexclui := .T.

						Endif

					Endif

					If  JCUSTOMER:ITEN:ITENS[NX]:CANCELADO == 'S' .OR. _lexclui
						If SC7->(dbSeek(cfilant + alltrim(JCUSTOMER:ITEN:IDENTIFIC ) + strzero(val(JCUSTOMER:ITEN:ITENS[NX]:NUMEROITEMPEDIDO),4)))
			
							Reclock("SC7",.F.)
							SC7->C7_ZCANCEL := "S"
							SC7->C7_ZUSRCAN := "Integração ME -  " + dtoc(date()) + " - " +  time()  
							SC7->(Msunlock())

						Endif	

					
					Endif

				Next nX 
		               
			next x

		endif

		END SEQUENCE
		END TRANSACTION

		//Atualiza tabela intermediária
		ZGV->(Dbsetorder(3)) //ZGV_TOKEN
		If ZGV->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))

			Reclock("ZGV",.F.)
			ZGV->ZGV_PCPROT 	:= alltrim(_CNumPed)
			ZGV->ZGV_STATME 	:= IIF(lMsErroAuto,'108','1')
			ZGV->ZGV_DATAP 		:= DATE()
			ZGV->ZGV_HORAP 		:= TIME()
			ZGV->ZGV_STATUS 	:= 'P'
			ZGV->ZGV_JSONR		:= _cerros
			ZGV->(Msunlock())

		Endif

		U_MFCONOUT("Completou processamento de cancelamento do pre pedido " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		_nnt++
		ZGVTMP->(Dbskip())

	Enddo

	Return


/*/{Protheus.doc} MGFWSC50S 
Envio de status de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC50S()

cQuery := " SELECT ZGV_FILIAL,ZGV_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZGV")
cQuery += "  WHERE ZGV_STATUS  = 'P'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZGVTMP") > 0
	ZGVTMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGVTMP", .F., .T.)
	
If ZGVTMP->(eof())	
	U_MFCONOUT("Não existem pre pedidos pendentes de retorno de status!")
	Return
Else
	U_MFCONOUT("Contando pre pedidos pendentes de retorno de status...")
	_ntot := 0
	Do while ZGVTMP->(!eof())
		_ntot++
		ZGVTMP->(Dbskip())
	Enddo
	ZGVTMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZGVTMP->(!eof())	

	ZGV->(Dbgoto(ZGVTMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando status para pre pedido "  + alltrim(ZGV->ZGV_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	
	cUrl	 := GetMv("MGF_WSC50A") 
	cHeadRet 	:= ""
	aHeadOut	:= {}
	cJson		:= ""
	oJson		:= Nil
	cTimeIni	:= ""
	cTimeProc	:= ""
	xPostRet	:= Nil
	nStatuHttp	:= 0
	nTimeOut    := 600
	_cfornec 	:= ""

	aadd( aHeadOut, 'Content-Type: application/json' )

	oJson						  := JsonObject():new()
	cjson := " "
	cjson +='   {                                                   '
	cjson +='  	"MSGSTATUSPREPEDIDO": {                             '

	cjson  +='	"IDENTIFIC":  "' + alltrim(ZGV->ZGV_PCPROT) + '"            ,'

	cjson  +='	"PREPEDIDO":"' + alltrim(ZGV->ZGV_PREPED)   + '"       ,'

	cjson  +='	"STATUS":    ' + alltrim(ZGV->ZGV_STATME) +'                                    ,'
	
	SC7->(Dbsetorder(1)) //C7_FILIAL+C7_NUM

	_cfornec := ""

	If  !(EMPTY(ALLTRIM(ZGV->ZGV_PCPROT))) .and. SC7->(Dbseek(ZGV->ZGV_FILIAL+ZGV->ZGV_PCPROT))

		_cfornec := alltrim(SC7->C7_FORNECE) + alltrim(SC7->C7_LOJA)

	Else

		jCustomer := nil
		_cfornec := ""
		if fwJsonDeserialize( ZGV->ZGV_JSONE, @jCustomer )
		
			if (AttIsMemberOf( JCUSTOMER:ITEN, "FORNECEDORCLIENTE")) .and. VALTYPE(JCUSTOMER:ITEN:FORNECEDORCLIENTE) == "C" 

					_cfornec := JCUSTOMER:ITEN:FORNECEDORCLIENTE

			Elseif !(AttIsMemberOf( JCUSTOMER:ITEN, "FORNECEDORCLIENTE")) .and. (AttIsMemberOf( JCUSTOMER:ITEN, "CNPJFORNECEDOR"))

					//Se não tem a tag com fornecedor cliente procura pelo cnpj na SA2
					SA2->(Dbsetorder(3)) //A2_FILIAL+A2_CGC				
					SA2->(Dbseek(xfilial("SA2")+alltrim(JCUSTOMER:ITEN:CNPJFORNECEDOR)))
					_cfornec := alltrim(SA2->A2_COD) + alltrim(SA2->A2_LOJA)
			
			Endif

		Endif

	Endif

	cjson +='	"FORNECEDORCLIENTE":"' + _cfornec   +'"                             ,'

	cjson +=' "OBSERP":  "' + Alltrim(ZGV->ZGV_JSONR) + '"  }}'
		
	oJson:fromJson(cjson )

	cTimeIni := time()

	U_MFCONOUT("Enviando URL...: " + cUrl )
	U_MFCONOUT("Enviando Json..: " + cjson )

	if !empty( cJson )
		CJSON := STRTRAN(STRTRAN(CJSON,CHR(13),' '),CHR(10),' ')
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	endif

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	If AllTrim( str( nStatuHttp ) ) = '200'

		U_MFCONOUT("Retorno com status 200...: " +  xPostRet)

	Else

		U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")

		For l := 1 To 5

			If ! Empty( cJson )
				U_MFCONOUT("Reenviando URL ("+strzero(l,1)+" de 5)...: " + cUrl )
				U_MFCONOUT("Reenviando Json ("+strzero(l,1)+" de 5)..: " + cjson )
				xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()
				If AllTrim( str(nStatuHttp)) = '200'
					U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
					l := 5
				Else
					U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
				Endif

			Endif

		Next l

	Endif

	freeObj( oJson )

	//Grava envio se foi bem sucedido
	If nStatuHttp == 200

		Reclock("ZGV",.F.)
		ZGV->ZGV_DATAR	 	:= DATE()
		ZGV->ZGV_HORAR	 	:= TIME()
		ZGV->ZGV_JSONR 		:= cJson
		ZGV->ZGV_URLR 		:= cUrl
		ZGV->ZGV_RETORR 	:= xPostRet
		ZGV->ZGV_STATUS 	:= 'S'
		ZGV->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do status para pre pedido "  + alltrim(ZGV->ZGV_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZGVTMP->(Dbskip())

Enddo

Return

/*/{Protheus.doc} MGFWSC50T 
Envio de tokens de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC50T()

cQuery := " SELECT ZGV_FILIAL,ZGV_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZGV")
cQuery += "  WHERE ZGV_STATUS  = 'S'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZGVTMP") > 0
	ZGVTMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGVTMP", .F., .T.)
	
If ZGVTMP->(eof())	
	U_MFCONOUT("Não existem pre pedidos pendentes de envio de token!")
	Return
Else
	U_MFCONOUT("Contando pre pedidos pendentes de envio de token...")
	_ntot := 0
	Do while ZGVTMP->(!eof())
		_ntot++
		ZGVTMP->(Dbskip())
	Enddo
	ZGVTMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZGVTMP->(!eof())	

	ZGV->(Dbgoto(ZGVTMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando token para pre pedido "  + alltrim(ZGV->ZGV_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")

    cUrl	 := Alltrim(GetMv("MGF_WSC44B"))+Alltrim(ZGV->ZGV_TOKEN) 
	cHeadRet 	:= ""
	aHeadOut	:= {}
	cTimeIni	:= ""
	cTimeProc	:= ""
	xPostRet	:= Nil
	nTimeOut    := 240

	aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')
	aadd( aHeadOut, 'Authorization: "' + Alltrim(ZGV->ZGV_TOKEN) + '" ')
	aadd( aHeadOut, 'Accept: application/json')

	U_MFCONOUT("Enviando URL...: " + cUrl )

	xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
	cTimeFin	:= time()

	If AllTrim( str( nStatuHttp ) ) = '200'
					
		U_MFCONOUT("Retorno com status 200...: " +  xPostRet)

	else

		U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")

		// Retentativas pois deu erro 
		For l := 1 To 5

			xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			If AllTrim(Str(nStatuHttp)) = '200'
				U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
				l := 5
			Else
				U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
			Endif

		Next l

	Endif

	//Grava envio se foi bem sucedido
	If nStatuHttp == 200

		Reclock("ZGV",.F.)
		ZGV->ZGV_DATAT	 	:= DATE()
		ZGV->ZGV_HORAT	 	:= TIME()
		ZGV->ZGV_URLT 		:= cUrl
		ZGV->ZGV_RETORT 	:= xPostRet
		ZGV->ZGV_STATUS 	:= 'T'
		ZGV->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do token para pre pedido "  + alltrim(ZGV->ZGV_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZGVTMP->(Dbskip())

Enddo

Return


