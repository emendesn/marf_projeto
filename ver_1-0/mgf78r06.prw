#Include "totvs.ch"

/*
=====================================================================================
Programa............: MGF78R06
Autor...............: Rafael Garcia de Melo
Data................: 04/10/2019
Descrição / Objetivo: Relatório Logistica - cte
Doc. Origem.........:
Solicitante.........: Nicomed Filho
Uso.................: Marfrig
Obs.................: Relatório Logistica - cte
=====================================================================================
*/

User Function MGF78R06()

	Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Relatório Logistica CTE"				)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Relatório Logistica CTE"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relatório Logistica CTE"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relatório Logistica CTE"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba
	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//				   01				 	 	 02						 03						 	 04	 05	 06	 07	 08	 09
	Aadd(_aCampoQry, { "CNPJ_EMISSOR"			,"CNPJ_EMISSOR"			,"CNPJ Emissor"				,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_EMISSOR"			,"NOME_EMISSOR"			,"Nome Emissor"				,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_REMETENTE"			,"CNPJ_REMETENTE"		,"CNPJ Remetente"			,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_REMETENTE"			,"NOME_REMETENTE"		,"Nome Remetente"			,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_DESTINATARIO"		,"CNPJ_DESTINATARIO"	,"CNPJ Destinatario"		,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_DESTINATARIO"		,"NOME_DESTINATARIO"	,"Nome Destinatario"		,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CNPJ_TOMADOR"			,"CNPJ_TOMADOR"			,"CNPJ Tomador"				,"C",014,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "NOME_TOMADOR"			,"NOME_TOMADOR"			,"Nome Tomador"				,"C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "INSCR_EST_TOMADOR"		,"INSCR_EST_TOMADOR"	,"Inscricao Estadual Tomador","C",080,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "DATA_EMISSAO"			,"DATA_EMISSAO"			,"Data Emissão"				,"D",008,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "CHAVE_NFE"				,"CHAVE_NFE"			,"Chave NF"					,"C",060,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "VALOR_DOCUMENTO"		,"VALOR_DOCUMENTO"		,"Valor Documento"			,"N",017,2	,"@E 99,999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, { "NUMERO"					,"NUMERO"				,"Número Documento"			,"N",016,0	,""	,""	,""	})
	Aadd(_aCampoQry, { "SERIE"					,"SERIE"				,"Série Documento"			,"N",003,0	,""	,""	,""	})

	aAdd(_aParambox,{1,"Data Emissao De"	,Ctod("")						,""	,""													,""		,"",050,.T.})	//03
	aAdd(_aParambox,{1,"Data Emissao Ate"	,Ctod("")						,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})	//04
	aAdd(_aParambox,{1,"CNPJ Tomador"		,Space(15)		,""	,""													,""		,"",075,.F.})


	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

//	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil
//	If Empty(_aSelFil) ; Return ; Endif
//	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_LOGISTICA_CTES_PROTHEUS" )                   	+ CRLF
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DATA_EMISSAO_FILTRO BETWEEN '"          	+ _aRet[1]  + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[3] ),       " COALESCE(CNPJ_TOMADOR,' ') = '"	+ _aRet[3]  + "'"                         ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery) 
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})


Return