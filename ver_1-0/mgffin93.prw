#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN93
Autor....:              TARCISIO GALEANO
Data.....:              03/2018
Descricao / Objetivo:   Baixa CNAB - gravar campo E5_HISTOR com "CART" quanto pagto em cartorio
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              
Obs......:              Chamado pelo P.E F200TIT - APOS GRAVAR A BAIXA
=====================================================================================
*/

User Function MGFFIN93()
Local aArea		:= {SE5->(GetArea()),SE1->(GetArea()),GetArea()}
Local cZCNAB	:= SuperGetMV("MGF_FIN93C",.T.,"34108;23708") //Ocorrencias de baixa em cartorio. Separar com ";". BANCO(3)+OCORRENCIA(2): Ex: Itau 341 + ocorr 08. 
//Local cZCNAB	:= GetAdvFVal("SEB","EB_ZCNAB",xFilial("SEB")+SE5->E5_BANCO+SE5->E5_CNABOC+"R"+SE5->E5_CNABOC,1)



dbSelectArea("SE5")

If Alltrim(SE5->E5_BANCO) + Alltrim(SE5->E5_CNABOC) $ cZCNAB
	If RecLock("SE5",.F.)
		SE5->E5_HISTOR := "CART -" + SE5->E5_HISTOR
		SE5->(MsUnLock())
	Endif
Endif

aEval(aArea,{|x| RestArea(x)})

Return
