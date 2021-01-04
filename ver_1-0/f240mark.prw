/*/{Protheus.doc} F240MARK
    //Descri��o: Ponto de entrada para alterar ordena��o dos campos 
    //na tela de bordero pagamentos.)
    @type  Function
    @author William Silva
    @since 10/07/2020
    @version 1.0
    /*/
#include 'protheus.ch'

User Function F240MARK()  

Local aRet 		:= {}

If FindFunction("U_MGFFINBU")
	aRet := U_MGFFINBU() 
EndIf

Return(aRet)