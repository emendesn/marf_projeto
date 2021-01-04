#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAP15
Autor....:              Marcelo Carneiro         
Data.....:              21/06/2017 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA ESTOQUE OP PROTHEUS
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaEstoqueOPProtheus
==========================================================================================================
*/

WSSTRUCT TAP15_CONSULTA
	WSDATA FILIAL        as String
	WSDATA OP            as String
ENDWSSTRUCT

WSSTRUCT TAP15_ITENS
	WSDATA COD            as String
	WSDATA TIPO           as String
	WSDATA QUANT          as Float
ENDWSSTRUCT

WSSTRUCT TAP15_RETORNO
   WSDATA ITENS  as Array of TAP15_ITENS
ENDWSSTRUCT

WSSERVICE MGFTAP15 DESCRIPTION "Consulta Saldo Estoque da OP Protheus" NameSpace "http://www.totvs.com.br/MGFTAP15"
	WSDATA WSCONSULTA as TAP15_CONSULTA
	WSDATA WSRETORNO  as TAP15_RETORNO

	WSMETHOD ConsultaEstoqueOPProtheus DESCRIPTION "Consulta Saldo Estoque da OP Protheus"
ENDWSSERVICE

WSMETHOD ConsultaEstoqueOPProtheus  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAP15
            
Local nI := 0
Private cFilSaldo := Alltrim(::WSCONSULTA:FILIAL)
Private cOP       := Alltrim(::WSCONSULTA:OP)
Private aRetorno  := {} 

aRetorno := TAP15_CONS(cFilSaldo,cOP)

::WSRETORNO := WSClassNew( "TAP15_RETORNO")
::WSRETORNO:ITENS := {}

For nI := 1 To Len(aRetorno)
	aAdd(::WSRETORNO:ITENS,WSClassNew( "TAP15_ITENS"))
	::WSRETORNO:ITENS[nI]:COD            := aRetorno[nI,1]
	::WSRETORNO:ITENS[nI]:TIPO           := aRetorno[nI,2]
	::WSRETORNO:ITENS[nI]:QUANT          := aRetorno[nI,3]
Next nI

Return .T.
********************************************************************************************************************************************
Static Function TAP15_CONS(cFilSaldo,cOP)

Local cQuery    := ''     
Local aRetorno  := {} 
Local aRec      := {}
Private cTMDev2		:= GetMv("MGF_TAP02U",,"001")
                      
//RE4 - Requisição por transferência.
//DE4 - Devolução de transferência entre locais.

cQuery  := " SELECT D3_COD,  "
cQuery  += "        CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN 'CS'"
cQuery  += "             WHEN  D3_CF = 'RE4' AND D3_TM = '999'  THEN 'CS'"
cQuery  += "             WHEN  D3_CF = 'DE4' AND D3_TM = '499'  THEN 'PR'"
cQuery  += "             WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "             WHEN  D3_TM >= '500' THEN 'CS' "
cQuery  += "        END TIPO, "
cQuery  += "        Sum(CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN -1"
cQuery  += "            ELSE 1  END * D3_QUANT)  TOTAL "
cQuery  += " FROM "+RetSqlName('SD3')
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND D3_FILIAL   = '"+cFilSaldo+"'"
cQuery  += "   AND D3_ZOPTAUR  = '"+cOP+"'"
cQuery  += "   AND D3_ESTORNO <> 'S' "   
cQuery  += " GROUP BY D3_COD,   CASE WHEN  D3_TM  ='001'  THEN 'CS'"
cQuery  += "             			 WHEN  D3_CF = 'RE4' AND D3_TM = '999'  THEN 'CS'"
cQuery  += "             		     WHEN  D3_CF = 'DE4' AND D3_TM = '499'  THEN 'PR'"
cQuery  += "                         WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "                         WHEN  D3_TM >= '500' THEN 'CS' END"
If Select("QRY_OP") > 0
	QRY_OP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
MemoWrite("c:\temp\query.sql.txt",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_OP",.T.,.F.)
dbSelectArea("QRY_OP")
QRY_OP->(dbGoTop())
While !QRY_OP->(EOF())
	aRec      := {}
	AAdd(aRec,QRY_OP->D3_COD)
	AAdd(aRec,QRY_OP->TIPO)
	AAdd(aRec,QRY_OP->TOTAL)
	AAdd(aRetorno,aRec)
	QRY_OP->(dbSkip())
End

IF Len(aRetorno) == 0
	aRec      := {}
	AAdd(aRec,'')
	AAdd(aRec,'')
	AAdd(aRec,0)
	AAdd(aRetorno,aRec)
EndIF

Return aRetorno
***********************************************************************************
User Function ZTeste_TAP15
Private aRetorno  := {} 

RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )

aRetorno := TAP15_CONS('010003','17122003113024')

msgAlert('1929')      

Return

