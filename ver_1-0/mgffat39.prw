#include 'protheus.ch'
#include 'parmtype.ch'

user function MGFFAT39()

Local aAreaSF2 := SF2->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local cAliasSC5 := GetNextAlias()

BeginSql Alias cAliasSC5 

	SELECT C5_PESOL, C5_PBRUTO 
	FROM %table:SC5%
	WHERE %notDel% AND
		C5_FILIAL = %xFilial:SC5% AND 
		C5_NOTA = %Exp:SF2->F2_DOC% AND 
		C5_SERIE = %Exp:SF2->F2_SERIE% 
EndSql

If !(cAliasSC5)->(Eof())
	SF2->(RecLock("SF2",.F.))
	SF2->F2_PLIQUI := iif((cAliasSC5)->C5_PESOL>0,(cAliasSC5)->C5_PESOL,SF2->F2_PLIQUI)
	SF2->F2_PBRUTO := iif((cAliasSC5)->C5_PBRUTO>0,(cAliasSC5)->C5_PBRUTO,SF2->F2_PBRUTO)
	SF2->(MsUnlock())
EndIf

SC5->(RestArea(aAreaSC5))
SF2->(RestArea(aAreaSF2))
	
return