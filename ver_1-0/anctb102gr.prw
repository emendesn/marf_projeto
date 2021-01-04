#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: ANCTB102GR
Autor...............: Joni Lima
Data................: 16/11/2016
Descricao / Objetivo: O ponto de entrada ANCTB102GR utilizado Antes a gravacao dos dados da tabela de lancamento.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: http://tdn.totvs.com/display/public/mp/ANCTB102GR+-+Tratativa+do+temporario+--+10926
=====================================================================================
*/
User Function ANCTB102GR()
	
	Local aArea		:=  GetArea()
	
	Local nOpc		:= 	PARAMIXB[1]	
	Local dDatalanc	:= 	PARAMIXB[2]			
	Local cLote		:= 	PARAMIXB[3]				
	Local cSubLote	:= 	PARAMIXB[4]				
	Local cDoc		:= 	PARAMIXB[5]
	
	If Findfunction( 'U_xMF0PEANCT' ) .and. !(IsInCallStack('U_xMF0PEANCT')) //Necessario devido ao reutilizacao do MSEXECAUTO CTBA102
		U_xMF0PEANCT(nOpc)			
	EndIf             
	If FindFunction("U_MGFFIN87")
		U_MGFFIN87(5,nOpc,dDatalanc,cLote,cSubLote,cDoc)
	Endif	
	
	RestArea(aArea)
Return