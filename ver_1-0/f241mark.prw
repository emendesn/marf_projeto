/*/{Protheus.doc} F241MARK
    //Descrição: Ponto de entrada para alterar ordenação dos campos 
    //na tela de bordero pagamentos.)
    @type  Function
    @author William Silva
    @since 10/07/2020
    @version 1.0
    /*/
#include 'protheus.ch'

User Function F241MARK()  

Local aRet 		:= {}

If FindFunction("U_MGFFINBU")
	aRet := U_MGFFINBU() 
EndIf

Return(aRet)