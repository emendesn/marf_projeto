#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R12	�Autor  � Geronimo Benedito Alves																	�Data �16/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Lancamento Cont�bil x NF Saida  (Modulo 34-CTB)					���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R12()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contab. Gerencial - Cont�bil x NF Saida"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Cont�bil x NF Saida"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Cont�bil x NF Saida"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Cont�bil x NF Saida"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			02											03							04	 	 05		 06	 07							 08 09		
	Aadd(_aCampoQry, {"F2_FILIAL"	,"EMPRESA"									,"Empresa"					,"C"	,006	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_DOC"		,"NUM_NOTA"									,"Num. Nota"				,"C"	,009	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_SERIE"	,"SERIE"									,"Serie"					,"C"	,003	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_EMISSAO"	,"DATA_EMISSAO_NF			as DTEMISSANF"	,"Emissao NF"				,"D"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"ZJ_NOME"		,"TIPO_PEDIDO				as TP_PEDIDO"	,"Tipo Pedido"				,"C"	,030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"STATUS_SEFAZ				as STAT_SEFAZ"	,"Status Sefaz"				,"C"	,025	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_ZSTNFE"	,"STATUS_NFEPACK			as STNFEPACK"	,"Status NFe Pack"			,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO				as NUMPEDIDO"	,"Num. Pedido"				,"C"	,006	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE7_PEDIDO"	,"NUM_EXP"									,"Num. Exportacao"			,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"C5_ZTPOPER"	,"COD_TIPO_OPERACAO			as CODTP_OPER"	,"Codigo Tipo Operacao"		,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"TIPO_OPERACAO				as TP_OPERACA"	,"Tipo de Operacao"			,"C"	,055	,0	,""							,""	,""	 })  
	Aadd(_aCampoQry, {"F4_CODIGO"	,"CODIGO_TES"								,"C�d. Tp Entr/Saida"		,"C"	,003	,0	,""							,""	,""	 })  
	Aadd(_aCampoQry, {"F4_TEXTO"	,"DESC_TES"									,"Descr. Tp Entr/Saida"		,"C"	,020	,0	,""							,""	,""	 })  
	Aadd(_aCampoQry, {"X5_CHAVE"	,"CODIGO_FISCAL				as COD_FISCAL"	,"Codigo Fiscal"			,"C"	,006	,0	,""							,""	,""	 })  
	Aadd(_aCampoQry, {"X5_DESCRI"	,"DESC_CODIGO_FISCAL		as DESCCDFISC"	,"Descr. Codigo Fiscal"		,"C"	,055	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_INSCR"	,"CLIENTE_INSC_ESTADUAL		as INSESTATUA"	,"Inscr. Estad Cliente"		,"C"	,018	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CLIENTE				as CNPJCLIENT"	,"CNPJ Cliente"				,"C"	,018	,0	,"@!"						,""	,"@!"})				
	Aadd(_aCampoQry, {"A1_NOME"		,"RAZAO_SOCIAL				as RAZ_SOCIAL"	,"Razao Social Cliente"		,"C"	,040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F4_CODIGO"	,"COD_TRIBUTARIO_CLIENTE	as CD_TRIBCLI"	,"C�d. Tributario Cliente"	,"C"	,003	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"DESC_TRIBUTARIO_CLIENTE	as DS_TRIBCLI"	,"Descr. Tributario Cliente","C"	,055	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_TIPO"		,"TIPO_CLIENTE				as TP_CLIENTE"	,"Tipo Cliente"				,"C"	,015	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_SIMPLES"	,"SIMPLES_NACIONAL			as SIMPL_NACI"	,"Simples Nacional"			,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_TPESSOA"	,"TIPO_PESSOA				as TP_PESSOA"	,"Tipo Pessoa"				,"C"	,030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_MUN"		,"CIDADE"									,"Cidade"					,"C"	,060	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS"										,"Pais"						,"C"	,025	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_EST"		,"ESTADO"									,"Estado"					,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"D2_ITEM"		,"SEQUENCIA"								,"Sequencia"				,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"D2_COD"		,"COD_ITEM"									,"Codigo Item"				,"C"	,015	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_ITEM"								,"Descricao Item"			,"C"	,076	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"B1_CEST"		,"CEST"										,"C�d. Espec. ST"			,"C"	,009	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"B1_GRTRIB"	,"COD_TRIBUTARIO_PRODUTO	as CD_TRIBPRO"	,"C�d. Tributario Produto"	,"C"	,006	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"DESCR_TRIBUTARIO_PRODUTO	as DS_TRIBPRO"	,"Descr. Tributario Produto","C"	,055	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"D2_UM"		,"UNIDADE_MEDIDA			as UNID_MEDID"	,"Unidade Medida"			,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"BM_DESC"		,"LINHA_PRODUTO				as LINHA_PROD"	,"Linha Produto"			,"C"	,030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"BM_DESC"		,"GRUPO_ESTOQUE				as GRUP_ESTOQ"	,"Grupo Estoque"			,"C"	,030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"CT1_CONTA"	,"CONTA_CONTABIL_PROD		as CONTABPROD"	,"Conta Contabil Produto"	,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"D2_GRUPO"	,"FAMILIA"									,"Familia"					,"C"	,004	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"TIPO_PRODUTO				as TP_PRODUTO"	,"Tipo Produto"				,"C"	,055	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"ORIGEM"									,"Origem"					,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"FT_CLASFIS"	,"CST_ICMS"									,"CST Icms"					,"C"	,003	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A3_NOME"		,"REPRESENTANTE				as REPRESENTA"	,"Representante"			,"C"	,040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"C5_VOLUME1"	,"VOLUME"									,"Volume"					,"N"	,010	,0	,"@E 99999"					,""	,""	 })
	Aadd(_aCampoQry, {"D2_QUANT"	,"QTDE_ITEM"								,"Quantidade de Item"		,"N"	,018	,3	,"@E 999,999,999,999.999"	,""	,""	 })
	Aadd(_aCampoQry, {"C5_PESOL"	,"PESO_LIQUIDO				as PESO_LIQUI"	,"Peso Liquido"				,"N"	,012	,4	,"@E 999,999.9999"			,""	,""	 })
	Aadd(_aCampoQry, {"D2_PRCVEN"	,"VALOR_UNITARIO			as VLR_UNITAR"	,"Valor Unit�rio"			,"N"	,018	,6	,"@E 999,999,999.999999"	,""	,""	 })
	Aadd(_aCampoQry, {"D2_QUANT"	,"VALOR_ITEM"								,"Valor do Item"			,"N"	,018	,6	,"@E 999,999,999.999999"	,""	,""	 })
	Aadd(_aCampoQry, {"CFC_VLICMP"	,"PAUTA_FISCAL_ITEM			as PAUTA_FISC"	,"Pauta Fiscal de Item"		,"N"	,012	,2	,"@E 9,999,999.99"			,""	,""	 })
	Aadd(_aCampoQry, {"D2_CONTA"	,"CONTA_CONTABIL			as CONTA_CONT"	,"Conta Contabil"			,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"C5_DESPESA"	,"DESPESAS_ACESSORIAS		as DESPEACESS"	,"Despesas Acess�rias"		,"N"	,017	,2	,"@E 999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F4_ICM"		,"INCID_ICMS"								,"Incid. Icms"				,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F3_ALIQICM"	,"PCT_ICMS"									,"Pct Icms"					,"N"	,008	,2	,"@E 9,999.99"				,""	,""	 })
	Aadd(_aCampoQry, {"F2_VALICM"	,"ICMS"										,"Icms"						,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F2_BASEICM"	,"BASE_CALC_ICMS			as BASE_ICMS"	,"Base de Calculo do Icms"	,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F2_VALIPI"	,"IPI"										,"IpI"						,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_VALPIS"	,"VALOR_PIS"								,"PIS"						,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_VALCOF"	,"VALOR_COFINS				as VL_COFINS"	,"Cofins"					,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"D2_BRICMS"	,"BASE_ICMS_RETIDO			as ICMS_RETID"	,"Base Icms Retido"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F3_ICMSRET"	,"VALOR_ICMS_ST				as VL_ICMS_ST"	,"Valor Icms ST"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F2_VALICM"	,"VALOR_ICMS"								,"Valor Icms"				,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_CSTCOF"	,"CST_COFINS"								,"CST Cofins"				,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"FT_ALIQCOF"	,"PCT_COFINS"								,"Perc. Cofins"				,"N"	,007	,4	,"@E 99.9999"				,""	,""	 })
	Aadd(_aCampoQry, {"FT_CSTPIS"	,"CST_PIS"									,"CST PIS"					,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"FT_CTIPI"	,"CST_IPI"									,"CST IPI"					,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"FT_ALIQPIS"	,"PCT_PIS"									,"Perc. PIS"				,"N"	,007	,4	,"@E 99.9999"				,""	,""	 })
	Aadd(_aCampoQry, {"F4_COFDSZF"	,"COFINS_DESC_ZF			as COFINSDEZF"	,"Cofins Desc. Zona Franca", "C"	,001	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"D2_DESCZFR"	,"ICMS_DESC_ZF				as ICMS_DESC"	,"Icms Desc Zona Franca"	,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"D2_DESCZFP"	,"PIS_DESC_ZF				as PIS_DESCZF"	,"Pis Desc Zona Franca"		,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"D2_DESCZFR"	,"DESC_ZF"									,"Desc Zona Franca"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_MARGEM"	,"ICMS_ST_MARGEM			as ICMS_MARGE"	,"Icms Subs Trib Margem"	,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"C5_TPFRETE"	,"TIPO_FRETE"								,"Tipo Frete"				,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_FRETE"	,"VALOR_FRETE_NF			as VLR_FR_NF"	,"Valor Frete NF"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_FRETE"	,"VALOR_FRETE_RATEADO_KG	as VLR_FR_KG"	,"Valor Frete Rateado"		,"N"	,016	,4	,"@E 999,999,999.9999"		,""	,""	 })
	Aadd(_aCampoQry, {"B1_POSIPI"	,"NBM"										,"NBM"						,"C"	,005	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A4_COD"		,"COD_TRANSPORTADORA		as CODTRANSPO"	,"Codigo Transportadora"	,"C"	,006	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A4_NOME"		,"TRANSPORTADORA			as TRANSPORTA"	,"Nome Transportadora"		,"C"	,040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"DA3_PLACA"	,"PLACA"									,"Placa"					,"C"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A4_EST"		,"UF_TRANSPORTADORA			as UFTRANSPOR"	,"UF Transportadora"		,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"E4_DESCRI"	,"CONDICAO_PAGAMENTO		as COND_PAGTO"	,"Condicao Pagamento"		,"C"	,015	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_TIPODOC"	,"TIPO_DOCUMENTO			as TP_DOCUMEN"	,"Tipo Documento"			,"C"	,002	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_ZPROTNF"	,"PROTOCOLO"								,"Protocolo"				,"C"	,015	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_CHVNFE"	,"CHAVE_SEFAZ				as CHAV_SEFAZ"	,"Chave Sefaz"				,"C"	,044	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"F2_SEGURO"	,"VALOR_SEGURO				as VLR_SEGURO"	,"Valor do Seguro"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"BM_DESC"		,"NUM_ROTEIRO				as NUMROTEIRO"	,"Numero do Roteiro"		,"C"	,030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"FT_BASEDES"	,"BASE_DIFAL"								,"Base Difal Destino"		,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_PDDES"	,"PCT_ICMS_DESTINO			as PCTICMSDES"	,"Perc. ICMS Destino"		,"N"	,010	,2	,"@E 999,999.99"			,""	,""	 })
	Aadd(_aCampoQry, {"F3_ICMSCOM"	,"DIFAL_UF_ORIGEM			as DIFAL_ORIG"	,"Difal UF Origem"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"F3_DIFAL"	,"DIFAL_UF_DESTINO			as DIFAL_DEST"	,"Difal UF Destino"			,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_ALQFECP"	,"PCT_FUNDO_POBREZA			as PCTPOBREZA"	,"Perc. Fundo Pobreza"		,"N"	,009	,2	,"@E 9,999,999.99"			,""	,""	 })
	Aadd(_aCampoQry, {"FT_VFCPDIF"	,"VALOR_FUNDO_POBREZA		as VL_POBREZA"	,"Valor Fundo Pobreza"		,"N"	,017	,2	,"@E 99,999,999,999.99"		,""	,""	 })
	Aadd(_aCampoQry, {"FT_GRPCST"	,"ENQ_DE_IPI"								,"Enq de IPI"				,"C"	,003	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_RE"		,"REGISTRO_EXPORTACAO		as REG_EXPORT"	,"Registro Exportacao"		,"C"	,012	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EXL_NROMEX"	,"MEMORANDO_EXPORTACAO		as MEMO_EXPOR"	,"Memorando Exportacao"		,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EXL_DTMEX"	,"DATA_MEMORANDO_EXPORTACAO as DT_MEMORAN"	,"Data Memorando Exp"		,"D"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_NRSD"	,"NUM_SOLIC_DESPACHO		as NSOLICDESP"	,"Num. Solic. Despacho"		,"C"	,020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_DTRE"	,"DATA_RE"									,"Data RE"					,"D"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_DTAVRB"	,"AVERB_SD"									,"Averb SD"					,"D"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"C5_FECENT"	,"DATA_ENTREGA				as DATAENTREG"	,"Data Entrega"				,"D"	,008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A3_COD"		,"CODIGO_VENDEDOR			as CODVENDEDO"	,"Codigo Vendedor"			,"C"	,006	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR				as NOMVENDEDO"	,"Nome do Vendedor"			,"C"	,040	,0	,""							,""	,""	 })

	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissao')"	,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Codigo Fiscal Inicial"	,Space(tamSx3("X5_CHAVE")[1])	,""		,""													,"13"	,"",050,.F.})	
	aAdd(_aParambox,{1,"Codigo Fiscal Final"	,Space(tamSx3("X5_CHAVE")[1])	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Codigo Fiscal')"	,"13"	,"",050,.F.})	
	aAdd(_aParambox,{1,"Numero da Nota"			,Space(tamSx3("F2_DOC")[1])		,""		,""													,""		,"",050,.F.})	
	aAdd(_aParambox,{1,"Conta Cont�bil Inicial"	,Space(tamSx3("CT1_CONTA")[1])	,""		,""													,"CT1"	,"",075,.F.})	
	aAdd(_aParambox,{1,"Conta Cont�bil Final"	,Space(tamSx3("CT1_CONTA")[1])	,""		,"U_VLFIMMAI(MV_PAR06, MV_PAR07, 'Conta Cont�bil')"	,"CT1"	,"",075,.F.})	

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_LANCCONTABNFSAIDA"  )     + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " EMPRESA  IN "                     + _cCODFILIA  + CRLF                        ) //OBRIGATORIO - SELECIONAR AS FILIAIS
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_EMISSAO_NF_FILTRO BETWEEN '" + _aRet[1]    + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDA��O DE 366 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " CODIGO_FISCAL BETWEEN '"          + _aRet[3]    + "' AND '" + _aRet[4]	+ "' " ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),      " NUM_NOTA LIKE '%"                 + _aRet[5]    + "%' "                       ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),      " CONTA_CONTABIL BETWEEN '"         + _aRet[6]    + "' AND '" + _aRet[7]	+ "' " ) //NAO OBRIGATORIO 

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
