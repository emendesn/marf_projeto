#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF09R01	�Autor  � Geronimo Benedito Alves                                                                   �Data �  20/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Livros Fiscais - NF-e Pack                       (Modulo 09-FIS )  ���
//���			� Dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, pode-se gerar uma planilha excel com eles          ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods                                                                                                             ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF09R01()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	 
	Aadd(_aDefinePl, "Livros Fiscais - NF-e Pack"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "NF-e Pack"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"NF-e Pack"}						)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"NF-e Pack"}						)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""								


	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			  02					 03						 04	 05	 	 06	 07						 08		 09	
	Aadd(_aCampoQry, {"F1_FILIAL"	,"EMPRESA"				,"Cod. Filial"			,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXF1_DOC"	,"NUM_NFE"				,"N� NFE"				,"C",010	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXF1SERIE"	,"SER_NFE"				,"Serie NFE"			,"C",005	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DAT_EMISSAO"			,"Data Emissao"			,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXDTENTXML"	,"DATA_ENTRADA_XML"		,"Data Entrada XML"		,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DATA_ENTRADA_NFE"		,"Data Entrada NFE"		,"D",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"NATUREZA_OPERACAO"	,"Natureza da Operacao"	,"C",050	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXI_CFOP"	,"CFOP_FORNECEDOR"		,"CFOP Fornecedor"		,"N",010	,0	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"XXCFOPMARF"	,"CFOP_MARFRIG"			,"CFOP Marfrig"			,"C",006	,0	,""						,"" 	,"" })
	//Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR"		,"Cod. Fornecedor"		,"C",006	,0	,""						,"" 	,"" })
	//Aadd(_aCampoQry, {"A2_LOJA"		,"LOJA_FORNECEDOR"		,"Loja Fornecedor"		,"C",002	,0	,""  					,"" 	,"" })
	Aadd(_aCampoQry, {"XXDESTCNPJ"	,"CNPJ_CPF_FORNECEDOR"	,"CNPJ/CPF Fornecedor"	,"C",025	,0	,"@!"					,"" 	,"@!" })
	Aadd(_aCampoQry, {"A2_INSCR"	,"INSCRICAO_ESTADUAL"	,"Inscri��o Estadual"	,""	,""		,""	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"XXDESXNOME"	,"NOME_FORNECEDOR"		,"Nome Fornecedor"		,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A2_MUN"		,"MUNICIPIO_FORNECEDOR"		,"Municipio"				,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A2_ESTADO"	,"ESTADO_FORNECEDOR"		,"Estado"					,"C",015	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXA2GRPTRI"	,"GRUPO_TRIBUTARIO"		,"Grupo Tributario"		,"C",006	,0	,""						,"" 	,"" })
	Aadd(_aCampoQry, {"XXDESTV_NF"	,"VAL_TOT_NF"			,"Valor Total NF"		,"N",015	,2	,"@E 999,999,999,999.99","" 	,"" })
	Aadd(_aCampoQry, {"A2_ZEMINFE"	,"UTILIZA_NFE"			,"Utiliza NFE"			,"C",001	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXTEM_XML"	,"TEM_XML"				,"Tem XML"				,"C",003	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"ZZH_AR"		,"AR"					,"AR"					,"C",007	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXMANIFEST"	,"MANIFESTO"			,"Manifesto"			,"C",027	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXSTATSEFA"	,"STATUS_SEFAZ"			,"Status Sefaz"			,"C",009	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXDESCHVNF"	,"CHAVE_NFE"			,"Chave NFE"			,"C",080	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXNF_SAIDA"	,"NF_SAIDA"				,"NF Saida"				,"C",015	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXTIPOPESS"	,"TIPO_PESS"			,"Tipo Pessoa"			,"C",010	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"F1_ORIGEM"	,"ORIGEM"				,"Origem"				,"C",008	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR"		,"Cod. Vendedor"		,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR"		,"Nome Vendedor"		,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"ZQ_COD"		,"COD_REDE"				,"Cod. Rede"			,"C",003	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"			,"Descricao Rede"		,"C",040	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"ZB_XPED" 	,"TAG_XPED"				,"Tag Xped"				,"C",015	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"XXCLASSIFI"	,"CLASSIFICADO"			,"Classificado"			,"C",020	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"FINALIDADE_NF","FINALIDADE_NF"		,"Finalidade NF"		,"C",030	,0	,"" 					,"" 	,"" })	

 
	aAdd(_aParambox,{1,"Data Emissao Inicial"		,Ctod("")					,""	,""															,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissao Final"			,Ctod("")					,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Emissao')"			,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Entrada Xml Inicial"	,Ctod("")					,""	,""															,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Entrada Xml Final"		,Ctod("")					,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Data Entrada Xml')"		,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Rede Inicial"			,Space(tamSx3("ZQ_COD")[1])	,""	,""															,"SZQCOD"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Rede Final"			,Space(tamSx3("ZQ_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'Cod. Rede')" 				,"SZQCOD"	,"",050,.F.})
	aAdd(_aParambox,{1,"Grupo Tribut�rio Inicial"	,Space(tamSx3("A1_COD")[1])	,""	,""															,"ZA"		,"",050,.F.})
	aAdd(_aParambox,{1,"Grupo Tribut�rio Final"		,Space(tamSx3("A1_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08	,'Grupo Tribut�rio')" 		,"ZA"		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])	,""	,""															,"SA2"		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"		,Space(tamSx3("A2_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10	,'Cod. Fornecedor')" 		,"SA2"		,"",050,.F.})
	//aAdd(_aParambox,{3,"Listar Fornecedor ou Cliente"	,Iif(Set(_SET_DELETED),1,2), {"Fornecedor","Cliente","Ambos" }, 100, "",.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	//_cForn_Cli	:= ""
	//If _aRet[11] <> 3	// 1=Ambos
	//	_cForn_Cli	:= If(_aRet[11] == 1, "Fornecedor" , "Cliente" )
	//Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	//---- T I P O   D E    P E S S O A
	cQryTipPes	:= "			  select  'FISICA'   as CAMPO_01 from dual
	cQryTipPes	+= " union all select  'JURIDICA' as CAMPO_01 from dual
	aCpoTipPes	:=	{   { "CAMPO_01"	,"Pessoa Fisica / Juridica"	,25	}  } 
	cTitTipPes	:= "Marque os Status de solicita��es � serem listadas: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	//aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg )
	_cTpPessoa	:= U_Array_In( U_MarkGene(cQryTipPes, aCpoTipPes, cTitTipPes, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR",	"V_FISCAL_NFEPACK"  )                + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),		" EMPRESA IN "                       + _cCODFILIA                                ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2]),		" DAT_EMISSAO_FILTRO BETWEEN '"      + _aRet[1]   + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4]),		" DATA_ENTRADA_XML_FILTRO BETWEEN '" + _aRet[3]   + "' AND '" + _aRet[4]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cTpPessoa),		" TIPO_PESS IN "                     + _cTpPessoa                                ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6]),		" COD_REDE BETWEEN '"                + _aRet[5]   + "' AND '" + _aRet[6]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8]),		" GRUPO_TRIBUTARIO BETWEEN '"        + _aRet[7]   + "' AND '" + _aRet[8]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10]),		" COD_FORNECEDOR BETWEEN '"          + _aRet[9]   + "' AND '" + _aRet[10] + "' " ) //NAO OBRIGATORIO

	//If _aRet[11] <> 3	// 1=Todos
	//	_cQuery += U_WhereAnd( !empty(_cForn_Cli ),	" TP_FORNCLIE = '"          		 + _cForn_Cli + "' "	                	 ) // NAO OBRIGATORIO
	//Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

