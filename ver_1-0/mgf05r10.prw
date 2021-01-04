#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R10	�Autor  � Eduardo Augusto Donato																	�Data �  24/04/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Controle de Pallets					(Modulo 05-FAT)			���
//���			� Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R10()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Controle de Pallets"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Controle de Pallets"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Controle de Pallets"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Controle de Pallets"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03								 04		05	 06	 07		 08	 09		

	Aadd(_aCampoQry, {"C5_TIPO"		,"TIPO_MOVIMENTO"				,"Tipo Movimento"				,"C",001	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"C5_FILIAL"	,"COD_FILIAL"					,"Cod. Empresa"					,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_FILIAL"					,"Descricao Empresa"			,"C",030	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"D1_DOC"		,"NOTA_FISCAL"					,"N� Nota Fiscal"				,"C",010	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"D1_SERIE"	,"SERIE"						,"Serie NF"						,"C",005	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"D1_EMISSAO"	,"DATA_EMISSAO"					,"Data Emissao"					,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"DATA_DIGITACAO"				,"Data Digitacao"				,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"D1_COD"		,"COD_PRODUTO"					,"Cod. Produto"					,"C",020	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO"					,"Descr. Produto"				,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"F1_COND"		,"CONDICAO_PGTO"				,"Cod. Condicao"				,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESCRICAO_COND_PGTO"			,"Descr. Condicao"				,"C",030	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"F1_FORNECE"	,"COD_FORNECEDOR_CLIENTE"		,"Cod. Cliente Fornecedor"		,"C",008	,0	,""						,"" 	,"" })
	//Aadd(_aCampoQry, {"F1_LOJA"		,"LOJA"							,"Loja Cliente Fornecedor"		,"C",002	,0	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CPF"						,"CPF/CNPJ Cliente Fornecedor"	,"C",025	,0	,"@!"					,"" 	,"@!" })
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR_CLIENTE"		,"Nome Cliente Fornecedor"		,"C",050	,0	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"D1_QUANT"	,"QUANTIDADE"					,"Qtde Solicitada"				,"N",015	,2	,"@E 999,999,999,999.99","" 	,"" })
	Aadd(_aCampoQry, {"D1_TOTAL"	,"PRECO_UNIT_MEDIO"				,"Preco Unitario M�dio"			,"N",015	,2	,"@E 999,999,999,999.99","" 	,"" })
	Aadd(_aCampoQry, {"D1_TOTAL"	,"VALOR_TOTAL_ITEM"				,"Valor Total Item"				,"N",015	,2	,"@E 999,999,999,999.99","" 	,"" })
	AAdd(_aCampoQry, {"D1_CF"		,"CFOP"							,"Cod. CFOP"					,"C",004	,0	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"DESC_CFOP"					,"Descricao CFOP"				,"C",020	,0	,""						,"" 	,"" })

	/*WHERE COD_FILIAL IN ('02001','','') --OBRIGATORIO, SELECAO FILIAL
    AND DATA_FILTRO BETWEEN '20181201' AND '20181231' --OBRIGATORIO - TRAVA 45 DIAS
    AND COD_PRODUTO BETWEEN '01' AND '10' --NAO OBRIGATORIO DE/ATE
	AND COD_FORNECEDOR_CLIENTE --COMBO DE SELECAO CONFORME PADRAO -- PRECISARIA DE DOIS COMBOS, UM DE FORNECEDOR E UM DE CLIENTE NAO SENDO OBRIGATORIO
	AND LOJA -- COMBO DE SELECAO CONFORME PADRAO -- PRECISARIA DE DOIS COMBOS, UM DE FORNECEDOR E UM DE CLIENTE NAO SENDO OBRIGATORIO
	AND TIPO_MOVIMENTO -- NAO OBRIGATORIO / SELECAO (ENTRADA OU SAIDA) A NAO SELECAO MOSTRAR TODOS
	*/


	aAdd(_aParambox,{1,"Data Digitacao Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Digitacao Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrega')"	,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"	,Space(tamSx3("C6_PRODUTO")[1])	,""		,""													,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final"		,Space(tamSx3("C6_PRODUTO")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Produto')"	,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{3,"Tipo Movimento"			,Iif(Set(_SET_DELETED),1,2), {"TODOS","ENTRADA","SAIDA" }, 100, "",.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
 
	If _aRet[5] <> 1	// 1=Todos
		_cTpMovimento	:= If(_aRet[5] == 2, "ENTRADA" , "SAIDA" )
	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Digitacao Inicial, nao pode ser maior que a data de Digitacao Final.")
		Return.F.
	Endif
	
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

	//=========	S E L E C I O N A     C L I E N T E  
	cQryCliente	:= "SELECT ' ' as A1_COD_LOJ, 'NAO INFORMADO' as A1_NOME, ' ' AS A1_CGC  FROM DUAL UNION ALL "
	cQryCliente	+= "SELECT A1_COD||A1_LOJA as A1_COD_LOJ, A1_NOME "
	cQryCliente	+= " ,CASE LENGTH(TRIM(A1_CGC))                   "
	cQryCliente	+= "      WHEN NULL                               " 
	cQryCliente	+= "          THEN ''                             "
	cQryCliente	+= "      WHEN 0                                  "
	cQryCliente	+= "          THEN ''                             "
	cQryCliente	+= "      WHEN 11                                 "
	cQryCliente	+= "          THEN SUBSTR(A1_CGC,1,3)||'.'||SUBSTR(A1_CGC,4,3)||'.'||SUBSTR(A1_CGC,7,3)||'-'||SUBSTR(A1_CGC,10,2) "
	cQryCliente	+= "      WHEN 14                                 "
	cQryCliente	+= "          THEN SUBSTR(A1_CGC,1,2)||'.'||SUBSTR(A1_CGC,3,3)||'.'||SUBSTR(A1_CGC,6,3)||'/'||SUBSTR(A1_CGC,9,4)||'-'|| SUBSTR(A1_CGC,13,2) "
	cQryCliente	+= "      ELSE A1_CGC                             "
	cQryCliente	+= "  END                              AS A1_CGC   "
	cQryCliente  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA1")  ) + " TMPSA1 "
	cQryCliente	+= "  WHERE TMPSA1.D_E_L_E_T_ = ' ' " 
	//cQryFornec	+= "  AND TMPSA2.A2_COD <  '000101'  " 
	cQryCliente	+= "  ORDER BY A1_COD_LOJ"

	aCpoClient	:=	{	{ "A1_COD_LOJ"	,"Codigo-loja"			,TamSx3("A1_COD")[1] + TamSx3("A1_LOJA")[1] +20		} ,;
	aCpoClient	:=		{ "A1_NOME"		,"Nome do Cliente"		,TamSx3("A1_NOME")[1]  +50  }	 ,; 
	aCpoClient	:=		{ "A1_CGC"		,U_X3Titulo("A1_CGC")	,TamSx3("A1_CGC")[1]  }	} 
	cTitClient	:= " Marque os Clientes � listar."
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_aCliente	:= U_MarkForn(cQryCliente, aCpoClient, cTitClient, nPosRetorn, @_lCancProg )
	_cCliente	:= U_Array_In( _aCliente )
	If _lCancProg
		Return
	Endif 
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTROLE_PALETE" ) +CRLF 

	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                                )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DATA_FILTRO BETWEEN '"  + _aRet[1]  + "' AND '" + _aRet[2] + "'  "	)	// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " COD_PRODUTO BETWEEN '"          + _aRet[3]  + "' AND '" + _aRet[4] + "'  "	)	// NAO OBRIGATORIO
	
	If _aRet[5] <> 1	// 1=Todos
		_cQuery += U_WhereAnd( !empty(_cTpMovimento ),    " TIPO_MOVIMENTO = '"          		+ _cTpMovimento + "' "	                )	// NAO OBRIGATORIO
	Endif
	_cCliFor := ""
	If !Empty(_cForneced) .or. !Empty(_cCliente)
		If !Empty(_cForneced)
		_cForneced := strtran(_cForneced,"(","")
		_cForneced := strtran(_cForneced,")","")
		_cForneced := strtran(_cForneced,"'","")
		EndIf
		If !Empty(_cCliente)
		_cCliente := strtran(_cCliente,"(","")
		_cCliente := strtran(_cCliente,")","")
		_cCliente := strtran(_cCliente,"'","")
		EndIf
		_cCliFor := "("+alltrim(_cForneced) + iif(Empty(_cCliente),"",",") + Alltrim(_cCliente)+")"
	EndIf
	
	If Empty( _cCliFor )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", _cCliFor ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_FORNECEDOR_CLIENTE IS NULL OR COD_FORNECEDOR_CLIENTE IN " + _cCliFor + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_FORNECEDOR_CLIENTE IN " + _cCliFor	)	
	Endif 

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN