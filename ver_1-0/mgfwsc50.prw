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

	//RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	conout('[MGFWSC38] Iniciada Threads para a empresa - 01 - ' + dToC(dDataBase) + " - " + time())

	RUNMGF50()

	RESET ENVIRONMENT
return


static function RUNMGF50()

	local cURLInteg		:= " "//Alltrim(GetMv("MGF_MEPEDS"))//"https://spdwvapl203:8059/api/mensagemPedido"
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
	

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	//Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile := .T.
	private aLog := {}
	Private cvar := " "

	//--------------| Verifica existencia de parametros e caso nao exista cria. |-------------------------

	cURLInteg := Alltrim(GetMv("MGF_WSC50")) 


	aadd( aHeadStr, 'Content-Type: application/json')

	cTimeIni	:= time()
	cHeaderRet	:= ""
		
	cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime(cTimeIni, cTimeFin)

	nStatuHttp := 0
	nStatuHttp := httpGetStatus()

	If len(cHttpRet) = 6 
		conout("Zero Cancelamentos ...")
		Return
	Endif

	If nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCustomer := nil
		if fwJsonDeserialize( cHttpRet, @jCustomer )
			cJsonRet := cHttpRet

			// Para buscar a Empresa e Filial
			For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

				cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG // retirado n + 1
				cEmpant := SUBSTR(JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG,1,2) //01
				n := Len(JCUSTOMER:ITEN:BORGS)  + 1
			Next
			CONOUT('FILIAL'+cfilant)


			For X := 1 to 1//Len(JCUSTOMER:ITEN)  // itens
				conout(JCUSTOMER:ITEN:IDENTIFIC )

				dbSelectArea("SC7")
				SC7->(dbSetOrder(3))

				If SC7->(dbSeek(cfilant +  JCUSTOMER:ITEN:FORNECEDORCLIENTE + JCUSTOMER:ITEN:IDENTIFIC ))


				Else

				Endif


				aadd(aCabec,{"C7_FILIAL"     , SC7->C7_FILIAL })
				aadd(aCabec,{"C7_NUM"        , SC7->C7_NUM })
				aadd(aCabec,{"C7_EMISSAO"    , SC7->C7_EMISSAO })
				aadd(aCabec,{"C7_FORNECE"    , Substring(JCUSTOMER:ITEN:FORNECEDORCLIENTE,1,6) }) // 
				aadd(aCabec,{"C7_LOJA"       , Substring(JCUSTOMER:ITEN:FORNECEDORCLIENTE,7,2) })
				aadd(aCabec,{"C7_FILENT"     ,  SC7->C7_FILENT })
				conout('pEDIDO'+SC7->C7_NUM)			

				For nX := 1 To Len(JCUSTOMER:ITEN:ITENS)

					//If JCUSTOMER:ITEN:ITENS[NX]:CANCELADO = 'S'

					aLinha := {}

					If  JCUSTOMER:ITEN:ITENS[NX]:CANCELADO == 'S'

						aadd(aLinha,{"LINPOS","C7_ITEM+C7_PRODUTO",PADL(JCUSTOMER:ITEN:ITENS[NX]:NUMEROITEM,4,"0"),JCUSTOMER:ITEN:ITENS[NX]:CODIGO_PRODUTO })
						aadd(aLinha,{"AUTDELETA" ,"S"})
						
						aadd(aLinha,{"AUTDELETA" ,"N" , Nil})
						CONOUT('PRODUTO  CANCELANDO'+JCUSTOMER:ITEN:ITENS[NX]:CODIGO_PRODUTO)
						aadd(aLinha,{"C7_PRODUTO"   , JCUSTOMER:ITEN:ITENS[NX]:CODIGO_PRODUTO       , Nil })//JCUSTOMER:ITENS[X]:itens:itemprepedido:codigo_produto
						aadd(aLinha,{"C7_REC_WT"   ,  SC7->( RECNO())      , Nil })
						aadd(aLinha,{"C7_RESIDUO" ,"S" ,Nil})
						aadd(aLinha,{"C7_ENCER" ,"E" ,Nil})


						aadd(aItens,aLinha)



					ENDIF
				Next nX 

				AutoGrLog("")


				aLog := {}
				lMSErroAuto := .F.
				conout ("exclui .... ")
				MATA120(1,aCabec,aItens,5)
				conout ("exclu")
				
				IF ! lMSErroAuto

					alert("excluido com sucesso! ") 

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"PD"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"GET"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	Alltrim(xPostRet)
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	" "


					Msunlock () 



				ENDIF
				If  lMsErroAuto

					AutoGrLog("ERRO : ")
					aLog := GetAutoGRLog()	

					alert("Erro na exclusao!")

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"PD"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"GET"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	"ERRO INCLUSAO"
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	" "


					Msunlock () 



				EndIf	


				aItens := {}
				aCabec := {}


				// Acesso a Interface StatusPrePedido
				cUrl 		:= Alltrim(GetMv("MGF_WSC50A"))
				cHeadRet 	:= ""
				aHeadOut	:= {}
				cJson		:= ""
				oJson		:= Nil

				cTimeIni	:= ""
				cTimeProc	:= ""

				xPostRet	:= Nil
				nStatuHttp	:= 0
				nTimeOut    := 120

				aadd( aHeadOut, 'Content-Type: application/json' )

				oJson						  := JsonObject():new()
				cjson := " "

				cjson +='   {                                                   '
				cjson +='  	"MSGSTATUSPEDIDO": {                             '

				cjson  +='	"IDENTIFIC":  "' + JCUSTOMER:ITEN:IDENTIFIC + '"            ,'

				cjson  +='	"PREPEDIDO":"' + JCUSTOMER:ITEN:PREPEDIDO   + '"       ,'
				cjson  +='	"PEDIDO":"' + JCUSTOMER:ITEN:PEDIDO   + '"       ,'

				If !lMsErroAuto 
					cjson  +='	"STATUS":    1                                    ,' 

				Else
					cjson  +='	"STATUS":    3                                  ,'
				Endif

				cjson +='	"FORNECEDORCLIENTE":"' + Substr(JCUSTOMER:ITEN:FORNECEDORCLIENTE,1,6) + Substr(JCUSTOMER:ITEN:FORNECEDORCLIENTE,7,2)   +'"                             ,'

				If Len(aLog) > 0


					For t:=1 to Len(aLog)

						cvar += alltrim(STRTRAN(alog[t],Chr(13)+Chr(10),"")) + "**"


					Next t

					cjson +=' "OBSERP":  "' + Alltrim(cvar) + '" '

				Elseif Len(aLog) = 0 

					cjson +=' "OBSERP":" " '

				Else
					cjson +=' "OBSERP":"Pedido ERP Inexistente !!! " '

				Endif



				cjson +='			}}                                    '

				oJson:fromJson(cjson )

				cTimeIni := time()

				if !empty( cJson )
					xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
				endif

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()

				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )

				If AllTrim( str( nStatuHttp ) ) = '200'
					conout("status")

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"SP"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"POST"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	"ENVIO STATUS"
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	" "


					Msunlock () 


				else
					CONOUT("dif 200"+str( nStatuHttp ))

					// Retentativas pois deu erro 

					For l := 1 To 5

						If !Empty( cJson )
							conout ('Retentativa ...  '+str(l))
							xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
						Endif
						conout ('analise ...  '+str(l))
						nStatuHttp	:= 0
						nStatuHttp	:= httpGetStatus()
						If AllTrim( str(nStatuHttp)) = '200'
							l := 5
						Endif
					Next l
					// Fim Retentativas

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"SP"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"POST"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	"ERRO STATUS"
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	" "


					Msunlock () 




				Endif
				freeObj( oJson )

				// Fim Acesso a Interface StatusPrePedido


				// Envio Toquen

				cUrl 		:= GETMV("MGF_WSC44B")+Alltrim(JCUSTOMER:TOKEN)

				cHeadRet 	:= ""
				aHeadOut	:= {}

				cTimeIni	:= ""
				cTimeProc	:= ""

				xPostRet	:= Nil

				nTimeOut    := 240

				aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

				aadd( aHeadOut, 'Authorization: "' + Alltrim(JCUSTOMER:TOKEN) + '" ')
				aadd( aHeadOut, 'Accept: application/json')

				xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
				alert("VALE -toqken" +xPostRet)

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()
				conout("st_toqken" +xPostRet)
				cTimeFin	:= time()

				If AllTrim( str( nStatuHttp ) ) = '200'
					alert("status-token")

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"K1"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"POST"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	"TOKEN SUCESSO"
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	Alltrim(JCUSTOMER:TOKEN)


					Msunlock () 


				else
					alert("dif 200-toqken" +xPostRet)


					// Retentativas pois deu erro 

					For l := 1 To 5

						conout ('Retentativa token ...  '+str(l))
						xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)

						nStatuHttp	:= 0
						nStatuHttp	:= httpGetStatus()
						If AllTrim( str(nStatuHttp)) = '200'
							l := 5
						Endif
					Next l
					// Fim Retentativas

					Reclock("ZF1",.T.)

					ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
					ZF1->ZF1_FILIAL :=	cfilant
					ZF1->ZF1_INTERF	:=	"K1"
					ZF1->ZF1_DATA	:=	dDataBase  
					ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN:PREPEDIDO
					ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:IDENTIFIC
					ZF1->ZF1_METODO	:=	"POST"
					ZF1->ZF1_NOTA	:=	" "  
					ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
					ZF1->ZF1_ERRO	:=	"TOKEN ERRO"
					ZF1->ZF1_JSON	:=	cJsonRet
					ZF1->ZF1_HORA	:=	time()
					ZF1->ZF1_TOKEN	:=	Alltrim(JCUSTOMER:TOKEN)


					Msunlock () 



				Endif

				// ***********fim token******************************************************************************




			next x

		endif


		conout("Nao h� pedidos!")


		//next x
	Else
		conout ("Outro erro fora o 200 "+Str(nStatuHttp))
	endif

return



