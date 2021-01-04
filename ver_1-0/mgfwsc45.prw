#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC45	
Integração Protheus-ME, para envio dos Produtos
@type function

@author Anderson Reis
@since 26/02/2020
@version P12
@history Alteracao 20/03 - Mudança da regra de Produtos 
@history_1  Retirar caracteres de aspas dupla e tabalução no campo do complemento 
/*/

User function MGFWSC45()

	Private _aMatriz  	:= {"01","010001"}  
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"  
	
	IF _lIsBlind  

	RPCSetType( 3 )
	RpcSetEnv(_aMatriz[1],_aMatriz[2])
	
	If !LockByName("u_MGFWSC45")
			Conout("JOB já em Execução: MGFWSC45 " + DTOC(dDataBase) + " - " + TIME() )
			RpcClearEnv()
			Return
	EndIf  
	   
		conOut("********************************************************************************************************************"+ CRLF	)       
		conOut('------- Inicio do processamento - MGFWSC45 - Integração ME - Produto - ' + DTOC(dDataBase) + " - " + TIME()		)
		conOut("********************************************************************************************************************"+ CRLF	)       
	
	RUNINTEG45()
	
	conOut("********************************************************************************************************************"+ CRLF	)       
	conOut("------- Fim - MGFWSC45 - Integração ME - Produto - " + DTOC(dDataBase) + " - " + TIME()  				  		)
	conOut("********************************************************************************************************************"+ CRLF	)       
	
	RpcClearEnv()
	UnLockByName(ProcName())

	Endif
     
    	RUNINTEG45()
Return

Static Function RUNINTEG45() 


	Local cQ 		:= ""
	Local cAliasTrb := GetNextAlias()

	Local cUrl 		:= " "
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}

	Local cJson		:= ""
	Local oJson		:= Nil

	Local cTimeIni	:= ""
	Local cTimeProc	:= ""

	Local xPostRet	:= Nil
	Local nStatuHttp	:= 0
	local nTimeOut		:= 120
	Local cCodok  := " " 
	    
	cUrl := Alltrim(GetMv("MGF_WSC45")) 

	// INCLUSAO
	cQ := " SELECT B1_COD,B1_DESC,B1_MGFFAM,B1_UM,B1_POSIPI,B1_TIPO,B1_MSBLQL,B1_ZPEDME,B1_ORIGEM,"
	CQ += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,200,1)) COD ,B1_FILIAL ,'INCLUSAO' as STATUS  "
	cQ += " FROM "+RetSqlName("SB1")+" A "
	cQ += " WHERE  B1_ZPEDME = ' ' AND D_E_L_E_T_ = ' ' AND B1_MGFFAM <> ' '  AND B1_MSBLQL <> '1'"
	cQ += " AND B1_COD >= '500000'   "
	
	
	cQ += "  UNION ALL "

	// ALTERACAO
	cQ += " SELECT B1_COD,B1_DESC,B1_MGFFAM,B1_UM,B1_POSIPI,B1_TIPO,B1_MSBLQL,B1_ZPEDME,B1_ORIGEM,"
	CQ += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,200,1)) COD ,B1_FILIAL ,'ALTERACAO' as STATUS "
	cQ += " FROM "+RetSqlName("SB1")+" A "
	CQ += " WHERE  B1_ZPEDME = 'A' AND D_E_L_E_T_ = ' ' AND B1_MGFFAM <> ' ' "
	cQ += " AND B1_COD >= '500000' "
	
	cQ += " UNION ALL "

	// EXCLUSAO
	cQ += " SELECT B1_COD,B1_DESC,B1_MGFFAM,B1_UM,B1_POSIPI,B1_TIPO,B1_MSBLQL,B1_ZPEDME,B1_ORIGEM,"
	CQ += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,200,1)) COD ,B1_FILIAL,'EXCLUSAO' as STATUS  "
	cQ += " FROM "+RetSqlName("SB1")+" A "
	cQ += " WHERE  B1_ZPEDME = 'D' AND D_E_L_E_T_ = '*' AND B1_MGFFAM <> ' ' "
	cQ += " AND B1_COD >= '500000' "  
	
	cQ := ChangeQuery(cQ)
    
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)
		
	aadd( aHeadOut, 'Content-Type: application/json' )
	
	conout(" [MGFWSC45] * * * * * Status da integracao PRODUTO * * * * *")
	conout("   [PRODUTO] URL..........................: " + cUrl			)
	conout("   [PRODUTO] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout("   [PRODUTO] Query........................: " + allTrim( cq ) 					)

	While (cAliasTrb)->(!Eof())

		conout("   [PRODUTO] Produto * * "+alltrim((cAliasTrb)->B1_COD))

		cjson := " "
		oJson						  := JsonObject():new()

		// VERSAO CAMPOS DA PLANILHA

		cjson +='   {                                                           													      '
		cjson +='  	"MSGPRODUTO": {                                             													      '

		cjson +='	"IDINTEGRACAO"           : "' + alltrim((cAliasTrb)->B1_COD) + '"     												 ,'
		cjson +='	"CODIGO"                 : "' + alltrim((cAliasTrb)->B1_COD) + '"            										 ,'
		cjson +='	"CODPRODUTO"               : "' + alltrim((cAliasTrb)->B1_COD) + '"            										 ,'
		//history_1 : Tratamento do Aspas Duplas como erro na Integração
			
		cjson +='	"DESCRICAO"              : "' + STRTRAN(alltrim((cAliasTrb)->B1_DESC), CHR(34) ," ' " ) + '"     						 ,'
				
		cjson +='	"CODIGO_GRUPO"           : "' + alltrim((cAliasTrb)->B1_MGFFAM) + '"    												 ,'
		cjson +='	"DESCRICAO_GRUPO"        : "' + Alltrim(POSICIONE('ZFN',1, xFilial('ZFN') + alltrim((cAliasTrb)->B1_MGFFAM), 'ZFN_DESCRI')) + '" ,'
		cjson +='	"GENERICO"               : "N"                                             											 ,' // Sempre N
		cjson +='	"UNIDADE"                : "' + alltrim((cAliasTrb)->B1_UM) + '"          											 ,'
		
		// History_1 Tratamento de Aspas Duplas e tabulação
	    cCodok := STRTRAN(alltrim((cAliasTrb)->COD), CHR(34) ," ' " ) 
	   
	    cCodok := SUBSTRING(alltrim((cAliasTrb)->COD),1,LEN(alltrim((cAliasTrb)->COD)) - 2)
		
		cjson +='	"COMPLEMENTO"            :"' + cCodok  + '"               				 ,' // B1_ZPRODES
		cjson +='	"NBM"                    : "' + alltrim((cAliasTrb)->B1_POSIPI) + '"           										 ,'
		cjson +='   "SERVICO"                : "' + If(alltrim((cAliasTrb)->B1_TIPO) = "N","S","N") + '"   								 ,'


		If (cAliasTrb)->B1_MSBLQL <> '1' .AND. ((cAliasTrb)->B1_ZPEDME <> "A" )//Produto Novo

			cjson +='	"TIPOALTERACAO"          : "N"    	,'
			cjson +='	"STATUS"                 : "N"      ,'


		Elseif (cAliasTrb)->B1_MSBLQL = "1" .AND. (cAliasTrb)->B1_ZPEDME = "A"// Produto Bloqueado

			cjson +='	"TIPOALTERACAO"          : "S"      ,'
			cjson +='	"STATUS"                 : "B"      ,'

		Elseif (cAliasTrb)->B1_ZPEDME = "A" .AND.  (cAliasTrb)->B1_MSBLQL <> '1'

			cjson +='	"TIPOALTERACAO"          : "S"      ,'
			cjson +='	"STATUS"                 : "N"      ,'

		Endif


		cjson +='	"CONTACONTABIL"          : " "                                                                                       ,'
		cjson +='	"MARGEMTOLERANCIA"       : "0"                                             											 ,' // Sempre N
		cjson +='	"FLOW"                   : "0"                                             											 ,' // Sempre N
		cjson +='	"ORIGEMMATERIAL"         : "' + alltrim((cAliasTrb)->B1_ORIGEM) + '"     											 '

		cjson +='			}}                                                  '

		oJson:fromJson(cjson )
         
		cTimeIni := time()

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif


		nStatuHttp	:= 0
		
		nStatuHttp	:= httpGetStatus ()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )


		cQ := "UPDATE "
		cQ += RetSqlName("SB1")+" "
		cQ += "SET "
		if nStatuHttp >= 200 .and. nStatuHttp <= 299

			cQ += "B1_ZPEDME = 'S' "
			conout("     [PRODUTO] Atualizado Campo Personalizado (B1_ZPEDME) - Inclusao Produto.........: " + (cAliasTrb)->B1_COD 					)

		endif

		cQ += "WHERE B1_COD = '" + alltrim((cAliasTrb)->B1_COD) + "'    "

		nRet := tcSqlExec(cQ)

		If nRet == 0

		Else
			conout("Problemas na gravação dos campos do cadastro de produto, para envio ao ME.")

		EndIf

		Reclock("ZF1",.T.)

		ZF1->ZF1_FILIAL :=	alltrim((cAliasTrb)->B1_FILIAL)  
		ZF1->ZF1_INTERF	:=	"PR"
		ZF1->ZF1_DATA	:=	dDataBase  
		ZF1->ZF1_PREPED	:=	" "
		ZF1->ZF1_PEDIDO	:=	" "
		ZF1->ZF1_NOTA	:=	alltrim((cAliasTrb)->B1_COD)  
		ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
		ZF1->ZF1_ERRO	:=	Alltrim(xPostRet)
		ZF1->ZF1_JSON	:=	cJson
		ZF1->ZF1_HORA	:=	time()
		ZF1->ZF1_TOKEN	:=	" "

		Msunlock ()

		freeObj( oJson )

		conout("   [PRODUTO] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )
		conout("   [PRODUTO] Tempo de Processamento.......: " + cTimeProc 							)
		conout("   [PRODUTO] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
		conout("   [PRODUTO] cJson........................: " + allTrim( cJson ) 					)
		conout("   [PRODUTO] STATUS........................: " + (cAliasTrb)->STATUS)
		conout("   [PRODUTO] * * * * * * * FIM - PRODUTO * * * * * * * * * * * * * "	    	)

		(cAliasTrb)->(dbSkip())
	EndDo

	(cAliasTrb)->(dbCloseArea())

Return()