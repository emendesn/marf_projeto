#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

User Function MATA061(oModel)

	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local aSelFil		:= {}
	Local aSelOpc       := {}
	Local cCodFil		:= cFilAnt
	Local _cStatus      := ' '
	
	Local _aRet	:= {}, _aParambox	:= {}, _bParameRe

	Local nLinha     := 0
	Local nQtdLinhas := 0
     
	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		lIsGrid    := ( Len( aParam ) > 3 )
    	
		If cIdPonto == "MODELCOMMITNTTS"
			
			If SB1->B1_TIPO == "EM"  //EMBALAGEM

				MsgInfo("O produto é de embalagem e precisa ser informada as filiais para integração no controle de embalagens.","MATA061_PE")

				While .T.
					_aSelFil := AdmGetFil()
					If Len(_aSelFil) == 0
						Loop
					Else
						Exit
					EndIf
				EndDo

				_cCodFilia	:= U_Array_In(_aSelFil)
				_cProduto := SB1->B1_COD
				Processa({|| _cGravaZG9(_cProduto,_aSelFil) },"Aguarde!!! Integrando registros no controle de embalagens...",,.T.)

			EndIf
		
		EndIf

/*
ZG9	RTASK0011129 - Cadastro de Insumos x Fornecedor - Cabeçalho
ZGA	RATSK0011129 - Cadastro de Insumos x Fornecedor - Itens
*/
	EndIf

Return xRet


Static Function _cGravaZg9(_cProduto,_aSelFil)

	Local lRet 	:= .T.
	Local cwf  	:= ""
	Local Nx 	:= 0
	Local cAliasSA5 := GetNextAlias()

	//Query de pesquisa SA5
	If Select("QRYSA5") > 0
    	QRYSA5->(DbClosearea())
    EndIf
	cQuery := " "
	cQuery := " Select A5_PRODUTO,A5_NOMPROD,A5_FORNECE,A5_LOJA,A5_NOMEFOR"
	cQuery += " From " + RetSqlName("SA5")+" TSA5"
	cQuery += " Where "
	cquery += "	TSA5.A5_PRODUTO = '"+_cProduto+"' And "
	cQuery += " TSA5.D_E_L_E_T_<>'*' "
	cquery += " Order By 1,3,4"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSA5",.T.,.F.)
	dbSelectArea("QRYSA5")
	Count To nRegSa5
	QRYSA5->(dbGoTop())

	nContTot  := Len(_aSelFil) * nRegSa5

	ProcRegua( nContTot )

	While QRYSA5->(!Eof())
	
		_cChave :=	QRYSA5->(A5_PRODUTO+A5_FORNECE+A5_LOJA)
		_cMun	:=	POSICIONE("SA2",1,XFILIAL("SA2")+QRYSA5->(A5_FORNECE+A5_LOJA),"A2_MUN")
		_cUf 	:=	POSICIONE("SA2",1,XFILIAL("SA2")+QRYSA5->(A5_FORNECE+A5_LOJA),"A2_EST")
		ZG9->(DbSetOrder(1))
		
		If ! ZG9->(DbSeek(xFilial("ZG9")+_cChave))
			ZG9->(RecLock("ZG9",.T.) )
			ZG9->ZG9_FILIAL 	:= xFilial("ZG9")
			ZG9->ZG9_CODPRO		:= 	QRYSA5->A5_PRODUTO
			ZG9->ZG9_DESCRI		:= 	QRYSA5->A5_NOMPROD
			ZG9->ZG9_FORNEC		:=	QRYSA5->A5_FORNECE
			ZG9->ZG9_LOJA		:=	QRYSA5->A5_LOJA
			ZG9->ZG9_NOMFOR		:=	QRYSA5->A5_NOMEFOR
			ZG9->ZG9_MUN		:=	_cMun
			ZG9->ZG9_UF 		:=	_cUf
			ZG9->(MsUnlock())			
		EndIf
		For nX := 1 To Len(_aSelFil)

			IncProc("Inserindo dados da filial : " +_aSelFil[nX] )
			
			_cFilial := _aSelFil[nX]
			_cChaveZGA := _cChave+_cFilial
			ZGA->(DbSetOrder(1))
			If ! ZGA->(DbSeek(xFilial("ZGA")+_cChaveZGA))
				ZGA->(RecLock("ZGA",.T.) )
				ZGA->ZGA_FILIAL := xFilial("ZGA")
				ZGA->ZGA_CODPRO		:= 	QRYSA5->A5_PRODUTO
				ZGA->ZGA_FORNEC		:=	QRYSA5->A5_FORNECE
				ZGA->ZGA_LOJA		:=	QRYSA5->A5_LOJA
				ZGA->ZGA_ITEFIL		:=	_cFilial
				ZGA->ZGA_FILNOM		:=  U_wNomFilial(_cFilial)
				ZGA->(MsUnlock())
			Endif

		Next

		QRYSA5->(DBSKIP())

	EndDo

Return

User Function wNomFilial(_cFilial)
Local _cNomefil	:= ' '
DbSelectArea( "SM0" )
nRegSM0 := SM0->(Recno())
SM0->(DbGoTop())
While ! SM0->(Eof())
	If SM0->M0_CODFIL = _cFilial
		_cNomeFil := SM0->M0_FILIAL
	EndIf
	SM0->(DBSKIP())
EndDo
SM0->(DbGoto(nRegSM0))	
Return _cNomeFil