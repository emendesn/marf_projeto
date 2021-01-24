#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
{Protheus.doc} MGFWSS24
Integra��o de Produtores - Salesforce

@description
Este programa ir� tratar pontos espec�ficos da integra��o Salesforce

@author Edson Bella Gon�alves
@since 18/11/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function
@table
	SA2 - Fornecedores
	FIL - bancos de Fornecedores
	ZH3 - Controle de integra��o
@param
@return

@menu
@history
/*/

//--------------------------------------------------------------------
//ESTRUTURA PARA INTEGRA��O DE BANCOS SF->PROTHEUS
//--------------------------------------------------------------------

WSSTRUCT WSS24_BANCO
	WSDATA A2_CGC		AS STRING
	WSDATA ABANCO		AS ARRAY OF WSS24_BANCO_PECUARISTA
ENDWSSTRUCT
//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS24_BANCO_PECUARISTA
	WSDATA FIL_BANCO	AS STRING optional
	WSDATA FIL_AGENCI	AS STRING optional
	WSDATA FIL_DVAGE	AS STRING optional
	WSDATA FIL_CONTA	AS STRING optional
	WSDATA FIL_DVCTA	AS STRING optional
	WSDATA FIL_TIPO		AS STRING optional
	WSDATA FIL_TIPCTA	AS STRING optional
	WSDATA FIL_DETRAC	AS STRING optional
	WSDATA FIL_MOEDA 	AS STRING optional
	WSDATA FIL_MOVCTO	AS STRING optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS24_RETURN_BCO
	WSDATA RETORNO			AS STRING
ENDWSSTRUCT
//FIM ESTRUTURA PARA INTEGRA��O DE BANCOS SF->PROTHEUS

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS24 DESCRIPTION "Integra��o de banco Produtor - Pecuarista e Fazenda" namespace "http://www.totvs.com.br/MGFWSS24"
	WSDATA response			AS WSS24_RETURN_BCO
	WSDATA banco			AS WSS24_BANCO
	WSDATA abanco			AS WSS24_BANCO_PECUARISTA

	WSMETHOD insertOrUpdateBanco	DESCRIPTION "Inclus�o / Atualiza��o Banco do Produtor- S�ncrono"
	//WSMETHOD callback				DESCRIPTION "Callback integra��o de produtores"
	//WSMETHOD UpdateFornecedor 		DESCRIPTION "Atualiza��o Fornecedor no Protheus - S�ncrono"
ENDWSSERVICE

//--------------------------------------------------------------------
//--------------------------------------------------------------------

WSMETHOD insertOrUpdateBanco WSRECEIVE banco WSSEND response WSSERVICE MGFWSS24

setFunName( "MGFWSS24" )

U_MFCONOUT( "insertOrUpdateBancoProdutor in�cio" )

_cRetFor	:= GetNextAlias()
	
BeginSql Alias _cRetFor

	SELECT
		A2_COD, A2_LOJA, A2_ZIDCRM, A2_MSBLQL
	FROM
		%table:SA2% SA2
	WHERE
		A2_FILIAL=%xFilial:SA2% AND A2_CGC=%exp:banco:A2_CGC% AND A2_LOJA='01' AND
		SA2.%notDel%
EndSql

BEGIN TRANSACTION

	If Eof()

		_AtuZH3('2', 'N�o existe cadastrado o pecuarista '+banco:A2_CGC)

		::response:RETORNO		:="Status "+ZH3->ZH3_STATUS+" - "+ZH3->ZH3_RETURN
	
	ElseIf (_cRetFor)->A2_MSBLQL='1'

		_AtuZH3('2', 'Pecuarista pendente de aprova��o. CGC/CNPJ '+Alltrim(banco:A2_CGC)+' - C�digo/loja '+(_cRetFor)->A2_COD+'/'+(_cRetFor)->A2_LOJA)

		::response:RETORNO		:="Status "+ZH3->ZH3_STATUS+" - "+ZH3->ZH3_RETURN
	else

		_nBco		:=len(banco:abanco)
		_cFIL_FORNEC:=(_cRetFor)->A2_COD
		_cFIL_LOJA	:=(_cRetFor)->A2_LOJA
		_lAtuSA2	:=.f.

		For nFor:=1 To _nBco
			
			If banco:abanco[nFor]:FIL_TIPO=='1'
				dbSelectArea("FIL")
				dbSetOrder(1)
				
				If dbSeek(xFilial("FIL")+_cFIL_FORNECE+_cFIL_LOJA+'1')
					RecLock("FIL")
					FIL->FIL_TIPO:='2'
					MsUnlock()
				End
			End
			
			_cRetFil	:= GetNextAlias()
	
			BeginSql Alias _cRetFil

				SELECT
					FIL_FORNEC
				FROM
					%table:FIL% FIL
				WHERE
					FIL_FILIAL=%xFilial:FIL% AND FIL_FORNEC=%exp:_cFIL_FORNEC% AND FIL_LOJA=%exp:_cFIL_LOJA% AND
					FIL_BANCO=%exp:banco:abanco[nFor]:FIL_BANCO% AND FIL_AGENCI=%exp:banco:abanco[nFor]:FIL_AGENCI% AND
					FIL_CONTA=%exp:banco:abanco[nFor]:FIL_CONTA% AND
					FIL.%notDel%
			
			EndSql

			dbSelectArea("FIL")
			RecLock("FIL",(_cRetFil)->(Eof()))

				FIL->FIL_FILIAL	:=xFilial("FIL")
				FIL->FIL_FORNEC	:=_cFIL_FORNEC
				FIL->FIL_LOJA	:=_cFIL_LOJA
				FIL->FIL_AGENCI	:=banco:abanco[nFor]:FIL_AGENCI
				FIL->FIL_BANCO	:=banco:abanco[nFor]:FIL_BANCO
				FIL->FIL_CONTA	:=banco:abanco[nFor]:FIL_CONTA
				FIL->FIL_DVAGE	:=banco:abanco[nFor]:FIL_DVAGE
				FIL->FIL_DVCTA	:=banco:abanco[nFor]:FIL_DVCTA
				FIL->FIL_TIPCTA	:=banco:abanco[nFor]:FIL_TIPCTA
				FIL->FIL_TIPO	:=banco:abanco[nFor]:FIL_TIPO
				FIL->FIL_DETRAC :=banco:abanco[nFor]:FIL_DETRAC
				FIL->FIL_MOEDA	:=Val(banco:abanco[nFor]:FIL_MOEDA)
				FIL->FIL_MOVCTO	:=banco:abanco[nFor]:FIL_MOVCTO
			FIL->(MSUNLOCK())
			
			(_cRetFil)->(dbcloseArea())
			
			_cFIL_BANCO:=banco:abanco[nFor]:FIL_BANCO
			
			If FIL->FIL_TIPO=='1'
				_AtuGradeSA2()
				_lAtuSA2:=.t.
			End
		Next

		If !_lAtuSA2
				_AtuGradeSA2()
		End

		If SA2->A2_MSBLQL=='1'
			_AtuZH3('3', 'Status 3 - InsertUpdate com Sucesso.' )
		
			::response:RETORNO		:=ZH3->ZH3_RETURN

		Else
			_AtuZH3('5', 'Status 5 - InsertUpdate com Sucesso. N�o houve altera��o.' )
		
			::response:RETORNO		:=ZH3->ZH3_RETURN

		End
		
	End

End TRANSACTION

U_MFCONOUT( "insertOrUpdateBanco Finalizado" )

(_cRetFor)->(dbcloseArea())

return .T.

/*/
{Protheus.doc} _AtuZH3()
Cria ZH3

