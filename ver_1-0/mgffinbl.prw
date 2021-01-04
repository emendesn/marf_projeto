#INCLUDE 'TOTVS.CH'
#Include "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'

/*
{Protheus.doc} MGFFINBL 
@description 
	RTASK0010896 Desenvolvido opção para que seja possível enviar relação por e-mail aos usuários pre selecionaos.
	Tela desenvolvida para ser chamada por JOB , em um cahamdo futuro.
@author Henrique Vidal Santos
@Type Tela de relatório
@since 23/02/2020
@version P12.1.017
*/
User Function MGFFINBL()

	Local lExibe		:=.T.
	Local lReturn		:=.T.
	Local nI			:= 0
	Local cTitulo  		:= OemToAnsi("Selecione os aprovadores que deverão ser notificado por e-mail")
	Local nOpc			:= 0
	Local oOk			:= LoadBitMap(GetResources(),"LBOK")
	Local oNo			:= LoadBitMap(GetResources(),"LBNO")
	Local aTitulo  		:= {" ",'Aprovador',"Nome ", "E-mail" ,'Apr.Principal'}
	Local aTam			:= {10, TamSX3("CR_USER")[1], 30 , TamSX3("A1_EMAIL")[1] }
	Local nListTam1		:= 250	
	Local nListTam2		:= 170	
 	Local oListBox
	Local oSay
	Local oDlg
	Local nI
	Local lChk	
	Local aUsrPr	:= {}							// Array com todos os aprovadores principais da View
	Local aList 	:= {}							
	Local aTemp		:= {}							// Lista com todos aprovadores + substitutos
	Local aListBrw	:= {}							// Aprovadores selecionados na brw
	Local nQCmpApr 	:= GetNewPar('MGF_FBJ01', 7)	// Quantidade de campos para aprovadores
	Local cMailEnv	:= ''							// E-mails enviados
	Local lRetEnv	:= .F. 							// Enviou e-mail com sucesso ?
	Local nPosApr	:= ascan(aTitulo,'Aprovador')
	Local nPosNome	:= ascan(aTitulo,'Nome')
	Local nPosMail	:= ascan(aTitulo,'E-mail')
	Local nPAprPri	:= ascan(aTitulo,'Apr.Principal') 	// Aprovadores principal que consta nos títulos
	Local cFrom 	:= Alltrim(UsrRetMail(RetCodUsr()))

	If Empty(cFrom)
		MsgInfo('Você não contém e-mail cadastrado na conta de usuário. Necessário cadastrar e-mail para prosseguri!')
		Return .F.
	EndIf 

	dbSelectArea(_cTmp01)
	dbGoTop()
	While (_cTmp01)->(!Eof()) 			// Separa aprovadores principais do Array
		For y:= 1 to nQCmpApr
			cCampo := 'USR_ID'+cValtochar(y)  
			cCtdApr	:= Alltrim(&cCampo)
			If !Empty(cCtdApr)
				If ascan( aUsrPr , cCtdApr) == 0
					AADD(aUsrPr, cCtdApr)
				EndIf
			EndIf
		Next y 
		(_cTmp01)->(dbSkip())
	EndDo

	For y:= 1 to Len(aUsrPr)		// Trata e adiciona aprovadores principais ao Atemp para serem escolhidos a partir da View. Pode ser lido na SCR. 
		If Empty(aTemp) 
			AADD(aTemp, {.F. , aUsrPr[y] , Alltrim(UsrFullName(aUsrPr[y])) , Alltrim(UsrRetMail(aUsrPr[y])) ,aUsrPr[y]} ) 
		Else
			nPAtemp	:= ascan( aTemp, {|x| x[nPosApr] == aUsrPr[y] })
			If  nPAtemp == 0  
				AADD(aTemp, {.F. , aUsrPr[y] , Alltrim(UsrFullName(aUsrPr[y])) , Alltrim(UsrRetMail(aUsrPr[y])) ,aUsrPr[y] } ) 
			Else
				aTemp[nPAtemp] [5] := aTemp[nPAtemp] [5] + ' ; ' + aUsrPr[y]
			EndIf	
		EndIf
	Next y 

	_cQrApr	:= " SELECT CASE WHEN TRIM(ZAA_CODSUB) IS NULL THEN ZAA_CODAPR ELSE ZAA_CODSUB END  AS ZAA_CODSUB, ZAA_CODAPR FROM " + Retsqlname('ZAA') 
	_cQrApr	+= " WHERE ZAA_EMPFIL IN " + _cCODFILIA
	_cQrApr	+= " 		AND D_E_L_E_T_ =' ' "					"
	_cQrApr	+= " 		AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN ZAA_DTINIC AND ZAA_DTFINA "

	_cQrApr	+= " ORDER BY ZAA_CODSUB"		
	dbUseArea(.T.,"TOPCONN"    ,TcGenQry(,,_cQrApr),'ZAAX' ,.T. ,.F.)

	While ZAAX->(!Eof())		// Adiiciona os substitutos ao array aTemp para serem apresentados no Browser e marcados
		If ascan( aUsrPr , ZAA_CODAPR) > 0	//Verifica se o aprovador do substituto está como apr. principal no array retornado da View.
			If Empty(aTemp) 
				AADD(aTemp, {.F. , ZAA_CODSUB , Alltrim(UsrFullName(ZAA_CODSUB)) , Alltrim(UsrRetMail(ZAA_CODSUB)) ,ZAA_CODAPR} ) 
			Else
				nPAtemp	:= ascan( aTemp, {|x| x[nPosApr] == ZAA_CODSUB })
				If  nPAtemp == 0  
					AADD(aTemp, {.F. , ZAA_CODSUB , Alltrim(UsrFullName(ZAA_CODSUB)) , Alltrim(UsrRetMail(ZAA_CODSUB)) ,ZAA_CODAPR } ) 
				Else
					aTemp[nPAtemp] [5] := aTemp[nPAtemp] [5] + ' ; ' + ZAA_CODAPR
				EndIf	
			EndIf
		EndIf
		ZAAX->(dbSkip())
	EndDo

	ZAAX->(dbCloseArea())

	aSort(aTemp, , , { | x,y | x[nPosNome] < y[nPosNome] } ) // Ordena pelo nome do aprovador

	If Len(aTemp) > 0 .and. lExibe ==.T.
		DEFINE MSDIALOG oDlg TITLE cTitulo From 005,005 TO 035,070 OF oMainWnd
		@ 001,001 LISTBOX oListBox VAR cListBox Fields ;
		HEADER  aTitulo[1],;
		OemtoAnsi(aTitulo[2]),;
		OemtoAnsi(aTitulo[3]),;
		OemtoAnsi(aTitulo[4]) ;
		SIZE nListTam1,nListTam2 ON DBLCLICK (aTemp[oListBox:nAt,1] := !aTemp[oListBox:nAt,1],oListBox:Refresh()) 

		oListBox:bHeaderClick := {|x,nColuna| If(nColuna=1,(InvSelecao( @aTemp, oListBox, @lChk, oChk ), VerTodos( aTemp, @lChk, oChk ) ),NIL) }

		oListBox:SetArray(aTemp)
		oListBox:aColSizes := aTam
		oListBox:bLine := { || {	If(aTemp[oListBox:nAt,1],oOk,oNo), aTemp[oListBox:nAt,2], aTemp[oListBox:nAt,3], aTemp[oListBox:nAt,4]}}

		SetKey(VK_F4,{|| MarcaTodF4( @lChk, @aTemp, oListBox ) })		// Cria a associação da tecla F4, à funcão MarcaTodF4()
		
		@ 200, 010 CHECKBOX oChk Var lChk Prompt "&Marca/Desmarca Todos - < F4 >" Message "&Marca/Desmarca Todos < F4 >" SIZE 90,007 PIXEL OF oDlg ON CLICK MarcaTodos( lChk, @aTemp, oListBox )

		@ 200, 130 BUTTON	oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aTemp, oListBox, @lChk, oChk ), VerTodos( aTemp, @lChk, oChk ) ) Message 'Inverter Seleção' Of oDlg	
		DEFINE SBUTTON oBtnCan	FROM 200,200 TYPE 1 ACTION (nOpc := 1,oDlg:End())		ENABLE OF oDlg
		DEFINE SBUTTON oBtnOk	FROM 200,230 TYPE 2 ACTION (nOpc := 0,oDlg:End())		ENABLE OF oDlg	

		ACTIVATE MSDIALOG oDlg CENTERED
		SetKey( VK_F4 , {||} )				

		If nOpc == 0
			aTemp := {}
		Endif
	Endif

	If Len(aTemp) <= 0 .or. Ascan(aTemp,{|x| x[1] ==.T.}) <= 0
		Aviso("Inconsistência", "Não foi selecionada nenhum usuário para envio do e-mail. Processamento não será efetuado",{"Ok"}	,,"Atenção:")
		lReturn :=.F.
	EndIf

	If lReturn
	
		For nx := 1 to Len(aTemp)		
			If aTemp[nx][1]				// Cria aListBrw com todos os aprovadores que foram marcados para envio de e-mail	
				AADD(aListBrw,aTemp[nx]) 
			EndIf
		Next nx

		For nz := 1 to Len(aListBrw)  // Lê array com aprovadores que devem receber e-mail
			
			cTitulo := 'Títulos a pagar pendentes de aprovação'
			cMsg := 'Prezado Aprovador, <br><br>'
			cMsg += 'Segue abaixo lista dos títulos que estão aguardando sua aprovação. <br><br>'
			cMsg += 'Por favor, providenciar a aprovação dos mesmos para que estes possam ser pagos na data de vencimento programada. <br><br>'
			cMsg += '<b> E-mail gerado pelo sistema Protheus. </b> <br><br>'	

			cHtml := '	<table border="1" cellspacing="1" width="100%" bgcolor="#FFFFFF">'
			cHtml += '	  <tr>'
			cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Empresa origem' +'</font></td>'
			cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Descrição empresa' +'</font></td>'
			cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Fornecedor' +'</font></td>'
			cHtml += '	    <td width="20%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Nome fornecedor' +'</font></td>'
			cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Nº Título' +'</font></td>'
			cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Data Emissão' +'</font></td>'
			cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Natureza' +'</font></td>'
			cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Descrição Natureza' +'</font></td>'
			cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Vencimento' +'</font></td>'
			cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Vencimento Real' +'</font></td>'
			cHtml += '	    <td width="20%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + 'Valor Título' +'</font></td>'
			cHtml += '	  </tr>'

			dbSelectArea(_cTmp01)
			dbGoTop()

			While (_cTmp01)->(!Eof()) 
				If Alltrim(USR_ID1) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID2) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID3) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID4) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID5) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID6) $ aListBrw[nz][nPAprPri] .Or. ;
				   Alltrim(USR_ID7) $ aListBrw[nz][nPAprPri] 

					cHtml += '	  <tr>'
					cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + EMPRESAORI +'</font></td>'
					cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + NOMEEMPORI  +'</font></td>'
					cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + CODFORNECE +'</font></td>'
					cHtml += '	    <td width="20%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + NOMEFORNEC +'</font></td>'
					cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + NUM_TITULO +'</font></td>'
					cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + dtoc(DT_EMISSAO) +'</font></td>'
					cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + CDNATUREZA +'</font></td>'
					cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + DSCNATUREZ +'</font></td>'
					cHtml += '	    <td width="05%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + dtoc(VENCIMENTO) +'</font></td>'
					cHtml += '	    <td width="10%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + dtoc(VENCI_REAL) +'</font></td>'
					cHtml += '	    <td align="right" width="20%"  bgcolor="#FFFFFF"><font size="1" face="Tahoma">' + TransForm(VALORTITUL,"@E 999,999,999.99") +'</font></td>'
					cHtml += '	  </tr>'
				EndIf 

				(_cTmp01)->(dbSkip())
			EndDo

			cHtml += '	</table>'
			
			If Empty(aListBrw[nz][nPosMail])
				MsgInfo('Aprovador ' +aListBrw[nz][nPosNome]+ ' não contém e-mail cadastrado na conta de usuário. E-mail não será enviado!')
				Loop
			Else
				lRetEnv :=U_MGFEMAIL(cTitulo,cMsg+cHtml,aListBrw[nz][nPosMail],,,.F.,cFrom)
			EndIf 

			If lRetEnv 
				cMailEnv += IIF(Empty(cMailEnv),'','; ') + aListBrw[nz][nPosMail] 
			EndIf
		
		Next nz	
	EndIf

	If !Empty(cMailEnv)
		MsgInfo('Enviado e-mail para os destinatários: ' + chr(13) + chr(10)  + cMailEnv)
	EndIf

Return(lReturn)

/*
@function : Auxiliar para marcar/desmarcar todos os itens do Brw por tecla F4
@author Henrique Vidal Santos
@Type Function
@since 20/03/2020	
*/
Static Function MarcaTodF4( lChk, aList, oListBox )
	lChk	:= ! lChk
	MarcaTodos( lChk,  @aList, oListBox )		
	VerTodos  ( aList, @lChk,  oChk )			
Return NIL

/*
@function : Auxiliar para marcar/desmarcar todos os itens do Brw
@author Henrique Vidal Santos
@Type Function
@since 20/03/2020	
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0

	If lMarca							// Quando marco todos, 
		_nDesmarca	:= 0				// _nDesmarca é zero
	Else								// Quando Desmarco todos,
		_nDesmarca	:= Len( aVetor )	// _nDesmarca é igual à quantidade de todas as linhas
	Endif
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI

	oLbx:Refresh()

Return NIL

Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue :=.T.
	Local nI		:= 0

	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1],.F., lTTrue )
	Next nI

	lChk := IIf( lTTrue,.T.,.F. )
	oChkMar:Refresh()

Return NIL

/*
@function : Inverter seleção
@author Henrique Vidal Santos
@Type Function
@since 20/03/2020	
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0
	_nDesmarca	:= 0		// Contador para identificar se existe linhas desmarcadas depois que o botão "Marcar Todos" foi ativado
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
		
		If !aVetor[nI][1]		// Se encontrar linha que ficou desmarcada,
			_nDesmarca++		// Incremento _nDesmarca 
		Endif
	Next nI

	oLbx:Refresh()

Return NIL
