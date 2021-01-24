//
//
//
User Function ZMATA120()

	Local aRotAuto	:= {}
	Local cNumPC    := ""
	Local nSaveSX8 := GetSX8Len()


	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
















	cNumPC := CriaVar("C7_NUM", .T. )
	While ( GetSX8Len() > nSaveSX8 )
		ConfirmSx8()
	EndDo
	If ( Empty(cNumPC) )
		cNumPC := GetSxeNum("SC7","C7_NUM")
	EndIf

	__aCabec := {}
	aAdd( __aCabec , {"C7_NUM"	    ,cNumPC		, Nil}	)
	aadd( __aCabec , {"C7_EMISSAO"	,dDataBase	, Nil}	)
	aadd( __aCabec , {"C7_FORNECE"	,"000002"	, Nil}	)
	aadd( __aCabec , {"C7_LOJA"     ,"01"		, Nil}	)
	aadd( __aCabec , {"C7_COND"     ,"001"		, Nil}	)
	aadd( __aCabec , {"C7_CONTATO"  ,"AUTO"		, Nil}	)
	aadd( __aCabec , {"C7_FILENT"   ,cFilAnt	, Nil}	)
	aAdd( __aCabec , {"C7_TPOP"     ,"F"		, Nil}	)


	__aItens :=	{}

	aadd( __aItens ,{"C7_PRODUTO"  	,"761692"			,Nil})
	aadd( __aItens ,{"C7_QUANT"		,20					,Nil})
	aadd( __aItens ,{"C7_PRECO"		,0.0001				,Nil})
	aadd( __aItens ,{"C7_TOTAL"		,0.02				,Nil})
	aadd( __aItens ,{"C7_TES"		,"001"				,Nil})
	aAdd( __aItens ,{"C7_CC"		,"2207"				,Nil})
	aAdd( __aItens ,{"C7_NUMSC"     ,"000109"  			,Nil})
	aAdd( __aItens ,{"C7_ITEMSC" 	,"0001"  			,Nil})

	__aItens	:= { __aItens }








	MsExecAuto({|x,y,z,w| Mata120(x,y,z,w)},2,__aCabec,__aItens,3)



	If lMsErroAuto
		MostraErro()
	EndIf

Return
