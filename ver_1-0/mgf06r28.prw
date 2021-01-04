#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF06R28
Autor...............: Bruno Tamanaka
Data................: 18/03/2019
Descricao / Objetivo: Relatorio Posicao Titulos ME - 06 Financeiro. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Posicao Titulos ME.
=====================================================================================
*/

User Function MGF06R28()
	
	Local _cStatus, _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Posicao Titulos ME"			)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Posicao Titulos ME"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Posicao Titulos ME"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Posicao Titulos ME"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//				   01				 	 02							 	 03						 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "NUM_EXP"			,"NUM_EXP"						,"Numero da Exportacao"		,"C",020,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "ANO_EXP"			,"ANO_EXP"						,"Ano da Exportacao"		,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SUBEXP"				,"SUBEXP"						,"Sub Exp"					,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PEDIDO_EXPORTACAO"	,"PEDIDO_EXPORTACAO"			,"Pedido Exportacao"    	,"C",020,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_BUYER"			,"COD_BUYER"					,"Codigo Buyer"				,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_BUYER"			,"NOME_BUYER"					,"Nome Buyer"				,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "MOEDA"				,"MOEDA"						,"Moeda"					,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SALDO_RECEBER"		,"SALDO_RECEBER"				,"Saldo Receber"			,"N",015,2	,""	,""	,""	})
	Aadd(_aCampoQry, { "ADIANTAMENTO"		,"ADIANTAMENTO"					,"Adiantamento"				,"N",015,2	,""	,""	,""	})
	Aadd(_aCampoQry, { "COMPLEMENTO"		,"COMPLEMENTO"					,"Complemento"				,"N",015,2	,""	,""	,""	})
	Aadd(_aCampoQry, { "EMISSAO"			,"EMISSAO"						,"Emissao"					,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DT_VENCTO"			,"DT_VENCTO"					,"Data de Vencimento"		,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_ETA_DESTINO"	,"DATA_ETA_DESTINO"				,"Data Eta Destino"			,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DIAS_VENCER"		,"DIAS_VENCER"					,"Dias Vencer"				,"N",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "STATUS"				,"STATUS"						,"Status"					,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PAIS_PORTO_DESTINO"	,"PAIS_PORTO_DESTINO"			,"Pais Porto Dest"			,"C",025,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_PRODUTO"		,"TIPO_PRODUTO"					,"Tipo Produto"				,"C",045,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_PAGAMENTO"		,"TIPO_PAGAMENTO"				,"Tipo Pagamento"			,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "FAMILA_PRODUTO"		,"FAMILA_PRODUTO"				,"Familia Produto"			,"C",045,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NEGOCIO"			,"NEGOCIO"						,"Negocio"					,"C",045,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SITUACAO"			,"SITUACAO"						,"Situacao"					,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PORTO_DESTINO"		,"PORTO_DESTINO"				,"Porto Destino"			,"C",020,0	,""	,""	,""	})
																																							
	aAdd(_aParambox,{3,"Exportadora" 			,iif(Set(_SET_DELETED),1,2)		, {'Todas','MARFRIG','PAMPEANO','WESTON'}						,100,"",.T.})	//01
	aAdd(_aParambox,{1,"Buyer De"				,Space(tamSx3("A1_COD")[1])		,""	,""													,""		,"",100,.F.})	//02
	aAdd(_aParambox,{1,"Buyer Ate"				,Space(tamSx3("A1_COD")[1])		,""	,""													,""		,"",100,.F.})	//03
	aAdd(_aParambox,{1,"Tipo Produto"			,Space(tamSx3("YC_NOME")[1])	,""	,""													,""		,"",050,.F.})	//04
	aAdd(_aParambox,{1,"Negocio"				,Space(tamSx3("EEG_NOME")[1])	,""	,""													,""		,"",050,.F.})	//05
	aAdd(_aParambox,{3,"Status"		 			,iif(Set(_SET_DELETED),1,2)		, {'Todos','Vencer','Vencidos de 1 a 30 dias','Vencidos de 31 a 60 dias','Vencidos de 61 a 120 dias','Vencidos acima de 121 dias'},100,"",.T.})	//06
	aAdd(_aParambox,{1,"Porto Destino"			,Space(tamSx3("YR_CID_DES")[1])	,""	,""													,""		,"",050,.F.})	//07
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	_cExport	:= "'MARFRIG','PAMPEANO','WESTON'"
	If _aRet[1] <> 1	//1 = Todas
		_cExport	:= If(_aRet[1] == 2, "'MARFRIG'"  	, _cExport )
		_cExport	:= If(_aRet[1] == 3, "'PAMPEANO'" 	, _cExport )
		_cExport	:= If(_aRet[1] == 4, "'WESTON'" 	, _cExport )
	Endif
	
	_cStatus	:= " 'VENCER','VENCIDOS DE 1 A 30 DIAS','VENCIDOS DE 31 A 60 DIAS','VENCIDOS DE 61 A 120 DIAS','VENCIDOS ACIMA DE 121 DIAS' "
	If _aRet[6] <> 1
		_cStatus	:= If(_aRet[6] == 2, " 'VENCER' " 						, _cStatus )
		_cStatus	:= If(_aRet[6] == 3, " 'VENCIDOS DE 1 A 30 DIAS' " 		, _cStatus )
		_cStatus	:= If(_aRet[6] == 4, " 'VENCIDOS DE 31 A 60 DIAS' " 	, _cStatus )
		_cStatus	:= If(_aRet[6] == 5, " 'VENCIDOS DE 61 A 120 DIAS' " 	, _cStatus )
		_cStatus	:= If(_aRet[6] == 6, " 'VENCIDOS ACIMA DE 121 DIAS' " 	, _cStatus )	
	Endif

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_CR_POSICAO_TITULOS_ME")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_aRet[1]),    " FILTRO_EXP  IN ("    			  + _cExport + ")  " +CRLF )						
	_cQuery += U_WhereAnd(!empty(_aRet[3]),    " COD_BUYER BETWEEN '"             + _aRet[2] + "' AND '" + _aRet[3] + "' " 	+CRLF ) 	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " TIPO_PRODUTO LIKE '%"            + _aRet[4] + "%' " 	+CRLF )	 
	_cQuery += U_WhereAnd(!empty(_aRet[5]),    " NEGOCIO LIKE '%"                 + _aRet[5] + "%' " 	+CRLF ) 
	_cQuery += U_WhereAnd(!empty(_aRet[6]),    " UPPER(STATUS)  IN ("		  	  + _cStatus + ")  " 	+CRLF )	 
	_cQuery += U_WhereAnd(!empty(_aRet[7]),    " PORTO_DESTINO LIKE '%"           + _aRet[7] + "%' " 	+CRLF )
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})



Return