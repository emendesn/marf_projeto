#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFFATBE
Cadastra o cliente automaticamente na estrutura de vendas (carteira) do vendedor
@description
Cadastra o cliente automaticamente na estrutura de vendas (carteira) do vendedor
@author TOTVS
@since 23/12/2019
@type Function
@table
SA1 - Clientes
ZBJ - Estrutura de Vendas - Cliente x Vendedor
@param
@return
Sem retorno
@menu
Sem menu
/*/
user function MGFFATBE()
	local cQryZBI	:= ""
	local cQryZBJ	:= ""
	local aAreaX	:= getArea()
	local aAreaZBI	:= ZBI->( getArea() )
	local aAreaZBJ	:= ZBJ->( getArea() )

	if !empty( SA1->A1_VEND )
		cQryZBI := "SELECT  ZBI_SUPERV , ZBI_REGION , ZBI_TATICA , ZBI_NACION , ZBI_DIRETO , ZBI_CODIGO , ZBI_REPRES"	+ CRLF
		cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"																+ CRLF
		cQryZBI += " WHERE"																								+ CRLF
		cQryZBI += " 		ZBI.ZBI_REPRES	=	'" + SA1->A1_VEND	+ "'"												+ CRLF
		cQryZBI += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")	+ "'"												+ CRLF
		cQryZBI += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"																	+ CRLF

		tcQuery cQryZBI new alias "QRYZBI"

		if !QRYZBI->( EOF() )

			cQryZBJ := ""
			cQryZBJ := "SELECT ZBJ_CLIENT , ZBJ_LOJA , ZBJ_REPRES"				+ CRLF
			cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"					+ CRLF
			cQryZBJ += " WHERE"													+ CRLF
			cQryZBJ += " 		ZBJ.ZBJ_LOJA	=	'" + SA1->A1_LOJA	+ "'"	+ CRLF
			cQryZBJ += " 	AND	ZBJ.ZBJ_CLIENT	=	'" + SA1->A1_COD	+ "'"	+ CRLF
			cQryZBJ += " 	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ")	+ "'"	+ CRLF
			cQryZBJ += " 	AND	ZBJ.D_E_L_E_T_	<>	'*'"						+ CRLF

			tcQuery cQryZBJ new alias "QRYZBJ"

			if QRYZBJ->( EOF() )
				// SOMENTE INSERE SE CLIENTE NAO EXISTIR NA ESTRUTURA COMERCIAL

				DBSelectArea( "ZBJ" )

				recLock( "ZBJ" , .T. )
					ZBJ->ZBJ_FILIAL	:= xFilial( "ZBJ" )
					ZBJ->ZBJ_DIRETO := QRYZBI->ZBI_DIRETO
					ZBJ->ZBJ_NACION := QRYZBI->ZBI_NACION
					ZBJ->ZBJ_TATICA := QRYZBI->ZBI_TATICA
					ZBJ->ZBJ_REGION := QRYZBI->ZBI_REGION
					ZBJ->ZBJ_SUPERV := QRYZBI->ZBI_SUPERV
					ZBJ->ZBJ_ROTEIR := QRYZBI->ZBI_CODIGO
					ZBJ->ZBJ_REPRES	:= SA1->A1_VEND
					ZBJ->ZBJ_CLIENT	:= SA1->A1_COD
					ZBJ->ZBJ_LOJA	:= SA1->A1_LOJA
					ZBJ->ZBJ_INTSFO	:= "P"
				ZBJ->( msUnLock() )
			endif

			QRYZBJ->( DBCloseArea() )
		endif

		QRYZBI->( DBCloseArea() )
	endif

	restArea( aAreaZBJ )
	restArea( aAreaZBI )
	restArea( aAreaX )
return