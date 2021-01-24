#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSC45	
Integracao Protheus-ME, para envio dos Produtos
@type function

@author Anderson Reis
@since 26/02/2020
@version P12
@history Alteracao 20/03 - Mudanca da regra de Produtos 
@history_1  Retirar caracteres de aspas dupla e tabulacaoo no campo do complemento 
/*/

User function MGFWSC45()

SetFunName("MGFWSC45")

U_MFCONOUT('Iniciando envio de produtos para Mercado Eletronico...') 
MGFWSC45E() 
U_MFCONOUT('Completou envio de produtos para Mercado Eletronico...') 	
	
Return

//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFWSC45E - Envio de produtos para mercado eletronico
@author  Anderson Reis
@since 26/02/2020
*/
Static Function MGFWSC45E() 


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

	// INCLUSAO, ALTERACAO E HASH - Se teve mudança em qualquer campo o hash muda 
	cQ += " SELECT B1_COD,B1_DESC,B1_MGFFAM,B1_UM,B1_POSIPI,B1_TIPO,B1_MSBLQL,B1_ZPEDME,B1_ORIGEM,B1_ZBLQSC,"
	CQ += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,2000,1)) COD ,B1_FILIAL ,'ALTERACAO' as STATUS, "
	CQ += " ora_hash(B1_DESC||B1_MGFFAM||B1_UM||B1_POSIPI||B1_TIPO||B1_MSBLQL||B1_ORIGEM||B1_ZBLQSC "
	CQ += " ||UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,2000,1))) HASH "
	cQ += " FROM "+RetSqlName("SB1")+" A "
	CQ += " WHERE  (B1_ZPEDME = 'A' OR B1_ZPEDME = ' ' OR rtrim(ltrim(B1_ZDCATEG)) <>  "
	CQ += "        RTRIM(LTRIM(TO_CHAR(ora_hash(B1_DESC||B1_MGFFAM||B1_UM||B1_POSIPI||B1_TIPO||B1_MSBLQL||B1_ORIGEM||B1_ZBLQSC "                                            
	CQ += " ||UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,2000,1)))))) ) "
	CQ += " AND D_E_L_E_T_ = ' ' AND B1_MGFFAM <> ' ' "
	cQ += " AND B1_COD >= '500000'  AND B1_COD <= '999999'"
	
	cQ += " UNION ALL "

	// EXCLUSAO
	cQ += " SELECT B1_COD,B1_DESC,B1_MGFFAM,B1_UM,B1_POSIPI,B1_TIPO,B1_MSBLQL,B1_ZPEDME,B1_ORIGEM,B1_ZBLQSC,"
	CQ += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,2000,1)) COD ,B1_FILIAL,'EXCLUSAO' as STATUS,  "
	CQ += " ora_hash(B1_DESC||B1_MGFFAM||B1_UM||B1_POSIPI||B1_TIPO||B1_MSBLQL||B1_ORIGEM||B1_ZBLQSC "
	CQ += " ||UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(B1_ZPRODES,2000,1))) HASH "
	cQ += " FROM "+RetSqlName("SB1")+" A "
	cQ += " WHERE  B1_ZPEDME = 'D' AND D_E_L_E_T_ = '*' AND B1_MGFFAM <> ' ' "
	cQ += " AND B1_COD >= '500000' AND B1_COD <= '999999' "  
	
	cQ := ChangeQuery(cQ)
    
	U_MFCONOUT('Carregando produtos para envio...') 
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	U_MFCONOUT('Contando produtos para envio...') 
	//Conta envios a realizar
	_ntot := 0
	While (cAliasTrb)->(!Eof())
		_ntot++
		(cAliasTrb)->(Dbskip())
	Enddo

	(cAliasTrb)->(Dbgotop())
		
	aadd( aHeadOut, 'Content-Type: application/json' )
	
	_nni := 1

	While (cAliasTrb)->(!Eof())

		U_MFCONOUT('Enviando produto ' + alltrim((cAliasTrb)->B1_COD) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)+ "...") 
	
		cjson := " "
		oJson						  := JsonObject():new()

    	cCodok := STRTRAN(alltrim((cAliasTrb)->COD), CHR(34) ,"'" )  // Retirar aspas duplas
		cCodok := STRTRAN(alltrim(cCodok), CHR(59) ,"." )  // Retirar ponto e virgula
		cCodok := STRTRAN(alltrim(cCodok), CHR(13) ," " )  // Retirar CTRL-CHAR, code 13
		cCodok := alltrim(FwCutOff(cCodok,.F.)) // retirar quebra de linhas

		cdesc := STRTRAN(ALLTRIM((cAliasTrb)->B1_DESC), CHR(34) ,"'" )  // Retirar aspas duplas
		cdesc := STRTRAN(alltrim(cdesc), CHR(59) ,"." )  // Retirar ponto e virgula
		cdesc := STRTRAN(alltrim(cdesc), CHR(13) ," " )  // Retirar CTRL-CHAR, code 13
		cdesc := alltrim(FwCutOff(cdesc,.F.)) // retirar quebra de linhas

		cjson +='   {                                                           													      '
		cjson +='  	"MSGPRODUTO": {                                             													      '

		cjson +='	"IDINTEGRACAO"           : "' + alltrim((cAliasTrb)->B1_COD) + '"     												 ,'
		cjson +='	"CODIGO"                 : "' + alltrim((cAliasTrb)->B1_COD) + '"            										 ,'
		cjson +='	"CODPRODUTO"               : "' + alltrim((cAliasTrb)->B1_COD) + '"            										 ,'
	
		cjson +='	"DESCRICAO"              : "' + cdesc + '"     						 ,'
				
		cjson +='	"CODIGO_GRUPO"           : "' + alltrim((cAliasTrb)->B1_MGFFAM) + '"    												 ,'
		cjson +='	"DESCRICAO_GRUPO"        : "' + Alltrim(POSICIONE('ZFN',1, xFilial('ZFN') + alltrim((cAliasTrb)->B1_MGFFAM), 'ZFN_DESCRI')) + '" ,'
		cjson +='	"GENERICO"               : "N"                                             											 ,' // Sempre N
		cjson +='	"UNIDADE"                : "' + alltrim((cAliasTrb)->B1_UM) + '"          											 ,'
		
		cjson +='	"COMPLEMENTO"            :"' + cCodok  + '"               				 ,' // B1_ZPRODES
		cjson +='	"NBM"                    : "' + alltrim((cAliasTrb)->B1_POSIPI) + '"           										 ,'
		cjson +='   "SERVICO"                : "' + If(alltrim((cAliasTrb)->B1_TIPO) = "N","S","N") + '"   								 ,'

		If (cAliasTrb)->B1_ZPEDME <> "A"
			cjson +='	"TIPOALTERACAO"          : "N"    	,'
		Else
			cjson +='	"TIPOALTERACAO"          : "S"    	,'
		Endif


		If (cAliasTrb)->B1_MSBLQL <> '1' .AND. (cAliasTrb)->B1_ZBLQSC <> '1'  

			cjson +='	"STATUS"                 : "N"      ,'


		Else

			cjson +='	"STATUS"                 : "B"      ,'

		Endif


		cjson +='	"CONTACONTABIL"          : " "                                                                                       ,'
		cjson +='	"MARGEMTOLERANCIA"       : "0"                                             											 ,' // Sempre N
		cjson +='	"FLOW"                   : "0"                                             											 ,' // Sempre N
		cjson +='	"ORIGEMMATERIAL"         : "' + alltrim((cAliasTrb)->B1_ORIGEM) + '"     											 '

		cjson +='			}}                                                  '

		oJson:fromJson(cjson )
         
		cTimeIni := time()

		//Ajusta escapes do json
		cjson := strtran(cjson,'\','\\')

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif


		nStatuHttp	:= 0
		
		nStatuHttp	:= httpGetStatus ()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		if nStatuHttp >= 200 .and. nStatuHttp <= 299

			cQ := "UPDATE "
			cQ += RetSqlName("SB1")+" "
			cQ += "SET "
			cQ += "B1_ZPEDME = 'S', "
			cQ += "B1_ZDCATEG = '" + alltrim(STR((cAliasTrb)->HASH)) + "'    "
			cQ += "WHERE B1_COD = '" + alltrim((cAliasTrb)->B1_COD) + "'    "

			nRet := tcSqlExec(cQ)

			If nRet != 0

				U_MFCONOUT("Problemas na gravacao dos campos do cadastro de produto, apos envio ao ME.")
				xpostret := "Problemas na gravacao dos campos do cadastro de produto, apos envio ao ME. - " + xpostret

			EndIf

		Else

			If valType(xpostret) != "C"
				xpostret := "Retorno nulo"
			Endif

			U_MFCONOUT("Erro no envio da integrao ao ME - " + xpostret)

		Endif


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
		ZF1->ZF1_TOKEN	:=	alltrim(STR((cAliasTrb)->HASH))

		Msunlock ()

		freeObj( oJson )

		U_MFCONOUT("URL..........................: " + cUrl			)
		U_MFCONOUT("Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
		U_MFCONOUT("cJson........................: " + allTrim( cJson ) 					)
		U_MFCONOUT("STATUS........................: " + (cAliasTrb)->STATUS)

		U_MFCONOUT('Completou envio do  produto ' + alltrim((cAliasTrb)->B1_COD) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6)+ "...") 
		_nni++
	
		(cAliasTrb)->(dbSkip())

	EndDo

	(cAliasTrb)->(dbCloseArea())

Return()
