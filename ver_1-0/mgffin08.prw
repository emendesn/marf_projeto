#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CRLF ( chr(13) + chr(10) )

User Function MGFFIN08()
	Private aArea     := GetArea()
	Private aArray    := {}
	Private I         := 0
	Private _nReg     := 0
	Private _nAtu     := 0
	Private _nCab     := 3
	Private _cArq     := " "
	Private _cAtu     := " "
	Private _cArqLog  := " "
	Private _cTextCR  := " "
	Private _TMP_ARQ  := " "
	Private _nAraux   := 0

	Private nHandle         := 0
	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .T.
	Private cEOL            := "CHR(13)+CHR(10)"
	Private _cCond1			:= ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//PREPARE ENVIRONMENT EMPRESA "99"
	//FILIAL "01"
	//MODULO "FAT"
	//TABLES "SA1"

	_cArq := cGetFile("Todos os Arquivos|*.csv",OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	fwMsgRun(, {|oSay| procFin08( oSay ) }, "Processando arquivo", "Aguarde. Processando arquivo..." )

	RestArea( aArea )
Return

//-------------------------------------
//-------------------------------------
static function procFin08()

	Local cClasse	:= ''
	Local cStatus	:= ''
	Local cGerBol	:= ''
	local cLogSA1	:= ""

	// Abre arquivo com dados a importar
	nHandle := ft_fuse(_cArq)
	_nReg	:= FT_FLastRec()
	ft_fgotop()
	nLinha := 1
	Procregua(_nReg)

	//Caso o arquivo não exista ou estiver em branco ou não for a extensão txt
	If Empty(_cArq) .Or. !File(_cArq) .Or. (SubStr(_cArq, RAt('.', _cArq)+1, 3) != "txt" .And. SubStr(_cArq, RAt('.', _cArq)+1, 3) != "csv")
		MsgStop("Arquivo inválido! ", " Atenção ")
	EndIf

	_nHdl := FT_FUSE(_cArq)
	IF _nHdl <> NIL .and. _nHdl <= 0
		Aviso("Atenção !","Não foi possível a abertura do arquivo "+_cArq+" !",{"Ok"})
		FT_FUSE()
		RETURN()
	ENDIF

	FT_FGOTOP()

	// Pula linha para não pegar o cabeçalho
	For I = 1 to _nCab    //(03) linhas do cabeçalho
		FT_FSKIP()
	Next I

	PROCREGUA( FT_FLASTREC() )

	WHILE !FT_FEOF()

		cBuffer := FT_FREADLN()
		AADD( aArray , STRTOKARR2( cBuffer , ";" , .T. ) )

		//INCPROC()
		FT_FSKIP()

	ENDDO

	FT_FUSE(_cArq)

	//Percorrendo o array
	For _nAraux := 1 To Len(aArray)
		_cCod   := SUBSTR(aArray[_nAraux][1],2,6)
		_cLoja  := SUBSTR(aArray[_nAraux][2],2,2)
		_nLC    := VAL(aArray[_nAraux][09])           //LC
		_dVLC   := STOD(aArray[_nAraux][10])          //Validade LC
		_cCond  := StrTran(aArray[_nAraux][11],chr(160))                //Condição Pgto

		cStatus := Alltrim(aArray[_nAraux][23])
		cGerBol := Alltrim(aArray[_nAraux][24])
		cClasse := Alltrim(aArray[_nAraux][25])

		If UPPER(cStatus) == "LIBERADO"
			cStatus := "2"
		Else
			cStatus := "1"
		EndIf

		If UPPER(cGerBol) == "SIM"
			cGerBol := "S"
		Else
			cGerBol := "N"
		EndIf

		_cTextCR := ""
		if len(aArray[_nAraux]) > 31
			_cTextCR := aArray[_nAraux][32]
		endif

		If !Empty( _cCond )

			If LEN(_cCond) < 2
				_cCond1 := "00" + _cCond
			ElseIf LEN(_cCond) < 3
				_cCond1 := "0" + _cCond
			Else
				_cCond1 := _cCond
			EndIf

			DbSelectArea("SE4")
			DbSetOrder(1)

			If !DbSeek(xFilial("SE4")+_cCond1)
				MSGAlert("Condição Pagto não encontrada. " + _cCond1 ,"Atenção!")
				RestArea( aArea )
				Return()
			EndIf

		EndIf

		DbSelectArea("SA1")
		DbSetOrder(1)

		If DbSeek( xFilial( "SA1" ) + _cCod + _cLoja )
			cGrade := ""
			cGrade := getZB1()

			if !empty( cGrade )
				cLogSA1 += "CNPJ " + SA1->A1_CGC + " está pendente na Grade de Aprovação: " + cGrade + CRLF
			else
				if ( allTrim( aArray[ _nAraux ][ 23 ] ) == "LIBERADO" .and. ( allTrim( aArray[ _nAraux ][ 26 ] ) == "SIM" .or. allTrim( aArray[ _nAraux ][ 27 ] ) == "SIM" ) );
					.OR.;
					( allTrim( aArray[ _nAraux ][ 23 ] ) == "BLOQUEADO" .and. allTrim( aArray[ _nAraux ][ 26 ] ) == "NAO" .and. allTrim( aArray[ _nAraux ][ 27 ] ) == "NAO" )

					cLogSA1 += "Cliente " + SA1->A1_COD + "-" + SA1->A1_LOJA + " está com bloqueio de cadastro inconsistente! " + CRLF
				else
					recLock("SA1", .F.)

					// MUDA FLAGS PARA ATUALIZAR OS SISTEMAS INTEGRADOS
					SA1->A1_XINTECO	:= '0' // ECOMMERCE
					SA1->A1_XINTSFO	:= 'P' // SALESFORCE
					SA1->A1_XINTEGX	:= 'P' // SFA

					SA1->A1_LC		:= _nLC
					SA1->A1_VENCLC	:= _dVLC

					if allTrim( aArray[ _nAraux ][ 26 ] ) == "SIM" .or. allTrim( aArray[ _nAraux ][ 27 ] ) == "SIM"
						SA1->A1_MSBLQL	:= "1"
					elseif allTrim( aArray[ _nAraux ][ 26 ] ) == "NAO" .and. allTrim( aArray[ _nAraux ][ 27 ] ) == "NAO"
						SA1->A1_MSBLQL	:= "2"
					endif

					// SA1->A1_MSBLQL	:= iif( allTrim( aArray[ _nAraux ][ 23 ] ) == "BLOQUEADO"	, "1" , "2" )

					SA1->A1_XPENFIN	:= iif( allTrim( aArray[ _nAraux ][ 26 ] ) == "SIM"			, "S" , "N" )
					SA1->A1_ZINATIV	:= iif( allTrim( aArray[ _nAraux ][ 27 ] ) == "SIM"			, "1" , "0" )
					SA1->A1_XBLQREC	:= iif( allTrim( aArray[ _nAraux ][ 28 ] ) == "SIM"			, "S" , "N" )
					SA1->A1_XTEMPOR	:= iif( allTrim( aArray[ _nAraux ][ 29 ] ) == "SIM"			, "S" , "N" )

					//SA1->A1_ZREDE	:= allTrim( aArray[ _nAraux ][ 04 ] )
					SA1->A1_ZREDE	:= allTrim( strTran( aArray[ _nAraux ][ 04 ] , chr(160) , chr(32) ) )
					//SA1->A1_XMAILCO	:= allTrim( aArray[ _nAraux ][ 30 ] )
					SA1->A1_XMAILCO	:= allTrim( strTran( aArray[ _nAraux ][ 30 ] , chr(160) , chr(32) ) )

					SA1->A1_ZGDERED	:= iif( allTrim( aArray[ _nAraux ][ 31 ] ) == "SIM" , "S" , "N" )

					If Alltrim(SA1->A1_ZBOLETO) <> cGerBol
						SA1->A1_ZBOLETO := cGerBol
					EndIf

					If Alltrim(SA1->A1_ZCLASSE) <> cClasse
						IF cClasse $ 'ABCDE'
							SA1->A1_ZCLASSE := cClasse
						Else
							SA1->A1_ZCLASSE := ' '
						EndIF
					EndIf

					if !Empty(_cTextCR)
						if Empty(SA1->A1_ZALTCRED)
							SA1->A1_ZALTCRED := DtoC(ddatabase)+" - "+SubStr(cUsuario,7,15)+" - Obs: "+_cTextCR
						Else
							SA1->A1_ZALTCRED := Alltrim(SA1->A1_ZALTCRED)+CRLF+DtoC(ddatabase)+" - "+SubStr(cUsuario,7,15)+" - Obs: "+_cTextCR
						Endif
					Endif
					If !Empty(_cCond1)
						SA1->A1_COND   := _cCond1
					EndIf
					_nAtu ++
					//_TMP_ARQ       := _cArqLog
					("SA1")->(MsUnlock())
				endif
			endif
		Else
			MSGAlert("Cliente não encontrado. " +  _cCod+" Loja "+_cLoja ,"Atenção!")
		EndIf
	Next _nAraux
	_cAtu := STR(_nAtu)
	MSGAlert("Atualizacoes:  " + (_cAtu) ,"Atenção!")

	if !empty( cLogSA1 )
		cLogSA1 := "CNPJs que não foram atualizados:" + CRLF + cLogSA1
		showLog( cLogSA1 )
	endif
return

//-----------------------------------------------------------
// Verifica se existe grade de aprovacao
//-----------------------------------------------------------
static function getZB1()
	local aAreaX		:= getArea()
	local cQryZB1		:= ""
	local cApprovals	:= ""

	cQryZB1 := "SELECT ZB1.R_E_C_N_O_ ZB1RECNO , ZB6_NOME, ZB2.R_E_C_N_O_ ZB2RECNO"			+ CRLF
	cQryZB1 += " FROM "			+ retSQLName( "ZB1" ) + " ZB1"								+ CRLF
	cQryZB1 += " INNER JOIN "	+ retSQLName( "ZB2" ) + " ZB2"								+ CRLF
	cQryZB1 += " ON"																		+ CRLF
	cQryZB1 += " 		ZB2.ZB2_ID		=	ZB1.ZB1_ID"										+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_STATUS	<>	'1'"											+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_FILIAL	=	'" + xFilial("ZB2")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB2.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryZB1 += " LEFT JOIN "	+ retSQLName( "ZB6" ) + " ZB6"								+ CRLF
	cQryZB1 += " ON"																		+ CRLF
	cQryZB1 += " 		ZB6.ZB6_ID    	=	ZB2.ZB2_IDSET"									+ CRLF
	cQryZB1 += " 	AND	ZB6.ZB6_FILIAL	=	'" + xFilial("ZB6")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB6.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryZB1 += " WHERE"																		+ CRLF
	cQryZB1 += "		ZB1.ZB1_RECNO	=	'" + alltrim( str( SA1->( RECNO() ) ) ) + "'"	+ CRLF
	cQryZB1 += " 	AND	ZB1.ZB1_STATUS	IN	( '3' , '4' )"									+ CRLF // Solicitação Aberta / Aprovação em Andamento
	cQryZB1 += " 	AND	ZB1.ZB1_CAD		=	'1'"											+ CRLF // SA1 - Clientes
	cQryZB1 += " 	AND	ZB1.ZB1_FILIAL	=	'" + xFilial("ZB1")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB1.D_E_L_E_T_	<>	'*'"											+ CRLF

	tcQuery cQryZB1 new alias "QRYZB1"

	while !QRYZB1->( EOF() )
		cApprovals += allTrim( QRYZB1->ZB6_NOME ) + ";"

		QRYZB1->( DBSkip() )
	enddo

	if !empty( cApprovals )
		cApprovals := left( cApprovals , len( cApprovals ) - 1 )
	endif

	QRYZB1->( DBCloseArea() )

	restArea( aAreaX )
return cApprovals

//---------------------------------------------------------
//---------------------------------------------------------
static function showLog( xMsg, cTitulo, cLabel, aButtons, bValid, lQuebraLinha )
	local oDlg
	local oMemo
	local oFont				:= TFont():New("Courier New",09,15)
	local bOk				:= { || oDlg:end() }
	local bCancel			:= { || oDlg:end() }
	local cMsg				:= ""
	local nQuebra			:= 68

	default xMsg			:= ""
	default cTitulo			:= ""
	default cLabel			:= ""
	default aButtons		:= {}
	default bValid			:= {|| .T. }
	default lQuebraLinha	:= .F.

   aadd( aButtons, { "NOTE" ,{ ||  openNotePa( .f., cMsg, "log.txt" ) }, "NotePad", } )

   // ** JPM - 06/10/05
   If ValType(xMsg) = "C"
      cMsg := xMsg
   ElseIf ValType(xMsg) = "A"
      For i := 1 To Len(xMsg)
         If xMsg[i][2] // Posição que define se fará quebra de linha
            For j := 1 To MLCount(xMsg[i][1],nQuebra)
               cMsg += MemoLine(xMsg[i][1], nQuebra, j) + ENTER
            Next
         Else
            cMsg += xMsg[i][1]
         EndIf
      Next
   EndIf

   Define MsDialog oDlg Title cTitulo From 9,0 To 39,85 of oDlg

      oPanel:= TPanel():New(0, 0, "", oDlg,, .F., .F.,,, 90, 165) //MCF - 15/07/2015 - Ajustes Tela P12.
      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

      @ 05,05 To 190,330 Label cLabel Pixel Of oPanel
      @ 10,10 Get oMemo Var cMsg MEMO HSCROLL FONT oFont Size 315,175 READONLY Of oPanel  Pixel

      oMemo:lWordWrap := lQuebraLinha
      oMemo:EnableVScroll(.t.)
      oMemo:EnableHScroll(.t.)

   Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,,,,,,aButtons,) Centered // BHF - 01/08/08 -> Trocado Enchoicebar por AvButtonBar

return