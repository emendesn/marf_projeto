#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa   � MGF04R03	�Autor  � Geronimo Benedito Alves																	�Data � 12/03/18   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: ESTOQUE - Boletim de Abate					(Modulo 04-ESTOQUE)		  		   ���
//���			� Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF04R03()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "ESTOQUE - Boletim de Abate"	)		//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Boletim de Abate"				)		//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Boletim de Abate"}			)		//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Boletim de Abate"}			)		//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)		//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)		//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02								 	 03					 04		 05	 06		 07		 08	 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"						,"Cod. Filial"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_FILIAL		as NOM_FILIAL"	,"Nome Filial"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_DTPROD"	,"DATA_PRODUCAO		as DTPRODUCAO"	,"Data Producao"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_PEDIDO"	,"NUMERO_PEDIDO		as NUM_PEDIDO"	,"N� Pedido"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_FORNEC"	,"COD_FORNECEDOR	as CODFORNECE"	,"Cod. Fornecedor"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_LOJA"	,"LOJA_FORNECEDOR	as LOJAFORNEC"	,"Loja Fornecedor"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_NOME"	,"NOME_FORNECEDOR	as NOMEFORNEC"	,"Nome Fornecedor"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_DOC"		,"NUMERO_NF"						,"N� NF"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_SERIE"	,"NUMERO_SERIE_NF	as NUMSERIENF"	,"Serie NF"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZM_NUMOP"	,"NUMERO_OP"						,"N� Operacao"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_PRODUT"	,"COD_PRODUTO		as CODPRODUTO"	,"Cod. Produto"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO		as DESCPRODUT"	,"Descr. Produto"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_QTCAB"	,"QTD_CABECAS		as QTDCABECAS"	,"Qtd. de Cabecas",  ""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_QTKG"	,"QTD_QUILOS"						,"Qtd. de Quilos"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_QTPE"	,"QTD_PERDA"						,"Qtd. de Perda"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_VLARRO"	,"VALOR_ARROBA		as VLR_ARROBA"	,"Vlr. Arroba"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_VLTOT"	,"VALOR_TOTAL		as VLR_TOTAL"	,"Vlr. Total"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZN_CODAGR"	,"AGRUPADOR"						,"Agrupador"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"DATA_DIGITACAO"					,"Data Digitacao"	,""		,""	,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data de Producao Inicial"	,Ctod("")					,"",""													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data de Producao Final"		,Ctod("")					,"","U_VLFIMMAI(MV_PAR01, MV_PAR02,'Data de Producao')"	,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])	,"",""													,"CF8A2","",050,.F.}) 
	aAdd(_aParambox,{1,"Loja Fornecedor Inicial"	,Space(tamSx3("A2_LOJA")[1]),"",""													,""		,"",020,.F.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Final"	,Space(tamSx3("A2_COD")[1])	,"","U_VLFIMMAI(MV_PAR03, MV_PAR05,'Cod. Fornecedor')"	,"CF8A2","",050,.F.})	
	aAdd(_aParambox,{1,"Loja Fornecedor Final"		,Space(tamSx3("A2_LOJA")[1]),"","U_VLFIMMAI(MV_PAR04, MV_PAR06,'Loja Fornecedor')"	,""		,"",020,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
 
	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_ESTOQUE_BOLETIMABATE")       + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " COD_FILIAL IN "                 + _cCODFILIA	                            )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " DATA_PRODUCAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO (DATA EMISSAO SOLICITACAO) - VALIDACAO PERIODO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),   " COD_FORNECEDOR BETWEEN '"       + _aRet[3] + "' AND '" + _aRet[5] + "' "	)	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),   " LOJA_FORNECEDOR BETWEEN '"      + _aRet[4] + "' AND '" + _aRet[6] + "' "	)	// NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
