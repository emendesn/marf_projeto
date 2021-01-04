#include "totvs.ch"

/*/{Protheus.doc} MGF29R36
Relatório de comissão - ME (RTASK010461/RITM0032694)

@author Paulo da Mata
@since 05/12/2019
@version P12.1.17
@return Nil
/*/

User Function MGF29R36()

	Private _aRet	    := {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl  := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil	:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""

	Aadd(_aDefinePl, "Relatório de Comissão - ME")	  //01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Relatório de Comissão - ME")	  //02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relatório de Comissão - ME"})  //03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relatório de Comissão - ME"})  //04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}							   )  //05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry
	Aadd(_aDefinePl, { {||.T.} }				   )  //06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba

	_aCpoExce	:= {}
	_cTmp01		:= ""

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado
	//pela clausula "as" que será transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
	//					01			 02					 03							 04	 05	 06	07		08	09

	Aadd(_aCampoQry, {"EEC_FILIAL"		,"FILIAL"			,"FILIAL"    			,"C" ,TamSx3("EEC_FILIAL")[1],00,"","","",""})
	Aadd(_aCampoQry, {"EEC_PREEMB"		,"NUM_EXP"		 	,"EXP"       			,"C" ,TamSx3("EEC_PREEMB")[1],00,"","","",""})
	Aadd(_aCampoQry, {"EEC_IMPODE"		,"IMPORTADOR"    	,"IMPORTADOR"			,"C" ,TamSx3("EEC_IMPODE")[1],00,"","","",""})
	Aadd(_aCampoQry, {"Y9_DESCR"		,"PORTO_DESTINO"    ,"PORTO DESTINO"		,"C" ,TamSx3("Y9_DESCR")[1]  ,00,"","","",""})
	Aadd(_aCampoQry, {"YC_NOME"			,"TIPO_PRODUTO"     ,"TIPO PRODUTO"			,"C" ,TamSx3("YC_NOME")[1]   ,00,"","","",""})
	Aadd(_aCampoQry, {"DATA_BL"		    ,"DATA_BL"          ,"DATA BL"				,""  ,""                     ,00,"","","",""})
	Aadd(_aCampoQry, {"DT_VCT"			,"DT_VCT"           ,"DATA VENCIMENTO"		,""  ,""                     ,00,"","","",""})
	Aadd(_aCampoQry, {"EEC_DIASPA"		,"PRAZO"            ,"PRAZO"				,"N" ,TamSx3("EEC_DIASPA")[1],00,"","","",""})
	Aadd(_aCampoQry, {"DATA_LIQ_TOT"	,"DATA_LIQ_TOT"     ,"DATA LIQ TOTAL"		,""  ,""                     ,00,"","","",""})
	Aadd(_aCampoQry, {"EEC_CONDPA"		,"TIPO_PAGAMENTO"   ,"TIPO PAGAMENTO"		,"C" ,TamSx3("EEC_CONDPA")[1],00,"","","",""})
	Aadd(_aCampoQry, {"EEC_MOEDA"		,"MOEDA"            ,"MOEDA"				,"C" ,TamSx3("EEC_MOEDA")[1] ,00,"","","",""})
	Aadd(_aCampoQry, {"EEC_FRPPCC"		,"TIPO_PGTO_FRETE"  ,"TIPO PGTO FRETE"		,"C" ,TamSx3("EEC_FRPPCC")[1],00,"","","",""})
	Aadd(_aCampoQry, {"VALOR_ITEM_EMBAR","VALOR_ITEM_EMBAR" ,"VALOR ITEM EMBARCADO"	,"N" ,15,02,"@E 999,999,999,999.99","","",""})
	Aadd(_aCampoQry, {"VALOR_RECEBIDO"	,"VALOR_RECEBIDO"   ,"VALOR RECEBIDO"		,"N" ,15,02,"@E 999,999,999,999.99","","",""})
	Aadd(_aCampoQry, {"CREDIT_NOTE"		,"CREDIT_NOTE"      ,"CREDIT NOTE"			,"N" ,15,02,"@E 999,999,999,999.99","","",""})
	Aadd(_aCampoQry, {"DESP_BANCARIA"	,"DESP_BANCARIA"    ,"DESPESA BANCARIA"		,"N" ,15,02,"@E 999,999,999,999.99","","",""})
	Aadd(_aCampoQry, {"FRETE"			,"FRETE"            ,"FRETE"				,"N" ,15,02,"@E 999,999,999,999.99","","",""})

 	AADD(_aParambox,{1,"Emissao de"	  ,Ctod(Space(08)),"",""												,""	,""	,050,.F.})
	AADD(_aParambox,{1,"Emissao ate"  ,Ctod(Space(08)),"","U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Emissao' )"	,""	,""	,050,.F.})

	If !U_ParameRe(_aParambox, _bParameRe, @_aRet)
	   Return
	Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecão das FILIAIS a processar e as armazena na array _aSelFil
	
	If Empty(_aSelFil)
		Return
	Endif

	_cCODFILIA	:= U_Array_In(_aSelFil)

	cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))

	IF cEnviroSrv $ 'PRODUCAO|PRE_RELEASE'                  
		_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_COMISSAO_ME"  )				+ CRLF
	Else
	    _cQuery += "  FROM V_CR_COMISSAO_ME" + CRLF
	EndIF

    _cQuery += U_WhereAnd( !Empty(_cCODFILIA) , " FILIAL IN " 				   + _cCODFILIA 						 )
	_cQuery += U_WhereAnd( !Empty(_aRet[2])	  , " DT_EMISSAO_FILTRO BETWEEN '" + _aRet[1] + "' AND '"+_aRet[2]+"' ")

	MemoWrite("C:\TEMP\AAA_" + FunName() +".SQL",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN