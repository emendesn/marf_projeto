#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R07	�Autor  � Geronimo Benedito Alves																	�Data �  11/07/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Devolucao X AR   (Modulo 05-FAT)                                   ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R07()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Devolucao X AR"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Devolucao X AR"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Devolucao X AR"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Devolucao X AR"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 
	// O nome do campo esta no elemento 2, mas, se � usado alguma funcao (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras �  
	// dado a ele um apelido indicado pela clausula "as" que sera transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos do Array, nao precisando declara-los.		
	// As unicas excecoes sao os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Titulo, que se no array _aCampoQry, estiver preenchido,
	// � preservado, nao sendo sobreposto pelo X3_DESCRIC 
	//					01			 02						 03							 04	 	05	06	 07	 	 08		 09
	Aadd(_aCampoQry, { "F1_FILIAL"	,"COD_FILIAL"			,""							,""		,""	,""	,""		,""		,""		})
	Aadd(_aCampoQry, { "M0_FILIAL"	, "NOME_FILIAL"			,"Nome Filial"				,"C"	,40	,0	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_TIPO"	,"TIPO_OPERACAO_NF"		,"Tipo Operacao NF"			,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZZH_AR"		,"NUMERO_AR"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_DTDIGIT"	,"DT_DIGITACAO"			,"Data lancamento NF"		,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_DOC"		,"NUMERO_NF"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_SERIE"	,"SERIE_NF"				,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_NFORI"	,"NUMERO_NF_ORIGEM"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_SERIE"	,"SERIE_NF_ORIGEM"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F2_EMISSAO"	,"DT_EMISAO_ORIGEM"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZAV_CODIGO"	,"COD_RAMI"				,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZAV_DTABER"	,"DT_ABERT_RAMI"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZAU_MOTIVO"	,"MOTIVO_RAMI"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZAU_JUSTIF"	,"JUSTIFICATIVA_RAMI"	,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_FORNECE"	,"COD_CLIENTE"			,"Codigo Cliente"			,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "F1_LOJA"	,"LJ_CLIENTE"			,"Loja Cliente"				,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "A1_CGC"		,"CNPJ_CLIENTE"			,"CNPJ Cliente"				,"C"	,22	,0	,"@!"	,""		,"@!"	})
	Aadd(_aCampoQry, { "A1_NOME"	,"NOME_CLIENTE"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_ITEM"	,"ITEM"					,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_COD"	,	"COD_PRODUTO"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "B1_DESC"	,"DESC_PRODUTO"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "B1_LOCPAD"	,"LOCAL_ARMAZ"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_QUANT"	,"QTDE_DEVOLV_NF"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_VUNIT"	,"VLR_UNIT_NF"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "D1_TOTAL"	,"VLR_TOTAL_NF"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZZI_QCONT"	,"QTD_CONTADA"			,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZZI_QNF"	,"QTD_DIFERENCA"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "A4_COD"		,"COD_TRASPORTADOR"		,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "A4_NOME"	,"DESC_TRANSPORTADOR"	,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "A4_CGC"		,"CNPJ_TRANSPORTADOR"	,"Cnpj Transportadora"		,"C"	,22	,0	,"@!"	,""		,"@!"	})
	Aadd(_aCampoQry, { "DA3_PLACA"	,"PLACA"				,""							,""		,""	,	,""		,""		,""		})
	Aadd(_aCampoQry, { "ZZH_STATUS"	,"STATUS_AR"			,"Status AR"				,"C"	,50	,0	,""		,""		,""		})

	aAdd(_aParambox,{1,"Data lancamento NF Inicial"	,Ctod("")		,""	,""														,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Data lancamento NF Final"	,Ctod("")		,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data lancamento NF')"	,""		,""	, 050,.T.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_DEVOLUCAO_AR"  )          + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_FILIAL IN "                + _cCODFILIA	                         ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_DIGITACAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // NAO OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

