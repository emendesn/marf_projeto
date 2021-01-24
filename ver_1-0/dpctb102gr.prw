#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: DPCTB102GR
Autor...............: Joni Lima
Data................: 22/11/2016
Descrição / Objetivo: O ponto de entrada DPCTB102GR utilizado Após a gravação dos dados da tabela de lançamento.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6068636
=====================================================================================
*/
User Function DPCTB102GR()
Local nOpc		:= 	PARAMIXB[1]	
Local dDatalanc	:= 	PARAMIXB[2]			
Local cLote		:= 	PARAMIXB[3]				
Local cSubLote	:= 	PARAMIXB[4]				
Local cDoc		:= 	PARAMIXB[5]
	
If Findfunction( 'U_xMF02DEPGV' )
	U_xMF02DEPGV(nOpc)
EndIf
If FindFunction("U_MGFFIN87")
	U_MGFFIN87(4,nOpc,dDatalanc,cLote,cSubLote,cDoc)
Endif	
/*
=====================================================================================
Autor....: Caroline Cazela 
Data.....: 04/12/2018
Descrição: Grava SCR da grade para aprovação no fonte MGFCOM14.
=====================================================================================
*/
If FindFunction("U_MGFCTB25")
	U_MGFCTB25(nOpc)//(4,nOpc,dDatalanc,cLote,cSubLote,cDoc)
EndIf

Return