#Include "totvs.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGF78R07

Relatório de integrações Protheus x Multiembarcador

@description
De acordo com os parametros informados, gera relatorio com campos de Documentos de Frete
do módulo de Frete Embarcador.

@author Renato Vieira Bandeira Junior
@since 10/03/2020
@type Function

@table 
    GW3 - Documentos de Frete
	
@param
    _cpar01 - tipo do parâmetro e função do mesmo, resumir em uma linha apenas
    _cpar02 - tipo do parâmetro e função do mesmo, resumir em uma linha apenas 

	01 - Data Emissao De
	02 - Data Emissao Ate
	03 - CNPJ De - Utiliza grupo de perguntas "GR3TRP", que retorna Cnpj do Emitente
	04 - CNPJ Ate - Utiliza grupo de perguntas "GR3TRP", que retorna Cnpj do Emitente
	05 - Filial De
	06 - Filial Ate

@return
 	NIL

@menu
    Gestão Frete Embarcador-  Relatórios-Especificos Marfrig-Doc de Frete GFE
	
@history
    10/03/2020 - MGF78R07 - Criação do programa  - Renato V.B. Junior
/*/   

User Function MGF78R07()

	Local _cExport
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _nInterval, _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {} ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Relatório Doc de Frete GFE"				)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Relatório Doc de Frete GFE"				)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relatório Doc de Frete GFE" }			)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relatório Doc de Frete GFE" }			)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  )										//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, { {||.T.} } )								//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba

	_nInterval	:= 35											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//				   01				 	 	 02						 03						 	 04	 05	 06	 07	 08	 09 10

	Aadd(_aCampoQry, { "GW3_FILIAL"				,"GW3_FILIAL"			,"Filial"					,"C",06,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_CDESP"				,"GW3_CDESP"			,"Espécie"					,"C",05,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_EMISDF"				,"GW3_EMISDF"			,"Emissor"					,"C",14,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_SERDF"				,"GW3_SERDF"			,"Série"					,"C",05,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_NRDF"				,"GW3_NRDF"				,"Número CTE"				,"C",16,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_DTEMIS"				,"GW3_DTEMIS"			,"Data Emissão"				,"D",08,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_DTFIS"				,"GW3_DTFIS"			,"Data Fiscal"				,"D",08,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_DTENT"				,"GW3_DTENT"			,"Data Entrada/Integração"	,"D",08,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_TPDF"				,"GW3_TPDF"				,"Tipo Documento"			,"C",22,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_CFOP"				,"GW3_CFOP"				,"CFOP"						,"C",06,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_SIT"				,"GW3_SIT"				,"Sit. Tributária"			,"C",15,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_CDREM"				,"GW3_CDREM"			,"Remetente"				,"C",14,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_CDDEST"				,"GW3_CDDEST" 			,"Destinatário"				,"C",14,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_VLDF"				,"GW3_VLDF"				,"Valor Documento Fiscal"	,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_FRVAL"				,"GW3_FRVAL"			,"Valor Frete"				,"N",09,2	,"@E 999,999.99    " ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_TRBIMP"				,"GW3_TRBIMP"			,"Tributação"				,"C",22,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_BASIMP"				,"GW3_BASIMP"			,"Base ICMS"				,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_PCIMP"				,"GW3_PCIMP"			,"Alíquota ICMS"			,"N",05,2	,"@E 99.99         " ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_VLIMP"				,"GW3_VLIMP"			,"Vl ICMS"					,"N",09,2	,"@E 999,999.99    " ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_IMPRET"				,"GW3_IMPRET"			,"Vl ICMS Retido"			,"N",09,2	,"@E 999,999.99    " ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_BASCOF"				,"GW3_BASCOF"			,"Base COFINS"				,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_VLCOF"				,"GW3_VLCOF"			,"Vl COFINS"				,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_BASPIS"				,"GW3_BASPIS"			,"Base PIS"					,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_VLPIS"				,"GW3_VLPIS"			,"Vl PIS"					,"N",12,2	,"@E 999,999,999.99" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_CTE"				,"GW3_CTE"				,"Chave CT-e"				,"C",44,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_USUBLQ"				,"GW3_USUBLQ"			,"User Audit"				,"C",15,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_TES"				,"GW3_TES"				,"TES Atual"				,"C",03,0	,"" ,"" ,"" })
	Aadd(_aCampoQry, { "GW3_ZTESOR"				,"GW3_ZTESOR"			,"TES Origem"				,"C",03,0	,"" ,"" ,"" })

	aAdd(_aParambox,{1,"Data Emissao De"	,Ctod("")	,""	,""	,""		,"",050,.T.})	//03
	aAdd(_aParambox,{1,"Data Emissao Ate"	,Ctod("")	,""	,""	,""		,"",050,.T.})	//04
	aAdd(_aParambox,{1,"CNPJ De"			,Space(15)	,""	,""												,"GU3TRP"		,"",075,.F.})
	aAdd(_aParambox,{1,"CNPJ Ate"			,REPL("Z",15)	,""	,""											,"GU3TRP"		,"",075,.T.})

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_LOGIST_INTEG_EMBAR_PROTHEUS" )                   	+ CRLF
	_cQuery += U_WhereAnd(!empty(_cCODFILIA ),     " GW3_FILIAL IN "				+ _cCODFILIA                               ) //OBRIGATORIO (SELEÇÃO DO COMBO)  CAMPO FILIAL(06 posições)
	_cQuery += U_WhereAnd(!empty(_aRet[2] ),       " GW3_DTENT_FILTRO BETWEEN '"	+ _aRet[1]  + "' AND '" + _aRet[2] + "' " ) //OBRIGATORIO
	_cQuery += U_WhereAnd(!empty(_aRet[4] ),       " GW3_EMISDF BETWEEN '"	+ _aRet[3]  + "' AND '" + _aRet[4] + "' " ) //OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery) 
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
