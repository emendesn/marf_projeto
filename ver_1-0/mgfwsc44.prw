#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC44
Integração Protheus-ME, para envio do Cadastro de Centro de Custo 
Em produção flag no campo CTT_ZPEDME e não flag CTT_BLOQ  = 1

@type function
@author Anderson Reis
@since 26/02/2020
@version P12
/*/

User function MGFWSC44()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

	conout('[MGFWSC44] Iniciada Threads (CENTRO DE CUSTO) - ' + dToC(dDataBase) + " - " + time())

	RUNINTEG44()

return


Static Function RUNINTEG44()

	Local cQ 		  := ""                                 // Utilizado na Query
	Local cAliasTrb   := GetNextAlias()                     // Utilizado na Query

	// URL de Integração Centro de Custo entre a ME e Marfrig
	Local cUrl 		  := " "      //  https://spdwvapl203:8059/api/centroCusto
	Local cHeadRet 	  := ""                                 //  Utilizado na função HTTPQuote
	Local aHeadOut    := {}								    //  Utilizado na função HTTPQuote

	Local cJson		  := "" 								//  Utilizado na função HTTPQuote
	Local oJson		  := Nil								//  Utilizado na função HTTPQuote

	Local cTimeIni	  := ""                                 // Variável de Inicio de Tempo Integração
	Local cTimeProc	  := ""                                 // Variável de Fim Tempo Integração

	Local xPostRet	  := Nil                                // Retorno da Função HTTPQuote
	Local nStatuHttp  := 0                                  // Retorno Status Integração
	local nTimeOut	  := 120                                // Utilizado na função HTTPQuote
	Local nVezes      := 0                                  // Utilizado no Conout
	
	Local aPergs	:= {}
	Local aRet      := {}
	Local cmens     := " "

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------

	cUrl := Alltrim(GetMv("MGF_WSC44")) 

	// Validação se encontra o Parametro

	If Empty(cUrl)
		ConOut("Não encontrado parâmetro 'MGF_WSC44'.")
		Return()
	Endif

	// Serão 3 queries Inclusao / Alteracao (CTT_BLOQ) / Exclusao

	// Inclusao
	cQ := " SELECT CTT_FILIAL,CTT_CUSTO,CTT_DESC01,CTT_DTEXIS,CTT_DTEXSF,CTT_BLOQ,'INCLUSAO' as STATUS
	cQ += " FROM "+RetSqlName("CTT")+" CTT "
	cQ += " WHERE "
	cQ += " CTT.D_E_L_E_T_ = ' ' " 
	cQ += " AND CTT.CTT_BLOQ <> '1' AND CTT.CTT_ZPEDME = ' ' "	

	cQ += " UNION ALL "

	// Exclusao
	cQ += " SELECT CTT_FILIAL,CTT_CUSTO,CTT_DESC01,CTT_DTEXIS,CTT_DTEXSF,CTT_BLOQ,'EXCLUSAO' as STATUS"
	cQ += " FROM "+RetSqlName("CTT")+" CTT "
	cQ += " WHERE "
	cQ += "  CTT.D_E_L_E_T_ = '*'  AND CTT.CTT_ZPEDME = 'D' " 


	cQ += " UNION ALL "

	// Alteração 
	cQ += " SELECT CTT_FILIAL,CTT_CUSTO,CTT_DESC01,CTT_DTEXIS,CTT_DTEXSF,CTT_BLOQ,'ALTERACAO' as STATUS "
	cQ += " FROM "+RetSqlName("CTT")+" CTT "
	cQ += " WHERE "
	cQ += "  (CTT.CTT_BLOQ  = '1' AND  CTT.CTT_ZPEDME = 'S'  AND D_E_L_E_T_ =  ' ') OR  " 
	cQ += "  (CTT.CTT_BLOQ  = '2' AND  CTT.CTT_ZPEDME = 'A'  AND D_E_L_E_T_ =  ' ') " 


	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)
	aadd( aHeadOut, 'Content-Type: application/json' )
	
	dbSelectarea('CTT')
	CTT->(dbSetOrder(1))

	//conout("[MGFWSC44] * * * * * Status da integracao - CENTRO DE CUSTO * * * * *"	     			  )
	conout("	* URL..........................: " + cUrl								  )
	conout("	* Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout("	* Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		  )
	conout("	* Query........................: " + allTrim( cq ) 					      )


	While (cAliasTrb)->(!Eof())

		nVezes++
		cJson	:= ""
		oJson	:= JsonObject():new()

		cjson +='   {                                                                               '
		cjson +='  	"MSGCENTROCUSTOS" : {                                                           '
		cjson +='	"ISLOADED"        : false                                                      ,'
		cjson  +='	"IDINTEGRACAO"    :  "' + alltrim((cAliasTrb)->CTT_CUSTO) + '"                 ,'
		cjson  +='	"CODIGO_CC"       : "' + alltrim((cAliasTrb)->CTT_CUSTO) + '"                  ,'
		cjson  +='	"DESCRICAO_CC"    : "' + Substr(alltrim((cAliasTrb)->CTT_DESC01),1,40) + '"    ,'

		If (cAliasTrb)->STATUS = "INCLUSAO"
			cjson +='	"DESABILITADA"     :"N"                                                     ,'
		Else
			cjson +='	"DESABILITADA"     :"S"                                                     ,'
		EndIf

		If ! Empty((cAliasTrb)->CTT_DTEXIS)

			cjson +='	"VALIDADE_DESDE":"' + Substring((cAliasTrb)->CTT_DTEXIS,1,4)+"-"+  ;
			Substring((cAliasTrb)->CTT_DTEXIS,5,2)+"-"+                                    ;
			Substring((cAliasTrb)->CTT_DTEXIS,7,2)+                                        ; 
			"T00:00:00-00:00" + '"                       ,'

		EndIf	 

		If ! Empty((cAliasTrb)->CTT_DTEXSF)

			cjson +='	"VALIDADE_ATE":"' + Substring((cAliasTrb)->CTT_DTEXSF,1,4)+"-"+ ;
			Substring((cAliasTrb)->CTT_DTEXSF,5,2)+"-"+ ;
			Substring((cAliasTrb)->CTT_DTEXSF,7,2)+     ;
			"T00:00:00-00:00" + '"  , '

		Endif
		//Foi chumbado pois não tem uma lógica , para buscar 020001/030001 . 
		cjson +='	"ORGANIZACAO_COMPRAS":""                                                       ,'
		cjson +='	"EMPRESA":""                                                                   ,'
		cjson +='	"CENTRO":""                                                                    ,'

		cjson +='  	"BORGITENS": [{                                                                 '
		cjson +='	"ISLOADED":false                                                               ,'
		cjson +='	"CAMPOVENT":"EMPRESA"                                                           ,'
		cjson +='	"CODIGOBORG": "01"                                                  ,'
		cjson +='	"CENTROCUSTO":"' + alltrim((cAliasTrb)->CTT_CUSTO) + '"                         '
		//cjson +='			}]}}                                                                    '
		cjson +='			},                                                                    '

		cjson +='			{                                                                    '
		// Foi chumbado pois não tem uma lógica , para buscar 020001/030001 . 
		cjson +='	"ISLOADED":false                                                               ,'
		cjson +='	"CAMPOVENT":"EMPRESA"                                                           ,'
		cjson +='	"CODIGOBORG": "02"                                                       ,'
		cjson +='	"CENTROCUSTO":"' + alltrim((cAliasTrb)->CTT_CUSTO) + '"                         '

		cjson +='			},                                                                    '

		cjson +='			{                                                                    '
		// Foi chumbado pois não tem uma lógica . 
		cjson +='	"ISLOADED":false                                                               ,'
		cjson +='	"CAMPOVENT":"EMPRESA"                                                           ,'
		cjson +='	"CODIGOBORG": "03"                                                  ,'
		cjson +='	"CENTROCUSTO":"' + alltrim((cAliasTrb)->CTT_CUSTO) + '"                         '

		cjson +='			   }                                                                '

		cjson +='		]}}                                                                    '

		oJson:fromJson(cjson )

		cTimeIni := time()

		If !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, ;
			cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/,;
			aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		Endif

		If !empty(xPostRet)
			conout("	* JSON ENVIADO........................: " + allTrim( cJson ) 					      )

		Else
			conout("	* ERRO        ........................: "     )


		Endif

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		cTimeFin	:= time()

		If AllTrim( str( nStatuHttp ) ) = '200'

			If CTT->(dbSeek(xFilial("CTT")+(cAliasTrb)->CTT_CUSTO ))


				Reclock("CTT",.F.)
				
					CTT->CTT_ZPEDME  := "S"// Gravação que foi Integrado

				
				Msunlock()

				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )
				conout("   [CENTRO_CUSTO] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
				conout("   [CENTRO_CUSTO] Tempo de Processamento.......: " + cTimeProc 							)

				conout("   [CENTRO_CUSTO] Atualizado Campo Personalizado (CTT_ZPEDME).........: " + (cAliasTrb)->CTT_CUSTO 					)

			Else 

				ConOut("Problemas na gravação dos campos do cadastro de veiculo, para envio ao ME.")


			Endif


		Endif

		// Será testado depois a tabela de Log

		Reclock("ZF1",.T.)

		ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")                                                                                                       
		ZF1->ZF1_FILIAL :=	(cAliasTrb)->CTT_FILIAL
		ZF1->ZF1_INTERF	:=	"CC"
		ZF1->ZF1_DATA	:=	dDataBase  
		ZF1->ZF1_PREPED	:=	" "
		ZF1->ZF1_PEDIDO	:=	" "
		ZF1->ZF1_METODO	:=	"POST"
		ZF1->ZF1_NOTA	:=	alltrim((cAliasTrb)->CTT_CUSTO)  
		ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
		ZF1->ZF1_ERRO	:=	Alltrim(xPostRet)
		ZF1->ZF1_JSON	:=	cJson
		ZF1->ZF1_HORA	:=	time()
		ZF1->ZF1_TOKEN	:=	(cAliasTrb)->STATUS


		Msunlock () 


		freeObj( oJson )

		(cAliasTrb)->(dbSkip())
	EndDo

	If nVezes = 0

		conout("	* NAO HÁ CENTRO DE CUSTOS PARA ENVIAR "	)
		conout("[MGFWSC44] * * * * * * * FIM - CENTRO DE CUSTO * * * * * * * * * * * * * "	    	)
	Else
		conout("[MGFWSC44] * * * * * * * FIM - CENTRO DE CUSTO * * * * * * * * * * * * * "	    	)
	Endif

	(cAliasTrb)->(dbCloseArea())

Return()

