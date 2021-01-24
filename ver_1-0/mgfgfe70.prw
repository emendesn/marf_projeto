#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"                                     

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFGFE70
WS Recep��o de �nicio de viagem de carga

@author Josu� Danich Prestes
@since 23/10/2020 
@type WS  
/*/   

WSSTRUCT MGFGFE70INICIOVIAGEM
	WSDATA ZHJ_UUID	AS string
    WSDATA ZHJ_JSONR AS string
ENDWSSTRUCT

WSSTRUCT MGFGFE70RETORNO
	WSDATA STATUS	AS String
	WSDATA MSG		AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Produ��o.				                       *
***************************************************************************/
WSSERVICE MGFGFE70 DESCRIPTION "Recebimento de inicio de viagem" NameSpace "http://totvs.com.br/MGFGFE70.apw"

	WSDATA MGFGFE70INICIOVIAGEM AS MGFGFE70INICIOVIAGEM
	WSDATA MGFGFE70RETORNO AS MGFGFE70RETORNO

	WSMETHOD InicioViagem DESCRIPTION "Recebimento de inicio de viagem"

ENDWSSERVICE

/************************************************************************************
** Metodo GerarMovTaura
** Grava dados de processos produtivos - apontamentos / requisi��es referentes a OPs
************************************************************************************/
WSMETHOD InicioViagem WSRECEIVE	MGFGFE70INICIOVIAGEM WSSEND MGFGFE70RETORNO WSSERVICE MGFGFE70

Local lReturn	:= .T.
Local _cuuid := IIF(::MGFGFE70INICIOVIAGEM:ZHJ_UUID<>NIL,::MGFGFE70INICIOVIAGEM:ZHJ_UUID,"")

U_MFCONOUT('Recebeu Inicio de Viagem com UUID ' + _cuuid +"...") 

BEGIN SEQUENCE

//Valida se j� existe registro com mesma UUID
ZHJ->(Dbsetorder(1)) //ZHJ_UUID
If ZHJ->(Dbseek(alltrim(_cuuid)))

	//Se j� existe e for igual retorna sucesso
	_ligual := .T.

	If 	ALLTRIM(ZHJ->ZHJ_JSONR)	!=	ALLTRIM(::MGFGFE70INICIOVIAGEM:ZHJ_JSONR)
		
		_ligual := .F.

	Endif

	If _ligual 

		U_MFCONOUT('     Chamada com UUID ' + alltrim(_cuuid) +" j� existe sem diverg�ncia...") 
        _cstatus := "1"
        _cretorno := '     Chamada com UUID ' + alltrim(_cuuid) +" j� existe sem diverg�ncia..."
        BREAK

	Else
	
		U_MFCONOUT('     Chamada com UUID ' + alltrim(_cuuid) +" j� existe com diverg�ncia...") 
        _cstatus := "2"
        _cretorno := '     Chamada com UUID ' + alltrim(_cuuid) +" j� existe com diverg�ncia..."
        BREAK

	Endif

	Return( aRetorno )

Endif

If !(mayiusecode(alltrim(_cuuid)))
    _cstatus := "2"
    _cretorno := '     Outra inst�ncia j� est� gravando com UUID ' + alltrim(_cuuid) +"..."
	U_MFCONOUT('     Outra inst�ncia j� est� gravando com UUID ' + alltrim(_cuuid) +"...")
    BREAK
Endif

U_MFCONOUT('     Gravando Chamada com UUID ' + alltrim(_cuuid) +"...")

If RecLock("ZHJ",.T.)
	ZHJ->ZHJ_UUID	:=	alltrim(_cuuid)
	ZHJ->ZHJ_JSONR	:=	ALLTRIM(::MGFGFE70INICIOVIAGEM:ZHJ_JSONR)
	ZHJ->ZHJ_DATAR := date()
	ZHJ->ZHJ_HORAR := time()
	ZHJ->( msUnlock() )

	_cstatus := "1"
    _cretorno := '     Gravou Chamada com UUID ' + alltrim(_cuuid) +"..."
	U_MFCONOUT('     Gravou Chamada com UUID ' + alltrim(_cuuid) +"...")
    BREAK


Else
	_cstatus := "2"
    _cretorno := '     Falhou grava��o de Chamada com UUID ' + alltrim(_cuuid) +"..."
	U_MFCONOUT('     Falhou grava��o de Chamada com UUID ' + alltrim(_cuuid) +"...")
    BREAK

EndIf

END SEQUENCE

Leave1Code(alltrim(_cuuid))

// Cria e alimenta uma nova instancia de retorno do cliente
::MGFGFE70RETORNO :=  WSClassNew( "MGFGFE70RETORNO" )
::MGFGFE70RETORNO:STATUS	:= _cstatus
::MGFGFE70RETORNO:MSG		:= _cretorno

::MGFGFE70INICIOVIAGEM := Nil

U_MFCONOUT('Completou Inicio de Viagem com UUID ' + _cuuid +" e resultado " + _cretorno + "...") 

Return lReturn
