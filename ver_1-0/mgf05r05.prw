#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF05R05	�Autor  � Geronimo Benedito Alves																	�Data �  29/05/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: FATURAMENTO - Rami										(Modulo 05-FAT)		   ���
//���			� Dados sao obtidos e mostrados na tela atraves da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF05R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Rami"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Rami"					)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Rami"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Rami"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  					)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }			)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03							 04	 	 05	 06	 	 07		 08	 09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"COD_FILIAL"							,"Filial"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_EMISSAO"	,"DT_EMISSAO"							,"Data Emissao"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_DOC"		,"NUM_NF"								,"NF"						,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_SERIE"	,"NUM_SERIE_NF			as NUMSERIENF"	,"Serie NF"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_NUM"		,"NUM_PEDIDO"							,"Pedido"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_CLIENTE"	,"NUM_CLIENTE			as NUMCLIENTE"	,"Cod Cliente"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_LOJA"		,"NUM_LOJA"								,"Loja Cliente"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"NUM_CNPJ"								,"CNPJ Cliente"				,""		,18	,"" 	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE			as NOMCLIENTE"	,"Nome Cliente"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR			as NOMVENDEDO"	,"Nome Vendedor"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"							,"Titulo"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA			as NUMPARCELA"	,"Parcela"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO			as DTVENCIMEN"	,"Data Vencimento"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_BAIXA"	,"DT_BAIXA"								,"Data Baixa"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"							,"Valor Titulo"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E1_SALDO"	,"VLR_SALDO"							,"Valor Saldo"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_CODIGO"	,"NUM_RAMI"								,"N� Rami"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_DTABER"	,"DT_ABERTURA_RAMI		as DTABERRAMI"	,"Data Abertura Rami"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_TIPO"	,"TIP_RAMI"								,"Tipo Rami"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_REVEND"	,"IND_REVENDA_RAMI		as INDREVRAMI"	,"Ind Revenda Rami"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"XXZAVORD01"	,"ORDEM_RETIRADA		as INDORDERET"	,"Ordem Retirada"			,"C"	,03	,00		,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_NOTA"	,"NUM_NF_RAMI			as NUMNF_RAMI"	,"NF Rami"					,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_SERIE"	,"SERIE_NF_RAMI			as SERINFRAMI"	,"Serie NF Rami"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZZH_AR"		,"NUM_AVISO_RECEBIMENTO	as AVISORECEB"	,"Aviso Recebimento"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"NUM_NF_ENTRADA		as NUMNFENTRA"	,"NF Entrada"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"SERIE_NF_ENTRADA		as SERINFENTR"	,"Serie NF Entrada"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO_NF_ENTRADA	as DTEMISNFEN"	,"Data Emissao NF Entrada"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_VALMERC"	,"VLR_NF_ENTRADA		as VLRNFENTRA"	,"Valor NF Entrada"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO_RAMI		as NPEDIDRAMI"	,"Pedido Rami"				,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_NOTA"		,"NFS_REFATURAMENTO		as NFSREFATUR"	,"NFS Refaturamento"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_SERIE"	,"SERIE_REFATURAMENTO	as SERIREFATU"	,"Serie Refaturmento"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_EMISSAO"	,"EMISSAO_REFATURAMENTO	as EMISREFATU"	,"Data Emissao Refatura"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_CLIENTE_REFAT	as CODCLIREFA"	,"C�di Cliente Refatur"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_LOJA"		,"LOJA_CLIENTE_REFAT	as LOJCLIREFA"	,"Loja Cliente Refatur"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE_REFAT	as CNPJCLIREF"	,"Cnpj Cliente Refatur"		,""		,18	,"" 	,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE_REFAT	as NOMCLIREFA"	,"Nome Cliente Refatur"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"F2_VALBRUT"	,"VLR_NF_REFAT			as VLRNFREFAT"	,"Vlr NF Refaturamento"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZAV_TIPO"	,"COD_TIP_RAMI			as CODTIPRAMI"	,"Cod. Tipo Rami"			,""		,""	, 		,""		,""	,""	})

	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"			,Space(tamSx3("A1_COD")[1])		,""	,""															,"CLI"	,""	,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Cliente Final:"			,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Cod. Cliente')"			,"CLI"	,""	,050,.F.})													
	aAdd(_aParambox,{1,"N� Rami Inicial:"				,Space(tamSx3("A1_COD")[1])		,""	,""															,""		,""	,050,.F.})													
	aAdd(_aParambox,{1,"N� Rami Final:"					,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'N� Rami')"				,""		,""	,050,.F.})													
	aAdd(_aParambox,{3,"Indicador Revenda Rami"			,Iif(Set(_SET_DELETED),4,2)		,{"S","N","NULL","TODOS" }, 100, "",.F.})
	aAdd(_aParambox,{3,"Ordem de Retirada"				,Iif(Set(_SET_DELETED),4,2)		,{"S","N","NULL","TODOS" }, 100, "",.F.})
	aAdd(_aParambox,{1,"N� Aviso Recebimento Inicial"	,Space(tamSx3("ZZH_AR")[1])		,""	,""															,""		,""	,050,.F.})													
	aAdd(_aParambox,{1,"N� Aviso Recebimento Final:"	,Space(tamSx3("ZZH_AR")[1])		,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'N� Aviso Recebimento')"	,""		,""	,050,.F.})													
	aAdd(_aParambox,{1,"N� Titulo Inicial"				,Space(tamSx3("E1_NUM")[1])		,""	,""															,""		,""	,050,.F.})													
	aAdd(_aParambox,{1,"N� Titulo Final:"				,Space(tamSx3("E1_NUM")[1])		,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'N� Titulo')"				,""		,""	,050,.F.})													
	aAdd(_aParambox,{1,"Data de Baixa Inicial"			,Ctod("")						,""	,"" 														,""		,""	,050,.F.})
	aAdd(_aParambox,{1,"Data de Baixa Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'Data de Baixa')"			,""		,""	,050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	//===		S E L E C I O N A	T I P O     R A M I
	cQryDireto	:= "SELECT 'R' as ZAV_TIPO, 'RECLAMACAO'          as DESCRICAO FROM DUAL UNION ALL "
	cQryDireto	+= "SELECT 'T' as ZAV_TIPO, 'DEVOLUCAO TOTAL'     as DESCRICAO FROM DUAL UNION ALL "
	cQryDireto	+= "SELECT 'P' as ZAV_TIPO, 'DEVOLUCAO PARCIAL'   as DESCRICAO FROM DUAL UNION ALL "
	cQryDireto	+= "SELECT 'D' as ZAV_TIPO, 'DESCONTO FINANCEIRO' as DESCRICAO FROM DUAL UNION ALL "
	cQryDireto	+= "SELECT 'F' as ZAV_TIPO, 'DEVOLUCAO FISCAL'    as DESCRICAO FROM DUAL UNION ALL "
	cQryDireto	+= "SELECT ' ' as ZAV_TIPO, 'NULL'                as DESCRICAO FROM DUAL "
	aCpoDireto	:=	{	{ "ZAV_TIPO"	,"Codigo"		,100	}	,;
						{ "DESCRICAO"	,"Tipo Rami"	,300 }	 } 
						
	cTitDireto	:= "Tipos Rami a serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	_cTIPRAMI2	:= U_Array_In( U_MarkGene(cQryDireto, aCpoDireto, cTitDireto, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FAT_RAMI" )    + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN " + _cCODFILIA	                                             )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " NUM_CLIENTE BETWEEN '"              + _aRet[1] + "' AND '" + _aRet[2] + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " COALESCE(NUM_RAMI, ' ' ) BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' " )	// NAO OBRIGATORIO
	If _aRet[5] = 1
		_cQuery += U_WhereAnd(.T.,                " IND_REVENDA_RAMI = 'S' " 	                                                 )	// NAO OBRIGATORIO
	ElseIf _aRet[5] = 2
		_cQuery += U_WhereAnd(.T.,                " IND_REVENDA_RAMI = 'N' " 	                                                 )	// NAO OBRIGATORIO
	ElseIf _aRet[5] = 3
		_cQuery += U_WhereAnd(.T.,                " IND_REVENDA_RAMI IS NULL  " 	                                             )	// NAO OBRIGATORIO
	ElseIf _aRet[5] = 4
		_cQuery += ""	//	Se foi escolhido 4=Todos, nao incluo nenhuma condicao ao where
	Endif

	If _aRet[6] = 1
		_cQuery += U_WhereAnd(.T.,                " ORDEM_RETIRADA_FILTRO = '1' " 	                                             )	//   1="S"
	ElseIf _aRet[6] = 2
		_cQuery += U_WhereAnd(.T.,                " ORDEM_RETIRADA_FILTRO = '0' " 	                                             )	//  0="N"
	ElseIf _aRet[6] = 3
		_cQuery += U_WhereAnd(.T.,                " ORDEM_RETIRADA_FILTRO IS NULL  " 	                                         )	// NAO OBRIGATORIO
	ElseIf _aRet[6] = 4
		_cQuery += ""				//	Se foi escolhido 4=Todos, nao incluo nenhuma condicao ao where
	Endif

	_cQuery += U_WhereAnd( !empty(_aRet[8] ),     " COALESCE(NUM_AVISO_RECEBIMENTO, ' ' ) BETWEEN '" + _aRet[7] + "' AND '" + _aRet[8]  + "' " )	// NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),    " NUM_TITULO BETWEEN '"                            + _aRet[9] + "' AND '" + _aRet[10] + "' " )	// NAO OBRIGATORIO
	
	If !Empty( _cTIPRAMI2 )			// NAO OBRIGATORIO
		If "' '" $ _cTIPRAMI2 .and. ( 'R' $ _cTIPRAMI2 .OR.  'T' $ _cTIPRAMI2 .OR.  'P' $ _cTIPRAMI2 .OR.  'D' $ _cTIPRAMI2 .OR.  'F' $ _cTIPRAMI2 )
			_cQuery += U_WhereAnd(.T. ,   " ( COD_TIP_RAMI IN " + _cTIPRAMI2 + " OR COD_TIP_RAMI IS NULL ) "	 )

		ElseIf "' '" $ _cTIPRAMI2 .and. !( 'R' $ _cTIPRAMI2 .OR.  'T' $ _cTIPRAMI2 .OR.  'P' $ _cTIPRAMI2 .OR.  'D' $ _cTIPRAMI2 .OR.  'F' $ _cTIPRAMI2 )
			_cQuery += U_WhereAnd(.T. ,   " COD_TIP_RAMI IS NULL  " )
		
		ElseIf !("' '" $ _cTIPRAMI2)
			_cQuery += U_WhereAnd(.T. ,   " COD_TIP_RAMI IN " + _cTIPRAMI2 )
		Endif
	Endif

	_cQuery += U_WhereAnd( !empty(_aRet[12] ),   " DT_BAIXA_FILTRO BETWEEN '" + _aRet[11] + "' AND '" + _aRet[12] + "' " )	// NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN