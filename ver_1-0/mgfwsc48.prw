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

	U_MFCONOUT('Iniciando integracao de pedidos de compra do Mercado Eletronico...') 
	
	//Leitura dos pre pedidos para a tabela ZGS
	U_MFCONOUT('Iniciando leitura de pedidos de compra do Mercado Eletronico...') 
	MGFWSC48L()
	U_MFCONOUT('Completou leitura de pedidos de compra do Mercado Eletronico...') 

	//Execução da integração dos pedidos
	U_MFCONOUT('Iniciando integracao de pedidos de compra do Mercado Eletronico...') 
	MGFWSC48E()
	U_MFCONOUT('Completou integracao de pedidos de compra do Mercado Eletronico...') 

	//Retorno de status
	U_MFCONOUT('Iniciando retorno de status para o Mercado Eletronico...')
	MGFWSC48S()
	U_MFCONOUT('Completou retorno de status para o Mercado Eletronico...')

	//Retorno de tokens
	U_MFCONOUT('Iniciando retorno de tokens para o Mercado Eletronico...')
	MGFWSC48T()
	U_MFCONOUT('Completou retorno de tokens para o Mercado Eletronico...')

Return

/*/{Protheus.doc} MGFWSC48L 
Leitura da integracao de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC48L()

Local cURLInteg	 	:= Alltrim(GetMv("MGF_WSC48")) 
Local aHeadstr 		:= {}
Local cTimeIni		:= time()
Local ctimeproc 	:= ""
Local ctimefin 		:= time()
Local cHeaderRet	:= ""
Local nStatuHttp 	:= 0
local nTimeOut		:= 600

aadd( aHeadStr, 'Content-Type: application/json')

U_MFCONOUT('Lendo pedidos...') 
U_MFCONOUT('URL...: ' +  cURLInteg)

cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
cTimeFin	:= time()
cTimeProc	:= elapTime(cTimeIni, cTimeFin)

nStatuHttp := httpGetStatus()

U_MFCONOUT('Status http...:' + alltrim(str(nStatuHttp))) 

If nStatuHttp < 200 .or. nStatuHttp > 299
	U_MFCONOUT('Erro na leitura de pedidos!')	
	Return
Endif
	
If len(cHttpRet) = 6 
	U_MFCONOUT('Não há pedidos pendentes!')	
	Return
Endif
	
If nStatuHttp >= 200 .and. nStatuHttp <= 299

	jCustomer := nil
	if fwJsonDeserialize( cHttpRet, @jCustomer )
	
		//Verifica se já tem integração com mesmo Token gravada na ZGS
		ZGS->(Dbsetorder(3)) //ZGS_TOKEN
		If ZGS->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))
			
			U_MFCONOUT('Token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o pre pedido ' + JCUSTOMER:ITEN[1]:PREPEDIDO + ' já gravado na tabela intermediária!')	

			//Se o token está com status T mas ainda na lista marca para reenviar token para que saia da lista
			If ZGS->ZGS_STATUS = "T"
				Reclock("ZGS",.F.)
				ZGS->ZGS_STATUS := "S"
				ZGS->(Msunlock())
			Endif

			Return
		
		Else
		
			U_MFCONOUT('Gravando token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o pre pedido ' + JCUSTOMER:ITEN[1]:PREPEDIDO + ' na tabela intermediária...')	

			// Para buscar a Empresa e Filial
			If Len(JCUSTOMER:ITEN[1]:BORGS) = 2
				For N := 1 to Len(JCUSTOMER:ITEN[1]:BORGS)

					cfilant := JCUSTOMER:ITEN[1]:BORGS[N+1]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN[1]:BORGS)  + 1
				Next
			Else
				For N := 1 to Len(JCUSTOMER:ITEN[1]:RequisicoesPrePedido[1]:BORGS)
						
					cfilant := JCUSTOMER:ITEN[1]:RequisicoesPrePedido[1]:BORGS[N+1]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN[1]:RequisicoesPrePedido[1]:BORGS)  + 1
				Next N
			Endif

			_cpcprot := " "

			If AttIsMemberOf( JCUSTOMER:ITEN[1], "IDENTIFIC") 
				_cpcprot := JCUSTOMER:ITEN[1]:IDENTIFIC
			Endif

			BEGIN TRANSACTION

			Reclock("ZGS",.T.)
			ZGS->ZGS_FILIAL := cfilant
			ZGS->ZGS_PREPED := JCUSTOMER:ITEN[1]:PREPEDIDO
			ZGS->ZGS_PCPROT := _cpcprot
			ZGS->ZGS_JSONE := cHttpRet
			ZGS->ZGS_DATAE := date()
			ZGS->ZGS_HORAE := time()
			ZGS->ZGS_TOKEN := Alltrim(JCUSTOMER:TOKEN) 
			ZGS->ZGS_URLE := cURLInteg
			ZGS->(Msunlock())

			END TRANSACTION

			U_MFCONOUT('Completou gravação do token ' +Alltrim(JCUSTOMER:TOKEN) + ' para o pre pedido ' + JCUSTOMER:ITEN[1]:PREPEDIDO + ' na tabela intermediária...')	

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

/*/{Protheus.doc} MGFWSC48E	 
Execução da integracao de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC48E()

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
	local _carma    := ""

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lAutoErrNoFile := .T.
	private aLog  := {}
	Private cvar  := " "
	Private nrats := 0 
	Private crats := 0
	Private cXrat  :=  "2" // Nao rateio

	cQuery := " SELECT ZGS_FILIAL,ZGS_PREPED, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZGS")
	cQuery += "  WHERE ZGS_STATUS  = ' '"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZGSTMP") > 0
		ZGSTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGSTMP", .F., .T.)
	
	If ZGSTMP->(eof())	
		U_MFCONOUT("Não existem pre pedidos pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando pre pedidos pendentes de processamento...")
		_ntot := 0
		Do while ZGSTMP->(!eof())
			_ntot++
			ZGSTMP->(Dbskip())
		Enddo
		ZGSTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZGSTMP->(!eof())	

		U_MFCONOUT("Processando pre pedido " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZGS->(Dbgoto(ZGSTMP->RECN))

		BEGIN TRANSACTION

		jCustomer := nil
		if fwJsonDeserialize( ZGS->ZGS_JSONE, @jCustomer )
			cJsonRet := ZGS->ZGS_JSONE

			For X := 1 to 1//Len(JCUSTOMER:ITENS)  // itens

				lMSErroAuto := .F.

				BEGIN SEQUENCE

				// Para buscar a Empresa e Filial
				If Len(JCUSTOMER:ITEN[X]:BORGS) = 2
					For N := 1 to Len(JCUSTOMER:ITEN[X]:BORGS)

						cfilant := JCUSTOMER:ITEN[X]:BORGS[N+1]:CODIGOBORG
						cEmpant := SUBSTR(JCUSTOMER:ITEN[X]:BORGS[N]:CODIGOBORG,1,2)
						n := Len(JCUSTOMER:ITEN[X]:BORGS)  + 1
					Next
				Else

					For N := 1 to Len(JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:BORGS)
						
						If AttIsMemberOf( JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1], "CENTROCUSTOSCLIENTE") 
							cCusto  := JCUSTOMER:ITEN[X]:RequisicoesPrePedido[1]:CENTROCUSTOSCLIENTE
						Endif

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

				//Valida tag fornecedor e cnpj
				If !(AttIsMemberOf( JCUSTOMER:ITEN[X], "FORNECEDORCLIENTE")) .and. !(AttIsMemberOf( JCUSTOMER:ITEN[X], "CNPJFORNECEDOR"))
					lMSErroAuto := .T.
					_cerros := "Tag FORNECEDORCLIENTE e CNPJFORNECEDOR inexistente para o pedido!"
					nrets := 99
					If AttIsMemberOf( JCUSTOMER:ITEN[X], "IDENTIFIC") 	
						If JCUSTOMER:ITEN[X]:IDENTIFIC <> " " .and. (JCUSTOMER:ITEN[X]:STATUS =  '107' .OR. JCUSTOMER:ITEN[X]:STATUS =  '108')
							noper := 4
						EndIf
					Endif
					BREAK
				Elseif (AttIsMemberOf( JCUSTOMER:ITEN[X], "FORNECEDORCLIENTE"))

					_cforn := JCUSTOMER:ITEN[X]:FORNECEDORCLIENTE

				Elseif !(AttIsMemberOf( JCUSTOMER:ITEN[X], "FORNECEDORCLIENTE")) .and. (AttIsMemberOf( JCUSTOMER:ITEN[X], "CNPJFORNECEDOR"))

					//Se não tem a tag com fornecedor cliente procura pelo cnpj na SA2
					SA2->(Dbsetorder(3)) //A2_FILIAL+A2_CGC
					
					If SA2->(Dbseek(xfilial("SA2")+alltrim(JCUSTOMER:ITEN[X]:CNPJFORNECEDOR)))

						_cforn := alltrim(SA2->A2_COD) + alltrim(SA2->A2_LOJA)

					Else
			
						lMSErroAuto := .T.
						_cerros := "Tag CNPJFORNECEDOR com fornecedor inexistente na base de dados Protheus!"
						nrets := 99
						If AttIsMemberOf( JCUSTOMER:ITEN[X], "IDENTIFIC") 	
							If JCUSTOMER:ITEN[X]:IDENTIFIC <> " " .and. (JCUSTOMER:ITEN[X]:STATUS =  '107' .OR. JCUSTOMER:ITEN[X]:STATUS =  '108')
								noper := 4
							EndIf
						Endif
						BREAK

					Endif

				Endif

		
				If AttIsMemberOf( JCUSTOMER:ITEN[X], "IDENTIFIC") 

					If JCUSTOMER:ITEN[X]:IDENTIFIC <> " " .and. (JCUSTOMER:ITEN[X]:STATUS =  '107' .OR. JCUSTOMER:ITEN[X]:STATUS =  '108')
						// Verificar esta clausula status 
						lAltera := .t.                                   
						noper  := 4
						dbSelectArea("SC7")
						SC7->(dbSetOrder(1)) //C7_FILIAL+C7_NUM

						If SC7->(dbSeek(cfilant + JCUSTOMER:ITEN[X]:IDENTIFIC ))

							U_MFCONOUT("Alterando pedido " + cfilant + " - " + JCUSTOMER:ITEN[X]:IDENTIFIC + "...")

						Else

						Endif

						aadd(aCabec,{"C7_NUM"    , JCUSTOMER:ITEN[X]:IDENTIFIC })
						aadd(aCabec,{"C7_FILIAL" ,  cfilant}) //JCUSTOMER:ITENS[X]:BORGS[X]:CODIGOBORG + JCUSTOMER:ITENS[X]:BORG_CENTR
						aadd(aCabec,{"C7_EMISSAO"    ,SC7->C7_EMISSAO}) 
						aadd(aCabec,{"C7_FORNECE"    , Substring(_cforn,1,6) }) // 
						aadd(aCabec,{"C7_LOJA"       , Substring(_cforn,7,2) })
					ELSE
						aadd(aCabec,{"C7_EMISSAO"    , dDataBase}) 
						aadd(aCabec,{"C7_FILIAL"    , CFILANT}) 
						aadd(aCabec,{"C7_FORNECE"    , Substring(_cforn,1,6) }) // 
						aadd(aCabec,{"C7_LOJA"       , Substring(_cforn,7,2) })
						
					Endif
				Else
					U_MFCONOUT("Incluindo pedido de compra para pre pedido " + JCUSTOMER:ITEN[X]:PREPEDIDO + "...")
					aadd(aCabec,{"C7_EMISSAO"    , dDataBase}) 
					aadd(aCabec,{"C7_FILIAL"    , CFILANT}) 
					aadd(aCabec,{"C7_FILENT"    , CFILANT}) 
					aadd(aCabec,{"C7_FORNECE"    , Substring(_cforn,1,6) }) // 
					aadd(aCabec,{"C7_LOJA"       , Substring(_cforn,7,2) })
					
				Endif
			
				
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
				Else
					aadd(aCabec,{"C7_COMPRA"     , " " })
				Endif

				//Valida centros de custo
				For _nnj := 1 to len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO) 

					For _nnl := 1 to len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[_nnj]:ItensRequisicaoItemPrePedido)

						For _nno := 1 to len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[_nnj]:ItensRequisicaoItemPrePedido[_nnl]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO)

							If !(AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[_nnj]:ItensRequisicaoItemPrePedido[_nnl]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[_nno], "CENTROCUSTO"));
								.or. empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[_nnj]:ItensRequisicaoItemPrePedido[_nnl]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[_nno]:CENTROCUSTO) 

								lMSErroAuto := .T.
								_cerros := "Item " + alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[_nnj]:CODIGO_PRODUTO) + " sem centro de custo!"
								nrets := 99
								BREAK
		

							Endif

						Next

					Next

				Next
							
				//Valida condição de pagamento
				SE4->(Dbsetorder(1)) //E4_FILIAL+E4_CODIGO
				If !(SE4->(Dbseek(xfilial("SE4")+alltrim(JCUSTOMER:ITEN[X]:COND_PAGTO))))
			
					lMSErroAuto := .T.
					_cerros := "Condição de pagamento " + alltrim(JCUSTOMER:ITEN[X]:COND_PAGTO) + " inexistente!"
					nrets := 99
					BREAK

				Elseif SE4->E4_MSBLQL == '1'

					lMSErroAuto := .T.
					_cerros := "Condição de pagamento " + alltrim(JCUSTOMER:ITEN[X]:COND_PAGTO) + " - " + alltrim(SE4->E4_DESCRI) +  " bloqueada!"
					nrets := 99
					BREAK

				Endif

				aadd(aCabec,{"C7_COND"       , JCUSTOMER:ITEN[X]:COND_PAGTO                      }) ////JCUSTOMER:ITEN[X]:COND_PAGTO 
				aadd(aCabec,{"C7_CONTATO"    , "Int. ME"})

				
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

				_aipi := {}
				
				For nX := 1 To Len(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO)


					aLinha := {}
					_lzeraipi := .F.


					aadd(aLinha,{"C7_PRODUTO"    , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO       , Nil })//JCUSTOMER:ITENS[X]:itens:itemprepedido:codigo_produto
					aadd(aLinha,{"C7_QUANT"      , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)      , Nil })
					
					if AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "CENTROCUSTOCLIENTE") 
						cRats := JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CENTROCUSTOCLIENTE
					Endif

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
						U_MFCONOUT("Precos Zerados ou com problemas . Sera Preco = 1 - "+JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO + "...")
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

							aadd(aLinha,{"C7_CLVL"         , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo , NIL    })//"10100002"

						ElseIF Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo) ;
						.AND. JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:NomeAtributo = "Classe"

							aadd(aLinha,{"C7_CLVL"         , " " , NIL    })//"10100002"

						Endif

					Next R

					_lzeraipi := .T.

					If AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "IPI") .and. AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "VALORIPI")

						If VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI) = 0 .AND.  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:VALORIPI) = 0
							aadd(aLinha,{"C7_IPI"       , 0  , NIL    })
							aadd(aLinha,{"C7_VALIPI"    , 0  , NIL    })
						Elseif VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI) > 0 .AND.  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:VALORIPI) > 0
							_lzeraipi := .F.
							aadd(aLinha,{"C7_IPI"       , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI)  , NIL    })
							aadd(aLinha,{"C7_VALIPI"    ,  (Round((ALINHA[ASCAN(ALINHA,{|X| X[1]='C7_PRECO'})][2]) ,6)  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE) )  *  VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:IPI)  / 100 , Nil })
						Endif
					
					Else
						aadd(aLinha,{"C7_IPI"       , 0  , NIL    })
						aadd(aLinha,{"C7_VALIPI"    , 0  , NIL    })
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
							U_MFCONOUT("Processando Item "+PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0") + "...")

							aadd(aLinha,{"C7_RATEIO"       , '1'   , Nil      })

							// Preenchimento do Local 

							_lachou := .F.
							For d:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS)

								If  JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:NomeAtributo = "ARMAZEM" ;
										.AND. ! Empty(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo)

									aadd(aLinha,{"C7_LOCAL" , Substr(Alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[B]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo),1,2)  , Nil })
									_lachou := .T.
									
									If PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0") = '0001'
										_carma := Substr(Alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[B]:ItemRequisicaoItemPrePedido:ATRIBUTOS[D]:ValorAtributo),1,2) 
									Endif

								Endif


							Next d

							If !_lachou .and. !(PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0") = '0001') .and. !(empty(_carma))
									aadd(aLinha,{"C7_LOCAL" , _carma , Nil })
							Elseif !_lachou
								//Coloca armazém padrão do produto
								SB1->(Dbsetorder(1)) //B1_FILIAL+B1_COD
								If SB1->(Dbseek(xfilial("SB1")+alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO) ))
									_carma := alltrim(SB1->B1_LOCPAD)
									aadd(aLinha,{"C7_LOCAL" , _carma , Nil })
								Else
									_cerros := "Tag ARMAZEM inexistente para o pedido e produto " 
									_cerros +=  alltrim(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO) + " não localizado!"
									nrets := 99
									BREAK
								Endif
							Endif

							//dados de embalagem para ZGG
							If LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS) > 0
								
								For w:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS)
 
									aadd(aBkpdt , { cFilant , ;                                                                                                                   // Filial
									                JCUSTOMER:ITEN[X]:PREPEDIDO , ;                                                                                               // Prepedido
													cItem , ;                                                                                                                     // Item
													JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO   , ;                                                                      // Produto
													val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:QUANTIDADE)  , ;  // Quantidade
									                SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,1,4) + SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,6,2)+ SUBSTRING(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:ENTREGAS[w]:DATAENTREGA ,9,2)  , ;  // Data
									                JCUSTOMER:ITEN[X]:PREPEDIDO   , ;                                                                                             // PREPEDIDO
													JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:REQUISICAO   } )                                                                          // Requisicao
										
								Next W
								
							Else
							
								If AttIsMemberOf( JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX], "DATAPREVISTA")

									_cdataprevista := Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,1,4)
									_cdataprevista += Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,6,2) 
									_cdataprevista += Substring(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:DATAPREVISTA,9,2)

								Else

									_cdataprevista := " "

								Endif

								aadd(aBkpdt , { cFilant                                                 , ;    // FILIAL
								 			    JCUSTOMER:ITEN[X]:PREPEDIDO                             , ;    // PREPEDIDO
							                    cItem                                                   , ;    // ITEM
												JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO      , ;    // PRODUTO 
												VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)     , ;    // QUANTIDADE
												_cdataprevista									        , ;   // DATA
												JCUSTOMER:ITEN[X]:PREPEDIDO                             , ;	   // PREPEDIDO
												JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:REQUISICAO           })   // REQUISICAO
							Endif


							// Preenchimento do Rateio
							for c:=1 to LEN(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO)

								cigual := PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0") + JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:CENTROCUSTO

								For h:=1 to len(aRats)//If aratcc[nx][2][c][8][2] + aratcc[nx][2][c][7][2] // itempd + custo
									if arats[h,1] + arats[h,2] == cigual
										litem := .t.
										h:= len(arats)
									Endif

								Next h

								aAdd(aItemCC,{"CH_FILIAL"		  , cfilant           			, nil})
								aAdd(aItemCC,{"CH_FORNECEDOR"     , Substring(_cforn,1,6)         , NIL})
								aAdd(aItemCC,{"CH_LOJA"           , Substring(_cforn,7,2)         , NIL})
								aAdd(aItemCC,{"CH_ITEM"           , StrZero(cont,Len(SCH->CH_ITEM)) , NIL})
								aAdd(aItemCC,{"CH_PEDIDO"           , JCUSTOMER:ITEN[X]:PREPEDIDO, NIL})
								
								_lok := .F.

								If AttIsMemberOf(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[1]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c],"QTD_PERC")

									If val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[1]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QTD_PERC) > 0

										aAdd(aItemCC,{"CH_PERC"           ,;
														 val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[1]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QTD_PERC),;
														 NIL})
								
										nPerc := val(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[1]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QTD_PERC)

										_lok := .T.

									Endif

								Endif

								If !_lok // não tem tag de percentual válida
								
										aAdd(aItemCC,{"CH_PERC"           , VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QUANTIDADE) ;
															/ VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)   ;               
																			* 100  , NIL})

										nPerc := VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:QUANTIDADE)/ ;
													VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)* 100

								Endif
		
								
								aAdd(aItemCC,{"CH_CC"             , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ItensRequisicaoItemPrePedido[b]:ItemRequisicaoItemPrePedido:OBJETOSCUSTO[c]:CENTROCUSTO,NIL})
								aAdd(aItemCC,{"CH_ITEMPD"         , PADL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:NUMEROITEM,4,"0")           , NIL})
								
								aAdd(aItemCC,{"CH_ZVALRAT"        , ( nperc ; 
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

							aItemcc := {}
						endif
					Next b	


					aadd(aItens,aLinha)
					aadd(_aipi,{_lzeraipi,JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO,VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)})

				Next nX // 

				AutoGrLog("")

				aLog := {}
				lMSErroAuto := .F.
				_cerros := " "

				If noper = 3  

					U_MFCONOUT("Validando se existe pedido para o pre pedido " + JCUSTOMER:ITEN[x]:PREPEDIDO + " a ser incluido...")
					// Verifica se é inclusao e nao tenha o pedido do ERP NA TAG IDENTIFIC
					cQuery := " SELECT C7_FILIAL,C7_NUM,C7_ZPEDME "
					cQuery += " FROM "+RetSqlName("SC7")+" SC7 "
					cQuery += " WHERE SC7.C7_ZPEDME = '" + JCUSTOMER:ITEN[x]:PREPEDIDO + "' AND "
					cQuery += " SC7.C7_FILIAL='" + cFilant +"'                            AND "
					cQuery += " SC7.D_E_L_E_T_= ' ' AND SC7.C7_ZPEDME <> ' ' "
					cQuery += " AND (SC7.C7_ZCANCEL <> 'S' OR (SC7.C7_ZCANCEL = 'S' AND SC7.C7_QUJE <> 0) ) "
 
					TCQuery cQuery New Alias "cAliasSC7"
				
					cpederp := cAliasSC7->C7_ZPEDME
						Count To nRets

					cAliasSC7->(Dbgotop())

						If nRets > 0 
							lMsErroAuto  := .t.
							_cerros := "Existe pedido " + cAliasSC7->C7_FILIAL + "/" + cAliasSC7->C7_NUM + " para esse pre pedido!"
						Endif

					dbCloseArea ("cAliasSC7")
					RestArea(aAreabkp)
				Endif

				_cprod := " "
				
				If !(lMSErroAuto)

					For nit := 1 to len(aitens)
				
						For nlin := 1 to len(aitens[nit])

							//Validando produtos do pedido
							//aadd(aLinha,{"C7_PRODUTO"    , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO       , Nil })//JCUSTOMER:ITENS[X]:itens:itemprepedido:codigo_produto
							If aitens[nit][nlin][1] == "C7_PRODUTO"

								_cprod := alltrim(aitens[nit][nlin][2])

								SB1->(Dbsetorder(1)) //B1_FILIAL+B1_COD
								If !SB1->(Dbseek(xfilial("SB1")+aitens[nit][nlin][2]))
									_cerros += " Produto " + alltrim(aitens[nit][nlin][2]) + " não existente!"
									lMSErroAuto := .T.
									nrets := 99
								Elseif (SB1->B1_MSBLQL == '1' .OR. SB1->B1_ZBLQSC = '1')
									_cerros += " Produto " + alltrim(aitens[nit][nlin][2]) + " bloqueado!"
									lMSErroAuto := .T.
									nrets := 99
								Endif

							Endif

							//Validando classes de valor do pedido
							//aadd(aLinha,{"C7_CLVL"         , JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:ATRIBUTOS[R]:ValorAtributo , NIL    })//"10100002"
							If aitens[nit][nlin][1] == "C7_CLVL"
								
								If !empty(alltrim(aitens[nit][nlin][2]))
								
									If !Ctb105ClVl( alltrim(aitens[nit][nlin][2]) )
										
										//Valida tipo de incosistencia
										CTH->(Dbsetorder(1)) //CTH_FILIAL+CTH_CLVL
										If !(CTH->(Dbseek(xfilial("CTH")+alltrim(aitens[nit][nlin][2]))))
											_cerros += " Classe de valor " + alltrim(aitens[nit][nlin][2]) + " inexistente para o produto " +alltrim(_cprod) + "!"
											lMSErroAuto := .T.
											nrets := 99
										Elseif CTH->CTH_BLOQ='1'
											_cerros += " Classe de valor " + alltrim(aitens[nit][nlin][2]) + " bloqueada para o produto " +alltrim(_cprod) + "!"
											lMSErroAuto := .T.
											nrets := 99
										Elseif CTH->CTH_DTEXIS < DATE() .OR. CTH->CTH_DTEXSF > DATE()
											_cerros += " Classe de valor " + alltrim(aitens[nit][nlin][2]) + " fora de vigência o produto " +alltrim(_cprod) + "!"
											lMSErroAuto := .T.
											nrets := 99
										Else
											_cerros += " Classe de valor " + alltrim(aitens[nit][nlin][2]) + " invalida para o produto " +alltrim(_cprod) + "!"
											lMSErroAuto := .T.
											nrets := 99
										Endif
								
									Endif
								
								Endif

							Endif

						Next

					Next

				Endif

				END SEQUENCE

				If lrateio  .AND.  nRets = 0 .and. !(lMSErroAuto)

					U_MFCONOUT("Realizando " + iif(noper==3,"inclusão","alteração") + " do pedido...")
					_xret := MATA120(1,aCabec,aItens,noper,,)
					U_MFCONOUT("Pedido " + ALLTRIM(SC7->C7_FILIAL)+ "/" + ALLTRIM(SC7->C7_NUM) + iif(noper==3," incluido"," alterado") + "...")

					//Ajusta fornecedor quando não é alterado
					If _xret .and. noper == 4 .and. ALLTRIM(SC7->C7_FILIAL) == cfilant .and.;
										 ALLTRIM(SC7->C7_NUM) == ALLTRIM(JCUSTOMER:ITEN[x]:IDENTIFIC)


						_nposk := SC7->(Recno())

						SC7->(Dbsetorder(1)) //C7_FILIAL+C7_NUM
						SC7->(Dbseek(cfilant+ALLTRIM(JCUSTOMER:ITEN[x]:IDENTIFIC)))	//vai para primeiro registro do pedido					

						Do while ALLTRIM(SC7->C7_FILIAL) == cfilant .and. ALLTRIM(SC7->C7_NUM) == ALLTRIM(JCUSTOMER:ITEN[x]:IDENTIFIC)


							Reclock("SC7",.F.)
							SC7->C7_FORNECE := Substring(_cforn,1,6)
							SC7->C7_LOJA := Substring(_cforn,7,2)
							SC7->(Msunlock())

							SC7->(Dbskip())

						Enddo

						SC7->(Dbgoto(_nposk))

					Endif

					For h:=1 to len(aBkp)

						U_MFCONOUT("Gravando rateio " + strzero(h,6) + " de " + strzero(len(aBkp),6) + "...")
						// Verificar se nao existe outro registro
						If aBkp[h][6][2] < 100 .AND. Empty(posicione("SCH",1,aBkp[h][1][2];
													+SC7->C7_NUM;
													+aBkp[h][2][2];
													+aBkp[h][3][2];
													+aBkp[h][8][2];
													+aBkp[h][4][2],"CH_PEDIDO") )
						
							Reclock("SCH",.T.)
									
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


				Elseif ! lrateio  .AND.  nRets = 0 .and. !(lMSErroAuto)
					U_MFCONOUT("Realizando " + iif(noper==3,"inclusão","alteração") + " do pedido...")
					MSExecAuto({|x,y,w,z,a|MATA120(x,y,w,z,a)},1,aCabec,aItens,noper,.F.)
					U_MFCONOUT("Pedido " + ALLTRIM(SC7->C7_FILIAL)+ "/" + ALLTRIM(SC7->C7_NUM) + iif(noper==3," incluido"," alterado") + "...")
				Endif


				If ! lMsErroAuto .AND. nRets = 0

					If nOper = 3
						CNumPed := SC7->C7_NUM
					Else
						cnumPed := JCUSTOMER:ITEN[x]:IDENTIFIC
					Endif 

					//Zera ipi se necessário
					//	aadd(_aipi,{_lzeraipi,JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:CODIGO_PRODUTO,VAL(JCUSTOMER:ITEN[X]:ITEMPREPEDIDO[NX]:QUANTIDADE)})
					For _nk := 1 to len(_aipi)

						If _aipi[_nk][1]

							SC7->(Dbsetorder(1)) //C7_FILIAL+C7_NUM+C7_ITEM
							If SC7->(Dbseek(cfilant+cnumPed+strzero(_nk,4)))
								If alltrim(SC7->C7_PRODUTO) == alltrim(_aipi[_nk][2]) .and. SC7->C7_QUANT == _aipi[_nk][3]
									Reclock("SC7",.F.)
									SC7->C7_VALIPI := 0
									SC7->C7_IPI := 0
									SC7->(Msunlock())
								Endif
							Endif

						Endif

					Next


					// Verifica qual Centro de Custo e rateio a ser gravado na SC7 
					For D := 1 to len(aBkp)
						
							If JCUSTOMER:ITEN[X]:PREPEDIDO   = aBkp[D][5][2] .AND.  ;
  						   		SC7->C7_FORNECE              = aBkp[D][2][2] .AND.  ;
						   		SC7->C7_LOJA                 = aBkp[D][3][2] .AND.  ;
   						   		SC7->C7_FILIAL               = aBkp[D][1][2] .AND.  ;
   						   		SC7->C7_ITEM                 = aBkp[D][8][2] 
							
									If aBkp[D][6][2] == 100
										cCusto := aBkp[D][7][2]
										CxRAT  := "2" // rateio nao  e centro de custo na linha do item
								
									Else
										cCusto := " "
										CxRAT  := "1" // rateio sim e centro de custo vazio no item , pois existe rateio
									Endif
								D := len(aBkp) + 1												
							Endif
					
						Next D

					cQ := "UPDATE "
					cQ += RetSqlName("SC7")+" "
					cQ += "SET "
					cQ += "C7_CONAPRO = 'L' , C7_CC = '"+ccusto+ "' , C7_COMPRA = '"+cRetUsr+ "' ,  C7_RATEIO = '"+CxRAT+ "'  "
					
					cQ += " WHERE C7_FILIAL  = '" + cFilant  + "'  "
					cQ += " AND  C7_FORNECE  = '" + Substr(_cforn,1,6) + "'  "
					cQ += " AND  C7_LOJA     = '" + Substr(_cforn,7,2)    + "'  "
					cQ += " AND  C7_NUM      = '" + cNumped  + "'  "

					nRet := tcSqlExec(cQ)

					If nRet == 0

						U_MFCONOUT("Gravação do pedido completada com sucesso!")

					Else
						U_MFCONOUT("Problemas na gravacao dos campos do cadastro, para envio ao ME.")
						Disarmtransaction()

					EndIf 

					For R:=1 to len(aBkpdt)

						ZGG->(Dbsetorder(1)) //ZGG_FILIAL+ZGG_PEDIDO+ZGG_ITEM
						IF ZGG->(DbSeek(aBkpDT[R][1] + cnumPed + aBkpDT[R][3]))
										
							Reclock("ZGG",.F.)

							ZGG->ZGG_FILIAL		:= aBkpDT[R][1]      		// Filial
							ZGG->ZGG_PEDIDO  	:= cNumped		       		// Pedido
							ZGG->ZGG_ITEM		:= aBkpDT[R][3]      		// Item
							ZGG->ZGG_PROD		:= aBkpDT[R][4]      		// Produto
							ZGG->ZGG_QUANT		:= aBkpDT[R][5] 			// Quantidade
							ZGG->ZGG_DTPRF		:= STOD(aBkpDT[R][6] )      // Data
							ZGG->ZGG_PREPED  	:= aBkpDT[R][7]      		// Prepedido
							ZGG->ZGG_REQUIS		:= aBkpDT[R][8]       		// Requisicao
																
							Msunlock()

						Else

							Reclock("ZGG",.T.)

							ZGG->ZGG_FILIAL		:= aBkpDT[R][1]     		// Filial
							ZGG->ZGG_PEDIDO  	:= cNumped		     		// Pedido
							ZGG->ZGG_ITEM		:= aBkpDT[R][3]    			// Item
							ZGG->ZGG_PROD		:= aBkpDT[R][4]      		// Produto
							ZGG->ZGG_QUANT		:= aBkpDT[R][5] 		// Quantidade
							ZGG->ZGG_DTPRF		:= STOD(aBkpDT[R][6] )      // Data
							ZGG->ZGG_PREPED  	:= aBkpDT[R][7]      		// Prepedido
							ZGG->ZGG_REQUIS		:= aBkpDT[R][8]       		// Requisicao
																
							Msunlock()

						Endif
						
					Next R
						
				Else

					If nOper = 3
						CNumPed := " "
					Else
						cnumPed := JCUSTOMER:ITEN[x]:IDENTIFIC
					Endif

					If nRets = 0 
						AutoGrLog("ERRO : ")
						U_MFCONOUT("Erro no execauto...")
						aLog := GetAutoGRLog()	
					Else
						U_MFCONOUT(_cerros)
						AutoGrLog(_cerros)
						aLog := {_cerros}
					Endif

				EndIf

				//Serializa erro
				If len(alog) == 0
					_cerros := " "
				Else
					_cerros := ""
					For _ner := 1 to len(alog)
						_cerros += alog[_ner]
					Next
				Endif

				//Atualiza tabela intermediária
				ZGS->(Dbsetorder(3)) //ZGS_TOKEN
				If ZGS->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))

					Reclock("ZGS",.F.)
					ZGS->ZGS_PCPROT 	:= alltrim(CNumPed)
					ZGS->ZGS_STATME 	:= IIF(lMsErroAuto,'108','1')
					ZGS->ZGS_DATAP 		:= DATE()
					ZGS->ZGS_HORAP 		:= TIME()
					ZGS->ZGS_STATUS 	:= 'P'
					ZGS->ZGS_JSONR		:= _cerros
					ZGS->(Msunlock())

				Endif
		
				// Para buscar todos os itens pendentes
				nitens := JCUSTOMER:ITENPENDENTES
                
			next x

		endif

		END TRANSACTION

		U_MFCONOUT("Completou processamento do pre pedido " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		_nnt++
		ZGSTMP->(Dbskip())

	Enddo

return

/*/{Protheus.doc} MGFWSC48S 
Envio de status de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC48S()

cQuery := " SELECT ZGS_FILIAL,ZGS_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZGS")
cQuery += "  WHERE ZGS_STATUS  = 'P'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZGSTMP") > 0
	ZGSTMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGSTMP", .F., .T.)
	
If ZGSTMP->(eof())	
	U_MFCONOUT("Não existem pre pedidos pendentes de retorno de status!")
	Return
Else
	U_MFCONOUT("Contando pre pedidos pendentes de retorno de status...")
	_ntot := 0
	Do while ZGSTMP->(!eof())
		_ntot++
		ZGSTMP->(Dbskip())
	Enddo
	ZGSTMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZGSTMP->(!eof())	

	ZGS->(Dbgoto(ZGSTMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando status para pre pedido "  + alltrim(ZGS->ZGS_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	
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

	cjson  +='	"IDENTIFIC":  "' + alltrim(ZGS->ZGS_PCPROT) + '"            ,'

	cjson  +='	"PREPEDIDO":"' + alltrim(ZGS->ZGS_PREPED)   + '"       ,'

	cjson  +='	"STATUS":    ' + alltrim(ZGS->ZGS_STATME) +'                                    ,'
	
	SC7->(Dbsetorder(1)) //C7_FILIAL+C7_NUM

	If  !(EMPTY(ALLTRIM(ZGS->ZGS_PCPROT))) .and. SC7->(Dbseek(ZGS->ZGS_FILIAL+ZGS->ZGS_PCPROT))

		_cfornec := alltrim(SC7->C7_FORNECE) + alltrim(SC7->C7_LOJA)

	Else

		jCustomer := nil
		_cfornec := ""
		if fwJsonDeserialize( ZGS->ZGS_JSONE, @jCustomer )
		
			if (AttIsMemberOf( JCUSTOMER:ITEN[1], "FORNECEDORCLIENTE"))

					_cfornec := JCUSTOMER:ITEN[1]:FORNECEDORCLIENTE

			Elseif !(AttIsMemberOf( JCUSTOMER:ITEN[1], "FORNECEDORCLIENTE")) .and. (AttIsMemberOf( JCUSTOMER:ITEN[1], "CNPJFORNECEDOR"))

					//Se não tem a tag com fornecedor cliente procura pelo cnpj na SA2
					SA2->(Dbsetorder(3)) //A2_FILIAL+A2_CGC				
					SA2->(Dbseek(xfilial("SA2")+alltrim(JCUSTOMER:ITEN[1]:CNPJFORNECEDOR)))
					_cfornec := alltrim(SA2->A2_COD) + alltrim(SA2->A2_LOJA)
			
			Endif

		Endif

	Endif

	cjson +='	"FORNECEDORCLIENTE":"' + _cfornec   +'"                             ,'

	cjson +=' "OBSERP":  "' + Alltrim(ZGS->ZGS_JSONR) + '"  }}'
		
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

		Reclock("ZGS",.F.)
		ZGS->ZGS_DATAR	 	:= DATE()
		ZGS->ZGS_HORAR	 	:= TIME()
		ZGS->ZGS_JSONR 		:= cJson
		ZGS->ZGS_URLR 		:= cUrl
		ZGS->ZGS_RETORR 	:= xPostRet
		ZGS->ZGS_STATUS 	:= 'S'
		ZGS->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do status para pre pedido "  + alltrim(ZGS->ZGS_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZGSTMP->(Dbskip())

Enddo

Return

/*/{Protheus.doc} MGFWSC48T 
Envio de tokens de Pedidos de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC48T()

cQuery := " SELECT ZGS_FILIAL,ZGS_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZGS")
cQuery += "  WHERE ZGS_STATUS  = 'S'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZGSTMP") > 0
	ZGSTMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZGSTMP", .F., .T.)
	
