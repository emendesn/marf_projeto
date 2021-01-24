#Include "PRTOPDEF.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"
/*
Executa a rotina automática do embarque de exportação, ajustando os parametros recebidos a partir do MILE para o padrão da rotina e garantindo a execução no módulo 29 (SigaEEC)
*/
User Function MLAE100(aDados)
Local nModExec := nModulo
Local cModExec := cModulo
Local xRet
Private lEE7Auto := .T.

    If nModulo <> 29
        nModulo := 29
        cModulo := "EEC"
    EndIf
    aEval(aDados, {|x| x[1] := Alltrim(x[1]) })
    xRet := EECAE100(Nil, 4,{{"EEC", aDados}})
    If nModulo <> nModExec
        nModulo := nModExec
        cModulo := cModExec
    EndIf

Return xRet

/*
Executa a atualização do processo de embarque de exportação via MILE
*/
User Function ImpEmb()
Local cArquivo := ChooseFile()
Local oFWMILE := FWMILE():New()
Local cFilExec := cFilAnt

Local cPath		:= AllTrim(GetTempPath())///'C:\Temp'
LOCAL cDirDocs  := MsDocPath()
Local oExcelApp
Local oExcel    := FWMSEXCEL():New()
Local nAux      := 0
Local cFileName	:= "ERRO_XXE_"+ DTOS(dDataBase) +"_"+ STRTRAN(TIME(),":","")
Local cQuery    := ''
Local cTmpSF2Fil  := ''

    If !Empty(cArquivo)
        oFWMILE:SetLayout("DUE")
        oFWMILE:SetTXTFile(cArquivo)
        If oFWMILE:Activate()
            oFWMILE:Import()
            If oFWMILE:Error()
                MsgInfo("Ocorreram erros no processamento. Verifique as ocorrências no LOG do MILE.", "Aviso")
                IF Msgyesno("Deseja abrir planilha com status da integração")
                	cPlanName1	:=  "Erros_XXE"
					cWSheet1 := "Erro_XXE"
					oExcel:AddworkSheet(cPlanName1)

					oExcel:AddTable (cPlanName1,cWSheet1)

					oExcel:AddColumn(cPlanName1,cWSheet1,"Arquivo"	,1,1)
					oExcel:AddColumn(cPlanName1,cWSheet1,"Data"		,1,1)
					oExcel:AddColumn(cPlanName1,cWSheet1,"Layout"		,1,1)
					oExcel:AddColumn(cPlanName1,cWSheet1,"Origem"		,1,1)
					oExcel:AddColumn(cPlanName1,cWSheet1,"Erro"			,1,1)
					oExcel:AddColumn(cPlanName1,cWSheet1,"Complemento"		,1,1)

					Iif(Select("QRY_1") > 0, QRY_1->(DbCloseArea()),)

					cQuery := " SELECT XXE_FILE Arquivo, XXE_DATE Data, XXE_LAYOUT Layout, XXE_ORIGIN Origem, "
					//cQuery += " dbms_lob.substr( XXE_ERROR, dbms_lob.getlength(XXE_ERROR), 1) erro, " // PARA CLOB
					//cQuery += " dbms_lob.substr( XXE_COMPLE, dbms_lob.getlength(XXE_COMPLE), 1) Complemento "// PARA CLOB
					cQuery += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XXE_ERROR, 2000, 1)) Erro, "//Para BLOB
					cQuery += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XXE_COMPLE, 2000, 1)) Complemento "//Para BLOB
					cQuery += " FROM " + RetSqlName("XXE")
					cQuery += " WHERE D_E_L_E_T_ <> '*' "
					cQuery += " AND XXE_FILIAL	=  '"+ XFilial('XXE') + "'"
					cQuery += " and    XXE_DATE     = '"+  DTOS(ddatabase)  + "'"
					cQuery += " and    XXE_FILE     = '"+  cArquivo  + "'"

					dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'QRY_1',.T.,.T.)

					QRY_1->(dbGoTop())
					While !QRY_1->(EOF())
						oExcel:AddRow(cPlanName1,cWSheet1,{	QRY_1->Arquivo		,;
										QRY_1->Data		,;
		       							QRY_1->Layout		    ,;
			               				QRY_1->Origem      	,;
			                      		QRY_1->Erro	        ,;
			                      		QRY_1->Complemento     	})
						QRY_1->(DbSkip())
					Enddo

					oExcel:Activate()
					oExcel:GetXMLFile(cFileName+".xml")

					CpyS2T( GetSrvProfString( 'StartPath', "" ) +cFileName+".xml" , cPath, .T. )

					cArqLocal := cPath + cFileName+".xml"


					If ! ApOleClient( 'MsExcel' )
						MsgStop('MsExcel nao instalado')
						Return
					EndIf

					oExcelApp := MsExcel():New()
					oExcelApp:WorkBooks:Open(cArqLocal) // Abre uma planilha
					oExcelApp:SetVisible(.T.)

                Endif
            Else
                MsgInfo("Processamento finalizado", "Aviso")
            EndIf
            oFWMILE:Deactivate()
        Else
            MsgInfo("Ocorreram erros na execução do MILE: " + oFWMILE:GetError(),)
        EndIf
    Else
        MsgInfo("Arquivo não informado", "Aviso")
    EndIf

cFilAnt := cFilExec //Restaura a filial pois a mesma pode ter sido alterada durante a execução
Return NIL

/*Abre janela para seleção do arquivo*/
Static Function ChooseFile()

Local cTitle:= "Seleção de Arquivo"
Local cMask := "Arquivos Texto|*.txt
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE

    cFile := cGetFile(cMask,cTitle,nDefaultMask,cDefaultDir,,nOptions)

Return AllTrim(cFile)