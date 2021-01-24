#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R06	บAutor  ณGeronimo Benedito Alves																	บData ณ29/12/17	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Posi็ใo Vencidos				(M๓dulo 06-FIN)	บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R06()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	Private _DE01A15DI, _DE16A30DI, _DE31A60DI, _DE61A120D, _ACIMA120D 

	Aadd(_aDefinePl, "Contas a Receber - Posi็ใo Vencidos" )	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Posi็ใo Vencidos"	)						//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Posi็ใo Vencidos"} )						//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Posi็ใo Vencidos"} )						//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  	
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	_DE01A15DI := "  SUM(CASE  "
	_DE01A15DI += "		 WHEN AUX.QTD_DIAS_VENCIDO <= 15 "
	_DE01A15DI += "		THEN AUX.E1_VALOR "
	_DE01A15DI += "		 ELSE 0 "
	_DE01A15DI += "  END)															AS DE01A15DIA "

	_DE16A30DI := "  SUM(CASE "
	_DE16A30DI += "		 WHEN AUX.QTD_DIAS_VENCIDO > 15 AND AUX.QTD_DIAS_VENCIDO <= 30 "
	_DE16A30DI += "		THEN AUX.E1_VALOR "
	_DE16A30DI += "		 ELSE 0 "
	_DE16A30DI += "  END)															AS DE16A30DIA "

	_DE31A60DI := "  SUM(CASE "
	_DE31A60DI += "		 WHEN AUX.QTD_DIAS_VENCIDO > 30 AND AUX.QTD_DIAS_VENCIDO <= 60 "
	_DE31A60DI += "		THEN AUX.E1_VALOR  "
	_DE31A60DI += "		 ELSE 0 "
	_DE31A60DI += "  END)															AS DE31A60DIA "

	_DE61A120D := "  SUM(CASE "
	_DE61A120D += "		 WHEN AUX.QTD_DIAS_VENCIDO > 60 AND AUX.QTD_DIAS_VENCIDO <= 120 "
	_DE61A120D += "		THEN AUX.E1_VALOR "														
	_DE61A120D += "		 ELSE 0  "
	_DE61A120D += "  END)															AS DE61A120DI "		

	_ACIMA120D := "  SUM(CASE "
	_ACIMA120D += "		 WHEN AUX.QTD_DIAS_VENCIDO > 120 "
	_ACIMA120D += "		THEN AUX.E1_VALOR " 
	_ACIMA120D += "		 ELSE 0 "
	_ACIMA120D += "  END)															AS ACIMA120DI "

	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02											 03							 04	 05		 06	 07				 	08		 09		
	Aadd(_aCampoQry, {"A1_COD"		,"MAX(COD_CLIENTE)			as CODCLIENTE"	,"C๓digo do Cliente"		,"C",006	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"MAX(NOM_CLIENTE)			as NOMCLIENTE"	,"Cliente"					,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"MAX(DESC_REDE)            as DESC_REDE"	,"Rede"						,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"ZE9_DESCAN"	,"MAX(DESC_CANAL_VENDA)		as DESC_CANAL"	,"Canal de Venda"			,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"MAX(NOM_VENDEDOR_RESP)	as NOMVENDRES"	,"Vendedor"					,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"MAX(DESC_SEGMENTO)		as DESCSEGMEN"	,"Segmento"					,"C",040	,0	,""					,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,_DE01A15DI									,"DE 01 A 15 DIAS"			,"N",009	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,_DE16A30DI									,"DE 16 A 30 DIAS"			,"N",009	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,_DE31A60DI									,"DE 31 A 60 DIAS"			,"N",009	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,_DE61A120D									,"DE 61 A 120 DIAS"			,"N",009	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,_ACIMA120D									,"ACIMA DE 120 DIAS"		,"N",009	,0	,"@E 999,999,999"	,""		,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"SUM(AUX.E1_VALOR)			as VLR_TOTAL"	,"Valor Total"				,"N",009	,0	,"@E 999,999,999"	,""		,""	})

	aAdd(_aParambox,{1,"Data de Vencimento P/ Cแlculo de Dias Vencidos" 	,Ctod("")	,""	 ,"" ,"" ,"" ,075,.T.})
	aAdd(_aParambox,{3,"Mercado Interno ou Externo", Iif(Set(_SET_DELETED),1,2), {"Mercado Interno","Mercado Externo" }, 100, "",.F.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil)
		Return
	Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	cTIPMERCAD	:= If(_aRet[2] == 1, "Mercado Interno" , "Mercado Externo" )

	_cQuery += "	FROM ( "
	_cQuery += "			SELECT A.COD_FILIAL "						
	_cQuery += "				, A.NOM_FILIAL "						
	_cQuery += "				, A.COD_CLIENTE "						
	_cQuery += "				, TRIM(A.NOM_CLIENTE) AS NOM_CLIENTE "						
	_cQuery += "				, A.DESC_REDE "
	_cQuery += "				, A.TIP_MERCADO "				
	_cQuery += "				, A.DT_VENCIMENTO "					
	_cQuery += "				, A.OBSERVACAO "						
	_cQuery += "				, A.COD_VENDEDOR_RESP "				
	_cQuery += "				, A.NOM_VENDEDOR_RESP "				
	_cQuery += "				, A.COD_SEGMENTO      "					
	_cQuery += "				, A.DESC_SEGMENTO     "			
	_cQuery += "				, A.DESC_CANAL_VENDA  "
	_cQuery += "				, A.E1_VALOR "
	_cQuery += "				, TO_DATE('" + _aRet[1] + "' , 'YYYY/MM/DD') - A.DT_VENCIMENTO  AS QTD_DIAS_VENCIDO " 		// <========= SUBSTITUIR A DATA PELO MESMO VALOR DE PARAMETRO SELECIONADO NO COMBO

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_POSICAO_VENCIDOS" ) + " A " +  CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[1] ),     " DT_VENCIMENTO_FILTRO    < '"    + _aRet[1] + "' " ) // OBRIGATORIO SOMENTE UMA DATA (NรO ษ RANGE)
	_cQuery += U_WhereAnd( !empty(cTIPMERCAD ),   " TIP_MERCADO = '"        + cTIPMERCAD       + "' " )  
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " A.COD_FILIAL IN "       + _cCODFILIA              ) // OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += "  ) AUX
	_cQuery += " GROUP BY AUX.DESC_REDE "                       
//	_cQuery += " , AUX.TIP_MERCADO "          
						
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

