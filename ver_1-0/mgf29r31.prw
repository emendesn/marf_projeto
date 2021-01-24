#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF29R31
Autor...............: Bruno Tamanaka
Data................: 15/03/2019
Descrição / Objetivo: Relatório Courrier Painel módulo 29 - Exportação. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: Marfrig
Obs.................: Relatório Courrier Painel BI.
=====================================================================================
*/

User Function MGF29R31()
	
	Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatório Courrier Painel"			)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Courrier Painel"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Courrier Painel"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Courrier Painel"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_nInterval	:= 3650											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado    
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//				   01				 	 02							 	 03						 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "NUM_EXP"			,"NUM_EXP"						,"Número da Exportação"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "ANO_EXP"			,"ANO_EXP"						,"Ano da Exportação"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "SUBEXP"				,"SUBEXP"						,"Sub Exp"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_TRADING"		,"NOME_TRADING"					,"Nome Trading"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_BUYER"			,"NOME_BUYER"					,"Nome Buyer"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_TIPO_PAGAMENTO"	,"COD_TIPO_PAGAMENTO"			,"Tipo Pagamento"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_PAGAMENTO"		,"TIPO_PAGAMENTO"				,"Desc Tipo Pagamento"		,""	,""	,""	,""	,""	,""	})																																															  
	Aadd(_aCampoQry, { "DOX"				,"DOX"							,"Dox"						,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "SALES_TERMS"		,"SALES_TERMS"					,"Sales Terms"				,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "PORTO_DESTINO"		,"PORTO_DESTINO"				,"Porto Destino"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "PAIS_PORTO_DESTINO"	,"PAIS_PORTO_DESTINO"			,"País Porto Destino"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_BL"			,"DATA_BL"						,"Data BL"					,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "MES_BL"				,"MES_BL"						,"Mês BL"					,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_BL_TRANSPORTE"	,"DATA_BL_TRANSPORTE"			,"Data BL Transporte"		,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "MES_BL_TRANSPORTE"	,"MES_BL_TRANSPORTE"			,"Mês BL Transporte"		,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_ENTREGA"		,"DATA_ENTREGA"					,"Data Entrega"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TRANSIT_TIME"		,"TRANSIT_TIME"					,"Transit Time"				,"N",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_ETA_DESTINO"	,"DATA_ETA_DESTINO"				,"Data ETA Destino"			,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DIAS_VENCER"		,"DIAS_VENCER"					,"Dias a Vencer"			,"N",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "STATUS"				,"STATUS"						,"Status"					,"C",035,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_TRANSPORTE"	,"TIPO_TRANSPORTE"				,"Tipo de Transporte"		,"C",035,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "FAMILA_PRODUTO"		,"FAMILA_PRODUTO"				,"Família Produto"			,""	,""	,""	,""	,""	,""	})
	Aadd(_aCampoQry, { "ADMINISTRADOR"		,"ADMINISTRADOR"				,"Administrador"			,""	,""	,""	,""	,""	,""	})
																																							
	aAdd(_aParambox,{3,"Exportadora" 			,iif(Set(_SET_DELETED),1,2)		, {'MARFRIG','PAMPEANO','Ambos'}						,100,"",.T.})			//01
	aAdd(_aParambox,{1,"Administrador"			,Space(240)						,""	,""													,""		,"",100,.F.})	//02
	aAdd(_aParambox,{1,"Data BL De"				,Ctod("")						,""	,""													,""		,"",050,.F.})	//03
	aAdd(_aParambox,{1,"Data BL Ate"			,Ctod("")						,""	,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""		,"",050,.F.})	//04
	aAdd(_aParambox,{1,"Data BL Transp De"		,Ctod("")						,""	,""													,""		,"",050,.F.})	//05
	aAdd(_aParambox,{1,"Data BL Transp Ate"		,Ctod("")						,""	,"U_VLDTINIF(MV_PAR05, MV_PAR06, _nInterval)"		,""		,"",050,.F.})	//06
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	_cExport	:= "MARFRIG,PAMPEANO"
	If _aRet[1] <> 3	//3 = Ambos
		_cExport	:= If(_aRet[1] == 1, "MARFRIG" , "PAMPEANO" )
	Endif

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_EX_COURRIER_PAINEL")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_aRet[1]),    " FILTRO_EXP  IN '"    			  	   + _cExport + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " ADMINISTRADOR LIKE '%"                + _aRet[2] + 					  "%' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " DATA_BL_FILTRO BETWEEN '"             + _aRet[3] + "' AND '" + _aRet[4] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[6]),    " DATA_BL_TRASNPORTE_FILTRO BETWEEN '"  + _aRet[5] + "' AND '" + _aRet[6] + "' " )
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})



Return