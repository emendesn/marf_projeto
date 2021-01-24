#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R23	บAutor  ณ Geronimo Benedito Alves                                                                   บData ณ  13/07/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha: Financeiro - Contas a Pagar - Tํtulo por Tipo Valor (M๓dulo 06-FIN)                    บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso       ณ Marfrig Global Foods                                                                                                              บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R23()
	 
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
 
 
	Aadd(_aDefinePl, "Contas เ Pagar - Tํtulo por Tipo Valor"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Tํtulo por Tipo Valor"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Tํtulo por Tipo Valor"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Tํtulo por Tipo Valor"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01				02						03							 04		 05		 06	 07		08	09	
	Aadd(_aCampoQry, {"E2_FILIAL"		,"COD_EMPRESA"			,"Cod. Filial"				,"C"	,006	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"M0_FILIAL"		,"DESC_EMPRESA"			,"Descri็ใo da Empresa"		,"C"	,041	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PREFIXO"		,"PREFIXO"				,"Prefixo"					,"C"	,003	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"X5_CHAVE"		,"TIPO"					,"Tipo NF"					,"C"	,003	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NATUREZ"		,"NATUREZA"				,"Natureza"					,"C"	,010	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_COD"			,"COD_FORNECEDOR"		,"Cod. Fornecedor"			,"C"	,006	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_LOJA"			,"LOJA"					,"Cod. Loja Forn."			,"C"	,002	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"A2_NOME"			,"NOME_FORNECEDOR"		,"Nome Fornecedor"			,"C"	,040	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_NUM"			,"NUM_TITULO"			,"N๚mero do Tํtulo"			,"C"	,009	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_PARCELA"		,"PARCELA"				,"Parcela"					,"C"	,002	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_EMISSAO"		,"DATA_EMISSAO"			,"Data Emissใo"				,"D"	,008	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VENCREA"		,"DT_VENCIMENTO_REAL"	,"Data Venc. Real"			,"D"	,008	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_BAIXA"		,"DT_PAGAMENTO"			,"Data Pagamento"			,"D"	,008	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"E2_VLCRUZ"		,"VALOR_TITULO"			,"Valor Tํtulo"				,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_IRRF"			,"TOTAL_IMPOSTOS"		,"Total Impostos"			,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E5_VALOR"		,"VALOR_COMPENSADO"		,"Valor Compensado"			,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_DECRESC"		,"VALOR_DESC_JUROS"		,"Valor Desc. Juros"		,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"E2_VALLIQ"		,"VALOR_PAGO"			,"Valor Pago"				,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"ZDS_COD"			,"COD_TP_VALOR"			,"C๓digo TP Valor"			,"C"	,003	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZDR_DESC"		,"DESC_TP_VALOR"		,"Descri็ใo TP Valor"		,"C"	,030	,0	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZDS_VALOR"		,"VALOR_TP_VR"			,"Valor TP VR"				,"N"	,014	,2	,"@E 99,999,999,999.99"	,""	,""	})
	Aadd(_aCampoQry, {"OBS_AUDITORIA"	,"OBS_AUDITORIA"		,"Observa็ใo Auditoria"		,"C"	,010	,0	,""		,""	,""	})
	

	aAdd(_aParambox,{1,"C๓digo Fornecedor Inicial"		,Space(tamSx3("A2_COD")[1])		,"@!"	,""															,"SA2"	,, 050,.F.})	//01
	aAdd(_aParambox,{1,"C๓digo Fornecedor Final"		,Space(tamSx3("A2_COD")[1])		,"@!"	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'C๓digo Fornecedor')"		,"SA2"	,, 050,.F.})	//02
	aAdd(_aParambox,{1,"Tipo Valor Inicial"				,Space(tamSx3("ZDS_COD")[1])	,"@!"	,""															,""		,, 050,.F.})	//03
	aAdd(_aParambox,{1,"Tipo Valor Final"				,Space(tamSx3("ZDS_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04	,'Tipo Valor  ')"			,""		,, 050,.F.})	//04
	aAdd(_aParambox,{1,"C๓digo Natureza Inicial"		,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,""															,"SED"	,, 100,.F.})	//05
	aAdd(_aParambox,{1,"C๓digo Natureza Final"			,Space(tamSx3("E2_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR05, MV_PAR06	,'C๓digo Natureza')"		,"SED"	,, 100,.F.})	//06
	aAdd(_aParambox,{1,"Data Emissใo Inicial"			,Ctod("")						,""		,""															,""		,, 050,.F.})	//07
	aAdd(_aParambox,{1,"Data Emissใo Final"				,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Data Emissใo' )"			,""		,, 050,.F.})	//08
	aAdd(_aParambox,{1,"Data Vencimento Real Inicial"	,Ctod("")						,""		,""															,""		,, 050,.F.})	//09
	aAdd(_aParambox,{1,"Data Vencimento Real Final"		,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Data Vencimento Real' )"	,""		,, 050,.F.})	//10
	aAdd(_aParambox,{3,"Trazer s๓ os Tํtulos Originais ou trazer todos os Tํtulos ?", Iif(Set(_SET_DELETED),1,2), {"Tras s๓ os Tํtulos Originais","Trแs todos os tํtulos, inclusive as Faturas" }, 150, "",.F.}) //11

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_TITULO_TIPOVALOR"  )             + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " COD_EMPRESA IN "                     + _cCODFILIA                              ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " COD_FORNECEDOR BETWEEN '"            + _aRet[1] + "' AND '" + _aRet[2]  + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " COD_TP_VALOR BETWEEN '"              + _aRet[3] + "' AND '" + _aRet[4]  + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " NATUREZA BETWEEN '"                  + _aRet[5] + "' AND '" + _aRet[6]  + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE) 
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),      " DT_EMISSAO_FILTRO BETWEEN '"         + _aRet[7] + "' AND '" + _aRet[8]  + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),     " DT_VENCIMENTO_REAL_FILTRO BETWEEN '" + _aRet[9] + "' AND '" + _aRet[10] + "' " ) //NAO OBRIGATORIO
	If _aRet[11] = 1
		_cQuery += U_WhereAnd( .T. ,                   " FATURA_FILTRO = 0 " )	//FATURA_FILTRO = 0, traz SOMENTE tํtulos Originais. 
	Else
		_cQuery += U_WhereAnd( .T. ,                   " FATURA_FILTRO = 1 " )	// Tํtulos Originais e Faturas
	Endif		
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

