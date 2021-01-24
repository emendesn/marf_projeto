#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF30R02	บAutor  ณ Geronimo Benedito Alves                                                                   บ Data ณ 13/06/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Rotina que mostra na tela os dados da planilha:                                                                                   บฑฑ
//ฑฑบ          ณ EFF-Easy Financing - 30 -Financiamento - Ordens de Pagamento com Saldo                                                            บฑฑ
//ฑฑบ          ณ Os dados sao obtidos e mostrados na tela executando uma query, e depois, o usuario gera uma planilha excel com eles               บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods                                                                                                             บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF30R02()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Financiamento - Ordens de Pagamento com Saldo")	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Ordens de Pagamento com Saldo"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Ordens de Pagamento com Saldo"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Ordens de Pagamento com Saldo"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}												)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }									)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 35													//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03						 04	 05		 06	 07					  	 	 08  09	
	Aadd(_aCampoQry, {"A2_NOME"		,"EMPRESA"								,"Empresa"				,"C",040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"XXM0_CGC01"	,"CNPJ_FILIAL			as CNPJFILIAL"	,"Cnpj Filial"			,"C",018	,0	,"@!"						,""	,"@!"	 })
	Aadd(_aCampoQry, {"EEQ_DTCE"	,"DATA_CREDITO_EXTERIOR	as DTCREDIEXT"	,"Data Credito Exterior","D",008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEC_PREEMB"	,"EXP"									,"Exp"					,"C",020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_ZREFBC"	,"REFERENCIA_BANCARIA	as REFEBANCAR"	,"Referencia Bancaria"	,"C",030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_ZNOMEB"	,"NOME_BANCO"							,"Nome Banco"			,"C",040	,0	,""							,""	,""	 })								
	Aadd(_aCampoQry, {"A1_NOME"		,"TRADING"								,"Trading"				,"C",040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"CLIENTE"								,"Cliente"				,"C",040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"CLIENTE_FINAL			as CLIENTEFIN"	,"Cliente Final"		,"C",040	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_ENTREGA			as PAISENTREG"	,"Pais Entrega"			,"C",020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_DESTINO			as PAISDESTIN"	,"Pais Destino"			,"C",020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEC_DTEMBA"	,"DATABL"								,"Data BL"				,"D",008	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_RE"		,"RE"									,"RE"					,"C",012	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EE9_NRSD"	,"SD"									,"SD"					,"C",020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEC_NRODUE"	,"DUE"									,"Due"					,"C",014	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEC_CHVDUE"	,"CHAVE_DUE"							,"Chave Due"			,"C",030	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"XXEEQEVE02"	,"TIPO_CREDITO			as TIPOCREDIT"	,"Tipo de Credito"		,"C",020	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_MOEDA"	,"MOEDA"								,"Moeda"				,"C",003	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_VL"		,"SALDO_RE"								,"Saldo RE"				,"N",015	,2	,"@E 999,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_ZDESP"	,"DESPESAS"								,"Despesas"				,"N",010	,2	,"@E 9,999,999.99 "			,""	,""	 })
	Aadd(_aCampoQry, {"EEQ_VL"		,"SALDO_LIQUIDO			as SALDOLIQUI"	,"Saldo Liquido"		,"N",015	,2	,"@E 999,999,999,999.99"	,""	,""	 })
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ANALISTA_RESPONSAVEL	as ANALIRESPO"	,"Analista Responsavel"	,"C",035	,0	,""							,""	,""	 })
	Aadd(_aCampoQry, {"EEC_ZNTRAN"	,"NOME_NAVIO 			as NOMENAVIO "	,"Nome Navio"			,"C",025	,0	,""							,""	,""	 })

	aAdd(_aParambox,{1,"C๓digo de Cliente Inicial"	,Space(tamSx3("A1_COD")[1])	,"@!",""													,"SA1"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Loja   do Cliente Inicial"	,Space(tamSx3("A1_LOJA")[1]),"@!",""													,""		,"",050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo de Cliente Final"	,Space(tamSx3("A1_COD")[1])	,"@!","U_VLFIMMAI(MV_PAR01, MV_PAR03, 'C๓digo de Cliente')"	,"SA1"	,"",050,.F.})													
	aAdd(_aParambox,{1,"Loja   do Cliente Final"	,Space(tamSx3("A1_LOJA")[1]),"@!","U_VLFIMMAI(MV_PAR02, MV_PAR04, 'Loja do Cliente')"	,""		,"",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)	// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_FINAN_ORDEMSALDO"  )   + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),         " COD_FILIAL IN "         + _cCODFILIA                                 ) // OBRIGATORIO (SELEวรO DO COMBO)  CAMPO EMPRESAS(02 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[3]),         " COD_CLIENTE BETWEEN '"  + _aRet[01] + "' AND '" + _aRet[03] + "' " ) // NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE)
	_cQuery += U_WhereAnd( !empty(_aRet[4]),         " LOJA_CLIENTE BETWEEN '" + _aRet[02] + "' AND '" + _aRet[04] + "' " ) // NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE)

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN
