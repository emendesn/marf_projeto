#include "totvs.ch"
#include "RWMAKE.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"  

/*/{Protheus.doc} MGFWSC48	 
Integracao Protheus-ME, para Integracao de Pedido de Compra vindo do ME
@type function

@author Anderson Reis 
@since 09/03/2020
@version P12
@history Alteracao 27/03 - Quando nao vier a TAG ICMS sera feito o calculo 
sem o ICMS embutido  . No fonte marcado como 'History 27/03'
@History_2 14/04 - Para que não aceite gerar um pedido no ERP para um prepedido já gerado 
@History_3 14/04 - Colocar no campo C7_OBS do ERP  as informações digitas no cabeçalho do ME 
/*/


User function MGFWSC48()

	//RPCSetType(3) - retirado pois estava com erro 
	

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	conout('[MGFWSC48] Iniciada Threads para a empresa - 01 - ' + dToC(dDataBase) + " - " + time())

	RUNINTEG48()

	RESET ENVIRONMENT
Return

static function RUNINTEG48()

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
	Local cNumPed := " "

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

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	//Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile := .T.
	private aLog  := {}
	Private cvar  := " "
	Private nrats := 0 
	Private crats := 0 

	cURLInteg	 := Alltrim(GetMv("MGF_WSC48")) 

	aadd( aHeadStr, 'Content-Type: application/json')

	cTimeIni	:= time()
	cHeaderRet	:= ""

	cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime(cTimeIni, cTimeFin)

	nStatuHttp := 0
	nStatuHttp := httpGetStatus()

	
	If len(cHttpRet) = 6 
		conout("Zero PrePedidos ...") 

		Return
	Endif
	

	If nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCustomer := nil
		if fwJsonDeserialize( cHttpRet, @jCustomer )
			cJsonRet := cHttpRet

			For X := 1 to 1//Len(JCUSTOMER:ITENS)  // itens
				
				// Para buscar a Empresa e Filial
				If Len(JCUSTOMER:ITEN[X]:BORGS) = 2
					For N := 1 to Len(JCUSTOMER:ITEN[X]:BORGS)

						cfilant := JCUSTOMER:ITEN[X]:BORGS[N+1]:CODIGOBORG
						cEmpant := SUBSTR(JCUSTOMER:ITEN[X]:BORGS[N]:CODIGOBORG,1,2)
						n := Len(JCUSTOMER:ITEN[X]:BORGS)  + 1
					Next
				Else

					For N := 1 to Len(JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:BORGS)
						cCusto  := JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:CENTROCUSTOSCLIENTE
						cfilant := JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:BORGS[N+1]:CODIGOBORG
						cEmpant := SUBSTR(JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:BORGS[N]:CODIGOBORG,1,2)
						n := Len(JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:BORGS)  + 1
					Next N

				Endif
				// Empresa MAtriz Energia e pampenao para que busque o grupo de empresas correto
				If  cEmpant = '03' // Matriz
					cEmpant := "01"
					cfilant := "030001"
				Elseif cEmpant = '02' // Pampeano
					cEmpant := "01"
				Endif

				If AttIsMemberOf( JCUSTOMER:ITEN[X], "IDENTIFIC") 
					If JCUSTOMER:ITEN[X]:IDENTIFIC <> " " .and. JCUSTOMER:ITEN[X]:STATUS =  '107'
						// Verificar esta clausula status 
						
						lAltera := .t.
						noper  := 4
						dbSelectArea("SC7")
						SC7->(dbSetOrder(3))

						If SC7->(dbSeek(cfilant +  JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE + JCUSTOMER:ITEN[X]:IDENTIFIC ))

						Else

						Endif

						aadd(aCabec,{"C7_NUM"    , JCUSTOMER:ITEN[X]:IDENTIFIC })
						aadd(aCabec,{"C7_FILIAL" ,  cfilant}) //JCUSTOMER:ITENS[X]:BORGS[X]:CODIGOBORG + JCUSTOMER:ITENS[X]:BORG_CENTR
						aadd(aCabec,{"C7_EMISSAO"    ,SC7->C7_EMISSAO}) 
					ELSE
						aadd(aCabec,{"C7_EMISSAO"    , dDataBase}) 
						aadd(aCabec,{"C7_FILIAL"    , CFILANT}) 
					Endif
				Else
					CONOUT ("INCLUSAO ..... ")
					aadd(aCabec,{"C7_EMISSAO"    , dDataBase}) 
					aadd(aCabec,{"C7_FILIAL"    , CFILANT}) 
					aadd(aCabec,{"C7_FILENT"    , CFILANT}) 
				Endif


				aadd(aCabec,{"C7_FORNECE"    , Substring(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,1,6) }) // 
				aadd(aCabec,{"C7_LOJA"       , Substring(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,7,2) })
				
				cQryUsr := "SELECT Y1_COD"
				cQryUsr += " FROM SYS_USR USR , SY1010 A"
				cQryUsr += " WHERE"
				cQryUsr += " 		USR.USR_CODIGO	=	'" + lower(Alltrim(JCUSTOMER:ITEN[X]:TAG)) + "'"
				cQryUsr += " 	AND	USR.D_E_L_E_T_	<>	'*' AND USR.USR_MSBLQL <> '1' "
				cQryUsr +=  "   AND A.D_E_L_E_T_ = ' ' AND USR.USR_ID = A.Y1_USER "

				TcQuery cQryUsr New Alias "QRYUSR2"

				If !QRYUSR2->(EOF())
					cRetUSR := allTrim(QRYUSR2->Y1_COD)
				Endif

				QRYUSR2->(DBCloseArea())
				
				If  ! Empty (cRetUsr)
					aadd(aCabec,{"C7_COMPRA"     , cRetUsr })
					CONOUT("COMPRADOR "+cRetUsr)
				Else
					CONOUT("Sem Comprador")
					aadd(aCabec,{"C7_COMPRA"     , " " })
				Endif
							
				

				aadd(aCabec,{"C7_COND"       , JCUSTOMER:ITEN[X]:COND_PAGTO                      }) ////JCUSTOMER:ITEN[X]:COND_PAGTO 
				aadd(aCabec,{"C7_CONTATO"    , "Int. ME"})

				If AttIsMemberOf( JCUSTOMER:ITEN[X], "LOCALENTREGACLIENTE")
					If Empty(JCUSTOMER:ITEN[X]:LOCALENTREGACLIENTE)
						aadd(aCabec,{"C7_FILENT"     , cfilant}) //JCUSTOMER:ITENS[X]:BORGS[X]:CODIGOBORG + JCUSTOMER:ITENS[X]:BORG_CENTRO
					Else
						aadd(aCabec,{"C7_FILENT"     , JCUSTOMER:ITEN[X]:LOCALENTREGACLIENTE}) //JCUSTOMER:ITENS[X]:BORGS[X]:CODIGOBORG + JCUSTOMER:ITENS[X]:BORG_CENTRO
					Endif
				endif

				If AttIsMemberOf( JCUSTOMER:ITEN[X], "VALORFRETE")
					if VALTYPE(JCUSTOMER:ITEN[X]:VALORFRETE) = "N"
						
						aadd(aCabec,{"C7_FRETE"     ,JCUSTOMER:ITEN[X]:VALORFRETE })//C7_VALFRE POR ITEM
					else
						
						aadd(aCabec,{"C7_FRETE"     ,VAL(JCUSTOMER:ITEN[X]:VALORFRETE) })
					endif
				Endif


				If JCUSTOMER:ITEN[X]:MOEDA = 0

					aadd(aCabec,{"C7_MOEDA"     , 1    })
				Else
					aadd(aCabec,{"C7_MOEDA"     , JCUSTOMER:ITEN[X]:MOEDA    })

				Endif

				If AttIsMemberOf( JCUSTOMER:ITEN[X], "FRETE")
					If SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "CIF"
						aadd(aCabec,{"C7_TPFRETE"    , "C"                           })
					ElseIf SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "FOB"
						aadd(aCabec,{"C7_TPFRETE"    , "F"                          })

					ElseIf SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "Por Conta Terceiros"
						aadd(aCabec,{"C7_TPFRETE"    , "T"                           })
					ElseIf SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "Por Conta Remetente"
						aadd(aCabec,{"C7_TPFRETE"    , "R"                        })
					ElseIf SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "Por Conta Destinatario"
						aadd(aCabec,{"C7_TPFRETE"    , "D"                          })
					ElseIf SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)) == "Sem frete"
						aadd(aCabec,{"C7_TPFRETE"    , "S"                        })
					Elseif Empty(SUBSTR(ALLTRIM(JCUSTOMER:ITEN[X]:FRETE),3,LEN(JCUSTOMER:ITEN[X]:FRETE)))
						aadd(aCabec,{"C7_TPFRETE"    , "C"    })
					Endif
				Endif
				// Contrato 
				If AttIsMemberOf( JCUSTOMER:ITEN[X], "CONTRATO")
					If ! Empty(JCUSTOMER:ITEN[X]:CONTRATO)
						aadd(aCabec,{"C7_TIPO"    , "2"    })
					Endif
				eNDIF


				For nX := 1 To Len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO)


					aLinha := {}


					aadd(aLinha,{"C7_PRODUTO"    , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO       , Nil })//JCUSTOMER:ITENS[X]:itens:itemprepedido:codigo_produto
					aadd(aLinha,{"C7_QUANT"      , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)      , Nil })
					cRats := JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CENTROCUSTOCLIENTE

					// HISTORY_3 - campo mensagem C7_OBS

					If AttIsMemberOf( JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1], "OBSERVACAO") 
						For R := 1 to Len(JCUSTOMER:ITEN[X]:RequisicoesPrePedido)
						
							aadd(aLinha,{"C7_OBS"  , JCUSTOMER:ITEN[X]:RequisicoesPrePedido[R]:OBSERVACAO  , Nil })
						
							R := Len(JCUSTOMER:ITEN[X]:RequisicoesPrePedido)  + 1
						Next R
					Endif

					// FIM HISTORY_3

					if  ValType(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO) == 'C' 
						If val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO) > 0

							If AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "ICMS") 
						   		//History 27/03
								If VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS) > 0
									
									aadd(aLinha,{"C7_PRECO"     , Round((VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)  / (VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS) - 100 ) ) * - 100 ,6)  , Nil })
									aadd(aLinha,{"C7_PICM"      , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS)           , Nil })
									aadd(aLinha,{"C7_VALICM"    ,  (Round((VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)  / (VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS) - 100 ) ) * - 100 ,6)  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE) )  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS)  / 100 , Nil })
						   			aadd(aLinha,{"C7_BASEICM"   ,   Round((VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)  / (VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ICMS) - 100 ) ) * - 100 ,6)  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)         , Nil })
								Else   
									
									aadd(aLinha,{"C7_PRECO"     , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)    , Nil })
						   			aadd(aLinha,{"C7_PICM"      ,   0          , Nil })
						   			aadd(aLinha,{"C7_VALICM"    ,   0          , Nil })
						   			aadd(aLinha,{"C7_BASEICM"   ,   0          , Nil })
								Endif
							Else  
								
						   		aadd(aLinha,{"C7_PRECO"     , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)    , Nil })
						   		aadd(aLinha,{"C7_PICM"      ,   0          , Nil })
						   		aadd(aLinha,{"C7_VALICM"    ,   0          , Nil })
						   		aadd(aLinha,{"C7_BASEICM"   ,   0          , Nil })
							Endif
							//Fim History 27/03
							lNprc := .t.
						Endif
					Endif

					If ! lNprc .AND. ValType(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECOLIQUIDO) == 'C' 
						If val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECOLIQUIDO) > 0
							
							aadd(aLinha,{"C7_PRECO"     , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECOLIQUIDO)    , Nil })
							lNprc := .t.
						Endif
					Endif


					If ! lNprc
						conout ("Precos Zerados ou com problemas . Sera Preco = 1 "+JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO)
						aadd(aLinha,{"C7_PRECO"     , 1          , Nil })
					Endif
					lNprc := .f.


					aadd(aLinha,{"C7_ZCODGRD"      , "ZZZZZZZZZZ" , Nil})
					aadd(aLinha,{"C7_ENVGRAD"      , "N" , Nil})
					aadd(aLinha,{"C7_CONAPRO"      , "L" , Nil})
					aadd(aLinha,{"C7_ZPEDME"       , JCUSTOMER:ITEN[X]:PREPEDIDO  , NIL    })

					If AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "UNIDADE")
						aadd(aLinha,{"C7_UM"           , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:UNIDADE, NIL    })
					Endif

					// CLASSE CABECALHO 
					For R := 1 TO Len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS)
						
						If ! Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo) ;
						.AND. JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:NomeAtributo = "Classe"
							conout("Classes - "+JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO  )
							aadd(aLinha,{"C7_CLVL"         , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo , NIL    })//"10100002"

						ElseIF Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo) ;
						.AND. JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:NomeAtributo = "Classe"
							aadd(aLinha,{"C7_CLVL"         , " " , NIL    })//"10100002"
						Endif
					Next R

					If AttIsMemberOf( JCUSTOMER, "IPI")

						If VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI) = 0 .AND.  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:VALORIPI) = 0
							aadd(aLinha,{"C7_IPI"       , 0  , NIL    })
							aadd(aLinha,{"C7_VALIPI"    , 0  , NIL    })
						Elseif VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI) > 0 .AND.  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:VALORIPI) > 0
							aadd(aLinha,{"C7_IPI"       , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI)  , NIL    })
							//aadd(aLinha,{"C7_VALIPI"    , (Round(VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)) *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)) * VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI)  / 100  , NIL    })
							aadd(aLinha,{"C7_VALIPI"    ,  (Round((VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO)) ,6)  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE) )  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI)  / 100 , Nil })
							 
						Endif

					Endif

					If AttIsMemberOf( JCUSTOMER:ITEN[X], "CONTRATO")
						
						aadd(aLinha,{"C7_CONTME"      , JCUSTOMER:ITEN[X]:CONTRATO  , NIL    })
					else
						aadd(aLinha,{"C7_CONTME"      ," "  , NIL    })
					Endif

				 
					for b:= 1 to 1//Len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido)//Len(JCUSTOMER:ITEN[1]:ITEMPREPEDIDO)
						// Rateio
						// Monta Itens Rateio

						If cItem <> PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0")
							//
							cItem := PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0")
							aAdd(aRatCC,{PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0"),{}})
							cont := 1
							aItemcc := {}
							// Primeiro Item do Rateio
							conout("Item"+PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0"))

							aadd(aLinha,{"C7_RATEIO"       , '1'   , Nil      })

							// Preenchimento do Local 

							For d:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS)

								If  JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:NomeAtributo = "ARMAZEM" ;
								.AND. ! Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo)

									aadd(aLinha,{"C7_LOCAL" , Substr(Alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[B]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo),1,2)  , Nil })
									conout("local "+Substr(Alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[B]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo),1,2))

								Endif


							Next d

							// History  Tratamento Embalagens fabiana 

								If LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS) > 0
								
									For w:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS)
 
										aadd(aBkpdt , { cFilant , ;                                                                                                                   // Filial
										                JCUSTOMER:ITEN[X]:PREPEDIDO , ;                                                                                               // Prepedido
														cItem , ;                                                                                                                     // Item
														JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO   , ;                                                                      // Produto
														JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:QUANTIDADE   , ;  // Quantidade
										                SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,1,4) + SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,6,2)+ SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,9,2)  , ;  // Data
										                JCUSTOMER:ITEN[X]:PREPEDIDO   , ;                                                                                             // PREPEDIDO
														JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:REQUISICAO   } )                                                                          // Requisicao
										
									Next W
								
								Else
										aadd(aBkpdt , { cFilant                                                 , ;    // FILIAL
										 			    JCUSTOMER:ITEN[X]:PREPEDIDO                             , ;    // PREPEDIDO
									                    cItem                                                   , ;    // ITEM
														JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO      , ;    // PRODUTO 
														VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)     , ;    // QUANTIDADE
														Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,1,4) + Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,6,2) + Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,9,2)        , ;   // DATA
														JCUSTOMER:ITEN[X]:PREPEDIDO                             , ;	   // PREPEDIDO
														JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:REQUISICAO           })   // REQUISICAO
								Endif


				            // Fim Tratamento Embalagens

							// Preenchimento do Rateio
							// via execauto

							for c:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO)
								conout ("custo"+JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:CENTROCUSTO)


								cigual := PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0") + JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:CENTROCUSTO
								conout("analisando -> "+cigual)
								For h:=1 to len(aRats)//If aratcc[nx][2][c][8][2] + aratcc[nx][2][c][7][2] // itempd + custo
									if arats[h,1] + arats[h,2] == cigual

										conout("analisado -> "+cigual)
										litem := .t.
										h:= len(arats)
									Endif

								Next h


								aAdd(aItemCC,{"CH_FILIAL"		  , cfilant           			, nil})
								aAdd(aItemCC,{"CH_FORNECEDOR"     , Substring(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,1,6)         , NIL})
								aAdd(aItemCC,{"CH_LOJA"           , Substring(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,7,2)         , NIL})
								aAdd(aItemCC,{"CH_ITEM"           , StrZero(cont,Len(SCH->CH_ITEM)) , NIL})
								aAdd(aItemCC,{"CH_PEDIDO"           , JCUSTOMER:ITEN[X]:PREPEDIDO, NIL})
								conout("itemcc"+StrZero(cont,Len(SCH->CH_ITEM)))
								
								aAdd(aItemCC,{"CH_PERC"           , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QUANTIDADE) ;
								/ VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)   ;               
								* 100  , NIL})// JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[1]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QTD_PERC
								nPerc := VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QUANTIDADE)/ ;
								VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)* 100
								
								aAdd(aItemCC,{"CH_CC"             , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:CENTROCUSTO,NIL})
								aAdd(aItemCC,{"CH_ITEMPD"         , PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0")           , NIL})
								
								aAdd(aItemCC,{"CH_ZVALRAT"        , ( nperc ; //VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QTD_PERC)
								* (VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE) ;
								* val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:PRECO))) /100                         , NIL})
								 


								If AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c], "ELEMENTOPEP")
									If ! Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:ELEMENTOPEP)
										aAdd(aItemCC,{"CH_ZFILDES"        , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:ELEMENTOPEP,NIL})
									Else
										aAdd(aItemCC,{"CH_ZFILDES"        , cfilant ,NIL})
									Endif
								Else
									aAdd(aItemCC,{"CH_ZFILDES"        , cfilant ,NIL})
								Endif

								aAdd(aRatCC[nx][2],aItemcc)
								aadd(aBkp, aItemcc )

								litem := .f.
								aItemcc := {}
								cont++
								lrateio := .t.


							Next c


							//Endif
							If ! lrateio
								If Empty(ccusto) 
									
									aadd(aLinha,{"C7_CC"           ,  JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CENTROCUSTOCLIENTE  , Nil      })
								else
									
									aadd(aLinha,{"C7_CC"           ,  cCusto  , Nil      })
								Endif
							endif

							aItemcc := {}
						endif
					Next b	


					aadd(aItens,aLinha)
					conout ("item feito "+str(nx))

				Next nX // 

				AutoGrLog("")


				aLog := {}
				lMSErroAuto := .F.

				// HISTORY_2 - Verificar se existe Pedido de Compra para o PREPEDIDO

				If noper = 3  
				// Verifica se é inclusao e nao tenha o pedido do ERP NA TAG IDENTIFIC
					cQuery := " SELECT C7_ZPEDME "
					cQuery += " FROM "+RetSqlName("SC7")+" SC7 "
					cQuery += " WHERE SC7.C7_ZPEDME = '" + JCUSTOMER:ITEN[x]:PREPEDIDO + "' AND "
					cQuery += " SC7.C7_FILIAL='" + cFilant +"'                            AND "
					cQuery += " SC7.D_E_L_E_T_= ' ' AND SC7.C7_ZPEDME <> ' ' "
 
					TCQuery cQuery New Alias "cAliasSC7"
				
					cpederp := cAliasSC7->C7_ZPEDME
						Count To nRets
						
						If nRets > 0 
							lMsErroAuto  := .t.
						Endif

					dbCloseArea ("cAliasSC7")
					RestArea(aAreabkp)
					conout("verificando se existe prepedido no ERP ... "+str(nrets))
				Endif
				//  FIM HISTORY_2 

				If lrateio  .AND.  nRets = 0 

					MATA120(1,aCabec,aItens,noper,,)
					conout("exec inclui com rateio ")
					conout (sc7->c7_num)


					For h:=1 to len(aBkp)
						// Verificar se nao existe outro registro
						If Empty(posicione("SCH",1,aBkp[h][1][2];
													+SC7->C7_NUM;
													+aBkp[h][2][2];
													+aBkp[h][3][2];
													+aBkp[h][8][2];
													+aBkp[h][4][2],"CH_PEDIDO") )
						
							Reclock("SCH",.T.)
							conout("dados SCH reclock")

								SCH->CH_FILIAL		:= aBkp[h][1][2]
								SCH->CH_FORNECEDOR	:= aBkp[h][2][2]
								SCH->CH_LOJA		:= aBkp[h][3][2]
								SCH->CH_ITEM		:= aBkp[h][4][2]
								SCH->CH_PEDIDO		:= SC7->C7_NUM
								SCH->CH_PERC		:= aBkp[h][6][2]
								SCH->CH_CC			:= aBkp[h][7][2]
								SCH->CH_ITEMPD		:= aBkp[h][8][2]
								SCH->CH_ZVALRAT		:= aBkp[h][9][2]
								SCH->CH_ZFILDES		:= aBkp[h][10][2]

							Msunlock()
						Endif
					Next h


				Elseif ! lrateio  .AND.  nRets = 0
					MSExecAuto({|x,y,w,z,a|MATA120(x,y,w,z,a)},1,aCabec,aItens,noper,.F.)
					conout("exec inclui sem rateio ")
				Endif

				If nOper = 3
					CNumPed := SC7->C7_NUM
				Else
					cnumPed := JCUSTOMER:ITEN[x]:IDENTIFIC
				Endif
				
				If ! lMsErroAuto .AND. nRets = 0
					conout("Incluido com sucesso! ") 

					cQ := "UPDATE "
					cQ += RetSqlName("SC7")+" "
					cQ += "SET "
					cQ += "C7_CONAPRO = 'L' , C7_CC = '"+cRats+ "' , C7_COMPRA = '"+cRetUsr+ "'  "

					If len(aBkp) > 1
						cQ += ", C7_RATEIO = '1'  "
					Endif

					cQ += " WHERE C7_FILIAL  = '" + cFilant  + "'  "
					cQ += " AND  C7_FORNECE  = '" + Substr(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,1,6) + "'  "
					cQ += " AND  C7_LOJA     = '" + Substr(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,7,2)    + "'  "
					cQ += " AND  C7_NUM      = '" + cNumped  + "'  "

					nRet := tcSqlExec(cQ)

					If nRet == 0

					Else
						conout("Problemas na gravacao dos campos do cadastro, para envio ao ME.")

					EndIf 
					/*
					// Grava Informações 
					If nOper = 3 
						For R:=1 to len(aBkpdt)
							// Verificar se nao existe outro registro
										
								Reclock("ZGG",.T.)
								conout("dados inclui ZGG ")

									ZGG->ZGG_FILIAL		:= aBkpDT[R][1]      // Filial
									ZGG->ZGG_PEDIDO  	:= cnumPed       // Pedido
									ZGG->ZGG_ITEM		:= aBkpDT[R][3]      // Item
									ZGG->ZGG_PROD		:= aBkpDT[R][4]      // Produto
									ZGG->ZGG_QUANT		:= val(aBkpDT[R][5]) // Quantidade
									ZGG->ZGG_DTPRF		:= STOD(aBkpDT[R][6] )      // Data
									ZGG->ZGG_PREPED  	:= aBkpDT[R][7]      // Prepedido
									ZGG->ZGG_REQUIS		:= aBkpDT[R][8]       // Requisicao
																
								Msunlock()
						
						Next R
					Else

						DbSelectArea("ZGG")
						IF ZGG->(DbSeek(aBkpDT[R][1] + cnumPed + aBkpDT[R][3]) + aBkpDT[R][4] )

							For R:=1 to len(aBkpdt)
								// Verificar se nao existe outro registro
										
								Reclock("ZGG",.F.)
								conout("dados altera ZGG ")

									ZGG->ZGG_FILIAL		:= aBkpDT[R][1]      // Filial
									ZGG->ZGG_PEDIDO  	:= SC7->C7_NUM       // Pedido
									ZGG->ZGG_ITEM		:= aBkpDT[R][3]      // Item
									ZGG->ZGG_PROD		:= aBkpDT[R][4]      // Produto
									ZGG->ZGG_QUANT		:= val(aBkpDT[R][5]) // Quantidade
									ZGG->ZGG_DTPRF		:= STOD(aBkpDT[R][6] )      // Data
									ZGG->ZGG_PREPED  	:= aBkpDT[R][7]      // Prepedido
									ZGG->ZGG_REQUIS		:= aBkpDT[R][8]       // Requisicao
																
								Msunlock()
						
							Next R
						
						else
							
							For R:=1 to len(aBkpdt)
								// Verificar se nao existe outro registro
										
								Reclock("ZGG",.T.)
								conout("dados altera ZGG ")

									ZGG->ZGG_FILIAL		:= aBkpDT[R][1]      // Filial
									ZGG->ZGG_PEDIDO  	:= SC7->C7_NUM       // Pedido
									ZGG->ZGG_ITEM		:= aBkpDT[R][3]      // Item
									ZGG->ZGG_PROD		:= aBkpDT[R][4]      // Produto
									ZGG->ZGG_QUANT		:= val(aBkpDT[R][5]) // Quantidade
									ZGG->ZGG_DTPRF		:= STOD(aBkpDT[R][6] )      // Data
									ZGG->ZGG_PREPED  	:= aBkpDT[R][7]      // Prepedido
									ZGG->ZGG_REQUIS		:= aBkpDT[R][8]       // Requisicao
																
								Msunlock()
						
							Next R
						
						Endif
					endif
					*/
				Else

					If nRets = 0 
						AutoGrLog("ERRO : ")
						aLog := GetAutoGRLog()	
					Else
						AutoGrLog("PREPEDIDO JÁ EXISTENTE NO ERP , NÚMERO "+cPedERP)
						aLog := {"PREPEDIDO JÁ EXISTENTE nNO ERP , NUMERO "+cPedERP}
					Endif

					conout("Erro na inclusao!")

				EndIf

				Reclock("ZF1",.T.)

				ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
				ZF1->ZF1_FILIAL :=	cFilant
				ZF1->ZF1_INTERF	:=	"P1"
				ZF1->ZF1_DATA	:=	dDataBase  
				ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN[X]:PREPEDIDO
				ZF1->ZF1_PEDIDO	:=	cNumped
				ZF1->ZF1_METODO	:=	"GET"
				ZF1->ZF1_NOTA	:=	""  
				ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
				IF ! lMsErroAuto
					ZF1->ZF1_ERRO	:=	"OK"
				Else
					ZF1->ZF1_ERRO	:=	"ERRO"
				Endif
				ZF1->ZF1_JSON	:=	cJsonRet
				ZF1->ZF1_HORA	:=	Time()
				ZF1->ZF1_TOKEN	:=	" "


				Msunlock () 
				CONOUT ("acesso status prepedido")
				// Acesso a Interface StatusPrePedido

				cUrl	 := GetMv("MGF_WSC48A") 

				cHeadRet 	:= ""
				aHeadOut	:= {}
				cJson		:= ""
				oJson		:= Nil

				cTimeIni	:= ""
				cTimeProc	:= ""

				xPostRet	:= Nil
				nStatuHttp	:= 0
				nTimeOut    := 600

				aadd( aHeadOut, 'Content-Type: application/json' )

				oJson						  := JsonObject():new()
				cjson := " "

				cjson +='   {                                                   '
				cjson +='  	"MSGSTATUSPREPEDIDO": {                             '

				If !lMsErroAuto 
					cjson  +='	"IDENTIFIC":  "' + cNumped + '"            ,'
				Else
					cjson  +='	"IDENTIFIC": "  "                              ,'
				Endif

				cjson  +='	"PREPEDIDO":"' + JCUSTOMER:ITEN[X]:prepedido   + '"       ,'

				If !lMsErroAuto 
					cjson  +='	"STATUS":    1                                    ,'
				Else
					cjson  +='	"STATUS":    108                                  ,'
				Endif

				cjson +='	"FORNECEDORCLIENTE":"' + Substr(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,1,6) + Substr(JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE,7,2)   +'"                             ,'

				If Len(aLog) > 0


					For t:=1 to Len(aLog)

						cvar += alltrim(STRTRAN(alog[t],Chr(13)+Chr(10),"")) + "**"


					Next t

					cjson +=' "OBSERP":  "' + Alltrim(cvar) + '"  }}'

				Else

					cjson +=' "OBSERP":" " }}'

				Endif
				
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
					conout("status_ret")

				Else
					conout("dif 200" +xPostRet)
					// Retentativas pois deu erro 

					For l := 1 To 5

						If ! Empty( cJson )
							conout ('Retentativa ...  ')
							xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )


							nStatuHttp	:= 0
							nStatuHttp	:= httpGetStatus()
							If AllTrim( str(nStatuHttp)) = '200'
								l := 5
							Endif

						Endif
					Next l
					// Fim Retentativas
				Endif

				freeObj( oJson )


				// Fim Acesso a Interface StatusPrePedido

				Reclock("ZF1",.T.)

				ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
				ZF1->ZF1_FILIAL :=	cFilant
				ZF1->ZF1_INTERF	:=	"P2"
				ZF1->ZF1_DATA	:=	dDataBase  
				ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN[X]:PREPEDIDO
				ZF1->ZF1_PEDIDO	:=	cNumped
				ZF1->ZF1_METODO	:=	"POST"
				ZF1->ZF1_NOTA	:=	" "  
				ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
				ZF1->ZF1_ERRO	:=	" "
				ZF1->ZF1_JSON	:=	cjson
				ZF1->ZF1_HORA	:=	Time()
				ZF1->ZF1_TOKEN	:=	" "


				Msunlock () 
				
               
				conout("iniciando token")
				cUrl	 := Alltrim(GetMv("MGF_WSC44B"))+Alltrim(JCUSTOMER:TOKEN) 

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
				conout("VALE -toqken" +xPostRet)
				//endif

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()
				conout("st_toqken" +Alltrim(JCUSTOMER:TOKEN))
				cTimeFin	:= time()

				If AllTrim( str( nStatuHttp ) ) = '200'
					conout("status-token")

				else
					conout("dif 200-toqken" +xPostRet)

					// Retentativas pois deu erro 

					For l := 1 To 5

						conout("Retentativa Token ")
						xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)

						nStatuHttp	:= 0
						nStatuHttp	:= httpGetStatus()

						If AllTrim(Str(nStatuHttp)) = '200'
							l := 5
						Endif

					Next l
					// Fim Retentativas

				Endif

				// ***********fim token******************************************************************************

				Reclock("ZF1",.T.)

				ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
				ZF1->ZF1_FILIAL :=	cFilant
				ZF1->ZF1_INTERF	:=	"P3"
				ZF1->ZF1_DATA	:=	dDataBase  
				ZF1->ZF1_PREPED	:=	JCUSTOMER:ITEN[X]:PREPEDIDO
				ZF1->ZF1_PEDIDO	:=	cNumped
				ZF1->ZF1_METODO	:=	"POST"
				ZF1->ZF1_NOTA	:=	" "  
				ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
				ZF1->ZF1_ERRO	:=	"OK"
				ZF1->ZF1_JSON	:=	" "
				ZF1->ZF1_HORA	:=	Time()
				ZF1->ZF1_TOKEN	:=	JCUSTOMER:TOKEN


				Msunlock () 

				// Para buscar todos os itens pendentes
				nitens := JCUSTOMER:ITENPENDENTES
                
			next x

		endif


	Else
		CONOUT("Erro diferente de 200 ")
	endif



return

