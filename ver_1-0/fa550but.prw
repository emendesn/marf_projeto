#include 'protheus.ch'
#include 'parmtype.ch'

user function FA550BUT()
	
	Local axRotina := PARAMIXB[1]
	
	nPosCan := aScan(axRotina,{|x| upper(AllTrim(x[2])) == "FA550REPOS"})
	nTam	:= Len(axRotina) - 1

	aDel(axRotina,nPosCan)
	aSize(axRotina,nTam)
	
	AADD(axRotina,{"Reposição Marfrig", "U_MGFFIN94" ,0,4})
	
return axRotina