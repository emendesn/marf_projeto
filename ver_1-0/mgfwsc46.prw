#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC46
Integracao Protheus-ME, para envio de Fornecedor
@type function

@author Anderson Reis
@since 26/02/2020
@version P12
@history_1 . Ajuste para acerto do CNPJ	
/*/

User function MGFWSC46()

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	conout('[MGFWSC46] Iniciada Threads para a empresa - 01 - ' + dToC(dDataBase) + " - " + time())

	RUNINTEG46()

	RESET ENVIRONMENT
return


Static Function RUNINTEG46()

	Local cQ 		:= ""
	Local cAliasTrb := GetNextAlias()
	
	Local cUrl 		:= " "//Alltrim(GetMv("MGF_MEFORN"))//"https://spdwvapl203:8059/api/fornecedor"//
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}

	Local cJson		:= ""
	Local oJson		:= Nil

	Local cTimeIni	:= ""
	Local cTimeProc	:= ""

	Local xPostRet	:= Nil
	Local nStatuHttp	:= 0
	local nTimeOut		:= 120

	Local nAt           := 0

	Local nvezes        := 0
	local cTimeFin		:= ""


	cUrl := Alltrim(GetMv("MGF_WSC46")) 
	// INCLUSAO
	cQ := " SELECT A2_COD,A2_LOJA,A2_NOME,A2_CONTATO,A2_END,A2_MUN,A2_BAIRRO,A2_EST,A2_TIPO,A2_CGC,A2_TEL,A2_EMAIL,A2_MSBLQL,A2_ZPEDME,A2_DDD,A2_ZINTME,A2_PAIS,A2_CEP,A2_FILIAL "
	cQ += " FROM "+RetSqlName("SA2")+" SA2 "
	cQ += " WHERE D_E_L_E_T_ = ' ' AND A2_ZINTME = 'S' AND A2_ZPEDME = ' '  AND A2_EMAIL <> ' '  "
 	
 	If Getmv("MGF_WSC46A") == "F"
 		cQ += " AND A2_EST <> 'EX' "
 	Endif
	
	cQ += "  UNION ALL "
	//ALTERCAO
	cQ += " SELECT A2_COD,A2_LOJA,A2_NOME,A2_CONTATO,A2_END,A2_MUN,A2_BAIRRO,A2_EST,A2_TIPO,A2_CGC,A2_TEL,A2_EMAIL,A2_MSBLQL,A2_ZPEDME,A2_DDD,A2_ZINTME,A2_PAIS,A2_CEP,A2_FILIAL "
	cQ += " FROM "+RetSqlName("SA2")+" SA2 "
	cQ += " WHERE A2_ZPEDME = 'A' AND D_E_L_E_T_ = ' ' AND A2_EMAIL <> ' ' AND A2_ZINTME = 'S'  "

	If Getmv("MGF_WSC46A") == "F"
 		cQ += " AND A2_EST <> 'EX' "
 	Endif

	cQ += " UNION ALL "
	// EXCLUSAO
	cQ += " SELECT A2_COD,A2_LOJA,A2_NOME,A2_CONTATO,A2_END,A2_MUN,A2_BAIRRO,A2_EST,A2_TIPO,A2_CGC,A2_TEL,A2_EMAIL,A2_MSBLQL,A2_ZPEDME,A2_DDD,A2_ZINTME,A2_PAIS,A2_CEP,A2_FILIAL"
	cQ += " FROM "+RetSqlName("SA2")+" SA2 "
	cQ += "WHERE A2_ZPEDME = 'D' AND D_E_L_E_T_ = '*' AND A2_EMAIL <> ' ' AND A2_ZINTME = 'S' "

	If Getmv("MGF_WSC46A") = "F"
 		cQ += " AND A2_EST <> 'EX' "
 	Endif

	cQ := ChangeQuery(cQ)
	conout("Query"+cq)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.F.,.F.)
	aadd( aHeadOut, 'Content-Type: application/json' )

	conout(" [MGFWSC46] * * * * * Status da integracao - Fornecedor * * * * *"								)
	
	While (cAliasTrb)->(!Eof())
		cjson := " "

		oJson						  := JsonObject():new()
		
		cjson +='   {                                                                       '
		cjson +=' "MSGFORNECEDOR": {                                                        '
		cjson +='  "ID": "' + (cAliasTrb)->A2_COD + (cAliasTrb)->A2_LOJA + '"       ,'
		cjson +=' "FORNECEDORCLIENTE": "' + (cAliasTrb)->A2_COD + (cAliasTrb)->A2_LOJA + '"  ,' 
		cjson +=' "NOME":  "' + Substr(alltrim((cAliasTrb)->A2_NOME),1,20) + '"            ,'
		cjson +=' "RAZAO": "' + Substr(alltrim((cAliasTrb)->A2_NOME),1,20) + '"            ,'
		cjson +=' "CONTATO": "' + alltrim((cAliasTrb)->A2_CONTATO) + '"                    ,'
		cjson +=' "ENDERECO":  "' + alltrim((cAliasTrb)->A2_END) + '"                      ,'
		cjson +='  "CIDADE": "' + alltrim((cAliasTrb)->A2_MUN) + '"                        ,'
		cjson +=' "REGIAO": "' + alltrim((cAliasTrb)->A2_BAIRRO) + '"                      ,'
		cjson +=' "ESTADO": "' + alltrim((cAliasTrb)->A2_EST) + '"                         ,'

		cjson +=' "PAIS": "' + POSICIONE("SYA", 1, xFilial("SYA") + alltrim((cAliasTrb)->A2_PAIS) , "YA_ZSIGLA") + '"                                                             ,' // VERIFICAR OUTRO PAIS

		cjson +=' "CEP": "' + alltrim((cAliasTrb)->A2_CEP) + '"                            ,'
		cjson +='  "TELEFONE": "' + alltrim((cAliasTrb)->A2_DDD) + alltrim((cAliasTrb)->A2_TEL) + '"                      ,'

		nAt := AT( ",",  alltrim((cAliasTrb)->A2_EMAIL))

		If nAt > 0

			cjson +='  "EMAIL": "' + Substring(alltrim((cAliasTrb)->A2_EMAIL),1,nat - 1 ) + '"  ,'


		Else

			cjson +='  "EMAIL": "' + alltrim((cAliasTrb)->A2_EMAIL) + '"  ,'


		Endif

		nAt := AT( ",", alltrim((cAliasTrb)->A2_EMAIL)) 


		If nAt > 0

			cjson +='  "EMAILSADICIONAIS": "' + Substring(alltrim((cAliasTrb)->A2_EMAIL),nat + 1,LEN(alltrim((cAliasTrb)->A2_EMAIL))) + '"  ,'


		Else

			cjson +=' "EMAILSADICIONAIS": " ",'

		Endif
		// hISTORY_1
		If (cAliasTrb)->A2_PAIS == "105"  // Brasil
			
			cjson +=' "CNPJ": "' + alltrim((cAliasTrb)->A2_CGC) + '"                         ,'
			cjson +=' "INTERNACIONAL": "0"                       ,'

		ElseIF (cAliasTrb)->A2_PAIS == "249"  // EUA
			
			cjson +=' "CNPJ": " "                   ,'
			cjson +=' "INTERNACIONAL": "1"                       ,'
		Else // diferente de EUA e Brasil
			
			cjson +=' "CNPJ": " "                    ,'
			cjson +=' "INTERNACIONAL": "2"                       ,'
		Endif
		
		cjson +=' "IE": ""                                                                 ,'

		If alltrim((cAliasTrb)->A2_MSBLQL) = '1'
			cjson +=' "BLOQUEADO": "S"                                                          ,'
		Else
			cjson +=' "BLOQUEADO": "N"                                                          ,'
		Endif

		If alltrim((cAliasTrb)->A2_ZPEDME) = "A"
			cjson +=' "TIPOALTERACAO": "S"                                                       '
		Elseif alltrim((cAliasTrb)->A2_ZINTME) = "S"
			cjson +=' "TIPOALTERACAO": "N"                                                       '
		Else
			cjson +=' "TIPOALTERACAO": " "                                                       '

		Endif

		cjson +=' }}'

		oJson:fromJson(cjson )

		conout(cJson)
		cTimeIni := time()

		if !empty( cJson )
		conout("post . "+(cAliasTrb)->A2_COD)
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif
	

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()
		
		If nStatuHttp = 10061
			conout ("API FORA")
		Endif
		cTimeFin	:= time()



		If AllTrim( str( nStatuHttp ) ) == '200' 
			
			cQ := "UPDATE "
			cQ += RetSqlName("SA2")+" "
			cQ += "SET "
			cQ += " A2_ZPEDME = 'S' "
			cQ += " WHERE A2_COD =  '" + alltrim((cAliasTrb)->A2_COD) + "' AND A2_LOJA = '" + alltrim((cAliasTrb)->A2_LOJA) + "'   "

			nRet := tcSqlExec(cQ)
			

			If nRet == 0
				conout("Update"+alltrim((cAliasTrb)->A2_COD + alltrim((cAliasTrb)->A2_LOJA)))
			Else
				Conout("Problemas na gravacao dos campos do cadastro do ME, para envio ao ME.")

			EndIf
		Else
			CONOUT ("nao atualizado FORNECEDOR"+alltrim((cAliasTrb)->A2_COD + alltrim((cAliasTrb)->A2_LOJA)))
			


		Endif


		Reclock("ZF1",.T.)

		ZF1->ZF1_FILIAL :=	alltrim((cAliasTrb)->A2_FILIAL)  
		ZF1->ZF1_INTERF	:=	"FR"
		ZF1->ZF1_DATA	:=	dDataBase  
		ZF1->ZF1_PREPED	:=	" "
		ZF1->ZF1_PEDIDO	:=	" "
		ZF1->ZF1_NOTA	:=	alltrim((cAliasTrb)->A2_COD)  
		ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
		ZF1->ZF1_ERRO	:=	Alltrim(xPostRet)
		ZF1->ZF1_JSON	:=	cJson
		ZF1->ZF1_HORA	:=	time()
		ZF1->ZF1_TOKEN	:=	" "

		Msunlock ()


		freeObj( oJson )

		(cAliasTrb)->(dbSkip())
	EndDo

	(cAliasTrb)->(dbCloseArea())

Return()