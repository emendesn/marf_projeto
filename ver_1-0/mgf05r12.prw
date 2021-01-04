#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF05R12
Autor...............: Bruno Tamanaka
Data................: 19/03/2019
Descricao / Objetivo: Relatorio Palete - 05 Faturamento. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Palete.
=====================================================================================
*/

User Function MGF05R12()
	
	Local _nI
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Palete"						)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Relatorio Palete"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relatorio Palete"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relatorio Palete"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	//				   01				 	 	 02						 03						 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "COD_FILIAL"				,"COD_FILIAL"			,"Filial"					,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_FILIAL"			,"DESC_FILIAL"			,"Nome Filial"				,"C",050,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "STATUS"					,"STATUS"				,"Status"					,"C",035,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_PALLET"				,"COD_PALLET"			,"Codigo Palete"			,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "END_ENTREGA"			,"END_ENTREGA"			,"Endereco Entrega"			,"C",050,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_TRANSPORTADORA"		,"COD_TRANSPORTADORA"	,"Codigo Transportadora"	,"C",010,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_TRANSPORTADORA"	,"NOME_TRANSPORTADORA"	,"Nome Transportadora"		,"C",050,0	,""	,""	,""	})																																															  
	Aadd(_aCampoQry, { "COD_PRODUTO"			,"COD_PRODUTO"			,"Codigo Produto"			,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DESC_PRODUTO"			,"DESC_PRODUTO"			,"Descricao Produto"		,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PLACA_VEICULO"			,"PLACA_VEICULO"		,"Placa Ve�culo"			,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "MOTORISTA"				,"MOTORISTA"			,"Motorista"				,"C",050,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CPF_MOTORISTA"			,"CPF_MOTORISTA"		,"CPF Motorista"			,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "QAUNTIDADE"				,"QAUNTIDADE"			,"Quantidade"				,"N",009,5	,""	,""	,""	})
	Aadd(_aCampoQry, { "VALOR_UNITARIO"			,"VALOR_UNITARIO"		,"Valor Unitario"			,"N",014,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, { "VALOR_TOTAL"			,"VALOR_TOTAL"			,"Valor Total"				,"N",014,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, { "DATA_ENTREGA"			,"DATA_ENTREGA"			,"Data Entrega"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_RECEBIMENTO"		,"DATA_RECEBIMENTO"		,"Data Recebimento"			,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "VALIDADE_DIAS"			,"VALIDADE_DIAS"		,"Validade Dias"			,"N",012,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "VALE_BONUS"				,"VALE_BONUS"			,"Vale Bonus"				,"N",016,2	,""	,""	,""	})
	Aadd(_aCampoQry, { "QTDE_ENVIADA"			,"QTDE_ENVIADA"			,"Quantidade Enviada"		,"N",009,5	,""	,""	,""	})
	Aadd(_aCampoQry, { "QTDE_RECEBIDA"			,"QTDE_RECEBIDA"		,"Quantidade Recebida"		,"N",009,5	,""	,""	,""	})
	Aadd(_aCampoQry, { "Z01_MOTIVO"				,"Z01_MOTIVO"			,"Motivo"					,"C",010,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PREF_TITULO"			,"PREF_TITULO"			,"Prefixo Titulo"			,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NUM_TITULO"				,"NUM_TITULO"			,"Numero Titulo"			,"C",009,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_TITULO"			,"TIPO_TITULO"			,"Tipo Titulo"				,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NF_CLIENTE"				,"NF_CLIENTE"			,"NF do Cliente"			,"C",009,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NF_SERIE_CLIENTE"		,"NF_SERIE_CLIENTE"		,"Serie NF do Cliente"		,"C",006,0	,""	,""	,""	})
	
	
	aAdd(_aParambox,{1,"Data Entrega De"		,Ctod("")						,""	,""													,""		,"",050,.F.})	//03
	aAdd(_aParambox,{1,"Data Entrega Ate"		,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.F.})	//04
	aAdd(_aParambox,{1,"Data Recebimento De"	,Ctod("")						,""	,""													,""		,"",050,.F.})	//05
	aAdd(_aParambox,{1,"Data Recebimento Ate"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""		,"",050,.F.})	//06
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	//---- S  T  A  T  U  S
	cQryStatus	:= "SELECT X5_TABELA, X5_CHAVE, X5_DESCRI "
	cQryStatus	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")) + " TMPSX5 " 
	cQryStatus	+= "  WHERE TMPSX5.X5_TABELA	= 'TY' "	//Criada a tabela gen�rica TY na SX5.
	cQryStatus	+= "  AND	TMPSX5.D_E_L_E_T_  =  ' ' " 
	aCpoStatus	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	, TamSx3("X5_CHAVE")[1]  } , ;
	{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI"), TamSx3("X5_DESCRI")[1] }	} 
	cTitStatus	:= "Marque Situa��es Possiveis a serem listadas: "
	nPosRetorn	:= 2		// Quero que seja retornado o segundo campo: X5_DESCRI

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	aStatus	:= U_MarkGene(cQryStatus, aCpoStatus, cTitStatus, nPosRetorn, @_lCancProg )
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aStatus)
		aStatus[_nI] := Alltrim(aStatus[_nI]) 
	Next
	_cStatus	:= U_Array_In( aStatus )
	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FAT_PALETE")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ), " COD_FILIAL IN "                   	 + _cCODFILIA                           )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_cStatus )	 , " STATUS IN "                   	   	 + _cStatus                             )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " DATA_ENTREGA_FILTRO BETWEEN '"      + _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " DATA_RECEBIMENTO_FILTRO BETWEEN '"  + _aRet[3] + "' AND '" + _aRet[4] + "' " )
	
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})



Return