#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFFATA4	 
Integracao de pedidos de venda do E-Commerce
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/

user function MGFFATA4()

U_MFCONOUT('Iniciando integração de pedidos do E-Commerce...')

U_MFCONOUT('Recuperando pedidos do OCC...')

MGFFATA4R()

U_MFCONOUT("Completou recuperação de pedidos do OCC") 


U_MFCONOUT('Processando pedidos na tabela intermediária...')

MGFFATA4()

U_MFCONOUT('Completou processamento de pedidos do E-Commerce')

U_MFCONOUT('Validando registros na tabela de caução...')

MGFFATA4V()

U_MFCONOUT('Completou validação de registros na tabela de caução')

U_MFCONOUT('Validando registros faturados na tabela de caução...')

MGFFATA4F()

U_MFCONOUT('Completou validação de registros faturados na tabela de caução')

return

/*/{Protheus.doc} MGFFATA4R 
Recupera pedidos de venda do E-Commerce
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/
Static function MGFFATA4R()

Local _carqcon := getmv("MGFWSC79C",,"\\spdwvhml016\Consulta\CONSULTA.TXT")
Local _carqcpl := getmv("MGFWSC792",,"\\itpinf44\consultaecommerce\Completo\CONSULTA2.TXT")
Local _apeds := {}

nHandle := FT_FUse(_carqcon)

//Verifica se buscou arquivo, essa parte precisará ser mudada para buscar via api                
If nHandle = -1
    U_MFCONOUT('Não localizou arquivo de pedidos, encerrando rotina!')
	Return
Else
    _nLast := FT_FLastRec()
    FT_FGoTop()
    _nni := 1
    _lfalha := .F.
               
    Do while !FT_FEOF()

        U_MFCONOUT('Validando pedido ' + strzero(_nni,6) + ' de ' + strzero(_nlast,6) + '...' )
                        
       _cline  := alltrim(FT_FReadLn())   
                        
        If substr(_cline,1,19) == '{"lastModifiedDate"'
                        
            oJson := JsonObject():New()
            ret := oJson:FromJson(_cline)
            _nId := oJson['id']
            _cstatus := oJson['state']
                            
            XC5->(Dbsetorder(5)) //XC5->IDECOM

            If _cstatus == "SUBMITTED" .AND. !(XC5->(Dbseek(_nId)))

                aadd(_apeds, _nId)

            Endif

            FreeObj(oJson)

        Endif

        FT_FSKIP()
        _nni++

    Enddo

    FT_FUSE()

	//Valida se tem arquivo completo
	oFile := FwFileReader():New(_carqcpl)

	If !(oFile:Open())
   
    	U_MFCONOUT('Não localizou arquivo completo de pedidos, encerrando rotina!')
		Return

	Else

		_alinhas := oFile:GetAllLines() 

	Endif

	For _nnj := 1 to len(_apeds)

		U_MFCONOUT('Gravando tabela intermediária para o pedido ' + alltrim(_apeds[_nnj]) + ' - ' + strzero(_nnj,6) + ' de ' + strzero(_nlast,6) + '...' )

		//Procura linha do pedido e joga na variavel
		
		_cline := ""

		For _nni := 1 to len(_alinhas)

			_cLine  := _alinhas[_nni]   
                        
        	If substr(_cline,1,18) == '{"notaBonificacao"' .and. alltrim(_apeds[_nnj]) $ _cLine .and. "SUBMITTED" $ _cLine
				Exit 
			Else
				_cline := ""
			Endif

		Next

		If _cline == ""
			U_MFCONOUT('Não localizou dados para o pedido ' + alltrim(_apeds[_nnj]) + ' - ' + strzero(_nnj,6) + ' de ' + strzero(_nlast,6) + '...' )
			Loop
		Else

			//monta json para enviar ao experience
 			_csjon :=  '{ "orderId":"' + alltrim(_apeds[_nnj]) + '",'
 			_csjon +=  '  "parentSessionId":"AJj8UpJhMUNsUb05d_RgGGUQMblJw43saQz3UbFKBKOC_QFH0KmX!-142364467!1576191301806",'
 			_csjon +=  '  "sessionId":"AJj8UpJhMUNsUb05d_RgGGUQMblJw43saQz3UbFKBKOC_QFH0KmX!-142364467!1576191301806",'
 			_csjon +=  '  "source":"MessageForwardFilter",'
 			_csjon +=  '  "type":"atg.commerce.fulfillment.SubmitOrder",'
			_csjon +=  '   "userId":null,'
			_csjon +=  '   "discountInfo":{'
 			_csjon +=  '     "orderCouponsMap":null'
			_csjon +=  '   },'
			_csjon +=  '   "profileId":"6441286",'
			_csjon +=  '   "originalUserId":null,'
			_csjon +=  '   "siteId":{' 
			_csjon +=  '      "name":"Mercado Marfrig",'
 			_csjon +=  '     "id":"siteUS"'
 			_csjon +=  '  },'
			_csjon +=  '   "id":"ci102003995",'
 			_csjon +=  '  "originalId":"ci102003995",'
 			_csjon +=  '  "order":'
	

			_csjon :=  _csjon + alltrim(_cline) + '}'

			cHeadRet 	:= ""
			aHeadOut	:= {}
			nTimeOut    := 600

			aadd( aHeadOut, 'Content-Type: application/json' )
			aAdd( aHeadOut , "Authorization: Basic "+Encode64("barramento"+":"+"YmFycmFtZW50bw==" ) )

			curl := getmv("MGFFAT4U",,"https://SPDWVAPL240:443/experience/oracle/commerce/api/pedidos/orders")

			//Envia json para a experience
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, _csjon/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

			nStatuHttp	:= httpGetStatus()

			T := 1


		Endif


	Next

Endif

Return

/*/{Protheus.doc} MGFFATA4
Processa pedidos de venda do E-Commerce
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/
Static function MGFFATA4()

	local nI			:= 0
	local nLimXC5		:= superGetMv( "MGF_ECOCOU", , 5 )
	local cIdToProc		:= ""
	Local _ntot := 0
	Local _nni := 1

	private aSalesOrde	:= {}
	private oSalesOrde	:= nil
	private oItem		:= nil

	private __nLimTr	:= superGetMv( "MGF_ECOTHR", , 15 )

	U_MFCONOUT("Carregando pedidos pendentes da tabela intermediária...")

	cQryXC5 := "SELECT XC5.R_E_C_N_O_ XC5RECNO"												+ CRLF
	cQryXC5 += " FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryXC5 += " WHERE"																		+ CRLF
	cQryXC5 += " 	XC5.XC5_STATUS	=	'1'"												+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
	cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryXC5 += " ORDER BY XC5_IDECOM"														+ CRLF

	If select("QRYXC5") > 0
		QRYXC5->(Dbclosearea())
	Endif

	tcQuery cQryXC5 new Alias "QRYXC5"

	if !QRYXC5->( EOF() )

		while !QRYXC5->( EOF() )
			_ntot++
			QRYXC5->(Dbskip())
		Enddo

		QRYXC5->(Dbgotop())
		_nni := 1
	
		
		while !QRYXC5->( EOF() )
	
			XC5->(Dbgoto(QRYXC5->XC5RECNO))

			U_MFCONOUT("Processando pedido " + ALLTRIM(XC5->XC5_IDECOM) + " - " + STRZERO(_nni,6);
																	 + " de " + strzero(_ntot,6) + "...")

			CFILANT := XC5->XC5_FILIAL

			U_runFATA5() //Processa pedido de venda da XC5 posicionada, funcao no fonte MGFFATA5

			XC5->(Dbgoto(QRYXC5->XC5RECNO))

			If XC5->XC5_STATUS = '3'

				U_MFCONOUT("Criou pedido " + ALLTRIM(XC5->XC5_FILIAL) + "/" + ALLTRIM(XC5->XC5_PVPROT);
											 + " - " + STRZERO(_nni,6) + " de " + strzero(_ntot,6) + "...")

			Else


				U_MFCONOUT("Falhou criação do  pedido " + ALLTRIM(XC5->XC5_IDECOM) + " - " + STRZERO(_nni,6);
												 + " de " + strzero(_ntot,6) + " - " + alltrim(XC5->XC5_OBS))

			Endif


			QRYXC5->(Dbskip())
			_nni++

		enddo

	Else

		U_MFCONOUT("Não há pedidos pendentes na tabela intermediária")

	endif

	QRYXC5->(DBCloseArea())

