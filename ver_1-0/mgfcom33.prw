#include 'protheus.ch'
#include 'parmtype.ch'

User function MGFCOM33()
	
	local aArea	:= GetArea()
	
	Local cFilPdr	:= ''
	Local oMBrowse := nil

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZZL")
	oMBrowse:SetDescription('Log de Alteração')
	oMBrowse:SetMenuDef(' ')
	oMBrowse:SetFilterDefault("SUBSTR(ZZL_SEEK,1,TamSx3('ZA2_FILIAL')[1]) == '" + ZA1->ZA1_FILIAL + "' .and. SUBSTR(ZZL_SEEK,13,TamSx3('ZA2_NIVEL')[1]) == '" + ZA1->ZA1_NIVEL + "'")
	
	oMBrowse:Activate()
	
	RestArea(aArea)
	
return

User Function xMC33ILog(cTbl, cSeek, nRecno, cField, cOld, cNew, dDate, cHour, cUser)

	DBSelectArea("ZZL")

	RecLock("ZZL", .T.)
		ZZL->ZZL_FILIAL	:= xFilial("ZZL")
		ZZL->ZZL_NUM	:= GETSXENUM("ZZL","ZZL_NUM")
		ZZL->ZZL_TABLE	:= cTbl
		ZZL->ZZL_SEEK	:= cSeek
		ZZL->ZZL_RECNO	:= nRecno
		ZZL->ZZL_FIELD	:= cField
		ZZL->ZZL_OLD	:= cOld
		ZZL->ZZL_NEW	:= cNew
		ZZL->ZZL_DATE	:= dDate
		ZZL->ZZL_HOUR	:= cHour
		ZZL->ZZL_USER	:= cUser
	ZZL->(msUnLock())

	CONFIRMSX8()

	ZZL->(DBCloseArea())

return