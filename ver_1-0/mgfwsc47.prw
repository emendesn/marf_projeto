#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"
 
/*/{Protheus.doc} MGFWSC47
Integracao Protheus-ME, para envio das Entregas/Devolucoes/
@type function

@author Anderson Reis
@since 26/02/2020
@history CRIACAO DOS CAMPOS C7_ZRECME / D1_ZMEDEV
@version P12
/*/

user function MGFWSC47()

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
Local cCont         := 0
Local nret          := 0 
Local ndevol        := 0

U_MFCONOUT('Iniciando integracao de envio de entregas e devolucoes...')

cAliasTrb := GetNextAlias()
cUrl := Alltrim(GetMv("MGF_WSC47"))

U_MFCONOUT('Carregando pedidos...')

// Entrada Nota 

cQ := " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'NOTA' AS STATUS,D1_QUANT,D1_SERIE    "
cQ += " , SD1.R_E_C_N_O_ AS D1REC, SC7.R_E_C_N_O_ AS C7REC "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = ' ' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEMPC    AND SD1.D1_ZPEDME = ' ' "
cQ += " AND SD1.D1_DTDIGIT >= " + GetMv("MGF_WSC45B")+  "  "
cq += " UNION ALL        "


// Cancel Nota - ALteradO C7_QUJE

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC,  "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'NOTA_CANCELADA' AS STATUS,D1_QUANT,D1_SERIE    "
cQ += " , SD1.R_E_C_N_O_ AS D1REC, SC7.R_E_C_N_O_ AS C7REC "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SC7.C7_ZPEDME <> ' ' AND   SD1.D_E_L_E_T_ = '*' AND  "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEMPC      AND SD1.D1_ZPEDME <> 'X'  "
cQ += " AND SD1.D1_DTDIGIT >= " + GetMv("MGF_WSC45B")+  "  "


cq += " UNION ALL        "

// Eliminacao de Resi­duo

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC,  "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'ELIM. RESIDUO' AS STATUS,D1_QUANT,D1_SERIE    "
cQ += " , SD1.R_E_C_N_O_ AS D1REC, SC7.R_E_C_N_O_ AS C7REC "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = ' ' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEMPC      AND "
cq += " SC7.C7_RESIDUO <> '  ' AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  "  AND SD1.D1_ZPEDME <> 'R'  "

cq += " UNION ALL        "


// Devolucao Parcial

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'DEV. PARCIAL' AS STATUS,D1_QUANT,D1_SERIE    "
cQ += " , SD1.R_E_C_N_O_ AS D1REC, SC7.R_E_C_N_O_ AS C7REC "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO   AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEMPC      AND SD1.D1_ZPEDME <> ' ' AND  "
cQ += " SD1.D1_QTDEDEV   <>  SD1.D1_ZMEDEV  AND SD1.D1_QTDEDEV  > 0  AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  " "


//  Cancelar Devolucao
cq += " UNION ALL        "

cQ += " SELECT C7_NUM,C7_FILIAL,C7_EMISSAO,C7_NUM,C7_FORNECE,C7_LOJA,C7_ZRECME,D1_ZMEDEV,D1_PEDIDO,D1_DOC, "
cQ += " C7_ITEM,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_CONAPRO,C7_PRODUTO,D1_QTDEDEV ,D1_FILIAL,'CANCEL. DEV' AS STATUS,D1_QUANT,D1_SERIE    "
cQ += " , SD1.R_E_C_N_O_ AS D1REC, SC7.R_E_C_N_O_ AS C7REC "
cQ += " FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SC7")+" SC7 WHERE "
cQ += " SD1.D_E_L_E_T_ = '*' AND SC7.C7_ZPEDME <> ' ' AND   "
cQ += " SC7.D_E_L_E_T_   = ' '              AND D1_TES <> ' '  AND "
cQ += " SC7.C7_FILIAL    = SD1.D1_FILIAL    AND "
cQ += " SC7.C7_FORNECE   = SD1.D1_FORNECE   AND "
cQ += " SC7.C7_NUM       = SD1.D1_PEDIDO    AND "
cQ += " SC7.C7_PRODUTO   = SD1.D1_COD       AND "
cQ += " SC7.C7_ITEM      = SD1.D1_ITEMPC      AND SD1.D1_ZPEDME <> 'W'  AND "
cQ += " SD1.D1_QTDEDEV   <>  SD1.D1_ZMEDEV  AND SD1.D1_DTDIGIT  >= " + GetMv("MGF_WSC45B")+  " "


cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

_ntot := 0
_nni := 1

If (cAliasTrb)->(!Eof())

	U_MFCONOUT('Contando pedidos...')
	Do While (cAliasTrb)->(!Eof())
		_ntot++
		(cAliasTrb)->(Dbskip())
	Enddo
	(cAliasTrb)->(Dbgotop())

Else

	U_MFCONOUT('Não foram localizados pedidos pendentes de integração!')
	Return

Endif

aadd( aHeadOut, 'Content-Type: application/json' )
 
