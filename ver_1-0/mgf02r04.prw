#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF02R04	�Autor  � Geronimo Benedito Alves																	�Data � 02/05/18	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: COMPRAS - Relatorio de Abate (DAEMS)				 (Modulo 02-Compras)				���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF02R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "COMPRAS - Abate-DAEMS"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Abate-DAEMS"				)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Abate-DAEMS"} 			)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Abate-DAEMS"}			)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  						)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 				)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			  02							 03					 04		 05		06	07		08	09	
	Aadd(_aCampoQry, { "ZZM_FILIAL"	,"COD_EMPRESA	as CODEMPRESA"	,"Cod. Filial"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZM_PEDIDO"	,"PEDIDO"						,"Pedido"			,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "XXNFSERIPR"	,"NFP"							,"NF-Serie PRODUTOR","C"	,045,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "XXNFSERIE"	,"NF" 							,"NF-Serie"			,"C"	,013,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZQ_GTA"	,"NUM_GTA"						,"Numero GTA"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "CC2_MUN"	,"MUNICIPIO"					,"Municipio"		,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "XXXXXXXX02"	,"PROPRIEDADE	as PROPRIEDAD"	,"Propriedade"		,"C"	,065,0	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZM_FORNEC"	,"COD_PRODUTOR	as CODPRODUTO"	,"Cod. Produtor"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZM_LOJA"  	,"LOJA_PRODUTOR	as LOJAPRODUT"	,"Loja Produtor"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "A2_NOME" 	,"NOME_PRODUTOR	as NOMEPRODUT"	,"Nome Produtor"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZN_QTCAB" 	,"QTD_BOIS"						,"Quantidade Bois"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZN_QTCAB" 	,"QTD_VACAS"					,"Quantidade Vacas"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZN_QTCAB" 	,"TOTAL_ANIMAIS	as TOTALANIMA"	,"Total Animais"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZM_DTPROD"	,"DATA_PRODUCAO	as DATAPRODUC"	,"Data Producao"	,""		,	, 	,""		,""	,""	})
	Aadd(_aCampoQry, { "ZZM_NUMOP" 	,"NUM_OP"						,"N� OP."			,""		,	, 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Producao Inicial"	,Ctod("")	,""	,"" 												,""	,"",050,.T.})
	aAdd(_aParambox,{1,"Data Producao Final"	,Ctod("")	,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data de Emissao')",""	,"",050,.T.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
 
	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_FAT_RELABATE_DAEMS") +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),   " DATA_PRODUCAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "	)	// OBRIGATORIO, SEM A VALIDACAO DE DATAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ), " COD_EMPRESA IN "                + _cCODFILIA	                            )	// OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)

	// Mostra mensagem MsgRun "Aguarde!!! Montando\Desconectando Tela" ao montar a tela de dados e tambem ao fecha-la
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
