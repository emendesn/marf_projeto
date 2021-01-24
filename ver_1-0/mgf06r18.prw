#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF06R18	บAutor  ณ Geronimo Benedito Alves																	บData ณ  20/06/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Tํtulos Recebiveis				(M๓dulo 06-FIN)บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF06R18()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Tํtulos Recebํveis"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Tํtulos Recebํveis"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Tํtulos Recebํveis"}						)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Tํtulos Recebํveis"}						)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02						 03						 04	 05		 06	 07							 08		 09		
	Aadd(_aCampoQry, {"E1_FILIAL"	,"COD_FILIAL"			,"C๓d. Filial"			,"C",006	,0	,"" 						,"" 	,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL"			,"Nome Filial"			,"C",040	,0	,"" 						,"" 	,"" })
	Aadd(_aCampoQry, {"NUM_PREFIXO"	,"NUM_PREFIXO"			,"Prefixo"				,"C",003	,0	,"" 						,"" 	,"" })
	Aadd(_aCampoQry, {"NUM_TITULO"	,"NUM_TITULO"			,"Nบ Tํtulo"			,"C",009	,0	,"" 						,"" 	,"" })
	Aadd(_aCampoQry, {"NUM_EXP"		,"NUM_EXP"				,"Num EXP"				,"C",030	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"E1_MOEDA"	,"COD_MOEDA"			,"Moeda"				,"N",002	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"XXE1_MOEDA"	,"DESC_MOEDA"			,"Descri็ใo da Moeda"	,"C",015	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"COD_CLIENTE"	,"COD_CLIENTE"			,"C๓d. Cliente"			,"C",006	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"NOM_CLIENTE"	,"NOM_CLIENTE"			,"Nome Cliente"			,"C",040	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"COD_LOJA"	,"COD_LOJA"				,"C๓d Loja"				,"C",002	,0	,""  						,"" 	,"" })
	Aadd(_aCampoQry, {"E1_EMISSAO"	,"DT_EMISSAO"			,"Data de Emissใo"		,"D",008	,0	,"" 						,"" 	,"" })
	Aadd(_aCampoQry, {"E1_VENCTO"	,"DT_VENCTO"			,"Data Vencimento"		,"D",008	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"EEC_DEST"	,"SIGLA_PAIS_DESTINO"	,"Sigla Dest"			,"C",003	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"YA_DESCR"	,"NOM_PAIS_DESTINO"		,"Nome Pais Destino"	,"C",025	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"EEC_COND2"	,"COND_PAGAMENTO"		,"Cond. Pagto"			,"C",005	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"EEH_NOME"	,"NOM_FAMILIA_PROD"		,"Nome Familia Produto"	,"C",045	,0	,""							,"" 	,"" })
	Aadd(_aCampoQry, {"E1_SALDO"	,"VLR_SALDO_SE1"		,"Valor Saldo SE1"		,"N",016	,2	,"@E 9,999,999,999,999.99 "	,"" 	,"" })
	Aadd(_aCampoQry, {"EEQ_VL"		,"VLR_SALDO_EEQ"		,"Valor Saldo EEQ"		,"N",015	,2	,"@E 999,999,999,999.99 "	,"" 	,"" })

	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,""	,""													,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Cod. Cliente')" 	,"CLI"	,"",050,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet ) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_TITULOS_RECEBIVEIS" ) + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " COD_FILIAL IN "           + _cCODFILIA                               ) // OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " COD_CLIENTE BETWEEN '"    + _aRet[1]   + "' AND '" + _aRet[2] + "' " ) // NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN
