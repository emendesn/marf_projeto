#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
#INCLUDE 'PROTHEUS.CH'

/*
{Protheus.doc} MGFFINBJ 
@description 
	RTASK0010896 Desenvolvido opção para que seja possível enviar relação por e-mail aos usuários pre selecionaos.
	Rotina similar aos relatórios do BI - MGF06R09. 
	Foi solicitado para criar uma cópia exata da tela TGRIDEL()-MGF06R09 por exigência nas premissas do projeto. 
@author Henrique Vidal Santos
@Type Tela de relatório
@since 23/02/2020
@version P12.1.017
*/
User Function MGFFINBJ()

	Local aLinha		:={}
	Local _nI			:= ""
	Local _nAlinhamento
	Local oDlgMain
	Local _cBanco		:= Alltrim(Upper(TCGetDb()))

	Public _nArqName		:= 0
	Public _aArqName		:= {}
	
	Private oBrowse
	Private aRotina		:= MenuDef()
	Private cCadastro	:= _aDefinePl[1]
	Private aSeek := {}, aFieFilter := {}

	If Select(_cTmp01) > 0
		dbSelectArea(_cTmp01)
		dbCloseArea()
	EndIf

	aStruTRB	:= {}
	For _nI := 1 to len(_aCampoQry)
		aAdd(aStruTRB,{ _aCampoQry[_nI,_nPoApeli] ,;	// Nome do Campo
						_aCampoQry[_nI,_nPoTipo],;		// Tipo
						_aCampoQry[_nI,_nPoTaman],;		// tamanho
						_aCampoQry[_nI,_nPoDecim]})		// Nº de decimais
	Next
	aAdd(aStruTRB,{ 	"X" ,;	// Nome do Campo
						"C" ,;	// Tipo
						1   ,;	// tamanho
						0   })	// Nº de decimais

	__LocalDriver	:= __LocalDriver + ""	

	cNomeArq:=CriaTrab( aStruTRB,.T. )
	
	dbUseArea(.T.,__LocalDriver,cNomeArq          ,_cTmp01 ,.T. ,.F.)
	MsAguarde({|| SqlToTrb(_cQuery, aStruTRB, _cTmp01 )},"Criando a tabela com os dados da Query", "Criando a tabela com os dados da Query",.T. )  //MSAguarde( bAcao, cTitulo ,cMensagem, lAbortar)	Obs. lAborta =.T. habilita o botão
	cIndice1 := Alltrim(CriaTrab(,.F.))

	If File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	EndIf

	dbSelectArea(_cTmp01)
	DbGoTop()

	If !eof()
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100,.T.,.T. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		DEFINE MSDIALOG oDlgMain TITLE _aDefinePl[1] FROM aSize[7], aSize[8] TO aSize[6],aSize[5]-10 OF oMainWnd PIXEL 
	
		oDlgMain:lEscClose :=.T.		
		
		oBrowse := FWMBrowse():New()
		oBrowse:setdatatable()     		
		oBrowse:SetAlias( _cTmp01 )

		oBrowse:SetDescription( cCadastro )
		oBrowse:setSeek(,aSeek)
		oBrowse:setOwner(oDlgMain)

		For _nI	:= 1 to len(_aCampoQry)
			If _aCampoQry[_ni, _nPoTipo] == "D"	
					_nAlinhamento := 0		
			ElseIf _aCampoQry[_ni, _nPoTipo] == "N"	
				_nAlinhamento := 2			
			Else
					_nAlinhamento := 1			
			Endif
			
			oBrowse:SetColumns(MontaColun  (_aCampoQry[_ni, _nPoApeli] ,_aCampoQry[_ni, _nPoTitul] ,_nI ,_aCampoQry[_ni, _nPoPictu] ,_nAlinhamento ,_aCampoQry[_ni ,_nPoTaman] ,_aCampoQry[_ni, _nPoDecim] ))

    	Next _nI	

		oBrowse:DisableDetails()
		oBrowse:Refresh( .T. ) 		
		oBrowse:Activate()
		oDlgMain:Activate(	,,,.F.	,,.T.	,, )
			
    Else
		MsgStop(" Não existem dados para os parametros informados" )
	Endif

	If !Empty(cNomeArq)
		Ferase(cNomeArq+GetDBExtension())
		Ferase(cNomeArq+OrdBagExt())
		cNomeArq := ""
		(_cTmp01)->(DbCloseArea())
		delTabTmp(_cTmp01)
		dbClearAll()
	Endif		

Return

Static Function MontaColun(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData 	:= {||}
	Local cTipoDado	:= "C"
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0
	
	If nArrData > 0
		If nAlign == 0	

			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")			// Usar esta linha, se TRB for CTREE
			cTipoDado	:= "D"

		ElseIf nAlign == 2		
			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
			cTipoDado	:= "N"
			
		Else
			bData := &("{|| " + cCampo +" }") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
			cTipoDado	:= "C"

		Endif
	EndIf

	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
	
Return {aColumn}


Static Function MenuDef()
	Local aArea		:= GetArea()
	Local aRotina 	:= {}

	AADD(aRotina, {"Gera Planilha"	, "U_GeraPlan"		, 0, 3, 0, .F. })
	AADD(aRotina, {"Enviar e-mail"	, "U_MGFFINBL"		, 0, 3, 0, .F. })
	
	RestArea(aArea)
Return( aRotina )
