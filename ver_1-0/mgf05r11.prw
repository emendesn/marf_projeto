#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ MGF05R03	ºAutor  ³ Eduardo Augusto Donato																	ºData ³  24/04/18  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.		³ Rotina que mostra na tela os dados da planilha: FATURAMENTO - Pedidos Cancelados      					(Módulo 05-FAT)			º±±
//±±º			³ Os dados sao obtidos e mostrados na tela atraves da execução de query, e depois, o usuario pode gerar uma planilha excel com eles º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso		³ Marfrig Global Foods																												º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MGF05R11()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Pedidos Cancelados"	)		//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Pedidos Cancelados"				)		//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Pedidos Cancelados"}				)		//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Pedidos Cancelados"}				)		//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado    
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//					01			 02											 03								 04		05	 06	 07		 08	 09		

	Aadd(_aCampoQry, {"C5_FILIAL"	,"COD_FILIAL"								,"Cód. Empresa"					,"C",006	,0	,"" 					,"" 	,"" })
	AAdd(_aCampoQry, {"A1_NOME"		,"DESC_FILIAL"								,"Descr. Filial"				,"C",030	,0	,"" 					,"" 	,"" })
	AAdd(_aCampoQry, {"C5_NUM"		,"PEDIDO"									,"Nº Pedido"					,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_CLIENTE"	,"COD_CLIENTE"								,"Cód. Cliente"					,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_LOJACLI"	,"LOJA_CLIENTE			 	as LJ_CLIENTE"	,"Loja Cliente"					,"C",002	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE				as NOM_CLIENT"	,"Nome Cliente"					,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_XCGCCPF"	,"CNPJ_CLIENTE"								,"CPF/CNPJ Cliente"				,"C",025	,0	,"@!"					,"" 	,"@!" })
	Aadd(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO			as ESPECIEPED"	,"Espécie Pedido"				,"C",003	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR			as COD_VENDED"	,"Cód. Vendedor"				,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR				as NOM_VENDED"	,"Nome Vendedor"				,"C",030	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C6_PRODUTO"	,"COD_PRODUTO				as CD_PRODUTO"	,"Cód. Produto"					,"C",015	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C6_DESCRI"	,"DESCRICAO"								,"Descr. Produto"				,"C",030	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO			 	as DT_EMISSAO"	,"Data Emissao"					,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_ZDTEMBA"	,"DATA_EMBARQUE			 	as DTEMBRAQUE"	,"Data Embarque"				,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C6_DATFAT"	,"DATA_FATURAMENTO  		as DT_FATURAM"	,"Data Faturamento"				,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QUANT_SOLICITADA  		as QTDESOLICI"	,"Qtde Solicitada"				,"N",015	,2	,"@E 999,999,999,999.99","" 	,"" })
	Aadd(_aCampoQry, {"C6_NOTA"		,"N_NF_CANCELADA"							,"Nº Nota Fiscal"				,"C",010	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C6_SERIE"	,"N_SERIE_CANCELADA"						,"Serie NF"						,"C",005	,0	,"" 					,"" 	,"" })

	aAdd(_aParambox,{1,"Data Emissão Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Emissão Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissão')"	,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Nº do Pedido"			,Space(tamSx3("C5_NUM")[1])		,"@!"	,""													,""		,""	,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
 
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	IF Empty(_aRet[1]) .and. Empty(_aRet[2])
		MsgStop("É obrigatório o preenchimento do parâmetro data de Emissao Final.")
		Return.F.
	Endif
	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Emissão Inicial, não pode ser maior que a data de Emissão Final.")
		Return.F.
	Endif
	
	//===		S E L E C I O N A	C L I E N T E
	/*	Traz todos os cliente
	cQryClient	:= "	SELECT '" +SPACE(TamSx3("A1_COD")[1] ) + "' as A1_COD , '" + SPACE(TamSx3("A1_LOJA")[1] ) + "' as A1_LOJA, ' Não Informado' as A1_NOME "
	cQryClient	+= "	FROM DUAL UNION ALL "
	cQryClient	+= "	SELECT DISTINCT A1_COD, A1_LOJA, A1_NOME "
	cQryClient  += "	FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA1") ) + " TMPSA1 " 
	cQryClient	+= "	WHERE TMPSA1.D_E_L_E_T_ = ' ' " 
	cQryClient	+= "	ORDER BY A1_COD, A1_LOJA, A1_NOME "
	aCpoClient	:=	{	{ "A1_COD"	,U_X3Titulo("A1_COD")			,TamSx3("A1_COD")[1]  		}	,;
						{ "A1_LOJA"	,U_X3Titulo("A1_LOJA")			,TamSx3("A1_COD")[1]  		}	,;
						{ "A1_NOME"	,U_X3Titulo("A1_NOME")			,TamSx3("A1_NOME")[1] 		}} 
	*/			
	// Traz todos os clientes que fizeram pedido no período nas filiais selecionadas
	cQryClient	:= "	SELECT '" +SPACE(TamSx3("C5_CLIENTE")[1] ) + "' as C5_CLIENTE , '" + SPACE(TamSx3("C5_LOJACLI")[1] ) + "' as C5_LOJACLI, ' Não Informado' as C5_XNOMECL "
	cQryClient	+= "	FROM DUAL UNION ALL "
	cQryClient	+= "	SELECT DISTINCT C5_CLIENTE, C5_LOJACLI, C5_XNOMECL "
	cQryClient  += "	FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SC5") ) + " TMPSC5 " 
	cQryClient	+= " 	WHERE C5_EMISSAO BETWEEN '"  + _aRet[1]  + "' AND '" + _aRet[2] + "'  "
	cQryClient	+= "	AND TMPSC5.D_E_L_E_T_ = ' ' " 
	cQryClient	+= "	AND	C5_FILIAL IN " + _cCODFILIA 		+CRLF
	cQryClient	+= "	ORDER BY C5_CLIENTE, C5_LOJACLI, C5_XNOMECL "
	aCpoClient	:=	{	{ "C5_CLIENTE"	,U_X3Titulo("C5_CLIENTE")			,TamSx3("C5_CLIENTE")[1]  		}	,;
						{ "C5_LOJACLI"	,U_X3Titulo("C5_LOJACLI")			,TamSx3("C5_LOJACLI")[1]  		}	,;
						{ "C5_XNOMECL"	,U_X3Titulo("C5_XNOMECL")			,TamSx3("C5_XNOMECL")[1] 		}} 
						
	cTitClient	:= "Clientes a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: C5_CLIENTE
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
	//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
	_cCliente	:= U_Array_In( U_MarkGene(cQryClient, aCpoClient, cTitClient, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_PEDIDOSCANCELADOS" ) +CRLF 

	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                                )	// OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DATA_EMISSAO_FILTRO BETWEEN '"  + _aRet[1]  + "' AND '" + _aRet[2] + "'  "	)	// OBRIGATORIO, COM A VALIDAÇÃO DE 90 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),     " PEDIDO LIKE '%"         + _aRet[3]  + "%' "	                        )	// NÃO OBRIGATORIO

	IF empty(_cCliente )
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", _cCliente ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_CLIENTE_FILTRO IS NULL OR COD_CLIENTE_FILTRO IN " + _cCliente + " )"              )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_CLIENTE_FILTRO IN " + _cCliente	                                        )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN