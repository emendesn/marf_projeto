#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
{Protheus.doc} MGFWSC88
Callback integração a partir do ZH3 - Compra de gado

@description
Este programa irá enviar callback de atualização de fornecedor para o Salesforce a partir do ZH3.
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
User Function M_WSC88()

	RpcSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); Else; RpcSetEnv( "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); endif

	U_MGFWSC88()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return

User Function MGFWSC88

U_MFCONOUT( "Envio do Callback fornecedores - Início")

_cCallB   := GetNextAlias()

BeginSql Alias _cCallB

	SELECT
		ZH3_CHAVE, ZH3_HASH, A2_COD, A2_LOJA, ZH3_CODID, A2_ZCAEPF, A2_ZIDCRM, ZH3_STATUS
	FROM
		%table:ZH3% ZH3
		LEFT JOIN %Table:SA2% SA2
			ON SubStr(ZH3_CHAVE,1,6)=A2_FILIAL
			AND SubStr(ZH3_CHAVE,7,6)=A2_COD
			AND SubStr(ZH3_CHAVE,13,2)=A2_LOJA
			AND SA2.%notDel%
	WHERE
		ZH3_CODINT='008' AND ZH3_CODTIN in ('018') AND ZH3_STATUS in ('1','2','4','9','B') AND
		ZH3.%notDel%
EndSql

dbGoTop()

_lAchou:=!Eof()

IF _lAchou

    BEGIN TRANSACTION

        If (_cCallB)->ZH3_STATUS $"2,9,B"
            
	        dbSelectArea("ZH3")
            dbSetOrder(4)
            dbSeek((_cCallB)->ZH3_HASH)
            RecLock("ZH3")

            _cReturn:=ZH3->ZH3_RETURN
            
            If _cReturn<>''
		        _cReturn+=CRLF+"========================"+CRLF
                _cReturn+=DtoC(date())+" - "+Time()+CRLF
        	End

            If(_cCallB)->ZH3_STATUS=='2'
                ZH3->ZH3_STATUS:='8'    //Callback Salesforce - cadastrado com erro
                _cReturnA:="Erro no cadastro. "
            ElseIf(_cCallB)->ZH3_STATUS=='9'
			    ZH3->ZH3_STATUS	:='A'   //inclusão não aprovada
                _cReturnA:="Inclusão REJEITADA. "
    		ElseIf(_cCallB)->ZH3_STATUS=='B'
    			ZH3->ZH3_STATUS	:='C'   //alteração não aprovada
                _cReturnA:="Alteração REJEITADA. "
            End

            ZH3->ZH3_RETURN:=_cReturn+"Callback Status "+ZH3->ZH3_STATUS+" - "+_cReturnA
            MsUnLock()

            oClassRet				:=JsonObject():new()
            oClassRet["idERP"]		:= (_cCallB)->A2_COD
            oClassRet["idLoja"]		:= (_cCallB)->A2_LOJA
            oClassRet["caepf"]		:= (_cCallB)->A2_ZCAEPF
            oClassRet["idCRM"]		:= (_cCallB)->ZH3_CODID
            oClassRet["status"]		:= ZH3->ZH3_STATUS
            oClassRet["hash"]		:= (_cCallB)->ZH3_HASH
            oClassRet["mensagem"]	:= "Status "+ZH3->ZH3_STATUS+" - "+_cReturnA

        Else

            dbSelectArea("ZH3")
            dbSetOrder(4)
            If dbSeek((_cCallB)->ZH3_HASH)
                RecLock("ZH3")
                If ZH3_STATUS=='1'
                    ZH3->ZH3_STATUS:='3' //Callback Salesforce - cadastrado
                ElseIf ZH3_STATUS=='4'
                    ZH3->ZH3_STATUS:='5' //Callback Salesforce - desbloqueado
                End
                MsUnlock()
            End
            
            oClassRet				:=JsonObject():new()
            oClassRet["idERP"]		:= (_cCallB)->A2_COD
            oClassRet["idLoja"]		:= (_cCallB)->A2_LOJA
            oClassRet["caepf"]		:= (_cCallB)->A2_ZCAEPF
            oClassRet["idCRM"]		:= (_cCallB)->A2_ZIDCRM
            oClassRet["status"]		:= ZH3->ZH3_STATUS
            oClassRet["hash"]		:= (_cCallB)->ZH3_HASH
            oClassRet["mensagem"]	:= If(ZH3->ZH3_STATUS=='3',"FORNECEDOR BLOQUEADO","FORNECEDOR DESBLOQUEADO")

            dbSelectArea(_cCallB)
        End

        //ENVIO CALLBACK
        //

    //	If _lAchou //!Empty((_cCallB)->A2_COD) //oClassRet:idERP<>''
        If !ExisteSx6("MGF_WSC88A")
            CriarSX6("MGF_WSC88A", "C", "URL callback integração produtor"	, "https://integracoes-homologacao.marfrig.com.br:1315/experience-protheus/api/v1/fornecedores/" )
        End

        cURLInteg	:= AllTrim(SuperGetMv("MGF_WSC88A",,"https://integracoes-homologacao.marfrig.com.br:1315/experience-protheus/api/v1/fornecedores/"))
        cJson 		:= fwJsonSerialize( oClassRet , .F. , .T. )
        cHTTPMetho	:= "PUT"
        cHeaderRet	:= ""
        cHttpRet	:= ""	
        cIdInteg	:= fwUUIDv4( .T. )
        cURLInteg	+= cIdInteg+"/callback"

        aHeadStr	:= {}
        aadd( aHeadStr , 'Content-Type: application/json'			)
        aadd( aHeadStr , 'origem-criacao: '+'WGFWSC88 CALLBACK FORN')
        aadd( aHeadStr , 'origem-alteracao: protheus'				)
        aadd( aHeadStr , 'x-marfrig-client-id: ' 					)
        aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg			)

        cURLUse := cURLInteg

        nTimeOut	:= 120
        cTimeIni	:= time()

        cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )
        nStatuHttp	:= 0
        nStatuHttp	:= httpGetStatus()

        _cConout:=" * * * * * Status da integracao * * * * *"+CRLF
        _cConout+=" Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )+CRLF
        _cConout+=" Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )+CRLF
        _cConout+=" Tempo de Processamento.......: " + cTimeProc+CRLF
        _cConout+=" URL..........................: " + cURLUse+CRLF
        _cConout+=" HTTP Method..................: " + cHTTPMetho+CRLF
        _cConout+=" Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) )+CRLF
        _cConout+=" Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr )+CRLF
        _cConout+=" Envio Body...................: " + cJson+CRLF
        _cConout+=" Retorno......................: " + cHttpRet+CRLF
        _cConout+=" * * * * * * * * * * * * * * * * * * * * "

        U_MFCONOUT(_cConout)

        if nStatuHttp >= 200 .and. nStatuHttp <= 299
            //	oRequisicao := Nil
            //	fwJsonDeserialize(cHTTPRET, @oRequisicao)
            cStaLog 	:= "1"	// Sucesso
            _GrvErroCallback88('1')
        else
            cStaLog		:= "2"	// Erro
            _GrvErroCallback88('2')
            //	cErroLog	:= cHttpRet
        endif

        //FIM ENVIO CALLBACK
        //

        //End
    END TRANSACTION

    U_MFCONOUT( "Envio do Callback fornecedores - Fim")
Else

    U_MFCONOUT( "Envio do Callback fornecedores - Fim - Não há dados para envio")
End

(_cCallB)->(dbcloseArea())

Return .t.

/*/
{Protheus.doc} _GrvErroCallback88()
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

Static Function _GrvErroCallback88(_cErrBK)
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
Return