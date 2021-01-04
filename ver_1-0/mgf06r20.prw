#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R20	�Autor  � Geronimo Benedito Alves																	�Data � 05/07/17   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro - Contas � Pagar - Seguro                            (Modulo 06-FIN)  ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																										       ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R20()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas � Pagar - Seguro"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Seguro"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Seguro"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Seguro"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }				)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""
	

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02						 03						 04	 05		 06	 07			 08		 09		
	Aadd(_aCampoQry, {"E2_FILIAL"	,"COD_EMPRESA"			,"Filial"				,"C",006	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"XXM0FILIAL"	,"DESC_EMPRESA"			,"Descricao da Empresa"	,"C",040	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"			,"N� Titulo"			,"C",009	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E5_FORNECE"	,"COD_FORNECEDOR"		,"Fornecedo"			,"C",006	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E5_LOJA"		,"COD_LOJA"				,"Loja Fornec"			,"C",002	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"XXA2_CGC"	,"CNPJ_FORNECEDOR"		,"CNPJ Fornecedor"		,"C",018	,0	,"@!" 		,"" 	,"@!" })
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR"		,"Nome Fornecedor"		,"C",040	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"ED_CODIGO"	,"COD_NATUREZA"			,"Natureza"				,"C",010	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESCR_NATUREZA"		,"Descricao Natureza"	,"C",040	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_NF"				,"Valor NF"				,"N",016	,2	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_LIQUIDO_PAGAR"	,"Valor � Pagar"		,"N",016	,2	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_VALLIQ"	,"VALOR_PAGO"			,"Valor Pago"			,"N",016	,2	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_DESCONT"	,"DESCONTO"				,"Desconto"				,"N",016	,2	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"			,"DT Emissao"			,"D",008	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO"		,"DT Vencto"			,"D",008	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_PAGAMENTO"			,"DT Pagto"				,"D",008	,0	,"" 		,"" 	,"" })

	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")					,""							,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")					,""							,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Emissao')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Inicial"	,Ctod("")					,""							,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Final"		,Ctod("")					,""							,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Data Vencimento')",""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento Inicial"		,Ctod("")					,""							,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento Final"		,Ctod("")					,""							,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'Data Pagamento')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"CNPJ Inicial"				,Space(tamSx3("A2_CGC")[1])	,"@R 99.999.999/9999-99"	,""													,""		,"",100,.F.})  

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)


	//=========	S E L E C I O N A     P R O D U T O  
	cQryProdut	:= "SELECT ' ' as B1_COD, 'NAO INFORMADO' as B1_DESC FROM DUAL UNION ALL "
	cQryProdut	+= "SELECT DISTINCT B1_COD, B1_DESC"
	cQryProdut  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SB1")  ) + " TMPSB1 "
	cQryProdut	+= "  WHERE TMPSB1.D_E_L_E_T_ = ' ' " 
	//cQryProdut	+= "  AND TMPSB1.B1_COD <  '000101'  " 
	cQryProdut	+= "  AND TMPSB1.B1_COD NOT IN ('817979', '758711', '855659' )  " 
	cQryProdut	+= "  ORDER BY B1_COD"

	aCpoProdut	:=	{	{ "B1_COD"		,U_X3Titulo("B1_COD")	,TamSx3("B1_COD")[1]		} ,;
	aCpoProdut	:=		{ "B1_DESC"	,U_X3Titulo("B1_DESC")	,TamSx3("B1_DESC")[1] }	} 
	cTitProdut	:= " Marque os Produtos � listar."		// No relatorio, sempre serao listados, ao menos os produtos: 817979, 758711 e 855659"
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	Private lChk
	_aProduto	:= U_MarkProd(cQryProdut, aCpoProdut, cTitProdut, nPosRetorn, @_lCancProg )
	If lChk					// Se marcou todos os produtos, 
		_aProduto	:= {}	// Torno o vetor _aProduto vazio para nem precisar gerar o filtro que ficaria enorme, lento e sucetivel a erro de memoria. 
	Else
		Aadd(_aProduto, '817979' )
		Aadd(_aProduto, '758711' )
		Aadd(_aProduto, '855659' )
	Endif
	_cProduto	:= U_Array_In( _aProduto )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_SEGURO"  )                  + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_EMPRESA IN "                + _cCODFILIA                                ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_EMISSAO_FILTRO BETWEEN '"    + _aRet[1]    + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " DT_VENCIMENTO_FILTRO BETWEEN '" + _aRet[3]    + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " DT_PAGAMENTO_FILTRO BETWEEN '"  + _aRet[5]    + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7]),       " CNPJ_FORNECEDOR_FILTRO LIKE '%" + _aRet[7]    + "%' "                       ) //NAO OBRIGATORIO - USUARIO DIGITA O NOME		

	If empty(_cProduto)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cProduto ) <> 0
		_cQuery += U_WhereAnd(  .T. , " ( COD_PRODUTO_FILTRO IS NULL OR COD_PRODUTO_FILTRO IN " + _cProduto + " )"                             ) 
	Else	
		_cQuery += U_WhereAnd(  .T. , " COD_PRODUTO_FILTRO IN " + _cProduto                                                              ) 	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
