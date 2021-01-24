#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

user function MGFFATAL(_cMENNOTA,_cZMENNOT,_cZMENEXP,nOpc)
Local lRet:=.T.
Local _carcblo :=GetMv("MGF_CARBLQ")

lRet:=Iif((!Empty(Alltrim(_cMENNOTA)) .And. (nOpc=3 .Or. nOpc=4 .Or. nOpc=41)) ,Fvalmennt(Alltrim(_cMENNOTA),Iif(nOpc=41,'< Mensagem Nota 1 >','< Mens.p/ Nota - Aba Principal >'),_carcblo),.T.)
lRet:=Iif((!Empty(Alltrim(_cZMENNOT)) .And. lRet .And. (nOpc=3 .Or. nOpc=4 .Or. nOpc=41)) ,Fvalmennt(Alltrim(_cZMENNOT),Iif(nOpc=41,'< Mensagem Nota 2 >','< M.p/ Nota 2 - Aba Principal >'),_carcblo),Iif(!lRet,lRet,.T.))
lRet:=Iif((!Empty(Alltrim(_cZMENEXP)) .And. lRet .And. (nOpc=3 .Or. nOpc=4 .Or. nOpc=41)) ,Fvalmennt(Alltrim(_cZMENEXP),Iif(nOpc=41,'< Mens.Exp >','< Men.p/ Exp - Aba Outros >'),_carcblo),Iif(!lRet,lRet,.T.))

return lRet

Static Function Fvalmennt(_cmen,_cmenerr,_cparusu)
Local _lret:=.T.
Local _xx

For _xx:=1 To Len(_cmen)
    If At(SubStr(_cmen,_xx,01),_cparusu)>0 .And. SubStr(_cmen,_xx,01)<>Space(1) 
       MsgStop("O Campo "+_cmenerr+" possui o caracter especial ==> "+SubStr(_cmen,_xx,01)+" não Valido,Favor verificar.","Validação Mensagem Nota")
       _lret    := .F.
       Exit
    EndIf
Next _xx
Return _lret