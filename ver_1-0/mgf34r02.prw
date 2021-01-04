#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R02	�Autor  � Geronimo Benedito Alves																	�Data �01/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Razao Contabil  (Modulo 34-CTB)									���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= " AND "	// J� inicio com AND, pois o inicio do Where da query, j� vem escrita no programa fonte

	Aadd(_aDefinePl, "Contabilidade Gerencial - Razao Contabil"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Razao Contabil"							)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Razao Contabil"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Razao Contabil"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_nInterval	:= 366												//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01				 02											 03									 04		 05		 06	 07		 08	 09	
	Aadd(_aCampoQry, {	"A1_FILIAL"		,"FILIAL"									,"Codigo Filial"					,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A1_NOME"		,"DESC_FILIAL 				as NOMEFILIAL"	,"Descric�o Filial"					,"C"	,040	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_DATA"		,"DATA_LANCAMENTO			as DATA_LCTO"	,"Data Lcto"						,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_LOTE"		,"LOTE"										,"Lote"								,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_SBLOTE"	,"SUB_LOTE"									,"Sub Lote" 						,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_DOC"		,"DOCUMENTO"								,"Documento"						,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_DC"		,"TIPO"										,"Tipo"								,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_DEBITO"	,"CONTA_DEBITO 				as CTA_DEBITO"	,"Conta Cont�bil Debito"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT1_DESC01"	,"DESCRICAO_CTA_DEBITO 		as DESCCTADEB"	,"Descricao Conta Cont�bil Debito"	,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_CREDIT"	,"CONTA_CRETIDO 			as CTACREDITO"	,"Conta Cont�bil Credito"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT1_DESC01"	,"DESCRICAO_CTA_CRETIDO 	as DESCCTACRE"	,"Descricao Conta Cont�bil"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A2_CGC"		,"CGC_DEBITO"								,"CGC Debito"						,""		,018	,0	,"@!"	,""	,"@!"})
	Aadd(_aCampoQry, {	"A2_NOME"		,"FORNECEDEB"								,"Nome Fornecedor Debito"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A2_CGC"		,"CGC_CREDIT"								,"CGC Credito"						,""		,018	,0	,"@!"	,""	,"@!"})
	Aadd(_aCampoQry, {	"A2_NOME"		,"FORNECECRE"								,"Nome Fornecedor Credito"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_VALOR"		,"VALOR"									,"Valor"							,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_HP"		,"HISTORICO					as CODHISTORI"	,"C�d. Hist."						,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_HIST"		,"DESC_HISTORICO			as DESHISTORI"	,"Historico"						,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_CCD"		,"C_CUSTO_DEBITO			as CCUSTODEBI"	,"Centro Custo Debito"				,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CTT_DESC01"	,"DESCRICAO_C_CUSTO_DEBITO	as DCCUSTODEB"	,"Descricao Centro de Custo Debito"	,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_CCD"		,"C_CUSTO_CREDITO			as CCUSTOCRED"	,"Centro Custo Credito"				,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CTT_DESC01"	,"DESCRICAO_C_CUSTO_CREDITO	as DCCUSTOCRE"	,"Descricao Centro de Custo Credito",""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_ITEMD"		,"ITEM_CONTABIL_DEB			as ITEMCTBDEB"	,"Item Cont�bil Debito"				,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_ITEMC"		,"ITEM_CONTABIL_CRE			as ITEMCTBCRE"	,"Item Cont�bil Credito"			,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_CLVLDB"	,"CLASSE_VLR_DEB			as CLASVLRDEB"	,"Classe Valor Debito"				,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_CLVLCR"	,"CLASSE_VLR_CRE			as CLASVLRCRE"	,"Classe Valor Credito"				,""		,""		,""	,""		,""	,""	})
	Aadd(_aCampoQry, {	"CT2_DATA"		,"DATA_PROCESSAMENTO		as DTPROCESSA"	,"Data Process"						,""		,""		,""	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Lancto Inicial"			,Ctod("")						,""	,""															,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Lancto Final"				,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"				,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Conta Cont�bil Debito Inicial"	,Space(tamSx3("CT1_CONTA")[1])	,""	,""															,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Debito Final"	,Space(tamSx3("CT1_CONTA")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Conta Cont�bil Debito')"	,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Credito Inicial"	,Space(tamSx3("CT1_CONTA")[1])	,""	,""															,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Credito Final"	,Space(tamSx3("CT1_CONTA")[1])	,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Conta Cont�bil Credito')"	,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Debito Inicial"	,Space(tamSx3("CTT_CUSTO")[1])	,""	,""															,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Debito Final"		,Space(tamSx3("CTT_CUSTO")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Centro de Custo Debito')"	,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Credito Inicial"	,Space(tamSx3("CTT_CUSTO")[1])	,""	,""															,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Credito Final"		,Space(tamSx3("CTT_CUSTO")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Centro de Custo Credito')","CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe Valor Debito Inicial"	,Space(tamSx3("CTH_CLVL")[1])	,""	,""															,"CTH"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe Valor Debito Final"		,Space(tamSx3("CTH_CLVL")[1])	,""	,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'Classe de Valor Debito')"	,"CTH"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe Valor Credito Inicial"	,Space(tamSx3("CTH_CLVL")[1])	,""	,""															,"CTH"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe Valor Credito Final"		,Space(tamSx3("CTH_CLVL")[1])	,""	,"U_VLFIMMAI(MV_PAR13, MV_PAR14, 'Classe de Valor Credito')","CTH"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery := ""	// Limpo a query da variavel _cQuery, criada pelo programa, a partir do _aCampoQry, para criar a query a partir do zero, nas linhas abaixo.
	
	_cQuery += "  SELECT T.FILIAL "																	+CRLF
	_cQuery += " 			, T.DESC_FILIAL 				as NOMEFILIAL "							+CRLF
	_cQuery += " 			, T.DATA_LANCAMENTO 			as DATA_LCTO  "							+CRLF
	_cQuery += " 			, T.LOTE "																+CRLF
	_cQuery += " 			, T.SUB_LOTE "															+CRLF
	_cQuery += " 			, T.DOCUMENTO "															+CRLF
	_cQuery += " 			, T.TIPO "																+CRLF
	_cQuery += " 			, T.CONTA_DEBITO 				as CTA_DEBITO "							+CRLF
	_cQuery += " 			, T.DESCRICAO_CTA_DEBITO 		as DESCCTADEB "							+CRLF
	_cQuery += " 			, T.CONTA_CRETIDO 				as CTACREDITO "							+CRLF
	_cQuery += " 			, T.DESCRICAO_CTA_CREDITO		as DESCCTACRE "							+CRLF
	_cQuery += " 			, CASE LENGTH(TRIM(SAD.A2_CGC)) "										+CRLF
	_cQuery += " 						WHEN NULL "													+CRLF
	_cQuery += " 								THEN '' "											+CRLF
	_cQuery += " 						WHEN 0 "													+CRLF
	_cQuery += " 								THEN '' "											+CRLF
	_cQuery += " 						WHEN 11 "													+CRLF
	_cQuery += " 								THEN SUBSTR(SAD.A2_CGC,1,3)||'.'||SUBSTR(SAD.A2_CGC,4,3)||'.'||SUBSTR(SAD.A2_CGC,7,3)||'-'||SUBSTR(SAD.A2_CGC,10,2) "	+CRLF
	_cQuery += " 						WHEN 14 "													+CRLF
	_cQuery += " 								THEN SUBSTR(SAD.A2_CGC,1,2)||'.'||SUBSTR(SAD.A2_CGC,3,3)||'.'||SUBSTR(SAD.A2_CGC,6,3)||'/'||SUBSTR(SAD.A2_CGC,9,4)||'-'|| SUBSTR(SAD.A2_CGC,13,2) "	+CRLF
	_cQuery += " 						ELSE SAD.A2_CGC "											+CRLF
	_cQuery += " 				END         AS CGC_DEBITO "											+CRLF
	_cQuery += " 			, SAD.A2_NOME	AS FORNECEDEB "											+CRLF		
	_cQuery += " 			, CASE LENGTH(TRIM(SAC.A2_CGC)) "										+CRLF
	_cQuery += " 						WHEN NULL "													+CRLF
	_cQuery += " 								THEN '' "											+CRLF
	_cQuery += " 						WHEN 0 "													+CRLF
	_cQuery += " 								THEN '' "											+CRLF
	_cQuery += " 						WHEN 11 "													+CRLF
	_cQuery += " 								THEN SUBSTR(SAC.A2_CGC,1,3)||'.'||SUBSTR(SAC.A2_CGC,4,3)||'.'||SUBSTR(SAC.A2_CGC,7,3)||'-'||SUBSTR(SAC.A2_CGC,10,2) "	+CRLF
	_cQuery += " 						WHEN 14 "					+CRLF
	_cQuery += " 								THEN SUBSTR(SAC.A2_CGC,1,2)||'.'||SUBSTR(SAC.A2_CGC,3,3)||'.'||SUBSTR(SAC.A2_CGC,6,3)||'/'||SUBSTR(SAC.A2_CGC,9,4)||'-'|| SUBSTR(SAC.A2_CGC,13,2) "	+CRLF
	_cQuery += " 						ELSE SAC.A2_CGC "											+CRLF
	_cQuery += " 				END     AS CGC_CREDIT "												+CRLF
	_cQuery += " 			, SAC.A2_NOME AS FORNECECRE "											+CRLF
	_cQuery += " 			, T.VALOR "																+CRLF
	_cQuery += " 			, T.HISTORICO					as CODHISTORI "							+CRLF
	_cQuery += " 			, T.DESC_HISTORICO				as DESHISTORI "							+CRLF
	_cQuery += " 			, T.C_CUSTO_DEBITO				as CCUSTODEBI "							+CRLF
	_cQuery += " 			, T.DESCRICAO_C_CUSTO_DEBITO 	as DCCUSTODEB "							+CRLF
	_cQuery += " 			, T.C_CUSTO_CREDITO 			as CCUSTOCRED "							+CRLF
	_cQuery += " 			, T.DESCRICAO_C_CUSTO_CREDITO 	as DCCUSTOCRE "							+CRLF
	_cQuery += " 			, T.ITEM_CONTABIL_DEB 			as ITEMCTBDEB "							+CRLF
	_cQuery += " 			, T.ITEM_CONTABIL_CRE 			as ITEMCTBCRE "							+CRLF
	_cQuery += " 			, T.CLASSE_VLR_DEB  			as CLASVLRDEB "							+CRLF
	_cQuery += " 			, T.CLASSE_VLR_CRE  			as CLASVLRCRE "							+CRLF
	_cQuery += " 			, T.DATA_PROCESSAMENTO  		as DTPROCESSA "							+CRLF
	_cQuery += "    FROM ( "																		+CRLF
	_cQuery += " 				SELECT CT2.CT2_FILIAL            AS FILIAL "						+CRLF
	_cQuery += " 						 , RTRIM(SYC.M0_FILIAL)  AS DESC_FILIAL "					+CRLF
	_cQuery += " 						 , TO_CHAR(CT2.CT2_DATA) AS DATA_LANCAMENTO "				+CRLF
	_cQuery += " 						 , CT2.CT2_LOTE          AS LOTE "							+CRLF
	_cQuery += " 						 , CT2.CT2_SBLOTE        AS SUB_LOTE "						+CRLF
	_cQuery += " 						 , CT2.CT2_DOC           AS DOCUMENTO "						+CRLF
	_cQuery += " 						 , CASE "													+CRLF
	_cQuery += " 									 WHEN CT2.CT2_DC = '1' "						+CRLF
	_cQuery += " 												THEN 'D' "							+CRLF
	_cQuery += " 										WHEN CT2.CT2_DC = '2' "						+CRLF
	_cQuery += " 												THEN 'C' "							+CRLF
	_cQuery += " 										ELSE 'P' "									+CRLF
	_cQuery += " 							 END              	AS TIPO "							+CRLF
	_cQuery += " 						 , CT2.CT2_DEBITO     	AS CONTA_DEBITO "					+CRLF
	_cQuery += " 						 , ( "														+CRLF
	_cQuery += " 								SELECT RTRIM(CTD.CT1_DESC01) "						+CRLF
	_cQuery += " 									FROM  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("CT1")  ) + "  CTD "	+CRLF
	_cQuery += " 								 WHERE CTD.CT1_FILIAL   = ' ' "						+CRLF
	_cQuery += " 									 AND CT2.CT2_DEBITO   = CTD.CT1_CONTA "			+CRLF
	_cQuery += " 									 AND CTD.D_E_L_E_T_   = ' ' "					+CRLF
	_cQuery += " 							 )                  AS DESCRICAO_CTA_DEBITO "			+CRLF
	_cQuery += " 						 , CT2.CT2_CREDIT       AS CONTA_CRETIDO "					+CRLF
	_cQuery += " 						 , ( "														+CRLF
	_cQuery += " 								SELECT RTRIM(CTD.CT1_DESC01) "						+CRLF
	_cQuery += " 									FROM  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("CT1")  ) + "  CTD "	+CRLF
	_cQuery += " 								 WHERE CTD.CT1_FILIAL   = ' ' "						+CRLF
	_cQuery += " 									 AND CT2.CT2_CREDIT   = CTD.CT1_CONTA "			+CRLF
	_cQuery += " 									 AND CTD.D_E_L_E_T_   =  ' ' "					+CRLF
	_cQuery += " 							 )                           AS DESCRICAO_CTA_CREDITO "	+CRLF
	_cQuery += " 						 , CAST(CT2.CT2_VALOR AS NUMBER(15,4))  AS VALOR "			+CRLF
	_cQuery += " 						 , CT2.CT2_HP                           AS HISTORICO "		+CRLF
	_cQuery += " 						 , CT2.CT2_HIST                         AS DESC_HISTORICO "	+CRLF
	_cQuery += " 						 , CT2.CT2_CCD                          AS C_CUSTO_DEBITO "	+CRLF
	_cQuery += " 						 , ( "														+CRLF
	_cQuery += " 								SELECT RTRIM(CCD.CTT_DESC01) "						+CRLF
	_cQuery += " 									FROM  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("CTT")  ) + "  CCD "	+CRLF
	_cQuery += " 								 WHERE CCD.CTT_FILIAL = ' ' "						+CRLF
	_cQuery += " 									 AND CT2.CT2_CCC    = CCD.CTT_CUSTO "			+CRLF
	_cQuery += " 									 AND CCD.D_E_L_E_T_ = ' ' "						+CRLF
	_cQuery += " 							 )                                  AS DESCRICAO_C_CUSTO_DEBITO "			+CRLF
	_cQuery += " 						 , CT2.CT2_CCC                          AS C_CUSTO_CREDITO "					+CRLF
	_cQuery += " 						 , ( "																			+CRLF
	_cQuery += " 								SELECT RTRIM(CCC.CTT_DESC01) "											+CRLF
	_cQuery += " 									FROM  " +U_IF_BIMFR("PROTHEUS",RetSqlName("CTT"))+ "  CCC "			+CRLF
	_cQuery += " 								 WHERE CCC.CTT_FILIAL = ' ' "											+CRLF
	_cQuery += " 									 AND CT2.CT2_CCC    = CCC.CTT_CUSTO "								+CRLF
	_cQuery += " 									 AND CCC.D_E_L_E_T_ = ' ' "										+CRLF
	_cQuery += " 							 )                                  		 AS DESCRICAO_C_CUSTO_CREDITO "	+CRLF
	_cQuery += " 						 , CT2.CT2_ITEMD                        		 AS ITEM_CONTABIL_DEB "			+CRLF
	_cQuery += " 						 , CT2.CT2_ITEMC                        		 AS ITEM_CONTABIL_CRE "			+CRLF
	_cQuery += " 						 , CT2.CT2_CLVLDB                       		 AS CLASSE_VLR_DEB "			+CRLF
	_cQuery += " 						 , CT2.CT2_CLVLCR                       		 AS CLASSE_VLR_CRE "			+CRLF
	_cQuery += " 						 , TO_DATE(SYSDATE)                     		 AS DATA_PROCESSAMENTO "		+CRLF
	_cQuery += " 						 , CT2.CT2_DATA                         		 AS DATA_LANCAMENTO_FILTRO "	+CRLF
	_cQuery += " 						 , CAST(SUBSTR(CT2.CT2_AT01DB, 1, 6) AS CHAR(6)) AS COD_FORNE_DB "				+CRLF
	_cQuery += " 						 , CAST(SUBSTR(CT2.CT2_AT01DB, 7, 8) AS CHAR(2)) AS LOJA_FORNE_DB "				+CRLF
	_cQuery += " 						 , CAST(SUBSTR(CT2.CT2_AT01CR, 1, 6) AS CHAR(6)) AS COD_FORNE_CR "				+CRLF
	_cQuery += " 						 , CAST(SUBSTR(CT2.CT2_AT01CR, 7, 8) AS CHAR(2)) AS LOJA_FORNE_CR "				+CRLF
	_cQuery += " 					FROM  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("CT2")  ) + "            CT2 "		+CRLF
	_cQuery += " 				 INNER JOIN " + U_IF_BIMFR("PROTHEUS", "SYS_COMPANY"  ) + " SYC ON CT2.CT2_FILIAL =   SYC.M0_CODFIL "				+CRLF
	_cQuery += " 																AND SYC.D_E_L_E_T_ = ' ' "				+CRLF
	_cQuery += " 				 WHERE CT2.D_E_L_E_T_ = ' ' "															+CRLF
	_cQuery += " 				     AND CT2.CT2_DATA BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "				+CRLF	// FILTRO DE DATA OBRIGATORIO (TRAVA DE UM ANO)
	_cQuery += " "															+CRLF
	_cQuery += " 					 AND CT2.CT2_FILIAL IN " + _cCODFILIA	+CRLF									//	FILTRO DA FILIAL OBRIGATORIO 

	_cQuery += U_WhereAnd( !empty(_aRet[4]),  " CT2.CT2_DEBITO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) // '  ' AND '999999999' --NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6]),  " CT2.CT2_CREDIT BETWEEN '" + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) // '  ' AND '999999999' --NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8]),  " CT2.CT2_CCD    BETWEEN '" + _aRet[7]  + "' AND '" + _aRet[8]  + "' " ) // '  ' AND '9999'  --NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10]), " CT2.CT2_CCC    BETWEEN '" + _aRet[9]  + "' AND '" + _aRet[10] + "' " ) // '  ' AND '9999'   --NAO OBRIGATORIO               
	_cQuery += U_WhereAnd( !empty(_aRet[12]), " CT2.CT2_CLVLDB BETWEEN '" + _aRet[11] + "' AND '" + _aRet[12] + "' " ) // '  ' AND '999999999'  --NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[14]), " CT2.CT2_CLVLCR BETWEEN '" + _aRet[13] + "' AND '" + _aRet[14] + "' " ) // '  ' AND '999999999'  --NAO OBRIGATORIO
		
	_cQuery += " 	    ) T "												+CRLF 
	_cQuery += "   LEFT JOIN  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA2")  ) + "    SAD ON T.COD_FORNE_DB    = SAD.A2_COD AND SAD.D_E_L_E_T_  = ' '  "		+CRLF 
	_cQuery += "                      AND T.LOJA_FORNE_DB   = SAD.A2_LOJA "	+CRLF 
	_cQuery += "   LEFT JOIN  " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA2")  ) + "    SAC ON T.COD_FORNE_CR    = SAC.A2_COD AND SAC.D_E_L_E_T_  = ' '  "		+CRLF 
	_cQuery += "                      AND T.LOJA_FORNE_CR   = SAC.A2_LOJA "	+CRLF 
	_cQuery += "  ORDER BY FILIAL "											+CRLF 																			
	_cQuery += "         , DATA_LANCAMENTO " 								+CRLF 
	_cQuery += "         , DOCUMENTO "										+CRLF 
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

