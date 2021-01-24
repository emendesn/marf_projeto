#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFEST20
Autor....:              Marcelo Carneiro         
Data.....:              16/09/2016 
Descricao / Objetivo:   Controle de endereço do armazem central
Doc. Origem:            MGFPER01 - Contrato
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relatorio de Saldos/Endereços/Locais
=====================================================================================
*/
User Function MGFEST20 
Local oReport   
Local aReg   := {}
Local cQuery := ''
Local nPos   := 0 
Local aAux   := {}
Private cFilCD  := GetMV('MGF_FILCD',.F.,"'010001','010002','010003','010005'")
Private aRelImp := {}      
Private cPerg   := 'MGFEST20'

If !Pergunte(cPerg,.T.)
	lContinua	:= .F.
	Return
EndIf
aRelImp := {}      

cQuery := " Select SBF.*, B1_DESC "
cQuery += " FROM "+RetSqlName('SBF') + " SBF , "+RetSqlName('SB1') + " SB1 "
cQuery += " Where BF_FILIAL IN ("+cFilCD+")"
cQuery += " 	AND SBF.BF_PRODUTO = SB1.B1_COD "
cQuery += " 	AND SBF.D_E_L_E_T_ = ' ' "
cQuery += " 	AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "     AND BF_QUANT > 0 "
cQuery += " 	AND SBF.BF_PRODUTO >= '"+MV_PAR01+"'"
cQuery += " 	AND SBF.BF_PRODUTO <= '"+MV_PAR02+"'"
cQuery += " 	AND SBF.BF_LOCAL >= '"+MV_PAR03+"'"
cQuery += " 	AND SBF.BF_LOCAL <= '"+MV_PAR04+"'"
cQuery += " 	AND SB1.B1_GRUPO >= '"+MV_PAR05+"'"
cQuery += " 	AND SB1.B1_GRUPO <= '"+MV_PAR06+"'"
cQuery += " ORDER BY SBF.BF_LOCAL" 

If Select("QRY_BF") > 0
	QRY_BF->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_BF",.T.,.F.)
dbSelectArea("QRY_BF")    
QRY_BF->(dbGoTop())
While QRY_BF->(!Eof())
	aReg := {}
	AADD(aReg,QRY_BF->BF_FILIAL)
	AADD(aReg,QRY_BF->BF_PRODUTO)  
	AADD(aReg,QRY_BF->B1_DESC) 
	AADD(aReg,QRY_BF->BF_LOCALIZ)
	AADD(aReg,QRY_BF->BF_QUANT ) 
	AADD(aReg,QRY_BF->BF_EMPENHO)  
	nPos := aScan(aRelImp,{|X| X[1] == QRY_BF->BF_LOCAL})
	IF nPos == 0 
	     AADD(aRelImp,{QRY_BF->BF_LOCAL,QRY_BF->BF_LOCALIZ+'#',1,{aReg}}) 
	Else
	     aAux   := aRelImp[nPos,4]
	     AADD(aAux,aReg)
	     aRelImp[nPos,4] := aAux
	     IF !(QRY_BF->BF_LOCALIZ $ aRelImp[nPos,2])
	        aRelImp[nPos,2] += QRY_BF->BF_LOCALIZ+'#'
	        aRelImp[nPos,3] += 1
	     EndIF                 
	EndIF
	QRY_BF->(dbSKIP())
EndDo
                           
oReport := RelEST20()
oReport:PrintDialog()

Return
***********************************************************************************************************************
Static Function RelEST20

Local oReport
Local oImp

oReport := TReport():New("EST20","Relatório de Saldos por Armazém Central",,{|oReport| PrintReport(oReport)},"Relatorio de Saldos")
//oReport:SetLandscape()
oReport:SetPortrait()
oCab := TRSection():New(oReport,"Locais","EST20")
oImp := TRSection():New(oReport,"Detalhes","EST20")

TRCell():New(oCab,"rLocal"       ,,"Local"           ,,20,.F.,) 
TRCell():New(oCab,"rQuant"       ,,"Total Endereços" ,,20,.F.,) 
TRCell():New(oIMP,"rFilial"      ,,"Filial"      ,,TamSX3("BF_FILIAL")[1],.F.,) 
TRCell():New(oIMP,"rCodigo"      ,,"Código"      ,,TamSX3("BF_PRODUTO")[1],.F.,) 
TRCell():New(oImp,"rDescricao"   ,,"Descriçao"   ,,TamSX3("B1_DESC")[1],.F.,) 
TRCell():New(oImp,"rEndereco"    ,,"Endereço"    ,,TamSX3("BF_LOCALIZ")[1],.F.,)
TRCell():New(oImp,"rSaldo"       ,,"Saldo"       ,,TamSX3("BF_QUANT")[1],.F.,) 
TRCell():New(oImp,"rEmpenho"     ,,"Empenho"     ,,TamSX3("BF_EMPENHO")[1],.F.,)

Return oReport

***********************************************************************************************************************
Static Function PrintReport(oReport)
Local nI := 0
Local nX := 0 

oReport:SetMeter(LEN(aRelImp))
For nI := 1 To LEN(aRelImp)
	IF oReport:Cancel()
		Exit
	Endif
	oReport:IncMeter()       
	oReport:Section(1):Init()     
	oReport:Section(1):Cell("rLocal"):SetBlock({|| aRelImp[nI,1] })
	oReport:Section(1):Cell("rQuant"):SetBlock({|| aRelImp[nI,3] })
	oReport:Section(1):PrintLine()                                 
	oReport:Section(2):Init()
	For nX := 1 To LEN(aRelImp[nI,4])
		oReport:Section(2):Cell("rFilial"):SetBlock({|| aRelImp[nI,4][nX][1] })
		oReport:Section(2):Cell("rCodigo"):SetBlock({|| aRelImp[nI,4][nX][2] })
		oReport:Section(2):Cell("rDescricao"):SetBlock({|| aRelImp[nI,4][nX][3] })
		oReport:Section(2):Cell("rEndereco"):SetBlock({|| aRelImp[nI,4][nX][4] })
		oReport:Section(2):Cell("rSaldo"):SetBlock({|| aRelImp[nI,4][nX][5] })
		oReport:Section(2):Cell("rEmpenho"):SetBlock({|| aRelImp[nI,4][nX][6] })
		oReport:Section(2):PrintLine()
	Next nX
    oReport:Section(2):Finish()                                                                                               
    oReport:ThinLine()
    oReport:Section(1):Finish()                                                                                                
NEXT

Return oReport

