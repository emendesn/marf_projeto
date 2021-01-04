#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE23
Autor....:              Marcelo Carneiro         
Data.....:              21/06/2017 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA ESTOQUE PROTHEUS
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaEstoqueProtheus
==========================================================================================================
*/

WSSTRUCT TAE23_CONSULTA
	WSDATA FILIAL         as String
	WSDATA COD            as String
	WSDATA LOTE           as String 
	WSDATA LOCAL_ESTOQUE  as String 
ENDWSSTRUCT

WSSTRUCT TAE23_ITENS
	WSDATA COD            as String
	WSDATA UM             as String
	WSDATA LOTE           as String
	WSDATA LOCAL_ESTOQUE  as String
	WSDATA QUANT          as Float
	WSDATA VALIDADE       as String
ENDWSSTRUCT

WSSTRUCT TAE23_RETORNO
   WSDATA ITENS  as Array of TAE23_ITENS
ENDWSSTRUCT

WSSERVICE MGFTAE23 DESCRIPTION "Consulta Saldo Estoque Protheus" NameSpace "http://www.totvs.com.br/MGFTAE23"
	WSDATA WSCONSULTA as TAE23_CONSULTA
	WSDATA WSRETORNO  as TAE23_RETORNO

	WSMETHOD ConsultaEstoqueProtheus DESCRIPTION "Consulta Saldo Estoque Protheus"
ENDWSSERVICE

WSMETHOD ConsultaEstoqueProtheus  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAE23
     
Local cQuery  := ''
Local nI      := 0 
Private cFilSaldo := Alltrim(::WSCONSULTA:FILIAL)
Private cCodProd  := Alltrim(::WSCONSULTA:COD)
Private cLote     := Alltrim(::WSCONSULTA:LOTE)
Private cLocal    := Alltrim(::WSCONSULTA:LOCAL_ESTOQUE)
Private bContinua := .T.
Private aRetorno  := {} 
Private aRec      := {}
                      
cCodProd  := Padr(cCodProd,TamSX3("B1_COD")[1])

dbSelectArea('SB1')
SB1->(dbSetorder(1))
IF SB1->(!dbSeek(xFilial('SB1')+cCodProd))
    bContinua := .F.
Else
   IF SB1->B1_RASTRO $ "LS"
     	cQuery  := " SELECT * "
		cQuery  += " FROM "+RetSqlName('SB8')
		cQuery  += " WHERE D_E_L_E_T_  = ' ' "
		cQuery  += "   AND B8_SALDO    > 0 "
		cQuery  += "   AND B8_FILIAL   = '"+cFilSaldo+"'"
		cQuery  += "   AND B8_PRODUTO  = '"+cCodProd+"'"
		IF !Empty(cLocal)
		   cQuery  += "   AND B8_LOCAL   = '"+cLocal+"'"
		EndIF
		IF !Empty(cLote)
		   cQuery  += "   AND B8_LOTECTL  = '"+cLote+"'"
		EndIF
		If Select("QRY_B8") > 0
			QRY_B8->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_B8",.T.,.F.)
		dbSelectArea("QRY_B8")
		QRY_B8->(dbGoTop())
		While !QRY_B8->(EOF())
			aRec      := {}
			AAdd(aRec,QRY_B8->B8_PRODUTO)
			AAdd(aRec,SB1->B1_UM)
			AAdd(aRec,QRY_B8->B8_LOTECTL)
			AAdd(aRec,QRY_B8->B8_LOCAL)
			AAdd(aRec,QRY_B8->B8_SALDO)
			AAdd(aRec,QRY_B8->B8_DTVALID)
			AAdd(aRetorno,aRec)
			QRY_B8->(dbSkip())
		End
	Else
     	cQuery  := " SELECT * "
		cQuery  += " FROM "+RetSqlName('SB2')
		cQuery  += " WHERE D_E_L_E_T_  = ' ' "          
		cQuery  += "   AND B2_QATU     > 0 "
		cQuery  += "   AND B2_FILIAL   = '"+cFilSaldo+"'"
		cQuery  += "   AND B2_COD      = '"+cCodProd+"'"
		IF !Empty(cLocal)
		   cQuery  += "   AND B2_LOCAL   = '"+cLocal+"'"
		EndIF
		If Select("QRY_B2") > 0
			QRY_B2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_B2",.T.,.F.)
		dbSelectArea("QRY_B2")
		QRY_B2->(dbGoTop())
		While !QRY_B2->(EOF()) 
		    aRec      := {}
			AAdd(aRec,QRY_B2->B2_COD)
			AAdd(aRec,SB1->B1_UM) 
			AAdd(aRec,'')
			AAdd(aRec,QRY_B2->B2_LOCAL)
			AAdd(aRec,QRY_B2->B2_QATU)
			AAdd(aRec,'')
			AAdd(aRetorno,aRec)
			QRY_B2->(dbSkip())
		End
   EndIF
EndIF

IF Len(aRetorno) == 0 .OR. !bContinua
	aRec      := {}
	AAdd(aRec,Alltrim(cCodProd))
	IF bContinua
	     AAdd(aRec,SB1->B1_UM)
	Else                      
	     AAdd(aRec,'')
	EndIF
	AAdd(aRec,'')
	AAdd(aRec,'')
	AAdd(aRec,0)
	AAdd(aRec,'')
	AAdd(aRetorno,aRec)
EndIF

::WSRETORNO := WSClassNew( "TAE23_RETORNO")
::WSRETORNO:ITENS := {}

For nI := 1 To Len(aRetorno)
	aAdd(::WSRETORNO:ITENS,WSClassNew( "TAE23_ITENS"))
	::WSRETORNO:ITENS[nI]:COD            := aRetorno[nI,1]
	::WSRETORNO:ITENS[nI]:UM             := aRetorno[nI,2]
	::WSRETORNO:ITENS[nI]:LOTE           := aRetorno[nI,3]
	::WSRETORNO:ITENS[nI]:LOCAL_ESTOQUE  := aRetorno[nI,4]
	::WSRETORNO:ITENS[nI]:QUANT          := aRetorno[nI,5]
	::WSRETORNO:ITENS[nI]:VALIDADE       := aRetorno[nI,6]
Next nI

Return .T.



