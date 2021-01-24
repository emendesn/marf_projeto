#include "totvs.ch" 
/*/{Protheus.doc} MGF34R26 

@description
	Listar mercadoria em tânsito	

	O relatório será desenvolvido a partir de uma querie dispobilizada pela equipe de BI, onde será adaptada para utilização no Protheus. 
	
	Não será utilizada View para esse relatório devido ao tamanho da massa de dados, e demora no processamento conforme informado 
	  pela Priscila BI.  
	
Obs.: Querie foi montanda conforme passado pelo BI. Não realizado alterações para manter histórico.

@author Henrique Vidal Santos
@since 07/11/2019

@version P12.1.017
@country Brasil
@language Português
@type Function  
@table 
	SF1 - Cabeçalho de entrada                      
	SF2 - Cabeçalho de saída                      
	SC5 - Pedido de vendas   
	SB1 - Produtos

@param
@return
@menu
	Sigactb/Relatórios/Especificos/Mercadoria em Trânsito- MGF34R26.PRW 
/*/
User Function MGF34R26()
	 
	Private _aRet		:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl 	:= {}, _aCampoQry 	:= {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil	:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "CONTABILIDADE-Mercadoria em trânsito"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Mercadoria em trânsito"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Mercadoria em trânsito"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Mercadoria em trânsito"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	Aadd(_aCampoQry, {"F2_FILIAL"   ,	"EMP_ORIGEM"	,"Filial Origem"	,"","","","","",""})
	Aadd(_aCampoQry, {"M0_FILIAL"	,	"DESCRI_EMP"	,"Descrição"		,"","","","","",""})
	Aadd(_aCampoQry, {"C5_FILIAL"	,	"EMP_DESTIN"	,"Filial Destinatário"		,"","","","","",""})
	Aadd(_aCampoQry, {"M0_FILIAL"	,	"DESCR_DEST"	,"Descrição"		,"","","","","",""})
	Aadd(_aCampoQry, {"F1_DOC"		,	"NUM_NOTA"		,"Nota"				,"","","","","",""})
	Aadd(_aCampoQry, {"F1_SERIE"	,	"SERIE"			,"Série"			,"","","","","",""})
	Aadd(_aCampoQry, {""			,	"EMISSAO_NF"	,"Emissão Nf"		,"C",10,0,"","",""})
	Aadd(_aCampoQry, {""			,	"DIGIT_ENTR"	,"Data Digitação"	,"C",10,0,"","",""})
	Aadd(_aCampoQry, {"C5_NUM"		,	"NUM_PEDIDO"	,"Numero Pedido"	,"","","","","",""})
	Aadd(_aCampoQry, {""			,	"EMISSAOPED"	,"Emissão Pedido"	,"C",10,0,"","",""})
	Aadd(_aCampoQry, {"B1_COD"		,	"COD_ITEM"		,"Codigo do item"	,"","","","","",""})
	Aadd(_aCampoQry, {"B1_DESC"		,	"DESC_ITEM"		,"Item"				,"","","","","",""})
	Aadd(_aCampoQry, {"CT1_CONTA "	,	"CONTA_PROD"	,"Conta Contábil"	,"","","","","",""})
	Aadd(_aCampoQry, {"D2_PRCVEN"	,	"VALOR_UNIT"	,"Valor Unitário"	,"","","","","",""})
	Aadd(_aCampoQry, {"D2_TOTAL"	,	"VALOR_ITEM"	,"Valor do item"	,"","","","","",""})
	Aadd(_aCampoQry, {"BM_DESC"		,	"GRPESTOQUE"	,"Grupo Estoque"	,"","","","","",""})
	Aadd(_aCampoQry, {"D2_CF"		,	"COD_FISCAL"	,"Código Fiscal"	,"","","","","",""})
	Aadd(_aCampoQry, {"D2_QUANT"	,	"QTDE_ITEM"		,"Quantidade"		,"","","","","",""})
	Aadd(_aCampoQry, {"F2_BASEICM"	,	"BASE_ICMS"		,"Base Icms"		,"","","","","",""})
	Aadd(_aCampoQry, {"D2_VALICM"	,	"VALOR_ICMS"	,"Valor Icms"		,"","","","","",""})
	Aadd(_aCampoQry, {"X5_DESCRI"	,	"CODFISCAL"		,"Descrição Fiscal"	,"","","","","",""})
	Aadd(_aCampoQry, {"F2_CHVNFE"	,	"CHAVE_SEFAZ"	,"Chave Nfe"		,"","","","","",""})
	Aadd(_aCampoQry, {"FT_OBSERV"	,	"OBSERVACAO"	,"Observação"		,"","","","","",""})

	aAdd(_aParambox,{1,"Emissão De:"		,Ctod("")						,""		,""	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Emissão Ate:"		,Ctod("")						,""		,""	,""		,,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) 
		 Return  
	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		  
	
	If Empty(_aSelFil) 
		 Return 
	Endif
	
	_cCODFILIA	:= U_Array_In(_aSelFil)

 	cQryTipPro	:= "SELECT ' ' as X5_CHAVE, 'Sem Código Fiscal' as X5_DESCRI FROM DUAL UNION ALL "
	cQryTipPro	+= "SELECT DISTINCT X5_CHAVE, X5_DESCRI"
	cQryTipPro  += "  FROM " + RetSqlName("SX5")  + " TMPSX5 "
	cQryTipPro	+= "  WHERE	TMPSX5.X5_TABELA  = '13' " 
	cQryTipPro	+= "  AND   TMPSX5.D_E_L_E_T_ = ' '  " 
	cQryTipPro	+= "  AND 	TMPSX5.X5_CHAVE IN(" + GetNewPar("MGF_34R26", "'5151','5152','5155','5156','5208','5209','5409','5409','5552','5557','6151','6152','6155','6156','6408','6408','6409','6552','6557','5949'")  + ")"
	cQryTipPro	+= "  ORDER BY X5_CHAVE"
	aCpoTipPro	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")		,TamSx3("X5_CHAVE")[1]		} ,;
	aCpoTipPro	:=		{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI")	,TamSx3("X5_DESCRI")[1] }	} 
	cTitTipPro	:= "Marque os Tipos de Produtos à serem listados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 	
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	QryMaster() 	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

Return 

Static Function QryMaster() 

	_cQuery := " SELECT T.EMPRESA_ORIGEM AS EMP_ORIGEM  "  +CRLF
	_cQuery += " 		 , T.DESC_EMPRESA_ORIGEM 	AS DESCRI_EMP "  +CRLF
	_cQuery += " 		 , T.EMPRESA_DESTINO 		AS EMP_DESTIN "  +CRLF
	_cQuery += " 		 , T.DESC_EMPRESA_DESTINO 	AS DESCR_DEST "  +CRLF
	_cQuery += " 		 , T.NUM_NOTA							  "  +CRLF
	_cQuery += " 		 , T.SERIE 					              "  +CRLF
	_cQuery += " 		 , T.DATA_EMISSAO_NF 		AS EMISSAO_NF "  +CRLF
	_cQuery += " 		 , T.DATA_DIGIT_ENTRADA 	AS DIGIT_ENTR "  +CRLF
	_cQuery += " 		 , T.NUM_PEDIDO 			              "  +CRLF
	_cQuery += " 		 , T.EMISSAO_PEDIDO 		AS EMISSAOPED "  +CRLF
	_cQuery += " 		 , T.COD_ITEM 				              "  +CRLF
	_cQuery += " 		 , T.DESC_ITEM 							  "  +CRLF
	_cQuery += " 		 , T.CONTA_CONTABIL_PROD 	AS CONTA_PROD "  +CRLF
	_cQuery += " 		 , T.VALOR_UNITARIO 		AS VALOR_UNIT "  +CRLF
	_cQuery += " 		 , T.VALOR_ITEM 			AS VALOR_ITEM "  +CRLF
	_cQuery += " 		 , T.GRUPO_ESTOQUE 			AS GRPESTOQUE "  +CRLF
	_cQuery += " 		 , T.CODIGO_FISCAL 			AS COD_FISCAL "  +CRLF
	_cQuery += " 		 , T.QTDE_ITEM 							  "  +CRLF
	_cQuery += " 		 , T.BASE_CALC_ICMS 		AS BASE_ICMS  "  +CRLF
	_cQuery += " 		 , T.VALOR_ICMS 						  "  +CRLF
	_cQuery += " 		 , T.DESC_CODIGO_FISCAL 	AS CODFISCAL  "  +CRLF
	_cQuery += " 		 , T.CHAVE_SEFAZ  						  "  +CRLF
	_cQuery += " 		 , T.OBSERVACAO 						  "  +CRLF
	_cQuery += " FROM (				 "  +CRLF
	_cQuery += " 			SELECT DISTINCT NFS.F2_FILIAL                   AS EMPRESA_ORIGEM "  +CRLF
	_cQuery += " 						, EMPO.M0_FILIAL                          AS DESC_EMPRESA_ORIGEM "  +CRLF
	_cQuery += " 						, LTRIM(RTRIM(ED.M0_CODFIL))              AS EMPRESA_DESTINO	 "  +CRLF
	_cQuery += " 						, ED.M0_FILIAL                            AS DESC_EMPRESA_DESTINO "  +CRLF
	_cQuery += " 						, NFS.F2_DOC                              AS NUM_NOTA			 "  +CRLF
	_cQuery += " 						, NFS.F2_SERIE                            AS SERIE				 "  +CRLF
	_cQuery += " 						, ENTRADA.F1_LOJA "  +CRLF
	_cQuery += " 						, TO_CHAR( "  +CRLF
	_cQuery += " 												TO_DATE( "  +CRLF
	_cQuery += " 																CASE "  +CRLF 
	_cQuery += " 																WHEN NFS.F2_EMISSAO = ' ' "  +CRLF
	_cQuery += " 																THEN NULL "  +CRLF
	_cQuery += " 																ELSE NFS.F2_EMISSAO "  +CRLF
	_cQuery += " 																END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 														), 'DD/MM/YYYY' "  +CRLF
	_cQuery += " 									)	AS DATA_EMISSAO_NF "  +CRLF
	_cQuery += " 						, TO_CHAR( "  +CRLF
	_cQuery += " 												TO_DATE( "  +CRLF
	_cQuery += " 															CASE "  +CRLF 
	_cQuery += " 															WHEN ENTRADA.F1_DTDIGIT = ' ' "  +CRLF
	_cQuery += " 															THEN NULL "  +CRLF
	_cQuery += " 															ELSE ENTRADA.F1_DTDIGIT "  +CRLF
	_cQuery += " 															END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 														), 'DD/MM/YYYY' "  +CRLF
	_cQuery += " 									)   AS DATA_DIGIT_ENTRADA "  +CRLF
	_cQuery += " 						, PED.C5_NUM                              AS NUM_PEDIDO	 "  +CRLF
	_cQuery += " 						, TO_CHAR( "  +CRLF
	_cQuery += " 												TO_DATE( "  +CRLF
	_cQuery += " 															CASE "  +CRLF 
	_cQuery += " 															WHEN PED.C5_EMISSAO = ' ' "  +CRLF
	_cQuery += " 															THEN NULL "  +CRLF
	_cQuery += " 															ELSE PED.C5_EMISSAO "  +CRLF
	_cQuery += " 															END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 														), 'DD/MM/YYYY'	 "  +CRLF
	_cQuery += " 								)	AS EMISSAO_PEDIDO "  +CRLF
	_cQuery += " 						, SB1.B1_COD                              AS COD_ITEM "  +CRLF
	_cQuery += " 						, SB1.B1_DESC                             AS DESC_ITEM "  +CRLF
	_cQuery += " 						, CONTA.CT1_CONTA                         AS CONTA_CONTABIL_PROD "  +CRLF
	_cQuery += " 						, NFSI.D2_PRCVEN                          AS VALOR_UNITARIO	 "  +CRLF
	_cQuery += " 						, (    "
	_cQuery += " 							( "  +CRLF
	_cQuery += " 								CASE "  +CRLF
	_cQuery += " 									WHEN NFS.F2_TIPO = 'I' "  +CRLF
	_cQuery += " 									THEN 0 "  +CRLF
	_cQuery += " 									ELSE COALESCE(NFSI.D2_TOTAL,0) "  +CRLF
	_cQuery += " 								END "  +CRLF
	_cQuery += " 							)        "    
	_cQuery += " 							+   COALESCE(NFSI.D2_SEGURO,0) "  +CRLF 
	_cQuery += " 							+   COALESCE(NFSI.D2_VALFRE,0) "  +CRLF
	_cQuery += " 							+   COALESCE(NFSI.D2_DESPESA,0) "  +CRLF
	_cQuery += " 							+   ( "  +CRLF
	_cQuery += " 								CASE "  +CRLF
	_cQuery += " 									WHEN NFS.F2_TIPO = 'I' "  +CRLF
	_cQuery += " 									THEN 0 "  +CRLF
	_cQuery += " 									ELSE COALESCE(NFSI.D2_ICMSRET,0) "  +CRLF
	_cQuery += " 									END "  +CRLF
	_cQuery += " 								) "  +CRLF
	_cQuery += " 						)- COALESCE(NFSI.D2_DESCON,0)           AS VALOR_ITEM "  +CRLF
	_cQuery += " 					, GPP.BM_DESC                             AS GRUPO_ESTOQUE "  +CRLF
	_cQuery += " 					,(		SELECT CFOP.X5_CHAVE "  +CRLF
	_cQuery += " 							FROM  " + RetSqlName("SX5") + " CFOP "  +CRLF
	_cQuery += " 							WHERE CFOP.X5_CHAVE     = NFSI.D2_CF "
	_cQuery += " 							AND CFOP.X5_TABELA    = '13'  "
	_cQuery += " 							AND CFOP.X5_FILIAL    = '      ' "  +CRLF
	_cQuery += " 							AND CFOP.D_E_L_E_T_   <> '*' "  +CRLF
	_cQuery += " 					) AS CODIGO_FISCAL "  +CRLF
	_cQuery += " 					, NFSI.D2_QUANT                           AS QTDE_ITEM  "  +CRLF
	_cQuery += " 					, NFS.F2_BASEICM                          AS BASE_CALC_ICMS "  +CRLF 
	_cQuery += " 					, NFSI.D2_VALICM                          AS VALOR_ICMS "  +CRLF
	_cQuery += " 					,(		SELECT CFOP.X5_DESCRI	
	_cQuery += " 							FROM  " + RetSqlName("SX5") + " CFOP "  +CRLF
	_cQuery += " 							WHERE CFOP.X5_CHAVE     = NFSI.D2_CF "  +CRLF 
	_cQuery += " 							AND CFOP.X5_TABELA    = '13'  "
	_cQuery += " 							AND CFOP.X5_FILIAL    = '      ' "  +CRLF
	_cQuery += " 							AND CFOP.D_E_L_E_T_   <> '*' "  +CRLF
	_cQuery += " 					) AS DESC_CODIGO_FISCAL "  +CRLF
	_cQuery += " 					, NFS.F2_CHVNFE                           AS CHAVE_SEFAZ  "  +CRLF
	_cQuery += " 					, CL.A1_COD "  +CRLF
	_cQuery += " 					, CL.A1_LOJA "
	_cQuery += " 					, FORN.A2_COD "  +CRLF
	_cQuery += " 					, FORN.A2_LOJA "  +CRLF
	_cQuery += " 					, LFI.FT_OBSERV							              AS OBSERVACAO "  +CRLF
	_cQuery += " 			FROM  " + RetSqlName("SF2") + "             NFS "  +CRLF
	_cQuery += " 			INNER JOIN  SYS_COMPANY     EMPO ON EMPO.M0_CODFIL      = NFS.F2_FILIAL "  +CRLF
	_cQuery += " 						AND EMPO.D_E_L_E_T_     <> '*' "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SD2") + "  		NFSI ON NFS.F2_DOC          = NFSI.D2_DOC  "  +CRLF
	_cQuery += " 						AND NFS.F2_SERIE        = NFSI.D2_SERIE    "  +CRLF
	_cQuery += " 						AND NFS.F2_FILIAL       = NFSI.D2_FILIAL   "  +CRLF
	_cQuery += " 						AND NFS.F2_CLIENTE      = NFSI.D2_CLIENTE  "  +CRLF
	_cQuery += " 						AND NFS.F2_LOJA         = NFSI.D2_LOJA     "  +CRLF
	_cQuery += " 						AND NFS.F2_EMISSAO      = NFSI.D2_EMISSAO  "  +CRLF
	_cQuery += " 						AND NFSI.D_E_L_E_T_     <> '*' "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SC5") + "      PED ON PED.C5_FILIAL       = NFS.F2_FILIAL "  +CRLF
	_cQuery += " 						AND PED.C5_NUM          = NFSI.D2_PEDIDO "  +CRLF
	_cQuery += " 						AND PED.D_E_L_E_T_      <> '*'  "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SA1") + "    	CL ON CL.A1_COD           = NFS.F2_CLIENTE "  +CRLF
	_cQuery += " 						AND CL.A1_LOJA          = NFS.F2_LOJA "  +CRLF
	_cQuery += " 						AND CL.D_E_L_E_T_       <> '*' "  +CRLF
	_cQuery += " 						AND CL.A1_NOME          IN ('MARFRIG GLOBAL FOODS S A','MARFRIG GLOBAL FOODS S.A.', 'MARFRIG GLOBAL FOODS SA', 'PAMPEANO ALIMENTOS S/A', 'PAMPEANO ALIMENTOS SA', 'PAMPEANO ALIMENTOS S.A.') "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SB1") + "           SB1 ON NFSI.D2_COD         = SB1.B1_COD  "  +CRLF
	_cQuery += " 						AND SB1.D_E_L_E_T_      <>  '*' "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("CT1") + "          CONTA ON CONTA.CT1_CONTA     = SB1.B1_CONTA "  +CRLF
	_cQuery += " 						AND CONTA.CT1_FILIAL    = '      ' "  +CRLF
	_cQuery += " 						AND CONTA.D_E_L_E_T_    <> '*'   "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SBM") + "            GPP ON GPP.BM_GRUPO        = SB1.B1_GRUPO "  +CRLF
	_cQuery += " 						AND GPP.D_E_L_E_T_      <> '*'     "  +CRLF 
	_cQuery += " 			LEFT JOIN  SYS_COMPANY        ED ON ED.M0_CGC           = CL.A1_CGC "  +CRLF
	_cQuery += " 						AND ED.D_E_L_E_T_       <>  '*'     "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SA2") + "           FORN ON FORN.A2_CGC         = EMPO.M0_CGC "  +CRLF
	_cQuery += " 						AND FORN.D_E_L_E_T_      <>  '*'    "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SF1") + "        ENTRADA ON ENTRADA.F1_DOC      = NFSI.D2_DOC  "  +CRLF
	_cQuery += " 			            AND ENTRADA.F1_SERIE    = NFSI.D2_SERIE "  +CRLF
	_cQuery += " 			            AND ENTRADA.F1_FILIAL   = ED.M0_CODFIL  "  +CRLF
	_cQuery += " 			            AND ENTRADA.D_E_L_E_T_  <> '*'  "  +CRLF
	_cQuery += " 						AND ENTRADA.F1_FORNECE  = FORN.A2_COD "  +CRLF
	_cQuery += " 						AND ENTRADA.F1_LOJA     = FORN.A2_LOJA "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SD1") + "        ENTITEM ON ENTITEM.D1_DOC      = ENTRADA.F1_DOC  "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_SERIE    = ENTRADA.F1_SERIE "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_FILIAL   = ENTRADA.F1_FILIAL "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_EMISSAO	= ENTRADA.F1_EMISSAO "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_FORNECE  = ENTRADA.F1_FORNECE  "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_LOJA     = ENTRADA.F1_LOJA  "  +CRLF
	_cQuery += " 		 				AND ENTITEM.D_E_L_E_T_  <> '*'   "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_TIPO     = 'D'  "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_CF			  IN ('1151','1152','1155','1156','1208','1209','1408','1409','1552','1557','2151','2152','2155','2156','2408','2409','2552','2557','1949','2949') "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SFT") + "					   LFI ON LFI.FT_FILIAL       = ENTITEM.D1_FILIAL "  +CRLF
	_cQuery += " 						AND LFI.FT_TIPOMOV      = 'E' "  +CRLF
	_cQuery += " 						AND LFI.FT_SERIE        = ENTITEM.D1_SERIE "  +CRLF
	_cQuery += " 						AND LFI.FT_NFISCAL      = ENTITEM.D1_DOC "  +CRLF
	_cQuery += " 						AND LFI.FT_CLIEFOR      = ENTITEM.D1_FORNECE "  +CRLF
	_cQuery += " 						AND LFI.FT_LOJA         = ENTITEM.D1_LOJA "  +CRLF
	_cQuery += " 						AND LFI.FT_ITEM         = ENTITEM.D1_ITEM "  +CRLF
	_cQuery += " 						AND LFI.FT_PRODUTO      = ENTITEM.D1_COD "  +CRLF
	_cQuery += " 						AND LFI.R_E_C_D_E_L_    = 0 "  +CRLF
	_cQuery += " 		WHERE NFS.F2_FILIAL              NOT LIKE '02%' "  +CRLF

	If !Empty(_cCODFILIA) 
		_cQuery += " 	AND NFS.F2_FILIAL IN " + _cCODFILIA  + " "
	EndIf 

	_cQuery += "		AND NFS.D_E_L_E_T_             <>'*' "  +CRLF
	_cQuery += " 		AND NFSI.D2_TIPO               <> 'D' "  +CRLF
	_cQuery += " 		AND NFS.F2_EMISSAO             BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  +CRLF
	_cQuery += " 		AND CL.A1_LOJA                 IS NOT NULL "  +CRLF
	_cQuery += " 	   	AND (	ENTRADA.F1_DTDIGIT     > '" + _aRet[2] + "'  "  +CRLF
	_cQuery += " 		      	OR ENTRADA.F1_DTDIGIT     IS NULL  "  +CRLF
	_cQuery += " 				OR ENTRADA.F1_STATUS			<> 'A' "  +CRLF
	_cQuery += " 			) 		  "  +CRLF
	_cQuery += " 	   	AND NFSI.D2_CF                 IN ('5151','5152','5155','5156','5208','5209','5409','5409','5552','5557','6151','6152','6155','6156','6408','6408','6409','6552','6557','5949') "  +CRLF
	_cQuery += " ) T "  +CRLF
	_cQuery += " LEFT JOIN	( "  +CRLF

	_cQuery += " 				SELECT DISTINCT A.D1_NFORI "  +CRLF
	_cQuery += "      				, A.D1_SERIORI "  +CRLF
	_cQuery += "      				, A.D1_FILORI "  +CRLF
	_cQuery += "   					FROM " + RetSqlName("SD1") + " A "  +CRLF
	_cQuery += "   					WHERE A.R_E_C_D_E_L_ = 0 "  +CRLF
	_cQuery += "   					AND A.D1_EMISSAO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  +CRLF
	_cQuery += "   					AND A.D1_NFORI <> ' ' "  +CRLF
	_cQuery += "  					AND ( A.D1_CF LIKE '%208%' OR A.D1_CF LIKE '%209%') "  +CRLF
	_cQuery += " 			) DEV "  +CRLF
	_cQuery += "  			ON DEV.D1_NFORI			= T.NUM_NOTA "  +CRLF
	_cQuery += " 			AND DEV.D1_SERIORI		= T.SERIE    "  +CRLF
	_cQuery += " 			AND DEV.D1_FILORI		= T.EMPRESA_ORIGEM   "  +CRLF

	_cQuery += " WHERE T.EMPRESA_ORIGEM <> T.EMPRESA_DESTINO "  +CRLF
	_cQuery += " AND DEV.D1_NFORI			IS NULL "  +CRLF
	If !Empty(cCodTipPro) 
		_cQuery += " AND T.CODIGO_FISCAL IN " + cCodTipPro +CRLF
	EndIf 

	_cQuery += " UNION "  +CRLF

	_cQuery += " SELECT T.EMPRESA_ORIGEM AS EMP_ORIGEM  "  +CRLF
	_cQuery += " 		 , T.DESC_EMPRESA_ORIGEM 	AS DESCRI_EMP "  +CRLF
	_cQuery += " 		 , T.EMPRESA_DESTINO 		AS EMP_DESTIN "  +CRLF
	_cQuery += " 		 , T.DESC_EMPRESA_DESTINO 	AS DESCR_DEST "  +CRLF
	_cQuery += " 		 , T.NUM_NOTA							  "  +CRLF
	_cQuery += " 		 , T.SERIE 					              "  +CRLF
	_cQuery += " 		 , T.DATA_EMISSAO_NF 		AS EMISSAO_NF "  +CRLF
	_cQuery += " 		 , T.DATA_DIGIT_ENTRADA 	AS DIGIT_ENTR "  +CRLF
	_cQuery += " 		 , T.NUM_PEDIDO 			              "  +CRLF
	_cQuery += " 		 , T.EMISSAO_PEDIDO 		AS EMISSAOPED "  +CRLF
	_cQuery += " 		 , T.COD_ITEM 				              "  +CRLF
	_cQuery += " 		 , T.DESC_ITEM 							  "  +CRLF
	_cQuery += " 		 , T.CONTA_CONTABIL_PROD 	AS CONTA_PROD "  +CRLF
	_cQuery += " 		 , T.VALOR_UNITARIO 		AS VALOR_UNIT "  +CRLF
	_cQuery += " 		 , T.VALOR_ITEM 			AS VALOR_ITEM "  +CRLF
	_cQuery += " 		 , T.GRUPO_ESTOQUE 			AS GRPESTOQUE "  +CRLF
	_cQuery += " 		 , T.CODIGO_FISCAL 			AS COD_FISCAL "  +CRLF
	_cQuery += " 		 , T.QTDE_ITEM 							  "  +CRLF
	_cQuery += " 		 , T.BASE_CALC_ICMS 		AS BASE_ICMS  "  +CRLF
	_cQuery += " 		 , T.VALOR_ICMS 						  "  +CRLF
	_cQuery += " 		 , T.DESC_CODIGO_FISCAL 	AS CODFISCAL  "  +CRLF
	_cQuery += " 		 , T.CHAVE_SEFAZ  						  "  +CRLF
	_cQuery += " 		 , T.OBSERVACAO 						  "  +CRLF
	_cQuery += " FROM	( "  +CRLF
	_cQuery += " 			SELECT DISTINCT NFS.F2_FILIAL                   AS EMPRESA_ORIGEM "  +CRLF
	_cQuery += " 				, EMPO.M0_FILIAL                          AS DESC_EMPRESA_ORIGEM "  +CRLF
	_cQuery += " 				, LTRIM(RTRIM(ED.M0_CODFIL))              AS EMPRESA_DESTINO "  +CRLF
	_cQuery += " 				, ED.M0_FILIAL                            AS DESC_EMPRESA_DESTINO "  +CRLF
	_cQuery += " 				, NFS.F2_DOC                              AS NUM_NOTA "  +CRLF
	_cQuery += " 				, NFS.F2_SERIE                            AS SERIE "  +CRLF
	_cQuery += " 				, ENTRADA.F1_LOJA "  +CRLF
	_cQuery += " 				, TO_CHAR( "  +CRLF
	_cQuery += " 							TO_DATE( "  +CRLF
	_cQuery += " 										CASE  "  +CRLF
	_cQuery += " 										WHEN NFS.F2_EMISSAO = ' ' "  +CRLF
	_cQuery += " 										THEN NULL "  +CRLF
	_cQuery += " 										ELSE NFS.F2_EMISSAO "  +CRLF
	_cQuery += " 										END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 									), 'DD/MM/YYYY' "  +CRLF
	_cQuery += " 						 )  AS DATA_EMISSAO_NF "  +CRLF
	_cQuery += " 				, TO_CHAR( "  +CRLF
	_cQuery += " 							TO_DATE( "  +CRLF
	_cQuery += " 										CASE  "  +CRLF
	_cQuery += " 										WHEN ENTRADA.F1_DTDIGIT = ' ' "  +CRLF
	_cQuery += " 										THEN NULL "  +CRLF
	_cQuery += " 										ELSE ENTRADA.F1_DTDIGIT "  +CRLF
	_cQuery += " 										END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 									), 'DD/MM/YYYY' "  +CRLF
	_cQuery += " 					 	  )                              AS DATA_DIGIT_ENTRADA "  +CRLF
	_cQuery += " 				, PED.C5_NUM                              AS NUM_PEDIDO "  +CRLF
	_cQuery += " 				, TO_CHAR( "  +CRLF
	_cQuery += " 							TO_DATE( "  +CRLF
	_cQuery += " 										CASE  "  +CRLF
	_cQuery += " 										WHEN PED.C5_EMISSAO = ' ' "  +CRLF
	_cQuery += " 										THEN NULL "  +CRLF
	_cQuery += " 										ELSE PED.C5_EMISSAO "  +CRLF
	_cQuery += " 										END, 'YYYY/MM/DD' "  +CRLF
	_cQuery += " 						 			), 'DD/MM/YYYY' "  +CRLF
	_cQuery += " 							)                              AS EMISSAO_PEDIDO "  +CRLF
	_cQuery += " 				, SB1.B1_COD                              AS COD_ITEM "  +CRLF
	_cQuery += " 				, SB1.B1_DESC                             AS DESC_ITEM "  +CRLF
	_cQuery += " 				, CONTA.CT1_CONTA                         AS CONTA_CONTABIL_PROD "  +CRLF
	_cQuery += " 				, NFSI.D2_PRCVEN                          AS VALOR_UNITARIO "  +CRLF
	_cQuery += " 				, (     "  +CRLF
	_cQuery += " 					( "  +CRLF
	_cQuery += " 						CASE "  +CRLF
	_cQuery += " 						WHEN NFS.F2_TIPO = 'I' "  +CRLF
	_cQuery += " 						THEN 0 "  +CRLF
	_cQuery += " 						ELSE COALESCE(NFSI.D2_TOTAL,0) "  +CRLF
	_cQuery += " 						END "  +CRLF
	_cQuery += " 					)             "  +CRLF
	_cQuery += " 					+   COALESCE(NFSI.D2_SEGURO,0)  "  +CRLF
	_cQuery += " 					+   COALESCE(NFSI.D2_VALFRE,0) "  +CRLF
	_cQuery += " 					+   COALESCE(NFSI.D2_DESPESA,0) "  +CRLF
	_cQuery += " 					+   ( "  +CRLF
	_cQuery += " 							CASE "  +CRLF
	_cQuery += " 								WHEN NFS.F2_TIPO = 'I' "  +CRLF
	_cQuery += " 								THEN 0 "  +CRLF
	_cQuery += " 								ELSE COALESCE(NFSI.D2_ICMSRET,0) "  +CRLF
	_cQuery += " 								END "  +CRLF
	_cQuery += " 						) "  +CRLF
	_cQuery += " 				)- COALESCE(NFSI.D2_DESCON,0)           AS VALOR_ITEM "  +CRLF
	_cQuery += " 				, GPP.BM_DESC                             AS GRUPO_ESTOQUE "  +CRLF
	_cQuery += " 				,(		SELECT CFOP.X5_CHAVE "  +CRLF
	_cQuery += " 						FROM  " + RetSqlName("SX5") + " CFOP "  +CRLF
	_cQuery += " 						WHERE CFOP.X5_CHAVE     = NFSI.D2_CF  "  +CRLF
	_cQuery += " 						AND CFOP.X5_TABELA    = '13'   "  +CRLF
	_cQuery += " 						AND CFOP.X5_FILIAL    = '      ' "  +CRLF
	_cQuery += " 						AND CFOP.D_E_L_E_T_   <> '*' "  +CRLF
	_cQuery += " 				)	AS CODIGO_FISCAL "  +CRLF
	_cQuery += " 				, NFSI.D2_QUANT                           AS QTDE_ITEM  "  +CRLF
	_cQuery += " 				, NFS.F2_BASEICM                          AS BASE_CALC_ICMS  "  +CRLF
	_cQuery += " 				, NFSI.D2_VALICM                          AS VALOR_ICMS "  +CRLF
	_cQuery += " 				,(		SELECT CFOP.X5_DESCRI "  +CRLF
	_cQuery += " 						FROM  " + RetSqlName("SX5") + " CFOP "  +CRLF
	_cQuery += " 						WHERE CFOP.X5_CHAVE     = NFSI.D2_CF  "  +CRLF
	_cQuery += " 						AND CFOP.X5_TABELA    = '13'   "  +CRLF
	_cQuery += " 						AND CFOP.X5_FILIAL    = '      ' "  +CRLF
	_cQuery += " 						AND CFOP.D_E_L_E_T_   <> '*' "  +CRLF
	_cQuery += " 				)	AS DESC_CODIGO_FISCAL "  +CRLF
	_cQuery += " 				, NFS.F2_CHVNFE                           AS CHAVE_SEFAZ  "  +CRLF
	_cQuery += "  				, LFI.FT_OBSERV							              AS OBSERVACAO "  +CRLF
	_cQuery += " 			FROM  " + RetSqlName("SF2") + "                NFS "  +CRLF
	_cQuery += " 			INNER JOIN  SYS_COMPANY     EMPO ON EMPO.M0_CODFIL      = NFS.F2_FILIAL "  +CRLF
	_cQuery += " 						AND EMPO.D_E_L_E_T_     <> '*' "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SD2") + "        NFSI ON NFS.F2_DOC          = NFSI.D2_DOC  "  +CRLF
	_cQuery += " 						AND NFS.F2_SERIE        = NFSI.D2_SERIE "  +CRLF   
	_cQuery += " 						AND NFS.F2_FILIAL       = NFSI.D2_FILIAL   "  +CRLF
	_cQuery += " 						AND NFS.F2_CLIENTE      = NFSI.D2_CLIENTE  "  +CRLF
	_cQuery += " 						AND NFS.F2_LOJA         = NFSI.D2_LOJA     "  +CRLF
	_cQuery += " 						AND NFS.F2_EMISSAO      = NFSI.D2_EMISSAO  "  +CRLF
	_cQuery += " 						AND NFSI.D_E_L_E_T_     <> '*' "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SC5") + "           PED ON PED.C5_FILIAL       = NFS.F2_FILIAL "  +CRLF
	_cQuery += " 						AND PED.C5_NUM          = NFSI.D2_PEDIDO "  +CRLF
	_cQuery += " 						AND PED.D_E_L_E_T_      <> '*'  "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SA2") + "            FO ON FO.A2_COD           = NFS.F2_CLIENTE "  +CRLF
	_cQuery += " 						AND FO.A2_LOJA          = NFS.F2_LOJA "  +CRLF
	_cQuery += " 						AND FO.D_E_L_E_T_       <> '*' "  +CRLF
	_cQuery += " 						AND FO.A2_NOME          IN ('MARFRIG GLOBAL FOODS S A','MARFRIG GLOBAL FOODS S.A.', 'MARFRIG GLOBAL FOODS SA', 'PAMPEANO ALIMENTOS S/A', 'PAMPEANO ALIMENTOS SA', 'PAMPEANO ALIMENTOS S.A.') "  +CRLF
	_cQuery += " 			INNER JOIN  " + RetSqlName("SB1") + "           SB1 ON NFSI.D2_COD         = SB1.B1_COD  "  +CRLF
	_cQuery += " 						AND SB1.D_E_L_E_T_      <>  '*' "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("CT1") + "          CONTA ON CONTA.CT1_CONTA     = SB1.B1_CONTA "  +CRLF
	_cQuery += " 						AND CONTA.CT1_FILIAL    = '      ' "  +CRLF
	_cQuery += " 						AND CONTA.D_E_L_E_T_    <> '*'   "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SBM") + "            GPP ON GPP.BM_GRUPO        = SB1.B1_GRUPO "  +CRLF
	_cQuery += " 						AND GPP.D_E_L_E_T_      <> '*'    "  +CRLF  
	_cQuery += " 			LEFT JOIN  SYS_COMPANY        ED ON ED.M0_CGC           = FO.A2_CGC "  +CRLF
	_cQuery += " 						AND ED.D_E_L_E_T_       <>  '*'     "  +CRLF
	_cQuery += "            LEFT JOIN  " + RetSqlName("SA1") + "             CL ON CL.A1_CGC           = ED.M0_CGC  "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SF1") + "        ENTRADA ON ENTRADA.F1_DOC      = NFSI.D2_DOC  "  +CRLF
	_cQuery += " 			            AND ENTRADA.F1_SERIE    = NFSI.D2_SERIE "  +CRLF
	_cQuery += " 			            AND ENTRADA.F1_FILIAL   = ED.M0_CODFIL  "  +CRLF
	_cQuery += " 						AND ENTRADA.F1_FORNECE  = CL.A1_COD "  +CRLF
	_cQuery += " 			            AND ENTRADA.D_E_L_E_T_  <> '*'   "  +CRLF
	_cQuery += " 						AND NFSI.D2_TIPO        = 'D'  "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SD1") + "        ENTITEM ON ENTITEM.D1_DOC      = ENTRADA.F1_DOC  "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_SERIE    = ENTRADA.F1_SERIE "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_FILIAL   = ENTRADA.F1_FILIAL "  +CRLF
	_cQuery += " 						AND ENTITEM.D1_EMISSAO	= ENTRADA.F1_EMISSAO "  +CRLF
	_cQuery += " 						AND ENTITEM.D_E_L_E_T_  <> '*'   "  +CRLF
	_cQuery += " 		 			  	AND ( "  +CRLF
	_cQuery += " 							    ENTITEM.D1_CF		LIKE '%208' "  +CRLF
	_cQuery += " 								OR  ENTITEM.D1_CF		LIKE '%209' "  +CRLF
	_cQuery += " 							) "  +CRLF
	_cQuery += " 			LEFT JOIN  " + RetSqlName("SFT") + "		 LFI ON LFI.FT_FILIAL       = ENTITEM.D1_FILIAL "  +CRLF
	_cQuery += " 						AND LFI.FT_TIPOMOV      = 'E' "  +CRLF
	_cQuery += " 						AND LFI.FT_SERIE        = ENTITEM.D1_SERIE "  +CRLF
	_cQuery += " 						AND LFI.FT_NFISCAL      = ENTITEM.D1_DOC "  +CRLF
	_cQuery += " 						AND LFI.FT_CLIEFOR      = ENTITEM.D1_FORNECE "  +CRLF
	_cQuery += " 						AND LFI.FT_LOJA         = ENTITEM.D1_LOJA "  +CRLF
	_cQuery += " 						AND LFI.FT_ITEM         = ENTITEM.D1_ITEM "  +CRLF
	_cQuery += " 						AND LFI.FT_PRODUTO      = ENTITEM.D1_COD "  +CRLF
	_cQuery += " 						AND LFI.R_E_C_D_E_L_    = 0 "  +CRLF
	_cQuery += " 			WHERE NFS.F2_FILIAL              NOT LIKE '02%' "  +CRLF
	If !Empty(_cCODFILIA)
		_cQuery += " 		AND NFS.F2_FILIAL IN " + _cCODFILIA  + " "
	EndIf 
	_cQuery += " 			AND NFS.D_E_L_E_T_             <>'*' "  +CRLF
	_cQuery += " 			AND NFSI.D2_TIPO               = 'D' "  +CRLF
	_cQuery += " 			AND NFS.F2_EMISSAO             BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  +CRLF
	_cQuery += " 			AND FO.A2_LOJA                 IS NOT NULL "  +CRLF
	_cQuery += " 			AND (  "  +CRLF
	_cQuery += "			 		ENTRADA.F1_DTDIGIT      > '" + _aRet[2] + "' "  +CRLF
	_cQuery += "			 		 OR ENTRADA.F1_DTDIGIT      IS NULL "  +CRLF
	_cQuery += " 					 OR ENTRADA.F1_STATUS			  <> 'A' "  +CRLF
	_cQuery += " 	 			) "  +CRLF
	_cQuery += " 		) T "  +CRLF
	_cQuery += " WHERE T.EMPRESA_ORIGEM <> T.EMPRESA_DESTINO "  +CRLF
	If !Empty(cCodTipPro) 
		_cQuery += " AND T.CODIGO_FISCAL IN " + cCodTipPro +CRLF
	EndIf 

Return 
