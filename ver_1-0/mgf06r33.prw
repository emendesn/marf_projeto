#INCLUDE "totvs.ch"


/*/
==============================================================================================================================================================================
{Protheus.doc} MGF06R33
Relatório que apresente o prazo médio de recebimento x faturamento por segmento e rede

@description
o prazo médio de recebimento x faturamento por segmento e rede

@author Renato Junior
@since 29/07/2020
@type Function

@table
    SE1 - titulos a receber
    SE5 - movimento bancário

@param

@return

@menu
    Financeiro-Atualizações-Especifico Marfrig-
@history
/*/
User Function MGF06R33()
	Local _cLayout  :=  ""
	Local aPergs	:= {}
	Local cSrvLog	:= ""

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	aAdd(aPergs,{3,"Layout Por"             ,1,{"Nota","Rede/Grupo"},50,"",.F.})
	If !ParamBox(aPergs ,"Layout do Relatório",_aRet)
		Help( ,, 'Relatório',, 'Processamento Cancelado', 1, 0 )
		Return
	EndIf
	_cLayout	:=	_aRet[1]
	_aRet		:= {}

	Aadd(_aDefinePl, "Contas a Receber - Movimentação de Titulos" )	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Movimentação de Titulos"	)					//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Movimentação de Titulos"} )					//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Movimentação de Titulos"} )					//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )											//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, { {||.T.} } )									//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//					01			 02									 03							 04	 05		 06	 07						 08		 09

	If _cLayout	==	2	//"Rede/Grupo"
		Aadd(_aCampoQry, {"REDE_GRUPO"	,"REDE_GRUPO							as REDE_GRUPO"	,"Rede Grupo/Cliente"       ,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"COD_PAGTO"	,"COD_PAGTO		  						as COD_PAGTO"	,"Condição Pagamento"       ,"C",020	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E5_VALOR"	,"SUM(VLR_MOVIMENTACAO)					as VLRMOVIMEN"	,"Soma Valor Movimentação"	,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		Aadd(_aCampoQry, {"E5_VALOR"	,"SUM(PONDERADO)     					as PONDERADO"	,"Soma Valor Ponderado"		,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		Aadd(_aCampoQry, {"E5_VALOR"	,"SUM(PONDERADO)/SUM(VLR_MOVIMENTACAO) 	as MEDIAPOND"	,"Media Valor Ponderada"	,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Else
		Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"						,"Cód. Filial"				,"C",006	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"						,"Nome Filial"				,"C",041	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_NUM"		,"NUM_DOCUMENTO		as NUM_DOCUME"	,"No. Documento"			,"C",009	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_PREFIXO"	,"PREFIXO"							,"Prefixo"					,"C",003	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_TIPO"		,"TIPO_TITULO 		as TP_TITULO"	,"Tipo Título"				,"C",003	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA		as NUMPARCELA"	,"Parcela"					,"C",002	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA"						,"Natureza"					,"C",010	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"						,"Data Emissão"				,"D",008	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO		as DTVENCIMEN"	,"Data Vencimento"			,"D",008	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E5_DATA"		,"DT_MOVIMENTACAO	as DTMOVIMENT"	,"Data Movimentação"		,"D",008	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_MOVIMENTACAO	as VLRMOVIMEN"	,"Valor Movimentação"		,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		Aadd(_aCampoQry, {"ALO_DESCR"	,"TIPO_MOVIMENTACAO	as TIPOMOVIME"	,"Tipo Movimentação"		,"C",017	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E5_HISTOR"	,"HIST_MOVIMENTACAO	as HISTMOVIME"	,"Histórico Movimentação"	,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_HIST"		,"OBS_TITULO"						,"Obs. Titulo"				,"C",240	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"DESMOTBAIX"	,"MOTIVO_BAIXA		as MOTIVOBAIX"	,"Motivo da Baixa"			,"C",010	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE		as CODCLIENTE"	,"Cód. Cliente"				,"C",006	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE		as NOMCLIENTE"	,"Nome Cliente"				,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE		as CNPJCLIENT"	,"CNPJ Cliente"				,"C",018	,0	,"@!"					,""		,"@!"	})
		Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO		as CODSEGMENT"	,"Código do Segmento"		,"C",006	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"AOV_DESSEG"	,"NOM_SEGMENTO		as DESCSEGMEN"	,"Descrição do Segmento"	,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"						,"Descrição Rede"			,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR		as NOMVENDEDO"	,"Nome do Vendedor"			,"C",040	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR		as CODPORTADO"	,"Código do Portador"		,"C",003	,0	,""						,""		,""	})
		AADD(_aCampoQry, {"E1_AGEDEP"	,"NUM_AGENCIA		as NUMAGENCIA"	,"No. Agencia"				,"C",005	,0	,""						,""		,""	})
		AADD(_aCampoQry, {"E1_CONTA"	,"NUM_CONTA"						,"No. Conta"				,"C",010	,0	,""						,""		,""	})
		AADD(_aCampoQry, {"E1_NUMBCO"	,"NUM_TITULO_BANCO	as NUM_TITULO"	,"No. Titulo do Banco"		,"C",015	,0	,""						,""		,""	})
		AADD(_aCampoQry, {"E1_VALOR"	,"VLR_BRUTO"						,"Valor Bruto"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		AADD(_aCampoQry, {"E1_VALOR"	,"VLR_JUROS"						,"Valor Juros"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		AADD(_aCampoQry, {"E1_SALDO"	,"VLR_SALDO_TITULO	as SALDOTITUL"	,"Valor Saldo do Titulo"	,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
		//
		Aadd(_aCampoQry, {"E5_DATA"		,"MEDIA             as MEDIA"       ,"Média"        			,"N",008	,0	,""						,""		,""	})
		Aadd(_aCampoQry, {"E5_VALOR"	,"PONDERADO         as PONDERADO"	,"Ponderado"    			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Endif
	aAdd(_aParambox,{1,"Dt Movimentação Inicial",Ctod("")					,""		,"" 													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Dt Movimentação Final"	,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Dt Movimentação')"	,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,"@!"	,"",													"CLI"	,""	,070,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final  "	,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	,070,.F.})
	aAdd(_aParambox,{1,"Cod. Rede De "			,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"",													"SZQ"	,""	,070,.F.})
	aAdd(_aParambox,{1,"Cod. Rede Até "			,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Rede')"			,"SZQ"	,""	,070,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	Do While.T.	// Laço para obrigar a marcação de ao menos um portador
		cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
		cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
		cQryPorPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6") ) + " TMPSA6 "
		cQryPorPro	+= "  WHERE TMPSA6.D_E_L_E_T_ = ' ' "
		cQryPorPro	+= "  ORDER BY A6_COD"

		aCpoPorPro	:=	{	{ "A6_COD"		,U_X3Titulo("A6_COD")	,TamSx3("A6_COD")[1]	 } ,;
			aCpoPorPro	:=		{ "A6_NOME"	,U_X3Titulo("A6_NOME")	,TamSx3("A6_NOME")[1] }	}
		cTituPorta	:= "Selecione os Códigos de Portadores a serem listados "

		nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
		//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa.
		//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro)
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
		_lInComAll	:= .T. 	//Se for .T. Indica que se na tela de MarkGene, usuário, marcar todos os itens, eles todos retornarão dentro da cláusula IN. Se for .F. indica que se todos os itens forem marcados, retorna vazio não criando a claúsula IN.
		cPortaProd	:= U_Array_In( U_MarkGene(cQryPorPro, aCpoPorPro, cTituPorta, nPosRetorn, @_lCancProg ,_lInComAll ) )

		Exit	// Mudança da lógica. Não tem mais MarkGene obrigatória. Se não marcar nenhum, ou marcar todos, prossigo e não incluo a condição no where

		//If empty(cPortaProd)
		//	MsgStop("É obrigatorio a seleçao de ao menos um portador. ")
		//	Loop		// Se nao marcou nenhum portador, dou loop ao While para marca-lo
		//Else
		//	Exit		// Se marcou ao menos um portador, dou exit neste laço e continuo o processamento da rotina
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
		cTituRede	:= "Selecione os Códigos de Rede à serem listados: "
		nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
		//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa.
		//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro)
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
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

	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene.
	//.T. no _lCancProg, após a Markgene, indica que realmente foi teclado o botão cancelar e que devo abandonar o programa.
	//.F. no _lCancProg, após a Markgene, indica que realmente não foi teclado o botão cancelar ou que mesmo ele teclado, não devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcação dos registro)
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botão cancelar da MarkGene
	cVendedor	:= U_Array_In( U_MarkGene(cQryVended, aCpoVended, cTituVende, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	If _cLayout	==	2	//"Rede/Grupo"
		_cQuery += "	FROM ( "
		_cQuery += "			SELECT A.REDE_GRUPO, COD_PAGTO, NOM_VENDEDOR, VLR_MOVIMENTACAO, PONDERADO "
	Endif

	cSrvLog	:= AllTrim(UPPER(GETENVSERVER()))

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_CR_MOVTO_TIT_NOTA_DINAMICO" )        +CRLF

	If _cLayout	==	2	//"Rede/Grupo"
		_cQuery += " A "	// ALIAS NA SUBQUERY
	Endif

	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DT_MOVIMENTACAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " COD_FILIAL IN " + _cCODFILIA	     +CRLF                                    ) //OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " COD_CLIENTE BETWEEN '"            + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NÃO OBRIGATORIO
	If empty(cPortaProd)
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery +=  ""		// Não incrementa a clausula Where
	Else
		_cQuery += U_WhereAnd( .T. ,             " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"            )
	Endif


	If !empty(_aRet[5])
		_cQuery += U_WhereAnd( !empty(_aRet[5] ),    " COD_REDE BETWEEN '"            + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NÃO OBRIGATORIO
	Else
		If empty(cRede)
			_cQuery +=  ""		// Não incrementa a clausula Where
		ElseIF AT("' '", cRede ) <> 0
			_cQuery +=  ""		// Não incrementa a clausula Where
		Else
			_cQuery += U_WhereAnd( .T. ,             " ( COD_REDE IS NULL OR COD_REDE IN " + cRede + " )"                         )
		Endif
	EndIf

	If empty(cVendedor)
		_cQuery +=  ""		// Não incrementa a clausula Where
	ElseIF AT("' '", cVendedor ) <> 0
		_cQuery +=  ""		// Não incrementa a clausula Where
	Else
		_cQuery += U_WhereAnd(  .T. , " ( COD_VENDEDOR_FILTRO IS NULL OR COD_VENDEDOR_FILTRO IN " + cVendedor + " )"                             )
	Endif

	// Filtros Fixos
	_cQuery += U_WhereAnd(  .T. , " TIPO_MOVIMENTACAO = 'PAGAMENTO' "   )	// Somente Tipo PAGAMENTO
	_cQuery += U_WhereAnd(  .T. , " TIPO_TITULO = 'NF ' "   )	// Somente Tipo NF
	_cQuery += U_WhereAnd(  .T. , " COD_NATUREZA IN ('10101','10111') "   )	// somente estas Naturezas

	If _cLayout	==	2	//"Rede/Grupo"
		_cQuery += "  ) AUX
		_cQuery += " GROUP BY AUX.REDE_GRUPO, AUX.COD_PAGTO "
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN