#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"                                                                                                                   

/*
=====================================================================================
Programa............: MGFTAC01
Autor...............: Mauricio Gresele
Data................: 28/11/2016 
Descricao / Objetivo: Integração Protheus-Taura, para envio do Cadastro de Fornecedores
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFTAC01(aParam)

//If IsBlind()
//	StartJob( "U_TAC01", GetEnvServer(), .T., {"01", "010001"} )
//Else
	U_TAC01({"01", "010001"})
//Endif		

Return()


User Function TAC01(aParam)

//If !IsBlind()

	if !isInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5")
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" //aParam[1] FILIAL aParam[2]
	endif

//Endif	
//conout("MGFTAC01 - Taura - Iniciando integração de Fornecedores")
//SET DELETE OFF // OBS: processa linhas deletadas
U_TAC01FilForn()
//SET DELETE ON
//conout("MGFTAC01 - Taura - Finalizando integração de Fornecedores")
//UnLockByName(ProcName())
//If IsBlind()
//	RESET ENVIRONMENT
//Endif	

Return()


// funcao de envio do cadatro de fornecedores para o Taura
User Function TAC01EnvForn(aParam)

Local aArea := {SA2->(GetArea()),GetArea()}
Local cURLPost := Alltrim(GetMv("MGF_URLTFO"))

/*
Local cJson	:= ""
Local cPostRet := ""
Local nTimeOut := 0//GetMv("")
Local aHeadOut := {}
Local cHeadRet := ""
Local oObjRet := Nil
*/

Local cForn := aParam[1]
Local cLoja := aParam[2]
Local cStatus := Alltrim(Str(aParam[3]))
Local lRet := .F.
Local nCnt := 0
//Local oWSForn := Nil
Local cChave := ""
Local nRet := 0
Local cQ := ""

Private oForn := Nil
Private oWSForn := Nil

//aadd(aHeadOut,'Content-Type: application/Json')

//SA2->(dbSetOrder(1))
//If SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
SA2->(dbGoto(aParam[4]))
If SA2->(Recno()) == aParam[4] 
	cChave := cForn+'-'+cLoja
	If cStatus == "3"
		// se for exclusao do fornecedor
		// somente prossegue se o fornecedor jah foi enviado ao Taura
		If !SA2->A2_ZTAUFLA $ "1/2" .and. SA2->A2_ZTAUINT == "S" 
			aEval(aArea,{|x| RestArea(x)})
			Return(lRet)
		Endif
	Endif
	
	oForn := Nil
	oForn := GravarFornecedor():New()
	oForn:CarregaCampos(cStatus)

	oWSForn := MGFINT53():New(cURLPost,oForn/*oObjToJson*/,SA2->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT01"))/*cCodtpint*/,cChave/*cChave*/,.F./*lDeserialize*/,,.T.)
	//oWSForn:SendByHttpPost()
	ForcaIsBlind(oWSForn)
   	cQ := "UPDATE "
	cQ += RetSqlName("SA2")+" "
	cQ += "SET "
	If oWSForn:lOk .And. oWSForn:nStatus == 1
		cQ += "A2_ZTAUFLA = '1', "
		cQ += "A2_ZTAUINT = 'S' "
	Else
		cQ += "A2_ZTAUFLA = '2', "
		cQ += "A2_ZTAUVEZ = A2_ZTAUVEZ+1 " 
	Endif
	cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SA2->(Recno())))

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação dos campos do cadastro de fornecedor, para envio ao Taura.")
		Return()	
	EndIf

	//MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",oWSForn:CDETAILINT)
	
	/*
	cJson := fwJsonSerialize(oForn,.F.,.T.)
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

	SA2->(RecLock("SA2",.F.))
	if !Empty(cPostRet)
		// sucesso
		//fwJsonDeserialize(cPostRet,@oObjRet)
		If 'result' $ cPostRet .and. 'ok' $ cPostRet //.T. //oObjRet???
			// sucesso
			cRet := "Integrado com sucesso: "
			lRet := .T.	
			SA2->A2_ZTAUFLA := "1" // processado 
			If Empty(SA2->A2_ZTAUINT)
				SA2->A2_ZTAUINT := "S"
			Endif	
		else
			cRet := "Não Integrado. Erro: "
			SA2->A2_ZTAUFLA := "2" // erro
		endif
	else
		cRet := "Nenhuma mensagem de retorno retornada. "
		SA2->A2_ZTAUFLA := "2" // erro
	endif
	SA2->(MsUnLock())
	MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",cRet+cPostRet)
	
	// envia para o monitor
	// U_ENVIAMONITOR()
    */
Endif

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Class GravarFornecedor

	Data Acao					as String	
	Data FornecedorAtivo		as String
	Data Email					as String
	Data Bairro					as String	
	Data Cep					as String
	Data Cidade		   			as String
	Data Complemento			as String
	Data Estado					as String
	Data Logradouro				as String
	Data Numero					as String
	Data Endereco				as String
	Data Pais					as String
	Data Nome					as String
	Data Natureza				as String
	Data NomeReduzido			as String
	Data Nacionalidade			as String
	Data Agencia				as String
	Data Banco					as String
	Data TipoContaBancaria		as String		
	Data Conta					as String
	Data CAR					as String
	Data Cnpj					as String
	Data Cpf					as String
	Data CCIR					as String
	Data InscricaoEstadual		as String
	Data Nirf					as String
	Data RG						as String
	Data SNCR					as String	
	Data DatadeNascimento		as String
	Data Propriedade			as String
	Data DDD					as String
	Data DDI					as String
	Data NumeroTelefone			as String
	Data TelefonePadrao			as String
	Data TipoTelefone			as String
	Data TipoEndereco			as String
	Data TipoFornecedor			as String
	Data CodERP					as String
	Data Loja					as String                                   
	Data NumeroExportacao       as String
	Data CAEPF				    as String
	Data ApplicationArea		as ApplicationArea	

	Method New()
	Method CarregaCampos()

//Return
EndClass


Method New() Class GravarFornecedor

::ApplicationArea := ApplicationArea():New()

Return


Method CarregaCampos(cStatus) Class GravarFornecedor

Local cStringTime := "T00:00:00"
Local nPos := 0
Local aCBox := {}
Local cNumero := "" 

::Acao := cStatus
::FornecedorAtivo := IIf(SA2->A2_MSBLQL == "1","0","1")
::Email := Alltrim(SA2->A2_EMAIL)
::Bairro := Alltrim(SA2->A2_BAIRRO)
::Cep := Alltrim(SA2->A2_CEP)
::Cidade := PesqCidade(SA2->A2_COD_MUN,SA2->A2_EST) //SA2->A2_COD_MUN
::Complemento := Alltrim(SA2->A2_COMPLEM)
::Estado := Alltrim(SA2->A2_EST)
::Logradouro := Alltrim(Subs(SA2->A2_END,1,IIf(At(",",SA2->A2_END)>0,At(",",SA2->A2_END)-1,Len(SA2->A2_END))))
cNumero := Alltrim(TAC01EndNum(SA2->A2_END,"A2_END"))
::Numero := Alltrim(cNumero)
::Endereco := Alltrim(SA2->A2_ZENDPAD)
::Pais := Alltrim(SA2->A2_ZPAIS)
::Nome := Alltrim(SA2->A2_NOME)
::Natureza := IIf(SA2->A2_TIPO $ "J/X","PESSOA JURIDICA","PESSOA FISICA")
::NomeReduzido := Alltrim(SA2->A2_NREDUZ)
::Nacionalidade	:= Alltrim(SA2->A2_ZNASCIO)
::Agencia := Alltrim(SA2->A2_AGENCIA)+IIf(Empty(SA2->A2_DVAGE),"","-"+Alltrim(SA2->A2_DVAGE))
::Banco := Alltrim(SA2->A2_BANCO)
aCBox := RetSX3Box(Posicione("SX3",2,"A2_TIPCTA","X3CBox()"),,,1)
::TipoContaBancaria := FwNoAccent(IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SA2->A2_TIPCTA)})) > 0,Upper(Alltrim(aCBox[nPos][3])),""))
::Conta  			:= Alltrim(Alltrim(SA2->A2_NUMCON)+IIf(Empty(SA2->A2_DVCTA),"","-"+SA2->A2_DVCTA))
::CAR 				:= Alltrim(SA2->A2_ZCAR)
::CCIR 				:= Alltrim(SA2->A2_ZCCIR)
::InscricaoEstadual := Alltrim(SA2->A2_INSCR)
::Nirf 				:= Alltrim(SA2->A2_ZNIRF)
::RG 				:= Alltrim(SA2->A2_PFISICA)
::SNCR 				:= Alltrim(SA2->A2_ZSNCR)
::DatadeNascimento 	:= IIf(!Empty(SA2->A2_ZDTNASC),Subs(dTos(SA2->A2_ZDTNASC),1,4)+"-"+Subs(dTos(SA2->A2_ZDTNASC),5,2)+"-"+Subs(dTos(SA2->A2_ZDTNASC),7,2)+cStringTime,"")
::Propriedade 		:= Alltrim(SA2->A2_ZPROPRI)
::DDD 				:= Alltrim(SA2->A2_DDD)
::DDI 				:= Alltrim(SA2->A2_DDI)
::NumeroTelefone 	:= Alltrim(SA2->A2_TEL)
::TelefonePadrao 	:= Alltrim(SA2->A2_ZTELPAD)
aCBox := RetSX3Box(Posicione("SX3",2,"A2_ZTPTEL","X3CBox()"),,,1)
::TipoTelefone 		:= IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SA2->A2_ZTPTEL)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
aCBox := RetSX3Box(Posicione("SX3",2,"A2_ZTPENDE","X3CBox()"),,,1)
::TipoEndereco := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SA2->A2_ZTPENDE)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
aCBox := RetSX3Box(Posicione("SX3",2,"A2_ZTPFORN","X3CBox()"),,,1)
::TipoFornecedor    := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==Alltrim(SA2->A2_ZTPFORN)})) > 0,Upper(Alltrim(aCBox[nPos][3])),"")
::Cpf := IIf(SA2->A2_TIPO == "F",SA2->A2_CGC,"")
::CodERP 			:= Alltrim(IIf(!Empty(SA2->A2_ZCODMGF),SA2->A2_ZCODMGF,SA2->A2_COD))
::Loja 				:= Alltrim(SA2->A2_LOJA)
::CAEPF				:= Alltrim(SA2->A2_ZCAEPF)
IF SA2->A2_TIPO == 'X'   
	::NumeroExportacao  := Alltrim(IIf(!Empty(SA2->A2_ZCODMGF),SA2->A2_ZCODMGF,SA2->A2_COD+SA2->A2_LOJA))
	::Cnpj 				:= ''
ElSE
	::Cnpj 				:= IIf(SA2->A2_TIPO $ "J",SA2->A2_CGC,"")
	::NumeroExportacao  := ''      
EndIF
	
Return()



// funcao de filtragem dos fornecedores que serao enviados ao Taura
// serah chamada por job
// ******************************
//OBS: nao deixar nenhum reclock neste fonte e nem nos fontes chamados por este, pois esta rotina eh executada em job, e caso algum registro do cadastro 
//esteja em alteracao pelo usuario, o job vai parar aguardando o final da alteracao do usuario, bloqueando toda a execucao do job, o qual eh executado 
// para este e demais cadastros e movimentos.
// ******************************
User Function TAC01FilForn()

Local cQ := ""
Local cEmpSav:= cEmpAnt
Local cFilSav := cFilAnt
Local cAliasTrb := GetNextAlias()
Local nCnt := 0
Local lRet := .F.
Local nRet := 0
Local cIDTaura := GetMV("MGF_IDTCFO",.F.,) // 0000000001
Local nOper := 0
Local nOperNew := 0

/*
A2_ZTAUFLA, flags:
1=enviado com sucesso
2=enviado e rejeitado - Erro
*/

If Empty(cIDTaura)
	ConOut("Não encontrado parâmetro 'MGF_IDTCFO'.")
	Return()
Endif

cIDTaura := Soma1(cIDTaura)
PutMV("MGF_IDTCFO",cIDtaura)	

// flega todos os fornecedores selecionados como "em processamento", para que outro job nao pegue o mesmo fornecedor para processar
cQ := "UPDATE "
cQ += RetSqlName("SA2")+" "
cQ += "SET A2_ZTAUID = '"+cIDTaura+"' "
//cQ += "WHERE D_E_L_E_T_ <> '*' " // OBS: processa linhas deletadas
//cQ += "AND A2_FILIAL = '"+aParam[2]+"' "
cQ += "WHERE (A2_ZTAUFLA = ' ' "
cQ += "OR A2_ZTAUREE = 'S' "
cQ += "OR A2_ZTAUFLA = '2') "
cQ += "AND A2_ZTAUSEM <> 'S' "
// nao enviar registros deletados, que nao tenham sido integrados
cQ += "AND NOT (D_E_L_E_T_ = '*' "
cQ += "AND A2_ZTAUINT = ' ') "
cQ += "AND A2_ZTAUVEZ <= "+Alltrim(Str(GetMv("MGF_TAUVEZ",,5)))+" "

nRet := tcSqlExec(cQ)
If nRet == 0
Else
	ConOut("Problemas na gravação do semáforo do cadastro de fornecedor, para envio ao Taura.")
	Return()	
EndIf

cQ := "SELECT SA2.R_E_C_N_O_ SA2_RECNO,A2_FILIAL,A2_COD,A2_LOJA,A2_ZTAUFLA,A2_MSBLQL,A2_ZTAUINT,SA2.D_E_L_E_T_ DELET "
cQ += "FROM "+RetSqlName("SA2")+" SA2 "
cQ += "WHERE "
//cQ += "SA2.D_E_L_E_T_ <> '*' " // OBS: processa linhas deletadas
cQ += "A2_ZTAUID = '"+cIDTaura+"' "
cQ += "ORDER BY A2_FILIAL,A2_COD,A2_LOJA "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

While (cAliasTrb)->(!Eof())

	cEmpAnt := Subs((cAliasTrb)->A2_FILIAL,1,2)
	cFilAnt := Subs((cAliasTrb)->A2_FILIAL,1,6)

	Begin Transaction
	
	//SA2->(dbGoto((cAliasTrb)->SA2_RECNO))
	//If SA2->(Recno()) == (cAliasTrb)->SA2_RECNO
	//	SA2->(RecLock("SA2",.F.))
	//	SA2->A2_ZTAUSEM := "S"
	//	SA2->(MsUnLock())
	//Endif	
	nOper := IIf((cAliasTrb)->DELET=="*",3,IIf(Empty((cAliasTrb)->A2_ZTAUINT),1,2))
    nOperNew := U_TOperEnvia(nOper,(cAliasTrb)->A2_ZTAUFLA,IIf((cAliasTrb)->A2_MSBLQL=="1",.T.,.F.),(cAliasTrb)->A2_ZTAUINT)
    If !Empty(nOperNew)
		lRet := U_TAC01EnvForn({(cAliasTrb)->A2_COD,(cAliasTrb)->A2_LOJA,nOperNew,(cAliasTrb)->SA2_RECNO})
	Endif
	SA2->(dbGoto((cAliasTrb)->SA2_RECNO))
	If SA2->(Recno()) == (cAliasTrb)->SA2_RECNO
		If SA2->A2_ZTAUFLA != "2" // soh tira flag de reenvio se o envio foi com sucesso
			/*
			SA2->(RecLock("SA2",.F.))
			//SA2->A2_ZTAUSEM := ""
			If SA2->A2_ZTAUFLA != "2" // soh tira flag de reenvio se o envio foi com sucesso
				SA2->A2_ZTAUREE := ""
			Endif	
			SA2->(MsUnLock())
			*/
		   	cQ := "UPDATE "
			cQ += RetSqlName("SA2")+" "
			cQ += "SET "
			cQ += "A2_ZTAUREE = ' ' "
			cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SA2->(Recno())))
		
			nRet := tcSqlExec(cQ)
			If nRet == 0
			Else
				ConOut("Problemas na gravação dos campos do cadastro de fornecedor, para envio ao Taura.")
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


// rotina chamada pelo ponto de entrada MA020TDOK
User Function TAC01MA020TDOK()

Local aArea := {SX3->(GetArea()),SXA->(GetArea()),GetArea()}
Local lRet := .T.
//Local aCampos := {"A2_BAIRRO","A2_CEP","A2_COD_MUN","A2_EST","A2_END","A2_ZENDPAD","A2_ZPAIS","A2_CGC","A2_INSCR","A2_ZTPENDE","A2_ZTPFORN"}
Local aCampos1 := {"A2_ZDTNASC"}
Local aCampos2 := {"A2_ZPROPRI"}
Local aCampos3 := {"A2_INSCR"}
Local bBlock := {|x| IIf((lRet .and. Empty(&("M->"+x))),(lRet:=.F.,SX3->(dbSeek(x)),SXA->(dbSeek("SA2"+SX3->X3_FOLDER)),APMsgStop("Campo obrigatório para o envio ao Taura não informado, campo: '"+Alltrim(X3Titulo())+"'"+IIf(SXA->(Found()),", aba: '"+Alltrim(SXA->XA_DESCRIC)+"' ",IIf(SXA->(dbSeek("SA2")),", aba: 'Outros'","")))),Nil)}
Local bBlockB := {|x| IIf((lRet .and. Empty(&("M->"+x))),(lRet:=.F.,SX3->(dbSeek(x)),SXA->(dbSeek("SA2"+SX3->X3_FOLDER)),Help(" ",1,'TAURAOBRIGAT',,"Campo obrigatório para o envio ao Taura não informado, campo: '"+Alltrim(X3Titulo())+"'"+IIf(SXA->(Found()),", aba: '"+Alltrim(SXA->XA_DESCRIC)+"' ",IIf(SXA->(dbSeek("SA2")),", aba: 'Outros'",""))),1,0),Nil)}
Local nCnt := 0

SX3->(dbSetOrder(2))
SXA->(dbSetOrder(1))

//aEval(aCampos,bBlock)
If lRet
	If M->A2_TIPO == "F"
		If IsBlind()
			aEval(aCampos1,bBlockB)
		Else
			aEval(aCampos1,bBlock)
		EndIf
	Endif
Endif		

If lRet
	If M->A2_LOJA != "01"
		If IsBlind()
			aEval(aCampos2,bBlockB)
		Else
			aEval(aCampos2,bBlock)
		EndIf
	Endif
Endif		

If lRet
	If M->A2_TIPO != "F"
		If IsBlind()
			aEval(aCampos3,bBlockB)
		Else
			aEval(aCampos3,bBlock)
		EndIf
	Endif
Endif		

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// rotina chamada pelo ponto de entrada MT20FOPOS
User Function TAC01MT20FOPOS(ParamIxb)

Local lTauEnvia := GetMv("MGF_TAUFOR",,.F.)
Local lTauJob := GetMv("MGF_TAUJFO",,.F.)
Local nOper := 0

If ParamIxb[1] != 5 // exclusao nao envia por este ponto de entrada
	/*
	// Os registros bloqueados não serão exportados quando for inclusão
	If ParamIxb[1] == 3 .and. SA2->A2_MSBLQL == "1"
		Return()
	Endif	
    */
    nOper := U_TOperEnvia(ParamIxb[1]-2,SA2->A2_ZTAUFLA,IIf(SA2->A2_MSBLQL=="1",.T.,.F.),SA2->A2_ZTAUINT)
    If !Empty(nOper)
		If lTauEnvia
			//U_TauraEnvia(lTauJob,"xTAC01EnvForn",{SA2->A2_COD,SA2->A2_LOJA,ParamIxb[1]-2},.F.) // inclusao ou alteracao
			U_TauraEnvia(lTauJob,"xTAC01EnvForn",{SA2->A2_COD,SA2->A2_LOJA,nOper,SA2->(Recno())},.F.) // inclusao ou alteracao
		Else // se nao enviar ao Taura o fornecedor de forma on-line, flag para ser enviado por job
			SA2->(RecLock("SA2",.F.))
			SA2->A2_ZTAUREE := "S"
			SA2->A2_ZTAUVEZ := 0
			SA2->(MsUnLock())	
		Endif	
	Else // se tipo de operacao de envio retornar vazio, apenas limpa o campo de numero de tentativas de envio
		SA2->(RecLock("SA2",.F.))
		SA2->A2_ZTAUVEZ := 0
		SA2->(MsUnLock())	
	Endif
Endif	

Return()


// rotina chamada pelo ponto de entrada M020EXC
User Function TAC01M020EXC()

Local lTauEnvia := .T. // tem que ser sempre on-line a exclusao
Local lTauJob := .F. // exclusao nao pode ser nunca via job, pois tem o risco do registro jah ter sido deletado quando chagar na thread

If lTauEnvia .and. SA2->A2_ZTAUINT == "S" 
	U_TauraEnvia(lTauJob,"xTAC01EnvForn",{SA2->A2_COD,SA2->A2_LOJA,3,SA2->(Recno())},.F.) // exclusao
Endif	

Return()


// rotina generica de envio de dados para o Taura
User Function TauraEnvia(lJob,cFuncao,aParam,lWait)

Local xRet
Local cFuncaoJob := "U_"+cFuncao

If !lJob
	xRet := ExecBlock(cFuncao,.F.,.F.,aParam)
Else
	xRet := StartJob(cFuncaoJob,GetEnvServer(),lWait,aParam,.T.,cEmpAnt,cFilAnt)
Endif		

Return(xRet)


// rotina complementar a rotina TAC01EnvForn
// inicia ou nao empresa para enviar dados para o Taura
User Function xTAC01EnvForn(aParam,lJob,cEmp,cFil)

Local nVezes := 100
Local nCnt := 0
Local lRet := .F.
Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
Local lStart := .F.

Default lJob := .F.

If lJob
	RpcSetType(3)
	lStart := RpcSetEnv(cEmp,cFil,,,/*"FAT"*/,,{"SA2"},,,.T.)
	If !lStart
		Return(lRet) 
	Else // posiciona fornecedor
		//SA2->(dbSetOrder(1))
		//SA2->(dbSeek(xFilial("SA2")+aParam[1]+aParam[2]))
		SA2->(dbGoto(aParam[4]))
		If SA2->(Recno()) != aParam[4] 
			Return(lRet)
		Endif	
	Endif
Endif
			
For nCnt:=1 To nVezes
	If !Empty(SA2->A2_ZTAUSEM)
		Loop
	Else
		Exit	
	Endif
Next

If Empty(SA2->A2_ZTAUSEM)
	
	Begin Transaction 
	
	//SA2->(RecLock("SA2",.F.))
	//SA2->A2_ZTAUSEM := "S" // em processamento
	//SA2->(MsUnLock())
	lRet := U_TAC01EnvForn({aParam[1],aParam[2],aParam[3],aParam[4]})
	//SA2->(RecLock("SA2",.F.))
	//SA2->A2_ZTAUSEM := ""
	//SA2->(MsUnLock())
	
	End Transaction 
	
Else
	If SA2->(FieldPos("A2_ZTAUREE")) > 0
		SA2->(RecLock("SA2",.F.))
		SA2->A2_ZTAUREE := "S"
		SA2->A2_ZTAUVEZ := 0
		SA2->(MsUnLock())		
	Endif	
Endif	

If lJob
	RpcClearEnv()
Endif
	
Return(lRet)   


// verifica se Fornecedor pode sofrer manutencao
User Function TAC01VldMnt(aParam)

Local aArea := {SA2->(GetArea()),GetArea()}
Local cForn := aParam[1]
Local cLoja := aParam[2]
Local lRet := .T.

If SA2->A2_COD+SA2->A2_LOJA != cForn+cLoja
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
	If SA2->(!Found())
		lRet := .F.
		APMsgStop("Fornecedor não encontrado.")
	Endif
Endif

If lRet
	If SA2->A2_ZTAUSEM == "S"
		lRet := .F.
		APMsgAlert("Fornecedor não poderá sofrer manutenção agora, pois está sendo enviado para o Taura. Aguarde o envio.")
	Endif
Endif	
		
aEval(aArea,{|x| RestArea(x)})

Return(lRet)			


// procura numero do endereco, no trecho compreendido apos a primeira virgula do endereco e ate o primeiro espaco apos a virgula
Static Function TAC01EndNum(cEndereco,cCampo)

Local cNumero := ""
Local nPos := 0
Local nPos1 := 0
Local cEndAux := ""

// procura numero do endereco, no trecho compreendido apos a primeira virgula do endereco e ate o primeiro espaco apos a virgula
If (nPos := At(",",cEndereco)) > 0
	cEndAux := Alltrim(Subs(cEndereco,nPos+1))
	If !Empty(cEndAux)
		If (nPos1 := At(" ",cEndAux)) > 0
			cNumero := Alltrim(Subs(cEndAux,1,nPos1))
		Else
			cNumero := Alltrim(Subs(cEndAux,1,TamSX3(cCampo)[1]))
		Endif
	Else
		cNumero := "SN"
	Endif	
Else
	cNumero := "SN"
Endif			

Return(cNumero)


// tratamento quanto a operacao para enviar o registro para o Taura
User Function TOperEnvia(nOper,cFlag,lBloqueio,cIntegrou)

// nOper:1=inclusao,2=alteracao,3=exclusao

Local nOperNew := nOper // se zerado, nao eh para enviar o registro

// Os registros bloqueados não serão exportados quando for inclusão
If nOper == 1 .and. lBloqueio
	nOperNew := 0
Endif

// verifica no caso de alteracao, se o registro jah foi enviado ao Taura
If nOper == 2	
	// envia como alteracao se jah foi enviado anteriormente
	If (cFlag == "1" .or. cFlag == "2") .and. !Empty(cIntegrou)
		nOperNew := 2
	Endif
	// envia como inclusao se nao foi enviado antes e o registro nao estiver bloqueado, pois entende-se que a alteracao foi de bloqueado para desbloqueado
	If Empty(cIntegrou) .and. !lBloqueio
		nOperNew := 1
	Endif
	// nao envia se for alteracao, nao foi enviado antes e o registro estiver bloqueado, pois entende-se que eh alteracao de um registro que ainda se encontra bloqueado
	// e ainda nao foi enviado
	If Empty(cIntegrou) .and. lBloqueio
		nOperNew := 0 // zera para forcar o nao envio
	Endif
Endif

Return(nOperNew)				


// funcao para carregar o codigo do estado junto com o codigo do municipio e retornar um codigo unico
Static Function PesqCidade(cCidade,cEstado)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local aArea := {GetArea()}
Local cRet := ""

cQ := "SELECT GU7_NRCID "
cQ += "FROM "+RetSqlName("GU7")+" GU7 "
cQ += "WHERE "
cQ += "GU7.D_E_L_E_T_ <> '*' "
cQ += "AND GU7_CDUF = '"+cEstado+"' "
cQ += "AND SUBSTR(GU7_NRCID,3,5) = '"+cCidade+"' "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

While (cAliasTrb)->(!Eof())
	cRet := (cAliasTrb)->GU7_NRCID
	Exit
Enddo

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return(cRet)	
	

// forca para que a funcao padrao do frame httpPost(), rode no isblind()
Static Function ForcaIsBlind(oObj)

// tratamento para funcao padrao do frame, httpPost(), nao apresentar mensagem de "DATA COMMAND ERRO" quando executada em tela,	
// forca funcao padrao IsBlind() a retornar .T.
cSavcInternet := Nil
//If Type("__cInternet") == "C"
	cSavcInternet := __cInternet
//Endif	
__cInternet := "AUTOMATICO"

oObj:SendByHttpPost()

//If cSavcInternet != Nil
	__cInternet := cSavcInternet
//Endif
	
Return()


// valida os campos de nascionalidade e codigo do pais, digitados pelo usuario
User Function TAC01PaisNac(cCampo,cConteudo)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local aArea := {GetArea()}
Local lRet := .F.

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SYA")+" SYA "
cQ += "WHERE "
cQ += "SYA.D_E_L_E_T_ <> '*' "
cQ += "AND YA_FILIAL = '"+xFilial("SYA")+"' "
If cCampo == "_ZPAIS"
	cQ += "AND YA_ZSIGLA = '"+Alltrim(cConteudo)+"' "
Elseif cCampo == "_ZNASCI"	
	cQ += "AND YA_NASCIO = '"+Alltrim(cConteudo)+"' "
Endif	

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	lRet := .T.
Endif

If !lRet
	Help(" ",1,"REGNOIS")
Endif

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return(lRet)	
