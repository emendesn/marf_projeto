#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
{Protheus.doc} MGFWSC89
Callback integração a partir do ZH3 - Compra de gado

@description
Este programa irá enviar callback de atualização de fornecedor do Protheus para o Salesforce a partir do ZH3.
Integração no cadastro de fornecedores

@author Edson Bella Gonçalves
@since 07/12/2020

@version P12.1.017
@country Brasil
@language Português

@type Function
@table
	SA2 - Fornecedores
    ZH3 - controle de Integrações via WS
@param
@return

@menu
@history
/*/

/* FUNÇÃO SOMENTE PARA CHAMADA EM DEBUG*/
User Function M_WSC89()

	RpcSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); Else; RpcSetEnv( "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); endif

	U_MGFWSC89()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return

User Function MGFWSC89

_lRet:=.t.


setFunName( "MGFWSC89" )

U_MFCONOUT("Edição Fornecedor - início")

_cRetUpdF   := GetNextAlias()

BeginSql Alias _cRetUpdF

SELECT
	R_E_C_N_O_ REGIS, ZH3_CHAVE
FROM
	%table:ZH3% ZH3
WHERE
	ZH3_CODINT='008' AND ZH3_CODTIN='018' AND ZH3_STATUS='6' AND
	ZH3.%notDel%
EndSql

dbgoTop()

_lAchou:=!Eof()

// Cria a instância de 4etorno
_acontaBancaria			:={}

If _lAchou
	BEGIN TRANSACTION
			
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(Left((_cRetUpdF)->ZH3_CHAVE,14))

		oidFavorecido	:=JsonObject():new()
		ocontato		:=JsonObject():new()			
		oendereco		:=JsonObject():new()
		ocontaBancaria	:=JsonObject():new()

		cDatanasc:=DtoS(SA2->A2_ZDTNASC)

		oidFavorecido["idFavorecido"]		:=""
		oidFavorecido["idFornecedor"]		:=SA2->A2_COD
		oidFavorecido["idLoja"]				:=SA2->A2_LOJA
		oidFavorecido["tipoPessoa"]			:=SA2->A2_TIPO
		oidFavorecido["documento"]			:=''
		oidFavorecido["nomeFornecedor"]		:=SA2->A2_NOME
		oidFavorecido["nomePropriedade"]	:=''
		oidFavorecido["dataNascimento"]		:=Left(cDatanasc,4)+'-'+Substring(cDatanasc,5,2)+'-'+Right(cDatanasc,2)
		oidFavorecido["nacionalidade"]		:=SA2->A2_ZNASCIO
		oidFavorecido["inscrEstadual"]		:=SA2->A2_INSCR
		oidFavorecido["nirf"]				:=SA2->A2_ZNIRF
		oidFavorecido["idImovel"]			:=''
		oidFavorecido["idAmbiental"]		:=''
		oidFavorecido["emiteNFE"]			:=If(SA2->A2_ZEMINFE=='1',.t.,.f.)
		oidFavorecido["contato"]			:=''
		oidFavorecido["tipoFornecedor"]		:=If(SA2->A2_LOJA=='01' .And. SA2->A2_TIPO='F' ,'PECUARISTA','FAZENDA')

		ocontato["celular"]	:=AllTrim(SA2->A2_ZDDDCEL)+AllTrim(SA2->A2_ZCELULA)
		ocontato["telefone"]:=AllTrim(SA2->A2_DDD)+AllTrim(SA2->A2_TEL)
		ocontato["email"]	:=SA2->A2_EMAIL

		oidFavorecido["contato"]				:=ocontato

		oendereco["tipoEndereco"]	:=If(SA2->A2_ZTPENDE=='1',"R","C")
		oendereco["cep"]			:=SA2->A2_CEP
		oendereco["estado"]			:=SA2->A2_EST
		oendereco["idCidade"]		:=SA2->A2_COD_MUN
		oendereco["nomeCidade"]		:=''
		oendereco["logradouro"]		:=SA2->A2_END
		oendereco["numero"]			:=''
		oendereco["complemento"]	:=SA2->A2_ENDCOMP
		oendereco["bairro"]			:=SA2->A2_BAIRRO

		oidFavorecido["endereco"]	:=oendereco
		dbSelectArea("FIL")
		dbSetOrder(1)
		IF dbSeek(xFilial("FIL")+SA2->A2_COD+SA2->A2_LOJA+'1')

			ocontaBancaria["banco"]			:=FIL->FIL_BANCO
			ocontaBancaria["agencia"]		:=FIL->FIL_AGENCI
			ocontaBancaria["digAgencia"]	:=FIL->FIL_DVAGE
			ocontaBancaria["conta"]			:=FIL->FIL_CONTA
			ocontaBancaria["digConta"]		:=FIL->FIL_DVCTA
			ocontaBancaria["tipo"]			:=If(FIL->FIL_TIPCTA=='1',"C","P")
			ocontaBancaria["detraccion"]	:=.f.
			ocontaBancaria["principal"]		:=If(FIL->FIL_TIPO=='1',.t.,.f.)

			AAdd(_acontaBancaria,ocontaBancaria)
		End

		oidFavorecido["contaBancaria"]	:=_acontaBancaria

		dbSelectArea("ZH3")
		Go (_cRetUpdF)->REGIS
		RecLock("ZH3",.f.)
		ZH3->ZH3_STATUS	:='3' //callback de bloqueio enviado
		ZH3->ZH3_DTPROC	:=DtoC(date())
		ZH3->ZH3_HRPROC	:=time()
		MsUnlock()

		dbSelectArea(_cRetUpdF)

		//ENVIO CALLBACK
				//
		If !ExisteSx6("MGF_WSC89A")
			CriarSX6("MGF_WSC89A", "C", "URL callback edição produtor"	, "https://integracoes-homologacao.marfrig.com.br:1315/experience-protheus/api/v1/fornecedores/" )
		End

		cURLInteg	:= AllTrim(SuperGetMv("MGF_WSC89A",,"https://integracoes-homologacao.marfrig.com.br:1315/experience-protheus/api/v1/fornecedores/"))

		//freeObj(oClassRet)
		_cRequisicao:=oidFavorecido
		cJson:= fwJsonSerialize( _cRequisicao , .F. , .T. )
		cHTTPMetho	:= "PUT"
		cHeaderRet	:= ""
		cHttpRet	:= ""	
		cIdInteg	:= ZH3->ZH3_CODID//fwUUIDv4( .T. )
		cURLInteg	+= cIdInteg
		aHeadStr	:= {}
		aadd( aHeadStr , 'Content-Type: application/json'				)
		aadd( aHeadStr , 'origem-criacao: '+'WGFWSSC88 CALLBACK EDT F'	)
		aadd( aHeadStr , 'origem-alteracao: protheus'					)
		aadd( aHeadStr , 'x-marfrig-client-id: ' 						)
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg				)

		cURLUse := cURLInteg

		nTimeOut	:= 30//120
		cTimeIni	:= time()

		cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni , cTimeFin )
		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		_cConout:="_ * * * * * Status da integracao * * * * *"+CRLF
		_cConout+="_ Inicio.......................: " + cTimeIni + " - " + dToC( date() )+CRLF
		_cConout+="_ Fim..........................: " + cTimeFin + " - " + dToC( date() )+CRLF
		_cConout+="_ Tempo de Processamento.......: " + cTimeProc+CRLF
		_cConout+="_ URL..........................: " + cURLUse+CRLF
		_cConout+="_ HTTP Method..................: " + cHTTPMetho+CRLF
		_cConout+="_ Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) )+CRLF
		_cConout+="_ Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr )+CRLF
		_cConout+="_ Envio Body...................: " + cJson+CRLF
		_cConout+="_ Retorno......................: " + cHttpRet+CRLF
		_cConout+="_ * * * * * * * * * * * * * * * * * * * * "+CRLF

		U_MFCONOUT(_cConout)

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			cStaLog 	:= "1"	// Sucesso
			_GrvErroCallback89('1')
		else
			cStaLog		:= "2"	// Erro
			_GrvErroCallback89('2')
		endif

		//FIM ENVIO CALLBACK

	END TRANSACTION

	U_MFCONOUT(" Edição Fornecedor - Fim")
