#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
=====================================================================================
Programa.:              MGFFIN30 - PE
Autor....:              Antonio Carlos
Data.....:              04/10/2016
Descricao / Objetivo:   apresentar Pedidos por Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              Pedidos por Rede na Posicao do Cliente
=====================================================================================
*/
User Function  MGFFIN30(cQuery)
LOCAL _cCodRede := SA1->A1_ZREDE
LOCAL _cCodCli  := SA1->A1_COD
LOCAL _cLojaCli := SA1->A1_LOJA
Local cRaizCNPJ := Subs(SA1->A1_CGC,1,8)
Local cQryRede  := ""
Local cSQLSA1   := ""

If IsInCallStack("MATA440")
	DbSelectArea("SA1")
	If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		_cCodRede := SA1->A1_ZREDE
		_cCodCli  := SA1->A1_COD
		_cLojaCli := SA1->A1_LOJA
	EndIf
EndIf


cSQLSA1   := ", " + RetSqlName("SA1") + " SA1 "+CHR(10)
cSQLSA1   += " WHERE SA1.A1_COD||SA1.A1_LOJA = C5_CLIENTE||C5_LOJACLI "+CHR(10)
cSQLSA1   += " AND SA1.D_E_L_E_T_<>'*'  AND "+CHR(10)
cQuery  := STRTRAN(cQuery, 'WHERE ',cSQLSA1)

IF MV_PAR18 = 1     //MsgNoYes(Pedidos por Rede ?")    //MV_PAR18 := 1
	 cQryRede := StaticCall(MGFFIN22,QueryRede,_cCodRede,cRaizCNPJ,SA1->A1_EST)
	 cQuery  := STRTRAN(cQuery, "C5_CLIENTE='"+SA1->A1_COD+"'", "C5_CLIENTE <>'' ")
	 cQuery  := STRTRAN(cQuery, "C5_LOJACLI='"+SA1->A1_LOJA+"'", "C5_LOJACLI <>'' ")
	 cQuery  := STRTRAN(cQuery, 'UNION', cQryRede+' UNION')
	 cQuery  += " "+cQryRede
EndIF
	            


Return(cQuery)
