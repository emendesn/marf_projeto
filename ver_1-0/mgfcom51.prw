/*
=====================================================================================
Programa.:              MGFCOM51
Autor....:              TOTVS
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo campo X3_INIBRW do campo customizado C7_ZNOMCOM
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM51()

Local aArea := {SC1->(GetArea()),SY1->(GetArea()),GetArea()}
Local cNome := ""

If !Empty(SC7->C7_COMPRA)
	SY1->(dbSetOrder(1))
	If SY1->(dbSeek(xFilial("SY1")+SC7->C7_COMPRA))
		cNome := SY1->Y1_NOME
	Endif	
Else
	SY1->(dbSetOrder(1))
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC)) // obs: posicionar o SC1 sempre pela filial do SC7 e nao pela funcao xFilial("SC1")
		If !Empty(SC1->C1_CODCOMP)
			If SY1->(dbSeek(xFilial("SY1")+SC1->C1_CODCOMP))
				cNome := SY1->Y1_NOME
			Endif
		Endif
	Endif
Endif				
		
aEval(aArea,{|x| RestArea(x)})	
	
//Return(IIf(!Empty(SC7->C7_COMPRA),GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+SC7->C7_COMPRA,1,""),GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+GetAdvFVal('SC1','C1_CODCOMP',xFilial('SC1')+SC7->(C7_NUMSC+C7_ITEMSC),1,''),1,""))) 
Return(cNome)