#Include "RwMake.ch"
#Include "Protheus.ch"

//
//
//
//
//
//
//
//
//
/*/{Protheus.doc} MGFFIN10
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFIN10()
	Local aCores      := {{'SZQ->ZQ_BLOQUEI == "N"',"BR_VERDE"},{'SZQ->ZQ_BLOQUEI == "S"',"BR_VERMELHO"}}
	Local cString     := "SZQ"
	Private cCadastro := "Manutencao Cadastro de Rede de Clientes"






	Private aRotina   := {{"Procurar","AxPesqui",0,1}, {"Visualisar","AxVisual",0,2}, {"Incluir","AxInclui",0,3}, {"Alterar","AxAltera",0,4}, {"Excluir","AxDeleta",0,5}, {"Atrelar","U_Atrelar()",0,6}, {"Legenda","U_LegRede()",0,2,0, .F. }}
	dbSelectArea("SZQ")
	dbSetOrder(1)
	SZQ->(dbGoTop())
	MBrowse(6,1,22,75,cString,,,,,,aCores)
Return()












User Function LegRede()
	Local aCor := {}
	Local cCadastro := "Legenda"
	Local cTitle

	aAdd(aCor, {"BR_VERDE",		"Liberado" })
	aAdd(aCor, {"BR_VERMELHO",	"Bloqueado"})

	BrwLegenda(cCadastro, "Legenda", aCor)
Return()












User Function Atrelar()
	Local aArea      := GetArea()

	Local cQuery     := ""
	Local cAliasQry  := ""

	Local nOpca      := 0
	Local nLoop      := 0
	Local nX

	Local lProcessa  := .F.
	Local oOk        := LoadBitmap( GetResources(), "LBOK" )
	Local oNOk       := LoadBitmap( GetResources(), "LBNO" )

	Local oBold
	Local oBmp
	Local oBut1

	Local lTodos     := .F.
	Local cFilCtr    := cFilAnt

	Local oSize 	 := FwDefSize():New()

	Local cGet1		:= Space(40)
	Local oSay1
	Local oWBrowse1
	Local oFont
	Local aFilter	:= {}
	Local aPosFilter:= {}
	Local oButton1
	Local aDadosLoc	:= {}
	Local aHeader	:= {}
	Local aDados	:= {}
	Local cFields	:= ""
	Private oDlg

	Private _aListBox := {}
	Private _cCodRede := ""
	Private _cTeste   := Space(06)
	Private oDlgGet

	_cCodRede := SZQ->ZQ_COD

	DbSelectArea("SA1")
	DbSetOrder(1)

	cAliasQry := GetNextAlias()
	cQuery := "SELECT A1_FILIAL, A1_COD, A1_NOME, A1_CGC, A1_ZREDE " +Chr(10)
	cQuery += "  FROM "+RetSqlName("SA1")+" A1 " +Chr(10)
	cQuery += " WHERE " +Chr(10)
	cQuery += "   A1.A1_ZREDE = '      ' OR A1.A1_ZREDE = '" + _cCodRede + "'"+Chr(10)
	cQuery += "   AND A1.D_E_L_E_T_=' ' " +Chr(10)
	cQuery += "   ORDER BY A1_COD " +Chr(10)

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T. , "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F. , .T.  )






	cFields		:= "'','Cod Rede','Codigo','Clien','CNPJ'"
	aHeader		:= StrToKarr(cFields , ",")
	nLen		:= Len(aHeader)
	If len(_aListBox)=0
		While !( cAliasQry )->( Eof() )
			AADD(aDados ,Array(nLen))
			AAdd( _aListBox, Array(5))
			Atail(_aListBox)[1] := If( Empty((cAliasQRY)->A1_ZREDE), .F. , .F. )
			Atail(_aListBox)[5] := ( cAliasQRY )->A1_ZREDE
			Atail(_aListBox)[2]  := ( cAliasQRY )->A1_COD
			Atail(_aListBox)[3]    := ( cAliasQRY )->A1_NOME
			Atail(_aListBox)[4]    := ( cAliasQRY )->A1_CGC
			( cAliasQry )->( dbSkip() )
		EndDo
	Endif

	( cAliasQRY )->( dbCloseArea() )




	oDlg = MsDialog():New( 0, 0, 282, 552, "REDES",,,.F.,,,,, oDlg,.T.,, ,.F. )
	oBold := TFont():New( "Arial", 0, -13,.F.,.T.,,,,,,,,,,, )

	oList := TWBrowse():New(20, 10, 275, 108 ,,{"","Cod Rede","Codigo","Cliente", "CNPJ"},,oDlg,,,,,,,,,,,, .F. ,, .T. ,, .F. ,,,)
	oList:SetArray(_aListBox)





	oList:bLine := { || { If(  _aListBox[oList:nAT,1]= .T. , oOk, oNOK ), _aListBox[oList:nAT,5] , _aListBox[oList:nAt,2]  , _aListBox[oList:nAT,3]    , _aListBox[oList:nAT,4]} }
	oList:bLDblClick := { || CLI001MkCron()}

	oSay1 := TSay():New( 004, 020,{||  "Informe o nome"},oDlg,, oFont,.F.,.F.,.F.,.T., 0, 16777215, 090, 007,.F.,.F.,.F.,.F.,.F.,.F. )
	oGet1 := TGet():New( 004, 085, { | u | If( PCount() == 0, cGet1, cGet1 := u ) },oDlg, 40, 10,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet1",,,, )
	oButton1 := TButton():New( 004, 195, "Pesquisar", oDlg,{||  Filtracl(@cGet1,@_aListBox,@aFilter,oDlg,oWBrowse1,@aPosFilter)}, 030, 015,,,.F.,.T.,.F.,,.F.,,,.F. )

	oTodos := TCheckBox():New( 130, 025, "Marcar Todos",{ | u | If( PCount() == 0, lTodos, lTodos := u ) }, oDlg, 060, 015,,{|| MarcDesm(lTodos)},,,,,.F.,.T.,,.F., )
	TButton():New( 130, 165, "Confirmar", oDlg, {||Atrelcl(_cCodRede)}, 35, 11,,,.F.,.T.,.F.,,.F.,,,.F. )


	oBut2 := SButton():New( 130, 220,2,{||  (nOpca:=0,oDlg:End())}, oDlg,.T.,,)

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

	RestArea( aArea )

Return( .T.  )

















Static Function CLI001MkCron()

	Local nX         := 0
	Local lRetVCK    := .T.

	IF _aListBox[oList:nAT, 1]== .T.
		_aListBox[oList:nAT, 1]:= .F.
	Else
		_aListBox[oList:nAT, 1]:= .T.
	Endif

Return()















Static Function MarcDesm( lTodos )

	Local nX := 0

	For nX := 1 to Len(_aListBox)
		If lTodos
			_aListBox[nX,1] := .T.
		Else
			_aListBox[nX,1] := .F.
		EndIf
	next

	oList:Refresh()

Return Nil





Static Function Filtracl(cGet1 , _aList , aFilter , oDlg , oWBrowse1 , aPosFilter)
	Local nW			:= 0
	Local nLen			:= 0
	Local nPosDesc		:= 0
	Local aFilterBkp	:= {}

	nPosDesc	:= 3

	aFilter	:= {}

	nLen		:= Len(_aListBox)

	For nW := 1 TO nLen



		If ( Upper(AllTrim(cGet1)) $ Upper(AllTrim(_aListBox[nW , nPosDesc])))

			AADD(aFilter , aClone(_aListBox[nW]))
			AADD(aPosFilter , nW)

		EndIf

	Next

	If ( Len(aFilter) )

		fWBrowse1(NIL , @aFilter , oDlg , @oWBrowse1 , .T. )

	Else

		fWBrowse1(NIL , _aListBox , oDlg , @oWBrowse1 , .T. )

	EndIf

	cGet1	:= Space(40)

Return()


Static Function fWBrowse1(aHeader , _aList , oDlg, oWBrowse1 , lAtuDados)

	Local aBrowse 	:= {}
	Local nX		:= 0
	Local nY		:= 0
	Local nPosArray	:= 0
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")

	aBrowse	:= aClone(_aList)

	If !( lAtuDados )









		oWBrowse1 := TWBrowse():New( 020, 007, 610, 150,,{ aHeader[++nPosArray],			aHeader[++nPosArray],			aHeader[++nPosArray],			aHeader[++nPosArray],			aHeader[++nPosArray],},{ 10,30,130,80}, oDlg, ,,,,,,,,,,,.F.,,.T.,,.F.,,, )

		oWBrowse1:SetArray(aBrowse)







		oWBrowse1:bLine := {|| { If(aBrowse[oWBrowse1:nAt,01],oOK,oNO), aBrowse[oWBrowse1:nAt,02], aBrowse[oWBrowse1:nAt,03], aBrowse[oWBrowse1:nAt,04], aBrowse[oWBrowse1:nAt,05], }}


		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1], oWBrowse1:DrawSelect()}

	Else

		oList:SetArray(aBrowse)







		oList:bLine := {|| { If(aBrowse[oList:nAt,01],oOK,oNO), aBrowse[oList:nAt,02], aBrowse[oList:nAt,03], aBrowse[oList:nAt,04], aBrowse[oList:nAt,05], }}


		oList:bLDblClick := {|| aBrowse[oList:nAt,1] := !aBrowse[oList:nAt,1], oList:DrawSelect()}

		oList:Refresh()

	EndIf

Return





Static Function Atrelcl(_cCodRede)
	Local nY

	For nY := 1 to Len(_aListBox)
		DbSelectArea("SA1")
		DbSetOrder(1)
		IF (DbSeek(xFilial("SA1")+_aListBox[nY,2])) .AND.  _aListBox[nY,1] = .T.
			RecLock("SA1", .F. )
			SA1->A1_ZREDE := _cCodRede
			MsUnlock()
		ENDIF
	next
	oDlg:End()
Return()
