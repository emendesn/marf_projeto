#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R01	�Autor  �Geronimo Benedito Alves																	�Data �  01/12/17  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Estoque Pr� - Contabilizado  (Modulo 34-CTB)						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R01()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - Estoque Pre Contabilizado"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Estoque Pre_Contabilizado"							)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Estoque Pre_Contabilizado"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Estoque Pre_Contabilizado"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  													)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 											)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35															//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02									 03							 04	 05		 06	07					  	08		 09	
	Aadd(_aCampoQry, {"A1_FILIAL"	, "COD_FILIAL"						,"Codigo Filial"			,"C",012	,0, ""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_NOME"		,"FILIAL"							,"Filial"					,"C",041	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_EMISSAO"	,"DT_MOVIMENTO	as DTMOVIMENT"		,"Data do Movimento"		,"D",008	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_TM"		,"TP_MOVIMENTO	as TPMOVIMENT"		,"Tipo Movimento"			,"C",003	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_DOC"		,"DOCUMENTO"						,"Documento"				,"C",009	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_COD"		,"COD_PRODUTO	as CODPRODUTO"		,"Codigo do Produto"		,"C",015	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO	as DESCRPRODU"		,"Descricao do Produto"		,"C",076	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_QUANT"	,"QTDE"								,"Quantidade"				,"N",017	,2, "@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"D3_CUSTO1"	,"VALOR"							,"Valor"					,"N",017	,2, "@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"CTT_CUSTO"	,"COD_C_CUSTO	as COD_C_CUST"		,"Codigo C.Custo"			,"C",009	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"CTT_DESC01"	,"DESC_C_CUSTO	as DESC_C_CUS"		,"Descricao C.Custo"		,"C",040	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"D3_CLVL"		,"CL_VALOR"							,"Classe de Valor"			,"C",009	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"B1_CONTA"	,"CONT_ERP"							,"Conta Cont�bil"			,"C",020	,0, ""						,""		,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"CT1_DESC01"						,"Descricao Conta Cont�bil"	,"C",040	,0, ""						,""		,""	})

	aAdd(_aParambox,{1,"Data Movimento Inicial"		,Ctod("")						,""		,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Movimento Final"		,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"			,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Conta Contabil Inicial"		,Space(tamSx3("CT1_CONTA")[1])	,""		,""														,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Contabil Final"		,Space(tamSx3("CT1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Conta Contabil')"		,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Inicial"	,Space(tamSx3("CTT_CUSTO")[1])	,""		,""														,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Final"		,Space(tamSx3("CTT_CUSTO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Centro de Custo')"	,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe de Valor Inicial"	,Space(tamSx3("D3_CLVL")[1])	,""		,""														,"CTH"	,"",050,.F.})
	aAdd(_aParambox,{1,"Classe de Valor Final"		,Space(tamSx3("D3_CLVL")[1])	,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Classe de Valor')"	,"CTH"	,"",050,.F.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_PLANEJAMENTO_ESTOQUE" ) + ' A ' + CRLF 
	_cQuery += "  INNER JOIN " + U_IF_BIMFR(       "PROTHEUS", RetSqlName("CT1") )    + " CT1 ON TRIM(A.CONT_ERP) = TRIM(CT1.CT1_CONTA) " +CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_MOVIMENTO_FILTRO BETWEEN '"   + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO (USU�RIO DIGITA) 
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " CONT_ERP	BETWEEN '"            + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NAO � OBRIGATORIO (USU�RIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " COD_C_CUSTO BETWEEN '"           + _aRet[5]   + "' AND '" + _aRet[6] + "' " ) //NAO � OBRIGATORIO (USU�RIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[8]),       " CL_VALOR BETWEEN '"              + _aRet[7]   + "' AND '" + _aRet[8] + "' " ) //NAO � OBRIGATORIO 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN "                  + _cCODFILIA                               ) //OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN


