#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFTAE12
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada MT120FIM para que bloqueie o pagamento de compra de gado
=============================================================================================
*/


User Function MGFTAE12(nTipo)

Local cQuery := ''                                             
Private cGrupo := GetMV('MGF_TAE12',.F.,'0010') 

Private nViaCad   := nTipo // 1= via Documento de Entrada 2= via modulo Pedido de Abate

cQuery  := " SELECT * "
cQuery  += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1"
cQuery  += " WHERE SD1.D_E_L_E_T_  = ' ' " 
cQuery  += "  AND SB1.D_E_L_E_T_  = ' ' "
cQuery  += "  AND D1_COD     = B1_COD"
cQuery  += "  AND B1_GRUPO   = '"+cGrupo+"'"
cQuery  += "  AND D1_FILIAL  = '"+SF1->F1_FILIAL+"'"
cQuery  += "  AND D1_DOC     = '"+SF1->F1_DOC+"'"
cQuery  += "  AND D1_SERIE   = '"+SF1->F1_SERIE+"'"
cQuery  += "  AND D1_FORNECE = '"+SF1->F1_FORNECE+"'"
cQuery  += "  AND D1_LOJA    = '"+SF1->F1_LOJA+"'"

If Select("QRY_SD1") > 0
	QRY_SD1->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD1",.T.,.F.)
dbSelectArea("QRY_SD1")
QRY_SD1->(dbGoTop())
IF !QRY_SD1->(EOF())
	IF nViaCad == 1    // Via Documento de Entrada
		IF SF1->F1_FORMUL <> 'S'
			cQuery := " Update "+RetSqlName("SE2")
			cQuery += " Set E2_MSBLQL    = '1'"
			cQuery += " Where E2_FILIAL  = '"+xFilial('SE2')+"'"
			cQuery += "   AND E2_PREFIXO = '"+SF1->F1_PREFIXO+"'"
			cQuery += "   AND E2_NUM     = '"+SF1->F1_DOC+"'"
			cQuery += "   AND E2_TIPO    = 'NF'"
			cQuery += "   AND E2_FORNECE = '"+SF1->F1_FORNECE+"'"
			cQuery += "   AND E2_LOJA    = '"+SF1->F1_LOJA+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgStop(TcSQLError())
			EndIF
			MsgAlert('Documento de entrada de compra de Gado, o pagamento foi bloqueado !')
		EndIF
	EndIF
EndIF

Return                                                            
