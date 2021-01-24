#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF04R02	�Autor  � Geronimo Benedito Alves																	�Data �23/02/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: ESTOQUE - Acompanhamento de Recebimento	(M�dulo 04-ESTOQUE)					���
//���			� Os dados sao obtidos e mostrados na tela atrav�s da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF04R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "ESTOQUE - Acompanhamento de Recebimento"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Acompanhamento de Recebimento"			)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Acompanhamento de Recebimento"}			)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Acompanhamento de Recebimento"}			)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""												

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					 01				 02										 03							 04		 05		 06		 07		08	09		
	Aadd(_aCampoQry, {	"A1_FILIAL"		,"COD_FILIAL"							,"C�d. Filial"				,""		,""		,""		,""		,""	,""	})
	Aadd(_aCampoQry, {	"A1_NOME"		,"DESC_FILIAL			as DESCFILIAL"	,"Nome Filial"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"XXF1_TIPO"		,"TIPO_OPERACAO_NF		as TIPOOPERNF"	,"Tipo de Operca��o da NF"	,"C"	,0040,   0		,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZH_AR"		,"NUM_AR"								,"N� AR"					,""		,""		,""		,""		,""	,""	})
	Aadd(_aCampoQry, {	"F1_DTLANC"		,"DT_LANCAMENTO_NF		as DTLANCAMNF"	,"Data Lan�amento NF"		,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZH_DOC"		,"NUMERO_NF"							,"N� NF"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZH_SERIE"		,"SERIE_NF"								,"S�rie NF"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"F2_DOC"		,"NF_ORIGEM"							,"NF Origem"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"F2_SERIE"		,"SERIE_NF_ORIGEM		as SERIENFORI"	,"S�rie NF Orig"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"F2_EMISSAO"	,"EMISSAO_NF_ORIGEM		as EMISSNFORI"	,"Emiss�o NF Ori"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"D1_ZRAMI"		,"NUM_RAMI"								,"C�d.Rami"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZAV_DTABER"	,"DT_ABERT_RAMI			as DTABERRAMI"	,"Data Abert. Rami"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZAW_MOTIVO"	,"MOTIVO_RAMI			as MOTIVORAMI"	,"Motivo Rami"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZAW_JUSTIF"	,"JUSTIFICATIVA_RAMI	as JUSTIFRAMI"	,"Justificativa Rami"		,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A2_COD"		,"COD_FORNECEDOR		as CODFORNECE"	,"C�d. Fornecedor"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A2_LOJA"		,"LOJA_FORNECEDOR		as LOJAFORNEC"	,"Loja Fornecedor"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A2_NOME"		,"NOME_FORNECEDOR		as NOMEFORNEC"	,"Nome Fornecedor"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_ITEM"		,"ITEM_AR"								,"Item AR"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"B1_COD"		,"COD_PRODUTO			as CODPRODUTO"	,"C�d. Produto"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"B1_DESC"		,"DESC_PRODUTO			as DESCPRODUT"	,"Descr. Produto"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_LOCAL"		,"COD_LOCAL_ARMAZ		as CODLOCALAR"	,"C�d. Local Armazem"		,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_QNF"		,"QTD_NF"								,"Qtd. NF"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"D1_VUNIT"		,"VL_UNT_NF"							,"Valor Unit. na NF"		,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"D1_TOTAL"		,"VL_TOTAL_NF			as VL_TOTALNF"	,"Valor Total Item"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_QCONT"		,"QTD_CONTADA			as QTDCONTADA"	,"Qtd. Contada"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_QCONT"		,"QTD_DIFERENCA			as QTDDIFEREN"	,"Qtd. Diferen�a"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"A4_CGC"		,"CNPJ_TRANSPORTADORA	as CNPJTRANSP"	,"CNPJ Transportadora"		,""		,0018	,0		,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {	"A4_NOME"		,"NOME_TRANSPORTADORA	as NOMETRANSP"	,"Nome da Transportadora"	,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"F1_PLACA"		,"PLACA"								,"Placa"					,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_QDEV"		,"QTD_DEVOLUCAO			as QTDDEVOLUC"	,"Qtd. Devolu��o"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_QCOMPL"	,"QTD_COMPLEMENTAR		as QTDCOMPLEM"	,"Qtd. Complementar"		,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_AJUSTE"	,"QTD_AJUSTE"							,"Qtd. Ajuste"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_DOC"		,"NF_ACERTO"							,"NF Acerto"				,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_SERIE"		,"NF_ACERTO_SERIE		as SERIE_ACER"	,"S�rie NF Acerto"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZI_TIPONF"	,"TIPO_NF_ACERTO		as TIPONFACER"	,"Tipo NF Acerto"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ZZH_CNF"		,"CERTIFICADO_SANITARIO	as CERTIFSANI"	,"Certificado Sanit�rio" 	,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"B14_MOTIVO"	,"OBS_AR"								,"Observa��o AR"			,""		,""		,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {	"ABS_DESCRI"	,"STATUS_AR"							,"Status AR"				,""		,""		,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Dt Lan�amento NF Inicial"	,Ctod("")						,""		,""													,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Lan�amento NF Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02,'Dt Lan�amento')"	,""			,"",050,.T.})
	aAdd(_aParambox,{1,"Numero AR"					,Space(tamSx3("ZZH_AR")[1])		,"@!"	,""													,"ZZH_AR"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Numero NF Entrada"			,Space(tamSx3("ZZH_DOC")[1])	,"@!"	,""													,"SF1ZZZ"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Serie NF Entrada"			,Space(tamSx3("ZZH_SERIE")[1])	,"@!"	,""													,""			,"",050,.F.}) 
	aAdd(_aParambox,{1,"Cod. Fornec. Inicial"		,Space(tamSx3("A2_COD")[1])		,""		,""													,"CF8A2"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Loja Fornec. Inicial"		,Space(tamSx3("A2_LOJA")[1])	,""		,""													,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornec. Final"			,Space(tamSx3("A2_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR06, MV_PAR08,'Cod. Fornecedor')"	,"CF8A2"	,"",050,.F.})	
	aAdd(_aParambox,{1,"Loja Fornec. Final"			,Space(tamSx3("A2_LOJA")[1])	,""		,"U_VLFIMMAI(MV_PAR07,MV_PAR09,'Loja Fornecedor')"	,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Produto Inicial"		,Space(tamSx3("C7_PRODUTO")[1])	,""		,													,"SB1"		,"",050,.F.}) 
	aAdd(_aParambox,{1,"Cod. Produto Final"			,Space(tamSx3("C7_PRODUTO")[1])	,""		,"U_VLFIMMAI(MV_PAR10,MV_PAR11,'Cod. Produto')"		,"SB1"		,"",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Lan�amento Inicial, n�o pode ser maior que a data de Lan�amento Final.")
		Return.F.
	Endif

	//===  S E L E C I O N A    T I P O   D E    O P E R A C A O     D A    N F
	// &N=Normal;C=Compl.Preco/Quantidade;I=Compl.ICMS;P=Compl.IPI;D=Dev.Compras;B=Utiliza Fornecedor									 
	cQTipOpeNF := "			  select  'N' as CAMPO_01, 'DOCTO. NORMAL'							as CAMPO_02 from dual
	cQTipOpeNF += " union all select  'C' as CAMPO_01, 'DOCTO. DE COMPL PRECO/FRETE/DESP. IMP.'	as CAMPO_02 from dual
	cQTipOpeNF += " union all select  'I' as CAMPO_01, 'DOCTO. DE COMPL ICMS'					as CAMPO_02 from dual
	cQTipOpeNF += " union all select  'P' as CAMPO_01, 'COMPL. DE IPI'							as CAMPO_02 from dual
	cQTipOpeNF += " union all select  'D' as CAMPO_01, 'DOCTO. DE DEVOLU��O'					as CAMPO_02 from dual
	cQTipOpeNF += " union all select  'B' as CAMPO_01, 'DOCTO. DE BENEFICIAMENTO'				as CAMPO_02 from dual
	aCpoTipOpe	:=	{{ "CAMPO_01"	,"Tipo"						,01	} ,;
					 { "CAMPO_02"	,"Descri��o do Tipo de NF"	,40	} } 
	cTitTipOpe	:= "Marque os Tipos de opera��es de NF � serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene.
	//.T. no _lCancProg, ap�s a Markgene, indica que realmente foi teclado o bot�o cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, ap�s a Markgene, indica que realmente n�o foi teclado o bot�o cancelar ou que mesmo ele teclado, n�o devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca��o dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o bot�o cancelar da MarkGene
	cTipoOPeNF	:= U_Array_In( U_MarkGene(cQTipOpeNF, aCpoTipOpe, cTitTipOpe, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif 
 
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_ACOMPANHAMENTO_RECEBIMENTO") +CRLF 

	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " COD_FILIAL IN " + _cCODFILIA	                                                      ) // OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	If empty(_aRet[1])  // se for Vazio
		_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " DT_LANCAMENTO_NF_FILTRO BETWEEN '  '" + " AND '" + _aRet[2] + "' "              ) // OBRIGATORIO - SEM VALIDA��O DE DATA E PRIMEIRA DATA PODE SER EM BRANCO DEVIDO AR SEM NF(SINISTRO)
	Elseif ( !empty(_aRet[1]) .and. !empty(_aRet[2]) )  // se for NaoVazio
		_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " DT_LANCAMENTO_NF_FILTRO BETWEEN '"    + _aRet[1] + "' AND '" + _aRet[2] + "' "  ) // OBRIGATORIO - SEM VALIDA��O DE DATA E PRIMEIRA DATA PODE SER EM BRANCO DEVIDO AR SEM NF(SINISTRO)
	Endif
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),   " NUM_AR LIKE '%"              + _aRet[3]   + "%' "                        )	// N�O OBRIGATORIO (USUARIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),   " NUMERO_NF LIKE '%"           + _aRet[4]   + "%' "                        )	// N�O OBRIGATORIO (USUARIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),   " SERIE_NF = '"                + _aRet[5]   + "' "                         )	// N�O OBRIGATORIO (USUARIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),   " COD_FORNECEDOR BETWEEN '"    + _aRet[6]   + "' AND '" + _aRet[8]  + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),   " LOJA_FORNECEDOR BETWEEN '"   + _aRet[7]   + "' AND '" + _aRet[9]  + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),  " COD_PRODUTO BETWEEN '"       + _aRet[10]  + "' AND '" + _aRet[11] + "' " )	// N�O OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(cTipoOPeNF),  " TIPO_OPERACAO_NF_FILTRO IN " + cTipoOPeNF	                               )	// N�O OBRIGATORIO (COMBO PARA SELECIONAR - SELECT PARA POPULAR O COMBO ABAIXO)

	_cQuery += "	ORDER BY COD_FILIAL "	+CRLF	
	_cQuery += "			,DT_LANCAMENTO_NF_FILTRO "	+CRLF
	_cQuery += "			,NUM_AR "	+CRLF

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

