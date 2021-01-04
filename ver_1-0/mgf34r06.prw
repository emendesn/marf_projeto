#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R06	�Autor  � Geronimo Benedito Alves																	�Data �16/11/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Estoque em Transito  (Modulo 34-CTB)   							���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R06()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	Private _aSelFilORI	:= {}

	Aadd(_aDefinePl, "Contabilidade - Estoque em Transito" )	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Estoque em Transito")						//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Estoque em Transito"} )					//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Estoque em Transito"} )					//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  	
	_nInterval	:= 92											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02		  								 03							04	 05	 06	 07	 	08	 09	
	Aadd(_aCampoQry, {"D1_FILORI"	,"EMPRESA_ORIGEM       as EMPRESAORI"	,"Empresa Origem"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_EMPRESA_ORIGEM  as DESCEMPORI"	,"Descricao Empresa Origem"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_FILORI"	,"EMPRESA_DESTINO      as EMPRESADES"	,"Empresa Destino"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"DESC_EMPRESA_DESTINO as DESCEMPDES"	,"Descricao Empresa Destino",""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_NFISCAL"	,"NUM_NOTA"								,"Numero Nota"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_SERIE"	,"SERIE"								,"Serie"					,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_EMISSAO"	,"DATA_EMISSAO_NF as DTEMISSANF"		,"Data Emissao NF"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_ITEM"		,"SEQ_ITEM"								,"Item"						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_PRODUTO"	,"COD_ITEM"								,"C�d Produto"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_ITEM"							,"Descricao Produto"		,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_UM"		,"UM"									,"Unidade Medida"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_QUANT"	,"QTDE_SAIDA"							,"Quant. Saida"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_PRCUNIT"	,"VALOR_UNITARIO as VALORUNITA"			,"Valor Unit."				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_VALCONT"	,"VALOR_ITEM"							,"Valor Item"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"BM_DESC"		,"GRUPO_ESTOQUE as GRUPOESTOQ"			,"Grupo Estoque"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_CFOP"		,"CODIGO_FISCAL as CODIGOFISC"			,"Codigo Fiscal"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"X5_DESCRI"	,"DESC_CODIGO_FISCAL as DESCODFISC"		,"Descricao Codigo Fiscal"	,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_BASERET"	,"BASE_ICMS_RETIDO as BASICMSRET"		,"Base Icms Retido"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_VALICM"	,"VALOR_ICMS"							,"Valor Icms"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_CLIEFOR"	,"CLIENTE"								,"Cliente"					,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F3_LOJA"		,"LOJA"									,"Loja"						,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_CHVNFE"	,"CHAVE_SEFAZ as CHAVESEFAZ"			,"Chave Sefaz"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"FT_ENTRADA"	,"DATA_ENTRADA as DATAENTRAD"			,"Data Entrega"				,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"SD1.D1_DTDIGIT AS DTDIGDEVOL"			,"Data Devolucao"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_DOC"		,"SD1.D1_DOC     AS NFDEVOLUCA"			,"N� nf Devolucao"			,""	,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_SERIE"	,"SD1.D1_SERIE   AS SERIEDEVOL"			,"Serie nf Devolucao"		,""	,""	,""	,""		,""	,""	})
	//	  				01			 02		  								 03							04	 05	 06	 07	 	08	 09	

	aAdd(_aParambox,{1,"Data Entrada Inicial"	,Ctod("")	,""	,""												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Entrada Final"		,Ctod("")	,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"	,""		,"",050,.T.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	// Selecionar as empresas de ORIGEM das NFs de entrada
	MsgInfo("Selecione as EMPRESAS DE ORIGEM das Notas Fiscais de Entrada. ")
	AdmSelecFil("", 0 ,.F.,@_aSelFilORI,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFilORI  
	If Empty(_aSelFilORI) ; Return ; Endif
	cCODFILORI	:= U_Array_In(_aSelFilORI)

	// Selecionar as empresas de DESTINO das trasnferencias
	//MsgInfo("Selecione as EMPRESAS DE DESTINO das Notas Fiscais de Entrada. ")
	//AdmSelecFil("", 0 ,.F.,@_aSelFilDES,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFilDES  
	//If Empty(_aSelFilDES) ; Return ; Endif
	//cCODFILDES	:= U_Array_In(_aSelFilDES)
	
	// Selecionar as empresas de DESTINO das trasnferencias
	cQryEmpDes	:= "SELECT DISTINCT M0_CODFIL, M0_FILIAL"
	cQryEmpDes  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", "SYS_COMPANY"  ) + " TMPSYSCOMPANY "
	cQryEmpDes	+= "  WHERE TMPSYSCOMPANY.D_E_L_E_T_ = ' ' "
	cQryEmpDes	+= "  ORDER BY M0_CODFIL"
	aCpoEmpDes	:=	{	{ "M0_CODFIL"	, "Codigo Empresa"		,15		} ,;
	aCpoEmpDes	:=		{ "M0_FILIAL"	, "Descricao Empresa"	,40 }	} 
	cTitEmpDes	:= "Marque as empresas de destino das Transferencias "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 	//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene 
	_lInComAll	:= .T. 	//Se for .T. Indica que se na tela de MarkGene, usuario, marcar todos os itens, eles todos retornar�o dentro da clausula IN. Se for .F. indica que se todos os itens forem marcados, retorna vazio nao criando a cla�sula IN.
	While .T.
		cCODFILDES	:= U_Array_In( U_MarkGene(cQryEmpDes, aCpoEmpDes, cTitEmpDes, nPosRetorn, @_lCancProg ,_lInComAll ) )
		If _lCancProg
			Return
		Endif       
		If Empty(cCODFILDES)
			MsgStop("� obrigatorio a selecao de ao menos uma Empresa")
			Loop
		Else
			Exit
		Endif
	Enddo

	_cQuery	:= " " + CRLF			// Limpa a parte j� criada da query para recria-la come�ando por " SELECT DISTINCT T.EMPRESA_ORIGEM ,EMPRESA_DESTINO ...."
	_cQuery	+= " SELECT DISTINCT T.EMPRESA_ORIGEM  as EMPRESAORI "                                                    + CRLF
	_cQuery	+= "      , T.DESC_EMPRESA_ORIGEM      as DESCEMPORI "                                                    + CRLF  //NOVO CAMPO
	_cQuery	+= "      , T.EMPRESA_DESTINO          as EMPRESADES "                                                    + CRLF
	_cQuery	+= "      , T.DESC_EMPRESA_DESTINO     as DESCEMPDES "                                                    + CRLF  //NOVO CAMPO
	_cQuery	+= "      , T.NUM_NOTA "                                                                                  + CRLF
	_cQuery	+= "      , T.SERIE "                                                                                     + CRLF
	_cQuery	+= "      , T.DATA_EMISSAO_NF as DTEMISSANF"                                                              + CRLF
	_cQuery	+= "      , T.SEQ_ITEM "                                                                                  + CRLF
	_cQuery	+= "      , T.COD_ITEM "                                                                                  + CRLF
	_cQuery	+= "      , T.DESC_ITEM "                                                                                 + CRLF
	_cQuery	+= "      , T.UM "                                                                                        + CRLF
	_cQuery	+= "      , T.QTDE_SAIDA "                                                                                + CRLF
	_cQuery	+= "      , T.VALOR_UNITARIO as VALORUNITA"                                                               + CRLF
	_cQuery	+= "      , T.VALOR_ITEM "                                                                                + CRLF
	_cQuery	+= "      , T.GRUPO_ESTOQUE as GRUPOESTOQ"                                                                + CRLF
	_cQuery	+= "      , T.CODIGO_FISCAL as CODIGOFISC"                                                                + CRLF
	_cQuery	+= "      , T.DESC_CODIGO_FISCAL as DESCODFISC"                                                           + CRLF
	_cQuery	+= "      , T.BASE_ICMS_RETIDO as BASICMSRET"                                                             + CRLF
	_cQuery	+= "      , T.VALOR_ICMS "                                                                                + CRLF
	_cQuery	+= "      , T.CLIENTE "                                                                                   + CRLF
	_cQuery	+= "      , T.LOJA "                                                                                      + CRLF
	_cQuery	+= "      , T.CHAVE_SEFAZ as CHAVESEFAZ"                                                                  + CRLF
	_cQuery	+= "      , T.DATA_ENTRADA as DATAENTRAD"                                                                 + CRLF
	_cQuery	+= "      , SD1.D1_DTDIGIT    AS DTDIGDEVOL "                                                             + CRLF
	_cQuery	+= "      , SD1.D1_DOC        AS NFDEVOLUCA "                                                             + CRLF
	_cQuery	+= "      , SD1.D1_SERIE      AS SERIEDEVOL "                                                             + CRLF
	_cQuery	+= "      ,  ' ' as X "                                                                                   + CRLF
	_cQuery	+= "   FROM (  "                                                                                          + CRLF
	_cQuery	+= "         SELECT LIVRO.F3_FILIAL                         AS EMPRESA_ORIGEM "                           + CRLF
	_cQuery	+= "              , EMPO.M0_FILIAL							AS DESC_EMPRESA_ORIGEM "                      + CRLF
	//_cQuery	+= "              , ED.M0_CODFIL                            AS EMPRESA_DESTINO "                          + CRLF
	_cQuery	+= "              , LTRIM(RTRIM(ED.M0_CODFIL))              AS EMPRESA_DESTINO "                          + CRLF
	_cQuery	+= "              , ED.M0_FILIAL                            AS DESC_EMPRESA_DESTINO
	_cQuery	+= "              , LIVRO.F3_NFISCAL                        AS NUM_NOTA "                                 + CRLF
	_cQuery	+= "              , LIVRO.F3_SERIE                          AS SERIE "                                    + CRLF
	_cQuery	+= "              , TO_CHAR( "                                                                            + CRLF
	_cQuery	+= "                                  TO_DATE( "                                                          + CRLF
	_cQuery	+= "                                          CASE  "                                                     + CRLF
	_cQuery	+= "                                                WHEN LIVRO.F3_EMISSAO = ' ' "                         + CRLF
	_cQuery	+= "                                                    THEN NULL "                                       + CRLF
	_cQuery	+= "                                                ELSE LIVRO.F3_EMISSAO "                               + CRLF
	_cQuery	+= "                                            END, 'YYYY/MM/DD' "                                       + CRLF
	_cQuery	+= "                                          ) "                                                         + CRLF
	_cQuery	+= "                                )                       AS DATA_EMISSAO_NF "                          + CRLF
	_cQuery	+= "              , L_ITEM.FT_ITEM                          AS SEQ_ITEM "                                 + CRLF
	_cQuery	+= "              , L_ITEM.FT_PRODUTO                       AS COD_ITEM "                                 + CRLF
	_cQuery	+= "              , SB1.B1_DESC                             AS DESC_ITEM "                                + CRLF
	_cQuery	+= "              , SB1.B1_UM                               AS UM  "                                      + CRLF
	_cQuery	+= "              , L_ITEM.FT_QUANT                         AS QTDE_SAIDA "                               + CRLF
	_cQuery	+= "              , L_ITEM.FT_PRCUNIT                       AS VALOR_UNITARIO "                           + CRLF
	_cQuery	+= "              , L_ITEM.FT_VALCONT                       AS VALOR_ITEM "                               + CRLF
	_cQuery	+= "              , GPP.BM_DESC                             AS GRUPO_ESTOQUE "                            + CRLF
	_cQuery	+= "              , L_ITEM.FT_CFOP                          AS CODIGO_FISCAL "                            + CRLF
	_cQuery	+= "              , ( "                                                                                   + CRLF
	_cQuery	+= "                  SELECT SX5.X5_DESCRI "                                                              + CRLF
	_cQuery	+= "                    FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5") ) + " SX5 "                   + CRLF
	_cQuery	+= "                   WHERE SX5.X5_CHAVE    = L_ITEM.FT_CFOP "                                           + CRLF
	_cQuery	+= "                     AND SX5.X5_TABELA   = '13'  "                                                    + CRLF
	_cQuery	+= "                     AND SX5.D_E_L_E_T_  <>  '*' "                                                    + CRLF
	_cQuery	+= "                )                                       AS DESC_CODIGO_FISCAL "                       + CRLF
	_cQuery	+= "              , LIVRO.F3_BASERET                        AS BASE_ICMS_RETIDO "                         + CRLF
	_cQuery	+= "              , L_ITEM.FT_VALICM                        AS VALOR_ICMS "                               + CRLF
	_cQuery	+= "              , LIVRO.F3_CLIEFOR                        AS CLIENTE "                                  + CRLF
	_cQuery	+= "              , LIVRO.F3_LOJA                           AS LOJA "                                     + CRLF
	_cQuery	+= "              , L_ITEM.FT_CHVNFE                        AS CHAVE_SEFAZ "                              + CRLF
	_cQuery	+= "              , ENTRADA.FT_ENTRADA											 AS DATA_ENTRADA "        + CRLF
	_cQuery	+= "              , CASE "                                                                                + CRLF
	_cQuery	+= "                     WHEN LIVRO.F3_OBSERV LIKE '%DENEGADA%' OR LIVRO.F3_OBSERV LIKE '%CANCELADA%' "   + CRLF
	_cQuery	+= "                          THEN 'Cancelada' "                                                          + CRLF
	_cQuery	+= "                     ELSE 'Normal' "                                                                  + CRLF
	_cQuery	+= "                END                                     AS STATUS_NF   "                              + CRLF
	_cQuery	+= "                , CL.A1_CGC    "                                                                      + CRLF
	_cQuery	+= "           FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SF3") ) + " LIVRO "                          + CRLF
	_cQuery	+= "           INNER JOIN " + U_IF_BIMFR( "PROTHEUS", "SYS_COMPANY" ) + " EMPO ON EMPO.M0_CODFIL = LIVRO.F3_FILIAL "               + CRLF 
	_cQuery	+= "                                                                AND EMPO.D_E_L_E_T_     <> '*' "      + CRLF
	_cQuery	+= "           INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SFT") ) + " L_ITEM ON LIVRO.F3_NFISCAL    = L_ITEM.FT_NFISCAL  " + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_SERIE      = L_ITEM.FT_SERIE "               + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_FILIAL     = L_ITEM.FT_FILIAL "              + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_CLIEFOR    = L_ITEM.FT_CLIEFOR "             + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_LOJA       = L_ITEM.FT_LOJA "                + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_EMISSAO    = L_ITEM.FT_EMISSAO "             + CRLF
	_cQuery	+= "                                            AND L_ITEM.FT_TIPOMOV   = 'S' "                           + CRLF
	_cQuery	+= "                                            AND L_ITEM.D_E_L_E_T_   <> '*' "                          + CRLF
	_cQuery	+= "           INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SA1") ) + " CL ON CL.A1_COD           = LIVRO.F3_CLIEFOR "       + CRLF
	_cQuery	+= "                                            AND CL.A1_LOJA          = LIVRO.F3_LOJA "                 + CRLF
	_cQuery	+= "                                            AND CL.D_E_L_E_T_       <> '*' "                          + CRLF
	_cQuery	+= "                                            AND CL.A1_NOME          IN ('MARFRIG GLOBAL FOODS S.A.', 'MARFRIG GLOBAL FOODS SA', 'PAMPEANO ALIMENTOS S/A', 'PAMPEANO ALIMENTOS SA', 'PAMPEANO ALIMENTOS S.A.') " + CRLF
	_cQuery	+= "           INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SB1") ) + " SB1 ON L_ITEM.FT_PRODUTO   = SB1.B1_COD  "           + CRLF
	_cQuery	+= "                                            AND SB1.D_E_L_E_T_      <>  '*' "                         + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SBM") ) + " GPP ON GPP.BM_GRUPO        = SB1.B1_GRUPO "           + CRLF
	_cQuery	+= "                                            AND GPP.D_E_L_E_T_      <> '*'         "                  + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", "SYS_COMPANY" ) + " ED ON ED.M0_CGC           = CL.A1_CGC    "                + CRLF
	_cQuery	+= "                                            AND ED.D_E_L_E_T_       <>  '*'         "                 + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SFT") ) + " ENTRADA ON ENTRADA.FT_NFISCAL  = L_ITEM.FT_NFISCAL  " + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_SERIE    = L_ITEM.FT_SERIE "               + CRLF
	//_cQuery	+= "                                            AND ENTRADA.FT_FILIAL   = ED.M0_CODFIL  "                 + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_FILIAL   = LTRIM(RTRIM(ED.M0_CODFIL))  "   + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_TIPOMOV  = 'E' "                           + CRLF
	_cQuery	+= "                                            AND ENTRADA.D_E_L_E_T_  <> '*'   "                        + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_EMISSAO  >= '" + _aRet[1] + "' "           + CRLF
	_cQuery	+= "             WHERE LIVRO.D_E_L_E_T_<>'*' "                                                               + CRLF
	_cQuery	+= "               AND LIVRO.F3_TIPO <> 'D' "                                                                + CRLF
	_cQuery	+= "               AND LIVRO.F3_ENTRADA BETWEEN  '"     + _aRet[1] + "' AND '" + _aRet[2] + "' "			  + CRLF	//_cQuery	+= "            AND LIVRO.F3_ENTRADA BETWEEN '20180901' AND '20180930' "                                  + CRLF
	// DIFERENCIA��O DE UNIDADES, POIS MARBRAND AO DAR ENTRADA � COM OUTRO CODIGO PRODUTO "		//POR ISSO, QUANDO FOR ESSAS UNIDADES NAO TER� VINCULO DE PRODUTO "   + CRLF
	_cQuery	+= "        ) T  "                                                                                        + CRLF
	_cQuery	+= "   LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SD1") ) + " SD1 ON T.NUM_NOTA       = SD1.D1_NFORI "                      + CRLF
	_cQuery	+= "                                AND T.SERIE          = SD1.D1_SERIORI "                               + CRLF
	_cQuery	+= "                                AND T.CLIENTE        = SD1.D1_FORNECE  "                              + CRLF
	_cQuery	+= "                                AND T.LOJA           = SD1.D1_LOJA "                                  + CRLF
	_cQuery	+= "                                AND T.EMPRESA_ORIGEM = SD1.D1_FILORI "                                + CRLF
	_cQuery	+= "                                AND SD1.D1_TIPO      = 'D' "                                          + CRLF 	// DEVOLU��O
	_cQuery	+= "                                AND SD1.D1_FORMUL    = 'S' "                                          + CRLF	//FORMUL�RIO PR�PRIO 
	_cQuery	+= "                                AND SD1.D_E_L_E_T_   <>  '*' "                                        + CRLF
	_cQuery	+= "  WHERE     T.STATUS_NF <> 'Cancelada' "                                                              + CRLF
	_cQuery += "        AND T.EMPRESA_ORIGEM  IN "       + cCODFILORI												  + CRLF	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += "        AND T.EMPRESA_DESTINO IN "       + cCODFILDES												  + CRLF	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery	+= " "                                                                                                    + CRLF
	_cQuery	+= "  UNION "                                                                                             + CRLF

	_cQuery	+= " SELECT DISTINCT T.EMPRESA_ORIGEM as EMPRESAORI "                                                     + CRLF
	_cQuery	+= "      , T.DESC_EMPRESA_ORIGEM     as DESCEMPORI "                                                     + CRLF
	_cQuery	+= "      , T.EMPRESA_DESTINO         as EMPRESADES "                                                     + CRLF
	_cQuery	+= "      , T.DESC_EMPRESA_DESTINO    as DESCEMPDES "                                                     + CRLF
	_cQuery	+= "      , T.NUM_NOTA "                                                                                  + CRLF
	_cQuery	+= "      , T.SERIE "                                                                                     + CRLF
	_cQuery	+= "      , T.DATA_EMISSAO_NF as DTEMISSANF"                                                              + CRLF
	_cQuery	+= "      , T.SEQ_ITEM "                                                                                  + CRLF
	_cQuery	+= "      , T.COD_ITEM "                                                                                  + CRLF
	_cQuery	+= "      , T.DESC_ITEM "                                                                                 + CRLF
	_cQuery	+= "      , T.UM "                                                                                        + CRLF
	_cQuery	+= "      , T.QTDE_SAIDA "                                                                                + CRLF
	_cQuery	+= "      , T.VALOR_UNITARIO as VALORUNITA"                                                               + CRLF
	_cQuery	+= "      , T.VALOR_ITEM "                                                                                + CRLF
	_cQuery	+= "      , T.GRUPO_ESTOQUE as GRUPOESTOQ"                                                                + CRLF
	_cQuery	+= "      , T.CODIGO_FISCAL as CODIGOFISC"                                                                + CRLF
	_cQuery	+= "      , T.DESC_CODIGO_FISCAL as DESCODFISC"                                                           + CRLF
	_cQuery	+= "      , T.BASE_ICMS_RETIDO as BASICMSRET"                                                             + CRLF
	_cQuery	+= "      , T.VALOR_ICMS "                                                                                + CRLF
	_cQuery	+= "      , T.CLIENTE "                                                                                   + CRLF
	_cQuery	+= "      , T.LOJA "                                                                                      + CRLF
	_cQuery	+= "      , T.CHAVE_SEFAZ as CHAVESEFAZ"                                                                  + CRLF
	_cQuery	+= "      , T.DATA_ENTRADA as DATAENTRAD"                                                                 + CRLF
	_cQuery	+= "      , SD1.D1_DTDIGIT    AS DTDIGDEVOL "                                                             + CRLF
	_cQuery	+= "      , SD1.D1_DOC        AS NFDEVOLUCA "                                                             + CRLF
	_cQuery	+= "      , SD1.D1_SERIE      AS SERIEDEVOL "                                                             + CRLF
	_cQuery	+= "      ,  ' ' as X "                                                                                   + CRLF
	_cQuery	+= "   FROM (  "                                                                                          + CRLF
	_cQuery	+= "         SELECT LIVRO.F3_FILIAL                         AS EMPRESA_ORIGEM "                           + CRLF
	_cQuery	+= "              , EMPO.M0_FILIAL							AS DESC_EMPRESA_ORIGEM "                      + CRLF
