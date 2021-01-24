#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R07	�Autor  � Geronimo Benedito Alves																	�Data � 26/12/17   ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Baixas                                          (M�dulo 34-CTB)  ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																										       ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R07()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - Baixas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Baixas"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Baixas"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Baixas"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }				)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			02						03								 04		 05		 06		 07		 08	 09		
	Aadd(_aCampoQry, {"E5_FILIAL"	,"COD_FILIAL"			,"Filial"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DATA"		,"DATA_MOVIMENTO"		,"Data Movimento"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_TIPO"		,"TIPO_TITULO"			,"Tipo"							,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_MOEDA"	,"MOEDA"				,"Moeda"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"	,"VAL_MOVIMENTO"		,"Valor"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_NATUREZ"	,"COD_NATUREZA"			,"Natureza"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_BANCO"	,"BANCO"				,"Banco"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_AGENCIA"	,"AGENCIA"				,"Agencia"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CONTA"	,"CONTA"				,"Conta"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DOCUMEN"	,"NUM_DOC"				,"N� Documento"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VENCTO"	,"DATA_VENCIMENTO"		,"Data Vencimento"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_RECPAG"	,"RECIBO_PG"			,"Recibo Pagamento"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_BENEF"	,"BENEFICIARIO"			,"Beneficiario"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_HISTOR"	,"HISTORICO"			,"Hist�rico"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_TIPODOC"	,"TIPO_MOVIMENTACAO"	,"Tipo Movimenta��o"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLMOED2"	,"VALOR_MOEDA2"			,"Valor em D�lar"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_SITUACA"	,"SITUACAO"				,"Situa��o"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_LOTE"		,"LOTE_BAIXA"			,"Lote da Baixa"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PREFIXO"	,"PREFIXO_TITULO"		,"Prefixo"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_NUMERO"	,"NUMERO_TITULO"		,"N� T�tulo"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PARCELA"	,"NUM_PARCELA"			,"Parcela"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CLIFOR"	,"CLIENTE_FORNEC"		,"Cliente/Fornecedor"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_LOJA"		,"LJ_CLIENTE_FORNEC"	,"Loja"							,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DTDIGIT"	,"DATA_DIGITACAO"		,"Data Digita��o"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_TIPOLAN"	,"TP_LANC_CONTABIL"		,"Tipo Lancamento Cont�bil"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DEBITO"	,"CONTA_DEBITO"			,"Conta D�bito"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CREDITO"	,"CONTA_CREDITO"		,"Conta Cr�dito"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_MOTBX"	,"MOT_CANCELAMENTO"		,"Motivo Cancelamento"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_RATEIO"	,"RATEIO"				,"Rateio"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_SEQ"		,"SEQUENCIA"			,"Sequencia"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DTDISPO"	,"DT_DISPONIB"			,"Data Disponibilidade"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CCD"		,"CC_DEBITO"			,"Centro de Custo Debito"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CCC"		,"CC_CREDITO"			,"Centro de Custo Cr�dito"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FILORIG"	,"FILIAL_ORIGEM"		,"Filial Origem"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ARQCNAB"	,"ARQ_CNAB"				,"Arquivo Cnab"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLJUROS"	,"VAL_JUROS"			,"Valor Juros"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLMULTA"	,"VAL_MULTA"			,"Valor Multa"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLCORRE"	,"VAL_CORRECAO"			,"Valor Corre��o"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLDESCO"	,"VAL_DESCONTO"			,"Valor Desconto"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CLVLDB"	,"CL_VAL_DEBITO"		,"Classe de Valor D�bito"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CLVLCR"	,"CL_VAL_CREDITO"		,"Classe de Valor Cr�dito"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FATURA"	,"FATURA"				,"Fatura"						,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_TXMOEDA"	,"TX_MOEDA_TIT"			,"Taxa Moeda do T�tulo"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FATPREF"	,"PREFIXO_FATURA"		,"Prefixo da Fatura"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_SITCOB"	,"SIT_COBRANCA"			,"Situa��o Cobran�a"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FORNADT"	,"FORNEC_ADTO"			,"Fornecedor Adiantamento"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FORNADT"	,"LJ_FORNEC_ADTO"		,"Loja Fornec Adto"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CLIENTE"	,"COD_CLIENTE"			,"C�d. Cliente"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_FORNECE"	,"COD_FORNECEDOR"		,"C�d. Fornecedor"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_MOVCX"	,"MOV_CAIXINHA"			,"Movimento de Caixinha"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLACRES"	,"VAL_ACRESCIMO"		,"Valor Acr�scimo"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VLDECRE"	,"VAL_DECRESCIMO"		,"Valor Decr�scimo"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VRETPIS"	,"VAL_RT_PIS"			,"Valor Retido Pis"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PRETCOF"	,"PEND_RT_COFINS"		,"Valor Retido Cofins"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VRETCSL"	,"VAL_RT_CSL"			,"Valor Retido CSLL"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PRETPIS"	,"PEND_RT_PIS"			,"Pendente Retenc�o PIS"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PRETCOF"	,"PEND_RT_COFINS"		,"Pendente Retenc�o COFINS"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PRETCSL"	,"PEND_RT_CSL"			,"Pendente Retenc�o CSLL"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PRETIRF"	,"PRETENCAO_IRRF"		,"Pendente Retenc�o IRRF"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_VRETIRF"	,"VALOR_RETIDO_IRRF"	,"Valor Retido IRRF"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_PROCTRA"	,"NUM_PROCESSO_TRANSF"	,"N� Processo Transfer�ncia"	,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_IDMOVI"	,"ID_MOVIMENTO"			,"ID Movimento"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_BASEIRF"	,"BASE_IRPF"			,"Base C�lculo IRPF"			,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ORIGEM"	,"ORIGEM_MOVIMENTACAO"	,"Origem Moviment."				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_CCUSTO"	,"CENTRO_CUSTO"			,"Centro de Custo"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_SEQCON"	,"SEQUENCIA_CONCILIACAO","Sequencia Concilia��o"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ZTPDESC"	,"TIPO_DESCONTO"		,"Tipo Desconto"				,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ZNOME"	,"NOME_BANCO"			,"Nome Banco"					,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ZDSTPDE"	,"DESC_TIPO_DESCONTO"	,"Descri��o Tipo Desconto"		,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_DTCANBX"	,"DATA_CANC_BAIXA"		,"Data Cancelamento da Baixa"	,""		,""		,""	 	,""		,""	,""	})
	Aadd(_aCampoQry, {"E5_ZLOTEBX"	,"LOTE_BAIXA_CUST"		,"Lote da Baixa Customizado"	,""		,""		,""	 	,""		,""	,""	})   

	aAdd(_aParambox,{1,"Data Movimento  Inicial"		,Ctod("")						,""	,""															,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Movimento Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data Movimento')"			,""		,"",050,.F.})
	aAdd(_aParambox,{1,"N�mero do T�tulo"				,Space(tamSx3("E5_NUMERO")[1])	,""	,""															,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Inicial"		,Ctod("")						,""	,""															,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vencimento Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR04, MV_PAR05	,'Data Vencimento')"		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Digita��o Inicial"			,Ctod("")						,""	,""															,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Digita��o Final"			,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR06, MV_PAR07	,'Data Digita��o')" 		,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo D�bito Inicial"	,Space(tamSx3("E5_CCUSTO")[1])	,""	,""															,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo D�bito Final"		,Space(tamSx3("E5_CCUSTO")[1])	,""	,"U_VLFIMMAI(MV_PAR08, MV_PAR09	,'Centro Custo D�bito')"	,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Cr�dito Inicial"	,Space(tamSx3("E5_CCUSTO")[1])	,""	,""															,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Centro Custo Cr�dito Final"		,Space(tamSx3("E5_CCUSTO")[1])	,""	,"U_VLFIMMAI(MV_PAR10, MV_PAR11	,'Centro Custo Cr�dito')"	,"CTT"	,"",050,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil D�bito Inicial"	,Space(tamSx3("E5_DEBITO")[1])	,""	,""															,"CT1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil D�bito Final"	,Space(tamSx3("E5_DEBITO")[1])	,""	,"U_VLFIMMAI(MV_PAR12, MV_PAR13	,'Conta Cont�bil D�bito')"	,"CT1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Cr�dito Inicial"	,Space(tamSx3("E5_CREDITO")[1])	,""	,""															,"CT1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Conta Cont�bil Cr�dito Final"	,Space(tamSx3("E5_CREDITO")[1])	,""	,"U_VLFIMMAI(MV_PAR14, MV_PAR15	,'Conta Cont�bil Cr�dito')"	,"CT1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Prefixo do T�tulo"				,Space(tamSx3("E5_PREFIXO")[1])	,""	,""															,""		,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_CONTAB_BAIXAS"  ) +CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " COD_FILIAL IN "                   + _cCODFILIA                               ) //OBRIGATORIO (SELE��O DO COMBO)  CAMPO FILIAL(06 posi��es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " DATA_MOVIMENTO_FILTRO BETWEEN '"  + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),     " NUMERO_TITULO LIKE '%"            + _aRet[3]  + "%' "                        ) //N�O OBRIGATORIO - USUARIO DIGITA O NOME		
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),     " DATA_VENCIMENTO_FILTRO BETWEEN '" + _aRet[4]  + "' AND '" + _aRet[5]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),     " DATA_DIGITACAO_FILTRO BETWEEN '"  + _aRet[6]  + "' AND '" + _aRet[7]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),     " CC_DEBITO BETWEEN '"              + _aRet[8]  + "' AND '" + _aRet[9]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),    " CC_CREDITO BETWEEN '"             + _aRet[10] + "' AND '" + _aRet[11] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[13] ),    " CONTA_DEBITO BETWEEN '"           + _aRet[12] + "' AND '" + _aRet[13] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[15] ),    " CONTA_CREDITO BETWEEN '"          + _aRet[14] + "' AND '" + _aRet[15] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[16] ),    " PREFIXO_TITULO LIKE '%"           + _aRet[16] + "%' "			             ) //N�O OBRIGATORIO - USUARIO DIGITA O NOME		

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN


