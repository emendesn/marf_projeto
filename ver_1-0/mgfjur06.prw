#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFJUR06
Autor....:              Marcelo Carneiro
Data.....:              27/09/2019
Descricao / Objetivo:   Importar documentos SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Importar documentos
=====================================================================================
*/
User Function MGFJUR06

Local lConfirma := .F.
Local bGetDir   := {|| cDiretorio := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)}
Local aAreaNSZ  := NSZ->(GetArea())
Local nCont     := 1
Local nI        := ''
						
Private cDiretorio	:= Space(100)//'C:\TEMP\IMPORTA3.CSV' //Space(100)
Private oDlg
Private cLinha      := ''
Private aCampos     := {}
Private cProcesso   := ''
Private cArquivo    := ''
Private cArqEspaco  := ''
Private cCompleto   := ''
Private cArqExt     := ''
Private bFim        := .F.

dbSelectArea('NSZ')
NSZ->(dbSetOrder(6))

dbSelectArea('NUM')
NUM->(dbSetOrder(4))

Define MSDialog oDlg Title "Importar Documentos/Selecione o arquivo que tenha o caminho dos diretorios" FROM 000, 000  TO 086, 650 COLORS 0, 16777215 PIXEL 

	@ 010,006 Say "Arquivo:"
	@ 005,029 MSGet cDiretorio SIZE 210,10 Picture "@!"  Valid (Vazio() .OR. IIF(!File(AllTrim(cDiretorio)),(MsgStop("Arquivo Inválido!"),.F.),.T.)) When .F. Pixel OF  oDlg
	@ 005,240 BUTTON "..." SIZE 12,12 ACTION (Eval(bGetDir)) Pixel OF oDlg
	
	@ 02,262  BUTTON "Importar"  SIZE 60,12 ACTION (lConfirma := .T.,oDlg:End()) Pixel OF oDlg
	@ 16,262  BUTTON "Comparar"  SIZE 60,12 ACTION (Compara_TXT()) Pixel OF oDlg
	@ 30,262  BUTTON "Sair"      SIZE 60,12 ACTION (lConfirma := .F.,oDlg:End()) Pixel OF oDlg

Activate MSDialog oDlg Centered

