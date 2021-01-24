#include "totvs.ch"  

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ MGF34R15	บAutor  ณ Geronimo Benedito Alves																	บData ณ13/04/18	บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฯออออออออออออนฑฑ
//ฑฑบDesc.		ณ Rotina que mostra na tela os dados da planilha: CONTABILIDADE - Planejamento - Pagamento de Compra de Gado  (M๓dulo 34-CTB)		บฑฑ
//ฑฑบ			ณ Os dados sao obtidos e mostrados na tela atrav้z da execu็ใo de query, e depois, o usuario pode gerar uma planilha excel com eles บฑฑ
//ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบUso		ณ Marfrig Global Foods																												บฑฑ
//ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function MGF34R15()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Planejamento - Pgto de Compra de Gado"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerแ na regua de processamento.
	Aadd(_aDefinePl, "Pgto de Compra de Gado"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Pgto de Compra de Gado"}					)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Pgto de Compra de Gado"}					)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serใo mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, serแ mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluํdo naquela aba  
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou ้ usado alguma fun็ใo (Sum,Count,max,Coalesc,etc), ้ dado a ele um apelido indicado    
	//pela clausula "as" que serแ transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sใo sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serใo preservados.
	//					01			 02										 03							 04		05		06	07		  				  	 08	 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"FILIAL"								,"C๓d. Filial"				,"C"	,006	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_TES"		,"COD_TES"								,"C๓d. TES"					,"C"	,003	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"F4_TEXTO"	,"DESCRICAO_TES			as DESCRI_TES"	,"Descr. TES"				,"C"	,060	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_CF"		,"COD_FISCAL"							,"C๓digo Fiscal"			,"C"	,005	,0	,""  						,"" ,"" })	  
	Aadd(_aCampoQry, {"D1_DOC"		,"NOTA_FISCAL			as NOTAFISCAL"	,"Nบ Nota Fiscal"			,"C"	,009	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_SERIE"	,"SERIE"								,"Nบ Serie"					,"C"	,003	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_EMISSAO"	,"DATA_EMISSAO			as DT_EMISSAO"	,"Data de Emissใo"			,"D"	,008	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_DTDIGIT"	,"DATA_DIGITACAO		as DT_DIGITAC"	,"Data de Digita็ao"		,"D"	,008	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"F1_COND"		,"CONDICAO_PAGAMENTO	as COND_PAGTO"	,"Condi็ใo de Pagamento"	,"C"	,003	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"E4_DESCRI"	,"DESCRICAO_COND_PGTO	as DESC_PAGTO"	,"Descr. Condi็ใo de Pagto"	,"C"	,015	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"E2_VENCTO"	,"VENCIMENTO			as DT_VENCIME"	,"Data de Vencimento"		,"D"	,008	,0	,""  						,"" ,"" })  
	Aadd(_aCampoQry, {"E2_VENCREA"	,"VECIMENTO_REAL		as VENCI_REAL"	,"Data de Vencimento Real"	,"D"	,008	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"F1_FORNECE"	,"COD_FORNECEDOR		as COD_FORNEC"	,"C๓d. Fornecedor"			,"C"	,006	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_NOME"		,"FORNECEDOR"							,"Nome Fornecedor"			,"C"	,040	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"F1_LOJA"		,"LOJA"									,"Loja"						,"C"	,002	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_TPESSOA"	,"TIPO_PESSOA			as TP_PESSOA"	,"Tipo de Pessoa"			,"C"	,002	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ_CPF"								,"CNPJ ou CPF"				,"C"	,018	,0	,"@!"  						,"" ,"@!" })
	Aadd(_aCampoQry, {"A2_END"		,"FAZENDA"								,"Fazenda"					,"C"	,040	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_INSCR"	,"INSCRICAO_ESTADUAL	as INESTATUAL"	,"Inscri็ใo Estatual"		,"C"	,018	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_MUN"		,"CIDADE"								,"Cidade"					,"C"	,040	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"A2_EST"		,"ESTADO"								,"Estado"					,"C"	,002	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_COD"		,"COD_PRODUTO 			as CODPRODUTO"	,"C๓d. Produto"				,"C"	,015	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"B1_DESC"		,"DESC_PRODUTO			as DESC_PRODU"	,"Descr. Produto"			,"C"	,076	,0	,""  						,"" ,"" })
	AAdd(_aCampoQry, {"D1_QUANT"	,"QUANTIDADE"							,"Quantidade"				,"N"	,017	,3	,"@E 999,999,999,999.999"	,"" ,"" }) 
	Aadd(_aCampoQry, {"D1_UM"		,"UNIDADE"								,"Unidade"					,"C"	,002	,0	,""  						,"" ,"" })
	Aadd(_aCampoQry, {"D1_TOTAL"	,"TOTAL_NF"								,"Total NF"					,"N"	,016	,2	,"@E 99,999,999,999.99"		,"" ,"" })
	
	aAdd(_aParambox,{1,"Data Entrada Inicial"			,Ctod("")					,""	,"" 														,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Entrada Final"				,Ctod("")					,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Entrada')"			,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Tipo de Entrada/Saida Inicial"	,Space(tamSx3("D1_TES")[1])	,""	,""															,"SF4"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"Tipo de Entrada/Saida Final"	,Space(tamSx3("D1_TES")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Tipo de Entrada/Saida')"	,"SF4"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo Fiscal Inicial"			,Space(tamSx3("D1_CF")[1])	,""	,""															,"13"	,"",050,.F.}) 
	aAdd(_aParambox,{1,"C๓digo Fiscal Final"			,Space(tamSx3("D1_CF")[1])	,""	,"U_VLFIMMAI(MV_PAR05, MV_PAR06, 'C๓digo Fiscal')"			,"13"	,"",050,.F.}) 

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecใo das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_PLANEJAMENTO_PAGAMENTOGADO" ) +CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " FILIAL IN "             + _cCODFILIA                                ) // OBRIGATORIO - SELECIONAR AS FILIAIS
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DATA_ENTRADA BETWEEN '" + _aRet[1]    + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO, COM A VALIDAวรO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " COD_TES BETWEEN '"      + _aRet[3]    + "' AND '" + _aRet[4] + "' " ) //NรO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[6] ),      " COD_FISCAL BETWEEN '"   + _aRet[5]    + "' AND '" + _aRet[6] + "' " ) //NรO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
	
RETURN

