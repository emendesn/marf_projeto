#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R22	บAutor  ณ Geronimo Benedito Alves 							        บData ณ  13/07/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Acordo Comercial (M๓dulo 06-FIN)                    บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R22()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
 
 
	Aadd(_aDefinePl, "Contas เ Pagar - Acordo Comercial")	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Acordo Comercial"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Acordo Comercial"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Acordo Comercial"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//   Versใo Nova  do posicionamento dos campos da _aCampoQry
	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 
	// O nome do campo estแ no elemento 2, mas, se ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras ้  
	// dado a ele um apelido indicado pela clausula "as" que serแ transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos do Array, nใo precisando declara-los.		
	// As unicas exce็๕es sใo os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Tit๚lo, que se no array _aCampoQry, estiver preenchido,
	// ้ preservado, nใo sendo sobreposto pelo X3_DESCRIC 
	//					01			 02					 03			 04		 05	 06	07		08	09
	Aadd(_aCampoQry, {"E1_FILIAL"	,"COD_FILIAL"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"		,"Filial"	,"C"	,40	,0	,""		,""	,""		})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"A1_LOJA"		,"NUM_LOJA_CLIENTE"	,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"A1_CGC"		,"NUM_CNPJ"			,""			,""		,18	,""	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"ZQ_COD"		,"DESC_REDE"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_SEGMENTO"	,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_TIPO"		,"TIP_TITULO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_HIST"		,"OBSERVACAO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DEVOLVIDO"	,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"E1_SALDO"	,"VLR_LIQUIDO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"CN9_ZACORD"	,"PERC_ACORDO"		,""			,""		,""	,""	,""		,""	,""		})
	Aadd(_aCampoQry, {"CN9_ZDESCF"	,"PREC_DESCONTO"	,""			,""		,""	,""	,""		,""	,""		})

	aAdd(_aParambox,{1,"Data Emissใo Inicial"	,Ctod("")					,""		,""													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Emissใo Final"		,Ctod("")					,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Codigo Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,"@!"	,""													,"CLI"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Codigo Cliente Final"	,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'C๓digo Cliente')"	,"CLI"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Codigo Rede Inicial:"	,Space(tamSx3("ZQ_COD")[1])	,"@!"	,""													,"SZQ"	,""	,070,.F.})  
	aAdd(_aParambox,{1,"Codigo Rede Final:"		,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Rede')"		,"SZQ"	,""	,070,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
	cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
	cQryPorPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6")  ) + " TMPSA6 "
	cQryPorPro	+= "  WHERE TMPSA6.D_E_L_E_T_ = ' ' " 
	cQryPorPro	+= "  ORDER BY A6_COD"
	aCpoPorPro	:=	{	{ "A6_COD"		,U_X3Titulo("A6_COD")	,TamSx3("A6_COD")[1]		} ,;
	aCpoPorPro	:=		{ "A6_NOME"	,U_X3Titulo("A6_NOME")	,TamSx3("A6_NOME")[1] }	} 
	cTituPorta	:= "Marque os Cod. Portador a serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
	//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
	cPortaProd	:= U_Array_In( U_MarkGene(cQryPorPro, aCpoPorPro, cTituPorta, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_ACORDO_COMERCIAL"  )     + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_EMISSAO_FILTRO BETWEEN '" + _aRet[1]     + "' AND '" + _aRet[2] + "' "   ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN "              + _cCODFILIA                                   ) // OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " COD_CLIENTE  BETWEEN '"      + _aRet[3]     + "' AND '" + _aRet[4] + "' "   ) // NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	If empty(cPortaProd)
		_cQuery +=  ""		// Nใo incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery += U_WhereAnd( .T. ,               " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"             ) 
	Else	
		_cQuery += U_WhereAnd( .T. ,               " COD_PORTADOR IN " + cPortaProd                                              ) 	
	Endif
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " COD_REDE_FILTRO BETWEEN '"    + _aRet[5]    + "' AND '"  + _aRet[6] + "' "  ) // NรO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

