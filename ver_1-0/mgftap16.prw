#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAP16
Autor....:              Marcelo Carneiro         
Data.....:              21/06/2017 
Descricao / Objetivo:   Integração TAURA - Protheus
Doc. Origem:            MIT044- METODO CONSULTA Data de Fechamento
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WbeService Server Metodo ConsultaDataFechamento
==========================================================================================================
*/

WSSTRUCT TAP16_CONSULTA
	WSDATA FILIAL        as String
	WSDATA DATAESTOQUE   as String
ENDWSSTRUCT

WSSTRUCT TAP16_RETORNO
	WSDATA FILIAL        		as String
	WSDATA DATAESTOQUE   	  	as String
	WSDATA PERMITEREABERTURA    as String
ENDWSSTRUCT

WSSERVICE MGFTAP16 DESCRIPTION "Consulta Data Fechamento de Estoque Protheus" NameSpace "http://www.totvs.com.br/MGFTAP16"
	WSDATA WSCONSULTA as TAP16_CONSULTA
	WSDATA WSRETORNO  as TAP16_RETORNO

	WSMETHOD ConsultaDataFechamento DESCRIPTION "Consulta Data Fechamento de Estoque Protheus"
ENDWSSERVICE

WSMETHOD ConsultaDataFechamento  WSRECEIVE WSCONSULTA WSSEND WSRETORNO WSSERVICE MGFTAP16
    

Private cFilFecha  := Alltrim(::WSCONSULTA:FILIAL)
Private cDataFecha := Alltrim(::WSCONSULTA:DATAESTOQUE)
Private cPermite   := '0'

cPermite := TAP16_CONS(cFilFecha,cDataFecha)

::WSRETORNO := WSClassNew( "TAP16_RETORNO")
::WSRETORNO:FILIAL            := cFilFecha
::WSRETORNO:DATAESTOQUE   	  := cDataFecha
::WSRETORNO:PERMITEREABERTURA := cPermite

Return .T.
*********************************************************************************************************************************************************************
Static Function TAP16_CONS(cFilFecha,cDataFecha)

Local cQuery	:= ''
Local dMovBlq

Private cPermite   := '0'

cFilAnt := cFilFecha

dMovBlq	:= GetMV("MV_DBLQMOV")
dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

DTOS(dMovBlq)

IF  DTOS(dMovBlq) < cDataFecha
	cPermite := '1'
EndIF

/*
cQuery  := " SELECT X6_CONTEUD"
cQuery  += " FROM "+MPSysSqlName('SX6')
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND X6_FIL  = '"+cFilFecha+"'"
cQuery  += "   AND X6_VAR  = 'MV_ULMES' "
If Select("QRY_FECHA") > 0
	QRY_FECHA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_FECHA",.T.,.F.)
dbSelectArea("QRY_FECHA")
QRY_FECHA->(dbGoTop())
IF QRY_FECHA->(!EOF())
   IF  QRY_FECHA->X6_CONTEUD < cDataFecha
	  cPermite := '1'
   EndIF
EndIF
*/

Return cPermite

***********************************************************************************
User Function Z_TAP16
Private cPermite := ''

RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )

cPermite := TAP16_CONS('010003','20171201')

msgAlert(cPermite)      

Return




