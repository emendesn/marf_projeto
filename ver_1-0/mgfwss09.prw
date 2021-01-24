#include "parmtype.ch"
#include "restful.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

user function MGFWSS09()
return

WSRESTFUL MGFCALLBACK DESCRIPTION "Servi�o REST para Callback getnet"
	WSDATA payment_type				AS STRING	// Tipo de pagamento
	WSDATA order_id					AS STRING	// N�mero de pedido
	WSDATA payment_id				AS STRING	// Identificador da transa��o na plataforma
	WSDATA amount					AS INT		// Valor da transa��o
	WSDATA status					AS STRING	// Status da transa��o
	WSDATA authorization_timestamp	AS STRING	// Data e hora de autoriza��o
	WSDATA acquirer_transaction_id	AS STRING	// Identificador da transa��o por parte do adquirente
	WSDATA customer_id				AS STRING	// Seu c�digo de identifica��o do cliente
	WSDATA subscription_id			AS STRING	// Identificador da assinatura de recorr�ncia
	WSDATA plan_id					AS STRING	// Identificador do plano utilizado na assinatura
	WSDATA charge_id				AS STRING	// Identificador da cobran�a
	WSDATA number_installments		AS INT		// N�mero de parcelas

	/*
		Status da transa��o:
		
		- PENDING = Registrada

		- CANCELED = Desfeita ou Cancelada
		
		- APPROVED = Aprovada
		
		- DENIED = Negada
		
		- AUTHORIZED = Autorizada pelo emissor
	*/

	//WSMETHOD GET TESTE DESCRIPTION "Retorna o produto informado na URL" WSSYNTAX "/BILU" //Disponibilizamos um m�todo do tipo GET
	//WSMETHOD GET TESTE DESCRIPTION "Retorna o produto informado na URL" PATH "/v2/BILU"
	WSMETHOD GET DESCRIPTION "Get no modelo antigo WSSYNTAX que n�o valida agrupamentos e nem path" WSSYNTAX "/MGFCALLBACK || /MGFCALLBACK/{id}" //N�o possibilita utilizar outro GET
END WSRESTFUL

//WSMETHOD GET MYLIST QUERYPARAM startIndex, count WSSERVICE samplenew
//WSMETHOD GET WSRECEIVE CODPRODUTO, CODGENERIC1, CODGENERIC2 WSSERVICE BILU
//WSMETHOD GET TESTE QUERYPARAM CODPRODUTO, CODGENERIC1, CODGENERIC2 WSSERVICE BILU
WSMETHOD GET WSRECEIVE payment_type, order_id, payment_id, amount, status, authorization_timestamp, acquirer_transaction_id, customer_id, subscription_id, plan_id, charge_id, number_installments WSSERVICE MGFCALLBACK
	local cJson			:= ""
	local oJson			:= nil
	local aAreaX		:= getArea()
	local aAreaXC7		:= XC7->( getArea() )

	varInfo( "payment_type.............."	, self:payment_type				)
	varInfo( "order_id.................."	, self:order_id					)
	varInfo( "payment_id................"	, self:payment_id				)
	varInfo( "amount...................."	, self:amount					)
	varInfo( "status...................."	, self:status					)
	varInfo( "authorization_timestamp..."	, self:authorization_timestamp	)
	varInfo( "acquirer_transaction_id..."	, self:acquirer_transaction_id	)
	varInfo( "customer_id..............."	, self:customer_id				)
	varInfo( "subscription_id..........."	, self:subscription_id			)
	varInfo( "plan_id..................."	, self:plan_id					)
	varInfo( "charge_id................."	, self:charge_id				)
	varInfo( "number_installments......."	, self:number_installments		)

	// define o tipo de retorno do m�todo
	::SetContentType("application/json")

	DBSelectArea("XC7")
	if recLock( "XC7", .T. )
		XC7->XC7_FILIAL	:= xFilial("XC7")
		XC7->XC7_ID		:= GETSXENUM("XC7","XC7_ID")
		XC7->XC7_PAYTYP	:= self:payment_type
		XC7->XC7_ORDEID	:= self:order_id
		XC7->XC7_PAYMID	:= self:payment_id
		XC7->XC7_AMOUNT	:= val( self:amount )
		XC7->XC7_STATUS	:= self:status
		XC7->XC7_TIME	:= self:authorization_timestamp
		XC7->XC7_ACQUIR	:= self:acquirer_transaction_id
		XC7->XC7_IDCUST	:= self:customer_id
		XC7->XC7_SUBSID	:= self:subscription_id
		XC7->XC7_PLANID	:= self:plan_id
		XC7->XC7_CHARGE	:= self:charge_id
		XC7->XC7_NUMPAR	:= self:number_installments
		XC7->XC7_DTRECE	:= dDataBase
		XC7->XC7_HRRECE	:= time()

		XC7->( msUnlock() )

		CONFIRMSX8()
	else
		setRestFault( 500 /*nCode*/, 'Ops... 500 - Internal Server Error' /*cMessage*/, .T./*lJson*/ )
		return .F.
	endif

	oJson				:= jsonObject():new()
	oJson['message']	:= "OK"
	cJson				:= oJson:toJson()

	// --> Envia o JSON Gerado para a aplica��o Client
	::SetResponse( cJson )

	restArea( aAreaXC7 )
	restArea( aAreaX )

return(.T.)