#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
=====================================================================================
Programa.:              MGFFIN32 - PE
Autor....:              Antonio Carlos
Data.....:              03/10/2016
Descricao / Objetivo:   incluir informacoes de Titulos Recebidos por Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              Titulos Recebidos por Rede na Posicao do Cliente
=====================================================================================
*/
User Function  MGFFIN32(cQueryori)
LOCAL cQuery    := ''
LOCAL _cCodRede := SA1->A1_ZREDE
LOCAL cRaizCNPJ := Substr(SA1->A1_CGC,1,8)
Local cQryRede  := ""                                                          
Local cCampos   := ""
Local cSQLSA1   := ""

IF MV_PAR18 = 1    //MsgNoYes("Titulos Recebidos por Rede ?")
    cQryRede := StaticCall(MGFFIN22,QueryRede,_cCodRede,cRaizCNPJ,SA1->A1_EST)
	IF cQryRede == '' 
		cCampos := ", SE1.E1_CLIENTE XA1COD, SE1.E1_LOJA XA1LOJ , E1_NOMCLI "+CHR(10)
		cQuery  := STRTRAN(cQueryOri, 'FROM', cCampos+' FROM')
	Else
	  cQuery  := STRTRAN(cQueryOri, "XA1COD,XA1LOJ,E1_NOMCLI", "SA1.A1_COD XA1COD, SA1.A1_LOJA XA1LOJ, E1_NOMCLI")
	  cSQLSA1   := ", " + RetSqlName("SA1") + " SA1 "+CHR(10)
	  cSQLSA1   += " WHERE SA1.A1_COD||SA1.A1_LOJA = E1_CLIENTE||E1_LOJA "+CHR(10)
	  cSQLSA1   += " AND SA1.D_E_L_E_T_<>'*'  AND "+CHR(10)
	  
	  cQuery  := STRTRAN(cQuery, 'WHERE ',cSQLSA1)
	  cQuery  := STRTRAN(cQuery, "E1_CLIENTE='"+SA1->A1_COD+"'", "E1_CLIENTE <>'' ")
	  cQuery  := STRTRAN(cQuery, "E1_LOJA='"+SA1->A1_LOJA+"'", "E1_LOJA <>'' ")
	  cQuery  += " "+cQryRede
	EndIF
	Memowrite("C:\tEMP\TB1P10U.SQL",cQuery )
ELSE
	cQuery := cQueryori
ENDIF

Return (cQuery)
