#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"
 
/*/{Protheus.doc} MGFWSC47
Integração Protheus-ME, para envio das Entregas/Devoluções/
@type function

@author Anderson Reis
@since 26/02/2020
@history CRIAÇÃO DOS CAMPOS C7_ZRECME / D1_ZMEDEV
@version P12
/*/

user function MGFWSC47()

RPCSetType( 3 )

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"

conout('[MGFWSC47] Iniciada Threads (ENTREGA) - ' + dToC(dDataBase) + " - " + time())

RUNINTEG47()

RESET ENVIRONMENT
return



STATIC Function RUNINTEG47()


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
Local cCont         := 0
Local nret          := 0 
Local ndevol        := 0

cUrl := Alltrim(GetMv("MGF_WSC47"))

conout(" URL..........................: " + cUrl									)
If Empty(cUrl)
	ConOut("Não encontrado parâmetro 'MGF_WSC47'.")
	Return()
Endif

// Entrada Nota 

cQ := " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'NOTA' AS STATUS    "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = ' ' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_LOJA      = SD1.D1_LOJA      AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEM      AND SD1.D1_ZPEDME = ' ' "
cQ += " AND SD1.D1_DTDIGIT >= " + GetMv("MGF_WSC45B")+  "  "
cq += " UNION ALL        "


// Cancel Nota - ALteradO C7_QUJE

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC,  "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'NOTA_CANCELADA' AS STATUS    "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SC7.C7_ZPEDME <> ' ' AND   SD1.D_E_L_E_T_ = '*' AND  "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_LOJA      = SD1.D1_LOJA      AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEM      AND SD1.D1_ZPEDME <> 'X'  "
cQ += " AND SD1.D1_DTDIGIT >= " + GetMv("MGF_WSC45B")+  "  "


cq += " UNION ALL        "

// Eliminação de Resíduo

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC,  "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'ELIM. RESIDUO' AS STATUS    "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = ' ' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_LOJA      = SD1.D1_LOJA      AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEM      AND "
cq += " SC7.C7_RESIDUO <> '  ' AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  "  AND SD1.D1_ZPEDME <> 'R'  "

cq += " UNION ALL        "


// Devoluçao Parcial

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'DEV. PARCIAL' AS STATUS    "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_LOJA      = SD1.D1_LOJA      AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEM      AND SD1.D1_ZPEDME <> ' ' AND  "
cQ += " SD1.D1_QTDEDEV   <>  SD1.D1_ZMEDEV  AND SD1.D1_QTDEDEV  > 0  AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  " "


//  Cancelar Devolução
cq += " UNION ALL        "

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'CANCEL. DEV' AS STATUS    "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = '*' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_LOJA      = SD1.D1_LOJA      AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEM      AND SD1.D1_ZPEDME <> 'W'  AND "
cQ += " SD1.D1_QTDEDEV   <>  SD1.D1_ZMEDEV  AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  " "



