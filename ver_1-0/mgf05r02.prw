#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R02	�Autor  � Geronimo Benedito Alves																	�Data �  24/04/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Relat�rio de Devolu��o					(M�dulo 05-FAT)			   ���
//���			� Os dados sao obtidos e mostrados na tela atraves da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Relat�rio de Devolu��o"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Relat�rio de Devolu��o"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relat�rio de Devolu��o"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relat�rio de Devolu��o"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01				02										03						04	 05	  06	07		08	09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"EMPRESA"								,"C�d. Empresa"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NM_EMPRESA"							,"Nome Empresa"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_TIPO"		,"TIPO_PED"								,"Tipo Pedido"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"N_NF"									,"N� Nota Fiscal"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"SERIE_NF"								,"Serie NF"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_FORNECE"	,"COD_CLIENTE			as COD_CLIENT", "C�d. Cliente"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_LOJA"		,"LJ_CLIENTE"							,"Loja"					,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE			as CNPJCLIENT"	,"CPF/CNPJ Client"		,"C"	,18	,000,"@!"	,""	,"@!"})
	Aadd(_aCampoQry, {"A1_NOME"		,"NM_CLIENTE"							,"Nome Cliente"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_CODIGO"	,"N_RAMI"								,"N� RAMI"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAU_MOTIVO"	,"MOTIVO"								,"Motivo"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAU_JUSTIF"	,"JUSTIFICATIVA			as JUSTIFICAT"	,"Justificativa"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAW_DIRECI"	,"DIRECIONAMENTO		as DIRECIONAM"	,"Direcionamento"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"XXZAVSTATU"	,"STATUS_OCORRENCIA		as STATUSOCOR"	,"Status Ocorrencia"	,"C"	,20	,000,""		,""	,""	})
	Aadd(_aCampoQry, {"XXZAVREVEN"	,"REVENDA"								,"Revenda"				,"C"	,03	,000,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO"							,"Data Emissao"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DTDIGIT"	,"DT_DIGITACAO			as DT_DIGITAC"	,"Data Digita��o"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DTLANC"	,"DT_LANCAMENTO			as DT_LANCAME"	,"Data Lan�amento"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_COD"		,"COD_SKU"								,"C�d. SKU"				,""		,	, 	,""		,""	,""	})
	AAdd(_aCampoQry, {"B1_DESC"		,"NM_SKU"								,"Nome SKU"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_QUANT"	,"QTDE_DEVOLV 			as QTDEDEVOLV"	,"Qtde Devolvida"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_VUNIT"	,"VLR_UNIT"								,"Vlr. Unit�rio"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_TOTAL"	,"VLR_TOTAL"							,"Vlr. Total"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D1_NFORI"	,"N_NF_ORIGEM 			as NF_ORIGEM"	,"N� NF Origem"			,""		,	, 	,""		,""	,""	})
	AAdd(_aCampoQry, {"D1_SERIE"	,"SERIE_NF_ORIGEM		as SERIE_ORIG"	,"S�rie Origem"			,""		,	, 	,""		,""	,""	})
	AAdd(_aCampoQry, {"D2_PEDIDO"	,"N_PEDIDO_ORIGEM		as PEDIDO_ORI"	,"N� Pedido Origem"		,""		,	, 	,""		,""	,""	}) 
	Aadd(_aCampoQry, {"D1_ITEMORI"	,"SKU_ORIGEM"							,"SKU Origem", 			""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_VEND1"	,"COD_VENDEDOR			as COD_VENDED"	,"C�d. Vendedor", 		""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NM_VENDEDOR			as NOM_VENDED"	,"Nome Vendedor", 		""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_QUANT"	,"QTDE_NF_ORIGEM 		as QTNFORIGEM"	,"Qtde NF Origem"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_PRCVEN"	,"VLR_UNIT_NF_ORIGEM 	as VLRNFORIGE"	,"Vlr. Unit. NF Origem"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,"VLR_TOTAL_NF_ORIGEM 	as VLRTOTALNF"	,"Vlr. Total NF Origem"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZBG_DESCRI"	,"NM_REGIONAL			as NMREGIONAL"	,"Nome Regional"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZBG_REPRES"	,"COD_GERENTE			as COD_GERENT"	,"C�d. Gerente"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NM_GERENTE"							,"Nome Gerente"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"DAK_TRANSP"	,"COD_TRASPORTADOR		as CODTRANSPO"	,"C�d. Transportadora"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A4_NOME"		,"NM_TRANSPORTADOR		as NOMTRANSPO"	,"Nome Transportadora"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"DAK_SEQCAR"	,"N_OE"									,"N� OE"				,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"DA3_PLACA"	,"N_PLACA"								,"Placa do Ve�culo"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZIDEND"	,"COD_REGIAO"							,"C�d. da Regi�o"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_DESCREG"	,"NM_REGIAO"							,"Nome da Regi�o"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZBD_DESCRI"	,"DIRETORIA"							,"Diretoria"			,""		,	, 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Emiss�o Inicial"	,Ctod("")						,""	,""													,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Emiss�o Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emiss�o')"	,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Digita��o Inicial"	,Ctod("")						,""	,""													,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data Digita��o Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Data Digita��o')"	,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])		,""	,""													,"CLI"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Cliente')"	,"CLI"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"	,Space(tamSx3("D1_COD")[1])		,""	,""													,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Final"		,Space(tamSx3("D1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Cod. Produto')"	,"SB1"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Gerente Inicial"	,Space(tamSx3("ZBG_REPRES")[1])	,""	,""													,"ZBG90",""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Gerente Final"		,Space(tamSx3("ZBG_REPRES")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod. Gerente')"	,"ZBG90",""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Inicial"	,Space(tamSx3("C5_VEND1")[1])	,""	,""													,"SA3"	,""	,050,.F.})
	aAdd(_aParambox,{1,"Cod. Vendedor Final"	,Space(tamSx3("C5_VEND1")[1])	,""	,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'Cod. Vendedor')"	,"SA3"	,""	,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Emiss�o Inicial, n�o pode ser maior que a data de Emiss�o Final.")
		Return.F.
	Endif
	If _aRet[3] > _aRet[4]
		MsgStop("A Data de Digita��o Inicial, n�o pode ser maior que a data de Digita��o Final.")
		Return.F.
	Endif
//===		S E L E C I O N A	M O T I V O
	cQryMotivo	:= " SELECT '" +SPACE(TamSx3("ZAU_MOTIVO")[1])+ "' AS ZAS_DESCRI, '" +SPACE(TamSx3("ZAS_CODIGO")[1])+ "' AS ZAS_CODIGO, 'N�o Informado' as OBSERVACAO FROM DUAL UNION ALL "
	cQryMotivo	+= " SELECT ZAS_DESCRI || '                                        ' AS ZAS_DESCRI, ZAS_CODIGO, ' ' AS OBSERVACAO "  // Ao ZAS_DESCRI somo mais 40 espacos para ficar do tamanho do ZAU_MOTIVO 
	cQryMotivo  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("ZAS")) + " TMPZAS " 
	cQryMotivo	+= "  WHERE TMPZAS.ZAS_FILIAL = '" +xFilial("ZAS")+  "' AND TMPZAS.D_E_L_E_T_ = ' ' " 
	cQryMotivo	+= "  ORDER BY ZAS_CODIGO " 

	aCpoMotivo	:=	{	{"ZAS_DESCRI"		,U_X3Titulo("ZAS_DESCRI")	,TamSx3("ZAS_DESCRI")[1] + 40	}	,;
	 					{"ZAS_CODIGO"		,U_X3Titulo("ZAS_CODIGO")	,TamSx3("ZAS_CODIGO")[1]	}	,; 
						{ "OBSERVACAO"		,"Obs."						,13 + 30 				}   } 
	cTituMotiv	:= "Marque op��o do Motivo a serem listado: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZAS_DESCRI
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene.
	//.T. no _lCancProg, ap�s a Markgene, indica que realmente foi teclado o bot�o cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap�s a Markgene, indica que realmente n�o foi teclado o bot�o cancelar ou que mesmo ele teclado, n�o devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca��o dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene
	cMotivoPro	:= U_Array_In( U_MarkGene(cQryMotivo, aCpoMotivo, cTituMotiv, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif	

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_FAT_RELATORIODEVOLUCAO") +CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " EMPRESA IN "                   + _cCODFILIA                               )	// OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DT_EMISSAO_FILTRO BETWEEN '"   + _aRet[1]  + "' AND '" + _aRet[2]  + "' " )	// OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " DT_DIGITACAO_FILTRO BETWEEN '" + _aRet[3]  + "' AND '" + _aRet[4]  + "' " )	// OBRIGATORIO, SEM TRAVA DE DATA
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " COD_CLIENTE BETWEEN '"         + _aRet[5]  + "' AND '" + _aRet[6]  + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " COD_SKU BETWEEN '"             + _aRet[7]  + "' AND '" + _aRet[8]  + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),   " COD_GERENTE BETWEEN '"         + _aRet[9]  + "' AND '" + _aRet[10] + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[12] ),   " COD_VENDEDOR BETWEEN '"        + _aRet[11] + "' AND '" + _aRet[12] + "' " )	// N�O OBRIGATORIO
	If empty(cMotivoPro)
		_cQuery +=  ""		// N�o incrementa a clausula Where
	ElseIF AT("' '", cMotivoPro ) <> 0
		_cQuery += U_WhereAnd( .T. ,             " ( MOTIVO IS NULL OR MOTIVO IN " + cMotivoPro + " )"                       )
	Else	
		_cQuery += U_WhereAnd( .T. ,             " MOTIVO IN " + cMotivoPro	                                                 )	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN

