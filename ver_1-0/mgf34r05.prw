#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R05	�Autor  �Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Informacoes Ref. Patrimonio (Modulo 34-CTB)										���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

/*/{Protheus.doc} MGF34R05 (Relacao de patrim�nios)
@alteracoes 
	@author Henrique Vidal Santos @since 10/09/2019
	RTASK0010023 - Criado condicoes para filtrar situacao do patrim�nio.
/*/
User Function MGF34R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - Informacoes Ref. Patrimonio"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Inf. Ref. Patrimonio"							)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Inf. Ref. Patrimonio"}						)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Inf. Ref. Patrimonio"}						)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 366													//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03							 04	 05	  	06  07						 08		 09	
	Aadd(_aCampoQry, {"N1_FILIAL"	,"COD_FILIAL"								,"Codigo Filial"			,"C",006	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"								,"Nome da Filial"			,"C",041	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"BDM_DESCRI"	,"SITUACAO"									,"Situa��o"					,"C",035	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"X5_DESCRI"	,"TIP_ITEM"									,"Tipo Item"				,"C",055	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_CHAPA"	,"NUM_PLAQUETA				as NUMPLAQUET"	,"N� Plaqueta"				,"C",020	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_AQUISIC"	,"DT_AQUISICAO				as DT_AQUISIC"	,"Data Aquisi��o"			,"D",008	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_NSERIE"	,"NUM_SERIE_NF				as NSERIE_NF"	,"N� Serie NF"				,"C",003	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_NFISCAL"	,"NUM_NF"									,"N� NF"					,"C",009	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_CBASE"	,"COD_BASE"									,"C�d. Base"				,"C",010	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_ITEM"		,"COD_ITEM"									,"C�d. Item"				,"C",004	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_PRODUTO"	,"COD_PRODUTO"								,"C�d. Produto"				,"C",015	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_HISTOR"	,"NOM_ITEM"									,"Nome Item"				,"C",040	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_CUSTBEM"	,"COD_CENTRO_CUSTO			as COD_CCUSTO"	,"C�d C.Custo"				,"C",009	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_GRUPO"	,"COD_AGRUPAMENTO			as COD_AGRUPA"	,"C�d. Agrupamento"			,"C",004	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"NG_DESCRIC"	,"NOM_AGRUPAMENTO			as NOM_AGRUPA"	,"Nome Agrupamento"			,"C",080	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_UTIPATR"	,"IND_UTILIZACAO			as IND_UTILIZ"	,"Ind. Utiliza��o"			,"C",002	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_CCONTAB"	,"CONTA_CONTABIL			as CTA_CONTAB"	,"Conta Cont�bil"			,"C",020	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_BAIXA"	,"DT_BAIXA"									,"Data Baixa"				,"D",008	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"FN6_MOTIVO"	,"COD_MOTIVO_BAIXA			as MOTIVOBAIX"	,"C�d Motivo Baixa"			,"C",002	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"BDM_DESCRI"	,"DESC_MOTIVO_BAIXA			as DESC_MOTIV"	,"Descricao Motivo Baixa"	,"C",035	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_CSTCOFI"	,"CST_COFINS"								,"CST COFINS"				,"C",002	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N1_CSTPIS"	,"CST_PIS"									,"CST PIS"					,"C",002	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_VORIG1"	,"VLR_AQUISICAO_REAL		as VLRAQUREAL"	,"Vlr Aquisi��o Real"		,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"N3_VORIG2"	,"VLR_AQUISICAO_DOLAR		as VLRAQUDOLA"	,"Vlr Aquisi��o D�lar"		,"N",017	,4,"@E 99,999,999,999.9999"	,""		,""	})
	Aadd(_aCampoQry, {"N3_VRDMES1"	,"VLR_DEPRECIACAO_MES		as VLRDEPRMES"	,"Vlr Deprecia��o M�s"		,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"N3_VRDACM1"	,"VLR_DEPRECIACAO_ACUMULADO	as VLRDEPRACU"	,"Vlr Deprec. Acumulado"	,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"N3_VRDACM1"	,"VLR_RESIDUAL				as VLRRESIDUA"	,"Valor residual"			,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"N1_TAXAPAD"	,"PERC_FISCAL				as PERCFISCAL"	,"Codigo Classif. Fiscal"	,"C",006	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"N3_TXDEPR1"	,"TAXA_DEPRECIACAO			as TAXADEPREC"	,"Taxa Deprecia��o"			,"N",009	,4,"@E 9999.9999"			,""		,""	})
	Aadd(_aCampoQry, {"N1_FORNEC"	,"COD_FORNECEDOR"							,"Cod. Fornecedor"			,"C",006	,0,""						,""		,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"DESC_FORNECEDOR"							,"Nome Fornecedor"			,"C",040	,0,""						,""		,""	})
	


	aAdd(_aParambox,{1,"Data Aquisi��o Inicial"	,Ctod("")	,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Aquisi��o Final"	,Ctod("")	,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Aquisi��o')"	,""		,"",050,.T.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	cQrySit	:= "SELECT	'01' as CAMPO_01,'Situa��o nao informada'  AS SITUACAO_PATRIMONIO FROM DUAL UNION ALL "
	cQrySit	+= "SELECT	'02' as CAMPO_01,	'ATIVO FIXO'									AS SITUACAO_PATRIMONIO  FROM DUAL	"     
	cQrySit	+= "UNION	SELECT '03' as CAMPO_01,	'PATRIMONIO LIQUIDO'					AS SITUACAO_PATRIMONIO  FROM DUAL	"          
	cQrySit	+= "UNION	SELECT '04' as CAMPO_01, 'AMORTIZACAO'							AS SITUACAO_PATRIMONIO  FROM DUAL	"          
	cQrySit	+= "UNION	SELECT '05' as CAMPO_01, 'CAPITAL SOCIAL'						AS SITUACAO_PATRIMONIO  FROM DUAL	"          
	cQrySit	+= "UNION 	SELECT '06' as CAMPO_01, 'PATRIMONIO (PREJUIZO)'				AS SITUACAO_PATRIMONIO  FROM DUAL	"          
	cQrySit	+= "UNION	SELECT '07' as CAMPO_01,	'ATIVO DIFERIDO'						AS SITUACAO_PATRIMONIO  FROM DUAL	"          
	cQrySit	+= "UNION	SELECT '08' as CAMPO_01,	'ATIVO INTANGIVEL'                 AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '09' as CAMPO_01,	'ORCAMENTO DE PROVISAO DE DESPESAS' AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '10' as CAMPO_01,	'PROVISAO DE DESPESAS'             AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '11' as CAMPO_01,	'CUSTOS DE TRANSACAO'              AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '12' as CAMPO_01, 'CUSTO DE EMPRESTIMO'				AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '13' as CAMPO_01,	'BEM BAIXADO'							AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '14' as CAMPO_01,	'BEM EM GARANTIA'						AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '15' as CAMPO_01,	'BEM EM PENHORA'						AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '16' as CAMPO_01, 'BEM PENHORADO'						AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '17' as CAMPO_01, 'TRANSFERENCIA INTERNA DE FILIAL'	AS SITUACAO_PATRIMONIO  FROM DUAL	"      
	cQrySit	+= "UNION	SELECT '18' as CAMPO_01, 'PENDENTE CLASSIFICACAO'			AS SITUACAO_PATRIMONIO  FROM DUAL	"  
	aCpoStSoli	:=	{	{ "CAMPO_01"				,"N�"						,02	} ,;
						{ "SITUACAO_PATRIMONIO"	,"Situa��o Patrim�nio"	,50	} } 
	cTitTipPro	:= "Marque as situacoes de patrim�nio � serem listados: "
	nPosRetorn	:= 2		
	_lCancProg	:= .T. 	
	cCodTipPro	:= U_Array_In( U_MarkGene(cQrySit, aCpoStSoli, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_INF_PATRIMONIO" ) + " A " + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_AQUISICAO_FILTRO BETWEEN '"    + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " A.COD_FILIAL IN "                 + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	
	If Empty( cCodTipPro )
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd(  !empty(cCodTipPro) ,	" ( A.SITUACAO IS NULL OR A.SITUACAO IN " + cCodTipPro + " )"         )
	Else	
		_cQuery += U_WhereAnd(  !empty(cCodTipPro) ,	" A.SITUACAO IN " + cCodTipPro	                                            )	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