cQ := ChangeQuery(cQ)
memowrite("c:\TEMP\ENTREGAS.TXT",cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

aadd( aHeadOut, 'Content-Type: application/json' )
 
While (cAliasTrb)->(!Eof())
	cCont ++
	cjson := " "
	oJson := JsonObject():new()
	
	
	cjson +='   {                                                           '
	cjson +='  	"MSGENTREGA": {                                             '
	cjson  +='	"IDENTIFIC":    "' + alltrim((cAliasTrb)->C7_NUM ) + '"    ,' // alltrim((cAliasTrb)->D1_PEDIDO)
	cjson  +='	"FORNECEDORCLIENTE": "' + alltrim((cAliasTrb)->C7_FORNECE) + alltrim((cAliasTrb)->C7_LOJA) + '"  ,'
	cjson +='	"NUMEROITEM":  "' + alltrim((cAliasTrb)->C7_ITEM) + '"     ,'
	cjson +='	"DATARECEBIMENTO":"' + Substring(DTOS(DATE()),1,4)+"-"+Substring(DTOS(DATE()),5,2)+"-"+Substring(DTOS(DATE()),7,2)+"T00:00:00-00:00" + '"  , '//"2019-01-01T00:00:00-00:00"
	
	If ALLTRIM((cAliasTrb)->STATUS) == 'NOTA' 
		
		cjson +='	"QUANTIDADE":"' + str((cAliasTrb)->C7_QUJE) + '"               ,'
		// Verificar se a quantidade  
		If  (cAliasTrb)->C7_QUJE =  (cAliasTrb)->C7_QUANT
			cjson +='	"FECHADO":"S"  ,'
		Else
			cjson +='	"FECHADO":"N"  ,'
		Endif
		cjson +='	"ESTORNO":"N"  ,'
	
	Elseif ALLTRIM((cAliasTrb)->STATUS) == 'NOTA_CANCELADA' 

		cjson +='	"QUANTIDADE":"'  + str((cAliasTrb)->C7_QUANT * - 1 )   + '"               ,'
		cjson +='	"FECHADO":"S"  ,'
		cjson +='	"ESTORNO":"S"  ,'

	Elseif ALLTRIM((cAliasTrb)->STATUS) == 'CANCEL. DEV' 

		cjson +='	"QUANTIDADE":  "' + str(( (cAliasTrb)->D1_ZMEDEV -  (cAliasTrb)->D1_QTDEDEV ) )   + '"               ,'
		cjson +='	"FECHADO":"N"  ,'
		cjson +='	"ESTORNO":"S"  ,'

	Elseif ALLTRIM((cAliasTrb)->STATUS) == 'ELIM. RESIDUO' 
	
	   	cjson +='	"QUANTIDADE":"' + str(((cAliasTrb)->C7_QUANT - (cAliasTrb)->C7_QUJE )) + '"               ,'
	

	ElseIF ALLTRIM((cAliasTrb)->STATUS) == 'DEVOLUCAO' .or. ALLTRIM((cAliasTrb)->STATUS) == 'DEV. PARCIAL'
		
	
		If (cAliasTrb)->D1_QTDEDEV > (cAliasTrb)->D1_ZMEDEV 
			cjson +='	"QUANTIDADE":  "' + str(((cAliasTrb)->D1_QTDEDEV - (cAliasTrb)->D1_ZMEDEV ) * - 1 )   + '"               ,'
		Else
			cjson +='	"QUANTIDADE":  "' + str(((cAliasTrb)->D1_QTDEDEV - (cAliasTrb)->D1_ZMEDEV ) * - 1 )   + '"  
		Endif


	
	
	Endif
	
	
	If ALLTRIM((cAliasTrb)->STATUS) == "ENCERRADO"
		
		cjson +='	"FECHADO":"S"  ,'
		cjson +='	"ESTORNO":"N"  ,'
		
	Elseif  ALLTRIM((cAliasTrb)->STATUS) == "ELIM. RESIDUO"
		
		cjson +='	"FECHADO":"S"  ,'
		cjson +='	"ESTORNO":"N"  ,'
		
	Elseif aLLTRIM((cAliasTrb)->STATUS) == "DEV. PARCIAL" .AND.  (cAliasTrb)->C7_QUANT = (cAliasTrb)->D1_QTDEDEV 
		
		cjson +='	"FECHADO":"S"  ,'
		cjson +='	"ESTORNO":"S"  ,'
		
	Elseif  aLLTRIM((cAliasTrb)->STATUS) == "DEV. PARCIAL"
		
		cjson +='	"FECHADO":"N"  ,'
		cjson +='	"ESTORNO":"S"  ,'
		
	Endif
	
	cjson +='	"SERIENF":" "                                               ,'
	cjson +='	"DATAEMISSAO":"' + Substring((cAliasTrb)->C7_EMISSAO,1,4)+"-"+Substring((cAliasTrb)->C7_EMISSAO,5,2)+"-"+Substring((cAliasTrb)->C7_EMISSAO,7,2)+"T00:00:00-00:00" + '"  , '//"2019-01-01T00:00:00-00:00"
	
	cjson +='  	"BORGS": [{                                                 '
	
	If Substr(Alltrim((cAliasTrb)->C7_FILIAL),1,2) = "01"
		
		cjson +='	"CODIGOBORG": "010001"                                  ,'
		
	Elseif Substr(Alltrim((cAliasTrb)->C7_FILIAL),1,2) = "02"
		
		cjson +='	"CODIGOBORG": "020001"                                  ,'
		
	ElseIf Substr(Alltrim((cAliasTrb)->C7_FILIAL),1,2) = "03"
		
		cjson +='	"CODIGOBORG": "030001"                                  ,'
		
	Endif
	
	cjson +='	"CAMPOVENT": "EMPRESA"                                   '
	
	cjson +='			},{                                                 '
	
	cjson +='	"CODIGOBORG":"' + alltrim((cAliasTrb)->C7_FILIAL ) + '"                                            ,'
	cjson +='	"CAMPOVENT":"CENTRO"                                             '
	
	
	cjson +='			}]}}                                                 '
	
	oJson:fromJson(cjson )
	
	
	cTimeIni := time()
	
	if !empty( cJson )
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	endif
	
	
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
	
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )
	
	
	conout(" [MGFWSS10] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
	conout(" [MGFWSS10] cJson........................: " + allTrim( cJson ) 					)
	conout(" [MGFWSS10] Retorno......................: " + allTrim( xPostRet ) 					)
	
	if nStatuHttp >= 200 .and. nStatuHttp <= 299
	  
	ndevol :=  (cAliasTrb)->D1_QTDEDEV 
	
	cQ := "UPDATE "
	
	
	cQ += RetSqlName("SD1")+" "
	
	
	cQ += "SET "

		
		If ALLTRIM((cAliasTrb)->STATUS) == 'NOTA'
			
			cQ += "D1_ZPEDME = 'S'"
			
					
		ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'ELIM. RESIDUO'
			
			cQ += "D1_ZPEDME = 'R' "

		ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'NOTA_CANCELADA'
			
			cQ += "D1_ZPEDME = 'X'   "

		ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'CANCEL. DEV'
			
			cQ += "D1_ZPEDME = 'W'   "
		Else	
			cQ += " D1_ZMEDEV =  '" + STR(ndevol) + "  "
		
		
		EndIf
			
		
		cQ += " WHERE D1_FILIAL  = '" + alltrim((cAliasTrb)->C7_FILIAL)   + "'  "
		cQ += " AND   D1_FORNECE  = '" + alltrim((cAliasTrb)->C7_FORNECE)  + "'  "
		cQ += " AND   D1_LOJA     = '" + alltrim((cAliasTrb)->C7_LOJA)     + "'  "
		cQ += " AND   D1_PEDIDO   = '" + alltrim((cAliasTrb)->C7_NUM)      + "'  "
		cQ += " AND   D1_COD      = '" + alltrim((cAliasTrb)->C7_PRODUTO)  + "'  "
		cQ += " AND   D1_ITEM     = '" + alltrim((cAliasTrb)->C7_ITEM)     + "'  "
		
		
		nRet := tcSqlExec(cQ)
	endif
	If nRet == 0
		conout ("Atualizado o Status da Nota com sucesso ... ")
	Else
		conout ("Não atualizado o Status da Nota")
		
		
	EndIf
	

// Atualizando SC7 

If (nStatuHttp >= 200 .and. nStatuHttp <= 299)            //.AND. ;
   //ALLTRIM((cAliasTrb)->STATUS)      == 'NOTA_CANCELADA'                      
  

	nRet := 0
	
	cQ := "UPDATE "
	cQ += RetSqlName("SC7")+" "
	cQ += "SET  C7_ZRECME = (cAliasTrb)->C7_C7_QUJE  " 
	
	cQ += " WHERE C7_FILIAL    = '" + alltrim((cAliasTrb)->C7_FILIAL)   + "'  "
	cQ += " AND   C7_FORNECE   = '" + alltrim((cAliasTrb)->C7_FORNECE)  + "'  "
	cQ += " AND   C7_LOJA      = '" + alltrim((cAliasTrb)->C7_LOJA)     + "'  "
	cQ += " AND   C7_NUM       = '" + alltrim((cAliasTrb)->C7_NUM)      + "'  "
	cQ += " AND   C7_PRODUTO   = '" + alltrim((cAliasTrb)->C7_PRODUTO)  + "'  "
	cQ += " AND   C7_ITEM      = '" + alltrim((cAliasTrb)->C7_ITEM)     + "'  "
				
	nRet := tcSqlExec(cQ)

	If nRet == 0
		conout ("Atualizado o Status da Nota devolvida com sucesso ... ")
	Else
		conout ("Não atualizado o Status da Nota devolvida")
			
	EndIf
	
	
Endif
	
	Reclock("ZF1",.T.)
	
	ZF1->ZF1_ID     :=  GETSX8NUM("ZF1","ZF1_ID")
	ZF1->ZF1_FILIAL :=	(cAliasTrb)->D1_FILIAL
	ZF1->ZF1_INTERF	:=	"ET"
	ZF1->ZF1_DATA	:=	dDataBase
	ZF1->ZF1_PREPED	:=	" "
	ZF1->ZF1_PEDIDO	:=	(cAliasTrb)->D1_PEDIDO
	ZF1->ZF1_NOTA	:=	(cAliasTrb)->D1_DOC
	ZF1->ZF1_HTTP	:=	allTrim( str( nStatuHttp ) )
	ZF1->ZF1_ERRO	:=	Alltrim(xPostRet)
	ZF1->ZF1_JSON	:=	cJson
	ZF1->ZF1_HORA	:=	time()
	ZF1->ZF1_TOKEN	:=	(cAliasTrb)->STATUS
	
	Msunlock ()
	
	
	freeObj( oJson )
	
	(cAliasTrb)->(dbSkip())
EndDo
If cCont = 0
	conout ("Não há notas a serem Integradas ... ")
Endif
(cAliasTrb)->(dbCloseArea())

	Return()