return

/*/{Protheus.doc} MGFFATA4V 
Verifica e corrige tabela ZE6010
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/

static function MGFFATA4V() 

_ndias := getmv("MGFFATA4V",,60)

U_MFCONOUT("Carregando pedidos órfãos...")

//Seleciona pedidos dos últimos 60 dias que não tem ZE6
cQryXC5 := "SELECT XC5.R_E_C_N_O_ XC5RECNO"												+ CRLF
cQryXC5 += " FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
cQryXC5 += " WHERE"																		+ CRLF
cQryXC5 += " 	XC5.XC5_STATUS	=	'3'"												+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
cQryXC5 += " 	AND	XC5_DTRECE >= '" + DTOS(DATE()-_ndias) + "' "						+ CRLF 
cQryXC5 += " 	AND XC5_NSU > ' ' "														+ CRLF
cQryXC5 += " 	AND NOT EXISTS(SELECT ZE6.R_E_C_N_O_ FROM ZE6010 ZE6 WHERE ZE6.D_E_L_E_T_ <> '*' "  + CRLF
cQryXC5 += " 	                                                     AND XC5.XC5_NSU = ZE6.ZE6_NSU ) " + CRLF
cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
cQryXC5 += " ORDER BY XC5_IDECOM"														+ CRLF

tcQuery cQryXC5 new Alias "QRYXC5T"

_ntot := 0
_nni := 1

If QRYXC5T->( EOF() )

	U_MFCONOUT("Não foram localizados pedidos órfãos")
	QRYXC5T->(Dbclosearea())
	Return

Else

	U_MFCONOUT("Contando pedidos órfãos...")

	Do while !QRYXC5T->( EOF() )

		_ntot++
		QRYXC5T->( Dbskip() )

	Enddo

	QRYXC5T->(Dbgotop())

Endif


//Cria ZE6 para pedidos órfãos
Do while !QRYXC5T->( EOF() )

	XC5->(Dbgoto(QRYXC5T->XC5RECNO))

	U_MFCONOUT("Criando ZE6 para pedido órfão " + ALLTRIM(XC5->XC5_IDECOM) + " - " + strzero(_nni,6) +  " de " + strzero(_ntot,6) + "...")

	cQryZE6 := "SELECT R_E_C_N_O_ REC "											+ CRLF
	cQryZE6 += " FROM " + retSQLName("ZE6") + " ZE6"							+ CRLF	
	cQryZE6 += " WHERE"															+ CRLF
	cQryZE6 += " 		ZE6.ZE6_NSU		=	'" + alltrim(XC5->XC5_NSU)	+ "'"	+ CRLF
	cQryZE6 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")			+ "'"	+ CRLF
	cQryZE6 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQryZE6 New Alias "QRYZE6"

	if QRYZE6->(EOF())
	
		SA1->(Dbsetorder(15)) //A1_ZCDECOM

		if (SA1->(Dbseek(alltrim(XC5->XC5_CLIENT))))

			RecLock("ZE6",.T.)
			ZE6->ZE6_FILIAL		:= XC5->XC5_FILIAL
			ZE6->ZE6_STATUS		:= "0"		// 0-Caução / 1-Título Gerado / 2-Título Baixado / 3-Erro
			ZE6->ZE6_PEDIDO     := XC5->XC5_PVPROT
			ZE6->ZE6_CLIENT		:= SA1->A1_COD
			ZE6->ZE6_LOJACL		:= SA1->A1_LOJA
			ZE6->ZE6_CNPJ		:= SA1->A1_CGC
			ZE6->ZE6_NOMECL		:= SA1->A1_NOME
			ZE6->ZE6_NSU		:= XC5->XC5_NSU
			ZE6->ZE6_IDTRAN		:= XC5->XC5_PAYMID
			ZE6->ZE6_DTINCL		:= date()
			ZE6->ZE6_VALCAU		:= ( XC5->XC5_VALCAU / 100 ) // Valor vem em centavos -  convertido para reais
			ZE6->ZE6_CODADM		:= '001'
			ZE6->ZE6_DESADM		:= 'MASTERCARD A VISTA'            
			ZE6->ZE6_OBS		:= "Caucao criada a partir do pedido OCC na rotina de acerto posterior " + ALLTRIM(XC5->XC5_IDECOM)
			
			//Verifica se já tem nota fiscal
			SD2->(Dbsetorder(8)) //D2_FILIAL+D2_PEDIDO
			SE1->(Dbsetorder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA
			ZEC->(Dbsetorder(1)) //ZEC_FILIAL+ZEC_COD

			If SD2->(Dbseek(XC5->XC5_FILIAL+XC5->XC5_PVPROT));
				 .AND. SE1->(Dbseek(SD2->D2_FILIAL+SD2->D2_SERIE+SD2->D2_DOC))
	
				ZE6->ZE6_STATUS	=	'1'
				ZE6->ZE6_NOTA	=	SD2->D2_DOC											
				ZE6->ZE6_SERIE	=	SD2->D2_SERIE											
				ZE6->ZE6_DTNOTA	=	SD2->D2_EMISSAO										
				ZE6->ZE6_VALEFE	=	SE1->E1_VALOR - (SE1->E1_VALOR/100*1.75)											
				ZE6->ZE6_VALREA	=	SE1->E1_VALOR									
				ZE6->ZE6_VENCTO	=	SD2->D2_EMISSAO+30						
				ZE6->ZE6_VENCRE	=	dataValida( SD2->D2_EMISSAO+30, .T. ) 	
				ZE6->ZE6_OBS		=	'Título Gerado'															
				ZE6->ZE6_PREFIX	=	SE1->E1_PREFIXO											
				ZE6->ZE6_TITULO	=	SE1->E1_NUM												
				ZE6->ZE6_PARCEL	=	SE1->E1_PARCELA											
				ZE6->ZE6_TIPO	=	'CC'

			Endif	

			ZE6->(MsUnLock())

		Endif

	Endif

	QRYZE6->(Dbclosearea())

	U_MFCONOUT("Gravou ZE6 para pedido órfão " + ALLTRIM(XC5->XC5_IDECOM) + " - " + strzero(_nni,6) +  " de " + strzero(_ntot,6) + "...")

	_nni++

	QRYXC5T->( Dbskip() )

Enddo

QRYXC5T->(Dbclosearea())

Return


/*/{Protheus.doc} MGFFATA4F
Verifica e corrige itens faturados da tabela ZE6010
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/

static function MGFFATA4F() 

_ndias := getmv("MGFFATA4V",,60)

U_MFCONOUT("Carregando nota órfãs...")

//Seleciona ZE6 dos ultimos 60 dias que tem SD2 mas não estão com faturamento marcado
cQryXC5 := "select ZE6.R_E_C_N_O_ RECNO"												+ CRLF
cQryXC5 += " FROM "			+ retSQLName("ZE6") + " ZE6"								+ CRLF
cQryXC5 += " WHERE"																		+ CRLF
cQryXC5 += " 	ZE6_STATUS <> '5' AND ZE6_STATUS <> '3'"								+ CRLF  
cQryXC5 += " 	AND	ZE6_DTINCL >= '" + DTOS(DATE()-_ndias) + "' "						+ CRLF 
cQryXC5 += " 	AND ZE6_NOTA = ' ' "														+ CRLF
cQryXC5 += " 	AND EXISTS(SELECT R_E_C_N_O_ FROM SD2010 SD2 WHERE D2_FILIAL = ZE6_FILIAL AND D2_PEDIDO = ZE6_PEDIDO "  + CRLF
cQryXC5 += " 	                                                     AND SD2.D_E_L_E_T_ <> '*' ) " + CRLF
cQryXC5 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"											+ CRLF

tcQuery cQryXC5 new Alias "QRYXC5T"

_ntot := 0
_nni := 1

If QRYXC5T->( EOF() )

	U_MFCONOUT("Não foram localizados notas órfãs")
	QRYXC5T->(Dbclosearea())
	Return

Else

	U_MFCONOUT("Contando notas órfãs...")

	Do while !QRYXC5T->( EOF() )

		_ntot++
		QRYXC5T->( Dbskip() )

	Enddo

	QRYXC5T->(Dbgotop())

Endif


//marca ZE6 que já estão com faturamento
Do while !QRYXC5T->( EOF() )

	ZE6->(Dbgoto(QRYXC5T->RECNO))

	U_MFCONOUT("Marcando ZE6 para nota órfã " + ALLTRIM(ZE6->ZE6_FILIAL) + " - " + ALLTRIM(ZE6->ZE6_PEDIDO) + " - " + strzero(_nni,6) +  " de " + strzero(_ntot,6) + "...")

	SD2->(Dbsetorder(8)) //D2_FILIAL+D2_PEDIDO
	SF2->(Dbsetorder(1)) //F2_FILIAL+F2_DOC)
	SE1->(Dbsetorder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM

	if (SD2->(Dbseek(ZE6->ZE6_FILIAL+ZE6->ZE6_PEDIDO)) .AND. SF2->(Dbseek(SD2->D2_FILIAL+SD2->D2_DOC));
											 .AND.  SE1->(Dbseek(SD2->D2_FILIAL+SD2->D2_SERIE+SD2->D2_DOC)) )

		Reclock("ZE6",.F.)
		ZE6->ZE6_STATUS	=	'1'
		ZE6->ZE6_NOTA	=	SD2->D2_DOC											
		ZE6->ZE6_SERIE	=	SD2->D2_SERIE											
		ZE6->ZE6_DTNOTA	=	SD2->D2_EMISSAO										
		ZE6->ZE6_VALEFE	=	SE1->E1_VALOR - (SE1->E1_VALOR/100*1.75)											
		ZE6->ZE6_VALREA	=	SE1->E1_VALOR									
		ZE6->ZE6_VENCTO	=	SD2->D2_EMISSAO+30						
		ZE6->ZE6_VENCRE	=	dataValida( SD2->D2_EMISSAO+30, .T. ) 	
		ZE6->ZE6_OBS		=	'Título Gerado'															
		ZE6->ZE6_PREFIX	=	SE1->E1_PREFIXO											
		ZE6->ZE6_TITULO	=	SE1->E1_NUM												
		ZE6->ZE6_PARCEL	=	SE1->E1_PARCELA											
		ZE6->ZE6_TIPO	=	'CC'

		ZE6->(MsUnLock())

		Reclock("SE1",.F.)
		SE1->E1_ZNSU	:= ALLTRIM(ZE6->ZE6_NSU)
		SE1->(Msunlock())

	Endif

	U_MFCONOUT("Gravou ZE6 para pedido órfão " + ALLTRIM(XC5->XC5_IDECOM) + " - " + strzero(_nni,6) +  " de " + strzero(_ntot,6) + "...")

	_nni++

	QRYXC5T->( Dbskip() )

Enddo

QRYXC5T->(Dbclosearea())

Return