Do While (cAliasTrb)->(!Eof())

	cjson := " "
	oJson := JsonObject():new()
	
	cjson +='   {                                                           '
	cjson +='  	"MSGENTREGA": {                                             '
	cjson  +='	"IDENTIFIC":    "' + alltrim((cAliasTrb)->C7_NUM ) + '"    ,' // alltrim((cAliasTrb)->D1_PEDIDO)
	cjson  +='	"FORNECEDORCLIENTE": "' + alltrim((cAliasTrb)->C7_FORNECE) + alltrim((cAliasTrb)->C7_LOJA) + '"  ,'
	cjson +='	"NUMEROITEM":  "' + alltrim((cAliasTrb)->C7_ITEM) + '"     ,'
	cjson +='	"DATARECEBIMENTO":"' + Substring(DTOS(DATE()),1,4)+"-"+Substring(DTOS(DATE()),5,2)+"-"+Substring(DTOS(DATE()),7,2)+"T00:00:00-00:00" + '"  , '//"2019-01-01T00:00:00-00:00"
	
	If ALLTRIM((cAliasTrb)->STATUS) == 'NOTA' 
		
		cjson +='	"QUANTIDADE":"' + str((cAliasTrb)->D1_QUANT) + '"               ,'
		// Verificar se a quantidade  
		If  (cAliasTrb)->C7_QUJE =  (cAliasTrb)->C7_QUANT
			cjson +='	"FECHADO":"S"  ,'
		Else
			cjson +='	"FECHADO":"N"  ,'
		Endif
		cjson +='	"ESTORNO":"N"  ,'
	
	Elseif ALLTRIM((cAliasTrb)->STATUS) == 'NOTA_CANCELADA' 

		cjson +='	"QUANTIDADE":"'  + str((cAliasTrb)->D1_QUANT * - 1 )   + '"               ,'
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
			cjson +='	"QUANTIDADE":  "' + str((cAliasTrb)->D1_QTDEDEV )   + '" ,' 
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

	cjson +='	"NUMERONF":"'+ (cAliasTrb)->D1_DOC + '"  ,'  
	cjson +='	"SERIENF":"'+ (cAliasTrb)->D1_SERIE + '"  ,'                                              
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

	//Abre transação e atualiza os campos antes de enviar o status
	BEGIN TRANSACTION

	U_MFCONOUT('Atualizando status ' + alltrim((cAliasTrb)->STATUS) + ' do pedido ' +; 
	 (cAliasTrb)->C7_FILIAL + '/' + (cAliasTrb)->C7_NUM + ' - ' + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...')

	SD1->(Dbgoto((cAliasTrb)->D1REC))
	Reclock("SD1",.F.)

	If ALLTRIM((cAliasTrb)->STATUS) == 'NOTA'
		SD1->D1_ZPEDME := 'S'
	ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'ELIM. RESIDUO'
		SD1->D1_ZPEDME := 'R' 
	ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'NOTA_CANCELADA'
		SD1->D1_ZPEDME := 'X'   
	ElseIf ALLTRIM((cAliasTrb)->STATUS) == 'CANCEL. DEV'
		SD1->D1_ZPEDME := 'W'   
	Else	
		SD1->D1_ZMEDEV :=   + SD1->D1_QTDEDEV
	EndIf
			
	SD1->(Msunlock())	
	
	// Atualizando SC7 

	SC7->(Dbgoto((cAliasTrb)->C7REC))
	Reclock("SC7",.F.)
	SC7->C7_ZRECME := (cAliasTrb)->C7_QUJE
	SC7->(Msunlock())
	
	//Envia o Status
	
	cTimeIni := time()

	U_MFCONOUT('Enviando status ' + alltrim((cAliasTrb)->STATUS) + ' do pedido ' +; 
	 (cAliasTrb)->C7_FILIAL + '/' + (cAliasTrb)->C7_NUM + ' - ' + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...')
	
	if !empty( cJson )
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	endif
	
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
	
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )
	
	conout(" [MGFWSC47] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
	conout(" [MGFWSC47] cJson........................: " + allTrim( cJson ) 					)
	conout(" [MGFWSC47] Retorno......................: " + allTrim( xPostRet ) 					)
	
	//Se falhou cancela transação para tentar novamente
	if !(nStatuHttp >= 200 .and. nStatuHttp <= 299)
	
		U_MFCONOUT('Falhou envio de status ' + alltrim((cAliasTrb)->STATUS) + ' do pedido ' +; 
	 	(cAliasTrb)->C7_FILIAL + '/' + (cAliasTrb)->C7_NUM + ' - ' + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...')

		Disarmtransaction()
	Else

		U_MFCONOUT('Completou envio de status ' + alltrim((cAliasTrb)->STATUS) + ' do pedido ' +; 
		 (cAliasTrb)->C7_FILIAL + '/' + (cAliasTrb)->C7_NUM + ' - ' + strzero(_nni,6) + ' de ' + strzero(_ntot,6) + '...')
	
	Endif

	END TRANSACTION

	//Grava log sempre
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
	_nni++

EndDo

(cAliasTrb)->(dbCloseArea())
U_MFCONOUT('Completou integracao de envio de entregas e devolucoes...')

Return
