#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
=====================================================================================
Programa............: MGFFAT46
Autor...............: Atilio Amarilla
Data................: 04/07/2017
Descricao / Objetivo: Rotina para impressao/envio para sistema WinPrint
Doc. Origem.........: FAT WINPRINT
Solicitante.........: Cliente
Uso.................: 
Obs.................: Integracao Protheus Faturamento x WinPrint
=====================================================================================
*/

User Function MGFFAT46(cIdEnt,cFilePrint,cCaminho,_DeNf,_AteNf,_Serie,_EntSai,_ImpVers)

Local oSetup
local nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN

Private cWinPrint	:= GetMV("MGF_FAT46A",,"\\spdwvapl052\WINPRINT1TST") //N_USAR_4")
Private lSrvPrint	:= GetMV("MGF_FAT46B",,.T.) // Gerar no Servidor

//MsgStop( cIdEnt )
/*
private mv_par01:=	_DeNf //de nf
private mv_par02:=	_AteNf //ate nf
private mv_par03:=	_Serie //serie
private mv_par04:=	2 //tipo: 2-saida/1-entrada
private mv_par05:=	Val(_ImpVers)//imprime no verso
private mv_par06:=2	//DANFE Simplificada = Nao
ConOut("#### Entrou na Function de Preparacao da DANFE ####")


SpedDanfe()
ConOut("#### Chamou a Function da DANFE ####")

Return
*/
/*
nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType      := aScan(aDevice,{|x| x == cDevice })

lAdjustToLegacy := .F.
lDisableSetup  := .T.
oPrinter := FWMSPrinter():New("Danfe.rel", IMP_PDF, lAdjustToLegacy, , lDisableSetup)
// Ordem obrig�toria de configura��o do relatorio
oPrinter:SetResolution(72)
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior 
oPrinter:cPathPDF := "c:\directory\" // Caso seja utilizada impressao em IMP_PDF
*/

oSetup:=FWPrintSetup():New(nFlags, "DANFE")
/*
PD_DESTINATION	1-Servidor		2-Local
PD_PRINTTYPE	1-Spool			6-PDF
PD_ORIENTATION	1-Retrato		2-Paisagem (DANFEIII)		
PD_PAPERSIZE	2-A4		
PD_PREVIEW		.F.
PD_VALUETYPE	"PDFCreator" (Spool)	"C:\" (PDF, caminho) 
PD_MARGIN		{}
*/
//oSetup:Activate()

oSetup:SetPropert(PD_DESTINATION , 1)
oSetup:SetPropert(PD_PRINTTYPE , 2 ) // oSetup:SetPropert(PD_PRINTTYPE , 6)//ou 1 verificar <<== SERJIN BLOCO ORIGINAL
oSetup:SetPropert(PD_ORIENTATION , 1)
oSetup:SetPropert(PD_PAPERSIZE , 2)
oSetup:SetPropert(PD_PREVIEW ,.F.)
oSetup:aOptions[PD_VALUETYPE]:=cWinPrint //"PDFCreator"//cCaminho
oSetup:SetPropert(PD_MARGIN , {60,60,60,60})



oDanfe := FWMSPrinter():New(cFilePrint	, ; // [01] < cFilePrintert >
							IMP_SPOOL	, ; // [02] [ nDevice]
							.F. 		, ; // [03] [ lAdjustToLegacy]
							cCaminho	, ; // [04] [ cPathInServer]
							.T. 		, ; // [05] [ lDisabeSetup ]
							.F. 		, ; // [06] [ lTReport]
							@oSetup		, ;	// [07] [ @oPrintSetup] 
							cWinPrint	, ; // [08] [ cPrinter] 
							lSrvPrint	)/*, ; // [09] [ lServer]
							.F.			, ; // [10] [ lPDFAsPNG]
							.T. 		, ; // [11] [ lRaw]
							.F.			, ; // [12] [ lViewPDF] 
							1			)   // [13] [ nQtdCopy]
							*/
// Lexmark MGF ET0021B728772F
// \\spdwvapl052\N_USAR_4
/*
If oDanfe:IsPrinterActive()
	ConOut(cWinPrint+" Ativa")
Else
	ConOut(cWinPrint+" Inativa")
EndIf
*/
private mv_par01:=	_DeNf //de nf
private mv_par02:=	_AteNf //ate nf
private mv_par03:=	_Serie //serie
private mv_par04:=	2 //tipo: 2-saida/1-entrada
private mv_par05:=	Val(_ImpVers)//imprime no verso
private mv_par06:=2	//DANFE Simplificada = Nao

U_PrtNfeSef(cIdEnt,,,@oDanfe, @oSetup, cFilePrint)	//danfeii

If !Empty(SF2->F2_CHVNFE) .And. Empty( SF2->F2_ZWINPRN )
	RecLock("SF2",.F.)
	SF2->F2_ZWINPRN := FWTimeStamp(2)
	SF2->( msUnlock() )
EndIf

FreeObj(oDanfe)
oDanfe := Nil

FreeObj(oSetup)
oSetup := Nil

//MS_FLUSH()

Return(.T.)