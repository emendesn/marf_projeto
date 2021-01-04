#include "totvs.ch"   

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R18	�Autor  � Renato Vieira Bandeira Junior																	�Data �  11/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - SFT - Saidas                      (Modulo 05-FAT)       ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R16()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Volumetria de Notas Faturadas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Notas Faturadas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Notas Faturadas"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Notas Faturadas"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	Aadd(_aCampoQry, {"FT_EMISSAO"		,"FT_EMISSAO"		,"FT_EMISSAO"		,"D"	,008	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_NFISCAL"		,"FT_NFISCAL"		,"FT_NFISCAL"		,"C"	,009	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_SERIE"		,"FT_SERIE"			,"FT_SERIE"			,"C"	,003	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CLIEFOR"		,"FT_CLIEFOR"		,"FT_CLIEFOR"		,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_LOJA"			,"FT_LOJA"			,"FT_LOJA"			,"C"	,002	,0	,""	,""	,""	})

	Aadd(_aCampoQry, {"CNPJ_CLIENTE"	,"CNPJ_CLIENTE"		,"CNPJ_CLIENTE"		,"C"	,014	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CNPJ_FORNECEDOR"	,"CNPJ_FORNECEDOR"	,"CNPJ_FORNECEDOR"	,"C"	,014	,0	,""	,""	,""	})

	Aadd(_aCampoQry, {"FORNECEDOR"		,"FORNECEDOR"		,"FORNECEDOR"		,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"CLIENTE"			,"CLIENTE"			,"CLIENTE"			,"C"	,040	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_ESTADO"		,"FT_ESTADO"		,"FT_ESTADO"		,"C"	,002	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_CFOP"			,"FT_CFOP"			,"FT_CFOP"			,"C"	,005	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_VALCONT"		,"FT_VALCONT"		,"FT_VALCONT"		,"N"	,014	,2	,""	,""	,""	})
	Aadd(_aCampoQry, {"FT_OBSERV"		,"FT_OBSERV"		,"FT_OBSERV"		,"C"	,031	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"USR_ID"			,"USR_ID"			,"ID_USUARIO"		,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"USR_CODIGO"		,"USR_CODIGO"		,"COD_USUARIO"		,"C"	,010	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"USR_NOME"		,"USR_NOME"			,"NOME_USUARIO"		,"C"	,020	,0	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Saida Inicial"		,Ctod("")						,""		,""												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Saida Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data')" 		,""		,"",050,.T.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_SFTSAIDA_USUARIO"  )         + CRLF

	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " FT_FILIAL IN "               + _cCODFILIA                             	 ) +CRLF //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " FT_EMISSAO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " 	 ) +CRLF //NAO OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

