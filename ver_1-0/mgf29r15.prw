#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R15	�Autor  � Geronimo Benedito Alves																	�Data �08/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTACAO - Controle AWB x ETA						���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R15()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTACAO - Controle AWB x ETA"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Controle AWB x ETA"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Controle AWB x ETA"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Controle AWB x ETA"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03						 04	 05	  	 06  07			  08 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP"								,"N� EXP"				,"C",013	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"								,"Ano EXP"				,"C",002	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"								,"SUBEXP"				,"C",003	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_TRADING 		as COD_TRADIN"	,"Cod. Trading"			,"C",006	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_TRADING 			as NOM_TRADIN"	,"Nome Trading"			,"C",040	,0, ""				,	,})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_IMPORTADOR 	as COD_IMPORT"	,"Cod. Importador"		,"C",006	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADOR		as NOM_IMPORT"	,"Nome Importador"		,"C",040	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_CONSIGNEE		as COD_CONSIG"	,"Cod. Consignee"		,"C",006	,0, "" 				,	,})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE		as NOM_CONSIG"	,"Nome Consignee"		,"C",040	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"								,"Navio"				,"C",040	,0, ""				,	,})
	Aadd(_aCampoQry, {"Y5_NOME"		,"AGENCIA"								,"Agencia"				,"C",040	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATA_BL"								,"Data Embarque"		,"D",008	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_TRSTIM"	,"TRANSIT_TIME 			as TRANSITE"	,"Transit Time"			,"N",010	,0, "@E 99999999999",	,})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO 		as PORTO_DEST"	,"Porto Destino"		,"C",020	,0, ""				,	,})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_PORTO_DESTINO	as PAIS_DEST"	,"Pa�s Destino"			,"C",025	,0, ""				,	,})
	Aadd(_aCampoQry, {"BDM_DESCRI"	,"STATUS"								,"Status"				,"C",035	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EX9_CONTNR"	,"NUM_CONTAINER 		as NCONTAINER"	,"N� Container"			,"C",020	,0, "" 				,	,})
	Aadd(_aCampoQry, {"EEC_COURI2"	,"COURIER_BANCO 		as COUR_BANCO"	,"Courrier Banco"		,"C",030	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_COURIE"	,"COURIER_IMPORTADOR	as COUR_IMPOR"	,"Courrier Importador"	,"C",030	,0, ""				,	,})
	Aadd(_aCampoQry, {"EEC_DTENDC"	,"DATA_AWB"								,"Data Env. Docs"		,"D",008	,0, ""				,	,})
	Aadd(_aCampoQry, {"ZC7_DTENTR"	,"DATA_ENTREGA			as DT_ENTREGA"	,"Data de Entrega"		,"D",008	,0, ""				, 	,})

	aAdd(_aParambox,{1,"Data Embarque Inicial"	,Ctod("")					,""	,"" 											,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Embarque Final"	,Ctod("")					,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"	,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Trading Inicial"		,Space(tamSx3("A1_COD")[1])	,""	,"" 											,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Trading Final"			,Space(tamSx3("A1_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR03,MV_PAR04,'Trading')"		,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Importador Inicial"		,Space(tamSx3("A1_COD")[1])	,""	,"" 											,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Importador Final"		,Space(tamSx3("A1_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR05,MV_PAR06,'Importador')"	,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Data AWB Inicial"		,Ctod("")					,""	,"" 											,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data AWB Final"			,Ctod("")					,""	,"U_VLDTINIF(MV_PAR07, MV_PAR08, _nInterval)"	,""		,"",050,.F.})
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_EX_CONTROLAWBXETA"  )       + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DATA_BL_FILTRO  BETWEEN '"   + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " FILIAL_FILTRO IN "           + _cCODFILIA                             ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " CODIGO_TRADING BETWEEN '"    + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //NAO � OBRIGATORIO (CODIGO DE ATE - TABELAS SA1010)
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " CODIGO_IMPORTADOR BETWEEN '" + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NAO � OBRIGATORIO (CODIGO DE ATE - TABELAS SA1010)
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " DATA_AWB_FILTRO	 BETWEEN '" + _aRet[7] + "' AND '" + _aRet[8] + "' " ) //NAO � OBRIGATORIO (CODIGO DE ATE - TABELAS SA1010)

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

