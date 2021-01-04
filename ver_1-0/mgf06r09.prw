#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R09	�Autor  �Geronimo Benedito Alves																	�Data �15/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Titulos Bloqueados (Modulo 06-FIN)					���
//���			� Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R09()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Pagar - Titulos Bloqueados"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Titulos Bloqueados"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Titulos Bloqueados"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Titulos Bloqueados"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03						 04	 05		 06	 07						 08	 09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"COD_EMPRESA_ORIGEM	as EMPRESAORI"	,"Empresa Origem"		,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_EMPRESA_ORIGEM	as NOMEEMPORI"	,"Descr. Empresa Origem","C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"								,"Prefixo"				,"C",003	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"TB6_CODTIP"	,"TIPO"									,"Tipo"					,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR		as CODFORNECE"	,"Cod. Fornecedor"		,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR		as NOMEFORNEC"	,"Nome Fornecedor"		,"C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"							,"N� Titulo"			,"C",009	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_CODBAR"	,"COD_BARRA"							,"Cod. Barras"			,"C",044	,0, ""						,""	,""	})  // Paulo Henrique - 01/10/2019 - Inclusao dos Codigos de barras
	Aadd(_aCampoQry, {"F1_ZAUDUSR"	,"USUARIO_AUDITOR		as USRAUDITOR"	,"Usuario Auditor"		,"C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"CR_EMISSAO"	,"DATA_EMISSAO			as DT_EMISSAO"	,"Data Emissao"			,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"CR_ZNATURE"	,"COD_NATUREZA			as CDNATUREZA"	,"Cod. Natureza"		,"C",010	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"CR_ZNATDES"	,"DESC_NATUREZA			as DSCNATUREZ"	,"Descr. Natureza"		,"C",030	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"VENCIMENTO"							,"Vencimento"			,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"VENCIMENTO_REAL		as VENCI_REAL"	,"Vencimento Real"		,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_TITULO			as VALORTITUL"	,"Valor Titulo"			,"N",016	,2, "@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N1			as NOMEAPROV1"	,"Nome Aprovador 1"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N2			as NOMEAPROV2"	,"Nome Aprovador 2"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N3			as NOMEAPROV3"	,"Nome Aprovador 3"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N4			as NOMEAPROV4"	,"Nome Aprovador 4"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N5			as NOMEAPROV5"	,"Nome Aprovador 5"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N6			as NOMEAPROV6"	,"Nome Aprovador 6"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"AK_NOME"		,"NOME_APROV_N7			as NOMEAPROV7"	,"Nome Aprovador 7"		,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_ORIGEM"	,"MOD_ORIGEM"							,"Modulo Origem"		,"C",010	,0, ""						,""	,""	})

	aAdd(_aParambox,{1,"Data Vencimento Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Vencimento')",""		,"",050,.F.})
	aAdd(_aParambox,{1,"Vencimento Real Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Vencimento Real Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Vencimento Real')",""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,"@!"	,"" 												,"SA2"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"		,Space(tamSx3("A2_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod.Fornecedor')"	,"SA2"	,"",050,.F.})		
	aAdd(_aParambox,{1,"Numero Titulo"				,Space(tamSx3("E2_NUM")[1])		,""		,"" 												,""		,"",050,.F.})		
	aAdd(_aParambox,{1,"Prefixo Inicial"			,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,"" 												,""		,"",050,.F.})  
	aAdd(_aParambox,{1,"Prefixo Final"				,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'Cod.Fornecedor')"	,""		,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Inicial"		,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,"" 												,"SED"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Final"		,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR10, MV_PAR11, 'Cod. Natureza')"	,"SED"	,"",050,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	IF Empty(_aRet[2]) .and. Empty(_aRet[4])
		MsgStop("� obrigatorio o preenchimento do parametro data de Vencimento final e/ou do parametro data de Vencimento Real final.")
		Return.F.

	ElseIf _aRet[1] > _aRet[2]
		MsgStop("A Data de Vencimento Inicial, nao pode ser maior que a data de Vencimento Final.")
		Return.F.

	ElseIf _aRet[3] > _aRet[4]
		MsgStop("A Data de Vencimento Real Inicial, nao pode ser maior que a data de Vencimento Real Final.")
		Return.F.

	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_TITULOGRADEAPR" ) +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_VENCIMENTO_FILTRO BETWEEN '"      + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " DT_VENCIMENTO_REAL_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_EMPRESA_ORIGEM IN "              + _cCODFILIA                             ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),     " COD_FORNECEDOR  BETWEEN '"           + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),     " NUM_TITULO = '"                      + _aRet[7]  + "' "                        ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),     " PREFIXO  BETWEEN '"                  + _aRet[8]  + "' AND '" + _aRet[9]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),    " COD_NATUREZA  BETWEEN '"             + _aRet[10] + "' AND '" + _aRet[11] + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( .T. ,                  " ( NOME_APROV_N1 IS NOT NULL OR NOME_APROV_N2 IS NOT NULL OR NOME_APROV_N3 IS NOT NULL OR NOME_APROV_N4 IS NOT NULL OR NOME_APROV_N5 IS NOT NULL OR NOME_APROV_N6 IS NOT NULL OR NOME_APROV_N7 IS NOT NULL ) "  )
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN