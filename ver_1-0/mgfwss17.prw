#include 'totvs.ch'
#include 'restful.ch'
#include "topconn.ch"
#include "tbiconn.ch"

#DEFINE LOG_DIRECTORY "\log_integ"

//****************************************************************************
//****************************************************************************
WSRESTFUL stock DESCRIPTION 'API de Estoque' FORMAT APPLICATION_JSON
    WSMETHOD POST inclusionStock DESCRIPTION 'Inclusão de Stock' WSSYNTAX '/stock/inclusionStock'  PRODUCES APPLICATION_JSON
ENDWSRESTFUL

//****************************************************************************
//****************************************************************************
WSMETHOD POST inclusionStock WSRESTFUL stock
    local lRet			:= .T.
	local aAreaX		:= getArea()
	local aAreaZF6		:= ZF6->( getArea() )
    local oJson			:= nil
    local cError		:= ""
	local nI			:= 0
	local dDtRecebid	:= cToD( "//" )
	local cHrRecebid	:= ""
	local cSgRecebid	:= ""
	local cSeqLote		:= ""
	local nTamProd		:= superGetMv( "MFG_WSS17A" , , 6 )

	local cDtValidad	:= ""
	local cDtProduca	:= ""

   // Local cJson		:= Self:GetContent()

	setFunName( "MGFWSSXX" )

	conout( "[MGFWSSXX] inclusionStock - CHEGADA - " + dToC( dDataBase ) + " - " + time() )

	//if !empty( cJson )
	if !empty( self:getContent() )
		oJson   := jsonObject():new()
		cError  := oJson:fromJson( self:getContent() )

		if !empty( cError )
			setRestFault( 400 , 'Parser Json Error' )
	        lRet := .F.
		else
			conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - " + allTrim( oJson:getJsonObject('lote') ) )

			if ChkFile( "ZF6" , .T. /*[lExclusivo]*/ )
				ZF6->( DBSetOrder( 1 ) )

				ZF6->( DBGoTop() )

				dDtRecebid	:= date()
				cHrRecebid	:= time()
				cSgRecebid	:= seconds()

				conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - INICIO Sequencial - " + allTrim( oJson:getJsonObject('lote') ) )
				cSeqLote	:= getMaxZF6()
				conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - FIM Sequencial - " + allTrim( oJson:getJsonObject('lote') ) )

				conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Verificando Lote - " + allTrim( oJson:getJsonObject('lote') ) )
				if !ZF6->( DBSeek( allTrim( oJson:getJsonObject('filial') ) + left( oJson:getJsonObject('lote'), tamSx3("ZF6_LOTE")[1] ) ) )
					conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Lote Valido - " + allTrim( oJson:getJsonObject('lote') ) )

					BEGIN TRANSACTION

						conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Iniciada Gravação - Dentro da Transação - " + allTrim( oJson:getJsonObject('lote') ) )

						for nI := 1 to len( oJson:getJsonObject('estoques') )
							recLock( "ZF6" , .T. )
								ZF6->ZF6_FILIAL		:= oJson:getJsonObject('filial')
								ZF6->ZF6_LOTE		:= oJson:getJsonObject('lote')
								ZF6->ZF6_PMEDIO		:= oJson:getJsonObject('estoques')[ nI ]:getJsonObject('pesoMedio')
								ZF6->ZF6_ESTOQU		:= oJson:getJsonObject('estoques')[ nI ]:getJsonObject('estoque')
								ZF6->ZF6_PRODUT		:= padL( allTrim( oJson:getJsonObject('estoques')[ nI ]:getJsonObject('idProduto') ) , nTamProd , "0" )

								// 2019-06-26T00:00:00
								cDtValidad		:= ""
								cDtValidad		:= allTrim( oJson:getJsonObject('estoques')[ nI ]:getJsonObject('dataValidade') )
								cDtValidad		:= strTran( oJson:getJsonObject('estoques')[ nI ]:getJsonObject('dataValidade')	, "-" )
								cDtValidad		:= left( cDtValidad , 8 )
								ZF6->ZF6_DTVALI	:= sToD( cDtValidad )

								cDtProduca		:= ""
								cDtProduca		:= allTrim( oJson:getJsonObject('estoques')[ nI ]:getJsonObject('dataProducao') )
								cDtProduca		:= strTran( oJson:getJsonObject('estoques')[ nI ]:getJsonObject('dataProducao')	, "-" )
								cDtProduca		:= left( cDtProduca , 8 )
								ZF6->ZF6_DTPROD	:= sToD( cDtProduca )

								ZF6->ZF6_DTRECE		:= dDtRecebid
								ZF6->ZF6_TIMERE		:= cHrRecebid
								ZF6->ZF6_SECMID		:= cSgRecebid
								ZF6->ZF6_SEQUEN		:= cSeqLote
							ZF6->( msUnlock() )
						next

						conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Gravação Encerrada - Dentro da Transação - " + allTrim( oJson:getJsonObject('lote') ) )

					END TRANSACTION

					conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Gravação Encerrada - Fora da Transação - " + allTrim( oJson:getJsonObject('lote') ) )
				else
					conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Lote já enviado - " + allTrim( oJson:getJsonObject('lote') ) )
				endif
			else
				conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Não foi possível abrir de modo exclusivo - " + allTrim( oJson:getJsonObject('lote') ) )
			endif
		endif

		conout( "[MGFWSSXX] inclusionStock - " + dToC( dDataBase ) + " - " + time() + " - Encerramento - " + allTrim( oJson:getJsonObject('lote') ) )
	else
		setRestFault( 400 , 'No Content' )
	    lRet := .F.
	endif

	restArea( aAreaZF6 )
	restArea( aAreaX )

	conout( "[MGFWSSXX] inclusionStock - SAIDA - " + dToC( dDataBase ) + " - " + time() )
return( lRet )

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function getMaxZF6()
	local cQryZF6		:= ""
	local cMaxSequen	:= soma1( strZero ( 0 , tamSX3("ZF6_SEQUEN")[1] ) )

	cQryZF6 := "SELECT"									+ CRLF
	cQryZF6 += " MAX( ZF6_SEQUEN ) ZF6_SEQUEN"			+ CRLF
	cQryZF6 += " FROM " + retSQLName( "ZF6" ) + " ZF6"	+ CRLF
	cQryZF6 += " WHERE"									+ CRLF
	cQryZF6 += " 		ZF6.D_E_L_E_T_	<>	'*'"		+ CRLF

	tcQuery cQryZF6 new alias "QRYZF6"

	if !QRYZF6->( EOF() )
		cMaxSequen := soma1( ZF6_SEQUEN )
	endif

	QRYZF6->( DBCloseArea() )
return cMaxSequen