@description
Cria uma linha de status no ZH3
Integra��o de bancos no cadastro de fornecedores - Salfesforce -> Protheus

@author Edson Bella Gon�alves
@since 10/12/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function
@table
	ZH3 - Status integra��o
	SA2 - Fornecedor
	FIL - Banco fornecedor
@param
@return

@menu
@history
/*/
Static Function _AtuZH3(_cStatus, _cReturn)

dbSelectArea("ZH3")
RecLock("ZH3",.t.)

ZH3->ZH3_HASH	:=fwUUIDv4()
ZH3->ZH3_CODID	:=(_cRetFor)->A2_ZIDCRM
ZH3->ZH3_CODINT	:='008'
ZH3->ZH3_CODTIN	:='018'
ZH3->ZH3_DTRECE	:=DtoC(date())
ZH3->ZH3_HRRECE	:=time()
ZH3->ZH3_RESULT	:='ALTERA��O DE BANCO Salesforce - MGFWSS24'
ZH3->ZH3_STATUS	:=_cStatus
ZH3->ZH3_CHAVE	:=xfilial("SA1")+(_cRetFor)->A2_COD+(_cRetFor)->A2_LOJA
ZH3->ZH3_RETURN :=_cReturn

MsUnlock()

Return .t.


/*/
{Protheus.doc} _AtuGradeSA2()
Atualiza grade

@description
Atualiza grade de aprova��o
Integra��o de bancos no cadastro de fornecedores - Salfesforce -> Protheus ao inserir uma alter��o deve gerar grade de aproca��o

@author Edson Bella Gon�alves
@since 10/12/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function
@table
	SA2 - Fornecedor
	FIL - Banco fornecedor
@param
@return

@menu
@history
/*/

Static Function _AtuGradeSA2()

DBSelectArea("SA2")
DBSetOrder(1)
DBSeek(xFilial("SA2")+_cFIL_FORNEC+_cFIL_LOJA)

RegToMemory("SA2") //gera as vari�veis M->

M->A2_BANCO		:=FIL->FIL_BANCO
M->A2_AGENCIA	:=FIL->FIL_AGENCI
M->A2_NUMCON	:=FIL->FIL_CONTA

ALTERA=.t.

IF findfunction("U_MGFINT38") 
	lRet := U_MGFINT38('SA2','A2')  //grava a grade
EndIF

DBSelectArea("SA2")
RecLock("SA2")
				
SA2->A2_BANCO	:=FIL->FIL_BANCO
SA2->A2_AGENCIA	:=FIL->FIL_AGENCI
SA2->A2_NUMCON	:=FIL->FIL_CONTA

SA2->(MSUNLOCK())

Return .t.

/*/
{Protheus.doc} _WSS24ID()
Grava o idCRM de forncedor do SalesFornce

@description
Este programa ir� gravar idCRM do Salesforce no SA2
Integra��o no cadastro de fornecedores

@author Edson Bella Gon�alves
@since 19/11/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function
@table
	SA2 - Fornecedores
@param
@return

@menu
@history
/*/

User Function _WSS24ID()

dbSelectArea("SA2")
RecLock("SA2")
SA2->A2_ZIDCRM:=ZH3->ZH3_CODID
MsUnlock()

Return