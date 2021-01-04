#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

User Function MATA114()
	
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
	Local oMdlSALGrid
	
	If aParam <> NIL
		
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		
		If	cIdPonto == 'MODELVLDACTIVE'

			oMdlSALGrid := oObj:GetModel('DetailSAL')
			oMdlSALGrid:SetUniqueLine( {'AL_ITEM' ,'AL_APROV' })

			oMdlGrid:= oObj:GetModel('DetailDBL')
			oMdlGrid:bLinePost := {|a,b,c,d,e|FWFormAfter(a,{||U_xMGC6VldPo(oObj)},"FORMLINE",b,c,d,e)}

		EndIf
	EndIf

Return xRet

