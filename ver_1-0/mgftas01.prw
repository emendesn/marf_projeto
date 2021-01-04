#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"

/*
=====================================================================================
Programa............: MGFTAS01
Autor...............: Mauricio Gresele
Data................: 24/10/2016
Descricao / Objetivo: Integracao Protheus-Taura, para envio de PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: A. Carlos - Incuido converter memo em caracter
Data................: 12/11/2019
=====================================================================================
*/
User Function  xTestTAS01


	U_TAS01({99,{'010041'}})

Return


User Function MGFTAS01(cPar1,cPar2,cPar3,cPar4,cPar5,cPar6,cPar7,cPar8)
	Local aParam	:= {}

	// tratamento do job por grupo de filiais passado por par�mentros

	If ValType(cPar2) == "C"
		aAdd( aParam , cPar2)
	EndIf
	If ValType(cPar3) == "C"
		aAdd( aParam , cPar3)
	EndIf
	If ValType(cPar4) == "C"
		aAdd( aParam , cPar4)
	EndIf
	If ValType(cPar5) == "C"
		aAdd( aParam , cPar5)
	EndIf
	If ValType(cPar6) == "C"
		aAdd( aParam , cPar6)
	EndIf
	If ValType(cPar7) == "C"
		aAdd( aParam , cPar7)
	EndIf
	If ValType(cPar8) == "C"
		aAdd( aParam , cPar8)
	EndIf

	U_TAS01({Val(cPar1),aParam})

Return()

User Function TAS01(aParam)
	Private _aMatriz   := {"01","010001"}
	Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
	Private cTipo      := aParam[01]
	Private cObs       := " "

	IF lIsBlind

		RpcSetType(3)
		RpcSetEnv(_aMatriz[1],_aMatriz[2])

		cTipo := STRZERO(cTipo,2)

		If !LockByName("TAES01_"+cTipo)
			Conout("JOB j� em Execucao : MGFTAS01_"+cTipo +" "+ DTOC(dDATABASE) + " - " + TIME() )
			RpcClearEnv()
			Return
		EndIf
		conOut("********************************************************************************************************************"+ CRLF)
		conOut('--------------------- Inicio do processamento - MGFTAS01_'+cTipo +' - Envio PV Taura - ' + DTOC(dDATABASE) + " - " + TIME())
		conOut("********************************************************************************************************************"+ CRLF)

		U_TAS01FilPV(aParam[02])

		conOut("********************************************************************************************************************"+ CRLF)
		conOut('---------------------- Fim  - MGFTAS01_'+cTipo +' - Envio PV Taura - ' + DTOC(dDATABASE) + " - " + TIME()  				  )
		conOut("********************************************************************************************************************"+ CRLF)

		RpcClearEnv()

		UnLockByName(ProcName())
	EndIF


Return()

