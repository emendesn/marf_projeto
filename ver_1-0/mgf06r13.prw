#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R13	�Autor  �Geronimo Benedito Alves																	�Data �  07/03/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Ocorrencia Prorrogacao			(Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R13()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Ocorrencia Prorrogacao"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Ocorrencia Prorrogacao"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Ocorrencia Prorrogacao"}						)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Ocorrencia Prorrogacao"}						)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35													//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02											 03						 04	 05		 06	 07					 	 08	 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"								,"Cod. Filial"			,"C",006	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"								,"Nome Filial"			,"C",041	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"PREFIXO"									,"Prefixo"				,"C",003	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"								,"Cod. Segmento"		,"C",006	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"								,"Data Emissao"			,"D",008	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE				as CODCLIENTE"	,"Cod. Cliente"			,"C",006	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE				as NOMCLIENTE"	,"Nome Cliente"			,"C",040	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"ZQ_COD"		,"COD_REDE"									,"Codigo Rede"			,"C",003	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"								,"Descr. Rede"			,"C",040	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR				as CODPORTADO"	,"Cod. Portador"		,"C",003	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_VENCORI"	,"DT_VENCIMENTO_ORIGINAL	as DTVENCIORI"	,"Vencimento Original"	,"D",008	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_VENCREA"	,"DT_VENCIMENTO_REAL		as DTVENCIREA"	,"Vencimento Real"		,"D",008	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_SERIE"	,"SERIE_NF"									,"Serie NF"				,"C",003	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_NUMNOTA"	,"NUM_NF"									,"N� NF"				,"C",009	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_NUMBCO"	,"NUM_TIT_BANCO				as NUMTITBANC"	,"N� Titulo Banco"		,"C",015	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_ZHIST"	,"MOTIVO_PRORROGACAO		as MOTIVPRORR"	,"Motivo Prorroga��o"	,"C",250	,0	,""						,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"								,"Valor Titulos"		,"N",017	,2	,"@E 99,999,999,999.99"	,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")					,""		,"" 													,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final  "	,Ctod("")					,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"			,""		,""	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,"@!"	,"",													"CLI"	,""	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final  "	,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,""	,070,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	cQryRede	:= " SELECT '" +SPACE(TamSx3("ZQ_COD")[1])+ "' as ZQ_COD, 'SEM REDE' as ZQ_DESCR FROM DUAL UNION ALL "
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

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_OCORRENCIA_PRORROGACAO" ) +CRLF +  " A "
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DT_EMISSAO_FILTRO BETWEEN '"        + _aRet[1]   + "' AND '" + _aRet[2] + "' " )// OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN "                     + _cCODFILIA                               )// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " COD_CLIENTE BETWEEN '"              + _aRet[3]   + "' AND '" + _aRet[4] + "' " )// NAO OBRIGATORIO

	If empty(cRede)
		_cQuery +=  ""		// Nao  incrementa a clausula Where
	ElseIF AT("' '", cRede ) <> 0
		_cQuery += U_WhereAnd( .T. ,     " ( COD_REDE IS NULL OR COD_REDE IN " + cRede + " )"  )
	Else	
		_cQuery += U_WhereAnd( .T. ,     " COD_REDE IN " + cRede                               )	
	Endif

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
