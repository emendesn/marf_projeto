#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF04R04	บAutor  ณ Geronimo Benedito Alves																	บData ณ29/12/17	   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: ESTOQUE - Itens Sem Movimenta็ใo 2  (M๓dulo 04-ESTOQUE)						   บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																											   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function MGF04R04()
	Local	_dDataInic	:= Ctod("")
	
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "ESTOQUE - Itens Sem Movimenta็ใo 2"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Itens Sem Movimenta็ใo 2"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Itens Sem Movimenta็ใo 2"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Itens Sem Movimenta็ใo 2"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  									)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""										

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02												 03					 	 		 04		 05	 06		 07		 08	 09		
	Aadd(_aCampoQry, { "B1_FILIAL"	,"COD_FILIAL"									,"Filial"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "M0_FILIAL"	,"NOME_FILIAL"									,"Descri็ใo da Filial"			,"C"	,040,0		,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_COD"		,"COD_PRODUTO"									,"C๓digo Produto"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_DESC"	,"DESC_PRODUTO"									,"Descri็ใo Produto"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_CHAVE"	,"COD_TIPO_PRODUTO"								,"C๓digo Tipo Produto"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_DESCRI"	,"DESC_TIPO_PRODUTO"							,"Descri็ใo Tipo Produto"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_DESCPO"	,"DESC_UNIDADE_MEDIDA"							,"Descri็ใo Unidade de medida"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_GRUPO"	,"COD_GRUPO_ESTOQUE"							,"C๓digo Grupo Estoque"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_DESC"	,"DESC_GRUPO_ESTOQUE"							,"Descri็ใo Grupo Estoque"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_CONTA"	,"CONTA_CONTABIL"								,"Conta Contแbil"				,""		,""	,"" 	,""		,""	,""	})// CHAR(9) -- NOVO 09/10
	Aadd(_aCampoQry, { "NNR_CODIGO"	,"COD_LOCAL_ESTOQUE"							,"C๓d. Local Estoque"			,""		,""	,"" 	,""		,""	,""	})// CHAR(2)  -- NOVO 09/10
	Aadd(_aCampoQry, { "NNR_DESCRI"	,"DESC_LOCAL_ESTOQUE"							,"Descri็ใo Local Estoque"		,""		,""	,"" 	,""		,""	,""	})// CHAR(20) -- NOVO 09/10
	Aadd(_aCampoQry, { "B2_USAI"	,"DATA_ULT_SAIDA"								,"Data ฺltima Saํda"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_DINVENT","DATA_INVENTARIO"								,"Data Inventแrio"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_DTINV"	,"DATA_BLOQUEIO"								,"Data Bloqueio"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_QATU"	,"QTD_ESTOQUE_ATUAL"							,"Qtde Estoque Atual"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_CM1"		,"CUSTO_UNITARIO"								,"Custo Unitแrio"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_VATU1"	,"CUSTO_TOTAL"									,"Custo Total"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "D3_EMISSAO"	,"DATA_MOVIMENTACAO AS DATA_ULTIMA_MOVIMENTACAO","Data Ultima Movim."			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "D1_DTDIGIT"	,"DATA_ULT_ENTRADA"								,"Data Ultima Entrada."			,""		,""	,"" 	,""		,""	,""	})
    //
	aAdd(_aParambox,{1,"Quant. dia sem movimento"	,0	,"@E 9,999"	,"" ,""	,"",050,.T.})
	aAdd(_aParambox,{1,"C๓digo Produto Inicial"	,Space(tamSx3("B1_COD")[1])		,""	,""													,"SB1"	,"",100,.F.})
	aAdd(_aParambox,{1,"C๓digo Produto Final"	,Space(tamSx3("B1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR02,MV_PAR03,'C๓digo de Produto')","SB1"	,"",100,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	_dDataInic	:= Dtos(dDataBase - _aRet[1] )

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
 
 	cQryTipPro	:= "SELECT ' ' as X5_CHAVE, 'Sem Tipo Produto' as X5_DESCRI FROM DUAL UNION ALL "
	cQryTipPro	+= "SELECT DISTINCT X5_CHAVE, X5_DESCRI"
	cQryTipPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")  ) + " TMPSX5 "
	cQryTipPro	+= "  WHERE  TMPSX5.X5_TABELA  = '02' " 
	cQryTipPro	+= "  AND    TMPSX5.D_E_L_E_T_ = ' '  " 
	cQryTipPro	+= "  ORDER BY X5_CHAVE"
	aCpoTipPro	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	,TamSx3("X5_CHAVE")[1]		} ,;
	aCpoTipPro	:=		{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI")	,TamSx3("X5_DESCRI")[1] }	} 
	cTitTipPro	:= "Marque os Tipos de Produtos เ serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_ALMOX_ITEMSEMMOVIMENTACAO2")   + CRLF 
	_cQuery += U_WhereAnd( .T. ,      " (  (DATA_MOVIMENTACAO_FILTRO <= '" + _dDataInic + "' OR DATA_MOVIMENTACAO_FILTRO IS NULL)   " ) // OBRIGATORIO, PERอODO ABERTO
	_cQuery += U_WhereAnd( .T. ,      "    (DATA_ULT_ENTRADA_FILTRO  <= '" + _dDataInic + "' OR DATA_ULT_ENTRADA_FILTRO  IS NULL) ) " ) // OBRIGATORIO, PERอODO ABERTO
	_cQuery += U_WhereAnd( .T. ,      " COD_FILIAL IN "       + _cCODFILIA	)														   // OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[3]),    " COD_PRODUTO BETWEEN '"   + _aRet[2] + "' AND '" + _aRet[3] + "' " )				   //NรO OBRIGATORIO
	If Empty( cCodTipPro )
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"     )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   COD_TIPO_PRODUTO IN "  + cCodTipPro                                       )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

