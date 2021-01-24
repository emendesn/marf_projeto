#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF29R34	บAutor  ณ Geronimo Benedito Alves																	บData ณ08/01/18	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTAวรO - Controle AWB x ETA						บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF29R34()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery/*, _cCODFILIA*/
	Private _nInterval/*, _aSelFil		:= {}*/
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTAวรO - Gera็ใo de Titulos"	)		// 01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Gera็ใo de Titulos"				)	// 02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Gera็ใo de Titulos"}				)	// 03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Gera็ใo de Titulos"}				)	// 04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}	)						// 05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	// 06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 35							// Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03						 04	 05	  	 06  07			  08 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP"								,"No. EXP"			,"C",013	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"								,"Ano EXP"			,"C",002	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"								,"SUBEXP"			,"C",003	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"							,"Buyer"			,"C",040	,0, ""				,""	,""	 })
 	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_PORTO_DESTINO	as PAIS_DEST"	,"Paํs Destino"		,"C",025	,0, ""				,	,})
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"								,"Navio"			,"C",040	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_DTENDC"	,"DT_SAIDA_NAVIO"						,"Data Saida Navio"	,"D",008	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_DTENDC"	,"DT_DOC"								,"Data Docs"		,"D",008	,0, ""				,	,})
	Aadd(_aCampoQry, {"ZB8_MOEDA"	,"MOEDA"								,"Moeda"			,"C",003	,0, ""				,""	,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"TOTAL"								,"Total"			,"N",015	,2, "@E 999,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR		as ADMINISTRA"		,"Adm"				,"C",035	,0, ""				,""	,""	 })
	Aadd(_aCampoQry, {"YC_NOME"		,"FAMILA_PRODUTO	as FAM_PRODUT"		,"Familia"			,"C",045	,0, ""				,""	,""	 })
	Aadd(_aCampoQry, {"BDM_DESCRI"	,"STATUS"								,"Status"			,"C",035	,0, "" 				,	,})


	aAdd(_aParambox,{3,"Exportadora" 			,iif(Set(_SET_DELETED),1,2)		, {'MARFRIG','PAMPEANO','Ambos'}						,100,"",.T.})			//01
	aAdd(_aParambox,{1,"Administrador"					,Space(tamSx3("ZB8_RESPON")[1])	,"@!"	,"" 												,""			,"",115,.F.})	     // retirada a consulta SXB E33													
	aAdd(_aParambox,{1,"Nome Familia Produto"			,Space(tamSx3("EEH_NOME")[1])	,"@!"	,""													,"EEH90"	,"",115,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cExport	:= "'MARFRIG','PAMPEANO'"
	If _aRet[1] <> 3	//3 = Ambos
		_cExport	:= If(_aRet[1] == 1, "'MARFRIG'" , "'PAMPEANO'" )
	Endif

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_EX_GERACAO_TITULOS"  )       + CRLF
	_cQuery += U_WhereAnd(!empty(_aRet[1]),    " FILTRO_EXP  IN ("    			  + _cExport + ") " 	)	
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " ADMINISTRADOR LIKE '%"       + _aRet[2] + "%' "    )//NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " FAMILA_PRODUTO LIKE '%"      + _aRet[3] + "%' "    )//NรO ษ OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

