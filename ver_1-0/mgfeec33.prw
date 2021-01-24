#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MGFEEC33
//TODO Distribuição de EXP
@author leonardo.kume
@since 05/10/2017
@version 6

@type function
/*/
User function MGFEEC33()

	Local aOldRot := iif(Type("aRotina")<>"U",aRotina,{})
	Local aArea := ZB8->(GetArea())
	Local cQuery := " UPDATE "+RetSqlName("ZB8")+" SET ZB8_MARK = ' ' WHERE ZB8_MARK <> ' ' "

	Private oMBrowse := nil
	If Type("aRotina")<>"U"
		aRotina := {}
	EndIf

	TCSQLEXEC(cQuery)


	DbSelectArea("ZB8")
	ZB8->(DbSetOrder(3))
	ZB8->(DbGoTop())
	oMBrowse:= FWMarkBrowse():New()
	oMBrowse:SetAlias("ZB8")
	oMBrowse:SetDescription('EXP')
	oMBrowse:SetFieldMark( 'ZB8_MARK' )
	oMBrowse:AddLegend("ZB8_MOTEXP = '1' ","YELLOW" ,'Aguardando Distribuição')
	oMBrowse:AddLegend("ZB8_MOTEXP = '5' ","WHITE"  ,'EXP Parcialmente Distribuida')
	oMBrowse:AddLegend("ZB8_MOTEXP = '6' ","GRAY"   ,'EXP Distribuida')
	oMBrowse:AddLegend("ZB8_MOTEXP = '4' ","BLUE"   ,'Pedido de Venda Parcialmente Gerado')
	oMBrowse:AddLegend("ZB8_MOTEXP = '2' ","GREEN"  ,'Pedido de Venda Gerado')
	oMBrowse:AddLegend("ZB8_MOTEXP = '3' ","RED"    ,'EXP Cancelada')
	If IsInCallStack("u_MGFEEC19")
		oMBrowse:SetFilterDefault("ZB8_MOTEXP $ '1/4/5/6' .AND. ZB8_FILIAL == '" + ZZC->ZZC_FILIAL +  "' .and. ZB8_ORCAME == '" + ZZC->ZZC_ORCAME + "' ")
	Else
		oMBrowse:SetFilterDefault("ZB8_MOTEXP $ '1/4/5/6'")
	EndIf
	oMBrowse:SetMenuDef("MGFEEC33")
	oMBrowse:bAllMark := {|| InverteBrw( oMBrowse ) }
	oMBrowse:Activate()

	if Type("aRotina")<>"U
		aRotina := aOldRot
	EndIf
	ZB8->(RestArea(aArea))

Return

Static Function InverteBrw(oMBrowse)

	Local lRet	:= .T.		   								// Retorno da rotina.
	Local aAreaTmp	:= (oMBrowse:Alias())->(GetArea())		// Guarda a area do browse.
	Local lGoTop 	:= .T.										// Posiciona no primeiro registro.

	(oMBrowse:Alias())->(DbGoTop())

	While (oMBrowse:Alias())->(!Eof())
		If ( !oMBrowse:IsMark() )
			RecLock(oMBrowse:Alias(),.F.)
			(oMBrowse:Alias())->ZB8_MARK  := oMBrowse:Mark()
			(oMBrowse:Alias())->(MsUnLock())
		Else
			RecLock(oMBrowse:Alias(),.F.)
			(oMBrowse:Alias())->ZB8_MARK  := ""
			(oMBrowse:Alias())->(MsUnLock())
		EndIf
		(oMBrowse:Alias())->(DbSkip())
	EndDo

	RestArea(aAreaTmp)
	oMBrowse:Refresh(lGoTop)

Return( lRet )

Static function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Distribuir"	ACTION "U_M33Distr" 	  		OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.MGFEEC33' 	OPERATION 2 ACCESS 0

Return(aRotina)

Static function ModelDef()

	Local oStruZB8 := FWFormStruct( 1, 'ZB8')
	Local oStruZB9 := FWFormStruct( 1, 'ZB9')

	Local oModel := nil

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XMGFEEC33', /*bPreValidacao*/, /*bPosValidacao*/{|oModel|xVldMdl(oModel)}, {|oModel|xCommit(oModel)}/*bCommit*/, /*bCancel*/)

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields('ZB8MASTER', /*cOwner*/, oStruZB8, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	oModel:AddGrid("ZB9DETAIL","ZB8MASTER",oStruZB9,/*bLinePreValid*/,/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/)

	oModel:SetRelation("ZB9DETAIL",{ {"ZB9_FILIAL","xFilial('ZB9')"},{"ZB9_EXP", "ZB8_EXP"}, {"ZB9_ANOEXP","ZB8_ANOEXP"} , {"ZB9_SUBEXP","ZB8_SUBEXP"} },ZB9->(IndexKey(2)))

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZB8MASTER' ):SetDescription( 'EXP' )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"ZB8_FILIAL","ZB8_EXP"})

	oModel:AddCalc("EEC24CALC", "ZB8MASTER", "ZB9DETAIL", "ZB9_PRCINC", "ZB9__TOTSD", "SUM", {||.T.}, ,"Total Itens")
	oModel:AddCalc("EEC24CALC", "ZB8MASTER", "ZB9DETAIL", "ZB9_PRCINC", "ZB9__TOTFS", "FORMULA", {||.T.},,"Total + Seguro + Frete",{|oModel| U_MGF24TRG(oModel,.f.) })
Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author leonardo.kume
@since 05/10/2017
@version 6

@type function
/*/
Static function ViewDef()

	Local oModel 	:= FwLoadModel('MGFEEC33')
	Local oView 	:= nil
	Local oStrZB8 	:= FWFormStruct( 2, "ZB8" )
	Local oStrZB9 	:= FWFormStruct( 2, "ZB9" )
	Local oCalc1	:= oCalc1 := FWCalcStruct( oModel:GetModel( 'EEC24CALC') )

	Local ni		:= 0
	Local nPos		:= 5

	Local aFldZB8 := oStrZB8:GetFields()
	Local cFld	  := ""
	Local cFlsPos := "01"

	oStrZB8:SetProperty( 'ZB8_EXP' 	  , MVC_VIEW_ORDEM,'001')
	oStrZB8:SetProperty( 'ZB8_ANOEXP' , MVC_VIEW_ORDEM,'002')
	oStrZB8:SetProperty( 'ZB8_SUBEXP' , MVC_VIEW_ORDEM,'003')
	oStrZB8:SetProperty( 'ZB8_ORCAME' , MVC_VIEW_ORDEM,'004')
	oStrZB8:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)

	For ni := 1 To Len(aFldZB8)
		cFld := Alltrim(aFldZB8[ni,1])
		If !(cFld $ "ZB8_EXP|ZB8_ANOEXP|ZB8_SUBEXP|ZB8_ORCAME" )
			cFlsPos := StrZero(nPos,3)
			oStrZB8:SetProperty( cFld , MVC_VIEW_ORDEM , cFlsPos )
			nPos++
		EndIf
	Next ni

	oStrZB9:RemoveField("ZB9_EXP")
	oStrZB9:RemoveField("ZB9_ANOEXP")
	oStrZB9:RemoveField("ZB9_SUBEXP")
	oStrZB9:RemoveField("ZB9_ORCAME")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZB8' , oStrZB8, 'ZB8MASTER' )
	oView:AddGrid( 'VIEW_ZB9' , oStrZB9, 'ZB9DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'EEC24CALC' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 60 )
	oView:CreateHorizontalBox( 'INFERIOR' , 30 )
	oView:CreateHorizontalBox( 'CALC' , 10 )

	oView:SetOwnerView( 'VIEW_ZB8', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZB9', 'INFERIOR' )
	oView:SetOwnerView( 'VIEW_CALC', 'CALC' )

	oView:AddIncrementField( 'VIEW_ZB9', 'ZB9_SEQUEN' )

return oView


/*/{Protheus.doc} M33Distr
//TODO Distribuição de Registros
@author leonardo.kume
@since 05/10/2017
@version 6

@type function
/*/
User Function M33Distr()

	Local cPerg := "MGFEEC33"
	Local aAreaZB8 := ZB8->(GetArea())
	Local aAreaZB9 := ZB9->(GetArea())
	Local lPedido := .f.
	Local cExps := ""
	Local cAliasZBY := GetNextAlias()

	DbSelectArea("ZB9")
	ZB9->(DbSetOrder(2))

	If Pergunte(cPerg,.t.)
		
		// RTASK0011709 - Inicio
        _cSemana := RETSEM(dDataBase)
        _cYear   := Year2Str(dDataBase)
                
        IF 		MV_PAR04 == 1
            	_cAnoSem 	:= '2020'
            	_cSemdoAno  := SUBS(RETSEM(CTOD('31/12/'+_cAnoSem+"'") ),8,2)
        ELSEIF 	MV_PAR04 == 2
            	_cAnoSem 	:= '2021'
            	_cSemdoAno  := SUBS(RETSEM(CTOD('31/12/'+_cAnoSem+"'") ),8,2)
        ELSEIF 	MV_PAR04 == 3
            	_cAnoSem 	:= '2022'
            	_cSemdoAno  := SUBS(RETSEM(CTOD('31/12/'+_cAnoSem+"'") ),8,2)
        ELSEIF 	MV_PAR04 == 4                     
            	_cAnoSem 	:= '2023
            	_cSemdoAno  := SUBS(RETSEM(CTOD('31/12/'+_cAnoSem+"'") ),8,2)
        ELSEIF 	MV_PAR04 == 5
            	_cAnoSem 	:= '2024'
            	_cSemdoAno  := SUBS(RETSEM(CTOD('31/12/'+_cAnoSem+"'") ),8,2)
        ENDIF
                               
        _dDiaIniAno := CTOD('01/01/'+_cAnoSem+"'")
                               
		IF      DOW(_dDiaIniAno) == 1     //DOMINGO
                _dDiaIniAno := _dDiaIniAno
        ELSEIF 	DOW(_dDiaIniAno) == 2 //SEGUNDA
               	_dDiaIniAno := _dDiaIniAno - 1
        ELSEIF 	DOW(_dDiaIniAno) == 3 //TERÇA
               	_dDiaIniAno := _dDiaIniAno - 2
        ELSEIF 	DOW(_dDiaIniAno) == 4 //QUARTA
               	_dDiaIniAno := _dDiaIniAno - 3
        ELSEIF 	DOW(_dDiaIniAno) == 5 //QUINTA
               	_dDiaIniAno := _dDiaIniAno - 4
        ELSEIF 	DOW(_dDiaIniAno) == 6 //SEXTA
               	_dDiaIniAno := _dDiaIniAno- 5 
        ELSEIF 	DOW(_dDiaIniAno) == 7 //SABADO
               	_dDiaIniAno := _dDiaIniAno - 6
        ENDIF
                               
        If MV_PAR03 <= Subs(_cSemana,8,2) .And. _cAnoSem <= Subs(_cSemana,16,4) 
            If Subs(_cSemana,8,2)!=alltrim(str(_cSemdoAno))  //Se semana atual for igual ao total de semanas no ano
                Help(NIL, NIL, "Validacao Semana WEEK", NIL, "Semana WEEK informada [ "+MV_PAR03+" ] esta menor ou igual a semana em vigor. Hoje e dia "+DTOC(ddatabase)+" que corresponde a semana "+subs(_cSemana,8,2)+"/"+subs(_csemana,16,4), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Na presente data sera aceito informar neste campo, a semana acima de "+subs(_cSemana,8,2)+"/"+subs(_cSemana,16,4)+"." })
                lRet := .F.
                Return lRet
            EndIf
        EndIf
/*
        If ( MV_PAR03 > Subs(_cSemana,8,2)) .And.  _cAnoSem > Subs(_cSemana,16,4) 
            Help(NIL, NIL, "Validacao do Ano Semana WEEK", NIL, "Ano da Semana WEEK informada esta maior que o ano da semana em vigor.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"O ano deve ser o mesmo da presente data."})
            lRet := .F.
            Return lRet
        EndIf
*/                           
        If MV_PAR03 > ALLTRIM(_cSemdoAno)
            Help(NIL, NIL, "Validacao Semana Maxima WEEK", NIL, "Semana WEEK informada [ "+MV_PAR03+" ] esta maior do que o valor maximo permitido [ "+ALLTRIM(STR(_cSemdoAno))+" ]", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe uma semana valida." })
            lRet := .F.
            Return lRet
        EndIf
                               
        If _cAnoSem < Subs(_cSemana,16,4) 
            Help(NIL, NIL, "Validacao do Ano Semana WEEK", NIL, "Ano da Semana WEEK informada esta maior que o ano da semana em vigor.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"O ano deve ser o mesmo da presente data."})
            lRet := .F.
            Return lRet
        Endif
                               
        _dDiaIniSem := _dDiaIniAno + ( 7 * (VAL(MV_PAR03)-1) )
        _dDtEstuf   := _dDiaIniSem + 5  // resultado final

		// RTASK0011709 - Fim
	
		ZB8->(DbGoTop())
		While !ZB8->(Eof())
			If ZB8->ZB8_MARK == oMBrowse:Mark()
				lPedido := .F.
				If ZB9->(DbSeek(xFilial("ZB9")+ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
					While !ZB9->(Eof()) .AND. ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP) == ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP)
						If Empty(Alltrim(ZB9->ZB9_ZPEDID))
							Reclock("ZB9",.F.)
								ZB9->ZB9_FILVEN := mv_par01
								ZB9->ZB9_FILENT := mv_par01
							ZB9->(MsUnlock())
						Else
							lPedido := .T.
						EndIf
						ZB9->(DbSkip())
					EndDo
				EndIf
				cExps += "<LI>"+ZB8->(ZB8_EXP+"-"+ZB8_ANOEXP+IIF(!Empty(alltrim(ZB8_SUBEXP)),"/"+ZB8_SUBEXP,""))
				cExps +=  IIF(lPedido,"(Somente para itens que não tem pedido gerado)","")
				cExps +=  CRLF
				RecLock("ZB8",.F.)
				ZB8->ZB8_FILVEN := Mv_Par01
				//RTASK0011709-INICIO
				ZB8->ZB8_ZDTEST := _dDtEstuf  
				ZB8->ZB8_XWEEKP := MV_PAR03
				ZB8->ZB8_XANOWE := _cAnoSem
				//RTASK0011709-FIM
				ZB8->ZB8_MARK   := " "
				ZB8->ZB8_NOMFIL := U_fVldNfil(Mv_Par01) // Paulo da Mata - 02/07/2020 - RTASK0011075 - Salva o nome da filial
				If !lPedido
					ZB8->ZB8_MOTEXP := '6'
				EndIf
				ZB8->(MsUnlock())
				// Paulo da Mata - 07/07/2020 - Envia o Json para o Taura através da Distribuição
				U_FM33EXPT()
			EndIf
			ZB8->(DbSkip())
		EndDo

		ApMsgInfo( cExps, 'Exp(s) distribuídas:' )

		If Select(cAliasZBY)
			(cAliasZBY)->(DbCloseArea())
		EndIf

		BeginSql Alias cAliasZBY

		SELECT  ZBY.ZBY_FILIAL,
				ZBY.ZBY_APROVA
		FROM %Table:ZBX% ZBX
		INNER JOIN %Table:ZBY% ZBY
		ON  ZBY.%notDel% AND
			ZBY.ZBY_FILIAL = ZBX.ZBX_FILIAL AND
			ZBY.ZBY_NIVEL = ZBX.ZBX_NIVEL
		WHERE  	ZBX.%notDel% AND
				ZBX.ZBX_FILIAL = %Exp:mv_par01% AND
				ZBX.ZBX_DNIVEL LIKE '%LOCAL%'
		ORDER BY ZBY.ZBY_FILIAL, ZBY.ZBY_APROVA
		EndSql
		While !(cAliasZBY)->(Eof())
			EnvAprov(Alltrim(UsrFullName((cAliasZBY)->ZBY_APROVA)),Alltrim(UsrRetMail((cAliasZBY)->ZBY_APROVA)),cExps,mv_par02)
			(cAliasZBY)->(DbSkip())
		EndDo
	EndIf
	ZB9->(RestArea(aAreaZB9))
	ZB8->(RestArea(aAreaZB8))
Return


Static Function EnvAprov(_cNome,_cEmail,_cListOrc,_cObserv)
	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail

	//_cEmail	:= "leonardo.kume@totvs.com.br"

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//		Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := alltrim(_cEmail)
	oMessage:cCc                    := ""
	oMessage:cSubject               := "Distribuição de EXP"

		oMessage:cBody := "<HTML><BODY><P>Sr.(a) "+alltrim(_cNome)+ ","+CRLF+"As seguintes EXPS foram distribuídas para sua unidade: </P>"
		oMessage:cBody += CRLF+"<P><UL>"+alltrim(_cListOrc)+"</UL></P>"
		oMessage:cBody += CRLF+CRLF+"<P>"+alltrim(_cObserv)+"</P>"
		oMessage:cBody += "</BODY></HTML>"

	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()


Return lRetMail

User Function Valid33(cParam)

	Local lRet := !Empty(Alltrim(cParam)) .AND. EXISTCPO("SM0","01"+cParam) .AND. Substr(cParam,1,2) == Substr(cFilAnt,1,2)

	If !lRet
		ApMsgInfo('Filial '+ cParam + ' não é válida.'+CRLF+'	- Filial deve existir'+CRLF+'	- Filial deve pertencer a mesma empresa', 'Filial inválida' )
	EndIf

Return lRet

/*/{Protheus.doc} fVldNfil
//TODO Gatilho para preencher o nome da filial
@author Paulo da Mata
@since 15/06/2020
@version  

@type function
/*/

User function fVldNfil(cCodFil)

	Local cNomFil   := ""
	Local cQuery    := ""

	If !Empty(AllTrim(cCodFil))

	   cQuery := "SELECT * FROM SYS_COMPANY "
	   cQuery += "WHERE D_E_L_E_T_= ' ' " 
	   cQuery += "AND M0_CODFIL = '" +cCodFil+ "' "
	    
	   cQuery := ChangeQuery(cQuery)

	   dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	   cNomFil := TRB->M0_FILIAL
	
	EndIf

	TRB->(dbCloseArea())

Return cNomFil

/*/{Protheus.doc} FM33EXPT
//TODO Envia dados da EXP para o TAURA
@author Paulo da Mata
@since 07/05/2020
@version 1

@type function
/*/
User Function FM33EXPT()

	Local cWayUrl	 := SuperGetMV("MGF_E24URL",,"http://integracoes.marfrig.com.br:1451/processo-exportacao/api/v1/empresa/")
	Local cUrl 		 := AllTrim(AllTrim(cWayUrl)+AllTrim(ZB8->ZB8_FILVEN)+"/exp/"+ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)) 
	Local cMsgErro	 := ""
	Local cHeadRet 	 := ""
	Local aHeadOut	 := {}

	Local cJson		 := ""
	Local oJson		 := Nil
	Local xPostRet	 := Nil
	Local oDetRet 	 := nil
    Local nTimeOut	 := 120
	Local cTimeIni	 := ""
	Local cTimeProc	 := ""
	Local nStatuHttp := 0

	// Variáveis para gravação do mointor de integração
	Local cCdIntEx   := SuperGetMV("MGF_EEC24F",,"001")
	Local cCdTipEx   := SuperGetMV("MGF_EEC24G",,"019")
	
	Local cChave 	 := ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
	Local cCdLxi     := Posicione("SA1",1,xFilial("SA1")+ZB8->(ZB8_IMPORT+ZB8_IMLOJA),"A1_ZCODMGF")
	Local cCdLxt     := Posicione("SA1",1,xFilial("SA1")+ZB8->(ZB8_ZCLIET+ZB8_ZLJAET),"A1_ZCODMGF")

	If 		Empty(ZB8->ZB8_FILVEN)
	   		ApMsgAlert(OemToAnsi("O campo [FILIAL PEDID] está vazio. Para este processo, ele deve estar preeenchido"),OemToAnsi("ATENÇÃO"))
	   		Return
	ElseIf 	ZB8->ZB8_MOTEXP $ "2/3/7"
	   		ApMsgAlert(OemToAnsi("exportação já processada, em faturamento ou cancelada."),OemToAnsi("ATENÇÃO"))
	   		Return
	EndIf

	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'Accept-Charset: utf-8' )
	
	oJson							:= JsonObject():new()

	oJson['numExp']					:= AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
	oJson['dataCriacao']			:= AllTrim(SubStr(DtoS(Date()),1,4)+"-"+SubStr(DtoS(Date()),5,2)+"-"+SubStr(DtoS(Date()),7,2))
	oJson['numExp']					:= AllTrim(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
	oJson['idCliente']				:= If(Empty(cCdLxt),AllTrim(ZB8->(ZB8_ZCLIET+"|"+ZB8_ZLJAET)),cCdLxt)
	oJson['idImportador']			:= If(Empty(cCdLxi),AllTrim(ZB8->(ZB8_IMPORT+"|"+ZB8_IMLOJA)),cCdLxi)
	oJson['traceCode']				:= AllTrim(ZB8->ZB8_ZTRCOD)
	oJson['traceCodeReligioso']		:= AllTrim(ZB8->ZB8_ZTRCDR)
	oJson['halal']					:= If(ZB8->ZB8_ZHALAL=="S",.T.,.F.)
	oJson['observacoes']			:= AllTrim(Posicione("ZZC",1,xFilial("ZZC")+ZB8->ZB8_ORCAME,"ZZC_ZOBSND"))+AllTrim(ZB8->ZB8_ZOBS)
	oJson['status']					:= If(ZB8->ZB8_MOTEXP=="3","Cancelada","Normal")
	oJson['itens'] 					:= {}

	ZB9->(dbSetOrder(2))

	If ZB9->(dbSeek(cChave))

	   While xFilial("ZB9")+ZB9->(ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP) == cChave .And. ZB9->(!Eof())
	   			  
		  oJsonItem				  := JsonObject():new()

		  oJsonItem['idEmpresa']  := AllTrim(ZB9->ZB9_FILVEN)
		  oJsonItem['idProduto']  := AllTrim(ZB9->ZB9_COD_I)
		  oJsonItem['quantidade'] := ZB9->ZB9_SLDINI
		  oJsonItem['valor'] 	  := ZB9->ZB9_PRECO

		  aadd( oJson['itens'] , oJsonItem )

		  ZB9->(dbSkip())
	   
	   EndDo

	EndIf   	  

	cJson	:= ""
	cJson	:= oJson:toJson()
		
	If !Empty( cJson )
		xPostRet := httpQuote( cUrl 		/*<cUrl>*/		,;
		                       "PUT" 		/*<cMethod>*/	,;
							   				/*[cGETParms]*/	,;
							   cJson		/*[cPOSTParms]*/,;
							   nTimeOut 	/*[nTimeOut]*/	,; 
							   aHeadOut 	/*[aHeadStr]*/	,; 
							   @cHeadRet 	/*[@cHeaderRet]*/ )
		fwJsonDeserialize( xPostRet, @oDetRet )
	EndIf	

	cTimeIni := time()

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= Time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	U_MFCONOUT(" * * * * * Status da integracao * * * * *"								 )
	U_MFCONOUT(" Inicio.......................: " + cTimeIni + " - " + DtoC( dDataBase ) )
	U_MFCONOUT(" Fim..........................: " + cTimeFin + " - " + DtoC( dDataBase ) )
	U_MFCONOUT(" Tempo de Processamento.......: " + cTimeProc 							 )
	U_MFCONOUT(" URL..........................: " + cUrl								 )
	U_MFCONOUT(" HTTP Method..................: " + "PUT" 								 )
	U_MFCONOUT(" Status Http (200 a 299 ok)...: " + AllTrim( str( nStatuHttp ) ) 		 )
	U_MFCONOUT(" cJson........................: " + AllTrim( cJson ) 					 )
	U_MFCONOUT(" Retorno......................: " + AllTrim( xPostRet ) 			  	 )
	U_MFCONOUT(" * * * * * * * * * * * * * * * * * * * * "								 )

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",cJson)

    If Valtype(xPostRet) == 'C'
	   cMsgErro := xPostRet
    EndIf

	freeObj( oJson )

	If 	!Empty(cMsgErro)
	   	ApMsgInfo(OemToAnsi(AllTrim(cMsgErro)),OemToAnsi("ATENÇÃO"))
	Else   
		ZB8->(RecLock("ZB8",.f.))
		ZB8->ZB8_INTTAU := If(!Empty(ZB8->ZB8_INTTAU),"I","A")
		ZB8->(MsUnLock())
	EndIf

	// Salvar os dados no monitor de integração	- Parte 1 - SZ3 - TABELA DE TIPO DE INTEGRACAO
	If SZ3->(!dbSeek(xFilial("SZ3")+cCdIntEx+cCdTipEx))
		RecLock("SZ3",.T.)
		SZ3->Z3_FILIAL  := xFilial("SZ3")
		SZ3->Z3_CODINTG := cCdIntEx
		SZ3->Z3_CODTINT := cCdTipEx
		SZ3->Z3_TPINTEG := 'Integracao EXP Taura'
		SZ3->Z3_EMAIL	:= ''
		SZ3->Z3_FUNCAO	:= ''
		MsUnlock()
	EndIf

	// Salvar os dados no monitor de integração	- Parte 2 - SZ1 - MONITOR DE INTEGRACOES
	U_MGFMONITOR(	ZB8->ZB8_FILVEN																							,;
					If(nStatuHttp >= 200 .And. nStatuHttp <= 299,"1","2")													,;
					cCdIntEx 																								,;
					cCdTipEx 																								,;
					If(nStatuHttp >= 200 .And. nStatuHttp <= 299,"Processamento realizado com sucesso!",AllTrim(xPostRet)) 	,;
					ZB8->ZB8_EXP 																							,;
					cTimeProc																								,;
					cJson 																									,;
  					" "														                								,;
					cValToChar(nStatuHttp) 																					,;
					.F.																										,;
					{}																										,;
 					" " 																    								,;
					If(TYPE(xPostRet) <> "U", xPostRet, " ")																,;
					If(!Empty(ZB8->ZB8_INTTAU),"I","A")																		,;
					" "																										,;
					" "																										,;
					StoD(Space(08)) 																						,;
					" "																										,;
					" "																										,;
        			cUrl     																								,;
					" " 																									)
	
	delClassINTF()

	freeObj( oJson )

Return
