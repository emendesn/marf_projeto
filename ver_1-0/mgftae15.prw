#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)
#define DMPAPER_A4 9
/*
============================================================================================
Programa.:              MGFTAE15
Autor....:              Marcelo Carneiro
Data.....:              22/11/2016
Descricao / Objetivo:   Integracao TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              MANUTEN��O DO Boletim DE ABATE
=============================================================================================
*/
User Function MGFTAE15
Private cCadastro := "Boletim de Abate"
Private aRotina   := { {"Pesquisar"          ,"AxPesqui"           ,0, 1} ,;
		               {"Visualizar"	     ,"U_TAE15_MAN"        ,0, 2, 0, NIL},;
		               {"Alterar"   	     ,"U_TAE15_MAN"        ,0, 4, 0, NIL},;
		               {"Estornar"  	     ,"U_TAE15_EXC"        ,0, 5} ,;
		               {"Emite NF Entrada"   ,"U_TAE15_EFETIVA(1)" ,0, 4} ,;
		               {"Efetiva"   	     ,"U_TAE15_EFETIVA(2)" ,0, 4} ,;
		               {"Agrupar Boletins"   ,"U_TAE15_AGR"        ,0, 4} ,;
		               {"Relatorio Abate"    ,"U_MGFINT26"         ,0, 2} ,;
		               {"Controle de Acertos","U_MGFINT51"         ,0, 2} ,;
		               {"Nota Promissoria"   ,"U_TAE15_NP"         ,0, 2} ,;
		               {"Cancela Efetiva��o" ,"U_TAE15_EFETIVA(3)" ,0, 4} ,;
		               {"Relatorio OUF"      ,"U_MGFINT50"         ,0, 2} ,;
		               {"Terceiro"	         ,"U_TAE15_TER"        ,0, 3, 0, NIL},;
                       {"Legenda"   	     ,"U_TAE15_Legenda"    ,0, 2 }}

Private cDelFunc  := ".T."
Private aCores    := { {'ZZM_STATUS=="1"','ENABLE' },;
					   {'ZZM_STATUS=="2"','BR_AMARELO' },;
					   {'ZZM_STATUS=="3"','BR_AZUL' },;
					   {'ZZM_STATUS=="4"','DISABLE' },;
					   {'ZZM_STATUS=="5"','BR_CINZA'},;
					   {'ZZM_STATUS=="6"','BR_PINK'}}

ChkFile("ZZM")
ChkFile("ZZN")
ChkFile("ZZO")
ChkFile("ZZP")
ChkFile("ZZQ")
ChkFile("ZDU")

// Criacao dos SXB para melhoria de performance das consultas padr�es especificas do programa
cFuncao := 'u_zTAE_05()'
u_zCriaCEsp("TAE_5A", "Nota Compl. de Valor", "SF1", cFuncao, "__cRetorn", {'F1_FILIAL','F1_FORNECE','F1_LOJA','F1_DOC','F1_SERIE'})

cFuncao := 'u_zTAE_06()'
u_zCriaCEsp("TAE_6A", "Nota Devolucao de Valor", "SF2", cFuncao, "__cRetorn", {'F2_FILIAL','F2_CLIENTE','F2_LOJA','F2_DOC','F2_SERIE'})

dbSelectArea("ZZM")
dbSetOrder(1)

mBrowse( 6,1,22,75,"ZZM",,,,,,aCores)

Return
**************************************************************************************************
User Function TAE15_Legenda()
Local aLegenda:= {}

/*
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
Private bPassou := .T.
Processa( {|| Gera_Doc_Entrada(@bPassou) },'Aguarde...', 'Efetivando Boletim de Abate - Gerando Nota',.F. )
Gera_Mov_OP()


Processa( {|| U_CPA999(2) },'Aguarde...', 'Atualizando Dados Banc�rios',.F. )

  */


AADD(aLegenda, {""	 ,'Produtor Emite nota fiscal Eletronica'})
AADD(aLegenda, {""	 ,'-------------------------------------'})
AADD(aLegenda, {"ENABLE"	 ,'Falta Vincular Notas'})
AADD(aLegenda, {"BR_AMARELO" ,'Quantidade Divergente'})
AADD(aLegenda, {"BR_PINK"	 ,'Boletim Agrupado'})
AADD(aLegenda, {"BR_AZUL"    ,'Pendente Movimento de Estoque '})
AADD(aLegenda, {"DISABLE"	 ,'Diferen�a de Valor'})
AADD(aLegenda, {"BR_CINZA"	 ,'Encerrado'})
AADD(aLegenda, {""	 ,'Produtor NAO emite nota fiscal Eletronica'})
AADD(aLegenda, {""	 ,'-----------------------------------------------'})
AADD(aLegenda, {"ENABLE"	 ,'Processo Iniciado'})
AADD(aLegenda, {"BR_AZUL"    ,'Notas Vinculadas'})
AADD(aLegenda, {"BR_AMARELO" ,'Boletim Agrupado'})
AADD(aLegenda, {"DISABLE"	 ,'Nota Emitida-Pendente Movi. Estoque'})
AADD(aLegenda, {"BR_CINZA"	 ,'Encerrado'})
BrwLegenda('Boletim de Abate','Taura',aLegenda)

Return
**************************************************************************************************
User Function TAE15_MAN( cAlias, nReg, nOpc )

Local nI        := 0
Local nOpcA     := 0
Local bEncerra  := .F.

Private aHeader := {}
Private aCols   := {}
Private aREG    := {}
Private aREGDEL := {}
Private aREGINC := {}
Private bCampo  := { | nField | FieldName(nField) }
Private aSize   := {}
Private aOBJ    := {}
Private aInfo   := {}
Private aPObj   := {}
Private aAlter  := {'ZZN_QTPE','ZZN_CODAGR'}
Private oDlg
Private oGet
Private aButtons   :={}

Private aCpos      :={}
Private cFILNFE    := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.)) //IIF(ZZM->ZZM_EMITE=='S',.T.,.F.)
Private aProdutor  := {}
Private aRecProd   := {}
Private bAlterou   := .F.

IF nOpc == 3 //Alteracao
	IF ZZM->ZZM_STATUS == '5' .and. !Empty(ZZM->ZZM_DOC)
		MsgAlert('Nao � possivel alterar, Boletim encerrado !!')
		Return
	EndIF
	IF (ZZM->ZZM_STATUS == '2' .And. bEmite) .OR. (ZZM->ZZM_STATUS == '6' .And. !bEmite )
		MsgAlert('Nao � possivel alterar, Boletim Agrupado !!')
		Return
	EndIF
	IF ZZM->ZZM_STATUS == '5' .and. Empty(ZZM->ZZM_DOC)
		AAdd(aButtons , {"GTA" ,       {|| U_TAE15_GTA(.F.)},"Guia Transporte Animal","Guia Transporte Animal",{|| .T.}})
		AAdd(aButtons , {"NF Produtor",{|| U_TAE15_Prod(.F.)},"Nota Fiscal Produtor","Nota Fiscal Produtor",{|| .T.}})
		AAdd(aButtons , {"NF Compl/Devol",   {|| U_TAE15_NFC(.F.)},"Nota fiscal Complementar/Devolucao","Nota fiscal Complementar/Devolucao",{|| .T.}})
	   aCpos :={"ZZM_VENCE", "ZZM_VLDESC","ZZM_VLACR","ZZM_VICMS",'ZZM_VNFP','ZZM_ICMSNP','ZZM_ROMAN','ZZM_DTROMA','ZZM_ADIAN','ZZM_DESPEC','ZZM_ICMSFR','ZZM_OBS'}
	Else
		AAdd(aButtons , {"GTA" ,       {|| U_TAE15_GTA(.T.)},"Guia Transporte Animal","Guia Transporte Animal",{|| .T.}})
		AAdd(aButtons , {"NF Produtor",{|| U_TAE15_Prod(.T.)},"Nota Fiscal Produtor","Nota Fiscal Produtor",{|| .T.}})
		IF !bEmite .And. ZZM->ZZM_STATUS == '4'
			AAdd(aButtons , {"NF Compl/Devol",   {|| U_TAE15_NFC(.T.)},"Nota fiscal Complementar/Devolucao","Nota fiscal Complementar/Devolucao",{|| .T.}})
		Else
			AAdd(aButtons , {"NF Compl/Devol",   {|| U_TAE15_NFC(.F.)},"Nota fiscal Complementar/Devolucao","Nota fiscal Complementar/Devolucao",{|| .T.}})
			aCpos :={"ZZM_VENCE","ZZM_VLDESC","ZZM_VLACR","ZZM_VICMS",'ZZM_VNFP','ZZM_ICMSNP','ZZM_ROMAN','ZZM_DTROMA','ZZM_ADIAN','ZZM_DESPEC','ZZM_ICMSFR','ZZM_OBS'}
			IF SUBSTR(ZZM->ZZM_PEDIDO,1,1) == 'T'
				aCpos :={"ZZM_VENCE","ZZM_BANCO",'ZZM_TIPOC','ZZM_FAV',"ZZM_AGENCI","ZZM_CONTA","ZZM_VLDESC","ZZM_VLACR","ZZM_VICMS",'ZZM_VNFP','ZZM_ICMSNP',;
						 'ZZM_ROMAN','ZZM_DTROMA','ZZM_ADIAN','ZZM_DESPEC','ZZM_ICMSFR','ZZM_OBS'}
				AAdd(aButtons , {"Inclui Item", {|| U_TAE15_IT(1)}    ,"Inclui Itens no Boletim ","Inclui Itens no Boletim ",{|| .T.}})
				AAdd(aButtons , {"Exclui Item", {|| U_TAE15_IT(2)}    ,"Exclui Itens no Boletim","Exclui Itens no Boletim",{|| .T.}})
			EndIF
		EndIF
		AAdd(aButtons , {"Modifica Agrupador", {|| U_TAE15_MG()}    ,"Modifica o Codigo do Agrupador","Modifica o Codigo do Agrupador",{|| .T.}})
	EndIF
ElseiF nOpc == 2 //Visualizar
	AAdd(aButtons , {"GTA" ,       {|| U_TAE15_GTA(.F.)},"Guia Transporte Animal","Guia Transporte Animal",{|| .T.}})
	AAdd(aButtons , {"NF Produtor",{|| U_TAE15_Prod(.F.)},"Nota Fiscal Produtor","Nota Fiscal Produtor",{|| .T.}})
EndIF

IF ZZM->ZZM_STATUS == '4' .OR. (ZZM->ZZM_STATUS == '5' .and. !Empty(ZZM->ZZM_DOC)) .Or. (ZZM->ZZM_STATUS == '2' .And. bEmite) .OR. (ZZM->ZZM_STATUS == '6' .And. !bEmite )
	aAlter  := {}
	aCpos    :={}
Else
    aAlter  := {'ZZN_QTPE'}
EndIF
aSize := MsAdvSize()
AAdd(aOBJ,{100,120,.T.,.F.})
AAdd(aOBJ,{100,50,.T.,.T.})  //75
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
aPObj := MsObjSize( aInfo, aObj )

//Montando o cabecalho
dbSelectArea( cAlias )
dbSetOrder(1)
For nI := 1 To FCount()
	M->&( Eval( bCampo, nI ) ) := FieldGet( nI )
Next nI

//Montando o Header do Itens
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZN"))
While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "ZZN"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. Alltrim(SX3->X3_CAMPO) <> 'ZZN_PEDIDO'  .AND. Alltrim(SX3->X3_CAMPO) <>'ZZN_ACRESC'
	   	AADD( aHeader, { Trim( X3Titulo() ),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT})
	Endif
	SX3->(dbSkip())
EndDo
//Coloca o Campo do Produto Agrupador
//AADD( aHeader, {  'Agrupador','ZZN_AGRUP','@!',15,0,'','','C','',''})

// Preenche os Itens
dbSelectArea('ZZN')
dbSetOrder(1)
ZZN->(dbSeek( ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO ))
While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ ZZM->ZZM_PEDIDO
	AAdd( aREG, ZZN->( RecNo() ) )
	AAdd( aCols, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		If aHeader[nI,10] == "V"
			aCols[Len(aCols),nI] := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+ZZN->ZZN_PRODUT, 1, "" )
		Else
			aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
		Endif
	Next nI
	//aCols[Len(aCols),Len(aHeader)]   := GetAdvFVal( "SB1", "B1_ZCODAGR", xFilial('SB1')+ZZN->ZZN_PRODUT, 1, "" )
	aCols[Len(aCols),Len(aHeader)+1] := .F.
    ZZN->(dbSkip())
End

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd Pixel

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1],aCpos)

	oGet := MsNewGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],GD_UPDATE ,"AllwaysTrue","AllwaysTrue",,aAlter,0,999 ,"U_TAE15_VAL","","AllwaysTrue",oDlg,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
					  {||  nOpcA := 1, oDlg:End() ,NIL  },;
	                  {|| oDlg:End() },,@aButtons)
If nOpcA == 1 .And. ( nOpc == 3 .Or. nOpc == 4 )
    TAE15_GRV( nOpc, aREG )
Else
    IF  nOpc == 3
    	For nI := 1 To Len( aREGINC )
			ZZN->(dbGoto( aREGINC[nI] ))
			Reclock("ZZN",.F.)
			ZZN->(dbDelete())
			ZZN->(MsUnlock())
		Next nX
    EndIF
Endif

Return
*******************************************************************************************************************************
User Function TAE15_VAL()
Local bRet       := .T.
Local nPos       := oGet:oBrowse:nColPos
Local nDiferenca := 0
Local nPosQTCab  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_QTCAB' })
Local nPosQTPE   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_QTPE' })
Local nPosAGR    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_CODAGR' })

dbSelectArea('SB1')
SB1->(dbSetOrder(1))

IF nPos == nPosQTPE
	IF M->ZZN_QTPE > oGet:aCols[oGet:nAt][nPosQTCab]
		bRet := .F.
		MsgAlert('A Quantidade de Perda nao pode ser maior que a quantidade de cabe�as abatidas !!')
	EndIf
EndIF

Return bRet
*************************************************************************************************************************
Static Function TAE15_GRV( nOpc, aAltera  )
Local nX := 0
Local nPosQTPE   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_QTPE' })
Local nPosQTCAB  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_QTCAB' })
Local nPosQTKG   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_QTKG' })
Local nPosVLARRO := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_VLARRO' })
Local nPosVLTOT  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_VLTOT' })
Local nPosITEM   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_ITEM' })
Local nPosAGR    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZN_CODAGR' })
Local nI         := 1
Local bEncerra   := .T.

If nOpc == 3
	dbSelectArea("ZZN")
	ZZN->(dbSetOrder(1))
	For nX := 1 To Len( oGet:aCols )
		If nX <= Len( aREG )
			ZZN->(dbGoto( aREG[nX] ))
			RecLock("ZZN",.F.)
			ZZN->ZZN_QTPE     := oGet:aCols[nX,nPosQTPE]
			ZZN->ZZN_QTCAB    := oGet:aCols[nX,nPosQTCAB]
			ZZN->ZZN_QTKG     := oGet:aCols[nX,nPosQTKG]
			ZZN->ZZN_VLARRO   := oGet:aCols[nX,nPosVLARRO]
			ZZN->ZZN_VLTOT    := oGet:aCols[nX,nPosVLTOT]
			ZZN->ZZN_CODAGR   := oGet:aCols[nX,nPosAGR]
			ZZN->(MsUnLock())
		Endif
	Next nX
	For nX := 1 To Len( aREGDel )
		ZZN->(dbGoto( aREGDel[nX] ))
		Reclock("ZZN",.F.)
		ZZN->(dbDelete())
		ZZN->(MsUnlock())
	Next nX
    IF SUBSTR(ZZM->ZZM_PEDIDO,1,1) == 'T'
		dbSelectArea('ZZN')
		dbSetOrder(1)
		ZZN->(dbSeek( ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO ))
		While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ ZZM->ZZM_PEDIDO
				RecLock("ZZN",.F.)
				ZZN->ZZN_ITEM     := STRZERO(nI,2)
				ZZN->(MsUnLock())
				nI  += 1

		    ZZN->(dbSkip())
		End
	 EndIF
	IF bEmite
		dbSelectArea("ZZM")
		RecLock("ZZM", .F. )
		ZZM->ZZM_VLDESC := M->ZZM_VLDESC
	    ZZM->ZZM_VLACR  := M->ZZM_VLACR
	    ZZM->ZZM_VICMS  := M->ZZM_VICMS
	    ZZM->ZZM_VNFP   := M->ZZM_VNFP
		ZZM->ZZM_ICMSNP := M->ZZM_ICMSNP
		ZZM->ZZM_BANCO  := M->ZZM_BANCO
		ZZM->ZZM_AGENCI := M->ZZM_AGENCI
		ZZM->ZZM_CONTA  := M->ZZM_CONTA
		ZZM->ZZM_VNFP   := M->ZZM_VNFP
		ZZM->ZZM_ICMSNP := M->ZZM_ICMSNP
		ZZM->ZZM_ROMAN  := M->ZZM_ROMAN
		ZZM->ZZM_DTROMA := M->ZZM_DTROMA
		ZZM->ZZM_ADIAN  := M->ZZM_ADIAN
		ZZM->ZZM_DESPEC := M->ZZM_DESPEC
		ZZM->ZZM_ICMSFR := M->ZZM_ICMSFR
		ZZM->ZZM_OBS    := M->ZZM_OBS
		ZZM->ZZM_TIPOC  := M->ZZM_TIPOC
		ZZM->ZZM_FAV    := M->ZZM_FAV
		ZZM->ZZM_VENCE  := M->ZZM_VENCE
	    ZZM->(MsUnLock())
	Else
		dbSelectArea("ZZM")
		RecLock("ZZM", .F. )
		ZZM->ZZM_OBS    := M->ZZM_OBS
		ZZM->ZZM_VENCE  := M->ZZM_VENCE
	    ZZM->(MsUnLock())
	EndIF
	IF ZZM->ZZM_STATUS ='4' .And. !Empty(M->ZZM_DOCC)
		Reclock("ZZM",.F.)
		ZZM->ZZM_DOCC   := M->ZZM_DOCC
		ZZM->ZZM_SERC   := M->ZZM_SERC
		ZZM->ZZM_STATUS := '5'
		ZZM->(MsUnlock())
    EnDIF

Endif

Return
******************************************************************************************************************************************************************
User Function TAE15_EXC
Local cFILPED := ZZM->ZZM_FILIAL
Local cPedido := ZZM->ZZM_PEDIDO
Local cQuery  := ''
Local bContinua := .F.

IF ZZM->ZZM_STATUS $ '45'
	MsgAlert('Boletim de Abate j� efetivado, nao � possivel estornar !!')
Else
	IF !Empty(ZZM->ZZM_AGRUP) .And. SUBSTR(ZZM->ZZM_PEDIDO,1,1)<>'A'
	     MsgAlert('Boletim de Abate sofreu um agrupamento, impossivel estornar !!')
	     Return
	EndIF
	IF MsgYESNO('Deseja excluir o Boletim de Abate ?')
		IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)=='A' .OR. SUBSTR(ZZM->ZZM_PEDIDO,1,1)=='T'
			bContinua := .T.
		Else
		    IF ZZM->ZZM_ENVIA  == 'S'
		    	MsgAlert('Boletim de Abate aguardando envio para o Taura, favor aguardar !!')
	     	    Return
		    EndIF
		    IF U_MGFTAE17(cFILPED,cPedido,'3','','')
		    	bContinua := .T.// Verifica_Taura Metodo consulta
		    EndIF
		EndIF
		IF  bContinua
		  BEGIN TRANSACTION
			IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)=='A'
				cQuery := " Update  "+RetSqlName("ZZM")
				cQuery += " SET ZZM_AGRUP   = '       ',"
				cQuery += "     ZZM_STATUS  = '1'"
				cQuery += " Where ZZM_FILIAL = '"+cFILPED+"'"
				cQuery += "   AND ZZM_AGRUP  = '"+cPedido+"'"
				IF (TcSQLExec(cQuery) < 0)
					bContinua   := .F.
					MsgAlert('Erro ao Excluir: '+TcSQLError())
				EndIF
			EndIF
			//ZZM
			cQuery := " Delete From  "+RetSqlName("ZZM")
			cQuery += " Where ZZM_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZM_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF
			//ZZN
			cQuery := " Delete From  "+RetSqlName("ZZN")
			cQuery += " Where ZZN_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZN_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF
			//ZZO
			cQuery := " Delete From  "+RetSqlName("ZZO")
			cQuery += " Where ZZO_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZO_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF
			//ZZP
			cQuery := " Delete From  "+RetSqlName("ZZP")
			cQuery += " Where ZZP_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZP_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF
			//ZZQ
			cQuery := " Delete From  "+RetSqlName("ZZQ")
			cQuery += " Where ZZQ_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZQ_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF
			cQuery := " Delete From  "+RetSqlName("ZDU")
			cQuery += " Where ZDU_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZDU_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF

			//IF SUBSTR(cPedido,1,1) <> 'A'
			 //   U_MGFTAE17(cFILPED,cPedido,'3','','')
			///EndIF
		 END TRANSACTION
		EndIF
	EndIF
EndIf


Return
******************************************************************************************************************************************************************
User Function TAE15_GTA(bInclui)
Local oBtn
Local oDlg1

Private aGTA      := {}
Private aRecGTA   := {}
Private oListGTA  := {}

Dados_GTA()

DEFINE MSDIALOG oDlg1 TITLE "GTA-Guia de Transporte Animal" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

	@ 007, 005 LISTBOX oListGTA	 Fields HEADER "Numero do GTA" SIZE 143,127 OF oDlg1 COLORS 0, 16777215 PIXEL
	oListGTA:SetArray(aGTA)
	oListGTA:nAt := 1
	oListGTA:bLine := { || {aGTA[oListGTA:nAt,1]}}

	IF bInclui
		oBtn := TButton():New( 137, 005 ,'Incluir'    , oDlg1,{|| Cad_GTA() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 137, 090 ,'Excluir'    , oDlg1,{|| Exc_GTA() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	EndIF

  ACTIVATE MSDIALOG oDlg1 CENTERED

Return
*********************************************************************************************************************************************
Static Function Dados_GTA

Local cQuery := ''

aGTA    :={}
aRecGTA := {}
cQuery := " SELECT ZZQ_GTA, R_E_C_N_O_  REGATU  "
cQuery += " FROM "+RetSQLName("ZZQ")
cQuery += " WHERE ZZQ_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZQ_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZQ_GTA "
If Select("QRY_GTA") > 0
	QRY_GTA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_GTA",.T.,.F.)
dbSelectArea("QRY_GTA")
QRY_GTA->(dbGoTop())
While !QRY_GTA->(EOF())
    AADD(aGTA,{QRY_GTA->ZZQ_GTA})
    AADD(aRecGTA,QRY_GTA->REGATU)
    QRY_GTA->(dbSkip())
EndDo

If Len(aGTA) == 0
	AADD(aGTA,{""})
EndIF

Return
*********************************************************************************************************************************************
Static Function Cad_GTA()
Local cGTA := Space(15)
Local oButton2
Static oDLG2


DEFINE MSDIALOG oDLG2 TITLE "Entre com Numero do GTA" FROM 000, 000  TO 080, 296 COLORS 0, 16777215 PIXEL
	@ 008, 002 SAY  "GTA :"   SIZE 028, 009 OF oDLG2              COLORS 0, 16777215 PIXEL
	@ 006, 025 MSGET  cGTA    SIZE 123, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	oBtn := TButton():New( 021, 095 ,'Confirmar'    , oDlg2,{|| oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
ACTIVATE MSDIALOG oDLG2 CENTERED

IF !Empty(cGTA)
	Reclock("ZZQ",.T.)
	ZZQ->ZZQ_FILIAL := ZZM->ZZM_FILIAL
	ZZQ->ZZQ_PEDIDO	:= ZZM->ZZM_PEDIDO
	ZZQ->ZZQ_GTA    := cGTA
	ZZQ->(MsUnlock())

	Dados_GTA()
	oListGTA:SetArray(aGTA)
	oListGTA:nAt := 1
	oListGTA:bLine := { || {aGTA[oListGTA:nAt,1]}}
    oListGTA:Refresh()

EndIF
Return

*********************************************************************************************************************************************
Static Function Exc_GTA()

IF Len(aRecGTA)<> 0
	IF MsgYESNO('Exclui GTA ?')
		ZZQ->(dbGoTo(aRecGTA[oListGTA:nAt]))
		Reclock("ZZQ",.F.)
		ZZQ->(dbDelete())
		ZZQ->(MsUnlock())
		Dados_GTA()
		oListGTA:SetArray(aGTA)
		oListGTA:nAt := 1
		oListGTA:bLine := { || {aGTA[oListGTA:nAt,1]}}
		oListGTA:Refresh()
	EndIF
EndIF

Return

******************************************************************************************************************************************************************
User Function TAE15_Prod(bInclui)
Local oBtn
Local oDlg1
local bReabre := .F.
Private aListNF    := {}
Private oListProd
Private oListNF
Private oListSel
Private bQtdDirv  := .T.
/*
IF bEmite

	Dados_Produtor()

	DEFINE MSDIALOG oDlg1 TITLE "Nota Fiscal do Produtor" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

		@ 007, 005 LISTBOX oListProd Fields HEADER "Documento","Serie" SIZE 143,127 OF oDlg1 COLORS 0, 16777215 PIXEL
		oListProd:SetArray(aProdutor)
		oListProd:nAt := 1
		oListProd:bLine := { || {aProdutor[oListProd:nAt,1], aProdutor[oListProd:nAt,2]}}

		IF bInclui
			oBtn := TButton():New( 137, 005 ,'Incluir'    , oDlg1,{|| Cad_Produtor() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
			oBtn := TButton():New( 137, 090 ,'Excluir'    , oDlg1,{|| Exc_Produtor() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		EndIF

	ACTIVATE MSDIALOG oDlg1 CENTERED
Else
*/
IF ZZM->ZZM_STATUS == '3'
      bReabre := .T.
EndIF
    IF !Dados_NF()
         msgAlert('Existe produto sem agrupador ! Favor verificar!')
    Else
		IF bAlterou
		 	msgAlert('Foi alterado Agrapador, favor salvar os dados e retornar !!')
		 	Return
		EndIF
		IF ZZM->ZZM_STATUS == '3' .And. bReabre
		    IF MsgYESNO('Vc quer reabrir a a etapa de "Vincular Notas" ?')
		        Reclock("ZZM",.F.)
		        ZZM->ZZM_STATUS := '1'
		        ZZM->(MsUnlock())
			EndIF
		EndIf


		DEFINE MSDIALOG oDlg2 TITLE "Nota Fiscal do Produtor" FROM 000, 000  TO 300, 580 COLORS 0, 16777215 PIXEL

			@ 007, 005 LISTBOX oListNF Fields HEADER "Produto","Descricao","Qtde. Total","Qtd. Selecionada" SIZE 283,50 OF oDlg2 COLORS 0, 16777215 PIXEL
			oListNF:SetArray(aListNF)
			oListNF:nAt := 1
			oListNF:bChange := {||Atu_dados_NF()}
			oListNF:bLine := { || {aListNF[oListNF:nAt,1], aListNF[oListNF:nAt,2], aListNF[oListNF:nAt,3], aListNF[oListNF:nAt,4]}}

			@ 065, 005 LISTBOX oListSel Fields HEADER "Documento","Serie","Prod.Auxiliar","Quantidade" SIZE 283,65 OF oDlg2 COLORS 0, 16777215 PIXEL
			oListSel:SetArray(aListNF[oListNF:nAt,5])
			oListSel:nAt := 1
			oListSel:bLine := { || {aListNF[oListNF:nAt,5][oListSel:nAt,1], aListNF[oListNF:nAt,5][oListSel:nAt,2], aListNF[oListNF:nAt,5][oListSel:nAt,3], aListNF[oListNF:nAt,5][oListSel:nAt,4]}}

			IF bInclui .And. ZZM->ZZM_STATUS  $ '12'
			    oBtn := TButton():New( 137, 005 ,'Incluir'     , oDlg2,{|| Cad_NF(1) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
			    oBtn := TButton():New( 137, 065 ,'Outro Codigo', oDlg2,{|| Cad_NF(2) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
				oBtn := TButton():New( 137, 240 ,'Excluir'     , oDlg2,{|| Exc_NF() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
			EndIF
		ACTIVATE MSDIALOG oDlg2 CENTERED
	EndIF
//EndIF

Return
*********************************************************************************************************************************************
Static Function Dados_Produtor

Local cQuery := ''
Local bRet   := .T.

aProdutor  :={}
aRecProd   := {}
cQuery := " SELECT ZZP_DOC,ZZP_SERIE, ZZP_QTD, R_E_C_N_O_  REGATU  "
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZP_DOC, ZZP_SERIE "
If Select("QRY_PROD") > 0
	QRY_PROD->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PROD",.T.,.F.)
dbSelectArea("QRY_PROD")
QRY_PROD->(dbGoTop())
While !QRY_PROD->(EOF())
    AADD(aProdutor,{QRY_PROD->ZZP_DOC,QRY_PROD->ZZP_SERIE})
    AADD(aRecProd,QRY_PROD->REGATU)
    QRY_PROD->(dbSkip())
EndDo

If Len(aProdutor) == 0
	AADD(aProdutor,{"",""})
	bRet   := .F.
EndIF

Return bRet
*********************************************************************************************************************************************
Static Function Cad_Produtor()
Local cNF       := Space(09)
Local cSerie    := Space(03)
Local oButton2
Private oDLG2

DEFINE MSDIALOG oDLG2 TITLE "Entre com Nota Fiscal Produtor" FROM 000, 000  TO 080, 296 COLORS 0, 16777215 PIXEL
	@ 008, 002 SAY  "NF:"    SIZE 028, 009 OF oDLG2              COLORS 0, 16777215 PIXEL
	@ 006, 025 MSGET  cNF    SIZE 040, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	@ 008, 075 SAY  "Serie:" SIZE 028, 009 OF oDLG2              COLORS 0, 16777215 PIXEL
	@ 006, 103 MSGET  cSerie SIZE 020, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	oBtn := TButton():New( 021, 095 ,'Confirmar'    , oDlg2,{|| oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
ACTIVATE MSDIALOG oDLG2 CENTERED

IF Empty(cNF) .OR. Empty(cSerie)
	MsgAlert('Nota fiscal ou Serie em Branco !!')
Else

	Reclock("ZZP",.T.)
	ZZP->ZZP_FILIAL := ZZM->ZZM_FILIAL
	ZZP->ZZP_PEDIDO	:= ZZM->ZZM_PEDIDO
	ZZP->ZZP_DOC    := cNF
	ZZP->ZZP_SERIE  := cSerie
	ZZP->ZZP_QTD    := 0
	ZZP->(MsUnlock())

	Dados_Produtor()
	oListProd:SetArray(aProdutor)
	oListProd:nAt := 1
	oListProd:bLine := { || {aProdutor[oListProd:nAt,1], aProdutor[oListProd:nAt,2]}}
	oListProd:Refresh()
EndIF

Return

*********************************************************************************************************************************************
Static Function Exc_Produtor()

IF Len(aRecProd)<> 0
	IF MsgYESNO('Exclui relacionamento da NF ?')
		ZZP->(dbGoTo(aRecProd[oListProd:nAt]))
		Reclock("ZZP",.F.)
		ZZP->(dbDelete())
		ZZP->(MsUnlock())
		Dados_Produtor()
		oListProd:SetArray(aProdutor)
		oListProd:nAt := 1
		oListProd:bLine := { || {aProdutor[oListProd:nAt,1], aProdutor[oListProd:nAt,2]}}
		oListProd:Refresh()
	EndIF
EndIF

Return
*********************************************************************************************************************************************
Static Function Dados_NF
Local cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Local cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Local bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))


Local cQuery := ''
Local bRet   := .T.
Local aRec   := {}
Local aRec2  := {}
Local nQuant := 0
Local bIgual := .T.

dbSelectArea('ZZP')
ZZP->(dbSetOrder(2))
aListNF  :={}
cQuery := " SELECT ZZN_CODAGR B1_ZCODAGR, SUM(ZZN_QTCAB+ZZN_QTPE) QTD_CAB"
cQuery += " FROM "+RetSQLName("ZZN")+' ZZN, '+RetSQLName("SB1")+' SB1'
cQuery += " Where ZZN.D_E_L_E_T_ = ' '"
cQuery += "   AND SB1.D_E_L_E_T_ = ' '"
cQuery += "   AND B1_COD     = ZZN_PRODUT"
cQuery += "   AND B1_FILIAL  = '"+xFilial('SB1')+"'"
cQuery += "   AND ZZN_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZN_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND ZZN_PRODUT <= '500000'"
cQuery += " Group BY ZZN_CODAGR  "
cQuery += " ORDER BY ZZN_CODAGR "

If Select("QRY_PROD") > 0
	QRY_PROD->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PROD",.T.,.F.)
dbSelectArea("QRY_PROD")
QRY_PROD->(dbGoTop())
While !QRY_PROD->(EOF())
    IF EMPTY(QRY_PROD->B1_ZCODAGR)
        bRet  := .F.
    EndIF
    aRec   := {}
    nQuant := 0
    AAdd(aRec,QRY_PROD->B1_ZCODAGR)
    AAdd(aRec,Alltrim(GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+QRY_PROD->B1_ZCODAGR, 1, "" )))
    AAdd(aRec,QRY_PROD->QTD_CAB)
    AAdd(aRec,0)
    AAdd(aRec,0)
    AADD(aListNF,aRec)

    aRec   := {}
    ZZP->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO+QRY_PROD->B1_ZCODAGR))
    While !ZZP->(EOF()).And.;
		   ZZP->ZZP_FILIAL == ZZM->ZZM_FILIAL .And.;
		   ZZP->ZZP_PEDIDO == ZZM->ZZM_PEDIDO .And.;
		   ZZP->ZZP_PRODUT == QRY_PROD->B1_ZCODAGR
           AAdd(aRec, {ZZP->ZZP_DOC, ZZP->ZZP_SERIE,ZZP->ZZP_CODAUX,ZZP->ZZP_QTD,ZZP->(Recno()) })
           nQuant += ZZP->ZZP_QTD
         ZZP->(dbSkip())
    Enddo
    aListNF[Len(aListNF),4] := nQuant
    IF aListNF[Len(aListNF),3] <> aListNF[Len(aListNF),4]
         bIgual := .F.
    EndIF
    IF Len(aRec) == 0
       aListNF[Len(aListNF),5] := {{ "","","",0,0}}
    Else
       aListNF[Len(aListNF),5] := aRec
    EndIF
    QRY_PROD->(dbSkip())
EndDo
IF ( (ZZM->ZZM_STATUS == '2' .AND. !bEmite) .OR. (ZZM->ZZM_STATUS == '1' .AND. bEmite)) .And. bIgual
    IF MsgYESNO('A quantidade selecionada totalizada a quantidade do pedido, deseja encerrar a etapa de "Vincular Notas" ?')
        bQtdDirv  := .F.
        Reclock("ZZM",.F.)
        ZZM->ZZM_STATUS := '3'
        ZZM->(MsUnlock())
	EndIF
EndIf

Return bRet
***********************************************************************************************************
Static Function Atu_dados_NF()

oListSel:SetArray(aListNF[oListNF:nAt,5])
oListSel:nAt := 1
oListSel:bLine := { || {aListNF[oListNF:nAt,5][oListSel:nAt,1], ;
						aListNF[oListNF:nAt,5][oListSel:nAt,2], ;
						aListNF[oListNF:nAt,5][oListSel:nAt,3], ;
					    aListNF[oListNF:nAt,5][oListSel:nAt,4]}}
oListSel:Refresh()
Return
*********************************************************************************************************************************************
Static Function Exc_NF()
Private cFILNFE    := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
//Local bEmite  := IIF(ZZM->ZZM_EMITE=='S',.T.,.F.)


IF aListNF[oListNF:nAt,5][oListSel:nAt,5] <> 0 .And. bQtdDirv .And. ( (ZZM->ZZM_STATUS $ '1#2' .AND. !bEmite) .OR. (ZZM->ZZM_STATUS == '1' .AND. bEmite))
	IF MsgYESNO('Exclui relacionamento da NF ?')
		ZZP->(dbGoTo(aListNF[oListNF:nAt,5][oListSel:nAt,5]))
		Reclock("ZZP",.F.)
		ZZP->(dbDelete())
		ZZP->(MsUnlock())
		Dados_NF()
		oListNF:SetArray(aListNF)
		oListNF:nAt := 1
		oListNF:bChange := {||Atu_dados_NF()}
		oListNF:bLine := { || {aListNF[oListNF:nAt,1], aListNF[oListNF:nAt,2], aListNF[oListNF:nAt,3], aListNF[oListNF:nAt,4]}}

		oListSel:SetArray(aListNF[oListNF:nAt,5])
		oListSel:nAt := 1
		oListSel:bLine := { || {aListNF[oListNF:nAt,5][oListSel:nAt,1], aListNF[oListNF:nAt,5][oListSel:nAt,2], aListNF[oListNF:nAt,5][oListSel:nAt,3], aListNF[oListNF:nAt,5][oListSel:nAt,4]}}
		oListSel:Refresh()

	EndIF
EndIF

Return

*********************************************************************************************************************************************
Static Function Cad_NF(nTipoCod)

Local oBtn
Local oDlg3
Local cQuery   := ''
Local nQuant   := 0
Local bCad     := .T.

Private aNFProd    := {}
Private aRecNFProd := {}
Private oBrowNF
Private aParamBox  := {}
Private aRet       := {}
Private bAux       := IIF(nTipoCod == 2,.T.,.F.)
Private cCodProc   := ''
Private cBuscaGado := GetMV('MGF_TAE15B',.F.,"'04B','05C'") //TES DE BUSCA DE GADO


IF aListNF[oListNF:nAt,4] == aListNF[oListNF:nAt,3]
    msgAlert('J� foi selecionado notas suficiente')
    Return
EndIF

IF nTipoCod == 2
    AAdd(aParamBox, {1, "Produto:"          ,Space(tamSx3("B1_COD")[1])       , "@!",  ,"SB1" ,, 060	, .T.	})
	IF ParamBox(aParambox, "Escolha um Produto Alternativo"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
    	IF SB1->(!dbSeek(xFilial('SB1')+MV_PAR01))
			msgAlert('Produto nao cadastrado !!')
			Return
		Else
			cCodProc := SB1->B1_COD
		EndIF
    Else
       Return
    EndIF
Else
	cCodProc := aListNF[oListNF:nAt,1]
EndIF
cQuery := " SELECT D1_FILIAL,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_COD,SUM(D1_QUANT) D1_QUANT, "
cQuery += "        ROUND(SUM(D1_VUNIT*D1_QUANT) / SUM(D1_QUANT),6) D1_VUNIT "
cQuery += " FROM "+RetSQLName("SD1")+' SD1, '+RetSQLName("SF1")+' SF1'
cQuery += " WHERE D1_FILIAL  = F1_FILIAL "
cQuery += "   AND D1_FORNECE = F1_FORNECE "
cQuery += "   AND D1_LOJA    = F1_LOJA "
cQuery += "   AND D1_DOC     = F1_DOC "
cQuery += "   AND D1_SERIE   = F1_SERIE "
cQuery += "   AND D1_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND D1_FORNECE = '" + ZZM->ZZM_FORNEC + "' "
cQuery += "   AND D1_LOJA    = '" + ZZM->ZZM_LOJA + "' "
cQuery += "   AND D1_COD     = '" + cCodProc+ "' "
cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SF1.F1_TIPO = 'N' " // Paulo Mata - PRB0040824 - 23/04/2020
cQuery += "   AND F1_STATUS      <> ' ' "
cQuery += "   AND (F1_FORMUL     <>  'S'  OR ( F1_FORMUL ='S' AND D1_TES in ("+cBuscaGado+") ) ) "
cQuery += " GROUP BY D1_FILIAL ,D1_FORNECE, D1_LOJA, D1_DOC , D1_SERIE	,D1_COD		"
cQuery += " ORDER BY D1_DOC,D1_SERIE "
If Select("QRY_NF") > 0
	QRY_NF->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NF",.T.,.F.)
dbSelectArea("QRY_NF")
QRY_NF->(dbGoTop())
ZZP->(dbSetOrder(1))
While !QRY_NF->(EOF())
    cQuery := " SELECT SUM(ZZP_QTD) SOMA_QTD "
	cQuery += " FROM "+RetSQLName("ZZP")+' ZZP, '+RetSQLName("ZZM")+' ZZM'
	cQuery += " WHERE ZZP_FILIAL  = ZZM_FILIAL "
	cQuery += "   AND ZZP_PEDIDO  = ZZM_PEDIDO "
	cQuery += "   AND ZZP_FILIAL  = '" + QRY_NF->D1_FILIAL + "' "
	cQuery += "   AND ZZM_FORNEC  = '" + QRY_NF->D1_FORNECE + "' "
	cQuery += "   AND ZZM_LOJA    = '" + QRY_NF->D1_LOJA + "' "
	cQuery += "   AND ZZP_DOC     = '" + QRY_NF->D1_DOC + "' "
	cQuery += "   AND ZZP_SERIE   = '" + QRY_NF->D1_SERIE + "' "
	cQuery += "   AND (ZZP_PRODUT  = '" + QRY_NF->D1_COD+ "' OR ZZP_CODAUX  = '" + QRY_NF->D1_COD+ "' )"
	cQuery += "   AND ZZP.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZZM.D_E_L_E_T_ = ' ' "

	If Select("QRY_PNOTA") > 0
		QRY_PNOTA->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PNOTA",.T.,.F.)
	dbSelectArea("QRY_PNOTA")
	QRY_PNOTA->(dbGoTop())
	bCad := .T.
	IF QRY_PNOTA->(!EOF())
	   nQuant := QRY_NF->D1_QUANT - QRY_PNOTA->SOMA_QTD
	   IF nQuant <= 0
	       bCad     := .F.
	   EndIF
    EndIF
    IF bCad
		aRec   := {}
		AAdd(aRec,QRY_NF->D1_DOC)
	    AAdd(aRec,QRY_NF->D1_SERIE)
	    AAdd(aRec,nQuant)
	    AAdd(aRec,QRY_NF->D1_VUNIT)
	    AADD(aNFProd,aRec)
    EndIF
    QRY_NF->(dbSkip())
EndDo

IF len(aNFProd) == 0
    msgAlert('Nao existe Nota para ser relacionada!!')
Else

	DEFINE MSDIALOG oDlg3 TITLE "Escolha Nota Fiscal Produtor" FROM 000, 000  TO 340, 300 COLORS 0, 16777215 PIXEL

		@ 007, 005 LISTBOX oBrowNF	 Fields HEADER "Documento","Serie","Saldo" SIZE 143,147 OF oDlg3 COLORS 0, 16777215 PIXEL
		oBrowNF:SetArray(aNFProd)
		oBrowNF:nAt := 1
		oBrowNF:bLine := { || {aNFProd[oBrowNF:nAt,1],aNFProd[oBrowNF:nAt,2],aNFProd[oBrowNF:nAt,3]}}

		oBtn := TButton():New( 157, 005 ,'Confirmar' , oDlg3,{|| Cad_TBNF(),oDlg3:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 157, 092 ,'Sair'      , oDlg3,{|| oDlg3:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDlg3 CENTERED


EndIF


Return
*************************************************************************************************************************************************************
Static Function Cad_TBNF

Local bAchou    := .F.
Local nQuantCAB := 0
Local oDLG2
Local nMax      :=  aListNF[oListNF:nAt,3] - aListNF[oListNF:nAt,4]
Local bSai      := .F.
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))


IF nMax > aNFProd[oBrowNF:nAt,3]
    nMax := aNFProd[oBrowNF:nAt,3]
EndIF

DEFINE MSDIALOG oDLG4 TITLE "Entre com a Quantidade" FROM 000, 000  TO 080, 200 COLORS 0, 16777215 PIXEL
	@ 006, 005 MSGET  nQuantCAB      SIZE 95, 010 OF oDLG4 PICTURE "999999" Valid nQuantCab <= nMax COLORS 0, 16777215 PIXEL
	oBtn := TButton():New( 021, 050 ,'Confirmar'    , oDLG4,{|| bSai:=.T., oDLG4:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
ACTIVATE MSDIALOG oDLG4 CENTERED

ZZP->(dbSetOrder(1))
IF bSai .And. nQuantCAB <> 0
    IF ZZP->(dbSeek(ZZM->ZZM_FILIAL+;
    				ZZM->ZZM_PEDIDO+;
                    PADR(ALLTRIM(aNFProd[oBrowNF:nAt,1]),TamSX3("ZZP_DOC")[1])+;
                    PADR(ALLTRIM(aNFProd[oBrowNF:nAt,2]),TamSX3("ZZP_SERIE")[1])+;
                    PADR(ALLTRIM(aListNF[oListNF:nAt,1]),TamSX3("ZZP_PRODUT")[1])))
          IF bAux
              While ZZP->(!EOF()) .And. ;
                    ZZP->ZZP_FILIAL == ZZM->ZZM_FILIAL .And. ;
    				ZZP->ZZP_PEDIDO == ZZM->ZZM_PEDIDO .And.;
                    ZZP->ZZP_DOC    == PADR(ALLTRIM(aNFProd[oBrowNF:nAt,1]),TamSX3("ZZP_DOC")[1]) .And.;
                    ZZP->ZZP_SERIE  == PADR(ALLTRIM(aNFProd[oBrowNF:nAt,2]),TamSX3("ZZP_SERIE")[1]) .And.;
                    ZZP->ZZP_PRODUT == PADR(ALLTRIM(aListNF[oListNF:nAt,1]),TamSX3("ZZP_PRODUT")[1])
                    IF ZZP->ZZP_CODAUX == cCodProc
                        Reclock("ZZP",.F.)
	          			ZZP->ZZP_QTD    := ZZP->ZZP_QTD+ nQuantCAB
			  			ZZP->(MsUnlock())
			  			bAchou    := .T.
			  			EXIT
                    EndIF
               	ZZP->(dbSkip())
          	  End
          Else
	          Reclock("ZZP",.F.)
	          ZZP->ZZP_QTD    := ZZP->ZZP_QTD+ nQuantCAB
			  ZZP->(MsUnlock())
			  bAchou    := .T.
		  EndIF
	EndIF
	IF !bAchou
		Reclock("ZZP",.T.)
		ZZP->ZZP_FILIAL := ZZM->ZZM_FILIAL
		ZZP->ZZP_PEDIDO	:= ZZM->ZZM_PEDIDO
		ZZP->ZZP_DOC    := aNFProd[oBrowNF:nAt,1]
		ZZP->ZZP_SERIE  := aNFProd[oBrowNF:nAt,2]
		ZZP->ZZP_PRODUT := aListNF[oListNF:nAt,1]
		ZZP->ZZP_QTD    := nQuantCAB
		ZZP->ZZP_VALOR  := aNFProd[oBrowNF:nAt,4]
		IF bAux
			ZZP->ZZP_CODAUX := cCodProc
		EndIF
		ZZP->(MsUnlock())
	EndIF
	IF ZZM->ZZM_STATUS == '1' .AND. !bEmite
		Reclock("ZZM",.F.)
	 	ZZM->ZZM_STATUS := '2'
	  	ZZM->(MsUnlock())
	EndIF
	Dados_NF()
	oListNF:SetArray(aListNF)
	oListNF:nAt := 1
	oListNF:bChange := {||Atu_dados_NF()}
	oListNF:bLine := { || {aListNF[oListNF:nAt,1], aListNF[oListNF:nAt,2], aListNF[oListNF:nAt,3], aListNF[oListNF:nAt,4]}}
	oListSel:SetArray(aListNF[oListNF:nAt,5])
	oListSel:nAt := 1
	oListSel:bLine := { || {aListNF[oListNF:nAt,5][oListSel:nAt,1], aListNF[oListNF:nAt,5][oListSel:nAt,2], aListNF[oListNF:nAt,5][oListSel:nAt,3], aListNF[oListNF:nAt,5][oListSel:nAt,4]}}
	oListSel:Refresh()
EndIF

Return
****************************************************************************************************************************************************************
User Function TAE07_F5
Local cRet      := .F.

IF !EMPTY(SF1->F1_STATUS)  ;
    .AND. SF1->F1_TIPO=='C';
	.AND. SF1->F1_FILIAL == ZZM->ZZM_FILIAL ;
	.AND. PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZM_FORNEC")[1]) == ZZM->ZZM_FORNEC ;
    .AND. SF1->F1_LOJA == ZZM->ZZM_LOJA;
    .AND. TAE15_VINCULO(1,SF1->F1_FILIAL,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE)

	cRet := .T.
EndIF

Return cRet

****************************************************************************************************************************************************************
User Function TAE07_F6

Local cRet      := .F.

IF SF2->F2_TIPO=='D';
	.AND. SF2->F2_FILIAL == ZZM->ZZM_FILIAL ;
	.AND. PADR(ALLTRIM(SF2->F2_CLIENTE),TamSX3("ZZM_FORNEC")[1]) == ZZM->ZZM_FORNEC ;
    .AND. SF2->F2_LOJA == ZZM->ZZM_LOJA;
    .AND. TAE15_VINCULO(2,SF2->F2_FILIAL,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_DOC,SF2->F2_SERIE)

	cRet := .T.
EndIF

Return cRet

****************************************************************************************************************************************************************
Static Function TAE15_VINCULO(nTipo,cF1_FILIAL,cF1_FORNECE,cF1_LOJA,cF1_DOC,cF1_SERIE)

Local bRet := .T.
Local aSalvAmb  := GetArea()

cQuery := " SELECT * "
cQuery += " FROM "+RetSQLName("ZZM")+" ZZM , "+RetSQLName("ZDU")+" ZDU"
cQuery += " WHERE ZZM_FILIAL  = '" + cF1_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC  = '" + cF1_FORNECE + "' "
cQuery += "   AND ZZM_LOJA    = '" + cF1_LOJA + "' "
cQuery += "   AND ZZM_FILIAL  = ZDU_FILIAL "
cQuery += "   AND ZZM_PEDIDO  = ZDU_PEDIDO "
cQuery += "   AND ZDU_DOC     = '" + cF1_DOC + "' "
cQuery += "   AND ZDU_SERIE   = '" + cF1_SERIE + "' "
IF nTipo == 1
	cQuery += "   AND ZDU_TIPO    = 'E' "
Else
	cQuery += "   AND ZDU_TIPO    = 'S' "
EndIF
cQuery += "   AND ZDU.D_E_L_E_T_ = ' ' "
cQuery += "   AND ZZM.D_E_L_E_T_ = ' ' "
If Select("QRY_PNOTA") > 0
	QRY_PNOTA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PNOTA",.T.,.F.)
dbSelectArea("QRY_PNOTA")
QRY_PNOTA->(dbGoTop())
IF QRY_PNOTA->(!EOF())
    bRet := .F.
EndIF

RestArea( aSalvAmb )
Return bRet
*************************************************************************************************************************************************************
User Function TAE15_EFETIVA (nOpcEfetiva)
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
Private bPassou := .T.


IF nOpcEfetiva == 1
    IF !bEmite
		MsgAlert('Fornecedor Emite Nota Fiscal Eletronica, nao � possivel fazer a NF Entrada !!')
	    Return
    Else
    	IF !Empty(ZZM->ZZM_DOC)
    		MsgAlert('Nota j� emitida!!')
	    	Return
    	EndIF
    	IF ZZM->ZZM_STATUS <> '3' .AND. ZZM->ZZM_STATUS <> '5'
    		MsgAlert('Situacao do Boletim nao permite a emissao da Nota !!')
	    	Return
	    Else
	    	//IF ZZM->ZZM_STATUS == '5'
	    	//    MsgAlert('Boletim encerrado e a Nota foi cancelada, sera emitida uma NF sem movimentar estoque !!')
	    	//EndIF
	    	Processa( {|| Gera_Doc_Entrada(@bPassou) },'Aguarde...', 'Efetivando Boletim de Abate - Gerando Nota',.F. )
	    EndIF
	EndIF

ElseIF nOpcEfetiva == 2
	IF bEmite
		IF ZZM->ZZM_STATUS <> '4'
	    	MsgAlert('Situacao do Boletim nao permite a efetiva��o !!')
		    Return
		EndIF
	Else
		IF ZZM->ZZM_STATUS <> '3'
			MsgAlert('Situacao do Boletim nao permite a efetiva��o !!')
			Return
		EndIF
	EndIF
	IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)=='T'
		MsgAlert('Boletim de Abate de Terceiro nao � possivel Efetivar !!')
		Return
	EndIF
	IF MsgYESNO('Deseja efetivar o Boletim de Abate ?')
		//Verifica se existe OP de abate do dia
		Processa( {|| Gera_Mov_OP(@bPassou) },'Aguarde...', 'Efetivando Boletim de Abate',.F. )
		IF bPassou
		    Processa( {|| Libera_Pag() },'Aguarde...', 'Liberando Pagamento',.F. )
			IF !bEmite
				Processa( {|| U_CPA999(2) },'Aguarde...', 'Atualizando Dados Banc�rios',.F. )
			EndIF
		EndIF
	EndIF
ElseIF nOpcEfetiva == 3
	IF bEmite
		IF ZZM->ZZM_STATUS <> '5'
			MsgAlert('Boletim ainda nao efetivado, nao � possivel cancelar a Efetiva��o !!')
			Return
		EndIF
	Else
		IF ZZM->ZZM_STATUS <> '5' .AND. ZZM->ZZM_STATUS <> '4'
			MsgAlert('Boletim ainda nao efetivado, nao � possivel cancelar a Efetiva��o !!')
			Return
		EndIF
	EndIF
	IF MsgYESNO('Deseja Cancelar a efetiva��o do Boletim de Abate ?')
		dbSelectArea("SD3")
		Processa( {|| Can_Mov_OP() },'Aguarde...', 'Cancelando Movimentos Boletim de Abate',.F. )
	EndIF

EndIF
Return
***********************************************************************************************************************************************
Static Function Gera_Mov_OP(bPassou)
Local aMata650  := {}
Local aErro     := {}
Local cErro     := ""
Local cQuery    := ''
Local nI        := 0
Local bContinua := .T.
Local aCab      := {}
Local aItem     := {}
Local aTotItem  := {}
Local aCodAgrup := {}
Local nSomaKG   := 0
Local aDifValor := {}
Local cPedAbate := ''
Local bkFil     := cFilAnt
Local cNumOP    := ""
Local aEncerOP  := {}
Local aBloqueio := {}
Local nTotZZE   := 0
Local cTexto    := ''
Local cBkMod    := cModulo
Local nBkMod    := nModulo

Private cOPAbate      	:= SUBSTR(DTOS(ZZM->ZZM_DTPROD),3,6)+'04001' //Ret_OP_DIA()
Private cCarcaca 		:= GetMV('MGF_TAE05',.F.,"")
Private cTMReq          := GetMV('MGF_TAE06',.F.,"")
Private cTMProd         := GetMV('MGF_TAE07',.F.,"")
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.
Private lA185BxEmp      := .F.



dbSelectArea('SC2')
SC2->(dbSetOrder(1))
AAdd(aBloqueio,{cCarcaca,.F.})
dbSelectArea('SB1')
SB1->(dbSetOrder(1))
aTotItem  := {}
aCodAgrup := {}
ZZN->(dbSetOrder(1))
ZZN->(dbSeek( ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO ))
While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ ZZM->ZZM_PEDIDO
	IF Alltrim(ZZN->ZZN_CODAGR) <> 'INP14526'
		SB1->(dbSeek(xFilial('SB1')+ZZN->ZZN_PRODUT))
		cAgrup := ZZN->ZZN_CODAGR
		SB1->(dbSeek(xFilial('SB1')+cAgrup))
		nPos   := aScan( aCodAgrup, { |x| Alltrim(x[1]) == Alltrim(cAgrup) })
		IF nPos == 0
			AAdd( aCodAgrup,{cAgrup,ZZN->ZZN_QTCAB , SB1->B1_UM, SB1->B1_LOCPAD}) //+ ZZN->ZZN_QTPE
			AAdd(aBloqueio,{cAgrup,.F.})
		ElSE
			aCodAgrup[nPos,2] := aCodAgrup[nPos,2] + (ZZN->ZZN_QTCAB ) //+ ZZN->ZZN_QTPE
		EndIF
		nSomaKG   += ZZN->ZZN_QTKG
	EndIF
	ZZN->(dbSkip())
End
IF SUBSTR(ZZM->ZZM_PEDIDO,1,1) == 'A'
	cPedAbate := Ret_Agrup()
Else
	cPedAbate := "'"+Alltrim(ZZM->ZZM_PEDIDO)+"'"
EndIF
cQuery := " SELECT SUM(CASE WHEN ZZE_ACAO = '1' THEN ZZE_QUANT ELSE -ZZE_QUANT END ) ZZE_QUANT"
cQuery += " FROM "+RetSqlName("ZZE")+" ZZE "
cQuery += " WHERE ZZE.D_E_L_E_T_ = ' ' "
cQuery += "   AND ZZE_FILIAL = '"+ZZM->ZZM_FILIAL+"' "
cQuery += "   AND ZZE_PEDLOT in ( " + cPedAbate + ") "
cQuery += "   AND ZZE_STATUS in ('A','1','P') "
//cQuery += "   AND ZZE_CANCEL <> '1' "
cQuery += "   AND ZZE_TPOP = '01' "
cQuery += "   AND ZZE_TPMOV = '01' "
If Select("QRY_OPAB") > 0
	QRY_OPAB->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY_OPAB',.T.,.F.)

tcSetField('QRY_OPAB',"ZZE_QUANT",'N',TamSx3("ZZE_QUANT")[1],TamSx3("ZZE_QUANT")[2])
QRY_OPAB->(dbGoTop())
nTotZZE   := 0
IF QRY_OPAB->(!EOF())
	nTotZZE   := QRY_OPAB->ZZE_QUANT
EndIF
IF nTotZZE <> nSomaKG
	 cTexto += 'Quantidade Total de Carcaca do Boletim esta diferente das integra��es recebidas : '+CRLF
	 cTexto +=  'Boletim : '+Alltrim(STR(nSomaKG))+CRLF
	 cTexto +=  'Integra��es : '+Alltrim(STR(nTotZZE))+CRLF
	 cTexto +=  'Nao sera possivel efetivar o Boletim !!'
     MsgAlert(cTexto)
     bPassou := .F.
     Return bPassou
EndIF
BEGIN TRANSACTION
	cFilAnt := ZZM->ZZM_FILIAL
	cModulo := 'EST'
	nModulo := 4

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1')+PADR(cCarcaca,TamSx3('B1_COD')[1])))

 /*
    dbSelectArea("SB2")
	SB2->(dbSetOrder(1))
	IF SB2->(dbSeek(xFilial('SB2')+PADR(cCarcaca,TamSx3('B1_COD')[1])+SB1->B1_LOCPAD))
	   IF SB2->B2_VATU1 < 0
			RecLock("SB2",.F.)
			SB2->B2_VATU1	:= 0
			SB2->( msUnlock() )
	    EndIF
	EndIF */

	// Faz o Desbloqueio do Produtos utilizados
	For nI := 1 To Len(aBloqueio)
		SB1->( dbSeek( xFilial("SB1")+aBloqueio[nI,01] ) )
		If SB1->B1_MSBLQL == '1'
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '2'
			SB1->( msUnlock() )
			aBloqueio[nI,02] := .T.
		EndIf
	Next nI

	IF SC2->(!dbSeek(ZZM->ZZM_FILIAL+cOPAbate))
		aMata650  := {  {'C2_FILIAL'   ,ZZM->ZZM_FILIAL  ,NIL},;
						{'C2_PRODUTO'  ,cCarcaca  		 ,NIL},;
						{'C2_ITEM'     ,'04' 			 ,NIL},;
						{'C2_SEQUEN'   ,SUBSTR(cOPAbate,9,3) ,NIL},;
						{'C2_NUM'      ,SUBSTR(cOPAbate,1,6)  ,NIL},;
						{'C2_QUANT'    ,nSomaKG          ,NIL},;
						{'C2_DATPRI'   ,ZZM->ZZM_DTPROD ,NIL},;
						{"C2_DATPRF"   ,dDataBase        ,Nil},;
						{"C2_TPOP"    , "F"              ,Nil},;
						{"AUTEXPLODE" , "N"              ,Nil}}
		lMsErroAuto := .F.
		MSExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)
		IF lMsErroAuto
			DisarmTransaction()
			aErro := GetAutoGRLog()
			cErro := ""
			For nI := 1 to Len(aErro)
				cErro += aErro[nI] + CRLF
			Next nI
			msgStop(cErro)
			bContinua  := .F.
			bPassou      := .F.
		Else
			bContinua   := .T.
		Endif
	EndIF
	//Mata241 para baixar o Boi
	IF bContinua
		aCab := {{'D3_TM'      ,cTMReq           ,NIL},;
				 {'D3_FILIAL'  ,ZZM->ZZM_FILIAL     ,NIL},;
		         {'D3_EMISSAO' ,ZZM->ZZM_DTPROD  ,NIL}}
		For nI := 1 To Len(aCodAgrup)
			aItem	    := {}
			Aadd(aItem,{'D3_COD'      ,aCodAgrup[nI,1] ,NIL})
			Aadd(aItem,{'D3_UM'       ,aCodAgrup[nI,3] ,NIL})
			Aadd(aItem,{'D3_QUANT'    ,aCodAgrup[nI,2] ,NIL})
			Aadd(aItem,{'D3_LOCAL'    ,aCodAgrup[nI,4] ,NIL})
			Aadd(aItem,{"D3_OP"       ,cOPAbate 	   ,NIL})
			Aadd(aItem,{"D3_ZPEDLOT"  ,ZZM->ZZM_PEDIDO ,NIL})
			Aadd(aItem,{"D3_ZORIGEM"  ,'ABATE'         ,NIL})
			AAdd(aTotItem,aItem)
		Next nI
		MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aTotItem,3)
		IF lMsErroAuto
			DisarmTransaction()
			aErro := GetAutoGRLog()
			cErro := ""
			For nI := 1 to Len(aErro)
				cErro += aErro[nI] + CRLF
			Next nI
			msgStop(cErro)
			bContinua   := .F.
			bPassou      := .F.
		Else
			bContinua   := .T.
		Endif
	EndIF
	//Apontamento de Producao MATA250
	IF bContinua
		aCab   :={ 	{"D3_TM"      ,cTMProd 				,NIL},;
					{"D3_OP"      ,cOPAbate 		    ,NIL},;
					{"D3_COD"     ,cCarcaca   		    ,NIL},;
					{"D3_QUANT"   ,nSomaKG        		,NIL},;
					{"D3_PARCTOT" ,'P' 					,NIL},;
					{"D3_EMISSAO" ,ZZM->ZZM_DTPROD	    ,NIL},;
					{"D3_ZPEDLOT" ,ZZM->ZZM_PEDIDO      ,NIL},;
					{"D3_ZORIGEM" ,'ABATE'              ,NIL}}

		MSExecAuto({|x, y| mata250(x, y)},aCab, 3 )
		IF lMsErroAuto
			DisarmTransaction()
			aErro := GetAutoGRLog()
			cErro := ""
			For nI := 1 to Len(aErro)
				cErro += aErro[nI] + CRLF
			Next nI
			msgStop(cErro)
			bContinua   := .F.
			bPassou      := .F.
		Else
			bContinua   := .T.
		Endif
	EndIF
	//Requisi��o da carca�a em quilos nas OPs de
	// de Abate de Producao
	/*
	IF bContinua
		dbSetOrder(1)
		SB1->(dbSeek(xFilial('SB1')+cCarcaca))
		IF SUBSTR(ZZM->ZZM_PEDIDO,1,1) == 'A'
		    cPedAbate := Ret_Agrup()
		Else
		    cPedAbate := "'"+Alltrim(ZZM->ZZM_PEDIDO)+"'"
		EndIF
		aTotItem := {}
		aCab 	 := {{'D3_TM'      ,cTMReq           ,NIL},;
		             {'D3_EMISSAO' ,ZZM->ZZM_DTPROD  ,NIL}}
		cQuery := " SELECT  D3_OP , SUM(D3_QUANT) QUANT "
		cQuery += " FROM "+RetSQLName("SD3")
		cQuery += " WHERE D3_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += "   AND D3_ESTORNO <> 'S' "
		cQuery += "   AND D3_OP      <> ' '"
		cQuery += "   AND D3_ZPEDLOT in ( " + cPedAbate + ") "
		cQuery += " GROUP BY  D3_OP "
		If Select("QRY_OPAB") > 0
			QRY_OPAB->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_OPAB",.T.,.F.)
		dbSelectArea("QRY_OPAB")
		QRY_OPAB->(dbGoTop())
		While QRY_OPAB->(!EOF())
			aItem	    := {}
			Aadd(aItem,{'D3_COD'      ,cCarcaca ,NIL})
			Aadd(aItem,{'D3_UM'       ,SB1->B1_UM ,NIL})
			Aadd(aItem,{'D3_QUANT'    ,QRY_OPAB->QUANT ,NIL})
			Aadd(aItem,{'D3_LOCAL'    ,SB1->B1_LOCPAD,NIL})
			Aadd(aItem,{"D3_OP"       ,QRY_OPAB->D3_OP ,NIL})
			Aadd(aItem,{"D3_ZPEDLOT"  ,ZZM->ZZM_PEDIDO ,NIL})
			AAdd(aTotItem,aItem)
			QRY_OPAB->(dbSkip())
		End
		IF Len(aTotItem) > 0
			MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aTotItem,3)
			IF lMsErroAuto
				DisarmTransaction()
				aErro := GetAutoGRLog()
				cErro := ""
				For nI := 1 to Len(aErro)
					cErro += aErro[nI] + CRLF
				Next nI
				msgStop(cErro)
				bContinua   := .F.
			Else
				bContinua   := .T.
			Endif
		EndIF
	EndIF
	*/

	IF bContinua
		dbSetOrder(1)
		SB1->(dbSeek(xFilial('SB1')+cCarcaca))
		aTotItem := {}
		cQuery := " SELECT ZZE_FILIAL, ZZE_GERACA, ZZE_CODPA, ZZE_TPOP, "
		cQuery += "       SUM(CASE WHEN ZZE_ACAO = '1' THEN ZZE_QUANT ELSE -ZZE_QUANT END ) ZZE_QUANT, ZZE_PEDLOT "
		cQuery += " FROM "+RetSqlName("ZZE")+" ZZE "
		cQuery += " WHERE ZZE.D_E_L_E_T_ = ' ' "
		cQuery += "   AND ZZE_FILIAL = '"+ZZM->ZZM_FILIAL+"' "
		cQuery += "   AND ZZE_PEDLOT in ( " + cPedAbate + ") "
		cQuery += "   AND ZZE_STATUS in ('A','1','P') "
		//cQuery += "   AND ZZE_CANCEL <> '1' "
		cQuery += "   AND ZZE_TPOP = '01' "
		cQuery += "   AND ZZE_TPMOV = '01' "
		cQuery += " GROUP BY ZZE_FILIAL, ZZE_GERACA, ZZE_CODPA, ZZE_TPOP, ZZE_PEDLOT "
		cQuery += " Having SUM(CASE WHEN ZZE_ACAO = '1' THEN ZZE_QUANT ELSE -ZZE_QUANT END ) > 0"
		If Select("QRY_OPAB") > 0
			QRY_OPAB->(dbCloseArea())
		EndIf

		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY_OPAB',.T.,.F.)

		tcSetField('QRY_OPAB',"ZZE_QUANT",'N',TamSx3("ZZE_QUANT")[1],TamSx3("ZZE_QUANT")[2])
		QRY_OPAB->(dbGoTop())
		SC2->(dbSetOrder(9))
		While QRY_OPAB->(!EOF()) .and. bContinua
			// verifica se tem a OP criada
			If SC2->(!dbSeek(xFilial("SC2")+Subs(QRY_OPAB->ZZE_GERACA,3,6)+"01"+QRY_OPAB->ZZE_CODPA))
				cNumOP := TAE15CriaSC2()
				aMata650  := {  {'C2_FILIAL'   ,ZZM->ZZM_FILIAL  ,NIL},;
								{'C2_DATPRI'   ,sTod(QRY_OPAB->ZZE_GERACA)-3 ,NIL},;
								{'C2_NUM'      ,Subs(cNumOP,1,6)  ,NIL},;
								{'C2_ITEM'     ,'01' 			 ,NIL},;
								{'C2_SEQUEN'   ,Subs(cNumOP,9,3) ,NIL},;
								{'C2_PRODUTO'  ,QRY_OPAB->ZZE_CODPA  		 ,NIL},;
								{'C2_QUANT'    ,QRY_OPAB->ZZE_QUANT          ,NIL},;
								{"C2_DATPRF"   ,dDataBase        ,Nil},;
								{"C2_TPOP"    , "F"              ,Nil},;
								{"AUTEXPLODE" , "N"              ,Nil}}
				lMsErroAuto := .F.
				MSExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)
				IF lMsErroAuto
					DisarmTransaction()
					aErro := GetAutoGRLog()
					cErro := ""
					For nI := 1 to Len(aErro)
						cErro += aErro[nI] + CRLF
					Next nI
					msgStop(cErro)
					bContinua   := .F.
					bPassou      := .F.
				Else
					bContinua   := .T.
				Endif
			Else
				cNumOP := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
				// verificar se OP estah encerrada, reabrindo para realizar os apontamentos
				If !Empty(SC2->C2_DATRF)
					aAdd(aEncerOP,{SC2->(Recno()),SC2->C2_DATRF})
					SC2->(RecLock("SC2",.F.))
					SC2->C2_DATRF := cTod("")
					SC2->(MsUnLock())
				Endif
			Endif

			If bContinua
				aItem	    := {}
				Aadd(aItem,{'D3_COD'      ,cCarcaca ,NIL})
				Aadd(aItem,{'D3_UM'       ,SB1->B1_UM ,NIL})
				Aadd(aItem,{'D3_QUANT'    ,QRY_OPAB->ZZE_QUANT ,NIL})
				Aadd(aItem,{'D3_LOCAL'    ,SB1->B1_LOCPAD,NIL})
				Aadd(aItem,{"D3_OP"       ,cNumOP ,NIL})
				Aadd(aItem,{"D3_ZPEDLOT"  ,ZZM->ZZM_PEDIDO ,NIL})
				Aadd(aItem,{"D3_ZORIGEM"  ,'ABATE'         ,NIL})
				AAdd(aTotItem,aItem)
			Endif
			QRY_OPAB->(dbSkip())
		Enddo
		QRY_OPAB->(dbCloseArea())

		IF Len(aTotItem) > 0
			aCab 	 := {{'D3_TM'      ,cTMReq           ,NIL},;
						 {'D3_FILIAL'  ,ZZM->ZZM_FILIAL     ,NIL},;
			             {'D3_EMISSAO' ,ZZM->ZZM_DTPROD  ,NIL}}
			MSExecAuto({|x,y,z| mata241(x,y,z)},aCab,aTotItem,3)
			IF lMsErroAuto
				DisarmTransaction()
				aErro := GetAutoGRLog()
				cErro := ""
				For nI := 1 to Len(aErro)
					cErro += aErro[nI] + CRLF
				Next nI
				msgStop(cErro)
				bContinua   := .F.
				bPassou      := .F.
			Else
				bContinua   := .T.
			Endif
		EndIF
		If bContinua
			For nI := 1 To Len(aEncerOP)
				SC2->(dbGoto(aEncerOP[nI][1]))
				If SC2->(Recno()) == aEncerOP[nI][1]
					SC2->(RecLock("SC2",.F.))
					SC2->C2_DATRF := aEncerOP[nI][2]
					SC2->(MsUnLock())
				Endif
			Next
			/*cQuery := " Update "+RetSqlName("ZZE")
			cQuery += " Set ZZE_STATUS = 'P' "
			cQuery += "WHERE D_E_L_E_T_ = ' ' "
			cQuery += "AND ZZE_FILIAL = '"+ZZM->ZZM_FILIAL+"' "
			cQuery += "AND ZZE_PEDLOT in ( " + cPedAbate + ") "
			cQuery += "AND ZZE_STATUS = 'A' "
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				bPassou      := .F.
				MsgStop(TcSQLError())
			EndIF */
		Endif
	Endif

	IF bContinua
		IF bEmite
			Reclock("ZZM",.F.)
			ZZM->ZZM_STATUS := '5'
			ZZM->ZZM_NUMOP  := cOPAbate
			ZZM->(MsUnlock())
			MsgAlert('Boletim encerrado com sucesso !')
		Else
			aDifValor := DifValor()
			Reclock("ZZM",.F.)
			ZZM->ZZM_STATUS := '5'
			ZZM->ZZM_NUMOP  := cOPAbate
			IF !aDifValor[1]
				ZZM->ZZM_STATUS := '4'
			Else
				ZZM->ZZM_STATUS := '5'
			EndIF
			ZZM->ZZM_ENVIA  := 'S'
			ZZM->(MsUnlock())
			IF !aDifValor[1]
				MsgAlert('Boletim com diferenca de valor !'+CRLF+'Diferen�a de : '+Transform(aDifValor[2],		"@e 9,999,999,999,999.99"))
			Else
				//TAE15_Lib_Fin()
				MsgAlert('Boletim encerrado com sucesso !')
			EndiF
		EndIF
	EndIF
		// Faz o bloqueio do Produtos utilizados
	For nI := 1 To Len(aBloqueio)
		IF aBloqueio[nI,02]
			SB1->( dbSeek( xFilial("SB1")+aBloqueio[nI,01] ) )
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '1'
			SB1->( msUnlock() )
		EndIf
	Next nI

END TRANSACTION


cFilAnt := bkFil
cModulo := cBkMod
nModulo := nBkMod



Return bPassou
***************************************************************************************************************************************************
Static Function Gera_Doc_Entrada(bPassou)

Local cEst       := GetAdvFVal( "SA2", "A2_EST", xFilial('SA2')+PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1])+;
											     PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]), 1, "" )
Local cTES       := ''
Local cOper      := Alltrim(GetMV('MGF_TAE08',.F.,"46"))
//Local cOperSEM   := Alltrim(GetMV('MGF_TAE1501',.F.,''))
Local aCodAgrup  := {}
Local nPos       := 0
Local nI         := 0
Local aItem      := {}
Local aTotItem   := {}
Local aCabSF1    := {}
Local nValunit   := 0
Local nValTot    := 0
Local cOperTES   := ''
Local cMsg       := ''
Local bSel       := .T.
Local cNUM       := ''
Local nTotCab    := 0
Local nDesc      := 0
Local nTotKG     := 0
Local cCodAux    := ''

Private cNumero         := ''
Private cSerie  		:= ''
Private bSel    		:= .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.
Private aParamBox := {}
Private aRet      := {}

//IF ZZM->ZZM_STATUS == '5'
//   IF Empty(cOperSEM)
//	   MsgAlert('Parametro de Operacao para Boletim Encerrado nao cadastrado!!')
//	   Return
//   Else
 //    cOper := cOperSEM
 //  EndIF
//EndIF
IF !Sx5NumNota()
     bPassou := .F.
Else
    SF1->(dbSetOrder(1))
    IF SF1->(dbSeek(ZZM->ZZM_FILIAL+cNumero+cSerie+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
    	msgAlert('N�mera��o da nota j� existe para este fornecedor !!')
    	bPassou := .F.
    Else
        //bSel := ConPad1(,,,'DJ')
	    //IF !bSel
	   //      bPassou := .F.
	  //  Else
    	    //cOperTES   := SX5->X5_CHAVE
    	    cNUM     := Ret_Pedido()
			IF !Empty(cNUM)
			    DbSelectArea('SC7')
				SC7->(DbOrderNickName('IDZPTAURA'))
				IF SC7->(DbSeek(ZZM->ZZM_FILIAL+cNUM))
					msgAlert('A Condicao de Pagamento do Pedido de Compra � : '+SC7->C7_COND)
				EndIF
		    EndIF
    	    bSel := ConPad1(,,,'SE4')
		    IF !bSel
		         bPassou := .F.
		    Else
		    	cOperTES := cOper
		    	ZZN->(dbSetOrder(1))
				ZZN->(dbSeek( ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO ))
				While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ ZZM->ZZM_PEDIDO
						IF ZZN->ZZN_PRODUT <= '500000' .AND. ZZN->ZZN_VLTOT > 0
							SB1->(dbSeek(xFilial('SB1')+ZZN->ZZN_PRODUT))
							cAgrup := ZZN->ZZN_CODAGR
							nPos   := aScan( aCodAgrup, { |x| Alltrim(x[1]) == Alltrim(cAgrup) })
							IF nPos == 0
								AAdd( aCodAgrup,{cAgrup,ZZN->ZZN_QTCAB + ZZN->ZZN_QTPE, ZZN->ZZN_VLTOT,ZZN->ZZN_ACRESC})
							ElSE
								aCodAgrup[nPos,2] += (ZZN->ZZN_QTCAB + ZZN->ZZN_QTPE)
								aCodAgrup[nPos,3] += ZZN->ZZN_VLTOT
								aCodAgrup[nPos,4] += ZZN->ZZN_ACRESC
							EndIF
							nTotCab += (ZZN->ZZN_QTCAB + ZZN->ZZN_QTPE)
							nTotKG  += ZZN->ZZN_QTKG
						EndIF
						ZZN->(dbSkip())
				End
		    	//AAdd(aParamBox, {1, "Volume"      	    ,nTotCab , "@E 999999",                ,     , , 050	, .T.	})
				//AAdd(aParamBox, {1, "Especie"           ,PADR('CABE�AS',tamSx3("F1_ESPECI1")[1])  , "@!",  , ,, 060	, .T.	})
				//AAdd(aParamBox, {1, "Peso Bruto"  	    ,nTotKG , "@E 999,999.9999"           ,     ,      ,, 050	, .T.	})
				//AAdd(aParamBox, {1, "Peso Liquido"	    ,nTotKG , "@E 99,999,999.99999"       ,     ,      ,, 050	, .T.	})
				//IF ParamBox(aParambox, "Dados de Volume / Peso"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

		    		cNumero := NxtSX5Nota(cSerie)
	            	SB1->(dbSetOrder(1))
				    aCabSF1      := {}
					Aadd(aCabSF1,{"F1_FILIAL"     ,ZZM->ZZM_FILIAL   ,Nil})
					Aadd(aCabSF1,{"F1_DOC"        ,cNumero      ,Nil})
					Aadd(aCabSF1,{"F1_SERIE"      ,cSerie    ,Nil})
					Aadd(aCabSF1,{"F1_FORNECE"    ,Alltrim(ZZM->ZZM_FORNEC)  ,Nil})
					Aadd(aCabSF1,{"F1_LOJA"       ,ZZM->ZZM_LOJA    ,Nil})
					Aadd(aCabSF1,{"F1_COND"       ,SE4->E4_CODIGO   ,Nil})
					Aadd(aCabSF1,{"F1_EMISSAO"    ,dDataBase        ,Nil})
					Aadd(aCabSF1,{"F1_FORMUL"     ,'S'              ,Nil})
					Aadd(aCabSF1,{"F1_ESPECIE"    ,'SPED'  			,Nil})
					Aadd(aCabSF1,{"F1_TIPO"       ,'N'     			,Nil})
					Aadd(aCabSF1,{"F1_DTDIGIT"    ,dDataBase  		,Nil})
					Aadd(aCabSF1,{"F1_EST"        ,cEst     		,Nil})
					Aadd(aCabSF1,{"F1_ZICMS"      ,ZZM->ZZM_VICMS   ,Nil})
					Aadd(aCabSF1,{"F1_VOLUME1"    ,nTotCab         ,Nil})
					Aadd(aCabSF1,{"F1_ESPECI1"    ,'Cabecas'         ,Nil})
					Aadd(aCabSF1,{"F1_PBRUTO"     ,nTotKG         ,Nil})
					Aadd(aCabSF1,{"F1_PLIQUI "    ,nTotKG         ,Nil})
					//Adequando o Valor total com o acrescimo e descontog
					IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)  <> 'A'
						nDesc := Round((ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC + ZZM->ZZM_DESPEC) / nTotCab, 6)
						For nI := 1 To Len(aCodAgrup)
						    aCodAgrup[nI,3] +=  (nDesc * aCodAgrup[nI,2])
						Next nI
					Else
						For nI := 1 To Len(aCodAgrup)
						    aCodAgrup[nI,3] +=  aCodAgrup[nI,4] //ZZN_ACRESC
						Next nI
					    //Ajus_Agrup(@aCodAgrup,nTotCab)
					EndIF
					SD1->(dbSetOrder(1))
					ZZP->(dbSetOrder(2))
					For nI := 1 To Len(aCodAgrup)
						ZZP->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO+PADR(ALLTRIM(aCodAgrup[nI,1]),TamSX3("ZZP_PRODUT")[1]) ))
					    While !ZZP->(EOF()).And.;
							   ZZP->ZZP_FILIAL == ZZM->ZZM_FILIAL .And.;
							   ZZP->ZZP_PEDIDO == ZZM->ZZM_PEDIDO .And.;
							   Alltrim(ZZP->ZZP_PRODUT) == Alltrim(aCodAgrup[nI,1])

					            aItem	   := {}
						        cTes       := MaTesInt(1,Alltrim(cOperTES),PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1]),PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]),"F",PADR(ALLTRIM(aCodAgrup[nI,1]),TamSX3("B1_COD")[1]))
								IF Empty(cTes)
								    cMsg := "Pelas regras cadastradas de 'TES inteligente', nao foi encontrado 'TES' para os dados abaixo: "+CRLF+;
									"Tipo de Operacao: "+cOperTES+CRLF+;
									"Fornecedor: "+ALLTRIM(ZZM->ZZM_FORNEC)+'-'+ALLTRIM(ZZM->ZZM_LOJA)+CRLF+;
									"Produto: "+ALLTRIM(aCodAgrup[nI,1])
									APMsgStop(cMsg)
								    bPassou := .F.
									Return
								EndIf
								SB1->(dbSeek(xFilial('SB1')+aCodAgrup[nI,1]))
								nValunit   := Round(aCodAgrup[nI,3]/aCodAgrup[nI,2],6)
								nValTot    := Round(ZZP->ZZP_QTD* nValunit, 2)
								Aadd(aItem,{"D1_COD"        ,aCodAgrup[nI,1]  ,Nil})
								Aadd(aItem,{"D1_QUANT"      ,ZZP->ZZP_QTD  ,Nil})
								Aadd(aItem,{"D1_VUNIT"      , nValunit  ,Nil})
								Aadd(aItem,{"D1_TOTAL"      , nValTot ,Nil})
								Aadd(aItem,{"D1_TES"        ,cTES      		,Nil})
								Aadd(aItem,{"D1_LOCAL"      ,SB1->B1_LOCPAD 	,Nil})
								//Aadd(aItem,{"D1_OPER"       ,cOperTES 		,Nil})
								Aadd(aItem,{"D1_NFORI"      ,ZZP->ZZP_DOC       	,Nil})
								Aadd(aItem,{"D1_SERIORI"	,ZZP->ZZP_SERIE  		,Nil})
								IF !Empty(ZZP->ZZP_CODAUX)
								    cCodAux  := ZZP->ZZP_CODAUX
								Else
								    cCodAux  := aCodAgrup[nI,1]
								EndIF
								IF SD1->(!dbSeek(ZZM->ZZM_FILIAL+;
												PADR(ALLTRIM(ZZP->ZZP_DOC),TamSX3("D1_DOC")[1])+;
												PADR(ALLTRIM(ZZP->ZZP_SERIE),TamSX3("D1_SERIE")[1])+;
												PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("D1_FORNECE")[1])+;
												PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("D1_LOJA")[1])+;
												PADR(ALLTRIM(cCodAux),TamSX3("ZZP_PRODUT")[1])))
								     MsgAlert('Item da Nota de referencia nao encontrado !!')
								     bPassou := .F.
								     Return
								EndIF
								Aadd(aItem,{"D1_ITEMORI"    , SD1->D1_ITEM 		,Nil})
								AAdd(aTotItem,aItem)
					         ZZP->(dbSkip())
					    Enddo
					Next nI
					ZZN->(dbSetOrder(1))
					ZZN->(dbSeek( ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO ))
					While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ ZZM->ZZM_PEDIDO
							IF ZZN->ZZN_PRODUT > '500000'
								aItem	   := {}
								IF Empty(ZZN->ZZN_CODAGR)
								     cMsg := "Codigo Agrupador do Incentivo em Branco !"
									  APMsgStop(cMsg)
								      bPassou := .F.
									  Return
								EndIF
						  		SB1->(dbSeek(xFilial('SB1')+ZZN->ZZN_CODAGR))
								cTes := MaTesInt(1,Alltrim(cOperTES),PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1]),PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]),"F",PADR(ALLTRIM(ZZN->ZZN_CODAGR),TamSX3("B1_COD")[1]))
								IF Empty(cTes)
								    cMsg := "Pelas regras cadastradas de 'TES inteligente', nao foi encontrado 'TES' para os dados abaixo: "+CRLF+;
									"Tipo de Operacao: "+cOperTES+CRLF+;
									"Fornecedor: "+ALLTRIM(ZZM->ZZM_FORNEC)+'-'+ALLTRIM(ZZM->ZZM_LOJA)+CRLF+;
									"Produto: "+ALLTRIM(ZZN->ZZN_CODAGR)
									APMsgStop(cMsg)
								    bPassou := .F.
									Return
								EndIf
								nValunit   := Round(ZZN->ZZN_VLARRO,6)
								nValTot    := Round(ZZN->ZZN_QTCAB * nValunit, 2)
								Aadd(aItem,{"D1_COD"        ,ZZN->ZZN_CODAGR  ,Nil})
								Aadd(aItem,{"D1_QUANT"      ,ZZN->ZZN_QTCAB  ,Nil})
								Aadd(aItem,{"D1_VUNIT"      , nValunit  ,Nil})
								Aadd(aItem,{"D1_TOTAL"      , nValTot ,Nil})
								Aadd(aItem,{"D1_TES"        ,cTES      		,Nil})
								Aadd(aItem,{"D1_LOCAL"      ,SB1->B1_LOCPAD 	,Nil})
								AAdd(aTotItem,aItem)
							EndIF
							ZZN->(dbSkip())
					End
						MSExecAuto({|x,y| MATA103(x,y)},aCabSF1,aTotItem)
						If lMsErroAuto
							DisarmTransaction()
							aErro := GetAutoGRLog()
							cErro := ""
							For nI := 1 to Len(aErro)
								cErro += aErro[nI] + CRLF
							Next nI
							msgStop(cErro)
							bPassou   := .F.
						Else
							bPassou   := .T.
							Reclock("ZZM",.F.)
							ZZM->ZZM_DOC    := cNumero
							ZZM->ZZM_SERIE  := cSerie
							IF ZZM->ZZM_STATUS == '3'
								ZZM->ZZM_STATUS := '4'
							EndIF
							ZZM->ZZM_ENVIA  := 'S'
							ZZM->(MsUnlock())
							//U_FIS16_GNRE()  O recolhimento � feito mensal, nao sera feito nota a nota. Carneiro 12/2017
							U_CPA999(1) // Tipo 1 = emite a nota fiscal.
						Endif

				//EndIF
			EndIF
		//EndIF
	EndIF
EndIF
Return
*******************************************************************************************************************************************************
Static Function DifValor()

Local cQuery  := ''
Local bRet    := .T.
Local nVZZN   := 0
Local nVZZP   := 0
Local nAdian  := 0
Local nLiq    := 0

cQuery := " SELECT SUM(ZZN_VLTOT) VALOR_ZZN  "
cQuery += " FROM "+RetSQLName("ZZN")
cQuery += " WHERE ZZN_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZN_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_ZZN") > 0
	QRY_ZZN->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZN",.T.,.F.)
dbSelectArea("QRY_ZZN")
QRY_ZZN->(dbGoTop())
IF  !QRY_ZZN->(EOF())
   nVZZN   := QRY_ZZN->VALOR_ZZN
EndIF

cQuery := " SELECT SUM(ZZP_QTD *ZZP_VALOR) VALOR_ZZP  "
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
IF  !QRY_ZZP->(EOF())
   nVZZP   := QRY_ZZP->VALOR_ZZP
EndIF
//IF nVZZN <> nVZZP
IF (nVZZN  - nVZZP + ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC + ZZM->ZZM_DESPEC  ) <> 0
    bRet := .F.
EndIF

nLiq   := nVZZN  - nVZZP + ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC + ZZM->ZZM_DESPEC

