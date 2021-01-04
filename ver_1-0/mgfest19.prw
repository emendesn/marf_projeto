#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFEST19
Autor....:              Marcelo Carneiro         
Data.....:              25/08/2016 
Descricao / Objetivo:   Controle de endereco do armazem central
Doc. Origem:            MGFPER01 - Contrato
Solicitante:            Cliente
Uso......:              
Obs......:              Relatorio de Enderecos
=====================================================================================
*/
User Function MGFEST19 //U_MGFEST19()
Local oReport   
Local aReg   := {}
Local cQuery := ''
Private cFilCD  := GetMV('MGF_FILCD',.F.,"'010001','010002','010003','010005'")
Private aRelImp := {}      
Private cPerg   := 'MGFEST19'

If !Pergunte(cPerg,.T.)
	lContinua	:= .F.
	Return
EndIf
aRelImp := {}      

cQuery := " Select BE_LOCALIZ,"
cQuery += "            MAX(BE_DESCRIC) DESCRICAO,"
cQuery += "            ( SELECT  distinct 'SIM'"
cQuery += "              FROM "+RetSqlName('SBF') + " SBF"
cQuery += "              WHERE BF_LOCALIZ = BE_LOCALIZ"
cQuery += "                AND BF_QUANT > 0 "           
cQuery += "                AND SBF.D_E_L_E_T_ = ' ' ) AS BESIM" 
cQuery += " From "+RetSqlName('SBE') + " SBE"
cQuery += " Where BE_FILIAL IN ("+cFilCD+")"
cQuery += " 	AND SBE.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY BE_LOCALIZ,BE_DESCRIC "

If Select("QRY_BE") > 0
	QRY_BE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_BE",.T.,.F.)
dbSelectArea("QRY_BE")    
QRY_BE->(dbGoTop())
While QRY_BE->(!Eof())
	aReg := {}             
	IF MV_PAR01 == 1 .OR. ( MV_PAR01 == 2 .And. QRY_BE->BESIM<>'SIM') .OR. ( MV_PAR01 == 3 .And. QRY_BE->BESIM=='SIM')
		AADD(aReg,QRY_BE->BE_LOCALIZ)
		AADD(aReg,QRY_BE->DESCRICAO)
		AADD(aReg,IIF(QRY_BE->BESIM=='SIM','Ocupado','Dispon�vel'))
		AADD(aRelImp,aReg)
	EndIF
	QRY_BE->(dbSKIP())
EndDo
                           
oReport := RelEST19()
oReport:PrintDialog()

Return
***********************************************************************************************************************
Static Function RelEST19

Local oReport
Local oImp

oReport := TReport():New("EST19","Relatorio de disponibilidade de endere�os do Armazem Central.",,{|oReport| PrintReport(oReport)},"Relatorio de Enderecos")
//oReport:SetLandscape()
oReport:SetPortrait()
oImp := TRSection():New(oReport,"Disponibilidade dos Enderecos","EST19")

TRCell():New(oIMP,"rINICIO"   ,,""      ,,40,.F.,) 
TRCell():New(oIMP,"rEndereco"   ,,"Endereco"      ,,TamSX3("BE_LOCALIZ")[1],.F.,) 
TRCell():New(oIMP,"rNome"       ,,"Descricao"    ,,TamSX3("BE_DESCRIC")[1],.F.,) 
TRCell():New(oImp,"rStatus"     ,,"Status"        ,,10,.F.,)

Return oReport

***********************************************************************************************************************
Static Function PrintReport(oReport)
Local nI :=0

oReport:SetMeter(LEN(aRelImp))
oReport:Section(1):Init()
For nI := 1 To LEN(aRelImp)
	IF oReport:Cancel()
		Exit
	Endif
	oReport:IncMeter()                                                
	oReport:Section(1):Cell("rINICIO"):SetBlock({|| Space(40) })
	oReport:Section(1):Cell("rEndereco"):SetBlock({|| aRelImp[nI,1] })
	oReport:Section(1):Cell("rNome"):SetBlock({|| aRelImp[nI,2] })
	oReport:Section(1):Cell("rStatus"):SetBlock(  {|| aRelImp[nI,3] })
	oReport:Section(1):PrintLine()
NEXT
oReport:Section(1):Finish()

Return oReport