Else
	U_MFCONOUT(" Edição Fornecedor - Fim - Não há dados para envio")
EndIf

//---Fechando area de trabalho
(_cRetUpdF)->(dbcloseArea())

return _lRet

/*/
{Protheus.doc} _GrvErroCallback89()
Grava o Status 7 caso ocorra erro no http de forncedor do SalesFornce

@description
Gravação do erro quando status 7
Integração no cadastro de fornecedores

@author Edson Bella Gonçalves
@since 25/11/2020

@version P12.1.017
@country Brasil
@language Português

@type Function
@table
	ZH3 - Status integração
@param
@return

@menu
@history
/*/

Static Function _GrvErroCallback89(_cErrBK)
	If _lAchou
		dbSelectarea("ZH3")
		_cReturn:=ZH3->ZH3_RETURN
		If _cReturn<>''
			_cReturn+=CRLF+"========================"+CRLF
		End
		_cReturn+=DtoC(date())+" - "+Time()+CRLF
		RecLock("ZH3")
		If _cErrBK=='2'
			ZH3->ZH3_STATUS:='7' //Callback Salesforce - COM ERRO
		End
		_cReturn+="Status "+ZH3->ZH3_STATUS+" - "+cHttpRet+CRLF
		_cReturn+="Código de retorno: "+Alltrim(Str(nStatuHttp))+CRLF
		_cReturn+=cURLUse+CRLF
		_cReturn+=cIdInteg+CRLF
		_cReturn+=cJson
		ZH3->ZH3_RETURN :=_cReturn
		MsUnlock()
	End
Return