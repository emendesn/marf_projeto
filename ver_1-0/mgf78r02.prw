#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF78R02	บAutor  ณBruno Canestre Tamanaka						บData ณ06/02/19	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: 									บฑฑ
//ฑฑบ       	ณ Gestใo de Frete Embarcador 78 - Tabelas de Frete									บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois,  บฑฑ
//ฑฑบ			ณ o usuario pode gerar uma planilha excel com eles 									บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF78R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Gestใo Frete embarcador - Tabela de Frete Normal"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Tabela de Frete Normal"								)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Tabela de Frete Normal"}							)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Tabela de Frete Normal"}							)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 180													//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""
	_cDtVigen	:= ""

	cCodFil			:= "	COD_FILIAL						"
	cDescFil		:= "	DESC_FILIAL						"
	cEmiten			:= "	EMITENTE						"
	cNEmite			:= "	NOME_EMITENTE					"
	cTpTab			:= "	TIPO_TABELA						"
	cTpOpe			:= "	TIPO_OPERACAO					"
	cDescTOp		:= "	DESC_TIPO_OPERACAO				"
	cTabela			:= "	TABELA							"
	cDescTab		:= "	DESC_TABELA						"
	cNegocia		:= "	NEGOCIACAO						"
	cEnvApv			:= "	ENVIADO_APROV					"
	cSituac			:= "	SITUACAO						"
	cDtAprov		:= "	DATA_APROV						"
	cUsrApro		:= "	USR_APROV						"
	cDtVigD			:= "	DATA_VIGENCIA_DE				"
	cDtVigA			:= "	DATA_VIGENCIA_ATE				"
	cTpLota			:= "	TIPO_LOTACAO					"
	cAtribFa		:= "	ATRIBUDO_FAIXA					"
	cFrtViag		:= "	FRETE_VIAGEM					"
	cTpValor		:= "	TIPO_VALOR						"
	cAdcIcms		:= "	ADC_ICMS						"
	cAdcIss			:= "	ADC_ISS							"
	cRatImp			:= "	RATEIA_IMPOSTO					"
	cCompImp		:= "	COMP_IMPOSTO					"
	cSeqFaix		:= "	SEQUENCIA_FAIXA					"
	cDescFx			:= "	DESC_FAIXA						"
	cRota			:= "	ROTA							"
	cInfRota		:= "	INFO_ROTA						"
	cComp			:= "	COMPONENTE						"
	cFrtMin			:= "	FRETE_MINIMO					"
	cVlrFNor		:= "	VLR_FIXO_NORMAL					"
	cPercNor		:= "	PERCENTUAL_NORMAL				"
	cVlrUNor		:= "	VLR_UNIT_NORMAL					"
	cFraNorm		:= "	FRACAO_NORMAL					"
	cVlrMNor		:= "	VLR_MIN_NORMAL					"
	cVlrLim			:= "	VLR_LIMITE						"
	cVlrFExt		:= "	VLR_FIXO_EXTRA					"
	cPercExt		:= "	PERCENTUAL_EXTRA				"
	cVlrUExt		:= "	VLR_UNIT_EXTRA					"	
	cCalExce		:= "	CALC_EXCED						"
	cQtdFina		:= "	QTDE_FINAL						"
	cUnidMed		:= "	UNID_MEDIDA						"
	cDtCrTbl		:= "	DATA_CRIACAO_TBL				"
	cUsrCrTb		:= "	USR_CRIACAO_TBL					"
	cDtAtuTb		:= "	DATA_ATUALIZACAO_TBL			"
	cUsrAtuT		:= "	USR_ATUALIZACAO_TBL				"
	cDtCrNeg		:= "	DATA_CRIACAO_NEGOCIACAO			"
	cUsrCNeg		:= "	USR_CRIACAO_NEGOCIACAO			"

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 			02			 03						 04	  05	 06	07					 	 	08	09		
	Aadd(_aCampoQry, {"COD_FILIAL"				,cCodFil	,"Filial"				,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DESC_FILIAL"				,cDescFil	,"Nome da Filial"		,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"EMITENTE"				,cEmiten	,"Emitente"				,"C",015	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"NOME_EMITENTE"			,cNEmite	,"Nome Emitente"		,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"TIPO_TABELA"				,cTpTab		,"Tipo Tabela"			,"C",014	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"TIPO_OPERACAO"			,cTpOpe		,"Tipo Operacao"		,"C",003	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DESC_TIPO_OPERACAO"		,cDescTOp	,"Desc Tipo de Operacao","C",036	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"TABELA"					,cTabela	,"Tabela"				,"C",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DESC_TABELA"				,cDescTab	,"Descricao Tabela"		,"C",036	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"NEGOCIACAO"				,cNegocia	,"Negociacao"			,"C",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ENVIADO_APROV"			,cEnvApv	,"Enviado Aprovacao"	,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"SITUACAO"				,cSituac	,"Situacao"				,"C",014	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_APROV"				,cDtAprov	,"Data de Aprovacao"	,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"USR_APROV"				,cUsrApro	,"Usuario Aprovacao"	,"C",016	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_VIGENCIA_DE"		,cDtVigD	,"Dt Vigencia De"		,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_VIGENCIA_ATE"		,cDtVigA	,"Dt Vigencia Ate"		,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"TIPO_LOTACAO"			,cTpLota	,"Tipo Lotacao"			,"C",036	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ATRIBUDO_FAIXA"			,cAtribFa	,"Atrib Faixa"			,"C",026	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"FRETE_VIAGEM"			,cFrtViag	,"Frete Viagem"			,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"TIPO_VALOR"				,cTpValor	,"Tipo Valor"			,"C",016	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ADC_ICMS"				,cAdcIcms	,"Adicional ICMS"		,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ADC_ISS"					,cAdcIss	,"Adicional ISS"		,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"RATEIA_IMPOSTO"			,cRatImp	,"Rateia Imposto"		,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"COMP_IMPOSTO"			,cCompImp	,"Complemento Imposto"	,"C",016	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"SEQUENCIA_FAIXA"			,cSeqFaix	,"Sequencia Faixa"		,"C",004	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DESC_FAIXA"				,cDescFx	,"Descricao Faixa"		,"C",036	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"QTDE_FINAL"				,cQtdFina	,"Quantidade Final"		,"N",015	,5	,""							,""	,""	})
	Aadd(_aCampoQry, {"UNID_MEDIDA"				,cUnidMed	,"Unidade de Medida"	,"C",002	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"ROTA"					,cRota		,"Rota"					,"C",006	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"INFO_ROTA"				,cInfRota	,"Informacao Rota"		,"C",076	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"COMPONENTE"				,cComp		,"Componente"			,"C",040	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"FRETE_MINIMO"			,cFrtMin	,"Frete Mํnimo"			,"N",016	,3	,"@E 999,999,999,999.999"	,""	,""	})
	Aadd(_aCampoQry, {"VLR_FIXO_NORMAL"			,cVlrFNor	,"Valor Fixo Normal"	,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"PERCENTUAL_NORMAL"		,cPercNor	,"Percentual Normal"	,"N",016	,3	,"@E 999,999,999,999.999"	,""	,""	})
	Aadd(_aCampoQry, {"VLR_UNIT_NORMAL"			,cVlrUNor	,"Valor Unitแrio Normal","N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"FRACAO_NORMAL"			,cFraNorm	,"Fracao Normal"		,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"VLR_MIN_NORMAL"			,cVlrMNor	,"Valor Mํnimo Normal"	,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"VLR_LIMITE"				,cVlrLim	,"Valor Limite"			,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"VLR_FIXO_EXTRA"			,cVlrFExt	,"Valor Fixo Extra"		,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"PERCENTUAL_EXTRA"		,cPercExt	,"Percentual Extra"		,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"VLR_UNIT_EXTRA"			,cVlrUExt	,"Valor Unitแrio Extra"	,"N",014	,2	,"@E 99,999,999,999.99"		,""	,""	})
	Aadd(_aCampoQry, {"CALC_EXCED"				,cCalExce	,"Calculo Excedente"	,"C",026	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_CRIACAO_TBL"		,cDtCrTbl	,"Data Criacao Tabela"	,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"USR_CRIACAO_TBL"			,cUsrCrTb	,"Usuแrio Criacao Tbl"	,"C",016	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_ATUALIZACAO_TBL"	,cDtAtuTb	,"Data Atualizacao Tbl"	,"D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"USR_ATUALIZACAO_TBL"		,cUsrAtuT	,"Usuแrio Atualiz Tbl"	,"C",016	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"DATA_CRIACAO_NEGOCIACAO"	,cDtCrNeg	,"Data Criacao Negociac","D",008	,0	,""							,""	,""	})
	Aadd(_aCampoQry, {"USR_CRIACAO_NEGOCIACAO"	,cUsrCNeg	,"Usuแrio Criacao Negoc","C",016	,0	,""							,""	,""	})
		

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	aAdd(_aParambox,{1,"Tipo Opera็ใo"		,Space(03)	,""		,""	,""		,""			,050	,.T.})
	aAdd(_aParambox,{3,"Situa็ใo"			,1			,{"Liberada","Em Negociacao"}	,050,""	,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	//If _aRet[1] == 1
	cQryVigen	:= "	SELECT DISTINCT DATA_VINGENCIA_DE_FILTRO 	AS DATA_VIGEN, DATA_VIGENCIA_DE_FORMATADA AS DATA_FORMA" 	+CRLF
	cQryVigen	+= "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FRETE_TABELAS_FRETE"  )   											+CRLF
	cQryVigen	+= U_WhereAnd(!empty(_cCODFILIA ), " COD_FILIAL  IN "       + _cCODFILIA ) 										+CRLF
	cQryVigen	+= "	AND TIPO_OPERACAO            = '" + _aRet[1] + "'" 														+CRLF
	cQryVigen	+= iif(_aRet[2] == 1, " AND SITUACAO  = 'LIBERADA' " , " AND SITUACAO  = 'EM NEGOCIACAO' " ) 					+CRLF
	cQryVigen	+= "	ORDER BY DATA_VIGEN	" 																					+CRLF
	aCpoDtVig	:=	{	{ "DATA_FORMA"	,U_X3Titulo("GV9_DTVALI") 					,50		},;
						{ "DATA_VIGEN"	,"(AnoMesDia)"								,30		}	}
		cTitDtVig	:= "Datas de Vig๊ncia: "
		nPosRetorn	:= 2		// Quero que seja retornado o segundo campo: DATA_VIGEN
		//.T. no envio do parametro _lCancProg, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene.
		//.T. no _lCancProg, ap๓s a Markgene, indica que realmente foi teclado o botใo cancelar e que devo abandonar o programa. 
		//.F. no _lCancProg, ap๓s a Markgene, indica que realmente nใo foi teclado o botใo cancelar ou que mesmo ele teclado, nใo devo abandonar o programa (mas apenas "limpar/desconsiderar" a marca็ใo dos registro) 
		_lCancProg	:= .T. 		//.T. no envio do parametro, indica que devo abandonar programa, se for clicado o botใo cancelar da MarkGene
		_cDtVigen	:= U_Array_In( U_MarkGene(cQryVigen, aCpoDtVig, cTitDtVig, nPosRetorn, @_lCancProg ) )
		If _lCancProg
			Return
		EndIf
	//EndIf
	
	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FRETE_TABELAS_FRETE"  )  + " WHERE "	+CRLF
	
	_cQuery += iif(!empty(_cCODFILIA ), " COD_FILIAL  IN " + _cCODFILIA, "" ) 							+ CRLF	//Filiais
	_cQuery += iif(!empty(_aRet[1] ), " AND TIPO_OPERACAO  = '" + _aRet[1] + "' ", " "			     )	+ CRLF	//Tipo de Opera็ใo
	_cQuery += iif(_aRet[2] == 1, " AND SITUACAO  = 'LIBERADA' " , " AND SITUACAO  = 'EM NEGOCIACAO' " ) + CRLF	//Situa็ใo
	
	If Empty(_cDtVigen )
		_cQuery += " " 												+ CRLF
	Else
		_cQuery += " AND DATA_VINGENCIA_DE_FILTRO IN " + _cDtVigen	+ CRLF 					//Data Vig๊ncia
	EndIf
	
	_cQuery += " ORDER BY  COD_FILIAL " 		+ CRLF
	_cQuery += " 		 , TABELA "				+ CRLF
	_cQuery += "         , NEGOCIACAO "			+ CRLF
	_cQuery += "         , TIPO_OPERACAO "		+ CRLF
	_cQuery += "         , DATA_VIGENCIA_DE "	+ CRLF
	_cQuery += "         , SEQUENCIA_FAIXA "	+ CRLF
	_cQuery += "         , ROTA "				+ CRLF
	_cQuery += "         , COMPONENTE "			+ CRLF
					
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

