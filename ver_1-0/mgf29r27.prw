#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R27	�Autor  � Geronimo Benedito Alves																	�Data �10/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTA��O - Shippinh Schedule						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R27()
	
	Local cEnviroSrv	:= ""
	
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTA��O - Shipping Schedule"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Shipping Schedule"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Shipping Schedule"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Shipping Schedule"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao(Sum,Count,max,etc), a ele � dado a ele um apelido, indicado    
	//pela clausula "as" que sera transportado para o elemento 8. Se o apelido nao for criado, o programa cria-o automaticamente, em tempo de execucao
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02											 03							 04	 05		 06	 07							 08		 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP"									,"Exp Num."					,"C",013	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"									,"Year"						,"C",002	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"									,"Item"						,"C",003	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_REFIMP"	,"REF_IMPORT"								,"PO Num."					,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_TRADING				as NOM_TRADIN"	,"Trading"					,"C",040	,0	,""							,""		,""	 })
 	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"								,"Buyer"					,"C",040	,0	,""							,""		,""	 })
 	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADOR			as NOMEIMPORT"	,"Importer"					,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE			as NOM_CONSIG"	,"Consignee"				,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_ZOBSWE"	,"OBS_WEEK"									,"Week"						,"C",090	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_DTEMBA"	,"EMB_PORTO"								,"Emb.Porto"				,"D",008	,0	,""							,""		,""	 })
    Aadd(_aCampoQry, {"M0_FILIAL"	,"FILIAL_PRODUTORA 			AS FILPRODU"	,"PLANT PRODUCER"			,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_ZDTEST"	,"DATA_ESTUFAGEM_PCP		as DTESTUFPCP"	,"Ready At Plant"			,"D",008	,0	,""							,""		,""	 })
//  Aadd(_aCampoQry, {"ZB8_ZDTPES"	,"DATA_ESTUFAGEM_TRANSPORTE	as DTESTUFTRP"	,"Ready (Logistica)"		,"D",008	,0	,""							,""		,""	 })
//  Aadd(_aCampoQry, {"ZBM_DESCRI"	,"LOCAL_ESTUFAGEM			as LOCAL_ESTU"	,"Plant"					,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"XXXXXXX001"	,"TIPO_TRANSB_ARMAZ			as TIPOTRANAR"	,"Type"						,"C",015	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_ZLOCAL"	,"LOCAL_TRANSB_ARMAZ		as LOCATRANAR"	,"Loading Place"			,"C",006	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_ZDTTRA"	,"DATA_TRANSB_ARMAZ			as DATATRANAR"	,"Loading Date"				,"D",008	,0	,""							,""		,""	 })
//  Aadd(_aCampoQry, {"EEC_ZSIFEX"	,"EXPORTADOR_EMBARQUE		as EXPORT_EMB"	,"Producer"					,"C",006	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZZR_PERDE"	,"DATA_PRODUCAO_DE			as DTPROD_DE"	,"Production Date(From)"	,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZZR_PERATE"	,"DATA_PRODUCAO_ATE			as DTPROD_ATE"	,"Production Date(To)"		,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EX9_CONTNR"	,"NUM_CONTAINER				as NCONTAINER"	,"Container Num."			,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZZR_DTESTU"	,"DATA_ESTUFAGEM			as DATAESTUFA"	,"Stuffed Date"				,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"Y5_NOME"		,"AGENCIA"									,"Shipping Line"			,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZNUMRE"	,"NUM_RESERVA				as NRESERVA"	,"Booking Num."				,"C",030	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"									,"Vessel"					,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YR_CID_ORI"	,"PORTO_ORIGEM				as PORTO_ORIG"	,"Origin Port"				,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZETAOR"	,"DATA_ETA_ORIGEM			as DT_ORIGEM"	,"Eta Origin"				,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_TRSTIM"	,"TRANSIT_TIME				as TRANSIT"		,"Transit Time"				,"N",010	,0	,"@E 99999999999"			,""		,""	 })
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO				as PORTO_DEST"	,"Destination Port"			,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_PORTO_DESTINO		as PAIS_DESTI"	,"Destination Country"		,"C",025	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO				as TP_PRODUTO"	,"Type Product"				,"C",045	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YC_NOME"		,"FAMILA_PRODUTO			as FAM_PRODUT"	,"Family"					,"C",045	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_INCOTE"	,"SALES_TERMS				as SALESTERMS"	,"Sales Terms"				,"C",003	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YP_TEXTO"	,"TIPO_PAGAMENTO			as TP_PAGTO"	,"Pymt Terms"				,"C",080	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_MOEDA"	,"MOEDA"									,"Currency"					,"C",003	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VALOR_PROFORMA "							,"Valor Proforma"			,"N",012	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VAL_PAGO_ANTECIPADO		as VL_PGTOANT"	,"Advance Value"			,"N",012	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VALOR_PARCIAL				as VALORPARCI"	,"Partial PYMT"				,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"EE9_PSLQTO"	,"PESO_LIQUIDO				as PESOLIQUID"	,"Net Weight"				,"N",016	,3	,"@E 999,999,999,999.999"	,""		,""	 })
	Aadd(_aCampoQry, {"EE9_PSBRTO"	,"PESO_BRUTO"								,"Gross Weight"				,"N",016	,3	,"@E 999,999,999,999.999"	,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"TOTAL_CAIXA				as TOTALCAIXA"	,"Total Amount"				,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"TOTAL_ROMANEIO			as TOTALROMAN"	,"Total Invoiced"			,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"EEC_DLDRAF"	,"DATA_DEADLINE_DRAFT		as DATA_DRAFT"	,"Deadline Draft"			,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_DLCARG"	,"DATA_DEADLINE_CARGA		as DATA_CARGA"	,"Deadline Cargo"			,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"Y5_NOME"		,"STATUS"									,"Status"					,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"Y5_NOME"		,"DESPACHANTE				as DESPACHANT"	,"Forwarder"				,"C",040	,0	,""							,""		,""	 })
//	Aadd(_aCampoQry, {"ZB8_DTEMBA"	,"DT_EMB_PORTO"								,"Dt.Emb.Porto"				,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YQ_DESCR"	,"TIPO_TRANSPORTE			as TP_TRANSPO"	,"Via"						,"C",015	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZCONT"	,"TIPO_PGTO_FRETE			as TPPAGTFRET"	,"Freight type"				,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_RESPON"	,"TRADER "									,"Trader"					,,	,	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR				as ADMINISTRA"	,"Adm"						,"C",035	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EE7_PEDFAT"	,"PV_PEDIDO_VENDA			as PEDI_VENDA"	,"PV Num."						,"C",006	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADORNF			as NOM_IMP_NF"	,"Buyer NF"					,"C",040	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZDTRES"	,"DATA_RESERVA				as DATARESERV"	,"Data Reserva"				,"D",008	,0	,""							,""		,""	 })
//	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL_TRANSPORTE		as DTBLTRANSP"	,"Data BL Transporte"		,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"XXPEDIEX01"	,"PEDIDO_EXPORTACAO			as PEDIEXPORT"	,"Pedido Exportacao"		,"C",020	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"XXNUMDUE02"	,"NUM_DUE"									,"No. Due"					,"C",014	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"XXDATDUE03"	,"DATA_DUE"									,"Data Due"					,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"XXFRETIN04"	,"FRETE_INTERM"								,"Frete Interm."			,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"XXSEGUIN05"	,"SEGURO_INTERM				as SEGUINTERM"	,"Seguro Interm"			,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"XXTOTFOB06"	,"TOTAL_FOB"								,"Total FOB"				,"N",016	,2	,"@E 999,999,999,999.99"	,""		,""	 })
	Aadd(_aCampoQry, {"YP_TEXTO"	,"RE"										,"RE"						,"C",080	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"YP_TEXTO"	,"SD"										,"SD"						,"C",080	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"D2_EMISSAO"	,"DATA_NF"									,"Data NF"					,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"D2_DOC"		,"NF"										,"No. NF"					,"C",009	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL"									,"Data BL"					,"D",008	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"EEC_ZDTSNA"	,"DATA_SAIDA_NAVIO			as DTSAINAVIO"	,"Data Saida Navio"			,"D",008	,0	,""							,""		,""	 })
	// RVBJ
	Aadd(_aCampoQry, {"ZB8_INLAND"	,"ZB8_INLAND"								,"Inland"					,"C",015	,0	,""							,""		,""	 })
	Aadd(_aCampoQry, {"ZB8_DTPROC"	,"ZB8_DTPROC"								,"Dt.Processo"				,"D",008	,0	,""							,""		,""	 })

	aAdd(_aParambox,{1,"Numero EXP"						,Space(tamSx3("ZB8_EXP")[1])	,"@!"	,""													,""			,"",050,.F.})	//01
	aAdd(_aParambox,{1,"Numero EXP"						,Space(tamSx3("ZB8_EXP")[1])	,"@!"	,""													,""			,"",050,.F.})	//02
	aAdd(_aParambox,{1,"Administrador"					,Space(tamSx3("ZB8_RESPON")[1])	,"@!"	,"" 												,""			,"",115,.F.})	//03   											
	aAdd(_aParambox,{1,"Nome Buyer"						,Space(tamSx3("A1_NOME")[1])	,"@!"	,""													,"VSA1"		,"",115,.F.})	//04											
	aAdd(_aParambox,{1,"Nome Trading"					,Space(tamSx3("A1_NOME")[1])	,"@!"	,""													,"VSA1"		,"",115,.F.})	//05											
	aAdd(_aParambox,{1,"Despachante"					,Space(tamSx3("Y5_NOME")[1])	,"@!"	,""													,"Y5A"		,"",115,.F.})	//06											
	aAdd(_aParambox,{1,"Nome Familia Produto"			,Space(tamSx3("EEH_NOME")[1])	,"@!"	,""													,"EEH90"	,"",115,.F.})	//07											
	aAdd(_aParambox,{1,"Pais Destino  (em portugues)"	,Space(tamSx3("YA_DESCR")[1])	,"@!"	,""													,"SYAEXP"	,"",115,.F.})	//08											
	aAdd(_aParambox,{1,"Negocio"						,Space(tamSx3("EEG_NOME")[1])	,"@!"	,""													,""			,"",115,.F.})	//09											
	aAdd(_aParambox,{1,"Porto Origem"					,Space(tamSx3("YR_CID_ORI")[1])	,"@!"	,""													,"SYRCID"	,"",075,.F.})	//10												
	aAdd(_aParambox,{1,"Data Reserva Inicial"			,Ctod("")						,""		,""													,""			,"",050,.F.})	//11
	//	RVBJ
	aAdd(_aParambox,{1,"Data Reserva Final"				,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR11, MV_PAR12, 'Data Reserva')"	,""			,"",050,.F.})	//12
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)	// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))
	IF cEnviroSrv $ 'PRODUCAO/PRE_RELEASE'                 
		_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_SHIPPPINGSCHEDULE"  )          + CRLF
	Else
		_cQuery += "  FROM V_EX_SHIPPPINGSCHEDULE"           + CRLF
	EndIF

		_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " FILIAL_FILTRO IN "                 + _cCODFILIA                               )//OBRIGATORIO (SELE��O DO COMBO)  CAMPO EMPRESAS(02 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " NUM_EXP BETWEEN '"            		+ _aRet[1] + "' AND '" + _aRet[2] + "' "   ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " ADMINISTRADOR LIKE '%"             + _aRet[3] + "%' "                         )//NAO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " NOME_BUYER LIKE '%"                + _aRet[4] + "%' "                         )//NAO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[5] ),      " NOME_TRADING LIKE '%"              + _aRet[5] + "%' "                         )//NAO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " DESPACHANTE LIKE '%"               + _aRet[6] + "%' "                         )//NAO � OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),      " FAMILA_PRODUTO LIKE '%"            + _aRet[7] + "%' "                         )//NAO � OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),      " PAIS_PORTO_DESTINO_FILTRO LIKE '%" + _aRet[8] + "%' "                         )//NAO � OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),      " NEGOCIO LIKE '%"                   + _aRet[9] + "%' "                         )//NAO � OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),     " PORTO_ORIGEM LIKE '%"              + _aRet[10] + "%' "                        )//NAO � OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[12] ),     " DATA_RESERVA_FILTRO BETWEEN '"     + _aRet[11] + "' AND '" + _aRet[12] + "' " )// --SEM TRAVA DE DATA

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
