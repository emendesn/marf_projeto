#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120F
Autor...............: Joni Lima
Data................: 11/04/2017
Descrição / Objetivo: Após a gravação dos itens do pedido de compras, no final da função A120GRAVA, pode ser usado para manipular os dados gravados do pedido de compras na tabela SC7, recebe como parametro a filial e numero do pedido.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/PROT/MT120F+-+Manipula+os+dados+no+pedido+de+Compras+na+tabela+SC7
=====================================================================================
*/
User Function MT120F()
	
	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
		
	Local cChv  := PARAMIXB
	Local cCC	:= ''//_XMGFcCC	
	Local nPosCC
	
	If FindFunction("U_xM10GVCC")
		If UPPER(AllTrim(FUNNAME())) == 'MATA120' .or. UPPER(AllTrim(FUNNAME())) == 'MATA121'
			If Type('_XMGFcCC')<>'C'
				nPosCC := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_CC' })
				xCrPubl()
				_XMGFcCC := aCols[1,nPosCC]
			EndIf
			
			cCC	:= _XMGFcCC
	
			U_xM10GVCC(cChv,cCC)
		EndIf
	EndIf
	
	RestArea(aAreaSC7)
	RestArea(aArea)
	
Return

Static Function xCrPubl()
	Public _XMGFcCC := ''
return