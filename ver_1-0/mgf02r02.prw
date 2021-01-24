#INCLUDE "totvs.ch" 

/*/
{Protheus.doc} MGF02R02
Job para validação dos XML´s de CTe´s.

@author Geronimo Benedito Alves
@since 18/01/18 
*/
User Function MGF02R02()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Compras - Saving de Negociacao"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Saving de Negociacao"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Saving de Negociacao"} 			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Saving de Negociacao"} 			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  								)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 	
	Aadd(_aDefinePl, { {||.T.} } 						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  	
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	cDesc_Stat  := "  CASE "					+CRLF
	cDesc_Stat	+= "		WHEN ECONOMIA > 0 "	+CRLF
	cDesc_Stat	+= "		THEN 'SAVING' "		+CRLF
	cDesc_Stat	+= "		WHEN ECONOMIA < 0 "	+CRLF
	cDesc_Stat	+= "		THEN 'PENALTY' "		+CRLF
	cDesc_Stat	+= "		ELSE	'		' "		+CRLF
	cDesc_Stat	+= "  END  AS STATUS "			+CRLF			

	AAdd(_aCampoQry, { 	"F2_FILIAL"	,"COD_FILIAL"								,"Cód. Filial"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A1_NOME"	,"NOME_FILIAL				as NOMEFILIAL"	,"Nome Filial"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, {	"C7_NUM"	,"NUMERO_PEDIDO				as NUMPEDIDO"	,"Nº Pedido"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, {	"C7_ZPEDME"	,"PEDIDOME				    as PEDIDOME"	,"Pedido ME"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, {	"C7_EMISSAO","DATA_EMISSAO_PEDIDO		as DTEMISSPED"	,"Data Emissão Pedido"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_DOC"	,"NUMERO_NF"								,"Nº NF"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_SERIE"	,"NUMERO_SERIE_NF			as N_SERIE_NF"	,"Nº Serie NF"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_ITEM"	,"ITEM_NF"									,"Item NF"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_DTLANC"	,"DATA_ENTRADA_NF			as DTENTRADNF"	,"Data Entrada NF"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_CONTRA"	,"CONTRATO_SPOT				as CONTRASPOT"	,"Contrato Spot"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"B1_COD"	,"COD_PRODUTO				as CODPRODUTO"	,U_X3Titulo("B1_COD")	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"B1_DESC"	,"DESC_PRODUTO				as DESCPRODUT"	,"Desc. Produto"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_QUANT"	,"QTD_SOLICITADA			as QTDSOLICIT"	,"Qtd. Solicitada"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_QUANT"	,"QTD_NF"									,"Qtd. NF"				,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"C8_PRECO"	,"PRECO_BASE"								,"Preço Base"			,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"C7_TOTAL"	,"PRECO_UNITARIO_FECHADO	as PRECOUNIFE"	,"Preço Unit. Fechado",  ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AH_UNIMED"	,"COD_UNIDADE_MEDIDA		as UNIDADEMED"	,"Cód. Unidade Medida",  ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AH_DESCPO"	,"DESC_UNIDADE_MEDIDA		as DESC_UNIDA"	,"Desc. Unidade Medida", ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AA1_FUNCAO","MOEDA_PRODUTO				as MOEDAPRODU"	,"Moeda Produto"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_TOTAL_NF 			as VLRTOTALNF"	,"Vlr. Total NF"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_ULTIMA_COMPRA		as VLRULTIMCP"	,"Vlr. Ultima Compra"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_PENULTIMA_COMPRA	as VLRPENULTI"	,"Vlr. Penultima"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_EMISSAO","DATA_ULTIMA_COMPRA		as DTULTIMACP"	,"Data Ultima Compra"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_EMISSAO","DATA_PENULTIMA_COMPRA		as DTPENULTIM"	,"Data Penultima Compra",""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_TOTAL"	,"ECONOMIA"									,"Economia"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A1_TELEX"	,cDesc_Stat									,"Status"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_PRECO"	,"COST_AVOIDANCE 			as COST_AVOID"	,"Cost Avoidance"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A2_COD"	,"COD_FORNECEDOR 			as CODFORNECE"	,"Cód. Fornecedor"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A2_LOJA"	,"LOJA_FORNECEDOR 			as LOJAFORNEC"	,"Loja Fornecedor"		,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"A2_NOME"	,"NOME_FORNECEDOR 			as NOMEFORNEC"	,"Nome Fornecedor"		,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"A2_CGC"	,"CNPJ_FORNECEDOR 			as CNPJFORNEC"	,"CNPJ Fornecedor"		,""	,18	,""	,"@!","","@!"})
	AAdd(_aCampoQry, { 	"Y1_USER"	,"USER_COMPRADOR 			as USERCOMPRA"	,"User Comprador"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"Y1_NOME"	,"NOME_COMPRADOR 			as NOMECOMPRA"	,"Nome Comprador"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"X5_CHAVE"	,"COD_TIPO_PRODUTO 			as CODTIPPROD"	,"Cód. Tipo Produto"	,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"X5_DESCRI"	,"DESC_TIPO_PRODUTO 		as DESCTIPPRO"	,"Desc. Tipo Produto"	,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"BM_GRUPO"	,"COD_GRUPO_PRODUTO 		as CODGRPPROD"	,"Cód. Grupo Produto"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"BM_DESC"	,"DESC_GRUPO_PRODUTO 		as DESCGRPPRO"	,"Desc. Grupo Produto"	, "",""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"E4_DESCRI"	,"CONDICAO_PAGAMENTO 		as CONDIPAGTO"	,"Condicao Pagamento"	,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"C7_PRECO"	,"SPEND"									,"Spend"				,""	,""	,""	,""	,""	,""	})				

	aAdd(_aParambox,{1,"Data Entrada NF Inicial",Ctod("")						,""	,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Entrada NF Final"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cod. Fornec. Inicial"	,Space(tamSx3("A2_COD")[1])		,""	,													,"CF8A2","",050,.F.}) 
	aAdd(_aParambox,{1,"Loja Fornec. Inicial"	,Space(tamSx3("A2_LOJA")[1])	,""	,													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornec. Final"		,Space(tamSx3("A2_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR05,'Cod. Fornecedor')"	,"CF8A2","",050,.F.})	
	aAdd(_aParambox,{1,"Loja Fornec. Final"		,Space(tamSx3("A2_LOJA")[1])	,""	,"U_VLFIMMAI(MV_PAR04, MV_PAR06,'Loja Fornecedor')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"	,Space(tamSx3("C7_PRODUTO")[1])	,""	,													,"SB1"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Cod. Produto Final"		,Space(tamSx3("C7_PRODUTO")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08,'Cod. Produto')"	,"SB1"	,"",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet, @_cTmp01) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	
	If Empty(_aSelFil) 
		Return 
	Endif
	
	_cCODFILIA	:= U_Array_In(_aSelFil)

 	cQryCompdo	:= "SELECT ' ' as Y1_COD, 'Sem Comprador' as Y1_NOME FROM DUAL UNION ALL "
	cQryCompdo	+= "SELECT DISTINCT Y1_COD, Y1_NOME"
	cQryCompdo  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SY1")  ) + " TMPSY1 "
	cQryCompdo	+= "  WHERE TMPSY1.D_E_L_E_T_ = ' ' "
	cQryCompdo	+= "  ORDER BY Y1_COD"

	aCpoCompdo	:=	{	{ "Y1_COD"		,U_X3Titulo("Y1_COD")	,TamSx3("Y1_COD")[1]		} ,;
	aCpoCompdo	:=		{ "Y1_NOME"	,U_X3Titulo("Y1_NOME")	,TamSx3("Y1_NOME")[1] }	} 

	cTitCompdo	:= "Marque os Códigos de compradores à serem listados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 	

	cComprador	:= U_Array_In( U_MarkGene(cQryCompdo, aCpoCompdo, cTitCompdo, nPosRetorn, @_lCancProg ) )

	If _lCancProg
		Return
	Endif 

 	cQryTipPro	:= "SELECT ' ' as X5_CHAVE, 'Sem Tipo Produto' as X5_DESCRI FROM DUAL UNION ALL "
	cQryTipPro	+= "SELECT DISTINCT X5_CHAVE, X5_DESCRI"
	cQryTipPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")  ) + " TMPSX5 "
	cQryTipPro	+= "  WHERE  TMPSX5.X5_TABELA  = '02' " 
	cQryTipPro	+= "  AND    TMPSX5.D_E_L_E_T_ = ' '  " 
	cQryTipPro	+= "  ORDER BY X5_CHAVE"

	aCpoTipPro	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	,TamSx3("X5_CHAVE")[1]		} ,;
	aCpoTipPro	:=		{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI")	,TamSx3("X5_DESCRI")[1] }	} 

	cTitTipPro	:= "Marque os Tipos de Produtos à serem listados: "
	nPosRetorn	:= 1		

	_lCancProg	:= .T. 		
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )

	If _lCancProg
		Return
	Endif 

	_cQuery += "	FROM "  +CRLF 
	_cQuery += " 				( SELECT DISTINCT R.M0_CODFIL       AS COD_FILIAL "  +CRLF
    _cQuery += " 					 , R.M0_FILIAL                AS NOME_FILIAL "  +CRLF
    _cQuery += " 					  , A.C7_NUM                   AS NUMERO_PEDIDO "  +CRLF
	 _cQuery += " 					  , A.C7_ZPEDME                   AS PEDIDOME "  +CRLF
    _cQuery += " 					  , TO_CHAR( "  +CRLF
	_cQuery += " 					 						 TO_DATE( "  +CRLF
	_cQuery += " 					 						 				 CASE "  +CRLF
	_cQuery += " 					 						 				      WHEN A.C7_EMISSAO   = ' ' "  +CRLF
	_cQuery += " 					 						 				          THEN NULL "  +CRLF
	_cQuery += " 					 						 				      ELSE A.C7_EMISSAO   "  +CRLF
	_cQuery += " 					 						 				 END, 'YYYYMMDD' "  +CRLF
	_cQuery += " 					 						 			  ) "  +CRLF
	_cQuery += " 					 						)	 AS DATA_EMISSAO_PEDIDO "  +CRLF
    _cQuery += " 					  , NF.F1_DOC                  AS NUMERO_NF "  +CRLF
    _cQuery += " 					  , NF.F1_SERIE                AS NUMERO_SERIE_NF "  +CRLF
    _cQuery += " 					  , NFI.D1_ITEM                AS ITEM_NF "  +CRLF
    _cQuery += " 					  , TO_CHAR( "  +CRLF
	_cQuery += " 					 						 TO_DATE( "  +CRLF
	_cQuery += " 					 						 				 CASE "  +CRLF
	_cQuery += " 					 						 				      WHEN NF.F1_DTDIGIT   = ' ' "  +CRLF
	_cQuery += " 					 						 				          THEN NULL "  +CRLF
	_cQuery += " 					 						 				      ELSE NF.F1_DTDIGIT   "  +CRLF
	_cQuery += " 					 						 				 END, 'YYYYMMDD' "  +CRLF
	_cQuery += " 					 						 			  ) "  +CRLF
	_cQuery += " 					 						)							      AS DATA_ENTRADA_NF "  +CRLF
    _cQuery += " 					  , NF.F1_DTDIGIT               AS DATA_ENTRADA_NF_FILTRO "  +CRLF
  
    _cQuery += "	,NVL((SELECT  NVL(TRIM(case INSTR(TMP1.JSON,'" + '"' + "CONTRATO" + '"' + ": " + '"' + "') when  0 then 'SPOT'   "  +CRLF
    _cQuery += "					 else substr(json,INSTR(TMP1.JSON,'" + '"' + "CONTRATO" + '"' + ": " + '"' + "') + 13, "  +CRLF
    _cQuery += "						INSTR(TMP1.JSON,'"+'"'+",',INSTR(TMP1.JSON,'" + '"' + "CONTRATO" + '"' + ": " + '"' + "')) "  +CRLF
	_cQuery += "							-INSTR(TMP1.JSON,'" + '"' + "CONTRATO" + '"' + ": " + '"' + "') - 13) "  +CRLF 
	_cQuery += "	                                                                                           end),' ') CONTRATO "  +CRLF
    _cQuery += "	 FROM( "  +CRLF
    	
	_cQuery += "	SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZGS_JSONE, 2000, 1)) JSON FROM ZGS010 ZGS WHERE "  +CRLF
	_cQuery += "										     ZGS.D_E_L_E_T_ <> '*' "  +CRLF
    _cQuery += "	                               AND  ZGS.ZGS_FILIAL = A.C7_FILIAL "  +CRLF
    _cQuery += "	                               AND  (ZGS.ZGS_PREPED = A.C7_ZPEDME) "  +CRLF
    _cQuery += "	                               AND  ZGS.ZGS_STATME = '1' "  +CRLF
    _cQuery += "	                               ORDER BY  ZGS.R_E_C_N_O_ DESC) TMP1 WHERE ROWNUM = 1),'SPOT') AS CONTRATO_SPOT "  +CRLF
	
	 _cQuery += " 					  , P.B1_COD                   AS COD_PRODUTO "  +CRLF
    _cQuery += " 					  , P.B1_DESC                  AS DESC_PRODUTO "  +CRLF
    _cQuery += " 					  , A.C7_QUANT                 AS QTD_SOLICITADA "  +CRLF
    _cQuery += " 					  , NFI.D1_QUANT               AS QTD_NF "  +CRLF
    _cQuery += " 					  , A.C7_PRECO                 AS PRECO_BASE "  +CRLF
    _cQuery += " 					  , A.C7_PRECO                 AS PRECO_UNITARIO_FECHADO "  +CRLF
    _cQuery += " 					  , U.AH_UNIMED                AS COD_UNIDADE_MEDIDA "  +CRLF
    _cQuery += " 					  , U.AH_DESCPO                AS DESC_UNIDADE_MEDIDA  "  +CRLF  
    _cQuery += " 					  , CASE WHEN A.C7_MOEDA  = '1' "  +CRLF
    _cQuery += " 					             THEN 'REAL' "  +CRLF
    _cQuery += " 					         WHEN A.C7_MOEDA  = '2' "  +CRLF
    _cQuery += " 					             THEN 'DOLAR' "  +CRLF
    _cQuery += " 					         WHEN A.C7_MOEDA  = '3' "  +CRLF
    _cQuery += " 					             THEN 'UFIR' "  +CRLF
    _cQuery += " 					         WHEN A.C7_MOEDA  = '4'  "  +CRLF
    _cQuery += " 					             THEN 'EURO' "  +CRLF
    _cQuery += " 					         WHEN A.C7_MOEDA  = '5' "  +CRLF
    _cQuery += " 					             THEN 'IENE' "  +CRLF
    _cQuery += " 					    END                        AS MOEDA_PRODUTO "  +CRLF
    _cQuery += " 					  , NFI.D1_TOTAL               AS VALOR_TOTAL_NF "  +CRLF
    _cQuery += " 					  , UPC.P_VALOR_ULTIMO                AS VALOR_ULTIMA_COMPRA   "  +CRLF  
    _cQuery += " 					  , UPC.P_VALOR_PENULTIMO             AS VALOR_PENULTIMA_COMPRA  "  +CRLF
    _cQuery += " 					  , TO_CHAR( "  +CRLF
	_cQuery += " 					 						 TO_DATE( "  +CRLF
	_cQuery += " 					 						 				 CASE "  +CRLF
	_cQuery += " 					 						 				      WHEN UPC.P_DT_EMISSAO_ULTIMO   = ' ' "  +CRLF
	_cQuery += " 					 						 				          THEN NULL "  +CRLF
	_cQuery += " 					 						 				      ELSE UPC.P_DT_EMISSAO_ULTIMO   "  +CRLF
	_cQuery += " 					 						 				 END, 'YYYYMMDD' "  +CRLF
	_cQuery += " 					 						 			  ) "  +CRLF
	_cQuery += " 					 						)							      AS DATA_ULTIMA_COMPRA "  +CRLF
    _cQuery += " 					  , TO_CHAR( "  +CRLF
	_cQuery += " 					 						 TO_DATE( "  +CRLF
	_cQuery += " 					 						 				 CASE "  +CRLF
	_cQuery += " 					 						 				      WHEN UPC.P_DT_EMISSAO_PENULTIMA   = ' ' "  +CRLF
	_cQuery += " 					 						 				          THEN NULL "  +CRLF
	_cQuery += " 					 						 				      ELSE UPC.P_DT_EMISSAO_PENULTIMA   "  +CRLF
	_cQuery += " 					 						 				 END, 'YYYYMMDD' "  +CRLF
	_cQuery += " 					 						 			  ) "  +CRLF
	_cQuery += " 					 						)							      AS DATA_PENULTIMA_COMPRA "  +CRLF
    _cQuery += " 					  , CASE  "  +CRLF
	_cQuery += " 					 					WHEN A.C7_TIPO = '2'  "  +CRLF
    _cQuery += " 					              THEN ((UPC.P_VALOR_PENULTIMO - A.C7_PRECO) * NFI.D1_QUANT) "  +CRLF
    _cQuery += " 					        ELSE ((UPC.P_VALOR_ULTIMO - A.C7_PRECO) * NFI.D1_QUANT) "  +CRLF
    _cQuery += " 					     END                       AS ECONOMIA "  +CRLF
    _cQuery += " 					  , CASE "  +CRLF
	_cQuery += " 					 					 WHEN ((A.C7_PRECO - A.C7_PRECO) * NFI.D1_QUANT) < 0 "  +CRLF
    _cQuery += " 					             THEN 0 "  +CRLF
    _cQuery += " 					          ELSE ((A.C7_PRECO - A.C7_PRECO) * NFI.D1_QUANT) "  +CRLF
    _cQuery += " 					      END                      AS COST_AVOIDANCE "  +CRLF
    _cQuery += " 					  , F.A2_COD                   AS COD_FORNECEDOR "  +CRLF
    _cQuery += " 					  , F.A2_LOJA                  AS LOJA_FORNECEDOR "  +CRLF
    _cQuery += " 					   , F.A2_NOME                  AS NOME_FORNECEDOR "  +CRLF
    _cQuery += " 					  , F.A2_CGC                   AS CNPJ_FORNECEDOR "  +CRLF
    _cQuery += " 					  , GC.Y1_USER                 AS USER_COMPRADOR "  +CRLF
    _cQuery += " 					  , GC.Y1_NOME                 AS NOME_COMPRADOR "  +CRLF
    _cQuery += " 					  , GC.Y1_COD                  AS COD_COMPRADOR_FILTRO "  +CRLF
    _cQuery += " 					  , TP.X5_CHAVE                AS COD_TIPO_PRODUTO "  +CRLF
    _cQuery += " 					  , TP.X5_DESCRI               AS DESC_TIPO_PRODUTO "  +CRLF
    _cQuery += " 					  , GP.BM_GRUPO                AS COD_GRUPO_PRODUTO "  +CRLF
    _cQuery += " 					  , GP.BM_DESC                 AS DESC_GRUPO_PRODUTO "  +CRLF
    _cQuery += " 					  , CP.E4_DESCRI               AS CONDICAO_PAGAMENTO "  +CRLF
    _cQuery += " 					  , CASE WHEN A.C7_TIPO = '2' "  +CRLF
    _cQuery += " 					             THEN UPC.P_VALOR_PENULTIMO * NFI.D1_QUANT "  +CRLF
    _cQuery += " 					         ELSE A.C7_PRECO * NFI.D1_QUANT "  +CRLF 
    _cQuery += " 					     END                       AS SPEND "  +CRLF
    _cQuery += " 					 FROM PROTHEUS.SC7010                   A "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SYS_COMPANY         R ON R.M0_CODFIL    = A.C7_FILIAL "  +CRLF
    _cQuery += " 					 									      AND R.D_E_L_E_T_   <> '*'  "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SB1010				 P ON P.B1_COD       = A.C7_PRODUTO   "  +CRLF
    _cQuery += " 					 										  AND P.D_E_L_E_T_   <> '*' "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SX5010				TP ON TP.X5_TABELA   = '02'  "  +CRLF
    _cQuery += " 					 										  AND TP.X5_CHAVE    = P.B1_TIPO   "  +CRLF
    _cQuery += " 					 										  AND TP.D_E_L_E_T_  <> '*'  "  +CRLF  
    _cQuery += " 					  INNER JOIN PROTHEUS.SAH010				 U ON U.AH_UNIMED    = P.B1_UM "  +CRLF
    _cQuery += " 					 										  AND U.D_E_L_E_T_   <> '*' "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SB2010				SE ON SE.B2_COD      = P.B1_COD "  +CRLF
    _cQuery += " 					 										  AND SE.B2_FILIAL   = R.M0_CODFIL "  +CRLF
    _cQuery += " 					 										  AND SE.D_E_L_E_T_  <> '*'  "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SBM010				GP ON GP.BM_GRUPO    = P.B1_GRUPO  "  +CRLF
    _cQuery += " 					 										  AND GP.D_E_L_E_T_  <> '*'   "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SD1010			   NFI ON NFI.D1_PEDIDO  = A.C7_NUM "  +CRLF
    _cQuery += " 					 										  AND NFI.D1_ITEMPC  = A.C7_ITEM "  +CRLF
    _cQuery += " 					 										  AND NFI.D1_FILIAL  = A.C7_FILIAL "  +CRLF
    _cQuery += " 					 										  AND NFI.D1_FORNECE = A.C7_FORNECE "  +CRLF
    _cQuery += " 					 										  AND NFI.D1_LOJA    = A.C7_LOJA "  +CRLF
    _cQuery += " 					 										  AND NFI.D1_COD     = A.C7_PRODUTO "  +CRLF
    _cQuery += " 					 										  AND NFI.D_E_L_E_T_ <> '*' "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SF1010		        NF ON NF.F1_DOC      = NFI.D1_DOC "  +CRLF
    _cQuery += " 					 									      AND NF.F1_SERIE    = NFI.D1_SERIE "  +CRLF
    _cQuery += " 					 										  AND NF.F1_FILIAL   = NFI.D1_FILIAL "  +CRLF
    _cQuery += " 					 										  AND NF.F1_FORNECE  = NFI.D1_FORNECE "  +CRLF
    _cQuery += " 					 										  AND NF.F1_LOJA     = NFI.D1_LOJA "  +CRLF
    _cQuery += " 					 										  AND NF.D_E_L_E_T_  <> '*' "  +CRLF
    _cQuery += " 					  INNER JOIN PROTHEUS.SA2010				 F ON F.A2_COD       = NF.F1_FORNECE "  +CRLF
    _cQuery += " 					 										  AND F.A2_LOJA      = NF.F1_LOJA "  +CRLF
    _cQuery += " 					 										  AND F.D_E_L_E_T_   <> '*' "  +CRLF 
    _cQuery += " 					  INNER JOIN PROTHEUS.SE4010				CP ON CP.E4_CODIGO   = A.C7_COND "  +CRLF
    _cQuery += " 					 										  AND CP.D_E_L_E_T_  <> '*'  "  +CRLF  
    _cQuery += " 					   LEFT JOIN PROTHEUS.SY1010			    GC ON GC.Y1_COD      = A.C7_COMPRA "  +CRLF
    _cQuery += " 					 									      AND GC.D_E_L_E_T_   <> '*' "  +CRLF
    _cQuery += " 					   LEFT JOIN "  +CRLF 
    _cQuery += "	(SELECT P_PRODUTO "  +CRLF
    _cQuery += "    , P_FILIAL "  +CRLF
    _cQuery += "    , NUM_PEDIDO "  +CRLF
    _cQuery += "    , NUM_PEDIDO_PENULTIMO "  +CRLF
    _cQuery += "     , MAX(C7_PRECO)   OVER(PARTITION BY P_FILIAL, P_PRODUTO)  AS P_VALOR_ULTIMO "  +CRLF
    _cQuery += "     , MAX(C7_EMISSAO) OVER(PARTITION BY P_FILIAL, P_PRODUTO)  AS P_DT_EMISSAO_ULTIMO "  +CRLF
    _cQuery += "     , P_VALOR_PENULTIMO "  +CRLF
    _cQuery += "    , P_DT_EMISSAO_PENULTIMA "  +CRLF
    _cQuery += "  FROM (SELECT C7.C7_PRODUTO								   AS P_PRODUTO "  +CRLF
    _cQuery += "             , C7.C7_FILIAL								   AS P_FILIAL "  +CRLF
    _cQuery += "             , C7.C7_NUM									   AS NUM_PEDIDO "  +CRLF
    _cQuery += "            , MAX(C7.C7_NUM)     OVER(PARTITION BY C7.C7_FILIAL, C7.C7_PRODUTO)		   AS MAX_PEDIDO "  +CRLF
    _cQuery += "             , C7.C7_PRECO "  +CRLF			   
    _cQuery += "             , C7.C7_EMISSAO	 "  +CRLF	   
    _cQuery += "            , LAG(C7.C7_NUM)     OVER(PARTITION BY C7.C7_FILIAL, C7.C7_PRODUTO ORDER BY C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_NUM) AS NUM_PEDIDO_PENULTIMO "  +CRLF
    _cQuery += "            , LAG(C7.C7_PRECO)   OVER(PARTITION BY C7.C7_FILIAL, C7.C7_PRODUTO ORDER BY C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_NUM) AS P_VALOR_PENULTIMO "  +CRLF
    _cQuery += "            , LAG(C7.C7_EMISSAO) OVER(PARTITION BY C7.C7_FILIAL, C7.C7_PRODUTO ORDER BY C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_NUM) AS P_DT_EMISSAO_PENULTIMA "  +CRLF
    _cQuery += "          FROM PROTHEUS.SC7010 C7 "  +CRLF
    _cQuery += "        WHERE C7.C7_QUJE >= C7_QUANT "  +CRLF
    _cQuery += "           AND C7.C7_ZREJAPR <> 'S' "  +CRLF
    _cQuery += "           AND C7.C7_PRODUTO >= '500000' "  +CRLF
    _cQuery += "           AND C7.D_E_L_E_T_ <> '*'  "  +CRLF
    _cQuery += "       ) "  +CRLF
    _cQuery += " WHERE NUM_PEDIDO = MAX_PEDIDO)   UPC ON UPC.P_PRODUTO   = P.B1_COD "  +CRLF
    _cQuery += " 					              AND UPC.P_FILIAL    = R.M0_CODFIL  AND UPC.P_DT_EMISSAO_ULTIMO < A.C7_EMISSAO "  +CRLF
    _cQuery += "								  AND UPC.P_DT_EMISSAO_ULTIMO <> UPC.P_DT_EMISSAO_PENULTIMA "  +CRLF
    _cQuery += " 					  WHERE P.B1_COD >=  '500000'  "  +CRLF
    _cQuery += " 					    AND A.D_E_L_E_T_ <> '*' ) "  +CRLF


	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),       " COD_FILIAL IN " + _cCODFILIA	                                               )	// OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),         " DATA_ENTRADA_NF_FILTRO  BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " )	// OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS

	If Empty( cComprador )
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", cComprador ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( COD_COMPRADOR_FILTRO IS NULL OR COD_COMPRADOR_FILTRO IN " + cComprador + " )"            )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   COD_COMPRADOR_FILTRO IN " + cComprador	                                               )	
	Endif

	_cQuery += U_WhereAnd(!empty(_aRet[5] ),         " COD_FORNECEDOR BETWEEN '"          + _aRet[3] + "' AND '" + _aRet[5] + "' " )	//NÃO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),         " LOJA_FORNECEDOR BETWEEN '"         + _aRet[4] + "' AND '" + _aRet[6] + "' " )	// NÃO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),         " COD_PRODUTO BETWEEN '"             + _aRet[7] + "' AND '" + _aRet[8] + "' " )	// NÃO OBRIGATORIO

	If Empty( cCodTipPro )
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"     )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   COD_TIPO_PRODUTO IN "  + cCodTipPro                                       )	
	Endif

	_cQuery += "	ORDER BY COD_FILIAL "	+CRLF	
	_cQuery += "			,DATA_ENTRADA_NF "	+CRLF

	aAdd(_aParambox,{1,"Códigos de compradores : "		,""})
	aAdd(_aRet, Iif(Empty(cComprador),"Todos",cComprador))

	aAdd(_aParambox,{1,"Tipos de Produtos : "			,""})
	aAdd(_aRet, Iif(Empty(cCodTipPro),"Todos",cCodTipPro))

	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
