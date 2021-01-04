#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            

#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE09
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WebServer Server para Gerar o Movimento de Contagem - Carga Fria
==========================================================================================================
*/

WSSTRUCT FTAE09_CHAVES
	WSDATA NOME  as String
	WSDATA VALOR as String
ENDWSSTRUCT


WSSTRUCT FTAE09_MOVAR
	WSDATA ACAO         as String
	WSDATA GERAROP      as String
	WSDATA FILIAL       as String
	WSDATA NUM_AR       as String
	WSDATA PRODUTO      as String
	WSDATA SEQ          as String
	WSDATA QUANT        as Float
	WSDATA DATAMOV      as String
	WSDATA HORAMOV      as String
	WSDATA LOTE         as String
	WSDATA VALIDADE     as String
	WSDATA DATAPROD     as String 
	WSDATA IDMOV        as Integer
	WSDATA CHAVES       as array of FTAE09_CHAVES OPTIONAL
	WSDATA ChaveUID     as String OPTIONAL
	WSDATA BLOQUEIO     as String OPTIONAL
ENDWSSTRUCT

WSSTRUCT FTAE09_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE09 DESCRIPTION "Gerar o Movimento de Contagem - Carga Fria" NameSpace "http://www.totvs.com.br/MGFTAE09"
	WSDATA WSMOVAR    as FTAE09_MOVAR
	WSDATA WSRETORNO  as FTAE09_RETORNO

	WSMETHOD GerarMovAR DESCRIPTION "Gerar o Movimento de Contagem - Carga Fria"	
ENDWSSERVICE
WSMETHOD GerarMovAR WSRECEIVE WSMOVAR WSSEND WSRETORNO WSSERVICE MGFTAE09

// FORMA SICRONA       
/*
Private aRetorno  := {}

aRetorno := U_MGFTAE10( ::WSMOVAR:ACAO     ,;
						::WSMOVAR:GERAROP  ,;
						::WSMOVAR:FILIAL   ,;
						::WSMOVAR:NUM_AR   ,;
						::WSMOVAR:PRODUTO  ,;
						::WSMOVAR:SEQ      ,;
						::WSMOVAR:QUANT    ,;
						::WSMOVAR:DATAMOV  ,;
						::WSMOVAR:HORAMOV  ,;
						::WSMOVAR:LOTE     ,;
						::WSMOVAR:VALIDADE ,;
						::WSMOVAR:DATAPROD ,;
						::WSMOVAR:IDMOV     )


::WSRETORNO := WSClassNew( "FTAE09_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]                 
::WSRETORNO:MSG	    := aRetorno[2]     
::WSRETORNO:ITENS[nI]:COD  
*/                                       
// FORMA ASSICRONA

Local nI := 0 

dbSelectArea("ZD1")
If RecLock("ZD1",.T.)
	ZD1->ZD1_FILIAL	  := ::WSMOVAR:FILIAL
	ZD1->ZD1_STATUS	  := Ret_Status(::WSMOVAR:ChaveUID)
	ZD1->ZD1_INTEGR   := 'N'       
	IF ::WSMOVAR:BLOQUEIO == 'S'
		IF ::WSMOVAR:ACAO == '1' 
			ZD1->ZD1_ACAO     := 'B'
		ElseIF ::WSMOVAR:ACAO == '2'                        
		    ZD1->ZD1_ACAO     := 'D'
		Else
		    ZD1->ZD1_ACAO     := ::WSMOVAR:ACAO
		EndIF
	Else
		ZD1->ZD1_ACAO     := ::WSMOVAR:ACAO
	EndIF
	ZD1->ZD1_GERAOP   := ::WSMOVAR:GERAROP
	ZD1->ZD1_NUM_AR   := ::WSMOVAR:NUM_AR
	ZD1->ZD1_PRODUT   := ::WSMOVAR:PRODUTO
	ZD1->ZD1_SEQ      := ::WSMOVAR:SEQ
	ZD1->ZD1_QUANT    := ::WSMOVAR:QUANT
	ZD1->ZD1_DATAMO   := ::WSMOVAR:DATAMOV
	ZD1->ZD1_HORAMO   := ::WSMOVAR:HORAMOV
	ZD1->ZD1_LOTE     := ::WSMOVAR:LOTE
	ZD1->ZD1_VALIDA   := ::WSMOVAR:VALIDADE
	ZD1->ZD1_DATAPR   := ::WSMOVAR:DATAPROD
	ZD1->ZD1_IDMOV    := ::WSMOVAR:IDMOV  
	ZD1->ZD1_DTREC    := dDataBase  
	ZD1->ZD1_HRREC    := Time()
	
	IF !Empty(::WSMOVAR:ChaveUID)
		ZD1->ZD1_ChaveU   := ::WSMOVAR:ChaveUID
	EndIF
	For nI := 1 to Len(::WSMOVAR:Chaves)
		IF Alltrim(::WSMOVAR:Chaves[nI]:NOME) == 'ID'  
		    ZD1->ZD1_ID:=VAL(::WSMOVAR:Chaves[nI]:VALOR)
		ENDIF
		IF Upper(Alltrim(::WSMOVAR:Chaves[nI]:NOME)) == Upper('IdOperacaoEstoque')  
		    ZD1->ZD1_IDOPER:=VAL(::WSMOVAR:Chaves[nI]:VALOR)
		ENDIF
		IF Upper(Alltrim(::WSMOVAR:Chaves[nI]:NOME)) == Upper('IdEmpresaOperacaoEstoque')  
		    ZD1->ZD1_IDEMPR:=VAL(::WSMOVAR:Chaves[nI]:VALOR)
		ENDIF
	Next nI   
	ZD1->( msUnlock() )
	::WSRETORNO := WSClassNew( "FTAE09_RETORNO")
	::WSRETORNO:STATUS  := '1'
	::WSRETORNO:MSG	    := 'ok'
Else
	::WSRETORNO := WSClassNew( "FTAE09_RETORNO")
	::WSRETORNO:STATUS  := '2'
	::WSRETORNO:MSG	    := 'ERRO'
EndIf
                          
::WSMOVAR := Nil
DelClassINTF()

Return .T.                                     

**********************************************************************************************************************************
Static Function Ret_Status(cChave)
Local cQuery    := ''
Local nRet      := 0 

cQuery  := " SELECT ZD1_CHAVEU "
cQuery  += " FROM "+RetSqlName("ZD1")
cQuery  += " WHERE D_E_L_E_T_ = ' ' "
cQuery  += "  AND ZD1_CHAVEU='"+Alltrim(cChave)+"'"
cQuery  += "  AND ZD1_STATUS not in ( 3, 4) "
If Select("QRY_CHAVE") > 0
	QRY_CHAVE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CHAVE",.T.,.F.)
dbSelectArea("QRY_CHAVE")
QRY_CHAVE->(dbGoTop())
IF QRY_CHAVE->(!EOF())
	nRet := 4
Else
	cUpd := "UPDATE "+RetSqlName("ZD1")+" " + CRLF
	cUpd += "SET ZD1_STATUS =  4 " + CRLF
	cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cUpd += "	AND ZD1_CHAVEU='"+Alltrim(cChave)+"' "+CRLF
	cUpd += "	AND ZD1_STATUS = 3 "+CRLF
	If TcSqlExec( cUpd ) == 0
		If "ORACLE" $ TcGetDB()
			TcSqlExec( "COMMIT" )
		EndIf
	EndIf
EndIF


Return nRet 

