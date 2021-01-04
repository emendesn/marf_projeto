#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"
#Include "ApWebex.ch"
#Include "APWEBSRV.ch"

/*/{Protheus.doc} MGFTAC05
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param aParam, array, descricao
@type function
/*/
User Function MGFTAC05(aParam)




	U_TAC05({"01", "010001"})


Return()


User Function TAC05(aParam)


	RpcSetType(3)
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif










	U_TAC05FilProd()







Return()



User Function TAC05EnvProd(aParam)

	Local aArea := {SB1->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTPR"))











	Local cProd := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local lRet := .F.
	Local nCnt := 0

	Local cChave := ""
	Local nRet := 0
	Local cQ := ""

	Private oProd      := Nil
	Private oWSProd    := Nil





	SB1->(dbGoto(aParam[3]))
	If SB1->(Recno()) == aParam[3]
		cChave := cProd
		If cStatus == "3"


			If !SB1->B1_ZTAUFLA $ "1/2" .and.  SB1->B1_ZTAUINT == "S"
				aEval(aArea,{|x| RestArea(x)})
				Return(lRet)
			Endif
		Endif

		oProd := Nil
		oProd := GravarProduto():New()
		oProd:CarregaCampos(cStatus)

		oWSProd := MGFINT53():New(cURLPost,oProd,SB1->(Recno()),,,AllTrim(GetMv("MGF_MONI01")),AllTrim(GetMv("MGF_MONT03")),cChave, .F. ,, .T. )

		StaticCall(MGFTAC01,ForcaIsBlind,oWSProd)
		cQ := "UPDATE "
		cQ += RetSqlName("SB1")+" "
		cQ += "SET "
		If oWSProd:lOk .And.  oWSProd:nStatus == 1
			cQ += "B1_ZTAUFLA = '1', "
			cQ += "B1_ZTAUINT = 'S' "
		Else
			cQ += "B1_ZTAUFLA = '2', "
			cQ += "B1_ZTAUVEZ = B1_ZTAUVEZ+1 "
		Endif
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SB1->(Recno())))

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de produto, para envio ao Taura.")
			Return()
		EndIf

		MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",oWSProd:CDETAILINT)













































	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Class GravarProduto

	Data cAcao AS String
	Data cIDProduto AS String
	Data cAtivo AS Integer
	Data cNome AS String
	Data cUnidadeMedida AS String
	Data cGrupodeProduto AS String
	Data cNcm AS String
	Data cNomeReduzido AS String
	Data cMercado AS String
	Data cMarca AS String
	Data cConservacao AS String
	Data cHabilitacaodeMercado AS String
	Data cCampoTexto AS String
	Data cCodigoEAN AS Integer
	Data Taura AS String
	Data ApplicationArea AS ApplicationArea

	Method New()
	Method CarregaCampos()

EndClass


Method New() Class GravarProduto

	Self:ApplicationArea := ApplicationArea():New()

Return


Method CarregaCampos(cStatus ) Class GravarProduto

	Local cStringTime := "T00:00:00"
	Local nPos := 0
	Local aCBox := {}

	Self:cAcao := cStatus
	Self:cIDProduto := Alltrim(SB1->B1_COD)
	Self:cAtivo := IIf(SB1->B1_MSBLQL == "1",0,1)
	Self:cNome := Alltrim(SB1->B1_DESC)
	Self:cUnidadeMedida := Alltrim(SB1->B1_UM)
	Self:cGrupodeProduto := "100"
	Self:cNcm := Alltrim(Transform(SB1->B1_POSIPI,PesqPict("SB1","B1_POSIPI")))
	Self:cNomeReduzido := Alltrim(Subs(SB1->B1_DESC,1,50))
	aCBox := RetSX3Box(Posicione("SX3",2,"B1_ZMERCAD","X3CBox()"),,,1)
	Self:cMercado := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SB1->B1_ZMERCAD)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
	Self:cMarca := Alltrim(Posicione("ZZU",1,xFilial("ZZU")+SB1->B1_ZMARCA,"ZZU_DESCRI"))
	aCBox := RetSX3Box(Posicione("SX3",2,"B1_ZCONSER","X3CBox()"),,,1)
	Self:cConservacao := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SB1->B1_ZCONSER)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")

	Self:cHabilitacaodeMercado := Alltrim(SB1->B1_ZCHABIL)
	Self:cCampoTexto := Alltrim(SB1->B1_ZOBS)
	Self:cCodigoEAN := IIf(Empty(SB1->B1_ZEAN13),0,SB1->B1_ZEAN13)
	Self:Taura := "S"

Return()









User Function TAC05FilProd()

	Local cQ := ""
	Local cEmpSav:= cEmpAnt
	Local cFilSav := cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local nCnt := 0
	Local lRet := .F.
	Local nRet := 0
	Local cIDTaura := GetMV("MGF_IDTCPR", .F. ,)
	Local nOper := 0
	Local nOperNew := 0

	Private cTipoTaura := Alltrim(GetMv("MGF_TPTAU"))







	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTCPR'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTCPR",cIDtaura)


	cQ := "UPDATE "
	cQ += RetSqlName("SB1")+" "
	cQ += "SET B1_ZTAUID = '"+cIDTaura+"' "

	cQ += "WHERE (B1_ZTAUFLA = ' ' "
	cQ += "OR B1_ZTAUREE = 'S' "
	cQ += "OR B1_ZTAUFLA = '2') "
	cQ += "AND B1_ZTAUSEM <> 'S' "

	cQ += "AND NOT (D_E_L_E_T_ = '*' "
	cQ += "AND B1_ZTAUINT = ' ') "

	cQ += "AND B1_TIPO IN ("+cTipoTaura+") "
	cQ += "AND B1_ZTAUVEZ <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de produto, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT SB1.R_E_C_N_O_ SB1_RECNO,B1_FILIAL,B1_COD,B1_ZTAUFLA,B1_MSBLQL,B1_ZTAUINT,SB1.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("SB1")+" SB1 "
	cQ += "WHERE "

	cQ += "B1_ZTAUID = '"+cIDTaura+"' "


	cQ := ChangeQuery(cQ)
	dbUseArea( .T. ,"TOPCONN",tcGenQry(,,cQ),cAliasTrb, .T. , .T. )

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->B1_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->B1_FILIAL,1,6)

		Begin Sequence; BeginTran()







		nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->B1_ZTAUINT),1,2))
		nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->B1_ZTAUFLA,IIf((cAliasTrb)->B1_MSBLQL=="1", .T. , .F. ),(cAliasTrb)->B1_ZTAUINT)
		If !Empty(nOperNew)
			lRet := U_TAC05EnvProd({(cAliasTrb)->B1_COD,nOperNew,(cAliasTrb)->SB1_RECNO})
		Endif
		SB1->(dbGoto((cAliasTrb)->SB1_RECNO))
		If SB1->(Recno()) == (cAliasTrb)->SB1_RECNO








			If SB1->B1_ZTAUFLA <> "2"
				cQ := "UPDATE "
				cQ += RetSqlName("SB1")+" "
				cQ += "SET "
				cQ += "B1_ZTAUREE = ' ' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SB1->(Recno())))

				nRet := tcSqlExec(cQ)
				If nRet == 0
				Else
					ConOut("Problemas na gravação dos campos do cadastro de produto, para envio ao Taura.")
					Return()
				EndIf
			Endif
		Endif

		EndTran(); end

		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea())

	cEmpAnt := cEmpSav
	cFilAnt := cFilSav

Return()



User Function TAC05A010TOK()

	Local aArea := {GetArea()}

	Local lRet := .T.


	Local nCnt := 0


	If IsInCallStack("A010Copia")
		M->B1_ZTAUFLA := CriaVar("B1_ZTAUFLA")
		M->B1_ZTAUID := CriaVar("B1_ZTAUID")
		M->B1_ZTAUREE := CriaVar("B1_ZTAUREE")
		M->B1_ZTAUSEM := CriaVar("B1_ZTAUSEM")
		M->B1_ZTAUINT := CriaVar("B1_ZTAUINT")
		M->B1_ZTAUVEZ := 0
	Endif

	If !Inclui

		lRet := U_TAC05VldMnt({M->B1_COD})
	Endif













	aEval(aArea,{|x| RestArea(x)})

Return(lRet)



User Function TAC05MT010INC()

	Local lTauEnvia := GetMv("MGF_TAUPRO",, .F. )
	Local lTauJob := GetMv("MGF_TAUJPR",, .F. )
	Local nOper := 0

	nOper := U_TOperEnvia(IIf(Inclui,1,IIf(Altera,2,0)),SB1->B1_ZTAUFLA,IIf(SB1->B1_MSBLQL=="1", .T. , .F. ),SB1->B1_ZTAUINT)
	If !Empty(nOper)
		If lTauEnvia
			U_TauraEnvia(lTauJob,"xTAC05EnvProd",{SB1->B1_COD,nOper,SB1->(Recno())}, .F. )
		Else
			SB1->(RecLock("SB1", .F. ))
			SB1->B1_ZTAUREE := "S"
			SB1->B1_ZTAUVEZ := 0
			SB1->(MsUnLock())
		Endif
	Else
		SB1->(RecLock("SB1", .F. ))
		SB1->B1_ZTAUVEZ := 0
		SB1->(MsUnLock())
	Endif

Return()



User Function TAC05EXCMT010()

	Local lTauEnvia := .T.
	Local lTauJob := .F.

	If lTauEnvia .and.  SB1->B1_ZTAUINT == "S"
		U_TauraEnvia(lTauJob,"xTAC05EnvProd",{SB1->B1_COD,3,SB1->(Recno())}, .F. )
	Endif

Return()




User Function xTAC05EnvProd(aParam,lJob,cEmp,cFil)

	Local nVezes := 100
	Local nCnt := 0
	Local lRet := .F.
	Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
	Local lStart := .F.

	lJob := If( lJob == nil, .F. , lJob )

	If lJob
		RpcSetType(3)
		lStart := RpcSetEnv(cEmp,cFil,,,,,{"SB1"},,, .T. )
		If !lStart
			Return(lRet)
		Else


			SB1->(dbGoto(aParam[3]))
			If SB1->(Recno()) <> aParam[3]
				Return(lRet)
			Endif
		Endif
	Endif

	For nCnt:=1 To nVezes
		If !Empty(SB1->B1_ZTAUSEM)
			Loop
		Else
			Exit
		Endif
	Next

	If Empty(SB1->B1_ZTAUSEM)

		Begin Sequence; BeginTran()




		lRet := U_TAC05EnvProd({aParam[1],aParam[2],aParam[3]})




		EndTran(); end

	Else
		SB1->(RecLock("SB1", .F. ))
		SB1->B1_ZTAUREE := "S"
		SB1->B1_ZTAUVEZ := 0
		SB1->(MsUnLock())
	Endif

	If lJob
		RpcClearEnv()
	Endif

Return(lRet)



User Function TAC05VldMnt(aParam)

	Local aArea := {SB1->(GetArea()),GetArea()}
	Local cProd := aParam[1]
	Local lRet := .T.

	If SB1->B1_COD <> cProd
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+cProd))
		If SB1->(!Found())
			lRet := .F.
			APMsgStop("Produto não encontrado.")
		Endif
	Endif

	If lRet
		If SB1->B1_ZTAUSEM == "S"
			lRet := .F.
			APMsgAlert("Produto não poderá sofrer manutenção agora, pois está sendo enviada para o Taura. Aguarde o envio.")
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)
