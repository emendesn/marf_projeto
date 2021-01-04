#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              MGFFIN05
Autor....:              Luis Artuso
Data.....:              20/09/2016
Descricao / Objetivo:   Execucao do P.E. F240FIL
Doc. Origem:            Contrato - GAP MGFFIN05
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MGFFIN05()

	Local cRet		:= ""
	Local cMvParCC	:= ""
	Local cMvParDT	:= ""
	Local cMvParBOL	:= ""
	Local aParambox		:= {}
	Local aRet := {}
	Local ParSav01
	Local ParSav02
	Local ParSav03
	Local ParSav04
	Local ParSav05
	Local ParSav06
	Local ParSav07
	Local cFilAux := ""
	local _cFiltro
	Local cNumBor	:= Space(Len(SE2->E2_ZBORD))
	
	/*cMvParCC	:= AllTrim(SuperGetMv("MGF_MODCC" , NIL , "01/"))  //Modelos Utilizados para Conta Corrente
	cMvParDT	:= AllTrim(SuperGetMv("MGF_MODDT" , NIL , "03/41/43/"))  //Modelos utilizados para Doc ou TED
	cMvParBOL	:= AllTrim(SuperGetMv("MGF_MODBOL" , NIL , "30/31/")) //Modelos utilizados para Boletos

	Do Case

		Case ( AllTrim(cModPgto) $ cMvParCC )

			cRet	:= "( (E2_FORBCO == '" + cPort240 + "' ) .AND. Empty(E2_CODBAR) )"

		Case ( AllTrim(cModPgto) $ cMvParDT )

			cRet	:= "( (E2_FORBCO <> '" + cPort240 + "' ) .AND. Empty(E2_CODBAR) )"

		Case ( AllTrim(cModPgto) $ cMvParBOL ) .And. AllTrim(cModPgto) == "30" // LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU

			cRet	:= "( (E2_FORBCO == '341' ) .AND. !Empty(E2_CODBAR) )"

		Case ( AllTrim(cModPgto) $ cMvParBOL )

			cRet	:= "( (E2_FORBCO <> '341' ) .AND. !Empty(E2_CODBAR) )"

	End Case*/

	
	
	If cModPgto == "30"
	   
	   If cPort240 $ "001|237"                                        
	      _cFiltro := " SUBS(E2_CODBAR,1,3)=="+"'"+cPort240+"'"
	   Else   
	      _cFiltro := " !EMPTY(E2_CODBAR) "
	   EndIf                                                                                                 
	   
	   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
	   
	ElseIf cModPgto == "31"
	   
	   _cFiltro := " !EMPTY(E2_CODBAR)"
	   
	   If cPort240 $ "001|237"                                         
	      _cFiltro += " .AND. SUBS(E2_CODBAR,1,3)<>"+"'"+cPort240+"'"
	   EndIf
	
	   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
	
	ElseIf cModPgto == "01"
	   
	   _cFiltro := " Empty(E2_CODBAR)  .and. " 
	   _cFiltro += " E2_SALDO > 0.01 .and. EMPTY(E2_XAGOP) .and. "
	   //_cFiltro += "( (!Empty(E2_ZBCOFAV) .AND. E2_ZBCOFAV == '" + cPort240 + "' ) .OR. (!Empty(E2_FORBCO) .AND. E2_FORBCO == '" + cPort240 + "' )    )"
	   //_cFiltro += "( ( !Empty( E2_ZBCOFAV ) .AND. E2_ZBCOFAV == '" + cPort240 + "' ) .OR. Empty( E2_ZBCOFAV ) )"
	  // _cFiltro += "( ( !Empty( E2_ZBCOFAV ) .AND. E2_ZBCOFAV == '" + cPort240 + "' ) .OR. Empty( E2_ZBCOFAV )  ) .and. (!Empty(E2_FORBCO) .AND. E2_FORBCO == '" + cPort240 + "' )" - Alterado conforme Erick
	   _cFiltro +=   "( ( !Empty( E2_ZBCOFAV ) .AND. E2_ZBCOFAV == '" + cPort240 + "' )  .OR. (!Empty(E2_FORBCO) .AND. E2_FORBCO == '" + cPort240 + "' .and. Empty( E2_ZBCOFAV ))) "
	   			
	ElseIf cModPgto $ "03" 
		
	   _cFiltro := " Empty(E2_CODBAR) .and. "// .and. "
	   _cFiltro += " E2_SALDO > 0.01 .and. EMPTY(E2_XAGOP) .and. "
	   
		If cPort240 == '001'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '001' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '001' )    ) .and. "
		ElseIf cPort240 == '237'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '237' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '237' )    ) .and. " 
		EndIf	   
	   
//	   _cFiltro += " .and. (" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,1),1,8) + " )" 
	   If !Empty(SE2->E2_ZCODFAV)
	   	_cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_ZCODFAV + SE2->E2_ZLOJFAV,1),1,8) + " )"
	   Else 
	   	_cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,1),1,8) + " )"
	   Endif
	    
	ElseIf cModPgto == "41"
	   
	   _cFiltro := " Empty(E2_CODBAR) .and. "// .and. "
	   _cFiltro += " E2_SALDO > 0.01 .and. EMPTY(E2_XAGOP) .and. "
	   
		If cPort240 == '001'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '001' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '001' )    ) .and. "
		ElseIf cPort240 == '237'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '237' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '237' )    ) .and. " 
		EndIf	   
	   
//	   _cFiltro += " .and. (" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,1),1,8) + " )" 
	   If !Empty(SE2->E2_ZCODFAV)
	   	_cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_ZCODFAV + SE2->E2_ZLOJFAV,1),1,8) + " )"
	   Else 
	   	_cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " <> " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,1),1,8) + " )"
	   Endif
	
	ElseIf cModPgto == "43"

	   _cFiltro := " Empty(E2_CODBAR) .and. "// .and. "
	   _cFiltro += " E2_SALDO > 0.01 .and. EMPTY(E2_XAGOP) .and. "
	   
		If cPort240 == '001'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '001' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '001' )    ) .and. " 
		ElseIf cPort240 == '237'
			_cFiltro += "( (!(Empty(E2_ZBCOFAV)) .AND. E2_ZBCOFAV <> '237' ) .OR. (!(Empty(E2_FORBCO)) .AND. E2_FORBCO <> '237' )    ) .and. " 
		EndIf	   
	   
//	   _cFiltro += " .and. ( '" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + "' == " + " SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + E2_FORNECE + E2_LOJA,1),1,8) " + " )" 
//	   If !Empty(SE2->E2_ZCODFAV)
//	   _cFiltro += " .and. ( SubStr(RetField('SM0',1,cEmpAnt + cFilant,'M0_CGC'),1,8) ==  SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + E2_ZCODFAV + E2_ZLOJFAV,1),1,8))"
//	   Else 
//	   _cFiltro += " .and. ( SubStr(RetField('SM0',1,cEmpAnt + cFilant,'M0_CGC'),1,8) ==  SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + E2_FORNECE + E2_LOJA,1),1,8))" 
//	   Endif
	   If !Empty(SE2->E2_ZCODFAV)
	   _cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " == " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_ZCODFAV + SE2->E2_ZLOJFAV,1),1,8) + " )"
	   Else 
	   _cFiltro += "(" + SubStr(RetField("SM0",1,cEmpAnt + cFilant,"M0_CGC"),1,8) + " == " + SubStr(GetAdvFval('SA2','A2_CGC',xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,1),1,8) + " )"
	   Endif

	ElseIf cModPgto == "10"  //--- Ordem de pagamento
		
//	   _cFiltro := " IIF(!EMPTY(E2_XAGOP),E2_XAGOP,IIF(!EMPTY(E2_ZAGEFAV),STRZERO(VAL(E2_ZAGEFAV),5),STRZERO(VAL(E2_FORAGE),5)))"
	   _cFiltro := " !EMPTY(E2_XAGOP) "
		
	ElseIf cModPgto $ "11"  //--- Concessionarias e tributos com Codigo de Barra
	
	   _cFiltro := " !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
	
	ElseIf cModPgto == "16"  //--- Darf Normal - Selecionar com codigo de retencao e tipo TX             
	
	   _cFiltro := " ( !Empty(E2_CODRET) ) .AND. (E2_TIPO == 'TX ' .OR. E2_TIPO == 'FOL')"
	
	ElseIf cModPgto == "17"  //--- GPS  

		_cFiltro := " (E2_TIPO == 'FOL') .OR. (E2_TIPO == 'INS') .OR. (E2_TIPO == 'FT ')"
		_cFiltro += " .AND."
		_cFiltro += " ( !Empty(E2_RETINS) .OR. !Empty(E2_CODINS) )"
	EndIf

	cRet := _cFiltro

	ParSav01 := mv_par01
	ParSav02 := mv_par02
	ParSav03 := mv_par03
	ParSav04 := mv_par04
	ParSav05 := mv_par05
	ParSav06 := mv_par06
	ParSav07 := mv_par07
	ParSav08 := mv_par08
	
	AAdd(aParamBox, {1, "Fornecedor de"		, Space(tamSx3("A2_COD")[1]) 				, "@!"							, , "SA2" 	,	, 070	, .F.	})
	AAdd(aParamBox, {1, "Fornecedor ate"	, Replicate("Z",tamSx3("A2_COD")[1])		, "@!"							, , "SA2" 	,	, 070	, .F.	})
	AAdd(aParamBox, {1, "Valor de"			, 0											, PesqPict("SE2","E2_VALOR")	, , ""	 	,	, 070	, .F.	})
	AAdd(aParamBox, {1, "Valor ate"			, 9999999999999.99							, PesqPict("SE2","E2_VALOR")	, , "" 		,	, 070	, .F.	})
	AAdd(aParamBox, {1, "Nome"				, Space(tamSx3("A2_NOME")[1])      			, "@!"							, , ""   	,	, 100	, .F.	})
	AAdd(aParamBox, {1, "Natureza de"		, Space(tamSx3("E2_NATUREZ")[1]) 			, PesqPict("SE2","E2_NATUREZ")	, , "SED" 	,	, 070	, .F.	})
	AAdd(aParamBox, {1, "Natureza ate"		, Replicate("Z",tamSx3("E2_NATUREZ")[1])	, PesqPict("SE2","E2_NATUREZ")	, , "SED" 	,	, 070	, .F.	})
	
	If IsInCallStack("Fin750241") .Or. FunName() == "FINA241"
		
		mv_par08	:= cNumBor	:= Space(Len(SE2->E2_ZBORD))

		aAdd(aParamBox,{1,"Numero do Bordero",cNumBor,"","","","",50,.F.})

	EndIf
	
	If ParamBox(aParambox, "Filtro Adicional", @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .T. /*lUserSave*/) 
		cFilAux := " ((E2_FORNECE >= '"+mv_par01+"' .and. E2_FORNECE <= '"+mv_par02+"' .and. E2_VALOR >= "+Alltrim(Str(mv_par03,18,2))+" .and. E2_VALOR <= "+Alltrim(Str(mv_par04,18,2))+IIf(Empty(mv_par05),")"," .and. '"+Upper(Alltrim(mv_par05))+"' $ Alltrim(E2_NOMFOR)) ")
		cFilAux += " .and. (E2_NATUREZ >= '" + mv_par06 + "' .and. E2_NATUREZ <= '" + mv_par07 + "' ) )"

		If IsInCallStack("Fin750241") .Or. FunName() == "FINA241"

			If !Empty(mv_par08) // aRet[8])
					cFilAux += " .And. E2_ZBORD == '"+mv_par08+"' "
			EndIf

		EndIf
		
		//cRet := cRet+IIf(Empty(cRet),cFilAux," .and. "+cFilAux)
		if Empty(cRet)
			cRet := ""
			cRet := cFilAux
		else
			cRet := cRet + " .and. " + cFilAux
		endif
	Endif

	mv_par01 := ParSav01
	mv_par02 := ParSav02
	mv_par03 := ParSav03
	mv_par04 := ParSav04
	mv_par05 := ParSav05
	mv_par06 := ParSav06
	mv_par07 := ParSav07
	mv_par08 := ParSav08
		
Return cRet