Return {bRet, nLiq }
*******************************************************************************************************************************************************
User Function TAE15_AGR

Local oBtn
Local oDlg1

Private aAGR      := {}
Private aRecAGR   := {}
Private oListAGR  := {}
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
Private oOK       := LoadBitmap(GetResources(),'LBOK')
Private oNO       := LoadBitmap(GetResources(),'LBNO')


IF !bEmite
    IF ZZM->ZZM_STATUS <>'1'
        MsgAlert('Situacao do Boletim nao permite Agrupamento !')
    	Return
    EndIF
Else
    IF ZZM->ZZM_STATUS <>'1'
		MsgAlert('Processo j� encerrado, nao � possivel Agrupar !!')
		Return
	EndIF
	IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)=='T'
		MsgAlert('Boletim de Abate de Terceiro nao � possivel Agrupar !!')
		Return
	EndIF
EndIF
Dados_AGR()
IF Len(aAGR) ==0
	msgAlert('Nao h� Boletins para agrupamento')
Else

	DEFINE MSDIALOG oDlg1 TITLE "Agrupamentos de Boletins" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

		@ 007, 005 LISTBOX oListAGR	 Fields HEADER "","Boletim de Abates" SIZE 143,127 OF oDlg1 COLORS 0, 16777215 PIXEL
		oListAGR:SetArray(aAGR)
		oListAGR:nAt        := 1
		oListAGR:bLine      := { || {If(aAGR[oListAGR:nAt,01],oOK,oNO),aAGR[oListAGR:nAt,2]}}
		oListAGR:bLDblClick := { || aAGR[oListAGR:nAt][1] := !aAGR[oListAGR:nAt][1],oListAGR:DrawSelect()}

		oBtn := TButton():New( 137, 005 ,'Cancelar'   , oDlg1,{|| oDlg1:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 137, 090 ,'Confirmar'  , oDlg1,{|| AGR_PED(),oDlg1:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDlg1 CENTERED
EndIF

Return .T.



Return
*********************************************************************************************************************************************
Static Function Dados_AGR

Local cQuery := ''
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))

aAGR    :={}
aRecAGR := {}
cQuery := " SELECT *  "
cQuery += " FROM "+RetSQLName("ZZM")
cQuery += " WHERE ZZM_FILIAL  =  '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC  =  '" + ZZM->ZZM_FORNEC + "' "
cQuery += "   AND ZZM_LOJA    =  '" + ZZM->ZZM_LOJA + "' "
cQuery += "   AND ZZM_PEDIDO  <> '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND ZZM_STATUS  =  '1' "
cQuery += "   AND ZZM_PEDIDO Not Like 'A%' "
cQuery += "   AND ZZM_PEDIDO Not Like 'T%' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZM_PEDIDO "
If Select("QRY_AGR") > 0
	QRY_AGR->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
dbSelectArea("QRY_AGR")
QRY_AGR->(dbGoTop())
While !QRY_AGR->(EOF())
	AADD(aAGR,{.F.,QRY_AGR->ZZM_PEDIDO})
	QRY_AGR->(dbSkip())
EndDo

Return
*********************************************************************************************************************************************
Static Function AGR_PED

Local nI      		  := 0
Local nC              := 0
Local aZZN    		  := {}
Local aPos      	  := 0
Local cNumZZM 		  := ''
Local aAGRTot 		  := {}
Local cItem   		  := ''
Local cFILPED         := ''
Local cDAT_EMISSAO    := ''
Local cCOD_FORNECEDOR := ''
Local cLOJA           := ''
Local cNOME           := ''
Local nVLDESC         := 0
Local nVLACR          := 0
Local cVENCE          := ''
Local nVLDUPL         := 0
Local cFAV            := ''
Local cCNPJ           := ''
Local cBANCO          := ''
Local cAGEN           := ''
Local cCONTA          := ''
Local aMapa           := {}
Local aGTA            := {}
Local cDAT_PROD       := ''
Local nVICMS          := 0
Local nICMSNP         := 0
Local nVNFP           := 0
Local nDESPEC         := 0
Local nTotCab         := 0
Local nAcresc         := 0
Local nDesc           := 0
Local cEmite          := ''

Private cFILNFE   := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL  := GetMV('MGF_TAE15A',.F.,"")
Private bEmite    := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))


