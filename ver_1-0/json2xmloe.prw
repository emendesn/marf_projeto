#include "protheus.ch"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TBICONN.CH"

User Function Json2XmlOE()
// converter o arquivo pelo site:
// https://www.freeformatter.com/json-to-xml-converter.html#ad-output
// deixar as opçoes default do site para fazer a conversao
// salvar o arquivo convertido em um txt, do jeito que vem, sem mexer em nada

MsAguarde({|| ProcArq()},"Processando, aguarde...")

Return()


Static Function ProcArq()

nPula := 2
nCount := 0
aMat := {}
aCab := {}
aRod := {}
lCab := .T.
lVol := .F.

aAdd(aMat,{' <','<mgf:'})
aAdd(aMat,{'</','</mgf:'})
aAdd(aMat,{'<mgf:element>','<mgf:ITEMCARGA>'})
aAdd(aMat,{'<mgf:/element>','</mgf:ITEMCARGA>'})
aAdd(aMat,{'<mgf:/CABECALHO>','</mgf:CABECALHO>'})
aAdd(aMat,{'<mgf:/ITENS>','</mgf:ITENS>'})
aAdd(aMat,{'<mgf:/VOLUMES>','</mgf:VOLUMES>'})
aAdd(aMat,{'<mgf:VOLUMES>','<mgf:ITEMCARGA>','<mgf:VOLUMECARGA>'})
aAdd(aMat,{'<mgf:VOLUMES>','</mgf:ITEMCARGA>','</mgf:VOLUMECARGA>'})

aAdd(aCab,{'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mgf="http://www.totvs.com.br/MGFTAS02">'+CRLF+;
   '<soapenv:Header/>'+CRLF+;
   '<soapenv:Body>'+CRLF+;
      '<mgf:GRAVARCARGA>'+CRLF+;
         '<mgf:CARGA>'})

aAdd(aRod,{'</mgf:CARGA>'+CRLF+;
      '</mgf:GRAVARCARGA>'+CRLF+;
   '</soapenv:Body>'+CRLF+;
'</soapenv:Envelope>'})

cArq := cGetFile("Todos os Arquivos|*.txt", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " não foi selecionado. A conversão será abortada!","ATENCAO")
	Return
EndIf

// tenta gerar o arquivo novo
cArqNew := Subs(cArq,1,At(".",cArq)-1)+"_convertido"+Subs(cArq,At(".",cArq),4)
If File(cArqNew)
	If fErase(cArqNew) <> 0
		MsgStop("O arquivo " +cArqNew + " não consegue ser deletado. A conversão será abortada!","ATENCAO")
		Return()
	Endif	
EndIf

nHdlNew := FCreate(cArqNew,0)

// verifica o sucesso da operacao
If nHdlNew == -1
	MsgStop("Não foi possível criar o arquivo convertido.")
   	Return()
EndIf

// copia para novo arquivo desprezando linhas que não devem ir
nHdl := FT_FUSE(cArq)
FT_FGOTOP()
While !FT_FEOF() 
	lGravou := .F.
	// pula linhas que nao serao usadas
	While !FT_FEOF()
		If nCount >= nPula
			Exit
		Endif	
		FT_FSKIP()
		nCount++
	Enddo 
			
	If lCab
		cLinha := aCab[1][1]
		lCab := .F.
		If !Copylinha(cLinha)
			Return()
		Endif	
	Endif	

	cLinha := FT_FREADLN()

	For nCnt:=1 To Len(aMat)
		If Len(aMat[nCnt]) == 2
			If aMat[nCnt][1] $ cLinha
				cLinha := StrTran(cLinha,aMat[nCnt][1],aMat[nCnt][2])
			Endif
		Endif
		If "<mgf:VOLUMES>" $ cLinha
			lVol := .T.
		Endif
		If lVol
			If Len(aMat[nCnt]) == 3
				If aMat[nCnt][2] $ cLinha
					cLinha := StrTran(cLinha,aMat[nCnt][2],aMat[nCnt][3])
				Endif
			Endif
		Endif
	Next		

	If !Copylinha(cLinha)
		Return()
	Endif	
			
	FT_FSKIP()

	If FT_FREADLN() == "</root>" .or. FT_FREADLN() == "</mgf:root>" // ultima linha
		cLinha := aRod[1][1]
		If !Copylinha(cLinha)
			Return()
		Endif	

		Exit
	Endif	
EndDo

FT_FUSE(cArq)
//FT_FUSE()
fClose(nHdl)

FT_FUSE(cArqNew)
//FT_FUSE()
fClose(nHdlNew)

Alert("Fim")

Return()


Static Function CopyLinha(cLinha)

nRecArq := FT_FRecno()

FT_FUSE(cArqNew)
If FT_FLastRec() != 0
	While !FT_FEOF() 
		FT_FSKIP()
	Enddo
Endif	
lGravou := IIf(fWrite(nHdlNew,cLinha) == Len(cLinha),.T.,.F.)

If !lGravou
	APMsgStop("Erro ao gravar linha no arquivo de saida" + chr(13) + ;
	"Codigo do erro: " + AllTrim(Str(fError())), "ATENCAO" )
	Return(.F.)
Else
	If Subs(cLinha,Len(cLinha)-2,1) != Chr(13) .and. Subs(cLinha,Len(cLinha)-1,1) != Chr(10)
		FWrite(nHdlNew,CRLF)
	Endif	
EndIf

FT_FUSE(cArq)
FT_FGoto(nRecArq)

Return(.T.)

