#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFIN
Autor...............: TOTVS
Data................: 07/06/2017 
Descricao / Objetivo: Funcao para gravar dados bancarios do fornecedor na fatura gerada 
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=110432913
=====================================================================================
*/
user function MGFFIN56()
	local aArea		:= getArea()
	local aAreaSE2	:= SE2->(getArea())
	local aAreaSA2	:= SA2->(getArea())

	DBSelectArea( "SA2" )
	SA2->( DBSetOrder(1) )
	SA2->( DBGoTop() )

	if SA2->( DBSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA ) )

		recLock("SE2", .F.)
			SE2->E2_FORBCO	:= SA2->A2_BANCO	// Banco For.
			SE2->E2_FORAGE	:= SA2->A2_AGENCIA	// Agencia For.
			SE2->E2_FAGEDV	:= SA2->A2_DVAGE	// DV Agencia
			SE2->E2_FORCTA	:= SA2->A2_NUMCON	// Conta For.
			SE2->E2_FCTADV	:= SA2->A2_DVCTA	// DV Conta			  
		SE2->(MSUnlock())

	endif
	
	recLock("SE2", .F.)
		SE2->E2_ZIDINTE := 'FATURAZZZ'
		SE2->E2_ZBLQFLG := 'N'
		SE2->E2_DATALIB := dDataBase
		SE2->E2_ZNEXGRD := ''
		//SE2->E2_ZGRPAPR := 'FATURA'
		SE2->E2_ZCODGRD := 'FATURA'
		SE2->E2_ZIDGRD  := 'FATURAZZZ'
	SE2->(MSUnlock())
	
	restArea(aAreaSA2)
	restArea(aAreaSE2)
	restArea(aArea)
return