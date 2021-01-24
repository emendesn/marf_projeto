/*
===========================================================================================
Programa.:              MGFCOM89
Autor....:              Totvs
Data.....:              Julho/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada MT120ALT 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MGFCOM89()

Local aArea := {SY1->(GetArea()),GetArea()}
Local lRet := .T.
Local nOpc := ParamIxb[1]

// so valida quando nao for rotina automatica
If Type("l120Auto") <> "U" .and. !l120Auto
	If nOpc == 3 .or. nOpc == 4 .or. nOpc == 5 .or. nOpc == 9 // incluir/alterar/excluir/copia
		// soh deixa prosseguir se usuario estiver cadastrado como comprador
		SY1->(dbSetOrder(3))
		If SY1->(!dbSeek(xFilial("SY1")+RetCodUsr()))
			lRet := .F.
			APMsgStop("Usuário não está cadastrado como comprador.")	
		Endif	
	Endif	
Endif	

aEval(aArea,{|x| RestArea(x)})	

Return(lRet) 