//	_cQuery	+= "              , ED.M0_CODFIL                            AS EMPRESA_DESTINO "                          + CRLF
	_cQuery	+= "              , LTRIM(RTRIM(ED.M0_CODFIL))              AS EMPRESA_DESTINO "                          + CRLF
	_cQuery	+= "              , ED.M0_FILIAL                            AS DESC_EMPRESA_DESTINO "                     + CRLF
	_cQuery	+= "              , LIVRO.F3_NFISCAL                        AS NUM_NOTA "                                 + CRLF
	_cQuery	+= "              , LIVRO.F3_SERIE                          AS SERIE "                                    + CRLF
	_cQuery	+= "              , TO_CHAR( "                                                                            + CRLF
	_cQuery	+= "                                  TO_DATE( "                                                          + CRLF
	_cQuery	+= "                                          CASE  "                                                     + CRLF
	_cQuery	+= "                                                WHEN LIVRO.F3_EMISSAO = ' ' "                         + CRLF
	_cQuery	+= "                                                    THEN NULL "                                       + CRLF
	_cQuery	+= "                                                ELSE LIVRO.F3_EMISSAO "                               + CRLF
	_cQuery	+= "                                            END, 'YYYY/MM/DD' "                                       + CRLF
	_cQuery	+= "                                          ) "                                                         + CRLF
	_cQuery	+= "                                )                       AS DATA_EMISSAO_NF "                          + CRLF
	_cQuery	+= "              , L_ITEM.FT_ITEM                          AS SEQ_ITEM "                                 + CRLF
	_cQuery	+= "              , L_ITEM.FT_PRODUTO                       AS COD_ITEM "                                 + CRLF
	_cQuery	+= "              , SB1.B1_DESC                             AS DESC_ITEM "                                + CRLF
	_cQuery	+= "              , SB1.B1_UM                               AS UM  "                                      + CRLF
	_cQuery	+= "              , L_ITEM.FT_QUANT                         AS QTDE_SAIDA "                               + CRLF
	_cQuery	+= "              , L_ITEM.FT_PRCUNIT                       AS VALOR_UNITARIO "                           + CRLF
	_cQuery	+= "              , L_ITEM.FT_VALCONT                       AS VALOR_ITEM "                               + CRLF
	_cQuery	+= "              , GPP.BM_DESC                             AS GRUPO_ESTOQUE "                            + CRLF
	_cQuery	+= "              , L_ITEM.FT_CFOP                          AS CODIGO_FISCAL "                            + CRLF
	_cQuery	+= "              , ( "                                                                                   + CRLF
	_cQuery	+= "                  SELECT SX5.X5_DESCRI "                                                              + CRLF
	_cQuery	+= "                    FROM " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SX5") ) + " SX5  "                   + CRLF
	_cQuery	+= "                   WHERE SX5.X5_CHAVE    = L_ITEM.FT_CFOP "                                           + CRLF
	_cQuery	+= "                     AND SX5.X5_TABELA   = '13'  "                                                    + CRLF
	_cQuery	+= "                     AND SX5.D_E_L_E_T_  <>  '*' "                                                    + CRLF
	_cQuery	+= "                )                                       AS DESC_CODIGO_FISCAL "                       + CRLF
	_cQuery	+= "              , LIVRO.F3_BASERET                        AS BASE_ICMS_RETIDO "                         + CRLF
	_cQuery	+= "              , L_ITEM.FT_VALICM                        AS VALOR_ICMS "                               + CRLF
	_cQuery	+= "              , LIVRO.F3_CLIEFOR                        AS CLIENTE "                                  + CRLF
	_cQuery	+= "              , LIVRO.F3_LOJA                           AS LOJA "                                     + CRLF
	_cQuery	+= "              , L_ITEM.FT_CHVNFE                        AS CHAVE_SEFAZ "                              + CRLF
	_cQuery	+= "              , ENTRADA.FT_ENTRADA											 AS DATA_ENTRADA "        + CRLF
	_cQuery	+= "              , CASE "                                                                                + CRLF
	_cQuery	+= "                     WHEN LIVRO.F3_OBSERV LIKE '%DENEGADA%' OR LIVRO.F3_OBSERV LIKE '%CANCELADA%' "   + CRLF
	_cQuery	+= "                          THEN 'Cancelada' "                                                          + CRLF
	_cQuery	+= "                     ELSE 'Normal' "                                                                  + CRLF
	_cQuery	+= "                END                                     AS STATUS_NF   "                              + CRLF
	_cQuery	+= "                , FO.A2_CGC    "                                                                      + CRLF
	_cQuery	+= "           FROM " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SF3") ) + " LIVRO "                           + CRLF
	_cQuery	+= "          INNER JOIN " + U_IF_BIMFR( "PROTHEUS" ,"SYS_COMPANY" ) + " EMPO ON EMPO.M0_CODFIL = LIVRO.F3_FILIAL "                + CRLF
	_cQuery	+= "                                                     AND EMPO.D_E_L_E_T_     <> '*' "                 + CRLF
	_cQuery	+= "          INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SFT") ) + " L_ITEM ON LIVRO.F3_NFISCAL    = L_ITEM.FT_NFISCAL  "  + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_SERIE      = L_ITEM.FT_SERIE "               + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_FILIAL     = L_ITEM.FT_FILIAL "              + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_CLIEFOR    = L_ITEM.FT_CLIEFOR "             + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_LOJA       = L_ITEM.FT_LOJA "                + CRLF
	_cQuery	+= "                                            AND LIVRO.F3_EMISSAO    = L_ITEM.FT_EMISSAO "             + CRLF
	_cQuery	+= "                                            AND L_ITEM.FT_TIPOMOV   = 'S' "                           + CRLF
	_cQuery	+= "                                            AND L_ITEM.D_E_L_E_T_   <> '*' "                          + CRLF
	_cQuery	+= "          INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SA2") ) + " FO ON FO.A2_COD = LIVRO.F3_CLIEFOR "                  + CRLF
	_cQuery	+= "                                            AND FO.A2_LOJA          = LIVRO.F3_LOJA "                 + CRLF
	_cQuery	+= "                                            AND FO.D_E_L_E_T_       <> '*' "                          + CRLF
	_cQuery	+= "                                            AND FO.A2_NOME          IN ('MARFRIG GLOBAL FOODS S.A.', 'MARFRIG GLOBAL FOODS SA', 'PAMPEANO ALIMENTOS S/A', 'PAMPEANO ALIMENTOS SA', 'PAMPEANO ALIMENTOS S.A.') "   + CRLF
	_cQuery	+= "          INNER JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SB1") ) + " SB1 ON L_ITEM.FT_PRODUTO   = SB1.B1_COD "             + CRLF 
	_cQuery	+= "                                            AND SB1.D_E_L_E_T_      <>  '*' "                         + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SBM") ) + " GPP ON GPP.BM_GRUPO = SB1.B1_GRUPO "                  + CRLF
	_cQuery	+= "                                            AND GPP.D_E_L_E_T_      <> '*'      "                     + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", "SYS_COMPANY" ) + " ED ON ED.M0_CGC = FO.A2_CGC "    + CRLF
	_cQuery	+= "                                            AND ED.D_E_L_E_T_       <>  '*' "                         + CRLF
	_cQuery	+= "           LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SFT") ) + " ENTRADA ON ENTRADA.FT_NFISCAL  = L_ITEM.FT_NFISCAL "  + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_SERIE    = L_ITEM.FT_SERIE "               + CRLF
