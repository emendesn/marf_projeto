#include "totvs.ch"
#include "RWMAKE.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC49	
Integração Protheus-ME, consulta ao estoque Requisicao
@type function

@author Anderson Reis
@since 26/02/2020
@version P12
@history Alteração 19/03 - Retirada da TAG OBSCLI 
/*/



User function MGFWSC49()

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	conout('[MGFWSC49] Iniciada Threads Requisicao - ' + dToC(dDataBase) + " - " + time())

	RUNINTEG49()

	RESET ENVIRONMENT
Return



static function RUNINTEG49()

	local cURLInteg		:= GETMV("MGF_WSC49")
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
	Local cNumPed := " "

	local cRetu 	:= " "//M->C1_PRODUTO  // verificar conteudo
	local cProd 	:= " "//M->C1_PRODUTO  // verificar conteudo
	local cQuery 	:= ""
	local nDias 	:=	GetMv("MGF_TRVEST") 
	local cFilblq 	:=	GetMv("MGF_FLBLQ") 
	Local nItens    := 0  // variável para puxar itenspendentes
	Local aretorno  := {} // Array para o retorno dos itens
	Local cStatus   := " "
	Local cStClas   := " "
	Local cclas     := .f.
	Local CMSG      := " "


	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	//Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile := .T.
	private aLog := {}
	Private cvar := " "



	aadd( aHeadStr, 'Content-Type: application/json')
	conout("	* URL..........................: " + cURLInteg								  )

	cTimeIni	:= time()
	cHeaderRet	:= ""

	//cURLUse := cURLInteg + allTrim( cCustomer )

	cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime(cTimeIni, cTimeFin)

	nStatuHttp := 0
	nStatuHttp := httpGetStatus()
	Conout("** Integração Requisicao *** ")
	If len(cHttpRet) = 6 
		conout("Nao há requisições ..."+ cTimeIni)
		Return
	Endif

	If nStatuHttp >= 200 .and. nStatuHttp <= 299

		conout("	* Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout("	* Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		  )

		jCustomer := nil
		if fwJsonDeserialize( cHttpRet, @jCustomer )
			cJsonRet := cHttpRet

			For X := 1 to Len(JCUSTOMER:ITEN:ITENSREQUISICAO)  
				conout(JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO)
				// Para buscar a Empresa e Filial
				For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

					cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG
					//cEmpant := SUBSTR(JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG,1,2)
					cEmpant := JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN:BORGS)  + 1
				Next N

				// Verificação estoque
				/////////////////////////////////////////////////////////////////////////////

				// Anderson . Verificar a filial que esta vindo 
				IF cfilant $ cFilblq //"010041|010045|020003"

					cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU), "
					cQuery += " (SELECT MAX(D1_DTDIGIT) FROM " + RetSqlName("SD1") + " WHERE D1_COD=B2_COD AND D1_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD1, "
					cQuery += " (SELECT MAX(D2_EMISSAO) FROM " + RetSqlName("SD2") + " WHERE D2_COD=B2_COD AND D2_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD2, "
					cQuery += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
					cQuery += " AND D3_CF IN ('RE1','RE5','RE0') ) AS DT_SD3 "
					cQuery += " From " + RetSqlName("SB2") + " "
					cQuery += " WHERE B2_QATU<>0 AND B2_COD='"+JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO+"' AND B2_FILIAL='"+cfilant+"' "	
					cQuery += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
				ELSE	         
					cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU), "
					cQuery += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
					cQuery += " AND D3_CF IN ('RE1','RE5','RE0') ) AS DT_SD3 "
					cQuery += " From " + RetSqlName("SB2") + " "
					cQuery += " WHERE B2_QATU<>0 AND B2_COD='"+JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO+"' AND B2_FILIAL='"+cfilant+"' "	
					cQuery += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
				ENDIF	

				If Select("TEMP1") > 0
					TEMP1->(dbCloseArea())
				EndIf
				cQuery  := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
				
				dbSelectArea("TEMP1")    
				TEMP1->(dbGoTop())

				cNum := 0
				cNumd1 := 0
				cNumd2 := 0
				cNumd3 := 0

				While TEMP1->(!Eof())

					// Anderson . Verificar a filial que esta vindo 0781171
					IF cFilAnt $ cFilblq //"010041|010045|020003"
						If !empty(TEMP1->DT_SD1)

							cNumd1 := ddatabase - Ctod(Substr(TEMP1->DT_SD1,7,2)+"/"+Substr(TEMP1->DT_SD1,5,2)+"/"+Substr(TEMP1->DT_SD1,1,4))
						Endif
						If !empty(TEMP1->DT_SD2)

							cNumd2 := ddatabase - Ctod(Substr(TEMP1->DT_SD2,7,2)+"/"+Substr(TEMP1->DT_SD2,5,2)+"/"+Substr(TEMP1->DT_SD2,1,4))

						Endif
						If !empty(TEMP1->DT_SD3)

							cNumd3 := ddatabase - Ctod(Substr(TEMP1->DT_SD3,7,2)+"/"+Substr(TEMP1->DT_SD3,5,2)+"/"+Substr(TEMP1->DT_SD3,1,4))
						Endif


						//compara os numeros

						cNum := cNumd1

						if cNumd2 < cNumd1
							cNum := cNumd2
						endif

						if cNumd3 < cNumd2
							cNum := cNumd3
						endif


					ELSE
						If !empty(TEMP1->DT_SD3)

							cNumd3 := ddatabase - Ctod(Substr(TEMP1->DT_SD3,7,2)+"/"+Substr(TEMP1->DT_SD3,5,2)+"/"+Substr(TEMP1->DT_SD3,1,4))
						Endif

						//compara os numeros

						cNum := cNumd3

					ENDIF

					//faz o tratamento para bloquear
					if cNum > nDias
						conout("Produto nesta filial não movimentado a mais de 90 dias, solicitação recusada. ")
						cRetu := " "
						
					Endif

					TEMP1->(dbSKIP())
				EndDo


				IF	cNum < nDias        
					// tratamento para localizar o produto em outras filiais
					cQueryn :=" "
					IF cfilant $ cFilblq //"010041|010045|020003"
						cQueryn =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU) as SALDO, "
						cQueryn += " (SELECT MAX(D1_DTDIGIT) FROM " + RetSqlName("SD1") + " WHERE D1_COD=B2_COD AND D1_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD1, "
						cQueryn += " (SELECT MAX(D2_EMISSAO) FROM " + RetSqlName("SD2") + " WHERE D2_COD=B2_COD AND D2_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD2, "
						cQueryn += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
						cQueryn += " AND D3_CF IN ('RE1','RE5','RE0')) AS DT_SD3 "
						cQueryn += " From " + RetSqlName("SB2") + " "
						cQueryn += " WHERE B2_QATU<>0 AND B2_COD='"+JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO+"' AND B2_FILIAL NOT IN ('"+cFilblq+"' ) " //010041','010045','020003') "	
						cQueryn += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
					else
						cQueryn =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU) as SALDO, "
						cQueryn += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
						cQueryn += " AND D3_CF IN ('RE1','RE5','RE0')) AS DT_SD3 "
						cQueryn += " From " + RetSqlName("SB2") + " "
						cQueryn += " WHERE B2_QATU<>0 AND B2_COD='"+JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO+"' AND B2_FILIAL<>'"+cFilAnt+"' "	
						cQueryn += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD ORDER BY B2_FILIAL"
					Endif

					If Select("TEMP2") > 0
						TEMP2->(dbCloseArea())
					EndIf
					cQueryn  := ChangeQuery(cQueryn)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryn),"TEMP2",.T.,.F.)
					
					dbSelectArea("TEMP2")    
					TEMP2->(dbGoTop())

					cNumf := 0 
					cNumf1 := 0 
					cNumf2 := 0 
					cNumf3 := 0 
					cFil := "" 
					cMsg := ""
					While TEMP2->(!Eof())

						//aqui verifica se o produto foi comprado entre 90 dias e a seu saldo
						// se saldo <= saldo comprado no periodo não apresentar como disponivel.

						cQuantd1 := 0 

						cQueryx :=" "
						cQueryx =  " SELECT SUM(D1_QUANT) AS QTDED1"
						cQueryx += " FROM " + RetSqlName("SD12") + " " 
						cQueryx += " WHERE D1_DTDIGIT >=  TO_CHAR(SYSDATE-90,'YYYYMMDD') "
						cQueryx += " AND D1_COD='"+TEMP2->B2_COD+"' AND D1_FILIAL='"+TEMP2->B2_FILIAL+"' AND D1_QUANT <> 0 "
						cQueryx += " ORDER BY D1_COD "

						If Select("TEMP3") > 0
							TEMP3->(dbCloseArea())
						EndIf
						cQueryx  := ChangeQuery(cQueryx)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryx),"TEMP3",.T.,.F.)
						
						dbSelectArea("TEMP3")    
						TEMP3->(dbGoTop())

						cQuantd1 := 0 

						While TEMP3->(!Eof())

							cQuantd1 :=  TEMP3->QTDED1

							TEMP3->(dbSKIP())
						EndDo





						IF CQUANTD1 <= TEMP2->SALDO


							IF cFilant $ cFilblq //"010041|010045|020003"
								If !empty(TEMP2->DT_SD1)

									cNumf1 := ddatabase - Ctod(Substr(TEMP2->DT_SD1,7,2)+"/"+Substr(TEMP2->DT_SD1,5,2)+"/"+Substr(TEMP2->DT_SD1,1,4))
								Endif
								If !empty(TEMP2->DT_SD2)

									cNumf2 := ddatabase - Ctod(Substr(TEMP2->DT_SD2,7,2)+"/"+Substr(TEMP2->DT_SD2,5,2)+"/"+Substr(TEMP2->DT_SD2,1,4))

								Endif
								If !empty(TEMP2->DT_SD3)

									cNumf3 := ddatabase - Ctod(Substr(TEMP2->DT_SD3,7,2)+"/"+Substr(TEMP2->DT_SD3,5,2)+"/"+Substr(TEMP2->DT_SD3,1,4))
								Endif

								//compara os numeros
								cNumf := cNumf1

								if cNumf2 < cNumf1
									cNumf := cNumf2
								endif

								if cNumf3 < cNumf2
									cNumf := cNumf3
								endif

							ELSE
								If !empty(TEMP2->DT_SD3)

									cNumf3 := ddatabase - Ctod(Substr(TEMP2->DT_SD3,7,2)+"/"+Substr(TEMP2->DT_SD3,5,2)+"/"+Substr(TEMP2->DT_SD3,1,4))
								Endif
								//compara os numeros
								cNumf := cNumf3

							ENDIF

							//faz o tratamento para bloquear
							if cNumf > nDias

								//cMsg := cMsg+" *** Na Unidade: "+ TEMP2->B2_FILIAL + " existe a Quantidade de : ["+ TRANS(TEMP2->SALDO,"999999") +" em estoque]    " //+ CHR(13+CHR(10))
								cMsg := cMsg + "Unid. "+ TEMP2->B2_FILIAL + " Qtd. ["+ TRANS(TEMP2->SALDO,'999999') +"] </br>   " //+ CHR(13+CHR(10))

							Endif

						ENDIF         


						TEMP2->(dbSKIP())
					EndDo


					if ! empty(cMsg)
						conout("Produto disponível sem movimentação nas seguintes filiais => "+cMsg)
						
					Endif

					

				Endif
				conout(cMsg)
				// Verificar aqui o Status se algum está errado a classe de valor
				if cStatus <> "108"
					For t := 1 to len (JCUSTOMER:ITEN:ITENSREQUISICAO)

						If ! Empty(JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:ValorAtributo) ;
						.and. JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:NomeAtributo == "Classe" 
							conout ("atribit - "+JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:ValorAtributo)
							cStClas := POSICIONE("CTH",1,Space(6)+Alltrim(JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:ValorAtributo),"CTH_CLVL")
							conout("valida atribit "+cStClas)
							If Empty(cStClas)
								conout("nao passa mais ")
								cClas := .t.
								cStatus := "108"
								t := len (JCUSTOMER:ITEN:ITENSREQUISICAO)
							Endif

						Endif

					Next t

					If ! cClas

						//If ! Empty(cMsg)
						cStatus := "1"

						//Else
						//cStatus := "108"
						//Endif

						//Else
						//cStatus := "108"
					Endif
				endif
				conout ("indo so St "+cStatus)

				////////////////////////////////////////////////////////////////////////////
				// Verificação Fim Estoque
				If Empty(cMsg)
					cMsg := "CONSULTA DE ESTOQUE PROTHEUS </br> REALIZADA SEM ESTOQUE "
				Endif
				// Em Negrito
				cMsg := " <p><strong>"+ cMsg +  "</strong></p>"
				//cMsg := ' <p style="color:red;"><strong>  ' + cMsg + ' </strong></p> '



				AAdd(aRetorno,{JCUSTOMER:ITEN:ITENSREQUISICAO[X]:NUMEROITEM , JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO , Val(JCUSTOMER:ITEN:ITENSREQUISICAO[X]:QUANTIDADE) , cMsg , JCUSTOMER:ITEN:ITENSREQUISICAO[X]:Atributos[1]:ValorAtributo })



				Reclock("ZF1",.T.)

				ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
				ZF1->ZF1_FILIAL :=	cFilant
				ZF1->ZF1_INTERF	:=	"R1"
				ZF1->ZF1_DATA	:=	dDataBase  
				ZF1->ZF1_PREPED	:=	" "
				ZF1->ZF1_PEDIDO	:=	JCUSTOMER:ITEN:ITENSREQUISICAO[X]:NUMEROITEM 
				ZF1->ZF1_METODO	:=	"GET"
				ZF1->ZF1_NOTA	:=	JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO 
				ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
				ZF1->ZF1_ERRO	:=	"OK"
				ZF1->ZF1_JSON	:=	cMsg
				ZF1->ZF1_HORA	:=	Time()
				ZF1->ZF1_TOKEN	:=	" "


				Msunlock () 


			next x


			conout ("acesso status REQUISICAO")

			// Acesso a Interface StatusPrePedido
			cUrl 		:= GetMv("MGF_WSC49A")
			cHeadRet 	:= ""
			aHeadOut	:= {}
			cJson		:= ""
			oJson		:= Nil

			cTimeIni	:= ""
			cTimeProc	:= ""

			xPostRet	:= Nil
			nStatuHttp	:= 0
			nTimeOut    := 240

			aadd( aHeadOut, 'Content-Type: application/json' )

			oJson						  := JsonObject():new()
			cjson := " "

			cjson +='   {                                  '
			cjson +='  	"MSGREQUISICAO": {                 '
			cjson +='	"REQUISICAO": "' + JCUSTOMER:ITEN:REQUISICAO + '"           ,'
			cjson +='	"TAGREQUISITANTE": "' + JCUSTOMER:ITEN:TAGREQUISITANTE + '"            ,'
			//cjson +='	"VERIFICADO_ESTOQUE": "SIM"            ,'
			// aqui sempre será um mesmo 
			If cStatus == "1"
				cjson +='	"STATUS": "0"                  ,'//ESTAVA 1 09_01_2020
			Else
				cjson +='	"STATUS": "108"                  ,'//ESTAVA 1 09_01_2020
			EndIf
			cjson +='	"ALTERACAO": "T"                  ,'

			// Verificado estoque
			cjson +=' "Atributos" :[{        '

			cjson +=' "NomeAtributo": "VERIFICADO_ESTOQUE"         ,'

			If cStatus == "1"
				cjson +=' "ValorAtributo": "Sim"         '
			Else
				cjson +=' "ValorAtributo": "Não"         '
			Endif

			cjson +=' }],        '
			// Fim Verificado Estoque 		


			cjson +='	"ITENSREQUISICAO": [              '

			For b:=1 to len(aRetorno)

				If b > 1 
					cjson += ' ,{  '
				Else
					cjson += ' {   '
				Endif

				cjson +='	"NUMEROITEM": "'     + aRetorno[b,1]       + '"    ,'
				cjson +='	"CODIGO_PRODUTO": "' + aRetorno[b,2]       + '"    ,'
				cjson +='	"QUANTIDADE": "'     + STR(aRetorno[b,3])  + '"    ,'
								
				//cjson +='	"Observação_ERP": "' + cMsg + '"                           ,'
				conout("mensagem -> "+cMsg)
				cjson +='	"ALTERACAO": "T"                 ,'

				// CLASSE DE VALOR
				cjson += '	"Atributos":[{  '
				cjson += ' "NomeAtributo": "Classe"  ,'
				if ! Empty(aRetorno[b,5])
					If ! Empty(POSICIONE("CTH",1,space(6)+Alltrim(aRetorno[b,5]),"CTH_CLVL"))
						cjson += ' "ValorAtributo": "' + POSICIONE("CTH",1,space(6)+Alltrim(aRetorno[b,5]),"CTH_CLVL")   + '"   },'
					Else
						cjson += ' "ValorAtributo": "00000000 "   },'
					Endif
				Else
					cjson += ' "ValorAtributo": " " },'
				Endif

				// Observação ERP 
				cjson += ' { "NomeAtributo": "Observação_ERP"  ,'

				If ! Empty(POSICIONE("CTH",1,space(6)+Alltrim(aRetorno[b,5]),"CTH_CLVL")) 
					cjson +='	"ValorAtributo": "' + aRetorno[b,4]   + '"                          }]} '
				Else
					
					cjson +='	"ValorAtributo": "CLASSE DE VALOR INEXISTENTE - > ' + aRetorno[b,5] + ' "   }]}'
				Endif

				// Fim Observação 

			Next b



			cjson +='	],                               '

			cjson +='	"BORGS": [{                        '
			cjson +='	"CAMPOVENT" :"EMPRESA"              ,'
			cjson +='	"CODIGOBORG" :"' + cEmpant + '"   }, '

			cjson +='   {"CAMPOVENT" :"FILIAL"            , '
			cjson +='	"CODIGOBORG" :"' + cFilant + '"   } '

			cjson +='	]}}                               '
			conout("memo "+cjson)
			
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

			else
				conout("dif 200" +xPostRet)


				// Retentativas pois deu erro 

				For l := 1 To 5

					If !Empty( cJson )
						conout ('Retentativa ...  ')
						xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )


						nStatuHttp	:= 0
						nStatuHttp	:= httpGetStatus()
						If AllTrim( str(nStatuHttp)) = '200'
							l := 5
						Endif

					Endif
				Next l


			Endif





			freeObj( oJson )

			// Envio Toquen


			cUrl 		:= GETMV("MGF_WSC44B")+Alltrim(JCUSTOMER:TOKEN)

			cHeadRet 	:= ""
			aHeadOut	:= {}

			cTimeIni	:= ""
			cTimeProc	:= ""

			xPostRet	:= Nil

			nTimeOut    := 240

			//aadd( aHeadOut, 'Content-Type: application/json' )
			aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

			//aadd( aHeadOut, 'Authorization: YaMGgAWngu9ve0NlERINow==')
			aadd( aHeadOut, 'Authorization: "' + Alltrim(JCUSTOMER:TOKEN) + '" ')
			aadd( aHeadOut, 'Accept: application/json')

			xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
			conout("VALE -toqken" +xPostRet)


			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()
			conout("st_toqken" +xPostRet)
			cTimeFin	:= time()
			//cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			If AllTrim( str( nStatuHttp ) ) = '200'
				conout("status-token")

			else
				conout("dif 200-toqken" +xPostRet)


				For l := 1 To 5

					If !Empty( cJson )
						conout ('Retentativa token ...  ')
						xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)


						nStatuHttp	:= 0
						nStatuHttp	:= httpGetStatus()
						If AllTrim( str(nStatuHttp)) = '200'
							l := 5
						Endif

					Endif
				Next l


			Endif


			// ***********fim token******************************************************************************
			// Para buscar todos os itens pendentes
			nitens := JCUSTOMER:ITENPENDENTES

		endif


	Else
		conout ("Outro erro fora o 200 "+Str(nStatuHttp))
	endif

return


