#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R21	บAutor  ณ Geronimo Benedito Alves																	บData ณ  11/07/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: FINANCEIRO (CONTAS A PAGAR - Comissใo   (M๓dulo 06-FIN)                     บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																											   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R21()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas a Pagar - Comissใo"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Comissใo"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Comissใo"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Comissใo"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""
	
	//   Versใo Nova  do posicionamento dos campos da _aCampoQry
	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 
	// O nome do campo estแ no elemento 2, mas, se ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras ้  
	// dado a ele um apelido indicado pela clausula "as" que serแ transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos do Array, nใo precisando declara-los.		
	// As unicas exce็๕es sใo os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Tit๚lo, que se no array _aCampoQry, estiver preenchido,
	// ้ preservado, nใo sendo sobreposto pelo X3_DESCRIC 
	//					01			 02						 03							 04		 05		 06	07	08	09
	Aadd(_aCampoQry, {"E1_FILIAL"	,"COD_FILIAL"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"			,"Nome Filial"				,"C"	,40		,0	,""	,""	,""	})	// Este campo nใo existe no SX3
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"NUM_PREFIXO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_LOJA"		,"NUM_LOJA_CLIENTE"		,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"NUM_CNPJ"				,""							,""		,18		,""	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_COMIS1"	,"PRC_COMISSAO"			,"% Comissใo"				,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VEND1"	,"COD_VENDEDOR"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR"			,""							,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO_ORIGINAL"	,"Valor Tํtulo Original"	,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_TITULO_BASE"		,"Valor Tํtulo Base"		,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_COMISSAO_LIQ"		,"Valor Comissใo Liquido"	,""		,""		,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DEVOLVIDO"		,"Valor Devolvido"			,""		,""		,""	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Movimenta็ใo Inicial"	,Ctod("")						,""	,""														,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Data Movimenta็ใo Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Movimenta็ใo')"	,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"C๓digo Cliente Inicial"		,Space(tamSx3("A1_COD")[1])		,""	,""														,"CLI"	,""	, 050,.F.})													
	aAdd(_aParambox,{1,"C๓digo Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	, 050,.F.})
	aAdd(_aParambox,{1,"C๓digo Vendedor Inicial"	,Space(tamSx3("E1_VEND1")[1])	,""	, 														,"SA3"	,""	, 050,.F.})  
	aAdd(_aParambox,{1,"C๓digo Vendedor Final"		,Space(tamSx3("E1_VEND1")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Vendedor')"		,"SA3"	,""	, 050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_COMISSAO"  )              + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_MOVIMENTACAO_FILTRO BETWEEN '"  + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN "               + _cCODFILIA                               ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " COD_CLIENTE BETWEEN '"        + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " COD_VENDEDOR BETWEEN '"       + _aRet[5]   + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
