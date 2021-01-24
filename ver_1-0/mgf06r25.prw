#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R25	บAutor  ณ Geronimo Benedito Alves                                                               บData ณ  22/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Tํtulos em Aberto CP (M๓dulo 06-FIN)                บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R25()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""
 
	Aadd(_aDefinePl, "Contas เ Pagar - Tํtulos em Aberto"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Tํtulos em Aberto"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Tํtulos em Aberto"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Tํtulos em Aberto"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	Aadd(_aCampoQry, {"E2_FILIAL"	,"COD_FILIAL"			,"C๓d. Filial"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"			,"Nome Filial"			,"C",040,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"				,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIPO"					,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"COD_NATUREZA"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESC_NATUREZA"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_LOJA"		,"COD_LOJA"				,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_FORNECEDOR"		,""						,"C",018,0	,"@!"	,""	,"@!"})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PARCELA"	,"NUM_PARCELA"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_VENCIMENTO_REAL"	,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_NF"				,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALLIQ"	,"VALOR_PAGO"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_LIQUIDO"		,"Valor Liquido"		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ACRESC"	,"VLR_ACRESCIMO"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_DECRESC"	,"VLR_DECRESCIMO"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NUMBOR"	,"NUM_BORDERO"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PORTADO"	,"COD_PORTADOR"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_IDCNAB"	,"ID_CNAB"				,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_DATALIB"	,"DATA_LIBERACAO"		,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_CODBAR"	,"COD_BARRAS"			,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ZBCOFAV"	,"COD_BCO_FORNEC"		,"C๓d. Bco Fornec."		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ZAGEFAV"	,"COD_AG_FORNEC"		,"C๓d. AG Fornec."		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ZDVAFAV"	,"COD_DV_AG_FORNEC"		,"C๓d. DV AG Fornec."	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ZCTAFAV"	,"COD_CONTA_FORNEC"		,"C๓d. Conta Fornec."	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_ZDVCFAV"	,"COD_DV_CONTA_FORNEC"	,"C๓d. DV Conta Fornec.",""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_HISTOR"	,"HISTORICO"			,""						,""	,2020,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_XOBS"		,"OBS_AUDIT"			,""						,"C",2020,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"Desc_01"	    ,"TROCA_FAVORECIDO"		,"Troca Favorecido"	    ,"C",3   ,"",""		,""	,""	})//Rafael 30/07/19 

	aAdd(_aParambox,{1,"Data Vencimento Real Inicial"	,Ctod("")						,""		,""															,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Real Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Vencimento Real' )"	,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"C๓digo Fornecedor Inicial"		,Space(tamSx3("A2_COD")[1])		,"@!"	,""															,"SA2"	,""	,050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo Fornecedor Final"		,Space(tamSx3("A2_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'C๓d. Fornecedor' )"		,"SA2"	,""	,050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo Natureza Inicial"		,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,""															,"SED"	,""	,050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo Natureza Final"			,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'C๓d. Natureza' )"			,"SED"	,""	,050,.F.}) 
	aAdd(_aParambox,{3,"Titulos em Aberto ou em Border๔", Iif(Set(_SET_DELETED),1,2), {'Titulos em Aberto','Titulos com Bordero' }, 100, "",.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cTIPTITUL	:= If(_aRet[7] == 1, 'Titulos em Aberto' , 'Titulos com Bordero' )
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_TITULOS_ABERTO"  )				+ CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN " 			+ _cCODFILIA 							 )
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " VENCIMENTO_REAL_FILTRO BETWEEN '"	+ _aRet[1]   + "' AND '" + _aRet[2] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " COD_FORNECEDOR BETWEEN '" 			+ _aRet[3]   + "' AND '" + _aRet[4] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " COD_NATUREZA BETWEEN '"  			+ _aRet[5]   + "' AND '" + _aRet[6] + "' " )
	_cQuery += "  AND  FILTRA_TITULOS = '" + _cTIPTITUL + "' "
																				// 		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

