#INCLUDE "totvs.ch" 


//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R10	�Autor  �Geronimo Benedito Alves																	�Data �08/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Prazo Medio						(Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R10()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	Private _MD_Emissa, _MD_Baixa

	Aadd(_aDefinePl, "Contas a Receber - Prazo Medio"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Prazo Medio"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Prazo Medio"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Prazo Medio"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  	
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	_MD_Emissa := "			ROUND(CASE"	+CRLF
	_MD_Emissa += "					WHEN (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO) = 0 "	+CRLF
	_MD_Emissa += "						THEN QTDE_EMISSAO "	+CRLF
	_MD_Emissa += "					ELSE QTDE_EMISSAO / (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO)"	+CRLF
	_MD_Emissa += "			END)													AS MD_EMISSAO"  +CRLF //NUMBER

	_MD_Baixa := "			ROUND(CASE"	+CRLF
	_MD_Baixa += "					WHEN (MAIOR_DATA_BAIXA - MENOR_DATA_BAIXA) = 0" +CRLF  
	_MD_Baixa += "						  THEN QTDE_BAIXA"	+CRLF
	_MD_Baixa += "					ELSE QTDE_BAIXA / (MAIOR_DATA_BAIXA - MENOR_DATA_BAIXA)"	+CRLF
	_MD_Baixa += "			END)														AS MD_BAIXA"	+CRLF //NUMBER	

	_Variacao := "			TRUNC(CASE"	+CRLF
	_Variacao += "					WHEN ROUND(CASE "	+CRLF
	_Variacao += "									 WHEN (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO) = 0 "	+CRLF
	_Variacao += "										THEN QTDE_EMISSAO"	+CRLF
	_Variacao += "									 ELSE QTDE_EMISSAO / (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO)"	+CRLF 
	_Variacao += "							 END) = 0"	+CRLF
	_Variacao += "						THEN 0"	+CRLF
	_Variacao += "						ELSE (ROUND(CASE "	+CRLF
	_Variacao += "										WHEN (MAIOR_DATA_BAIXA - MENOR_DATA_BAIXA) = 0 "	+CRLF
	_Variacao += "											THEN QTDE_BAIXA"	+CRLF
	_Variacao += "										ELSE QTDE_BAIXA / (MAIOR_DATA_BAIXA - MENOR_DATA_BAIXA) "	+CRLF
	_Variacao += "									 END)  /  ROUND(CASE "	+CRLF
	_Variacao += "														WHEN (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO) = 0 "	+CRLF
	_Variacao += "														 THEN QTDE_EMISSAO"	+CRLF
	_Variacao += "														ELSE QTDE_EMISSAO / (MAIOR_DATA_EMISSAO - MENOR_DATA_EMISSAO)"	+CRLF 
	_Variacao += "													END)"	+CRLF
	_Variacao += "							)"	+CRLF														
	_Variacao += "			END, 2)											AS VARIACAO"	+CRLF

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02								 03					 04	 05		 06	 07					 08		 09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"COD_FILIAL"					,"Cod. Filial"		,"C",012	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"					,"Nome Filial"		,"C",041	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO	as CODSEGMENT"	,"Cod. Segmento"	,"C",006	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"DESC_SEGMENTO	as DESCSEGMEN"	,"Descr. Segmento"	,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"A5_VOLMAX"	,_MD_Emissa						,"MD Emissao"		,"N",017	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"A5_VOLMAX"	,_MD_Baixa						,"MD Baixa"			,"N",017	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"A5_VOLMAX"	,_Variacao						,"Varia��o"			,"N",017	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULOS	as VLRTITULOS"	,"Valor Titulos"	,"N",017	,0	,"@E 999,999,999"	,""		,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")	,""		,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final  "	,Ctod("")	,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"			,""		,"",050,.T.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "				FROM ("	+CRLF
	_cQuery += "					SELECT 	 FIL.M0_CODFIL												AS COD_FILIAL"			+CRLF
	_cQuery += "							, FIL.M0_FILIAL												AS NOM_FILIAL"			+CRLF
	_cQuery += "							, SEG.AOV_CODSEG												AS COD_SEGMENTO"		+CRLF
	_cQuery += "							, SEG.AOV_DESSEG												AS DESC_SEGMENTO"		+CRLF
	_cQuery += "							, MIN(TO_DATE(CR.E1_EMISSAO,'YYYYMMDD'))						AS MENOR_DATA_EMISSAO"	+CRLF
	_cQuery += "							, MAX(TO_DATE(CR.E1_EMISSAO,'YYYYMMDD'))						AS MAIOR_DATA_EMISSAO"	+CRLF
	_cQuery += "							, COUNT(0)													AS QTDE_EMISSAO"		+CRLF
	_cQuery += "							, SUM(NVL2(TRIM(CR.E1_EMISSAO),1,0))							AS QTDE_EMISS_TESTE"	+CRLF
	_cQuery += "							, MIN(TO_DATE(NVL(TRIM(CR.E1_BAIXA),'29000101'),'YYYYMMDD')) AS MENOR_DATA_BAIXA"	+CRLF
	_cQuery += "							, MAX(TO_DATE(NVL(TRIM(CR.E1_BAIXA),'19000101'),'YYYYMMDD')) AS MAIOR_DATA_BAIXA"	+CRLF
	_cQuery += "							, SUM(NVL2(TRIM(CR.E1_BAIXA),1,0))							AS QTDE_BAIXA"			+CRLF
	_cQuery += "							, SUM(CR.E1_VALOR)											AS VLR_TITULOS"			+CRLF

	_cQuery +=" FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SE1")  ) + " CR " 
	_cQuery +=" INNER JOIN " + U_IF_BIMFR("PROTHEUS", "SYS_COMPANY"  ) + " FIL ON CR.E1_FILIAL = FIL.M0_CODFIL " 
	_cQuery +=" AND FIL.D_E_L_E_T_  = ' '  "  
	_cQuery +=" INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SA1")  ) + " CLI ON CR.E1_CLIENTE = CLI.A1_COD " 
	_cQuery +=" AND CR.E1_LOJA		 = CLI.A1_LOJA "  
	_cQuery +=" AND CLI.D_E_L_E_T_  = ' ' " 
	_cQuery +=" LEFT JOIN " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("AOV")  ) + " SEG ON CLI.A1_CODSEG = SEG.AOV_CODSEG "
	_cQuery +=" AND SEG.D_E_L_E_T_  = ' ' "		
	_cQuery +=" AND CR.D_E_L_E_T_ = ' ' "		 

	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " CR.E1_EMISSAO BETWEEN '" + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA) , " FIL.M0_CODFIL IN "       + _cCODFILIA                               ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += " GROUP BY FIL.M0_CODFIL " 
	_cQuery += " 	    , FIL.M0_FILIAL "  
	_cQuery += " 	    , SEG.AOV_CODSEG " 
	_cQuery += " 	    , SEG.AOV_DESSEG) TBL_AUX "
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

