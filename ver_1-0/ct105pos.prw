#include 'protheus.ch'
#include 'parmtype.ch'

user function CT105POS()

	Local lRet 			:= PARAMIXB[1]
	
	Local aArea		:= GetArea()
	Local aAreaTMP	:= {}
	Local nValor	:= 0
	Local cxUser	:= Alltrim(RetCodUsr())
	Local cUsDireto		:= SuperGetMV("MGF_CTB25A",.F.,"000000")
	Local cxUser		:= Alltrim(RetCodUsr())

	If !(cxUser $ cUsDireto) //Verifica se para usuario passa direto	
		If Select("TMP") > 0
			
			aAreaTMP	:= TMP->(GetArea())
			TMP->(dbGotop())
			
			While TMP->(!EOF())
				nValor += IIF(TMP->CT2_DC $ '2|3|',TMP->CT2_VALOR,0 )
				TMP->(dbSkip())
			EndDo
			
			lRet := U_xMC26Sal(cFilAnt,cxUser,nValor)
			
			TMP->(dbGotop())
			RestArea(aAreaTMP)
			
		EndIf
	EndIf
	
	RestArea(aArea)
	
return lRet