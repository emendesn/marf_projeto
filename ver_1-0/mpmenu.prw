#Include "Protheus.ch"
#Include "TopConn.ch"

User Function MpMenu()
Local aRet      := {}
Local aParamBox := {}
Local aCombo    := {"Modulo","Função"}

	aAdd(aParamBox,{3,"Escolher opção de seleção do menu",1,aCombo,30,"", .F. })
	aAdd(aParamBox,{1,"Informar nome da opção:",Space(20),"","","","",0, .F. })

	If ParamBox(aParamBox,"Planilha de Menu...",@aRet)
	   u_zQryMenu(aRet[1],aRet[2])
	Endif

Return












User Function zQryMenu(nProc,cField)
	Local cQry    := ""
	Local cTitulo := "Menu Protheus"















    Local cDb := Iif(TCGETDB() == "ORACLE","||","+")

	cQry:="SELECT RTRIM(A.M_NAME) MODULO" + Chr(13)+Chr(10)
	cQry+="      ,RTRIM(D.F_FUNCTION)"+cDb+"' - '"+cDb+"RTRIM(B.N_DESC) ROTINA"  + Chr(13)+Chr(10)
	cQry+="      ,(SELECT RTRIM(B.N_DESC) FROM MPMENU_I18N B WHERE B.N_PAREN_ID = C.I_FATHER AND B.N_LANG = '1') MENU " + Chr(13)+Chr(10)
	cQry+="  FROM MPMENU_MENU A" + Chr(13)+Chr(10)
	cQry+="      ,MPMENU_I18N B" + Chr(13)+Chr(10)
	cQry+="      ,MPMENU_ITEM C"  + Chr(13)+Chr(10)
	cQry+="      ,MPMENU_FUNCTION D" + Chr(13)+Chr(10)
	cQry+=" WHERE D.F_ID       = C.I_ID_FUNC" + Chr(13)+Chr(10)
	cQry+="   AND C.I_ID       = B.N_PAREN_ID " + Chr(13)+Chr(10)
	cQry+="   AND C.I_ID_MENU  = A.M_ID" + Chr(13)+Chr(10)

	If nProc == 1
		cQry+="   AND A.M_NAME  = '"+AllTrim(cField)+"'" + Chr(13)+Chr(10)

	Else
		cQry+="   AND D.F_FUNCTION = '"+AllTrim(cField)+"'" + Chr(13)+Chr(10)
	EndIf
	cQry+="   AND B.N_LANG = '1'" + Chr(13)+Chr(10)
	cQry+="   AND A.M_NAME NOT LIKE '#BKP%' " + Chr(13)+Chr(10)
	cQry+="   AND A.D_E_L_E_T_ = ' '" + Chr(13)+Chr(10)
	cQry+="   AND B.D_E_L_E_T_ = ' '" + Chr(13)+Chr(10)
	cQry+="   AND C.D_E_L_E_T_ = ' '" + Chr(13)+Chr(10)
	cQry+="   AND D.D_E_L_E_T_ = ' '" + Chr(13)+Chr(10)
	cQry+="ORDER BY 1,C.I_ORDER "

	u_zQry2Excel(cQry, cTitulo)

Return













User Function zQry2Excel(cQryAux,cTitAux)
    cQryAux := If( cQryAux == nil, "", cQryAux ) 
    cTitAux := If( cTitAux == nil, "Título", cTitAux ) 

    Processa({|| fProcessa(cQryAux, cTitAux) }, "Gerando Planilha...")
Return






Static Function fProcessa(cQryAux, cTitAux)
    Local aArea       := GetArea()
    Local aAreaX3     := SX3->(GetArea())
    Local nAux        := 0
    Local oFWMsExcel
    Local oExcel
    Local cDiretorio  := GetTempPath()
    Local cArquivo    := "menu_protheus.xml"
    Local cArqFull    := cDiretorio + cArquivo
    Local cWorkSheet  := "Aba - Principal"
    Local cTable      := ""
    Local aColunas    := {}
    Local aEstrut     := {}
    Local aLinhaAux   := {}
    Local cTitulo     := ""
    Local nTotal      := 0
    Local nAtual      := 0
    cQryAux := If( cQryAux == nil, "", cQryAux ) 
    cTitAux := If( cTitAux == nil, "Título", cTitAux ) 

    cTable := cTitAux


    If !Empty(cQryAux)
        dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryAux), "QRY_AUX" , .F. , .T. )

        DbSelectArea("SX3")
        SX3->(DbSetOrder(2))


        aEstrut := QRY_AUX->(DbStruct())
        ProcRegua(Len(aEstrut))
        For nAux := 1 To Len(aEstrut)
            IncProc("Incluindo coluna "+cValToChar(nAux)+" de "+cValToChar(Len(aEstrut))+"...")
            cTitulo := ""


            If SX3->(DbSeek(aEstrut[nAux][1]))
                cTitulo := Alltrim(SX3->X3_TITULO)


                If SX3->X3_TIPO == "D"
                    TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
                EndIf
            Else
                cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
            EndIf


            aAdd(aColunas, cTitulo)
        Next


        oFWMsExcel := FWMSExcel():New()
        oFWMsExcel:AddworkSheet(cWorkSheet)
            oFWMsExcel:AddTable(cWorkSheet, cTable)


            For nAux := 1 To Len(aColunas)
                oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
            Next


            DbSelectArea("QRY_AUX")
            QRY_AUX->(DbGoTop())
            nTotal := 0; DBEval( {|| nTotal := nTotal + 1},,,,,.F. )
            ProcRegua(nTotal)
            nAtual := 0


            QRY_AUX->(DbGoTop())
            While !QRY_AUX->(EoF())
                nAtual++
                IncProc("Processando registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")


                aLinhaAux := Array(Len(aColunas))
                For nAux := 1 To Len(aEstrut)
                    aLinhaAux[nAux] := &("QRY_AUX->"+aEstrut[nAux][1])
                Next


                oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)

                QRY_AUX->(DbSkip())
            EndDo


        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cArqFull)


        If ApOleClient("msexcel")
            oExcel := MsExcel():New()
            oExcel:WorkBooks:Open(cArqFull)
            oExcel:SetVisible( .T. )
            oExcel:Destroy()

        Else

            If ExistDir("C:\Program Files (x86)\LibreOffice 5")
                WaitRun('C:\Program Files (x86)\LibreOffice 5\program\scalc.exe "'+cDiretorio+cArquivo+'"', 1)


            Else
                ShellExecute("open", cArquivo, "", cDiretorio, 1)
            EndIf
        EndIf

        QRY_AUX->(DbCloseArea())
    EndIf

    RestArea(aAreaX3)
    RestArea(aArea)
Return
