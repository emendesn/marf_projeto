#include 'protheus.ch'

/*/{Protheus.doc} MGFEIC07
//TODO Numeraçao Embarque Importação
@author leonardo.kume
@since 04/05/2018
@version 6

@type function
/*/
user function MGFEIC07()

Local aAreaSW6		:= SW6->(GetArea())
Local lNext 		:= .T.
Local cNumeracao 	:= "IMP"+SUBSTR(CFILANT,2,1)+GETSXENUM("SW6","W6_ZSQ","W6_ZSQ"+SUBSTR(CFILANT,1,2))+"/"+SUBSTR(ALLTRIM(STR(YEAR(DDATABASE))),3,2)  

While existSW6(cNumeracao)
	confirmSx8()
	cNumeracao 	:= "IMP"+SUBSTR(CFILANT,2,1)+GETSXENUM("SW6","W6_ZSQ","W6_ZSQ"+SUBSTR(CFILANT,1,2))+"/"+SUBSTR(ALLTRIM(STR(YEAR(DDATABASE))),3,2)
EndDo

SW6->(RestArea(aAreaSW6))
	
return cNumeracao

Static Function existSW6(cNumeracao)
Local lRet	:= .F.
Local cAliasSW6 	:= GetNextAlias()

BeginSql Alias cAliasSW6

SELECT '*' 
FROM %Table:SW6%
WHERE 	W6_HAWB = %Exp:cNumeracao% AND
		D_E_L_E_T_ = ' ' AND
		W6_FILIAL <> '99'

EndSql

lRet := !(cAliasSW6)->(Eof())

(cAliasSW6)->(DbCloseArea())

Return lRet