#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
	Rotina para importação de Pré Cálculo
*/
user function MGFEEC64()
	if aviso("Importação de Pré Cálculo", "Serão importados os valores de Pré-Cálculo" + CRLF + ". Os valores antes desta importação serão descartados. Deseja Continuar?", { "Continuar", "Cancelar" }, 1) == 1
		if getParam()
			fwMsgRun(, {| oSay | impArq( oSay ) }, "Processando", "Aguarde. Processando arquivo..." )
		endif
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Selecione o arquivo"	, space(200), "@!"	, ""	, ""	, 070, .T., "Arquivos .CSV |*.CSV", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Tabela de Pré-Cálculo"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function impArq( oSay )
	local nOpen			:= FT_FUSE(AllTrim(MV_PAR01))
	local nLast			:= 0
	local cLinha		:= ""
	local nLinAtu		:= 0
	local aLineAux		:= {}
	local aArea			:= getArea()
	local aAreaZEE		:= ZEE->(getArea())
	local cQryZEE		:= ""
	local cUpdZEE		:= ""
	local nPosIt		:= 0

	private aLine		:= {}
	private cLogErrors	:= ""
	private cLogOk		:= ""
	private cLogAll		:= ""
	Private cTipo       := ''

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		DBSelectArea("ZEE")
		ZEE->( DBSetOrder( 1 ) ) //ZEE_FILIAL+ZEE_CODIGO+WI_DESP

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
				aLineAux	:= strTokArr2( cLinha, ";", .T. )

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
				if chkZED( cTable )// Verifica TABELA DE PRE CALCULO de destino
					eraseZEE( cTable )
					//cItemZEE := strZero( 0 , tamSX3("ZEE_ITEM")[1] )
					while nI <= len( aLine ) .and. cTable == aLine[ nI, 1 ]
						//cItemZEE := soma1( cItemZEE )

						processMessages()

						nLinAtu++

						oSay:cCaption := ( "Importando item " + str( nLinAtu ) + " de " + str( nLast ) )

						if chkSYB( strTran( aLine[ nI, 2 ] , ".", "" ) )
							recLock( "ZEE", .T. )
							IF cTipo == 'A'
								ZEE->ZEE_FILIAL	:= xFilial("ZEE")
								ZEE->ZEE_CODIGO	:= allTrim( aLine[ nI, 1 ] )
								ZEE->ZEE_CODDES	:= allTrim( strTran( aLine[ nI, 2 ] , ".", "" ) )
								ZEE->ZEE_TIPOPR	:= allTrim( aLine[ nI, 4 ] )
								ZEE->ZEE_TIPODE	:= allTrim( aLine[ nI, 5 ] )
								ZEE->ZEE_MOEDA	:= allTrim( aLine[ nI, 7 ] )
								ZEE->ZEE_VALOR	:= val( aLine[ nI, 8 ] )
								ZEE->ZEE_VALMIN	:= val( aLine[ nI, 9 ] )
								ZEE->ZEE_VALMAX	:= val( aLine[ nI, 10 ] )
								ZEE->ZEE_ORIGEM	:= allTrim( aLine[ nI, 11 ] )
								ZEE->ZEE_DESTIN	:= allTrim( aLine[ nI, 13 ] )
								ZEE->ZEE_ARMADO	:= allTrim( aLine[ nI, 15 ] )
							ElseIF cTipo == 'T'
							    ZEE->ZEE_FILIAL	:= xFilial("ZEE")
								ZEE->ZEE_CODIGO	:= allTrim( aLine[ nI, 1 ] )
								ZEE->ZEE_CODDES	:= allTrim( strTran( aLine[ nI, 2 ] , ".", "" ) )
								ZEE->ZEE_TERMIN := allTrim( aLine[ nI, 3 ] )
								ZEE->ZEE_PER	:= val( aLine[ nI, 4 ] )
								ZEE->ZEE_DIAPER := val( aLine[ nI, 5 ] )
								ZEE->ZEE_VLPER  := val( aLine[ nI, 6 ] )
								ZEE->ZEE_MOEDA  := allTrim( aLine[ nI, 7 ] )
								ZEE->ZEE_COB	:= allTrim( aLine[ nI, 8 ] )
								ZEE->ZEE_CONT   := allTrim( aLine[ nI, 09] )
								ZEE->ZEE_PCALC  := allTrim( aLine[ nI, 10] )
							EndIF
							ZEE->( msUnlock() )

							//cLogOk += "Produto " + ZEE->ZEE_CODPRO + " importado com sucesso para a Tabela " + ZEE->ZED_CODIGO + CRLF
						else
							// log despesa nao cadastrada
						endif

						nI++
					enddo
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

	restArea( aAreaZEE )
	restArea( aArea )
return

//---------------------------------------------------------
//---------------------------------------------------------
static function chkZED( cTable )
	local cQryZED	:= ""
	local lRet		:= .F.

	cQryZED := "SELECT ZED_TIPODE"										+ CRLF
	cQryZED += " FROM " + retSQLName("ZED") + " ZED"					+ CRLF
	cQryZED += " WHERE"													+ CRLF
	cQryZED += " 		ZED.ZED_CODIGO	=	'" + cTable			+ "'"	+ CRLF
	cQryZED += " 	AND	ZED.ZED_FILIAL	=	'" + xFilial("ZED")	+ "'"	+ CRLF
	cQryZED += " 	AND	ZED.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryZED New Alias "QRYZED"

	if !QRYZED->(EOF())
		lRet	:= .T.
		cTipo       := QRYZED->ZED_TIPODE
	else
		cLogErrors += "Tabela de Pré Cálculo " + cTable + " não encontrada. Verifique se ela já está criada." + CRLF
	endif

	QRYZED->(DBCloseArea())
return lRet

//---------------------------------------------------------
//---------------------------------------------------------
static function eraseZEE( cTable )
	local cUpdZEE	:= ""

	cUpdZEE := "DELETE FROM " + retSQLName("ZEE")							+ CRLF
	cUpdZEE += " WHERE"														+ CRLF
	cUpdZEE += " 		ZEE_CODIGO	=	'" + cTable			+ "'" 			+ CRLF
	cUpdZEE += " 	AND	ZEE_FILIAL	=	'" + xFilial("ZEE")	+ "'"			+ CRLF

	if tcSQLExec( cUpdZEE ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif
return

//---------------------------------------------------------
//---------------------------------------------------------
static function chkSYB( cYBCod )
	local cQRYSYB	:= ""
	local lRet		:= .F.

	cQRYSYB := "SELECT YB_DESP"											+ CRLF
	cQRYSYB += " FROM " + retSQLName("SYB") + " SYB"					+ CRLF
	cQRYSYB += " WHERE"													+ CRLF
	cQRYSYB += " 		SYB.YB_DESP		=	'" + cYBCod			+ "'"	+ CRLF
	cQRYSYB += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")	+ "'"	+ CRLF
	cQRYSYB += " 	AND	SYB.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQRYSYB New Alias "QRYSYB"

	if !QRYSYB->(EOF())
		lRet := .T.
	else
		cLogErrors += "Despesa " + aLine[ nI, 2 ] + " não encontrado. Verifique o código." + CRLF
	endif

	QRYSYB->(DBCloseArea())
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
