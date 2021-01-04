#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     

#Include "Protheus.Ch"
#Include "Report.Ch"
#include "Rwmake.ch"
#include "Ap5mail.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FWCOMMAND.CH"
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFJUR05
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integração Grade de Aprovação SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio de Email 
=====================================================================================
@alterações 18/12/2019 - Henrique Vidal
	RTASK0010528 - Processos gestão juridica desenvolver opção para habilitar processos
	Desenvolvido tratamento que possibilite habilitar-inativar processo para envio de e-mail para o processo 00006.
	Veja documentação na tarefa
*/

User Function MGFJUR05 

Local cQuery := ''

Private aMatriz   := {"01","010001"}  
Private lIsBlind  :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
Private cHtml     :=  ''    

IF lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	If !LockByName("MGFJUR05")
		Conout("JOB já em Execução : MGFJUR05 " + DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf   
EndIF

JURA091({'01', '010001', '000000', { '000002', '01', '010001' }})
JURA091({'01', '010001', '000000', { '000003', '01', '010001' }})
JURA091({'01', '010001', '000000', { '000004', '01', '010001' }})
JURA091({'01', '010001', '000000', { '000005', '01', '010001' }})


If Empty(Alias())
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
EndIf 

dbSelectArea("NSX")
dbSetOrder(1)
If dbSeek(xFilial('NSX')+'000006')
	If NSX->NSX_ATIVO
		JURA091({'01', '010001', '000000', { '000006', '01', '010001' }})
	EndIf
EndIf 

Return