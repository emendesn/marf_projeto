#include 'protheus.ch'
#include 'parmtype.ch'

user function FA560BRW()

	Local axRotina := PARAMIXB[1]

	nPosCan := aScan(axRotina,{|x| upper(AllTrim(x[2])) == "FA560DELETA"})
	nTam	:= Len(axRotina) - 1

	aDel(axRotina,nPosCan)
	aSize(axRotina,nTam)

	Aadd(axRotina,{"Estorno", "U_FA550RCan", 0, 3, ,.F.}) 	

return axRotina




