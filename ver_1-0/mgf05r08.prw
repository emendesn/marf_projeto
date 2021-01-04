#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R08	�Autor  � Geronimo Benedito Alves																	�Data �  10/08/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Devolucao NF Entrada   (Modulo 05-FAT)                             ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R08()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Devolucao NF Entrada"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Devolucao NF Entrada"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Devolucao NF Entrada"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Devolucao NF Entrada"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	// 1-Campo Base (existente no SX3), 2-Nome campo, 3-Titulo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture P/ Transform, 8-Apelido, 9-PictVar, 
	// O nome do campo esta no elemento 2, mas, se � usado alguma funcao (Sum,Count,max,Coalesc,etc), ou o nome do campo tem mais de 10 letras �  
	// dado a ele um apelido indicado pela clausula "as" que sera transportado para o elemento 8.
	// Se o campo do elemento 1 existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos do Array, nao precisando declara-los.		
	// As unicas excecoes sao os elemento 2-Nome campo que sempre deve ser declarado, e o campo 3-Titulo, que se no array _aCampoQry, estiver preenchido,
	// � preservado, nao sendo sobreposto pelo X3_DESCRIC 
	//					01			 02						 03							 	04		 05	 06	 07		 08	 09
	Aadd(_aCampoQry, {"F1_FILIAL"	,"EMPRESA"				,"Codigo Filial"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NM_EMPRESA"			,"Nome Filial"					,"C"	,40	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_TIPO"		,"TIPO_PED"				,"Tipo Pedido"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"N_NF"					,"N� NF"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"SERIE_NF"				,"Serie NF"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_FORNECE"	,"COD_CLIENTE"			,"Cod Cliente"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_LOJA"		,"LJ_CLIENTE"			,"Loja Cliente"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE"			,"CNPJ Cliente"					,"C"	,22	,0	,"@!"	,""		,"@!" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NM_CLIENTE"			,"Nome Cliente"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_ZRAMI"	,"N_RAMI"				,"N� Rami"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_ZDESCMO"	,"MOTIVO"				,"Motivo"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_ZDESCJU"	,"JUSTIFICATIVA"		,"Justificativa"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO"			,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_DTDIGIT"	,"DT_DIGITACAO"			,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"F1_DTLANC"	,"DT_LANCAMENTO"		,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_COD"		,"COD_SKU"				,"Codigo SKU"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"NM_SKU"				,"Nome SKU"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_QUANT"	,"QTDE_DEVOLV"			,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_VUNIT"	,"VLR_UNIT"				,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_TOTAL"	,"VLR_TOTAL"			,""								,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_NFORI"	,"N_NF_ORIGEM"			,"NF Origem"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_SERIE"	,"SERIE_NF_ORIGEM"		,"Serie NF Origem"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_PEDIDO"	,"N_PEDIDO_ORIGEM"		,"Pedido Origem"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D1_ITEMORI"	,"SKU_ORIGEM"			,"Item Origem"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"C5_VEND1"	,"COD_VENDEDOR"			,"Cod. Vendedor"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NM_VENDEDOR"			,"Nome Vendedor"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_QUANT"	,"QTDE_NF_ORIGEM"		,"QTD NF Origem"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_PRCVEN"	,"VLR_UNIT_NF_ORIGEM"	,"Valor Unit.NF Origem"			,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,"VLR_TOTAL_NF_ORIGEM"	,"Valor do Item NF Origem"		,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZBG_DESCRI" 	,"NM_REGIONAL"			,"Nome Regional"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZBG_REPRES"	,"COD_GERENTE"			,"Cod. Gerente"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NM_GERENTE"			,"Nome Gerente"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"DAK_TRANSP"	,"COD_TRASPORTADOR"		,"Cod Transportador"			,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"A4_NOME"		,"NM_TRANSPORTADOR"		,"Nome Transportador"			,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"XXDAKSEQCA"	,"N_OE"					,"N� OE"						,"C"	,10	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"DA3_PLACA"	,"N_PLACA"				,"Placa"						,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZP_CODREG"	,"COD_REGIAO"			,"Cod Regiao"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZP_DESCREG"	,"NM_REGIAO"			,"Nome Regiao"					,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZAW_MOTAFE"	,"MOTIVO_AFERIDO"		,"Motivo Aferido"				,""		,""	,""	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZAW_RESPAF"	,"RESPONSAVEL_AFERICAO"	,"Responsavel pela Afericao"	,""		,""	,""	,""		,""		,""	})

	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"	,Space(tamSx3("A1_COD")[1])		,""		,""													,"CLI"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final:"	,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Cod. Cliente')"	,"CLI"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. SKU Inicial:"		,Space(tamSx3("D1_COD")[1])		,""		,""													,"SB1"	,,075,.F.})
	aAdd(_aParambox,{1,"Cod. SKU Final:"		,Space(tamSx3("D1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. SKU')"		,"SB1"	,,075,.F.})
	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Emissao')"	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Digitacao Inicial"	,Ctod("")						,""		,""													,""		,,050,.F.})
	aAdd(_aParambox,{1,"Data Digitacao Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Data Digitacao')"	,""		,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Gerente Inicial:"	,Space(tamSx3("C5_VEND1")[1])	,""		,""													,"SA3"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Gerente Final:"	,Space(tamSx3("C5_VEND1")[1])	,""		,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod. Gerente')"	,"SA3"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Inicial:"	,Space(tamSx3("C5_VEND1")[1])	,""		,""													,"SA3"	,,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Final:"	,Space(tamSx3("C5_VEND1")[1])	,""		,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'Cod. Vendedor')"	,"SA3"	,,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

//--COMBO DE MOTIVO
//SELECT ZAS_DESCRI
// FROM PROTHEUS.ZAS010 
//WHERE D_E_L_E_T_ <> '*'

	//===		S E L E C I O N A	M O T I V O 
	cQryMotivo	:= "SELECT          ' Nao Informado' as CODIGO, '" +SPACE(TamSx3("ZAS_DESCRI")[1])+ "' as ZAS_DESCRI FROM DUAL UNION ALL "	// Coloco um espaco no come�o de " Nao Informado" para este registro aparecer na 1� linha do Browse 
	cQryMotivo	+= "SELECT DISTINCT '.             ' as CODIGO,  ZAS_DESCRI "
	cQryMotivo  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZAS")) + " TMPZAS " 
	cQryMotivo	+= "  WHERE TMPZAS.D_E_L_E_T_ = ' ' " 
	cQryMotivo	+= "  ORDER BY CODIGO, ZAS_DESCRI"
	aCpoMotivo	:=	{	{ "CODIGO"	    ,". "		    , 14 + 50	}	,;
						{ "ZAS_DESCRI"	,"Motivo Rami"	,TamSx3("ZAS_DESCRI")[1] 		}	 } 
	cTitMotivo	:= "Motivos a serem listados: "
	nPosRetorn	:= 2		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cMotivos	:= U_Array_In( U_MarkGene(cQryMotivo, aCpoMotivo, cTitMotivo, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_RELATORIODEVOLUCAONFE"  )	+ CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " EMPRESA IN "                	+ _cCODFILIA	                           ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " COD_CLIENTE BETWEEN '" 		+ _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " COD_SKU BETWEEN '" 			+ _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " DT_EMISSAO_FILTRO BETWEEN '" 	+ _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),      " DT_DIGITACAO_FILTRO BETWEEN '" + _aRet[7]  + "' AND '" + _aRet[8]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),     " COD_GERENTE BETWEEN '" 		+ _aRet[9]  + "' AND '" + _aRet[10] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[12] ),     " COD_VENDEDOR BETWEEN '" 		+ _aRet[11] + "' AND '" + _aRet[12] + "' " ) //NAO OBRIGATORIO
	If Empty( _cMotivos )
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", _cMotivos ) <> 0
		_cQuery += U_WhereAnd( .T. ,                 " ( MOTIVO IS NULL OR MOTIVO IN " + _cMotivos + " )"            )
	Else	
		_cQuery += U_WhereAnd( .T. ,                 "   MOTIVO IN " + _cMotivos	                                               )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN