#include "totvs.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF05R14	บAutor  ณ Geronimo Benedito Alves                                                               บData ณ  22/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Tํtulos em Aberto CP (M๓dulo 06-FIN)                บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF05R14()

	Private _aRet	    := {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl  := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil	:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento Analise de pedidos(1)"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Faturamento Analise pedidos(1)"		)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Faturamento Analise pedidos"}		)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Faturamento Analise pedidos"}		)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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

	Aadd(_aCampoQry, {"C5_FILIAL"	,"EMPRESA"				   ,"C๓d. Filial"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_NUM"		,"PEDIDO"				   ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_EMISSAO"   		   ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZTPOPER"	,"COD_TIPO_OPERACAO"	   ,""						,""	,""	,""	,""		,""	,""	}) // Paulo Henrique - MARFRIG - 30/10/2019 - RTASK0010342
	Aadd(_aCampoQry, {"X5_DESCRI"	,"TIPO_OPERACAO"	       ,""						,""	,""	,""	,""		,""	,""	}) // Paulo Henrique - MARFRIG - 30/10/2019 - RTASK0010342
	Aadd(_aCampoQry, {"C5_CLIENTE"	,"CLIENTE"                 ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_XCGCCPF"	,"CNPJ"                    ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZBLQRGA"	,"STATUS"                  ,"Status"	  		    ,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO"          ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"TABELA_PRECO","TABELA_PRECO"            ,"Tabela Preco"			,""	,""	,""	,""		,""	,""	}) // Paulo da Mata - 10/12/2019 - Altera็ใo de visibilidade do campo em questใo
//	Aadd(_aCampoQry, {"C5_FECENT"	,"DATA_ENTREGA"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZDTEMBA"	,"DATA_EMBARQUE"           ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR"         ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR"           ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_MUN"		,"CIDADE"                  ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_EST"		,"ESTADO"                  ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRODUTO"	,"COD_PRODUTO"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DESCRI"	,"DESCRICAO"               ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QUANT_SOLICITADA"        ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRCVEN"	,"PRECO_VENDA"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRUNIT"	,"PRECO_TABELA"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_VALOR"	,"VALOR"                   ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_DESCONT"	,"DESCONTO"                ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_EMISSAO"	,"DATA_FATURAMENTO"        ,""						,""	,""	,""	,""		,""	,""	})
//	Aadd(_aCampoQry, {"C6_DATFAT"	,"DATA_FATURAMENTO_FILTRO" ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_DOC"		,"N_NF"                    ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_SERIE"	,"N_SERIE"                 ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDENT"	,"QUANT_ATENDIDA"          ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_ZDTMIN"	,"DATA_MINIMA"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_ZDTMAX"	,"DATA_MAXIMA"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_TPFRETE"	,"TIPO_FRETE"              ,""						,"C",15	,0	,""		,""	,""	})
    Aadd(_aCampoQry, {"DESCRI_3"	,"STATUS_PEDIDO"           ,"Status Pedido"			,"C",12	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"DESCRI_1"	,"DIRETORIA"               ,"Diretoria"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"DESCRI_2"	,"TATICO"                  ,"Tatico"			    ,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZCODUSU"	,"COD_USUARIO"             ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZNOMUSU"	,"NOME_USUARIO"            ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"CJ_ZMESTRE"	,"NUM_ORCAMENTO"           ,""						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"CJ_EMISSAO"	,"EMISSAO_ORCAMENTO"       ,"Dt. Emissใo Or็amento"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_XOBSPED"	,"PEDIDO_OBSERVACAO"       ,""						,"C",2020,0	,""		,""	,""	})

	Aadd(_aCampoQry, {"DATA_BLOQUEIO"     ,"DATA_BLOQUEIO"        ,"Dt Bloqueio"	      ,"",,	,""		,""	,""	})
	Aadd(_aCampoQry, {"DESCRICAO_BLOQUEIO","DESCRICAO_BLOQUEIO"   ,"Bloqueio"	          ,"",,	,""		,""	,""	})
 	Aadd(_aCampoQry, {"STATUS_BLOQUEIO"   ,"STATUS_BLOQUEIO"      ,"Status Bloqueio"	  ,"",,	,""		,""	,""	})  // Paulo Henrique - MARFRIG - 30/10/2019 - RTASK0010342
	Aadd(_aCampoQry, {"TOTAL_DESCONTO"    ,"TOTAL_DESCONTO"       ,"Total Desconto"	      ,"N",17,2	,""		,""	,""	})
	
	Aadd(_aCampoQry, {"VLR_DESCONTO"      ,"PERC_DESC_FECHAMENTO" ,"% Desconto Contrato"  ,"N",15,2	,""		,""	,""	})
	Aadd(_aCampoQry, {"VLR_ACORDO"	      ,"PER_ACORDO_CONTRATO"  ,"% Acordo Contrato"    ,"N",15,2	,""		,""	,""	})
	Aadd(_aCampoQry, {"DESCRI_4"	      ,"DATA_APROVACAO"      ,"Data Aprova็ใo"	      ,"",	,	,""		,""	,""	})
	Aadd(_aCampoQry, {"DESCRI_5"	      ,"NOME_APROVADOR"      ,"Nome Aprovador"	      ,"C",40	,0	,""		,""	,""	})

//	aAdd(_aParambox,{1,"Data Entrega Inicial"	  ,Ctod("")						,""		,""														,""		,""	,050,.F.})
//	aAdd(_aParambox,{1,"Data Entrega Final"		  ,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrega' )"		,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Inicial"	  ,Ctod("")						,""		,""														,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Embarque Final"	  ,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Embarque' )"		,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inical"	  ,Ctod("")						,""		,""														,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"		  ,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Emissao' )"		,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Faturamento Inicial" ,Ctod("")						,""		,""														,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Faturamento Inicial" ,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Faturamento' )"	,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"C๓digo Produto Inicial"	  ,Space(tamSx3("B1_COD")[1])	,"@!"	,""														,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"C๓digo Produto Final"	  ,Space(tamSx3("B1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'C๓d. Produto' )"		,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"C๓digo Cliente Inicial"	  ,Space(tamSx3("A1_COD")[1])	,"@!"	,""														,"SA1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"C๓digo Cliente Final"	  ,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'C๓d. Produto' )"		,"SA1"	,""	,050,.F.})
 	aAdd(_aParambox,{3,"Status Pedido"			  ,Iif(Set(_SET_DELETED),1,2)	,{"FATURADO","NAO FATURADO","AMBOS"}					        , 100	,"" ,.F.})  // Paulo Henrique - MARFRIG - 30/10/2019 - RTASK0010342
	aAdd(_aParambox,{1,"Nบ do Pedido:"			  ,Space(tamSx3("C5_NUM")[1])	,"@!"		,""													,""		,"" ,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	// Paulo Henrique - S๓ emite o relat๓rio se a data de emissใo for menor de 90 dias
	If Mv_Par03 < (dDataBase - 90) .Or. Mv_Par04 > (dDataBase + 90)
	   ApMsgAlert(OemToAnsi("OS DADOS DEVERรO SER EMITIDOS DOS ULTIMOS 90 DIAS"),OemToAnsi("ATENวรO"))
	   Return
	EndIf

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//---- D I R E T O R I A
	cQryDireto	:= " SELECT ZBD_DESCRI "
	cQryDireto	+= "  FROM "+RetSqlName("ZBD")
	cQryDireto	+= "  WHERE D_E_L_E_T_ = ' ' "
	aCpoDireto	:=	{   { "ZBD_DESCRI", U_X3Titulo("ZBD_DESCRI"), TamSx3("ZBD_DESCRI")[1]	}  }
	cTitDireto	:= "Selecione os registros "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa.
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro)
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	//aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg )
	_cDiretoria	:= U_Array_In( U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif

	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
	
	IF cEnviroSrv $ 'PRODUCAO|PRE_RELEASE'                  
		_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_ANALISE_PEDIDOS"  )				+ CRLF
	Else
	    _cQuery += "  FROM V_FAT_ANALISE_PEDIDOS" + CRLF
	EndIF

	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " EMPRESA IN " 			+ _cCODFILIA 							 				)
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DATA_EMBARQUE BETWEEN '"		    + _aRet[1]   + "' AND '" + _aRet[2] + "' " 	)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " DATA_EMISSAO_FILTRO BETWEEN '"		+ _aRet[3]   + "' AND '" + _aRet[4] + "' " 	)
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " DATA_FATURAMENTO_FILTRO BETWEEN '"	+ _aRet[5]   + "' AND '" + _aRet[6] + "' " 	)
	_cQuery += U_WhereAnd( !empty(_aRet[8]),       " COD_PRODUTO BETWEEN '"				+ _aRet[7]   + "' AND '" + _aRet[8] + "' " 	)
	_cQuery += U_WhereAnd( !empty(_aRet[10]),      " COD_CLIENTE_FILTRO BETWEEN '"		+ _aRet[9]   + "' AND '" + _aRet[10] + "' " )
	_cQuery += U_WhereAnd( !empty(_cDiretoria),    " DIRETORIA IN " 					+ _cDiretoria 							 	)

    // Paulo Henrique - 28/11/2019 - Separa็ใo das informa็๕es conforme marca็ใo do usuแrio
	 IF VALTYPE(_aRet[11]) == 'N'

	     IF _aRet[11] == 1
	        _aRet[11] := 'FATURADO'
	     ElseIf _aRet[11] == 2
	        _aRet[11] := 'NAO FATURADO'
		 Else
		    _aRet[11] := 'FATURADO/NAO FATURADO'
		 EndIf

	EndIF
    
	If _aRet[11] == 'FATURADO' .Or. _aRet[11] == 'NAO FATURADO'
	   _cQuery += U_WhereAnd( !empty(_aRet[11] )," STATUS_PEDIDO = '"+_aRet[11]+"' ")  // Paulo Henrique - Marfrig - 30/10/2019 - RTASK0010342
	Else 
//     _cQuery += U_WhereAnd( !empty(_aRet[11] )," STATUS_PEDIDO LIKE '%"+_aRet[11]+"%' ")
       _cQuery += U_WhereAnd( !empty(_aRet[11] )," STATUS_PEDIDO IN "+FormatIn(_aRet[11],"/"))+" "
	EndIf
 	
	 _cQuery += U_WhereAnd( !empty(_aRet[12] )," PEDIDO LIKE '%"+_aRet[12]+"%' ")  // Paulo Henrique - Marfrig - 30/10/2019 - RTASK0010342
																				//
	//MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MemoWrite("C:\TEMP\AAA_" + FunName() +".SQL",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN