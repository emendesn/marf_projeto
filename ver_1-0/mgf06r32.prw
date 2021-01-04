#include "totvs.ch" 
/*
{Protheus.doc} MGF06R32 
@description 
	PRB0040776 Relátorio Protheus Capa
	Relatório para exibir títulos filtrados. 
@author Henrique Vidal Santos
@Type Relatório
@since 25/03/2020
@version P12.1.017
*/
User Function MGF06R32()
	Local cCpoSld	:= "E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE-E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO AS E2_ZSALDO"		
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Pagar - Protheus Capa	")	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Protheus Capa"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Protheus Capa"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Protheus Capa"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  
	_nInterval	:= 35										//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""									

	Aadd(_aCampoQry, {""			,"E2_FILIAL"		,"Filial"				,"C",30							,0, ""						,""	,""	})
	//Aadd(_aCampoQry, {"E2_PREFIXO"	,"E2_PREFIXO"		,"Prefixo"				,"C",TamSx3("E2_PREFIXO")[1]	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"		,"E2_NUM"			,"Nº Título"			,"C",TamSx3("E2_NUM")[1]		,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_TIPO"		,"E2_TIPO"			,"Tipo"					,"C",TamSx3("E2_TIPO")[1]		,0, ""						,""	,""	})  
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"E2_NATUREZ"		,"Natureza"				,"C",TamSx3("E2_NATUREZ")[1]	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_ZRAZAO"	," '' AS E2_ZRAZAO"	,"Razão Social"			,"C",TamSx3("E2_ZRAZAO")[1]		,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"E2_EMISSAO"		,"Data Emissão"			,"D",TamSx3("E2_EMISSAO")[1]	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"	,"E2_VENCREA"		,"Vencimento Real"		,"D",TamSx3("E2_VENCREA")[1]	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_VALOR"	,"E2_VALOR"			,"Valor Titulo"			,"N",TamSx3("E2_VALOR")[1]		,2, "@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_ZSALDO"	,cCpoSld			,"Saldo Liq"			,"N",TamSx3("E2_ZSALDO")[1]		,2, "@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_EMIS1"	,"E2_EMIS1"			,"Data Contábil"		,"D",TamSx3("E2_EMIS1")[1]		,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"E2_USERLGI"	,"E2_ZLOGI"			,"Log Inclusão"			,"C",TamSx3("E2_ZLOGI")[1]		,0,  						,""	,""	})
	

	aAdd(_aParambox,{1,"Data Emissão Inicial"		,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Emissão Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissao')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Vencimento Real Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Vencimento Real Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Vencimento Real')",""		,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Fornecedor Inicial"	,Space(tamSx3("A2_COD")[1])		,"@!"	,"" 												,"SA2"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Fornecedor Final"		,Space(tamSx3("A2_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod.Fornecedor')"	,"SA2"	,"",050,.F.})		
	aAdd(_aParambox,{1,"Numero Titulo"				,Space(tamSx3("E2_NUM")[1])		,""		,"" 												,""		,"",050,.F.})		
	aAdd(_aParambox,{1,"Prefixo Inicial"			,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,"" 												,""		,"",050,.F.})  
	aAdd(_aParambox,{1,"Prefixo Final"				,Space(tamSx3("E2_PREFIXO")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'Prefixo')"		,""		,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Inicial"		,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"" 												,"SED"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Final"		,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR10, MV_PAR11, 'Cod. Natureza')"	,"SED"	,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Contab. Inicial"			,Ctod("")						,""		,"" 												,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Dt Contab. Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR12, MV_PAR13, 'DT Contab.')"		,""		,"",050,.F.})	
	aAdd(_aParambox,{1,"Tipo Inicial"				,Space(tamSx3("E2_TIPO")[1])	,"@!"	,"" 												,"05"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Tipo Final"					,Space(tamSx3("E2_TIPO")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR14, MV_PAR15, 'Tipo')"			,"05"	,"",050,.F.})  												

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	IF Empty(_aRet[2]) .and. Empty(_aRet[4]) .and.  Empty(_aRet[13]) 
		MsgStop("É obrigatório o preenchimento do parâmetro data de Vencimento final e/ou do parâmetro data de Vencimento Real final.")
		Return.F.

	ElseIf _aRet[1] > _aRet[2]
		MsgStop("A Data de Vencimento Inicial, não pode ser maior que a data de Vencimento Final.")
		Return.F.

	ElseIf _aRet[3] > _aRet[4]
		MsgStop("A Data de Vencimento Real Inicial, não pode ser maior que a data de Vencimento Real Final.")
		Return.F.

	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)	
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)


	_cQuery := "  SELECT ( 	SELECT E2_FILIAL||'-'||sc.M0_FILIAL  FROM SYS_COMPANY SC WHERE SC.M0_CODFIL = XE2.E2_FILIAL AND SC.D_E_L_E_T_ =' ' ) as E2_FILIAL   " 	+CRLF 
	_cQuery += "  ,  E2_NUM " 			+CRLF 
	_cQuery += "  ,  E2_TIPO " 			+CRLF 
	_cQuery += "  ,  E2_NATUREZ " 		+CRLF 
	_cQuery += "  ,  ( SELECT A2_NOME FROM "+ RetSqlname('SA2') + " WHERE A2_FILIAL ='" +  xFilial('SA2') + "'  AND A2_COD = XE2.E2_FORNECE AND A2_LOJA = XE2.E2_LOJA AND D_E_L_E_T_ =' ') as E2_ZRAZAO "
	_cQuery += "  ,  E2_EMISSAO  " 		+CRLF 
	_cQuery += "  ,  E2_VENCREA " 		+CRLF 
	_cQuery += "  ,  E2_VALOR " 		+CRLF 
	_cQuery += "  ,  E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE-E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO AS E2_ZSALDO " +CRLF 
	_cQuery += "  ,  E2_EMIS1 " 		+CRLF 

	_cQuery += "  ,	(  " 				+CRLF 
	_cQuery += "  	SELECT USR_CODIGO " 				+CRLF 
	_cQuery += "  	FROM SYS_USR USR, SE2010 a " 		+CRLF 
	_cQuery += "  	WHERE 1=1	" 						+CRLF 
	_cQuery += "  	AND USR.USR_ID = TRIM( substr(E2_USERLGI, 11, 1) || substr(E2_USERLGI, 15, 1) || " 		+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 2, 1) || substr(E2_USERLGI, 6, 1) || " 		+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 10, 1) || substr(E2_USERLGI, 14, 1) ||  " 	+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 1, 1) || substr(E2_USERLGI, 5, 1) || " 		+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 9, 1) || substr(E2_USERLGI, 13, 1) ||  " 	+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 17, 1) || substr(E2_USERLGI, 4, 1) ||  " 	+CRLF 
	_cQuery += "  		substr(E2_USERLGI, 8, 1))  " 									+CRLF 
	_cQuery += " 	AND a.D_E_L_E_T_ <> '*'  " 											+CRLF 
	_cQuery += " 	AND a.E2_FILIAL = XE2.E2_FILIAL  	"								+CRLF 
	_cQuery += " 	AND a.E2_PREFIXO = XE2.E2_PREFIXO   " 								+CRLF 
 	_cQuery += " 	AND a.E2_NUM = XE2.E2_NUM  	" 										+CRLF 
 	_cQuery += " 	AND a.E2_PARCELA = XE2.E2_PARCELA   " 								+CRLF 
	_cQuery += " 	AND a.E2_TIPO = XE2.E2_TIPO	    	" 								+CRLF 	 
	_cQuery += " 	AND a.E2_FORNECE = XE2.E2_FORNECE   " 								+CRLF 
	_cQuery += " 	AND a.E2_LOJA = XE2.E2_LOJA 		"								+CRLF 
	_cQuery += "  	) as E2_ZLOGI "														+CRLF 
	
	_cQuery += "  ,  ' ' as X  " 		+CRLF 
	_cQuery += "	FROM " + RetSqlname('SE2')  + ' XE2' +CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " E2_EMISSAO BETWEEN '"   + _aRet[1]  + "' AND '" + _aRet[2]  + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " E2_VENCREA BETWEEN '" 	+ _aRet[3]  + "' AND '" + _aRet[4]  + "' " ) // OBRIGATORIO, COM A VALIDAÇÃO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),   " E2_FILIAL IN "          + _cCODFILIA                               ) // OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),     " E2_FORNECE  BETWEEN '"  + _aRet[5]  + "' AND '" + _aRet[6]  + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[7] ),     " E2_NUM = '"             + _aRet[7]  + "' "                         ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[9] ),     " E2_PREFIXO  BETWEEN '"  + _aRet[8]  + "' AND '" + _aRet[9]  + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[11] ),    " E2_NATUREZ  BETWEEN '"  + _aRet[10] + "' AND '" + _aRet[11] + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[13] ),    " E2_EMIS1 BETWEEN '" 	+ _aRet[12] + "' AND '" + _aRet[13]  + "' " ) // NÃO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[15] ),    " E2_TIPO  BETWEEN '" 	+ _aRet[14] + "' AND '" + _aRet[15] + "' " ) // NÃO OBRIGATORIO
	_cQuery += " AND  XE2.D_E_L_E_T_ =' ' " +CRLF 
	_cQuery += " ORDER BY E2_FILIAL, E2_NUM, E2_PREFIXO, E2_PARCELA "

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
Return