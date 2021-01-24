#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE26
Autor....:              Marcelo Carneiro         
Data.....:              10/11/2017 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA Saldo AR
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo SALDOAR
==========================================================================================================
*/

WSSTRUCT TAE26_CONSULTA
	WSDATA FILIAL         as String
	WSDATA NUM_AR         as String
ENDWSSTRUCT

WSSTRUCT TAE26_ITENS
	WSDATA COD            as String
	WSDATA QUANT          as Float
ENDWSSTRUCT

WSSTRUCT TAE26_RETORNO
   WSDATA ITENS  as Array of TAE26_ITENS
ENDWSSTRUCT

WSSERVICE MGFTAE26 DESCRIPTION "Consulta Saldo AR Protheus" NameSpace "http://www.totvs.com.br/MGFTAE26"
	WSDATA WSCONSULTA as TAE26_CONSULTA
	WSDATA WSRETORNO  as TAE26_RETORNO

	WSMETHOD SALDOAR DESCRIPTION "Consulta Saldo AR Protheus"
ENDWSSERVICE

WSMETHOD SALDOAR  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAE26
     
Local nI      := 0 
Private cFilSaldo := Alltrim(::WSCONSULTA:FILIAL)
Private cAR       := Alltrim(::WSCONSULTA:NUM_AR)
Private bContinua := .T.
Private aRetorno  := {} 
Private aRec      := {}
                      
dbSelectArea('ZZI')
ZZI->(dbSetOrder(1))
IF ZZI->(!dbSeek( cFilSaldo+cAR ))
    bContinua := .F.
Else
   While ZZI->(!EOF()) .And. ZZI->ZZI_FILIAL + ZZI->ZZI_AR  == cFilSaldo+cAR
		    aRec      := {}
			AAdd(aRec,ZZI->ZZI_PRODUT)	
			AAdd(aRec,ZZI->ZZI_QCONT)
			AAdd(aRetorno,aRec)
			ZZI->(dbSkip())
	End
EndIF
IF Len(aRetorno) == 0 .OR. !bContinua
	aRec      := {}
	AAdd(aRec,'')
	AAdd(aRec,0)
	AAdd(aRetorno,aRec)
EndIF

::WSRETORNO := WSClassNew( "TAE26_RETORNO")
::WSRETORNO:ITENS := {}


For nI := 1 To Len(aRetorno)
	aAdd(::WSRETORNO:ITENS,WSClassNew( "TAE26_ITENS"))
	::WSRETORNO:ITENS[nI]:COD            := aRetorno[nI,1]
	::WSRETORNO:ITENS[nI]:QUANT          := aRetorno[nI,2]
Next nI

Return .T.



