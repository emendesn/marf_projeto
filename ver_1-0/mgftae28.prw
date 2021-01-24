#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE28
Autor....:              Marcelo Carneiro         
Data.....:              09/02/2018
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA CUSTO EMBALAGEM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaCustoProtheus
==========================================================================================================
*/

WSSTRUCT TAE28_CONSULTA
	WSDATA FILIAL        as String
ENDWSSTRUCT

WSSTRUCT TAE28_ITENS
	WSDATA COD            as String
	WSDATA CUSTO          as Float
ENDWSSTRUCT

WSSTRUCT TAE28_RETORNO
   WSDATA ITENS  as Array of TAE28_ITENS
ENDWSSTRUCT

WSSERVICE MGFTAE28 DESCRIPTION "Consulta Custo Embalagens Protheus" NameSpace "http://www.totvs.com.br/MGFTAE28"
	WSDATA WSCONSULTA as TAE28_CONSULTA
	WSDATA WSRETORNO  as TAE28_RETORNO

	WSMETHOD ConsultaCustoProtheus DESCRIPTION "Consulta Custo Embalagens Protheus"
ENDWSSERVICE

WSMETHOD ConsultaCustoProtheus  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAE28
            
Local nI := 0
Private cFilCusto := Alltrim(::WSCONSULTA:FILIAL)
Private aRetorno  := {} 

aRetorno := TAE28_CONS(cFilCusto)

::WSRETORNO := WSClassNew( "TAE28_RETORNO")
::WSRETORNO:ITENS := {}

For nI := 1 To Len(aRetorno)
	aAdd(::WSRETORNO:ITENS,WSClassNew( "TAE28_ITENS"))
	::WSRETORNO:ITENS[nI]:COD            := aRetorno[nI,1]
	::WSRETORNO:ITENS[nI]:CUSTO          := aRetorno[nI,2]
Next nI

Return .T.
********************************************************************************************************************************************
Static Function TAE28_CONS(cFilCusto)

Local cQuery     := ''     
Local aRetorno   := {} 
Local aRec       := {}       
Local dDataFecha := CTOD(' /  /  ')

cFilAnt  := cFilCusto
//dDataFecha := GetMV("MV_ULMES") 
                      

cQuery  := " SELECT B2_COD, B2_CM1  "
cQuery  += " FROM "+RetSqlName('SB2')+" B2,  "+RetSqlName('SB1')+" B1 "
cQuery  += " WHERE B2.D_E_L_E_T_  = ' ' "
cQuery  += "   AND B1.D_E_L_E_T_  = ' ' "
cQuery  += "   AND B2_FILIAL   = '"+cFilCusto+"'"
//cQuery  += "   AND B9_DATA     = '"+DTOS(dDataFecha)+"'"
cQuery  += "   AND B1_FILIAL   = '      '"
cQuery  += "   AND B1_COD      = B2_COD  "
cQuery  += "   AND B2_LOCAL    = B1_LOCPAD  "
cQuery  += "   AND B2_COD      BETWEEN '500000' AND '899999'  "   
If Select("QRY_CUSTO") > 0
	QRY_CUSTO->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CUSTO",.T.,.F.)
dbSelectArea("QRY_CUSTO")
QRY_CUSTO->(dbGoTop())
While !QRY_CUSTO->(EOF())
	aRec      := {}
	AAdd(aRec,QRY_CUSTO->B2_COD)
	AAdd(aRec,QRY_CUSTO->B2_CM1)
	AAdd(aRetorno,aRec)
	QRY_CUSTO->(dbSkip())
End

IF Len(aRetorno) == 0
	aRec      := {}
	AAdd(aRec,'')
	AAdd(aRec,0)
	AAdd(aRetorno,aRec)
EndIF

Return aRetorno
