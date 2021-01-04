#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF09R02	�Autor  � Geronimo Benedito Alves                                                                   �Data �  31/10/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Livros Fiscais - Apuracao de ICMS                              (Modulo 09-FIS )  ���
//���			� Dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, pode-se gerar uma planilha excel com eles          ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods                                                                                                             ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF09R02()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	 
	 
	Aadd(_aDefinePl, "Livros Fiscais - Apuracao de ICMS")	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Apuracao de ICMS"					)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Apuracao de ICMS"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Apuracao de ICMS"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	Aadd(_aCampoQry, {"F1_FILIAL"	,"COD_FILIAL"			,"Cod. Filial"			,"C",006	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"M0_FILIAL"	,"DESC_FILIAL"			,"Descricao Filial"		,"C",030	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_TIPOIP"	,"TIPO_IMPOSTO"			,"Tipo Imposto"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_TIPOPR"	,"TIPO_PERIODO"			,"Tipo Periodo"			,"C",010	,0	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_PERIOD"	,"PERIODO"				,"Periodo"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_LIVRO"	,"NUM_LIVRO"			,"N� Livro"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_SEQUEN"	,"SEQUENCIA_APURACAO"	,"Sequencia Apuracao"	,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_DTINI"	,"DATA_INI"				,"Data Inicio"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_DTFIM"	,"DATA_FIM"				,"Data Fim"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_LINHA"	,"LINHA"				,"Linha"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_SUBITE"	,"SUB_ITEM"				,"Sub Item"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_CODLAN"	,"COD_AJUSTE"			,"Cod. Ajuste"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_DESC"	,"DESC_AJUSTE"			,"Descricao Ajuste"		,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_VALOR"	,"VALOR_AJUSTE"			,"Valor Ajuste"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_ESTGNR"	,"ESTADO_GNRE"			,"Estado GNRE"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_GNRE"	,"NUM_GNRE"				,"N� GNRE"				,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_GNREF3"	,"GNRE_VIA_F3"			,"GNRE Via F3"			,""	,		,	,"" 					,"" 	,"" })
	Aadd(_aCampoQry, {"CDH_TPLANC"	,"LANC_MANUAL"			,"Lanc. Manual"			,""	,		,	,"" 					,"" 	,"" })

	aAdd(_aParambox,{1,"Data Inicial da Apuracao"	,Ctod("")					,""	,""															,""			,"",050,.T.})
	aAdd(_aParambox,{1,"Data Final da Apuracao"		,Ctod("")					,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data da Apuracao')"		,""			,"",050,.T.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
    
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)


	//---- T I P O   D E    I M P O S T O
	cQryImpost	:= "		   select  'IC'  as CAMPO_01, 'ICMS'    as CAMPO_02 from dual
	cQryImpost	+= " union all select  'ST'  as CAMPO_01, 'ICMS ST' as CAMPO_02 from dual
	cQryImpost	+= " union all select  'IP'  as CAMPO_01, 'IPI'     as CAMPO_02 from dual
	aCpoImpost	:=	{   { "CAMPO_01"	,"Tipo de imposto"	    ,40	} ,;
						{ "CAMPO_02"	,"Descricao do imposto"	,40	}  } 
	cTitImpost	:= "Marque os Impostos a serem listados : "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	//aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg )
	_cImposto	:= U_Array_In( U_MarkGene(cQryImpost, aCpoImpost, cTitImpost, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	//---- T I P O   D E    P E R I O D O                            		
	cQryTipPer	:= "		   select  'Descendial' as CAMPO_01 from dual
	cQryTipPer	+= " union all select  'Quinzenal'  as CAMPO_01 from dual
	cQryTipPer	+= " union all select  'Mensal'     as CAMPO_01 from dual
	cQryTipPer	+= " union all select  'Semestral'  as CAMPO_01 from dual
	cQryTipPer	+= " union all select  'Anual'      as CAMPO_01 from dual
	aCpoTipPer	:=	{   { "CAMPO_01"	,"Tipo de Periodo"	,25	}  } 
	cTitTipPer	:= "Marque os Tipos de Periodos a serem listados : "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	//aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg )
	_cTipoPeri	:= U_Array_In( U_MarkGene(cQryTipPer, aCpoTipPer, cTitTipPer, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	//---- P E R I O D O 
	cQryPeriod	:= "		   select  '1' as CAMPO_01 from dual
	cQryPeriod	+= " union all select  '2'  as CAMPO_01 from dual
	cQryPeriod	+= " union all select  '3'     as CAMPO_01 from dual
	cQryPeriod	+= " union all select  '4'  as CAMPO_01 from dual
	aCpoPeriod	:=	{   { "CAMPO_01"	,"Periodo"	,25	}  } 
	cTitPeriod	:= "Marque Periodos a serem listados : "
	nPosRetorn	:= 1		// Quero que seja retornado o primeiro campo: CAMPO_01
	//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene.
	//.T. no _lCancProg, apos a Markgene, indica que realmente foi teclado o botao cancelar e que devo abandonar o programa. 
	//.F. no _lCancProg, apos a Markgene, indica que realmente nao foi teclado o botao cancelar ou que mesmo ele teclado, nao devo abandonar o programa (mas apenas "limpar/desconsiderar" a marcacao dos registro) 
	_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botao cancelar da MarkGene
	//aStatuSoli	:= U_MarkGene(cQStatSoli, aCpoStSoli, cTitStSoli, nPosRetorn, @_lCancProg )
	_cPeriodo	:= U_Array_In( U_MarkGene(cQryPeriod, aCpoPeriod, cTitPeriod, nPosRetorn, @_lCancProg ) )
	If _lCancProg
		Return
	Endif 

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR",	"V_FISCAL_RESUMO_APURACAO_ICMS"      	) + CRLF
	_cQuery += U_WhereAnd( .T.,						" COD_FILIAL IN "   + _cCODFILIA     	) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( .T.,						" CDH_DTINI >= '"    + _aRet[1] + "' "	) //OBRIGATORIO
	_cQuery += U_WhereAnd( .T.,						" CDH_DTFIM <= '" 	+ _aRet[2] + "' "	) //OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cImposto),		" TIPO_IMPOSTO IN " + _cImposto 	) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cTipoPeri),		" TIPO_PERIODO IN " + _cTipoPeri    	) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_cPeriodo),		" PERIODO IN "      + _cPeriodo     	) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

