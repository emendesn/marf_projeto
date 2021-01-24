#include "totvs.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF04R07	บAutor  ณ Geronimo Benedito Alves                                                               บData ณ  22/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Tํtulos em Aberto CP (M๓dulo 06-FIN)                บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF04R07()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""

	Aadd(_aDefinePl, "Grade de Aprova็ใo"					)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Grade de Aprova็ใo"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Grade Aprova็ใo"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Grade Aprova็ใo"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba

	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02					 03							 04	 05	 06	07		08	09
	Aadd(_aCampoQry, {"ZB2_ID"		,"ID"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_SEQ"		,"SEQ"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_IDSET"	,"ID_SETOR"       ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"USR_NOME"	,"USUARIO"        ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_IDAPR"	,"ID_APROVADOR"   ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_DATA"	,"DATA_APROVACAO" ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_HORA"	,"HORA_APROVACAO" ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_STATUS"	,"STATUS"         ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_OBS"		,"OBSERVACAO"     ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_EMAIL"	,"EMAIL"          ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_ABA"		,"ABA"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZB2_IDABA"	,"ID_ABA"         ,""						,""	,""	,""	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Inicial"	,Ctod("")						,""		,""															,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Vencimento Real' )"	,""		,""	,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_GRADE_APROVACAO"  )				+ CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DATA_FILTRO BETWEEN '"	+ _aRet[1]   + "' AND '" + _aRet[2] + "' " )
																				//
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

