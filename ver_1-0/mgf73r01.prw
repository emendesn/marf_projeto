#INCLUDE "totvs.ch"

/*/{Protheus.doc} MGF73R01 (Relatório dos Logs de RAMI'S Alteradas)
Relatï¿½rio que exibe os log's das RAMI'S alteradas

@description
Relatório que exibe os log's das RAMI'S alteradas, a partir de view pré definida. 

@author Paulo da Mata
@since 03/07/2020

@version P12.1.17
@country Brasil
@language Português

@type Function  
@table 
	View - V_LOG_RAMI

@param
@return

@menu
	SIGACRM->Relatorios/Especifico/Fretes e suprimentos 
@history
	RTASK0011155 - Integracao das alteracoes dos motivos da RAMI
/*/

User Function MGF73R01()

	Private _aRet	    := {}, _aParambox := {}, _bParameRe
	Private _aDefinePl  := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil := {}
	Private _aEmailQry , _cWhereAnd

	_aEmailQry	:= {}  ; _cWhereAnd	:= ""

	Aadd(_aDefinePl, "Logs de RAMIS Alteradas"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
	Aadd(_aDefinePl, "Logs de RAMIS Alteradas"	)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"RAMIS Alteradas"} 		)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"RAMIS Alteradas"} 		)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}  						)	//05-	Array de Arrays que define quais colunas serï¿½o mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} } 				)  	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluï¿½do naquela aba  	

	_aCpoExce	:= {}
	_cTmp01		:= ""

	Aadd(_aCampoQry, { "ZAV_FILIAL"	,"FILIAL"		,"Filial"		  ,"C",TamSx3("ZAV_FILIAL")[1],00,"","","","" })
	Aadd(_aCampoQry, { "M0_CIDENT"	,"UNIDADE"		,"Unidade"		  ,"" ,"",,"","","" })
	Aadd(_aCampoQry, { "ZAV_CODIGO"	,"NUM_RAMI"	    ,"RAMI"			  ,"C",TamSx3("ZAV_CODIGO")[1],00,"","","","" })
	Aadd(_aCampoQry, { "ZAV_NOTA"	,"NUM_NF"	    ,"Nota Fiscal"	  ,"C",TamSx3("ZAV_NOTA")[1]  ,00,"","","","" })
  	Aadd(_aCampoQry, { "ZAV_SERIE"	,"SER_NF"	    ,"Serie"    	  ,"C",TamSx3("ZAV_SERIE")[1] ,00,"","","","" })
	Aadd(_aCampoQry, { "ZAV_NFEMIS"	,"EMIS_NF"		,"Data Emissao"	  ,"D",TamSx3("ZAV_NFEMIS")[1],00,"","","","" })
  	Aadd(_aCampoQry, { "REV_RAMI"	,"REV_RAMI"	    ,"Revenda"        ,"" ,"",,"","","" })
  	Aadd(_aCampoQry, { "ZAV_DTABER"	,"ABERT_RAMI"	,"RAMI Aberta em" ,"D",TamSx3("ZAV_DTABER")[1],00,"","","","" })
  	Aadd(_aCampoQry, { "STAT_RAMI"	,"STAT_RAMI"    ,"Status RAMI"	  ,"" ,"",,"","","" })
  	Aadd(_aCampoQry, { "ZAV_NOMEUS"	,"USR_RAMI"	    ,"Usuario RAMI"	  ,"C",TamSx3("ZAV_NOMEUS")[1],00,"","","","" })
	Aadd(_aCampoQry, { "CV8_USER"	,"USR_LOG"	    ,"Usuario Log"	  ,"C",TamSx3("CV8_USER")[1]  ,00,"","","","" })
  	Aadd(_aCampoQry, { "CV8_DATA"	,"DT_LOG"	    ,"Log Criado em"  ,"D",TamSx3("CV8_DATA")[1]  ,00,"","","","" })
  	Aadd(_aCampoQry, { "CV8_HORA"	,"HR_LOG"	    ,"Hora" 	      ,"C",TamSx3("CV8_HORA")[1]  ,00,"","","","" })
  	Aadd(_aCampoQry, { "CV8_MSG"	,"MENS_LOG"	    ,"Mensagem"		  ,"C",TamSx3("CV8_MSG")[1]   ,00,"","","","" })

	aAdd(_aParambox,{1,"Data Ab. RAMI Inicio" ,CtoD(Space(08))					,""	,""															 ,"","",050,.T.})
	aAdd(_aParambox,{1,"Data Ab. RAMI Fim"    ,CtoD(Space(08))					,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR02	,'Data de Abertura da RAMI')","","",050,.F.})
	aAdd(_aParambox,{1,"RAMI de"	   		  ,Space(TamSx3("ZAV_CODIGO")[1])	,""	,""															 ,"","",050,.F.})
	aAdd(_aParambox,{1,"RAMI até"	   		  ,Space(TamSx3("ZAV_CODIGO")[1])	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cï¿½digo da RAMI')"			 ,"","",050,.F.})

	If !U_ParameRe(_aParambox, _bParameRe, @_aRet)
       Return
    Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecï¿½o das FILIAIS a processar e as armazena na array _aSelFil  
	
    If Empty(_aSelFil) 
       Return 
    Endif

    _cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR("IF_BIMFR", "V_LOG_RAMI")
	_cQuery += U_WhereAnd( !Empty(_cCODFILIA )  , " FILIAL IN " 		  + _cCODFILIA	                            )
	_cQuery += U_WhereAnd( !Empty(_aRet[2] )    , " ABERT_RAMI BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "  )
	_cQuery += U_WhereAnd( !Empty(_aRet[4] )    , " NUM_RAMI BETWEEN '"   + _aRet[3] + "' AND '" + _aRet[4] + "' "  )
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN
