#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFEEC70

Exclui os Lançamentos de Despesas na Tabela EET após exclusão do Pedido de Compra
Chamado pelo PE MT120FIM

@type function
@author TOTVS
@since JUNHO/2019
@version P12
/*/
user function MGFEEC70( cPed , nOpx , nOpca )
	local aAreaX	:= getArea()
	local aAreaEET	:= EET->( getArea() )
	local cQryEET	:= ""

	if nOpx == 5 .and. nOpca == 1
		cQryEET := "SELECT EET.R_E_C_N_O_ EETRECNO"
		cQryEET += " FROM " + retSQLName("EET") + " EET"
		cQryEET += " WHERE"
		cQryEET += " 		EET.EET_PEDCOM	=	'" + SC7->C7_NUM	+ "'"
		cQryEET += " 	AND EET.EET_FILIAL	=	'" + SC7->C7_FILIAL	+ "'"
		cQryEET += " 	AND EET.D_E_L_E_T_	<>	'*'"

		tcQuery cQryEET New Alias "QRYEET"

		if !QRYEET->( EOF() )
			DBSelectArea("EET")

			while !QRYEET->( EOF() )
				EET->( DBGoTo( QRYEET->EETRECNO ) )
				recLock( "EET" , .F. )
					EET->( DBDelete() )
				EET->( msUnlock() )

				QRYEET->( DBSkip() )
			enddo
		endif

		QRYEET->( DBCloseArea() )
	endif

	restArea( aAreaEET )
	restArea( aAreaX )
return