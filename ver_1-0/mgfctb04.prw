#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: CTBA120
Autor...............: Joni Lima
Data................: 07/11/2016
Descrição / Objetivo: Pontos de Entradas MVC para GAP CTB01
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: PE MVC do fonte CTBA120, Rateio.
=====================================================================================
*/
User Function CTBA120()
	
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	
	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''
	
	Local oMdlGrid
	
	If aParam <> NIL
		
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		/*lIsGrid    := ( Len( aParam ) > 3 )
		
		If lIsGrid
			nQtdLinhas := oObj:Lenght()
			nLinha     := oObj:GetLine()
		EndIf*/
		
		If	cIdPonto == 'MODELVLDACTIVE'
			oMdlGrid:= oObj:GetModel('CTJDETAIL')
			oMdlGrid:bLinePost := {|a,b,c,d,e|FWFormAfter(a,{||U_xMF03VlLP()},"FORMLINE",b,c,d,e)}
		ElseIf cIdPonto == 'MODELPOS'
			xRet := U_xMF03TdOK(oObj)
		EndIf
				
		
	EndIf
	
Return xRet
