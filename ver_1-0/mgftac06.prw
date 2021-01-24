#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#Include "APWEBSRV.CH"
#Include "FWMVCDEF.CH"
#Include "FWMBROWSE.CH"

/*/{Protheus.doc} MGFTAC06
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param aParam, array, descricao
@type function
/*/
User Function MGFTAC06(aParam)




	U_TAC06({"01", "010001"})


Return()


User Function TAC06(aParam)


	RpcSetType(3)
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif










	U_TAC06MotFil()
	U_TAC06AjuFil()







Return()



User Function TAC06EnvMot(aParam)

	Local aArea := {DA4->(GetArea()),DAU->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTMO"))










	Local cMot := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local cTipo := aParam[3]
	Local lRet := .F.
	Local nCnt := 0

	Local cChave := ""
	Local nRet := 0
	Local cQ := ""

	Private oMot := Nil
	Private oWSMot := Nil






	IIf(cTipo=="1",DA4->(dbGoto(aParam[4])),DAU->(dbGoto(aParam[4])))
	If IIf(cTipo=="1",DA4->(Recno()) == aParam[4],DAU->(Recno()) == aParam[4])
		cChave := cMot
		If cStatus == "3"


			If IIf(cTipo=="1",!DA4->DA4_ZTAUFL $ "1/2" .and.  DA4->DA4_ZTAUIN == "S" ,!DAU->DAU_ZTAUFL $ "1/2" .and.  DAU->DAU_ZTAUIN == "S" )
				aEval(aArea,{|x| RestArea(x)})
				Return(lRet)
			Endif
		Endif

		oMot := Nil
		oMot := GravarMotorista():New()
		oMot:CarregaCampos(cStatus,cTipo)

		oWSMot := MGFINT53():New(cURLPost,oMot,IIf(cTipo=="1",DA4->(Recno()),DAU->(Recno())),,,AllTrim(GetMv("MGF_MONI01")),AllTrim(GetMv("MGF_MONT04")),cChave, .F. , .F. , .T. )

		StaticCall(MGFTAC01,ForcaIsBlind,oWSMot)
		If cTipo == "1"
			cQ := "UPDATE "
			cQ += RetSqlName("DA4")+" "
			cQ += "SET "
			If oWSMot:lOk .And.  oWSMot:nStatus == 1
				cQ += "DA4_ZTAUFL = '1', "
				cQ += "DA4_ZTAUIN = 'S' "
			Else
				cQ += "DA4_ZTAUFL = '2', "
				cQ += "DA4_ZTAUVE = DA4_ZTAUVE+1 "
			Endif
			cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DA4->(Recno())))
		Else
			cQ := "UPDATE "
			cQ += RetSqlName("DAU")+" "
			cQ += "SET "
			If oWSMot:lOk .And.  oWSMot:nStatus == 1
				cQ += "DAU_ZTAUFL = '1', "
				cQ += "DAU_ZTAUIN = 'S' "
			Else
				cQ += "DAU_ZTAUFL = '2', "
				cQ += "DAU_ZTAUVE = DAU_ZTAUVE+1 "
			Endif
			cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DAU->(Recno())))
		Endif

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de motorista/ajudante, para envio ao Taura.")
			Return()
		EndIf































































	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Class GravarMotorista

	Data Acao AS String
	Data Tipo AS String
	Data Bairro AS String
	Data Cep AS String
	Data Cidade AS String
	Data Complemento AS String
	Data UF AS String
	Data Endereco AS String
	Data Numero AS String
	Data Nome AS String
	Data Nacionalidade AS String
	Data Pais AS String
	Data Cpf AS String
	Data RG AS String
	Data DataNascimento AS String
	Data Celular AS String
	Data Telefone AS String
	Data Email AS String
	Data DataValidadeCNH AS String
	Data CNH AS String
	Data Ativo AS String
	Data CodERP AS String
	Data ApplicationArea AS ApplicationArea
	Data TelefoneDDD AS String
	Data TelefoneDDI AS String
	Data CelularDDD AS String
	Data CelularDDI AS String
	Data TipoEndereco AS String
	Data NomeReduzido AS String

	Method New()
	Method CarregaCampos()

EndClass


Method New( ) Class GravarMotorista

	Self:ApplicationArea := ApplicationArea():New()

Return


Method CarregaCampos(cStatus,cTipo ) Class GravarMotorista

	Local cStringTime := "T00:00:00"
	Local cNumero := ""
	Local aCBox := {}
	Local nPos := 0

	Self:Acao := cStatus
	Self:Tipo := cTipo
	Self:Bairro := Alltrim(IIf(cTipo=="1",DA4->DA4_BAIRRO,DAU->DAU_BAIRRO))
	Self:Cep := Alltrim(IIf(cTipo=="1",DA4->DA4_CEP,DAU->DAU_CEP))
	Self:Cidade := Alltrim(IIf(cTipo=="1",StaticCall(MGFTAC01,PesqCidade,DA4->DA4_CODMUN,DA4->DA4_EST),StaticCall(MGFTAC01,PesqCidade,DAU->DAU_ZCODMU,DAU->DAU_EST)))
	Self:Complemento := Alltrim(IIf(cTipo=="1",DA4->DA4_ZCOMPL,DAU->DAU_ZCOMPL))
	Self:UF := Alltrim(IIf(cTipo=="1",DA4->DA4_EST,DAU->DAU_EST))
	Self:Endereco := Alltrim(IIf(cTipo=="1",Alltrim(Subs(DA4->DA4_END,1,IIf(At(",",DA4->DA4_END)>0,At(",",DA4->DA4_END)-1,Len(DA4->DA4_END)))),Alltrim(Subs(DAU->DAU_END,1,IIf(At(",",DAU->DAU_END)>0,At(",",DAU->DAU_END)-1,Len(DAU->DAU_END))))))
	cNumero := IIf(cTipo=="1",StaticCall(MGFTAC01,TAC01EndNum,DA4->DA4_END,"DA4_END"),StaticCall(MGFTAC01,TAC01EndNum,DAU->DAU_END,"DAU_END"))
	Self:Numero := Alltrim(cNumero)
	Self:Nome := Alltrim(IIf(cTipo=="1",DA4->DA4_NOME,DAU->DAU_NOME))
	Self:Nacionalidade	:= Alltrim(IIf(cTipo=="1",DA4->DA4_ZNASCI,DAU->DAU_ZNASCI))
	Self:Pais := Alltrim(IIf(cTipo=="1",DA4->DA4_ZPAIS,DAU->DAU_ZPAIS))
	Self:Cpf := StrZero(Val(IIf(cTipo=="1",DA4->DA4_CGC,DAU->DAU_CGC)),11)
	Self:RG := Alltrim(IIf(cTipo=="1",DA4->DA4_RG,DAU->DAU_ZRG))
	Self:DataNascimento := IIf(!Empty(IIf(cTipo=="1",DA4->DA4_DATNAS,DAU->DAU_ZDTNAS)),Subs(dTos(IIf(cTipo=="1",DA4->DA4_DATNAS,DAU->DAU_ZDTNAS)),1,4)+"-"+Subs(dTos(IIf(cTipo=="1",DA4->DA4_DATNAS,DAU->DAU_ZDTNAS)),5,2)+"-"+Subs(dTos(IIf(cTipo=="1",DA4->DA4_DATNAS,DAU->DAU_ZDTNAS)),7,2)+cStringTime,"")
	Self:Celular := Alltrim(IIf(cTipo=="1",DA4->DA4_ZTELCE,DAU->DAU_ZTELCE))
	Self:Telefone := Alltrim(IIf(cTipo=="1",DA4->DA4_TEL,DAU->DAU_TEL))
	Self:Email := Alltrim(IIf(cTipo=="1",DA4->DA4_ZEMAIL,DAU->DAU_ZEMAIL))
	Self:DataValidadeCNH := IIf(cTipo=="1",IIf(!Empty(DA4->DA4_DTVCNH),Subs(dTos(DA4->DA4_DTVCNH),1,4)+"-"+Subs(dTos(DA4->DA4_DTVCNH),5,2)+"-"+Subs(dTos(DA4->DA4_DTVCNH),7,2)+cStringTime,""),"")
	Self:CNH := Alltrim(IIf(cTipo=="1",DA4->DA4_NUMCNH,""))
	Self:Ativo := IIf(IIf(cTipo=="1",DA4->DA4_MSBLQL,DAU->DAU_MSBLQL) == "1","0","1")
	Self:CodERP := Alltrim(IIf(cTipo=="1",DA4->DA4_COD,DAU->DAU_COD))
	Self:TelefoneDDD := Alltrim(IIf(cTipo=="1",DA4->DA4_DDD,DAU->DAU_ZDDD))
	Self:TelefoneDDI := Alltrim(IIf(cTipo=="1",DA4->DA4_ZDDI,DAU->DAU_ZDDI))
	Self:CelularDDD := Alltrim(IIf(cTipo=="1",DA4->DA4_ZDDDCE,DAU->DAU_ZDDDCE))
	Self:CelularDDI := Alltrim(IIf(cTipo=="1",DA4->DA4_ZDDICE,DAU->DAU_ZDDICE))
	If cTipo == "1"
		aCBox := RetSX3Box(Posicione("SX3",2,"DA4_ZTPEND","X3CBox()"),,,1)
		Self:TipoEndereco := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(DA4->DA4_ZTPEND)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
	Elseif cTipo == "2"
		aCBox := RetSX3Box(Posicione("SX3",2,"DAU_ZTPEND","X3CBox()"),,,1)
		Self:TipoEndereco := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(DAU->DAU_ZTPEND)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
	Endif
	Self:NomeReduzido := Alltrim(IIf(cTipo=="1",DA4->DA4_NREDUZ,DAU->DAU_NREDUZ))

Return()









User Function TAC06MotFil()

	Local cQ := ""
	Local cEmpSav:= cEmpAnt
	Local cFilSav := cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local nCnt := 0
	Local lRet := .F.
	Local nRet := 0
	Local cIDTaura := GetMV("MGF_IDTCMO", .F. ,)
	Local nOper := 0
	Local nOperNew := 0







	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTCMO'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTCMO",cIDtaura)


	cQ := "UPDATE "
	cQ += RetSqlName("DA4")+" "
	cQ += "SET DA4_ZTAUID = '"+cIDTaura+"' "

	cQ += "WHERE (DA4_ZTAUFL = ' ' "
	cQ += "OR DA4_ZTAURE = 'S' "
	cQ += "OR DA4_ZTAUFL = '2') "
	cQ += "AND DA4_ZTAUSE <> 'S' "

	cQ += "AND NOT (D_E_L_E_T_ = '*' "
	cQ += "AND DA4_ZTAUIN = ' ') "
	cQ += "AND DA4_ZTAUVE <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de motorista, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT DA4.R_E_C_N_O_ DA4_RECNO,DA4_FILIAL,DA4_COD,DA4_ZTAUFL,DA4_MSBLQL,DA4_ZTAUIN,DA4.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("DA4")+" DA4 "
	cQ += "WHERE "

	cQ += "DA4_ZTAUID = '"+cIDTaura+"' "


	cQ := ChangeQuery(cQ)
	dbUseArea( .T. ,"TOPCONN",tcGenQry(,,cQ),cAliasTrb, .T. , .T. )

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->DA4_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->DA4_FILIAL,1,6)

		Begin Sequence; BeginTran()







		nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->DA4_ZTAUIN),1,2))
		nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->DA4_ZTAUFL,IIf((cAliasTrb)->DA4_MSBLQL=="1", .T. , .F. ),(cAliasTrb)->DA4_ZTAUIN)
		If !Empty(nOperNew)
			lRet := U_TAC06EnvMot({(cAliasTrb)->DA4_COD,nOperNew,"1",(cAliasTrb)->DA4_RECNO})
		Endif
		DA4->(dbGoto((cAliasTrb)->DA4_RECNO))
		If DA4->(Recno()) == (cAliasTrb)->DA4_RECNO








			If DA4->DA4_ZTAUFL <> "2"
				cQ := "UPDATE "
				cQ += RetSqlName("DA4")+" "
				cQ += "SET "
				cQ += "DA4_ZTAURE = ' ' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DA4->(Recno())))

				nRet := tcSqlExec(cQ)
				If nRet == 0
				Else
					ConOut("Problemas na gravação dos campos do cadastro de motorista, para envio ao Taura.")
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




User Function TAC06AjuFil()

	Local cQ := ""
	Local cEmpSav:= cEmpAnt
	Local cFilSav := cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local nCnt := 0
	Local lRet := .F.
	Local nRet := 0
	Local cIDTaura := GetMV("MGF_IDTCAJ", .F. ,)
	Local nOper := 0
	Local nOperNew := 0







	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTCAJ'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTCAJ",cIDtaura)


	cQ := "UPDATE "
	cQ += RetSqlName("DAU")+" "
	cQ += "SET DAU_ZTAUID = '"+cIDTaura+"' "

	cQ += "WHERE (DAU_ZTAUFL = ' ' "
	cQ += "OR DAU_ZTAURE = 'S' "
	cQ += "OR DAU_ZTAUFL = '2') "
	cQ += "AND DAU_ZTAUSE <> 'S' "

	cQ += "AND NOT (D_E_L_E_T_ = '*' "
	cQ += "AND DAU_ZTAUIN = ' ') "
	cQ += "AND DAU_ZTAUVE <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de ajudante, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT DAU.R_E_C_N_O_ DAU_RECNO,DAU_FILIAL,DAU_COD,DAU_ZTAUFL,DAU_MSBLQL,DAU_ZTAUIN,DAU.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("DAU")+" DAU "
	cQ += "WHERE "

	cQ += "DAU_ZTAUID = '"+cIDTaura+"' "


	cQ := ChangeQuery(cQ)
	dbUseArea( .T. ,"TOPCONN",tcGenQry(,,cQ),cAliasTrb, .T. , .T. )

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->DAU_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->DAU_FILIAL,1,6)

		Begin Sequence; BeginTran()







		nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->DAU_ZTAUIN),1,2))
		nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->DAU_ZTAUFL,IIf((cAliasTrb)->DAU_MSBLQL=="1", .T. , .F. ),(cAliasTrb)->DAU_ZTAUIN)
		If !Empty(nOperNew)
			lRet := U_TAC06EnvMot({(cAliasTrb)->DAU_COD,nOperNew,"2",(cAliasTrb)->DAU_RECNO})
		Endif
		DAU->(dbGoto((cAliasTrb)->DAU_RECNO))
		If DAU->(Recno()) == (cAliasTrb)->DAU_RECNO








			If DAU->DAU_ZTAUFL <> "2"
				cQ := "UPDATE "
				cQ += RetSqlName("DAU")+" "
				cQ += "SET "
				cQ += "DAU_ZTAURE = ' ' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DAU->(Recno())))

				nRet := tcSqlExec(cQ)
				If nRet == 0
				Else
					ConOut("Problemas na gravação dos campos do cadastro de ajudante, para envio ao Taura.")
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



User Function TAC06OTOK(cTipo,oObj)


	Local lRet := .T.
	Local aCampos := {}
	Local bBlock := Nil
	Local oMdl
	Local oStruct

	If cTipo == "1"
		aCampos := {"DA4_BAIRRO","DA4_CEP","DA4_CODMUN","DA4_EST","DA4_END","DA4_NOME","DA4_ZNASCI","DA4_ZPAIS","DA4_CGC","DA4_RG","DA4_DATNAS","DA4_ZTELCE","DA4_TEL","DA4_DTVCNH","DA4_NUMCNH"}

		oMdl := oObj:GetModel("OMSA040_DA4")
	Else
		aCampos := {"DAU_BAIRRO","DAU_CEP","DAU_ZCODMU","DAU_EST","DAU_END","DAU_NOME","DAU_ZNASCI","DAU_ZPAIS","DAU_CGC","DAU_ZRG","DAU_ZDTNAS","DAU_ZTELCE","DAU_TEL"}


		oMdl := oObj:GetModel("MdFieldDAU")
	Endif

	oStruct := oMdl:GetStruct()
	bBlock := {|x| oStruct:SetProperty(x,10, .T. )}
	aEval(aCampos,bBlock)



Return(lRet)



User Function TAC06GRV(cTipo,nOper)

	Local lTauEnvia := .F.
	Local lTauJob := .F.
	Local nOpc := IIf(nOper == 3,1,IIf(nOper == 4,2,IIf(nOper == 5,3,0)))

	If cTipo == "1"
		lTauEnvia := GetMv("MGF_TAUMOT",, .F. )
		lTauJob := GetMv("MGF_TAUJMO",, .F. )
		nOper := U_TOperEnvia(nOpc,DA4->DA4_ZTAUFL,IIf(DA4->DA4_MSBLQL=="1", .T. , .F. ),DA4->DA4_ZTAUIN)
		If !Empty(nOper)
			If lTauEnvia .or.  (nOpc == 3 .and.  DA4->DA4_ZTAUIN == "S")
				U_TauraEnvia(IIf(nOpc == 3, .F. ,lTauJob),"xTAC06EnvMot",{DA4->DA4_COD,nOper,cTipo,DA4->(Recno())}, .F. )
			Else
				DA4->(RecLock("DA4", .F. ))
				DA4->DA4_ZTAURE := "S"
				DA4->DA4_ZTAUVE := 0
				DA4->(MsUnLock())
			Endif
		Else
			DA4->(RecLock("DA4", .F. ))
			DA4->DA4_ZTAUVE := 0
			DA4->(MsUnLock())
		Endif
	Else
		lTauEnvia := GetMv("MGF_TAUAJU",, .F. )
		lTauJob := GetMv("MGF_TAUJAJ",, .F. )
		nOper := U_TOperEnvia(nOpc,DAU->DAU_ZTAUFL,IIf(DAU->DAU_MSBLQL=="1", .T. , .F. ),DAU->DAU_ZTAUIN)
		If !Empty(nOper)
			If lTauEnvia .or.  (nOpc == 3 .and.  DAU->DAU_ZTAUIN == "S")
				U_TauraEnvia(IIf(nOpc == 3, .F. ,lTauJob),"xTAC06EnvMot",{DAU->DAU_COD,nOper,cTipo,DAU->(Recno())}, .F. )
			Else
				DAU->(RecLock("DAU", .F. ))
				DAU->DAU_ZTAURE := "S"
				DAU->DAU_ZTAUVE := 0
				DAU->(MsUnLock())
			Endif
		Else
			DAU->(RecLock("DAU", .F. ))
			DAU->DAU_ZTAUVE := 0
			DAU->(MsUnLock())
		Endif
	Endif

Return()




User Function xTAC06EnvMot(aParam,lJob,cEmp,cFil)

	Local nVezes := 100
	Local nCnt := 0
	Local lRet := .F.
	Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
	Local lStart := .F.

	lJob := If( lJob == nil, .F. , lJob )

	If lJob
		RpcSetType(3)
		lStart := RpcSetEnv(cEmp,cFil,,,,,IIf(aParam[3]=="1",{"DA4"},{"DAU"}),,, .T. )
		If !lStart
			Return(lRet)
		Else
			If aParam[3] == "1"


				DA4->(dbGoto(aParam[4]))
				If DA4->(Recno()) <> aParam[4]
					Return(lRet)
				Endif
			Else


				DAU->(dbGoto(aParam[4]))
				If DAU->(Recno()) <> aParam[4]
					Return(lRet)
				Endif
			Endif
		Endif
	Endif

	For nCnt:=1 To nVezes
		If IIf(aParam[3]=="1",!Empty(DA4->DA4_ZTAUSE),!Empty(DAU->DAU_ZTAUSE))
			Loop
		Else
			Exit
		Endif
	Next

	If IIf(aParam[3]=="1",Empty(DA4->DA4_ZTAUSE),Empty(DAU->DAU_ZTAUSE))

		Begin Sequence; BeginTran()

		If aParam[3] == "1"



			lRet := U_TAC06EnvMot({aParam[1],aParam[2],aParam[3],aParam[4]})



		Else



			lRet := U_TAC06EnvMot({aParam[1],aParam[2],aParam[3],aParam[4]})



		Endif

		EndTran(); end

	Else
		If aParam[3] == "1"
			DA4->(RecLock("DA4", .F. ))
			DA4->DA4_ZTAURE := "S"
			DA4->DA4_ZTAUVE := 0
			DA4->(MsUnLock())
		Else
			DAU->(RecLock("DAU", .F. ))
			DAU->DAU_ZTAURE := "S"
			DAU->DAU_ZTAUVE := 0
			DAU->(MsUnLock())
		Endif
	Endif

	If lJob
		RpcClearEnv()
	Endif

Return(lRet)



User Function TAC06VldMnt(aParam)

	Local aArea := {DA4->(GetArea()),DAU->(GetArea()),GetArea()}
	Local cMot := aParam[2]
	Local lRet := .T.
	Local cTipo := aParam[1]

	If cTipo == "1"
		If DA4->DA4_COD <> cMot
			DA4->(dbSetOrder(1))
			DA4->(dbSeek(xFilial("DA4")+cMot))
			If DA4->(!Found())
				lRet := .F.
				Help( ,, "Help",, "Motorista não encontrado.", 1, 0 )
			Endif
		Endif

		If lRet
			If DA4->DA4_ZTAUSE == "S"
				lRet := .F.
				Help( ,, "Help",, "Motorista não poderá sofrer manutenção agora, pois está sendo enviada para o Taura. Aguarde o envio.", 1, 0 )
			Endif
		Endif
	Else
		If DAU->DAU_COD <> cMot
			DAU->(dbSetOrder(1))
			DAU->(dbSeek(xFilial("DAU")+cMot))
			If DAU->(!Found())
				lRet := .F.
				Help( ,, "Help",, "Ajudante não encontrado.", 1, 0 )
			Endif
		Endif

		If lRet
			If DAU->DAU_ZTAUSE == "S"
				lRet := .F.
				Help( ,, "Help",, "Ajudante não poderá sofrer manutenção agora, pois está sendo enviada para o Taura. Aguarde o envio.", 1, 0 )
			Endif
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)



User Function OMSA040_PE()

	Local aArea := {GetArea()}
	Local oObj := IIf(Type("ParamIxb[1]")<>"U",ParamIxb[1],Nil)
	Local cIdPonto := IIf(Type("ParamIxb[2]")<>"U",ParamIxb[2],"")
	Local cIdModel := IIf(Type("ParamIxb[3]")<>"U",ParamIxb[3],"")
	Local nOpcx := 0
	Local uRet := .T.

	If oObj == Nil .or.  Empty(cIdPonto)
		Return(uRet)
	Endif

	nOpcx := oObj:GetOperation()

	If cIdPonto == "MODELVLDACTIVE"
		If nOpcx == 4 .or.  nOpcx == 5
			uRet := U_TAC06VldMnt({"1",DA4->DA4_COD})
		Endif
		If uRet
			If nOpcx == 3 .or.  nOpcx == 4
				uRet := U_TAC06OTOK("1",oObj)
			Endif
		Endif
	ElseIf cIdPonto == "MODELPOS"
		If nOpcx == 5
			U_TAC06GRV("1",nOpcx)
		Endif
		
		IF findfunction("U_MGFINT38") .and. nOpcx == MODEL_OPERATION_DELETE
			IF U_MGF38_EXC('DA4','DA4') 
				uRet := .F.
				Help("",1,"Help",,'Pendência de grade',1,0,,,,,, {"Verifique pendência na Grade de Aprovação e tente novamente!"})
			EndIf
		EndIf
	ElseIf cIdPonto == "MODELCOMMITNTTS"
		If nOpcx == 3 .or.  nOpcx == 4
			U_TAC06GRV("1",nOpcx)
		Endif
		
		If FindFunction("U_MGFCOM88") .and. nOpcx == MODEL_OPERATION_DELETE
			U_MGFCOM88('DA4')
		Endif	
	EndIf

	aEval(aArea,{|x| RestArea(x)})

Return(uRet)



User Function OMSA050_PE()

	Local aArea := {GetArea()}
	Local oObj := IIf(Type("ParamIxb[1]")<>"U",ParamIxb[1],Nil)
	Local cIdPonto := IIf(Type("ParamIxb[2]")<>"U",ParamIxb[2],"")
	Local cIdModel := IIf(Type("ParamIxb[3]")<>"U",ParamIxb[3],"")
	Local nOpcx := 0
	Local uRet := .T.

	If oObj == Nil .or.  Empty(cIdPonto)
		Return(uRet)
	Endif

	nOpcx := oObj:GetOperation()

	If cIdPonto == "MODELVLDACTIVE"
		If nOpcx == 4 .or.  nOpcx == 5
			uRet := U_TAC06VldMnt({"2",DAU->DAU_COD})
		Endif
		If uRet
			If nOpcx == 3 .or.  nOpcx == 4
				uRet := U_TAC06OTOK("2",oObj)
			Endif
		Endif
	ElseIf cIdPonto == "MODELPOS"
		If nOpcx == 5
			U_TAC06GRV("2",nOpcx)
		Endif
	ElseIf cIdPonto == "MODELCOMMITNTTS"
		If nOpcx == 3 .or.  nOpcx == 4
			U_TAC06GRV("2",nOpcx)
		Endif
	EndIf

	aEval(aArea,{|x| RestArea(x)})

Return(uRet)
