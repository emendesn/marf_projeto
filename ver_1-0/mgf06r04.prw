#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R04	�Autor  � Geronimo Benedito Alves																	�Data �08/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - CR-Ocorrencia Baixa NCC		 (Modulo 06-FIN)		���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
 
	Aadd(_aDefinePl, "Contas a Receber-Ocorrencia Baixa NCC"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Ocorrencia Baixa NCC"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Ocorrencia Baixa NCC"}					)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Ocorrencia Baixa NCC"}					)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03							 04	 05		06	 07					  		 08	 09		
	Aadd(_aCampoQry, {"E1_FILIAL"	,"COD_FILIAL"								,"Codigo Filial"			,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"								,"Nome da Filial"			,"C",041	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"PREFIXO"									,"PREFIXO"					,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NUM"		,"NUM_TITULO"								,"N� Titulo"				,"C",009	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PARCELA"	,"NUM_PARCELA				as NUMPARCELA"	,"Parcela"					,"C",002	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NATUREZ"	,"COD_NATUREZA				as CODNATUREZ"	,"Cod. Natureza"			,"C",010	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"NOM_NATUREZA				as NOMNATUREZ"	,"Descricao Natureza"		,"C",030	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"								,"Data Emissao"				,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE				as CODCLIENTE"	,"Codigo Cliente"			,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE				as NOMCLIENTE"	,"Nome do Cliente"			,"C",020	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"								,"Descricao da Rede"		,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_PORTADO"	,"COD_PORTADOR				as CODPORTADO"	,"Codigo do Portador"		,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCIMENTO				as DTVENCIMEN"	,"Data de Vencimento"		,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_BAIXA"	,"DT_PAGAMENTO				as DT_PAGAMEN"	,"Data de Pagamento"		,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_SERIE"	,"SERIE_NF"									,"Serie"					,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NUMNOTA"	,"NUM_NF"									,"N� Nota Fiscal"			,"C",009	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_NUMBCO"	,"NUM_TIT_BANCO				as NUMTITBANC"	,"N� no Banco"				,"C",015	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_HIST"		,"OBSERVACAO"								,"Observacao"				,"C",250	,0	,""							,""	,""	}) 
	Aadd(_aCampoQry, {"E5_DTDIGIT"	,"DT_DIGITACAOABATIMENTO	as DT_ABATIME"	,"Data Digit. Abatimento"	,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E5_DOCUMEN"	,"NUM_NF_ABATIMENTO 		as NUMABATINF"	,"N� NF Abatimento"			,"C",050	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"E1_VALOR"	,"VLR_TITULO"								,"Valor Titulo"				,"N",017	,2	,"@E 999,999,999,999.99"	,""	,""	})	
	Aadd(_aCampoQry, {"E1_DECRESC"	,"COALESCE(VLR_ABATIMENTO,0) as VLRABATIME"	,"Valor Abatimento"			,"N",017	,2	,"@E 999,999,999,999.99"	,""	,""	}) 		

	aAdd(_aParambox,{1,"Data Emissao Inicial:"	,Ctod("")					,""		,""													,""		,	,050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final:"	,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data')"			,""		,	,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"	,Space(tamSx3("A1_COD")[1])	,"@!"	,""													,"CLI"	,	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final:"	,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"	,"CLI"	,	,070,.F.})		
	aAdd(_aParambox,{1,"Cod. Rede Inicial:"		,Space(tamSx3("ZQ_COD")[1])	,"@!"	,""													,"SZQ"	,	,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Rede Final:"		,Space(tamSx3("ZQ_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Rede')"		,"SZQ"	,	,070,.F.})													
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	Do While.T.	// La�o para obrigar a marcacao de ao menos um portador
		cQryPorPro	:= "SELECT ' ' as A6_COD, 'SEM PORTADOR' as A6_NOME FROM DUAL UNION ALL "
		cQryPorPro	+= "SELECT DISTINCT A6_COD, A6_NOME"
		cQryPorPro  += "  FROM " +  U_IF_BIMFR( "PROTHEUS", RetSqlName("SA6")  ) + " TMPSA6 "
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

		Exit	// Mudanca da l�gica. Nao tem mais MarkGene obrigat�ria. Se nao marcar nenhum, ou marcar todos, prossigo e nao incluo a condicao no where

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
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_OCORRENCIA_BAIXA_NC" ) + ' A '          + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_EMISSAO_FILTRO BETWEEN '"                + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " A.COD_FILIAL IN "                           + _cCODFILIA	                          ) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " A.COD_CLIENTE BETWEEN '"                    + _aRet[3] + "' AND '" + _aRet[4] + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " A.COD_REDE BETWEEN '"                       + _aRet[5] + "' AND '" + _aRet[6] + "' " ) // NAO OBRIGATORIO
	If empty(cPortaProd)
		_cQuery +=  ""		// Nao incrementa a clausula Where
	ElseIF AT("' '", cPortaProd ) <> 0
		_cQuery += U_WhereAnd(  .T. ,              " ( COD_PORTADOR IS NULL OR COD_PORTADOR IN " + cPortaProd + " )"  )
	Else	
		_cQuery += U_WhereAnd(  .T. ,              " COD_PORTADOR IN "                           + cPortaProd )	
	Endif
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