dbSelectArea('ZZN')
dbSetOrder(1)
IF Len(aAGR) > 0
	For nI := 1 TO Len(aAGR)
		IF aAGR[nI,1]
			AAdd(aAGRTot,aAGR[nI,2])
		EndIF
	Next
	IF LEN(aAGRTot) > 0
		AAdd(aAGRTot,ZZM->ZZM_PEDIDO)
		ZZM->(dbSetOrder(1))

		For nI := 1 TO Len(aAGRTot)
			ZZM->(dbSeek( ZZM->ZZM_FILIAL+aAGRTot[nI]))
			nTotCab  := 0
			nAcresc  := ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC +  ZZM->ZZM_DESPEC
			ZZN->(dbSeek( ZZM->ZZM_FILIAL+aAGRTot[nI] ))
			While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ aAGRTot[nI]
				IF ZZN->ZZN_PRODUT <= '500000'
					nTotCab += ZZN->ZZN_QTCAB
				EndIF
				ZZN->(dbSkip())
			End
			nDesc := Round((ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC + ZZM->ZZM_DESPEC) / nTotCab, 6)
			ZZN->(dbSeek( ZZM->ZZM_FILIAL+aAGRTot[nI] ))
			While ZZN->(!EOF()) .And. ZZN->ZZN_FILIAL + ZZN->ZZN_PEDIDO == ZZM->ZZM_FILIAL+ aAGRTot[nI]
				nPos   := aScan( aZZN, { |x| Alltrim(x[9]) == Alltrim(ZZN->ZZN_PRODUT+ZZN->ZZN_CODAGR) })
				IF nPos == 0
					AAdd( aZZN, {ZZN->ZZN_PRODUT,;
					             ZZN->ZZN_QTCAB,;
					             ZZN->ZZN_QTKG,;
					             ZZN->ZZN_VLTOT,;
					             (ZZN->ZZN_VLARRO * ZZN->ZZN_QTCAB),;
					             ZZN->ZZN_QTPE,;
					             ZZN->ZZN_QTCAB,;
					             ZZN->ZZN_CODAGR,;
					             ZZN->ZZN_PRODUT+ZZN->ZZN_CODAGR,;
					             IIF(ZZN->ZZN_PRODUT <= '500000',(nDesc * ZZN->ZZN_QTCAB),0)}  )
				Else
					aZZN[nPos,2]  += ZZN->ZZN_QTCAB
					aZZN[nPos,3]  += ZZN->ZZN_QTKG
					aZZN[nPos,4]  += ZZN->ZZN_VLTOT
					aZZN[nPos,5]  += (ZZN->ZZN_VLARRO * ZZN->ZZN_QTCAB)
					aZZN[nPos,6]  += ZZN->ZZN_QTPE
					aZZN[nPos,7]  += ZZN->ZZN_QTCAB
					aZZN[nPos,10] += IIF(ZZN->ZZN_PRODUT <= '500000',(nDesc * ZZN->ZZN_QTCAB),0)
				EndIF
				ZZN->(dbSkip())
			End



		Next nI
		cNumZZM  := NumZZM(1)
		cFILPED         := ZZM->ZZM_FILIAL
		cDAT_EMISSAO    := ZZM->ZZM_EMISSA
		cDAT_PROD       := ZZM->ZZM_DTPROD
		cCOD_FORNECEDOR := ZZM->ZZM_FORNEC
		cLOJA           := ZZM->ZZM_LOJA
		cNOME           := ZZM->ZZM_NOME
		cVENCE          := ZZM->ZZM_VENCE
		cFAV            := ZZM->ZZM_FAV
		//cCNPJ           := ZZM->ZZM_CNPJ
		cBANCO          := ZZM->ZZM_BANCO
		cAGEN           := ZZM->ZZM_AGENCI
		cCONTA          := ZZM->ZZM_CONTA
		nICMSNP         := ZZM->ZZM_ICMSNP
		nVNFP           := ZZM->ZZM_VNFP
		cEmite          := ZZM->ZZM_EMITE
		ZZM->(dbSetOrder(1))
		For nI := 1 TO Len(aAGRTot)
			ZZM->(dbSeek(cFILPED+aAGRTot[nI]))
			nVLDESC   += ZZM->ZZM_VLDESC
			nVLACR    += ZZM->ZZM_VLACR
			nVLDUPL   += ZZM->ZZM_VLDUPL
			nVICMS    += ZZM->ZZM_VICMS
			nDESPEC   += ZZM->ZZM_DESPEC
		Next nI


		//Criando o Pedido Agrupado
		Reclock("ZZM",.T.)
		ZZM->ZZM_FILIAL := cFILPED
		ZZM->ZZM_PEDIDO	:= cNumZZM
		ZZM->ZZM_EMITE 	:= cEmite
		ZZM->ZZM_EMISSA	:= cDAT_EMISSAO
		ZZM->ZZM_DTPROD := cDAT_PROD
		ZZM->ZZM_FORNEC	:= cCOD_FORNECEDOR
		ZZM->ZZM_LOJA  	:= cLOJA
		ZZM->ZZM_NOME 	:= cNOME
		ZZM->ZZM_VLDESC	:= nVLDESC
		ZZM->ZZM_VLACR 	:= nVLACR
		ZZM->ZZM_VENCE 	:= cVENCE
		ZZM->ZZM_VLDUPL	:= nVLDUPL
		ZZM->ZZM_VICMS  := nVICMS
		ZZM->ZZM_FAV   	:= cFAV
		//ZZM->ZZM_CNPJ  	:= cCNPJ
		ZZM->ZZM_BANCO 	:= cBANCO
		ZZM->ZZM_AGENCI	:= cAGEN
		ZZM->ZZM_CONTA	:= cCONTA
		ZZM->ZZM_STATUS := '1'
		ZZM->ZZM_AGRUP	:= ''
		ZZM->ZZM_ICMSNP := nICMSNP
		ZZM->ZZM_VNFP   := nVNFP
		ZZM->ZZM_DESPEC := nDESPEC
		ZZM->(MsUnlock())
		//Itens
		cItem := '00'
		For nI := 1 TO Len(aZZN)
			cItem := SOMA1(cItem)
			Reclock("ZZN",.T.)
			ZZN->ZZN_FILIAL := cFILPED
			ZZN->ZZN_PEDIDO	:= cNumZZM
			ZZN->ZZN_ITEM   := cItem
			ZZN->ZZN_PRODUT	:= aZZN[nI][1]
			ZZN->ZZN_QTCAB  := aZZN[nI][2]
			ZZN->ZZN_QTKG  	:= aZZN[nI][3]
			ZZN->ZZN_VLTOT 	:= aZZN[nI][4]
			ZZN->ZZN_VLARRO	:= aZZN[nI][5] / aZZN[nI][7]
			ZZN->ZZN_QTPE   := aZZN[nI][6]
			ZZN->ZZN_CODAGR := aZZN[nI][8]
			ZZN->ZZN_ACRESC := aZZN[nI,10]
			ZZN->(MsUnlock())
		Next NI

		//Atualizando os Pedidos Origens
		ZZM->(dbSetOrder(1))
		ZZO->(dbSetOrder(1))
		ZZQ->(dbSetOrder(1))
		For nI := 1 TO Len(aAGRTot)
			IF ZZM->(dbSeek(cFILPED+aAGRTot[nI]))
				Reclock("ZZM",.F.)
				ZZM->ZZM_AGRUP	:= cNumZZM
				ZZM->ZZM_STATUS	:= IIF(bEmite,'2','6')
				ZZM->(MsUnlock())
			EndIF

			//ZZP
			cQuery := " Delete From  "+RetSqlName("ZZP")
			cQuery += " Where ZZP_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZP_PEDIDO = '"+aAGRTot[nI]+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgAlert('Erro ao Excluir: '+TcSQLError())
			EndIF

			// MAPA
			aMapa :={}
			ZZO->(dbSeek( cFILPED+aAGRTot[nI]))
			While ZZO->(!EOF()) .And. ZZO->ZZO_FILIAL + ZZO->ZZO_PEDIDO == cFILPED+aAGRTot[nI]
				AADD(aMapa,{ZZO->ZZO_SEMADE ,ZZO->ZZO_MAPA,ZZO->ZZO_VTINC,ZZO->ZZO_IDA})
				ZZO->(dbSkip())
			EndDo
			// Mapa
			For nC := 1 To Len( aMapa )
				Reclock("ZZO",.T.)
				ZZO->ZZO_FILIAL := cFILPED
				ZZO->ZZO_PEDIDO	:= cNumZZM
				ZZO->ZZO_SEMADE := aMapa[nC][1]
				ZZO->ZZO_MAPA  	:= aMapa[nC][2]
				ZZO->ZZO_VTINC  := aMapa[nC][3]
				ZZO->ZZO_IDA   	:= aMapa[nC][4]
				ZZO->(MsUnlock())
			Next NC
			//GTA
			aGTA :={}
			ZZQ->(dbSeek( cFILPED+aAGRTot[nI]))
			While ZZQ->(!EOF()) .And. ZZQ->ZZQ_FILIAL + ZZQ->ZZQ_PEDIDO == cFILPED+aAGRTot[nI]
				AADD(aGTA,ZZQ->ZZQ_GTA)
				ZZQ->(dbSkip())
			EndDo
			For nC := 1 To Len( aGTA )
				Reclock("ZZQ",.T.)
				ZZQ->ZZQ_FILIAL := cFILPED
				ZZQ->ZZQ_PEDIDO	:= cNumZZM
				ZZQ->ZZQ_GTA    := aGTA[nC]
				ZZQ->(MsUnlock())
			Next nC
		Next nI
		msgAlert('Boletim Agrupado gerado : '+cNumZZM)
	EndIF
EndIF

Return
*******************************************************************************************************************************************************
Static Function NumZZM(nTipo)
Local cQuery   := ''
Local cNumZZM  := ''

IF nTipo == 1
	cNumZZM := 'A000001'
Else
	cNumZZM := 'T000001'
EndIF

cQuery  := " SELECT Max(SUBSTR(ZZM_PEDIDO,2,6))  MAXPED "
cQuery  += " FROM "+RetSqlName("ZZM")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "  AND ZZM_FILIAL  = '"+xFilial('ZZM')+"'"
IF nTipo == 1
	cQuery  += "  AND ZZM_PEDIDO Like 'A%' "
Else
	cQuery  += "  AND ZZM_PEDIDO Like 'T%' "
EndIF
If Select("QRY_PED") > 0
	QRY_PED->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PED",.T.,.F.)
dbSelectArea("QRY_PED")
QRY_PED->(dbGoTop())
IF !QRY_PED->(EOF()) .And. !Empty(QRY_PED->MAXPED)
 	IF nTipo == 1
	    cNumZZM    := 'A'+SOMA1(Alltrim(QRY_PED->MAXPED))
    Else
    	cNumZZM    := 'T'+SOMA1(Alltrim(QRY_PED->MAXPED))
    EndIF
EndIF

Return cNumZZM
******************************************************************************************************************************************
User Function FIS16_TXT
Local cQuery := ''
Local xTexto := ''
Local nAdian := 0
Local nLiq   := 0
Local cMapa  := ''
Local nICMS :=  0

dbSelectArea('ZZO')
ZZO->(dbSetOrder(1))

cQuery := " SELECT *  "
cQuery += " FROM "+RetSQLName("ZZM")
cQuery += " WHERE ZZM_FILIAL = '" + SF1->F1_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC = '" + SF1->F1_FORNECE + "' "
cQuery += "   AND ZZM_LOJA   = '" + SF1->F1_LOJA + "' "
cQuery += "   AND ZZM_DOC    = '" + SF1->F1_DOC + "' "
cQuery += "   AND ZZM_SERIE  = '" + SF1->F1_SERIE + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_PEDABATE") > 0
	QRY_PEDABATE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
dbSelectArea("QRY_PEDABATE")
QRY_PEDABATE->(dbGoTop())
IF QRY_PEDABATE->(!EOF())
     xTexto += CRLF
     IF QRY_PEDABATE->ZZM_ADIAN > 0
           nAdian := QRY_PEDABATE->ZZM_ADIAN
     Else
       IF QRY_PEDABATE->ZZM_DESPEC > 0
            nAdian := QRY_PEDABATE->ZZM_DESPEC
       EndIF
     EndIF
	 nLiq   := SF1->F1_VALBRUT- SF1->F1_CONTSOC - SF1->F1_VLSENAR - nAdian  - SF1->F1_VALFUND
	 IF SF1->F1_VALICM - SF1->F1_ZICMS > 0
	     nICMS := SF1->F1_VALICM - SF1->F1_ZICMS
	 EndIF
     xTexto += 'Valor Liquido a Pagar: '+ Alltrim(Transform(nLiq,'@E 99,999,999.99')) +' '
     xTexto += 'ICMS Recolhido: '       + Alltrim(Transform(SF1->F1_ZICMS,'@E 99,999,999.99')) +' '
     xTexto += 'ICMS a Recolher: '      + Alltrim(Transform(nICMS,'@E 99,999,999.99')) +' '
     xTexto += 'Valor da Nota: '        + Alltrim(Transform(SF1->F1_VALBRUT,'@E 99,999,999.99')) +' '
     xTexto += 'Valor do Adiantamento: '+ Alltrim(Transform(nAdian ,'@E 99,999,999.99')) +' '
     xTexto += 'ICMS da Nota: '         + Alltrim(Transform(SF1->F1_VALICM,'@E 99,999,999.99')) +' '
     xTexto += 'Romaneio : '+Alltrim(QRY_PEDABATE->ZZM_ROMAN) + ' Data: '+ DTOC(STOD(QRY_PEDABATE->ZZM_DTROMA)) +' '
     xTexto += Alltrim(QRY_PEDABATE->ZZM_OBS)+' '
     //Verifica se tem MAPA PRECOCE
	 ZZO->(dbSeek( QRY_PEDABATE->ZZM_FILIAL+QRY_PEDABATE->ZZM_PEDIDO ))
	 While ZZO->(!EOF()) .And. ZZO->ZZO_FILIAL + ZZO->ZZO_PEDIDO == QRY_PEDABATE->ZZM_FILIAL+ QRY_PEDABATE->ZZM_PEDIDO
		IF ZZO->ZZO_MAPA <> '' .AND. ZZO->ZZO_MAPA <> '0'
		   cMapa  += Alltrim(ZZO->ZZO_MAPA)+' '
		EndIF
		ZZO->(dbSkip())
      Enddo
	  IF !Empty(cMapa)
           xTexto += 'PRECOCE_MS PROAPE-PRECOCE/MS DECRETO No. 11.176/2003 MAPA: '+cMapa
      EndIF
EndIF
// Colocar no NFESEFAZ cMensFis := U_FIS16_TXT(cMensFis)
QRY_PEDABATE->(dbCloseArea())

Return xTexto
***************************************************************************************************************************************************
User Function FIS16_GNRE

Local aDadosSF1  := {}
Local cLcPadICMS := SubStr(GetMV("MV_LPADICM"),1,3)
Local aDataGuia  :=  DetDatas(Month(SF1->F1_DTDIGIT),Year(SF1->F1_DTDIGIT),3,1)
Local aGNRE      := {}
Local nValor     := 0

SF1->(dbSetOrder(1))
IF SF1->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_DOC+ZZM->ZZM_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
	nValor     := SF1->F1_VALICM - SF1->F1_ZICMS
	IF nValor > 0
		AAdd(aDadosSF1,{SF1->F1_DOC,  ;
		                SF1->F1_SERIE,;
		                SF1->F1_FORNECE,;
		                SF1->F1_LOJA, ;
		                SF1->F1_TIPO, ;
		                "1",          ;
		                SuperGetMV("MV_ESTADO") })
		GravaTit(.T. ,;//Gera titulo ICMS Antecipa��o
				 nValor,; //Valor do ICMS Antecipado.
				 "ICMS", ;
				 "IC",   ;
				 cLcPadICMS,;
				 aDataGuia[1]/*Dt  inic*/, ;
				 aDataGuia[2]/*Dt Fim*/, ;
				 DataValida(aDataGuia[2]+1,.T.) /*Dt Venc*/, ;
				 1,;
				 .T.,;//lIcmsGuia,;
				 Month(SF1->F1_DTDIGIT),;
				 Year(SF1->F1_DTDIGIT), ;
				 0,;
				 nValor,;
				 "MATA103",;
				 .F.,; //lCtbOnLine,;
				 SF1->F1_DOC,;//cNFiscal, ;
				 @aGNRE,,,,,,,,,,0,aDadosSF1)
	EndIF
EndIF

Return
***************************************************************************************************************************************************
User Function CPA999(nTipoCPA)
Local cPrefixo := ''
Local nPos     :=  0


SF1->(dbSetOrder(1))
IF nTipoCPA == 1
	IF SF1->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_DOC+ZZM->ZZM_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
		cPrefixo := SF1->F1_PREFIXO
		cQuery := " Update "+RetSqlName("SE2")
		cQuery += " Set E2_MSBLQL    = '2'"
		IF !Empty(ZZM->ZZM_BANCO) 	.And. !Empty(ZZM->ZZM_AGENCI) .And. !Empty(ZZM->ZZM_CONTA)
			cQuery += " , E2_FORBCO  = '"+Alltrim(ZZM->ZZM_BANCO)+"'"
			IF  '-' $ Alltrim(ZZM->ZZM_AGENCI)
				nPos := AT('-',Alltrim(ZZM->ZZM_AGENCI))
				cQuery += " , E2_FORAGE  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),1,nPos-1)+"'"
				IF !Empty(SUBSTR(Alltrim(ZZM->ZZM_AGENCI),nPos+1,LEN(Alltrim(ZZM->ZZM_AGENCI))))
					cQuery += " , E2_FAGEDV  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),nPos+1,LEN(Alltrim(ZZM->ZZM_AGENCI)))+"'"
				Else
					cQuery += " , E2_FAGEDV  = ' '"
				EndIF
			Else
				cQuery += " , E2_FORAGE  = '"+Alltrim(ZZM->ZZM_AGENCI)+"'"
			EndIF

			cQuery += " , E2_FORCTA  = '"+SUBSTR(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")),1,LEN(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")))-1)+"'"
			cQuery += " , E2_FCTADV  = '"+SUBSTR(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")),LEN(Alltrim(StrTran(ZZM->ZZM_CONTA,"-",""))),1)+"'"
			IF !Empty(ZZM->ZZM_TIPOC) .And. Alltrim(ZZM->ZZM_TIPOC) $ '01;11'
				cQuery += " , E2_XFINALI = '"+ZZM->ZZM_TIPOC+"'"
			EndIF
		EndIF

		cQuery += " Where E2_FILIAL  = '"+ZZM->ZZM_FILIAL+"'"
		cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"'"
		cQuery += "   AND E2_NUM     = '"+ZZM->ZZM_DOC+"'"
		cQuery += "   AND E2_TIPO    = 'NF'"
		cQuery += "   AND E2_FORNECE = '"+Alltrim(ZZM->ZZM_FORNEC)+"'"
		cQuery += "   AND E2_LOJA    = '"+ZZM->ZZM_LOJA+"'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQuery) < 0)
			bContinua   := .F.
			MsgStop(TcSQLError())
		EndIF
	EndIF
ElseIF nTipoCPA == 2
	cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("ZZP")
	cQuery += " WHERE ZZP_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
	cQuery += "   AND ZZP_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select("QRY_ZZP") > 0
		QRY_ZZP->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
	dbSelectArea("QRY_ZZP")
	QRY_ZZP->(dbGoTop())
	While !QRY_ZZP->(EOF())
		//IF SF1->(dbSeek(QRY_ZZP->ZZP_FILIAL+QRY_ZZP->ZZP_DOC+QRY_ZZP->ZZP_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
			cPrefixo := QRY_ZZP->ZZP_SERIE
			cQuery := " Update "+RetSqlName("SE2")
			cQuery += " Set E2_MSBLQL    = '2'"
			IF !Empty(ZZM->ZZM_BANCO) 	.And. !Empty(ZZM->ZZM_AGENCI) .And. !Empty(ZZM->ZZM_CONTA)
				cQuery += " , E2_FORBCO  = '"+Alltrim(ZZM->ZZM_BANCO)+"'"
				IF  '-' $ Alltrim(ZZM->ZZM_AGENCI)
					nPos := AT('-',Alltrim(ZZM->ZZM_AGENCI))
					cQuery += " , E2_FORAGE  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),1,nPos-1)+"'"
					IF !Empty(SUBSTR(Alltrim(ZZM->ZZM_AGENCI),nPos+1,LEN(Alltrim(ZZM->ZZM_AGENCI))))
						cQuery += " , E2_FAGEDV  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),nPos+1,LEN(Alltrim(ZZM->ZZM_AGENCI)))+"'"
					Else
						cQuery += " , E2_FAGEDV  = ' '"
					EndIF
				Else
					cQuery += " , E2_FORAGE  = '"+Alltrim(ZZM->ZZM_AGENCI)+"'"
				EndIF

				cQuery += " , E2_FORCTA  = '"+SUBSTR(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")),1,LEN(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")))-1)+"'"
				cQuery += " , E2_FCTADV  = '"+SUBSTR(Alltrim(StrTran(ZZM->ZZM_CONTA,"-","")),LEN(Alltrim(StrTran(ZZM->ZZM_CONTA,"-",""))),1)+"'"
				IF !Empty(ZZM->ZZM_TIPOC) .And. Alltrim(ZZM->ZZM_TIPOC) $ '01;11'
					cQuery += " , E2_XFINALI = '"+ZZM->ZZM_TIPOC+"'"
				EndIF
			EndIF
			cQuery += " Where E2_FILIAL  = '"+ZZM->ZZM_FILIAL+"'"
			cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"'"
			cQuery += "   AND E2_NUM     = '"+QRY_ZZP->ZZP_DOC+"'"
			cQuery += "   AND E2_TIPO    = 'NF'"
			cQuery += "   AND E2_FORNECE = '"+Alltrim(ZZM->ZZM_FORNEC)+"'"
			cQuery += "   AND E2_LOJA    = '"+ZZM->ZZM_LOJA+"'"
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgStop(TcSQLError())
			EndIF
		//EndIF
		QRY_ZZP->(dbSkip())
	End
EndIF

Return

**********************************************************************************************************************************************************
/*
Static Function Ret_OP_DIA()

Local cOP    := '000'
Local cQuery := ''

cQuery := " SELECT MAX(C2_SEQUEN) MXSEQ  "
cQuery += " FROM "+RetSQLName("SC2")
cQuery += " WHERE C2_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND C2_NUM+C2_ITEM = '" + SUBSTR(DTOS(ZZM->ZZM_EMISSA),3,6)+'04' + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_NUMOP") > 0
	QRY_NUMOP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NUMOP",.T.,.F.)
dbSelectArea("QRY_NUMOP")
QRY_NUMOP->(dbGoTop())
IF QRY_NUMOP->(!EOF())
     cOP    := SOMA1(QRY_NUMOP->MXSEQ)
EndIF
QRY_NUMOP->(dbCloseArea())

Return cOP*/
************************************************************************************************************
Static Function Ret_Agrup()

Local cAgrup := "'x'"
Local cQuery := ''

cQuery := " SELECT ZZM_PEDIDO  "
cQuery += " FROM   "+RetSqlName("ZZM")
cQuery += " Where ZZM_FILIAL = '"+ZZM->ZZM_FILIAL+"'"
cQuery += "   AND ZZM_AGRUP  = '"+ZZM->ZZM_PEDIDO+"'"
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_AGR") > 0
	QRY_AGR->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
dbSelectArea("QRY_AGR")
QRY_AGR->(dbGoTop())
WHILE QRY_AGR->(!EOF())
     cAgrup += ",'"+Alltrim(QRY_AGR->ZZM_PEDIDO)+"'"
     QRY_AGR->(dbSkip())
End
QRY_AGR->(dbCloseArea())

Return cAgrup

***********************************************************************************************************************************************
Static Function Libera_Pag

Local aNotas := {}
Local nI     := 0

SF1->(dbSetOrder(1))
cQuery := " SELECT ZZP_FILIAL, ZZP_DOC,ZZP_SERIE "
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY ZZP_FILIAL, ZZP_DOC,ZZP_SERIE "
If Select("QRY_NOTA") > 0
	QRY_NOTA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NOTA",.T.,.F.)
dbSelectArea("QRY_NOTA")
QRY_NOTA->(dbGoTop())
While !QRY_NOTA->(EOF())
    nI   += 1
    AADD(aNotas,{.T.,QRY_NOTA->ZZP_FILIAL,QRY_NOTA->ZZP_DOC,QRY_NOTA->ZZP_SERIE})

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SD1")+' SD1 '
	cQuery += " WHERE D1_FILIAL  = '" + QRY_NOTA->ZZP_FILIAL + "' "
	cQuery += "   AND D1_FORNECE = '" + ZZM->ZZM_FORNEC + "' "
	cQuery += "   AND D1_LOJA    = '" + ZZM->ZZM_LOJA + "' "
	cQuery += "   AND D1_DOC     = '" + QRY_NOTA->ZZP_DOC+ "' "
	cQuery += "   AND D1_SERIE   = '" + QRY_NOTA->ZZP_SERIE+ "' "
	cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
	If Select("QRY_NF") > 0
		QRY_NF->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NF",.T.,.F.)
	dbSelectArea("QRY_NF")
	QRY_NF->(dbGoTop())
	ZZP->(dbSetOrder(1))
	While !QRY_NF->(EOF())
	    cQuery := " SELECT SUM(ZZP_QTD) SOMA_QTD "
		cQuery += " FROM "+RetSQLName("ZZP")+' ZZP, '+RetSQLName("ZZM")+' ZZM'
		cQuery += " WHERE ZZP_FILIAL  = ZZM_FILIAL "
		cQuery += "   AND ZZP_PEDIDO  = ZZM_PEDIDO "
		cQuery += "   AND ZZP_FILIAL  = '" + QRY_NF->D1_FILIAL + "' "
		cQuery += "   AND ZZM_FORNEC  = '" + QRY_NF->D1_FORNECE + "' "
		cQuery += "   AND ZZM_LOJA    = '" + QRY_NF->D1_LOJA + "' "
		cQuery += "   AND ZZP_DOC     = '" + QRY_NF->D1_DOC + "' "
		cQuery += "   AND ZZP_SERIE   = '" + QRY_NF->D1_SERIE + "' "
		cQuery += "   AND ZZP_PRODUT  = '" + QRY_NF->D1_COD+ "' "
		cQuery += "   AND ZZM_STATUS  in ('4','5') "
		cQuery += "   AND ZZP.D_E_L_E_T_ = ' ' "
		cQuery += "   AND ZZM.D_E_L_E_T_ = ' ' "
		If Select("QRY_ZZP") > 0
			QRY_ZZP->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
		dbSelectArea("QRY_ZZP")
		QRY_ZZP->(dbGoTop())
		bCad := .T.
		IF QRY_ZZP->(!EOF())
		   nQuant := QRY_NF->D1_QUANT - QRY_ZZP->SOMA_QTD
		   IF nQuant <> 0
		       aNotas[nI][1] := .F.
		   EndIF
	    EndIF
	    QRY_NF->(dbSkip())
    End
    QRY_NOTA->(dbSkip())
EndDo
For nI := 1 To Len(aNotas)
	IF aNotas[nI][1]
		IF SF1->(dbSeek(aNotas[nI][2]+aNotas[nI][3]+aNotas[nI][4]+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
			cPrefixo := SF1->F1_PREFIXO
			cQuery := " Update "+RetSqlName("SE2")
			cQuery += " Set E2_MSBLQL    = '2'"
			IF !Empty(ZZM->ZZM_BANCO) 	.And. !Empty(ZZM->ZZM_AGENCI) .And. !Empty(ZZM->ZZM_CONTA)
			     cQuery += " , E2_FORBCO  = '"+Alltrim(ZZM->ZZM_BANCO)+"'"
			     cQuery += " , E2_FORAGE  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),1,LEN(Alltrim(ZZM->ZZM_AGENCI))-1)+"'"
			     cQuery += " , E2_FAGEDV  = '"+SUBSTR(Alltrim(ZZM->ZZM_AGENCI),LEN(Alltrim(ZZM->ZZM_AGENCI)),1)+"'"
			     cQuery += " , E2_FORCTA  = '"+SUBSTR(Alltrim(ZZM->ZZM_CONTA),1,LEN(Alltrim(ZZM->ZZM_CONTA))-1)+"'"
			     cQuery += " , E2_FCTADV  = '"+SUBSTR(Alltrim(ZZM->ZZM_CONTA),LEN(Alltrim(ZZM->ZZM_CONTA)),1)+"'"
	        EndIF
			cQuery += " Where E2_FILIAL  = '"+ZZM->ZZM_FILIAL+"'"
			cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"'"
			cQuery += "   AND E2_NUM     = '"+aNotas[nI][3]+"'"
			cQuery += "   AND E2_TIPO    = 'NF'"
			cQuery += "   AND E2_FORNECE = '"+Alltrim(ZZM->ZZM_FORNEC)+"'"
			cQuery += "   AND E2_LOJA    = '"+ZZM->ZZM_LOJA+"'"
			IF (TcSQLExec(cQuery) < 0)
				bContinua   := .F.
				MsgStop(TcSQLError())
			EndIF
		EndIF
	EndIF
Next nI
Return
**********************************************************************************************************************************************
User Function TAE15CAN

cQuery := " SELECT R_E_C_N_O_ RECZZM  "
cQuery += " FROM "+RetSQLName("ZZM")
cQuery += " WHERE ZZM_FILIAL = '" + SF1->F1_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC = '" + SF1->F1_FORNECE + "' "
cQuery += "   AND ZZM_LOJA   = '" + SF1->F1_LOJA + "' "
cQuery += "   AND ZZM_DOC    = '" + SF1->F1_DOC + "' "
cQuery += "   AND ZZM_SERIE  = '" + SF1->F1_SERIE + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_PEDABATE") > 0
	QRY_PEDABATE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
dbSelectArea("QRY_PEDABATE")
QRY_PEDABATE->(dbGoTop())
IF QRY_PEDABATE->(!EOF())
     dbSelectArea('ZZM')
     ZZM->(dbGoTo(QRY_PEDABATE->RECZZM))
     Reclock("ZZM",.F.)
     ZZM->ZZM_DOC    := ' '
     ZZM->ZZM_SERIE  := ' '
	 ZZM->ZZM_STATUS := IIF(ZZM->ZZM_STATUS == '5','5','3')
	 ZZM->ZZM_ENVIA  := 'S'
	 ZZM->(MsUnlock())
EndIF
QRY_PEDABATE->(dbCloseArea())


Return
**********************************************************************************************************************************************
User Function TAE15EXC
Local lRet := .T.
// Verifica se a nota a ser Excluida foi Emitida pelo programa de Abate

cQuery := " SELECT R_E_C_N_O_ RECZZM  "
cQuery += " FROM "+RetSQLName("ZZM")
cQuery += " WHERE ZZM_FILIAL = '" + SF1->F1_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC = '" + SF1->F1_FORNECE + "' "
cQuery += "   AND ZZM_LOJA   = '" + SF1->F1_LOJA + "' "
cQuery += "   AND ZZM_DOC    = '" + SF1->F1_DOC + "' "
cQuery += "   AND ZZM_SERIE  = '" + SF1->F1_SERIE + "' "
cQuery += "   AND ZZM_STATUS = '5' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_PEDABATE") > 0
	QRY_PEDABATE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
dbSelectArea("QRY_PEDABATE")
QRY_PEDABATE->(dbGoTop())
IF QRY_PEDABATE->(!EOF())
	lRet := .F.
	IF MsgYESNO('Boletim de Abate j� encerrado, Deseja realmente excluir a Nota ?')
		lRet := .T.
	EndIF
EndIF
QRY_PEDABATE->(dbCloseArea())
// Verifica se a esta referenciada de Produtor no Boletim de Abate
IF lRet
	cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("ZZM")+" ZZM, "+RetSQLName("ZZP")+" ZZP "
	cQuery += " WHERE ZZM_FILIAL = ZZP_FILIAL "
	cQuery += "   AND ZZM_PEDIDO = ZZP_PEDIDO "
	cQuery += "   AND ZZM_FORNEC = '" + SF1->F1_FORNECE + "' "
	cQuery += "   AND ZZM_LOJA   = '" + SF1->F1_LOJA + "' "
	cQuery += "   AND ZZP_DOC    = '" + SF1->F1_DOC + "' "
	cQuery += "   AND ZZP_SERIE  = '" + SF1->F1_SERIE + "' "
	cQuery += "   AND ZZM.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZZP.D_E_L_E_T_ = ' ' "
	If Select("QRY_PEDABATE") > 0
		QRY_PEDABATE->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
	dbSelectArea("QRY_PEDABATE")
	QRY_PEDABATE->(dbGoTop())
	IF QRY_PEDABATE->(!EOF())
		MsgAlert('Nota fiscal do Produtor relacionada ao Boletim de Abate ('+Alltrim(QRY_PEDABATE->ZZM_PEDIDO)+'), favor retirar este vinculo !!')
		lRet := .F.
	EndIF
EndIF

Return lRet
**********************************************************************************************************************************************
User Function TAE15ENV

Local aEnvia     := {}
Local nI         := 0
Local cFILNFE    := ''
Local cFILDUPL   := ''
Local bEmite     := .F.
Local cStatus    := ''
Local cNF        := ''

Private _aMatriz   := {"01","010001"}
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"

if lIsBlind
	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])


	If !LockByName("TAE15ENV")
		Conout("JOB j� em Execucao : TAE15ENV" + DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf

	conOut("********************************************************************************************************************"+ CRLF)
	conOut('---------------------- Envio de Notas de ABATE para o Taura' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)

	cFILNFE    := GetMV('MGF_TAE17',.F.,"")
	cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")


	dbSelectArea('ZZM')

	cQuery := " SELECT R_E_C_N_O_ RECZZM , ZZM.* "
	cQuery += " FROM "+RetSQLName("ZZM")+" ZZM"
	cQuery += " WHERE ZZM_ENVIA = 'S' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select("QRY_PEDABATE") > 0
		QRY_PEDABATE->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
	dbSelectArea("QRY_PEDABATE")
	QRY_PEDABATE->(dbGoTop())
	While QRY_PEDABATE->(!EOF())
		bEmite     := IIF(QRY_PEDABATE->ZZM_FILIAL $ cFILDUPL,IIF(QRY_PEDABATE->ZZM_EMITE=='S',.T.,.F.),IIF(QRY_PEDABATE->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
		IF SUBSTR(QRY_PEDABATE->ZZM_PEDIDO,1,1)=='A'
			cQuery := " Select R_E_C_N_O_ RECZZM, a.* "
			cQuery += " From "+RetSqlName("ZZM")+" a "
			cQuery += " Where ZZM_FILIAL = '"+QRY_PEDABATE->ZZM_FILIAL+"'"
			cQuery += "   AND ZZM_AGRUP  = '"+QRY_PEDABATE->ZZM_PEDIDO+"'"
			If Select("QRY_AGR") > 0
				QRY_AGR->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
			dbSelectArea("QRY_AGR")
			QRY_AGR->(dbGoTop())
			While QRY_AGR->(!EOF())
				AAdd(aEnvia,{QRY_PEDABATE->RECZZM,QRY_AGR->ZZM_FILIAL,QRY_AGR->ZZM_PEDIDO,QRY_PEDABATE->ZZM_DOC,QRY_PEDABATE->ZZM_SERIE,bEmite,QRY_PEDABATE->ZZM_STATUS})
				QRY_AGR->(dbSkip())
			End
		Else
			AAdd(aEnvia,{QRY_PEDABATE->RECZZM,QRY_PEDABATE->ZZM_FILIAL,QRY_PEDABATE->ZZM_PEDIDO,QRY_PEDABATE->ZZM_DOC,QRY_PEDABATE->ZZM_SERIE,bEmite,QRY_PEDABATE->ZZM_STATUS})
		EndIF
		QRY_PEDABATE->(dbSkip())
	End
	For nI := 1 To Len(aEnvia) // MGFTAE17(cFilAbate,cNumPed,cStat,cDoc,cSer)
		cStatus    := '1'
		cNF        := ''
		IF  aEnvia[nI,06] //Emite Nota fiscal
		     IF !Empty(aEnvia[nI,04])
		         cNF := aEnvia[nI,04]
		     Else
		         cNF := '0'
		     EndIF
		Else
			cStatus    := '1'
			cNF        := '0'
		EndIF
		IF U_MGFTAE17(aEnvia[nI,02],aEnvia[nI,03],cStatus,cNF,aEnvia[nI,05],bEmite)
			ZZM->(dbGoTo(aEnvia[nI,01]))
			Reclock("ZZM",.F.)
			ZZM->ZZM_ENVIA  := 'N'
			ZZM->(MsUnlock())
		EndIF
	Next nI

	QRY_PEDABATE->(dbCloseArea())

	conOut('---------------------- FIM de Notas de ABATE para o Taura' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)


EndIF

Return
************************************************************************************************************
Static Function Ret_Pedido()

Local cPedido := ''
Local cQuery  := ''

IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)  <> 'A'
    cPedido := SUBSTR(ZZM->ZZM_PEDIDO,1, AT('-',ZZM->ZZM_PEDIDO)-1)
Else
	cQuery := " SELECT ZZM_PEDIDO  "
	cQuery += " FROM   "+RetSqlName("ZZM")
	cQuery += " Where ZZM_FILIAL = '"+ZZM->ZZM_FILIAL+"'"
	cQuery += "   AND ZZM_AGRUP  = '"+ZZM->ZZM_PEDIDO+"'"
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += "   Order by ZZM_PEDIDO "
	If Select("QRY_AGR") > 0
		QRY_AGR->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
	dbSelectArea("QRY_AGR")
	QRY_AGR->(dbGoTop())
	IF QRY_AGR->(!EOF())
	     cPedido := SUBSTR(QRY_AGR->ZZM_PEDIDO,1, AT('-',QRY_AGR->ZZM_PEDIDO)-1)
	End
	QRY_AGR->(dbCloseArea())
EndIF

Return cPedido
*********************************************************************************************************************************************
User Function TAE15_NP

Local abkRotina    := aRotina
Local abkCadastro  := cCadastro
Local nAdian       := 0
Local cNome        := ''
Local nFundec	   := 0

Private cFILNFE   := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
Private cFiltro   := ''
Private nTotNP    := 0
Private nTotNF    := 0
Private cEmissao  := ''
Private aIndexNF   := {}
Private cCadastro := "Boletim de Abate - Nota Promissoria"
Private aRotina   := { {"Incluir"        ,"U_TAE15_INP(3)"  ,0, 3, 0, NIL},;
		               {"Excluir"   	 ,"U_TAE15_INP(4)"  ,0, 5, 0, NIL},;
		               {"Imprime Parcela","U_TAE15_INP(1)"  ,0, 2, 0, NIL},;
		               {"Imprime Todas"	 ,"U_TAE15_INP(2)"  ,0, 2} }
CHKFILE('ZDH')
dbSelectArea("ZDH")
dbSetOrder(1)

SF1->(dbSetOrder(1))
IF bEmite
	IF Empty(ZZM->ZZM_DOC+ZZM->ZZM_SERIE)
		msgAlert('Nota fiscal nao emitida !!')
		Return
	EndIF
	IF SF1->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_DOC+ZZM->ZZM_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
		nFundec := xFUNDEPEC(SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
		IF ZZM->ZZM_ADIAN > 0
			nAdian := ZZM->ZZM_ADIAN
		Else
			IF ZZM->ZZM_DESPEC > 0
				nAdian := ZZM->ZZM_DESPEC
			EndIF
		EndIF
		nTotNF  := SF1->F1_VALBRUT - SF1->F1_CONTSOC - nAdian - nFundec  - SF1->F1_VALFUND - SF1->F1_VLSENAR//- SF1->F1_VALFUND J� descontado no Valor Bruto
		cEmissao  := DTOC(SF1->F1_EMISSAO)
	EndIF
Else
	IF ZZM->ZZM_STATUS == "1" .OR. ZZM->ZZM_STATUS == "2"
		msgAlert('Situacao nao permite emitir NP !!')
		Return
	EndIF
	//IF ZZM->ZZM_ADIAN > 0
	//	IF ZZM->ZZM_ADIAN > 0
	//		nAdian := ZZM->ZZM_ADIAN
	//	Else
	//		IF ZZM->ZZM_DESPEC > 0
	//			nAdian := ZZM->ZZM_DESPEC
	//		EndIF
	//	EndIF
	//EndIF
	nTotNF  := TotalNFC() //- nAdian
	cEmissao  := '  /  /  '
EndIF
cFiltro  += "         ZDH_FILIAL   == '"+ZZM->ZZM_FILIAL+"'"
cFiltro  += "   .AND. ZDH_PEDIDO   == '"+ZZM->ZZM_PEDIDO+"'"

bFiltraBrw  := {|| FilBrowse('ZDH',@aIndexNF,@cFiltro) }
Eval(bFiltraBrw)

ZDH->(dbGoTop())
WHile ZDH->(!EOF())
     nTotNP += ZDH->ZDH_VALOR
     ZDH->(dbSkip())
End
cNome := GetAdvFVal( "SA2", "A2_NOME", xFilial('SA2')+PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1])+;
											     PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]), 1, "" )
cCadastro := "**Nota Promissoria** Fornecedor: "+Alltrim(ZZM->ZZM_FORNEC)+'-'+Alltrim(ZZM->ZZM_LOJA)+' '+Alltrim(cNome)+;
			 "     Nota: "+Alltrim(ZZM->ZZM_DOC)+'-'+Alltrim(ZZM->ZZM_SERIE)+'     Valor R$ '+Alltrim(Transform(nTotNF,'@E 99,999,999.99'))

mBrowse( 6,1,22,75,"ZDH",,,,,,)

EndFilBrw('ZDH',aIndexNF)

aRotina    := abkRotina
cCadastro  := abkCadastro

Return
**************************************************************************************************************************************
User Function TAE15_INP(nAcao)

Local dVencimento := CTOD('  /  /  ')
Local nValor      := 0

Private aParamBox := {}
Private aRet      := {}
Private cTitulo   := "Nota Promissoria Rural"
Private oPrn      := NIL
Private oFonte01  := TFont():New('Verdana',,19,,.T.,,,,,.F.,.F.)
Private oFonte02  := TFont():New('Verdana',,16,,.T.,,,,,.F.,.F.)
Private oFonte03  := TFont():New('Verdana',,15,,.T.,,,,,.F.,.T.)
Private oFonte04  := TFont():New('Arial',,11,,.T.,,,,,.F.,.F.)
Private oFonte05  := TFont():New('Arial',,13,,.T.,,,,,.F.,.F.)
Private oFonte06  := TFont():New('Courier New',,12,,.T.,,,,,.F.,.F.)
Private oFonte07  := TFont():New('Arial',,13,,.F.,,,,,.F.,.F.)
Private oFonte08  := TFont():New('Courier New',,13,,.F.,,,,,.F.,.F.)
Private oFonte09  := TFont():New('Courier New',,14,,.F.,,,,,.F.,.F.)

IF nAcao == 3 // Opcao Incluir
	msgAlert('Saldo R$ '+Alltrim(STR(nTotNF - nTotNP)))
	AAdd(aParamBox, {1, "Vencimento :"	        , dVencimento , "@!", , '',, 070	, .T.	})
	AAdd(aParamBox, {1, "Valor :"               , nValor   , "@E 999,999,999.99", , ,, 070	, .T.	})
	IF ParamBox(aParambox, "Nota Promissoria Fiscal"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
        IF 1==2 //ZDH->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO+DTOS(MV_PAR01)))
             msgAlert('J� existe Parcela nesta Data !!')
             Return
        Else
           IF MV_PAR02+ nTotNP > nTotNF
           		msgAlert('Valor Ultrapassa o valor da NF !! NF = R$ '+Alltrim(STR(nTotNF)))
                Return
           Else
           		RecLock("ZDH",.T.)
				ZDH->ZDH_FILIAL  := ZZM->ZZM_FILIAL
				ZDH->ZDH_PEDIDO  := ZZM->ZZM_PEDIDO
				ZDH->ZDH_DATA    := MV_PAR01
				ZDH->ZDH_VALOR   := MV_PAR02
				ZDH->(MsUnLock())
				msgAlert('Saldo R$ '+Alltrim(STR(nTotNF-(MV_PAR02+ nTotNP))))
				Refaz_Parcela()
           EndIF
        EndIF
    EndIF
    Return
EndIF
IF nAcao == 4 // Opcao Excluir
    IF MsgYESNO('Deseja excluir a Parcela ?')
        Reclock("ZDH",.F.)
		ZDH->(dbDelete())
		ZDH->(MsUnlock())
		Refaz_Parcela()
	EndIF
	Return
EndIF
/*
IF !FILE(GetTempPath()+"MGF_LOGO.bmp")
	IF !CpyS2T("MGF_LOGO.bmp",GetTempPath(),.F.)
	  Alert("Nao foi possivel utilizar o Logo da Marfrig...")
	  Return
	EndIF
EndIF

//MsgAlert(GetSrvProfString("Rootpath","")+GetSrvProfString("Startpath","")+"MGF_LOGO.bmp")
 */
oPrn:=FWMSPrinter():New('MGF_NFP',6,,,.T.,)
oPrn:SetPortrait()
oPrn:SetPaperSize(DMPAPER_A4)


//oPrn := TMSPrinter():New(cTitulo)
//oPrn:Setup()
//oPrn:SetPortrait()
//oPrn:SetPaperSize(DMPAPER_A4)

IF nAcao == 1
	Gera_NFP()
ElseIF nAcao == 2
	ZDH->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO))
	While ZDH->(!EOF()) .AND. ZDH->(ZDH_FILIAL+ZDH_PEDIDO) == ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO
		Gera_NFP()
		ZDH->(dbSkip())
	End
EndIF

oPrn:Preview()

FreeObj(oPrn)
oPrn := Nil

Return
***********************************************************************************************************
Static Function Refaz_Parcela()
Local cParcela := '01'

nTotNP := 0
ZDH->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO))
While ZDH->(!EOF()) .AND. ZDH->(ZDH_FILIAL+ZDH_PEDIDO) == ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO
	RecLock("ZDH",.F.)
	ZDH->ZDH_PARC  := cParcela
	ZDH->(MsUnLock())
	cParcela := SOMA1(cParcela)
	nTotNP += ZDH->ZDH_VALOR
	ZDH->(dbSkip())
End

Return
************************************************************************************************************
STATIC FUNCTION Gera_NFP()
Local nTam      := 0
Local aVExtenso := {}
Local cCGC      := ''
Local aNotas    := {}

Private nLin   := 480


oPrn:StartPage()
//Colocar o Logotipo na system do Protheus_data
//


oPrn:Box(050,0050,0500,2200)
oPrn:Box(060,1400,0490,2190)
//oPrn:SayBitmap(060,060,"MGF_LOGO.bmp",480,420)
oPrn:SayBitmap(060,060,GetSrvProfString("Startpath","") + "LGMID" + ".PNG",420,380)


oPrn:Say(090,550,'CLIENTE GLOBAL FOODS S/A', oFonte01)
//oPrn:Say(080,890,'ALIMENTOS S.A.',oFonte02)

oPrn:Say(180,550,Alltrim(SM0->M0_CODFIL)+" - "+SM0->M0_FILIAL,oFonte09)
oPrn:Say(280,570,SM0->M0_ENDCOB,oFonte08)
oPrn:Say(330,570,ALLTRIM(SM0->M0_CIDENT)+'-'+SM0->M0_ESTENT+'  CEP:'+SM0->M0_CEPENT,oFonte08)
oPrn:Say(380,570,'('+SUBSTR(ALLTRIM(SM0->M0_TEL),1,2)+')'+SUBSTR(SM0->M0_TEL,3,Len(SM0->M0_TEL)),oFonte08)
oPrn:Say(430,570,Transform(Substr('0'+SM0->M0_CGC,1,9),"@R 999.999.999")+"/"+Transform(Substr('0'+SM0->M0_CGC,10,6),"@R 9999-99"),oFonte08)

oPrn:Say(090,1420,'NOTA PROMISS�RIA RURAL' ,oFonte03)
oPrn:Say(190,1440,"N � M E R O :",oFonte07)
oPrn:Say(290,1440,"VENCIMENTO:",oFonte07)
oPrn:Say(390,1440,"VALOR R$:",oFonte07)

IF bEmite
	oPrn:Say(190,1700,ALLTRIM(ZZM->ZZM_DOC)+'/'+ZDH->ZDH_PARC,oFonte08)
Else
    oPrn:Say(190,1700,ALLTRIM(SUBSTR(ZZM->ZZM_PEDIDO,1,6))+'/'+ZDH->ZDH_PARC,oFonte08)
EndIF
oPrn:Say(290,1700,DTOC(ZDH->ZDH_DATA),oFonte08)
oPrn:Say(390,1700,Alltrim(Transform(ZDH->ZDH_VALOR, '@E 999,999,999.99')),oFonte08)

nTam := Ret_Tam("PAGAREI(EMOS) POR ESTA NOTA PROMISS�RIA RURAL, �",oFonte07)+60


