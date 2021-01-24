#include "totvs.ch" 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF29R22	บAutor  ณGeronimo Benedito Alves                                                                    บData ณ  10/01/18  บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: EEC-Easy Export Control - 29 -EXPORTAวรO - Relat๓rio Estufagem                   บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com elesบฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods                                                                                                             บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF29R22()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Exporta็ใo - Relat๓rio Estufagem"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Relat๓rio Estufagem"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relat๓rio Estufagem"}			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relat๓rio Estufagem"}			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	//					01			 02											 03						 04	 05	  	 06	 07					  	 08		 09	
	Aadd(_aCampoQry, {"EEC_ZEXP"	,"NUM_EXP "									,"N๚mero Exporta็ใo"	,"C",013	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZANOEX"	,"ANO_EXP"									,"Ano Exporta็ใo"		,"C",002	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZSUBEX"	,"SUBEXP"									,"Sub Exporta็ใo"		,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZZR_PERDE"	,"DATA_PRODUCAO_DE			as DTPROD_DE", 	"Data Produ็ใo De"		,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZZR_PERATE"	,"DATA_PRODUCAO_ATE			as DTPROD_ATE"	,"Data Produ็ใo Ate"	,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZB8_ZDTEST"	,"DATA_ESTUFAGEM_PCP		as DTESTUFPCP"	,"Data Estufagem PCP"	,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZB8_ZDTPES"	,"DATA_ESTUFAGEM_TRANSPORTE	as ESTUFTRANS"	,"Dt. Estufagem Transp.","D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_BUYER				as COD_BUYER"	,"C๓d. Buyer"			,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_BUYER"								,"Nome Buyer"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_CONSIGNEE			as COD_CONSIG"	,"C๓d. Consignee"		,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CONSIGNEE			as NOM_CONSIG"	,"Nome Consignee"		,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"CODIGO_IMPORTADOR			as COD_IMPORT"	,"C๓d. Importador NF"	,"C",006	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_IMPORTADOR			as NM_IMPORT" 	,"Nome Importador NF"	,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_RESPON"	,"ADMINISTRADOR 			as ADMINISTRA"	,"Administrador"		,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YP_TEXTO"	,"TIPO_PAGAMENTO 			as TIPO_PGTO" 	,"Tipo de Pagamento"	,"C",080	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ANTECI"	,"VALOR_PGTO_ANTECIPADO		as VL_PGTOANT"	,"Valor Pago Antecipado","N",018	,2	,"@E 999,999,999,999.99",""		,""	})
	Aadd(_aCampoQry, {"EEC_INCOTE"	,"SALES_TERMS				as TERM_SALES"	,"Sales Terms"			,"C",003	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"ZBM_DESCRI"	,"LOCAL_ESTUFAGEM			as LOCAL_ESTU"	,"Local Estufagem"		,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_DLDRAF"	,"DATA_DEADLINE_DRAFT		as DATA_DRAFT"	,"Data DeadLine Draft"	,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZETAOR"	,"DATA_DEADLINE_CARGA		as DATA_CARGA"	,"Data DeadLine Carga"	,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EE6_NOME"	,"NAVIO"									,"Navio"				,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"EEC_ZETAOR"	,"ETA_ORIGEM"								,"E.T.A Origem"			,"D",008	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YR_CID_ORI"	,"PORTO_ORIGEM 				as PORTA_ORIG"	,"Porto Origem"			,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"Y5_NOME"		,"DESPACHANTE 				as DESPACHANT"	,"Despachante"			,"C",040	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YA_DESCR"	,"PAIS_DESTINO				as PAIS_DESTI"	,"Paํs Destino"			,"C",025	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YR_CID_DES"	,"PORTO_DESTINO				as PORTO_DEST"	,"Porto de Destino"		,"C",020	,0	,""						,""		,""	})
	Aadd(_aCampoQry, {"YC_NOME"		,"TIPO_PRODUTO				as TP_PRODUTO"	,"Tipo de Produto"		,"C",045	,0	,""						,""		,""	})
	
	aAdd(_aParambox,{1,"N๚mero de Exporta็ใo"		,Space(tamSx3("EEC_ZEXP")[1])	,"@!"	,""														,"EECEXP"	,"",050,.F.})
	aAdd(_aParambox,{1,"C๓d Importador Inicio"		,Space(tamSx3("A1_COD")[1])		,""		,""														,"CLI"		,"",050,.F.})
	aAdd(_aParambox,{1,"C๓d Importador Final "		,Space(tamSx3("A1_COD")[1])		,""		,"U_VLFIMMAI(MV_PAR02,MV_PAR03,'C๓d. Importador')"		,"CLI"		,"",050,.F.})
	aAdd(_aParambox,{1,"Administrador"				,Space(tamSx3("EEC_RESPON")[1])	,"@!"	,""														,""			,"",050,.F.})	// retirada a consulta SXB E33
	aAdd(_aParambox,{1,"Data Estufagem PCP Inicial"	,Ctod("")						,""		,""														,""			,"",050,.F.})
	aAdd(_aParambox,{1,"Data Estufagem PCP Final"	,Ctod("")						,""		,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Data Estufagem PCP')"	,""			,"",050,.F.})
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_aSelFil:= U_SeleEmp()					// Rotina para obter a selecใo das EMPRESAS a processar.
	If Empty(_aSelFil) ; Return ; Endif
	_cCODEMPRE  := U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_EX_RELESTUFAGEMKARIN"  )  + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODEMPRE ),  " FILIAL_FILTRO IN "           + _cCODEMPRE                             ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO EMPRESAS(02 posi็๕es)
	_cQuery += U_WhereAnd( !empty(_aRet[1] ),    " NUM_EXP LIKE '%"             + _aRet[1] + "%' "                       ) 
	_cQuery += U_WhereAnd( !empty(_aRet[3] ),    " CODIGO_IMPORTADOR BETWEEN '" + _aRet[2] + "' AND '" + _aRet[3] + "' " ) //NรO OBRIGATORIO, USUARIO COLOCA O CODIGO DE/ATE (RANGE)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),    " ADMINISTRADOR LIKE '%"       + _aRet[4] + "%' "                       ) //NรO OBRIGATORIO (USUARIO DIGITA )
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),    " ESTUFAGEM_PCP BETWEEN '"     + _aRet[5] + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN

