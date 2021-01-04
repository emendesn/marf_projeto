#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF05R13
Autor...............: Bruno Tamanaka
Data................: 27/05/2019
Descricao / Objetivo: Relatorio Faturamento Lista de Produto. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Lista de Produto.
=====================================================================================
*/

User Function MGF05R13()
	
	//Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Lista de Produto"			)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Lista de Produto"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Lista de Produto"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Lista de Produto"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	//				   01				 	 	 02							 03						 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "COD_PRODUTO"			,"COD_PRODUTO"				,"Cod. Produto"			,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_PRODUTO_INGLES"	,"DESC_PRODUTO_INGLES"		,"Product Description"	,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_PRODUTO"			,"DESC_PRODUTO"				,"Descricao do Produto"	,"C",076,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "FAMILIA"				,"FAMILIA"					,"Familia"				,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "ORIGEM"					,"ORIGEM"					,"Origem"				,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NEGOCIO"				,"NEGOCIO"					,"Negocio"				,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SUBGRUPO"				,"SUBGRUPO"					,"Subgrupo"				,"C",030,0	,""	,""	,""	})																																														  
	Aadd(_aCampoQry, { "GRUPO"					,"GRUPO"					,"Grupo"				,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "MARCA"					,"MARCA"					,"Marca"				,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CONSERVACAO"			,"CONSERVACAO"				,"Conservacao"			,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "HABILITACAO"			,"HABILITACAO"				,"Habilitacao"			,"C",050,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NCM"					,"NCM"						,"NCM"					,"C",010,0	,""	,""	,""	}) //Rafael 30/07/19
																																							
	aAdd(_aParambox,{1,"Produto De "	,Space(tamSx3("B1_COD")[1])	,""		,""												,"SB1"	,,050,.F.}) //01
	aAdd(_aParambox,{1,"Produto Ate "	,Space(tamSx3("B1_COD")[1])	,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Produto')"	,"SB1"	,,050,.F.}) //02
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FAT_LISTPRODUTOS")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " COD_PRODUTO BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	
			
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})


Return