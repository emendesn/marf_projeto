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

Local cQ 		:= ""
Local cAliasTrb := ""
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
Local nAt           := 0
Local nvezes        := 0
local cTimeFin		:= ""

cAliasTrb := GetNextAlias()

U_MFCONOUT('Iniciando integracao de fornecedores para o Mercado Eletronico...') 

cUrl := Alltrim(GetMv("MGF_WSC46")) 
cAliasTrb := GetNextAlias()

U_MFCONOUT('Carregando fornecedores...') 

cQ := " SELECT A2_COD,A2_LOJA,A2_NOME,A2_CONTATO,A2_END,A2_MUN,A2_BAIRRO,A2_EST,A2_TIPO,A2_CGC,A2_TEL,A2_EMAIL,"
cQ += " A2_MSBLQL,A2_ZPEDME,A2_DDD,A2_ZINTME,A2_PAIS,A2_CEP,A2_FILIAL, R_E_C_N_O_ AS SA2REC "
cQ += " FROM "+RetSqlName("SA2")+" SA2 "
cQ += " WHERE D_E_L_E_T_ = ' ' AND A2_ZINTME = 'S' AND A2_EMAIL <> ' ' AND  "
cQ += " ( A2_ZPEDME = ' ' OR A2_ZPEDME = 'A' OR A2_ZPEDME = 'D' )

if Getmv("MGF_WSC46A") == "F"
	cQ += " AND A2_EST <> 'EX' "
Endif

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.F.,.F.)
aadd( aHeadOut, 'Content-Type: application/json' )

_ntot := 0
_nni := 1
Do While (cAliasTrb)->(!Eof())
	_ntot++
	(cAliasTrb)->(Dbskip())
Enddo

(cAliasTrb)->(Dbgotop())
	
Do While (cAliasTrb)->(!Eof())

	U_MFCONOUT('Enviando fornecedor ' + (cAliasTrb)->A2_COD + '/' + (cAliasTrb)->A2_LOJA + ' - ' ;
					+strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...') 

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

	If alltrim((cAliasTrb)->A2_ZPEDME) = "A" .OR. alltrim((cAliasTrb)->A2_ZPEDME) = "S"
		cjson +=' "TIPOALTERACAO": "S"                                                       '
	Elseif alltrim((cAliasTrb)->A2_ZINTME) = "S"
		cjson +=' "TIPOALTERACAO": "N"                                                       '
	Else
		cjson +=' "TIPOALTERACAO": " "                                                       '
	Endif

	cjson +=' }}'

	oJson:fromJson(cjson )

	cTimeIni := time()

	if !empty( cJson )
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	endif

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
		
	cTimeFin	:= time()

	If AllTrim( str( nStatuHttp ) ) == '200' 

		SA2->(Dbgoto((cAliasTrb)->SA2REC))		
		Reclock("SA2",.F.)
		SA2->A2_ZPEDME := 'S'
		SA2->(Msunlock())

		U_MFCONOUT('Completou envio do fornecedor ' + (cAliasTrb)->A2_COD + '/' + (cAliasTrb)->A2_LOJA + ' - ' ;
					+strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...') 
	
	Else

		U_MFCONOUT('Completou envio do fornecedor ' + (cAliasTrb)->A2_COD + '/' + (cAliasTrb)->A2_LOJA + ' - ' ;
					+strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...') 

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
	_nni++

EndDo

(cAliasTrb)->(dbCloseArea())
U_MFCONOUT("Completou envio de fornecedores para o Mercado Eletronico!")

Return
