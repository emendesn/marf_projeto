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
User Function MGF78R01()

	Private _aRet	   := {}, _aParambox := {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil := {}
	Private _cWhereAnd	:= "",_ctipDoc := "",_cTipSrv := ""
	Private _aEmailQry	:= {}

	Aadd(_aDefinePl, "Frete Embarcador - Nfs Frete CTE"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Nfs Frete CTE"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Nfs Frete CTE"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Nfs Frete CTE"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
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
	//					01			 02													 03									 04	 	 05	 06   07					  08 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL_NF						as CODFILIANF"	,"C๓digo Filial"					,"C"	,006,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL_NF						as NOMFILIANF"	,"Nome da Filial"					,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CIDADE_NF						as NOMCIDADNF"	,"Nome da Cidade"					,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"BA1_ESTADO"	,"NOM_ESTADO_NF						as NOMESTADNF"	,"Estado"							,"C"	,002,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"E2_CNPJC"	,"NUM_CNPJ_NF						as NUMCNPJ_NF"	,"CNPJ do Cliente"					,"C"	,018,0	,"@!"					,"" ,"@!" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE_NF					as NOMCLIENTE"	,"Nome do Cliente"					,"C"	,040,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"YA_DESCR"	,"NOM_PAIS_NF						as NOMPAIS_NF"	,"Paํs"								,"C"	,025,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"B1_DESC"		,"NOM_MUNICIPIO_NF					as NOMMUNICIP"	,"Municํpio"						,"C"	,076,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A2_EST"		,"NOM_UF_NF"										,"UF"								,"C"	,002,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"DAK_XOEREF"	,"NUM_ORDEM_EMBARQUE				as NUMORDEMBA"	,"Nบ Ordem de Embarque"				,"C"	,006,0	,""						,"" ,"" })
	//Aadd(_aCampoQry, {"DAI_COD"		,"OE_REFERENCIA						as REFERENCIA"	,"OE Referencia"					,"C"	,006,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"C5_NUM"		,"NUM_PEDIDO"										,"Nบ Pedido"						,"C"	,006,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"ZJ_NOME"		,"TIP_PEDIDO"										,"Descr. Tipo de Pedido"			,"C"	,030,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"F2_EMISSAO"	,"DT_EMISSAO_NF						as DTEMISS_NF"	,"Dt. Emissใo NF"					,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GW4_NRDC"	,"NUM_NF"											,"Nบ NF"							,"C"	,016,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GW4_SERDC"	,"NUM_SERIE_NF						as NUMSERIENF"	,"Nบ Serie NF"						,"C"	,003,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"F2_VALBRUT"	,"VLR_BRUTO_NF						as VLRBRUT_NF"	,"Vlr. Bruto NF"					,"N"	,017,2	,"@E 99,999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"F2_PBRUTO"	,"VLR_PESO_BRUTO_NF					as PESBRUT_NF"	,"Peso Bruto"						,"N"	,011,4	,"@E 999999.9999"		,"" ,"" })
	Aadd(_aCampoQry, {"F2_PLIQUI"	,"VLR_PESO_LIQUIDO_NF				as PESOLIQ_NF"	,"Peso Liquido"						,"N"	,011,4	,"@E 999999.9999"		,"" ,"" })
	Aadd(_aCampoQry, {"BV_DESCTAB"	,"STATUS_SEFAZ						as STAT_SEFAZ"	,"Status Sefaz"						,"C"	,018,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"AJU_COMPUN"	,"STATUS_NF_SAIDA					as STNF_SAIDA"	,"Status NF Saํda"					,"C"	,010,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"YA_DESCR"	,"TIPO_FRETE_NF						as TP_FRETENF"	,"Tipo Frete"						,"C"	,025,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_TRANSPORTADORA_NF 			as CNPJTRANSP"	,"CNPJ Transportad NF"				,"C"	,018,0	,"@!" 					,"" ,"@!" })
	Aadd(_aCampoQry, {"A4_NOME"		,"NOM_TRANSPORTADORA_NF				as NOMTRANSPO"	,"Nome Transportadora NF"			,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"DA3_PLACA"	,"PLACA_NF"											,"Placa NF"							,"C"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GV3_DSTPVC"	,"TIP_VEICULO_NF					as TIPVEICULO"	,"Tipo de Veiculo NF"				,"C"	,050,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GXG_NRDF"	,"NUM_DF_IMPORTACAO					as NUMDFIMPOR"	,"Nบ DF Importa็ใo"					,"C"	,016,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_TRANSP_IMPORTACAO 			as TRANSPIMPO"	,"Transportadora do XML"			,"C"	,018,0	,"@!" 					,"" ,"@!" })
	Aadd(_aCampoQry, {"A4_NOME"		,"NOM_TRANS_IMPORTACAO				as N_TRANSIMP"	,"Nome Transportadora do XML"		,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"HR_MUNICIP"	,"NOM_MUN_ORIGEM_IMPORTACAO			as ORIGEMIMPO"	,"Municํpio Origem Impor."			,"C"	,015,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GXG_DTIMP"	,"DT_IMPORTACAO_XML					as DTIMPORXML"	,"Data Importa็ใo XML"				,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GW4_DTEMIS"	,"DT_EMISSAO_IMPORTACAO				as DTEMISSIMP"	,"Data Emissใo Importa็ใo"			,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_FILIAL_IMPORTACAO				as NOMFILIIMP"	,"Nome da Filial Importa็ใo"		,"C"	,040,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"AG6_DSCPER"	,"NOM_DESTINATARIO_IMPORTACAO		as DESTINIMPO"	,"Nome Destinatแrio Importa็ใo"		,"C"	,080,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GI1_DSMUNI"	,"NOM_MUN_DEST_IMPORTACAO			as MUNIDESTIM"	,"Municํpio Destinatแrio Importa็ใo","C"	,060,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"GW3_PESOR"	,"VLR_PESO_IMPORTACAO				as VLPESO_IMP"	,"Peso Importa็ใo"					,"N"	,015,5	,"@E 9,999,999.99999"	,"" ,"" })
	Aadd(_aCampoQry, {"GXG_PEDAG"	,"VLR_PEDAGIO_IMPORTACAO			as VLPEDAGIOI"	,"Vlr. Pedแgio de Importa็ใo"		,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"GXG_VLIMP"	,"VLR_ICMS_IMPORTACAO				as VLICMSIMPO"	,"Vlr. ICMS Importa็ใo"				,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"GXG_VLDF"	,"VLR_DOCUMENTO_FRETE_IMPORTACAO	as VLDOCFRETE"	,"Vlr. Doc. Frete Import."			,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"ACT_DESCPG"	,"SIT_IMPORTACAO					as SITIMPORTA"	,"Situa็ใo de Importa็ใo"			,"C"	,015,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"GW4_NRDF"	,"NUM_DF_LANC						as NUM_DFLANC"	,"Nบ DF Lanc."						,"C"	,016,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"F1_SERIE"	,"NUM_SERIE_DF_LANC					as NUMSERIEDF"	,"Nบ Serie DF"						,"C"	,003,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"A2_CGC"		,"NUM_CNPJ_TRANS_LANC				as NUMCNPJLAN"	,"CNPJ Transpo. Lan็."				,"C"	,018,0	,"@!"					,"" ,"@!" })
	Aadd(_aCampoQry, {"A2_NOME"		,"NOM_TRANSP_LANC"									,"Nome Transportadora Lan็amento"	,"C"	,040,0	,""						,"" ,"" })
	Aadd(_aCampoQry, {"F1_DTDIGIT"	,"DT_LANCAMENTO						as DTLANCAMEN"	,"Dt. de Lan็amento"				,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO_LANC					as DTEMISSLAN"	,"Dt. Emissใo Lanc."				,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"E2_VENCTO"	,"DT_VCTO_LANC"										,"Dt. Vencimento Lanc."				,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"E2_VENCREA"	,"DT_VCTO_REAL_LANC"								,"Dt. Vencimento Real Lanc."		,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"E2_BAIXA"	,"DT_BAIXA_LANC"									,"Dt. Baixa Lanc."					,"D"	,008,0	,"" 					,"" ,"" })
	Aadd(_aCampoQry, {"F1_VALICM"	,"VLR_DOC_LANC						as VL_DOCLANC"	,"Vlr. Doc. Lanc."					,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"F1_VALPEDG"	,"VLR_PEDAGIO_LANC					as VLPEDAGLAN"	,"Vlr. Pedแgio Lanc."				,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"F1_VALICM"	,"VLR_ICMS_LANC						as VLICMSLANC"	,"Vlr. ICMS Lanc."					,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
	Aadd(_aCampoQry, {"F1_VALBRUT"	,"VLR_TOTAL_DOC_LANC				as VLTOTALLAN"	,"Vlr. Total Doc. Lanc."			,"N"	,014,2	,"@E 999,999,999.99"	,"" ,"" })
//	Aadd(_aCampoQry, {"DESC_01" 	,"TIPO_CALCULO"	                                    ,"Tipo de Cแlculo"                  ,"C"	,015,0	,"" 					,"" ,"" })
// 	Aadd(_aCampoQry, {"GW3_CDESP" 	,"ESPECIE_DOC"	                                    ,"Esp้cie de Documento"             ,"C"	,005,0	,"" 					,"" ,"" })
//	Aadd(_aCampoQry, {"DESC_02" 	,"TIPO_TRIBUTACAO"	                                ,"Tipo de Tributa็ใo"               ,"C"	,030,0	,"" 					,"" ,"" })

	aAdd(_aParambox,{1,"Data Emissใo Inicial"		,CtoD(Space(08))				,""	,""													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Data Emissใo Final"			,CtoD(Space(08))				,""	,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Nบ Ordem Embarque Inicial"	,Space(tamSx3("DAI_COD")[1])	,""	,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Nบ Ordem Embarque Final"	,Space(tamSx3("DAI_COD")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Ordem Embarque')"	,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Nบ Nota Fiscal"				,Space(tamSx3("GW4_NRDC")[1])	,""	,""													,"CBM"	,"",050,.F.})
	aAdd(_aParambox,{1,"Serie Nota Fiscal"			,Space(tamSx3("GW4_SERDC")[1])	,""	,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"CNPJ Transportadora NF"		,Space(tamSx3("A4_CGC")[1])		,""	,""													,""		,"",075,.F.})
	aAdd(_aParambox,{1,"CNPJ Transportadora XML" 	,Space(tamSx3("GXG_EMISDF")[1])	,""	,""													,""		,"",075,.F.})
	aAdd(_aParambox,{1,"CNPJ Transp. Lan็amento"	,Space(tamSx3("A2_CGC")[1])		,""	,""													,"SAX"	,"",075,.F.})
//	aAdd(_aParambox,{3,"Tipo de Documentos"			,Iif(Set(_SET_DELETED),1,2)		, {"TODOS","CTE","ND","NFS","NFST"} 						    ,100,"",.F.})
// 	aAdd(_aParambox,{3,"Tipo de Servico"			,Iif(Set(_SET_DELETED),1,2)		, {"TODOS","NORMAL","COMPLEMENTO","REDESPACHO"} 	    					            ,100,"",.F.})

	If !U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; EndIf
    
	// Escolha dos tipos de documentos
	//If _aRet[10] <> 1	// 1=Todos
	//   If     _aRet[10] == 2
	//   	  	  _cTipDoc := "CTE"
	//   ElseIf _aRet[10] == 3
	//   		  _cTipDoc := "ND"
	//   ElseIf _aRet[10] == 4
	//   		  _cTipDoc := "NFS"
	//   ElseIf _aRet[10] == 5
	//   		  _cTipDoc := "NFST"
	//   EndIf
    //EndIf

	// Escolha dos tipos de servi็o
    //If  _aRet[11] != 1
	//    If     _aRet[11] == 2
	//           _cTipSrv := "Normal"
	//	ElseIf _aRet[11] == 3 
	//	       _cTipSrv := "Complementar"
	//	ElseIf _aRet[11] == 4 
	//	       _cTipSrv := "Redespacho"
	//	EndIf	   
	//EndIf

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; EndIf
	_cCODFILIA	:= U_Array_In(_aSelFil)

	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))

	If cEnviroSrv $ 'PRODUCAO|PRE_RELEASE'
	   _cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_LOGIST_FRETE_CTE" )
	Else
    	_cQuery += " FROM V_LOGIST_FRETE_CTE"
	EndIf

	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " DT_EMISSAO_NF_FILTRO BETWEEN '"        	+ _aRet[1]  + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDAวรO DE 35 DIAS
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " COD_FILIAL_NF IN "                      	+ _cCODFILIA                              ) //OBRIGATORIO (SELEวรO DO COMBO)  CAMPO FILIAL(06 posi็๕es)
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " NUM_ORDEM_EMBARQUE BETWEEN  '"         	+ _aRet[3]  + "' AND '" + _aRet[4] + "' " ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd(!empty(_aRet[5] ),       " NUM_NF = '"                            	+ _aRet[5]  + "'"                         ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd(!empty(_aRet[6] ),       " NUM_SERIE_NF = '"                        	+ _aRet[6]  + "'"                         ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd(!empty(_aRet[7] ),       " COALESCE(CNPJ_TRANSPORTADORA_NF,' ') = '"	+ _aRet[7]  + "'"                         ) //NAO OBRIGATORIO 
	_cQuery += U_WhereAnd(!empty(_aRet[8] ),       " COALESCE(CNPJ_TRANSP_IMPORTACAO,' ') = '"	+ _aRet[8]  + "'"                         ) //NAO OBRIGATORIO	
	_cQuery += U_WhereAnd(!empty(_aRet[9] ),       " COALESCE(NUM_CNPJ_TRANS_LANC, ' ') = '"  	+ _aRet[9]  + "'"                         ) //NAO OBRIGATORIO
	
	// Fltro do tipos de documentos
	//_cQuery += U_WhereAnd(!empty(_cTipDoc), " ESPECIE_DOC = '" + _cTipDoc + "'" )
	
	// Fltro do tipos de servi็os
    //_cQuery += U_WhereAnd(!empty(_cTipSrv)," TIPO_CALCULO = '"+_cTipSrv+"'")
	//EndIf 
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN