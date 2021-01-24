#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

user function MGFFATA2()
	if aviso("Importação de Preços", "Serão importados os preços de todas as Tabelas de Preço definidas como 'E-Commerce'" + CRLF + ". Os preços antes desta importação serão descartados. Deseja Continuar?", { "Continuar", "Cancelar" }, 1) == 1
		if getParam()
			//impArq()
			fwMsgRun(, {| oSay | impArq( oSay ) }, "Processando", "Aguarde. Processando arquivo..." )
			//APMsgInfo("Importação finalizada.")
		endif
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Selecione o arquivo"	, space(200), "@!"	, ""	, ""	, 070, .T., "Arquivos .CSV |*.CSV", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Tabela de Preço x Clientes"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function impArq( oSay )
	local nOpen			:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast			:= 0
	local cLinha		:= ""
	local nLinAtu		:= 0
	local aLineAux		:= {}
	local aArea			:= getArea()
	local aAreaDA1		:= DA1->(getArea())
	local cQryDA1		:= ""
	local cUpdDA1		:= ""
	local nPosIt		:= 0
	local cIDInteg		:= fwTimeStamp( 1 ) // aaaammddhhmmss

	private aLine		:= {}
	private cLogErrors	:= ""
	private cLogOk		:= ""
	private cLogAll		:= ""

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		DBSelectArea("DA1")
		DA1->( DBSetOrder( 1 ) ) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM

		FT_FGOTOP()
		nLast := FT_FLastRec()
		FT_FGOTOP()

		while !FT_FEOF()
			nLinAtu++

			oSay:cCaption := ( "Preparando item " + str( nLinAtu ) + " de " + str( nLast ) )

			if nLinAtu > 1
				cLinha		:= ""
				cLinha		:= FT_FREADLN()
				aLineAux	:= {}
				aLineAux	:= strTokArr(cLinha, ";")

				aadd( aLine, aLineAux )
			endif

			FT_FSKIP()
		enddo

		if len( aLine ) > 0
			aSort( aLine ,,, { |x, y| x[1] < y[1] } )

			nLinAtu	:= 0
			nLast	:= 0
			nLast	:= len( aLine )

			nI := 1
			while nI <= len( aLine )
				cTable := aLine[ nI, 1 ]
				if chkDAO( cTable )// Verifica TABELA DE PREÇO de destino
					cItemDA1 := getDA1Max( cTable )
					while nI <= len( aLine ) .and. cTable == aLine[ nI, 1 ]

						processMessages()

						nLinAtu++

						oSay:cCaption := ( "Importando item " + str( nLinAtu ) + " de " + str( nLast ) )

						if chkSB1( aLine[ nI, 2 ] )

							cQryDA1	:= ""

							cQryDA1 := "SELECT D_E_L_E_T_ DA1DELETE, DA1_CODTAB, DA1_CODPRO, R_E_C_N_O_ DA1RECNO"	+ CRLF
							cQryDA1 += " FROM " + retSQLName("DA1") + " DA1"										+ CRLF
							cQryDA1 += " WHERE"																		+ CRLF
							cQryDA1 += " 		DA1.DA1_CODTAB	=	'" + cTable			+ "'"						+ CRLF
							cQryDA1 += " 	AND	DA1.DA1_CODPRO	=	'" + aLine[ nI, 2 ]	+ "'" 						+ CRLF
							cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")	+ "'"						+ CRLF
							cQryDA1 += " ORDER BY"																	+ CRLF
							cQryDA1 += "	CASE"																	+ CRLF
							cQryDA1 += "	WHEN D_E_L_E_T_ = ' ' THEN 1"											+ CRLF
							cQryDA1 += "	WHEN D_E_L_E_T_ = '*' THEN 2"											+ CRLF
							cQryDA1 += "	END"																	+ CRLF

							tcQuery cQryDA1 New Alias "QRYDA1"

							cItemDA1 := soma1( cItemDA1 )

							if QRYDA1->( EOF() )
								recLock( "DA1", .T. )
									DA1->DA1_FILIAL	:= xFilial("DA1")
									DA1->DA1_ITEM	:= cItemDA1
									DA1->DA1_CODTAB := cTable
									DA1->DA1_CODPRO := aLine[ nI, 2 ]
									DA1->DA1_PRCVEN := VAL( aLine[ nI, 3 ] )
									DA1->DA1_XPRCBA := VAL( aLine[ nI, 4 ] )
									DA1->DA1_ATIVO	:= "1"
									DA1->DA1_QTDLOT := 999999.99
									DA1->DA1_MOEDA	:= 1
									DA1->DA1_TPOPER	:= "4"
									//DA1->DA1_XALTER	:= cIDInteg
								DA1->( msUnlock() )
							else
								cUpdDA1	:= ""
								cUpdDA1 := "UPDATE " + retSQLName("DA1")							+ CRLF
								cUpdDA1 += "	SET"												+ CRLF

								if QRYDA1->DA1DELETE == "*"
									cUpdDA1 += "	D_E_L_E_T_	= ' '					,"			+ CRLF
								endif

								cUpdDA1 += "		DA1_PRCVEN	= " + aLine[ nI, 3 ] + ","			+ CRLF
								cUpdDA1 += "		DA1_XPRCBA	= " + aLine[ nI, 4 ] + ","			+ CRLF
								cUpdDA1 += "		DA1_ATIVO	= '1'					,"			+ CRLF
								cUpdDA1 += "		DA1_QTDLOT	= 999999.99				,"			+ CRLF
								cUpdDA1 += "		DA1_MOEDA	= 1						,"			+ CRLF
								cUpdDA1 += "		DA1_TPOPER	= '4'					,"			+ CRLF
								cUpdDA1 += "		DA1_ITEM	= '" + cItemDA1 + "'	,"			+ CRLF
								cUpdDA1 += "		DA1_XENEEC	= '0'"								+ CRLF
								//cUpdDA1 += "		DA1_XALTER	= '" + cIDInteg + "'"				+ CRLF
								cUpdDA1 += " WHERE"													+ CRLF
								cUpdDA1 += " 		R_E_C_N_O_ = '" + str( QRYDA1->DA1RECNO ) + "'"	+ CRLF

								if tcSQLExec( cUpdDA1 ) < 0
									conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
									cLogErrors += "Não foi possível atualizar o Produto " + QRYDA1->DA1_CODPRO + " não encontrada." + CRLF
								endif
							endif

							QRYDA1->(DBCloseArea())

							xAtuSB1( aLine[ nI, 2 ] )

							//cLogOk += "Produto " + DA1->DA1_CODPRO + " importado com sucesso para a Tabela " + DA1->DA1_CODTAB + CRLF
						endif

						nI++
					enddo

					// REMOCAO DE ITENS DA TABELA QUE NAO ESTAO NO ARQUIVO
					cQryDA1	:= ""

					cQryDA1 := "SELECT DA1_CODTAB, DA1_CODPRO"												+ CRLF
					cQryDA1 += " FROM " + retSQLName("DA1") + " DA1"					+ CRLF
					cQryDA1 += " WHERE"													+ CRLF
					cQryDA1 += " 		DA1.DA1_CODTAB	=	'" + cTable			+ "'"	+ CRLF
					cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")	+ "'"	+ CRLF
					cQryDA1 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"						+ CRLF

					TcQuery cQryDA1 New Alias "QRYDA1"

					while !QRYDA1->(EOF())
						oSay:cCaption := ( "Removendo itens não importados..." )

						nPosIt := 0
						nPosIt := aScan( aLine , { | x | allTrim( x[ 1 ] ) == allTrim( QRYDA1->DA1_CODTAB ) .and. allTrim( x[ 2 ] ) == allTrim( QRYDA1->DA1_CODPRO ) } )

						if nPosIt == 0
							eraseDA1( cTable , QRYDA1->DA1_CODPRO , cIDInteg )
						endif

						QRYDA1->(DBSkip())
					enddo

					xAtuDA0( cTable )

					QRYDA1->(DBCloseArea())
				else
					nI++
				endif
			enddo

			if len( cLogOk ) > 0
				cLogAll += "*******************************************************" + CRLF
				cLogAll += "|      Os itens abaixo foram importados com sucesso:  |" + CRLF
				cLogAll += "*******************************************************" + CRLF
				cLogAll += cLogOk
			endif

			if len( cLogErrors ) > 0
				cLogAll += CRLF
				cLogAll += "*******************************************************" + CRLF
				cLogAll += "|      Abaixo os erros que foram encontrados:         |" + CRLF
				cLogAll += "*******************************************************" + CRLF
				cLogAll += cLogErrors
			endif

			if len( cLogAll ) > 0
				showLog( cLogAll )
			endif
		endif
	endif

	restArea( aAreaDA1 )
	restArea( aArea )
return

//---------------------------------------------------------
//---------------------------------------------------------
static function chkDAO( cTable )
	local cQryDA0	:= ""
	local lRet		:= .F.
	local aAreaDA0	:= DA0->( getArea() )
	local aAreaX	:= getArea()

	cQryDA0 := "SELECT DA0_CODTAB"													+ CRLF
	cQryDA0 += " FROM " + retSQLName("DA0") + " DA0"								+ CRLF
	cQryDA0 += " WHERE"																+ CRLF
	//cQryDA0 += " 		DA0.DA0_XENVEC	=	'1'" 									+ CRLF
	//cQryDA0 += " 	AND	DA0.DA0_CODTAB	=	'" + cTable			+ "'"				+ CRLF
	cQryDA0 += " 		DA0.DA0_CODTAB	=	'" + cTable			+ "'"				+ CRLF
	cQryDA0 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0")	+ "'"				+ CRLF
	cQryDA0 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"									+ CRLF

	TcQuery cQryDA0 New Alias "QRYDA0"

	if !QRYDA0->(EOF())
		lRet := .T.
	else
		cLogErrors += "Tabela " + cTable + " não encontrada. Verifique se está configurada para o E-Commerce." + CRLF
	endif

	QRYDA0->(DBCloseArea())

	restArea( aAreaDA0 )
	restArea( aAreaX )
return lRet

//---------------------------------------------------------
// Marca registros como deletado
// Exclusao deve ser enviada para integracao
//---------------------------------------------------------
static function eraseDA1( cTable , cCodPro , cIDInteg )
	local cUpdDA1	:= ""

	cUpdDA1 := "UPDATE " + retSQLName("DA1")								+ CRLF
	cUpdDA1 += "	SET"													+ CRLF
	cUpdDA1 += "		D_E_L_E_T_	=	'*'"								+ CRLF
	//cUpdDA1 += "		DA1_XALTER	=	'" + cIDInteg + "'"					+ CRLF
	cUpdDA1 += " WHERE"														+ CRLF
	cUpdDA1 += " 		DA1_CODTAB	=	'" + cTable		+ "'" 				+ CRLF
	cUpdDA1 += " 	AND	DA1_CODPRO	=	'" + cCodPro	+ "'" 				+ CRLF

	if tcSQLExec( cUpdDA1 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif
return

//---------------------------------------------------------
//---------------------------------------------------------
static function chkSB1( cB1Cod )
	local cQrySB1	:= ""
	local lRet		:= .F.

	cQrySB1 := "SELECT B1_COD"												+ CRLF
	cQrySB1 += " FROM " + retSQLName("SB1") + " SB1"					+ CRLF
	cQrySB1 += " WHERE"													+ CRLF
	cQrySB1 += " 		SB1.B1_COD		=	'" + cB1Cod	+ "'"	+ CRLF
	cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1")	+ "'"	+ CRLF
	cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQrySB1 New Alias "QRYSB1"

	if !QRYSB1->(EOF())
		lRet := .T.
	else
		cLogErrors += "Produto " + aLine[ nI, 2 ] + " não encontrado. Verifique o código." + CRLF
	endif

	QRYSB1->(DBCloseArea())
return lRet

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

//-----------------------------------------------------------
// Atualiza flags para integracao de sistemas
//-----------------------------------------------------------
static function xAtuDA0( cCodTab )
	local aArea		:= getArea()
	local aAreaDA0 	:= DA0->( getArea() )
	local cUpdDA0	:= ""

	// ATUALIZA FLAG PARA INTEGRACAO COM E-COMMERCE
	cUpdDA0	:= ""
	cUpdDA0 := "UPDATE " + retSQLName("DA0")						+ CRLF
	cUpdDA0 += "	SET DA0_XINTEC	=	'0'"						+ CRLF
	cUpdDA0 += " WHERE"												+ CRLF
	cUpdDA0 += " 		DA0_CODTAB	=	'" + cCodTab		+ "'" 	+ CRLF
	cUpdDA0 += " 	AND	DA0_XENVEC	=	'1'" 						+ CRLF
	cUpdDA0 += " 	AND	DA0_FILIAL	=	'" + xFilial("DA0")	+ "'"	+ CRLF
	cUpdDA0 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

	if tcSQLExec( cUpdDA0 ) < 0
		conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
	endif

	// ATUALIZA FLAG PARA INTEGRACAO COM SALESFORCE
	cUpdDA0	:= ""
	cUpdDA0 := "UPDATE " + retSQLName("DA0")						+ CRLF
	cUpdDA0 += "	SET DA0_XINTSF	=	'P'"						+ CRLF
	cUpdDA0 += " WHERE"												+ CRLF
	cUpdDA0 += " 		DA0_CODTAB	=	'" + cCodTab		+ "'" 	+ CRLF
	cUpdDA0 += " 	AND	DA0_XENVSF	=	'S'" 						+ CRLF
	cUpdDA0 += " 	AND	DA0_FILIAL	=	'" + xFilial("DA0")	+ "'"	+ CRLF
	cUpdDA0 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

	if tcSQLExec( cUpdDA0 ) < 0
		conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
	endif

	restArea( aAreaDA0 )
	restArea( aArea )
return

Static Function xAtuSB1(cCodPrd)

	Local aArea		:= GetArea()
	Local aAreaSB1 	:= SB1->(GetArea())

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))//B1_FILIAL+B1_COD

	If SB1->(dbSeek(xFilial("SB1") + cCodPrd))
		If SB1->B1_ZSTATEC <> "1"
			RecLock( "SB1", .F. )
				SB1->B1_XINTECO = "0"
				SB1->B1_XENVECO = "1"
			SB1->(MsUnlock())
		EndIf
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

Return


Static Function openNotePa(lApaga,cMsg,cFile)

Local lRet:=.t., cDir:=GetWinDir()+"\Temp\",hFile

Default lApaga := .f. // Se .t. apaga arquivo temporário.
Default cFile  := "log.txt"

Begin Sequence

   If !lApaga
      hFile := fCreate(cDir+cFile)

      fWrite(hFile,cMsg,Len(cMsg))

      fClose(hFile)

      WinExec("NotePad "+cDir+cFile)
   Else
      If File(cDir+cFile)
         fErase(cDir+cFile)
      EndIf
   EndIf

End Sequence

Return lRet

//-------------------------------------------------------------
// Retorna o Maior item da tabela - para nao inserir duplicado
//-------------------------------------------------------------
static function getDA1Max( cTable )
	local cQryDA1	:= ""
	local cRetMax	:= ""

	cQryDA1 := "SELECT MAX(DA1_ITEM) MAXITEM"							+ CRLF
	cQryDA1 += " FROM " + retSQLName("DA1") + " DA1"					+ CRLF
	cQryDA1 += " WHERE"													+ CRLF
	cQryDA1 += " 		DA1.DA1_CODTAB	=	'" + cTable			+ "'"	+ CRLF
	cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1")	+ "'"	+ CRLF

	tcQuery cQryDA1 New Alias "QRYDA1"

	if !QRYDA1->(EOF())
		cRetMax := QRYDA1->MAXITEM
	endif

	QRYDA1->(DBCloseArea())
return cRetMax