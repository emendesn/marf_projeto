#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFTAC08
Autor...............: Mauricio Gresele
Data................: 14/12/2016
Descricao / Objetivo: Integração Protheus-Taura, para envio do Cadastro de Veiculo
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MGFTAC08(aParam)

	//If IsBlind()
	//	StartJob( "U_TAC08", GetEnvServer(), .T., {"01", "010001"} )
	//Else
	U_TAC08({"01", "010001"})
	//Endif

	Return()


User Function TAC08(aParam)

	//If IsBlind()
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" //aParam[1] FILIAL aParam[2]
	//Endif
	//If !LockByName(ProcName())
	//	Conout("JOB já em Execução : " + ProcName() + " - "+DTOC(dDATABASE) + " - " + TIME() )
	//	If IsBlind()
	//		RpcClearEnv() // Limpa o ambiente, liberando a licença e fechando as conexões
	//	Endif
	//	Return
	//EndIf
	//conout("MGFTAC08 - Taura - Iniciando integração de Veiculos")
	//SET DELETE OFF // OBS: processa linhas deletadas
	//Processa Tipo de Veiculo, solicitado por Natan para não criar novo Job de processamento 24/06/2019
	U_xMGFPT10()

	U_TAC08VeiFil()
	//SET DELETE ON
	//conout("MGFTAC08 - Taura - Finalizando integração de Veiculos")
	//UnLockByName(ProcName())
	//If IsBlind()
	//	RESET ENVIRONMENT
	//Endif

	Return()


	// funcao de envio do cadatro de veiculo para o Taura
User Function TAC08EnvVei(aParam)

	Local aArea := {DA3->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTVE"))

	/*
	Local cJson := ""
	Local cPostRet := ""
	Local nTimeOut := 0//GetMv("")
	Local aHeadOut := {}
	Local cHeadRet := ""
	Local oObjRet := Nil
	*/

	Local cVei := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local lRet := .F.
	Local nCnt := 0
	//Local oWSVei := Nil
	Local cChave := ""
	Local nRet := 0
	Local cQ := ""

	Private oVei := Nil
	Private oWSVei := Nil

	//aadd(aHeadOut,'Content-Type: application/Json')

	//DA3->(dbSetOrder(1))
	//If DA3->(dbSeek(xFilial("DA3")+cVei))
	DA3->(dbGoto(aParam[3]))
	If DA3->(Recno()) == aParam[3]
		cChave := cVei
		If cStatus == "3"
			// se for exclusao
			// somente prossegue se o veiculo jah foi enviada ao Taura, ou se jah foram enviado/alterado e estao aguardando para serem reenviados
			If !DA3->DA3_ZTAUFL $ "1/2" .and. DA3->DA3_ZTAUIN == "S"
				aEval(aArea,{|x| RestArea(x)})
				Return(lRet)
			Endif
		Endif

		oVei := Nil
		oVei := GravarVeiculo():New()
		oVei:CarregaCampos(cStatus)

		oWSVei := MGFINT53():New(cURLPost,oVei/*oObjToJson*/,DA3->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT05"))/*cCodtpint*/,cChave/*cChave*/,.F./*lDeserialize*/,,.T.)
		//oWSVei:SendByHttpPost()
		StaticCall(MGFTAC01,ForcaIsBlind,oWSVei)
		cQ := "UPDATE "
		cQ += RetSqlName("DA3")+" "
		cQ += "SET "
		If oWSVei:lOk .And. oWSVei:nStatus == 1
			cQ += "DA3_ZTAUFL = '1', "
			cQ += "DA3_ZTAUIN = 'S' "
		Else
			cQ += "DA3_ZTAUFL = '2', "
			cQ += "DA3_ZTAUVE = DA3_ZTAUVE+1 "
		Endif
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DA3->(Recno())))

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de veiculo, para envio ao Taura.")
			Return()
		EndIf

		//MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",oWSVei:CDETAILINT)


		/*
		cJson := fwJsonSerialize(oVei,.F.,.T.)
		If isblind()
			conout(cjson)
		Else
			//APMsgAlert(cJson)
		Endif
		MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_"+StrTran(Time(),":","")+".txt",cJson)

		cPostRet := httpPost(cURLPost,,cJson,nTimeOut,aHeadOut,@cHeadRet)
		If !isblind()
			//APMsgalert(cPostRet)
			//APMsgalert(cHeadRet)
		Else
			conout(cPostRet)
			conout(cHeadRet)
		Endif

		DA3->(RecLock("DA3",.F.))
		if !Empty(cPostRet)
			// sucesso
			//fwJsonDeserialize(cPostRet,@oObjRet)
			If 'result' $ cPostRet .and. 'ok' $ cPostRet //.T. //oObjRet???
				// sucesso
				cRet := "Integrado com sucesso: "
				lRet := .T.
				DA3->DA3_ZTAUFL := "1" // processado
				If Empty(DA3->DA3_ZTAUIN)
					DA3->DA3_ZTAUIN := "S"
				Endif
			else
				cRet := "Não Integrado. Erro: "
				DA3->DA3_ZTAUFL := "2" // erro
			endif
		else
			cRet := "Nenhuma mensagem de retorno retornada. "
			DA3->DA3_sZTAUFL := "2" // erro
		endif
		DA3->(MsUnLock())
		MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",cRet+cPostRet)

		// envia para o monitor
		// U_ENVIAMONITOR()
		*/
	Endif

	aEval(aArea,{|x| RestArea(x)})

	Return(lRet)


	Class GravarVeiculo

		Data Acao					as String
		Data Pais					as String
		Data UF						as String
		Data Renavan 				as String
		Data Chassi					as String
		Data Placa					as String
		Data Documento 				as String
		Data Tipo 					as String
		Data Marca					as String
		Data Modelo					as String
		Data Anofabricacao			as Integer
		Data CargaMaxima			as Float
		Data Transportadora			as String
		Data Ativo 					as String
		Data CodERP					as String
		Data IdClassificacao		as String
		Data ApplicationArea		as ApplicationArea

		Method New()
		Method CarregaCampos()

		//Return
	EndClass


Method New() Class GravarVeiculo

	::ApplicationArea := ApplicationArea():New()

	Return


Method CarregaCampos(cStatus) Class GravarVeiculo

	Local cStringTime := "T00:00:00"
	Local cTransp     := ''

	::Acao := cStatus
	::Pais := Alltrim(DA3->DA3_ZPAIS)
	::UF := Alltrim(DA3->DA3_ESTPLA)
	::Renavan := Alltrim(DA3->DA3_RENAVA)
	::Chassi := Alltrim(DA3->DA3_CHASSI)
	::Placa := Alltrim(StrTran(StrTran(DA3->DA3_PLACA," ",""),"-",""))
	::Documento := Alltrim(DA3->DA3_ZDOCUM)
	::Tipo := Alltrim(Posicione("DUT",1,xFilial("DUT")+DA3->DA3_TIPVEI,"DUT_ZTAURA"))
	::Marca := Alltrim(Posicione("SX5",1,xFilial("SX5")+"M6"+DA3->DA3_MARVEI,"X5_DESCRI"))
	::Modelo := Alltrim(Posicione("ZZX",1,xFilial("ZZX")+DA3->DA3_ZCMODE,"ZZX_DESCR")) //Alltrim(DA3->DA3_ZCMODE)
	::AnoFabricacao := Alltrim(DA3->DA3_ANOMOD)
	::CargaMaxima := DA3->DA3_CAPACM
	cTransp := Alltrim(Posicione("SA4",1,xFilial("SA4")+DA3->DA3_ZTRANS,"A4_ZCODMGF"))
	IF Empty(cTransp)
		cTransp := Alltrim(DA3->DA3_ZTRANS)
	EndIF
	::Transportadora := cTransp
	::Ativo := IIf(DA3->DA3_MSBLQL == "1","0","1")
	::CodERP := Alltrim(DA3->DA3_COD)
	::IdClassificacao := val(DA3->DA3_ZCDCLA)
	Return()


	// funcao de filtragem dos veiculos que serao enviados ao Taura
	// serah chamada por job
	// ******************************
	//OBS: nao deixar nenhum reclock neste fonte e nem nos fontes chamados por este, pois esta rotina eh executada em job, e caso algum registro do cadastro
	//esteja em alteracao pelo usuario, o job vai parar aguardando o final da alteracao do usuario, bloqueando toda a execucao do job, o qual eh executado
	// para este e demais cadastros e movimentos.
	// ******************************
User Function TAC08VeiFil()

	Local cQ := ""
	Local cEmpSav:= cEmpAnt
	Local cFilSav := cFilAnt
	Local cAliasTrb := GetNextAlias()
	Local nCnt := 0
	Local lRet := .F.
	Local nRet := 0
	Local cIDTaura := GetMV("MGF_IDTCVE",.F.,) // 0000000001
	Local nOper := 0
	Local nOperNew := 0

	/*
	DA3_ZTAUFL, flags:
	1=enviado com sucesso
	2=enviado e rejeitado - Erro
	*/

	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTCVE'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTCVE",cIDtaura)

	// flega todos os veiculos selecionados como "em processamento", para que outro job nao pegue o mesmo veiculo para processar
	cQ := "UPDATE "
	cQ += RetSqlName("DA3")+" "
	cQ += "SET DA3_ZTAUID = '"+cIDTaura+"' "
	//cQ += "WHERE D_E_L_E_T_ <> '*' " // OBS: processa linhas deletadas
	cQ += "WHERE (DA3_ZTAUFL = ' ' "
	cQ += "OR DA3_ZTAURE = 'S' "
	cQ += "OR DA3_ZTAUFL = '2') "
	cQ += "AND DA3_ZTAUSE <> 'S' "
	// nao enviar registros deletados, que nao tenham sido integrados
	cQ += "AND NOT (D_E_L_E_T_ = '*' "
	cQ += "AND DA3_ZTAUIN = ' ') "
	cQ += "AND DA3_ZTAUVE <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de veiculo, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT DA3.R_E_C_N_O_ DA3_RECNO,DA3_FILIAL,DA3_COD,DA3_ZTAUFL,DA3_MSBLQL,DA3_ZTAUIN,DA3.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("DA3")+" DA3 "
	cQ += "WHERE "
	//cQ += "DA3.D_E_L_E_T_ <> '*' " // OBS: processa linhas deletadas
	cQ += "DA3_ZTAUID = '"+cIDTaura+"' "
	//cQ += "ORDER BY DA3_FILIAL,DA3_COD "

	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())

		cEmpAnt := Subs((cAliasTrb)->DA3_FILIAL,1,2)
		cFilAnt := Subs((cAliasTrb)->DA3_FILIAL,1,6)

		Begin Transaction

			//DA3->(dbGoto((cAliasTrb)->DA3_RECNO))
			//If DA3->(Recno()) == (cAliasTrb)->DA3_RECNO
			//	DA3->(RecLock("DA3",.F.))
			//	DA3->DA3_ZTAUSE := "S"
			//	DA3->(MsUnLock())
			//Endif
			nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->DA3_ZTAUIN),1,2))
			nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->DA3_ZTAUFL,IIf((cAliasTrb)->DA3_MSBLQL=="1",.T.,.F.),(cAliasTrb)->DA3_ZTAUIN)
			If !Empty(nOperNew)
				lRet := U_TAC08EnvVei({(cAliasTrb)->DA3_COD,nOperNew,(cAliasTrb)->DA3_RECNO})
			Endif
			DA3->(dbGoto((cAliasTrb)->DA3_RECNO))
			If DA3->(Recno()) == (cAliasTrb)->DA3_RECNO
				/*
				DA3->(RecLock("DA3",.F.))
				//DA3->DA3_ZTAUSE := ""
				If DA3->DA3_ZTAUFL != "2" // soh tira flag de reenvio se o envio foi com sucesso
					DA3->DA3_ZTAURE := ""
				Endif
				DA3->(MsUnLock())
				*/
				If DA3->DA3_ZTAUFL != "2" // soh tira flag de reenvio se o envio foi com sucesso
					cQ := "UPDATE "
					cQ += RetSqlName("DA3")+" "
					cQ += "SET "
					cQ += "DA3_ZTAURE = ' ' "
					cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(DA3->(Recno())))

					nRet := tcSqlExec(cQ)
					If nRet == 0
					Else
						ConOut("Problemas na gravação dos campos do cadastro de veiculo, para envio ao Taura.")
						Return()
					EndIf
				Endif
			Endif

		End Transaction

		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea())

	cEmpAnt := cEmpSav
	cFilAnt := cFilSav

	Return()


	// rotina chamada pelo ponto de entrada OMSA060
User Function TAC08OTOK(oObj)

	Local aArea := {GetArea()}
	Local lRet := .T.
	Local aCampos := {}
	Local bBlock := Nil
	Local oMdl
	Local oStruct

	aCampos := {"DA3_ZPAIS","DA3_ESTPLA","DA3_RENAVA","DA3_CHASSI","DA3_PLACA","DA3_ZDOCUM","DA3_TIPVEI","DA3_MARVEI","DA3_ZCMODE","DA3_ANOMOD","DA3_CAPACM","DA3_ZTRANS"}
	oMdl := oObj:GetModel("OMSA060_DA3")
	oStruct := oMdl:GetStruct()
	bBlock := {|x| oStruct:SetProperty(x,MODEL_FIELD_OBRIGAT,.T.)}
	aEval(aCampos,bBlock)

	aEval(aArea,{|x| RestArea(x)})

	Return(lRet)


	// rotina chamada pelo ponto de entrada OMSA060
User Function TAC08GRV(nOper)

	Local aArea := {GetArea()}
	Local lTauEnvia := GetMv("MGF_TAUVEI",,.F.)
	Local lTauJob := GetMv("MGF_TAUJVE",,.F.)
	Local nOpc := IIf(nOper == MODEL_OPERATION_INSERT,1,IIf(nOper == MODEL_OPERATION_UPDATE,2,IIf(nOper == MODEL_OPERATION_DELETE,3,0)))

	nOper := U_TOperEnvia(nOpc,DA3->DA3_ZTAUFL,IIf(DA3->DA3_MSBLQL=="1",.T.,.F.),DA3->DA3_ZTAUIN)
	If !Empty(nOper)
		If lTauEnvia .or. (nOpc == 3 .and. DA3->DA3_ZTAUIN == "S") // exclusao eh via on-line
			U_TauraEnvia(IIf(nOpc == 3,.F.,lTauJob)/*exclusao nao pode ser via job*/,"xTAC08EnvVei",{DA3->DA3_COD,nOper,DA3->(Recno())},.F.)
		Else // se nao enviar ao Taura o veiculo de forma on-line, flag para ser enviado por job
			DA3->(RecLock("DA3",.F.))
			DA3->DA3_ZTAURE := "S"
			DA3->DA3_ZTAUVE := 0
			DA3->(MsUnLock())
		Endif
	Else // se tipo de operacao de envio retornar vazio, apenas limpa o campo de numero de tentativas de envio
		DA3->(RecLock("DA3",.F.))
		DA3->DA3_ZTAUVE := 0
		DA3->(MsUnLock())
	Endif

	aEval(aArea,{|x| RestArea(x)})

	Return()


	// rotina complementar a rotina TAC08EnvVei
	// inicia ou nao empresa para enviar dados para o Taura
User Function xTAC08EnvVei(aParam,lJob,cEmp,cFil)

	Local nVezes := 100
	Local nCnt := 0
	Local lRet := .F.
	Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
	Local lStart := .F.

	Default lJob := .F.

	If lJob
		RpcSetType(3)
		lStart := RpcSetEnv(cEmp,cFil,,,/*"FAT"*/,,{"DA3"},,,.T.)
		If !lStart
			Return(lRet)
		Else // posiciona cadastro
			//DA3->(dbSetOrder(1))
			//DA3->(dbSeek(xFilial("DA3")+aParam[1]))
			DA3->(dbGoto(aParam[3]))
			If DA3->(Recno()) != aParam[3]
				Return(lRet)
			Endif
		Endif
	Endif

	For nCnt:=1 To nVezes
		If !Empty(DA3->DA3_ZTAUSE)
			Loop
		Else
			Exit
		Endif
	Next

	If Empty(DA3->DA3_ZTAUSE)

		Begin Transaction

			//DA3->(RecLock("DA3",.F.))
			//DA3->DA3_ZTAUSE := "S" // em processamento
			//DA3->(MsUnLock())
			lRet := U_TAC08EnvVei({aParam[1],aParam[2],aParam[3]})
			//DA3->(RecLock("DA3",.F.))
			//DA3->DA3_ZTAUSE := ""
			//DA3->(MsUnLock())

		End Transaction

	Else
		DA3->(RecLock("DA3",.F.))
		DA3->DA3_ZTAURE := "S"
		DA3->DA3_ZTAUVE := 0
		DA3->(MsUnLock())
	Endif

	If lJob
		RpcClearEnv()
	Endif

	Return(lRet)


	// verifica se veiculo pode sofrer manutencao
User Function TAC08VldMnt(aParam)

	Local aArea := {DA3->(GetArea()),GetArea()}
	Local cVei := aParam[1]
	Local lRet := .T.

	If DA3->DA3_COD != cVei
		DA3->(dbSetOrder(1))
		DA3->(dbSeek(xFilial("DA3")+cVei))
		If DA3->(!Found())
			lRet := .F.
			Help( ,, 'Help',, 'Veículo não encontrado.', 1, 0 )
		Endif
	Endif

	If lRet
		If DA3->DA3_ZTAUSE == "S"
			lRet := .F.
			Help( ,, 'Help',, 'Veículo não poderá sofrer manutenção agora, pois está sendo enviada para o Taura. Aguarde o envio.', 1, 0 )
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

	Return(lRet)


	// rotina chamada pelo ponto de entrada OMSA060
User Function OMSA060_PE()

	Local aArea := {GetArea()}
	Local oObj := IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
	Local cIdPonto := IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
	Local cIdModel := IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
	Local nOpcx := 0
	Local uRet := .T.

	If oObj == Nil .or. Empty(cIdPonto)
		Return(uRet)
	Endif

	nOpcx := oObj:GetOperation()

	If cIdPonto == "MODELVLDACTIVE"
		If nOpcx == MODEL_OPERATION_UPDATE .or. nOpcx == MODEL_OPERATION_DELETE
			uRet := U_TAC08VldMnt({DA3->DA3_COD})
		Endif
		If uRet
			If nOpcx == MODEL_OPERATION_INSERT .or. nOpcx == MODEL_OPERATION_UPDATE
				uRet := U_TAC08OTOK(oObj)
			Endif
		Endif
	ElseIf cIdPonto == "MODELPOS"
		If nOpcx == MODEL_OPERATION_DELETE
			U_TAC08GRV(nOpcx)
		Endif
		
		IF findfunction("U_MGFINT38") .and. nOpcx == MODEL_OPERATION_DELETE
			IF U_MGF38_EXC('DA3','DA3')
				uRet := .F.
				Help("",1,"Help",,'Pendência de grade',1,0,,,,,, {"Verifique pendência na Grade de Aprovação e tente novamente!"})
			EndIf
		EndIf

	ElseIf cIdPonto == "MODELCOMMITNTTS"
		If nOpcx == MODEL_OPERATION_INSERT .or. nOpcx == MODEL_OPERATION_UPDATE
			U_TAC08GRV(nOpcx)
		Endif

		If FindFunction("U_MGFCOM88") .and. nOpcx == MODEL_OPERATION_DELETE
			U_MGFCOM88('DA3')
		Endif	

	EndIf

	aEval(aArea,{|x| RestArea(x)})

	Return(uRet)