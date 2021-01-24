#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFINT32
Autor....:              Leonardo Kume
Data.....:              01/03/2017
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFINT32()
	Local aAliasAtu := GetArea()
	Local aAliasSF2 := SF2->(GetArea())
	Local aAliasSA3 := SA3->(GetArea())
	
	DbSelectArea("SA3")
	DbSetOrder(1)
	If SA3->(dBSeek(xFilial("SA3")+SF2->F2_VEND1))
		If SA3->A3_XSFA == "S"
			recLock("SF2", .F.)
			SF2->F2_XSFA 	:= "S"
			SF2->F2_XINTEGR := "P"
			SF2->(msUnLock())
		EndIf
	Endif
	
	RestArea(aAliasSF2)
	RestArea(aAliasSA3)
	RestArea(aAliasAtu)
return