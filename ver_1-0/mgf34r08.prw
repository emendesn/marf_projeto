#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R08	�Autor  � Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - NFE Pr� Contabilizado  (Modulo 34-CTB)							���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R08()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - NFE Pre Contabilizado"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "NFE Pre Contabilizado"							)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"NFE Pre Contabilizado"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"NFE Pre Contabilizado"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}													)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }										)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35														//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					
	nValor_Uni := "  CASE					"			+CRLF
	nValor_Uni += "		 WHEN A.QTDE = 0 "			+CRLF			
	nValor_Uni += "			THEN A.VLR_TOT  "		+CRLF			
	nValor_Uni += "		 ELSE A.VLR_TOT / A.QTDE "	+CRLF	
	nValor_Uni += "  END			AS VLR_UNIT	" +CRLF

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02									 03							 04	 05	 06	  07					 	 08	 	 09		
	Aadd(_aCampoQry, {"D1_FILIAL"	,"FILIAL"							,"Codigo Filial"			,"C",006	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_NOME"		,"SYC.M0_NOME 		as DESCFILIAL"	,"Nome da Filial"			,"C",040	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"DATA_LCTO"						,"Data de Lancamento"		,"D",008	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_DOC"		,"NF"								,"Nota Fiscal"				,"C",009	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_NFORI"	,"NF_ORIGEM"						,"Nota Fiscal Origem"		,"C",009	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A2_NOME"		,"SA2.A2_NOME		as RAZAOSOCIA"	,"Razao Social"				,"C",040	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A2_NREDUZ"	,"SA2.A2_NREDUZ		as NOMEFANTAS"	,"Nome Fantasia"			,"C",040	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_ITEM"		,"ITEM_NF"							,"Item NF"					,"C",004	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_COD"		,"COD_PRODUTO		as COD_PRODUT"	,"C�d. Produto"				,"C",006	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO		as DES_PRODUT"	,"Descricao Produto"		,"C",076	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_QUANT"	,"QTDE"								,"Quantidade"				,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	})   
	Aadd(_aCampoQry, {"D1_UM"		,"UN_MED"							,U_X3Titulo("D1_UM")		,"C",002	,0,""						,""		,""	})   
	Aadd(_aCampoQry, {"D1_CUSTO"	,nValor_Uni							,"Valor Unit�rio"			,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	}) 
	Aadd(_aCampoQry, {"D1_CUSTO"	,"VLR_TOT"							,"Valor Total"				,"N",017	,2,"@E 99,999,999,999.99"	,""		,""	}) 
	Aadd(_aCampoQry, {"A00_MSBLQL"	,"D_C"								,"D_C"						,"C",004	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"B1_CONTA"	,"CTA_CONTABIL		as CTA_CONTAB"	,"Conta Cont�bil"			,"C",020	,0,""						,""		,""	}) 				
	Aadd(_aCampoQry, {"A1_NOME"		,"CT1.CT1_DESC01	as DESCTACONT", "Descr. Conta Cont�bil"		,"C",040	,0,""						,""		,""	})   
	Aadd(_aCampoQry, {"D1_CC"		,"C_CUSTO"							,"Centro de Custo"			,"C",009	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_NOME"		,"CTT.CTT_DESC01	as DESCCCUSTO"	,"Descr. Centro de Custo"	,"C",040	,0,""						,""		,""	}) 
	Aadd(_aCampoQry, {"D1_UM"		,"ITEM_CONTABIL		as ITEMCONTAB"	,"Item Cont�bil"			,"C",002	,0,""						,""		,""	})   
	Aadd(_aCampoQry, {"D1_CLVL"		,"CLS_VALOR"						,U_X3Titulo("D1_CLVL")		,"C",009	,0,""						,""		,""	}) 				
	Aadd(_aCampoQry, {"D1_FILIAL"	,"LP"								,"LP"						,"C",006	,0,""						,""		,""	}) 

	aAdd(_aParambox,{1,"Data Lancamento Inicial"	,Ctod("")						,""		,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Lancamento Final"		,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"			,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Conta Contabil Inicial"		,Space(tamSx3("CT1_CONTA")[1])	,""		,""														,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Contabil Final"		,Space(tamSx3("CT1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Conta Contabil')"		,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Inicial"	,Space(tamSx3("CTT_CUSTO")[1])	,""		,""														,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Final"		,Space(tamSx3("CTT_CUSTO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Centro de Custo')"	,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe de Valor Inicial"	,Space(tamSx3("CTH_CLVL")[1])	,""		,""														,"CTH"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe de Valor Final"		,Space(tamSx3("CTH_CLVL")[1])	,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Classe de Valor')"	,"CTH"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_PLANEJAMENTO_NFEPRECONTAB" ) + " A " +CRLF	
	_cQuery += "	INNER JOIN " + U_IF_BIMFR( "PROTHEUS", "SYS_COMPANY"  ) + " SYC  ON A.FILIAL  =  SYC.M0_CODFIL "  +CRLF
	_cQuery += "	AND  SYC.D_E_L_E_T_  <>  '*' "	+CRLF 
	_cQuery += "	INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SA2")  ) + " SA2  ON A.FORNECE  =  SA2.A2_COD "  +CRLF
	_cQuery += "	AND  A.LOJA	=  SA2.A2_LOJA "  +CRLF
	_cQuery += "	AND  SA2.D_E_L_E_T_  <>  '*' "	+CRLF
	_cQuery += "	INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("CT1")  ) + " CT1  ON A.CTA_CONTABIL  =  CT1.CT1_CONTA "  +CRLF
	_cQuery += "	AND  CT1.D_E_L_E_T_  <>  '*' "	+CRLF
	_cQuery += "	LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("CTT")  ) + " CTT  ON A.C_CUSTO  =  CTT.CTT_CUSTO "  +CRLF
	_cQuery += "	AND  CTT.D_E_L_E_T_  <>  '*' "	+CRLF

	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " A.DATA_LCTO_FILTRO BETWEEN '" + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),   " A.CTA_CONTABIL BETWEEN '"     + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),   " A.C_CUSTO BETWEEN '"          + _aRet[5]   + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),   " A.CLS_VALOR BETWEEN '"        + _aRet[7]   + "' AND '" + _aRet[8] + "' " ) //NAO OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " A.FILIAL IN "               + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

