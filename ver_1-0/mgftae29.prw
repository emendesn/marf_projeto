#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "FWMVCDEF.CH"
#include "apwebsrv.ch"
#include "apwebex.ch"

/*/{Protheus.doc} MGFTAE29_DADOS
Estrutura dos Dados que sera recebida no WS
@type property
http://spdwfapl180:8190/MGFTAE29.apw?WSDL

@author Marcos Cesar Donizeti Vieira
@since 18/07/2019
@version P12
/*/
WSSTRUCT MGFTAE29_DADOS
    WSDATA FILIAL       	as String
    WSDATA CODIGOAR			as String
	WSDATA ITEMNF			as String
    WSDATA CODIGOPRODUTO	as String
    WSDATA MOTIVOAFERIDO	as String
    WSDATA RESPONSAFERICAO	as String
ENDWSSTRUCT

/*/{Protheus.doc} MGFTAE29_RETORNO
Estrutura dos Dados para retorno do WS
@type property

@author Marcos Cesar Donizeti Vieira
@since 18/07/2019
@version P12
/*/
WSSTRUCT MGFTAE29_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

/*/{Protheus.doc} MGFTAE29
Classe do WS contendo suas propriedades e metodos
@type class

@author Marcos Cesar Donizeti Vieira
@since 18/07/2019
@version P12
/*/
WSSERVICE MGFTAE29 DESCRIPTION "Grava Motivo Aferido - Taura -> Protheus/RAMI" NameSpace "http://www.totvs.com.br/MGFTAE29"
	WSDATA WSDADOS    as MGFTAE29_DADOS 
	WSDATA WSRETORNO  as MGFTAE29_RETORNO

	WSMETHOD GravMotAfer DESCRIPTION "Grava Motivo Aferido"
ENDWSSERVICE

/*/{Protheus.doc} GravMotAfer
Metodo que ira realizar a gravação de classe do tipo do veiculo
@type method

@param WSDADOS, objeto de MGFTAE29_DADOS ,  Dados recebidos via WS (FILIAL,CODIGOAR,ITEMNF,CODIGOPRODUTO,MOTIVOAFERIDO,RESPONSAFERICAO )
@return WSSEND, objeto de MGFTAE29_RETORNO ,  Dados enviados apos processamento(Status, mensagem)

@author Marcos Cesar Donizeti Vieira
@since 18/07/2019
@version P12
/*/
WSMETHOD GravMotAfer WSRECEIVE WSDADOS WSSEND WSRETORNO WSSERVICE MGFTAE29

Local _lCont 		:= .T.
Local _aRetorno 	:= {"O","INTEGRAÇÃO FINALIZADA COM SUCESSO"}
Local _cFilial		:= Alltrim(::WSDADOS:FILIAL)
Local _cCodAr		:= Alltrim(::WSDADOS:CODIGOAR)
Local _cItemNF		:= SUBSTR(Alltrim(::WSDADOS:ITEMNF),3,2)+"  "
Local _cCodProd		:= Alltrim(::WSDADOS:CODIGOPRODUTO)
Local _cMotAfer		:= Alltrim(::WSDADOS:MOTIVOAFERIDO)
Local _cRespAfer	:= UPPER(Alltrim(::WSDADOS:RESPONSAFERICAO))

conout("=| INICIO - MGFTAE29 |=============================="	)
conout(" [MGFTAE29] * * * * * Status da integracao * * * * *"	)
conout(" [MGFTAE29] DATA................" + dToC(dDataBase)		)
conout(" [MGFTAE29] HORA................" + TIME()				)
conout(" [MGFTAE29] FILIAL.............." + _cFilial			)
conout(" [MGFTAE29] CODIGOAR............" + _cCodAr				)
conout(" [MGFTAE29] ITEMNF.............." + _cItemNF			)
conout(" [MGFTAE29] CODIGOPRODUTO......." + _cCodProd		    )
conout(" [MGFTAE29] MOTIVOAFERIDO......." + _cMotAfer			)
conout(" [MGFTAE29] RESPONSAFERICAO....." + _cRespAfer		    )

If Empty(_cFilial)
	_lCont := .F.
	_aRetorno := {"E","FILIAL NÃO INFORMADA." }
EndIf

If _lCont
	dbSelectArea("ZZH")
	ZZH->(dbSetOrder(1))	//ZZH_FILIAL+ZZH_AR
	If !(ZZH->(dbSeek(_cFilial+_cCodAr)))
		_lCont := .F.
		_aRetorno := {"E","AR NÃO CADASTRADO NO PROTHEUS. AR: " + _cCodAr}
	EndIf
EndIf

If _lCont
	If Empty(_cItemNF)
		_lCont := .F.
		_aRetorno := {"E","ITEM DA NF NÃO INFORMADO." }
	EndIf
EndIf

If Empty(_cCodProd)
	_lCont := .F.
	_aRetorno := {"E","CÓDIGO DO PRODUTO NÃO INFORMADO." }
EndIf

If _lCont
	dbSelectArea("ZAT")
	ZAT->(dbSetOrder(1))	//ZAT_FILIAL+ZAT_CODIGO
	If !(ZAT->(dbSeek(xFilial("ZAT") + _cMotAfer)))
		_lCont := .F.
		_aRetorno := {"E","MOTIVO AFERIDO NÃO CADATRADO NO PROTHEUS. MOTIVO: " + _cMotAfer}
	EndIf
EndIf

If _lCont
	If Empty(_cRespAfer)
		_lCont := .F.
		_aRetorno := {"E","REPONSÁVEL PELA AFERIÇÃO NÃO INFORMADO." }
	EndIf
EndIf

If _lCont
	dbSelectArea("ZAX")
	ZAX->(dbOrderNickName("ZAXDOCGER"))
	If (ZAX->(dbSeek( _cFilial+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+_cItemNF+_cCodProd )))
		dbSelectArea("ZAW")
		ZAW->(dbSetOrder(1))	//ZAW_FILIAL+ZAW_CDRAMI+ZAW_ITEMNF                                                                                                  
		If (ZAW->(dbSeek( _cFilial+ZAX->ZAX_CDRAMI+ZAX->ZAX_ITEMNF )))
			While !ZAW->( EOF() ) .AND.  _cFilial+ZAX->ZAX_CDRAMI+ZAX->ZAX_ITEMNF = ZAW->ZAW_FILIAL+ZAW->ZAW_CDRAMI+ZAW_ITEMNF
				RecLock("ZAW",.F.)
				ZAW->ZAW_MOTAFE := ZAT->ZAT_DESCRI
				ZAW->ZAW_RESPAF := _cRespAfer
				ZAW->(MsUnLock())

				ZAW->( dbSkip() )
			EndDo
		Else
			_aRetorno := {"E","OCORRÊNCIAS DA RAMI NÃO ENCONTRADA(ZAW)."}	
		EndIf
	Else
		_aRetorno := {"E","NOTA DE DEVOLUÇÃO NÃO ENCONTRADA(ZAX)."+_cFilial+ALLTRIM(ZZH->ZZH_DOC)+ALLTRIM(ZZH->ZZH_SERIE)+_cItemNF+_cCodProd} 
	EndIf
EndIf

U_MGFMONITOR(     _cFilial 		,;
				  _aRetorno[1]	,;
	              '001'			,; //cCodint
				  '019' 		,;//cCodtpint
				  _aRetorno[2]	,;
				  _cFilial+'-'+_cCodAr+'-'+_cItemNF+'-'+_cCodProd ,; //cDocori
				  '0' 			,;//cTempo
				  ''			,;
				  0)

conout(" [MGFTAE29] STATUS.............." + _aRetorno[1]		)
conout(" [MGFTAE29] MSG................." + _aRetorno[2]		)
conout("=================================| FIM - MGFTAE29 |="	)

::WSRETORNO := WSClassNew( "MGFTAE29_RETORNO")

::WSRETORNO:STATUS  := _aRetorno[1]
::WSRETORNO:MSG	    := _aRetorno[2]

Return .T.
