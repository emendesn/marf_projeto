#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "FWMVCDEF.CH"
#include "apwebsrv.ch"
#include "apwebex.ch"

/*/{Protheus.doc} MGFTAC12_DADOS
Estrutura dos Dados que sera recebida no WS
@type property

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
WSSTRUCT MGFTAC12_DADOS
	WSDATA TIPOVEICULO      as String
	WSDATA CODCLASSIFICAO   as Integer
	WSDATA DESCCLASSIFICAO  as String
	WSDATA ACAO  			as Integer
ENDWSSTRUCT

/*/{Protheus.doc} MGFTAC12_RETORNO
Estrutura dos Dados para retorno do WS
@type property

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
WSSTRUCT MGFTAC12_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

/*/{Protheus.doc} MGFTAC12
Classe do WS contendo suas propriedades e metodos
@type class

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
WSSERVICE MGFTAC12 DESCRIPTION "Grava Tipo Vei Vs Classifica��o" NameSpace "http://www.totvs.com.br/MGFTAC12"

	WSDATA WSDADOS    as MGFTAC12_DADOS
	WSDATA WSRETORNO  as MGFTAC12_RETORNO

	WSMETHOD GravClass DESCRIPTION "Grava Tipo Veiculo vs Classifi��o"

ENDWSSERVICE

/*/{Protheus.doc} GravClass
Metodo que ira realizar a grava��o de classe do tipo do veiculo
@type method

@param WSDADOS, objeto de MGFTAC12_DADOS ,  Dados recebidos via WS (tipo,cod classificacao, descricao classificacao)
@return WSSEND, objeto de MGFTAC12_RETORNO ,  Dados enviados apos processamento(Status, mensagem)

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
WSMETHOD GravClass WSRECEIVE WSDADOS WSSEND WSRETORNO WSSERVICE MGFTAC12

Local lCont := .T.
Local aRetorno := {"O","OK"}
Local cCodClass := StrZero(::WSDADOS:CODCLASSIFICAO,TamSx3("ZEG_CODCLA")[01])

dbSelectArea("DUT")
dbSelectArea("ZEG")

DUT->(dbSetOrder(1))//DUT_FILIAL+DUT_TIPVEI
ZEG->(dbSetOrder(1))//ZEG_FILIAL+ZEG_TIPVEI+ZEG_CODCLA

conout(" [MGFTAC12] * * * * * Status da integracao * * * * *"								)
conout(" [MGFTAC12] TIPOVEICULO........." + Alltrim(::WSDADOS:TIPOVEICULO)					)
conout(" [MGFTAC12] CODCLASSIFICAO......" + cCodClass								        )
conout(" [MGFTAC12] DESCCLASSIFICAO....." + Alltrim(::WSDADOS:DESCCLASSIFICAO)				)
conout(" [MGFTAC12] ACAO................" + Alltrim(STR(::WSDADOS:ACAO))				    )
conout(" [MGFTAC12] DATA................" + dToC(dDataBase)									)
conout(" [MGFTAC12] HORA................" + TIME()											)

If Empty(Alltrim(::WSDADOS:TIPOVEICULO))
	lCont := .F.
	aRetorno := {"E","Tipo de Veiculo n�o Informado" }
EndIf

If lCont
	If ::WSDADOS:CODCLASSIFICAO == 0 .or. Empty(::WSDADOS:CODCLASSIFICAO)
		lCont := .F.
		aRetorno := {"E","Codigo da Classifica��o n�o Informado" }
	EndIf
EndIf

If lCont
	If Empty(Alltrim(::WSDADOS:DESCCLASSIFICAO))
		lCont := .F.
		aRetorno := {"E","Descri��o da Classifica��o N�o Informada" }
	EndIf
EndIf

If lCont
	If !(DUT->(dbSeek(xFilial("DUT") + Alltrim(::WSDADOS:TIPOVEICULO))))
		lCont := .F.
		aRetorno := {"E","Tipo de Veiculo n�o encontrado, Tipo: " + Alltrim(::WSDADOS:TIPOVEICULO)}
	EndIf
EndIf

If ::WSDADOS:ACAO == 1 //Inclus�o

	If lCont
		If ZEG->(dbSeek(xFilial("ZEG") + Alltrim(::WSDADOS:TIPOVEICULO) + cCodClass  ))
			lCont := .F.
			aRetorno := {"E","Classifica��o ja existe cadatrada: " + Alltrim(cCodClass)}
		EndIf
	EndIf

	If lCont
		RecLock("ZEG",.T.)
		ZEG->ZEG_FILIAL := xFilial("ZEG")
		ZEG->ZEG_TIPVEI := ::WSDADOS:TIPOVEICULO
		ZEG->ZEG_CODCLA := cCodClass
		ZEG->ZEG_DESCLA := Alltrim(::WSDADOS:DESCCLASSIFICAO)
		ZEG->ZEG_MSBLQL := "2"
		ZEG->(MsUnLock())
	Endif


ElseIf ::WSDADOS:ACAO == 2 //Altera��o

	If lCont
		If !ZEG->(dbSeek(xFilial("ZEG") + Alltrim(::WSDADOS:TIPOVEICULO) + cCodClass  ))
			lCont := .F.
			aRetorno := {"E","Classifica��o nao existe cadatrada: " + Alltrim(cCodClass)}
		EndIf
	EndIf

	If lCont
		RecLock("ZEG",.F.)
		ZEG->ZEG_DESCLA := Alltrim(::WSDADOS:DESCCLASSIFICAO)
		ZEG->(MsUnLock())
	Endif

ElseIf ::WSDADOS:ACAO == 3 //Exclus�o

	If lCont
		If !ZEG->(dbSeek(xFilial("ZEG") + Alltrim(::WSDADOS:TIPOVEICULO) + cCodClass  ))
			lCont := .F.
			aRetorno := {"E","Classifica��o nao existe cadatrada: " + Alltrim(cCodClass)}
		EndIf
	EndIf

	If lCont
		RecLock("ZEG",.F.)
		ZEG->ZEG_MSBLQL := "1"
		ZEG->(MsUnLock())
	Endif
Else
	aRetorno := {"E","ACAO, Conteudo de ser 1 = Inclusao, 2 = Alteracao, 3 = Exclusao " }
EndIf

conout(" [MGFTAC12] STATUS.............." + aRetorno[1]											)
conout(" [MGFTAC12] MSG................." + aRetorno[2]											)

::WSRETORNO := WSClassNew( "MGFTAC12_RETORNO")

::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

Return .T.