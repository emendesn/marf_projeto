#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R16	�Autor  � Geronimo Benedito Alves																	�Data �  20/04/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Titulos em Aberto CR			(Modulo 06-FIN)    ���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R16()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Titulos em Aberto"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Titulos em Aberto"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Titulos em Aberto"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Titulos em Aberto"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03							 04	 05		 06		07					  	 08	 09		
	Aadd(_aCampoQry, {"E2_FILIAL"	,"COD_FILIAL"							,"Cod. Filial"				,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"							,"Descr. Filial"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE			as COD_CLIENT"	,"Cod. do Cliente"			,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE			as NOM_CLIENT"	,"Nome do Cliente"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_LOJA"		,"COD_LOJA				as COD_LOJA"	,"Loja do Cliente"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"COD_CNPJ_CLIENTE		as CNPJCLIENT"	,"CNPJ do Cliente"			,"C",018	,0	,"@!"						,""	,"@!" })
	Aadd(_aCampoQry, {"A1_INSCR"	,"COD_INSCR_EST_CLIENTE"				,"Inscri��o Estadual"		,"C",018	,0	,""							,""	,""	})	
	Aadd(_aCampoQry, {"A1_DDD"		,"COD_DDD_CLIENTE		as DDD_CLIENT"	,"DDD do Cliente"			,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_TEL"		,"NUM_TELEFONE_CLIENTE	as TEL_CLIENT"	,"Telefone do Cliente"		,"C",015	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_CONTATO_CLIENTE	as CONTACCLIE"	,"Nome para Contato"		,"C",040	,0	,""  						,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"EMAIL_CLIENTE			as EMAIL_CLIE"	,"E-mail Cliente"			,"C",040	,0	,""  						,"" ,""	})
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"DESC_SEGMENTO			as DESCSEGMEN"	,"Descricao do Segmento"	,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOM_VENDEDOR			as NOMVENDEDO"	,"Nome do Vendedor"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"							,"Descricao Rede"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"							,"Data de Emissao"			,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO			as DTVENCIMEN"	,"Data de Vencimento"		,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"							,"N� Titulo"				,"C",009	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA			as NUMPARCELA"	,"Parcela"					,"C",002	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA_OPERACAO	as CODNATUREZ"	,"Cod. Natureza"			,"C",010	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_TIPO"		,"TIP_TITULO"							,"Tipo Titulo"				,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"							,"Valor Titulo"				,"N",017	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_RECEBIDO			as VLRECEBIDO"	,"Valor Recebido"			,"N",014	,2	,"@E 999,999,999.99"		,""	,""	}) 
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DEVOLVIDO			as VLRDEVOLVE"	,"Valor Devolvido"			,"N",017	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DESCONTO			as VLRDESCONT"	,"Valor Desconto"			,"N",017	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_DESC_CONTRATO		as DESCCONTRA"	,"Vlr. Desconto Contrato"	,"N",017	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VLR_ADIANTAMENTO		as VLRADIANTA"	,"Valor Adiantamento"		,"N",014	,2	,"@E 999,999,999.99"		,""	,""	})
	AADD(_aCampoQry, {"E1_SALDO"	,"VLR_SALDO_TITULO		as SALDOTITUL"	,"Valor Saldo do Titulo"	,"N",017	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"E1_SALDO"	,"PERC_SALDO"							,"% Saldo"					,"N",006	,2	,"@E 999.99"				,""	,""	})
	Aadd(_aCampoQry, {"E1_NUMBCO"	,"NUM_TIT_BANCO			as NUMTITBANC"	,"N� no Banco"				,"C",015	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR			as CODPORTADO"	,"Cod. do Portador"			,"C",003	,0	,""							,""	,""	})
	AADD(_aCampoQry, {"E1_AGEDEP"	,"NUM_AGENCIA			as NUMAGENCIA"	,"N� Agencia"				,"C",005	,0	,""							,""	,""	})
	AADD(_aCampoQry, {"E1_CONTA"	,"NUM_CONTA				as NUM_CONTA"	,"N� Conta"					,"C",010	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_ZATEND"	,"ATENDENTE"							,"Atendente"				,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZZB_CONTAT"	,"CONTATO"								,"Contato"					,"C",050	,0	,"",  						""	,""	})
	Aadd(_aCampoQry, {"ZZB_RESPOS"	,"RESPOSTA"								,"Resposta"					,"C",250	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZZB_NRONFD"	,"DEVOLUCAO"							,"Devolucao"				,"C",250	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZZ9_DESPOS"	,"POSICAO"								,"Posicao"					,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZZB_DATA"	,"DATA_CONTATO			as DT_CONTATO"	,"Data Contato"				,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZZB_HORA"	,"HORA_CONTATO			as HR_CONTATO"	,"Hora Contato"				,"C",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_HIST"		,"HISTORICO_TITULO		as HISTOR_TIT"	,"Historico Titulo"			,"C",250	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_END"		,"NOM_ENDERECO			as NOM_ENDERE"	,"Endereco"					,"C",080	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_BAIRRO"	,"NOM_BAIRRO_CLIENTE	as BAIRROCLIE"	,"Bairro Cliente"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_ESTADO"	,"NOM_MUNICIPIO_CLIENTE	as MUNICICLIE"	,"Municipio Cliente"		,"C",020	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_MUN"		,"NOM_ESTADO_CLIENTE	as ESTADOCLIE"	,"Estado Cliente"			,"C",060	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_CEP"		,"NUM_CEP_CLIENTE		as NUMCEPCLIE"	,"Cep Cliente"				,"C",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"NUM_PREFIXO_TITULO	as PREFIXOTIT"	,"Prefixo Titulo"			,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_MOEDA"	,"COD_MOEDA"							,"Cod. Moeda"				,"N",002	,0	,"99"						,""	,""	})
	Aadd(_aCampoQry, {"XXDESMOE01"	,"DESC_MOEDA"							,"Descricao da Moeda"		,"C",005	,0	,""							,""	,""	})	
		
	aAdd(_aParambox,{1,"Dt Vencimento Inicial"	,Ctod("")						,""		,""														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Vencimento Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data de Vencimento')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])		,"@!"	,""														,"CLI"	,,  050,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,,  050,.F.})													
	aAdd(_aParambox,{1,"Cod. Natureza Inicial"	,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,""														,"SED"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Final"	,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Natureza')"		,"SED"	,"",050,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

//===		S E L E C I O N A	T I P O	D E		T I T U L O
	cQryTitPro	:= "SELECT DISTINCT E1_TIPO "
	cQryTitPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SE1") ) + " TMPSE1 " 
	cQryTitPro	+= "  WHERE TMPSE1.D_E_L_E_T_ = ' ' " 

	aCpoTitPro	:=	{	{"E1_TIPO"		,U_X3Titulo("E1_TIPO")	,TamSx3("E1_TIPO")[1]}	 } 
	cTituTipo	:= "Marque opcao do Tipo de Titulo a serem listado: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cTitulProd	:= U_Array_In( U_MarkGene(cQryTitPro, aCpoTitPro, cTituTipo, nPosRetorn, @_lCancProg ) )
	
	If _lCancProg
		Return
	Endif 
//===		S E L E C I O N A	R E D E
	cQryRede	:= " SELECT ' ' as ZQ_COD, 'SEM REDE' as ZQ_DESCR FROM DUAL UNION ALL "
	cQryRede	+= " SELECT DISTINCT ZQ_COD, ZQ_DESCR"
	cQryRede  	+= "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SZQ") ) + " TMPSZQ " 
	cQryRede	+= "  WHERE TMPSZQ.D_E_L_E_T_ = ' ' " 
	cQryRede	+= "  ORDER BY ZQ_COD"

	aCpoRede	:=	{	{ "ZQ_COD"		,U_X3Titulo("ZQ_COD")	,TamSx3("ZQ_COD")[1]	 } ,;
	aCpoRede	:=		{ "ZQ_DESCR"	,U_X3Titulo("ZQ_DESCR")	,TamSx3("ZQ_DESCR")[1] }	} 
	cTituRede	:= "Selecione os Codigos de Rede � serem listados: "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: ZQ_COD
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cRede	:= U_Array_In( U_MarkGene(cQryRede, aCpoRede, cTituRede, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

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
	
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
	cVendedor	:= U_Array_In( U_MarkGene(cQryVended, aCpoVended, cTituVende, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_TITULOS_EM_ABERTO" )          + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN "                   + _cCODFILIA                             ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_VENCIMENTO_FILTRO BETWEEN '"   + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " COD_CLIENTE BETWEEN '"            + _aRet[3] + "' AND '" + _aRet[4] + "' " ) // NAO OBRIGATORIO
	If empty(cTitulProd)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cTitulProd ) <> 0
		_cQuery += U_WhereAnd( .T.  ,             " ( TIP_TITULO IS NULL OR TIP_TITULO IN " + cTitulProd + " )"                ) 
	Else	
		_cQuery += U_WhereAnd( .T. ,              " TIP_TITULO IN " + cTitulProd                                               )	
	Endif
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),     " COD_NATUREZA_OPERACAO BETWEEN '"  + _aRet[5] + "' AND '" + _aRet[6] + "' " ) // NAO OBRIGATORIO

	If empty(cRede)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cRede ) <> 0
		_cQuery += U_WhereAnd( .T. ,             " ( COD_REDE_FILTRO IS NULL OR COD_REDE_FILTRO IN " + cRede + " )"                         )
	Else	
		_cQuery += U_WhereAnd( .T. ,             " COD_REDE_FILTRO IN " + cRede                                                      )	
	Endif

	If empty(cVendedor)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cVendedor ) <> 0
		_cQuery += U_WhereAnd(  .T. , " ( COD_VENDEDOR_FILTRO IS NULL OR COD_VENDEDOR_FILTRO IN " + cVendedor + " )"                             ) 
	Else	
		_cQuery += U_WhereAnd(  .T. , " COD_VENDEDOR_FILTRO IN " + cVendedor                                                              ) 	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

 
// teste da classe FWMSEXCELEX()
User Function TSTXMLgg()
Local oExcel := FWMSEXCELEX():New()
//ConOut(oExcel:ClassName())
oExcel:AddworkSheet("Teste do Edu - 1")
oExcel:AddTable             ("Teste do Edu - 1","Titulo de teste 1")
oExcel:AddColumn("Teste do Edu - 1","Titulo de teste 1","Col1",1,1)
oExcel:AddColumn("Teste do Edu - 1","Titulo de teste 1","Col2",2,2)
oExcel:AddColumn("Teste do Edu - 1","Titulo de teste 1","Col3",3,3)
oExcel:AddColumn("Teste do Edu - 1","Titulo de teste 1","Col4",1,1)

oExcel:AddRow("Teste do Edu - 1","Titulo de teste 1",{11,12,13,14})
oExcel:AddRow("Teste do Edu - 1","Titulo de teste 1",{21,22,23,24})
oExcel:AddRow("Teste do Edu - 1","Titulo de teste 1",{31,32,33,34})
oExcel:AddRow("Teste do Edu - 1","Titulo de teste 1",{41,42,43,44})

oExcel:AddworkSheet("Teste do Edu - 2")
oExcel:AddTable("Teste do Edu - 2","Titulo de teste 1")
oExcel:AddColumn("Teste do Edu - 2","Titulo de teste 1","Col1",1)
oExcel:AddColumn("Teste do Edu - 2","Titulo de teste 1","Col2",2)
oExcel:AddColumn("Teste do Edu - 2","Titulo de teste 1","Col3",3)
oExcel:AddColumn("Teste do Edu - 2","Titulo de teste 1","Col4",1)

oExcel:AddRow("Teste do Edu - 2","Titulo de teste 1",{11,12,13,stod("20121212")})
oExcel:AddRow("Teste do Edu - 2","Titulo de teste 1",{21,22,23,stod("20121212")})
oExcel:AddRow("Teste do Edu - 2","Titulo de teste 1",{31,32,33,stod("20121212")})
oExcel:AddRow("Teste do Edu - 2","Titulo de teste 1",{41,42,43,stod("20121212")})
oExcel:AddRow("Teste do Edu - 2","Titulo de teste 1",{51,52,53,stod("20121212")})

oExcel:Activate()
oExcel:GetXMLFile("TESTE.xml")

Return




                               
                               
                               
                               