// funcao de envio do PV para o Taura
User Function TAS01EnvPV(aParam)

	Local aArea    := {SC5->(GetArea()),SC6->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTPV")) //http://SPDWVAPL203:8081/taura-pedido-venda
	Local cPV      := aParam[1]
	Local cStatus  := Alltrim(Str(aParam[2]))
	Local oItens   := Nil
	Local lRet     := .F.
	Local nCnt     := 0
	Local cChave   := ""
	Local nRet     := 0
	Local cQ       := ""
	Local cTamErro := TAMSX3("C5_ZERRO")[1]
	Local bTaura := .F.
	Local cQuant := ''
	Local aRecnoSC6 := {}

	local cUpdSC6	:= ""

	Private oPV    := Nil
	Private oWSPV  := Nil

	SC5->(dbGoto(aParam[3]))
	If SC5->(Recno()) == aParam[3]
		If IsInCallStack("U_MGFFAT64")
			cChave := SC5->C5_FILIAL + " - " + Alltrim(cPV)
		Else
			cChave := cPV
		EndIf

		oPV := Nil
		oPV := GravarPedidoVenda():New()
		oPV:GravarPVCab(cStatus)

		aRecnoSC6 := ItensSC6(cStatus)

		For nCnt:=1 To Len(aRecnoSC6)
			SC6->(dbGoto(aRecnoSC6[nCnt]))
			If SC6->(Recno()) == aRecnoSC6[nCnt]
				oItens := Nil
				oItens := ItensPV():New()
				oPV:GravarPVItens(oItens)
			Endif
		Next

		oWSPV := MGFINT53():New(cURLPost,oPV/*oObjToJson*/,SC5->(Recno())/*nKeyRecord*/,/*"SC5"/*cTblUpd*/,/*"C5_ZTAUFLA"/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT08")),cChave/*cChave*/,.F./*lDeserialize*/,.F.,.T.)

		StaticCall(MGFTAC01,ForcaIsBlind,oWSPV)

		SZJ->(dbSetOrder(1))
		If SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
			If SZJ->ZJ_TAURA == 'S'
				bTaura := .T.
			EndIf
		EndIf

		If oWSPV:lOk
			If cStatus <> "3"
				u_TAS06_DelRegra(SC5->C5_FILIAL,SC5->C5_NUM)
			Endif

			IF oWSPV:nStatus == 1

				cUpdSC6 := ""
				cUpdSC6 += "UPDATE " + retSQLName("SC6")												+ chr(13) + chr(10)
				cUpdSC6 += " SET"																		+ chr(13) + chr(10)
				cUpdSC6 += " 	C6_XULTQTD = C6_QTDVEN"													+ chr(13) + chr(10)
				cUpdSC6 += " WHERE"																		+ chr(13) + chr(10)
				cUpdSC6 += " 	R_E_C_N_O_ IN"															+ chr(13) + chr(10)
				cUpdSC6 += " 	("																		+ chr(13) + chr(10)
				cUpdSC6 += " 		SELECT SUBSC6.R_E_C_N_O_"											+ chr(13) + chr(10)
				cUpdSC6 += " 		FROM "			+ retSQLName("SC5") + " SUBSC5"						+ chr(13) + chr(10)
				cUpdSC6 += " 		INNER JOIN " 	+ retSQLName("SC6") + " SUBSC6"						+ chr(13) + chr(10)
				cUpdSC6 += " 		ON"																	+ chr(13) + chr(10)
				cUpdSC6 += " 			SUBSC6.C6_NUM		=	SUBSC5.C5_NUM"							+ chr(13) + chr(10)
				cUpdSC6 += " 		AND	SUBSC6.C6_FILIAL	=	SUBSC5.C5_FILIAL"						+ chr(13) + chr(10)
				cUpdSC6 += " 		AND	SUBSC6.D_E_L_E_T_	<>	'*'"									+ chr(13) + chr(10)
				cUpdSC6 += " 		WHERE"																+ chr(13) + chr(10)
				cUpdSC6 += "			SUBSC5.R_E_C_N_O_	=	" + allTrim( str( SC5->( recno() ) ) )	+ chr(13) + chr(10)
				cUpdSC6 += " 		AND	SUBSC5.D_E_L_E_T_	<>	'*'"									+ chr(13) + chr(10)
				cUpdSC6 += " 	)"																		+ chr(13) + chr(10)

				if tcSQLExec( cUpdSC6 ) < 0
					conout( "Nao foi possivel executar UPDATE." + chr(13) + chr(10) + tcSqlError() )
				endif

				cQ := "UPDATE "+ RetSqlName("SC5")+" "
				cQ += "SET  C5_ZBLQTAU = ' ',"
				cQ += "     C5_ZLIBENV = 'N',"
				cQ += "     C5_ZERRO   = ' ',"
				cQ += "     C5_ZTAUREE = 'N',"
				cQ += "		C5_ZTAUINT = 'S'"
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))
			ElseIF oWSPV:nStatus == 2
				If bTaura
					u_TAS06_GRV(SC5->C5_FILIAL,SC5->C5_NUM,'01','000089')
					cQ := "UPDATE "+ RetSqlName("SC5")+" "
					cQ += "SET  C5_ZBLQTAU = ' ' ,"
					cQ += "     C5_ZLIBENV = 'N',"
					cQ += "     C5_ZTAUREE = 'N',"
					cQ += "     C5_ZERRO   = '"+SUBSTR(oWSPV:cDetailInt,1,cTamErro)+"'"
					cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))
				Endif
			EndIF
		Else
			IF oWSPV:lErro500
				IF SC5->C5_ZTAUREE $ "S N"
					cQuant := '1'
				ElseIF SC5->C5_ZTAUREE $ '123456789'
					cQuant := SOMA1(SC5->C5_ZTAUREE)
				Else
					cQuant := '1'
				EndIF

				cQ := "UPDATE "+ RetSqlName("SC5")+" "
				cQ += "SET  C5_ZTAUREE = '"+cQuant+"' "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(SC5->(Recno())))

			EndIF
		Endif


		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravacao dos campos do pedido de venda, para envio ao Taura.")
			Return()
		EndIf

	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(lRet)


// funcao de consulta do status do PV no Taura
User Function TAS01StatPV(aParam,_lshow,_lJob)

	Local aArea := {SC5->(GetArea()),GetArea()}
	Local cURLPost := Alltrim(GetMv("MGF_URLTSP")) //"spdwvtds002/wsintegracaoshape/api/v0/pedido/PostVerificarPodeAlterarExcluirPedidoVenda"//AllTrim(getMv(""))
	Local cAliasTrb := GetNextAlias()
	Local cPV := aParam[1]
	Local cStatus := Alltrim(Str(aParam[2]))
	Local lRet := .F.
	Local cChave := ""
	Local bTaura := .F.

	Local aRet   := {}
	Local nCt    := 0
	Local cGrupo := ''
	Local lCont  := .T.
	Local cUser := __CUSERID

	Default _lshow 	:= .T.
	Default _lJob	:= .F.

	Private oStPV	:= Nil
	Private oWSStPV := Nil

	If (IsInCallStack("A410Devol") .or. SC5->C5_TIPO == "D")
		Return(.T.)
	Endif
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+cPV))

		//Perfil de PCP nao pode ter acesso a alteracao de pedidos Especie VE � Venda /Tipo Operacao BJ e Pedido FIFO operacao FG.
		If IsInCallStack("A410Altera")
			If !Empty(cUser)
				aRet := FWSFUsrGrps(cUser)
				_cTpPed := SC5->C5_ZTIPPED
				_cOper := SC5->C5_ZTPOPER
				lCont := .T.
				If _cTpPed $ 'VE/FG' .AND. _cOper $ 'BJ'
					For nCt:= 1 to Len(aRet)
						cGrupo:= Upper(AllTrim(FWGetNameGrp(aRet[nCt])))
						If !Empty(cGrupo)
							If 'PCP' $ cGrupo
								APMsgAlert("[MGFTAS01/001] - Pedido do Tipo: "+_cTpPed+" e Operacao: "+_cOper+" nao pode ser alterado conforme Regra.")
								lCont := .F.
								Exit
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		Endif

		If lCont

			If (IsInCallStack("A410Devol") .or. SC5->C5_TIPO == "D" .or. IIf(_lJob,.F.,Inclui) .or. M->C5_TIPO == "D")
				aEval(aArea,{|x| RestArea(x)})
				If _lJob
					Return({.T., 'Pedido bloqueado com sucesso. Sem integracao com taura.' })
				Else
					Return(.T.)
				EndIf
			Endif

			dbSelectArea('SZJ')
			SZJ->(dbSetOrder(1))
			IF SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
				IF SZJ->ZJ_TAURA == 'S'
					bTaura := .T.
				EndIF
			EndIF

			IF !bTaura
				aEval(aArea,{|x| RestArea(x)})
				If _lJob
					Return({.T.,'Pedido bloqueado com sucesso. Sem integracao com taura.'})
				Else
					Return(.T.)
				EndIf
			EndIF

			If FunName() == "EECFATCP" // cModulo == "EEC"
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			If IsInCallStack("A410Copia")
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// rotina de importacao de ordem de embarque
			If IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP")
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// rotina de exclusao de nota de saida
			// quando ocorre exclusao de nota com processo de fis45, o pedido eh alterado novamente, para a condicao original, para se desfazer o fis45 e esta validacao nao deve ser executada
			If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
				aEval(aArea,{|x| RestArea(x)})
				Return(.T.)
			Endif

			// alteracao do pedido de exportacao, somente alteracao de campos permitidos
			// nao envia pedido para o taura
			If IsInCallStack("EECAP100") //.and. IsBlind()
				If Type("nOpcAux") != "U" .and. nOpcAux == 4 //ALTERAR
					If Type("__lRetStatPV") != "U" .and. !__lRetStatPV .and. SC5->C5_ZTAUINT == "S"
						aEval(aArea,{|x| RestArea(x)})
						Return(.T.)
					Endif
				Endif
			Endif

		EndIf

		cChave := xFilial("SC5")+cPV
		oStPV := Nil
		oStPV := PodeAlterarExcluirPedidoVenda():New(cStatus)

		oWSStPV := MGFINT23():New(cURLPost,oStPV/*oObjToJson*/,SC5->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONI14"))/*cCodtpint*/,cChave/*cChave*/,.F./*lDeserialize*/,.F.,.T.)

		StaticCall(MGFTAC01,ForcaIsBlind,oWSStPV)

		If (Type("oWSStPV:nStatus") != "U" .and. (oWSStPV:nStatus == 1 .or. oWSStPV:nStatus == 3)) .or. (Type("oWSStPV:CDETAILINT") != "U" .and. 'result' $ oWSStPV:CDETAILINT .and. 'ok' $ oWSStPV:CDETAILINT)
			lRet := .T.
		Endif

		If !lRet .and. !IsIncallStack("U_MGFFATA7") .and. _lshow
			APMsgAlert("Nao sera permitida manutencao no Pedido de Venda."+CRLF+;
			"Motivo: "+oWSStPV:CDETAILINT)
		ElseIf IsIncallStack("U_MGFFATA7") .and. !lRet .and. _lshow
			If Type("_cMensTaura") == "U"
				_cMensTaura += "Nao sera permitida manutencao no Pedido de Venda." + CRLF
				_cMensTaura += "Motivo: " + oWSStPV:CDETAILINT + CRLF
				_cMensTaura += "--------------------------------------------------------"
			EndIf
		Endif

	Endif

	aEval(aArea,{|x| RestArea(x)})

	If _lJob
		Return({lRet, Iif( Type('oWSStPV:CDETAILINT') <> 'U' , oWSStPV:CDETAILINT , 'Pedido nao localizado.' )})
	EndIf

Return(lRet)


Class PodeAlterarExcluirPedidoVenda

Data Acao				as String
Data Filial				as String
Data Pedido				as String
Data TipoPedido	   		as String
Data DataPedido	   		as String
Data ApplicationArea	as ApplicationArea

Method New()

Return


Method New(cStatus) Class PodeAlterarExcluirPedidoVenda

Local cStringTime := "T00:00:00"

::Acao := cStatus
::Filial := SC5->C5_FILIAL
::Pedido := Alltrim(SC5->C5_NUM)
::TipoPedido := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,""))
::DataPedido := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
::ApplicationArea := ApplicationArea():New()

Return


// funcao de filtragem dos PV�s que serao enviados ao Taura
// serah chamada por job
// ******************************
//OBS: nao deixar nenhum reclock neste fonte e nem nos fontes chamados por este, pois esta rotina eh executada em job, e caso algum registro do cadastro
//esteja em alteracao pelo usuario, o job vai parar aguardando o final da alteracao do usuario, bloqueando toda a execucao do job, o qual eh executado
// para este e demais cadastros e movimentos.
// ******************************
User Function TAS01FilPV(aEmpSel)

Local cQ 		:= ""
Local cEmpSav	:= cEmpAnt
Local cFilSav 	:= cFilAnt
Local cAliasTrb := GetNextAlias()
Local lRet 		:= .F.
Local nRet 		:= 0
Local cIDTaura 	:= GetMV("MGF_IDTSPV",.F.,) // 0000000001
Local cEmpSel   := "'x'"
Local nI		:= 0
Local cFilMafig	:= ""
Local nVezes    := GetMv("MGF_TAUVEZ",,5)
Local cVezes    := ''

Private nI            := 0

// alterado em 16/04/2018 - Paulo Fernandes
// tratamento do job por grupo de filiais
For nI := 1 To Len(aEmpSel)
	cEmpSel += ",'"+aEmpSel[nI]+"'"
Next nI
// fim
/*
C5_ZTAUFLA, flags:
1=enviado com sucesso
2=enviado e rejeitado - Erro
3=enviado e Taura nao usou PV
*/

If Empty(cIDTaura)
	ConOut("Nao encontrado parametro 'MGF_IDTSPV'.")
	Return()
Endif

cIDTaura := Soma1(cIDTaura)
PutMV("MGF_IDTSPV",cIDtaura)

cVezes := "'N',' ','S'"
For nI := 1 To nVezes-1
	cVezes += ",'"+Alltrim(STR(nI))+"'"
Next nI

// flega todos os pedidos selecionados como "em processamento", para que outro job nao pegue o mesmo pedido para processar
cQ := " UPDATE "
cQ += RetSqlName("SC5")+" "
cQ += " SET C5_ZTAUID = '"+cIDTaura+"' "
cQ += " WHERE (C5_ZBLQTAU = 'S' OR C5_ZLIBENV = 'S')" // PV nao enviado ainda ao Taura
cQ += " AND C5_ZTIPPED in ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_ = ' ' AND ( ZJ_TAURA='S' OR ZJ_KEYCONS='S' )) "
cQ += " AND (C5_NOTA = ' ' OR C5_NOTA like 'XXXX%') "
// alterado em 16/04/2018 - Paulo Fernandes
cQ += " AND C5_FILIAL in ("+cEmpSel+") "
cQ += " AND C5_ZTAUREE in ("+cVezes+") "
cQ += "	AND C5_ZTAUINT <> 'N' " // N = nao enviado ao taura, pois o envio deve ser feito on-line pelo fonte mgftas06. O inicializador padrao deste campo eh 'N', apos o envio pelo mgftas06, o campo vai para 'S' e se ocorrer erro no envio da inclusao vai para 'E'. Conteudos possiveis do campo, N/E/S.
cQ += " AND C5_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS011",,30))+"' "
cQ += " AND C5_XRESERV	<>	'N'"

conout("[MGFTAS01] [TAS01FilPV] [1] " + cQ)

nRet := tcSqlExec(cQ)
If nRet == 0
Else
	ConOut("Problemas na gravacao do sem�foro do pedido de venda, para envio ao Taura.")
	conout("[MGFTAS01] [TAS01FilPV] [1] Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
	Return()
EndIf

// FLAG DE INTEGRACAO DE PEDIDOS - USA O MESMO FILTRO - MAS SEM A FLAG C5_XRESERV
cQ := ""
cQ := " UPDATE "
cQ += RetSqlName("SC5")+" "
cQ += " SET C5_XINTEGR = 'P'"
cQ += " WHERE (C5_ZBLQTAU = 'S' OR C5_ZLIBENV = 'S')" // PV nao enviado ainda ao Taura
cQ += " AND C5_ZTIPPED in ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_ = ' ' AND ( ZJ_TAURA='S' OR ZJ_KEYCONS='S' )) "
cQ += " AND (C5_NOTA = ' ' OR C5_NOTA like 'XXXX%') "
// alterado em 16/04/2018 - Paulo Fernandes
cQ += " AND C5_FILIAL in ("+cEmpSel+") "
cQ += " AND C5_ZTAUREE in ("+cVezes+") "
cQ += "	AND C5_ZTAUINT <> 'N' " // N = nao enviado ao taura, pois o envio deve ser feito on-line pelo fonte mgftas06. O inicializador padrao deste campo eh 'N', apos o envio pelo mgftas06, o campo vai para 'S' e se ocorrer erro no envio da inclusao vai para 'E'. Conteudos possiveis do campo, N/E/S.
cQ += " AND C5_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS011",,30))+"' "

conout("[MGFTAS01] [TAS01FilPV] [2] [INICIO]" + cQ)

if tcSQLExec( cQ ) < 0
	ConOut("Problemas na gravacao do sem�foro do pedido de venda, para envio ao Taura.")
	conout("[MGFTAS01] [TAS01FilPV] [2] Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
	Return()
EndIf
cQ := ""

conout("[MGFTAS01] [TAS01FilPV] [2] [FIM]")
// FIM - FLAG DE INTEGRACAO DE PEDIDOS

// processamento de filiais que nao integram taura, mas integram com keyconsult, envio da alteracao do pedido que as vezes nao estah sendo enviada de forma sincrona, entao
// o job terah a funcao de enviar o pedido apos a alteracao
If GetMv("MGF_TAS012",,.T.)
	cQ := " UPDATE "
	cQ += RetSqlName("SC5")+" "
	cQ += " SET C5_ZTAUID = '"+cIDTaura+"' "
	cQ += " WHERE R_E_C_N_O_ IN "
	cQ += " ( "
	cQ += " SELECT SC5.R_E_C_N_O_ "
	cQ += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZV")+" SZV "
	cQ += " WHERE C5_FILIAL IN "+FormatIn(GetMv("MGF_TAS014"),"/")+" "
	cQ += " AND C5_ZTIPPED IN ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_ = ' ' AND (ZJ_TAURA<>'S' AND ZJ_KEYCONS='S') ) "
	cQ += " AND C5_NOTA = ' ' "
	cQ += " AND C5_ZTAUREE in ("+cVezes+") "
	cQ += "	AND C5_ZTAUINT = 'S' " // jah enviado
	cQ += " AND C5_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS013",,3))+"' "
	cQ += " AND SZV.D_E_L_E_T_ = ' ' " // OBS: os registros da sc5 devem ser lidos mesmo deletados, para envio da exclusao do pedido
	cQ += " AND C5_FILIAL = ZV_FILIAL "
	cQ += " AND C5_NUM = ZV_PEDIDO "
	cQ += " AND ZV_CODRGA IN "+FormatIn(GetMv("MGF_TAS015"),"/")+" " // somente pedidos com estes bloqueios
	cQ += " AND ZV_CODAPR = ' ' " // somente pedidos nao aprovados
	cQ += " AND C5_XRESERV	<>	'N'"
	cQ += " ) "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravacao do sem�foro do pedido de venda, para envio ao Taura.")
	EndIf
Endif

cQ := "SELECT SC5.R_E_C_N_O_ SC5_RECNO,C5_FILIAL,C5_NUM,C5_ZTAUFLA,C5_ZTAUINT,C5_LIBEROK,SC5.D_E_L_E_T_ DELET "
cQ += "FROM "+RetSqlName("SC5")+" SC5 "
cQ += "WHERE "
cQ += "C5_ZTAUID = '"+cIDTaura+"' "
// alterado em 16/04/2018 - Paulo Fernandes
cQ += "AND C5_FILIAL in ("+cEmpSel+")"
If GetMv("MGF_TAS012",,.T.)
	cQ += "UNION "
	cQ += "SELECT SC5.R_E_C_N_O_ SC5_RECNO,C5_FILIAL,C5_NUM,C5_ZTAUFLA,C5_ZTAUINT,C5_LIBEROK,SC5.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("SC5")+" SC5 "
	cQ += "WHERE "
	cQ += "C5_ZTAUID = '"+cIDTaura+"' "
	cQ += "AND C5_FILIAL IN "+FormatIn(GetMv("MGF_TAS014"),"/")+" "
Endif
cQ += "ORDER BY C5_FILIAL,C5_NUM "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())
	cEmpAnt := Subs((cAliasTrb)->C5_FILIAL,1,2)
	cFilAnt := Subs((cAliasTrb)->C5_FILIAL,1,6)

	lRet := U_TAS01EnvPV({(cAliasTrb)->C5_NUM,IIf((cAliasTrb)->DELET=="*" .or. SC5->C5_LIBEROK == "Z",3,1),(cAliasTrb)->SC5_RECNO})

	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())

cEmpAnt := cEmpSav
cFilAnt := cFilSav

Return()


// verifica se PV pode sofrer manutencao
User Function TAS01VldMnt(aParam,_lJob)

Local aArea     := {SC5->(GetArea()),GetArea()}
Local cPV       := aParam[1]
Local lRet      := .T.
Local cExcPed   := Alltrim(GetMv("MGF_EXPR"))
Local cUserEco	:= Alltrim(GetMv("MGF_EXUC"))//Usuario que podem excluir Pedidos do Ecommerce
Local cTiPPEco	:= Alltrim(GetMv("MGF_TPPED"))//Tipo de Pedido Ecommerce
Local cUserAlt  := RetCodUsr()
Local cBloqueio	:= ""

Default _lJob	:= .F.

If _lJob
	Inclui 	:= .F.
 	Altera	:= .F.
EndIf
If cModulo == "EEC"
	Return(.T.)
Endif

If IsInCallStack("A410Copia")
	Return(.T.)
Endif

If SC5->C5_NUM != cPV
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+cPV))
	If SC5->(!Found())
		lRet := .F.
		cBloqueio	:= "Pedido nao encontrado."
		APMsgAlert(cBloqueio)
	Endif
Endif

If lRet
	If SC5->C5_ZTAUSEM == "S"
		lRet := .F.
		cBloqueio	:= "Pedido nao podera sofrer manutencao agora, pois esta sendo enviado para o Taura. Aguarde o envio."
		APMsgAlert(cBloqueio)
	Endif
Endif
If lRet
	If SC5->C5_ZROAD == "S"
		IF !INCLUI .and. !ALTERA .and. !_lJob
			IF !( cUserAlt $ cExcPed)
				cBloqueio	:= "Pedido j� roterizado, nao � possivel excluir."
				APMsgAlert(cBloqueio)
			EndIF
		Else
			lRet := .F.
			cBloqueio	:= "Pedido j� roterizado, nao � possivel alterar."
			APMsgAlert(cBloqueio)
		Endif
	EndIF

	If (SC5->C5_ZTIPPED $ cTiPPEco) .and. lRet
		IF !INCLUI .and. !ALTERA .and. _lJob //Exclusao
			IF !( cUserAlt $ cUserEco)
				lRet := .F.
				cBloqueio	:= "Pedido do Ecommerce, nao � possivel excluir."
				APMsgAlert(cBloqueio)
			EndIF
		ElseIf ALTERA .Or. _lJob  //Alteracao
			IF !( cUserAlt $ cUserEco)
				lRet := .F.
				cBloqueio	:= "Pedido do Ecommerce, nao � possivel alterar."
				APMsgAlert(cBloqueio)
			EndIf
		Endif
	EndIF
Endif

If lRet
	If !Empty(SC5->C5_NOTA)
		lRet := .F.
		cBloqueio	:= "Pedido j� Faturado, nao � possivel alterar."
		APMsgAlert(cBloqueio)
	Endif
Endif

If _lJob
	Return({lRet,cBloqueio})
EndIf

Return(lRet)


// rotina chamada pelo ponto de entrada MT410CPY
User Function TAS01Cpy()
Local aPar := {"MGF_PVCPY"} // se precisar de mais de 1 parametro, criar os parametros com o seguinte nome MGF_PVCPY1, MGF_PVCPY2, MGF_PVCPY3, etc
Local nCnt := 0
Local cCampos := ""
Local aCampos := {}
Local aCamposSC5 := {}
Local aCamposSC6 := {}
Local nCntCampos := 0
Local cSC6 := ""
Local bSC6 := Nil

Local aArea        := GetArea()
Local nPosProd     := GdFieldPos("C6_PRODUTO")
Local nLinAtu      := 0

For nCnt := 1 To 5 // ate 5 parametros "MGF_PVCPY"
	cCampos := GetMv(aPar[1]+Alltrim(Str(nCnt)),.F.,"") // nao mostra tela se nao encontrar o parametro
	If !Empty(cCampos)
		aCampos := StrToKArr(cCampos,"/")
		For nCntCampos := 1 To Len(aCampos)
			If Subs(aCampos[nCntCampos],1,2) == "C5"
				If SC5->(FieldPos(aCampos[nCntCampos])) > 0
					If aScan(aCamposSC5,aCampos[nCntCampos]) == 0
						aAdd(aCamposSC5,aCampos[nCntCampos])
					Endif
				Endif
			Endif
			If Subs(aCampos[nCntCampos],1,2) == "C6"
				If SC6->(FieldPos(aCampos[nCntCampos])) > 0
					If aScan(aCamposSC6,aCampos[nCntCampos]) == 0
						aAdd(aCamposSC6,aCampos[nCntCampos])
					Endif
				Endif
		  	Endif
		Next
	Endif
Next

// zera campos sc5
For nCnt := 1 To Len(aCamposSC5)
	&("M->"+aCamposSC5[nCnt]) := CriaVar(aCamposSC5[nCnt])
Next

// zera campos sc6
For nCnt := 1 To Len(aCamposSC6)
	cSC6 += IIf(Empty(cSC6),"",",")+"x[aScan(aHeader,{|x| Alltrim(x[2])=='"+aCamposSC6[nCnt]+"'})]:=CriaVar('"+aCamposSC6[nCnt]+"') "
Next
If !Empty(cSC6)
	bSC6 := 'aEval(aCols,{|x| IIf(!x[Len(x)],('+cSC6+'),Nil)})'
	&(bSC6)
Endif

//Se encontrar o campo na grid, sobrep�e o valor
If nPosProd > 0
	//Percorrendo linhas da grid
    For nLinAtu := 1 To Len(aCols)
    	n := nLinAtu // variavel publica que indica a linha posicionada
        // verifica se h� trigger e executa, caso exista
        If ExistTrigger("C6_PRODUTO")
        	//RunTrigger(2,n,nil,,C6_PRODUTO)
			RunTrigger(2,Len(aCols),,"C6_PRODUTO")
        Endif
    Next nLinAtu
Endif

RestArea(aArea)
Return()



// rotina chamada pelo ponto de entrada M410AGRV
User Function TAS01M410AGRV(ParamIxb)

Local lRet := .F.

// envia exclusao do PV para o Taura
If ParamIxb[1] == 3 // exclusao
	dbSelectArea('SZJ')
	SZJ->(dbSetOrder(1))
	IF SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
		IF SZJ->ZJ_TAURA == 'S'
			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZBLQTAU := "S"
			SC5->(MsUnLock())
		EndIF
	EndIF
Endif

Return()


// rotina chamada pelo ponto de entrada MTA500FIL
User Function TAS01RESFIL()

Local cFil := ""

cFil := " C5_ZTAUFLA = '3' " // somente gera residuo de PV enviado ao Taura e nao aproveitado no Taura

Return(cFil)


// rotina chamada pelo ponto de entrada M410STTS
User Function TAS01STTSM410()

// se estiver alterando um PV, flag para reenviar o PV
If IsInCallStack('A410ALTERA') .and. SC5->C5_ZTAUFLA != "3" //.and. !Empty(SC5->C5_ZTAUINT)
	SC5->(RecLock("SC5",.F.))
	SC5->C5_ZTAUREE := "N"
	SC5->(MsUnLock())
Endif

Return()


// rotina para carregar os itens do pv usando query, para nao usar seek na tabela, pois eh necessario carregar itens deletados tb
// sc5 estah posicionado e pode estar deletado
Static Function ItensSC6(cStatus)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local aRecno := {}

cQ := "SELECT SC6.R_E_C_N_O_ SC6_RECNO "
cQ += "FROM "+RetSqlName("SC6")+" SC6 "
cQ += "WHERE "
If cStatus != "3"
	cQ += "SC6.D_E_L_E_T_ <> '*' "
Else
	cQ += "SC6.D_E_L_E_T_ = '*' "
Endif
cQ += "AND C6_FILIAL = '"+SC5->C5_FILIAL+"' "
cQ += "AND C6_NUM = '"+SC5->C5_NUM+"' "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())
	aAdd(aRecno,(cAliasTrb)->SC6_RECNO)
	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return(aRecno)


// avalia se pedido tem alguma regra de bloqueio do keyconsult
Static Function AvalRgaKey(cPed)

Local aArea := {GetArea()}
Local lRet := .F.
Local cAliasTrb := GetNextAlias()
Local cQ := ""

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SZV")+" SZV "
cQ += "WHERE SZV.D_E_L_E_T_ = ' ' "
cQ += "AND ZV_FILIAL = '"+xFilial("SZV")+"' "
cQ += "AND ZV_PEDIDO = '"+cPed+"' "
cQ += "AND ZV_CODRGA IN "+FormatIn(GetMv("MGF_TAS015"),"/")+" " // somente pedidos com estes bloqueios
cQ += "AND ZV_CODAPR = ' ' " // somente pedidos nao aprovados

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())
aEval(aArea,{|x| RestArea(x)})

Return(lRet)

Class GravarPedidoVenda

Data Acao					as String
Data Filial					as String
Data Pedido					as String
Data TipoPedidoERP			as String
Data TipoPedido	   			as String
Data Cliente				as String
Data ClienteLoja			as String
Data DataEmissao			as String
Data DataEmbarque			as String
Data DataEntrega			as String
Data Status					as String
Data TipoFrete				as String
Data Observacao				as String
Data CodigoBarras			as String
Data EnderecoEntrega		as String
Data PedidoCliente			as String
Data ApplicationArea		as ApplicationArea
Data Documento				as String
Data Inscricao_Estadual		as String
Data UF						as String
Data Data_Nascimento		as String
Data Inscricao_Suframa		as String
Data Validade_Suframa		as String
Data Consulta_Hab			as String
Data Taura					as String
Data Produtor_Rural			as String

Data Itens					as Array

Method New()
Method GravarPVCab()
Method GravarPVItens()

//Return
EndClass


Method New() Class GravarPedidoVenda

	::ApplicationArea := ApplicationArea():New()

Return


