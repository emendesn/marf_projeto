#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFCOM77
Autor....:              Gresele
Data.....:              Fev/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MTA094RO
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM77(aButtons)

Local nPos := 0

If IsInCallStack("MATA094")
	aAdd(aButtons,{OemToAnsi("Estornar Marfrig"),"U_COM77Proc",0,4,0,Nil})

	// retira rotina padrao de estorno, para usar somente a customizada 
	If (nPos := aScan(aButtons,{|x| Alltrim(x[2])=="A094VldEst"})) > 0 
		aDel(aButtons,nPos)
		aButtons := aSize(aButtons,Len(aButtons)-1)
	Endif	
Endif	
		
Return(aButtons)


User Function COM77Proc()

Local aArea := {SF1->(GetArea()),GetArea()}
Local lRet := .T.
Local cChave := ""
Local cGrupo := ""
Local lGrupo := .F.

If SCR->CR_STATUS $ "02,06"
	Help(" ",1,"A097NOESTOR")  //Nao e possivel estornar o documento selecionado.
	lRet := .F.
ElseIf SCR->CR_STATUS $ "04"
	Help(" ",1,"A097BLQ") // Esta operacao nao podera ser realizada pois este registro se encontra bloqueado pelo sistema
	lRet := .F.
ElseIf SCR->CR_TIPO == "MD"
	CND->(dbSetOrder(4))
	CND->(MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,Len(CND->CND_NUMMED))))
	If !Empty(CND->CND_PEDIDO) .Or. !Empty(CND->CND_NUMTIT)
		Help(" ",1,"A097MDEST")  //Este documento possui medi��es encerradas e nao sera possivel realizar o seu estorno //Para realizar o seu estorno devera ser feito o estorno da medicao.
		lRet := .F.
	EndIf
ElseIf SCR->CR_TIPO == "RV"
	Help(" ",1,"NAODISPONIVEL") //Opcao acionada nao esta disponivel para o tipo de documento selecionado. 
	lRet := .F.
Else
	
	Begin Transaction 
	
	If SCR->CR_TIPO == "NF"
		SF1->(dbSetOrder(1))
		cChave := Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		If SF1->(MsSeek(xFilial("SF1")+cChave))
			// caso status da nf esteja com A/B, � necessario limpar o status, senao rotina padrao A097Estorna nao eh executada 
			//If SF1->F1_STATUS $ "AB"
			If SF1->F1_STATUS $ "B"			
				SF1->(RecLock("SF1",.F.))
				SF1->F1_STATUS := " "
				SF1->F1_ZBLQVAL := " "
				SF1->(MsUnLock())
			EndIf
			If "_VALOR_NFE" $ Alltrim(SCR->CR_NUM)
				// deve-se alterar o grupo de aprovacao do sf1, pois a rotina padrao de estorno da alcada carrega o grupo pelo que estah
				// gravado no campo f1_aprov, que eh o grupo para bloqueio por tolerancia de recebimento padrao
				If SF1->F1_APROV != GetMv("MGF_GRPNFE") 
					cGrupo := SF1->F1_APROV
					lGrupo := .T.
					SF1->(RecLock("SF1",.F.))
					SF1->F1_APROV := GetMv("MGF_GRPNFE")
					SF1->(MsUnLock())
				Endif	
			Endif	
		EndIf
	Endif	
		
	A097Estorna()
	
	// refaz status na nf
	U_MGFCOM72()
	
	// retorna grupo de aprovacao anterior
	If lGrupo .and. !Empty(cGrupo)
		SF1->(RecLock("SF1",.F.))
		SF1->F1_APROV := cGrupo
		SF1->(MsUnLock())
	Endif	
    
	End Transaction 
	
EndIf

aEval(aArea,{|x| RestArea(x)})

Return()