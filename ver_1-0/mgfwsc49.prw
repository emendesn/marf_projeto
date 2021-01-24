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

U_MFCONOUT('Iniciando integracao de consultas para requisições do Mercado Eletronico...') 
	
//Leitura dos pre requisições para a tabela ZH1
U_MFCONOUT('Iniciando leitura de requisições de compra do Mercado Eletronico...') 
MGFWSC49L()
U_MFCONOUT('Completou leitura de requisições de compra do Mercado Eletronico...') 

//Execução da integração dos requisições
U_MFCONOUT('Iniciando integracao de requisições de compra do Mercado Eletronico...') 
MGFWSC49E()
U_MFCONOUT('Completou integracao de requisições de compra do Mercado Eletronico...') 

//Retorno de status
U_MFCONOUT('Iniciando retorno de status para o Mercado Eletronico...')
MGFWSC49S()
U_MFCONOUT('Completou retorno de status para o Mercado Eletronico...')

//Retorno de tokens
U_MFCONOUT('Iniciando retorno de tokens para o Mercado Eletronico...')
MGFWSC49T()
U_MFCONOUT('Completou retorno de tokens para o Mercado Eletronico...')

U_MFCONOUT('Completou integracao de consultas para requisições do Mercado Eletronico...') 

Return

/*/{Protheus.doc} MGFWSC49L 
Leitura da integracao de requisições de compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC49L()

Local cURLInteg	 	:= Alltrim(GETMV("MGF_WSC49")) 
Local aHeadstr 		:= {}
Local cTimeIni		:= time()
Local ctimeproc 	:= ""
Local ctimefin 		:= time()
Local cHeaderRet	:= ""
Local nStatuHttp 	:= 0
local nTimeOut		:= 600

aadd( aHeadStr, 'Content-Type: application/json')

U_MFCONOUT('Lendo requisições...') 
U_MFCONOUT('URL...: ' +  cURLInteg)

cHttpRet := httpQuote( cURLInteg /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
cTimeFin	:= time()
cTimeProc	:= elapTime(cTimeIni, cTimeFin)

nStatuHttp := httpGetStatus()

U_MFCONOUT('Status http...:' + alltrim(str(nStatuHttp))) 

If nStatuHttp < 200 .or. nStatuHttp > 299
	U_MFCONOUT('Erro na leitura de requisições!')	
	Return
Endif
	
If len(cHttpRet) = 6 
	U_MFCONOUT('Não há requisições pendentes!')	
	Return
Endif
	
If nStatuHttp >= 200 .and. nStatuHttp <= 299

	jCustomer := nil
	if fwJsonDeserialize( cHttpRet, @jCustomer )
	
		//Verifica se já tem integração com mesmo Token gravada na ZH1
		ZH1->(Dbsetorder(3)) //ZH1_TOKEN
		If ZH1->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))
			
			U_MFCONOUT('Token ' +Alltrim(JCUSTOMER:TOKEN) + ' para a requisição ' + JCUSTOMER:ITEN:REQUISICAO + ' já gravado na tabela intermediária!')	

			//Se o token está com status T mas ainda na lista marca para reenviar token para que saia da lista
			If ZH1->ZH1_STATUS = "T"
				Reclock("ZH1",.F.)
				ZH1->ZH1_STATUS := "S"
				ZH1->(Msunlock())
			Endif

			Return
		
		Else
		
			U_MFCONOUT('Gravando token ' +Alltrim(JCUSTOMER:TOKEN) + ' para a requisição ' + JCUSTOMER:ITEN:REQUISICAO + ' na tabela intermediária...')	

			// Para buscar a Empresa e Filial
			If Len(JCUSTOMER:ITEN:BORGS) = 2
				For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

					cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG
					n := Len(JCUSTOMER:ITEN:BORGS)  + 1
				Next
			Endif

			_cpcprot := " "


			BEGIN TRANSACTION

			Reclock("ZH1",.T.)
			ZH1->ZH1_FILIAL := cfilant
			ZH1->ZH1_PREPED := JCUSTOMER:ITEN:REQUISICAO
			ZH1->ZH1_PCPROT := ""
			ZH1->ZH1_JSONE := cHttpRet
			ZH1->ZH1_DATAE := date()
			ZH1->ZH1_HORAE := time()
			ZH1->ZH1_TOKEN := Alltrim(JCUSTOMER:TOKEN) 
			ZH1->ZH1_URLE := cURLInteg
			ZH1->(Msunlock())

			END TRANSACTION

			U_MFCONOUT('Completou gravação do token ' +Alltrim(JCUSTOMER:TOKEN) + ' para a requisição ' + JCUSTOMER:ITEN:REQUISICAO + ' na tabela intermediária...')	

		Endif

	Else

		U_MFCONOUT('Erro na leitura de requisições!')	
		Return

	Endif

Else

	U_MFCONOUT('Erro na leitura de requisições!')	
	Return

Endif

Return

/*{Protheus.doc} MGFWSC49E	 
Execução da integracao de Requisições de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
static function MGFWSC49E()

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
	Private lAutoErrNoFile := .T.
	private aLog  := {}
	Private cvar  := " "
	Private nrats := 0 
	Private crats := 0
	Private cXrat  :=  "2" // Nao rateio

	cQuery := " SELECT ZH1_FILIAL,ZH1_PREPED, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZH1")
	cQuery += "  WHERE ZH1_STATUS  = ' '"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZH1TMP") > 0
		ZH1TMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZH1TMP", .F., .T.)
	
	If ZH1TMP->(eof())	
		U_MFCONOUT("Não existem pre pedidos pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando pre pedidos pendentes de processamento...")
		_ntot := 0
		Do while ZH1TMP->(!eof())
			_ntot++
			ZH1TMP->(Dbskip())
		Enddo
		ZH1TMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZH1TMP->(!eof())	
		
		U_MFCONOUT("Processando requisição " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZH1->(Dbgoto(ZH1TMP->RECN))

		jCustomer := nil
		if fwJsonDeserialize( ZH1->ZH1_JSONE, @jCustomer )
	
			cJsonRet := ZH1->ZH1_JSONE
	
			For X := 1 to Len(JCUSTOMER:ITEN:ITENSREQUISICAO)  
	
				//Valida se tem campo de filial
				If Len(JCUSTOMER:ITEN:BORGS) < 2
		
					cempant := '01'
					cfilant := '010041'
				
				Else

					// Para buscar a Empresa e Filial
					For N := 1 to Len(JCUSTOMER:ITEN:BORGS)

						cfilant := JCUSTOMER:ITEN:BORGS[N+1]:CODIGOBORG
						//cEmpant := SUBSTR(JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG,1,2)
						cEmpant := JCUSTOMER:ITEN:BORGS[N]:CODIGOBORG
						n := Len(JCUSTOMER:ITEN:BORGS)  + 1
					Next N

				Endif

				IF cfilant $ cFilblq //"010041|010045|020003"

					cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU),  "
					cQuery += " (SELECT MAX(D1_DTDIGIT) FROM " + RetSqlName("SD1") + " WHERE D1_COD=B2_COD AND D1_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD1, "
					cQuery += " (SELECT MAX(D2_EMISSAO) FROM " + RetSqlName("SD2") + " WHERE D2_COD=B2_COD AND D2_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD2, "
					cQuery += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
					cQuery += " AND D3_CF IN ('RE1','RE5','RE0') ) AS DT_SD3 "
					cQuery += " From " + RetSqlName("SB2") + " "
					cQuery += " WHERE B2_QATU<>0 AND B2_COD='"+JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO+"' AND B2_FILIAL='"+cfilant+"' "	
					cQuery += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
	
				ELSE	         

					cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU),  "
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

				Do While TEMP1->(!Eof())

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
					if cNum > nDias .AND. !(cfilant $ cFilblq)
						conout("Produto nesta filial não movimentado a mais de 90 dias, solicitação recusada. ")
						cMsg := cMsg + 	"Produto " + JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO
						cMsg := cMsg + " na filial " + cfilant + " com saldo não movimentado a mais de 90 dias, solicitação recusada. "			
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

					Do While TEMP2->(!Eof())

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

								cMsg := cMsg + "Unid. "+ TEMP2->B2_FILIAL + " Qtd. ["+ TRANS(TEMP2->SALDO,'999999') +"] </br>   " //+ CHR(13+CHR(10))

							Endif

						ENDIF         

						TEMP2->(dbSKIP())

					EndDo				

				Endif

				// Verificar aqui o Status se algum está errado a classe de valor
				if cStatus <> "108"
	
					For t := 1 to len (JCUSTOMER:ITEN:ITENSREQUISICAO)

						If ! Empty(JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:ValorAtributo) ;
							.and. JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:NomeAtributo == "Classe" 

							cStClas := POSICIONE("CTH",1,Space(6)+Alltrim(JCUSTOMER:ITEN:ITENSREQUISICAO[T]:Atributos[1]:ValorAtributo),"CTH_CLVL")

							If Empty(cStClas)
								cClas := .t.
								cStatus := "108"
								t := len (JCUSTOMER:ITEN:ITENSREQUISICAO)
							Endif

						Endif

					Next t

					If ! cClas
						cStatus := "1"
					Endif

				endif

				// Verificação Fim Estoque
				If Empty(cMsg)
					cMsg := "CONSULTA DE ESTOQUE PROTHEUS </br> REALIZADA SEM ESTOQUE "
				Endif

				// Em Negrito
				cMsg := " <p><strong>"+ cMsg +  "</strong></p>"

				AAdd(aRetorno,{JCUSTOMER:ITEN:ITENSREQUISICAO[X]:NUMEROITEM , JCUSTOMER:ITEN:ITENSREQUISICAO[X]:CODIGO_PRODUTO , Val(JCUSTOMER:ITEN:ITENSREQUISICAO[X]:QUANTIDADE) , cMsg , JCUSTOMER:ITEN:ITENSREQUISICAO[X]:Atributos[1]:ValorAtributo })

			next x

			cjson := " "

			cjson +='   {                                  '
			cjson +='  	"MSGREQUISICAO": {                 '
			cjson +='	"REQUISICAO": "' + JCUSTOMER:ITEN:REQUISICAO + '"           ,'
			cjson +='	"TAGREQUISITANTE": "' + JCUSTOMER:ITEN:TAGREQUISITANTE + '"            ,'

			If cStatus == "1"
				cjson +='	"STATUS": "0"                  ,'//ESTAVA 1 09_01_2020
			Else
				cjson +='	"STATUS": "108"                  ,'//ESTAVA 1 09_01_2020
			EndIf

			cjson +='	"ALTERACAO": "T"                  ,'

			cjson +=' "Atributos" :[{        '

			cjson +=' "NomeAtributo": "VERIFICADO_ESTOQUE"         ,'

			If cStatus == "1"
				cjson +=' "ValorAtributo": "Sim"         '
			Else
				cjson +=' "ValorAtributo": "Não"         '
			Endif

			cjson +=' }],        '

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

				cjson += ' { "NomeAtributo": "Observação_ERP"  ,'

				If ! Empty(POSICIONE("CTH",1,space(6)+Alltrim(aRetorno[b,5]),"CTH_CLVL")) 
					cjson +='	"ValorAtributo": "' + aRetorno[b,4]   + '"                          }]} '
				Else				
					cjson +='	"ValorAtributo": "CLASSE DE VALOR INEXISTENTE - > ' + aRetorno[b,5] + ' "   }]}'
				Endif

			Next b

			cjson +='	],                               '

			cjson +='	"BORGS": [{                        '
			cjson +='	"CAMPOVENT" :"EMPRESA"              ,'
			cjson +='	"CODIGOBORG" :"' + cEmpant + '"   }, '

			cjson +='   {"CAMPOVENT" :"FILIAL"            , '
			cjson +='	"CODIGOBORG" :"' + cFilant + '"   } '

			cjson +='	]}}    


			//Grava o resultado na tabela intermediária
			ZH1->(Dbsetorder(3)) //ZH1_TOKEN
			If ZH1->(Dbseek(Alltrim(JCUSTOMER:TOKEN)))

				Reclock("ZH1",.F.)
				ZH1->ZH1_STATME 	:= cStatus
				ZH1->ZH1_DATAP 		:= DATE()
				ZH1->ZH1_HORAP 		:= TIME()
				ZH1->ZH1_STATUS 	:= 'P'
				ZH1->ZH1_JSONR		:= cjson
				ZH1->(Msunlock())

			Endif

		Endif

		ZH1TMP->(!Dbskip())	

	Enddo

Return

/*/{Protheus.doc} MGFWSC49S 
Envio de status de Requisições de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC49S()