Method GravarPVCab(cStatus) Class GravarPedidoVenda

	Local cStringTime := "T00:00:00"
	Local cCliente := ""
	Local cLoja := ""

	If SC5->C5_TIPO $ ("D/B")
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA2->A2_ZCODMGF)
				cCliente := SA2->A2_ZCODMGF
			Else
				cCliente := SA2->A2_COD
				cLoja := SA2->A2_LOJA
			Endif
			::Documento := SA2->A2_CGC
			::Inscricao_Estadual := SA2->A2_INSCR
			::UF := SA2->A2_EST
			::Data_Nascimento := IIf(!Empty(SA2->A2_DTNASC),Subs(dTos(SA2->A2_DTNASC),1,4)+"-"+Subs(dTos(SA2->A2_DTNASC),5,2)+"-"+Subs(dTos(SA2->A2_DTNASC),7,2)+cStringTime,"")
			::Inscricao_Suframa := ""
			::Validade_Suframa := ""
		Endif
	Else
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			If !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
				cCliente := SA1->A1_ZCODMGF
			Else
				cCliente := SA1->A1_COD
				cLoja := SA1->A1_LOJA
			Endif
			::Documento          := SA1->A1_CGC
			::Inscricao_Estadual := SA1->A1_INSCR
			::UF                 := SA1->A1_EST
			::Data_Nascimento    := IIf(!Empty(SA1->A1_DTNASC),Subs(dTos(SA1->A1_DTNASC),1,4)+"-"+Subs(dTos(SA1->A1_DTNASC),5,2)+"-"+Subs(dTos(SA1->A1_DTNASC),7,2)+cStringTime,IIf(!Empty(SA1->A1_DTCAD),Subs(dTos(SA1->A1_DTCAD),1,4)+"-"+Subs(dTos(SA1->A1_DTCAD),5,2)+"-"+Subs(dTos(SA1->A1_DTCAD),7,2)+cStringTime,""))
			::Inscricao_Suframa  := SA1->A1_SUFRAMA
			::Validade_Suframa   := IIf(SA1->(FieldPos("A1_ZSUFVLD"))>0 .and. !Empty(SA1->A1_ZSUFVLD),Subs(dTos(SA1->A1_ZSUFVLD),1,4)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),5,2)+"-"+Subs(dTos(SA1->A1_ZSUFVLD),7,2)+cStringTime,"")
		Endif
	Endif

	//A. Carlos - Incuido chamada funcao para converter memo em caracter
	if SC5->C5_ZTIPPED == "EX"
		cObs := allTrim( SC5->C5_ZOBSND ) + " -- " + allTrim( SC5->C5_ZOBS )
	else
	   cObs := allTrim( SC5->C5_ZOBS ) + " -- " + allTrim( SC5->C5_XOBSPED )
	endif

	::Acao            := IIf(SC5->(Deleted()) .or. SC5->C5_LIBEROK == "Z","3",IIf(SC5->C5_ZTAUINT=="S","2","1")) //'1' //cStatus
	::Filial 		  := SC5->C5_FILIAL
	::Pedido 		  := Alltrim(SC5->C5_NUM)
	::TipoPedidoERP   := Alltrim(SC5->C5_TIPO) //"VE"
	::TipoPedido 	  := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,"")) //"VE"
	::Cliente 		  := Alltrim(cCliente)
	::ClienteLoja 	  := Alltrim(cLoja)
	::DataEmissao 	  := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
	::DataEmbarque 	  := IIf(!Empty(SC5->C5_ZDTEMBA),Subs(dTos(SC5->C5_ZDTEMBA),1,4)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),5,2)+"-"+Subs(dTos(SC5->C5_ZDTEMBA),7,2)+cStringTime,"")
	::DataEntrega 	  := IIf(!Empty(SC5->C5_FECENT),Subs(dTos(SC5->C5_FECENT),1,4)+"-"+Subs(dTos(SC5->C5_FECENT),5,2)+"-"+Subs(dTos(SC5->C5_FECENT),7,2)+cStringTime,"")
	::Status 		  := IIf(!Empty(SC5->C5_PEDEXP),"N",IIf(SC5->C5_ZBLQRGA=="B","B","N")) // B=bloqueado,N=Liberado
	::TipoFrete 	  := SC5->C5_TPFRETE //IIf(SC5->C5_TPFRETE=="C","1",IIf(SC5->C5_TPFRETE=="F","2",IIf(SC5->C5_TPFRETE=="T","3","")))
	::Observacao 	  := Alltrim(cObs)   //era Alltrim(SC5->C5_ZOBS))
	::CodigoBarras 	  := Alltrim(SC5->C5_ZCODBAR)
	::EnderecoEntrega := cCliente+IIf(Empty(SC5->C5_ZIDEND),"0",Alltrim(Str(Val(SC5->C5_ZIDEND)))) //Alltrim(IIf(SC5->(FieldPos("C5_ZIDEND"))>0,IIf(Empty(SC5->C5_ZIDEND),"0",SC5->C5_ZIDEND),"0"))
	::PedidoCliente   := Alltrim(SC5->C5_ZPEDCLI)
	::Consulta_Hab 	  := IIf((GetMv("MGF_TAS012",,.T.) .and. SC5->C5_FILIAL $ GetMv("MGF_TAS014") .and. !Empty(GetMv("MGF_TAS015")) .and. GetAdvFVal("SZJ","ZJ_KEYCONS",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")=="S" .and. AvalRgaKey(SC5->C5_NUM)),"S",SC5->C5_ZCONFIS)
	::Taura			  := IIf(GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+SC5->C5_ZTIPPED,1,"")=="S","S","N")
	::Produtor_Rural  := IIf(SC5->C5_TIPOCLI=="L","S","N")

	::Itens	:= {}

Return()


Class ItensPV

Data Filial					as String
Data Pedido					as String
Data Item					as String
Data Produto				as String
Data UnidadeMedida			as String
Data QuantidadeKGVenda		as Float
Data PrecoVenda				as Float
Data QuantidadeCaixa		as Float
Data DataProducaoMinima		as String
Data DataProducaoMaxima		as String
Data DataPedido				as String
Data TipoPedido				as String
Data QuantidadeVolumes		as Integer
Data Observacao				as String

Method New()

Return


Method New() Class ItensPV

Local cStringTime := "T00:00:00"
Local cDtMin      := ''
Local cDtMax      := ''

::Filial := SC6->C6_FILIAL
::Pedido := Alltrim(SC6->C6_NUM)
::Item := SC6->C6_ITEM
::Produto := Alltrim(SC6->C6_PRODUTO)
::UnidadeMedida := Alltrim(SC6->C6_UM)
::QuantidadeKGVenda := SC6->C6_QTDVEN
::PrecoVenda := SC6->C6_PRCVEN
::QuantidadeCaixa := SC6->C6_ZQTDPEC
IF (SC6->C6_ZDTMIN  > dDataBase - 10000) .OR. (SC6->C6_ZDTMAX  <= dDataBase + 9000)
	//So preenche se tiver data valida
	If !(empty(alltrim(dTos(SC6->C6_ZDTMIN))))
		cDtMin      := Subs(dTos(SC6->C6_ZDTMIN),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMIN),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMIN),7,2)+cStringTime
	Endif
	If !(empty(alltrim(dTos(SC6->C6_ZDTMAX))))
		cDtMax      := Subs(dTos(SC6->C6_ZDTMAX),1,4)+"-"+Subs(dTos(SC6->C6_ZDTMAX),5,2)+"-"+Subs(dTos(SC6->C6_ZDTMAX),7,2)+cStringTime
	Endif
EndIF
::DataProducaoMinima := cDtMin
::DataProducaoMaxima := cDtMax
::DataPedido := IIf(!Empty(SC5->C5_EMISSAO),Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)+cStringTime,"")
::TipoPedido := Alltrim(IIf(SC5->(FieldPos("C5_ZTIPPED"))>0,SC5->C5_ZTIPPED,"")) //"VE"
::QuantidadeVolumes := SC6->C6_ZVOLUME
::Observacao := Alltrim(cObs)     //era Alltrim(SC5->C5_ZOBS)

Return()


Method GravarPVItens(oItens) Class GravarPedidoVenda

aAdd(::Itens,oItens)

Return()
