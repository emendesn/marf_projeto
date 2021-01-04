#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              F200AVL
Autor....:              Flavio Dentello        
Data.....:              14/11/2016 
Descricao / Objetivo:   FIN_BX_CNAB
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=============================================================================================
*/

/*
Estrutura do Array:
[01] - Numero do Titulo // IDCNAB
[02] - Data da Baixa
[03] - Tipo do Titulo
[04] - Nosso Numero
[05] - Valor da Despesa
[06] - Valor do Desconto
[07] - Valor do Abatimento
[08] - Valor Recebido
[09] - Juros
[10] - Multa
[11] - Outras Despesas
[12] - Valor do Credito
[13] - Data Credito
[14] - Ocorrencia
[15] - Motivo da Baixa
[16] - Linha Inteira
[17] - Data de Vencto
*/
User Function F200AVL()
/*	
	Local lRet := .T. 
	//Local aRet := aclone(ParamIXB) 
	Local nConta := 0
	local aArea		:= getArea()
	local aAreaSE1	:= SE1->( getArea() )
	local nRecnoX	:= 0
	

	//MsgStop("F200AVL "+ParamIXB[1][1]+ParamIXB[1][14])
	If !Subs(ParamIXB[1][14],1,2) $ "02/03/" // 02 - Entrada Confirmada / 03 - Entrada Rejeitada
		//MsgStop("F200AVL "+ParamIXB[1][14])
		DbSelectArea('SE1')
		DbSetorder(19)
		If SE1->(dbSeek(ALLTRIM(ParamIXB[1][1])))

			nConta := SE1->E1_SALDO + SE1->E1_SDACRESC - E1_SDDECRE
			If nConta <> ParamIXB[1][08]
			
				If (ParamIXB[1][08] - nConta) = ParamIXB[1][09] .OR. ParamIXB[1][10]
		
					lRet := .T.
				ElseIf	(ParamIXB[1][08] - nConta) = ParamIXB[1][06]
				
					If (SE1->E1_VALOR * SE1->E1_DESCFIN / 100) = ParamIXB[1][06]
					
						lRet := .T.
					
					Else
							RecLock('SE1',.F.)
							SE1->E1_ZNBXCNB := "S"
							SE1->(MsUnlock())
					
							lRet := .F.
					EndIf		
				EndIf	
				
			EndIf
		ELSE
			SE1->(DbOrderNickName('MGFXIDCNAB'))
			If SE1->( dbSeek(ParamIXB[1][1]) )
				nConta := SE1->E1_SALDO + SE1->E1_SDACRESC - E1_SDDECRE
				If (ParamIXB[1][08] - nConta) == ParamIXB[1][09] .OR. (ParamIXB[1][08] - nConta) == ParamIXB[1][10]
		
					lRet := .T.
				ElseIf	(nConta - ParamIXB[1][08]) == ParamIXB[1][06]
				
					If (SE1->E1_VALOR * SE1->E1_DESCFIN / 100) == ParamIXB[1][06]
						lRet := .T.
					Else
						RecLock('SE1',.F.)
							SE1->E1_ZNBXCNB := "S"
						SE1->(MsUnlock())
						lRet := .F.
					
					EndIf		
				EndIf	
			EndIf
		EndIf
	EndIf

	restArea(aAreaSE1)
	restArea(aArea)
Return lRet
*/

Local lAchouTit := .F.

If ExistBlock("MGFFIN89")
	lAchouTit := U_MGFFIN89()
EndIf

Return(lAchouTit)
