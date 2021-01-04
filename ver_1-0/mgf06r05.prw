#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R05	�Autor  �Geronimo Benedito Alves																	�Data � 12/12/17   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Fornecedores em Aberto			  (Modulo 06-FIN)  ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	Private cDesc_Stat

	Aadd(_aDefinePl, "Contas a pagar - Fornecedores em Aberto"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Fornecedores em Aberto"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Fornecedores em Aberto"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Fornecedores em Aberto"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35												//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""												 

	cDesc_Stat  := "  CASE "							 +CRLF
	cDesc_Stat	+= "		WHEN STATUS_TITULO = 1 "		+CRLF
	cDesc_Stat	+= "		THEN 'TITULO EM ABERTO' "		+CRLF
	cDesc_Stat	+= "		WHEN STATUS_TITULO = 2 "		+CRLF
	cDesc_Stat	+= "		THEN 'BAIXADO PARCIALMENTE' " +CRLF
	cDesc_Stat	+= "		WHEN STATUS_TITULO = 4 "		+CRLF
	cDesc_Stat	+= "		THEN 'TITULO EM BORDERO' "	+CRLF 
	cDesc_Stat	+= "		ELSE NULL "						+CRLF
	cDesc_Stat	+= "  END		AS DESCSTATUS "			+CRLF
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03							 04	 05		 06	 07					 	 08 09		
	Aadd(_aCampoQry, {"CT2_FILIAL"	,"COD_FILIAL"							,"Cod. Filial"				,"C",006	,0	,""	 					,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"							,"Nome da Filial"			,"C",040	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR		as CODFORNECE"	,"Cod. Fornecedor"			,"C",006	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_NOMFOR"	,"NOM_FORNECEDOR		as NOMFORNECE"	,"Nome do Fornecedor"		,"C",040	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ"									,"CNPJ"						,"C",018	,0	,"@!" 					,""	,"@!"	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"								,U_X3Titulo("E2_PREFIXO")	,"C",003	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"A1_NREDUZ"	,cDesc_Stat								,"Descricao Status"			,"C",020	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"COD_NATUREZA			as CODNATUREZ"	,U_X3Titulo("E2_NATUREZ")	,"C",010	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESC_NATUREZA			as DESCNATURE"	,U_X3Titulo("ED_DESCRIC")	,"C",030	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_CONTAD"	,"COD_CONTA_CONTABIL	as CODCONTCTB"	,U_X3Titulo("CT1_CONTA")	,"C",020	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"DESC_CONTA_CONTABIL 	as DESCCONTCT",U_X3Titulo("CT1_DESC01")		,"C",040	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"							,U_X3Titulo("E2_EMISSAO")	,"D",008	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO			as DT_VENCTO"	,U_X3Titulo("E2_VENCTO")	,"D",008	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_VENCIMENTO_REAL	as DTVENCREAL"	,U_X3Titulo("E2_VENCREA")	,"D",008	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_MOTIVO"	,"MOT_NAO_PAGAMENTO		as MOTNAOPAGT"	,U_X3Titulo("E2_MOTIVO ")	,"C",020	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIP_DOCUMENTO			as TIPDOCUMEN"	,U_X3Titulo("E2_TIPO")		,"C",003	,0	,"" 					,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VLR_DOCUMENTO			as VLRDOCUMEN"	,U_X3Titulo("E2_VALOR")		,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_SALDO"	,"VLR_SALDO"							,U_X3Titulo("E2_SALDO")		,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_MULTA"	,"VLR_MULTA"							,U_X3Titulo("E2_MULTA")		,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")		,""		,""												,""	,"",050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")		,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"	,""	,"",050,.T.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery	+= "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_FORNECEDORES_ABERTO " )  + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_EMISSAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_FILIAL IN "              + _cCODFILIA                              ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( .T. ,                   " STATUS_TITULO IN (1,2,4) "    )													
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

