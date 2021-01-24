#INCLUDE "totvs.ch" 


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ MGF02R01	ºAutor  ³ Geronimo Benedito Alves																	ºData ³  13/12/17  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.		³ Rotina que mostra na tela os dados da planilha: COMPRAS - Acompanhamento Compras  (Módulo 02-COM)									º±±
//±±º			³ Os dados sao obtidos e mostrados na tela atravéz da execução de query, e depois, o usuario pode gerar uma planilha excel com eles º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso		³ Marfrig Global Foods																												º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MGF02R01()
	Local _nI
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Almoxarifado - Acompanhamento Compras"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Acompanhamento Compras"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Acompanhamento Compras"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Acompanhamento Compras"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )											//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )									//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_nInterval	:= 35												//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado    
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//					01			 02												 03							 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "A1_NOME"	,"DESC_FILIAL					as DESCFILIAL"	,"Descrição da Filial"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"SITUACAO_PEDIDO				as SITUPEDIDO"	,"Situação do Pedido"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_NUM"		,"NUMERO_PEDIDO					as NUMEPEDIDO"	,"Nº Pedido Compra"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_DATPRF"	,"DATA_ENTREGA_PEDIDO			as DTENTRPEDI"	,"Data Entrega Pedido"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_EMISSAO"	,"DATA_PEDIDO					as DATAPEDIDO"	,"Data Pedido"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A2_COD"		,"COD_FORNECEDOR"								,"Cód. Fornecedor"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_FORNECEDOR"								,"Nome Fornecedor"			,""	,""	,""	,""	,""	,""	})																																															  
	Aadd(_aCampoQry, { "F2_FILIAL"	,"COD_PRODUTO					as CODPRODUTO"	,"Produto"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_PRODUTO"	,"DESC_PRODUTO					as DESCPRODUT"	,"Descrição Produto"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "BM_GRUPO"	,"COD_GRUPO_PRODUTO				as CODGRUPROD"	,"Código Grupo"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "BM_DESC"	,"DESC_GRUPO_PRODUTO			as DESCGRUPRO"	,"Descrição Grupo"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "X5_CHAVE"	,"COD_TIPO_PRODUTO				as CODTIPPROD"	,"Tipo de Produto"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "X5_DESCRI"	,"DESC_TIPO_PRODUTO				as DESCTIPPRO"	,"Descrição Tipo do Produto",""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C1_NUM"		,"NUM_SOLICITACAO_COMPRA 		as NUMSOLICCP"	,U_X3Titulo("C1_NUM")		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C1_DATPRF"	,"DATA_NECESSIDADE_SOLICITACAO	as DTNECESSID"	,"Data Necessidade"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C1_EMISSAO"	,"DATA_SOLICITACAO				as DTSOLICITA"	,U_X3Titulo("C1_EMISSAO")	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CCF_NRDCOM"	,"COD_SOLICITANTE				as CODSOLICIT"	,"Cod. Solicitante"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"NOME_SOLICITANTE				as NOMESOLICI"	,"Nome Solicitante"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "Y1_COD"		,"COD_COMPRADOR					as CODCOMPRAD"	,"Cod. Comprador"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "Y1_NOME"	,"NOME_COMPRADOR				as NOMECOMPRA"	,"Nome Comprador"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_QTDSOL"	,"QTD_SOLICITADA				as QTDSOLICIT"	,U_X3Titulo("C7_QTDSOL")	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_QUANT"	,"QTD_PEDIDO"									,"QTDE Pedido"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C7_ZVERSAO"	,"VERSAO_GRADE					as VERSAOGRAD"	,"Versão Grade"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_USER"	,"COD_APROV_N1 					as COD_APR_N1"	,"Código Usuário 1"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATALIB_APROV_N1 				as DAT_LIB_N1"	,"Data Liberada 1"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "AK_NOME"	,"NOME_APROV_N1 				as NOMEAPR_N1"	,"Nome Aprovador 1"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"STATUS_N1 "									,"Status 1"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_USER"	,"COD_APROV_N2 					as COD_APR_N2"	,"Cód. Usuário 2"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATALIB_APROV_N2 				as DAT_LIB_N2"	,"Data Liberada 2"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "AK_NOME"	,"NOME_APROV_N2 				as NOMEAPR_N2"	,"Nome Aprovador 2"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"STATUS_N2 "									,"Status 2"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_USER"	,"COD_APROV_N3 					as COD_APR_N3"	,"Cód. Usuário 3"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATALIB_APROV_N3 				as DAT_LIB_N3"	,"Data Liberada 3"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "AK_NOME"	,"NOME_APROV_N3 				as NOMEAPR_N3"	,"Nome Aprovador 3"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "A1_NOME"	,"STATUS_N3 "									,"Status 3"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_USER"	,"COD_APROV_N4 					as COD_APR_N4"	,"Cód. Usuário 4"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATALIB_APROV_N4 				as DAT_LIB_N4"	,"Data Liberada 4"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "AK_NOME"	,"NOME_APROV_N4 				as NOMEAPR_N4"	,"Nome Aprovador 4"			,""	,""	,""	,""	,""	,""	}) 
	Aadd(_aCampoQry, { "A1_NOME"	,"STATUS_N4 "									,"Status 4"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_USER"	,"COD_APROV_N5 					as COD_APR_N5"	,"Cód. Usuário 5"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "CR_DATALIB"	,"DATALIB_APROV_N5 				as DAT_LIB_N5"	,"Data Liberada 5"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "AK_NOME"	,"NOME_APROV_N5 				as NOMEAPR_N5"	,"Nome Aprovador 5"			,""	,""	,""	,""	,""	,""	}) 
	Aadd(_aCampoQry, { "A1_NOME"	,"STATUS_N5 "									,"Status 5"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "C1_ZOBSEST"	,"OBSERVACAO_ESTOQUE"							,"Observação Estoque"		,""	,""	,""	,""	,""	,""	}) 
																																						
	aAdd(_aParambox,{1,"Data Pedido Inicial"	,Ctod("")						,""	,""													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Pedido Final"		,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Código Produto Inicial"	,Space(tamSx3("B1_COD")[1])		,""	,""													,"SB1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Código Produto Final"	,Space(tamSx3("B1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03,MV_PAR04,'Código de Produto')","SB1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Solicitante Inicial"	,Space(6)						,""	,""													,"USR"	,"",070,.F.})
	aAdd(_aParambox,{1,"Solicitante Final"		,Space(6)						,""	,"U_VLFIMMAI(MV_PAR05,MV_PAR06,'Solicitante')"		,"USR"	,"",070,.F.})
	aAdd(_aParambox,{1,"Tipo Produto Inicial"	,Space(tamSx3("X5_CHAVE")[1])	,""	,""													,"02"	,"",070,.F.})
	aAdd(_aParambox,{1,"Tipo Produto Final"		,Space(tamSx3("X5_CHAVE")[1])	,""	,"U_VLFIMMAI(MV_PAR07,MV_PAR08,'Tipo de Produto')"	,"02"	,"",070,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//---- S  I  T  U  A  C  A  O		P  E  D  I  D  O
	cQrySituPC	:= "SELECT X5_CHAVE, X5_DESCRI "
	cQrySituPC	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")) + " TMPSX5 " 
	cQrySituPC	+= "  WHERE TMPSX5.X5_TABELA	= 'ZV' "
	cQrySituPC	+= "  AND	TMPSX5.D_E_L_E_T_  =  ' ' " 
	aCpoSituPC	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	, TamSx3("X5_CHAVE")[1]  } , ;
	{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI"), TamSx3("X5_DESCRI")[1] }	} 
	cTituSitPC	:= "Marque Situações Possiveis a serem listadas: "
	nPosRetorn	:= 2		// Quero que seja retornado o segundo campo: X5_DESCRI

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
	//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
	aSituacaPC	:= U_MarkGene(cQrySituPC, aCpoSituPC, cTituSitPC, nPosRetorn, @_lCancProg )
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aSituacaPC)
		aSituacaPC[_ni] := Alltrim(aSituacaPC[_ni]) 
	Next
	cSituacaPC	:= U_Array_In( aSituacaPC )
	
	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_ALMOX_ACOMPANHAMENTOPEDIDO")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " DATA_PEDIDO_FILTRO  BETWEEN '"    + _aRet[1] + "' AND '" + _aRet[2] + "' " )	// OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ), " COD_FILIAL IN "                   + _cCODFILIA                             )	// OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd(.T. ,                " COD_PRODUTO >= '500000' "                                                  )
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " COD_PRODUTO BETWEEN '"            + _aRet[3] + "' AND '" + _aRet[4] + "' " )	// NÃO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6]),    " ID_SOLICITANTE_FILTRO BETWEEN '"  + _aRet[5] + "' AND '" + _aRet[6] + "' " )	// NÃO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8]),    " COD_TIPO_PRODUTO BETWEEN '"       + _aRet[7] + "' AND '" + _aRet[8] + "' " )	// NÃO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(cSituacaPC),  " SITUACAO_PEDIDO IN "              + cSituacaPC                             )	// NÃO OBRIGATORIO (COMBO PARA SELECIONAR - SELECT PARA POPULAR O COMBO ABAIXO)

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN
