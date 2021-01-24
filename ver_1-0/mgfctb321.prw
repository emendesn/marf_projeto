#include 'protheus.ch'
#include 'parmtype.ch'
#define CRLF Chr(13)+Chr(10)

user function MGFCTB232()

Local aArea 	:= GetArea()
Local aAreaGW3	:= GW3->(GetArea())
Local aAreaGWF	:= GWF->(GetArea())
Local aAreaZD2	:= ZD2->(GetArea())

Local cQuery 	:= ""
Local cDocfre 	:= GW3->GW3_NRDF // Número do documento
Local cSerFre 	:= GW3->GW3_SERDF // Série do documento
Local cProduto  := ""
Local cQuerZD2  := ""
Local lRet 		:= .F.
Local cCFOP 	:= ""
Local aZD2		:= {}
Local lOcor		:= .F.
//Local cEstadMI  := GETMV('MGF_ESTAMI')
//Local cEstadME  := GETMV('MGF_ESTAME')
//Local cEstadImp := GETMV('MGF_ESTIMP')
Local cTpOcor	:= ""
Local cTpDoc := IIF(GW3->GW3_SITFIS=="6","NFE","NFS")

Public cNaturx  := ""
Public cProdutx := ""
Public cClassex := ""
Public cOperx   := ""
Public cPagtox  := "" //Condição de pagamento do Fornecedor
Public cCCx		:= ""
Public cItemx	:= ""
Public cContaX  := ""
Public cTesx	:= ""
Public cTpopx	:= ""

/// Verifica se é um documento de uma ocorrência.
DbSelectArea('GWF')
GWF->(DbSetOrder(6))//GWF_FILIAL+GWF_CDESP+GWF_EMISDF+GWF_SERDF+GWF_NRDF+DTOS(GWF_DTEMDF)
If GWF->(Msseek( xFilial('GWF') + GW3->GW3_CDESP + GW3->GW3_EMISDF + GW3->GW3_SERDF + GW3->GW3_NRDF))
	
	If !Empty(GWF->GWF_NROCO)
		
		DbSelectArea('GWD')
		GWD->(DbSetorder(1))//GWD_FILIAL+GWD_NROCO
		If GWD->(Msseek(Xfilial('GWD') + GWF->GWF_NROCO ))
			
			lOcor := .T.
			
		EndIf
	EndIf
EndIf
///QUERY QUE TRARA TODOS OS DADOS DO MOVIMENTO
cDados := GetNextAlias()

cQuery := " SELECT DISTINCT A2_ZCONDPG, GW8_CDTPDC, GU3_NATUR FROM "+CRLF
//cQuery := " SELECT GW3_FILIAL, A2_COD, A2_LOJA, GW8_CDTPDC, GW8_CFOP, B1_GRUPO, A1_TIPO, B1_COD, GW3_CDESP  FROM "
cQUERY +=  RetSqlName("GW3")+" GW3 " + " ," + RetSqlName("GW4") + " GW4" + " ," + RetSqlName("SX5") + " SX5"+ " ," + RetSqlName("GW8") + " GW8"+ " ," + RetSqlName("SB1") + " SB1"+ " ,"+CRLF
cQuery +=  + RetSqlName("GW1")+" GW1 " + " ," + RetSqlName("GU3") + " GU3"+ " ," +  RetSqlName("SA2") + " SA2"+CRLF

cQuery += " WHERE GW3_FILIAL ='" + XFILIAL("GW3") +"'"+CRLF
cQuery += " AND GW3_FILIAL = GW4_FILIAL"+CRLF
cQuery += " AND GW3_NRDF = GW4_NRDF"+CRLF
cQuery += " AND GW3_SERDF = GW4_SERDF"+CRLF
cQuery += " AND GW3_EMISDF = GW4_EMISDF"+CRLF
cQuery += " AND GW4_TPDC = '"+cTpDoc+"' " +CRLF

cQuery += " AND GW3_NRDF ='" + cDocfre +"'"+CRLF
cQuery += " AND GW3_SERDF ='" + cSerFre +"'"+CRLF
cQuery += " AND GW3_EMISDF ='" + GW3->GW3_EMISDF +"'"+CRLF
cQuery += " AND GW8_CFOP = X5_CHAVE"+CRLF
cQuery += " AND X5_TABELA = '13'"+CRLF

cQuery += " AND GW8_FILIAL = GW3_FILIAL "+CRLF
cQuery += " AND GW4_NRDC = GW8_NRDC "+CRLF
cQuery += " AND GW4_SERDC = GW8_SERDC "+CRLF
cQuery += " AND GW8_ITEM = B1_COD "+CRLF
cQuery += " AND GW1_FILIAL = GW8_FILIAL "+CRLF
cQuery += " AND GW1_NRDC = GW8_NRDC "+CRLF
cQuery += " AND GW1_SERDC = GW8_SERDC "+CRLF
cQuery += " AND GW1_CDDEST = GU3_CDEMIT "+CRLF
cQuery += " AND GW3_EMISDF = A2_CGC "+CRLF
cQuery += " AND GW1_EMISDC = GW8_EMISDC "+CRLF
cQuery += " AND GW4_TPDC  = GW8_CDTPDC "+CRLF

