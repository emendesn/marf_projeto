/*/{Protheus.doc} EECAE104
    (Ponto de entrada desenvolvido para habilitar a altera��o de campos na rotina de carregamento do embarque)
    @type  Function
    @William Silva
    @since 10/07/2019
    @1.0
    @http://tdn.totvs.com/pages/releaseview.action?pageId=185737774
    /*/
#include 'protheus.ch'

User Function EECAE104() 

Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,"")) 

If cParam == "ALT_TELA_CONT" 

    AADD(aEX9,"EX9_ZCERSA")
    AADD(aEX9,"EX9_CONTNR")
    AADD(aEX9,"EX9_LACRE")
    AADD(aEX9,"EX9_ZLACRE")
    AADD(aEX9,"EX9_VM_OBS")
    AADD(aEX9,"EX9_DTRETI")
    AADD(aEX9,"EX9_DTPREV")
    AADD(aEX9,"EX9_TARA")
    AADD(aEX9,"EX9_STATUS")
    AADD(aEX9,"EX9_TIPO")
    AADD(aEX9,"EX9_DTDEVO")

EndIf 

Return Nil
