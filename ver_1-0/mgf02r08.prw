#INCLUDE "totvs.ch" 

/*/{Protheus.doc} MGF02R08 (Relatório - Compras Pendente Pedido)
Criação de relatório 'Cubo para o sistema de fretes e suprimentos'

@description
Rotina tem o objetivo de exibir fretes e suplimentos de compras, a partir 
de view pré definida pelo BI. 

@author Henrique Vidal Santos
@since 23/09/2019

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	View - V_COMPRAS_COMPRASPENDENTEPED
	SA2 - Fornecedores
	SF1 - Cabeçalho da nota fiscal
	SA4	- Transportadora
	SB1 - Produtos 
	SBM - Grupo de produtos 
	SD1 - Itens da Nota fiscal 

@param
@return

@menu
	SIGACOM->Relatorios/Especifico/Fretes e suprimentos 
@history
	Criação da rotina
	RTASK0010066 - Cubo para o sistema de fretes e suprimentos
	
/*/

User Function MGF02R08()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS - Fretes e suprimentos"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Fretes e suprimentos"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Fretes e suprimentos"} 			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Fretes e suprimentos"}  			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  									)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 							)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  	
	_nInterval	:= 366												//Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	Aadd(_aCampoQry, { "A1_FILIAL"	,"COD_FILIAL"				,"Cód. Filial"			,"","",,"","",""})
	Aadd(_aCampoQry, { "M0_CODIGO"	,"DESCR_EMPRESA"			,"Nome Filial"			,"C",050,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "M0_CIDENT"	,"UNIDADE"					,"Unidade"					,""	,""	,,"","",""})
	Aadd(_aCampoQry, { "F1_DOC"		,"NUMERO_NF"				,"Nota fiscal"			,""	,""	,,"","",""})
	Aadd(_aCampoQry,	{ "F1_SERIE"	,"NUMERO_SERIE_NF"		,"Serie"					,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "F1_EMISSAO"	,"DT_EMISSAO_NF"			,"Data Emissao"			,""	,""	,,"","",""})
	Aadd(_aCampoQry, { "F1_EMISSAO"	,"DT_RECEBIMENTO_NF"		,"Data Recebimento"		,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A2_COD"		,"COD_FORNECEDOR"			,"Codigo Fornecedor"		,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A2_LOJA"	,"LOJA_FORNECEDOR"		,"Loja"					,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A2_NOME"	,"NOME_FORNECEDOR"		,"Fornecedor"				,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A2_CGC"		,"CNPJ_FORNECEDOR"		,"Cnpj"					,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "GW4_NRDF"	,"NUM_CONHECIMENTO"		,"Conhecimento"			,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A4_COD"		,"COD_TRANSPORTADORA"	,"Cod. Transportadora"	,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "A4_NOME"	,"NOME_TRANPORTADORA"	,"Transportadora"			,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "FT_FRETE"	,"VLR_FRETE"				,"Frete"					,""	,""	,,"","",""})
  	Aadd(_aCampoQry, { "F1_EMISSAO"	,"DT_EMISSAO_CTE" 		,"Emissao Cte"			,""	,""	,,"","",""})

	aAdd(_aParambox,{1,"Dt Emissão Nf Inicio"		,Ctod("")			,""	,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissão Nf Final"		,Ctod("")			,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Emissão Cte Inicial"	,Ctod("")			,""	,"" 													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Emissão Cte Final"		,Ctod("")			,""	,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""		,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//=========	S E L E C I O N A     F O R N E C E D O R  
	cQryFornec	:= "SELECT ' ' as A2_COD_LOJ, 'NÃO INFORMADO' as A2_NOME, ' ' AS A2_CGC  FROM DUAL UNION ALL "
	cQryFornec	+= "SELECT A2_COD||A2_LOJA as A2_COD_LOJ, A2_NOME "
	cQryFornec	+= " ,CASE LENGTH(TRIM(A2_CGC))                   "
	cQryFornec	+= "      WHEN NULL                               " 
	cQryFornec	+= "          THEN ''                             "
	cQryFornec	+= "      WHEN 0                                  "
	cQryFornec	+= "          THEN ''                             "
	cQryFornec	+= "      WHEN 11                                 "
	cQryFornec	+= "          THEN SUBSTR(A2_CGC,1,3)||'.'||SUBSTR(A2_CGC,4,3)||'.'||SUBSTR(A2_CGC,7,3)||'-'||SUBSTR(A2_CGC,10,2) "
	cQryFornec	+= "      WHEN 14                                 "
	cQryFornec	+= "          THEN SUBSTR(A2_CGC,1,2)||'.'||SUBSTR(A2_CGC,3,3)||'.'||SUBSTR(A2_CGC,6,3)||'/'||SUBSTR(A2_CGC,9,4)||'-'|| SUBSTR(A2_CGC,13,2) "
	cQryFornec	+= "      ELSE A2_CGC                             "
	cQryFornec	+= "  END                              AS A2_CGC   "
	cQryFornec  += "  FROM " +  RetSqlName("SA2") + " TMPSA2 "
	cQryFornec	+= "  WHERE TMPSA2.D_E_L_E_T_ = ' ' " 

	cQryFornec	+= "  ORDER BY A2_COD_LOJ"

	aCpoFornec	:=	{	{ "A2_COD_LOJ"	,"Código-loja"			,TamSx3("A2_COD")[1] + TamSx3("A2_LOJA")[1] +20		} ,;
	aCpoFornec	:=		{ "A2_NOME"		,"Fornecedor"	,TamSx3("A2_NOME")[1]  +50  }	 ,; 
	aCpoFornec	:=		{ "A2_CGC"		,U_X3Titulo("A2_CGC")	,TamSx3("A2_CGC")[1]  }	} 
	cTitFornec	:= " Marque os Fornecedores à listar."
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 	
	_aForneced	:= U_MarkForn(cQryFornec, aCpoFornec, cTitFornec, nPosRetorn, @_lCancProg )
	_cForneced	:= U_Array_In( _aForneced )
	If _lCancProg
		Return
	Endif 


 	cQryTransp	:= "SELECT ' ' as A4_COD ,'.Sem transportadora' as A4_NOME FROM DUAL UNION ALL "
	cQryTransp	+= "SELECT A4_COD ,A4_NOME "
	cQryTransp  += "  FROM " +  RetSqlName("SA4") + " SA4 " 
	cQryTransp	+= "  WHERE SA4.D_E_L_E_T_ = ' ' "
	cQryTransp	+= "  ORDER BY A4_NOME "
	aCpoSolici	:=	{	{ "A4_COD"		,"Código"	, 040	} ,;
	aCpoSolici	:=		{ "A4_NOME"	,"Transportadora"	, 080	}	} 
	cTitSolici	:= "Marque os Códigos de transportadoras à serem listados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 		
	cIdTransp	:= U_Array_In( U_MarkGene(cQryTransp, aCpoSolici, cTitSolici, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_FRETES_SUPRIMENTOS") +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_EMISSAO_NF_FILTRO BETWEEN '"     + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                              )		// OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " DT_EMISSAO_CTE_FILTRO BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' "	)		// NÃO OBRIGATORIO

	If Empty( cIdTransp )
		_cQuery +=  ""		
	ElseIF AT("' '", cIdTransp ) <> 0
		_cQuery += U_WhereAnd(  !empty(cIdTransp) ,	" ( COD_TRANSPORTADORA IS NULL OR COD_TRANSPORTADORA IN " + cIdTransp + " )"         )
	Else	
		_cQuery += U_WhereAnd(  !empty(cIdTransp) ,	" COD_TRANSPORTADORA IN " + cIdTransp	                                            )	
	Endif

	If Empty( _cForneced )
		_cQuery +=  ""		
	ElseIF AT("' '", _cForneced ) <> 0
		_cQuery += U_WhereAnd( .T. ,              " ( COD_FORNECEDOR IS NULL OR COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced + " )" )
	Else	
		_cQuery += U_WhereAnd( .T. ,              " COD_FORNECEDOR||LOJA_FORNECEDOR IN " + _cForneced	)	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
