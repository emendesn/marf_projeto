#include "totvs.ch" 


//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R11	�Autor  � Geronimo Benedito Alves																	�Data � 04/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Lancamento Cont�bil x NF Entrada (Modulo 34-CTB)							���
//���			� Os dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R11()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contab. Gerencial - Lancamento Cont�bil x NF Entrada" )	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Lancamento Cont�bil x NF Entrada")						//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Lancamento Cont�bil x NF Entrada"} )						//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Lancamento Cont�bil x NF Entrada"} )						//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )														//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )												//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""


	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03								 04	 05	 06	 07	 08	 09			
	Aadd(_aCampoQry, {"F1_FILIAL"	,"COD_EMPRESA				as COD_EMPRES"	,"C�d. Empresa"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_DTLANC"	,"DATA_LANCAMENTO			as DT_LANCAME"	,"Data Lancamento"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DATA_EMISSAO				as DT_EMISSAO"	,"Data Emissao"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"NOTA_FISCAL				as NOT_FISCAL"	,"Nota Fiscal"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"SERIE"									,"Serie"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_CF"		,"COD_FISCAL"								,"C�d. Fiscal"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F4_CODIGO"	,"COD_TES"									,"TES"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F4_TEXTO"	,"DESC_TES"									,"Descricao da TES"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F4_FINALID"	,"FINALIDADE_TES			as FINALIDTES"	,"Finalidade da TES"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_FORNECE"	,"COD_FORNECEDOR			as COD_FORNEC"	,"C�d. Fornecedor"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR			as NOMEFORNEC"	,"Nome Fornecedor"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_INSCR"	,"CLIENTE_INSC_ESTADUAL		as INSCESTATU"	,"Inscr. Estadual Cliente"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ"										,"Cnpj"							,""	,18	,""	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"A2_END"		,"ENDERECO"									,"Endereco"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_BAIRRO"	,"BAIRRO"									,"Bairro"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_CEP"		,"CEP"										,"Cep"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_MUN"		,"CIDADE"									,"Cidade"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_EST"		,"UF"										,"UF"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_ESTADO"	,"ESTADO"									,"ESTADO"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS"										,"Pa�s"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_COD"		,"COD_ITEM"									,"C�d. Item"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_ITEM"								,"Descricao do Item"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_UM"		,"UNIDADE_MEDIDA			as UNIDADMEDI"	,"Unidade de Medida"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"BM_GRUPO"	,"COD_GRUPO_ITEM			as CODGRUPITE"	,"Codigo Grupo Item"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"BM_DESC"		,"DESC_GRUPO_ITEM			as DESGRUPITE"	,"Descricao Grupo Item"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_POSIPI"	,"NCM_PRODUTO				as NCMPRODUTO"	,"Nomenclatura Produto"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"ED_CODIGO"	,"COD_NATUREZA 				as CODNATUREZ"	,"C�d. Natureza"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESC_NATUREZA				as DESNATUREZ"	,"Descricao Natureza"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E4_CODIGO"	,"COD_CONDICAO_PAG			as CODI_PAGTO"	,"C�d. Cond. Pagto"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESC_CONDICAO_PAG			as DESC_PAGTO"	,"Descri. Cond. Pagto"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_OP"		,"OBJ_ENTRADA				as OBJ_ENTRAD"	,"Objt. Entrada"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_QUANT"	,"QTDE_CABECAS				as QTDE_CABEC"	,"Quantidade Cabe�as"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"ZZN_QTKG"	,"QTDE_RECEBIDA				as QTDE_RECEB"	,"Quantidade Recebida"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_ZVOL"		,"VOLUME"									,"Volume"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VUNIT"	,"PRECO_UNITARIO			as PRECO_UNIT"	,"Preco Unit�rio"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_TOTAL"	,"VALOR_CONTABIL			as VLCONTABIL"	,"Valor Cont�bil"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"C7_CLVL"		,"CLASSE_VALOR_CONTABIL		as CL_VL_CONT"	,"Classe Vlr Cont�bil"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_BASEICM"	,"BASE_CALCULO				as BASE_CALC"	,"Base de Calculo"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F7_BASEICM"	,"PRC_REDUCAO_BASE_CALCULO 	as REDUBCALC" 	,"% Red. Base de Calculo"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_ICMS"		,"ICMS"										,"Icms"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_VALIPI"	,"IPI"										,"IPI"							,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_ICMSRET"	,"VALOR_ICMS_SOLIDARIO		as VL_ICMSSOL"	,"Valor ICMS Solid�rio"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_II"		,"VALOR_IMPOSTO_IMPORTACAO	as VL_IMPIMPO"	,"Vlr Imp Importacao"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_ICMSDIF"	,"VALOR_ICMS_ST 			as VL_ICMS_ST"	,"Vlr ICMS ST"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VALINS"	,"VALOR_INSS"								,"Valor INSS"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VALCMAJ"	,"VALOR_COFINS_MAJORADA		as VL_MAJORAD"	,"Valor Cofins Majorada"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VALISS"	,"VALOR_ISS"								,"Valor ISS"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VALIRR"	,"VALOR_IRRF"								,"Valor IRRF"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_ICMSCOM"	,"ICMS_COMPLEMENTAR			as ICMS_COMPL"	,"ICMS Complementar"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CLASFIS"	,"CST_ICMS"									,"CST ICMS"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CSTCOF"	,"CST_COFINS"								,"CST COFINS"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQCOF"	,"PERC_COFINS				as PCT_COFINS"	,"PERC COFINS"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_COFINS"	,"VALOR_COFINS				as VLR_COFINS"	,"Valor Cofins"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CSTPIS"	,"CST_PIS"									,"CST PIS"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_PPIS"		,"PERC_PIS"									,"PERC PIS"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_VALPIS"	,"VALOR_PIS"								,"Valor PIS"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_REFBAS"	,"BASE_CALC_ST 				as CALCULOST"	,"Base Calc ST"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"C7_ICMSRET"	,"VALOR_ICMS_RETIDO 		as VL_ICMSRET"	,"Valor Icms Retido"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_RETOPER"	,"PIS_COFINS"								,"Pis Cofins"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_TIPO"		,"FISICA_JURIDICA			as FISICAJURI"	,"Fisica/Jur�dica"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT1_CONTA"	,"COD_CONTA_CONTABIL		as CODCONTABI"	,"C�d. Conta Cont�bil"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"DESC_CONTA_CONTABIL		as DESCONTABI"	,"Descricao Conta Cont�bil"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"B1_CONTA"	,"COD_CONTA_CONTABIL_PROD	as CODCTBPROD"	,"C�d Cta Cont�b Produto"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"DESC_CONTA_CONTABIL_PROD	as DESCTBPROD"	,"Descricao Cta Cont�b Produto"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_PEDIDO"	,"NUM_PEDIDO"								,"N� Pedido"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_CHVNFE"	,"CHAVE_ACESSO				as CHV_ACESSO"	,"Chave de Acesso"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"W6_DI_NUM"	,"NUM_DI"									,"N� Declar. Impost."			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"W6_DTREG_D"	,"DATA_NUM_DI				as DT_NUM_DI"	,"Data Declar. Impost."			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"F1_ZPROTNF"	,"PROTOCOLO"								,"Protocolo"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"XXF1FORMUL"	,"FORMULARIO_PROPRIO		as FORPROPRIO"	,"Formulario Pr�prio"			,"C",03	,0	,"!",""	,"!"})
	Aadd(_aCampoQry, {"D1_NFORI"	,"NF_ORIGEM"								,"NF Origem"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_SERIORI"	,"SERIE_NF_ORIGEM			as SERIENFORI"	,"Serie Origem"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_ITEMORI"	,"ITEM_NF_ORIGEM			as ITEMNFORIG"	,"Item NF Origem"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"DATA_DIGITACAO			as DATADIGITA"	,"Data Digitacao"				,""	,""	,""	,""	,""	,""	})
	
	aAdd(_aParambox,{1,"Conta Cont�bil Inicial"		,Space(tamSx3("CT1_CONTA")[1])	,""		,""													,"CT1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Final"		,Space(tamSx3("CT1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR01,MV_PAR02,'Codigo Cont�bil')"	,"CT1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Numero da Nota a listar"	,Space(tamSx3("F1_DOC")[1])		,""		,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Lancamento Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Lancamento Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR04,MV_PAR05,'Data Lancamento')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR06, MV_PAR07,'Data Emissao')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Digitacao Inicial"		,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Digitacao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR08, MV_PAR09,'Data Digitacao')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Codigo Item Inicial"		,Space(tamSx3("D1_COD")[1])		,""		,""													,"SB1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Codigo Item Final"			,Space(tamSx3("D1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR10,MV_PAR11,'Codigo Item')"		,"SB1"	,"",075,.F.})
	aAdd(_aParambox,{1,"Codigo Grupo Item Inicial"	,Space(tamSx3("BM_GRUPO")[1])	,""		,""													,"SBM"	,"",075,.F.})
	aAdd(_aParambox,{1,"Codigo Grupo Item Final"	,Space(tamSx3("BM_GRUPO")[1])	,""		,"U_VLFIMMAI(MV_PAR12,MV_PAR13,'Codigo Grupo Item')","SBM"	,"",075,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_LANCCONTABNFENTRADA" )    + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_EMPRESA IN " + _cCODFILIA                                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " COD_CONTA_CONTABIL BETWEEN '"     + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO, RANGE DE/ATE DO CODIGO CONTABIL
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " NOTA_FISCAL LIKE '%"              + _aRet[3]  + "%' "                        ) //NAO OBRIGATORIO, USU�RIO DIGITA O NUMERO DA NOTA
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),      " DATA_LANCAMENTO_FILTRO BETWEEN '" + _aRet[4]  + "' AND '" + _aRet[5]  + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),      " DATA_EMISSAO_FILTRO BETWEEN '"    + _aRet[6]  + "' AND '" + _aRet[7]  + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),      " DATA_DIGITACAO_FILTRO BETWEEN '"  + _aRet[8]  + "' AND '" + _aRet[9]  + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),     " COD_ITEM BETWEEN '"               + _aRet[10] + "' AND '" + _aRet[11] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[13] ),     " COD_GRUPO_ITEM BETWEEN '"         + _aRet[12] + "' AND '" + _aRet[13] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN


