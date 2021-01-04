#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF02R03	�Autor  � Geronimo Benedito Alves																	�Data �23/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: COMPRAS - Compras Pendente				 (Modulo 02-Compras)						���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF02R03()

	Local _nI
	
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS - Compras Pendente"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Compras Pendente"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Compras Pendente"} 			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Compras Pendente"}  			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  							)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 					)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  	
	_nInterval	:= 366									//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01				02										 03								 04		 05	 06	 07		 08	 09	
	Aadd(_aCampoQry, { "A1_FILIAL"	,"COD_FILIAL"								,"Cod. Filial"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"NOME_FILIAL				as NOMEFILIAL"	,"Nome Filial"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_NUM"		,"NUMERO_SC"								,"N� Solicitacao"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_ITEM"	,"ITEM_SC"									,"Item Solicitado"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_ZGEAUTE"	,"GERA_AUT_ENTREGA"							,"Gera Autoriz Entrega"			,"C"	,003,0 	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_EMISSAO"	,"DATA_EMISSAO_SC"							,"Emissao Solicitacao Compras"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_NUM"		,"NUMERO_PEDIDO  			as NUMEPEDIDO"	,"N� Pedido"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_EMISSAO"	,"DATA_EMISSAO_PEDIDO		as DT_EMI_PED"	,"Data Emissao Pedido"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"USER_COMPRADOR 			as USERCOMPRA"	,"User Comprador"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_NOME"	,"NOME_COMPRADOR			as NOMECOMPRA"	,"Nome Comprador"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_COD"		,"COD_PRODUTO				as CODPRODUTO"	,"Cod. Produto"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_DESC"	,"DESC_PRODUTO				as DESCPRODUT"	,"Descr. Produto"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_CHAVE"	,"COD_TIPO_PRODUTO			as CODTIPOPRO"	,"Cod. Tipo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_DESCRI"	,"DESC_TIPO_PRODUTO			as DESCTIPPRO"	,"Descr. Tipo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_GRUPO"	,"COD_GRUPO_PRODUTO			as CODGRUPPRO"	,"Cod. Grupo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_DESC"	,"DESC_GRUPO_PRODUTO		as DESCGRPPRO"	,"Descr. Grupo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_FABRIC"	,"FABRICANTE				as FABRICANTE"	,"Fabricante"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZU_DESCRI"	,"MARCA"									,"Marca"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"STATUS_PRODUTO			as STATUSPROD"	,"Status Produto"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"MOEDA_PRODUTO				as MOEDAPRODU"	,"Moeda Produto"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_TOTAL"	,"PRECO_LIQUIDO_PEDIDO		as PRECLIQPED"	,"Preco Liquido Pedido"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_ZPRCORI"	,"PRECO_UNIT_ORIGEM			as PREUNITORI"	,"Preco Unitario Origem"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_PRECO"	,"PRECO_BASE"								,"Preco Base"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_ZVLDESC"	,"PERCENTUAL_SAVING			as PERCENSAV"	,"Percentual Saving"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_VALIDA"	,"DATA_VALIDADE_COTACAO 	as DTVALICOT"	,"Data Validade Cotacao"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_VALIPI"	,"VALOR_IPI"								,"Valor IPI"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_PRECO"	,"VALOR_ULTIMA_COMPRA		as VLRULTCOMP"	,"Valor ultima Compra"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_UNIMED"	,"COD_UNIDADE_MEDIDA		as CODUNIDMED"	,"Cod. Unidade Medida"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_DESCPO"	,"DESC_UNIDADE_MEDIDA		as DESCUNIMED"	,"Descr. Unidade Medida"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_DATPRF"	,"DATA_ENTREGA_PREVISTA 	as DTENTREGPR"	,"Data Entrega Prevista"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "F1_RECBMTO"	,"DATA_RECEBIMENTO			as DTRECEBIME"	,"Data Recebimento"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "F1_DOC"		,"NUMERO_NF"								,"N� NF"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "F1_SERIE"	,"NUMERO_SERIE_NF 			as NUMSERIENF"	,"N� Serie NF"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "F1_EMISSAO"	,"DATA_EMISSAO_NF			as DT_EMIS_NF"	,"Data Emissao NF"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_COD"		,"COD_FORNECEDOR			as CODFORNECE"	,"Cod. Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_LOJA"	,"LOJA_FORNECEDOR			as LOJAFORNEC"	,"Loja Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_FORNECEDOR			as NOMEFORNEC"	,"Nome Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_ESTADO"	,"UF_FORNECEDOR				as UF_FORNECE"	,"UF Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_VUNIT"	,"VALOR_UNIT_NF"							,"Valor Unitario NF"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_TOTAL_NF			as VLRTOTALNF"	,"Valor Total NF"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_VALIPI"	,"VALOR_IPI_NF"								,"Valor IPI NF"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_IPI"		,"ALIQ_IPI_NF"								,"Aliq. IPI NF"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_ICMS_IPI"							,"Valor ICMS IPI"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_PICM"	,"ALIQ_ICMS_NF"								,"Aliq. ICMS NF"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_ICMS_PROD"							,"Valor ICMS Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_ICMS_NF"							,"Valor ICMS NF"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_TOTAL_NF_SEMICMS_PROD"				,"Valor Total Sem ICMS Prod"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VALOR_UNITARIO_SEMICMS_PROD"				,"Valor Unitario Sem ICMS Prod"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_QUANT"	,"QTD_SOLICITADA			as QTDSOLICIT"	,"Qtd. Solicitada"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_QUANT"	,"QTD_NF"									,"Qtd. NF"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_QUANT"	,"QTD_SALDO"								,"Qtd. Saldo"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_QATU"	,"QTD_ESTOQUE_ATUAL			as QTDESTQATU"	,"Qtd. Estoque Atual"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"COD_SOLICITANTE			as CODSOLICIT"	,"Cod. Solicitante"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_SOLICITANTE			as NOMESOLICI"	,"Nome Solicitante"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_CONTRA"	,"CONTRATO_SPOT				as CONTRASPOT"	,"Contrato Spot"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_TPFRETE"	,"TIPO_FRETE"								,"Tipo Frete"					,"C"	,9	,0	,"@!"	,""	,"@!" })
	Aadd(_aCampoQry, { "C7_ACCPROC"	,"STATUS_PEDIDO_COMPRA 		as STATUSPEDI"	,"Status Pedido de Compras"		,"C"	,40	,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "ED_CODIGO"	,"COD_NATUREZA_FINANCEIRA 	as CODNATUREZ"	,"Cod. Natureza Financeira"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "ED_DESCRIC"	,"DESC_NATUREZA_FINANCEIRA	as DESCNATURE"	,"Descr. Natureza Financeira"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_OBS"		,"STATUS_SOLICITACAO		as STATSOLICI"	,"Status Solicitacao" 			,"C"	,60	,0  ,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_OBS"		,"OBSERVACAO_SC				as OBS_SC"		,"Observacao Solicit." 			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_OBS"		,"OBSERVACAO_PEDIDO			as OBS_PEDIDO"	,"Observacao Pedido" 			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_ZPRODES"	,"OBERVACAO_PRODUTO			as OBS_PRODUT"	,"Observacao Produto" 			,"C"	,2020,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "E4_DESCRI"	,"CONDICAO_PAGAMENTO		as CONDIPAGTO"	,"Condicao Pagamento" 			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A4_NOME"	,"TRANSPORTADORA			as TRANSPORTA"	,"Transportadora" 				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATA_LIBERACAO_SC			as DATALIBESC"	,"Data Liberacao SC" 			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_ZOBSEST"	,"OBERVACAO_ESTOQUE"						,"Observacao Estoque"			,""		,""	,	,""		,""	,""	}) 

	aAdd(_aParambox,{1,"Dt Emissao Solicitacao Inicio"	,Ctod("")						,""	,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissao Solicitacao Final"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissao Pedido Inicial"		,Ctod("")						,""	,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Emissao Pedido Final"		,Ctod("")						,""	,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"			,Space(tamSx3("C7_PRODUTO")[1])	,""	,""													,"SB1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final"				,Space(tamSx3("C7_PRODUTO")[1])	,""	,"U_VLFIMMAI(MV_PAR05,MV_PAR06,'Produto')"			,"SB1"	,"",050,.F.})

	//aAdd(_aParambox,{1,"Cod. Fornec. Inicial"			,Space(tamSx3("A2_COD")[1])		,""	,""													,"CF8A2","",050,.F.})
	//aAdd(_aParambox,{1,"Loja Fornec. Inicial"			,Space(tamSx3("A2_LOJA")[1])	,""	,""													,""		,"",050,.F.})
	//aAdd(_aParambox,{1,"Cod. Fornec. Final"			,Space(tamSx3("A2_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR07,'Cod. Fornecedor')"	,"CF8A2","",050,.F.})
	//aAdd(_aParambox,{1,"Loja Fornec. Final"			,Space(tamSx3("A2_LOJA")[1])	,""	,"U_VLFIMMAI(MV_PAR06, MV_PAR08,'Loja Fornecedor')"	,""		,"",050,.F.})


	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//=========	S E L E C I O N A     F O R N E C E D O R  
	cQryFornec	:= "SELECT ' ' as A2_COD_LOJ, 'NAO INFORMADO' as A2_NOME, ' ' AS A2_CGC  FROM DUAL UNION ALL "
	cQryFornec	+= "SELECT A2_COD||A2_LOJA as A2_COD_LOJ, A2_NOME "
	cQryFornec	+= " ,CASE LENGTH(TRIM(A2_CGC))                   "
	cQryFornec	+= "      WHEN NULL                               " 
	cQryFornec	+= "          THEN ''                             "
	cQryFornec	+= "      WHEN 0                                  "
	cQryFornec	+= "          THEN ''                             "
	cQryFornec	+= "      WHEN 11                                 "
	cQryFornec	+= "          THEN SUBSTR(A2_CGC,1,3)||'.'||SUBSTR(A2_CGC,4,3)||'.'||SUBSTR(A2_CGC,7,3)||'-'||SUBSTR(A2_CGC,10,2) "
	cQryFornec	+= "      WHEN 14                                 "
	cQryFornec	+= "          THEN SUBSTR(A2_CGC,1,2)||'.'||SUBSTR(A2_CGC,3,3)||'.'||SUBSTR(A2_CGC,6,3)||'/'||SUBSTR(A2_CGC,9,4)||'-'|| SUBSTR(A2_CGC,13,2) "
	cQryFornec	+= "      ELSE A2_CGC                             "
	cQryFornec	+= "  END                              AS A2_CGC   "
	cQryFornec  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA2")  ) + " TMPSA2 "
	cQryFornec	+= "  WHERE TMPSA2.D_E_L_E_T_ = ' ' " 
	//cQryFornec	+= "  AND TMPSA2.A2_COD <  '000101'  " 
	cQryFornec	+= "  ORDER BY A2_COD_LOJ"

	aCpoFornec	:=	{	{ "A2_COD_LOJ"	,"Codigo-loja"			,TamSx3("A2_COD")[1] + TamSx3("A2_LOJA")[1] +20		} ,;
	aCpoFornec	:=		{ "A2_NOME"		,"Nome do Fornecedor"	,TamSx3("A2_NOME")[1]  +50  }	 ,; 
	aCpoFornec	:=		{ "A2_CGC"		,U_X3Titulo("A2_CGC")	,TamSx3("A2_CGC")[1]  }	} 
	cTitFornec	:= " Marque os Fornecedores � listar."
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_aForneced	:= U_MarkForn(cQryFornec, aCpoFornec, cTitFornec, nPosRetorn, @_lCancProg )
	_cForneced	:= U_Array_In( _aForneced )
	
	If _lCancProg
		Return
	Endif 


	cQStatSoli := "			  select  '01' as CAMPO_01, 'SOLICITACAO PENDENTE'							as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '02' as CAMPO_01, 'SOLICITACAO TOTALMENTE ATENDIDA PELO SIGAGCT'	as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '03' as CAMPO_01, 'SOLICITACAO PARCIALMENTE ATENDIDA'				as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '04' as CAMPO_01, 'SOLICITACAO EM PROCESSO DE COTACAO'			as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '05' as CAMPO_01, 'ELIM. POR RESIDUO'								as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '06' as CAMPO_01, 'SOLICITACAO BLOQUEADA'							as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '07' as CAMPO_01, 'SOLICITACAO COM PRODUTO IMPORTADO'				as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '08' as CAMPO_01, 'SOLICITACAO REJEITADA'							as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '09' as CAMPO_01, 'INTEGRACAO COM O MODULO DE GESTAO DE CONTRATOS'as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '10' as CAMPO_01, 'SOLICITACAO EM COMPRA CENTRALIZADA'			as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '11' as CAMPO_01, 'SOLICITACAO DE IMPORTACAO'						as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '12' as CAMPO_01, 'SOLICITACAO PENDENTE (MKT)'					as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '13' as CAMPO_01, 'SOLICITACAO EM PROCESSO DE COTACAO (MKT)'		as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '14' as CAMPO_01, 'SOLICITACAO PARA LICITACAO'					as CAMPO_02 from dual " +CRLF
	cQStatSoli += " union all select  '15' as CAMPO_01, 'NAO INFORMADO'									as CAMPO_02 from dual " +CRLF
	aCpoStSoli	:=	{	{ "CAMPO_01"	,"N�"					,02	} ,;
						{ "CAMPO_02"	,"Status Solicitacao"	,50	} } 
	cTitStSoli	:= "Marque os Status de solicita��es � serem listadas: "
	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: CAMPO_01
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg ) 
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aStatuSoli)
		aStatuSoli[_nI] := Alltrim(aStatuSoli[_nI])		// Retiro os espa�os em branco para ficar perfeito na clausula IN
	Next
	cStatuSoli	:= U_Array_In( aStatuSoli )


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
	_lCancProg	:= .T. 	//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

 	cQrySolici	:= "SELECT ' ' as USR_ID ,' ' as USR_CODIGO ,'Sem solicitante' as USR_NOME FROM DUAL UNION ALL "
	cQrySolici	+= "SELECT USR_ID ,USR_CODIGO ,USR_NOME "
	cQrySolici  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", "SYS_USR" ) + " TMPSYS_USR "
	cQrySolici	+= "  WHERE TMPSYS_USR.D_E_L_E_T_ = ' ' "
	cQrySolici	+= "  ORDER BY USR_NOME "
	aCpoSolici	:=	{	{ "USR_ID"		,"ID Solicitante"		, 010	} ,;
	aCpoSolici	:=		{ "USR_CODIGO"	,"Codigo Solicitante"	, 040	} ,;
	aCpoSolici	:=		{ "USR_NOME"	,"Nome Solicitante"		, 080	}	} 
	cTitSolici	:= "Marque os Codigos de Solicitantes � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cIdSolicit	:= U_Array_In( U_MarkGene(cQrySolici, aCpoSolici, cTitSolici, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_COMPRAS_COMPRASPENDENTE") +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DATA_EMISSAO_SC_FILTRO BETWEEN '"     + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                                    )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " DATA_EMISSAO_PEDIDO_FILTRO BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' "	)	// NAO OBRIGATORIO
	If Empty( cComprador )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cComprador ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_COMPRADOR_FILTRO IS NULL OR COD_COMPRADOR_FILTRO IN " + cComprador + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_COMPRADOR_FILTRO IN " + cComprador	)	
	Endif

	If Empty( _cForneced )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", _cForneced ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_FORNECEDOR IS NULL OR COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced	)	
	Endif
	
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " COD_PRODUTO BETWEEN '"                + _aRet[5] + "' AND '" + _aRet[6] + "' "	)	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(cStatuSoli),    " STATUS_SOLICITACAO IN "               + cStatuSoli	                            )	// NAO OBRIGATORIO

	If Empty( cCodTipPro )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd(  .T. ,             " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"         )
	Else	
		_cQuery += U_WhereAnd(  .T. ,             " COD_TIPO_PRODUTO IN " + cCodTipPro	                                            )	
	Endif

	If Empty( cIdSolicit )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cIdSolicit ) <> 0
		_cQuery += U_WhereAnd(  !empty(cIdSolicit) ,	" ( ID_SOLICITANTE_FILTRO IS NULL OR ID_SOLICITANTE_FILTRO IN " + cIdSolicit + " )"         )
	Else	
		_cQuery += U_WhereAnd(  !empty(cIdSolicit) ,	" ID_SOLICITANTE_FILTRO IN " + cIdSolicit	                                            )	
	Endif

	// RVBJ
	aAdd(_aParambox,{1,"Fornecedores : "			,""})
	aAdd(_aRet, Iif(Empty(_cForneced),"Todos",_cForneced))

	aAdd(_aParambox,{1,"Status Solicitacao : "		,""})
	aAdd(_aRet, Iif(Empty(cStatuSoli),"Todos",cStatuSoli))

	aAdd(_aParambox,{1,"Compradores : "				,""})
	aAdd(_aRet, Iif(Empty(cComprador),"Todos",cComprador))

	aAdd(_aParambox,{1,"Tipos de Produtos : "		,""})
	aAdd(_aRet, Iif(Empty(cCodTipPro),"Todos",cCodTipPro))

	aAdd(_aParambox,{1,"Codigos de Solicitantes :"	,""})
	aAdd(_aRet, Iif(Empty(cIdSolicit),"Todos",cIdSolicit))

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
