#include "totvs.ch"  
//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF30R05	�Autor  � Geronimo Benedito Alves																	�Data �  21/12/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: EEC-Easy Financing - 30 -Financiamento-Ordens Importa��o antec. Pagos       ���
//���			� Os dados sao obtidos e mostrados na tela atrav�z da execu��o de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Marfrig Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������
User Function MGF30R05()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aSelFil		:= {}
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl,  "Financiamento-Ordens Importa��o Antec. Pagos"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl,  "Ordens Importa��o Antec. Pagos"	)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Ordens Importa��o Antec. Pagos"}	)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Ordens Importa��o Antec. Pagos"}	)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas ser�o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, ser� mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser inclu�do naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma fun��o (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que ser� transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 s�o sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos ser�o preservados.
	//					01			 02						03						04	  05	06		07		08		 09	
	Aadd(_aCampoQry, {"WA_HAWB"		,"IMP"					,""						,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_FORN"		,"COD_FORNECEDOR"		,"C�d. Forn"			,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_LOJA"		,"LOJA_FORNECEDOR"		,"Loja Forn"  			,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOME_FORNECEDOR"		,"Nome Fornecedor" 		,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_INVOICE"	,"FATURA"				,"Fatura" 				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_MOEDA"	,"MOEDA"				,"Moeda"				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_FOBMOE"	,"VALOR"				,"Valor"				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_DESCO"	,"DESCONTO"				,"Desconto"				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_VLIQ"		,"VALOR_LIQ_PAGAR_ANT"	,"Vlr Liq. Pagar Antec.",""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_DT_VEN"	,"DATA_VENCIMENTO "		,"Data Vencimento"		,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"E2_DATALIB"	,"DATA_APROVACAO"		,"Data Aprova��o" 		,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_CA_DT"	,"DATA_DEBITO"			,"Data D�bito"			,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_DT_DESE"	,"VALUE_DATE"			,""						,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_BANCO"	,"CONTA"				,"Conta"				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_CA_NUM"	,"CAMBIO"				,"Cambio"				,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_DT_REAL"	,"VALOR_DEBITADO_REAIS"	,"Vlr Debitado Reais"	,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_CA_TX"	,"TAXA_CAMBIO"			,"Taxa Cambio"			,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_ANTECIPACAO"		,"Data Antecipa��o"		,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"WB_FILIAL"	,"COD_FILIAL"			,"C�d Filial"			,""	, ""	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOME_FILIAL"			,"Nome Filial"			,"C", 40	, ""	, ""	, ""	, ""	})
	Aadd(_aCampoQry, {"E2_HIST"		,"HISTORICO"			,"Hist�rico"			,""	, ""	, ""	, ""	, ""	, ""	})
	
	aAdd(_aParambox,{1,"Data de Vencimento Inicial"	,Ctod("")	,""		,"" 													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data de Vencimento Final  "	,Ctod("")	,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data de Vencimento')"	,""		,"",050,.T.})

	SetKey(K_CTRL_F8,{||U_BIEmlini("Bi_e_Protheus")}) ;SetKey(K_CTRL_F9,{||U_BIEmlini("Protheus")})	// CTRL+F8 (Codigo inkey -27), executa a func�o que ir� alimentar a array, para o envio do email com a query do relat�rio para a equipe de desenvolvimento do B.I. e do Protheus.            // CTRL+F9 (Codigo inkey -28), envia o email somente para a equipe de desenvolvimento do Protheus.
	If Len(_aParambox) > 0 ;  _lRet := ParamBox(_aParambox, _aDefinePl[2], @_aRet	,,	,,	,,	,,.T.,.T.)  ; 	Endif
	SetKey(K_CTRL_F8,{||}) ; SetKey(K_CTRL_F9,{||})					// Cancela a associa��o das teclas CTRL+F8 (Codigo inkey -27) e CTRL+F9 (Codigo inkey -28)
	If ! U_ParameR2(_aParambox, _bParameRe, @_aRet ,_lRet ) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)						// Rotina que obtem a selec�o das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR",	"V_TESOURARIA_ANTECPAGOS" ) +CRLF
	_cQuery += U_WhereAnd( .T. ,	   " COD_FILIAL IN "			+ _cCODFILIA	                      		 ) 			//OBRIGATORIO (SELE��O COMBO)
	_cQuery += U_WhereAnd( .T. ,       " DATA_VENCIMENTO_FILTRO BETWEEN '"	+ _aRet[1] + "' AND '" + _aRet[2] + "' " )	//OBRIGATORIO (DATA VENCIMENTO) 
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
