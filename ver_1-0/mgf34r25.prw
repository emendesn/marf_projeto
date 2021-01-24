#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R25	บAutor  ณ Geronimo Benedito Alves																	บData ณ  12/08/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Contabilidade Gerencial - NFE Sem Classifica็ใo (M๓dulo 34-CTB)                  บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																											   บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R25()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Contabilidade Gerencial - NFE Sem Classifica็ใo"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "NFE Sem Classifica็ใo"			)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"NFE Sem Classifica็ใo"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"NFE Sem Classifica็ใo"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02						 03							 04		 05	 06  07		08 09		
	Aadd(_aCampoQry, {"F1_FILIAL"	,"COD_FILIAL"			,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"	,"NOM_FILIAL"			,"Nome da Filial"	,"C"	,40	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"NUM_NFE"				,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"SER_NFE"				,""					,""		,""	,""	,""		,""	,""	})

	Aadd(_aCampoQry, {"F1_ITEM"		,"ITEM_NF"				,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_COD"		,"COD_PRODUTO"			,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO"			,""					,""		,""	,""	,""		,""	,""	})

	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO"			,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"F1_DTDIGIT"	,"DT_DIGITACAO"			,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_COD"		,"COD_FORNECEDOR"		,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_LOJA"		,"COD_LOJA_FORNECEDOR"	,""					,""		,""	,""	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_CGC"		,"NUM_CNPJ"				,"CNPJ/CPF"			,""		,18	,0		,"@!"	,""	,"@!"	})
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_FORNECEDOR"		,""					,""		,""	,""	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data Digita็ใo Inicial"	,Ctod("")	,""	,""														,""		,""	, 050,.T.})
	aAdd(_aParambox,{1,"Data Digita็ใo Final"	,Ctod("")	,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02,'Data Digita็ใo')"		,""		,""	, 050,.T.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CONTAB_NFE_SEM_CLASSIF"  )          + CRLF
	
	_cQuery += U_WhereAnd( .T. ,     " COD_FILIAL IN "                + _cCODFILIA                             ) 				//OBRIGATORIO, SELEวรO POR FILIAL
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DT_DIGITACAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' " )	//OBRIGATORIO - SEM TRAVA DE DATA

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

