#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF02R05	�Autor  � Geronimo Benedito Alves																	�Data � 02/05/18   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: COMPRAS - Contrato Compras x Fiscal                      (Modulo 02-Compras)     ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF02R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS - Contrato Compras x Fiscal"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Contrato Compras x Fiscal"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Contrato Compras x Fiscal"} 			)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Contrato Compras x Fiscal"}			)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  							)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 					)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02							03					 	04	05	 06		07		08	09		
	Aadd(_aCampoQry, { "C3_NUM"		,"CONTRATO"				,"Contrato"					,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_COD"		,"FORNECEDOR"			,"Fornecedor"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_LOJA"	,"LOJA"					,"Loja"						,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME"	,"RAZAO_SOCIAL"			,"Razao Social"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "C3_PRODUTO"	,"COD_PROD"				,"Cod. Produto"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_DESC"	,"DESCRICAO"			,"Descricao do Produto"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "C3_DATPRF"	,"DT_VLD_CONTRATO"		,"Cod. Produtor"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "X5_DESCRI"	,"ORIGEM"				,"Origem"					,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "F4_CODIGO"	,"COD_TES"				,"TES"						,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "F4_TEXTO"	,"DESC_TES"				,"Descricao da TES"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_POSIPI"	,"NCM_PRODUTO"			,"NCM Produto"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "C3_IPI"		,"ALIQ_IPI_CONTRATO"	,"Aliq. IPI Contrato"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_IPI"		,"ALIQ_IPI_CADASTRO"	,"Aliq. IPI Cadastro"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_GRPTRIB"	,"GRUPO_TRIBUTO_FORNECE","Grupo Tributo Fornecedor"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_GRTRIB"	,"GRUPO_TRIBUTO"		,"Grupo Tributo"			,""		,	, 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Codigo TES Inicial"				,Space(tamSx3("F4_CODIGO")[1])	,"@!"	,""															,"SF4"	,"",050,.F.})
	aAdd(_aParambox,{1,"Codigo TES Final"				,Space(tamSx3("F4_CODIGO")[1])	,"@!"	,""															,"SF4"	,"",050,.F.})
	aAdd(_aParambox,{1,"Data Validade Contrato Inicial"	,Ctod("")						,""		,"" 														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Validade Contrato Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Validade Contrato')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Contrato"						,Space(tamSx3("C3_NUM")[1])		,"@!"	,""															,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"		,Space(tamSx3("A2_COD")[1])		,"@!"	,""															,"SA2"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"			,Space(tamSx3("A2_COD")[1])		,"@!"	,""															,"SA2"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"			,Space(tamSx3("B1_COD")[1])		,"@!"	,""															,"SB1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final"				,Space(tamSx3("B1_COD")[1])		,"@!"	,""															,"SB1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Cod. Tributo IPI Inicial"		,Space(tamSx3("A2_GRPTRIB")[1])	,"@!"	,""															,"ZA"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Tributo IPI Final"			,Space(tamSx3("A2_GRPTRIB")[1])	,"@!"	,""															,"ZA"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cQuery += "	FROM " + U_IF_BIMFR("IF_BIMFR", "V_COMPRAS_CONTCOMPRAS_FISCAL" ) +CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " COD_TES  BETWEEN '"                + _aRet[1]  + "' AND '" + _aRet[2]  + "' " )	// NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),   " DT_VLD_CONTRATO_FILTRO BETWEEN '"  + _aRet[3]  + "' AND '" + _aRet[4]  + "' "	)	// NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),   " CONTRATO LIKE '%"                  + _aRet[5]  + "%' "	                    )	//NAO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),   " FORNECEDOR BETWEEN '"              + _aRet[6]  + "' AND '" + _aRet[7]  + "' "	)	// NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),   " COD_PROD BETWEEN '"                + _aRet[8]  + "' AND '" + _aRet[9]  + "' "	)	// NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),  " GRUPO_TRIBUTO BETWEEN '"           + _aRet[10] + "' AND '" + _aRet[11] + "' "	)	// NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
