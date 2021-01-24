#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
=====================================================================================
Programa.:              MGFFIN31 - PE
Autor....:              Antonio Carlos
Data.....:              03/10/2016
Descricao / Objetivo:   incluir informações de Títulos Abertos Credito da Rede \ Titulos Vencidos da Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Títulos Abertos por Rede
Alteração efetuada para incluir clientes com mesmo início do CNPJ
=====================================================================================
*/
User Function MGFFIN31(cQueryOri)
LOCAL cQuery    :=  " "
LOCAL _cCodRede := SA1->A1_ZREDE
LOCAL cRaizCNPJ	:= Substr(SA1->A1_CGC,1,8)
Local cQryRede  := ""                                                          
Local cCampos   := ""
Local cSQLSA1   := ""

IF MV_PAR18 = 1     //MsgNoYes("Titulos Abertos por Rede ?")    //MV_PAR18 := 1
	 cQryRede := StaticCall(MGFFIN22,QueryRede,_cCodRede,cRaizCNPJ,SA1->A1_EST)
EndIF
IF cQryRede == '' 
	cCampos := ", SE1.E1_CLIENTE XA1COD, SE1.E1_LOJA XA1LOJ , E1_NOMCLI "+CHR(10)
	cQuery  := STRTRAN(cQueryOri, 'FRV.FRV_DESCRI', 'FRV.FRV_DESCRI' + cCampos)
Else
  cQuery  := STRTRAN(cQueryOri, "XA1COD,XA1LOJ,E1_NOMCLI", "SA1.A1_COD XA1COD, SA1.A1_LOJA XA1LOJ, E1_NOMCLI")
  cSQLSA1   := ", " + RetSqlName("SA1") + " SA1 "+CHR(10)
  cSQLSA1   += " WHERE SA1.A1_COD||SA1.A1_LOJA = E1_CLIENTE||E1_LOJA "+CHR(10)
  cSQLSA1   += " AND SA1.D_E_L_E_T_<>'*'  AND "+CHR(10)
  cQuery  := STRTRAN(cQuery, 'WHERE ',cSQLSA1)
                            
  cQuery  := STRTRAN(cQuery, "E1_CLIENTE='"+SA1->A1_COD+"'", "E1_CLIENTE <>'' ")
  cQuery  := STRTRAN(cQuery, "E1_LOJA='"+SA1->A1_LOJA+"'", "E1_LOJA <>'' ")
  cQuery  := STRTRAN(cQuery, 'ORDER', cQryRede+' ORDER')
  cQuery  := STRTRAN(cQuery, 'UNION', cQryRede+' UNION')
EndIF
            


Return(cQuery)

*******************************************************************************************************************************************88
User Function MGFF31O()

//Return "E1_NUM+E1_PARCELA+E1_EMISSAO+E1_VALOR+E1_CLIENTE+E1_LOJA+E1_PREFIXO"
Return "E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)+E1_CLIENTE+E1_LOJA+E1_PREFIXO"
