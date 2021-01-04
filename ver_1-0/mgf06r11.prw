#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R11	�Autor  � Geronimo Benedito Alves																	�Data �  17/01/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Ocorrencia Abatimento			(Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R11()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas a Receber - Ocorrencia Abatimento"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Ocorrencia Abatimento"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Ocorrencia Abatimento"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Ocorrencia Abatimento"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35												//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""													

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03							 04	 05		06	 07						 08		 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"							,"Cod. Filial"				,"C",009	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"							,"Nome Filial"				,"C",041	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"							,U_X3Titulo("E1_NUM")		,"C",006	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIP_TITULO"							,"Tipo Titulo"				,"C",003	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E2_PARCELA"	,"NUM_PARCELA			as NUMPARCELA"	,"Parcela"					,"C",002	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"							,"Data Emissao"				,"D",008	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO			as DT_VENCIME"	,"Data Vencimento"			,"D",008	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_BAIXA"	,"DT_ABATIMENTO			as DT_ABATIME"	,"Data Abatimento"			,"D",008	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E5_HISTOR"	,"DESC_ABATIMENTO		as DES_ABATIM"	,"Descr. Abatimento"		,"C",040	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E5_MOTBX"	,"COD_MOTIVOBAIXA		as MOTIVOBAIX"	,"Cod. Motivo Baixa"		,"C",003	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"AE2_COMPOS"	,"DESC_MOTIVO_BAIXA		as DESCMTBAIX"	,"Descr. Motivo Baixa"		,"C",010	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE			as CODCLIENTE"	,"Cod. Cliente"				,"C",006	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE			as NOMCLIENTE"	,"Nome Cliente"				,"C",040	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"							,"Descr. Rede"				,"C",040	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA_OPERACAO as CODNATUOPE"	,"Cod. Natureza de Operacao","C",010	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR          as CODPORTADO"	,"Cod. Portador"			,"C",003	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_SERIE"	,"SERIE_NF"								,"Serie NF"					,"C",003	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_NUMNOTA"	,"NUM_NF"								,"N� NF"					,"C",009	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_NUMBCO"	,"NUM_TIT_BANCO			as NUMTITBANC"	,"N� Titulo Banco"			,"C",015	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_HIST"		,"OBSERVACAO"							,"Observacao"				,"C",250	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_ZDSTPDE"	,"DESC_TIPO_DESCONTO	as DESCTIPDES"	,"Descr. Tipo Desconto"		,"C",015	,0	,""						,""		,""	}) 
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"							,"Valor Titulos"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	}) 
	Aadd(_aCampoQry, {"E1_DECRESC"	,"VLR_ABATIMENTO		as VLRABATIME"	,"Valor Abatimento"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	}) 

	aAdd(_aParambox,{1,"Data Abatimento Inicial",Ctod("")					,""		,""													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Abatimento Final "	,Ctod("")					,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,"@!"	,""													,"CLI"	,""	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"	,"CLI"	,""	,070,.F.})													

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
	
	Do While.T.	// La�o para obrigar a marcacao de ao menos um portador
		cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
		cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
		cQryPorPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6") ) + " TMPSA6 " 
		cQryPorPro	+= "  WHERE TMPSA6.D_E_L_E_T_ = ' ' " 
		cQryPorPro	+= "  ORDER BY A6_COD"

		aCpoPorPro	:=	{	{ "A6_COD"		,U_X3Titulo("A6_COD")	,TamSx3("A6_COD")[1]	 } ,;
		aCpoPorPro	:=		{ "A6_NOME"	,U_X3Titulo("A6_NOME")	,TamSx3("A6_NOME")[1] }	} 
		cTituPorta	:= "Selecione os Codigos de Portadores a serem listados "
		
		nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: A6_COD
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene.
		//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o Botao cancelar e que devo abandonar o programa. 
		//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o Botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o Botao cancelar da MarkGene
		cPortaProd	:= U_Array_In( U_MarkGene(cQryPorPro, aCpoPorPro, cTituPorta, nPosRetorn, @_lCancProg ) )

		Exit	// Mudanca da l�gica. Nao  tem mais MarkGene obrigat�ria. Se nao marcar nenhum, ou marcar todos, prossigo e nao incluo a condicao no where

		//If empty(cPortaProd)
		//	MsgStop("� obrigatorio a sele�ao de ao menos um portador. ")
		//	Loop		// Se nao marcou nenhum portador, dou loop ao While para marca-lo 
		//Else
		//	Exit		// Se marcou ao menos um portador, dou exit neste laco e continuo o processamento da rotina
		//Endif
	Enddo
	
	If _lCancProg
		Return
	Endif 

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR",   "V_CR_OCORRENCIA_ABATIMENTO" )    + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),       " DT_ABATIMENTO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),      " COD_FILIAL IN "                 + _cCODFILIA                             ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),       " COD_CLIENTE BETWEEN '"          + _aRet[3] + "' AND '" + _aRet[4] + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(cTitulProd ),     " TIP_TITULO IN "                 + cTitulProd                             ) // NAO OBRIGATORIO
	If Empty( cPortaProd )	// ZBD_DESCRI
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery += U_WhereAnd( .T. ,                " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"          )
	Else	
		_cQuery += U_WhereAnd( .T. ,                " COD_PORTADOR IN " + cPortaProd	                                       )	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
