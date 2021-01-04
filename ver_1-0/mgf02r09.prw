#INCLUDE "totvs.ch" 

/*/{Protheus.doc} MGF02R09 (Relatório - Compras Pendente Pedido)
Criação de relatório para exibir compras pendentes

@description
Rotina tem o objetivo de exibir pedidos de compras pendentes. 

@author Henrique Vidal Santos
@since 20/09/2019

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	View - V_COMPRAS_COMPRASPENDENTEPED
	SA2 - Fornecedores
	SY1 - Compradores
	USR - Usuários

@param
@return

@menu
	SIGACOM->Relatorios/Especifico/Compras pendentes pedido
@history
	Criação da rotina
	RTASK0010071 - Compras Pendentes Pedidos
	
/*/

User Function MGF02R09()

	Local _nI
	
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS - Compras Pendente Pedido"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Compras Pendente Pedido"			)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Compras Pendente Pedido"} 			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Compras Pendente Pedido"}  		)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  									)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 							)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  	
	_nInterval	:= 366												//Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	Aadd(_aCampoQry, { "A1_FILIAL"	,"COD_FILIAL"										,"Cód. Filial"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"NOME_FILIAL					as NOMEFILIAL"	,"Nome Filial"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_NUM"		,"NUMERO_SC"										,"Nº Solicitação"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_ITEM"	,"ITEM_SC"											,"Item Solicitado"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_ZGEAUTE"	,"GERA_AUT_ENTREGA"								,"Gera Autoriz Entrega"			,"C"	,003	,0 		,""	,""	,""	})
	Aadd(_aCampoQry, { "C1_EMISSAO"	,"DATA_EMISSAO_SC"								,"Emissão Solicitação Compras"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_NUM"		,"NUMERO_PEDIDO  				as NUMEPEDIDO"	,"Nº Pedido"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_EMISSAO"	,"DATA_EMISSAO_PEDIDO		as DT_EMI_PED"	,"Data Emissão Pedido"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"USER_COMPRADOR 				as USERCOMPRA"	,"User Comprador"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_NOME"	,"NOME_COMPRADOR				as NOMECOMPRA"	,"Nome Comprador"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_COD"		,"COD_PRODUTO					as CODPRODUTO"	,"Cód. Produto"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_CHAVE"	,"COD_TIPO_PRODUTO			as CODTIPOPRO"	,"Cód. Tipo Produto"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_DESCRI"	,"DESC_TIPO_PRODUTO			as DESCTIPPRO"	,"Descr. Tipo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_GRUPO"	,"COD_GRUPO_PRODUTO			as CODGRUPPRO"	,"Cód. Grupo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_DESC"	,"DESC_GRUPO_PRODUTO			as DESCGRPPRO"	,"Descr. Grupo Produto"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_FABRIC"	,"FABRICANTE					as FABRICANTE"	,"Fabricante"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZU_DESCRI"	,"MARCA"											,"Marca"							,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"STATUS_PRODUTO				as STATUSPROD"	,"Status Produto"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"MOEDA_PRODUTO				as MOEDAPRODU"	,"Moeda Produto"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_TOTAL"	,"PRECO_LIQUIDO_PEDIDO		as PRECLIQPED"	,"Preço Liquido Pedido"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_ZPRCORI"	,"PRECO_UNIT_ORIGEM			as PREUNITORI"	,"Preço Unitário Origem"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_PRECO"	,"PRECO_BASE"										,"Preço Base"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_ZVLDESC"	,"PERCENTUAL_SAVING			as PERCENSAV"		,"Percentual Saving"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_VALIDA"	,"DATA_VALIDADE_COTACAO 		as DTVALICOT"		,"Data Validade Cotação"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_VALIPI"	,"VALOR_IPI"										,"Valor IPI"						,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_PRECO"	,"VALOR_ULTIMA_COMPRA		as VLRULTCOMP"	,"Valor Última Compra"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_UNIMED"	,"COD_UNIDADE_MEDIDA			as CODUNIDMED"	,"Cód. Unidade Medida"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_DESCPO"	,"DESC_UNIDADE_MEDIDA		as DESCUNIMED"	,"Descr. Unidade Medida"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_DATPRF"	,"DATA_ENTREGA_PREVISTA 		as DTENTREGPR"	,"Data Entrega Prevista"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_COD"		,"COD_FORNECEDOR				as CODFORNECE"	,"Cód. Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_LOJA"	,"LOJA_FORNECEDOR				as LOJAFORNEC"	,"Loja Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_FORNECEDOR				as NOMEFORNEC"	,"Nome Fornecedor"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_ESTADO"	,"UF_FORNECEDOR				as UF_FORNECE"	,"UF Fornecedor"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_QUANT"	,"QTD_SOLICITADA				as QTDSOLICIT"	,"Qtd. Solicitada"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_QATU"	,"QTD_ESTOQUE_ATUAL			as QTDESTQATU"	,"Qtd. Estoque Atual"			,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "Y1_USER"	,"COD_SOLICITANTE				as CODSOLICIT"	,"Cód. Solicitante"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_SOLICITANTE			as NOMESOLICI"	,"Nome Solicitante"				,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C7_CONTRA"	,"CONTRATO_SPOT				as CONTRASPOT"	,"Contrato Spot"					,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C8_TPFRETE"	,"TIPO_FRETE"										,"Tipo Frete"						,"C"	,9	,0	,"@!"	,""	,"@!" })
	Aadd(_aCampoQry, { "C7_ACCPROC"	,"STATUS_PEDIDO_COMPRA 		as STATUSPEDI"	,"Status Pedido de Compras"		,"C"	,40	,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "ED_CODIGO"	,"COD_NATUREZA_FINANCEIRA 	as CODNATUREZ"	,"Cód. Natureza Financeira"		,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "ED_DESCRIC"	,"DESC_NATUREZA_FINANCEIRA	as DESCNATURE"	,"Descr. Natureza Financeira"	,""		,""	,	,""		,""	,""	})
	Aadd(_aCampoQry, { "C1_OBS"		,"STATUS_SOLICITACAO		 	as STATSOLICI"	,"Status Solicitação" 			,"C"	,60	,0  ,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATA_LIBERACAO_SC			as DATALIBESC"	,"Data Liberação SC" 			,""		,""	,	,""		,""	,""	})
 	

	aAdd(_aParambox,{1,"Dt Emissão Solicitação Inicio"	,Ctod("")							,""	,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissão Solicitação Final"	,Ctod("")							,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissão Pedido Inicial"		,Ctod("")							,""	,"" 													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Emissão Pedido Final"			,Ctod("")							,""	,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"				,Space(tamSx3("C7_PRODUTO")[1])	,""	,""														,"SB1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final"				,Space(tamSx3("C7_PRODUTO")[1])	,""	,"U_VLFIMMAI(MV_PAR05,MV_PAR06,'Produto')"		,"SB1"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//=========	S E L E C I O N A     F O R N E C E D O R  
	cQryFornec	:= "SELECT ' ' as A2_COD_LOJ, 'NÃO INFORMADO' as A2_NOME, ' ' AS A2_CGC  FROM DUAL UNION ALL "
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

	cQryFornec	+= "  ORDER BY A2_COD_LOJ"

	aCpoFornec	:=	{	{ "A2_COD_LOJ"	,"código-loja"			,TamSx3("A2_COD")[1] + TamSx3("A2_LOJA")[1] +20		} ,;
	aCpoFornec	:=		{ "A2_NOME"		,"Nome do Fornecedor"	,TamSx3("A2_NOME")[1]  +50  }	 ,; 
	aCpoFornec	:=		{ "A2_CGC"		,U_X3Titulo("A2_CGC")	,TamSx3("A2_CGC")[1]  }	} 
	cTitFornec	:= " Marque os Fornecedores à listar."
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
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
	aCpoStSoli	:=	{	{ "CAMPO_01"	,"Nº"					,02	} ,;
						{ "CAMPO_02"	,"Status Solicitação"	,50	} } 
	cTitStSoli	:= "Marque os Status de solicitações à serem listadas: "
	nPosRetorn	:= 2		
	_lCancProg	:= .T. 	
	aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg ) 
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aStatuSoli)
		aStatuSoli[_nI] := Alltrim(aStatuSoli[_nI])	
	Next
	cStatuSoli	:= U_Array_In( aStatuSoli )

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

 	cQrySolici	:= "SELECT ' ' as USR_ID ,' ' as USR_CODIGO ,'Sem solicitante' as USR_NOME FROM DUAL UNION ALL "
	cQrySolici	+= "SELECT USR_ID ,USR_CODIGO ,USR_NOME "
	cQrySolici  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", "SYS_USR" ) + " TMPSYS_USR "
	cQrySolici	+= "  WHERE TMPSYS_USR.D_E_L_E_T_ = ' ' "
	cQrySolici	+= "  ORDER BY USR_NOME "
	aCpoSolici	:=	{	{ "USR_ID"		,"ID Solicitante"		, 010	} ,;
	aCpoSolici	:=		{ "USR_CODIGO"	,"Código Solicitante"	, 040	} ,;
	aCpoSolici	:=		{ "USR_NOME"	,"Nome Solicitante"		, 080	}	} 
	cTitSolici	:= "Marque os Códigos de Solicitantes à serem listados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 		
	cIdSolicit	:= U_Array_In( U_MarkGene(cQrySolici, aCpoSolici, cTitSolici, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_COMPRAS_COMPRASPENDENTEPED") +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DATA_EMISSAO_SC_FILTRO BETWEEN '"     + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                                    )	// OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " DATA_EMISSAO_PEDIDO_FILTRO BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' "	)	// NÃO OBRIGATORIO
	If Empty( cComprador )
		_cQuery +=  ""		
	ElseIF AT("' '", cComprador ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_COMPRADOR_FILTRO IS NULL OR COD_COMPRADOR_FILTRO IN " + cComprador + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_COMPRADOR_FILTRO IN " + cComprador	)	
	Endif

	If Empty( _cForneced )
		_cQuery +=  ""		
	ElseIF AT("' '", _cForneced ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_FORNECEDOR IS NULL OR COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced	)	
	Endif
	
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " COD_PRODUTO BETWEEN '"                + _aRet[5] + "' AND '" + _aRet[6] + "' "	)	// NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(cStatuSoli),   " STATUS_SOLICITACAO IN "               + cStatuSoli	                            )	// NÃO OBRIGATORIO

	If Empty( cCodTipPro )
		_cQuery +=  ""	
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd(  .T. ,             " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"         )
	Else	
		_cQuery += U_WhereAnd(  .T. ,             " COD_TIPO_PRODUTO IN " + cCodTipPro	                                            )	
	Endif

	If Empty( cIdSolicit )
		_cQuery +=  ""		
	ElseIF AT("' '", cIdSolicit ) <> 0
		_cQuery += U_WhereAnd(  !empty(cIdSolicit) ,	" ( ID_SOLICITANTE_FILTRO IS NULL OR ID_SOLICITANTE_FILTRO IN " + cIdSolicit + " )"         )
	Else	
		_cQuery += U_WhereAnd(  !empty(cIdSolicit) ,	" ID_SOLICITANTE_FILTRO IN " + cIdSolicit	                                            )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
