#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R14	บAutor  ณ Geronimo Benedito Alves																	บData ณ  13/04/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Movimenta็ใo de Titulos		(M๓dulo 06-FIN)	บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R14()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Movimenta็ใo de Titulos" )	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Movimenta็ใo de Titulos"	)					//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Movimenta็ใo de Titulos"} )					//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Movimenta็ใo de Titulos"} )					//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )											//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )									//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02									 03							 04	 05		 06	 07						 08		 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"						,"C๓d. Filial"				,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"						,"Nome Filial"				,"C",041	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_DOCUMENTO		as NUM_DOCUME"	,"No. Documento"			,"C",009	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"PREFIXO"							,"Prefixo"					,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_TIPO"		,"TIPO_TITULO 		as TP_TITULO"	,"Tipo Tํtulo"				,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA		as NUMPARCELA"	,"Parcela"					,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA"						,"Natureza"					,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"						,"Data Emissใo"				,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO		as DTVENCIMEN"	,"Data Vencimento"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_DATA"		,"DT_MOVIMENTACAO	as DTMOVIMENT"	,"Data Movimenta็ใo"		,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_MOVIMENTACAO	as VLRMOVIMEN"	,"Valor Movimenta็ใo"		,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"ALO_DESCR"	,"TIPO_MOVIMENTACAO	as TIPOMOVIME"	,"Tipo Movimenta็ใo"		,"C",017	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_HISTOR"	,"HIST_MOVIMENTACAO	as HISTMOVIME"	,"Hist๓rico Movimenta็ใo"	,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_HIST"		,"OBS_TITULO"						,"Obs. Titulo"				,"C",240	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"DESMOTBAIX"	,"MOTIVO_BAIXA		as MOTIVOBAIX"	,"Motivo da Baixa"			,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE		as CODCLIENTE"	,"C๓d. Cliente"				,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE		as NOMCLIENTE"	,"Nome Cliente"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE		as CNPJCLIENT"	,"CNPJ Cliente"				,"C",018	,0	,"@!"					,""		,"@!"	})
	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO		as CODSEGMENT"	,"C๓digo do Segmento"		,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"NOM_SEGMENTO		as DESCSEGMEN"	,"Descri็ใo do Segmento"	,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"						,"Descri็ใo Rede"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR		as NOMVENDEDO"	,"Nome do Vendedor"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR		as CODPORTADO"	,"C๓digo do Portador"		,"C",003	,0	,""						,""		,""	})
	AADD(_aCampoQry, {"E1_AGEDEP"	,"NUM_AGENCIA		as NUMAGENCIA"	,"No. Agencia"				,"C",005	,0	,""						,""		,""	})
	AADD(_aCampoQry, {"E1_CONTA"	,"NUM_CONTA"						,"No. Conta"				,"C",010	,0	,""						,""		,""	})
	AADD(_aCampoQry, {"E1_NUMBCO"	,"NUM_TITULO_BANCO	as NUM_TITULO"	,"No. Titulo do Banco"		,"C",015	,0	,""						,""		,""	})
	AADD(_aCampoQry, {"E1_VALOR"	,"VLR_BRUTO"						,"Valor Bruto"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	AADD(_aCampoQry, {"E1_VALOR"	,"VLR_JUROS"						,"Valor Juros"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	AADD(_aCampoQry, {"E1_SALDO"	,"VLR_SALDO_TITULO	as SALDOTITUL"	,"Valor Saldo do Titulo"	,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})

	aAdd(_aParambox,{1,"Dt Movimenta็ใo Inicial"	,Ctod("")					,""		,"" 													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Dt Movimenta็ใo Final"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Dt Movimenta็ใo')"	,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"		,Space(tamSx3("A1_COD")[1])	,"@!"	,"",													"CLI"	,""	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final  "		,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	,070,.F.})													
	aAdd(_aParambox,{1,"Cod. Rede De "			,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"",													"SZQ"	,""	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Rede At้ "			,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Rede')"			,"SZQ"	,""	,070,.F.})													
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	Do While.T.	// La็o para obrigar a marca็ใo de ao menos um portador
		cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
		cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
		cQryPorPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6") ) + " TMPSA6 " 
		cQryPorPro	+= "  WHERE TMPSA6.D_E_L_E_T_ = ' ' " 
		cQryPorPro	+= "  ORDER BY A6_COD"

		aCpoPorPro	:=	{	{ "A6_COD"		,U_X3Titulo("A6_COD")	,TamSx3("A6_COD")[1]	 } ,;
		aCpoPorPro	:=		{ "A6_NOME"	,U_X3Titulo("A6_NOME")	,TamSx3("A6_NOME")[1] }	} 
		cTituPorta	:= "Selecione os C๓digos de Portadores a serem listados "

		nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
		//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
		//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
		_lInComAll	:= .T. 	//Se for .T. Indica que se na tela de MarkGene, usuแrio, marcar todos os itens, eles todos retornarใo dentro da clแusula IN. Se for .F. indica que se todos os itens forem marcados, retorna vazio nใo criando a cla๚sula IN.
		cPortaProd	:= U_Array_In( U_MarkGene(cQryPorPro, aCpoPorPro, cTituPorta, nPosRetorn, @_lCancProg ,_lInComAll ) )

		Exit	// Mudan็a da l๓gica. Nใo tem mais MarkGene obrigat๓ria. Se nใo marcar nenhum, ou marcar todos, prossigo e nใo incluo a condi็ใo no where

		//If empty(cPortaProd)
		//	MsgStop("ษ obrigatorio a sele็ao de ao menos um portador. ")
		//	Loop		// Se nao marcou nenhum portador, dou loop ao While para marca-lo 
		//Else
		//	Exit		// Se marcou ao menos um portador, dou exit neste la็o e continuo o processamento da rotina
		//Endif
	Enddo
	
	If _lCancProg
		Return
	Endif
	
	If Empty(_aRet[5])
	//===		S E L E C I O N A	R E D E
	cQryRede	:= " SELECT ' ' as ZQ_COD, 'SEM REDE' as ZQ_DESCR FROM DUAL UNION ALL "
	cQryRede	+= " SELECT DISTINCT ZQ_COD, ZQ_DESCR"
	cQryRede  	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZQ") ) + " TMPSZQ " 
	cQryRede	+= "  WHERE TMPSZQ.D_E_L_E_T_ = ' ' " 
	cQryRede	+= "  ORDER BY ZQ_COD"

	aCpoRede	:=	{	{ "ZQ_COD"		,U_X3Titulo("ZQ_COD")	,TamSx3("ZQ_COD")[1]	 } ,;
	aCpoRede	:=		{ "ZQ_DESCR"	,U_X3Titulo("ZQ_DESCR")	,TamSx3("ZQ_DESCR")[1] }	} 
	cTituRede	:= "Selecione os C๓digos de Rede เ serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	cRede	:= U_Array_In( U_MarkGene(cQryRede, aCpoRede, cTituRede, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	EndIf

	//===		S E L E C I O N A	V E N D E D O R
	cQryVended	:= "SELECT ' ' as A3_COD, 'SEM VENDEDOR' as A3_NOME FROM DUAL UNION ALL "
	cQryVended	+= "SELECT DISTINCT A3_COD, A3_NOME"
	cQryVended  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA3")  ) + " TMPSA3 "
	cQryVended	+= "  WHERE TMPSA3.D_E_L_E_T_ = ' ' " 
	cQryVended	+= "  ORDER BY A3_COD"

	aCpoVended	:=	{	{ "A3_COD"		,U_X3Titulo("A3_COD")	,TamSx3("A3_COD")[1]		} ,;
	aCpoVended	:=		{ "A3_NOME"	,U_X3Titulo("A3_NOME")	,TamSx3("A3_NOME")[1] }	} 
	cTituVende	:= "Marque os Cod. Vendedor a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A3_COD
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	cVendedor	:= U_Array_In( U_MarkGene(cQryVended, aCpoVended, cTituVende, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	cSrvLog	:= AllTrim(UPPER(GETENVSERVER()))

	If 'HML' $ cSrvLog
		_cQuery += " FROM " +  "V_CR_MOVIMENTACAO_TITULOS"      						  	+CRLF
	Else	
		_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_CR_MOVIMENTACAO_TITULOS" )        	+CRLF
	EndIf 
	
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DT_MOVIMENTACAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDAวรO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " COD_FILIAL IN " + _cCODFILIA	     +CRLF                                    ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " COD_CLIENTE BETWEEN '"            + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NรO OBRIGATORIO
	If empty(cPortaProd)
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	Else	
		_cQuery += U_WhereAnd( .T. ,             " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"            )
	Endif


	If !empty(_aRet[5])
		_cQuery += U_WhereAnd( !empty(_aRet[5] ),    " COD_REDE BETWEEN '"            + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO
	Else
		If empty(cRede)
			_cQuery +=  ""		// Nใo incrementa a clausula Where
		ElseIF AT("' '", cRede ) <> 0
			_cQuery +=  ""		// Nใo incrementa a clausula Where
		Else	
			_cQuery += U_WhereAnd( .T. ,             " ( COD_REDE IS NULL OR COD_REDE IN " + cRede + " )"                         )
		Endif
	EndIf

	If empty(cVendedor)
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", cVendedor ) <> 0
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	Else	
		_cQuery += U_WhereAnd(  .T. , " ( COD_VENDEDOR_FILTRO IS NULL OR COD_VENDEDOR_FILTRO IN " + cVendedor + " )"                             ) 
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN