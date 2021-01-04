#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R19	�Autor  � Geronimo Benedito Alves																	�Data �  18/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Faturas                          (Modulo 34-CTB)                 ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R19()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - Faturas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "SFT - Faturas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"SFT - Faturas"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"SFT - Faturas"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02						 03						 04		 05		 06	 07	 08	 09		
	Aadd(_aCampoQry, {"E2_FILIAL"	,"FILIAL"				,"Filial"				,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_FATURA"	,"FATURA"				,"Fatura"				,"C"	,009	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"				,"Prefixo"				,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUMERO_TITULO"		,"N� Titulo"			,"C"	,009	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_PARCELA"	,"PARCELA"				,"Parcela"				,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIPO"					,"Tipo"					,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"NATUREZA"				,"Natureza"				,"C"	,010	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"NATUREZA_DESCRICAO"	,"Descricao Natureza"	,"C"	,030	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"XXA2_CGC"	,"CNPJ_CPF"				,"CNPF / CPF"			,"C"	,018	,0	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR"		,"Cod. Fornecedor"		,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_LOJA"		,"LOJA"					,"LOJA"					,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR"		,"Nome Fornecedor"		,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"			,"Data Emissao"			,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"VENCIMENTO"			,"Vencimento"			,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCORI"	,"VENCIMENTO_ORIGEM"	,"Vencimento Origem"	,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_MOVIMEN"	,"DT_ULT_MOVIMENTO"		,"Data Ult. Movimnto"	,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"VENCIMENTO_REAL"		,"Vencim. Real"			,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_TITULO"			,"Valor Titulo"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_VALLIQ"	,"VALOR_LIQUIDO_BAIXA"	,"Valor Liquido Baixa"	,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_DECRESC"	,"DECRESCIMO"			,"Decresimo"			,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_SALDO"	,"SALDO"				,"Saldo"				,"N"	,016	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DATA_BAIXA"			,"Data Baixa"			,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"E2_EMIS1"	,"DATA_CONTAB"			,"Data Contab"			,"D"	,008	,0	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")						,""	,""														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Emissao')"		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Inicial"	,Ctod("")						,""	,""														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Data Vencimento')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Base Inicial"			,Ctod("")						,""	,""														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Base Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'Data Base')"			,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,""	,""														,"SA2"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"		,Space(tamSx3("A2_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08	,'Cod. Fornecedor')" 	,"SA2"	,"",050,.F.})
	aAdd(_aParambox,{1,"Prefixo Inicial"			,Space(tamSx3("E2_PREFIXO")[1])	,""	,""														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Prefixo Final"				,Space(tamSx3("E2_PREFIXO")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10	,'Prefixo')"			,""		,"",050,.F.})
	aAdd(_aParambox,{1,"C�d. Natureza Inicial"		,Space(tamSx3("E2_NATUREZ")[1])	,""	,""														,"SED"	,"",050,.F.})
	aAdd(_aParambox,{1,"C�d. Natureza Final"		,Space(tamSx3("E2_NATUREZ")[1])	,""	,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'C�d. Natureza')"		,"SED"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_FATURAS"  )          + CRLF
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),    " FILIAL IN "                  + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),      " DT_EMISSAO_FILTRO BETWEEN '" + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),      " VENCIMENTO_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),      " DATA_BASE_FILTRO BETWEEN '"  + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),      " COD_FORNECEDOR BETWEEN '"    + _aRet[7]  + "' AND '" + _aRet[8]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[10] ),     " PREFIXO BETWEEN '"           + _aRet[9]  + "' AND '" + _aRet[10] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[12] ),     " NATUREZA BETWEEN '"          + _aRet[11] + "' AND '" + _aRet[12] + "' " ) //NAO OBRIGATORIO
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN