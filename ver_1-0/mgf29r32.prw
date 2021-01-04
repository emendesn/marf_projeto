#include "totvs.ch"  

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF29R32	�Autor  � Geronimo Benedito Alves																	�Data �  25/05/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTA��O - Aprovacao por or�amento		       ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF29R32()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _nInterval
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTA��O - Vencidos"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Vencidos"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Vencidos"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Vencidos"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//				  01		 		 02											 03			 						 04	 05	     06	 07	 08		 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"		,"NUM_EXP"									,"Exp Num"							,"C",013	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"		,"ANO_EXP"									,"Year"								,"C",002	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"		,"SUBEXP"									,"Item"								,"C",003	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"XXPEDIEX01"		,"PEDIDO_EXPORTACAO	    	as PEDIEXPORT"	,"Pedido Exportacao"				,"C",020	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"		,"NOME_IMPORTADOR	    	as NOM_IMPORT"	,"Importer"							,"C",040	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"A1_NOME"			,"NOME_BUYER"								,"Buyer"							,"C",040	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"EEC_MOEDA"		,"MOEDA"									,"Currency"							,"C",003	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"SALDO_RECEBER"	,"SALDO_RECEBER"							,"Saldo Receber"					,"N",015	,2	,"@E 999,999,999,999.99" ,"" ,"" })																																															  
	Aadd(_aCampoQry, {"EEC_DTEMBA"		,"DATA_BL"									,"Data Embarque"					,"D",008	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"EEC_DTEMBA"		,"DATA_BL_TRANSPORTE"						,"Data Bloqueio Transporte"			,"D",008	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"DT_VENCTO"		,"DT_VENCTO"								,"Data de Vencimento"				,"D",008	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"DIAS_VENCER"		,"DIAS_VENCER"								,"Dias Vencer"						,"N",008	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"BDM_DESCRI"		,"STATUS"									,"Status"							,"C",035	,0	,"" ,""		,""	})
	Aadd(_aCampoQry, {"YA_DESCR"		,"PAIS_PORTO_DESTINO		as PAIS_DESTI"	,"Destination Country"				,"C",025	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"			,"TIPO_PRODUTO		     	as TP_PRODUTO"	,"Type Product"						,"C",045	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"		,"TIPO_PAGAMENTO	    	as TP_PAGTO"	,"Pymt Terms"						,"C",080	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"EEH_NOME"		,"FAMILA_PRODUTO	    	as FAM_PRODUT"	,"Familia Produto"					,"C",045	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"EEG_NOME"		,"NEGOCIO"									,"Negocio"							,"C",045	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"		,"SITUACAO"									,"Situa��o"							,"C",080	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"			,"FILTRO_EXP"								,"Buyer"							,"C",040	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"EEC_RESPON"		,"ADMINISTRADOR		    	as ADMINISTRA"	,"ADM"								,"C",020	,0	,""	,0		,""	})
	Aadd(_aCampoQry, {"EEC_ZETAOR"		,"DATA_ETA_ORIGEM	   		as DT_ORIGEM"	,"Eta Origin"						,"D",008	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"F1_COND"			,"CONDICAO_PAG_INTERMEDIACAO as CONDPGI"	,"Cond. Pagamento Intermedia��o"	,"C",003	,0	,"" ,"" 	,"" }) 
	Aadd(_aCampoQry, {"F1_COND"			,"CONDICAO_PAG_FINANCEIRO    as CONDPGF"	,"Cond. Pagamento Financeiro"		,"C",003	,0	,"" ,"" 	,"" }) 
	Aadd(_aCampoQry, {"EX9_CONTNR"		,"NUM_CONTAINER 	     	as NCONTAINER"	,"No. Container"					,"C",020	,0	,"" ,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZEXP"		,"NUM_RESERVA"								,"Numero Reserva"					,"C",045	,0	,""	,""		,""	})
	Aadd(_aCampoQry, {"XXARMADOR"		,"ARMADOR"									,"Armador"							,"C",040	,0	,""	,""		,""	})
	
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_VENCIDOS"  )  + CRLF

	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

