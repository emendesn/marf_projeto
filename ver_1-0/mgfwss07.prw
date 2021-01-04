#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr(13) + chr(10)

static _aErr

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Web Service E-Commerce

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  

WSSTRUCT WSS07_CUSTOMER
	WSDATA U5_CONTAT	AS STRING OPTIONAL
	WSDATA U5_DDD		AS STRING OPTIONAL
	WSDATA U5_FCOM2		AS STRING OPTIONAL
	WSDATA U5_CELULAR	AS STRING OPTIONAL
	WSDATA U5_EMAIL		AS STRING OPTIONAL
	WSDATA A1_NOME		AS STRING OPTIONAL
	WSDATA A1_NREDUZ	AS STRING OPTIONAL
	WSDATA A1_CGC		AS STRING OPTIONAL
	WSDATA A1_INSCR		AS STRING OPTIONAL
	WSDATA A1_CEP		AS STRING OPTIONAL
	WSDATA A1_END		AS STRING OPTIONAL
	WSDATA A1_COMPLEM	AS STRING OPTIONAL
	WSDATA A1_EST		AS STRING OPTIONAL
	WSDATA A1_ESTADO	AS STRING OPTIONAL
	WSDATA A1_COD_MUN	AS STRING OPTIONAL
	WSDATA A1_MUN		AS STRING OPTIONAL
	WSDATA A1_DDD		AS STRING OPTIONAL
	WSDATA A1_BAIRRO	AS STRING OPTIONAL
	WSDATA A1_DDI		AS STRING OPTIONAL
	WSDATA A1_TEL		AS STRING OPTIONAL
	WSDATA A1_PAIS		AS STRING OPTIONAL
	WSDATA A1_CNAE		AS STRING OPTIONAL
	WSDATA A1_DTNASC	AS STRING OPTIONAL
	WSDATA A1_EMAIL		AS STRING OPTIONAL
	WSDATA A1_SIMPNAC	AS STRING OPTIONAL
	WSDATA A1_ZCDECOM	AS STRING OPTIONAL	// 	Código E-Commerce Organização
	WSDATA A1_ZCDEREQ	AS STRING OPTIONAL	//	Código E-Commerce Request
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_REQ
	WSDATA UUID as string
	WSDATA ETAPA as string
	WSDATA OBS as string
	WSDATA STATUS as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_PRODUTO
	WSDATA B1_COD	as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_ADDRESS
	WSDATA Z9_ZCLIENT	AS STRING OPTIONAL
	WSDATA Z9_ZLOJA		AS STRING OPTIONAL
	WSDATA Z9_ZCGC		AS STRING OPTIONAL
	WSDATA Z9_ZRAZEND	AS STRING OPTIONAL
	WSDATA Z9_ZENDER	AS STRING OPTIONAL
	WSDATA Z9_ZBAIRRO	AS STRING OPTIONAL
	WSDATA Z9_ZCEP		AS STRING OPTIONAL
	WSDATA Z9_ZEST		AS STRING OPTIONAL
	WSDATA Z9_ZCODMUN	AS STRING OPTIONAL
	WSDATA Z9_ZMUNIC	AS STRING OPTIONAL
	WSDATA Z9_IDECOMM	AS STRING OPTIONAL
ENDWSSTRUCT

WSSTRUCT WSS07_GENERAL_STATUS
	WSDATA status		as string
	WSDATA observacao	as string
ENDWSSTRUCT

WSSTRUCT WSS07_CUSTOMER_STATUS
	WSDATA ID						AS STRING	// ID Gerado automaticamente pelo E-Commerce que sera gravado no Protheus
	WSDATA IDECOMMERCE				AS STRING	// ID Gerado automaticamente pelo E-Commerce que sera gravado no Protheus
	WSDATA IDEREQUEST				AS STRING	// ID Gerado automaticamente pelo E-Commerce que sera gravado no Protheus
	WSDATA ACTIVE					AS INTEGER	// 0=Não / 1=Sim
	WSDATA FINANCIALPENDENCY		AS STRING	// 0=Não / 1=Sim
	WSDATA LASTPURCHASEINSIXMONTHS	AS STRING	// 0=Não / 1=Sim
	WSDATA LASTPURCHASEINMONTHS		AS INTEGER	// QTDE EM MESES DA ULTIMA COMPRA
	WSDATA GENERAL_STATUS			AS WSS07_GENERAL_STATUS
ENDWSSTRUCT

WSSTRUCT WSS07_PRODUCT_LIST
	WSDATA PRODUCT_LIST		AS ARRAY OF WSS07_PRODUTO
	WSDATA GENERAL_STATUS	AS WSS07_GENERAL_STATUS
ENDWSSTRUCT

WSSTRUCT WSS07_CABECALHO_SC5
	WSDATA XC5_FILIAL	as string
	WSDATA XC5_CLIENT	as string
	WSDATA XC5_IDECOM	as string
	WSDATA XC5_VENDED	as string
	WSDATA XC5_ZIDEND	as string
	WSDATA XC5_CONDPG	as string
	WSDATA XC5_TABELA	as string
	WSDATA XC5_DTENTR	as string
	WSDATA XC5_PROMOC	as string	OPTIONAL
	WSDATA XC5_DTCARR	as string	OPTIONAL
	WSDATA XC5_NSU		as string	OPTIONAL
	WSDATA XC5_IDPROF	as string	OPTIONAL
	WSDATA XC5_USANCC	as boolean	OPTIONAL
	WSDATA XC5_PAYMID	as string	OPTIONAL
	WSDATA XC5_DSCBOL	as float	OPTIONAL
	WSDATA XC5_VALCAU	as float	OPTIONAL
	WSDATA XC5_DESCPV	as float	OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_ITEM_SC6
	WSDATA XC6_ITEM  	as string
	WSDATA XC6_PRODUT	as string
	WSDATA XC6_QTDVEN	as float
	WSDATA XC6_PRCVEN	as float
	WSDATA XC6_DSCITE	as float OPTIONAL
	WSDATA DETAIL		as array of WSS07_ITEM_DETAIL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_ITEM_DETAIL
	WSDATA discounted  	as boolean
	WSDATA amount		as float
	WSDATA quantity		as float
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_PEDIDO
	WSDATA cabecalho	as WSS07_CABECALHO_SC5
	WSDATA itens		as array of WSS07_ITEM_SC6
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS07_DELIVERYDATE_REQUEST
	WSDATA cityID		as string
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS07 DESCRIPTION "E-Commerce - Oracle" namespace "http://www.totvs.com.br/MGFWSS07"
	WSDATA productRequest		AS WSS07_REQ
	WSDATA productResponse		AS WSS07_GENERAL_STATUS
	WSDATA listProductResponse	AS WSS07_PRODUCT_LIST
	WSDATA codRequest			AS STRING
	WSDATA customerStatus		AS WSS07_CUSTOMER_STATUS
	WSDATA customerInsert		AS WSS07_CUSTOMER
	WSDATA generalResponse		AS WSS07_GENERAL_STATUS
	WSDATA address				AS WSS07_ADDRESS
	WSDATA pedido				as WSS07_PEDIDO
	WSDATA helloRequest			as string
	WSDATA helloReponse			as string
	WSDATA deliveryDateRequest	as WSS07_DELIVERYDATE_REQUEST

	WSMETHOD productIsEcom			DESCRIPTION "Verifica se o produto está vinculado no E-Commerce"
	WSMETHOD listProducts			DESCRIPTION "Lista todos os Produtos vinculados com o E-Commerce"
	WSMETHOD queryCustomer			DESCRIPTION "Consulta dados do Cliente"
	WSMETHOD insertOrUpdateCustomer	DESCRIPTION "Inclusão / Atualização cliente no Protheus"
	WSMETHOD insertAddress			DESCRIPTION "Inclusão de Endereço de Entrega no Protheus"
	WSMETHOD importSalesOrder		DESCRIPTION "Inclusão de Pedido de Venda"
	WSMETHOD deleteSalesOrder		DESCRIPTION "Exclusão de Pedido de Venda"
	WSMETHOD productIntegrated		DESCRIPTION "Resultado da integração de Produtos"
	WSMETHOD deliveryDate			DESCRIPTION "Calcula data de Entrega a partir da Data Atual"
ENDWSSERVICE

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Retorno de integração de produto

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD productIntegrated WSRECEIVE productRequest WSSEND productResponse WSSERVICE MGFWSS07
	local cUpdTbl := ""

	::productResponse	:= WSClassNew( "WSS07_GENERAL_STATUS")

	ZFU->(Dbsetorder(1))

	If ZFU->(Dbseek(alltrim(::productRequest:UUID)))

		If substr(allTrim( ::productRequest:STATUS ),1,1)  > subStr(alltrim(ZFU->ZFU_STATUS),1,1) //Fase posterior a já informada

			Reclock("ZFU",.F.)
			ZFU->ZFU_STATUS := allTrim( ::productRequest:STATUS )
			
			If allTrim( ::productRequest:ETAPA ) == '2'
				ZFU->ZFU_RETOR2 := allTrim( ::productRequest:OBS )
				ZFU->ZFU_DATA2 := DATE()
				ZFU->ZFU_HORA2 := TIME()
			Endif
			If allTrim( ::productRequest:ETAPA ) == '3'
				ZFU->ZFU_RETOR3 := allTrim( ::productRequest:OBS )
				ZFU->ZFU_DATA3 := DATE()
				ZFU->ZFU_HORA3 := TIME()
			Endif
			If allTrim( ::productRequest:ETAPA ) == '4'
				ZFU->ZFU_RETOR4 := allTrim( ::productRequest:OBS )
				ZFU->ZFU_DATA4 := DATE()
				ZFU->ZFU_HORA4 := TIME()
			Endif

			ZFU->(Msunlock())

		Endif

		U_MFCONOUT("Integração de UUID " + alltrim(::productRequest:UUID) + " atualizada para produto " + alltrim(ZFU->ZFU_PROD) + "!")
		::productResponse:status		:= "1"
		::productResponse:observacao	:= "Integração de UUID " + alltrim(::productRequest:UUID) + " atualizada para produto " + alltrim(ZFU->ZFU_PROD) + "!"

	Else

		U_MFCONOUT("Integração de UUID " + alltrim(::productRequest:UUID) + " não localizada!")
		::productResponse:status		:= "0"
		::productResponse:observacao	:= "Integração de UUID " + alltrim(::productRequest:UUID) + " não localizada!"

	Endif

return .T.


