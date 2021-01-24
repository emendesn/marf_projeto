#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R22	บAutor  ณ Geronimo Benedito Alves																	บData ณ  12/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Contabilidade Gerencial - SD3 (M๓dulo 34-CTB)                                    บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																											   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑบAltera็๕es		ณ Data: 22-01-2019 ณ Inclusใo de dois novos campos na query classe valor e descricao classe valor 			   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R23()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - SD3"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "SD3"								)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"SD3"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"SD3"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02						 03							 04		 05	 06  07		08 09		
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FILIAL"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"FILIAL"				,"Nome Filial"				,"C"	,40	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_TM"		,"COD_TP_MOVIMENTO"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F5_TEXTO"	,"TP_MOVIMENTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_COD"		,"COD_PRODUTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_UM"		,"UNIDADE"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_QUANT"	,"QTDE"					,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CONTA"	,"COD_CONTA_CONTABIL"	,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"CONTA_CONTABIL"		,""							,""		,""	,""	,""		,""	,""	})	// Verificar campo na query
	Aadd(_aCampoQry, {"D3_ORDEM"	,"ORDEM_PRODUCAO"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_LOCAL"	,"GRUPO_ARMAZEM"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_DOC"		,"DOCUMENTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_EMISSAO"	,"DATA_EMISSAO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CUSTO1"	,"CUSTO"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CUSTO2"	,"CUSTO_MOEDA2"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CUSTO3"	,"CUSTO_MOEDA3"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CUSTO4"	,"CUSTO_MOEDA4"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CUSTO5"	,"CUSTO_MOEDA5"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"XXD3ESTORN"	,"ESTORNADO"			,"Estornado"				,"C"	,3	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"CTT_CUSTO"	,"COD_C_CUSTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"CTT_DESC01"	,"DESC_C_CUSTO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_DTVALID"	,"VALIDADE_LOTE"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_USUARIO"	,"USUARIO"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D3_CLVL"	,"CLASSE_VALOR"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"CTH_DESC01"	,"CLASSE_VALOR_DESCRICAO"			,""							,""		,""	,""	,""		,""	,""	})


	aAdd(_aParambox,{1,"Data Emissใo Inicial"		,Ctod("")						,""		,""														,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Data Emissใo Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02,'Data Emissใo')"		,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"C๓digo Produto Inicial"		,Space(tamSx3("D3_COD")[1])		,"@!"	,""														,"SB1"	,""	, 075,.F.})
	aAdd(_aParambox,{1,"C๓digo Produto Final"		,Space(tamSx3("D3_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04,'C๓digo Fornecedor')"	,"SB1"	,""	, 075,.F.})
	aAdd(_aParambox,{1,"Tipo Movimento Inicial"		,Space(tamSx3("D3_TM")[1])		,"@!"	,""														,"SF5"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Tipo Movimento Final"		,Space(tamSx3("D3_TM")[1])		,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06,'Conta Contแbil')"		,"SF5"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Inicial"	,Space(tamSx3("CTT_CUSTO")[1])	,"@!"	,""														,"CTT"	,""	, 075,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Final"		,Space(tamSx3("CTT_CUSTO")[1])	,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08,'C๓digo Fornecedor')"	,"CTT"	,""	, 075,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_SD3"  )          + CRLF
	
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " COD_FILIAL IN "                + _cCODFILIA                             ) //OBRIGATORIO, SELEวรO POR FILIAL
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DATA_EMISSAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO - SEM TRAVA DE DATA
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " COD_PRODUTO         BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NรO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),       " COD_TP_MOVIMENTO    BETWEEN '" + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),       " COD_C_CUSTO         BETWEEN '" + _aRet[7] + "' AND '" + _aRet[8] + "' " ) //NรO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

