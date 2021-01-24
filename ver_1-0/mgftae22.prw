#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFTAE22
Autor....:              Marcelo Carneiro         
Data.....:              11/05/2016 
Descricao / Objetivo:   Relatorio de Ar
Doc. Origem:            TAura - Entrada - Carga Fria
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relatorio de do Resultado do AR
=====================================================================================
*/
User Function MGFTAE22
Local aReg   := {}
Local cQuery := ''
Local nPos   := 0 
Local aAux   := {}
Private aRelImp := {}      
Private cPerg   := 'MGFEST20'
Private oReport   


aRelImp := {}      

cQuery := " Select * "
cQuery += " FROM "+RetSqlName('ZZI')
cQuery += " Where ZZI_FILIAL = '"+ZZH->ZZH_FILIAL+"'"
cQuery += "  AND ZZI_AR = '"+ZZH->ZZH_AR+"'"
cQuery += "  AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZI_ITEM" 

If Select("QRY_ZZI") > 0
	QRY_ZZI->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZI",.T.,.F.)
dbSelectArea("QRY_ZZI")    
QRY_ZZI->(dbGoTop())
While QRY_ZZI->(!Eof())
	aReg := {}
	AADD(aReg,QRY_ZZI->ZZI_ITEM)  
	AADD(aReg,QRY_ZZI->ZZI_PRODUT)
	AADD(aReg,QRY_ZZI->ZZI_DESC)
	AADD(aReg,QRY_ZZI->ZZI_LOCAL)
	AADD(aReg,QRY_ZZI->ZZI_QNF)
	AADD(aReg,QRY_ZZI->ZZI_QCONT)
	AADD(aReg,QRY_ZZI->ZZI_QNF-QRY_ZZI->ZZI_QCONT) 
	AADD(aReg,QRY_ZZI->ZZI_QDEV)
	AADD(aReg,QRY_ZZI->ZZI_QCOMPL)
	AADD(aReg,QRY_ZZI->ZZI_AJUSTE)
	AADD(aReg,QRY_ZZI->ZZI_DOC)
	AADD(aReg,QRY_ZZI->ZZI_SERIE)   
	AADD(aReg,QRY_ZZI->ZZI_OBS)	     
	AADD(aRelImp,aReg) 
	QRY_ZZI->(dbSKIP())
EndDo
                           
oReport := RelTAE22()
oReport:PrintDialog()

Return
***********************************************************************************************************************
Static Function RelTAE22

Local oReport
Local oImp        
Local oCab1
Local oCab2
Local oCab3

oReport := TReport():New("TAE22","Relatório de AR",,{|oReport| PrintReport(oReport)},"Relatório de AR")
//oReport:SetLandscape()
oReport:SetPortrait()
oCab1 := TRSection():New(oReport,"Linha1","ZZH")
oCab2 := TRSection():New(oReport,"Linha2","ZZH")
oCab3 := TRSection():New(oReport,"Linha3","ZZH")
oImp  := TRSection():New(oReport,"Itens","ZZI")

TRCell():New(oCab1,"rFILIAL"   ,,"" ,,100,.F.,) 
TRCell():New(oCab1,"rAR"       ,,"" ,,100,.F.,) 
TRCell():New(oCab2,"rFORNEC"   ,,"" ,,100,.F.,) 
TRCell():New(oCab2,"rNOME"     ,,"" ,,100,.F.,) 
TRCell():New(oCab3,"rNF"       ,,"" ,,100,.F.,) 
TRCell():New(oCab3,"rCNF"      ,,"" ,,100,.F.,) 


TRCell():New(oIMP,"rITEM"  ,,"Item"          ,,TamSX3("ZZI_ITEM")[1],.F.,)  
TRCell():New(oIMP,"rPRODUT",,"Produto"       ,,TamSX3("ZZI_PRODUT")[1],.F.,)
TRCell():New(oIMP,"rDESC"  ,,"Descrição"     ,,TamSX3("ZZI_DESC")[1],.F.,)
TRCell():New(oIMP,"rLOCAL" ,,"Local"         ,,TamSX3("ZZI_LOCAL")[1],.F.,)
TRCell():New(oIMP,"rQNF"   ,,"Qtde. NF"      ,,TamSX3("ZZI_QNF")[1],.F.,)
TRCell():New(oIMP,"rQCONT" ,,"Qtde.Contada"  ,,TamSX3("ZZI_QCONT")[1],.F.,)
TRCell():New(oIMP,"rDIF"   ,,"Diferença"     ,,TamSX3("ZZI_QDEV")[1],.F.,) 
TRCell():New(oIMP,"rQDEV"  ,,"Qtde. Dev."    ,,TamSX3("ZZI_QDEV")[1],.F.,)
TRCell():New(oIMP,"rQCOMPL",,"Qtde. Compl"   ,,TamSX3("ZZI_QCOMPL")[1],.F.,)
TRCell():New(oIMP,"rAJUSTE",,"Qtde. Ajuste"  ,,TamSX3("ZZI_AJUSTE")[1],.F.,)
TRCell():New(oIMP,"rDOC"   ,,"NF Acerto"     ,,TamSX3("ZZI_DOC")[1],.F.,)
TRCell():New(oIMP,"rSERIE" ,,"Serie"         ,,TamSX3("ZZI_SERIE")[1],.F.,)   
TRCell():New(oIMP,"rOBS"   ,,"Observação"    ,,TamSX3("ZZI_OBS")[1],.F.,)


Return oReport

***********************************************************************************************************************
Static Function PrintReport(oReport)
Local nI := 0
Local nX := 0 

oReport:SetMeter(LEN(aRelImp))
oReport:IncMeter()                       
oReport:Section(1):Init()
oReport:Section(1):Cell("rFILIAL"):SetBlock({||'FILIAL: '+ZZH->ZZH_FILIAL })
oReport:Section(1):Cell("rAR"):SetBlock({||'AR: '+ZZH->ZZH_AR })
oReport:Section(1):PrintLine()
oReport:Section(1):Finish()                                                                                               
oReport:Section(2):Init()
oReport:Section(2):Cell("rFORNEC"):SetBlock({||'Fornecedor: '+Alltrim(ZZH->ZZH_FORNEC)+'-'+ZZH->ZZH_LOJA })
oReport:Section(2):Cell("rNOME"):SetBlock({||'Razão Social: '+ZZH->ZZH_NOME })
oReport:Section(2):PrintLine()
oReport:Section(2):Finish()                                                                                               
oReport:Section(3):Init()
oReport:Section(3):Cell("rNF"):SetBlock({||'Nota Fiscal: '+ZZH->ZZH_DOC+'-'+ZZH->ZZH_SERIE })
oReport:Section(3):Cell("rCNF"):SetBlock({||'CNF: '+ZZH->ZZH_CNF })
oReport:Section(3):PrintLine()
oReport:Section(3):Finish()                                                                                               

oReport:ThinLine()
oReport:Section(4):Init()
For nI := 1 To LEN(aRelImp)
	IF oReport:Cancel()
		Exit
	Endif
	oReport:Section(4):Cell("rITEM"  ):SetBlock({|| aRelImp[nI,01] })
	oReport:Section(4):Cell("rPRODUT"):SetBlock({|| aRelImp[nI,02] })
	oReport:Section(4):Cell("rDESC"  ):SetBlock({|| aRelImp[nI,03] })
	oReport:Section(4):Cell("rLOCAL" ):SetBlock({|| aRelImp[nI,04] })
	oReport:Section(4):Cell("rQNF"   ):SetBlock({|| aRelImp[nI,05] })
	oReport:Section(4):Cell("rQCONT" ):SetBlock({|| aRelImp[nI,06] })
	oReport:Section(4):Cell("rDIF"   ):SetBlock({|| aRelImp[nI,07] })
	oReport:Section(4):Cell("rQDEV"  ):SetBlock({|| aRelImp[nI,08] })
	oReport:Section(4):Cell("rQCOMPL"):SetBlock({|| aRelImp[nI,09] })
	oReport:Section(4):Cell("rAJUSTE"):SetBlock({|| aRelImp[nI,10] })
	oReport:Section(4):Cell("rDOC"   ):SetBlock({|| aRelImp[nI,11] })
	oReport:Section(4):Cell("rSERIE" ):SetBlock({|| aRelImp[nI,12] })
	oReport:Section(4):Cell("rOBS"   ):SetBlock({|| aRelImp[nI,13] })
	oReport:Section(4):PrintLine()
NEXT
oReport:Section(2):Finish()                                                                                               


Return oReport