/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Apagar Pedido de Vendas

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/ 
WSMETHOD deleteSalesOrder WSRECEIVE codRequest WSSEND generalResponse WSSERVICE MGFWSS07
	local cUpdXC5	:= ""

	::generalResponse := WSClassNew( "WSS07_GENERAL_STATUS")

	cUpdXC5 := "UPDATE " + retSQLName("XC5")						+ CRLF
	cUpdXC5 += "	SET"											+ CRLF
	cUpdXC5 += " 		XC5_CANCEL = '1',"							+ CRLF
	cUpdXC5 += " 		XC5_CANCOK = '0',"							+ CRLF
	cUpdXC5 += " 		XC5_SOLCAN = '" + dToS( dDataBase ) + "'"	+ CRLF
	cUpdXC5 += " WHERE"												+ CRLF
	cUpdXC5 += " 		XC5_IDECOM	=	'" + ::codRequest	+ "'"	+ CRLF
	cUpdXC5 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

	if tcSQLExec( cUpdXC5 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())

		::generalResponse:status		:= '0'
		::generalResponse:observacao	:= "Não foi possível executar UPDATE." + CRLF + tcSqlError()
	else
		::generalResponse:status		:= '1'
		::generalResponse:observacao	:= 'Cancelamento solicitado'
	endif
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Cria pedido de vendas

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD importSalesOrder WSRECEIVE pedido WSSEND generalResponse WSSERVICE MGFWSS07
	local lOk			:= .T.
	local bError 		:= ErrorBlock( { |oError| MyError( oError ) } )
	local cTpPedEcom	:= allTrim( superGetMv( "MGF_PVECOM", , "EC" ) )
	local cTpOpeEcom	:= allTrim( superGetMv( "MGF_OPECOM", , "BJ" ) )
	local nSumQty		:= 0
	local nWeightUnt	:= 0
	local nI			:= 0
	local nJ			:= 0

	setFunName( "MGFWSS07" )

	DBSelectArea( "XC5" )
	DBSelectArea( "XC6" )

	XC5->( DBSetOrder( 1 ) )
	XC5->( DBGoTop() )

	::generalResponse := WSClassNew( "WSS07_GENERAL_STATUS")

	BEGIN SEQUENCE
		conout("[MGFWSS07] Recebida requisicao -> E-Commerce: " + ::pedido:cabecalho:XC5_IDECOM)

		if !XC5->( DBSeek( allTrim( pedido:cabecalho:XC5_FILIAL ) + left( ::pedido:cabecalho:XC5_IDECOM, tamSx3("XC5_IDECOM")[1] ) ) )
			if recLock("XC5", .T.)
				XC5->XC5_FILIAL	:= allTrim(pedido:cabecalho:XC5_FILIAL)
				XC5->XC5_CLIENT	:= pedido:cabecalho:XC5_CLIENT
				XC5->XC5_TABELA	:= pedido:cabecalho:XC5_TABELA
				XC5->XC5_CONDPG	:= pedido:cabecalho:XC5_CONDPG
				XC5->XC5_ZTIPPE	:= cTpPedEcom
				XC5->XC5_ZTIPOP	:= cTpOpeEcom
				XC5->XC5_VENDED	:= pedido:cabecalho:XC5_VENDED
				XC5->XC5_DTRECE := dDataBase

				XC5->XC5_PROMOC	:= pedido:cabecalho:XC5_PROMOC

				if !empty( pedido:cabecalho:XC5_DTCARR )
					pedido:cabecalho:XC5_DTCARR := strTran( left( allTrim( pedido:cabecalho:XC5_DTCARR ) , 10 ) , "-" )
				endif

				XC5->XC5_NSU	:= pedido:cabecalho:XC5_NSU
				XC5->XC5_IDPROF := pedido:cabecalho:XC5_IDPROF
				XC5->XC5_PAYMID := pedido:cabecalho:XC5_PAYMID
				XC5->XC5_DESCPV := pedido:cabecalho:XC5_DESCPV

				XC5->XC5_ORIGEM := U_MGFINT68( 2 , funName() )

				if !empty( pedido:cabecalho:XC5_DTENTR )

					//2018-10-24T12:41:03.210Z
					// 20181024
					pedido:cabecalho:XC5_DTENTR := strTran( left( allTrim( pedido:cabecalho:XC5_DTENTR ) , 10 ) , "-" )
					XC5->XC5_DTENTR	:= sToD( allTrim( pedido:cabecalho:XC5_DTENTR ) )
				endif

				if val( pedido:cabecalho:XC5_ZIDEND ) > 0
					XC5->XC5_ZIDEND	:=  strZero( val( pedido:cabecalho:XC5_ZIDEND ) , 9 )
				endif

				XC5->XC5_STATUS	:= "1" // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

				XC5->XC5_IDECOM	:= ::pedido:cabecalho:XC5_IDECOM
				XC5->XC5_HRRECE	:= time() // Hr Recebido

				XC5->XC5_INTEGR	:= "P" // Apos gerado pedido e retornado ao SFA muda para Integrado

				if ::pedido:cabecalho:XC5_USANCC
					XC5->XC5_USANCC := "1"
				else
					XC5->XC5_USANCC := "0"
				endif

				if pedido:cabecalho:XC5_DSCBOL > 0
					XC5->XC5_DSCBOL	:= pedido:cabecalho:XC5_DSCBOL
				endif

				if pedido:cabecalho:XC5_VALCAU > 0
					XC5->XC5_VALCAU := pedido:cabecalho:XC5_VALCAU
				EndIf

				XC5->( msUnlock() )

				for nI := 1 to len( pedido:itens )

					// FOR para somar a quantidade total do item no Pedido
					nSumQty := 0
					for nJ := 1 to len( pedido:itens[ nI ]:DETAIL )
						nSumQty += pedido:itens[ nI ]:DETAIL[ nJ ]:quantity
					next

					nWeightUnt := 0
					nWeightUnt := pedido:itens[ nI ]:XC6_QTDVEN / nSumQty

					for nJ := 1 to len( pedido:itens[ nI ]:DETAIL )
						varInfo( "discounted..."	, pedido:itens[ nI ]:DETAIL[ nJ ]:discounted	)
						varInfo( "amount......."	, pedido:itens[ nI ]:DETAIL[ nJ ]:amount		)
						varInfo( "quantity....."	, pedido:itens[ nI ]:DETAIL[ nJ ]:quantity		)

						if pedido:itens[ nI ]:DETAIL[ nJ ]:discounted .AND. pedido:itens[ nI ]:DETAIL[ nJ ]:amount == 0
							// Item com bonificação

							if recLock("XC6", .T.)
								XC6->XC6_FILIAL	:= allTrim(pedido:cabecalho:XC5_FILIAL)
								XC6->XC6_ITEM	:= pedido:itens[ nI ]:XC6_ITEM
								XC6->XC6_PRODUT	:= alltrim( pedido:itens[ nI ]:XC6_PRODUT )
								XC6->XC6_QTDVEN	:= pedido:itens[ nI ]:DETAIL[ nJ ]:quantity * nWeightUnt
								XC6->XC6_PRCVEN	:= 0
								XC6->XC6_OPER	:= cTpOpeEcom
								XC6->XC6_IDECOM	:= ::pedido:cabecalho:XC5_IDECOM
								XC6->XC6_PRCLIS	:= 0
								XC6->XC6_DSCITE	:= 0

								XC6->( msUnlock() )
							else
								::generalResponse:status		:= '0'
								::generalResponse:observacao	:= 'Erro gravacao dos itens  (Tabela XC6)'

								lOk := .F.
								exit
							endif
						else
							// Item sem bonificação
							if recLock("XC6", .T.)
								XC6->XC6_FILIAL	:= allTrim(pedido:cabecalho:XC5_FILIAL)
								XC6->XC6_ITEM	:= pedido:itens[ nI ]:XC6_ITEM
								XC6->XC6_PRODUT	:= alltrim( pedido:itens[ nI ]:XC6_PRODUT )
								XC6->XC6_QTDVEN	:= pedido:itens[ nI ]:DETAIL[ nJ ]:quantity * nWeightUnt
								XC6->XC6_PRCVEN	:= pedido:itens[ nI ]:DETAIL[ nJ ]:amount
								XC6->XC6_OPER	:= cTpOpeEcom
								XC6->XC6_IDECOM	:= ::pedido:cabecalho:XC5_IDECOM
								XC6->XC6_PRCLIS	:= 0
		
								if pedido:itens[ nI ]:XC6_DSCITE > 0
									XC6->XC6_DSCITE	:= pedido:itens[ nI ]:XC6_DSCITE
								endif
		
								XC6->( msUnlock() )
							else
								::generalResponse:status		:= '0'
								::generalResponse:observacao	:= 'Erro gravacao dos itens  (Tabela XC6)'
		
								lOk := .F.
								exit
							endif
						endif
					next
				next

				if lOk
					::generalResponse:status		:= '1'
					::generalResponse:observacao	:= 'Pedido recebido'
				endif
			else
				::generalResponse:status		:= '0'
				::generalResponse:observacao	:= 'Erro gravacao do cabecalho (Tabela XC5)'
			endif
		else
			::generalResponse:status		:= '0'
			::generalResponse:observacao	:= 'Erro gravacao - ID ' + allTrim( pedido:cabecalho:XC5_FILIAL ) + left( ::pedido:cabecalho:XC5_IDECOM, tamSx3("XC5_IDECOM")[1] ) + ' ja existente na tabela intermediaria do Protheus'
		endif

	RECOVER
		conout('[MGFWSS07] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::generalResponse:status		:= _aErr[1]
		::generalResponse:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Insere endereco de entrega no cliente

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  

WSMETHOD insertAddress WSRECEIVE address WSSEND generalResponse WSSERVICE MGFWSS07
	local aArea		:= getArea()
	local aAreaSA1	:= SA1->(getArea())
	local aCodSA1	:= {}
	local aCampos	:= {}
	local oModel	:= nil
	local oAux		:= nil
	local oStruct	:= nil
	local nI		:= 0
	local nPos		:= 0
	local lRet		:= .T.
	local aAux		:= {}
	local lAux		:= .T.
	local aErro		:= {}
	local cQryCC2	:= ""

	local cCodMuni	:= ""
	local cNomeMun	:= ""

	::generalResponse	:= WSClassNew( "WSS07_GENERAL_STATUS")

	conout("[E-COM] [MGFWSS07] [insertAddress] - INICIO")

	DBSelectArea("SA1")
	SA1->( DBGoTop() )
	if SA1->( DBSeek( xFilial("SA1") + ::address:Z9_ZCLIENT + ::address:Z9_ZLOJA ) )

	
			cQryCC2 := "SELECT CC2_CODMUN, CC2_MUN, CC2_EST"											+ CRLF
			cQryCC2 += " FROM " + retSQLName("CC2") + " CC2"											+ CRLF
			cQryCC2 += " WHERE"																			+ CRLF
			cQryCC2 += " 		CC2.CC2_MUN		LIKE	'%" + allTrim( ::address:Z9_ZMUNIC )	+ "%'"	+ CRLF
			cQryCC2 += " 	AND	CC2.CC2_EST		=		'" + ::address:Z9_ZEST	+ "'"					+ CRLF
			cQryCC2 += " 	AND	CC2.CC2_FILIAL	=		'" + xFilial("CC2")		+ "'"					+ CRLF
			cQryCC2 += " 	AND	CC2.D_E_L_E_T_	<>		'*'"											+ CRLF

			TcQuery cQryCC2 New Alias "QRYCC2"

			if !QRYCC2->(EOF())
				cCodMuni := QRYCC2->CC2_CODMUN
				cNomeMun := QRYCC2->CC2_MUN
			else
				cCodMuni := ""
				cNomeMun := ::address:Z9_ZMUNIC
			endif

			QRYCC2->(DBCloseArea())

			aCampos := {}
			aadd( aCampos, { 'Z9_ZCGC'		, ::address:Z9_ZCGC		} )
			aadd( aCampos, { 'Z9_ZRAZEND'	, ::address:Z9_ZRAZEND	} )
			aadd( aCampos, { 'Z9_ZENDER'	, ::address:Z9_ZENDER	} )
			aadd( aCampos, { 'Z9_ZBAIRRO'	, ::address:Z9_ZBAIRRO	} )
			aadd( aCampos, { 'Z9_ZCEP'		, ::address:Z9_ZCEP		} )
			aadd( aCampos, { 'Z9_ZEST'		, ::address:Z9_ZEST		} )
			aadd( aCampos, { 'Z9_ZCODMUN'	, cCodMuni				} )
			aadd( aCampos, { 'Z9_ZMUNIC'	, cNomeMun				} )
			aadd( aCampos, { 'Z9_IDECOMM'	, ::address:Z9_IDECOMM	} )
			aadd( aCampos, { 'Z9_ZROTEIR'	, "S"					} )
			aadd( aCampos, { 'Z9_ALROAD'	, "S"					} )
			aadd( aCampos, { 'Z9_XSFA'		, "S"					} )
			aadd( aCampos, { 'Z9_MSBLQL'	, "1"					} )
			aadd( aCampos, { 'Z9_XSFAX'		, "S"					} )

			varInfo( "[E-COM] [MGFWSS07] [insertAddress] - aCampos" , aCampos )

			DBSelectArea( "SZ9" )
			DBSetOrder( 1 )

			oModel := FWLoadModel( 'MGFFAT01' )
			oModel:SetOperation( 3 )

			// Antes de atribuirmos os valores dos campos temos que ativar o modelo
			oModel:Activate()

			// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
			oAux    := oModel:GetModel( 'FAT01MASTER' )

			// Obtemos a estrutura de dados do cabeçalho
			oStruct := oAux:GetStruct()
			aAux	:= oStruct:GetFields()

			For nI := 1 To Len( aCampos )
				// Verifica se os campos passados existem na estrutura do cabeçalho
				If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCampos[nI][1] ) } ) ) > 0

					// È feita a atribuicao do dado aos campo do Model do cabeçalho
					If !( lAux := oModel:SetValue( "FAT01MASTER", aCampos[nI][1], aCampos[nI][2] ) )
						// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
						// o método SetValue retorna .F.
						lRet    := .F.
						Exit
					EndIf
				EndIf
			Next

			If lRet
				If ( lRet := oModel:VldData() )
					lRet := oModel:CommitData()
				EndIf
			EndIf

			If !lRet

				aErro   := oModel:GetErrorMessage()
	
				::generalResponse:status := "0"
				::generalResponse:observacao := ""
				::generalResponse:observacao += ( "Id do formulário de origem:" + ' [' + allToChar( aErro[1]  ) + ']' )
				::generalResponse:observacao += ( "Id do campo de origem:     " + ' [' + allToChar( aErro[2]  ) + ']' )
				::generalResponse:observacao += ( "Id do formulário de erro:  " + ' [' + allToChar( aErro[3]  ) + ']' )
				::generalResponse:observacao += ( "Id do campo de erro:       " + ' [' + allToChar( aErro[4]  ) + ']' )
				::generalResponse:observacao += ( "Id do erro:                " + ' [' + allToChar( aErro[5]  ) + ']' )
				::generalResponse:observacao += ( "Mensagem do erro:          " + ' [' + allToChar( aErro[6]  ) + ']' )
				::generalResponse:observacao += ( "Mensagem da solução:       " + ' [' + allToChar( aErro[7]  ) + ']' )
				::generalResponse:observacao += ( "Valor atribuido:           " + ' [' + allToChar( aErro[8]  ) + ']' )
				::generalResponse:observacao += ( "Valor anterior:            " + ' [' + allToChar( aErro[9]  ) + ']' )

				conout("[E-COM] [MGFWSS07] [insertAddress] - Id do formulário de origem:" + " [" + allToChar( aErro[1]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Id do campo de origem:     " + " [" + allToChar( aErro[2]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Id do formulário de erro:  " + " [" + allToChar( aErro[3]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Id do campo de erro:       " + " [" + allToChar( aErro[4]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Id do erro:                " + " [" + allToChar( aErro[5]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Mensagem do erro:          " + " [" + allToChar( aErro[6]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Mensagem da solução:       " + " [" + allToChar( aErro[7]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Valor atribuido:           " + " [" + allToChar( aErro[8]  ) + "]")
				conout("[E-COM] [MGFWSS07] [insertAddress] - Valor anterior:            " + " [" + allToChar( aErro[9]  ) + "]")
			else
				::generalResponse:status		:= "1"
				::generalResponse:observacao	:= "Endereço cadastrado com sucesso."

				conout("[E-COM] [MGFWSS07] [insertAddress] - Endereço cadastrado com sucesso.")
			endif

			oModel:DeActivate()
		else
			::generalResponse:status		:= "0"
			::generalResponse:observacao	:= "Codigo / Loja não encontrado na base."
		endif

	conout("[E-COM] [MGFWSS07] [insertAddress] - FIM")

	restArea(aAreaSA1)
	restArea(aArea)
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Insere e atualiza cliente

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  

WSMETHOD insertOrUpdateCustomer WSRECEIVE customerInsert WSSEND generalResponse WSSERVICE MGFWSS07
	local aErro				:= {}
	local cErro				:= ""
	local aSA1				:= {}
	local nI				:= 0
	local aMaxSA1			:= {}
	local cA1Cod			:= ""
	local cA1Loja			:= ""
	local nOpcX				:= 0
	local aSU5				:= {}
	local aCodSA1			:= {}
	local cUpdSA1			:= ""

	local aArea				:= getArea()
	local aAreaSA1			:= SA1->( getArea() )
	local aAreaSU5			:= SU5->( getArea() )
	local aAreaAC8			:= AC8->( getArea() )

	local lExecAutoX		:= .T.
	Local cListaPdr 		:= alltrim(SuperGetMv( "MGF_LISTEC", , "ECP" ))
	Local cEstVend			:= alltrim(SuperGetMv( "MGF_ESTVEN", , "RS;SC" ))//Estado Vendedor SUL
	Local cVendSul			:= alltrim(SuperGetMv( "MGF_VENSUL", , "EC0001" ))//Vendedor SUL
	Local cVendFoo			:= alltrim(SuperGetMv( "MGF_VENFOO", , "EC0002" ))//Vendedor FOOD

	private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	SetFunName("MGFWSS07")

	Conout("[MGFWSS07] insertOrUpdateCustomer")
	aCodSA1 := chkSA1( ::customerInsert:A1_CGC )

	if len( aCodSA1 ) > 0
		nOpcX := 4
	elseif len( aCodSA1 ) == 0
		nOpcX := 3
	endif

	::generalResponse	:= WSClassNew( "WSS07_GENERAL_STATUS")

	if nOpcX == 4
	Conout("[MGFWSS07] nOpcX = 4")
		if aCodSA1[6] == "2"
			Conout("[MGFWSS07] aCodSA1[6] == 2 ")
			lExecAutoX	:= .F. // Indica se continua a rotina apos ExecAuto

			// Atualiza Cliente com Lista de Preço Padrão (Somente se estiver em branco)
			cUpdSA1 := ""
			cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
			cUpdSA1 += "	SET"														+ CRLF
			cUpdSA1 += " 		A1_ZPRCECO	= '" + cListaPdr + "'"						+ CRLF
			cUpdSA1 += " WHERE"															+ CRLF
			cUpdSA1 += " 		A1_ZPRCECO	=	' '"									+ CRLF
			cUpdSA1 += " 	AND	A1_LOJA		=	'" + aCodSA1[2]		+ "'"				+ CRLF
			cUpdSA1 += " 	AND	A1_COD		=	'" + aCodSA1[1]		+ "'"				+ CRLF
			cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"				+ CRLF
			cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

			if tcSQLExec( cUpdSA1 ) < 0
				conout("[MGFWSS07] [ECOM] [insertOrUpdateCustomer] Não foi possível executar UPDATE." + CRLF + tcSqlError())
			Else
				tcSQLExec( "commit" )
			endif

			cUpdSA1 := ""
			// Se estiver desbloqueado apenas atualiza o ID do E-Commerce
			cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
			cUpdSA1 += "	SET"														+ CRLF
			cUpdSA1 += " 		A1_XINTECO	= '0',"										+ CRLF
			cUpdSA1 += " 		A1_XENVECO	= '1',"										+ CRLF
			cUpdSA1 += " 		A1_ZCDECOM	= '" + ::customerInsert:A1_ZCDECOM + "',"	+ CRLF 
			cUpdSA1 += " 		A1_ZCDEREQ	= '" + ::customerInsert:A1_ZCDEREQ + "'"	+ CRLF
			cUpdSA1 += " WHERE"															+ CRLF
			cUpdSA1 += " 		A1_LOJA		=	'" + aCodSA1[2]		+ "'"				+ CRLF
			cUpdSA1 += " 	AND	A1_COD		=	'" + aCodSA1[1]		+ "'"				+ CRLF
			cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"				+ CRLF
			cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

			if tcSQLExec( cUpdSA1 ) < 0
				conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				::generalResponse:status		:= "0"
				::generalResponse:observacao	:= "Erro na atualização do cliente: " + CRLF + tcSqlError()
			else
				tcSQLExec( "commit" )

				staticCall( MGFWSC25, runInteg25, ::customerInsert:A1_CGC )
				Conout("[MGFWSS07] Cliente: "+aCodSA1[1]+" loja: "+aCodSA1[2])
				
				staticCall( MGFWSC31, runInteg31, aCodSA1[1] , aCodSA1[2], ::customerInsert:A1_CGC )

				::generalResponse:status		:= "1"
				::generalResponse:observacao	:= "Cliente alterado com sucesso"
			endif
		else
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
			If SA1->(DbSeek(xFilial("SA1") + aCodSA1[1] + aCodSA1[2] ))
				If !(U_MGF38_PED('SA1','A1'))//Verifica se Existe alçada pendente de aprovação
					//Necessario Alterar o A1_MSBLQL == '1' para '2' para que o execauto possa ser executado
					cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
					cUpdSA1 += "	SET"														+ CRLF
					cUpdSA1 += " 		A1_MSBLQL	= '2' "										+ CRLF
					cUpdSA1 += " WHERE"															+ CRLF
					cUpdSA1 += " 		A1_LOJA		=	'" + aCodSA1[2]		+ "'"				+ CRLF
					cUpdSA1 += " 	AND	A1_COD		=	'" + aCodSA1[1]		+ "'"				+ CRLF
					cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"				+ CRLF
					cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

					If tcSQLExec( cUpdSA1 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					Else
						tcSQLExec( "commit" )
						conout("UPDATE. realizado com Sucesso - Alterado o A1_MSBLQL para '2' devido a update")
					EndIf
				Else
					lExecAutoX := .F.

					// Se estiver desbloqueado apenas atualiza o ID do E-Commerce
					cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
					cUpdSA1 += "	SET"														+ CRLF
					cUpdSA1 += " 		A1_XINTECO	= '1',"										+ CRLF
					cUpdSA1 += " 		A1_XENVECO	= '1',"										+ CRLF
					cUpdSA1 += " 		A1_ZCDECOM	= '" + ::customerInsert:A1_ZCDECOM + "',"	+ CRLF
					cUpdSA1 += " 		A1_ZCDEREQ	= '" + ::customerInsert:A1_ZCDEREQ + "'"	+ CRLF					
					cUpdSA1 += " WHERE"															+ CRLF
					cUpdSA1 += " 		A1_LOJA		=	'" + aCodSA1[2]		+ "'"				+ CRLF
					cUpdSA1 += " 	AND	A1_COD		=	'" + aCodSA1[1]		+ "'"				+ CRLF
					cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"				+ CRLF
					cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

					if tcSQLExec( cUpdSA1 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						::generalResponse:status		:= "0"
						::generalResponse:observacao	:= "Erro na atualização do cliente: " + CRLF + tcSqlError()
					else
						tcSQLExec( "commit" )
						::generalResponse:status		:= "1"
						::generalResponse:observacao	:= "Cliente alterado com sucesso"
					endif

				EndIf
			EndIf
		EndIf
	EndIf

	if lExecAutoX
		if nOpcX == 4
			aadd( aSA1, { "A1_FILIAL"	, xFilial("SA1")				, nil } )
			aadd( aSA1, { "A1_COD"		, aCodSA1[1]					, nil } )
			aadd( aSA1, { "A1_LOJA"		, aCodSA1[2]					, nil } )
		endif

		aadd( aSA1, { "A1_ZCDECOM"	, ::customerInsert:A1_ZCDECOM	, nil } )
		aadd( aSA1, { "A1_ZCDEREQ"	, ::customerInsert:A1_ZCDEREQ	, nil } )
		
		aadd( aSA1, { "A1_NOME"		, ::customerInsert:A1_NOME		, nil } )
		aadd( aSA1, { "A1_NREDUZ"	, left( allTrim( ::customerInsert:A1_NREDUZ ) , tamSX3("A1_NREDUZ")[1] )	, nil } )
		aadd( aSA1, { "A1_CGC"		, ::customerInsert:A1_CGC		, nil } )

		if !empty( ::customerInsert:A1_INSCR )
			aadd( aSA1, { "A1_INSCR"	, ::customerInsert:A1_INSCR		, nil } )
		endif

		aadd( aSA1, { "A1_CEP"		, ::customerInsert:A1_CEP		, nil } )
		aadd( aSA1, { "A1_END"		, ::customerInsert:A1_END		, nil } )
		aadd( aSA1, { "A1_COMPLEM"	, ::customerInsert:A1_COMPLEM	, nil } )
		aadd( aSA1, { "A1_EST"		, ::customerInsert:A1_EST		, nil } )

		If nOpcX == 3
			If !Empty(::customerInsert:A1_EST)
				If ::customerInsert:A1_EST $ cEstVend
					aadd( aSA1, { "A1_VEND"	, cVendSul						, nil } )
				Else
					aadd( aSA1, { "A1_VEND"	, cVendFoo						, nil } )
				EndIf
			Else
				aadd( aSA1, { "A1_VEND"	, cVendFoo						, nil } )
			EndIf
			aadd( aSA1, { "A1_TIPO"		, "R"							, nil } )
			aadd( aSA1, { "A1_PESSOA"	, "J"							, nil } )

		EndIf

		aadd( aSA1, { "A1_COD_MUN"	, ::customerInsert:A1_COD_MUN	, nil } )
		aadd( aSA1, { "A1_DDD"		, ::customerInsert:A1_DDD		, nil } )
		aadd( aSA1, { "A1_BAIRRO"	, ::customerInsert:A1_BAIRRO	, nil } )
		aadd( aSA1, { "A1_DDI"		, ::customerInsert:A1_DDI		, nil } )
		aadd( aSA1, { "A1_TEL"		, ::customerInsert:A1_TEL		, nil } )
		aadd( aSA1, { "A1_PAIS"		, ::customerInsert:A1_PAIS		, nil } )
		aadd( aSA1, { "A1_EMAIL"	, ::customerInsert:A1_EMAIL		, nil } )

		aadd( aSA1, { "A1_XENVECO"	, "1"		, nil } )

		if nOpcX == 3
			aadd( aSA1, { "A1_ZECOMME"	, "1"		, nil } )
			aadd( aSA1, { "A1_ZPRCECO"	, cListaPdr	, nil } )
			aadd( aSA1, { "A1_NATUREZ"	, "10101"	, nil } )
		endif

		if !empty( ::customerInsert:A1_CNAE )
			aadd( aSA1, { "A1_CNAE"		, Alltrim(TRANSFORM(Alltrim(::customerInsert:A1_CNAE),  "@R 9999-9/99")), nil } )
		endif

		if !empty( ::customerInsert:A1_DTNASC )
			aadd( aSA1, { "A1_DTNASC"	, sToD( ::customerInsert:A1_DTNASC )	, nil } )
		endif

		if !empty( ::customerInsert:A1_SIMPNAC )
			aadd( aSA1, { "A1_SIMPNAC"	, ::customerInsert:A1_SIMPNAC	, nil } )
		endif

		MSExecAuto( { |x,y| MATA030( x, y ) }, aSA1, nOpcX) // SA1 Cliente

		if lMsErroAuto
			::generalResponse:status		:= "0"
			aErro := GetAutoGRLog() // Retorna erro em array
			cErro := ""

			for nI := 1 to len(aErro)
				cErro += aErro[ nI ] + CRLF
			next nI

			::generalResponse:observacao := cErro
		else
			::generalResponse:status		:= "1"
			if nOpcX == 3
				::generalResponse:observacao	:= "Cliente incluído com sucesso"
			elseif nOpcX == 4
				::generalResponse:observacao	:= "Cliente alterado com sucesso"
			endif

			if nOpcX == 3
				aSU5 := {}

				aadd( aSU5, {"U5_FILIAL"	, xFilial("SU5")				, nil } )
				aadd( aSU5, {"U5_CONTAT"	, ::customerInsert:U5_CONTAT	, nil } )
				aadd( aSU5, {"U5_LOJA"		, SA1->A1_LOJA					, nil } )
				aadd( aSU5, {"U5_DDD"		, ::customerInsert:U5_DDD		, nil } )
				aadd( aSU5, {"U5_FCOM2"		, ::customerInsert:U5_FCOM2		, nil } )
				aadd( aSU5, {"U5_CELULAR"	, ::customerInsert:U5_CELULAR	, nil } )
				aadd( aSU5, {"U5_EMAIL"		, ::customerInsert:U5_EMAIL		, nil } )

				msExecAuto( { |x,y| TMKA070(x,y) }, aSU5, nOpcX)

				if lMsErroAuto
					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len(aErro)
						cErro += aErro[ nI ] + CRLF
					next nI

					::generalResponse:observacao += CRLF + "Problema na inclusão dos Dados de Contato:" + CRLF + cErro
				else
					DBSelectArea("AC8")

					recLock("AC8", .T.)
						AC8->AC8_FILIAL := xFilial("AC8")
						AC8->AC8_FILENT := xFilial("AC8")
						AC8->AC8_ENTIDA := "SA1"
						AC8->AC8_CODENT := SA1->( A1_COD + A1_LOJA )
						AC8->AC8_CODCON := SU5->U5_CODCONT
					AC8->( msUnlock() )

					::generalResponse:observacao += CRLF + "Dados de Contato adiconados"
				endif
			endif
		endif
	endif

	restArea(aAreaAC8)
	restArea(aAreaSU5)
	restArea(aAreaSA1)
	restArea(aArea)
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Consulta cliente

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD queryCustomer WSRECEIVE codRequest WSSEND customerStatus WSSERVICE MGFWSS07

	local cQWSS07		:= ""

	::customerStatus 				:= nil
	::customerStatus 				:= WSClassNew( "WSS07_CUSTOMER_STATUS")
	::customerStatus:GENERAL_STATUS	:= WSClassNew( "WSS07_GENERAL_STATUS")

		cQWSS07 := "SELECT DISTINCT SA1.A1_CGC, SA1.A1_ULTCOM, SA1.A1_ZCDECOM, SA1.A1_ZCDEREQ, SA1.A1_MSBLQL, SA1.A1_ZINATIV, SA1.A1_DTCAD"		+ CRLF
		cQWSS07 += " FROM "			+ retSQLName("SA1") + " SA1"					+ CRLF
		cQWSS07 += " WHERE"															+ CRLF
		cQWSS07 += " 		SA1.A1_CGC		=	'" + ::codRequest	+ "'"			+ CRLF
		cQWSS07 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")	+ "'"			+ CRLF
		cQWSS07 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF

		TcQuery cQWSS07 New Alias "QWSS07"

		if !QWSS07->(EOF())
			::customerStatus:GENERAL_STATUS:status		:= "1"
			::customerStatus:GENERAL_STATUS:observacao	:= "Consulta realizada com sucesso"

			::customerStatus:ID				:= QWSS07->A1_CGC
			::customerStatus:IDECOMMERCE	:= QWSS07->A1_ZCDECOM
			::customerStatus:IDEREQUEST		:= QWSS07->A1_ZCDEREQ

			if  xTitAtras( allTrim( QWSS07->A1_CGC ) )//QWSS07->TITULOS_ATRASADOS > 0
				::customerStatus:FINANCIALPENDENCY	:= "1"
			else
				::customerStatus:FINANCIALPENDENCY	:= "0"
			endif

			if QWSS07->A1_MSBLQL == "2"//Não Bloqueado
				if QWSS07->A1_ZINATIV == "1"
					::customerStatus:ACTIVE := 0
				elseif QWSS07->A1_ZINATIV == "0" .or. empty(QWSS07->A1_ZINATIV)
					::customerStatus:ACTIVE := 1
				endif
			elseif QWSS07->A1_MSBLQL == "1"//Bloqueado
				if QWSS07->A1_ZINATIV == "1"//Inatividade por falata de compra 6 meses
					::customerStatus:ACTIVE := 1
				Else
					::customerStatus:ACTIVE := 0
				EndIf
			endif

			
				If QWSS07->A1_MSBLQL == "1"//Bloqueado
					IF QWSS07->A1_ZINATIV <> "1"
						::customerStatus:LASTPURCHASEINSIXMONTHS	:= "1"
						::customerStatus:LASTPURCHASEINMONTHS		:=  1
					Else
						::customerStatus:LASTPURCHASEINSIXMONTHS	:= "0"
						::customerStatus:LASTPURCHASEINMONTHS		:= 99 // dDiffMonth ( Diferenca em meses entre duas datas )
					EndIf
				EndIf

				if QWSS07->A1_MSBLQL == "2"//Não Bloqueado
					if !empty( QWSS07->A1_ULTCOM )
						if dateDiffMonth( sToD( QWSS07->A1_ULTCOM ) , dDataBase ) <= 6
							::customerStatus:LASTPURCHASEINSIXMONTHS	:= "1"
							::customerStatus:LASTPURCHASEINMONTHS		:= dateDiffMonth( sToD( QWSS07->A1_ULTCOM ) , dDataBase )
						else
							::customerStatus:LASTPURCHASEINSIXMONTHS	:= "0"
							::customerStatus:LASTPURCHASEINMONTHS		:= dateDiffMonth( sToD( QWSS07->A1_ULTCOM ) , dDataBase )
						endif
					else
						if dateDiffMonth( sToD( QWSS07->A1_DTCAD ) , dDataBase ) <= 6
							::customerStatus:LASTPURCHASEINSIXMONTHS	:= "1"
							::customerStatus:LASTPURCHASEINMONTHS		:=  1
						Else
							::customerStatus:LASTPURCHASEINSIXMONTHS	:= "0"
							::customerStatus:LASTPURCHASEINMONTHS		:= dateDiffMonth( sToD( QWSS07->A1_DTCAD ) , dDataBase )
						EndIf
					EndIf
				Endif


		else
			::customerStatus:GENERAL_STATUS:status		:= "0"
			::customerStatus:GENERAL_STATUS:observacao	:= "Consulta não obteve resultados"

			::customerStatus:ID							:= ""
			::customerStatus:IDECOMMERCE				:= ""
			::customerStatus:IDEREQUEST					:= ""
			::customerStatus:ACTIVE						:= -1
			::customerStatus:FINANCIALPENDENCY			:= ""
			::customerStatus:LASTPURCHASEINSIXMONTHS	:= ""
			::customerStatus:LASTPURCHASEINMONTHS		:= 0
		endif
			
		QWSS07->(DBCloseArea())

	if valType(_aErr) == 'A'
		::customerStatus:GENERAL_STATUS:status		:= _aErr[1]
		::customerStatus:GENERAL_STATUS:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Consulta títulos atrasados

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
Static Function xTitAtras( cCgc )
	local lRet			:= .F.
	local cQrySE1		:= ""
	local aAreaX		:= getArea()
	local aAreaSA1		:= SA1->( getArea() )
	local aAreaSE1		:= SE1->( getArea() )
	local cEcoFilial	:= allTrim( superGetMv( "MFG_ECOFIL" , , "010041;010050" ) )
	local aEcoFilial	:= {}
	local nI			:= 0
	local nTamFilSE1	:= tamSX3("E1_FILIAL")[1]
	local nTamA1CGC		:= tamSX3("A1_CGC")[1]

	aEcoFilial := strTokArr( cEcoFilial , ";" )

	DBSelectArea("SA1")
	DBSelectArea("SE1")

	SA1->( DBSetOrder( 3 ) ) // SA1	3	A1_FILIAL+A1_CGC
	SE1->( DBSetOrder( 2 ) ) // SE1	2	E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	if SA1->( DBSeek( xFilial("SA1") + padR( cCgc , nTamA1CGC ) ) )
		for nI := 1 to len( aEcoFilial )
			if !lRet
				SE1->( DBGoTop() )
				if SE1->( DBSeek( padR( aEcoFilial[ nI ], nTamFilSE1 ) + SA1->A1_COD + SA1->A1_LOJA ) )
					cSE1Atu := ""
					cSE1Atu := SE1->( E1_FILIAL + E1_CLIENTE + E1_LOJA )

					while cSE1Atu == SE1->( E1_FILIAL + E1_CLIENTE + E1_LOJA )
						if SE1->E1_SALDO > 0 .and. SE1->E1_VENCREA < dDataBase .and. SE1->E1_TIPO $ "NF |JR |DP "
							lRet := .T.
							exit
						endif
						SE1->( DBSkip() )
					enddo
				endif
			endif
		next
	endif

	restArea( aAreaSE1 )
	restArea( aAreaSA1 )
	restArea( aAreaX )
return lRet

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Lista produtos do E-Commerce

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD listProducts WSRECEIVE productRequest WSSEND listProductResponse WSSERVICE MGFWSS07
	local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	local cQrySB1	:= ""

	::listProductResponse 					:= WSClassNew( "WSS07_PRODUCT_LIST")
	::listProductResponse:PRODUCT_LIST 		:= {}
	::listProductResponse:GENERAL_STATUS	:= WSClassNew( "WSS07_GENERAL_STATUS")

	BEGIN SEQUENCE
		cQrySB1 := "SELECT DISTINCT B1_COD"											+ CRLF
		cQrySB1 += " FROM "			+ retSQLName("SB1") + " SB1"					+ CRLF
		cQrySB1 += " WHERE"															+ CRLF
		cQrySB1 += " 		SB1.B1_MSBLQL	=	'2'"								+ CRLF
		cQrySB1 += " 	AND	SB1.B1_XENVECO	=	'1'"								+ CRLF
		cQrySB1 += " 	AND	SB1.B1_XINTECO	=	'1'"								+ CRLF
		cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1")			+ "'"	+ CRLF
		cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"								+ CRLF

		TcQuery cQrySB1 New Alias "QRYSB1"

		if !QRYSB1->(EOF())

			::listProductResponse:GENERAL_STATUS:status		:= "1"
			::listProductResponse:GENERAL_STATUS:observacao	:= "Consulta realizada com sucesso"

			while ( QRYSB1->( !EOF() ) )
				::productResponse := nil
				::productResponse := WSClassNew( "WSS07_PRODUTO")

				::productResponse:B1_COD := QRYSB1->B1_COD

				aadd( ::listProductResponse:PRODUCT_LIST, ::productResponse )
				QRYSB1->(dbSkip())
			enddo
		else
			::listProductResponse:GENERAL_STATUS:status		:= "0"
			::listProductResponse:GENERAL_STATUS:observacao	:= "Consulta não obteve resultados"
		endif

		QRYSB1->(DBCloseArea())
		RECOVER
		conout('[MGFWSS07] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::listProductResponse:GENERAL_STATUS:status		:= _aErr[1]
		::listProductResponse:GENERAL_STATUS:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Consulta se produto é integrado ao E-Commerce

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD productIsEcom WSRECEIVE productRequest WSSEND productResponse WSSERVICE MGFWSS07
	local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	local cQrySB1	:= ""

	::productResponse := WSClassNew( "WSS07_GENERAL_STATUS")

	BEGIN SEQUENCE
		cQrySB1 := "SELECT B1_COD"													+ CRLF
		cQrySB1 += " FROM "			+ retSQLName("SB1") + " SB1"					+ CRLF
		cQrySB1 += " INNER JOIN "	+ retSQLName("DA1") + " DA1"					+ CRLF
		cQrySB1 += " ON"															+ CRLF
		cQrySB1 += " 		DA1.DA1_CODPRO	=	SB1.B1_COD"							+ CRLF
		cQrySB1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'"			+ CRLF
		cQrySB1 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
		cQrySB1 += " INNER JOIN "	+ retSQLName("DA0") + " DA0"					+ CRLF
		cQrySB1 += " ON"															+ CRLF
		cQrySB1 += " 		DA0.DA0_XENVEC	=	'1'"								+ CRLF
		cQrySB1 += " 	AND	DA0.DA0_ATIVO	=	'1'"								+ CRLF //1=Sim;2=Nao
		cQrySB1 += " 	AND	DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
		cQrySB1 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'"			+ CRLF
		cQrySB1 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"								+ CRLF
		cQrySB1 += " WHERE"															+ CRLF
		cQrySB1 += " 		SB1.B1_MSBLQL	=	'2'"								+ CRLF
		cQrySB1 += " 	AND	SB1.B1_COD		=	'" + productRequest:produto	+ "'"	+ CRLF
		cQrySB1 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1")			+ "'"	+ CRLF
		cQrySB1 += " 	AND	SB1.D_E_L_E_T_	<>	'*'"								+ CRLF

		TcQuery cQrySB1 New Alias "QRYSB1"

		if !QRYSB1->(EOF())
			::productResponse:status		:= "1"
			::productResponse:observacao	:= "Produto Ativo e pertencente ao E-Commerce"
		else
			::productResponse:status		:= "0"
			::productResponse:observacao	:= "Produto e/ou Tabela de Preço Inativado(a) ou Produto não vinculado a uma Tabela de Preço do E-Commerce"
		endif

		QRYSB1->(DBCloseArea())
		RECOVER
		conout('[MGFWSS07] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::productResponse:status		:= _aErr[1]
		::productResponse:observacao	:= _aErr[2]
	endif

	delClassINTF()
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Tratamento de erro

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
static function MyError(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	nQtd := iif(nQtd > 4,4,nQtd) //Retorna as 4 linhas

	for ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( "[MGFWSS07] Deu Erro " + oError:Description )
	_aErr := { '0', cEr }
	break

return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Retorna dados do cliente

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
static function chkSA1( cA1CNPJ )
	local cQWSS07	:= ""
	local aRetSA1	:= {}
	local aArea		:= getArea()

	cQWSS07 := "SELECT A1_COD, A1_LOJA, A1_ZCDECOM, A1_ZCDEREQ, A1_TIPO, A1_PESSOA, A1_MSBLQL"	+ CRLF
	cQWSS07 += " FROM " + retSQLName("SA1") + " SA1"					+ CRLF
	cQWSS07 += " WHERE"													+ CRLF
	cQWSS07 += " 		SA1.A1_CGC		=	'" + cA1CNPJ		+ "'"	+ CRLF
	cQWSS07 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")	+ "'"	+ CRLF
	cQWSS07 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQWSS07 New Alias "QWSS07"

	if !QWSS07->( EOF() )
					//		 1				 2				  3				  	  4					  5				   6				  7	
		aRetSA1 := { QWSS07->A1_COD, QWSS07->A1_LOJA, QWSS07->A1_ZCDECOM, QWSS07->A1_TIPO, QWSS07->A1_PESSOA, QWSS07->A1_MSBLQL, QWSS07->A1_ZCDEREQ }
	endif

	QWSS07->(DBCloseArea())

	restArea( aArea )
return aRetSA1

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Retorna data de entrega

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
WSMETHOD deliveryDate WSRECEIVE deliveryDateRequest WSSEND generalResponse WSSERVICE MGFWSS07
	local bError 		:= ErrorBlock( { |oError| MyError( oError ) } )
	local aAreaX		:= getArea()
	local cQueryZAP		:= ""
	local nDayWeek		:= dow( date() )
	local aDelivWeek	:= {}
	local nI			:= 0
	local nDeliveDay	:= 0
	local cDelivery		:= ""
	local cStateReq		:= left( allTrim( ::deliveryDateRequest:cityID ) , 2 )
	local cCityReq		:= right( allTrim( ::deliveryDateRequest:cityID ) , 5 )

	::generalResponse := WSClassNew( "WSS07_GENERAL_STATUS" )

	BEGIN SEQUENCE
		cQueryZAP := "SELECT *"														+ CRLF
		cQueryZAP += " FROM "		+ retSQLName("ZAP") + " ZAP"					+ CRLF
		cQueryZAP += " INNER JOIN " + retSQLName("SZP") + " SZP"					+ CRLF
		cQueryZAP += " ON"															+ CRLF
		cQueryZAP += " 		ZAP.ZAP_CODREG	=	SZP.ZP_CODREG"						+ CRLF
		cQueryZAP += " 	AND	SZP.ZP_FILIAL	=	'" + xFilial("SZP")	+ "'"			+ CRLF
		cQueryZAP += " 	AND	SZP.D_E_L_E_T_	<>	'*'"								+ CRLF
		cQueryZAP += " WHERE"														+ CRLF
		cQueryZAP += " 		("														+ CRLF
		cQueryZAP += " 			ZAP_SEGUND	= 'S'"									+ CRLF
		cQueryZAP += " 			OR"													+ CRLF
		cQueryZAP += " 			ZAP_TERCA	= 'S'"									+ CRLF
		cQueryZAP += " 			OR"													+ CRLF
		cQueryZAP += " 			ZAP_QUARTA	= 'S'"									+ CRLF
		cQueryZAP += " 			OR"													+ CRLF
		cQueryZAP += " 			ZAP_QUINTA	= 'S'"									+ CRLF
		cQueryZAP += " 			OR"													+ CRLF
		cQueryZAP += " 			ZAP_SEXTA	= 'S'"									+ CRLF
		cQueryZAP += " 		)"														+ CRLF
		cQueryZAP += "  AND	ZAP.ZAP_CODMUN	=	'" + cCityReq		+ "'"			+ CRLF
		cQueryZAP += " 	AND	ZAP.ZAP_UF		=	'" + cStateReq		+ "'"			+ CRLF
		cQueryZAP += " 	AND	ZAP.ZAP_FILIAL	=	'" + xFilial("ZAP")	+ "'"			+ CRLF
		cQueryZAP += " 	AND	ZAP.D_E_L_E_T_	<>	'*'"								+ CRLF

		conout( "[MGFWSS07] [deliveryDate] " + cQueryZAP )

		tcQuery cQueryZAP New Alias "QRYZAP"

		if !QRYZAP->(EOF())
			aadd( aDelivWeek , 0 ) // Domingo

			if QRYZAP->ZAP_SEGUND == "S"
				aadd( aDelivWeek , 2 )
			else
				aadd( aDelivWeek , 0 )
			endif

			if QRYZAP->ZAP_TERCA == "S"
				aadd( aDelivWeek , 3 )
			else
				aadd( aDelivWeek , 0 )
			endif

			if QRYZAP->ZAP_QUARTA == "S"
				aadd( aDelivWeek , 4 )
			else
				aadd( aDelivWeek , 0 )
			endif

			if QRYZAP->ZAP_QUINTA == "S"
				aadd( aDelivWeek , 5 )
			else
				aadd( aDelivWeek , 0 )
			endif

			if QRYZAP->ZAP_SEXTA == "S"
				aadd( aDelivWeek , 6 )
			else
				aadd( aDelivWeek , 0 )
			endif

			aadd( aDelivWeek , 0 ) // Sabado

			nI			:= ( nDayWeek + 1 )
			nDayCount	:= 0
			while nI <= len( aDelivWeek )
				nDayCount++

				if aDelivWeek[ nI ] > 0 // .AND. VALIDACOES DE HORA DE CORTE E FERIADO

					if !isHoliday( date() + nDayCount , QRYZAP->ZAP_CODMUN , QRYZAP->ZAP_UF )
						if nDayCount == 1 .and. time() <= ( QRYZAP->ZP_FECHAME + ":00" )
							// Se for no mesmo dia verifica se esta antes do fechamento da grade de entrega
							exit
						elseif nDayCount > 1
							exit
						endif
					endif
				endif

				nI++
				// reinicia semana
				if nI > len( aDelivWeek )
					nI := 1
				endif
			enddo

			if nDayCount > 0
				SET CENTURY ON // Ano com 4 digitos

				cDelivery := dToC( date() + nDayCount )
				::generalResponse:status		:= "1"
				::generalResponse:observacao	:= cDelivery

				SET CENTURY OFF // Ano com 2 digitos 
			else
				::generalResponse:status		:= "0"
				::generalResponse:observacao	:= ""
			endif
		else
			::generalResponse:status		:= "0"
			::generalResponse:observacao	:= ""
		endif

		QRYZAP->(DBCloseArea())
	RECOVER
		conout('[MGFWSS07] [DELIVERYDATE] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::generalResponse:status		:= _aErr[1]
		::generalResponse:observacao	:= ""

		conout( " [MGFWSS07] [DELIVERYDATE] ERROR " + _aErr[2] )
	endif

	restArea( aAreaX )
return .T.

/*/
===========================================================================================================================
{Protheus.doc} MGFWSS07
Verifica se data é dia útil de acordo com grade de entrega

@author Josué Danich Prestes
@since 19/12/2019 
@type WebService  
/*/  
static function isHoliday( dDayToChk , cMunicipio , cEstado )
	local lRet		:= .F.
	local cQryZ04	:= ""

	cQryZ04 := "SELECT *"														+ CRLF
	cQryZ04 += " FROM " + retSQLName("Z04") + " Z04"							+ CRLF
	cQryZ04 += " WHERE"															+ CRLF
	cQryZ04 += " 		Z04.Z04_MUNICI	=	'" + cMunicipio			+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_DATA   	=	'" + dToS( dDayToChk )	+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_TIPO  	=	'M'"								+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_FILIAL	=	'" + xFilial("Z04")		+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryZ04 += " UNION ALL"														+ CRLF

	cQryZ04 += " SELECT *"														+ CRLF
	cQryZ04 += " FROM " + retSQLName("Z04") + " Z04"							+ CRLF
	cQryZ04 += " WHERE"															+ CRLF
	cQryZ04 += " 		Z04.Z04_ESTADO	=	'" + cEstado			+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_DATA   	=	'" + dToS( dDayToChk )	+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_TIPO  	=	'E'"								+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_FILIAL	=	'" + xFilial("Z04")		+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryZ04 += " UNION ALL"														+ CRLF

	cQryZ04 += " SELECT *"														+ CRLF
	cQryZ04 += " FROM " + retSQLName("Z04") + " Z04"							+ CRLF
	cQryZ04 += " WHERE"															+ CRLF
	cQryZ04 += " 		Z04.Z04_DATA   	=	'" + dToS( dDayToChk )	+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_TIPO  	=	'N'"								+ CRLF
	cQryZ04 += " 	AND	Z04.Z04_FILIAL	=	'" + xFilial("Z04")		+ "'"		+ CRLF
	cQryZ04 += " 	AND	Z04.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQryZ04 New Alias "QRYZ04"

	if !QRYZ04->(EOF())
		lRet := .T.
	endif

	QRYZ04->(DBCloseArea())

return lRet