#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF30R01	�Autor  � Geronimo Benedito Alves                                                                   � Data � 13/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.     � Rotina que mostra na tela os dados da planilha:                                                                                   ���
//���          � EFF-Easy Financing - 30 -Financiamento - Ordens de Pagamento com Saldo � Resumo                                                   ���
//���          � Os dados sao obtidos e mostrados na tela executando uma query, e depois, o usuario gera uma planilha excel com eles               ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods                                                                                                             ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF30R01()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval 
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Financiamento - Resumo-Ordens de Pagamento com Saldo"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Resumo-Ordens de Pagamento com Saldo"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Resumo-Ordens de Pagamento com Saldo"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Resumo-Ordens de Pagamento com Saldo"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}														)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }											)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35															//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03				 04	 05		 06	 07						  	 08  09	
	Aadd(_aCampoQry, {"A2_NOME"		,"EMPRESA"								,"Empresa"		,"C",040	,0, ""	 						,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_ZNOMEB"	,"NOME_BANCO"							,"Nome Banco"	,"C",040	,0, ""							,""	,""	 })
	Aadd(_aCampoQry, {"XXEEQEVE01"	,"TIPO_CREDITO			as TIPCREDITO"	,"Tipo Credito"	,"C",020	,0, ""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_MOEDA"	,"MOEDA"								,"Moeda"		,"C",003	,0, ""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_ZDESP"	,"SUM(DESPESAS)			as Despesas"	,"Despesas"		,"N",010	,2, "@E 9,999,999.99"			,""	,""	 })
 	Aadd(_aCampoQry, {"EEQ_VL"		,"SUM(SALDO_LIQUIDO)	as SALDOLIQUI"	,"Saldo Liquido","N",015	,2, "@E 999,999,999,999.99"		,""	,""	 })

	aAdd(_aParambox,{1,"Codigo Empresa Inicial",Space(tamSx3("A2_COD")[1])	,"@!"	,""													,"SAA2"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Loja   Empresa Inicial",Space(tamSx3("A2_LOJA")[1])	,"@!"	,""													,""		,"",050,.F.}) 
	aAdd(_aParambox,{1,"Codigo Empresa Final"	,Space(tamSx3("A2_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR01, MV_PAR03, 'Codigo Empresa')"	,"SAA2"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Loja   Empresa Final"	,Space(tamSx3("A2_LOJA")[1]),"@!"	,"U_VLFIMMAI(MV_PAR02, MV_PAR04, 'Loja   Empresa')"	,""		,"",050,.F.}) 
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	//===		S E L E C I O N A     A      M O E D A
	cQryMoeda	:= "SELECT ' ' as YF_MOEDA, 'Nao  Informado' as YF_DESC_SI FROM DUAL UNION ALL " +CRLF
	cQryMoeda	+= "SELECT DISTINCT YF_MOEDA, YF_MOEDA  " +CRLF
	cQryMoeda  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SYF") ) + " TMPSYF "  +CRLF
	cQryMoeda	+= "  WHERE TMPSYF.D_E_L_E_T_ = ' ' "  +CRLF
	cQryMoeda	+= "  ORDER BY YF_MOEDA, YF_DESC_SI " +CRLF
	aCpoMoeda	:=	{	{ "YF_MOEDA"	,"Moeda"		,TamSx3("YF_MOEDA")[1] + 80	}	,;
						{ "YF_DESC_SI"	,"Descricao"	,TamSx3("YF_DESC_SI")[1] 		}	 } 
	cTituMoeda	:= "Moedas a serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cMoeda	:= U_Array_In( U_MarkGene(cQryMoeda, aCpoMoeda, cTituMoeda, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FINAN_ORDEMSALDO"  )         + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[3]),     " COD_EMPRESA BETWEEN '"        + _aRet[1] + "' AND '" + _aRet[3] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[4]),     " LOJA_EMPRESA BETWEEN '"       + _aRet[2] + "' AND '" + _aRet[4] + "' " )
	IF Empty( _cMoeda )
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cMoeda ) <> 0
		_cQuery += U_WhereAnd( .T. ,             " ( MOEDA IS NULL OR MOEDA IN " + _cMoeda + " )"                         )
	Else	
		_cQuery += U_WhereAnd( .T. ,             " MOEDA IN "                    + _cMoeda                                )
	Endif
	_cQuery += " GROUP BY EMPRESA "
	_cQuery += " , NOME_BANCO "
	_cQuery += " , MOEDA "
	_cQuery += " , TIPO_CREDITO "
	_cQuery += " ORDER BY  EMPRESA "
	_cQuery += " ,  NOME_BANCO "
	_cQuery += " ,  TIPO_CREDITO " 
	_cQuery += " ,  MOEDA "
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
