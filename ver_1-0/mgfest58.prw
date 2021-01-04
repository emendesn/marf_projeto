#include "totvs.ch"
#include "protheus.ch"
#include 'parmtype.ch'
#INCLUDE "Rwmake.ch" 
/*
===========================================================================================
Programa.:              MGFEST58
Autor....:              Tarcisio Galeano
Data.....:              Dez/2018
Descricao / Objetivo:   Grava obs da medicao no Pedido de compras.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/

User function MGFEST58()

Local aCab := PARAMIXB[1] 
Local aItm := PARAMIXB[2] 
Local aArea:= GetArea() 

//TRATA OBS
For Nx:=1 to Len(aItm) 
          If (nLin :=aScan(aItm[Nx],{|x|x[1]=="C7_OBS"}))>0 
               aItm[Nx][nLin][2] := CND->CND_OBS
          Else 
               aAdd(aItm[Nx],{"C7_OBS",CND->CND_OBS,nil}) 
          EndIf 
Next 
// TRATA OBSM
For Nx:=1 to Len(aItm) 
          If (nLin :=aScan(aItm[Nx],{|x|x[1]=="C7_OBSM"}))>0 
               aItm[Nx][nLin][2] := CND->CND_OBS
          Else 
               aAdd(aItm[Nx],{"C7_OBSM",CND->CND_OBS,nil}) 
          EndIf 
Next 

RestArea(aArea) 
Return({aCab,aItm}) 
