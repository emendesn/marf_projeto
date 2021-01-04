#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R12	�Autor  � Geronimo Benedito Alves																	�Data �  07/03/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Fluxo Contas a Pagar				(Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R12()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contas a Pagar - Fluxo Contas a Pagar"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Fluxo Contas a Pagar"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Fluxo Contas a Pagar"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Fluxo Contas a Pagar"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 360												//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02										 03							 04	 05	 	 06	 07						 08		 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"							,"Cod. Filial"				,"C",009	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"							,"Nome Filial"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"								,"Prefixo"					,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"TIPO"									,"Tipo"						,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FATPREF"	,"PREF_FATURA			as PREFFATURA"	,"Prefixo Fatura"			,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_ZNPORTA"	,"ID_PORTAL"							,"Id. Portal"				,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FORNECE"	,"COD_FORNECEDOR		as CODFORNECE"	,"Cod. Fornecedor"			,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_LOJA"		,"COD_LOJA"								,"Cod. Loja"				,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_FORNECEDOR		as CNPJFORNEC"	,"CNPJ Fornecedor"			,"C",018	,0	,"@!"					,""		,"@!"	}) 
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR		as NOMEFORNEC"	,"Nome Fornecedor"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_ZCGCFAV"	,"CNPJ_FAVORECIDO		as CNPJFAVORE"	,"CNPJ Favorecido"			,"C",018	,0	,"@!"					,""		,"@!"	}) 
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FAVORECIDO		as NOMEFAVORE"	,"Nome Favorecido"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_ENT_SISTEMA		as DTENTSISTE"	,"Data Entrada Sistema"		,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_ZDTNPR"	,"DT_EMISSAO_NPR		as DTEMISSNPR"	,"Data Emissao NPR"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"DT_EMISSAO"							,"Data Emissao"				,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VENCIMENTO			as DT_VENCIME"	,"Data Vencimento"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_VENCIMENTO_REAL	as DTVENCREAL"	,"Data Vencimento Real"		,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_PAGAMENTO			as DT_PAGAMEN"	,"Data Pagamento"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"NUM_TITULO"							,"N� Titulo"				,"C",009	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_PARCELA"	,"NUM_PARCELA			as NUMPARCELA"	,"N� Parcela"				,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_MOEDA"	,"COD_MOEDA"							,"Cod. Moeda"				,"N",002	,0	,"@E 99"				,""		,""	})
	Aadd(_aCampoQry, {"AFK_GRTDE"	,"NOM_MOEDA"							,"Nome Moeda"				,"C",005	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_NF"								,"Valor NF"					,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_SALDO"	,"VALOR_LIQUIDO_PAGAR	as VLRLIQPAGA"	,"Valor Liq. Pagar"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_PAGO"							,"Valor Pago"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_ACRESC"	,"VLR_ACRESCIMO			as VLRACRESCI"	,"Acrescimo"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_DECRESC"	,"VLR_DECRESCIMO		as VLRDECRESC"	,"Decrescimo"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_ISS"		,"VLR_ISS"								,"Iss"						,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_INSS"		,"VLR_INSS"								,"Inss"						,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR_FUNRURAL		as VLRFUNRURA"	,"Valor Funrural"			,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_IRRF"		,"VLR_IRRF"								,"Irpf"						,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_PIS"		,"VLR_PIS"								,"Pis"						,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_COFINS"	,"VLR_COFINS"							,"Cofins"					,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_CSLL"		,"VLR_CSLL"								,"Csll"						,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	})
	Aadd(_aCampoQry, {"E2_FORBCO"	,"COD_BCO_FOR_FAV		as CDBCOFORNE"	,"Banco do Fornecedor"		,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FORAGE"	,"COD_AG_FOR_FAV		as CDAGEFORNE"	,"Ag. Bancaria Fornec."		,"C",005	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FAGEDV"	,"COD_DV_AG_FOR_FAV		as DVAGEFORNE"	,"Digito Verif. Agencia"	,"C",001	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FORCTA"	,"COD_CONTA_FOR_FAV		as CDCTAFORNE"	,"Conta do Fornecedor"		,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_FCTADV"	,"COD_DV_CONTA_FOR_FAV	as DVCTAFORNE"	,"Digito Verificador Conta"	,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_XFINALI"	,"TIP_CONTA"							,"Tipo Conta"				,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_XAGOP"	,"COD_AG_OP"							,"Cod. Agencia Operacao"	,"C",004	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_XDVOP"	,"COD_DV_OP"							,"Cod. Digito Verif. Oper."	,"C",001	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"BBD_DESINT"	,"FORMA_PG"								,"Forma de Pagto"			,"C",015	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_NUMBOR"	,"NUM_BORDERO			as NUMBORDERO"	,"N� Bordero"				,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_LOTE"		,"NUM_LOTE"								,"N� Lote"					,"C",004	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_IDCNAB"	,"ID_CNAB"								,"Id. CNAB"					,"C",015	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_BANCO"	,"NUM_BANCO_PAGADOR		as NUMBCAPAGA"	,"N� Banco Pagador"			,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_CONTA"	,"NUM_CONTA_PAGADOR		as NUMCTAPAGA"	,"N� Conta Pagador"			,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"COD_NATUREZA			as CODNATUREZ"	,"Cod. Natureza"			,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESC_NATUREZA			as DESNATUREZ"	,"Desc. Natureza"			,"C",030	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CB1_DESSTA"	,"MOD_INCLUSAO			as MODINCLUSA"	,"Mod. Inclusao"			,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CB1_DESSTA"	,"USR_INCLUSAO			as USRINCLUSA"	,"USR Inclusao"				,"C",010	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CB1_DESSTA"	,"E2_HIST"								,"Historico"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"D12_DOC"		,"SIT_TITULO"							,"Situacao Titulo"			,"C",009	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_CODBAR"	,"COD_BARRAS"							,"Codigo de Barras"			,"C",044	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E5_MOTBX"	,"MOTIVO_BAIXA"							,"Motivo da Baixa"			,"C",030	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"E2_XOBS"		,"OBS_AUDIT"							,"Observacao Produto" 		,"C",2020	,0	,""						,""		,""	})

	Aadd(_aCampoQry, {"CR_DATALIB"	,"DT_LIBERACAO_GRADE1"				,"Data Liberacao Aprov 1"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CR_DATALIB"	,"DT_LIBERACAO_GRADE2"				,"Data Liberacao Aprov 2"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CR_DATALIB"	,"DT_LIBERACAO_GRADE3"				,"Data Liberacao Aprov 3"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CR_DATALIB"	,"DT_LIBERACAO_GRADE4"				,"Data Liberacao Aprov 4"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"CR_DATALIB"	,"DT_LIBERACAO_GRADE5"				,"Data Liberacao Aprov 5"			,"D",008	,0	,""						,""		,""	})

	aAdd(_aParambox,{1,"Dt vencimento Real Inicial"	,Ctod("")						,""		,"" 												,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Dt vencimento Real Final"	,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)" 		,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento Inicial"		,Ctod("")						,""		,"" 												,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Pagamento Final"		,Ctod("")						,""		,"U_VLDTINIF(MV_PAR03, MV_PAR04, _nInterval)"		,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,"@!"	,"" 												,"SA2"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"		,Space(tamSx3("A2_COD")[1]) 	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod.Fornecedor')"	,"SA2"		,"",050,.F.})		
	aAdd(_aParambox,{1,"Natureza Inicial"			,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"" 												,"SED"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Natureza Final"				,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Natureza')"		,"SED"		,"",050,.F.})  
	aAdd(_aParambox,{1,"Data Vencimento Inicial"	,Ctod("")						,"@!"	,"" 												,""			,"",050,.F.})  
	aAdd(_aParambox,{1,"Data Vencimento Final"		,Ctod("")						,"@!"	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod.Fornecedor')"	,""			,"",050,.F.})		
	aAdd(_aParambox,{1,"Banco"						,Space(tamSx3("A6_COD")[1])		,"@!"	,"" 												,"SA6BCO"	,"",040,.F.})  
	aAdd(_aParambox,{1,"N� Bordero Inicial"			,Space(tamSx3("E2_NUMBOR")[1])	,"@!"	,"" 												,""			,"",040,.F.})  
	aAdd(_aParambox,{1,"N� Bordero Final"			,Space(tamSx3("E2_NUMBOR")[1])	,"@!"	,"" 												,""			,"",040,.F.})  

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	If empty(_aRet[1]) .and. empty(_aRet[4])
		MsgStop("� obrigatorio informar ou a datas de Vencimentos Real e/ou as Datas dos Pagamentos.")
		Return.F.
	Endif

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_FLUXO" )  +CRLF 

	If !empty(_aRet[2]) .and. !empty(_aRet[4])
		_cQuery += U_WhereAnd( .T. ,   " ( DT_VENCIMENTO_REAL_F BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  +  ; 
					" OR DT_PAGAMENTO_FILTRO BETWEEN '"   + _aRet[3] + "' AND '" + _aRet[4] + "' )" ) // OBRIGATORIO UM CAMPO OU OUTRO, COM A VALIDACAO DE 360 DIAS

	ElseIf empty(_aRet[2])
		_cQuery += U_WhereAnd( .T. ,   " DT_PAGAMENTO_FILTRO BETWEEN '" + _aRet[3] + "' AND '" + _aRet[4] + "' "	) 

	ElseIf empty(_aRet[4])
		_cQuery += U_WhereAnd( .T. ,   " DT_VENCIMENTO_REAL_F BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "	) 

	Endif

	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " COD_FORNECEDOR  BETWEEN '"      + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " COD_NATUREZA  BETWEEN '"        + _aRet[7]  + "' AND '" + _aRet[8]  + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),   " DT_VENCIMENTO_FILTRO BETWEEN '" + _aRet[9]  + "' AND '" + _aRet[10] + "' " ) // NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),   " BANCO_FORNECEDOR = '"           + _aRet[11] + "'  "                        ) // NAO OBRIGATORIO, USUARIO DIGITA, SEM CONSULTA GENERICA
	_cQuery += U_WhereAnd( !empty(_aRet[13] ),   " NUM_BORDERO  BETWEEN '"         + _aRet[12] + "' AND '" + _aRet[13] + "' " ) // NAO OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN