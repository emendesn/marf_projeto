#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R26	�Autor  � Geronimo Benedito Alves                                                               �Data �  22/08/18      ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.     � Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Receber- Status Pedidos de Venda (Modulo 06-FIN)            ���
//���          � Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso       � Cliente Global Foods                                                                                                              ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R26()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""
 
	Aadd(_aDefinePl, "Contas � Receber - Status Pedidos de Venda"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Status Pedidos de Venda"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Status Pedidos de Venda"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Status Pedidos de Venda"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02					 	 03								 04	 05	 06	07		08	09	
	Aadd(_aCampoQry, {"E2_FILIAL"	,"COD_FILIAL"					,"Cod. Filial"						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"DESC_FILIAL"					,"Nome Filial"						,"C",040,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CLIENTE"	,"COD_CLIENTE"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZQ_COD"		,"COD_REDE"						,"Cod. Rede"						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"					,"Decri��o Rede"					,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO"					,"Cod. Segmento"					,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"NOM_SEGMENTO"					,"Nome Segmento"					,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CONDPAG"	,"COD_COND_PAGAMENTO_PEDIDO"	,"Condicao Pagto Pedido"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESC_COND_PAGAMENTO_PEDIDO"	,"Descricao condicao Pagto Pedido"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E4_CODIGO"	,"COD_COND_PAGAMENTO_CLIENTE"	,"Condicao Pagto Cliente"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESC_COND_PAGAMENTO_CLIENTE"	,"Descricao condicao Pagto Cliente"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_LIBEROK"	,"STATUS_PEDIDO"				,"Status Pedido"					,"C",037,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_COD"		,"COD_PRODUTO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_UM"		,"UNIDADE_MEDIDA"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRUNIT"	,"VLR_PRECO_UNITARIO"			,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_PRCVEN"	,"VLR_PRECO_VENDA"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_VALDESC"	,"VLR_DESCONTO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QTDE_SOLICITADA"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_VALOR"	,"VLR_FATURAMENTO"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZV_DTAPR"	,"DT_APROVACAO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZV_HRAPR"	,"HR_APROVACAO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZV_CODAPR"	,"COD_APROVADOR"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZS_NOME"		,"NOM_APROVADOR"				,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZV_CODRGA"	,"COD_BLOQUEIO"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZT_DESCRI"	,"DESCRICAO_BLOQUEIO"			,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZV_DTAPR"	,"STATUS_BLOQUEIO"				,"Status Bloqueio"					,"C",026,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_VEND1"	,"COD_VENDEDOR"					,""									,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR"					,""									,""	,""	,""	,""		,""	,""	})
	
	aAdd(_aParambox,{1,"Data Aprovacao Inicial"		,Ctod("")						,""	,""														,""		,""	, 050,.F.})
	aAdd(_aParambox,{1,"Data Aprovacao Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Aprovacao' )"	,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Codigo Cliente Inicial"		,Space(tamSx3("A1_COD")[1])		,""	,""														,"CLI"	,""	, 050,.F.})													
	aAdd(_aParambox,{1,"Codigo Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	, 050,.F.})

 	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	// REDE
	cQryRede	:= " SELECT '" +SPACE(TamSx3("ZQ_COD")[1])+ "' as ZQ_COD, 'SEM REDE' as ZQ_DESCR FROM DUAL UNION ALL "
	cQryRede	+= " SELECT DISTINCT ZQ_COD, ZQ_DESCR"
	cQryRede  	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZQ") ) + " TMPSZQ " 
	cQryRede	+= "  WHERE TMPSZQ.D_E_L_E_T_ = ' ' " 
	cQryRede	+= "  ORDER BY ZQ_COD"
	aCpoRede	:=	{	{ "ZQ_COD"		,U_X3Titulo("ZQ_COD")	,TamSx3("ZQ_COD")[1]	 } ,;
	aCpoRede	:=		{ "ZQ_DESCR"	,U_X3Titulo("ZQ_DESCR")	,TamSx3("ZQ_DESCR")[1] }	} 
	cTituRede	:= "Selecione os Codigos de Rede � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cRede	:= U_Array_In( U_MarkGene(cQryRede, aCpoRede, cTituRede, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 


	// BLOQUEIO
	cQryBloque	:= " SELECT '" +SPACE(TamSx3("ZT_CODIGO")[1])+ "' as ZT_CODIGO, 'Nao  Informado' as ZT_DESCRI FROM DUAL UNION ALL "
	cQryBloque	+= " SELECT DISTINCT ZT_CODIGO, ZT_DESCRI"
	cQryBloque  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZT") ) + " TMP " 
	cQryBloque	+= "  WHERE TMP.D_E_L_E_T_ = ' ' AND ZT_MSBLQL <> '1'  " 
	cQryBloque	+= "  ORDER BY ZT_CODIGO"
	aCpoBloque	:=	{	{ "ZT_CODIGO"		,U_X3Titulo("ZT_CODIGO")	,TamSx3("ZT_CODIGO")[1]	 } ,;
	aCpoBloque	:=		{ "ZT_DESCRI"	,U_X3Titulo("ZT_DESCRI")	,TamSx3("ZT_DESCRI")[1] }	} 
	cTitBloque	:= "Selecione os Codigos de Bloqueio � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZT_CODIGO
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cBloqueio	:= U_Array_In( U_MarkGene(cQryBloque, aCpoBloque, cTitBloque, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
   
	// SEGMENTO
	cQrySegmen	:= " SELECT '" +SPACE(TamSx3("AOV_CODSEG")[1])+ "' as AOV_CODSEG, 'Nao  Informado' as AOV_DESSEG FROM DUAL UNION ALL "
	cQrySegmen	+= " SELECT DISTINCT AOV_CODSEG, AOV_DESSEG"
	cQrySegmen  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("AOV") ) + " TMP " 
	cQrySegmen	+= "  WHERE TMP.D_E_L_E_T_ = ' '  " 
	cQrySegmen	+= "  ORDER BY AOV_CODSEG"
	aCpoSegmen	:=	{	{ "AOV_CODSEG"		,U_X3Titulo("AOV_CODSEG")	,TamSx3("AOV_CODSEG")[1]	 } ,;
	aCpoSegmen	:=		{ "AOV_DESSEG"	,U_X3Titulo("AOV_DESSEG")	,TamSx3("AOV_DESSEG")[1] }	} 
	cTitSegmen	:= "Selecione os Codigos de Segmento � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: AOV_CODSEG
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cSegmento	:= U_Array_In( U_MarkGene(cQrySegmen, aCpoSegmen, cTitSegmen, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	// APROVADOR
	cQryAprova	:= " SELECT '" +SPACE(TamSx3("ZV_CODAPR")[1])+ "' as ZV_CODAPR, 'Nao  Informado' as ZS_NOME, '  Nao     ' as BLOQUEADO FROM DUAL UNION ALL "
	cQryAprova	+= " SELECT DISTINCT ZV_CODAPR, ZS_NOME, CASE WHEN ZS_MSBLQL = '1'  THEN 'BLOQUEADO' ELSE '  Nao     ' END as BLOQUEADO"
	cQryAprova  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZV") ) + " SZVTMP "
	cQryAprova  += "  LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SZS") ) + " SZSTMP ON SZVTMP.ZV_CODAPR = SZSTMP.ZS_CODIGO " 
	//cQryAprova  += "             AND SZSTMP.ZS_MSBLQL            <> '1'
	cQryAprova  += "             AND SZSTMP.D_E_L_E_T_           = ' '
	cQryAprova	+= "  WHERE SZVTMP.D_E_L_E_T_ = ' '  " 
	cQryAprova	+= "  ORDER BY ZV_CODAPR"
	aCpoAprova	:=	{	{ "ZV_CODAPR"	,U_X3Titulo("ZV_CODAPR")	,TamSx3("ZV_CODAPR")[1]	 } ,;
	aCpoAprova	:=		{ "ZS_NOME"		,U_X3Titulo("ZS_NOME")		,TamSx3("ZS_NOME")[1]    } ,; 
	aCpoAprova	:=		{ "BLOQUEADO"	,"Aprov.Bloqueado ?"		,20                      }	} 
	cTitAprova	:= "Selecione os Codigos dos Aprovadores � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZV_CODAPR
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	_cAprovado	:= U_Array_In( U_MarkGene(cQryAprova, aCpoAprova, cTitAprova, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

//WHERE V.DT_APROVACAO_FILTRO BETWEEN '20180818' AND '20180821'    
  // AND V.COD_FILIAL             IN ( '010041','010050','010022','010007','010001','020001') --OBRIGATORIO (SELECAO COMBO FILIAL)
   //AND V.COD_CLIENTE            IN ('000095','000063','000082', '000512')                   --NAO � OBRIGATORIO (DIGITAR O COD. CLIENTE)
   //AND V.COD_REDE               IN ('001',' ','014','639' )                                              --NAO OBRIGATORIO (SELECAO COMBO REDE) NOTAR OPCAO DE REDE EM BRANCO
   //AND V.COD_BLOQUEIO           IN ('000073','000015','000017','000094', '000004')
   //AND V.COD_SEGMENTO           IN ('000016','000020','000034')
   //AND COD_APROVADOR            IN ('000036','000068','000070')
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_STATUS_PEDIDOS_VENDA"  )	+ CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_FILIAL IN "                + _cCODFILIA 							 )
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DT_APROVACAO_FILTRO BETWEEN '"	+ _aRet[1] + "' AND '" + _aRet[2] + "' " )
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " COD_CLIENTE BETWEEN '" 		+ _aRet[3] + "' AND '" + _aRet[4] + "' " )
	
	If empty(_cRede)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cRede ) <> 0
		_cQuery += U_WhereAnd( .T. ,     " ( COD_REDE IS NULL OR COD_REDE IN " + _cRede + " )"  )
	Else	
		_cQuery += U_WhereAnd( .T. ,     " COD_REDE IN " + _cRede                               )	
	Endif
	
	If empty(_cBloqueio)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cBloqueio ) <> 0
		_cQuery += U_WhereAnd( .T. ,     " ( COD_BLOQUEIO IS NULL OR COD_REDE IN " + _cBloqueio + " )"  )
	Else	
		_cQuery += U_WhereAnd( .T. ,     " COD_BLOQUEIO IN " + _cBloqueio                               )	
	Endif
	
	If empty(_cSegmento)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cSegmento ) <> 0
		_cQuery += U_WhereAnd( .T. ,     " ( COD_SEGMENTO IS NULL OR COD_SEGMENTO IN " + _cSegmento + " )"  )
	Else	
		_cQuery += U_WhereAnd( .T. ,     " COD_SEGMENTO IN " + _cSegmento                               )	
	Endif
	
	If empty(_cAprovado)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", _cAprovado ) <> 0
		_cQuery += U_WhereAnd( .T. ,     " ( COD_APROVADOR IS NULL OR COD_APROVADOR IN " + _cAprovado + " )"  )
	Else	
		_cQuery += U_WhereAnd( .T. ,     " COD_APROVADOR IN " + _cAprovado                               )	
	Endif
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

