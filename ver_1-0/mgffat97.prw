#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

user function MGFFAT97()
	if getParam()
		//impArq()
		fwMsgRun(, {| oSay | impArq( oSay ) }, "Processando", "Aguarde. Processando arquivo..." )
	endif
	APMsgInfo("Importação finalizada.")
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

	private aLinha		:= {}
	private cLogErrors	:= ""
	private cLogOk		:= ""
	private cLogAll		:= ""

	if nOpen < 0
		Alert("Falha na abertura do arquivo.")
	else
		if !msgYesNo("A importação deste arquivo irá sobrepor a amarração atual de Clientes x Tabela de Preço. Deseja prosseguir?", "Alteração Clientes da Tabela")
			return
		endif

		FT_FGOTOP()
		nLast := FT_FLastRec()
		FT_FGOTOP()

		while !FT_FEOF()
			nLinAtu++

			oSay:cCaption := ( "Importando item " + str( nLinAtu ) + " de " + str( nLast ) )

			if nLinAtu > 1
				cLinha := ""
				cLinha := FT_FREADLN()
				aLinha := {}
				aLinha := strTokArr(cLinha, ";")

				if chkDAO()// Verifica TABELA DE PREÇO de destino
					if chkSA1() // Verifica s cliente existe
						updSA1()
					else
						// gera log
					endif
				else
					// gera log
				endif
			endif

			FT_FSKIP()
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
return

//---------------------------------------------------------
//---------------------------------------------------------
static function chkDAO()
	local cQryDA0	:= ""
	local lRet		:= .F.

	cQryDA0 := "SELECT DA0_CODTAB"													+ CRLF
	cQryDA0 += " FROM " + retSQLName("DA0") + " DA0"								+ CRLF	
	cQryDA0 += " WHERE"																+ CRLF
	cQryDA0 += " 		DA0.DA0_XENVEC	=	'1'" 									+ CRLF
	cQryDA0 += " 	AND	DA0.DA0_CODTAB	=	'" + padL(aLinha[1], 3, "0")	+ "'"	+ CRLF
	cQryDA0 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0")				+ "'"	+ CRLF
	cQryDA0 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"									+ CRLF

	TcQuery cQryDA0 New Alias "QRYDA0"

	if !QRYDA0->(EOF())
		lRet := .T.
	else
		cLogErrors += "Tabela " + padL( aLinha[ 1 ], 3, "0" ) + " não encontrada. Verifique se está configurada para o E-Commerce." + CRLF
	endif
	
	QRYDA0->(DBCloseArea())
return lRet

//---------------------------------------------------------
//---------------------------------------------------------
static function chkSA1()
	local lRet		:= .F.
	local cQrySA1	:= ""

	cQrySA1 := "SELECT A1_COD, A1_LOJA"												+ CRLF
	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"								+ CRLF	
	cQrySA1 += " WHERE"																+ CRLF
	cQrySA1 += " 		SA1.A1_LOJA		=	'" + padL(aLinha[3], 2, "0")	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_COD		=	'" + padL(aLinha[2], 6, "0")	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")				+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"									+ CRLF

	TcQuery cQrySA1 New Alias "QRYSA1"

	if !QRYSA1->(EOF())
		lRet := .T.
	else
		cLogErrors += "Cliente " + padL(aLinha[2], 6, "0") + "/" + padL(aLinha[3], 2, "0") + " não encontrado. Verifique o código/loja." + CRLF
	endif
	
	QRYSA1->(DBCloseArea())
return lRet

//---------------------------------------------------------
//---------------------------------------------------------
static function updSA1()
	local cUpdSA1	:= ""

	//Update da tabela de preço na tabela de Cliente
	cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF	
	cUpdSA1 += "	SET"														+ CRLF
	cUpdSA1 += " 		A1_ZPRCECO = '" + padL(aLinha[1], 3, "0") + "' "		+ CRLF
	cUpdSA1 += " WHERE"															+ CRLF
	cUpdSA1 += " 		A1_LOJA		=	'" + padL(aLinha[3], 2, "0")	+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_COD		=	'" + padL(aLinha[2], 6, "0")	+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")				+ "'"	+ CRLF
	cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

	if tcSQLExec( cUpdSA1 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		cLogErrors += "Não foi possível atualizar Cliente " + padL(aLinha[2], 6, "0") + "/" + padL(aLinha[3], 2, "0") + " com a Tabela de Preço " + padL( aLinha[1], 3, "0") + CRLF
	//else
		//cLogOk += "Cliente " + padL(aLinha[2], 6, "0") + "/" + padL(aLinha[3], 2, "0") + " atualizado com a Tabela de Preço " + padL(aLinha[1], 3, "0") + " com sucesso. " + CRLF
	endif

	//Caso Cliente seja do E-commerce
	//Update para Reenviar para E-commerce
	cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF	
	cUpdSA1 += "	SET"														+ CRLF
	cUpdSA1 += " 		A1_XINTECO = '0',"										+ CRLF
	cUpdSA1 += " 		A1_XENVECO = '1'"										+ CRLF
	cUpdSA1 += " WHERE"															+ CRLF
	cUpdSA1 += " 		A1_LOJA		=	'" + padL(aLinha[3], 2, "0")	+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_COD		=	'" + padL(aLinha[2], 6, "0")	+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")				+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_ZCDECOM	<>	' '"									+ CRLF
	cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

	if tcSQLExec( cUpdSA1 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		cLogErrors += "Não foi possível atualizar Cliente " + padL(aLinha[2], 6, "0") + "/" + padL(aLinha[3], 2, "0") + " com a Tabela de Preço " + padL( aLinha[1], 3, "0") + CRLF
	//else
		//cLogOk += "Cliente " + padL(aLinha[2], 6, "0") + "/" + padL(aLinha[3], 2, "0") + " atualizado com a Tabela de Preço " + padL(aLinha[1], 3, "0") + " com sucesso. " + CRLF
	endif	
	
return

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