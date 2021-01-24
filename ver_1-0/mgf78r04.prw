#include "totvs.ch"  

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF78R01	บAutor  ณ Geronimo Benedito Alves																	บData ณ  11/12/17  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: LOGISTICA/Gestใo Frete Embarcador- NFS Frete CTE					(M๓dulo 78-GFE) บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF78R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Frete Embarcador - Tabela de Frete Vํnculo"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Tabela de Frete Vํnculo"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Tabela de Frete Vํnculo"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Tabela de Frete Vํnculo"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""										

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//				  01			 02													 				 03		 04	 	 05	 					 06  07					  	
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL		as CAMP01"	,"C๓digo Filial"					,"C"	,006,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_FILIAL		as CAMP02"	,"Nome da Filial"					,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GU3_CDEMIT"	,"EMITENTE			as CAMP03"	,"Emitente"							,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GU3_NMEMIT"	,"NOME_EMITENTE		as CAMP04"	,"Nome Emitente"					,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_TPTAB"	,"COD_TIPO_TABELA	as CAMP05"	,"Cod. Tipo Tabela"					,"C"	,002,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_DSTAB"	,"DESC_TABELA		as CAMP06"	,"Desc Tabela"						,"C"	,018,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"TIPO_TABELA		as CAMP07"	,"Tipo Tabela"						,"C"	,040,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GV9_CDTPOP"	,"TIPO_OPERACAO		as CAMP08"	,"Tipo Operacao"					,"C"	,025,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_DTNEG"	,"DATA_NEGOCIACAO	as CAMP09"	,"Data Negocia็ใo"					,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"SITUACAO			as CAMP10"	,"Situacao"							,"C"	,002,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_NMCONT"	,"CONTATO			as CAMP11"	,"Contato"							,"C"	,006,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GVA_NMPROF"	,"PROFISSIONAL		as CAMP12"	,"Profissional"						,"C"	,006,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"TRAT_DECIM		as CAMP13"	,"Trat Decimal"						,"C"	,030,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GVA_OBS"		,"OBSERVACAO		as CAMP14"	,"Observa็ใo"						,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"SITUACAO_CPL		as CAMP15"	,"Situacao"							,"C"	,016,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_CPLDT"	,"DT_ULT_ENVIO		as CAMP16"	,"Data Ultimo Envio"				,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_DTCRIA"	,"DATA_CRIACAO		as CAMP17"	,"Data Criacao"						,"D"	,008,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GVA_USUCRI"	,"USER_CRIACAO		as CAMP18"	,"Usuario Criacao"					,"C"	,015,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GVA_DTATU"	,"DATA_ATUALIZACAO	as CAMP19"	,"Data Atualizacao"					,"D"	,008,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GVA_USUATU"	,"USER_ATUALIZACAO	as CAMP20"	,"Usuario Atualizacao"				,"C"	,018,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_EMIVIN"	,"EMITENTE_BASE		as CAMP21"	,"Emitente Base"					,"C"	,010,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_TABVIN"	,"TABELA_BASE		as CAMP22"	,"Tabela Base"						,"C"	,010,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_VLMULT"	,"MULTIPLIC			as CAMP23"	,"Multiplicador"					,"N"	,015,5	,"@E 999,999,999.99999" ,"" ,"" })
	Aadd(_aCampoQry, {"GVA_VLADIC"	,"ADICIONAL 		as CAMP24"	,"Adicional"						,"N"	,015,5	,"@E 999,999,999.99999"	,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"ENV_APROV			as CAMP25"	,"Envio Aprovador"					,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_DTAPR"	,"DATA_APROV		as CAMP26"	,"Data Aprova็ใo"					,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GVA_USUAPR"	,"USUARIO_APROV		as CAMP27"	,"Usuario Aprovador"				,"C"	,050,0	,"" 					,"" ,"" })
	
	aAdd(_aParambox,{1,"Tipo Opera็ใo"		,Space(03)	,""		,""	,""		,""			,050	,.T.})
	aAdd(_aParambox,{3,"Situa็ใo"			,1			,{"Liberada","Em Negociacao","Nใo Informar"}	,050,""	,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	If Empty(_aRet[1])
		MsgStop("O Tipo de Opera็ใo ้ obrigat๓rio informar.")
		Return .F.
	EndIf
	
	_cSitua	:= ""
	If _aRet[2] <> 3
		iif(_aRet[2] == 1, _cSitua := "LIBERADA" , _cSitua := "EM NEGOCIACAO" )
	EndIf
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FRETE_TABELAS_FRETE_VINCULO"  )  + " WHERE "			+ CRLF
	_cQuery += iif(!empty(_cCODFILIA ), " COD_FILIAL  IN " + _cCODFILIA, "" ) 								+ CRLF	//Filiais
	_cQuery += iif(!empty(_aRet[1] ), " AND TIPO_OPERACAO  = 	'" + _aRet[1] + "' ", " "			     )	+ CRLF	//Tipo de Opera็ใo
	_cQuery += iif(!empty(_cSitua ), " AND SITUACAO  = 			'" + _cSitua + "' "	, " "			     )	+ CRLF	//Tipo de Opera็ใo
	//_cQuery += iif(_aRet[2] == 1, " AND SITUACAO  = 'LIBERADA' " , " AND SITUACAO  = 'EM NEGOCIACAO' " ) 	+ CRLF	//Situa็ใo
		
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
