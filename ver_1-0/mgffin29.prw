#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
=====================================================================================
Programa.:              MGFFIN29  - PE
Autor....:              Antonio Carlos
Data.....:              04/10/2016
Descricao / Objetivo:   incluir informacoes de Notas Fiscais emitidas por Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir informacoes de Notas Fiscais emitidas por Rede
=====================================================================================
*/
User Function  MGFFIN29(cQueryori)

LOCAL _cCodRede := SA1->A1_ZREDE
LOCAL _cCodCli  := SA1->A1_COD
LOCAL _cLojaCli := SA1->A1_LOJA
Local cRaizCNPJ := Subs(SA1->A1_CGC,1,8)
Local cQryRede  := ""                          
Local cSQLSA1   := ""
Local cCampos   := ""
Local cQuery    := cQueryori



cSQLSA1   := ", " + RetSqlName("SA1") + " SA1 "+CHR(10)
cSQLSA1   += " WHERE SA1.A1_COD||SA1.A1_LOJA = F2_CLIENTE||F2_LOJA "+CHR(10)
cSQLSA1   += " AND SA1.D_E_L_E_T_<>'*'  AND "+CHR(10)
cQuery    := STRTRAN(cQuery, 'WHERE ',cSQLSA1)

IF MV_PAR18 = 1     //MsgNoYes(Pedidos por Rede ?")    //MV_PAR18 := 1
     cCampos := ", SF2.F2_CLIENTE F2_CLIENTE,SF2.F2_LOJA F2_LOJA , SA1.A1_NOME , SA1.A1_COD , 'X' REDE "+CHR(10)
	 cQuery  := STRTRAN(cQuery, 'FROM', cCampos+' FROM')
	  cQryRede := StaticCall(MGFFIN22,QueryRede,_cCodRede,cRaizCNPJ,SA1->A1_EST)
	 cQuery  := STRTRAN(cQuery, "F2_CLIENTE='"+SA1->A1_COD+"'", "F2_CLIENTE <>'' ")
	 cQuery  := STRTRAN(cQuery, "F2_LOJA='"+SA1->A1_LOJA+"'", "F2_LOJA <>'' ")
	 cQuery  += " "+cQryRede
Else
     cCampos := ", SF2.F2_CLIENTE F2_CLIENTE,SF2.F2_LOJA F2_LOJA , SA1.A1_NOME , SA1.A1_COD "+CHR(10)
	 cQuery  := STRTRAN(cQuery, 'FROM', cCampos+' FROM')
EndIF

Return(cQuery)
