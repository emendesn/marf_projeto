#include "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF34R09	�Autor  �Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Contab. Gerencial - M�dia de Vendas por Item (Modulo 34-CTB)						���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF34R09()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contab. Gerencial - M�dia de Vendas por Item"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "M�dia de Vendas por Item"						)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"M�dia de Vendas por Item"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"M�dia de Vendas por Item"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 180													//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	cCodItem	:= "	PROD.B1_COD                        AS COD_ITEM "		//-->CHAR(15)
	cDescItem	:= "	PROD.B1_DESC                       AS DESC_ITEM "		//-->CHAR(76)
	cFamilia	:= "	''                                 AS FAMILIA "			//-->CHAR(40)
	nQtdVenda 	:= "	SUM(NFI.D2_QUANT)                  AS QTDE_VENDA "		//-->NUMERIC(16,3)
	nValorVend	:= "	SUM(NFI.D2_TOTAL)                  AS VAL_VENDA "		//-->NUMERIC(14,2)
	nQtdDevolu	:= "	SUM(NFEI.D1_QUANT)                 AS QTDE_DEVOLUCAO "	//-->NUMERIC(16,3)
	nValorDevo	:= "	SUM(NFEI.D1_TOTAL)                 AS VAL_DEVOLUCAO "	//-->NUMERIC(14,2)
	nValorLiqu	:= "	TRUNC(SUM(NFI.VAL_LIQUIDO),2)      AS VALOR_LIQUIDO "	//-->NUMERIC(14,2)
	
	nPrecoMedi := " 	CASE  "														+CRLF 
	nPrecoMedi += "           WHEN SUM(NVL(NFI.D2_QUANT,0)) = 0 "					+CRLF
	nPrecoMedi += "                THEN 0 "											+CRLF
	nPrecoMedi += "           ELSE TRUNC((SUM(NFI.D2_TOTAL)/SUM(NFI.D2_QUANT)),2) "	+CRLF 
	nPrecoMedi += "	    END                                AS PRECO_MEDIO "  		+CRLF		//-->NUMERIC(14,2)

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02			 03						 04	  05	 06	07					 	 	08	09		
	Aadd(_aCampoQry, {"B1_COD"		,cCodItem	,"Codigo Item"			,"C",015	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,cDescItem	,"Descricao do Item"	,"C",076	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"B1_FAMILIA"	,cFamilia	,"Familia"				,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"D2_QUANT"	,nQtdVenda	,"Quantidade Venda"		,"N",016	,3	,"@E 999,999,999,999.999"	,""	,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,nValorVend	,"Valor Venda"			,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"D1_QUANT"	,nQtdDevolu	,"Quantidade Devolucao"	,"N",016	,3	,"@E 999,999,999,999.999"	,""	,""	})
	Aadd(_aCampoQry, {"D1_TOTAL"	,nValorDevo	,"Valor Devolucao"		,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,nValorLiqu	,"Valor Liquido"		,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,nPrecoMedi	,"Preco M�dio"			,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao Inicial"	,Ctod("")	,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Emissao Final"		,Ctod("")	,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Codigo Item Inicial"	,Space(15)	,""		,""													,"SB1"	,"",050,.F.})
	aAdd(_aParambox,{1,"Codigo Item Final"		,Space(15)	,""		,"U_VLFIMMAI(MV_PAR03,MV_PAR04,'Codigo de Item')"	,"SB1"	,"",050,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SF2")  ) + "             NF "							+CRLF
	_cQuery += " INNER JOIN ( "													+CRLF
	_cQuery += "                SELECT D2_DOC "									+CRLF
	_cQuery += "                     , D2_COD "									+CRLF
	_cQuery += "                     , D2_SERIE "								+CRLF
	_cQuery += "                     , D2_EMISSAO "								+CRLF
	_cQuery += "                     , D2_FILIAL "								+CRLF
	_cQuery += "                     , D2_PEDIDO "								+CRLF
	_cQuery += "                     , D2_ITEMPV "								+CRLF
	_cQuery += "                     , SUM(D2_TOTAL)  AS D2_TOTAL "				+CRLF
	_cQuery += "                     , SUM(D2_QUANT)  AS D2_QUANT "				+CRLF
	_cQuery += "                     , SUM((D2_QUANT * D2_PRUNIT) - (D2_VALIPI + D2_VALICM + D2_VALPIS + D2_VALIMP5))AS VAL_LIQUIDO "  	+CRLF 
	_cQuery += "                  FROM  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SD2")  ) + "   "						+CRLF
	_cQuery += "                 WHERE D_E_L_E_T_ <> '*'  "						+CRLF
	_cQuery += "								   AND D2_CF IN ('5101','5102','5102','5102','5102','5401','5949','6101','6101','6101','6102','6102','6109','6105','6107','7101','7102','7105', '7949', '7127' ) "  	+CRLF 
	_cQuery += "                 GROUP BY D2_DOC "								+CRLF
	_cQuery += "                        , D2_SERIE "							+CRLF
	_cQuery += "                        , D2_EMISSAO "							+CRLF
	_cQuery += "                        , D2_FILIAL  "							+CRLF
	_cQuery += "                        , D2_PEDIDO "							+CRLF
	_cQuery += "                        , D2_COD "								+CRLF
	_cQuery += "                        , D2_ITEMPV "							+CRLF
	_cQuery += "             )                   NFI ON NF.F2_DOC          = NFI.D2_DOC "  		+CRLF
	_cQuery += "                                    AND NF.F2_SERIE        = NFI.D2_SERIE "  	+CRLF
	_cQuery += "                                    AND NF.F2_EMISSAO      = NFI.D2_EMISSAO "  	+CRLF
	_cQuery += "                                    AND NF.F2_FILIAL       = NFI.D2_FILIAL "  	+CRLF
	_cQuery += "                                    AND NFI.D2_QUANT       > 0 "  				+CRLF                         
 	_cQuery += "INNER JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SC5")  ) + "       PED ON PED.C5_FILIAL        = NFI.D2_FILIAL "  	+CRLF
	_cQuery += "                                    AND PED.C5_NUM           = NFI.D2_PEDIDO "  +CRLF
	_cQuery += "                                    AND PED.D_E_L_E_T_       = ' '  "  			+CRLF
	_cQuery += "                                    AND PED.C5_CLIENT        = NF.F2_CLIENTE "  +CRLF
	_cQuery += "                                    AND PED.C5_LOJACLI       = NF.F2_LOJA "  	+CRLF
	_cQuery += " INNER JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SC6")  ) + "      PEDI ON PEDI.C6_FILIAL       = NFI.D2_FILIAL "  +CRLF
	_cQuery += "                                    AND PEDI.C6_ITEM         = NFI.D2_ITEMPV "  +CRLF
	_cQuery += "                                    AND PEDI.C6_PRODUTO      = NFI.D2_COD "  	+CRLF
	_cQuery += "                                    AND PEDI.C6_NUM          = PED.C5_NUM "  	+CRLF
	_cQuery += "                                    AND PEDI.D_E_L_E_T_      = ' '   "		  	+CRLF
	_cQuery += " INNER JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SB1")  ) + "      PROD ON PROD.B1_COD        = NFI.D2_COD "  		+CRLF 
	_cQuery += "                                    AND PROD.D_E_L_E_T_    <> '*' "				+CRLF
	_cQuery += "  LEFT JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SF3")  ) + "        LF ON LF.F3_NFISCAL      = NF.F2_DOC "		+CRLF
	_cQuery += "                                    AND LF.F3_SERIE        = NF.F2_SERIE "		+CRLF
	_cQuery += "                                    AND LF.F3_EMISSAO      = NF.F2_EMISSAO "	+CRLF
	_cQuery += "                                    AND LF.F3_FILIAL       = NF.F2_FILIAL "		+CRLF       
	_cQuery += "                                    AND LF.D_E_L_E_T_      <> '*'  "			+CRLF
	_cQuery += "  LEFT JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SF1")  ) + "       NFE ON NFE.F1_SERORIG     = NF.F2_SERIE "		+CRLF
	_cQuery += "                                    AND NFE.F1_NFORIG      = NF.F2_DOC "		+CRLF
	_cQuery += "                                    AND NFE.F1_FILORIG     = NF.F2_FILIAL "		+CRLF
	_cQuery += "                                    AND NFE.D_E_L_E_T_     <> '*'  "			+CRLF
	_cQuery += "  LEFT JOIN  " + U_IF_BIMFR( "PROTHEUS", RetSqlName("SD1")  ) + "      NFEI ON NFEI.D1_FILIAL     = NFE.F1_FILIAL "	+CRLF
	_cQuery += "                                    AND NFEI.D1_DOC        = NFE.F1_DOC "		+CRLF
	_cQuery += "                                    AND NFEI.D1_SERIE      = NFE.F1_SERIE "		+CRLF
	_cQuery += "                                    AND NFEI.D1_FORNECE    = NFE.F1_FORNECE "	+CRLF
	_cQuery += "                                    AND NFEI.D_E_L_E_T_    <> '*'  "			+CRLF

	_cQuery += U_WhereAnd(.T. ,                " LF.F3_DTCANC = '		' "                                         ) 
	_cQuery += U_WhereAnd(.T. ,                " NF.D_E_L_E_T_  <> '*' "                                             ) 
	_cQuery += U_WhereAnd(.T. ,                " PEDI.C6_TES IN ('504','506','526','528','532','884','640','880','508','936','526','528','531','937','504','846','527','965','509','516','641','508','523','548','857','846','859','868') "   ) 
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),   " NF.F2_EMISSAO BETWEEN '" + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, VALIDA��O DOS 35 DIAS
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ), " NF.F2_FILIAL  IN "       + _cCODFILIA							    ) //OBRIGATORIO, SELE��O POR COMBO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),   " PROD.B1_COD BETWEEN '"   + _aRet[3]   + "' AND '" + _aRet[4] + "'  ") //NAO OBRIGATORIO, SELE��O DOS COD PRODUTO POR RANGE DE/ATE
	_cQuery += "	GROUP BY PROD.B1_COD "														+CRLF					
	_cQuery += "			, PROD.B1_DESC  "													+CRLF

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

