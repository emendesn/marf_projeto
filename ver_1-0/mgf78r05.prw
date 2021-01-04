#Include "totvs.ch" 

/*
=====================================================================================
Programa............: MGF78R05
Autor...............: Bruno Tamanaka
Data................: 28/05/2019
Descricao / Objetivo: Relatorio Logistica - Devolucao Cross Docking. 
Doc. Origem.........: 
Solicitante.........: Priscilla Sombini
Uso.................: 
Obs.................: Relatorio Devolucao Cross Docking.
=====================================================================================
*/

User Function MGF78R05()
	
	//Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Relatorio Devolucao Cross Docking"		)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Devolucao Cross Docking"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Devolucao Cross Docking"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Devolucao Cross Docking"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	//				   01				 	 	 02							 				 03							 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "EMPRESA"				,"EMPRESA"									,"Empresa"					,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NM_EMPRESA"				,"NM_EMPRESA"								,"Nome Empresa"				,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "N_NF"					,"N_NF"										,"Numero da NF"				,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SERIE_NF"				,"SERIE_NF"									,"Serie da NF"				,"C",004,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "COD_CLIENTE"			,"COD_CLIENTE"								,"C�d. Cliente"				,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "LJ_CLIENTE"				,"LJ_CLIENTE"								,"Loja Cliente"				,"C",004,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_CLIENTE"			,"CNPJ_CLIENTE"								,"CNPJ Clliente"			,"C",014,0	,""	,""	,""	})																																														  
	Aadd(_aCampoQry, { "NM_CLIENTE"				,"NM_CLIENTE"								,"Nome Cliente"				,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "N_RAMI"					,"N_RAMI"									,"Numero da RAMI"			,"C",006,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DT_EMISSAO"				,"DT_EMISSAO"								,"Data Emissao"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DT_DIGITACAO"			,"DT_DIGITACAO"								,"Data Digitacao"			,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DT_LANCAMENTO"			,"DT_LANCAMENTO"							,"Data de Lancamento"		,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CIDADE_ORIGEM_2_TRECHO"	,"CIDADE_ORIGEM_2_TRECHO"					,"Cidade Origem 2 Trecho"	,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "N_NF_ORIGEM"			,"N_NF_ORIGEM"								,"Numero NF Origem"			,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SERIE_NF_ORIGEM"		,"SERIE_NF_ORIGEM"							,"Serie NF Origem"			,"C",004,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "N_PEDIDO_ORIGEM"		,"N_PEDIDO_ORIGEM"							,"N�m. Pedido Origem"		,"C",015,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "QTDE_NF_ORIGEM"			,"QTDE_NF_ORIGEM"							,"Qtde. NF Origem"			,"N",017,4	,"@E 999,999,999,999.9999"	,""	,""	})
	Aadd(_aCampoQry, { "COD_TRASPORTADOR"		,"COD_TRASPORTADOR"							,"C�d. Transportador"		,"C",015,0	,""	,""	,""	})																																												  
	Aadd(_aCampoQry, { "NM_TRANSPORTADOR"		,"NM_TRANSPORTADOR"							,"Nome Transportador"		,"C",040,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "N_OE"					,"N_OE"										,"Numero OE"				,"C",008,0	,""	,""	,""	})
	//Aadd(_aCampoQry, { "F1_EMISSAO"				,"F1_EMISSAO    AS DT_EMISSAO_FILTRO"		,"Data Emissao Filtro"		,"D",008,0	,""	,""	,""	})
	//Aadd(_aCampoQry, { "F1_DTLANC"				,"F1_DTLANC		AS DT_LANCAMENTO_FILTRO"	,"Data Lancamento Filtro"	,"D",008,0	,""	,""	,""	})																																													  
	
																																							
	aAdd(_aParambox,{1,"Data Digitacao Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.F.})			// 01
	aAdd(_aParambox,{1,"Data Digitacao Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Digitacao')"	,""		,""	,050,.F.})			// 02
	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")						,""		,""													,""		,""	,050,.F.})			// 03
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Emissao')"	,""		,""	,050,.F.})			// 04
	aAdd(_aParambox,{1,"RAMI De "				,Space(tamSx3("ZAV_CODIGO")[1])	,""		,""													,""		,,050,.F.}) //05
	aAdd(_aParambox,{1,"RAMI Ate "				,Space(tamSx3("ZAV_CODIGO")[1])	,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'RAMI')"			,""		,,050,.F.}) //06
	aAdd(_aParambox,{1,"Nota Fiscal De "		,Space(tamSx3("F2_DOC")[1])		,""		,""													,""		,,050,.F.}) //07
	aAdd(_aParambox,{1,"Nota Fiscal Ate "		,Space(tamSx3("F2_DOC")[1])		,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Nota Fiscal')"	,""		,,050,.F.}) //08
	aAdd(_aParambox,{1,"Numero OE De "			,Space(tamSx3("F2_DOC")[1])		,""		,""													,""		,,050,.F.}) //09
	aAdd(_aParambox,{1,"Numero OE Ate "			,Space(tamSx3("F2_DOC")[1])		,""		,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Grp. Produto')"	,""		,,050,.F.}) //10
	
		
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	
	//===		S E L E C I O N A		C I D A D E			O R I G E M 
	cQryCidade	:= "SELECT '" +SPACE(TamSx3("GU7_NMCID")[1]) + "' as GU7_NMCID FROM DUAL UNION ALL "
	cQryCidade	+= "SELECT DISTINCT GU7_NMCID "															
	cQryCidade  += "  FROM " + RetSqlName("GU7")  + " TMPCID " 			
	cQryCidade	+= "  WHERE TMPCID.D_E_L_E_T_ = ' ' " 													
	cQryCidade	+= "  ORDER BY GU7_NMCID  "														
	aCpoCidade	:=	{	{ "GU7_NMCID"	,U_X3Titulo("GU7_NMCID")	,TamSx3("GU7_NMCID")[1]	}	}
	
	cTitCidade	:= "Selecao Cidade Origem: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: GU7_NMCID
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cCidade	:= U_Array_In( U_MarkGene(cQryCidade, aCpoCidade, cTitCidade, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif
	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_LOGIST_DEVCROSS")   +CRLF 
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),    " EMPRESA IN "               		+ _cCODFILIA                ) 
	_cQuery += U_WhereAnd(!empty(_aRet[2]),    " DT_DIGITACAO_FILTRO BETWEEN '"  	+ _aRet[1] + "' AND '" + _aRet[2] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[4]),    " DT_EMISSAO_FILTRO BETWEEN '"  		+ _aRet[3] + "' AND '" + _aRet[4] + "' " )	
	_cQuery += U_WhereAnd(!empty(_cCidade ),      " CIDADE_ORIGEM_2_TRECHO IN "   	+ _cCidade                	)
	_cQuery += U_WhereAnd(!empty(_aRet[6]),    " N_RAMI BETWEEN '"  				+ _aRet[5] + "' AND '" + _aRet[6] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[8]),    " N_NF BETWEEN '"  					+ _aRet[7] + "' AND '" + _aRet[8] + "' " )	
	_cQuery += U_WhereAnd(!empty(_aRet[10]),   " N_OE BETWEEN '"  					+ _aRet[9] + "' AND '" + _aRet[10] + "' " )	
	
			
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})


Return