cQuery += " AND SA2.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND GW3.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND GW4.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND SX5.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND GW8.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND SB1.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND GW1.D_E_L_E_T_ <>'*' "+CRLF
cQuery += " AND GU3.D_E_L_E_T_ <>'*' "+CRLF
//cQuery += " AND SA1.D_E_L_E_T_ <>'*' "

memowrite("c:\temp\MGFCTB321.TXT", cQuery  )
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cDados, .F., .T.)

cPagtox  := (cDados)->A2_ZCONDPG

dBselectArea("ZD2")
//WHILE (cDados)->(!eof()) .AND. lRet = .F.

DbGotop("ZD2")
ZD2->(DbSetOrder(1))//ZD2_FILIAL+ZD2_TPDOC
ZD2->(Msseek(xFilial('GW3')))

If !lOcor
	While ZD2->(!eof()) .AND. ZD2->ZD2_FILIAL = xFilial("GW3")
		
		AADD(aZD2,{ZD2->ZD2_FILIAL, ZD2->ZD2_PRIORI, ZD2->ZD2_NTFIM, ZD2->ZD2_PROD, ZD2->ZD2_CLASS, ZD2->ZD2_CONDPG, ZD2->ZD2_CC, ZD2->ZD2_ITEMC, ZD2->ZD2_CONTA, ZD2->ZD2_TES, ZD2->ZD2_TPOP, ZD2->ZD2_CFOP, ZD2->ZD2_GRUPO, ZD2->ZD2_PRODUT, ZD2->ZD2_TPDOCF, ZD2->ZD2_TPPED, ZD2->ZD2_GRPTRB, ZD2->ZD2_TPOCO, ZD2->ZD2_TPDOC})
		
		ZD2->(dbskip())
	Enddo
Else
	While ZD2->(!eof()) .AND. ZD2->ZD2_FILIAL = xFilial("GW3")
		
		IF !EMPTY(ZD2->ZD2_TPOCO)
			
			AADD(aZD2,{ZD2->ZD2_FILIAL, ZD2->ZD2_PRIORI, ZD2->ZD2_NTFIM, ZD2->ZD2_PROD, ZD2->ZD2_CLASS, ZD2->ZD2_CONDPG, ZD2->ZD2_CC, ZD2->ZD2_ITEMC, ZD2->ZD2_CONTA, ZD2->ZD2_TES, ZD2->ZD2_TPOP, ZD2->ZD2_CFOP, ZD2->ZD2_GRUPO, ZD2->ZD2_PRODUT, ZD2->ZD2_TPDOCF, ZD2->ZD2_TPPED, ZD2->ZD2_GRPTRB, ZD2->ZD2_TPOCO, ZD2->ZD2_TPDOC})
			
		EndIf
		ZD2->(dbskip())
	Enddo
EndIf
Asort(aZD2,,,{|x,y|x[2] < y[2]})

For nI := 1 to len(aZD2) //.and. lRet == .F.
	If (cTpDoc == "NFE" .and. aZD2[nI][18] == "2") .or. (cTpDoc == "NFS" .and. aZD2[nI][18] == "1")
		Loop
	Endif
	
	cQuerZD2 := GetNextAlias()
	
	cQueryZD2 := " SELECT ZD2_FILIAL, ZD2_PRIORI, ZD2_NTFIM, ZD2_PROD, ZD2_CLASS, ZD2_CONDPG, ZD2_CC, ZD2_ITEMC, ZD2_CONTA, ZD2_TES, ZD2_TPOP FROM "+CRLF
	
	cQueryZD2 +=  RetSqlName("GW3")+" GW3 "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GW4")+" GW4 " + "ON " + "GW4.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW3_FILIAL = GW4_FILIAL "+CRLF
	cQueryZD2 +=  " AND GW3_NRDF = GW4_NRDF "+CRLF
	cQueryZD2 +=  " AND GW3_SERDF = GW4_SERDF "+CRLF
	cQueryZD2 +=  " AND GW3_EMISDF = GW4_EMISDF "+CRLF
	cQueryZD2 +=  " AND GW4_TPDC = '"+cTpDoc+"' " +CRLF
	cQueryZD2 +=  " AND GW3_CDESP = GW4_CDESP " +CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GW8")+" GW8 " + "ON " + "GW8.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW8_FILIAL = GW3_FILIAL  "+CRLF
	cQueryZD2 +=  " AND GW4_NRDC = GW8_NRDC  "+CRLF
	cQueryZD2 +=  " AND GW4_SERDC = GW8_SERDC  "+CRLF
	cQueryZD2 +=  " AND GW4_EMISDC = GW8_EMISDC "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("SB1")+" SB1 " + "ON " + "SB1.D_E_L_E_T_= ' '"+CRLF
	
	cQueryZD2 +=  "  AND GW8_ITEM = B1_COD "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GW1")+" GW1 " + "ON " + "GW1.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW1_FILIAL = GW8_FILIAL  "+CRLF
	cQueryZD2 +=  " AND GW1_NRDC = GW8_NRDC   "+CRLF
	cQueryZD2 +=  " AND GW1_SERDC = GW8_SERDC  "+CRLF
	cQueryZD2 +=  " AND GW1_EMISDC = GW8_EMISDC "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("SA2")+" SA2 " + "ON " + "SA2.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW3_EMISDF = A2_CGC  "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GU3")+" GU3 " + "ON " + "GU3.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW1_CDDEST = GU3_CDEMIT "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("SX5")+" SX5 " + "ON " + "SX5.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND X5_TABELA = '13' "+CRLF
	cQueryZD2 +=  " AND GW8_CFOP = X5_CHAVE "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GVT")+" GVT " + "ON " + "GVT.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW3_CDESP = GVT_CDESP "+CRLF
	
	cQueryZD2 +=  " INNER JOIN "  + RetSqlName("ZD2")+" ZD2 " + "ON " + "ZD2.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND ZD2_FILIAL ='" + aZD2[nI][1] +"'"+CRLF
	cQueryZD2 +=  " AND ZD2_PRIORI ='" + aZD2[nI][2] +"'"+CRLF
	
	// Filtra CFOP's'
	If !EMPTY(ALLTRIM(aZD2[nI][12]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][12])+CRLF
	EndIf
	// Filtra Grupo de Produtos
	If !EMPTY(ALLTRIM(aZD2[nI][13]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][13])+CRLF
	EndIf
	
	//Filtra produtos
	If !EMPTY(ALLTRIM(aZD2[nI][14]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][14])+CRLF
	EndIf
	// Filtra Documentos de Frete
	If !EMPTY(ALLTRIM(aZD2[nI][15]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][15])+CRLF
	EndIf
	// Filtra Tipos de Pedidos
	If !EMPTY(ALLTRIM(aZD2[nI][16]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][16])+CRLF
	EndIf
	//Filtra Tipos de documentos de carga
	If 	ALLTRIM((cDados)->GW8_CDTPDC) = 'NFS'
		cQueryZD2 += " AND (ZD2_TPDOC = '3' OR ZD2_TPDOC = '2') "+CRLF
	ElseIf ALLTRIM((cDados)->GW8_CDTPDC) = 'NFE'
		cQueryZD2 += " AND (ZD2_TPDOC = '3' OR ZD2_TPDOC = '1')"+CRLF
	EndIf
	
	// Filtra tipos de clientes.
	If /*(cDados)->A1_TIPO <> 'X' .OR.*/ (cDados)->GU3_NATUR <> 'X'
		cQueryZD2 += " AND (ZD2_TPCLI = '2' OR ZD2_TPCLI = '3')"+CRLF
	ElseIf /*(cDados)->A1_TIPO = 'X' .OR. */(cDados)->GU3_NATUR = 'X'
		cQueryZD2 += " AND (ZD2_TPCLI = '1' OR ZD2_TPCLI = '3')"+CRLF
	EndIf
	
	// Filtra Tipos de Pedidos
	If !EMPTY(ALLTRIM(aZD2[nI][17]))
		cQueryZD2 += " AND " + ALLTRIM(aZD2[nI][17])+CRLF
	EndIf
	
	If lOcor//!Empty(aZD2[nI][18])
		
		cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GWF")+" GWF " + "ON " + "GWF.D_E_L_E_T_= ' '"+CRLF
		cQueryZD2 +=  " AND GWF_FILIAL = GW3_FILIAL "+CRLF
		cQueryZD2 +=  " AND GWF_CDESP  = GW3_CDESP "+CRLF
		cQueryZD2 +=  " AND GWF_EMISDF = GW3_EMISDF "+CRLF
		cQueryZD2 +=  " AND GWF_SERDF  = GW3_SERDF "+CRLF
		cQueryZD2 +=  " AND GWF_NRDF   = GW3_NRDF "+CRLF
		
		cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GWD")+" GWD " + "ON " + "GWD.D_E_L_E_T_= ' '"+CRLF
		cQueryZD2 +=  " AND GWF_FILIAL = GWD_FILIAL "+CRLF
		cQueryZD2 +=  " AND GWF_NROCO  = GWD_NROCO "+CRLF
		
		cQueryZD2 +=  " INNER JOIN "  + RetSqlName("GU6")+" GU6 " + "ON " + "GU6.D_E_L_E_T_= ' '"+CRLF
		cQueryZD2 +=  " AND " + aZD2[nI][18]
		cQueryZD2 +=  " AND GU6_CDMOT = GWD_CDMOT "+CRLF
		
	EndIf
	
	cQueryZD2 +=  " WHERE GW3.D_E_L_E_T_= ' '"+CRLF
	cQueryZD2 +=  " AND GW3_FILIAL ='" + XFILIAL("GW3") +"'"+CRLF
	cQueryZD2 +=  " AND GW3_NRDF ='" + cDocfre +"'"+CRLF
	cQueryZD2 +=  " AND GW3_SERDF ='" + cSerFre +"'"+CRLF
	cQueryZD2 +=  " AND GW3_EMISDF ='" + GW3->GW3_EMISDF +"'"+CRLF	
	
	memowrite("c:\temp\cQuerZD2.TXT", cQueryZD2  )
	cQueryZD2 := ChangeQuery(cQueryZD2)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQueryZD2),cQuerZD2, .F., .T.)
	
	If (cQuerZD2)->(!EOF())
		
		lRet := .T.
		
		If !empty((cQuerZD2)->ZD2_NTFIM)
			cNaturx  := (cQuerZD2)->ZD2_NTFIM
		EndIf
		If !empty((cQuerZD2)->ZD2_PROD)
			cProdutx := (cQuerZD2)->ZD2_PROD
		EndIf
		If !empty((cQuerZD2)->ZD2_CLASS)
			cClassex := (cQuerZD2)->ZD2_CLASS
		EndIf
		If empty(cPagtox)
			cPagtox  := (cQuerZD2)->ZD2_CONDPG
		EndIf
		If !Empty((cQuerZD2)->ZD2_CC)
			cCCx	 := (cQuerZD2)->ZD2_CC
		EndIf
		If !Empty((cQuerZD2)->ZD2_ITEMC)
			cItemx	 := (cQuerZD2)->ZD2_ITEMC
		EndIf
		If !Empty((cQuerZD2)->ZD2_CONTA)
			cContaX	 := (cQuerZD2)->ZD2_CONTA
		EndIf
		If !Empty((cQuerZD2)->ZD2_TES)
			cTesx	 := (cQuerZD2)->ZD2_TES
		EndIf
		If !Empty((cQuerZD2)->ZD2_TPOP)
			cTpopx   := (cQuerZD2)->ZD2_TPOP
		EndIf
		
		Exit
	EndIf
	(cQuerZD2)->(dbCloseArea())
Next nI
//		ZD2->(dbskip())
//	Enddo
//(cDados)->(dbskip())
//Enddo
(cDados)->(dbCloseArea())

RestArea(aAreaZD2)
RestArea(aAreaGWF)
RestArea(aAreaGW3)
RestArea(aArea)

return

User Function CTB32FIM()

cNaturx  := ZD2->ZD2_NTFIM
cClassex := ZD2->ZD2_CLASS
cOperx   := ZD2->ZD2_TPOP
cProdutx := ZD2->ZD2_PROD

If IsincallStack("GFEA065XD") .and. !IsincallStack("MATA103")
	If cNaturx = ' ' .OR. NIL
		cNaturx := GetMv("MV_NTFGFE")
		If !Empty(SE2->E2_NUM)// <> "" .OR. NIL
			RecLock("SE2",.F.)
			SE2->E2_NATUREZ := cNaturx
			MsUnLock()
		EndIf
	Else
		If !Empty(SE2->E2_NUM)// <> "" .OR. NIL
			RecLock("SE2",.F.)
			SE2->E2_NATUREZ := cNaturx
			MsUnLock()
		EndIf
	EndIf
	//Else
	If !Empty(SE2->E2_NUM)// <> "" .OR. NIL
		If !Empty(ZD2->ZD2_NTFIM)// <> "" .OR. NIL
			RecLock("SE2",.F.)
			SE2->E2_NATUREZ := cNaturx
			MsUnLock()
		EndIf
	EndIf
	//					dBselectArea("SD1")
	//					SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	//					If SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	//						If cOperx <> ' ' .OR. NIL
	//							Return
	//
	If Empty(cContaX)
		U_MGFCTB232()
	Endif
	
	
	If 	!Empty(cClassex)// <> ' ' .OR. NIL
		RecLock("SD1",.F.)
		SD1->D1_CLVL := cClassex
		If !Empty(cContaX)
			SD1->D1_CONTA:= cContaX
		Endif
		MsUnLock()
	Else
		RecLock("SD1",.F.)
		//SD1->D1_CLVL := cClassex
		If !Empty(cContaX)
			SD1->D1_CONTA:= cContaX
		Endif
		MsUnLock()
	EndIf
EndIf



