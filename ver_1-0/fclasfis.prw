#INCLUDE "totvs.ch" 
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            
#include "parmtype.ch"
#include "rwmake.ch"

/*
{Protheus.doc} FCLASFIS

Rotina que atualiza Classificação Fiscal nos itens

@author  WagnerNeves
@since   10/01/2020

CRIAR PARAMETRO - MGF_ZCLASF - 

Gatilho no campo 
X7_CAMPO = D1_ZCLASFI
X7_REGRA = IF GETMV("MGF_ZCLASF"),U_fClasfis(),F)
X7_CDOMIN =  D1_ZCLASFI

*/

User Function fClasfis()

Local _nCl := 0
Local _zPoszCla := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZCLASFI"})
Local _zClasFis := M->D1_ZCLASFI

If n = 1  .And. ! GdDeleted(n)
   _zPoszCla := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZCLASFI"})
   _zClasFis := aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZCLASFI"})]
   For _nCl := 1 To Len(aCols)
      aCols[_ncl][_zPoszCla] := _zClasFis //aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZCLASFI"})]
      oGetDados:oBrowse:Refresh()
   Next
EndIf
Return(_zClasFis)