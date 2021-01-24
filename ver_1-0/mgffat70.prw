#Include "Protheus.ch"
#Include "TopConn.ch"

//
//
//
//
/*/{Protheus.doc} MGFFAT70
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFAT70()

	Local aArea := {GetArea()}
	Local cCposGetd := "C6_ITEM,C6_PRODUTO,C6_OPER,C6_TES,C6_CF,C6_CLASFIS"
	Local aCposGetd := {"C6_OPER","C6_TES","C6_CF","C6_CLASFIS"}
	Local aPosObj := {}
	Local aObjects := {}
	Local aSize := {}
	Local aPosGet := {}
	Local aInfo := {}
	Local lContinua:= .T.
	Local nOpcA := 0
	Local nUsado := 0
	Local nCntFor := 0
	Local oDlg
	Local lInclui := .F.
	Local lVisual := .F.
	Local lAltera := .F.
	Local cQ := ""
	Local nOpc := 0
	Local aHeadSav := IIf(Type("aHeader")<>"U",aClone(aHeader),Nil)
	Local aColsSav := IIf(Type("aCols")<>"U",aClone(aCols),Nil)
	Local nNSav := IIf(Type("n")<>"U",n,Nil)
	Local cCampo	:= ""
	Local oCombo	:= Nil
	Local nMaxLin	:= 0

	Private cCli, cLoja, cDesc

	Private aHeader := {}
	Private aCols := {}
	Private n := 1
	Private oGetD


	If SC5->C5_TIPO <> "N"
		lContinua := .F.

		APMsgStop(	"Não é Pedido de Venda!"+Chr(13)+Chr(10)+ "Não será possível a alteração.")
	ElseIf "S" <> GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")
		lContinua := .F.

		APMsgStop(	"Não é Pedido de Venda Taura!"+Chr(13)+Chr(10)+ "Não será possível a alteração.")
		
		
		
		


	ElseIf !Empty(SC5->C5_NOTA) .Or.  SC5->C5_LIBEROK=="E" .And.  Empty(SC5->C5_BLQ)
		lContinua := .F.

		APMsgStop(	"Pedido já encerrado!"+Chr(13)+Chr(10)+ "Não será possível a alteração.")
	Endif

	If lContinua

		SC6->( dbSetOrder(1) )

		cCli	:= SC5->C5_CLIENTE
		cLoja	:= SC5->C5_LOJACLI
		cDesc	:= Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_NOME")

		cQ := "SELECT R_E_C_N_O_ SC6RECNO "
		cQ += "FROM "+RetSqlName("SC6")+ " SC6 "
		cQ += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
		cQ += "AND SC6.D_E_L_E_T_ = ' ' "
		cQ += "AND C6_NUM = '"+SC5->C5_NUM+"' "
		cQ += "ORDER BY C6_NUM, C6_ITEM, C6_PRODUTO "

		cQ := ChangeQuery(cQ)
		dbUseArea( .T. ,"TOPCONN",TCGenQry(,,cQ),"_TRA", .F. , .T. )

		If !Eof()
			lAltera := .T.
			nOpc := 4

			ALTERA	:= .T.
			INCLUI	:= .F.
			EXCLUI	:= .F.

		EndIf




		RegToMemory("SC5", .F. , .F. )

		If M->C5_TIPOCLI == "X"
			aItens	:= { "X=Exportacao" }
		Else
			aItens	:= { "F=Cons.Final" , "L=Prod.Rural" , "R=Revendedor" , "S=Solidario " , "X=Exportacao" }
		EndIf

		aItensFret	:= {"C=CIF","F=FOB"}




		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6")
		While (!Eof() .And.  (SX3->X3_ARQUIVO == "SC6"))
			If (X3Uso(SX3->X3_USADO) .and.  cNivel >= SX3->X3_NIVEL .and.  AllTrim(SX3->X3_CAMPO) $ cCposGetd)
				nUsado++









				Aadd(aHeader,{TRIM(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo




		dbSelectArea("_TRA")
		dbGotop()

		If lAltera .or.  lVisual

			dbSelectArea("_TRA")

			While !Eof()
				nMaxLin++
				SC6->( dbGoTo( _TRA->SC6RECNO ) )
				aadd(aCols,Array(nUsado+1))

				For nCntFor	:= 1 To nUsado

					If Alltrim(aHeader[nCntFor,2]) == "C6_ITEM"
						aCols[Len(aCols)][nCntFor] := SC6->C6_ITEM
					ElseIf Alltrim(aHeader[nCntFor,2]) == "C6_PRODUTO"
						aCols[Len(aCols)][nCntFor] := SC6->C6_PRODUTO
					ElseIf Alltrim(aHeader[nCntFor,2]) == "C6_OPER"
						aCols[Len(aCols)][nCntFor] := CriaVar("C6_OPER")
					ElseIf Alltrim(aHeader[nCntFor,2]) == "C6_TES"
						aCols[Len(aCols)][nCntFor] := SC6->C6_TES
					ElseIf Alltrim(aHeader[nCntFor,2]) == "C6_CF"
						aCols[Len(aCols)][nCntFor] := SC6->C6_CF
					ElseIf Alltrim(aHeader[nCntFor,2]) == "C6_CLASFIS"
						aCols[Len(aCols)][nCntFor] := SC6->C6_CLASFIS
					EndIf












				next

				aCols[Len(aCols)][Len(aHeader)+1] := .F.

				dbSkip()
			Enddo

		Endif

		_TRA->(dbCloseArea())




		If (Len(aCols) == 0)

			Iif(FindFunction("APMsgInfo"), APMsgInfo("Não foi encontrado nenhum item.", "Atenção"), MsgInfo("Não foi encontrado nenhum item.", "Atenção"))
			lContinua := .F.
		EndIf

		If ( lContinua )



			aSize := MsAdvSize()
			aObjects := {}

			AAdd( aObjects, {100,30, .T. , .F. })
			AAdd( aObjects, {100,100, .T. , .T. })

			aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
			aPosObj := MsObjSize(aInfo,aObjects)

			aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{05,20,35,042,055,063},{05,20,65,080,120,130,155,175}})

			oDlg = MsDialog():New( aSize[7], 0, aSize[6], aSize[5], cCadastro,,,.F.,,,,, oMainWnd,.T.,, ,.F. )

			TGroup():New( aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4], "", oDlg,,,.T., )
			TSay():New( 037, aPosGet[1,01],{||  OemToAnsi("Cliente: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 030, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			TGet():New( 037, aPosGet[1,02], { | u | If( PCount() == 0, cCli, cCli := u ) },oDlg, 030, 006, PesqPict("SA2","A2_COD"),,,,,.F.,,.T.,,.F.,{||  .F. },.F.,.F.,,.F.,.F. ,,"cCli",,,, )
			TSay():New( 037, aPosGet[1,03],{||  OemToAnsi("Loja : ")},oDlg,,,.F.,.F.,.F.,.T.,,, 030, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			TGet():New( 037, aPosGet[1,04], { | u | If( PCount() == 0, cLoja, cLoja := u ) },oDlg, 015, 006, PesqPict("SA2","A2_LOJA"),,,,,.F.,,.T.,,.F.,{||  .F. },.F.,.F.,,.F.,.F. ,,"cLoja",,,, )
			TSay():New( 037, aPosGet[1,05],{||  OemToAnsi("Nome: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 030, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			TGet():New( 037, aPosGet[1,06], { | u | If( PCount() == 0, cDesc, cDesc := u ) },oDlg, 200, 006,,,,,,.F.,,.T.,,.F.,{||  .F. },.F.,.F.,,.F.,.F. ,,"cDesc",,,, )

			TSay():New( 050, aPosGet[2,01],{||  OemToAnsi("Tipo Cliente: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 040, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			oCombo := TComboBox():New( 050, aPosGet[2,02], { | u | If( PCount() == 0, M->C5_TIPOCLI, M->C5_TIPOCLI := u ) }, aItens, 080, 10, oDlg,,,,,,.T.,,,.F.,,.F.,,, ,"M->C5_TIPOCLI" )
			TSay():New( 050, aPosGet[2,03],{||  OemToAnsi("Tipo Frete: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 030, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			oCombo := TComboBox():New( 050, aPosGet[2,04], { | u | If( PCount() == 0, M->C5_TPFRETE, M->C5_TPFRETE := u ) }, aItensFret, 080, 10, oDlg,,,{||  Pertence("CTFS")},,,.T.,,,.F.,,.F.,,, ,"M->C5_TPFRETE" )

			TSay():New( 050, aPosGet[2,05],{||  OemToAnsi("Carreta: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 030, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			TGet():New( 050, aPosGet[2,06], { | u | If( PCount() == 0, M->C5_PLACA2, M->C5_PLACA2 := u ) },oDlg, 030, 006, PesqPict("SC5","C5_PLACA2"),,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,,"M->C5_PLACA2",,,, )

			TSay():New( 050, aPosGet[2,07],{||  OemToAnsi("Truck/Cavalo: ")},oDlg,,,.F.,.F.,.F.,.T.,,, 040, 006,.F.,.F.,.F.,.F.,.F.,.F. )
			TGet():New( 050, aPosGet[2,08], { | u | If( PCount() == 0, M->C5_PLACA1, M->C5_PLACA1 := u ) },oDlg, 030, 006, PesqPict("SC5","C5_PLACA1"),,,,,.F.,,.T.,,.F.,{||  .T. },.F.,.F.,,.F.,.F. ,,"M->C5_PLACA1",,,, )

			oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_FAT70LOk","U_FAT70TOk",, .F. ,aCposGetd,, .T. ,nMaxLin,)
























			oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,,,,{|Self|EnchoiceBar(oDlg,{||If(oGetd:TudoOk(),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||oDlg:End()},,)}, oDlg:bRClicked, )
		EndIf

		If nOpcA == 1

			Processa({||U_FAT70Grava(cCli,cLoja, .F. )},"Aguarde, gravando dados ...")
		Endif
	Endif

	If Type("aHeadSav")<>"U"
		aHeader := aClone(aHeadSav)
	Endif
	If Type("aColsSav")<>"U"
		aCols := aClone(aColsSav)
	Endif
	If Type("nNSav")<>"U"
		n := nNSav
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return()


User Function FAT70LOk()

	Local lRet	:= .T.
	Local x		:= 0

	Local nPIteVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
	Local nPPrdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPTesVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	Local nPCFOVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
	Local nPSitVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})

	If Empty(aCols[n][nPTesVen]) .Or.  Empty(aCols[n][nPCFOVen]) .Or.  Empty(aCols[n][nPSitVen])

		ApMsgAlert("Informe os campos obrigatórios: "+Chr(13)+Chr(10)+ "Tipo Saida / Cód. Fiscal / Sit. Tribut.","Alerta")
		lRet := .F.
	ElseIf Len(AllTrim(aCols[n][nPSitVen])) <> TamSX3("C6_CLASFIS")[1]

		ApMsgAlert("Informação inválida: "+Chr(13)+Chr(10)+ "Sit. Tribut.","Alerta")
		lRet := .F.
	Else
		If SC6->( C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO ) <> SC5->( C5_FILIAL + C5_NUM ) + aCols[n][nPIteVen] + aCols[n][nPPrdVen]
			If !SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM )  + aCols[n][nPIteVen] + aCols[n][nPPrdVen] ) )
				ApMsgAlert(	"Item original do pedido não localizado!","Alerta")
				lRet := .F.
			EndIf
		EndIf
		If lRet



			If	GetAdvFVal("SF4","F4_DUPLIC",xFilial("SF4")+SC6->C6_TES,1,"") <> GetAdvFVal("SF4","F4_DUPLIC",xFilial("SF4")+aCols[n][nPTesVen],1,"") .Or.  GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SC6->C6_TES,1,"") <> GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aCols[n][nPTesVen],1,"")

				ApMsgAlert(	"Tipo Saida inválido!"+Chr(13)+Chr(10)+ "Configuração finenceira e de estoque devem ser as mesmas que a origem.","Alerta")
				lRet := .F.
			EndIf
		EndIf
	Endif

Return(lRet)


User Function FAT70TOk()

	Local lRet := .T.
	Local x := 0
	Local y := 0

	Local nPIteVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
	Local nPPrdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPTesVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	Local nPCFOVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
	Local nPSitVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})

	For x := 1 To Len(aCols)
		If Empty(aCols[x][nPTesVen]) .Or.  Empty(aCols[x][nPCFOVen]) .Or.  Empty(aCols[x][nPSitVen])

			ApMsgAlert("Informe os campos obrigatórios: "+Chr(13)+Chr(10)+ "Tipo Saida / Cód. Fiscal / Sit. Tribut.","Alerta")
			lRet := .F.
		ElseIf Len(AllTrim(aCols[x][nPSitVen])) <> TamSX3("C6_CLASFIS")[1]

			ApMsgAlert("Informação inválida: "+Chr(13)+Chr(10)+ "Sit. Tribut.","Alerta")
			lRet := .F.
		Else
			If SC6->( C6_FILIAL + C6_NUM + C6_ITEM  + C6_PRODUTO ) <> SC5->( C5_FILIAL + C5_NUM ) + aCols[x][nPIteVen] + aCols[x][nPPrdVen]
				If !SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM )  + aCols[x][nPIteVen] + aCols[x][nPPrdVen] ) )
					ApMsgAlert(	"Item original do pedido não localizado!","Alerta")
					lRet := .F.
				EndIf
			EndIf
			If SC6->C6_TES <> aCols[x][nPTesVen] .And.  lRet



				If	GetAdvFVal("SF4","F4_DUPLIC",xFilial("SF4")+SC6->C6_TES,1,"") <> GetAdvFVal("SF4","F4_DUPLIC",xFilial("SF4")+aCols[x][nPTesVen],1,"") .Or.  GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SC6->C6_TES,1,"") <> GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aCols[x][nPTesVen],1,"")

					ApMsgAlert(	"Tipo Saida inválido!"+Chr(13)+Chr(10)+ "Configuração finenceira e de estoque devem ser as mesmas que a origem.","Alerta")
					lRet := .F.
				EndIf
			EndIf
		Endif
	next

Return(lRet)


User Function FAT70Grava(cCli,cLoja,lSoExclui)

	Local aArea := {GetArea()}
	Local x := 0

	Local nPIteVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
	Local nPPrdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPTesVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	Local nPCFOVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
	Local nPSitVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})

	Begin Sequence; BeginTran()

	If M->C5_TIPOCLI <> SC5->C5_TIPOCLI .Or.  M->C5_TPFRETE <> SC5->C5_TPFRETE .Or.  M->C5_PLACA1 <> SC5->C5_PLACA1 .Or.  M->C5_PLACA2 <> SC5->C5_PLACA2


		RecLock("SC5", .F. )
		SC5->C5_TIPOCLI	:= M->C5_TIPOCLI
		SC5->C5_TPFRETE	:= M->C5_TPFRETE
		SC5->C5_PLACA1	:= M->C5_PLACA1
		SC5->C5_PLACA2	:= M->C5_PLACA2
		SC5->( msUnlock() )

	EndIf

	For x := 1 To Len(aCols)
		If SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM   + aCols[x][nPIteVen] + aCols[x][nPPrdVen] ) ) )
			If SC6->C6_TES <> aCols[x][nPTesVen] .Or.  SC6->C6_CF <> aCols[x][nPCFOVen] .Or.  SC6->C6_CLASFIS <> aCols[x][nPSitVen]


				RecLock("SC6", .F. )
				SC6->C6_TES		:= aCols[x][nPTesVen]
				SC6->C6_CF		:= aCols[x][nPCFOVen]
				SC6->C6_CLASFIS := aCols[x][nPSitVen]
				SC6->( msUnlock() )

				If !Empty(SC5->C5_PEDEXP)
					cQ := "SELECT R_E_C_N_O_ EE8RECNO "
					cQ += "FROM "+RetSqlName("EE8")+ " EE8 "
					cQ += "WHERE EE8.D_E_L_E_T_ = ' ' "
					cQ += "AND EE8_FILIAL = '"+xFilial("EE8")+"' "
					cQ += "AND EE8_PEDIDO = '"+SC5->C5_PEDEXP+"' "
					cQ += "AND EE8_FATIT = '"+SC6->C6_ITEM+"'  "
					cQ += "AND EE8_COD_I = '"+SC6->C6_PRODUTO+"'  "

					cQ := ChangeQuery(cQ)
					dbUseArea( .T. ,"TOPCONN",TCGenQry(,,cQ),"_EE8", .F. , .T. )

					If !Eof()
						EE8->( dbGoto( _EE8->EE8RECNO ) )



						RecLock("EE8", .F. )
						EE8->EE8_TES	:= aCols[x][nPTesVen]
						EE8->EE8_CF		:= aCols[x][nPCFOVen]
						EE8->( msUnlock() )

					EndIf

					_EE8->( dbCloseArea() )

				EndIf
			EndIf
		EndIf
	next

	EndTran(); end

	aEval(aArea,{|x| RestArea(x)})

Return()