nLin +=70
oPrn:Say(nLin,0060,"Ao(S)",oFonte07)
oPrn:Say(nLin,0260,dia_extenso(Day(ZDH->ZDH_DATA)),oFonte08)
oPrn:Say(nLin,nTam - Ret_Tam("DIAS DO M�S DE",oFonte07),"DIAS DO M�S DE",oFonte07)
oPrn:Say(nLin,1120,MesExtenso(ZDH->ZDH_DATA),oFonte08)
oPrn:Say(nLin,1500,"DE",oFonte07)
oPrn:Say(nLin,1600,SubStr(DTOS(ZDH->ZDH_DATA),1,4),oFonte08)
nLin +=70
oPrn:Say(nLin,060,"PAGAREI(EMOS) POR ESTA NOTA PROMISS�RIA RURAL, �",oFonte07)
oPrn:Say(nLin,1120,Alltrim(ZZM->ZZM_FAV) ,oFonte08)
nLin +=70
oPrn:Say(nLin,nTam - Ret_Tam("CNPJ/CPF",oFonte07),"CNPJ/CPF",oFonte07)
cCGC      := GetAdvFVal( "SA2", "A2_CGC", xFilial('SA2')+PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1])+PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]), 1, "" )
oPrn:Say(nLin,1120,Alltrim(cCGC) ,oFonte08)
nLin +=70
oPrn:Say(nLin,060,"OU A SUA ORDEM NA PRA�A DE",oFonte07)
oPrn:Say(nLin,650,ALLTRIM(SM0->M0_CIDENT) ,oFonte08)
nLin +=70
aVExtenso := ConvTexto(ZDH->ZDH_VALOR)
oPrn:Say(nLin,060,"A QUANTIA DE",oFonte07)
oPrn:Say(nLin,060,aVExtenso[01],oFonte08)
nLin +=70
oPrn:Say(nLin,060,aVExtenso[02],oFonte08)
nLin +=70
oPrn:Say(nLin,060,aVExtenso[03],oFonte08)
nLin +=70
oPrn:Say(nLin,060,"PELO VALOR DA COMPRA QUE LHE FIZEMOS DE BOVINOS PARA ABATE CONFORME NOTA(S) FISCAL(IS) DE ENTRADA DE",oFonte07)
nLin +=70
oPrn:Say(nLin,060,"MERCADORIAS N�(S)",oFonte07)
IF bEmite
	oPrn:Say(nLin,420,ZZM->ZZM_DOC+' de '+cEmissao  ,oFonte08)
Else
	aNotas := Ret_Notas()
	For nI := 1 To Len(aNotas)
		oPrn:Say(nLin,420,aNotas[nI]  ,oFonte08)
		nLin+=030
	Next nI
EndIF
nLin +=70
oPrn:Say(nLin,060,"A T E N C A O",oFonte06)
nLin +=50
oPrn:Say(nLin,060,"Para que possamos manter a pontualidade nos pagamentos",oFonte06)
oPrn:Say(nLin,1160,ALLTRIM(SM0->M0_CIDENT)+",",oFonte08)
nLin +=50
oPrn:Say(nLin,060,"Solicitamos informar-nos com 7 dias uteis de antecedencia",oFonte06)
nLin +=50
oPrn:Say(nLin,060,"a forma para efetivar o pagamento.Caso nao tenhamos essa",oFonte06)
oPrn:Say(nLin,1160,SubStr(DTOS(dDataBase),7,2),oFonte08)
oPrn:Say(nLin,1370,MesExtenso(dDataBase)     ,oFonte08)
oPrn:Say(nLin,1780,SubStr(DTOS(dDataBase),1,4),oFonte08)

nLin +=50
oPrn:Say(nLin,060,"informacao sera depositado na conta: "+Alltrim(ZZM->ZZM_CONTA),oFonte06)
oPrn:Say(nLin,1100,"_________ de _______________________ de ___________",oFonte07)
nLin +=50
oPrn:Say(nLin,060,"Banco : "+Alltrim(ZZM->ZZM_BANCO)+" Agencia : "+Alltrim(ZZM->ZZM_AGENCI),oFonte06)
nLin +=200
oPrn:Say(nLin,060,"(ANTECIPA��O DA NPR FAVOR SOLICITAR",oFonte05)
oPrn:Say(nLin,1200,"___________________________________________",oFonte04)
nLin +=70
oPrn:Say(nLin,060,"COM 7(SETE) DIAS DE ANTECED�NCIA)",oFonte05)
oPrn:Say(nLin,1300,"Cliente Global Foods S/A",oFonte04)



oPrn:EndPage()

Return
************************************************************************************************************************************************************
 Static Function  dia_extenso(nDia)
Local cRet := ''

IF nDia == 1

	cRet :=  "UM"
ElseIF nDia == 2
	cRet :=  "DOIS"
ElseIF nDia == 3
	cRet :=  "TRES"
ElseIF nDia == 4
	cRet :=  "QUATRO"
ElseIF nDia == 5
	cRet :=  "CINCO"
ElseIF nDia == 6
	cRet :=  "SEIS"
ElseIF nDia == 7
	cRet :=  "SETE"
ElseIF nDia == 8
	cRet :=  "OITO"
ElseIF nDia == 9
	cRet :=  "NOVE"
ElseIF nDia == 10
	cRet :=  "DEZ"
ElseIF nDia == 11
	cRet :=  "ONZE"
ElseIF nDia == 12
	cRet :=  "DOZE"
ElseIF nDia == 13
	cRet :=  "TREZE"
ElseIF nDia == 14
	cRet :=  "QUATORZE"
ElseIF nDia == 15
	cRet :=  "QUINZE"
ElseIF nDia == 16
	cRet :=  "DEZESSEIS"
ElseIF nDia == 17
	cRet :=  "DEZESSETE"
ElseIF nDia == 18
	cRet :=  "DEZOITO"
ElseIF nDia == 19
	cRet :=  "DEZENOVE"
ElseIF nDia == 20
	cRet :=  "VINTE"
ElseIF nDia == 21
	cRet :=  "VINTE E UM"
ElseIF nDia == 22
	cRet :=  "VINTE E DOIS"
ElseIF nDia == 23
	cRet :=  "VINTE E TRES"
ElseIF nDia == 24
	cRet :=  "VINTE E QUATRO"
ElseIF nDia == 25
	cRet :=  "VINTE E CINCO"
ElseIF nDia == 26
	cRet :=  "VINTE E SEIS"
ElseIF nDia == 27
	cRet :=  "VINTE E SETE"
ElseIF nDia == 28
	cRet :=  "VINTE E OITO"
ElseIF nDia == 29
	cRet :=  "VINTE E NOVE"
ElseIF nDia == 30
	cRet :=  "TRINTA"
ElseIF nDia == 31
	cRet :=  "TRINTA E UM"
EndIF

Return cRet

*************************************************************************************************
Static Function Ret_Tam(cTexto,oFontText)
Local nRet := 0

nRet:= ROUND(oPrn:GetTextWidth(cTexto, oFontText )+10 ,0)

Return nRet
**************************************************************************************************
Static function ConvTexto(nValor)

Local cTexto := Extenso(nValor,0,1)
Local aRet   := {'','',''}
Local nI     := 0
Local bTem   := .T.

cTexto :=  '('+cTexto+' )'

nTam := Len(cTexto)

For nI := 85 To 1 STEP -1
    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem
         bTem   := .F.
         aRet[01] := SUBSTR(cTexto,1,nI-1)
         cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
    EndIF
Next nI

bTem   := .T.
IF nTam <= 85
    aRet[01] := aRet[01] + cTexto
Else
	bTem   := .T.
	For nI := 100 To 1 STEP -1
	    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem
	         bTem   := .F.
	         aRet[02] := SUBSTR(cTexto,1,nI-1)                                     '
	         IF Len(aRet[02]) >= 99
	            cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
	         Else
	            aRet[02] := cTexto
	         EndIF
	    EndIF
	Next nI
	IF nTam > 185
		bTem   := .T.
		For nI := 100 To 1 STEP -1
		    IF SubSTR(cTexto,nI,1) == ' ' .AND. bTem
		         bTem   := .F.
		         aRet[03] := SUBSTR(cTexto,1,nI-1)
		         cTexto   := SUBSTR(cTexto,nI+1,Len(cTexto))
		    EndIF
		Next nI
	EndIF
EndIF
IF Empty(aRet[02])
	aRet[01] := SPACE(15)+PADR(aRet[01],85,'*')
	aRet[02] := Replicate('*',100)
	aRet[03] := Replicate('*',100)
Else
	aRet[01] := SPACE(15)+PADC(aRet[01],85)
	IF Empty(aRet[03])
	   	aRet[02] := PADR(aRet[02],100,'*')
		aRet[03] := Replicate('*',100)
	Else
		aRet[02] := PADC(aRet[02],85)
		aRet[03] := PADR(aRet[03],100,'*')
    EndIF
EndIF

Return aRet


*******************************************************************************************************************************************************
Static Function Ajus_Agrup(aCodAgrup,nTotCab)
Local cPedido := ''
Local cQuery  := ''
Local nDesc   := 0
Local nI      := 0
Local nPos    := 0

cQuery := " SELECT ZZM_PEDIDO, "
cQuery += "         (ZZM_VLACR - ZZM_VLDESC + ZZM_DESPEC	) VALOR ,  "
cQuery += "         ZZN_CODAGR B1_ZCODAGR,  "
cQuery += "         SUM(ZZN_QTCAB + ZZN_QTPE) QCAB ,"
cQuery += "         D.TOTAL TOTAL "
cQuery += " FROM   "+RetSqlName("ZZM")+" A, "+RetSqlName("ZZN")+" B, "+RetSqlName("SB1")+" C, "
cQuery += "         (Select X.ZZN_FILIAL FILZZN, ZZN_PEDIDO PEDZZN, SUM(X.ZZN_QTCAB + X.ZZN_QTPE) TOTAL "
cQuery += "          from "+RetSqlName("ZZN")+" X "
cQuery += "          Where X.D_E_L_E_T_ = ' '                "
cQuery += "            AND X.ZZN_PRODUT < '500000' "
cQuery += "          GROUP BY X.ZZN_FILIAL, X.ZZN_PEDIDO) D "
cQuery += " Where ZZM_FILIAL = '"+ZZM->ZZM_FILIAL+"'"
cQuery += "   AND ZZM_AGRUP  = '"+ZZM->ZZM_PEDIDO+"'"
cQuery += "   AND ZZN_PRODUT < '500000' "
cQuery += "   AND ZZM_FILIAL = ZZN_FILIAL "
cQuery += "   AND ZZM_PEDIDO = ZZN_PEDIDO "
cQuery += "   AND FILZZN     = ZZM_FILIAL"
cQuery += "   AND PEDZZN     = ZZM_PEDIDO"
cQuery += "   AND B1_FILIAL  = '"+xFilial('SB1')+"' "
cQuery += "   AND B1_COD     = ZZN_PRODUT "
cQuery += "   AND A.D_E_L_E_T_ = ' ' "
cQuery += "   AND B.D_E_L_E_T_ = ' ' "
cQuery += "   AND C.D_E_L_E_T_ = ' ' "
cQuery += " Group by ZZM_PEDIDO, (ZZM_VLACR - ZZM_VLDESC  + ZZM_DESPEC	) , ZZN_CODAGR, D.TOTAL "
If Select("QRY_AGR") > 0
	QRY_AGR->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
dbSelectArea("QRY_AGR")
QRY_AGR->(dbGoTop())
While QRY_AGR->(!EOF())
	nPos   := aScan( aCodAgrup, { |x| Alltrim(x[1]) == Alltrim(QRY_AGR->B1_ZCODAGR) })
	IF nPos <> 0
		nDesc := Round((QRY_AGR->VALOR) / QRY_AGR->TOTAL, 6)
		aCodAgrup[nPos,3] +=  (nDesc * QRY_AGR->QCAB)
	EndIF
	QRY_AGR->(dbSkip())
End
QRY_AGR->(dbCloseArea())



Return
**************************************************************************************************************************************
User Function TAE15_TER

Local cNomeFor := ''

Private aParamBox := {}
Private aRet      := {}

SA2->(dbSetOrder(1))

