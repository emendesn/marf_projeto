#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R22	บAutor  ณ Geronimo Benedito Alves																	บData ณ  13/07/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Contabilidade Gerencial - Compras (M๓dulo 34-CTB)                             บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																											   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R22()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - Compras"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Compras"								)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Compras"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Compras"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02						 03							 04		 05	 06  07		08 09		
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"FORNECEDOR"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_LOJA"		,"LOJA_FORNECEDOR"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ"					,"CNPJ Fornecedor"			,"C"	,25	,0	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"E4_CODIGO"	,"COD_CONDICAO_PAG"		,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESC_CONDICAO_PAG"	,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_FILIAL"	,"D1_FILIAL"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ITEM"		,"D1_ITEM"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_COD"		,"D1_COD"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_UM"		,"D1_UM"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_QUANT"	,"D1_QUANT"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VUNIT"	,"D1_VUNIT"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_TOTAL"	,"D1_TOTAL"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VALIPI"	,"D1_VALIPI"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VALICM"	,"D1_VALICM"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_TES"		,"D1_TES"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CF"		,"D1_CF"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DESC"		,"D1_DESC"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_IPI"		,"D1_IPI"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_PICM"		,"D1_PICM"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_PESO"		,"D1_PESO"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CONTA"	,"D1_CONTA"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ITEMCTA"	,"D1_ITEMCTA"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CC"		,"D1_CC"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_OP"		,"D1_OP"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_PEDIDO"	,"D1_PEDIDO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ITEMPC"	,"D1_ITEMPC"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_LOCAL"	,"D1_LOCAL"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DOC"		,"D1_DOC"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_EMISSAO"	,"D1_EMISSAO"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"D1_DTDIGIT"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_GRUPO"	,"D1_GRUPO"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_TIPO"		,"D1_TIPO"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_SERIE"	,"D1_SERIE"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSTO2"	,"D1_CUSTO2"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSTO3"	,"D1_CUSTO3"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSTO4"	,"D1_CUSTO4"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSTO5"	,"D1_CUSTO5"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_TP"		,"D1_TP"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_NUMSEQ"	,"D1_NUMSEQ"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_NFORI"	,"D1_NFORI"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_SERIORI"	,"D1_SERIORI"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ITEMORI"	,"D1_ITEMORI"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_QTDEDEV"	,"D1_QTDEDEV"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VALDEV"	,"D1_VALDEV"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ORIGLAN"	,"D1_ORIGLAN"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_ICMSRET"	,"D1_ICMSRET"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_BRICMS"	,"D1_BRICMS"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_NUMCQ"	,"D1_NUMCQ"				,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DATORI"	,"D1_DATORI"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_BASEICM"	,"D1_BASEICM"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VALDESC"	,"D1_VALDESC"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_IDENTB6"	,"D1_IDENTB6"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_LOTEFOR"	,"D1_LOTEFOR"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_SKIPLOT"	,"D1_SKIPLOT"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_BASEIPI"	,"D1_BASEIPI"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_SEQCALC"	,"D1_SEQCALC"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSFF1"	,"D1_CUSFF1"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSFF2"	,"D1_CUSFF2"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSFF3"	,"D1_CUSFF3"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSFF4"	,"D1_CUSFF4"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CUSFF5"	,"D1_CUSFF5"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CODCIAP"	,"D1_CODCIAP"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_CLASFIS"	,"D1_CLASFIS"			,""							,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_BASIMP1"	,"D1_BASIMP1"			,""							,""		,""	,""	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Emissใo Inicial"		,Ctod("")						,""		,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Emissใo Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Emissใo')"		,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,"@!"	,""														,"SA2"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Codigo Fornecedor Final"	,Space(tamSx3("A2_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'C๓digo Fornecedor')"	,"SA2"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Conta Contabil Inicial"		,Space(tamSx3("D1_CONTA")[1])	,"@!"	,""														,"CT1"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"Conta Contabil Final"		,Space(tamSx3("D1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'Conta Contแbil')"		,"CT1"	,""	, 050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_COMPRAS"  )          + CRLF
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " D1_FILIAL IN "               + _cCODFILIA                             ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " D1_EMISSAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " COD_FORNECEDOR BETWEEN '"    + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),       " D1_CONTA BETWEEN '"          + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

