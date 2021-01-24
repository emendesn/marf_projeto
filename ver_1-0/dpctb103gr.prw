#include 'protheus.ch'
#include 'parmtype.ch'
/*
=====================================================================================
Autor....: Caroline Cazela 
Data.....: 04/12/2018
Descrição: Ponto de entrada após a gravação do lançamento contábil parametrizável.
=====================================================================================
*/
user function DPCTB103GR()
Local nOpc		:= 	PARAMIXB[1]	
Local dDatalanc	:= 	PARAMIXB[2]			
Local cLote		:= 	PARAMIXB[3]				
Local cSubLote	:= 	PARAMIXB[4]				
Local cDoc		:= 	PARAMIXB[5]
	
If FindFunction("U_MGFCTB25")
	U_MGFCTB25()//(4,nOpc,dDatalanc,cLote,cSubLote,cDoc)
EndIf

Return	