AAdd(aParamBox, {1, "Fornecedor:"       ,Space(tamSx3("A2_FILIAL")[1])        , "@!",,"SA2A" ,, 060	, .T.	})
AAdd(aParamBox, {1, "Loja:"			    ,Space(tamSx3("A2_LOJA")[1])          , "@!",,      ,, 030	, .T.	})
AAdd(aParamBox, {1, "Abatedouro:"       ,Space(tamSx3("A2_FILIAL")[1])        , "@!",,"SA2A" ,, 060	, .T.	})
AAdd(aParamBox, {1, "Loja Abat.:"	    ,Space(tamSx3("A2_LOJA")[1])          , "@!",,      ,, 030	, .T.	})
AAdd(aParamBox, {1, "Romaneio:"      	,Space(20)                            , "@!",,      ,, 070	, .T.	})
AAdd(aParamBox, {1, "Dt.Romaneiro:"	    ,CTOD('  /  /  ')                     , "@!",,      ,, 050	, .T.	})
IF ParamBox(aParambox, "Inclui Abate de Terceiros"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	If SA2->(!dbSeek(xFilial('SA2')+MV_PAR01+MV_PAR02))
		msgAlert('Forncedor nao Cadastrado !!')
		Return
	Else
	    cNomeFor := SA2->A2_NREDUZ
		IF SA2->(!dbSeek(xFilial('SA2')+MV_PAR03+MV_PAR04))
			msgAlert('Abatedouro nao Cadastrado !!')
			Return
		Else
			Reclock("ZZM",.T.)
			ZZM->ZZM_FILIAL := xFilial('ZZM')
			ZZM->ZZM_PEDIDO	:= NumZZM(2)
			ZZM->ZZM_EMISSA	:= dDataBase
			ZZM->ZZM_DTPROD	:= MV_PAR06
			ZZM->ZZM_FORNEC	:= MV_PAR01
			ZZM->ZZM_LOJA  	:= MV_PAR02
			ZZM->ZZM_NOME 	:= cNomeFor
			ZZM->ZZM_STATUS := '1'
			ZZM->ZZM_AGRUP	:= ''
			ZZM->ZZM_NOMEAB := SA2->A2_NREDUZ
			ZZM->ZZM_ROMAN  := MV_PAR05
			ZZM->ZZM_DTROMA := MV_PAR06
			ZZM->ZZM_ABATE  := MV_PAR03
			ZZM->ZZM_ABLOJA := MV_PAR04
			ZZM->(MsUnlock())
		EndIF
	EndIF
EndIF

Return
******************************************************************************************************************************************
User Function TAE15_IT(nTipo)

Local aAux := {}
Local nI   := 0
Private aParamBox := {}
Private aRet      := {}


IF nTipo == 1 // Inclusao
	SB1->(dbSetOrder(1))
	AAdd(aParamBox, {1, "Produto:"          ,Space(tamSx3("B1_COD")[1])       , "@!",  ,"SB1" ,, 060	, .T.	})
	AAdd(aParamBox, {1, "Qtd. Cabecas"	    ,0 , "@E 99,999,999,999,999.99",                           ,      ,, 050	, .T.	})
	AAdd(aParamBox, {1, "Qtd. em KG  "	    ,0 , "@E 99,999,999,999,999.99",                           ,      ,, 050	, .T.	})
	AAdd(aParamBox, {1, "Qtd. Perda  "	    ,0 , "@E 9,999,999 "           ,                           ,      ,, 050	, .F.	})
	AAdd(aParamBox, {1, "Vl Arroba   "	    ,0 , "@E 99,999,999,999,999.99",                           ,      ,, 050	, .T.	})
	AAdd(aParamBox, {1, "Valor Total "	    ,0 , "@E 99,999,999,999,999.99",                           ,      ,, 050	, .T.	})
	IF ParamBox(aParambox, "Inclui Abate de Terceiros"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		IF SB1->(!dbSeek(xFilial('SB1')+MV_PAR01))
			msgAlert('Produto nao cadastrado !!')
			Return
		EndIF
		Reclock("ZZN",.T.)
		ZZN->ZZN_FILIAL := ZZM->ZZM_FILIAL
		ZZN->ZZN_PEDIDO	:= ZZM->ZZM_PEDIDO
		ZZN->ZZN_ITEM   := STRZERO(Len(aCols)+1,2)
		ZZN->ZZN_PRODUT	:= MV_PAR01
		ZZN->ZZN_QTCAB  := MV_PAR02
		ZZN->ZZN_QTKG  	:= MV_PAR03
		ZZN->ZZN_QTPE   := MV_PAR04
		ZZN->ZZN_VLARRO	:= MV_PAR05
		ZZN->ZZN_VLTOT 	:= MV_PAR06
		ZZN->(MsUnlock())
		AAdd( aREG, ZZN->( RecNo() ) )
		AAdd( aREGINC, ZZN->( RecNo() ) )
		AAdd( aCols, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCols[Len(aCols),nI] := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+ZZN->ZZN_PRODUT, 1, "" )
			Else
				aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCols[Len(aCols),Len(aHeader)]   := GetAdvFVal( "SB1", "B1_ZCODAGR", xFilial('SB1')+ZZN->ZZN_PRODUT, 1, "" )
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		oGet:SetArray(aCols,.T.)
		oGet:ForceRefresh()
		//MsNewGetDados(): AddLine(.T.,.F.)
	EndIF
Else
   IF MsgYESNO('Deseja excluir o Item ?')
    	AADD(aREGDEL, aREG[oGet:nAt] )
    	aAux := {}
    	For nI := 1 To Len(aCols)
    		IF nI <> oGet:nAt
    		   AADD(aAux ,aCols[nI])
    		EndIF
    	Next nI
    	aCols := aAux
    	oGet:SetArray(aCols,.T.)
		oGet:ForceRefresh()
   EndIF
EndIF

Return

*****************************************************************************************************************************************************
// carrega o proximo numero disponivel da op
Static Function TAE15CriaSC2

Local cRet	:= ''
Local cSeq	:= ""
Local cQuery

cQuery := "SELECT MAX( C2_SEQUEN ) C2_SEQUEN " + CRLF
cQuery += "FROM "+RetSqlName("SC2")+" SC2 "+CRLF
cQuery += "WHERE SC2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "	AND C2_FILIAL = '"+ QRY_OPAB->ZZE_FILIAL +"' "+CRLF
cQuery += "	AND C2_NUM = '"+Subs(QRY_OPAB->ZZE_GERACA,3,6)+"' "+CRLF
cQuery += "	AND C2_ITEM = '01' "
//cQuery += "	AND C2_PRODUTO = '"+QRY_OPAB->ZZE_CODPA+"' "+CRLF

cQuery	:= ChangeQuery( cQuery )
If Select("QRY_NUMOP") > 0
    QRY_NUMOP->(dbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY_NUMOP', .T., .F. )
If !Empty( QRY_NUMOP->C2_SEQUEN )
	cSeq	:= Soma1( QRY_NUMOP->C2_SEQUEN )
	cRet	:= Subs(QRY_OPAB->ZZE_GERACA,3,6) + "01" + cSeq
Else
	cSeq	:= "001"
	cRet	:=  Subs(QRY_OPAB->ZZE_GERACA,3,6) + "01" + cSeq
EndIf

//QRY_NUMOP->(dbCloseArea())

Return( cRet )
**************************************************************************************************************************************************************
User Function TAE15_MG

Local aAux := {}
Local nI   := 0
Private aParamBox := {}
Private aRet      := {}

IF Dados_Produtor()
   MsgAlert('Existe nota fiscal relacionada, favor tirar o vinculo de todas para fazer a alteracao !!')
   Return
EndIF

SB1->(dbSetOrder(1))
AAdd(aParamBox, {1, "Produto:"          ,Space(tamSx3("B1_COD")[1])       , "@!",  ,"MGFSB1" ,, 060	, .T.	})
IF ParamBox(aParambox, "Modifica codigo Agrupador"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	IF SB1->(!dbSeek(xFilial('SB1')+MV_PAR01))
		msgAlert('Produto nao cadastrado !!')
		Return
	EndIF
	aCols[oGet:nAt,Len(aHeader)]   := SB1->B1_COD
	oGet:SetArray(aCols,.T.)
	oGet:ForceRefresh()
	bAlterou   := .T.
EndIF

Return

******************************************************************************************************************************************************************
User Function TAE15_NFC(bInclui)
Local oBtn
Local oDlg1

Private aNFC      := {}
Private aRecNFC   := {}
Private oListNFC  := {}
Private bEncerrou := .F.

Dados_NFC()

DEFINE MSDIALOG oDlg1 TITLE "Nota fiscal Complementar/Devolucao" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

	@ 007, 005 LISTBOX oListNFC	 Fields HEADER "Doc","Serie","Tipo" SIZE 143,127 OF oDlg1 COLORS 0, 16777215 PIXEL
	oListNFC:SetArray(aNFC)
	oListNFC:nAt := 1
	oListNFC:bLine := { || {aNFC[oListNFC:nAt,1],aNFC[oListNFC:nAt,2],aNFC[oListNFC:nAt,3]}}

	IF bInclui
		oBtn := TButton():New( 137, 005 ,'Incluir'    , oDlg1,{|| Cad_NFC() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 137, 090 ,'Excluir'    , oDlg1,{|| Exc_NFC() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	EndIF

  ACTIVATE MSDIALOG oDlg1 CENTERED

Return
*********************************************************************************************************************************************
Static Function Dados_NFC

Local cQuery := ''

aNFC    :={}
aRecNFC := {}
cQuery := " SELECT ZDU_SERIE,ZDU_DOC,ZDU_TIPO, R_E_C_N_O_ REGATU  "
cQuery += " FROM "+RetSQLName("ZDU")
cQuery += " WHERE ZDU_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZDU_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZDU_DOC "
If Select("QRY_NFC") > 0
	QRY_NFC->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NFC",.T.,.F.)
dbSelectArea("QRY_NFC")
QRY_NFC->(dbGoTop())
While !QRY_NFC->(EOF())
    AADD(aNFC,{QRY_NFC->ZDU_DOC,QRY_NFC->ZDU_SERIE,IIF(QRY_NFC->ZDU_TIPO=='E','COMPL','DEVOL')})
    AADD(aRecNFC,QRY_NFC->REGATU)
    QRY_NFC->(dbSkip())
EndDo

If Len(aNFC) == 0
	AADD(aNFC,{"","",""})
EndIF

Return
*********************************************************************************************************************************************
Static Function Cad_NFC()
Local cNFC      := Space(15)
Local oButton2
Local bSel
Local bCompl    := .F.
Local bContinua := .F.
Static oDLG2

ZDU->(dbSetOrder(1))
IF bEncerrou
    Msgalert('Pedido Encerrado !!')
    Return
EndIF
IF MsgYESNO('Nota fiscal de complemento ?')
	bSel := ConPad1(,,,'TAE_5A') //ConPad1(,,,'TAE_05')
	bCompl := .T.
Else
	bSel := ConPad1(,,,'TAE_6A') //ConPad1(,,,'TAE_06')
EndIF
IF bCompl
	IF bSel
		dbSelectArea('SF1')
		SF1->(DbGoto(val(__cRetorno)))
		IF SF1->(!EOF()) .AND. ;
		SF1->F1_FILIAL   == ZZM->ZZM_FILIAL .AND. ;
		Alltrim(SF1->F1_FORNECE)  == Alltrim(ZZM->ZZM_FORNECE) .AND. ;
		SF1->F1_LOJA     == ZZM->ZZM_LOJA .AND. ;
		SF1->F1_TIPO     =='C'

		bContinua := .T.
		EndIf
	EndIf
/*	IF bSel  .And. SF1->(!EOF()) .AND. ;
		SF1->F1_FILIAL   == ZZM->ZZM_FILIAL .AND. ;
		Alltrim(SF1->F1_FORNECE)  == Alltrim(ZZM->ZZM_FORNECE) .AND. ;
		SF1->F1_LOJA     == ZZM->ZZM_LOJA .AND. ;
		SF1->F1_TIPO     =='C'

		bContinua := .T.
	EndIF
*/
Else
	IF bSel
		dbSelectArea('SF2')
		SF2->(DbGoto(val(__cRetorno)))
		IF SF2->(!EOF()) .AND. ;
		SF2->F2_FILIAL   == ZZM->ZZM_FILIAL .AND. ;
		Alltrim(SF2->F2_CLIENTE)  == Alltrim(ZZM->ZZM_FORNECE) .AND. ;
		SF2->F2_LOJA     == ZZM->ZZM_LOJA .AND. ;
		SF2->F2_TIPO     =='D'

		bContinua := .T.
		EndIf
	EndIf
/* 	IF bSel  .And. SF2->(!EOF()) .AND. ;
		SF2->F2_FILIAL   == ZZM->ZZM_FILIAL .AND. ;
		Alltrim(SF2->F2_CLIENTE)  == Alltrim(ZZM->ZZM_FORNECE) .AND. ;
		SF2->F2_LOJA     == ZZM->ZZM_LOJA .AND. ;
		SF2->F2_TIPO     =='D'
		bContinua := .T.
	EndIF
*/
EndIF
IF bContinua
   ZDU->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_PEDIDO))
   While ZDU->(!Eof()) .AND.;
		 ZDU->ZDU_FILIAL == ZZM->ZZM_FILIAL .AND. ;
		 ZDU->ZDU_PEDIDO == ZZM->ZZM_PEDIDO
      IF ZDU->ZDU_DOC    == IIF(bCompl ,SF1->F1_DOC  ,SF2->F2_DOC) .AND. ;
		 ZDU->ZDU_SERIE  == IIF(bCompl ,SF1->F1_SERIE,SF2->F2_SERIE).AND. ;
		 ZDU->ZDU_TIPO   == IIF(bCompl ,'E','S')
      	 MsgAlert('Nota j� incluida !!')
      	 bContinua := .F.
      EndIF
      ZDU->(dbSkip())
   End
EndIF
IF bContinua
	Reclock("ZDU",.T.)
	ZDU->ZDU_FILIAL := ZZM->ZZM_FILIAL
	ZDU->ZDU_PEDIDO	:= ZZM->ZZM_PEDIDO
	ZDU->ZDU_DOC    := IIF(bCompl ,SF1->F1_DOC  ,SF2->F2_DOC)
	ZDU->ZDU_SERIE  := IIF(bCompl ,SF1->F1_SERIE,SF2->F2_SERIE)
	ZDU->ZDU_TIPO   := IIF(bCompl ,'E','S')
	ZDU->(MsUnlock())
	Dados_NFC()
	oListNFC:SetArray(aNFC)
	oListNFC:nAt := 1
	oListNFC:bLine := { || {aNFC[oListNFC:nAt,1],aNFC[oListNFC:nAt,2],aNFC[oListNFC:nAt,3]}}
	oListNFC:Refresh()
    IF MsgYESNO('Deseja Encerrar o Boletim de Abate ?')
        Reclock("ZZM",.F.)
        ZZM->ZZM_STATUS := '5'
        ZZM->(MsUnlock())
        bEncerrou := .T.
	EndIF
EndIF

Return

*********************************************************************************************************************************************
Static Function Exc_NFC()

IF bEncerrou
    Msgalert('Pedido Encerrado !!')
    Return
EndIF

IF Len(aRecNFC)<> 0
	IF MsgYESNO('Exclui o relacionamento da Nota fiscal Complementar ?')
		ZDU->(dbGoTo(aRecNFC[oListNFC:nAt]))
		Reclock("ZDU",.F.)
		ZDU->(dbDelete())
		ZDU->(MsUnlock())
		Dados_NFC()
		oListNFC:SetArray(aNFC)
		oListNFC:nAt := 1
		oListNFC:bLine := { || {aNFC[oListNFC:nAt,1],aNFC[oListNFC:nAt,2],aNFC[oListNFC:nAt,3]}}
		oListNFC:Refresh()
	EndIF
EndIF

Return
*************************************************************************************************************************************************
Static Function TotalNFC
Local cQuery := ''
Local nTotal := 0

cQuery := " SELECT  SUM(F1_VALBRUT - F1_CONTSOC - F1_VALFUND - F1_VLSENAR ) TOTAL" // * - F1_VALFUND, J� Retirado no valor Bruto
cQuery += " FROM "+RetSQLName("ZDU")+" A, "+RetSQLName("SF1")+" B"
cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
cQuery += "   AND B.D_E_L_E_T_ = ' ' "
cQuery += "   AND F1_FILIAL  = ZDU_FILIAL "
cQuery += "   AND F1_DOC     = ZDU_DOC"
cQuery += "   AND ZDU_TIPO   ='E' "
cQuery += "   AND F1_SERIE   = ZDU_SERIE "
cQuery += "   AND F1_FORNECE = '" + Alltrim(ZZM->ZZM_FORNEC) + "' "
cQuery += "   AND F1_LOJA    = '" + ZZM->ZZM_LOJA + "' "
cQuery += "   AND ZDU_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZDU_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
If Select("QRYZDU") > 0
	QRYZDU->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZDU",.T.,.F.)
dbSelectArea("QRYZDU")
QRYZDU->(dbGoTop())
IF !QRYZDU->(EOF())
     nTotal :=  QRYZDU->TOTAL
EndIF


cQuery := " SELECT  SUM(F2_VALBRUT - F2_CONTSOC - F2_VLSENAR ) TOTAL" // * - F1_VALFUND, J� Retirado no valor Bruto
cQuery += " FROM "+RetSQLName("ZDU")+" A, "+RetSQLName("SF2")+" B"
cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
cQuery += "   AND B.D_E_L_E_T_ = ' ' "
cQuery += "   AND F2_FILIAL  = ZDU_FILIAL "
cQuery += "   AND F2_DOC     = ZDU_DOC"
cQuery += "   AND ZDU_TIPO   ='S' "
cQuery += "   AND F2_SERIE   = ZDU_SERIE "
cQuery += "   AND F2_CLIENTE = '" + Alltrim(ZZM->ZZM_FORNEC) + "' "
cQuery += "   AND F2_LOJA    = '" + ZZM->ZZM_LOJA + "' "
cQuery += "   AND ZDU_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZDU_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
If Select("QRYZDU") > 0
	QRYZDU->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZDU",.T.,.F.)
dbSelectArea("QRYZDU")
QRYZDU->(dbGoTop())
IF !QRYZDU->(EOF())
     nTotal -=  QRYZDU->TOTAL
EndIF


cQuery := " SELECT SUM(ZZP_QTD *ZZP_VALOR) VALOR_ZZP  "
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
IF  !QRY_ZZP->(EOF())
   nTotal   += QRY_ZZP->VALOR_ZZP
EndIF

//nTotal += xFunD2(ZZM->ZZM_FILIAL,ZZM->ZZM_PEDIDO,Alltrim(ZZM->ZZM_FORNEC),ZZM->ZZM_LOJA)

nTotal -= U_TAE15_IM()

Return nTotal
*************************************************************************************************************************************************
User Function TAE15PRECOCE

Local cQuery := ''
Local xTexto := ''
Local cMapa  := ''
Local aRet   := {}

dbSelectArea('ZZO')
ZZO->(dbSetOrder(1))

cQuery := " SELECT *  "
cQuery += " FROM "+RetSQLName("ZZM")
cQuery += " WHERE ZZM_FILIAL = '" + SF1->F1_FILIAL + "' "
cQuery += "   AND ZZM_FORNEC = '" + SF1->F1_FORNECE + "' "
cQuery += "   AND ZZM_LOJA   = '" + SF1->F1_LOJA + "' "
cQuery += "   AND ZZM_DOC    = '" + SF1->F1_DOC + "' "
cQuery += "   AND ZZM_SERIE  = '" + SF1->F1_SERIE + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_PEDABATE") > 0
	QRY_PEDABATE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PEDABATE",.T.,.F.)
dbSelectArea("QRY_PEDABATE")
QRY_PEDABATE->(dbGoTop())
IF QRY_PEDABATE->(!EOF())
     //Verifica se tem MAPA PRECOCE
	 ZZO->(dbSeek( QRY_PEDABATE->ZZM_FILIAL+QRY_PEDABATE->ZZM_PEDIDO ))
	 While ZZO->(!EOF()) .And. ZZO->ZZO_FILIAL + ZZO->ZZO_PEDIDO == QRY_PEDABATE->ZZM_FILIAL+ QRY_PEDABATE->ZZM_PEDIDO
		IF ZZO->ZZO_MAPA <> '' .AND. ZZO->ZZO_MAPA <> '0'
		   cMapa  += Alltrim(ZZO->ZZO_MAPA)+' '
		EndIF
		ZZO->(dbSkip())
      Enddo
	  IF !Empty(cMapa)
           aRet   := {{"Precoce_MS",cMapa}}
      EndIF
EndIF
QRY_PEDABATE->(dbCloseArea())

Return aRet

Static Function xFUNDEPEC(cxFil,cDoc,cSerie,cFornec,cLoja)

	Local aArea	:= GetArea()

	Local cNextAlias 	:= GetNextAlias()
	Local nRet 	  := 0

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT D1_VALIMPF
		FROM %Table:SD1% D1
    WHERE
	    D1.%NotDel% AND
	    D1.D1_FILIAL = %Exp:cxFil% AND
	    D1.D1_DOC = %Exp:cDoc% AND
	    D1.D1_SERIE = %Exp:cSerie% AND
	    D1.D1_FORNECE = %Exp:cFornec% AND
	    D1.D1_LOJA = %Exp:cLoja%

	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		nRet += (cNextAlias)->D1_VALIMPF
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aArea)

return nRet

Static Function xFunD2(cxFil,cPedido,cFornec,cLoja)

	Local aArea	:= GetArea()

	Local cNextAlias 	:= GetNextAlias()
	Local nRet 	  := 0

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
			DISTINCT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA
		FROM
			%Table:ZDU% A, %Table:SF1% B
		WHERE A.%NotDel%
		  AND B.%NotDel%
		  AND F1_FILIAL  = ZDU_FILIAL
		  AND F1_DOC     = ZDU_DOC
		  AND F1_SERIE   = ZDU_SERIE
		  AND F1_FORNECE = %Exp:cFornec%
		  AND F1_LOJA    = %Exp:cLoja%
		  AND ZDU_FILIAL = %Exp:cxFil%
		  AND ZDU_PEDIDO = %Exp:cPedido%
		  AND ZDU_FILIAL = 'E'

	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		nRet += xFUNDEPEC((cNextAlias)->F1_FILIAL,(cNextAlias)->F1_DOC,(cNextAlias)->F1_SERIE,(cNextAlias)->F1_FORNECE,(cNextAlias)->F1_LOJA)
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aArea)

return nRet

*********************************************************************************************************************************************
Static Function Ret_Notas

Local cQuery := ''
Local bRet   := .T.
Local cNotas := ''
Local nCont  := 0
Local aRet   := {}

cQuery := " SELECT ZZP_DOC, ZZP_SERIE"
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZP_DOC"
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
While !QRY_ZZP->(EOF())
    cNotas += ' '+Alltrim(QRY_ZZP->ZZP_DOC)+'/'+Alltrim(QRY_ZZP->ZZP_SERIE)
    nCont++
    QRY_ZZP->(dbSkip())
    IF nCont == 7 .OR. QRY_ZZP->(EOF())
       AAdd(aRet,cNotas)
       IF nCont == 7
       		nCont  := 0
       EndIF
       cNotas := ''
    EndIF
EndDo

cQuery := " Select * "
cQuery += " From  "+RetSqlName("ZDU")
cQuery += " Where ZDU_FILIAL = '"+ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZDU_PEDIDO = '"+ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += "   AND ZDU_TIPO = 'E' "
cQuery += "   ORDER BY ZDU_TIPO,ZDU_DOC "
If Select("QRY_ZDU") > 0
	QRY_ZDU->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCOtNN",TcGenQry(,,cQuery),"QRY_ZDU",.T.,.F.)
dbSelectArea("QRY_ZDU")
QRY_ZDU->(dbGoTop())
While !QRY_ZDU->(EOF())
    cNotas += ' '+Alltrim(QRY_ZDU->ZDU_DOC)+'/'+Alltrim(QRY_ZDU->ZDU_SERIE)
    nCont++
    QRY_ZDU->(dbSkip())
    IF nCont == 7 .OR. QRY_ZDU->(EOF())
       AAdd(aRet,cNotas)
       nCont  := 0
       cNotas := ''
    EndIF
EndDo


Return aRet
*********************************************************************************************************************************************
User Function TAE15_IM

Local cQuery   := ''
Local bRet     := .T.
Local nImposto := 0
Local nPorc    := 0

cQuery := " SELECT * "
cQuery += " FROM "+RetSQLName("ZZP")
cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZP_DOC"
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
While !QRY_ZZP->(EOF())
    cQuery := " Select F1_CONTSOC + F1_VLSENAR + F1_VALFUND IMPOSTO, SUM(D1_TOTAL) TOTAL "
	cQuery += " from  "+RetSQLName("SF1") +" A , "+RetSQLName("SD1") +" B "
	cQuery += " Where A.D_E_L_E_T_ = ' ' "
	cQuery += "   AND B.D_E_L_E_T_ = ' ' "
	cQuery += "   AND F1_DOC       = D1_DOC "
	cQuery += "   AND F1_SERIE     = D1_SERIE "
	cQuery += "   AND F1_FORNECE   = D1_FORNECE "
	cQuery += "   AND F1_LOJA      = D1_LOJA "
	cQuery += "   AND F1_FILIAL	   = '"+ZZM->ZZM_FILIAL+"' "
	cQuery += "   AND F1_FORNECE   = '"+ZZM->ZZM_FORNEC+"' "
	cQuery += "   AND F1_LOJA      = '"+ZZM->ZZM_LOJA+"' "
	cQuery += "   AND F1_DOC       = '"+Alltrim(QRY_ZZP->ZZP_DOC)+"' "
	cQuery += "   AND F1_SERIE     = '"+Alltrim(QRY_ZZP->ZZP_SERIE)+"' 	"
	cQuery += " Group by F1_CONTSOC,F1_VLSENAR, F1_VALFUND "
	If Select("QRY_F1") > 0
		QRY_F1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_F1",.T.,.F.)
	dbSelectArea("QRY_F1")
	QRY_F1->(dbGoTop())
	IF !QRY_F1->(EOF())
	      nPorc    :=  ((QRY_ZZP->ZZP_VALOR * QRY_ZZP->ZZP_QTD) /   QRY_F1->TOTAL )
	      nImposto +=  (QRY_F1->IMPOSTO * nPorc)
	EndIF
    QRY_ZZP->(dbSkip())
EndDo

Return nImposto
***********************************************************************************************************************************************
Static Function Can_Mov_OP
Local aArea		:= GetArea()
Local aAreaSD3	:= SD3->(GetArea())
Local aErro     := {}
Local cErro     := ""
Local cQuery    := ''
Local bContinua := .T.
Local bkFil     := cFilAnt
Local aDados    := {}
Local aCab      := {}
Local nI        := 0
Local nL        := 0
Local nPos      := 0
Local aAux      := {}
Private cFILNFE    := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL   := GetMV('MGF_TAE15A',.F.,"")
Private bEmite     := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.))
Private aAgrup     := {}

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.
Private lA185BxEmp      := .F.
Private l241Auto        := .T.

dbSelectArea("SD3")
SD3->(dbSetOrder(0))

dbSelectArea('SC2')
SC2->(dbSetOrder(1))

cQuery := " SELECT  D3_ZPEDLOT, D3_TM,	D3_COD,	D3_OP,	D3_DOC	,D3_NUMSEQ , R_E_C_N_O_ RECD3 "
cQuery += " FROM "+RetSQLName("SD3")
cQuery += " WHERE D3_FILIAL  = '" + ZZM->ZZM_FILIAL + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += "   AND D3_ESTORNO <> 'S' "
cQuery += "   AND D3_ZPEDLOT = '"+ZZM->ZZM_PEDIDO+"'"
cQuery += "   AND D3_ZORIGEM = 'ABATE'   "
//cQuery += " Order by D3_TM desc "
cQuery += " Order by R_E_C_N_O_ desc "
If Select("QRY_MOVD3") > 0
	QRY_MOVD3->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_MOVD3",.T.,.F.)
dbSelectArea("QRY_MOVD3")
QRY_MOVD3->(dbGoTop())
IF QRY_MOVD3->(EOF())
     MsgAlert('Nao h� movimentos para estorno !!')
     Return
EndIF

dbSelectArea('SD3')
SD3->(dbSetOrder(1))
BEGIN TRANSACTION
	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))

	While QRY_MOVD3->(!EOF())
		nPos := aScan( aAgrup, { |x| x[1] == QRY_MOVD3->D3_DOC/*+QRY_MOVD3->D3_NUMSEQ*/ })
		IF nPos == 0
			AAdd(aAgrup,{QRY_MOVD3->D3_DOC/*+QRY_MOVD3->D3_NUMSEQ*/, {{QRY_MOVD3->D3_OP,.F.}},{{QRY_MOVD3->D3_COD,.F.}},QRY_MOVD3->D3_DOC,QRY_MOVD3->D3_NUMSEQ,QRY_MOVD3->D3_TM, {QRY_MOVD3->RECD3} })
		Else
		    aAux := aAgrup[nPos,2]
		    AAdd(aAux,{QRY_MOVD3->D3_OP,.F.})
		    aAgrup[nPos,2] := aAux

		    aAux := aAgrup[nPos,3]
		    AAdd(aAux,{QRY_MOVD3->D3_COD,.F.})
		    aAgrup[nPos,3] := aAux

		    aAux := aAgrup[nPos,7]
		    AAdd(aAux,QRY_MOVD3->RECD3)
		    aAgrup[nPos,7] := aAux

		EndIF
		QRY_MOVD3->(dbSkip())
	End
	cFilAnt := ZZM->ZZM_FILIAL
	For nI := 1 To Len(aAgrup)
		SD3->(dbGoTo(aAgrup[nI,7,1]))
		Lib_OPSB1(1,nI)
		If aAgrup[nI,6] < '500'
			aDados	:= 	{	{"D3_FILIAL"	, ZZM->ZZM_FILIAL	, Nil},;
							{"D3_DOC"		, aAgrup[nI,4]	, Nil},;
							{"D3_NUMSEQ"	, aAgrup[nI,5]	, Nil},;
							{"INDEX" 		, 8					, Nil}	}

			msExecAuto({|x,Y| Mata250(x,Y)},aDados,5)
		Else
			SD3->(dbGoTo(aAgrup[nI,7,1]))
			aCab    := { {'D3_FILIAL'  ,ZZM->ZZM_FILIAL     ,NIL},;
				         {'D3_TM'      ,aAgrup[nI,6]      ,NIL},;
				 	     {"D3_DOC"	   , aAgrup[nI,4]	, Nil} }
			aDados	:= {}
			For nC := 1 To  Len(aAgrup[nI,7])
				SD3->(dbGoto(aAgrup[nI,7,nC]))
				AAdd(aDados	,{ {"D3_NUMSEQ"	,SD3->D3_NUMSEQ, Nil},;
				               {'D3_COD'    ,SD3->D3_COD,NIL},;
						 	   {'D3_UM'     ,SD3->D3_UM ,NIL},;
						 	   {'D3_QUANT'  ,SD3->D3_QUANT ,NIL},;
						 	   {'D3_OP'     ,SD3->D3_OP ,NIL},;
						 	   {"D3_ESTORNO"  , 'S'        , NIL}})
			Next nC

         //aadd(aItem, {"D3_QUANT"    , ESTSAIDA->Qty         , NIL})
         //aadd(aItem, {"D3_LOCAL"    , ESTSAIDA->D3LOCAL        , NIL})

			msExecAuto({|x,Y,z| Mata241(x,Y,z)},aCab,aDados,6)
		EndIf
		Lib_OPSB1(2,nI)
		IF lMsErroAuto
			DisarmTransaction()
			aErro := GetAutoGRLog()
			cErro := ""
			For nL := 1 to Len(aErro)
				cErro += aErro[nL] + CRLF
			Next nL
			msgStop(cErro)
			bContinua   := .F.
		EndIF
	Next nI
END TRANSACTION

	If bContinua
		Reclock("ZZM",.F.)
		IF bEmite
			ZZM->ZZM_STATUS := '4'
        Else
        	ZZM->ZZM_STATUS := '3'
        EndIF
		ZZM->(MsUnlock())
		MsgAlert('Cancelamento da efetiva��o realizada com sucesso !')
	EndIF

cFilAnt := bkFil

RestArea(aAreaSD3)
RestArea(aArea)

Return
******************************************************************************************************************************************
Static Function Lib_OPSB1(nTipo,nPos)
Local nC  := 0

SC2->( dbSetOrder(1) )
IF nTipo == 1
     For nC := 1 To Len(aAgrup[nPos,2])
		SC2->( dbSeek( ZZM->ZZM_FILIAL+aAgrup[nPos,2][nC,1]+aAgrup[nPos,3][nC,1]) )
		SB1->( dbSeek( xFilial("SB1")+aAgrup[nPos,3][nC,1] ) )
		If SB1->B1_MSBLQL == '1'
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '2'
			SB1->( msUnlock() )
			aAgrup[nPos,3][nC,2] := .T.
		EndIf
		If !Empty(SC2->C2_DATRF)
			RecLock("SC2",.F.)
			SC2->C2_DATRF	:= CTOD("")
			SC2->( msUnlock() )
			aAgrup[nPos,2][nC,2] := .T.
		EndIf
      Next NC
ElseIF nTipo == 2
	For nC := 1 To Len(aAgrup[nPos,2])
		SC2->( dbSeek( ZZM->ZZM_FILIAL+aAgrup[nPos,2][nC,1]+aAgrup[nPos,3][nC,1]) )
		SB1->( dbSeek( xFilial("SB1")+aAgrup[nPos,3][nC,1] ) )
		If aAgrup[nPos,3][nC,2]
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL	:= '1'
			SB1->( msUnlock() )
		EndIf
		If aAgrup[nPos,2][nC,2]
			RecLock("SC2",.F.)
			SC2->C2_DATRF	:= CTOD("")
			SC2->( msUnlock() )
		EndIf
      Next NC
EndIF

Return


User Function zTAE_05()

lOk := u_zConsSQL("SELECT DISTINCT F1_FILIAL,F1_FORNECE, F1_LOJA, F1_DOC,F1_SERIE, SF1.R_E_C_N_O_ SF1RECNO FROM "+RetSqlName("SF1")+" SF1 INNER JOIN "+RetSqlName("ZZM")+" ZZM ON ZZM_FILIAL = F1_FILIAL AND ZZM_FORNEC = F1_FORNECE AND ZZM_LOJA = F1_LOJA AND ZZM.D_E_L_E_T_ = ' ' WHERE 1=1 AND F1_FILIAL ='"+XFILIAL("SF1")+"' AND F1_STATUS<>' ' AND F1_TIPO='C' AND F1_FORNECE = '"+ZZM->ZZM_FORNEC+"' AND F1_LOJA = '"+ZZM->ZZM_LOJA+"' AND SF1.D_E_L_E_T_ = ' '", "SF1RECNO", "", "")

Return lOk

User Function zTAE_06()

lOk := u_zConsSQL("SELECT DISTINCT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, SF2.R_E_C_N_O_ SF2RECNO FROM " + RetSqlName("SF2") + " SF2 INNER JOIN " + RetSqlName("ZZM") + " ZZM ON ZZM_FILIAL = F2_FILIAL AND ZZM_FORNEC = F2_CLIENTE AND ZZM_LOJA = F2_LOJA AND ZZM.D_E_L_E_T_ = ' ' WHERE 1=1 AND F2_FILIAL ='"+XFILIAL("SF2")+"' AND F2_TIPO='D' AND F2_CLIENTE = '"+ZZM->ZZM_FORNEC+"' AND F2_LOJA = '"+ZZM->ZZM_LOJA+"' AND SF2.D_E_L_E_T_ = ' '" , "SF2RECNO", "", "")'

Return(lOk)