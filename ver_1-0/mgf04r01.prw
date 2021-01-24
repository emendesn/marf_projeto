#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF04R01	�Autor  � Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: ESTOQUE - Itens Sem Movimenta��o  (M�dulo 04-ESTOQUE)							 ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF04R01()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "ESTOQUE - Itens Sem Movimenta��o"		)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Itens Sem Movimenta��o"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Itens Sem Movimenta��o"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Itens Sem Movimenta��o"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  									)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_nInterval	:= 90											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""										

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			 02										 03					 	 	04	     05	 06		07		08	09		
	Aadd(_aCampoQry, { "A1_NOME"	,"NOME_FILIAL 			as NOMEFILIAL"	,"Nome Filial"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_COD"		,"COD_PRODUTO 			as CODPRODUTO"	,"C�digo Produto"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B1_DESC"	,"DESC_PRODUTO	 		as DESCPRODUT"	,"Descri��o Produto"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "AH_DESCPO"	,"DESC_UNIDADE_MEDIDA	as DESCUNIDME"	,"Descri��o Unidade Medida"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_GRUPO"	,"COD_GRUPO_ESTOQUE		as CODGRUPEST"	,"C�digo Grupo Estoque"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "BM_DESC"	,"DESC_GRUPO_ESTOQUE 	as DESCGRUEST"	,"Descri��o Grupo Estoque"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "NNR_CODIGO"	,"COD_LOCAL_ESTOQUE	 	as CODLOCALES"	,"C�digo Local Estoque"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "NNR_DESCRI"	,"DESC_LOCAL_ESTOQUE 	as DESCLOCALE"	,"Descri��o Local Estoque"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_USAI"	,"DATA_ULT_SAIDA		as DTULTSAIDA"	,"Data �ltima Sa�da"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_DINVENT"	,"DATA_INVENTARIO		as DTINVENTAR"	,"Data Invent�rio"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_DINVENT"	,"DATA_BLOQUEIO			as DTBLOQUEIO"	,"Data Bloqueio"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_QATU"	,"QTD_ESTOQUE_ATUAL		as QTDESTOATU"	,"Qtde Estoque Atual"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_CM1"		,"CUSTO_UNITARIO		as CUSTOUNITA"	,"Custo Unit�rio"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, { "B2_VATU1"	,"CUSTO_TOTAL 			as CUSTOTOTAL"	,"Custo Total"				,""		,""	,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Bloqueio Inicial"	,Ctod("")	,""	,"" 											,""	,"",050,.T.})
	aAdd(_aParambox,{1,"Data Bloqueio Final"	,Ctod("")	,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"	,""	,"",050,.T.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
 
	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_ALMOX_ITEMSEMMOVIMENTACAO")  + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " DATA_BLOQUEIO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO, COM A VALIDA��O DE 90 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " COD_FILIAL IN "                 + _cCODFILIA	                            )	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

