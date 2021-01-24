#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF09R03
Autor...............: Bruno Tamanaka
Data................: 20/03/2019
Descri��o / Objetivo: Relat�rio Comprova��o Exporta��o - 09 Fiscal. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: Marfrig
Obs.................: Relat�rio Comprova��o Exporta��o.
=====================================================================================
*/

User Function MGF09R03()
	
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Comprova��o Exporta��o"		)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Comprova��o Exporta��o"		)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Comprova��o Exporta��o"}	)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Comprova��o Exporta��o"}	)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_nInterval	:= 3650											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//				   01				 	 02					 03					 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "FILIAL"				,"FILIAL"			,"Filial"				,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "EMBARQUE"			,"EMBARQUE"			,"Embarque"				,"C",020,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NF"					,"NF"				,"Nota Fiscal"			,"C",009,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SERIE"				,"SERIE"			,"S�rie NF"				,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_NF"			,"DATA_NF"			,"Data NF"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_FISCAL"			,"COD_FISCAL"		,"C�digo Fiscal"		,"C",005,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CHAVE_NF"			,"CHAVE_NF"			,"Chave NF"				,"C",044,0	,""	,""	,""	})																																  
	Aadd(_aCampoQry, { "COD_ITEM"			,"COD_ITEM"			,"C�digo Item"			,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "QTDE_EMBAR"			,"QTDE_EMBAR"		,"Quantidade Embarque"	,"N",014,2	,"@E 99,999,999,999.99"	    ,""	,""	})
	Aadd(_aCampoQry, { "PRECO_UNIT"			,"PRECO_UNIT"		,"Pre�o Unit�rio"		,"N",014,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, { "PRECO_TOTAL"		,"PRECO_TOTAL"		,"Pre�o Total"			,"N",014,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, { "RE"					,"RE"				,"RE"					,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_RE"			,"DATA_RE"			,"Data RE"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "AVERB_SD"			,"AVERB_SD"			,"Averb SD"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NUM_DUE"			,"NUM_DUE"			,"Num Due"				,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_DUE"			,"DATA_DUE"			,"Data Due"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CHAVE_DUE"			,"CHAVE_DUE"		,"Chave Due"			,"C",030,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NRO_RUC"			,"NRO_RUC"			,"NRO RUC"				,"C",035,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NRO_CONHECIMENTO"	,"NRO_CONHECIMENTO"	,"NRO Conhecimento"		,"C",020,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_CONHECIMENTO"	,"DATA_CONHECIMENTO","Data Conhecimento"	,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_EMBAR"			,"DATA_EMBAR"		,"Data Embarque"		,"D",008,0	,""	,""	,""	})
	
		
	aAdd(_aParambox,{1,"Data NF De"		,Ctod("")			,""	,""													,""		,"",050,.T.})	//03
	aAdd(_aParambox,{1,"Data NF Ate"	,Ctod("")			,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})	//04
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	
	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FISCAL_COMPROVACAO_EXPORT")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ), " COD_FILIAL IN "                + _cCODFILIA                           )	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " DATA_NF_FILTRO BETWEEN '"      + _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})



Return