If ZGSTMP->(eof())	
	U_MFCONOUT("Não existem pre pedidos pendentes de envio de token!")
	Return
Else
	U_MFCONOUT("Contando pre pedidos pendentes de envio de token...")
	_ntot := 0
	Do while ZGSTMP->(!eof())
		_ntot++
		ZGSTMP->(Dbskip())
	Enddo
	ZGSTMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZGSTMP->(!eof())	

	ZGS->(Dbgoto(ZGSTMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando token para pre pedido "  + alltrim(ZGS->ZGS_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")

    cUrl	 := Alltrim(GetMv("MGF_WSC44B"))+Alltrim(ZGS->ZGS_TOKEN) 
	cHeadRet 	:= ""
	aHeadOut	:= {}
	cTimeIni	:= ""
	cTimeProc	:= ""
	xPostRet	:= Nil
	nTimeOut    := 240

	aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')
	aadd( aHeadOut, 'Authorization: "' + Alltrim(ZGS->ZGS_TOKEN) + '" ')
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

		Reclock("ZGS",.F.)
		ZGS->ZGS_DATAT	 	:= DATE()
		ZGS->ZGS_HORAT	 	:= TIME()
		ZGS->ZGS_URLT 		:= cUrl
		ZGS->ZGS_RETORT 	:= xPostRet
		ZGS->ZGS_STATUS 	:= 'T'
		ZGS->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do token para pre pedido "  + alltrim(ZGS->ZGS_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZGSTMP->(Dbskip())

Enddo

Return

