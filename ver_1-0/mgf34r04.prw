#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R04	�Autor  �Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: CONTABILIDADE Gerencial - Relatorio Item Fiscal(Modulo 34CTB)						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade - Relatorio Item Fiscal"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Item Fiscal"								)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Item Fiscal"}							)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Item Fiscal"}							)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {} 										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01				02								 03							 04	 05		 06  07					 08		 09	
	Aadd(_aCampoQry, {"B1_COD"		,"COD_ITEM"							,"Codigo Item"				,"C",015	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_DESC"		,"ITEM"								,"Descricao Item"			,"C",076	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"BM_GRUPO"	,"COD_GRUPO"						,"Grupo"					,"C",004	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"BM_DESC"		,"GRUPO"							,"Descricao do Grupo"		,"C",030	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_GRTRIB"	,"GRUPO_TRIBUTO		as GRUPTRIBUT"	,"Grupo do Tributo"			,"C",006	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"ORIGEM_PRODUTO	as ORIGPRODUT"	,"Origem do Produto"		,"C",001	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_UM"		,"UNIDADE"							,"Unidade"					,"C",002	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"X5_DESCRI"	,"TIPO"								,"Tipo"						,"C",055	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_COD"		,"ATIVO"							,"Ativo"					,"C",015	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"E1_PREFIXO"	,"PIS_COFINS"						,"Pis / Cofins"				,"C",006	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_UREV"		,"DATA_ULT_REVISAO	as DTULTREVIS"	,"Data �ltima Revisao"		,"D",008	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_PESO"		,"PESO_LIQUIDO		as PESOLIQUID"	,"Peso Liquido"				,"N",012	,4	,"@E 999,999.9999"	,""		,""	 })
	Aadd(_aCampoQry, {"B1_CONV"		,"FATOR_CONVERSAO	as FATORCONVE"	,"Fator de Convers�o"		,"N",009	,3	,"@E 9,999.999"		,""		,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"TIPO_CONVERSAO	as TPCONVERSA"	,"Tipo de Convers�o"		,"C",020	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"MERCADO"							,"Mercado"					,"C",020	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"LINHA_PRODUTO		as LINHPRODUT"	,"Linha de Produto"			,"C",040	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"LINHA_RECEITA		as LINRECEITA"	,"Linha de Receita"			,"C",040	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"SEGMENTO_MERCADO	as SEGMENMERC"	,"Segmento do Mercado"		,"C",015	,0	,""					,""	 	,""	 })
	Aadd(_aCampoQry, {"B1_IPI"		,"IPI"								,"IPI"						,"N",006	,2	,"@E 999.99", 		,""	})

	aAdd(_aParambox,{1,"Codigo do Item Inicial"	,Space(15)	,""		,""													,"SB1"	,"",100,.F.})
	aAdd(_aParambox,{1,"Codigo do Item Final "	,Space(15)	,""		,"U_VLFIMMAI(MV_PAR01,MV_PAR02,'Codigo do Item')"	,"SB1"	,"",100,.T.})
	aAdd(_aParambox,{1,"Grupo Inicial"			,Space(04)	,""		,"" 												,"SBM"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Grupo Final"			,Space(04)	,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04,'Grupo')"			,"SBM"	,"",050,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_ITEMFISCAL" ) + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " COD_ITEM  BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, 
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " COD_GRUPO BETWEEN '"  + _aRet[3] + "' AND '" + _aRet[4] + "' " ) //Nao  OBRIGATORIO
	_cQuery += "  ORDER BY COD_ITEM " 

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

