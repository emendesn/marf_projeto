#include 'protheus.ch'

/*/{Protheus.doc} EECCAD00
//TODO Ponto de entrada para alterar o campo marca��o
@author leonardo.kume
@since 27/03/2018
@version 6
@return caracter, Descri��o Marca��o

@type function
/*/
user function EECCAD00()
	Local cRet := ""

	If Findfunction( 'U_EEC24CAD' )
		cRet := U_EEC24CAD()
	EndIf	
	
return cRet