//	_cQuery	+= "                                            AND ENTRADA.FT_FILIAL   = ED.M0_CODFIL  "                 + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_FILIAL   = LTRIM(RTRIM(ED.M0_CODFIL))  "   + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_TIPOMOV  = 'E' "                           + CRLF
	_cQuery	+= "                                            AND ENTRADA.D_E_L_E_T_  <> '*'   "                        + CRLF
	_cQuery	+= "                                            AND ENTRADA.FT_EMISSAO  >= '" + _aRet[1] + "' "           + CRLF //SETAR COM A DATA INICIAL DA EMISS�O
	_cQuery	+= "          WHERE LIVRO.D_E_L_E_T_<>'*' "                                                               + CRLF
	_cQuery	+= "            AND LIVRO.F3_TIPO = 'D' "                                                                 + CRLF
	_cQuery	+= "            AND LIVRO.F3_ENTRADA BETWEEN  '"     + _aRet[1] + "' AND '" + _aRet[2] + "' "			  + CRLF		//_cQuery	+= "            AND LIVRO.F3_ENTRADA BETWEEN '20180901' AND '20180930' "                                  + CRLF
    //  DIFERENCIA��O DE UNIDADES, POIS MARBRAND AO DAR ENTRADA � COM OUTRO CODIGO PRODUTO  //POR ISSO, QUANDO FOR ESSAS UNIDADES NAO TER� VINCULO DE PRODUTO
	_cQuery	+= "        ) T "                                                                                         + CRLF
	_cQuery	+= "   LEFT JOIN " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SD1") ) + " SD1 ON T.NUM_NOTA = SD1.D1_NFORI "   + CRLF
	_cQuery	+= "                                AND T.SERIE          = SD1.D1_SERIORI "                               + CRLF
	_cQuery	+= "                                AND T.CLIENTE        = SD1.D1_FORNECE  "                              + CRLF
	_cQuery	+= "                                AND T.LOJA           = SD1.D1_LOJA "                                  + CRLF
	_cQuery	+= "                                AND T.EMPRESA_ORIGEM = SD1.D1_FILORI "                                + CRLF
	_cQuery	+= "                                AND SD1.D1_TIPO      = 'D'  "                                         + CRLF	//DEVOLU��O
	_cQuery	+= "                                AND SD1.D1_FORMUL    = 'S' 	 "                                        + CRLF	//--FORMUL�RIO PR�PRIO 
	_cQuery	+= "                                AND SD1.D_E_L_E_T_   <>  '*' "                                        + CRLF
	_cQuery	+= "  WHERE T.STATUS_NF <> 'Cancelada' "                                                                  + CRLF
	_cQuery += "        AND T.EMPRESA_ORIGEM  IN "       + cCODFILORI												  + CRLF	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += "        AND T.EMPRESA_DESTINO IN "       + cCODFILDES												  + CRLF	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posicoes)

	//FILTROS:
	//EMPRESA_ORIGEM IN ('010003','010005') --COMBO DE SELE��O
	//EMPRESA_DESTINO IN ('010003','010005') --COMBO DE SELE��O
	//DATA ENTRADA BETWEEN '20180101' AND '20181001' --OBRIGATORIO / TRAVAR 3 MESES
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

