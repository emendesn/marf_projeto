#include "totvs.ch" 

/*/{Protheus.doc} MGF02R07 
Relat�rio Grades de compras pendentes

@description
Relat�rio listar� a View V_compraspendentes.

@author Henrique Vidal Santos
@since 04/09/2019

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function  
@table 
	SC1 - Solicita��o de compras                        
	SC7 - Pedido de compras  
	SYS_USR - Usu�rios   

@param
@return

@menu
	Sigacom/Relat�rios/Especificos - MGF02R07.PRW 
/*/
User Function MGF02R07()
	 
	Private _aRet		:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl 	:= {}, _aCampoQry 	:= {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil	:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS-Grade de compras pendentes"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Grade de compras pendentes"			)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Grade de compras pendentes"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Grade de compras pendentes"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	Aadd(_aCampoQry, {"C1_FILIAL"	,	"COD_FILIAL"			,"C�digo Filial"		,"","","","","",""})
	Aadd(_aCampoQry, {"M0_FILIAL"	,	"NOME_FILIAL"			,"Nome Filial"		,"","","","","",""})
	Aadd(_aCampoQry, {"C1_NUM"		,	"NUMERO_SC	"			,"Solicita��o"		,"","","","","",""})
	Aadd(_aCampoQry, {"USR_NOME"	,	"PENDENTE_APROVADOR_SC"	,"Aprovador Sc"		,"","","","","",""})
	Aadd(_aCampoQry, {"C1_EMISSAO"	,	"DATA_LIBERACAO_SC"		,"Data Libera��o Sc"	,"","","","","",""})
	Aadd(_aCampoQry, {"C1_ITEM"		,	"ITEM_SC"				,"Item Sc"				,"","","","","",""})
	Aadd(_aCampoQry, {"C1_ZGEAUTE"	,	"GERA_AUT_ENTREGA"		,"Gera Entrega"		,"","","","","",""})
	Aadd(_aCampoQry, {"C1_EMISSAO"	,	"DATA_EMISSAO_SC"		,"Data Emiss�o Sc	"	,"","","","","",""})
	Aadd(_aCampoQry, {"C7_NUM"		,	"NUMERO_PEDIDO"			,"Numero Pedido"		,"","","","","",""})
	Aadd(_aCampoQry, {"USR_NOME"	,	"PENDENTE_APROVADOR_PC"	,"Aprovador Pc"		,"","","","","",""})
	Aadd(_aCampoQry, {"C7_EMISSAO"	,	"DATA_EMISSAO_PEDIDO"	,"Data Emiss�o Pc	"	,"","","","","",""})
	Aadd(_aCampoQry, {"C1_CODCOMP"	,	"USER_COMPRADOR"		,"C�digo Comprador"	,"","","","","",""})
	Aadd(_aCampoQry, {"Y1_NOME"		,	"NOME_COMPRADOR"		,"Comprador"			,"","","","","",""})
	Aadd(_aCampoQry, {"B1_COD"		,	"COD_PRODUTO"			,"Produto"				,"","","","","",""})
	Aadd(_aCampoQry, {"B1_DESC"		,	"DESC_PRODUTO"			,"Descri��o"			,"","","","","",""})
	Aadd(_aCampoQry, {"B1_MSBLQL"	,	"STATUS_PRODUTO"		,"Status"				,"","","","","",""})
	Aadd(_aCampoQry, {"C7_DATPRF"	,	"DATA_ENTREGA_PREVISTA"	,"Entrega Prevista"	,"","","","","",""})
	Aadd(_aCampoQry, {"F1_RECBMTO"	,	"DATA_RECEBIMENTO"		,"Data Recebimento"	,"","","","","",""})
	Aadd(_aCampoQry, {"F1_DOC"		,	"NUMERO_NF"				,"Nota"				,"","","","","",""})
	Aadd(_aCampoQry, {"F1_SERIE"	,	"NUMERO_SERIE_NF"		,"S�rie"				,"","","","","",""})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,	"DATA_EMISSAO_NF"		,"Emiss�o Nf"			,"","","","","",""})
	Aadd(_aCampoQry, {"A2_COD"		,	"COD_FORNECEDOR"		,"C�digo Forn."		,"","","","","",""})
	Aadd(_aCampoQry, {"A2_LOJA"		,	"LOJA_FORNECEDOR"		,"Loja"				,"","","","","",""})
	Aadd(_aCampoQry, {"A2_NOME"		,	"NOME_FORNECEDOR"		,"Fornecedor"			,"","","","","",""})
	Aadd(_aCampoQry, {"A2_ESTADO"	,	"UF_FORNECEDOR"			,"Estado Forn."		,"","","","","",""})
	Aadd(_aCampoQry, {"D1_VUNIT"	,	"VALOR_UNIT_NF"			,"Valor Unit�rio"		,"","","","","",""})
	Aadd(_aCampoQry, {"D1_TOTAL"	,	"VALOR_TOTAL_NF"		,"Valor TotaL"	,"","","","","",""})
	Aadd(_aCampoQry, {"C1_QUANT"	,	"QTD_SOLICITADA"		,"Qtd Solicitada"		,"","","","","",""})
	Aadd(_aCampoQry, {"D1_QUANT"	,	"QTD_NF"				,"Qtd Nota"			,"","","","","",""})
	Aadd(_aCampoQry, {"D1_QUANT"	,	"QTD_SALDO"				,"Qtd Saldo"			,"","","","","",""})
	Aadd(_aCampoQry, {"D1_QUANT"	,	"QTD_ESTOQUE_ATUAL"		,"Qtd Estoque"		,"","","","","",""})
	Aadd(_aCampoQry, {"USR_CODIGO"	,	"COD_SOLICITANTE"		,"Codigo Soli."		,"","","","","",""})
	Aadd(_aCampoQry, {"USR_NOME"	,	"NOME_SOLICITANTE"		,"Solicitante"		,"","","","","",""})
	Aadd(_aCampoQry, {"C7_ZREJAPR"	,	"STATUS_PEDIDO_COMPRA"	,"Status Pedido"		,"","","","","",""})
	Aadd(_aCampoQry, {"C7_ZREJAPR"	,	"STATUS_SOLICITACAO"	,"Status Solicita��o","","","","","",""})
	Aadd(_aCampoQry, {"A4_NOME"		,	"TRANSPORTADORA"		,"Transportadora"		,"","","","","",""})
			
	aAdd(_aParambox,{1,"Emiss�o Solicita��o De:"	,Ctod("")							,""		,""	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Emiss�o Solicita��o Ate:"	,Ctod("")							,""		,""	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Emiss�o Pedido De:"			,Ctod("")							,""		,""	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Emiss�o Pedido Ate:"		,Ctod("")							,""		,""	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Produto De:"				,Space(tamSx3("D1_COD")[1])		,""		,""		,"SB1"	,,075,.F.})
	aAdd(_aParambox,{1,"Produto At�:"				,Space(tamSx3("D1_COD")[1])		,""		,""		,"SB1"	,,075,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) 
		 Return  
	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		  
	
	If Empty(_aSelFil) 
		 Return 
	Endif
	
	_cCODFILIA	:= U_Array_In(_aSelFil)

 	cQryTipPro	:= "SELECT ' ' as X5_CHAVE, 'Sem Tipo Produto' as X5_DESCRI FROM DUAL UNION ALL "
	cQryTipPro	+= "SELECT DISTINCT X5_CHAVE, X5_DESCRI"
	cQryTipPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5")  ) + " TMPSX5 "
	cQryTipPro	+= "  WHERE  TMPSX5.X5_TABELA  = '02' " 
	cQryTipPro	+= "  AND    TMPSX5.D_E_L_E_T_ = ' '  " 
	cQryTipPro	+= "  ORDER BY X5_CHAVE"
	aCpoTipPro	:=	{	{ "X5_CHAVE"	,U_X3Titulo("X5_CHAVE")	,TamSx3("X5_CHAVE")[1]		} ,;
	aCpoTipPro	:=		{ "X5_DESCRI"	,U_X3Titulo("X5_DESCRI")	,TamSx3("X5_DESCRI")[1] }	} 
	cTitTipPro	:= "Marque os Tipos de Produtos � serem listados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 	
	cCodTipPro	:= U_Array_In( U_MarkGene(cQryTipPro, aCpoTipPro, cTitTipPro, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	//=== ESCOLHER SOLICITANTES A SEREM LISTADOS 
	cQryMotivo	:= "SELECT          ' N�o Informado' as ID, ' ' as USR_CODIGO, '" +SPACE(50)+ "' as USR_NOME FROM DUAL UNION ALL "	
	cQryMotivo	+= "SELECT  DISTINCT USR_ID as ID , USR_CODIGO ,  USR_NOME  "
	cQryMotivo  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", "SYS_USR") + " TMPSYS_USR  " 
	cQryMotivo	+= "  WHERE TMPSYS_USR.D_E_L_E_T_ = ' ' " 
	cQryMotivo	+= "  ORDER BY ID, USR_NOME"
	aCpoMotivo	:=	{	{ "ID"	    	,"ID SOLICITANTE "		, 14 + 50	}	,;
						{ "USR_CODIGO","CODIGO SOLICITANTE"		, 040		} 	,;
						{ "USR_NOME"	,"NOME SOLICITANTE"		,50 		}	 } 
	cTitMotivo	:= "Motivos a serem listados: "
	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: A6_COD
							//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene.
							//.T. no _lCancProg, ap�s a Markgene, indica que realmente foi teclado o bot�o cancelar e que devo abandonar o programa. 
							//.F. no _lCancProg, ap�s a Markgene, indica que realmente n�o foi teclado o bot�o cancelar ou que mesmo ele teclado, n�o devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca��o dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene
	_cMotivos	:= U_Array_In( U_MarkGene(cQryMotivo, aCpoMotivo, cTitMotivo, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_COMPRAS_COMPRASPENDENTEGRADE"  )	+ CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_FILIAL IN "                	+ _cCODFILIA	                           ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	_cQuery += U_WhereAnd( !empty(_aRet[1] ),      " DATA_EMISSAO_SC_FILTRO BETWEEN '" 	+ _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " DATA_EMISSAO_PEDIDO_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),      " COD_PRODUTO BETWEEN '" 		+ _aRet[5]  + "' AND '" + _aRet[6] + "' " ) //NAO OBRIGATORIO

	If Empty( _cMotivos )
		_cQuery +=  ""		// N�o incrementa a clausula Where
	ElseIF AT("' '", _cMotivos ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( ID_SOLICITANTE_FILTRO IS NULL OR ID_SOLICITANTE_FILTRO IN " + _cMotivos + " )"            )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   ID_SOLICITANTE_FILTRO IN " + _cMotivos	                                               )	
	Endif
	
	If Empty( cCodTipPro )
		_cQuery +=  ""		// N�o incrementa a clausula Where
	ElseIF AT("' '", cCodTipPro ) <> 0
		_cQuery += U_WhereAnd(  .T. ,             " ( COD_TIPO_PRODUTO IS NULL OR COD_TIPO_PRODUTO IN " + cCodTipPro + " )"         )
	Else	
		_cQuery += U_WhereAnd(  .T. ,             " COD_TIPO_PRODUTO IN " + cCodTipPro	                                            )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

