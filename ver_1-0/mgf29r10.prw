#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF29R10	บAutor  ณ Geronimo Benedito Alves																	บData ณ08/01/18	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control -EXPORTACAO - Faturado Sem BL (M๓dulo 29)		บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF29R10()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "EXPORTAวรO - Faturado sem BL"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Faturado sem BL"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Faturado sem BL"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Faturado sem BL"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}								)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }					)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_nInterval	:= 35									//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03							 04	 05		 06	 07							08	 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP"								,"Exp #"					,"C",013	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"								,"Year"						,"C",002	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"								,"Item"						,"C",003	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_REFIMP"	,"REF_IMPORT"							,"PO#"						,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_TRADING			as NOMETRADIN"	,"Trading"					,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"							,"Buyer"					,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"NOME_IMPORTADOR		as NOM_IMPORT"	,"Importer"					,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE		as NOM_CONSIG"	,"Consignee"				,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO			as TIPOPRODUT"	,"Type Product"				,"C",045	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEH_NOME"	,"FAMILA_PRODUTO		as FAMILIAPRO"	,"Family"					,"C",045	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YQ_DESCR"	,"TIPO_TRANSPORTE		as TIPOTRANSP"	,"Via"						,"C",015	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO			as PORTODESTI"	,"Destination Port"			,"C",020	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_DESTINO			as PAIS_DESTI"	,"Destination Country"		,"C",025	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"Y5_NOME"		,"AGENCIA"								,"Shipping Line"			,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ZNUMRE"	,"NUM_RESERVA			as NRESERVA"	,"Booking #"				,"C",030	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EX9_CONTNR"	,"NUM_CONTAINER			as NCONTAINER"	,"Cntr #"					,"C",020	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"								,"Vessel"					,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ETADES"	,"DATA_ETA_ORIGEM"						,"ETA Origin"				,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YR_CID_ORI"	,"PORTO_ORIGEM			as PORTO_ORIG"	,"Origin Port"				,"C",020	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ZDELDR"	,"DATA_DEADLINE_DRAFT	as DTDEADDRAF"	,"Deadline Draft"			,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ZDTDEC"	,"DATA_DEADLINE_CARGA	as DTDEADCARG"	,"Deadline Cargo"			,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"Y5_NOME"		,"DESPACHANTE			as DESPACHANT"	,"Forwarder"				,"C",040	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"	,"TIPO_PAGAMENTO		as TP_PGTO"		,"Pymt Terms"				,"C",080	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_MOEDA"	,"MOEDA"								,"Currency"					,"C",003	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VAL_PAGO_ANTECIPADO 	as VL_PGTOANT"	,"Advance Value"			,"N",018	,2	,"@E 999,999,999,999.99"	,2	,""	})
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VALOR_PARCIAL			as VALORPARCI"	,"Partial Pymt"				,"N",018	,2	,"@E 999,999,999,999.99"	,2	,""	})
	Aadd(_aCampoQry, {"EEC_ZOBSWE"	,"OBS_WEEK"								,"Week"						,"C",090	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"ZZR_DTESTU"	,"DATA_ESTUFAGEM		as DATAESTUFA"	,"Stuffed Date" 			,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EE9_PSLQTO"	,"PESO_LIQUIDO			as PESOLIQUID"	,"Net Weight"				,"N",016	,3	,"@E 999,999,999,999.999"	,3	,""	})
	Aadd(_aCampoQry, {"EE9_PSBRTO"	,"PESO_BRUTO"							,"Gross Weight"				,"N",016	,3	,"@E 999,999,999,999.999"	,3	,""	})
	Aadd(_aCampoQry, {"ZZR_TOTCAI"	,"TOTAL_CAIXA			as TOTALCAIXA"	,"Total Amount"				,"N",015	,2	,"@E 999,999,999,999.99"	,2	,""	})
	Aadd(_aCampoQry, {"EE9_PRCINC"	,"TOTAL_ROMANEIO		as TOTROMANEI"	,"Total Invoiced"			,"N",015	,2	,"@E 999,999,999,999.99"	,2	,""	})
	Aadd(_aCampoQry, {"D2_DOC"		,"NUM_NF"								,"NF"						,"C",009	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"D2_EMISSAO"	,"DATA_EMISSAO			as DATAEMISSA"	,"Data Emissใo NF"			,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"M2_MOEDA2"	,"TAXA"									,"Taxa NF"					,"N",011	,4	,"@E 999,999.9999"			,4	,""	})
	Aadd(_aCampoQry, {"D2_TOTAL"	,"VALOR_NF"								,"Val NF"					,"N",017	,2	,"@E 99,999,999,999.99"		,2	,""	})
	Aadd(_aCampoQry, {"ZZR_PERDE"	,"DATA_PRODUCAO_DE		as DTPRODUDE"	,"Production Date (From)"	,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"ZZR_PERATE"	,"DATA_PRODUCAO_ATE		as DTPRODUATE"	,"Production Date (To)"		,"D",008	,0	,""							,0	,""	})
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR			as ADMINISTRA"	,"ADM"						,"C",020	,0	,""							,0	,""	})

	aAdd(_aParambox,{1,"Nome Trading"				,Space(tamSx3("A1_NOME")[1])	,"@!"	,""												,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome Importador"			,Space(tamSx3("A1_NOME")[1])	,"@!"	,""												,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome Consignee"				,Space(tamSx3("A1_NOME")[1])	,"@!"	,""												,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Nome Buyer"					,Space(tamSx3("A1_NOME")[1])	,"@!"	,""												,"VSA1"		,"",115,.F.})													
	aAdd(_aParambox,{1,"Paํs Destino (em portugues)",Space(tamSx3("YA_DESCR")[1])	,""		,""												,"SYAEXP"	,"",100,.F.})
	aAdd(_aParambox,{1,"Tipo Pagamento"				,Space(tamSx3("YP_TEXTO")[1])	,"@!"	,""												,""			,"",100,.F.})
	aAdd(_aParambox,{1,"Administrador"				,Space(tamSx3("EEC_RESPON")[1])	,"@!"	,""												,""			,"",100,.F.}) // retirada a consulta SXB E33
	aAdd(_aParambox,{1,"ETA Origem Inicial"			,Ctod("")						,""		,""												,""			,"",050,.F.})
	aAdd(_aParambox,{1,"ETA Origem Final"			,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'ETA Origem')"	,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Porto Origem"				,Space(tamSx3("YR_CID_ORI")[1])	,""		,""												,"SYRCID"	,"",115,.F.})
	aAdd(_aParambox,{1,"Despachante"				,Space(tamSx3("Y5_NOME")[1])	,"@!"	,""												,"Y5A"		,"",115,.F.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)
	
	_cQuery += "	FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_FATURADOSEMBL" ) + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " FILIAL_FILTRO IN "           + _cCODFILIA                              ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[1]),       " NOME_TRADING LIKE '%"        + _aRet[1]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[2]),       " NOME_IMPORTADOR LIKE '%"     + _aRet[2]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[3]),       " NOME_CONSIGNEE LIKE '%"      + _aRet[3]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " NOME_BUYER LIKE '%"          + _aRet[4]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[5]),       " PAIS_DESTINO_FILTRO LIKE '%" + _aRet[5]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[6]),       " TIPO_PAGAMENTO LIKE '%"      + _aRet[6]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[7]),       " ADMINISTRADOR LIKE '%"       + _aRet[7]  + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[8]),       " ETA_ORIGEM_FILTRO BETWEEN '" + _aRet[8]  + "' AND '" + _aRet[9] + "' " ) //NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[10]),      " PORTO_ORIGEM  LIKE '%"       + _aRet[10] + "%' "                       )// NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[11]),      " DESPACHANTE LIKE '%"         + _aRet[11] + "%' "                       )// NรO OBRIGATORIO (USUARIO DIGITA )

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

