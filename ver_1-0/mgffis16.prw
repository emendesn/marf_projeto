#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFFIS16
Autor....:              Marcelo Carneiro         
Data.....:              06/02/2017
Descricao / Objetivo:   Relatorio do Fundepec
Doc. Origem:            Contrato de Gaps - GAP FIS20
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFIS16 

Private aRelImp   := {}   
Private aParambox := {}     
Private aRet      := {}                        
Private nTotal    := 0 


AAdd(aParamBox, {1, "Emissão de"		, CToD(Space(8))																											, 							, , 		,	, 070	, .T.	})
AAdd(aParamBox, {1, "Emissão até"		, CToD(Space(8))																											, 							, , 		,	, 070	, .T.	})
IF ParamBox(aParambox, "Relatorio Fundepec"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
    Processa( {|| U_FIS16() },'Aguarde...', 'Montando o Relatorio',.F. )
EndIF	
Return
***********************************************************************************************************************
User Function FIS16 
Local oReport   
Local aReg   := {}
Local cQuery := ''


aRelImp := {}
cQuery := " Select SD1.*, B1_DESC "
cQuery += " FROM "+RetSqlName('SD1') + " SD1 , "+RetSqlName('SB1') + " SB1 "
cQuery += " Where SD1.D1_COD     = SB1.B1_COD "
cQuery += "   AND SD1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SD1.D1_FILIAL  = '"+xFilial('SD1')+"'"
cQuery += "   AND SD1.D1_EMISSAO >= '"+DTOS(MV_PAR01)+"'"
cQuery += "   AND SD1.D1_EMISSAO <= '"+DTOS(MV_PAR02)+"'"
cQuery += "   AND D1_VALIMPF     > 0 " /// TEVE O IMPOSTO.
cQuery += " ORDER BY D1_EMISSAO, D1_DOC, D1_SERIE"
If Select("QRY_SD1") > 0
	QRY_SD1->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD1",.T.,.F.)
dbSelectArea("QRY_SD1")
QRY_SD1->(dbGoTop())
While QRY_SD1->(!Eof())
	aReg := {}
	AADD(aReg,QRY_SD1->D1_FILIAL)
	AADD(aReg,QRY_SD1->D1_EMISSAO)
	AADD(aReg,QRY_SD1->D1_DOC)
	AADD(aReg,QRY_SD1->D1_SERIE)
	AADD(aReg,QRY_SD1->D1_FORNECE)
	AADD(aReg,QRY_SD1->D1_LOJA )
	AADD(aReg,GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+QRY_SD1->D1_FORNECE+QRY_SD1->D1_LOJA,1,"") )
	AADD(aReg,QRY_SD1->D1_COD )
	AADD(aReg,QRY_SD1->B1_DESC )
	AADD(aReg,QRY_SD1->D1_QUANT )
	AADD(aReg,QRY_SD1->D1_VUNIT )
	AADD(aReg,QRY_SD1->D1_BASIMPF)
	AADD(aReg,QRY_SD1->D1_ALQIMPF)
	AADD(aReg,QRY_SD1->D1_VALIMPF)
	nTotal    += QRY_SD1->D1_VALIMPF
	AADD(aRelImp,aReg)
	QRY_SD1->(dbSKIP())
EndDo
oReport := RelFis20()
oReport:PrintDialog()
Return
***********************************************************************************************************************
Static Function RelFis20

Local oReport
Local oImp
Local oTot

oReport := TReport():New("FIS20","Relatório FUNDEPEC - GO",,{|oReport| PrintReport(oReport)},"Relatorio FUNDEPEC - GO")
oReport:SetLandscape()                        
//oReport:SetPortrait()
oImp := TRSection():New(oReport,"Detalhes","")
oTot := TRSection():New(oReport,"Total","")
TRCell():New(oIMP,"rFilial"      ,,"Filial"      ,,TamSX3("D1_FILIAL")[1],.F.,) 
TRCell():New(oIMP,"rEmissao"     ,,"Emissão"     ,,TamSX3("D1_EMISSAO")[1],.F.,) 
TRCell():New(oIMP,"rDoc"         ,,"NF"          ,,TamSX3("D1_DOC")[1],.F.,) 
TRCell():New(oImp,"rSerie"       ,,"Série"       ,,TamSX3("D1_SERIE")[1],.F.,) 
TRCell():New(oImp,"rFornece"     ,,"Fornecedor"  ,,TamSX3("D1_FORNECE")[1],.F.,)
TRCell():New(oImp,"rLoja"        ,,"Loja"        ,,TamSX3("D1_LOJA")[1],.F.,) 
TRCell():New(oImp,"rNome"        ,,"Nome"        ,,TamSX3("A2_NOME")[1],.F.,)
TRCell():New(oIMP,"rCod"         ,,"Código"      ,,TamSX3("D1_COD")[1],.F.,) 
TRCell():New(oIMP,"rDesc"        ,,"Descrição"   ,,TamSX3("B1_DESC")[1],.F.,) 
TRCell():New(oIMP,"rQuant"       ,,"Quant."      ,,TamSX3("D1_QUANT")[1],.F.,) 
TRCell():New(oImp,"rVunit"       ,,"V. Unit"     ,,TamSX3("D1_VUNIT")[1],.F.,) 
TRCell():New(oImp,"rBase"        ,,"Base"        ,,TamSX3("D1_BASIMPF")[1],.F.,)
TRCell():New(oImp,"rAliq"        ,,"Aliq."       ,,TamSX3("D1_ALQIMPF")[1],.F.,) 
TRCell():New(oImp,"rImposto"     ,,"V.Imposto"   ,,TamSX3("D1_VALIMPF")[1],.T.,)

TRCell():New(oTot,"rTotal"        ,,"Total"       ,,100,.F.,) 

Return oReport

***********************************************************************************************************************
Static Function PrintReport(oReport)
Local nI := 0

oReport:SetMeter(LEN(aRelImp))
For nI := 1 To LEN(aRelImp)
	IF oReport:Cancel()
		Exit
	Endif
	oReport:IncMeter()       
	oReport:Section(1):Init()     
	oReport:Section(1):Cell("rFilial"   ):SetBlock({|| aRelImp[nI,1] })
	oReport:Section(1):Cell("rEmissao"  ):SetBlock({|| aRelImp[nI,2] })
	oReport:Section(1):Cell("rDoc"      ):SetBlock({|| aRelImp[nI,3] })
	oReport:Section(1):Cell("rSerie"    ):SetBlock({|| aRelImp[nI,4] })
	oReport:Section(1):Cell("rFornece"  ):SetBlock({|| aRelImp[nI,5] })
	oReport:Section(1):Cell("rLoja"     ):SetBlock({|| aRelImp[nI,6] })
	oReport:Section(1):Cell("rNome"     ):SetBlock({|| aRelImp[nI,7] })
	oReport:Section(1):Cell("rCod"      ):SetBlock({|| aRelImp[nI,8] })
	oReport:Section(1):Cell("rDesc"     ):SetBlock({|| aRelImp[nI,9] })
	oReport:Section(1):Cell("rQuant"    ):SetBlock({|| aRelImp[nI,10] })
	oReport:Section(1):Cell("rVunit"    ):SetBlock({|| aRelImp[nI,11] })
	oReport:Section(1):Cell("rBase"     ):SetBlock({|| aRelImp[nI,12] })
	oReport:Section(1):Cell("rAliq"     ):SetBlock({|| aRelImp[nI,13] })
	oReport:Section(1):Cell("rImposto"  ):SetBlock({|| aRelImp[nI,14] })
	oReport:Section(1):PrintLine()
NEXT
oReport:Section(1):Finish()                                                                                                
oReport:Section(2):Init()     
oReport:Section(2):Cell("rTotal"   ):SetBlock({|| 'T O T A L  G E R A L  : '+Alltrim(STR(nTotal))  })
oReport:Section(2):PrintLine()
oReport:Section(2):Finish()                                                                                                

Return oReport

