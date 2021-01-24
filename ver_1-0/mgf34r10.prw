#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R10	บAutor  ณ Geronimo Benedito Alves																	บData ณ 05/07/17   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: CONTABILIDADE - CT2                                             (M๓dulo 34-CTB)  บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																										       บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R10()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - CT2"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "CT2"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"CT2"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"CT2"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }				)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02				 03				 04	 05	 06	 07	 08	 09		
	Aadd(_aCampoQry, {"CT2_FILIAL"	,"CT2_FILIAL"	,"CT2_FILIAL"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_DATA"	,"CT2_DATA"		,"CT2_DATA"		,""	,""	,""	,""	,""	,""	})				
	Aadd(_aCampoQry, {"CT2_LOTE"	,"CT2_LOTE"		,"CT2_LOTE"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_SBLOTE"	,"CT2_SBLOTE"	,"CT2_SBLOTE"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_DOC"		,"CT2_DOC"		,"CT2_DOC"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_LINHA"	,"CT2_LINHA"	,"CT2_LINHA"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_DC"		,"CT2_DC"		,"CT2_DC"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_DEBITO"	,"CT2_DEBITO"	,"CT2_DEBITO"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_CREDIT"	,"CT2_CREDIT"	,"CT2_CREDIT"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_VALOR"	,"CT2_VALOR"	,"CT2_VALOR"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_HP"		,"CT2_HP"		,"CT2_HP"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_HIST"	,"CT2_HIST"		,"CT2_HIST"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_CCD"		,"CT2_CCD"		,"CT2_CCD"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_CCC"		,"CT2_CCC"		,"CT2_CCC"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_ITEMD"	,"CT2_ITEMD"	,"CT2_ITEMD"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_ITEMC"	,"CT2_ITEMC"	,"CT2_ITEMC"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_CLVLDB"	,"CT2_CLVLDB"	,"CT2_CLVLDB"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_CLVLCR"	,"CT2_CLVLCR"	,"CT2_CLVLCR"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_EMPORI"	,"CT2_EMPORI"	,"CT2_EMPORI"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_FILORI"	,"CT2_FILORI"	,"CT2_FILORI"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_TPSALD"	,"CT2_TPSALD"	,"CT2_TPSALD"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_MANUAL"	,"CT2_MANUAL"	,"CT2_MANUAL"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_ORIGEM"	,"CT2_ORIGEM"	,"CT2_ORIGEM"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_ROTINA"	,"CT2_ROTINA"	,"CT2_ROTINA"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_AGLUT"	,"CT2_AGLUT"	,"CT2_AGLUT"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_LP"		,"CT2_LP"		,"CT2_LP"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_KEY"		,"CT2_KEY"		,"CT2_KEY"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_AT01DB"	,"CT2_AT01DB"	,"CT2_AT01DB"	,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, {"CT2_AT01CR"	,"CT2_AT01CR"	,"CT2_AT01CR"	,""	,""	,""	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Lancamento Contแbil Inicial"	,Ctod(""),""	,""															,""	,"",050,.F.})
	aAdd(_aParambox,{1,"Data Lancamento Contแbil Final"		,Ctod(""),""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Lancamento Contab')"	,""	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_CT2"  )        + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " CT2_FILIAL IN "        + _cCODFILIA                             ) // OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // NAO OBRIGATORIO
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
