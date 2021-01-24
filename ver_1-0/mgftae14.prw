#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFTAE14
Autor....:              Marcelo Carneiro         
Data.....:              21/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio Pedido Abate de Gado - Parte Criar tabelas
=====================================================================================
*/


User Function MGFTAE14( cACAO,;            
                        cFILPED,;          
						nNUM_PEDIDO,;      
	                    cCOD_FORNECEDOR,;  
						cLOJA,;            
						cDAT_EMISSAO,;     
						cDAT_PROD,;
						nVAL_DESCONTO,;    
						nVAL_ACRESCIMO,;   
						cNUM_GTA,;         
						cDATA_VENCIMENTO,; 
						nVAL_DUPLICATA,;   
						cFAVORECIDO,;  
						cLOJAFAV,;    
						cBANCO,;           
						cAGENCIA,;         
						cCONTA,;	
						aITEM,;
						aMapa,;
						cCNPJ_FOR,;
						cCODEXP_FOR,;
						cIDFazenda,;
						cTipoConta,;
						nQtde_Qtpe) // Paulo da Mata - 31/08/2020 - RTASK0011418

Local nI		:= 0
Local aErro	    := {}
Local cErro	    := ""
Local bContinua := .T.
Local aRetorno  := {}
Local aGTA      := {}

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.                  
Private cPedido         := nNUM_PEDIDO               


CHKFILE('ZZM')
IF !(cACAO $ '123')
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'ACAO:Ação deverá ser : 1=Inclusão 2=Alteração 3=Exclusão')
	bContinua := .F.
Else
	IF  !FWFilExist(cEmpAnt,cFILPED)
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,'FILIAL:Filial não cadastrada')
		bContinua := .F.
	Else
		IF Empty(cLOJA) .AND. Empty(cIDFazenda)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'C7_LOJA:Loja e ID da Fazenda em Brancoem Branco')
			bContinua := .F.
		Else
			//Fornecedor
			dbSelectArea('SA2')
			SA2->(dbSetOrder(1))
			IF !U_TAE02_VALFOR(cCOD_FORNECEDOR,cLOJA,cCNPJ_FOR,cCODEXP_FOR,cIDFazenda)
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'FORNECE:Fornecedor não cadastrado')
				bContinua := .F.
			Else
				cCOD_FORNECEDOR := SA2->A2_COD
				cLOJA           := SA2->A2_LOJA
				//Existe Pedido para alteração ou Exclusão
				dbSelectArea('ZZM')
				ZZM->(dbSetOrder(1))
				IF cACAO <> '1'
					IF ZZM->(!dbSeek(cFILPED+cPedido))
						AAdd(aRetorno ,"2")
						AAdd(aRetorno,'NUM_PEDIDO:Pedido de Abate não cadastrado')
						bContinua := .F.
					Else
						IF ZZM->ZZM_STATUS $ '45'
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,'NUM_PEDIDO:Não possivel alterar ou excluir por causa do status do pedido')
							bContinua := .F.
						ElseIF !Empty(ZZM->ZZM_AGRUP)
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,'NUM_PEDIDO:Não é possivel a alteração para pedido Agrupado !!')
							bContinua := .F.
						EndIF
					EndIF
				Else
					IF ZZM->(dbSeek(cFILPED+cPedido))
						AAdd(aRetorno ,"2")              
						AAdd(aRetorno,'NUM_PEDIDO:Pedido já cadastrado')
						bContinua := .F.
					Else
						For nI := 1 To Len( aITEM )
							IF bContinua
								dbSelectArea('SB1')
								SB1->(dbSetOrder(1))
								IF SB1->(!dbSeek(xFilial('SB1')+PADR(ALLTRIM(aITEM[nI][2]),TamSX3("B1_COD")[1])))
									AAdd(aRetorno ,"2")
									AAdd(aRetorno,'COD_PRODUTO:Produto não Cadastrado')
									bContinua := .F.
								EndIF
							EndIF
						Next NI
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
EndIF
                                

IF bContinua
    AAdd(aRetorno ,"2")
    AAdd(aRetorno,'Erro na inclusão')

   BEGIN TRANSACTION                                         
		IF cAcao $ '23'
		    //ZZM
		    cQuery := " Delete From  "+RetSqlName("ZZM")
			cQuery += " Where ZZM_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZM_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)        
			     bContinua   := .F.
			     aRetorno[1]:= TcSQLError()
			EndIF                             
		    //ZZN
		    cQuery := " Delete From  "+RetSqlName("ZZN")
			cQuery += " Where ZZN_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZN_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)        
			     bContinua   := .F.
			     aRetorno[1]:= TcSQLError()
			EndIF                             
		    //ZZO
		    cQuery := " Delete From  "+RetSqlName("ZZO")
			cQuery += " Where ZZO_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZO_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)        
			     bContinua   := .F.
			     aRetorno[1]:= TcSQLError()
			EndIF                             
		    //ZZP
		    cQuery := " Delete From  "+RetSqlName("ZZP")
			cQuery += " Where ZZP_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZP_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)        
			     bContinua   := .F.
			     aRetorno[1]:= TcSQLError()
			EndIF                             
			//ZZQ
		    cQuery := " Delete From  "+RetSqlName("ZZQ")
			cQuery += " Where ZZQ_FILIAL = '"+cFILPED+"'"
			cQuery += "   AND ZZQ_PEDIDO = '"+cPedido+"'"
			IF (TcSQLExec(cQuery) < 0)        
			     bContinua   := .F.
			     aRetorno[1]:= TcSQLError()
			EndIF                             
		EndIF
		IF bContinua 
		   IF cAcao == '3'
		        aRetorno[1]:= "1"
			    aRetorno[2]:= 'Pedido realizado com sucesso'
           Else
				Reclock("ZZM",.T.)
				ZZM->ZZM_FILIAL := cFILPED
				ZZM->ZZM_PEDIDO	:= cPedido
				ZZM->ZZM_EMITE 	:= IIF(SA2->A2_ZEMINFE=='2','S','N')
				ZZM->ZZM_EMISSA	:= STOD(cDAT_EMISSAO)
				ZZM->ZZM_DTPROD	:= STOD(cDAT_PROD)
				ZZM->ZZM_FORNEC	:= cCOD_FORNECEDOR
				ZZM->ZZM_LOJA  	:= cLOJA
				ZZM->ZZM_NOME 	:= SA2->A2_NREDUZ
				ZZM->ZZM_VLDESC	:= nVAL_DESCONTO
				ZZM->ZZM_VLACR 	:= nVAL_ACRESCIMO
				ZZM->ZZM_VENCE 	:= STOD(cDATA_VENCIMENTO)
				ZZM->ZZM_VLDUPL	:= nVAL_DUPLICATA
				ZZM->ZZM_FAV   	:= cFAVORECIDO
				ZZM->ZZM_LOJAFA := cLOJAFAV
				ZZM->ZZM_BANCO 	:= cBANCO
				ZZM->ZZM_AGENCI := cAGENCIA//trTran(cAGENCIA,"-","")
				ZZM->ZZM_CONTA	:= cCONTA//StrTran(cCONTA,"-","")
				ZZM->ZZM_STATUS := '1'
				ZZM->ZZM_AGRUP	:= ''
				ZZM->ZZM_TIPOC  := IIF(cTipoConta == '1','01','11') 
				ZZM->(MsUnlock())
				// Itens						
				For nI := 1 To Len( aITEM )
					Reclock("ZZN",.T.)             
					ZZN->ZZN_FILIAL  := cFILPED
					ZZN->ZZN_PEDIDO	 := cPedido
					ZZN->ZZN_ITEM    := STRZERO(Val(aITEM[nI][1]),2)
					ZZN->ZZN_PRODUT	 := aITEM[nI][2]
					ZZN->ZZN_QTCAB   := aITEM[nI][3]
					ZZN->ZZN_QTKG  	 := aITEM[nI][4]
					ZZN->ZZN_VLTOT 	 := aITEM[nI][5]
					ZZN->ZZN_VLARRO	 := aITEM[nI][6] 
					ZZN->ZZN_CODAGR  := GetAdvFVal( "SB1", "B1_ZCODAGR", xFilial('SB1')+aITEM[nI][2], 1, "" )
					ZZN->ZZN_QTPE    := nQtde_Qtpe // Paulo da Mata - 31/08/2020 - RTASK0011418
					ZZN->(MsUnlock())
				Next NI
				// MAPA
				For nI := 1 To Len( aMapa )
					Reclock("ZZO",.T.)             
					ZZO->ZZO_FILIAL := cFILPED
					ZZO->ZZO_PEDIDO	:= cPedido
					ZZO->ZZO_SEMADE := aMapa[nI][1]
					ZZO->ZZO_MAPA  	:= aMapa[nI][2]
					ZZO->ZZO_VTINC  := aMapa[nI][3]
					ZZO->ZZO_IDA   	:= aMapa[nI][4]
					ZZO->(MsUnlock())
				Next NI
	
				//GTA
				aGTA := Separa(cNUM_GTA,';',.T.)         
				For nI := 1 To Len( aGTA )
					Reclock("ZZQ",.T.)             
					ZZQ->ZZQ_FILIAL := cFILPED
					ZZQ->ZZQ_PEDIDO	:= cPedido
					ZZQ->ZZQ_GTA    := aGTA[nI]
					ZZQ->(MsUnlock())
				Next NI       
				
				aRetorno[1]:= "1"
				aRetorno[2]:= 'Pedido realizado com sucesso'
			EndIF
		EndIF
	END TRANSACTION
EndIF

If Len(aRetorno) == 0 .or. (Len(aRetorno) > 0 .and. !aRetorno[1] $ "1/2")
    AAdd(aRetorno ,"2")
    AAdd(aRetorno,'Erro não identificado')
Endif
	
Return aRetorno

