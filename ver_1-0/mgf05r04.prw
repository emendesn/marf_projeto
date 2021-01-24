#INCLUDE "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF05R04	บAutor  ณ Geronimo Benedito Alves																	บData ณ  04/05/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: FATURAMENTO - Conferencia Roteiriza็ใo					(M๓dulo 05-FAT)			บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atraves da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF05R04()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Faturamento - Conferencia Roteiriza็ใo"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Conferencia Roteiriza็ใo"					)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Conferencia Roteiriza็ใo"}				)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Conferencia Roteiriza็ใo"}				)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  										)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02									 03						 04		 05	 06		 07	 	 08	 09		
	Aadd(_aCampoQry, {"C5_FILIAL"	,"FILIAL"							,"Filial"				,""		,""	,"" 	,""		,""	,""	})
	AAdd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO"						,"Nบ Pedido"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_CLIENT"	,"COD_CLIENTE		as CODCLIENTE"	,"C๓d. Cliente"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE		as NOMECLIENT"	,"Nome do Cliente"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_CODREG"	,"COD_REGIAO"						,"C๓d. da Regiใo"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"ZP_DESCREG"	,"DESC_REGIAO		as DESCREGIAO"	,"Nome da Regiใo"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C6_QTDVEN"	,"QUANTIDADE"						,"Quantidade"			,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZBLQRGA"	,"BLOQUEIO_REGRA	as BLOQUEIORE"	,"Bloqueio de Regra"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZTIPPED"	,"ESPECIE_PEDIDO	as ESPECIEPED"	,"Especie de Pedido"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_VEND1"	,"COD_VENDEDOR		as CODVENDEDO"	,"C๓d. Vendedor"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A3_NOME"		,"NOME_VENDEDOR		as NOM_VENDED"	,"Nome Vendedor"		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZROAD"	,"STATUS_INTEGRADO	as STATUSINTE"	,"Status Integra็ใo"	,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_TPFRETE"	,"TIPO_FRETE"						,"Tipo do Frete" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"C5_ZCROAD"	,"COD_ROADNET		as CODROADNET"	,"Cod. RoadNet" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_MUN"		,"MUNICIPIO"						,"Nome Municipio" 		,""		,""	,"" 	,""		,""	,""	})
	Aadd(_aCampoQry, {"XXXXCIDADE"	,"CIDADE"							,"UF/Cidade"			,"C"	,10	,0		,""		,""	,""	})
	Aadd(_aCampoQry, {"A1_END"		,"ENDERECO"							,"Endere็o"				,""		,""	,"" 	,""		,""	,""	})

	aAdd(_aParambox,{1,"Data de Entrega Inicial"	,Ctod("")						,""	,"" 												,""		,""	 ,050,.F.})
	aAdd(_aParambox,{1,"Data de Entrega Final"		,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data')"			,""		,""	 ,050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"		,Space(tamSx3("A1_COD")[1])		,""	,""													,"CLI"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Cliente Final:"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"	,"CLI"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Nบ Pedido Inicial:"			,Space(tamSx3("C5_NUM")[1])		,""	,""													,""	 	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Nบ Pedido Final:"			,Space(tamSx3("C5_NUM")[1])		,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Nบ Pedido')"		,""	 	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Regiใo Inicial:"		,Space(tamSx3("ZP_CODREG")[1])	,""	,""													,"SZP"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Regiใo Final:"			,Space(tamSx3("ZP_CODREG")[1])	,""	,"U_VLFIMMAI(MV_PAR07, MV_PAR08, 'Cod. Regiใo')"	,"SZP"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Municipio Inicial:"	,Space(tamSx3("A1_COD_MUN")[1])	,""	,""													,"CC2"	,""	 ,050,.F.})													
	aAdd(_aParambox,{1,"Cod. Municipio Final:"		,Space(tamSx3("A1_COD_MUN")[1])	,""	,"U_VLFIMMAI(MV_PAR09, MV_PAR10, 'Cod. Municipio')"	,"CC2"	,""	 ,050,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR","V_FAT_CONFERENCIAROTEIRIZACAO" ) + CRLF 
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),  " FILIAL IN "                     + _cCODFILIA	                             )	// OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),    " DATA_ENTREGA_FILTRO BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2]  + "' " )	// OBRIGATORIO, COM A VALIDAวรO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " COD_CLIENTE BETWEEN '"          + _aRet[3] + "' AND '" + _aRet[4]  + "' " )	// NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " NUM_PEDIDO BETWEEN '"           + _aRet[5] + "' AND '" + _aRet[6]  + "' " )	// NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[8] ),    " COD_REGIAO BETWEEN '"           + _aRet[7] + "' AND '" + _aRet[8]  + "' " )	// NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10] ),   " SUBSTR(CIDADE,3,5) BETWEEN '"   + _aRet[9] + "' AND '" + _aRet[10] + "' " )	// NรO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()	})

RETURN