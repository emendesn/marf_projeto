#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R33	�Autor  � Geronimo Benedito Alves																	�Data �08/01/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTA��O - Controle AWB x ETA						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R33()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery/*, _cCODFILIA*/
	Private _nInterval/*, _aSelFil		:= {}*/
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTA��O - Performance NF x BL"	)		// 01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Performance NF x BL"				)	// 02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Performance NF x BL"}				)	// 03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Performance NF x BL"}				)	// 04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {})							// 05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	// 06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35							// Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//				  01	 		 02										 	 03					 04	 05	  	 06  07		 08 	 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUMERO_EXP"								,"No. EXP"			,"C",013	,0	,"" 	,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO"										,"Ano EXP"			,"C",002	,0	,"" 	,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"ITEM_SUB"									,"SUBEXP"			,"C",003	,0	,"" 	,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"TRADING"									,"Trading"			,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"BUYER"									,"Buyer"			,"C",040	,0	,""		,""		,""	})
 	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_PORTO_DESTINO	as PAIS_DEST"		,"Pa�s Destino"		,"C",025	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"D2_DOC"		,"NF"										,"Nota Fiscal"		,"C",009	,0	,""		,""		,""	})
 	Aadd(_aCampoQry, {"C5_EMISSAO"	,"DATA_NF				as DT_EMISSAO"		,"Data Emissao"		,"D",008	,0 	,""		,""		,""	})
	AAdd(_aCampoQry, {"ZV_DTBLQ"	,"DATA_BL_TRANSPORTE AS DTBL1"				,"Data Bloqueio"	,"D",008	,0 	,""		,""		,""	})
	AAdd(_aCampoQry, {"ZV_DTBLQ"	,"DATA_BL AS DTBL2"							,"Data Bloqueio"	,"D",008	,0 	,""		,""		,""	})
	Aadd(_aCampoQry, {"C6_NOTA"		,"NF_BL"									,"No. Nota Fiscal"	,"C",009	,0 	,""		,""		,""	})
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR		as ADMINISTRA"			,"Adm"				,"C",035	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"TRADER"									,"Trader"			,"C",035	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"FAMILA_PRODUTO	as FAM_PRODUT"			,"Familia"			,"C",045	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"ZB8_MOEDA"	,"MOEDA"									,"Moeda"			,"C",003	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"YQ_DESCR"	,"VIA"										,"Navio"			,"C",040	,0	,""		,""		,""	})
	Aadd(_aCampoQry, {"EE9_PRCTOT"	,"VLR_ITEM_EMB AS VLRIEMB"					,"Total"			,"N",015	,2	,"@E 999,999,999,999.99"	,""		,""	 })

	aAdd(_aParambox,{1,"Data NF Inicial"		,Ctod("")						,""		,""													,""		,	,050,.F.})
	aAdd(_aParambox,{1,"Data NF Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrega')"	,""		,	,050,.F.})
	aAdd(_aParambox,{1,"Administrador"			,Space(tamSx3("ZB8_RESPON")[1])	,"@!"	,"" 												,""		,"" ,115,.F.})	  											
	aAdd(_aParambox,{1,"Nome Familia Produto"	,Space(tamSx3("EEH_NOME")[1])	,"@!"	,""													,""		,"" ,115,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	If _aRet[1] > _aRet[2]
		MsgStop("A Data de Entrega Inicial, nao pode ser maior que a data de Entrega Final.")
		Return .F.
	Endif

	_cQuery += " FROM " + U_IF_BIMFR("IF_BIMFR", "V_EX_PERFORMANCE_NF_BL"  )       + CRLF
	
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_NF_FILTRO BETWEEN '"   + _aRet[1]  + "' AND '" + _aRet[2] + "'  " ) // OBRIGATORIO, COM A VALIDA��O DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),      " ADMINISTRADOR LIKE '%"             + _aRet[3] + "%' "                         )//NAO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " FAMILA_PRODUTO LIKE '%"            + _aRet[4] + "%' "                         )//NAO � OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

