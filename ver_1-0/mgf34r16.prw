#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R16	�Autor  � Geronimo Benedito Alves																	�Data �27/04/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Relatorio NF Canceladas						(Modulo 34-CTB)		���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R16()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - NF Canceladas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "NF Canceladas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"NF Canceladas"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"NF Canceladas"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03						 04		 05	  	06	 07	08	09		
	Aadd(_aCampoQry, {"F3_FILIAL"	,"FILIAL"								,"C�d. Filial"			,"C"	,006	,0	,""	,""	,""	})
	Aadd(_aCampoQry, {"F3_DTCANC"	,"DATA_CANCELAMENTO		as DT_CANCELA"	,"Dt. de Cancelamento"	,"D"	,008	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_NFISCAL"	,"NOTA_FISCAL			as NOTAFISCAL"	,"N� Nota Fiscal"		,"C"	,009	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_SERIE"	,"SERIE"								,"N� Serie"				,"C"	,003	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_CLIEFOR"	,"CLIENTE_FORNECEDOR	as CLIE_FORNE"	,"Cliente-Fornecedor"	,"C"	,006	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_LOJA"		,"LOJA"									,"Loja"					,"C"	,002	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_CFO"		,"COD_FISCAL"							,"C�d. Fiscal"			,"C"	,005	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_CODISS"	,"COD_SERVICO_ISS		as SERVICOISS"	,"C�d. Servico ISS"		,"C"	,009	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_ESTADO"	,"ESTADO"								,"Estado"				,"C"	,002	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_EMISSAO"	,"DATA_EMISSAO			as DT_EMISSAO"	,"Data Emissao"			,"D"	,008	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_OBSERV"	,"OBSERVACAO"							,"Observacao"			,"C"	,060	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_DESCRET"	,"DESC_RETORNO			as DESCR_RETO"	,"Descr. Retorno"		,"C"	,250	,0	,""	,"" ,""	})
	Aadd(_aCampoQry, {"F3_CHVNFE"	,"CHAVE_NFE"							,"Chave NFE"			,"C"	,044	,0	,""	,"" ,""	})
		
	aAdd(_aParambox,{1,"Data Cancelamento Inicial"	,Ctod("")						,""	,""														,"","",050,.F.})
	aAdd(_aParambox,{1,"Data Cancelamento Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Cancelamento')" 	,"","",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")						,""	,""														,"","",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Emissao')" 		,"","",050,.F.})
	aAdd(_aParambox,{1,"Nota Fiscal Inicial"		,Space(tamSx3("F3_NFISCAL")[1])	,""	,""														,"","",050,.F.}) 
	aAdd(_aParambox,{1,"Nota Fiscal Final"			,Space(tamSx3("F3_NFISCAL")[1])	,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Nota Fiscal')" 		,"","",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Cancelamento Inicial, nao pode ser maior que a data de Cancelamento Final.")
		Return.F.
	Endif
	If _aRet[3] > _aRet[4]
		MsgStop("A Data de Emissao Inicial, nao pode ser maior que a data de Emissao Final.")
		Return.F.
	Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_NFCANCELADAS"  )            + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " FILIAL IN "                         + _cCODFILIA                             ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_CANCELAMENTO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " DATA_EMISSAO_FILTRO BETWEEN '"      + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " NOTA_FISCAL BETWEEN '"              + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN