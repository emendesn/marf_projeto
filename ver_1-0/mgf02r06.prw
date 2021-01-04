#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF02R06
Autor...............: Bruno Tamanaka
Data................: 28/05/2019
Descricao / Objetivo: Relatorio Compras - Planejamento e Consumo. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Planejamento e Consumo.
=====================================================================================
*/

User Function MGF02R06()
	
	//Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Planejamento e Consumo"			)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Planejamento e Consumo"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Planejamento e Consumo"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Planejamento e Consumo"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 3650											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//				   01				 	 	 02							 03							 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "COD_FILIAL"				,"COD_FILIAL"				,"Cod. Filial"				,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_FILIAL"			,"NOME_FILIAL"				,"Nome Filial"				,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_PRODUTO"			,"COD_PRODUTO"				,"Codigo do Produto"		,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_PRODUTO"			,"DESC_PRODUTO"				,"Descricao do Produto"		,"C",076,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_TIPO_PRODUTO"		,"COD_TIPO_PRODUTO"			,"Cod. Tipo do Produto"		,"C",004,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_TIPO_PRODUTO"		,"DESC_TIPO_PRODUTO"		,"Desc. Tipo do Produto"	,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_GRUPO_PRODUTO"		,"COD_GRUPO_PRODUTO"		,"Cod. Grupo do Produto"	,"C",004,0	,""	,""	,""	})																																														  
	Aadd(_aCampoQry, { "DESC_GRUPO_PRODUTO"		,"DESC_GRUPO_PRODUTO"		,"Desc. Grupo do Produto"	,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "UNID_MEDIDA"			,"UNID_MEDIDA"				,"Unidade de Medida"		,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "QTD_ESTOQUE_ATUAL"		,"QTD_ESTOQUE_ATUAL"		,"Qtde. Estoque Atual"		,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "QTD_SC"					,"QTD_SC"					,"Qtde. Solicit. de Compra"	,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "QTD_PEDIDO"				,"QTD_PEDIDO"				,"Qtde. Pedido"				,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "QTD_ARECEBER"			,"QTD_ARECEBER"				,"Qtde. A Receber"			,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "QTD_TERCEIRO"			,"QTD_TERCEIRO"				,"Qtde. Em Terceiro"		,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	}) // Paulo Henrique - 02/10/2019
	Aadd(_aCampoQry, { "QTD_SALDO_TOTAL"		,"QTD_SALDO_TOTAL"			,"Qtde. Saldo Total"		,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "CUSTO_MEDIO"			,"CUSTO_MEDIO"				,"Custo M�dio"				,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "CONSUMO_ULT_3_MESES"	,"CONSUMO_ULT_3_MESES"		,"Consumo Ult. 3 Meses"		,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "CONSUMO_MES_ATUAL"		,"CONSUMO_MES_ATUAL"		,"Consumo M�s Atual"		,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "SUGESTAO_COMPRA"		,"SUGESTAO_COMPRA"			,"Sugestao Compra"			,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})																																													  
	
																																							
	aAdd(_aParambox,{1,"Produto De "			,Space(tamSx3("B1_COD")[1])		,""		,""													,"SB1"	,,050,.F.}) //01
	aAdd(_aParambox,{1,"Produto Ate "			,Space(tamSx3("B1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Produto')"		,"SB1"	,,050,.F.}) //02
	aAdd(_aParambox,{1,"Tipo do Produto De "	,Space(tamSx3("B1_TIPO")[1])	,""		,""													,""		,,050,.F.}) //03
	aAdd(_aParambox,{1,"Tipo do Produto Ate "	,Space(tamSx3("B1_TIPO")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Tipo Produto')"	,""		,,050,.F.}) //04
	aAdd(_aParambox,{1,"Grupo do Produto De "	,Space(tamSx3("BM_GRUPO")[1])	,""		,""													,""		,,050,.F.}) //05
	aAdd(_aParambox,{1,"Grupo do Produto Ate "	,Space(tamSx3("BM_GRUPO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Grp. Produto')"	,""		,,050,.F.}) //06
	
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_COMPRAS_PLANEJAMENTOCONSUMO")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),    " COD_FILIAL IN "               + _cCODFILIA                ) 
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " COD_PRODUTO BETWEEN '"  		+ _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " COD_TIPO_PRODUTO BETWEEN '"  	+ _aRet[3] + "' AND '" + _aRet[4] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[6]),    " COD_GRUPO_PRODUTO BETWEEN '"  	+ _aRet[5] + "' AND '" + _aRet[6] + "' " )	
	
			
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})


Return