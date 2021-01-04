#include "totvs.ch"   

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R18	�Autor  � Geronimo Benedito Alves																	�Data �  11/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - SFT - Saidas                      (Modulo 34-CTB)       ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R18()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - SFT - Saidas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "SFT - Saidas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"SFT - Saidas"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"SFT - Saidas"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02					03					04		 05		 06	 07	08 09		
	Aadd(_aCampoQry, {"FT_FILIAL"		,"FT_FILIAL"		,"FT_FILIAL"		,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ENTRADA"		,"FT_ENTRADA"		,"FT_ENTRADA"		,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_EMISSAO"		,"FT_EMISSAO"		,"FT_EMISSAO"		,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_NFISCAL"		,"FT_NFISCAL"		,"FT_NFISCAL"		,"C"	,009	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ESPECIE"		,"FT_ESPECIE"		,"FT_ESPECIE"		,"C"	,005	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_SERIE"		,"FT_SERIE"			,"FT_SERIE"			,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CLIEFOR"		,"FT_CLIEFOR"		,"FT_CLIEFOR"		,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_LOJA"			,"FT_LOJA"			,"FT_LOJA"			,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FORNECEDOR"		,"FORNECEDOR"		,"FORNECEDOR"		,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CNPJ_FOR"		,"CNPJ_FOR"			,"CNPJ_FOR"			,"C"	,025	,0	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"CLIENTE"			,"CLIENTE"			,"CLIENTE"			,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CNPJ_CLI"		,"CNPJ_CLI"			,"CNPJ_CLI"			,"C"	,025	,0	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"FT_ESTADO"		,"FT_ESTADO"		,"FT_ESTADO"		,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CFOP"			,"FT_CFOP"			,"FT_CFOP"			,"C"	,005	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_TOTAL"		,"FT_TOTAL"			,"FT_TOTAL"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALCONT"		,"FT_VALCONT"		,"FT_VALCONT"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQICM"		,"FT_ALIQICM"		,"FT_ALIQICM"		,"N"	,005	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASEICM"		,"FT_BASEICM"		,"FT_BASEICM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALICM"		,"FT_VALICM"		,"FT_VALICM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQIPI"		,"FT_ALIQIPI"		,"FT_ALIQIPI"		,"N"	,005	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASEIPI"		,"FT_BASEIPI"		,"FT_BASEIPI"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALIPI"		,"FT_VALIPI"		,"FT_VALIPI"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASERET"		,"FT_BASERET"		,"FT_BASERET"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ICMSRET"		,"FT_ICMSRET"		,"FT_ICMSRET"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_OBSERV"		,"FT_OBSERV"		,"FT_OBSERV"		,"C"	,031	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_DTCANC"		,"FT_DTCANC"		,"FT_DTCANC"		,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ICMSDIF"		,"FT_ICMSDIF"		,"FT_ICMSDIF"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_PDV"			,"NUM_PDV"			,"NUM_PDV"			,"C"	,010	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CONTA"		,"FT_CONTA"			,"FT_CONTA"			,"C"	,020	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_PRODUTO"		,"FT_PRODUTO"		,"FT_PRODUTO"		,"C"	,015	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"PRODUTO"			,"PRODUTO"			,"PRODUTO"			,"C"	,076	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_POSIPI"		,"FT_POSIPI"		,"FT_POSIPI"		,"C"	,010	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_TIPOMOV"		,"FT_TIPOMOV"		,"FT_TIPOMOV"		,"C"	,001	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_TIPO"			,"FT_TIPO"			,"FT_TIPO"			,"C"	,001	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ITEM"			,"FT_ITEM"			,"FT_ITEM"			,"C"	,004	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_QUANT"		,"FT_QUANT"			,"FT_QUANT"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_FRETE"		,"FT_FRETE"			,"FT_FRETE"			,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_DESPESA"		,"FT_DESPESA"		,"FT_DESPESA"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_PRCUNIT"		,"FT_PRCUNIT"		,"FT_PRCUNIT"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_DESCONT"		,"FT_DESCONT"		,"FT_DESCONT"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASEPIS"		,"FT_BASEPIS"		,"FT_BASEPIS"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQPIS"		,"FT_ALIQPIS"		,"FT_ALIQPIS"		,"N"	,007	,4	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALPIS"		,"FT_VALPIS"		,"FT_VALPIS"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASECOF"		,"FT_BASECOF"		,"FT_BASECOF"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQCOF"		,"FT_ALIQCOF"		,"FT_ALIQCOF"		,"N"	,007	,4	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALCOF"		,"FT_VALCOF"		,"FT_VALCOF"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CHVNFE"		,"FT_CHVNFE"		,"FT_CHVNFE"		,"C"	,044	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CSTPIS"		,"CST_PIS"			,"CST_PIS"			,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CSTCOF"		,"CST_COF"			,"CST_COF"			,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CLASFIS"		,"FT_CLASFIS"		,"FT_CLASFIS"		,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CTIPI"		,"FT_CTIPI"			,"FT_CTIPI"			,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_INDNTFR"		,"IND_NAT_FRET"		,"IND_NAT_FRET"		,"C"	,001	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_NATOPER"		,"NATUREZA_OPER"	,"NATUREZA_OPER"	,"C"	,010	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_DESCZFR"		,"DESC_ZFR"			,"DESC_ZFR"			,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CRDZFM"		,"CRD_ZFM"			,"CRD_ZFM"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_TES"			,"FT_TES"			,"FT_TES"			,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"F4_FINALID"		,"FINALIDADE_TES"	,"FINALIDADE_TES"	,"C"	,254	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CODISS"		,"FT_CODISS"		,"FT_CODISS"		,"C"	,009	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ISENICM"		,"FT_ISENICM"		,"FT_ISENICM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_OUTRICM"		,"FT_OUTRICM"		,"FT_OUTRICM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ISENIPI"		,"FT_ISENIPI"		,"FT_ISENIPI"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_OUTRIPI"		,"FT_OUTRIPI"		,"FT_OUTRIPI"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"GRUPO_TRIBUTARIO","GRUPO_TRIBUTARIO"	,"GRUPO_TRIBUTARIO"	,"C"	,006	,0	,""	,""	,""	}) // Paulo Henrique - TOTVS - 09/09/2019 - RTASK0010017
	Aadd(_aCampoQry, {"DESCR_TRIBUTARIO","DESCR_TRIBUTARIO"	,"DESCR_TRIBUTARIO"	,"C"	,055	,0	,""	,""	,""	}) // Paulo Henrique - TOTVS - 09/09/2019 - RTASK0010017
	Aadd(_aCampoQry, {"YD_DESC_P"		,"YD_DESC_P"		,"YD_DESC_P"		,"C"	,040	,0	,""	,""	,""	})		
	Aadd(_aCampoQry, {"FT_ICMSCOM"		,"FT_ICMSCOM"		,"FT_ICMSCOM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_TRFICM"		,"FT_TRFICM"		,"FT_TRFICM"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASIMP5"		,"FT_BASIMP5"		,"FT_BASIMP5"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASIMP6"		,"FT_BASIMP6"		,"FT_BASIMP6"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALQIMP5"		,"FT_ALQIMP5"		,"FT_ALQIMP5"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALQIMP6"		,"FT_ALQIMP6"		,"FT_ALQIMP6"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALIMP5"		,"FT_VALIMP5"		,"FT_VALIMP5"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALIMP6"		,"FT_VALIMP6"		,"FT_VALIMP6"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ISSST"		,"FT_ISSST"			,"FT_ISSST"			,"C"	,001	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_SEGURO"		,"FT_SEGURO"		,"FT_SEGURO"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASEIRR"		,"FT_BASEIRR"		,"FT_BASEIRR"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQIRR"		,"FT_ALIQIRR"		,"FT_ALIQIRR"		,"N"	,006	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALIRR"		,"FT_VALIRR"		,"FT_VALIRR"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASEINS"		,"FT_BASEINS"		,"FT_BASEINS"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQINS"		,"FT_ALIQINS"		,"FT_ALIQINS"		,"N"	,006	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALINS"		,"FT_VALINS"		,"FT_VALINS"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_BASECSL"		,"FT_BASECSL"		,"FT_BASECSL"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ALIQCSL"		,"FT_ALIQCSL"		,"FT_ALIQCSL"		,"N"	,006	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALCSL"		,"FT_VALCSL"		,"FT_VALCSL"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_NFELETR"		,"FT_NFELETR"		,"FT_NFELETR"		,"C"	,020	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_DIFAL"		,"FT_DIFAL"			,"FT_DIFAL"			,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"ZQ_COD"			,"COD_REDE"			,"COD_REDE"			,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"		,"DESC_REDE"		,"DESC_REDE"		,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CDA_BASE"		,"CDA_BASE"			,"CDA_BASE"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"CDA_ALIQ"		,"CDA_ALIQ"			,"CDA_ALIQ"			,"N"	,005	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"CDA_VALOR"		,"CDA_VALOR"		,"CDA_VALOR"		,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"CDA_CODREF"		,"CDA_CODREF"		,"CDA_CODREF"		,"C"	,007	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CDA_CODLAN"		,"CDA_CODLAN"		,"CDA_CODLAN"		,"C"	,010	,0	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Saida Inicial"		,Ctod("")						,""		,""												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Saida Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data')" 		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cliente De"				,Space(tamSx3("A1_COD")[1])		,"@!"	,"" 											,"SA1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cliente Ate"			,Space(tamSx3("A1_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Cliente')" 	,"SA1"	,"",050,.F.})
	aAdd(_aParambox,{1,"TES De"					,Space(tamSx3("F4_CODIGO")[1])	,"@!"	,"" 											,"SF4"	,"",050,.F.})
	aAdd(_aParambox,{1,"TES Ate"				,Space(tamSx3("F4_CODIGO")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'TES')" 		,"SF4"	,"",050,.F.})
	aAdd(_aParambox,{1,"CFOP De"				,Space(tamSx3("F4_CF")[1])		,"@!"	,"" 											,""		,"",050,.F.})
	aAdd(_aParambox,{1,"CFOP Ate"				,Space(tamSx3("F4_CF")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR07, MV_PAR08	,'CFOP')" 		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Produto De"				,Space(tamSx3("B1_COD")[1])		,"@!"	,""										 		,"SB1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Produto Ate"			,Space(tamSx3("B1_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR09, MV_PAR10	,'Produto')" 	,"SB1"	,"",050,.F.})
	
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	//===		S E L E C I O N A 	   R E D E
	cQryRede	:= "SELECT '" +SPACE(TamSx3("ZQ_COD")[1])+ "' as ZQ_COD ,'" +SPACE(TamSx3("ZQ_DESCR")[1])+ "' as ZQ_DESCR FROM DUAL UNION ALL "
	cQryRede	+= "SELECT DISTINCT ZQ_COD, ZQ_DESCR "
	cQryRede 	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZQ") ) + " TMPSZQ " 
	cQryRede	+= "  WHERE TMPSZQ.D_E_L_E_T_ = ' ' " 
	cQryRede	+= "  ORDER BY ZQ_COD  "
	aCpoRede	:=	{	{ "ZQ_COD"		,U_X3Titulo("ZQ_COD")		,TamSx3("ZQ_COD")[1]	},;
						{ "ZQ_DESCR"	,U_X3Titulo("ZQ_DESCR")		,TamSx3("ZQ_DESCR")[1]	}	}
						
	cTitRede	:= "Selecao das Redes: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cCodRede	:= U_Array_In( U_MarkGene(cQryRede, aCpoRede, cTitRede, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_SFTSAIDA"  )         + CRLF
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " FT_FILIAL IN "               + _cCODFILIA                             	 ) +CRLF //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " FT_ENTRADA_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " 	 ) +CRLF //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " FT_CLIEFOR 	   BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' "   ) +CRLF // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cCodRede ),              " COD_REDE IN " + _cCodRede		+ " "								 ) +CRLF 
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),       " FT_TES 		   BETWEEN '" + _aRet[5] + "' AND '" + _aRet[6] + "' "   ) +CRLF // NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),       " FT_CFOP 		   BETWEEN '" + _aRet[7] + "' AND '" + _aRet[8] + "' "   ) +CRLF // NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[10] ),      " FT_PRODUTO 	   BETWEEN '" + _aRet[9] + "' AND '" + _aRet[10] + "' "  ) +CRLF // NAO OBRIGATORIO
	
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

