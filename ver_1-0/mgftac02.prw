#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "APWEBEX.CH"
#Include "APWEBSRV.CH"

/*/{Protheus.doc} MGFTAC02
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param aParam, array, descricao
@type function
/*/
User Function MGFTAC02(aParam)




	U_TAC02({"01", "010001"})


Return()


User Function TAC02(aParam)


	RpcSetType(3)
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif










	U_TAC02FilTran()








Return()



User Function TAC02EnvTran(aParam)

	Local aArea := {SA4->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTTR"))










	Local cTransp := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local lRet := .F.
	Local nCnt := 0

	Local cChave := ""
	Local nRet := 0
	Local cQ := ""

	Private oTran := Nil
	Private oWSTran := Nil





	SA4->(dbGoto(aParam[3]))
	If SA4->(Recno()) == aParam[3]
		cChave := cTransp
		If cStatus == "3"


			If !SA4->A4_ZTAUFLA $ "1/2" .and.  SA4->A4_ZTAUINT == "S"
				aEval(aArea,{|x| RestArea(x)})
				Return(lRet)
			Endif
		Endif

		oTran := Nil
		oTran := GravarTransportadora():New()
		oTran:CarregaCampos(cStatus)

		oWSTran := MGFINT53():New(cURLPost,oTran,SA4->(Recno()),,,AllTrim(GetMv("MGF_MONI01")),AllTrim(GetMv("MGF_MONT02")),cChave, .F. ,, .T. )

		StaticCall(MGFTAC01,ForcaIsBlind,oWSTran)

		cQ := "UPDATE "
		cQ += RetSqlName("SA4")+" "
		cQ += "SET "
		If oWSTran:lOk .And.  oWSTran:nStatus == 1
			cQ += "A4_ZTAUFLA = '1', "
			cQ += "A4_ZTAUINT = 'S' "
		Else
			cQ += "A4_ZTAUFLA = '2', "
			cQ += "A4_ZTAUVEZ = A4_ZTAUVEZ+1 "
		Endif
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SA4->(Recno())))

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de transportadora, para envio ao Taura.")
			Return()
		EndIf














































	Endif

	aEval(aArea,{|x| RestArea(x)})

	Return(lRet)
	
	
Class GravarTransportadora

	Data Acao AS String
	Data Status AS String
	Data Natureza AS String
	Data Pais AS String
	Data NomeReduzido AS String
	Data Nome AS String
	Data Nacionalidade AS String
	Data Cnpj AS String
	Data IE AS String
	Data Cep AS String
	Data Estado AS String
	Data Bairro AS String
	Data Cidade AS String
	Data Complemento AS String
	Data Logradouro AS String
	Data Numero AS String
	Data Telefone AS String
	Data Email AS String
	Data CodERP AS String
	Data DDD AS String
	Data DDI AS String
	Data TipoTelefone AS String
	Data NumeroExportacao AS String
	Data ApplicationArea AS ApplicationArea

	Method New()
	Method CarregaCampos()

EndClass


Method New() Class GravarTransportadora

	Self:ApplicationArea := ApplicationArea():New()

Return


Method CarregaCampos( cStatus ) Class GravarTransportadora

	Local cStringTime 	:= "T00:00:00"
	Local cNumero 		:= ""

	Self:Acao       	:= cStatus
	Self:Status 	 	:= IIf(SA4->A4_MSBLQL == "1","0","1")
	Self:Natureza 		:= IIf(SA4->A4_ZPESSOA == "J","PESSOA JURIDICA","PESSOA FISICA")
	Self:NomeReduzido 	:= Alltrim(SA4->A4_NREDUZ)
	Self:Nome 			:= Alltrim(SA4->A4_NOME)
	Self:Nacionalidade	:= Alltrim(SA4->A4_ZNASCIO)
	Self:IE 			:= Alltrim(SA4->A4_INSEST)
	Self:Cep 			:= Alltrim(SA4->A4_CEP)
	Self:Estado 		:= Alltrim(SA4->A4_EST)
	Self:Bairro 		:= Alltrim(SA4->A4_BAIRRO)
	Self:Cidade 		:= StaticCall(MGFTAC01,PesqCidade,SA4->A4_COD_MUN,SA4->A4_EST)
	Self:Complemento 	:= Alltrim(SA4->A4_COMPLEM)
	Self:Logradouro 	:= Alltrim(Subs(SA4->A4_END,1,IIf(At(",",SA4->A4_END)>0,At(",",SA4->A4_END)-1,Len(SA4->A4_END))))
	cNumero 			:= StaticCall(MGFTAC01,TAC01EndNum,SA4->A4_END,"A4_END")
	Self:Numero 		:= Alltrim(cNumero)
	Self:Telefone 		:= Alltrim(SA4->A4_TEL)
	Self:Email 			:= Alltrim(SA4->A4_EMAIL)
	Self:DDD 			:= Alltrim(SA4->A4_DDD)
	Self:DDI 			:= Alltrim(SA4->A4_DDI)
	Self:TipoTelefone 	:= "COMERCIAL"
	Self:Pais 			:= Alltrim(SA4->A4_ZPAIS)
	Self:CodERP 		:= Alltrim(IIf(!Empty(SA4->A4_ZCODMGF),SA4->A4_ZCODMGF,SA4->A4_COD))


	IF SA4->A4_ZPAIS <> "BR"
		Self:NumeroExportacao  := Alltrim(IIf(!Empty(SA4->A4_ZCODMGF),SA4->A4_ZCODMGF,SA4->A4_COD))
		Self:Cnpj 				:= ""
	ElSE
		Self:Cnpj 				:= Alltrim(SA4->A4_CGC)
		Self:NumeroExportacao  := ""
	EndIF

Return()









User Function TAC02FilTran()

	Local cQ := ""
	Local cEmpSav:= cEmpAnt
	Local cFilSav := cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local nCnt := 0
	Local lRet := .F.
	Local nRet := 0
	Local cIDTaura := GetMV("MGF_IDTCTR", .F. ,)
	Local nOper := 0
	Local nOperNew := 0







	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTCTR'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTCTR",cIDtaura)


	cQ := "UPDATE "
	cQ += RetSqlName("SA4")+" "
	cQ += "SET A4_ZTAUID = '"+cIDTaura+"' "

	cQ += "WHERE (A4_ZTAUFLA = ' ' "
	cQ += "OR A4_ZTAUREE = 'S' "
	cQ += "OR A4_ZTAUFLA = '2') "
	cQ += "AND A4_ZTAUSEM <> 'S' "

	cQ += "AND NOT (D_E_L_E_T_ = '*' "
	cQ += "AND A4_ZTAUINT = ' ') "
	cQ += "AND A4_ZTAUVEZ <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de transportadora, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT SA4.R_E_C_N_O_ SA4_RECNO,A4_FILIAL,A4_COD,A4_ZTAUFLA,A4_MSBLQL,A4_ZTAUINT,SA4.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("SA4")+" SA4 "
	cQ += "WHERE "

	cQ += "A4_ZTAUID = '"+cIDTaura+"' "


	cQ := ChangeQuery(cQ)
	dbUseArea( .T. ,"TOPCONN",tcGenQry(,,cQ),cAliasTrb, .T. , .T. )

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->A4_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->A4_FILIAL,1,6)

		Begin Sequence; BeginTran()







		nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->A4_ZTAUINT),1,2))
		nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->A4_ZTAUFLA,IIf((cAliasTrb)->A4_MSBLQL=="1", .T. , .F. ),(cAliasTrb)->A4_ZTAUINT)
		If !Empty(nOperNew)
			lRet := U_TAC02EnvTran({(cAliasTrb)->A4_COD,nOperNew,(cAliasTrb)->SA4_RECNO})
		Endif
		SA4->(dbGoto((cAliasTrb)->SA4_RECNO))
		If SA4->(Recno()) == (cAliasTrb)->SA4_RECNO








			If SA4->A4_ZTAUFLA <> "2"
				cQ := "UPDATE "
				cQ += RetSqlName("SA4")+" "
				cQ += "SET "
				cQ += "A4_ZTAUREE = ' ' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SA4->(Recno())))

				nRet := tcSqlExec(cQ)
				If nRet == 0
				Else
					ConOut("Problemas na gravação dos campos do cadastro de transportadora, para envio ao Taura.")
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



User Function TAC02M050TOK()

	Local aArea := {SX3->(GetArea()),SXA->(GetArea()),GetArea()}
	Local lRet := .T.
	Local aCampos := {"A4_ZPESSOA","A4_ZPAIS","A4_NREDUZ","A4_ZNASCIO","A4_CGC","A4_INSEST","A4_CEP","A4_EST","A4_COD_MUN","A4_BAIRRO","A4_END","A4_TEL","A4_EMAIL"}
	Local bBlock := {|x| IIf((lRet .and.  Empty(&("M->"+x))),(lRet:= .F. ,SX3->(dbSeek(x)),SXA->(dbSeek("SA4"+SX3->X3_FOLDER)),APMsgStop("Campo obrigatório para o envio ao Taura não informado, campo: '"+Alltrim(X3Titulo())+"'"+IIf(SXA->(Found()),", aba: '"+Alltrim(SXA->XA_DESCRIC)+"' ",IIf(SXA->(dbSeek("SA4")),", aba: 'Outros'","")))),Nil)}
	Local nCnt := 0


	If !Inclui
		lRet := U_TAC02VldMnt({M->A4_COD})
	Endif











	aEval(aArea,{|x| RestArea(x)})

Return(lRet)



User Function TAC02MA050TTS()

	Local lTauEnvia := GetMv("MGF_TAUTRA",, .F. )
	Local lTauJob := GetMv("MGF_TAUJTR",, .F. )
	Local nOper := 0

	nOper := U_TOperEnvia(IIf(Inclui,1,IIf(Altera,2,3)),SA4->A4_ZTAUFLA,IIf(SA4->A4_MSBLQL=="1", .T. , .F. ),SA4->A4_ZTAUINT)
	If !Empty(nOper)
		If lTauEnvia .or.  (!Inclui .and.  !Altera .and.  SA4->A4_ZTAUINT == "S")
			U_TauraEnvia(IIf((!Inclui .and.  !Altera), .F. ,lTauJob),"xTAC02EnvTran",{SA4->A4_COD,nOper,SA4->(Recno())}, .F. )
		Else
			SA4->(RecLock("SA4", .F. ))
			SA4->A4_ZTAUREE := "S"
			SA4->A4_ZTAUVEZ := 0
			SA4->(MsUnLock())
		Endif
	Else
		SA4->(RecLock("SA4", .F. ))
		SA4->A4_ZTAUVEZ := 0
		SA4->(MsUnLock())
	Endif

Return()




User Function xTAC02EnvTran(aParam,lJob,cEmp,cFil)

	Local nVezes := 100
	Local nCnt := 0
	Local lRet := .F.
	Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
	Local lStart := .F.

	lJob := If( lJob == nil, .F. , lJob )

	If lJob
		RpcSetType(3)
		lStart := RpcSetEnv(cEmp,cFil,,,,,{"SA4"},,, .T. )
		If !lStart
			Return(lRet)
		Else


			SA4->(dbGoto(aParam[3]))
			If SA4->(Recno()) <> aParam[3]
				Return(lRet)
			Endif
		Endif
	Endif

	For nCnt:=1 To nVezes
		If !Empty(SA4->A4_ZTAUSEM)
			Loop
		Else
			Exit
		Endif
	Next

	If Empty(SA4->A4_ZTAUSEM)

		Begin Sequence; BeginTran()




		lRet := U_TAC02EnvTran({aParam[1],aParam[2],aParam[3]})




		EndTran(); end

	Else
		SA4->(RecLock("SA4", .F. ))
		SA4->A4_ZTAUREE := "S"
		SA4->A4_ZTAUVEZ := 0
		SA4->(MsUnLock())
	Endif

	If lJob
		RpcClearEnv()
	Endif

Return(lRet)



User Function TAC02VldMnt(aParam)

	Local aArea := {SA4->(GetArea()),GetArea()}
	Local cTransp := aParam[1]
	Local lRet := .T.

	If SA4->A4_COD <> cTransp
		SA4->(dbSetOrder(1))
		SA4->(dbSeek(xFilial("SA4")+cTransp))
		If SA4->(!Found())
			lRet := .F.
			APMsgStop("Transportadora não encontrada.")
		Endif
	Endif

	If lRet
		If SA4->A4_ZTAUSEM == "S"
			lRet := .F.
			APMsgAlert("Transportadora não poderá sofrer manutenção agora, pois está sendo enviada para o Taura. Aguarde o envio.")
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)
