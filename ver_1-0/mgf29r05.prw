#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R05	�Autor  �Geronimo Benedito Alves																	�Data �05/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EXPORTA��O - Relat�rio de PV por Cliente  (M�dulo 29-EXPORTA��O)					���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTA��O - PV por Cliente"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "PV por Cliente"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"PV por Cliente"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"PV por Cliente"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			 02									 03							 04	 05		 06	 07					  	 08  	09	
	Aadd(_aCampoQry, {"ZZC_ORCAME"	,"NUM_PV"							,"N� PV"					,"C",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZZC_ZANOOR"	,"PV_ANO"							,"PV ANO"					,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZZC_DTPROC"	,"DATA_PROCESSO		as DTPROCESS"	,"Data Processo" 			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER		as NOM_BUYER"	,"Nome Buyer"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"TRADER"							,"Trader"					,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_TRADING		as NOMETRADI"	,"Nome Trading" 			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE	as NOMECONSI"	,"Nome Consignee" 			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPSANITARIO	as NOM_IMPSAN"	,"Nome Importador Sanitario","C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO		as PORTO_DEST"	,"Porto Destino"			,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_DESTINO		as PAIS_DESTI"	,"Pa�s Destino"				,"C",025	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEH_NOME"	,"FAMILA_PRODUTO	as FAM_PRODUT"	,"Fam�lia Produto"			,"C",045	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO		as TIPOPRODUT"	,"Tipo Produto" 			,"C",045	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"B1_COD"		,"COD_ITEM"							,"C�digo Item"				,"C",015	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"ITEM"								,"Item"						,"C",076	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"B1_UM"		,"UNIDADE_MEDIDA	as UNIDMEDIDA"	,"Unid. Medida"				,"C",002	,0	,""						,""		,""	})			 
	Aadd(_aCampoQry, {"ZZC_INCO2"	,"SALES_TERMS		as SALESTERMS"	,"Sales Terms" 				,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZZD_SLDINI"	,"QUANTIDADE"						,"Quantidade"				,"N",015	,3	,"@E 99,999,999,999.999",""		,""	})
	Aadd(_aCampoQry, {"ZZD_PRECO"	,"PRECO_UNITARIO	as PRECO_UNIT"	,"Pre�o Unit�rio"			,"N",016	,6	,"@E 999,999,999.999999",""		,""	})
	Aadd(_aCampoQry, {"ZZD_ZPRECO"	,"PRECO_VENDA		as PRECOVENDA"	,"Pre�o Venda"				,"N",016	,6	,"@E 999,999,999.999999",""		,""	})
	Aadd(_aCampoQry, {"ZZC_ZQTDCO"	,"QTDE_CONTAINER	as QTDCONTAIN"	,"Quantidade Container"		,"N",006	,0	,"@E 999,999"			,""		,""	})
	Aadd(_aCampoQry, {"ZZC_MOEDA"	,"MOEDA"							,"Moeda"					,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"AC5_DESCRI"	,"STATUS_ORCAMENTO	as STATUS_ORC"	,"Status do Or�amento"		,"C",040	,0	,""						,""		,""	})

	aAdd(_aParambox,{1,"Data Processo Inicial"			,Ctod("")						,""		,"" 												,""			,"",050,.T.})
	aAdd(_aParambox,{1,"Data Processo Final  "			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Processo')"	,""			,"",050,.T.})
	aAdd(_aParambox,{1,"Pedido:"						,Space(tamSx3("ZZC_ORCAME")[1])	,""		,""													,"ZZC"		,"",050,.F.})
	aAdd(_aParambox,{1,"Trader"							,Space(tamSx3("A3_NOME")[1])	,"@!"	,""													,"SA3NOM"	,"",115,.F.})
	aAdd(_aParambox,{1,"Nome Trading"					,Space(tamSx3("A1_NOME")[1])	,"@!"	,""													,"VSA1"		,"",115,.F.})
	aAdd(_aParambox,{1,"Nome Consignee"					,Space(tamSx3("A1_NOME")[1])	,"@!"	,""													,"VSA1"		,"",115,.F.})
	aAdd(_aParambox,{1,"Sales Terms"					,Space(tamSx3("ZZC_INCOTE")[1])	,"@!"	,""													,"SYJ"		,"",050,.F.})
	aAdd(_aParambox,{1,"Descri��o Item  (em portugues)"	,Space(tamSx3("B1_DESC")[1])	,"@!"	,""													,"SB1DES"	,"",115,.F.})
	aAdd(_aParambox,{1,"Nome Familia Produto"			,Space(tamSx3("EEH_NOME")[1])	,"@!"	,""													,"EEH90"	,"",115,.F.})
	aAdd(_aParambox,{1,"Tipo Produto"					,Space(tamSx3("YC_NOME")[1])	,"@!"	,""													,"YC90"		,"",115,.F.})
	aAdd(_aParambox,{1,"Pa�s Destino  -  em portugues"	,Space(tamSx3("YA_DESCR")[1])	,"@!"	,""													,"SYAEXP"	,"",075,.F.})
	aAdd(_aParambox,{1,"Porto Destino"					,Space(tamSx3("YR_CID_DES")[1])	,"@!"	,""													,"SYRCID"	,"",075,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_aSelFil:= U_SeleEmp()					// Rotina para obter a selec�o das EMPRESAS a processar.
	If Empty(_aSelFil) ; Return ; Endif
	_cCODEMPRE	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_PVCLIENTE"  )               + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " DATA_PROCESSO_FILTRO BETWEEN '" + _aRet[1]  + "' AND '" + _aRet[2] + "' " )//OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[3]),       " NUM_PV LIKE '%"                 + _aRet[3]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_cCODEMPRE),     " FILIAL_FILTRO IN "              + _cCODEMPRE                              )//FILTRO EMPRESA OU FILIAL --OBRIGATORIO (SELE��O DO COMBO)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " TRADER LIKE '%"                 + _aRet[4]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[5]),       " NOME_TRADING LIKE '%"           + _aRet[5]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " NOME_CONSIGNEE LIKE '%"         + _aRet[6]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[7]),       " SALES_TERMS LIKE '%"            + _aRet[7]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[8]),       " PRODUTO_FILTRO LIKE '%"         + _aRet[8]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[9]),       " FAMILA_PRODUTO LIKE '%"         + _aRet[9]  + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[10]),      " TIPO_PRODUTO LIKE '%"           + _aRet[10] + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[11]),      " PAIS_DESTINO_FILTRO LIKE '%"    + _aRet[11] + "%' "                       )//N�O OBRIGATORIO		
	_cQuery += U_WhereAnd( !empty(_aRet[12]),      " PORTO_DESTINO LIKE '%"          + _aRet[12] + "%' "                       )//N�O OBRIGATORIO		

	_cQuery += "	ORDER BY NUM_PV "  +CRLF
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)

	// Mostra mensagem MsgRun "Aguarde!!! Montando\Desconectando Tela" ao montar a tela de dados e tamb�m ao fecha-la
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