IF lConfirma
	If Empty(cDiretorio)
		MsgStop("Caminho do arquivo em Branco!")
		Return
	Endif
	Ft_FUse(cDiretorio)
	nCont := 0
	While !FT_FEof() 
		cLinha    := FT_FReadLn()
		//cLinha    := DecodeUTF8(cLinha, "cp1252")
		aCampos   := SEPARA(cLinha,';')
		IF Len(aCampos) <>  3
            MsgAlert('O layout esperado é codigo_do_proecesso;caminho;nome_do_arquivo  !!')		
            Exit
		EndIF
		cProcesso  := Alltrim(aCampos[1]) // Processo
		cArquivo   := Alltrim(aCampos[3]) // Arquivo + extensão
		cArqEspaco := Rtrim(aCampos[3])   // Arquivo com espaço no começo
		bFim       := .T.
		cArqExt    := '' // Arquivo sem extensão
		For nI := Len(cArquivo) To 1 STEP -1
		    IF bFim 
		       IF SUBSTR(cArquivo,nI,1) =='.'
                   cArqExt := SUBSTR(cArquivo,1,nI-1)  	
                   bFim := .F.
                   Exit	       
		       EndIF
		    EndIF
		Next nI
		cCompleto := Alltrim(aCampos[2])+"\"+cArqEspaco // Arquivo
		IF NSZ->(!dbSeek(xFilial('NSZ')+cProcesso))
            IF MsgYESNO('Numero do Processo não encontrado !! Processo:'+cProcesso+'. Deseja Continuar?')		
            	FT_FSkip()
            	Loop
		    Else
            	Exit
		    EndIF
		EndIF
		IF !File(AllTrim(cCompleto))
            IF MsgYESNO('Arquivo não encontrado !! Arquivo:'+cCompleto+'. Deseja Continuar?')		
            	FT_FSkip()
            	Loop
		    Else
            	Exit
		    EndIF
		EndIF
		IF NUM->(dbSeek(xFilial('NUM')+PADR(cArqExt,TamSx3('NUM_DOC')[1])+'NSZ'+xFilial('NSZ')+NSZ->NSZ_COD))
	        FT_FSkip()
            Loop
		EndIF
		IF !CpyT2S(cCompleto,'\Spool',.F.,.F.) 
	         MsgAlert('Problema em copiar o arquivo para o servidor !! Arquivo:'+cCompleto)	
		Else	
			 J026Anexar("NSZ", xFilial("NSZ"), NSZ->NSZ_COD, NSZ->NSZ_COD, '\Spool\'+cArqEspaco)
			 nCont++
		EndIF
		FT_FSkip()
	EndDo
	MsgAlert('Importado ('+Alltrim(STR(nCont))+') documentos !!')
	Ft_FUse()
Endif

RestArea(aAreaNSZ)

Return 
******************************************************************************************************************************************************************	
Static Function Compara_TXT
Local cTexto1 := ''
Local cTexto2 := ''
Local cTexto3 := ''
Local cTexto  := ''
Local oMGet1 
Local oDlg1
Local nI      := 0 

If Empty(cDiretorio)
	MsgStop("Caminho do arquivo em Branco!")
	Return
Endif
Ft_FUse(cDiretorio)
While !FT_FEof() 
	cLinha    := FT_FReadLn()
//	cLinha    := DecodeUTF8(cLinha, "cp1252")
	aCampos   := SEPARA(cLinha,';')
	IF Len(aCampos) <> 3
        MsgAlert('O layout esperado é codigo_do_proecesso;caminho;nome_do_arquivo  !!')		
        Exit
	EndIF
	cProcesso  := Alltrim(aCampos[1]) // Processo
	cArquivo   := Alltrim(aCampos[3]) // Arquivo + extensão
	cArqEspaco := Rtrim(aCampos[3])   // Arquivo com espaço no começo
	bFim       := .T.
	cArqExt    := '' // Arquivo sem extensão
	For nI := Len(cArquivo) To 1 STEP -1
	    IF bFim 
	       IF SUBSTR(cArquivo,nI,1) =='.'
               cArqExt := SUBSTR(cArquivo,1,nI-1)  	
               bFim := .F.
               Exit	       
	       EndIF
	    EndIF
	Next nI
	cCompleto := Alltrim(aCampos[2])+"\"+cArqEspaco // Arquivo
	IF NSZ->(!dbSeek(xFilial('NSZ')+cProcesso))
        cTexto1 += cProcesso+' Arquivo : '+cCompleto+CRLF
	Else
		IF NUM->(dbSeek(xFilial('NUM')+PADR(cArqExt,TamSx3('NUM_DOC')[1])+'NSZ'+xFilial('NSZ')+NSZ->NSZ_COD))
			cTexto2 += cProcesso+' Arquivo : '+cCompleto+CRLF
		Else
		    cTexto3 += cProcesso+' Arquivo : '+cCompleto+CRLF
		EndIF
	EndIF
	FT_FSkip()
EndDo

Ft_FUse()

cTexto  := 'Processo não encontrados :'+CRLF
cTexto  += cTexto1+CRLF
cTexto  += 'Arquivos Importados :'+CRLF
cTexto  += cTexto2+CRLF
cTexto  += 'Arquivos NÃO Importados :'+CRLF
cTexto  += cTexto3+CRLF


Define MSDialog oDlg1 Title "Status" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL 

oMGet1 := TMultiGet():New( 004,004,{|u| If(PCount()>0,cTexto:=u,cTexto)},oDlg1,394,244,,,,,,.T.,,,{|| .T.},,,.F.)

Activate MSDialog oDlg1 Centered

Return