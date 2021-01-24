#include "totvs.ch" 
/*
{Protheus.doc} MGF06R31 
@description 
	RTASK0010896 Criar opção para envio por email dos títulos pendentes de aprovação para os aprovadores.
	Relatório BI que a partir da View, exibe relação de títulos a pagar bloqueados. 
	Desenvolvido opção para que seja possível enviar relação por e-mail aos usuários pre selecionaos.
	Rotina similar a MGF06R09, foi desenvolvida nova tela mantendo o mesmo padrão por exigência nas premissas do projeto. 
@author Henrique Vidal Santos
@Type Relatório
@since 20/03/2020
@version P12.1.017
*/
User Function MGF06R31()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Pagar - Títulos Bloqueados"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Titulos Bloqueados"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Titulos Bloqueados"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Titulos Bloqueados"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	Aadd(_aCampoQry, {"F2_FILIAL"	,"COD_EMPRESA_ORIGEM	as EMPRESAORI"	,"Empresa Origem"		,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_EMPRESA_ORIGEM	as NOMEEMPORI"	,"Descr. Empresa Origem","C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"								,"Prefixo"				,"C",003	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"TB6_CODTIP"	,"TIPO"									,"Tipo"					,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR		as CODFORNECE"	,"Cód. Fornecedor"		,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR		as NOMEFORNEC"	,"Nome Fornecedor"		,"C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"							,"Nº Título"			,"C",009	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_CODBAR"	,"COD_BARRA"							,"Cod. Barras"			,"C",044	,0, ""						,""	,""	})  // Paulo Henrique - 01/10/2019 - Inclusão dos códigos de barras
	Aadd(_aCampoQry, {"F1_ZAUDUSR"	,"USUARIO_AUDITOR		as USRAUDITOR"	,"Usuário Auditor"		,"C",040	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"CR_EMISSAO"	,"DATA_EMISSAO			as DT_EMISSAO"	,"Data Emissão"			,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"CR_ZNATURE"	,"COD_NATUREZA			as CDNATUREZA"	,"Cód. Natureza"		,"C",010	,0, ""						,""	,""	})
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
	Aadd(_aCampoQry, {"E2_ORIGEM"	,"MOD_ORIGEM"							,"Módulo Origem"		,"C",010	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID1"		,"USR_ID1"							    ,"Codigo aprovador 1"	,"C",200	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID2"		,"USR_ID2"							    ,"Codigo aprovador 2"	,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID3"		,"USR_ID3"							    ,"Codigo aprovador 3"	,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID4"		,"USR_ID4"							    ,"Codigo aprovador 4"	,"C",200	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID5"		,"USR_ID5"							    ,"Codigo aprovador 5"	,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID6"		,"USR_ID6"							    ,"Codigo aprovador 6"	,"C",080	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"USR_ID7"		,"USR_ID7"							    ,"Codigo aprovador 7"	,"C",080	,0, ""						,""	,""	})

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
		MsgStop("É obrigatório o preenchimento do parâmetro data de Vencimento final e/ou do parâmetro data de Vencimento Real final.")
		Return.F.

	ElseIf _aRet[1] > _aRet[2]
		MsgStop("A Data de Vencimento Inicial, não pode ser maior que a data de Vencimento Final.")
		Return.F.

	ElseIf _aRet[3] > _aRet[4]
		MsgStop("A Data de Vencimento Real Inicial, não pode ser maior que a data de Vencimento Real Final.")
		Return.F.

	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)	
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_TITULOGRADEAPR" ) +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_VENCIMENTO_FILTRO BETWEEN '"      + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " DT_VENCIMENTO_REAL_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_EMPRESA_ORIGEM IN "              + _cCODFILIA                             ) // OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),     " COD_FORNECEDOR  BETWEEN '"           + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),     " NUM_TITULO = '"                      + _aRet[7]  + "' "                        ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),     " PREFIXO  BETWEEN '"                  + _aRet[8]  + "' AND '" + _aRet[9]  + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),    " COD_NATUREZA  BETWEEN '"             + _aRet[10] + "' AND '" + _aRet[11] + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( .T. ,                  " ( NOME_APROV_N1 IS NOT NULL OR NOME_APROV_N2 IS NOT NULL OR NOME_APROV_N3 IS NOT NULL OR NOME_APROV_N4 IS NOT NULL OR NOME_APROV_N5 IS NOT NULL OR NOME_APROV_N6 IS NOT NULL OR NOME_APROV_N7 IS NOT NULL ) "  )
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_MGFFINBJ()})
	
Return