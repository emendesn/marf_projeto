#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF02R02	�Autor  � Geronimo Benedito Alves																	�Data �  18/01/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: COMPRAS - Saving de Negociacao  (Modulo 02-COM)									���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF02R02()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Compras - Saving de Negociacao"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Saving de Negociacao"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Saving de Negociacao"} 			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Saving de Negociacao"} 			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  								)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 	
	Aadd(_aDefinePl, { {||.T.} } 						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  	
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

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03						 04	 05	 06	 07	 08	 09
	AAdd(_aCampoQry, { 	"F2_FILIAL"	,"COD_FILIAL"								,"Cod. Filial"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A1_NOME"	,"NOME_FILIAL				as NOMEFILIAL"	,"Nome Filial"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C1_NUM"	,"NUMERO_SC					as NUMERO_SC"	,U_X3Titulo("C1_NUM")	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C1_EMISSAO","DATA_EMISSAO_SC			as DTEMISS_SC"	,"Data Emissao SC"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, {	"C7_NUM"	,"NUMERO_PEDIDO				as NUMPEDIDO"	,"N� Pedido"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, {	"C7_EMISSAO","DATA_EMISSAO_PEDIDO		as DTEMISSPED"	,"Data Emissao Pedido"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_DOC"	,"NUMERO_NF"								,"N� NF"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_SERIE"	,"NUMERO_SERIE_NF			as N_SERIE_NF"	,"N� Serie NF"			,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_ITEM"	,"ITEM_NF"									,"Item NF"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"F1_DTLANC"	,"DATA_ENTRADA_NF			as DTENTRADNF"	,"Data Entrada NF"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_CONTRA"	,"CONTRATO_SPOT				as CONTRASPOT"	,"Contrato Spot"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"B1_COD"	,"COD_PRODUTO				as CODPRODUTO"	,U_X3Titulo("B1_COD")	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"B1_DESC"	,"DESC_PRODUTO				as DESCPRODUT"	,"Desc. Produto"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C1_QUANT"	,"QTD_SOLICITADA			as QTDSOLICIT"	,"Qtd. Solicitada"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_QUANT"	,"QTD_NF"									,"Qtd. NF"				,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"C8_PRECO"	,"PRECO_BASE"								,"Preco Base"			,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"C7_TOTAL"	,"PRECO_UNITARIO_FECHADO	as PRECOUNIFE"	,"Preco Unit. Fechado",  ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AH_UNIMED"	,"COD_UNIDADE_MEDIDA		as UNIDADEMED"	,"Cod. Unidade Medida",  ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AH_DESCPO"	,"DESC_UNIDADE_MEDIDA		as DESC_UNIDA"	,"Desc. Unidade Medida", ""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"AA1_FUNCAO","MOEDA_PRODUTO				as MOEDAPRODU"	,"Moeda Produto"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_TOTAL_NF 			as VLRTOTALNF"	,"Vlr. Total NF"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_ULTIMA_COMPRA		as VLRULTIMCP"	,"Vlr. Ultima Compra"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_TOTAL"	,"VALOR_PENULTIMA_COMPRA	as VLRPENULTI"	,"Vlr. Penultima"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_EMISSAO","DATA_ULTIMA_COMPRA		as DTULTIMACP"	,"Data Ultima Compra"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"D1_EMISSAO","DATA_PENULTIMA_COMPRA		as DTPENULTIM"	,"Data Penultima Compra",""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C7_TOTAL"	,"ECONOMIA"									,"Economia"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A1_TELEX"	,cDesc_Stat									,"Status"				,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C8_PRECO"	,"COST_AVOIDANCE 			as COST_AVOID"	,"Cost Avoidance"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"C8_VALIDA"	,"DATA_VALIDADE_COTACAO 	as DTVALIDCOT"	,"Data Validade Cotacao",""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A2_COD"	,"COD_FORNECEDOR 			as CODFORNECE"	,"Cod. Fornecedor"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"A2_LOJA"	,"LOJA_FORNECEDOR 			as LOJAFORNEC"	,"Loja Fornecedor"		,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"A2_NOME"	,"NOME_FORNECEDOR 			as NOMEFORNEC"	,"Nome Fornecedor"		,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"A2_CGC"	,"CNPJ_FORNECEDOR 			as CNPJFORNEC"	,"CNPJ Fornecedor"		,""	,18	,""	,"@!","","@!"})
	AAdd(_aCampoQry, { 	"Y1_USER"	,"USER_COMPRADOR 			as USERCOMPRA"	,"User Comprador"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"Y1_NOME"	,"NOME_COMPRADOR 			as NOMECOMPRA"	,"Nome Comprador"		,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"X5_CHAVE"	,"COD_TIPO_PRODUTO 			as CODTIPPROD"	,"Cod. Tipo Produto"	,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"X5_DESCRI"	,"DESC_TIPO_PRODUTO 		as DESCTIPPRO"	,"Desc. Tipo Produto"	,""	,""	,""	,""	,""	,""	})	
	AAdd(_aCampoQry, { 	"BM_GRUPO"	,"COD_GRUPO_PRODUTO 		as CODGRPPROD"	,"Cod. Grupo Produto"	,""	,""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"BM_DESC"	,"DESC_GRUPO_PRODUTO 		as DESCGRPPRO"	,"Desc. Grupo Produto"	, "",""	,""	,""	,""	,""	})
	AAdd(_aCampoQry, { 	"E4_DESCRI"	,"CONDICAO_PAGAMENTO 		as CONDIPAGTO"	,"Condicao Pagamento"	,""	,""	,""	,""	,""	,""	}) 
	AAdd(_aCampoQry, { 	"C8_PRECO"	,"SPEND"									,"Spend"				,""	,""	,""	,""	,""	,""	})				

	aAdd(_aParambox,{1,"Data Entrada NF Inicial",Ctod("")						,""	,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Entrada NF Final"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cod. Fornec. Inicial"	,Space(tamSx3("A2_COD")[1])		,""	,													,"CF8A2","",050,.F.}) 
	aAdd(_aParambox,{1,"Loja Fornec. Inicial"	,Space(tamSx3("A2_LOJA")[1])	,""	,													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornec. Final"		,Space(tamSx3("A2_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR05,'Cod. Fornecedor')"	,"CF8A2","",050,.F.})	
	aAdd(_aParambox,{1,"Loja Fornec. Final"		,Space(tamSx3("A2_LOJA")[1])	,""	,"U_VLFIMMAI(MV_PAR04, MV_PAR06,'Loja Fornecedor')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"	,Space(tamSx3("C7_PRODUTO")[1])	,""	,													,"SB1"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Cod. Produto Final"		,Space(tamSx3("C7_PRODUTO")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08,'Cod. Produto')"	,"SB1"	,"",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet, @_cTmp01) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

 	cQryCompdo	:= "SELECT ' ' as Y1_COD, 'Sem Comprador' as Y1_NOME FROM DUAL UNION ALL "
	cQryCompdo	+= "SELECT DISTINCT Y1_COD, Y1_NOME"
	cQryCompdo  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SY1")  ) + " TMPSY1 "
	cQryCompdo	+= "  WHERE TMPSY1.D_E_L_E_T_ = ' ' "
	cQryCompdo	+= "  ORDER BY Y1_COD"
	aCpoCompdo	:=	{	{ "Y1_COD"		,U_X3Titulo("Y1_COD")	,TamSx3("Y1_COD")[1]		} ,;
	aCpoCompdo	:=		{ "Y1_NOME"	,U_X3Titulo("Y1_NOME")	,TamSx3("Y1_NOME")[1] }	} 
	cTitCompdo	:= "Marque os Codigos de compradores � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
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
	cTitTipPro	:= "Marque os Tipos de Produtos � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_COMPRAS_SAVINGNEGOCIACAO" ) +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),       " COD_FILIAL IN " + _cCODFILIA	                                               )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),         " DATA_ENTRADA_NF_FILTRO  BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " )	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	If Empty( cComprador )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cComprador ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( COD_COMPRADOR_FILTRO IS NULL OR COD_COMPRADOR_FILTRO IN " + cComprador + " )"            )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   COD_COMPRADOR_FILTRO IN " + cComprador	                                               )	
	Endif
	_cQuery += U_WhereAnd(!empty(_aRet[5] ),         " COD_FORNECEDOR BETWEEN '"          + _aRet[3] + "' AND '" + _aRet[5] + "' " )	//NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),         " LOJA_FORNECEDOR BETWEEN '"         + _aRet[4] + "' AND '" + _aRet[6] + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),         " COD_PRODUTO BETWEEN '"             + _aRet[7] + "' AND '" + _aRet[8] + "' " )	// NAO OBRIGATORIO
	If Empty( cCodTipPro )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"     )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   COD_TIPO_PRODUTO IN "  + cCodTipPro                                       )	
	Endif

	_cQuery += "	ORDER BY COD_FILIAL "	+CRLF	
	_cQuery += "			,DATA_ENTRADA_NF "	+CRLF
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)

	// RVBJ
	aAdd(_aParambox,{1,"Codigos de compradores : "		,""})
	aAdd(_aRet, Iif(Empty(cComprador),"Todos",cComprador))

	aAdd(_aParambox,{1,"Tipos de Produtos : "			,""})
	aAdd(_aRet, Iif(Empty(cCodTipPro),"Todos",cCodTipPro))

	// Mostra mensagem MsgRun "Aguarde!!! Montando\Desconectando Tela" ao montar a tela de dados e tambem ao fecha-la
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
