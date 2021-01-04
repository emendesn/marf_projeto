//Bibliotecas
#Include "Protheus.ch" 
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

/*/{Protheus.doc} MGFFATBZ
Função que gera a danfe e o xml de uma nota em uma pasta passada por parâmetro
@author Rodrigo Franco
@since 24/04/2020
@version 1.0
@param _cNota, characters, Nota que será buscada
@param _cSerie, characters, Série da Nota
@param cPasta, characters, Pasta que terá o XML e o PDF salvos
@type function
@example u_MGFFATBZ("000123ABC", "1", "C:\TOTVS\NF")
@obs Para o correto funcionamento dessa rotina, é necessário:
	1. Ter baixado e compilado o rdmake danfeii.prw
	2. Ter baixado e compilado o zSpedXML.prw - https://terminaldeinformacao.com/2017/12/05/funcao-retorna-xml-de-uma-nota-em-advpl/
/*/
User Function MGFFATBZ()
	Local aArea     := GetArea()
	Local _cFilial	:= SC5->C5_FILIAL
	Local _cNum		:= SC5->C5_NUM
	Local _cNota  	:= SC5->C5_NOTA
	Local _cSerie	:= SC5->C5_SERIE
	Local cPasta	:= "C:\TOTVS\" //GetTempPath()
	Local cIdent    := ""
	Local cArquivo  := ""
	Local oDanfe    := Nil
	Local lEnd      := .F.
	Local nTamNota  := TamSX3('F2_DOC')[1]
	Local nTamSerie := TamSX3('F2_SERIE')[1]
	Private PixelX
	Private PixelY
	Private nConsNeg
	Private nConsTex
	Private oRetNF
	Private lPtImpBol
	Private aNotasBol
	Private nColAux
//	Default _cNota   := SC5->C5_NOTA
//	Default _cSerie  := SC5->C5_SERIE
//	Default cPasta  := GetTempPath()
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK(_cFilial+_cNum+"01")
		_cNota 	:= SC6->C6_NOTA
		_cSerie	:= SC6->C6_SERIE
	ENDIF
	
	//Se existir nota
	If ! Empty(_cNota)
		//Pega o IDENT da empresa
		cIdent := RetIdEnti()
		
		//Se o último caracter da pasta não for barra, será barra para integridade
		If SubStr(cPasta, Len(cPasta), 1) != "\"
			cPasta += "\"
		EndIf
		
		//Gera o XML da Nota
		cArquivo := _cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
		zSpedXML(_cNota, _cSerie, cPasta + cArquivo  + ".xml", .F.)
		
		//Define as perguntas da DANFE
		Pergunte("NFSIGW",.F.)
		MV_PAR01 := PadR(_cNota,  nTamNota)     //Nota Inicial
		MV_PAR02 := PadR(_cNota,  nTamNota)     //Nota Final
		MV_PAR03 := PadR(_cSerie, nTamSerie)    //Série da Nota
		MV_PAR04 := 2                          //NF de Saida
		MV_PAR05 := 2                          //Frente e Verso = Nao
		MV_PAR06 := 2                          //DANFE simplificado = Nao
		
		//Cria a Danfe
		oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T.)
		
		//Propriedades da DANFE
		oDanfe:SetResolution(78)
		oDanfe:SetPortrait()
		oDanfe:SetPaperSize(DMPAPER_A4)
		oDanfe:SetMargin(60, 60, 60, 60)
		
		//Força a impressão em PDF
		oDanfe:nDevice  := 6
		oDanfe:cPathPDF := cPasta				
		oDanfe:lServer  := .F.
		oDanfe:lViewPDF := .T.

	//	oDanfe:lServer := .T.
	//	oDanfe:nDevice := IMP_SPOOL
		
		//Variáveis obrigatórias da DANFE
		PixelX    := oDanfe:nLogPixelX()
		PixelY    := oDanfe:nLogPixelY()
		nConsNeg  := 0.4
		nConsTex  := 0.5
		oRetNF    := Nil
		lPtImpBol := .F.
		aNotasBol := {}
		nColAux   := 0
		
		//Chamando a impressão da danfe no RDMAKE
		RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
		
		oDanfe:Print()
	EndIf
	
FreeObj(oDanfe)
oDanfe := Nil

	RestArea(aArea)
Return





/*/{Protheus.doc} zSpedXML
Função que gera o arquivo xml da nota (normal ou cancelada) através do documento e da série disponibilizados
@author Rodrigo Franco
@since 24/04/2020
@version 1.0
@param cDocumento, characters, Código do documento (F2_DOC)
@param _cSerie, characters, Série do documento (F2_SERIE)
@param cArqXML, characters, Caminho do arquivo que será gerado (por exemplo, C:\TOTVS\arquivo.xml)
@param lMostra, logical, Se será mostrado mensagens com os dados (erros ou a mensagem com o xml na tela)
@type function
@example Segue exemplo abaixo
u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo1.xml", .F.) //Não mostra mensagem com o XML
u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo2.xml", .T.) //Mostra mensagem com o XML
/*/
Static Function zSpedXML(cDocumento, _cSerie, cArqXML, lMostra)
Local aArea        := GetArea()
Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)  
Local oWebServ
Local cIdEnt       := StaticCall(SPEDNFE, GetIdEnt)
Local cTextoXML    := ""
Default cDocumento := ""
Default _cSerie     := ""
Default cArqXML    := GetTempPath()+"arquivo_"+_cSerie+cDocumento+".xml"
Default lMostra    := .F.
//Se tiver documento
If !Empty(cDocumento)
cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
_cSerie     := PadR(_cSerie,     TamSX3('F2_SERIE')[1])
//Instancia a conexão com o WebService do TSS    
oWebServ:= WSNFeSBRA():New()
oWebServ:cUSERTOKEN        := "TOTVS"
oWebServ:cID_ENT           := cIdEnt
oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (_cSerie+cDocumento)
oWebServ:nDIASPARAEXCLUSAO := 0
oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"   
//Se tiver notas
If oWebServ:RetornaNotas()
//Se tiver dados
If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
//Se tiver sido cancelada
If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
//Senão, pega o xml normal
Else
cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
EndIf
//Gera o arquivo
MemoWrite(cArqXML, cTextoXML)
//Se for para mostrar, será mostrado um aviso com o conteúdo
If lMostra
Aviso("zSpedXML", cTextoXML, {"Ok"}, 3)
EndIf
//Caso não encontre as notas, mostra mensagem
Else
ConOut("zSpedXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+_cSerie+")...")
If lMostra
Aviso("zSpedXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+_cSerie+")...", {"Ok"}, 3)
EndIf
EndIf
//Senão, houve erros na classe
Else
ConOut("zSpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
If lMostra
Aviso("zSpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
EndIf
EndIf
EndIf
RestArea(aArea)
Return