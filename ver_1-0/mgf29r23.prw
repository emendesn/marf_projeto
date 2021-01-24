#include "totvs.ch" 


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF29R23	บAutor  ณGeronimo Benedito Alves																	บData ณ10/01/18	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTAวรO - Mensal por BL							บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

/*/{Protheus.doc} MGF29R23
//TODO Relat๓rio de BI.
@author Eduardo A. Donato
@since 28/01/2019
@version 1.0
@return ${return}, ${return_description}
@description Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTAวรO - Mensal por BL
@type function
/*/
User Function MGF29R23()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Exporta็ใo - Mensal por BL")	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Mensal por BL"			 )	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Mensal por BL"}			 )	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Mensal por BL"}			 )	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							 )	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }				 )	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 35								//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03							 04	 05		 06	 07						 08		 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP "								,"N๚mero Exporta็ใo"		,"C",013	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"								,"Ano Exporta็ใo"			,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"								,"Sub Exporta็ใo"			,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_TRADING			as NOM_TRADIN"	,"Nome Trading"				,"C",040	,0	,""						,""		,""	})  
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADOR		as NOM_IMPORT"	,"Nome Importador"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE		as NOMCONSIGN"	,"Nome Consignee"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"							,"Nome Buyer"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EE9_PSLQTO"	,"PESO_LIQUIDO			as PESOLIQUID"	,"Peso Liquido"				,"N",016	,2	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"EEC_MOEDA"	,"MOEDA"								,"Moeda"					,"C",003	,9	,""						,""		,""	})
	Aadd(_aCampoQry, {"XXTOTAL"		,"VLR_ITEM_EMB"							,"Valor Item embarcado"		,"N",016	,2	,"@E 999,999,999,999.99",""		,""	})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_DESTINO 			as PAIS_DESTI"	,"Pais Destino"				,"C",025	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"XXYAZCDM01"	,"BLOCO_ECON_PORT_DEST	as ECONPORTDE"	,"Bloco Econ Porto Destino"	,"C",030	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"XXYAZCDM02"	,"CONTINENTE_PORT_DEST	as CONTPORTDE"	,"Continente Porto Destino"	,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO			as TP_PRODUTO"	,"Tipo de Produto"			,"C",045	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"FAMILIA_PRODUTO		as FAM_PRODUT"	,"Familia do Produto"		,"C",045	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEG_NOME"	,"NEGOCIO"								,"Negocio"					,"C",045	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL"								,"Data Embarque"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"XXEECDTE01"	,"ANO_MES_BL"							,"Ano Mes do BL"			,"C",007	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"	,"SITUACAO"								,"Situa็ใo"					,"C",080	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"XXEECZRE01"	,"REGIAO"								,"Regiใo"					,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YQ_COD_DI"	,"VIA"									,"Via"						,"C",020	,0	,""						,""		,""	})      
	Aadd(_aCampoQry, {"EEC_INCOTE"	,"SALES_TERMS 			as TERM_SALES"	,"Sales Terms"				,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"	,"TIPO_PAGAMENTO		as TIPO_PAGTO"	,"Tipo Pagamento"			,"C",080	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"TRADER"								,"Trader"					,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR			as ADMINISTRA"	,"Administrador"			,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADORNF		as NOM_IMP_NF"	,"Nome Importador NF"		,"C",040	,0	,""						,""		,""	})

	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL_TRANSPORTE"					,"Data Bloqueio Transporte"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_RESERVA"							,"Numero Reserva"					,"C",045	,0	,""						,""		,""	})


	aAdd(_aParambox,{1,"Nome do Trading"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome do Importador"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome do Consignee"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome do Buyer"					,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Pais Destino  (em portugues)"	,Space(tamSx3("YA_DESCR")[1])	,"@!"		,""		,"SYAEXP"	,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome do Tipo de Produto"		,Space(tamSx3("EEH_NOME")[1])	,"@!"		,""		,"EEH90"	,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome da Familia Produto"		,Space(tamSx3("EEH_NOME")[1])	,"@!"		,""		,"EEH90"	,"",115,.F.})													
	aAdd(_aParambox,{1,"Neg๓cio"						,Space(tamSx3("EEG_NOME")[1])	,"@!"		,""		,""			,"",115,.F.})													
	aAdd(_aParambox,{1,"Mes Ano BL no formato MM/AAAA"	,Space(07)						,"99/9999"	,""		,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Nome do Trader"					,Space(tamSx3("A3_NOME")[1])	,"@!"		,""		,"SA3NOM"	,"",100,.F.})
	aAdd(_aParambox,{1,"Nome do Administrador"			,Space(tamSx3("EEC_RESPON")[1])	,"@!"		,""		,""			,"",100,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//=========	S E L E C I O N A	  B L O C O    E C O N O M I C O    D E S T I N O
	cQBlEcoDes := "			  select  '1 - America do Sul'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '2 - America do Norte/Central'	as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '3 - Oriente Medio'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '4 - Leste Europeu'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '5 - Russia'						as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '6 - Ucrania'						as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '7 - Europa'						as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '8 - Nao Informado'				as CAMPO_01 from dual
	aCpoBlEcoD	:=	{{ "CAMPO_01"	,"Bloco Economico do destino", 30 } }  
	cTitBlEcoD	:= "Blocos Economicos do destino เ serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	_cBlEcoDes	:= U_Array_In( U_MarkGene(cQBlEcoDes, aCpoBlEcoD, cTitBlEcoD, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	//=========	S E L E C I O N A     C O N T I N E N T E     D E S T I N O
	cQBlEcoDes := "			  select  '1 - America'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '2 - Europa'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '3 - Africa'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '4 - Asia'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '5 - Oceania'				as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '6 - Antartida'			as CAMPO_01 from dual
	cQBlEcoDes += " union all select  '8 - Nao Informado'		as CAMPO_01 from dual
	aCpoBlEcoD	:=	{{ "CAMPO_01"	,"Continente do destino", 30	 }} 
	cTitBlEcoD	:= "Continentes de destino เ serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	_cContiDes	:= U_Array_In( U_MarkGene(cQBlEcoDes, aCpoBlEcoD, cTitBlEcoD, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	//=========	S E L E C I O N A     S I T U A ว ร O
	cQrySituac	:= " SELECT '" +SPACE(TamSx3("YP_TEXTO")[1])+ "' as YP_TEXTO, 'Nใo Informado' as OBSERVACAO FROM DUAL UNION ALL "
	cQrySituac	+= " SELECT DISTINCT YP_TEXTO, ' ' AS OBSERVACAO "
	cQrySituac  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SYP") ) + " TMPSYP " 
	cQrySituac	+= "  WHERE TMPSYP.YP_FILIAL = '" +xFilial("SYP")+  "' AND TMPSYP.YP_CAMPO = 'EE4_TEXTO' AND TMPSYP.D_E_L_E_T_ = ' ' " 
	cQrySituac	+= "  ORDER BY YP_TEXTO"
	aCpoSituac	:=	{	{ "YP_TEXTO"		,"S I T U A ว ร O"	,TamSx3("YP_TEXTO")[1] + 40	}  ,; 
						{ "OBSERVACAO"		,"Obs."				,13 + 30 					}   } 
	cTitSituac	:= "Situa็๕es เ serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: YQ_COD_DI
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	_cSituacao	:= U_Array_In( U_MarkGene(cQrySituac, aCpoSituac, cTitSituac, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	//=========	S E L E C I O N A     V I A 
	cQryVia	:= " SELECT ' Nใo Informado' as YQ_COD_DI, '" +SPACE(TamSx3("YQ_DESCR")[1])+ "' as YQ_DESCR FROM DUAL UNION ALL "
	cQryVia	+= " SELECT DISTINCT YQ_COD_DI, YQ_DESCR "
	cQryVia  	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SYQ") ) + " TMPSYQ " 
	cQryVia	+= "  WHERE TMPSYQ.D_E_L_E_T_ = ' ' " 
	cQryVia	+= "  ORDER BY YQ_COD_DI"
	aCpoVia	:=	{	{ "YQ_COD_DI"		,"Via de Transporte"	,TamSx3("YQ_COD_DI")[1] + 40 }  ,; 
					{ "YQ_DESCR"		,"Descri็ใo em Ingles"	,TamSx3("YQ_DESCR")[1] + 30 }   } 
	cTituVia	:= "Vias de transportes เ serem listadas: "
	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: YQ_COD_DI
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	_cVia	:= U_Array_In( U_MarkGene(cQryVia, aCpoVia, cTituVia, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 


	//aAdd(_aParambox,{1,"Nome do Trading"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	//aAdd(_aParambox,{1,"Nome do Importador"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	//aAdd(_aParambox,{1,"Nome do Consignee"				,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	//aAdd(_aParambox,{1,"Nome do Buyer"					,Space(tamSx3("A1_NOME")[1])	,"@!"		,""		,"VSA1"		,"",115,.F.})													
	//aAdd(_aParambox,{1,"Pais Destino  (em portugues)"	,Space(tamSx3("YA_DESCR")[1])	,"@!"		,""		,"SYAEXP"	,"",115,.F.})													
	
	//aAdd(_aParambox,{1,"Nome do Tipo de Produto"		,Space(tamSx3("EEH_NOME")[1])	,"@!"		,""		,"EEH90"	,"",115,.F.})													
	//aAdd(_aParambox,{1,"Nome da Familia Produto"		,Space(tamSx3("EEH_NOME")[1])	,"@!"		,""		,"EEH90"	,"",115,.F.})													
	//aAdd(_aParambox,{1,"Neg๓cio"						,Space(tamSx3("EEG_NOME")[1])	,"@!"		,""		,""			,"",115,.F.})													
	//aAdd(_aParambox,{1,"Mes Ano BL no formato MM/AAAA"	,Space(07)						,"99/9999"	,""		,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Nome do Trader"					,Space(tamSx3("A3_NOME")[1])	,"@!"		,""		,"SA3NOM"	,"",100,.F.})
	aAdd(_aParambox,{1,"Nome do Administrador"			,Space(tamSx3("EEC_RESPON")[1])	,"@!"		,""		,""			,"",100,.F.})

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_EX_MENSALPORBL"  )                 + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " FILIAL_FILTRO IN "                  + _cCODFILIA ) 												// OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[1] ),    " NOME_TRADING LIKE '%"               + _aRet[1] + "%' "  ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " NOME_IMPORTADOR LIKE '%"            + _aRet[2] + "%' "  ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),    " NOME_CONSIGNEE LIKE '%"             + _aRet[3] + "%' "  ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " NOME_BUYER LIKE '%"                 + _aRet[4] + "%' "  ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),    " PAIS_DESTINO_FILTRO LIKE '%"        + _aRet[5] + "%' "  ) //NรO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_cBlEcoDes ),  " BLOCO_ECON_PORT_DEST IN "           + _cBlEcoDes        ) //NรO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_cContiDes ),  " CONTINENTE_PORT_DEST IN "           + _cContiDes        ) //NรO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " TIPO_PRODUTO LIKE '%"               + _aRet[6] + "%' "  ) //NรO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),    " FAMILIA_PRODUTO LIKE '%"            + _aRet[7] + "%' "  ) //NรO OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " NEGOCIO LIKE '%"                    + _aRet[8] + "%' "  ) 		
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),    " ANO_MES_BL = '"                     + _aRet[9] + "'  "  ) //NรO OBRIGATORIO - DIGITADO									**NOVO FILTRO**

	If Empty( _cSituacao )		// YP_TEXTO
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", _cSituacao ) <> 0
		_cQuery += U_WhereAnd( .T. ,             " ( SITUACAO IS NULL OR SITUACAO IN " + _cSituacao + " )" ) 
	Else	
		_cQuery += U_WhereAnd( .T. ,             " SITUACAO IN " + _cSituacao	+CRLF                      ) 	
	Endif

	If Empty( _cVia )	// YQ_COD_DI
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", _cVia ) <> 0
		_cQuery += U_WhereAnd( .T. ,             " ( VIA IS NULL OR VIA IN " + _cVia + " )"                ) 
	Else	
		_cQuery += U_WhereAnd( .T. ,             " VIA IN " + _cVia                                        ) 	
	Endif
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),   " TRADER LIKE '%"                     + _aRet[10] + "%' " ) 						
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),   " ADMINISTRADOR LIKE '%"              + _aRet[11] + "%' " ) //NรO OBRIGATORIO  - DIGITADO								**NOVO FILTRO**
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN


