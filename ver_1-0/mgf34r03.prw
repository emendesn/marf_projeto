#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R03	บAutor  ณ Geronimo Benedito Alves																	บData ณ26/12/17	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Relat๓rio Lan็amento Despesas  (M๓dulo 34-CTB)					บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R03()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - Lan็amento Despesas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Lan็amento Despesas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Lan็amento Despesas"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Lan็amento Despesas"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  	
	_nInterval	:= 180											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03						 04	 05		 06	 07						 08		 09	
	Aadd(_aCampoQry, {"CT2_FILIAL"	,"COD_FILIAL"							,"C๓digo Filial"		,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"							,"Nome da Filial"		,"C",041	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_DATA"	,"DT_MOVIMENTACAO		as DTMOVIMENT"	,"Data Movimenta็ใo"	,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_TIPO"		,"MES_MOVIMENTACAO		as MESMOVIMEN"	,"M๊s Movimenta็ใo"		,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_TIPO"		,"ANO_MOVIMENTACAO		as ANOMOVIMEN"	,"Ano Movimenta็ใo"		,"C",004	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_LOTE"	,"NUM_LOTE"								,"Nบ Lote"				,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"NOM_LOTE"								,"Nome Lote"			,"C",024	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_DOC"		,"NUM_LANCAMENTO		as NUMLANCAME"	,"Nบ Lan็amento"		,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_DEBITO"	,"COD_CONTA_CONTABIL	as CODCONTCTB"	,"C๓d. Conta Contabil"	,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT1_DESC01"	,"NOM_CONTA_CONTABIL	as NOMCONTCTB"	,"Nome Conta Contabil"	,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_CCD"		,"COD_CENTRO_CUSTO		as CODCENTCUS"	,"C๓d. C.Custo"			,"C",009	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CTT_DESC01"	,"NOM_CENTRO_CUSTO		as NOMCENTCUS"	,"Nome C.Custo"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_HIST"	,"HISTORICO"							,"Hist๓rico"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"B1_COD"		,"TIP_LANCAMENTO		as TIPLANCAME"	,"Tipo Lan็amento"		,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CT2_VALOR"	,"VLR_LANCAMENTO		as VLRLANCAME"	,"Valor Lan็amento"		,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	}) 

	aAdd(_aParambox,{1,"Data Movimento Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Movimento Final"	,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Conta Contabil Inicial"	,Space(tamSx3("CT1_CONTA")[1])	,""		,""													,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Contabil Final"	,Space(tamSx3("CT1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Conta Contabil')"	,"CT1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Inicial",Space(tamSx3("CTT_CUSTO")[1])	,""		,""													,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro de Custo Final"	,Space(tamSx3("CTT_CUSTO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Centro Custo')"	,"CTT"	,"",050,.F.})	

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_LANC_DESPESAS" ) + " A " +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " A.DT_MOVIMENTACAO_FILTRO BETWEEN '" + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDAวรO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " A.COD_FILIAL IN "                   + _cCODFILIA                               ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),   " A.COD_CONTA_CONTABIL BETWEEN '"     + _aRet[3]   + "' AND '" + _aRet[4] + "' " ) //NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),   " A.COD_CENTRO_CUSTO BETWEEN '"       + _aRet[5]   + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO		

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
