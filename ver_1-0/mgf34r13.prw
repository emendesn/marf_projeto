#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R13	�Autor  � Geronimo Benedito Alves																	�Data � 24/01/18   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - processo de Importacao  (Modulo 34-CTB)						   ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R13()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "CONTABILIDADE - Processo de Importacao"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Processo de Importacao"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Processo de Importacao"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Processo de Importacao"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 180												// 		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03							 04	 05	 	 06	 07						 08  09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"								,"C�d. Filial"				,"C",012	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_FILIAL				as DESCR_FILI"	,"Nome Filial"				,"C",041	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W6_HAWB"		,"COD_PROCESSO				as COD_PROCES"	,"C�d. Processo"			,"C",017	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W6_DI_NUM"	,"NUM_DI"									,"N� Declara��o Impos."		,"C",010	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W6_DT_NF"	,"DT_NFA"									,"Data NFe"					,"D",008	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W6_NF_ENT"	,"NUM_NFA"									,"N� NFe"					,"C",020	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W6_DI_OBS"	,"OBSERVACAO"								,"Observacao"				,"C",006	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"WD_DOCTO"	,"DOCUMENTO"								,"Documento"				,""	,""		,""	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"W7_FORN"		,"COD_FORNECEDOR			as COD_FORNEC"	,"C�d. Fornecedor"			,"C",006	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR			as NOM_FORNEC"	,"Nome Fornecedor"			,"C",040	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"A2_CGC"		,"NUM_CNPJ_FORNECEDOR		as CNPJFORNEC"	,"CNPJ Fornecedor"			,"C",018	,0	,"@!"  					,"" ,"@!" })
	Aadd(_aCampoQry, {"WD_DESPESA"	,"COD_DESPESA				as CODDESPESA"	,"C�d. Despesa"				,"C",003	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"WD_DES_ADI"	,"DT_DESPESA				as DT_DESPESA"	,"Data Despesa"				,"D",008	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"WD_FORN"		,"COD_FORNECEDOR_DESPESA	as COD_FORDES"	,"C�d. Fornecedor Despesa"	,"C",006	,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_BAIXA"									,"Data Baixa"				,"D",008	,0	,""  					,"" ,"" })
	Aadd(_aCampoQry, {"E2_MOEDA"	,"COD_MOEDA"								,"C�d. Moeda"				,"N",017	,2	,"@E 99,999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"VV2_MODEDI"	,"NOM_MOEDA"								,"Descr. Moeda"				,"C",005	,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"W6_VL_NF"	,"VLR_NF_PROCESSO			as VLNFPROCES"	,"Valor NF Processo"		,"N",017	,2	,"@E 99,999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"WD_VALOR_R"	,"VLR_DESPESA				as VL_DESPESA"	,"Valor Despesa"			,"N",017	,2	,"@E 99,999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"W7_COD_I"	,"COD_ITEM"									,"C�d. Item"				,"C",015	,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"B1_DESC"		,"DESCRICAO_ITEM			as DESCR_ITEM"	,"Descricao do Item"		,"C",076	,0	,""						,"" ,"" })

	aAdd(_aParambox,{1,"Data NFe Inicial"		,Ctod("")					,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data NFe Final"			,Ctod("")					,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cod. Fornec. Inicial"	,Space(tamSx3("A2_COD")[1])	,""		,"" 												,"CF8A2","",050,.F.}) 
	aAdd(_aParambox,{1,"Cod. Fornec. Final"		,Space(tamSx3("A2_COD")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04,'Cod. Fornecedor')"	,"CF8A2","",050,.F.})	

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_PROCESSOIMPORTACAO" ) +CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_NFA_FILTRO BETWEEN '"  + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 180 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_FILIAL IN "           + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " COD_FORNECEDOR BETWEEN '" + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
