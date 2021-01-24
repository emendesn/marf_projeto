#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFTAE08
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integra��o TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Pontos de Entrada para Tratamento da exclus�o/Classifica��o 
 						Altera��o de Pr� e Documento de Sa�da
 						nTipoPE:
 						1=A100DEL - Na exclus�o do Doc.entrada ou estorno da Classifica��o
                        2=MT103PN - Bloqueia Classificar se tiver AR e n�o estiver encerrado
                        3=MT100TOK - N�o permite classificar se a TES movimenta Estoque
                        4=A140ALT - N�o permitir Alterar pr� nota que tenha AR
                        5=A140EXC - N�o permitir Excluir pr� nota que tenha AR
============================================================================================
*/


User Function MGFTAE08(nTipoPE)
Local bRet := .T. 
Local nI      := 0
Local nPosTES := 0
Local cTes     := ''
                          
                          
IF nTipoPE ==1
	dbSelectArea('ZZH')
	ZZH->(dbSetOrder(3))
	IF ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
		MsgAlert('Foi gerado um AR para esta Nota, Exclua o AR primeiro  !!')
		bRet := .F.
	EndIF
ElseIF nTipoPE ==2
	
	IF l103Class  // Classifica��o da Nota
		dbSelectArea('ZZH')
		ZZH->(dbSetOrder(3))
		IF ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
			IF ZZH->ZZH_STATUS <> '3'
				MsgAlert('Foi gerado um AR para esta Nota, o AR precisa estar finalizado para classificar  !!')
				bRet := .F.
			EndIF
		EndIF
	EndIF
ElseIF nTipoPE ==3
	nPosTES   := aScan( aHeader, { |x| Alltrim(x[2]) == 'D1_TES' })
	lMT100TOK := .F.
	IF l103Class  // Classifica��o da Nota
		dbSelectArea('ZZH')
		ZZH->(dbSetOrder(3))
		IF SF1->F1_TIPO == 'D' .AND. ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
			dbSelectArea('SF4')
			SF4->(dbSetOrder(1))
			For nI := 1 To Len(aCols)
				IF !Empty(aCols[nI,nPosTES])
					IF SF4->(dbSeek(xFilial('SF41')+aCols[nI,nPosTES]))
						IF SF4->F4_ESTOQUE =='S'
							bRet := .F.
						EndIF
					EndIF
				EndIF
			Next nI
			IF !bRet
				MsgAlert('Para Devolu��o com AR a TES n�o pode movimentar estoque!!')
			EndIF
		EndIF
	EndIF  
ELSEIF nTipoPE ==4 
	dbSelectArea('ZZH')
	ZZH->(dbSetOrder(3))
	IF ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
		IF ZZH->ZZH_STATUS <>'2'
			MsgAlert('Foi gerado um AR para esta pr� nota, exclua o AR ou espere a conclus�o da Contagem !!')
			bRet := .F.
		EndIF
	EndIF          
ELSEIF nTipoPE ==5
	dbSelectArea('ZZH')
	ZZH->(dbSetOrder(3))
	IF ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
		MsgAlert('Foi gerado um AR para esta pr� nota, exclua o AR primeiro  !!')
		bRet := .F.
	EndIF          
EndIF

Return bRet