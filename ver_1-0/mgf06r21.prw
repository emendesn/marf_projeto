#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R21	�Autor  � Geronimo Benedito Alves																	�Data �  11/07/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FINANCEIRO (CONTAS A PAGAR - Comiss�o   (Modulo 06-FIN)                     ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R21()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas a Pagar - Comiss�o"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Comiss�o"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Comiss�o"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Comiss�o"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""
	
	//   Vers�o Nova  do posicionamento dos campos da _aCampoQry
	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 
	// O nome do campo esta no elemento 2, mas, se � usado alguma funcao (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras �  
	// dado a ele um apelido indicado pela clausula "as" que sera transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos do Array, nao precisando declara-los.		
	// As unicas excecoes sao os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Titulo, que se no array _aCampoQry, estiver preenchido,
	// � preservado, nao sendo sobreposto pelo X3_DESCRIC 
	//					01			 02						 03							 04		 05		 06	07	08	09
	Aadd(_aCampoQry, {"E1_FILIAL"	,"COD_FILIAL"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"			,"Nome Filial"				,"C"	,40		,0	,""	,""	,""	})	// Este campo nao existe no SX3
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"NUM_PREFIXO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_LOJA"		,"NUM_LOJA_CLIENTE"		,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"NUM_CNPJ"				,""							,""		,18		,""	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_COMIS1"	,"PRC_COMISSAO"			,"% Comiss�o"				,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VEND1"	,"COD_VENDEDOR"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO_ORIGINAL"	,"Valor Titulo Original"	,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_TITULO_BASE"		,"Valor Titulo Base"		,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_COMISSAO_LIQ"		,"Valor Comiss�o Liquido"	,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DEVOLVIDO"		,"Valor Devolvido"			,""		,""		,""	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Movimentacao Inicial"	,Ctod("")						,""	,""														,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Data Movimentacao Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Movimentacao')"	,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Codigo Cliente Inicial"		,Space(tamSx3("A1_COD")[1])		,""	,""														,"CLI"	,""	, 050,.F.})													
	aAdd(_aParambox,{1,"Codigo Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Vendedor Inicial"	,Space(tamSx3("E1_VEND1")[1])	,""	, 														,"SA3"	,""	, 050,.F.})  
	aAdd(_aParambox,{1,"Codigo Vendedor Final"		,Space(tamSx3("E1_VEND1")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Vendedor')"		,"SA3"	,""	, 050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_COMISSAO"  )              + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_MOVIMENTACAO_FILTRO BETWEEN '"  + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN "               + _cCODFILIA                               ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " COD_CLIENTE BETWEEN '"        + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " COD_VENDEDOR BETWEEN '"       + _aRet[5]   + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
