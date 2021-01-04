#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF78R03
Autor...............: Bruno Tamanaka
Data................: 20/03/2019
Descricao / Objetivo: Relatorio Trechos de NF - 78 Gestao de Frete e Embarque. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Trechos de NF.
=====================================================================================
*/

User Function MGF78R03()
	
	Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Trechos de NF"				)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Relatorio Trechos de NF"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relatorio Trechos de NF"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relatorio Trechos de NF"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//				   01				 	 	 02						 03						 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "COD_FILIAL"				,"COD_FILIAL"			,"Filial"					,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_EMISSOR_NF"		,"CNPJ_EMISSOR_NF"		,"CNPJ Emissor NF"			,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_EMISSOR_NF"			,"NOM_EMISSOR_NF"		,"Nome Emissor NF"			,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NUM_DOCUMENTO"			,"NUM_DOCUMENTO"		,"Numero Documento"			,"C",016,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SER_DOCUMENTO"			,"SER_DOCUMENTO"		,"Serie Documento"			,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DT_EMISSAO_DOC_CARGA"	,"DT_EMISSAO_DOC_CARGA"	,"Data Emissao Doc Carga"	,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "PESO_REAL_TOTAL"		,"PESO_REAL_TOTAL"		,"Peso Real Total"			,"N",013,5	,""	,""	,""	})																																															  
	Aadd(_aCampoQry, { "PESO_CUBADO_TOTAL"		,"PESO_CUBADO_TOTAL"	,"Peso Qtd/Alt Total"		,"N",013,5	,""	,""	,""	})
	Aadd(_aCampoQry, { "DES_ORIGEM"				,"DES_ORIGEM"			,"Descricao Origem"			,"C",010,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SITUACAO_DOC_CARGA"		,"SITUACAO_DOC_CARGA"	,"Situa��o Doc Carga"		,"C",010,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NUM_ROMANEIO"			,"NUM_ROMANEIO"			,"Numero Romaneio"			,"C",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_REMETENTE"			,"CNPJ_REMETENTE"		,"CNPJ Remetente"			,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_REMETENTE"			,"NOM_REMETENTE"		,"Nome Remetente"			,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_DESTINATARIO"		,"CNPJ_DESTINATARIO"	,"CNPJ Destinatario"		,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_DESTINATARIO"		,"NOM_DESTINATARIO"		,"Nome Destinatario"		,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TIPO_FRETE"				,"TIPO_FRETE"			,"Tipo Frete"				,"C",020,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CHAVE_NF"				,"CHAVE_NF"				,"Chave NF"					,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_CIDADE_DESTINO_NF"	,"COD_CIDADE_DESTINO_NF","Cod Cidade Destino NF"	,"C",007,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_CIDADE_DESTINO_NF"	,"NOM_CIDADE_DESTINO_NF","Nome Cidade Destido NF"	,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "UF_DESTINO_NF"			,"UF_DESTINO_NF"		,"UF Destino NF"			,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SEQ_TRECHO"				,"SEQ_TRECHO"			,"Seq Trecho"				,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_TRANSPORTADORA"		,"COD_TRANSPORTADORA"	,"Cod Transportadora"		,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_TRANSPORTADORA"		,"NOM_TRANSPORTADORA"	,"Nome Transportadora"		,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_TIPO_VEICULO"		,"COD_TIPO_VEICULO"		,"Cod Tipo Ve�culo"			,"C",010,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "TRECHO_A_PAGAR"			,"TRECHO_A_PAGAR"		,"Trecho a Pagar"			,"C",003,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_CIDADE_ORIGEM"		,"COD_CIDADE_ORIGEM"	,"Cod Cidade Origem"		,"C",007,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_CIDADE_ORIGEM"		,"NOM_CIDADE_ORIGEM"	,"Nome Cidade Origem"		,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "UF_ORIGEM"				,"UF_ORIGEM"			,"UF Origem"				,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_CIDADE_DESTINO"		,"COD_CIDADE_DESTINO"	,"Cod Cidade Destino"		,"C",007,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOM_CIDADE_DESTINO"		,"NOM_CIDADE_DESTINO"	,"Nome Cidade Destino"		,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "UF_DESTINO"				,"UF_DESTINO as UF2"	,"UF Destino"				,"C",002,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "ORDEM_SEP"				,"ORDEM_SEP"			,"Ordem SEP"				,"C",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "KM_TRECHO_2"			,"KM_TRECHO_2"			,"KM Trecho 2"				,"N",009,2	,""	,""	,""	})
	
	
	aAdd(_aParambox,{1,"Emissao Doc Carga De"	,Ctod("")						,""	,""													,""		,"",050,.F.})	//03
	aAdd(_aParambox,{1,"Emissao Doc Carga Ate"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.F.})	//04
	aAdd(_aParambox,{1,"Romaneio De"			,Space(tamSx3("GW1_NRROM")[1])	,""	,""													,""		,"",050,.F.})	//05
	aAdd(_aParambox,{1,"Romaneio Ate"			,Space(tamSx3("GW1_NRROM")[1])	,""	,""													,""		,"",050,.F.})	//06
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	//---- S  I  T  U  A  C  A  O		D  O  C  U  M  E  N  T  O		C  A  R  G  A
	cQryStatus	:= "SELECT X5_TABELA, X5_CHAVE, X5_DESCRI "
	cQryStatus	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")) + " TMPSX5 " 
	cQryStatus	+= "  WHERE TMPSX5.X5_TABELA	= 'TB' "	//Criada a tabela gen�rica TB na SX5.
	cQryStatus	+= "  AND	TMPSX5.X5_CHAVE >= '00' "
	cQryStatus	+= "  AND	TMPSX5.X5_CHAVE <= '06' " 
	cQryStatus	+= "  AND	TMPSX5.D_E_L_E_T_  =  ' ' " 
	aCpoStatus	:=	{	{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI"), TamSx3("X5_DESCRI")[1] }	} 
	cTitStatus	:= "Marque Situa��es Possiveis a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o segundo campo: X5_DESCRI

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	aStatus	:= U_MarkGene(cQryStatus, aCpoStatus, cTitStatus, nPosRetorn, @_lCancProg )
	If _lCancProg
		Return
	Endif 
	For _nI := 1 to len(aStatus)
		aStatus[_ni] := Alltrim(aStatus[_ni]) 
	Next
	_cStatus	:= U_Array_In( aStatus )
	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_LOGIST_TRECHOS_NF")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ), " COD_FILIAL IN "                   	 	+ _cCODFILIA                           	 )
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " DT_EMISSAO_DOC_CARGA_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " NUM_ROMANEIO BETWEEN '"  				+ _aRet[3] + "' AND '" + _aRet[4] + "' " )
	_cQuery += U_WhereAnd(!empty(_cStatus )	 , " STATUS IN "                   	   	 	+ _cStatus                             	 )	
	
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})



Return