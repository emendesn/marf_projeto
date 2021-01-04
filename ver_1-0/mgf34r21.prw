#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R21	�Autor  � Geronimo Benedito Alves																	�Data �  13/07/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Contabilidade Gerencial - Provis�o   (Modulo 34-CTB)                             ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R21()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - Provis�o"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Provis�o"								)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Provis�o"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Provis�o"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02						 03							 04	 05	  06  07	 08	 09		
	Aadd(_aCampoQry, {"F1_FILIAL"	,"COD_FILIAL"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"			,"Nome Filial"				,"C",40	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PARCELA"	,"NUM_PARCELA"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIPO"					,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"COD_NATUREZA"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESC_NATUREZA"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"FORNECEDOR"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_LOJA"		,"LOJA_FORNECEDOR"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ"					,"CNPJ Fornecedor"			,"C",22	,0	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO_FILTRO"	,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCORI"	,"DT_VENCIMENTO_ORIGEM"	,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DATA"		,"DT_ULT_MOVIMENTO"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_VENCIMENTO_REAL"	,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VLR_TITULO"			,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALLIQ"	,"VALOR_LIQUIDO_BAIXA"	,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_DECRESC"	,"VLR_DECRESCIMO"		,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_BAIXA"				,""							,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_CONTAB  "			,""							,""	,""	,""	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")						,""	,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Emissao')"		,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Inicial"	,Ctod("")						,""	,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Data Vencimento')"	,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Baixa Inicial"			,Ctod("")						,""	,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Baixa Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'Data Baixa')"			,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Contabilizacao Inicial",Ctod("")						,""	,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Contabilizacao Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08	,'Data Contabilizacao')",""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Titulo"						,Space(tamSx3("E2_NUM")[1])		,"@!",""													,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,"@!",""													,"SA2"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Final"	,Space(tamSx3("A2_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR10, MV_PAR11	,'Codigo Fornecedor')"	,"SA2"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Natureza Inicial"	,Space(tamSx3("E2_NATUREZ")[1])	,"@!",""													,"SED"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Natureza Final"		,Space(tamSx3("E2_NATUREZ")[1])	,""	,"U_VLFIMMAI(MV_PAR10, MV_PAR11	,'Codigo Natureza')"	,"SED"	,""	, 050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_PROVISAO"  )            + CRLF
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " COD_FILIAL IN "                 + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DT_EMISSAO_FILTRO BETWEEN '"    + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " DT_VENCIMENTO_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),       " DT_BAIXA_FILTRO BETWEEN '"      + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),       " DT_CONTAB_FILTRO BETWEEN '"     + _aRet[7]  + "' AND '" + _aRet[8]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[9] ),       " NUM_TITULO LIKE '%"             + _aRet[9]  + "%' "                        ) //NAO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd(!empty(_aRet[11] ),      " COD_FORNECEDOR  BETWEEN '"      + _aRet[10] + "' AND '" + _aRet[11] + "' " ) //NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd(!empty(_aRet[13] ),      " COD_NATUREZA  BETWEEN '"        + _aRet[12] + "' AND '" + _aRet[13] + "' " ) //NAO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
 

