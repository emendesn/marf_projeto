#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            
#include "parmtype.ch"
#include "rwmake.ch"

#Define DS_MODALFRAME 128 


/*/{Protheus.doc} MGFFATB9 (nome da Função)
	Breve descrição... Rotina de registro de motivo de exclusão de pedido de vendas 

	@description
	Rotina de registro de motivo de exclusão de pedido de vendas
	Executada pelo ponto de entrada MT410TOK para solicitar registro de motivo de exclusão de pedido de vendas 

	@author Fabio Costa
	@since 22/08/2019

	@version P12.1.017
	@country Brasil
	@language Português

	@history
	Referente ao problema PRB0040215 - Paulo Henrique - TOTVS - 11/09/2019.
/*/

User Function MGFFATB9()

    Local oDlg
	Private cCod    := Space(06)
	Private cMotivo := space(40)
	Private lRet    := .T.
	
	DEFINE MsDialog oDlg From 196,52 To 345,555 Title "Informe o motivo para excluir este pedido ?" Pixel Style DS_MODALFRAME 
	oDlg:lEscClose := .F.
	@ 05,010 TO 50,250
	@ 10,020 say "Motivo : "
	@ 10,050 get cCod picture "@!" SIZE 40,20 F3 "ZEJ" VALID(FATB9V(cCod,odlg,.F.))
	@ 22,020 say "Descricao : "
	@ 22,050 get cMotivo picture "@!" SIZE 190,40 when .F.
	@ 060,196 BMPBUTTON TYPE 1 ACTION FATB9O(oDlg)
	@ 060,146 BMPBUTTON TYPE 2 ACTION FATB9C(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
   
Return lRet  

Static Function FATB9V(cCod,odlg,_lshow)

	Local cQuery  := ""
	Local nRecZEJ := 0
	Local _lret := .T.

	cQuery := "SELECT ZEJ_FILIAL, ZEJ_CODIGO, ZEJ_DESCR, ZEJ_MSBLQL, R_E_C_N_O_ AS RECNOZEJ "  
	cQuery += "FROM"+RetSqlName("ZEJ") + " ZEJ "
	cQuery += "WHERE ZEJ.D_E_L_E_T_ <> '*' " 
	cQuery += "AND ZEJ_CODIGO = '"+cCod+"' "
	cQuery += "AND ZEJ_MSBLQL <> '1' "

	Iif(Select("TRB01")>0,TRB01->(dbCloseArea()),Nil)
	
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "TRB01"
	
	dbSelectArea("TRB01")
	dbSelectArea("ZEJ")
	
	If TRB01->(Eof()) .and. _lshow
		msgbox("Registro inválido","Atenção")
		_lret := .F.
	Endif

	cMotivo := TRB01->ZEJ_DESCR
	oDlg:Refresh()
	processmessages()

Return _lret

Static Function FATB9O(oDlg)

    Local cQuery  := ""
    Local cCli    := SC5->C5_CLIENTE
    Local cLoj    := SC5->C5_LOJACLI

	If FATB9V(cCod,odlg,.T.)
    
		ZEI->(RecLock("ZEI",.T.))
		ZEI->ZEI_FILIAL  := SC5->C5_FILIAL 
		ZEI->ZEI_PEDIDO  := SC5->C5_NUM
		ZEI->ZEI_CLIENT  := SC5->C5_CLIENTE
		ZEI->ZEI_LOJA    := SC5->C5_LOJACLI
		ZEI->ZEI_RAZAO   := POSICIONE("SA1",1,xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		ZEI->ZEI_EMISSAO := SC5->C5_EMISSAO
		ZEI->ZEI_EMBARQ  := SC5->C5_ZDTEMBA
		ZEI->ZEI_ENTREG  := SC5->C5_FECENT 
		ZEI->ZEI_ESPECI  := SC5->C5_ZTIPPED
		ZEI->ZEI_PESO    := SC5->C5_PESOL
		ZEI->ZEI_PESOB   := SC5->C5_PBRUTO
		ZEI->ZEI_DTEXCL  := Date()
		ZEI->ZEI_CODMOT  := cCod
		ZEI->ZEI_DESCMO  := cMotivo 
		ZEI->ZEI_DATA    := DATE()
		ZEI->ZEI_HORA    := TIME()
		ZEI->ZEI_USER    := cusername
		ZEI->(MsUnlock())
	
		Close(oDlg)

	Endif
	
Return Nil

Static Function FATB9C(oDlg)

	Close(oDlg)
	msgbox("Motivo não informado, pedido não será excluido!","Atenção")
	lret := .F.

Return