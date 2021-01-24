#include "TOTVS.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10) 

/*/
{Protheus.doc} MGFCRM53
Relatório de RAMI, com Motivos e Justificativas.

@description
Este relatório irá imprimir o cabeçalho da RAMI e as ocorrências quanto a Motivo e Justificativas.

@author Marcos Cesar Donizeti Vieira
@since 26/08/2019

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	ZAV - RAMI
	ZAW - Ocorrências da RAMI
@param
@return

@menu
@history 
/*/          
User Function MGFCRM53 
	Local _aArea   := GetArea()

	oReport := UCRM53A()
	oReport:PrintDialog()

	RestArea(_aArea)
Return



/*/
{Protheus.doc} UCRM53A()
Montar seções do relatório

@author Marcos Cesar Donizeti Vieira
@since 26/09/2019

@type Function
@param	
@return
/*/
Static Function UCRM53A()
	Local oReport
	Local oDet

	oReport := TReport():New("MGFCRM53","Relatório de RAMI x Ocorrências",,{|oReport| PrintReport(oReport)},"Relatório de RAMI")
	oReport:SetPortrait()
	oCab := TRSection():New(oReport,"RAMI","MGFCRM53")
	oDet := TRSection():New(oReport,"Ocorrências","MGFCRM53")

	TRCell():New(oCab,"ZAV_FILIAL"	,,	"Filial"         	,,	TamSX3("ZAV_FILIAL")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_CODIGO"	,,	"RAMI" 				,,	TamSX3("ZAV_CODIGO")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_NOTA"	,,	"Nota Fiscal"    	,,	TamSX3("ZAV_NOTA")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_SERIE"   ,,	"Serie" 			,,	TamSX3("ZAV_SERIE")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_NFEMIS"  ,,	"Emissao NF"		,,	TamSX3("ZAV_NFEMIS")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_REVEND"  ,,	"Revenda"			,,	TamSX3("ZAV_REVEND")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_ORDRET"  ,,	"Ordem Retira"		,,	TamSX3("ZAV_ORDRET")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_PLANTA"  ,,	"Planta"			,,	TamSX3("ZAV_PLANTA")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_DTABER"  ,,	"Dt Abertura"		,,	TamSX3("ZAV_DTABER")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_STATUS"  ,,	"Status" 			,,	TamSX3("ZAV_STATUS")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_CODUSR"  ,,	"Cod.Usuario"		,,	TamSX3("ZAV_CODUSR")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_NOMEUS"  ,,	"Nome Usuario"		,,	TamSX3("ZAV_NOMEUS")[1]	,.F.,) 
	TRCell():New(oCab,"ZAV_MAILUS"  ,,	"Email Usuario"		,,	TamSX3("ZAV_MAILUS")[1]	,.F.,) 

	TRCell():New(oDet,"ZAW_CDPROD"	,,"Cod Produto"    		,,	TamSX3("ZAW_CDPROD")[1]	,.F.,) 
	TRCell():New(oDet,"ZAW_DESCPR"	,,"Desc Produto"   		,,	TamSX3("ZAW_DESCPR")[1]	,.F.,) 
	TRCell():New(oDet,"ZAW_QTD"		,,"Quantidade"   		,,	TamSX3("ZAW_QTD")[1]	,.F.,) 
	TRCell():New(oDet,"ZAW_MOTIVO"	,,"Motivo"    			,,	TamSX3("ZAW_MOTIVO")[1]	,.F.,)
	TRCell():New(oDet,"ZAW_JUSTIF"	,,"Justificativa"  		,,	TamSX3("ZAW_JUSTIF")[1]	,.F.,) 
Return oReport



/*/
{Protheus.doc} PrintReport()
Gerar o relatório

@author Marcos Cesar Donizeti Vieira
@since 30/09/2019

@type Function
@param	
@return
/*/
Static Function PrintReport(oReport)
	Local _cFil := ZAV->ZAV_FILIAL	
	Local _cCod := ZAV->ZAV_CODIGO

	oReport:SetMeter(10)
	oReport:IncMeter()       
	oReport:Section(1):Init()     
	oReport:Section(1):Cell("ZAV_FILIAL"):SetBlock({|| ZAV->ZAV_FILIAL 	})
	oReport:Section(1):Cell("ZAV_CODIGO"):SetBlock({|| ZAV->ZAV_CODIGO 	})
	oReport:Section(1):Cell("ZAV_NOTA"):SetBlock({||   ZAV->ZAV_NOTA	})
	oReport:Section(1):Cell("ZAV_SERIE"):SetBlock({||  ZAV->ZAV_SERIE 	})
	oReport:Section(1):Cell("ZAV_NFEMIS"):SetBlock({|| ZAV->ZAV_NFEMIS 	})		
	oReport:Section(1):Cell("ZAV_REVEND"):SetBlock({|| ZAV->ZAV_REVEND 	})
	oReport:Section(1):Cell("ZAV_ORDRET"):SetBlock({|| ZAV->ZAV_ORDRET 	})
	oReport:Section(1):Cell("ZAV_PLANTA"):SetBlock({|| ZAV->ZAV_PLANTA 	})
	oReport:Section(1):Cell("ZAV_DTABER"):SetBlock({|| ZAV->ZAV_DTABER 	})
	oReport:Section(1):Cell("ZAV_STATUS"):SetBlock({|| ZAV->ZAV_STATUS 	})
	oReport:Section(1):Cell("ZAV_CODUSR"):SetBlock({|| ZAV->ZAV_CODUSR 	})
	oReport:Section(1):Cell("ZAV_NOMEUS"):SetBlock({|| ZAV->ZAV_NOMEUS 	})
	oReport:Section(1):Cell("ZAV_MAILUS"):SetBlock({|| ZAV->ZAV_MAILUS	})
	oReport:Section(1):PrintLine()                                 
	oReport:Section(2):Init()

	ZAW->(DbSetOrder(1))
	ZAW->(dbSeek( _cFil+_cCod ) )
	While ZAW->(!EOF()) .AND. ZAW->ZAW_FILIAL = _cFil .AND. ZAW->ZAW_CDRAMI = _cCod
		oReport:Section(2):Cell("ZAW_CDPROD"):SetBlock({|| ZAW->ZAW_CDPROD 	})
		oReport:Section(2):Cell("ZAW_DESCPR"):SetBlock({|| ZAW->ZAW_DESCPR 	})
		oReport:Section(2):Cell("ZAW_QTD"):SetBlock(   {|| ZAW->ZAW_QTD 	})
		oReport:Section(2):Cell("ZAW_MOTIVO"):SetBlock({|| ZAW->ZAW_MOTIVO 	})
		oReport:Section(2):Cell("ZAW_JUSTIF"):SetBlock({|| ZAW->ZAW_JUSTIF 	})
		oReport:Section(2):PrintLine()
			
		ZAW->(dbSkip())
	EndDo
	oReport:Section(2):Finish()                                                                                               
	oReport:ThinLine()
	oReport:Section(1):Finish() 
Return oReport