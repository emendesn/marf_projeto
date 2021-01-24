#include 'protheus.ch'
#include 'TOTVS.ch'
#INCLUDE 'FIVEWIN.CH'


/*
==================================================================================
Programa............: MGFCOMA7
Autor...............: Juscelino Alves dos Santos
Data................: 26/11/2018
Descricao / Objetivo: Ativar a Tecla <F4> na Inclusão da Solicitação 
                      para consultar o Painel de Gestão de Estoque
Doc. Origem ........: MIT680 - GAP EST16
Solicitante.........: Marfrig
Uso.................: Gestão de Compras 
==================================================================================
*/

user function MGFCOMA7(_cprod,_exec)
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local _nacolatu :=n

Default _exec:=.F.


If _exec
   _cond:=""
   _ltrue:=.F.
   For _xx:=1 To Len(aCols)
     If _ltrue .And. _xx>1 
        _cond+=" OR B1_COD ='"+aCols[_xx][nPosPrd]+"'"
     Else
        _cond+=" B1_COD ='"+aCols[_xx][nPosPrd]+"'"
        _ltrue:=.T.
     EndIf   
   Next _xx
   fexec(_cond)
   Return
Else
   SetKey(VK_F4, {|| U_MGFCOMA7('',.T.)})
   Return(aCols[n][nPosPrd])
EndIf

Static Function fexec(_cond) 
   SetKey(VK_F4, {||})
   U_MGFEST21(_cond)
   SetKey(VK_F4, {|| U_MGFCOMA7('',.T.)})
Return
