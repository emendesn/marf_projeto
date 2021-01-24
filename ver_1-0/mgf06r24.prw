#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R24	บAutor  ณ Geronimo Benedito Alves                                                                   บData ณ  03/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Seguro por Rateio (M๓dulo 06-FIN)                   บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R24()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""
 
 
	Aadd(_aDefinePl, "Contas เ Pagar - Seguro por Rateio"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Seguro por Rateio"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Seguro por Rateio"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Seguro por Rateio"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02						 03								 04	 05	 06	07		08	09	
	Aadd(_aCampoQry, {"E2_FILIAL"	,"COD_EMPRESA_ORIGEM"	,"C๓digo da Empresa Origem"		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"DESC_EMPRESA_ORIGEM"	,"Descri็ใo da Empresa Origem"	,"C",040,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"CH_ZFILDES"	,"COD_EMPRESA_DESTINO"	,"C๓digo da Empresa Destino"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"DESC_EMPRESA_DESTINO"	,"Descri็ใo da Empresa Destino"	,"C",040,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"			,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR"		,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_LOJA"		,"COD_LOJA"				,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_FORNECEDOR"		,""								,"C",018,0	,"@!"	,""	,"@!"})     
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR"		,""								,""	,""	,""	,""		,""	,""	}) 
	Aadd(_aCampoQry, {"ED_CODIGO"	,"COD_NATUREZA"			,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESCR_NATUREZA"		,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_VALBRUT"	,"VALOR_NF"				,"Valor da NF"					,""	,""	,""	,""		,""	,""	}) 
	Aadd(_aCampoQry, {"E2_SALDO"	,"VALOR_LIQUIDO_PAGAR"	,"Valor Liquido a Pagar"		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALLIQ"	,"VALOR_PAGO"			,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_DESCONT"	,"DESCONTO"				,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"			,""								,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO"		,""								,""	,""	,""	,""		,""	,""	}) 
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_PAGAMENTO"			,"Data de Pagamento"			,""	,""	,""	,""		,""	,""	})   

	aAdd(_aParambox,{1,"Data Emissใo Inicial"		,Ctod("")					,""		,""															,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Data Emissใo Final"			,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissใo' )"			,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento  Inicial"	,Ctod("")					,""		,""															,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento  Final"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Vencimento Real' )"	,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento  Inicial"	,Ctod("")					,""		,""															,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento  Final"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Pagamento Real' )"	,""		,, 050,.F.})
	aAdd(_aParambox,{1,"Cnpj Fornecedor "			,Space(tamSx3("A2_CGC")[1])	,"@!"	,""															,"SAX"	,, 075,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_SEGURO_POR_RATEIO"  )       + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_EMPRESA_ORIGEM IN "                + _cCODFILIA )
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_EMISSAO_FILTRO BETWEEN '"    + _aRet[1] + "' AND '" + _aRet[2] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " DT_VENCIMENTO_FILTRO BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " DT_PAGAMENTO_FILTRO BETWEEN '"  + _aRet[5] + "' AND '" + _aRet[6] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[7]),       " CNPJ_FORNECEDOR_FILTRO LIKE '%" + _aRet[7] + "%' " )
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

