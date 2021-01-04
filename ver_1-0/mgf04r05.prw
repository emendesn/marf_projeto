//Bibliotecas
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "Rptdef.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} xRelat
//TODO Descricao auto-gerada.
@author eadonato
@since 12/12/2018
@version undefined

@type function

============================================================================================
Programa.:              MGF04R05
Autor....:              Eduardo Augusto Donato
Data.....:              12/12/2018
Descricao / Objetivo:   Relatorio de Saldo de Estoque para confronto com o Taura
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Relatorio de Analise
=============================================================================================
=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Historico de Alteracoes <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<|
=============================================================================================
|   Data    |               Alteracao              				 |    Autor     |  Chamado  |
=============================================================================================
|12/12/2018 |Criacao do Relatorio de saldo de Estoque com OP     |Eduardo Donato|           |
|  /  /     |                                                    |              |           | 
=============================================================================================

/*/

User Function MGF04R05()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg   := ""

	//Definicoes da pergunta
	cPerg := "MGF04R05  "

	AjustSX1()

	if ! Pergunte(cPerg)
		return
	endif

	//Cria as definicoes do relatorio
	oReport := fReportDef()

	//Sera enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
		//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf

	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
| Func:  fReportDef                                                             |
| Desc:  Funcao que monta a definicao do relatorio                              |
*-------------------------------------------------------------------------------*/

Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak   := Nil
	Local oFunTot1 := Nil

	//Criacao do componente de impressao
	oReport := TReport():New(	"MGF6999",;		//Nome do Relatorio
	"Relatorio de Saldo Estoque",;		//Titulo
	cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, sera impresso uma pagina com os parametros, conforme privil�gio 101
	{|oReport| fRepPrint(oReport)},;		//Bloco de Codigo que sera executado na confirmacao da impressao
	)		//Descricao
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()

	//Criando a secao de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a secao pertence
	"Dados",;		//Descricao da secao
	{"QRY_AUX"})	//Tabelas utilizadas, a primeira sera considerada como principal da secao
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serao impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	//Colunas do relatorio
	TRCell():New(oSectDad, "B2_FILIAL"						, "QRY_AUX", "Filial", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B2_COD"							, "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC"						, "QRY_AUX", "Descricao", /*Picture*/, 76, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_INICIAL_EM_DTESTOQUE"		, "QRY_AUX", "Qtd_inicial_em_"+DTOS(MV_PAR07), /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_MOVIMENTADA"				, "QRY_AUX", "Qtd_movimentada", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_SAIDA_ATE_DTFIM"			, "QRY_AUX", "Qtd_saida_ate_"+DTOS(MV_PAR02), /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_ESTOQUE_EM_DTFIM"			, "QRY_AUX", "Qtd_estoque_em_"+DTOS(MV_PAR02), /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD_EM_ESTOQUE_AGORA"			, "QRY_AUX", "Qtd_em_estoque_"+DTOS(DDATABASE)+"_"+TIME(), /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	oFunTot1 := TRFunction():New(oSectDad:Cell("QTD_INICIAL_EM_DTESTOQUE"),,"SUM",oBreak,,"@E 999.999.999,99")
	oFunTot1 := TRFunction():New(oSectDad:Cell("QTD_MOVIMENTADA"),,"SUM",oBreak,,"@E 999.999.999,99")
	oFunTot1 := TRFunction():New(oSectDad:Cell("QTD_SAIDA_ATE_DTFIM"),,"SUM",oBreak,,"@E 999.999.999,99")
	oFunTot1 := TRFunction():New(oSectDad:Cell("QTD_ESTOQUE_EM_DTFIM"),,"SUM",oBreak,,"@E 999.999.999,99")
	oFunTot1 := TRFunction():New(oSectDad:Cell("QTD_EM_ESTOQUE_AGORA"),,"SUM",oBreak,,"@E 999.999.999,99")
	oFunTot1:SetEndReport(.F.)
Return oReport

/*-------------------------------------------------------------------------------*
| Func:  fRepPrint                                                              |
| Desc:  Funcao que imprime o relatorio                                         |
*-------------------------------------------------------------------------------*/

Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0

	//Pegando as secoes do relatorio
	oSectDad := oReport:Section(1)

	//Montando consulta de dados
	cQryAux := ""
	cQryAux += " WITH TBLSC2 AS (SELECT DISTINCT C2_FILIAL, C2_NUM, C2_SEQUEN, C2_ITEM, C2_PRODUTO FROM "+RetSqlName("SC2")+" SC2 WHERE C2_FILIAL = '"+xFilial("SB2")+"' AND SC2.D_E_L_E_T_ = ' ' AND C2_DATPRF BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND C2_PRODUTO < '500000' AND C2_ZOPTAUR BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND C2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')"		+ STR_PULA
	cQryAux += " SELECT A.B2_FILIAL, A.B2_COD , A.B1_DESC "		+ STR_PULA
	cQryAux += " ,Sum(A.saldo_anterior) QTD_INICIAL_EM_DTESTOQUE"		+ STR_PULA
	cQryAux += " ,Sum(A.nf_entradas+A.requisicao-A.devolucao+A.qtd_movimentada_op) QTD_MOVIMENTADA"		+ STR_PULA
	cQryAux += " ,Sum(A.nf_saidas) QTD_SAIDA_ATE_DTFIM"		+ STR_PULA
	cQryAux += " ,Sum(A.saldo_anterior+A.nf_entradas+A.requisicao-A.devolucao+A.qtd_movimentada_op-A.nf_saidas) QTD_ESTOQUE_EM_DTFIM"		+ STR_PULA
	cQryAux += " ,Sum(saldo_atual)QTD_EM_ESTOQUE_AGORA"		+ STR_PULA
	cQryAux += " FROM (SELECT "		+ STR_PULA
	cQryAux += "   B2_FILIAL"		+ STR_PULA
	cQryAux += " , B2_COD"		+ STR_PULA
	cQryAux += " , B1_DESC"		+ STR_PULA
	cQryAux += " , NVL((SELECT Sum(B9_QINI)  FROM "+RetSqlName("SB9")+" SB9 WHERE SB9.D_E_L_E_T_ = ' ' AND B9_FILIAL = B2_FILIAL AND B9_COD = SB2.B2_COD AND SB2.B2_LOCAL = B9_LOCAL AND B9_DATA = '"+DTOS(MV_PAR07)+"'),0) SALDO_ANTERIOR"		+ STR_PULA
	cQryAux += " , NVL((SELECT Sum(D1_QUANT) FROM "+RetSqlName("SD1")+" SD1 WHERE SD1.D_E_L_E_T_ = ' ' AND D1_COD = SB2.B2_COD AND D1_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND D1_FILIAL = SB2.B2_FILIAL AND D1_TES <> ' ' AND SB2.B2_LOCAL = D1_LOCAL),0) NF_ENTRADAS"		+ STR_PULA
	cQryAux += " , NVL((SELECT Sum(D2_QUANT) FROM "+RetSqlName("SD2")+" SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD = SB2.B2_COD AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND D2_FILIAL = SB2.B2_FILIAL AND SB2.B2_LOCAL = D2_LOCAL),0) NF_SAIDAS"		+ STR_PULA
	cQryAux += " , NVL((SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND D3_COD = SB2.B2_COD AND D3_FILIAL = SB2.B2_FILIAL AND SUBSTR(D3_CF,1,2) = 'RE' AND D3_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND SB2.B2_LOCAL = D3_LOCAL),0) REQUISICAO"		+ STR_PULA
	cQryAux += " , NVL((SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND D3_COD = SB2.B2_COD AND D3_FILIAL = SB2.B2_FILIAL AND SUBSTR(D3_CF,1,2) = 'DE' AND D3_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND SB2.B2_LOCAL = D3_LOCAL),0) DEVOLUCAO "		+ STR_PULA
	cQryAux += " ,     (SELECT Nvl(Sum(QTD),0) FROM ("		+ STR_PULA
	cQryAux += "       SELECT DISTINCT C2_FILIAL, C2_NUM, C2_PRODUTO, C2_LOCAL, Sum(D3_QUANT) QTD FROM "+RetSqlName("SC2")+" SC2 "		+ STR_PULA
	cQryAux += "       INNER JOIN "+RetSqlName("SD3")+" SD3 ON SD3.D_E_L_E_T_ = ' ' AND D3_COD = SC2.C2_PRODUTO AND D3_FILIAL = SC2.C2_FILIAL AND TRIM(SC2.C2_NUM)||TRIM(SC2.C2_ITEM)||TRIM(SC2.C2_SEQUEN) = TRIM(D3_OP) AND SC2.C2_LOCAL = D3_LOCAL"		+ STR_PULA
	cQryAux += "       WHERE SC2.D_E_L_E_T_ = ' ' AND C2_ZOPTAUR BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND C2_DATPRF BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND C2_PRODUTO = SB2.B2_COD AND C2_FILIAL = SB2.B2_FILIAL AND SB2.B2_LOCAL = SC2.C2_LOCAL"		+ STR_PULA
	cQryAux += "       GROUP BY C2_FILIAL, C2_NUM, C2_PRODUTO, C2_LOCAL))  QTD_MOVIMENTADA_OP"		+ STR_PULA
	cQryAux += " , B2_QATU SALDO_ATUAL"		+ STR_PULA

	cQryAux += " FROM "+RetSqlName("SB2")+" SB2"		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSC2 ON TBLSC2.C2_FILIAL = B2_FILIAL AND TBLSC2.C2_PRODUTO = B2_COD "		+ STR_PULA
	cQryAux += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += " WHERE "		+ STR_PULA
	cQryAux += " B2_FILIAL = '"+xFilial("SB2")+"'"		+ STR_PULA
	cQryAux += " AND SB2.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += " AND B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"		+ STR_PULA
	If Empty(MV_PAR05) .and. upper(MV_PAR06) = 'ZZZZZZZZZZZZZZZ'
		cQryAux += " AND B2_COD < '500000') A"		+ STR_PULA
	Else
		cQryAux += " AND B2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') A"		+ STR_PULA
	EndIf
	cQryAux += " GROUP BY   A.B2_FILIAL, A.B2_COD , A.B1_DESC	"		+ STR_PULA
	/*
	cQryAux += " WITH TBLSB1 AS (SELECT B1_FILIAL, B1_COD, B1_DESC FROM "+RetSqlName("SB1")+" SB1 WHERE SB1.D_E_L_E_T_ = ' ' AND B1_COD < '500000') ,"		+ STR_PULA
	cQryAux += "     TBLSB9 AS (SELECT B9_FILIAL, B9_COD, SUM(B9_QINI) B9_QINI FROM  "+RetSqlName("SB9")+" SB9 WHERE SB9.D_E_L_E_T_ = ' ' AND B9_COD < '500000' AND B9_DATA = '"+DTOS(MV_PAR07)+"' GROUP BY B9_FILIAL, B9_COD)  ,"		+ STR_PULA
	cQryAux += "     TBLSD2 AS (SELECT D2_FILIAL, D2_COD, SUM(D2_QUANT) D2_QUANT FROM  "+RetSqlName("SD2")+"  SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND D2_COD < '500000' AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' GROUP BY D2_FILIAL, D2_COD),"		+ STR_PULA
	cQryAux += "     TBLSB2 AS (SELECT B2_FILIAL, B2_COD, SUM(B2_QATU) B2_QATU FROM  "+RetSqlName("SB2")+" SB2 WHERE SB2.D_E_L_E_T_ = ' ' AND B2_COD < '500000' AND B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' GROUP BY B2_FILIAL, B2_COD),"		+ STR_PULA
	cQryAux += "     TBLSD3 AS (SELECT D3_FILIAL, D3_COD, D3_OP, SUM(D3_QUANT) D3_QUANT FROM  "+RetSqlName("SD3")+" SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND D3_COD < '500000' GROUP BY D3_FILIAL, D3_COD, D3_OP),"		+ STR_PULA
	cQryAux += "     TBLSC2 AS (SELECT DISTINCT C2_FILIAL, C2_NUM, C2_SEQUEN, C2_ITEM, C2_PRODUTO, C2_LOCAL FROM "+RetSqlName("SC2")+" SC2 WHERE SC2.D_E_L_E_T_ = ' ' AND C2_DATPRF BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND C2_PRODUTO < '500000' )"		+ STR_PULA
	cQryAux += " SELECT B9_FILIAL, B9_COD, B1_DESC"		+ STR_PULA
	cQryAux += ", NVL(A.QTD_INICIAL,0) AS QTD_INICIAL_EM_DTESTOQUE"		+ STR_PULA
	cQryAux += ", SUM(NVL(A.QTD_MOVIMENTADA,0)) AS QTD_MOVIMENTADA"		+ STR_PULA
	cQryAux += ", NVL(A.QTD_SAIDA,0) AS QTD_SAIDA_ATE_DTFIM"		+ STR_PULA
	cQryAux += ", NVL(A.QTD_INICIAL,0) + SUM(NVL(A.QTD_MOVIMENTADA,0)) - NVL(A.QTD_SAIDA,0) AS QTD_ESTOQUE_EM_DTFIM"		+ STR_PULA
	cQryAux += ", A.QTD_EM_ESTOQUE_AGORA AS QTD_EM_ESTOQUE_AGORA"		+ STR_PULA
	cQryAux += " FROM ("	+ STR_PULA
	cQryAux += " SELECT " + STR_PULA
	cQryAux += "  TBLSB9.B9_FILIAL"		+ STR_PULA
	cQryAux += ", TBLSB9.B9_COD, B1_DESC"		+ STR_PULA
	cQryAux += ", NVL(TBLSB9.B9_QINI,0)  QTD_INICIAL"		+ STR_PULA
	cQryAux += ", NVL(TBLSD3.D3_QUANT,0) QTD_MOVIMENTADA"		+ STR_PULA
	cQryAux += ", NVL(TBLSD2.D2_QUANT "		+ STR_PULA
	cQryAux += "  +"		+ STR_PULA
	cQryAux += "  (SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND D3_COD = TBLSB9.B9_COD AND D3_FILIAL = TBLSB9.B9_FILIAL AND SUBSTR(D3_CF,1,2) = 'RE' AND D3_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"')"		+ STR_PULA
	cQryAux += "  -"		+ STR_PULA
	cQryAux += "  (SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" SD3 WHERE SD3.D_E_L_E_T_ = ' ' AND D3_COD = TBLSB9.B9_COD AND D3_FILIAL = TBLSB9.B9_FILIAL AND SUBSTR(D3_CF,1,2) = 'DE' AND D3_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'),0) QTD_SAIDA"		+ STR_PULA
	cQryAux += ", NVL(TBLSB9.B9_QINI,0)+NVL(TBLSD3.D3_QUANT,0)-NVL(D2_QUANT,0)  QTD_EM_ESTOQUE"		+ STR_PULA
	cQryAux += ", NVL(B2_QATU,0) QTD_EM_ESTOQUE_AGORA"		+ STR_PULA
	cQryAux += " FROM TBLSB9"		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSC2 ON TBLSC2.C2_FILIAL = B9_FILIAL AND TBLSC2.C2_PRODUTO = B9_COD "		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSD3 ON TBLSD3.D3_FILIAL = B9_FILIAL AND TRIM(C2_NUM)||TRIM(C2_ITEM)||TRIM(C2_SEQUEN) = TRIM(TBLSD3.D3_OP) AND TBLSD3.D3_COD = B9_COD"		+ STR_PULA
	cQryAux += " INNER JOIN TBLSB1 ON TBLSB1.B1_COD = B9_COD"		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSB9 ON TBLSB9.B9_FILIAL = B9_FILIAL AND TBLSB9.B9_COD = TBLSB1.B1_COD"		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSB2 ON TBLSB2.B2_FILIAL = B9_FILIAL AND TBLSB2.B2_COD = TBLSB1.B1_COD"		+ STR_PULA
	cQryAux += " LEFT JOIN TBLSD2 ON TBLSD2.D2_FILIAL = B9_FILIAL AND TBLSD2.D2_COD = TBLSB1.B1_COD"		+ STR_PULA
	cQryAux += " WHERE TBLSB9.B9_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"		+ STR_PULA
	cQryAux += " AND TBLSB9.B9_FILIAL = '"+xFilial("SB9")+"'"		+ STR_PULA
	cQryAux += " ) A"		+ STR_PULA
	cQryAux += " GROUP BY B9_FILIAL,A.B9_COD, A.B1_DESC, A.QTD_INICIAL,A.QTD_SAIDA,A.QTD_EM_ESTOQUE_AGORA"		+ STR_PULA
	cQryAux += " ORDER BY B9_COD"		+ STR_PULA
	//	cQryAux := ChangeQuery(cQryAux)
	*/
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)

	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r�gua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()

		//Imprimindo a linha atual
		oSectDad:PrintLine()

		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())

	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Eduardo Donato     �                    ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria pergunta no e o help do SX1                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustSX1()

	Local aArea := GetArea()
	Local aRegs := {}
	Local i

	cPerg := PADR(cPerg,10)

	AAdd(aRegs,{"01","Emissao de ?" 	,"mv_ch1","D",8,0,0,"G","MV_PAR01","" ,"", "" })
	AAdd(aRegs,{"02","Emissao ate ?"	,"mv_ch2","D",8,0,0,"G","MV_PAR02","" ,"", "" })
	AAdd(aRegs,{"03","Armazem de ?"		,"mv_ch3","C",tamSX3("B2_LOCAL")[1],0,0,"G","MV_PAR03","" ,"", "" })
	AAdd(aRegs,{"04","Armazem ate ?"	,"mv_ch4","C",tamSX3("B2_LOCAL")[1],0,0,"G","MV_PAR04","" ,"", "" })
	AAdd(aRegs,{"05","Produto de ?"		,"mv_ch5","C",tamSX3("B1_COD")[1],0,0,"G","MV_PAR05","" ,"", "SB1" })
	AAdd(aRegs,{"06","Produto ate ?"	,"mv_ch6","C",tamSX3("B1_COD")[1],0,0,"G","MV_PAR06","" ,"", "SB1" })
	AAdd(aRegs,{"07","Dt Inicial Saldo ?","mv_ch7","D",8,0,0,"G","MV_PAR07","" ,"", "" })
	AAdd(aRegs,{"08","OP Taura de ?"	,"mv_ch8","C",tamSX3("C2_ZOPTAUR")[1],0,0,"G","MV_PAR08","" ,"", "SC2" })
	AAdd(aRegs,{"09","OP Taura ate ?"	,"mv_ch9","C",tamSX3("C2_ZOPTAUR")[1],0,0,"G","MV_PAR09","" ,"", "SC2" })


	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		dbSeek(cPerg+aRegs[i][1])
		If !Found() .or. aRegs[i][2]<>X1_PERGUNT
			RecLock("SX1",!Found())
			SX1->X1_GRUPO 	:= cPerg
			SX1->X1_ORDEM 	:= aRegs[i][01]
			SX1->X1_PERGUNT := aRegs[i][02]
			SX1->X1_VARIAVL := aRegs[i][03]
			SX1->X1_TIPO 	:= aRegs[i][04]
			SX1->X1_TAMANHO := aRegs[i][05]
			SX1->X1_DECIMAL := aRegs[i][06]
			SX1->X1_PRESEL 	:= aRegs[i][07]
			SX1->X1_GSC 	:= aRegs[i][08]
			SX1->X1_VAR01 	:= aRegs[i][09]
			SX1->X1_DEF01 	:= aRegs[i][10]
			SX1->X1_DEF02 	:= aRegs[i][11]
			SX1->X1_F3 		:= aRegs[i][12]
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return