#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)
#define DMPAPER_A4 9
/*
============================================================================================
Programa.:              CRIASXE
Autor....:              Marcelo Carneiro
Data.....:              11/06/2018
Descricao / Objetivo:   Atualizar o controle de Numeracao apos atualizacao do License server.
Doc. Origem:            MIT006 - item 281
Solicitante:            Help desk
Uso......:              
Obs......:              Atualiza somente os registros das tabelas mencionadas no programa
=============================================================================================
*/
User Function xTestCria
Local cUsa   := {{'SC5','C5_NUM'},{'SC7','C7_NUM'},{'SC1','C1_NUM'},{'SCP','CP_NUM'},{'ZZC','ZZC_ORCAME'},{'ZB8','ZB8_ORCAME'},{'ZB1','ZB1_ID'}}
Local nI     := 0
Local cTexto := ''

Private _aMatriz   := {"01","010012"}
RpcSetType(3)
RpcSetEnv(_aMatriz[1],_aMatriz[2])

For nI := 1 To Len(cUsa)
    cTexto += ' Tabela '+cUsa[nI,01]+' campo '+cUsa[nI,02]+' retornou '+U_CRIASXE(cUsa[nI,01],cUsa[nI,02],'TST',0)+CRLF
Next nI

MemoWrite("C:\TEMP\CRIASXE"+StrTran(Time(),":","")+".txt",cTexto)
Return
***************************************************************************************************************************************
User Function CRIASXE()

Local cNum      := NIL
Local aArea     := GetArea()
Local cAlias    := Paramixb[1]
Local cCpoSx8   := Paramixb[2]
Local cAliasSx8 := Paramixb[3]
Local nOrdSX8   := Paramixb[4]
Local cUsa      := GETMV("MGF_TCRSXE")

If cAlias $ cUsa .AND.  ! ( Empty(cAlias) .AND. empty(cCpoSx8) .AND. empty(cAliasSx8) )
	cNum :=Ret_Max(cCpoSx8,cAlias)
Endif

RestArea(aArea)

Return cNum
*************************************************************************************************************************************************
Static Function Ret_Max(cCampo,cTabela)
Local cQuery  := ''
Local cRet    := ''
Local cFilTab := IIF(SubStr(cTabela,1,1)=='S',SubStr(cTabela,2,2),cTabela)

If cTabela == "SC5" // nao pode iniciar com letra o pedido de venda
	If Empty(cCampo)
		cCampo := "C5_NUM"
	EndIf
	cQuery  := " SELECT Max("+cCampo+") RETMAX "
	cQuery  += " FROM "+RetSqlName(cTabela)
	cQuery  += " WHERE D_E_L_E_T_  = ' ' "
	cQuery  += "  AND "+cFilTab+"_FILIAL =  '"+xFilial(cTabela)+"'"
//	cQuery  += "  AND SUBSTR("+cCampo+",1,1) IN ('0','1','2','3','4','5','6','7','8','9') "
	cQuery  += "  AND SUBSTR("+cCampo+",1,3) <> 'REM' "
Else
	cQuery  := " SELECT Max("+cCampo+") RETMAX "
	cQuery  += " FROM "+RetSqlName(cTabela)
	cQuery  += " WHERE D_E_L_E_T_  = ' ' "
	cQuery  += "  AND "+cFilTab+"_FILIAL =  '"+xFilial(cTabela)+"'"
Endif
If Select("QRY_MAX") > 0
	QRY_MAX->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_MAX",.T.,.F.)
dbSelectArea("QRY_MAX")
QRY_MAX->(dbGoTop())
IF !QRY_MAX->(EOF()) .And. !Empty(QRY_MAX->RETMAX)
 	cRet    :=  SOMA1(QRY_MAX->RETMAX)
else //ALTERADO RAFAEL 05/12/2018 - QUANDO � O PRIMEIRO REGISTRO DA FILIAL ESTAVA DANDO ERRO
	cRet    := Nil
endif	
If Select("QRY_MAX") > 0
	QRY_MAX->(dbCloseArea())
EndIf

Return cRet