cQuery := " SELECT ZH1_FILIAL,ZH1_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZH1")
cQuery += "  WHERE ZH1_STATUS  = 'P'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZH1TMP") > 0
	ZH1TMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZH1TMP", .F., .T.)
	
If ZH1TMP->(eof())	
	U_MFCONOUT("Não existem requisições pendentes de retorno de status!")
	Return
Else
	U_MFCONOUT("Contando requisições pendentes de retorno de status...")
	_ntot := 0
	Do while ZH1TMP->(!eof())
		_ntot++
		ZH1TMP->(Dbskip())
	Enddo
	ZH1TMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZH1TMP->(!eof())	

	ZH1->(Dbgoto(ZH1TMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando status para requisição "  + alltrim(ZH1->ZH1_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	
	cUrl 		:= GetMv("MGF_WSC49A")
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

	cjson := alltrim(ZH1->ZH1_JSONR)

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

		Reclock("ZH1",.F.)
		ZH1->ZH1_DATAR	 	:= DATE()
		ZH1->ZH1_HORAR	 	:= TIME()
		ZH1->ZH1_JSONR 		:= cJson
		ZH1->ZH1_URLR 		:= cUrl
		ZH1->ZH1_RETORR 	:= xPostRet
		ZH1->ZH1_STATUS 	:= 'S'
		ZH1->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do status para pre pedido "  + alltrim(ZH1->ZH1_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZH1TMP->(Dbskip())

Enddo

Return

/*/{Protheus.doc} MGFWSC49T 
Envio de tokens de requisicoes de Compra
@type function

@author Anderson Reis 
@since 09/03/2020
*/
Static Function MGFWSC49T()

cQuery := " SELECT ZH1_FILIAL,ZH1_PREPED, R_E_C_N_O_ AS RECN "
cQuery += " FROM " + RetSqlName("ZH1")
cQuery += "  WHERE ZH1_STATUS  = 'S'"
cQuery += "  AND D_E_L_E_T_= ' ' "

If select("ZH1TMP") > 0
	ZH1TMP->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZH1TMP", .F., .T.)
	
If ZH1TMP->(eof())	
	U_MFCONOUT("Não existem requisicoes pendentes de envio de token!")
	Return
Else
	U_MFCONOUT("Contando requisicoes pendentes de envio de token...")
	_ntot := 0
	Do while ZH1TMP->(!eof())
		_ntot++
		ZH1TMP->(Dbskip())
	Enddo
	ZH1TMP->(Dbgotop())
Endif
	
_nnt := 1

Do while ZH1TMP->(!eof())	

	ZH1->(Dbgoto(ZH1TMP->RECN))

	BEGIN TRANSACTION

	U_MFCONOUT("Retornando token para requisicao "  + alltrim(ZH1->ZH1_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")

    cUrl	 := Alltrim(GetMv("MGF_WSC44B"))+Alltrim(ZH1->ZH1_TOKEN) 
	cHeadRet 	:= ""
	aHeadOut	:= {}
	cTimeIni	:= ""
	cTimeProc	:= ""
	xPostRet	:= Nil
	nTimeOut    := 240

	aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')
	aadd( aHeadOut, 'Authorization: "' + Alltrim(ZH1->ZH1_TOKEN) + '" ')
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

		Reclock("ZH1",.F.)
		ZH1->ZH1_DATAT	 	:= DATE()
		ZH1->ZH1_HORAT	 	:= TIME()
		ZH1->ZH1_URLT 		:= cUrl
		ZH1->ZH1_RETORT 	:= xPostRet
		ZH1->ZH1_STATUS 	:= 'T'
		ZH1->(Msunlock())

	Endif

	END TRANSACTION

	U_MFCONOUT("Completou envio do token para pre pedido "  + alltrim(ZH1->ZH1_PREPED) + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	_nnt++
	ZH1TMP->(Dbskip())

Enddo

Return

