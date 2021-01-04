#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFINT68
Atualiza o campo A1_XORIGEM respons�vel pelo Sistema de Origem
@description
Atualiza o campo A1_XORIGEM respons�vel pelo Sistema de Origem
@author TOTVS
@since 15/10//2019
@type Function
@table
SA1 - Clientes
ZF5 - Sistema de Origem
@param
@return
Sem retorno
@menu
Sem menu
/*/
user function MGFINT68( nTipo , cFunc )
	local cQryZF5		:= ""
	local cRetOrigem	:= ""
	local aAreaX		:= getArea()

	default nTipo		:= 1 // 1 - Clientes, 2 - WS de Pedidos , 3 - Pedido de Venda
	default cFunc		:= ""

	cQryZF5 := "SELECT ZF5_CODIGO , ZF5_FUNCTI"							+ CRLF
	cQryZF5 += " FROM " + retSQLName("ZF5") + " ZF5"					+ CRLF
	cQryZF5 += " WHERE"													+ CRLF
	cQryZF5 += " 		ZF5.ZF5_FILIAL	=	'" + xFilial("ZF5")	+ "'"	+ CRLF
	cQryZF5 += " 	AND	ZF5.D_E_L_E_T_	<>	'*'"						+ CRLF

	if nTipo == 1
		if PARAMIXB <> 3
			cQryZF5 += " AND ZF5.ZF5_FUNCTI = '" + funName() + "'" + CRLF
		endif
	elseif nTipo == 2
		cQryZF5 += " AND ZF5.ZF5_FUNCTI = '" + cFunc + "'" + CRLF
	endif

	tcQuery cQryZF5 new alias "QRYZF5"

	if !QRYZF5->( EOF() )
		if nTipo == 1
			if PARAMIXB <> 3
				recLock("SA1", .F.)
					SA1->A1_XORIGEM	:= QRYZF5->ZF5_CODIGO
					cRetOrigem		:= QRYZF5->ZF5_CODIGO
				SA1->(msUnLock())
			endif
		elseif nTipo == 2
			cRetOrigem := QRYZF5->ZF5_CODIGO
		elseif nTipo == 3
			// FLAG DE INTEGRACAO DE PEDIDO DE VENDA
			SC5->( recLock( 'SC5' , .F. ) )
				SC5->C5_XINTEGR := 'P'
			SC5->( msUnLock() )

			if empty( SC5->C5_XORIGEM )
				while !QRYZF5->( EOF() )
					if isInCallStack( allTrim( QRYZF5->ZF5_FUNCTI ) )

						cRetOrigem := QRYZF5->ZF5_CODIGO

						exit
					endif

					QRYZF5->( DBSkip() )
				enddo

				if !empty( cRetOrigem )
					SC5->( recLock( 'SC5' , .F. ) )
						SC5->C5_XORIGEM := cRetOrigem
						SC5->C5_XCALLBA := 'S'
					SC5->( msUnLock() )
				endif
			endif
		endif
	endif

	QRYZF5->( DBCloseArea() )

	restArea( aAreaX )
return cRetOrigem