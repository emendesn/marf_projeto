#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define _Enter chr(13) + chr(10)

/*/{Protheus.doc} MGFEEC60
Rotina chamada pelo ponto de entrada EECAE100, Validar cancelamento de embarque
@type  Function
@author Totvs
@since Outubro/2018
@version 12
@param 
@return return_var, return_type, return_description
@example
(examples)
@alterações
	2020-02-26 feature/RTASK0010725-situacao-embarque - Cláudio Alves
	Foi alterado o fonte para automatizar o preenchimento do campo EEC->EEC_MOTSIT com '0010' no caso de cancelamento
/*/

User Function MGFEEC60()
	local cParam := if(Type("ParamIxb") == "A",ParamIxb[1],if(Type("ParamIxb") == "C",ParamIxb,""))
	local nOpc := if((Type("ParamIxb") == "A" .AND. cParam == "BUTTON_REMESSA" .AND. Type("nOpcPE") == "N"),nOpcPE,Nil)
	if IsInCallStack("EECAE100") .AND. cParam == "BUTTON_REMESSA" .AND. nOpc <> Nil
		if nOpc == 5 // cancelar
			if !Empty(EEC->EEC_DTEMBA)
				lExibeTela := .F.
				APMsgAlert("Esse processo já possui data de embarque informada. É necessário retirar a data de embarque para realizar o cancelamento/eliminação.")
				BREAK
			endif
		endif
	endif
	if cParam == "PE_EXC"
		fMudaStatus()
	endif
Return()


/*/{Protheus.doc} fMudaStatus
	função para mudar de status os embarques tanto principal como o intermediário
	@type  Static Function
	@author Cláudio Alves
	@since 27/02/2020
	@version version
	@param 
	@return 
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function fMudaStatus()
	local _cQry :=  ''
	
	if !ExisteSx6("MGF_EEC79A")
		CriarSX6("MGF_EEC79A", "L", "Habilita Funcionalodade da Rotina",'.T.' )
	endif
	
	if !(superGetMV("MGF_EEC79A", , .T.))
		return
	endif

	_cQry := _Enter  + "UPDATE "
	_cQry += _Enter  + "    " + retSQLName("EEC") + " "
	_cQry += _Enter  + "SET "
	_cQry += _Enter  + " 	EEC_MOTSIT = '0010' "
	_cQry += _Enter  + " WHERE 1 = 1 "
	_cQry += _Enter  + " 	AND EEC_PREEMB = '" + M->EEC_PREEMB + "' "
	_cQry += _Enter  + " 	AND	D_E_L_E_T_	=	' ' "

	MemoWrite('C:\TEMP\mgfeec60.sql', _cQry)

	If tcSQLExec( strTran(_cQry, _Enter, '' )) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	Else
		tcSQLExec( "commit" )
		conout("UPDATE. realizado com Sucesso - Alterado o EEC_MOTSIT para '0010' devido a update")
	EndIf
	// RecLock("EEC", .f.)
	// EEC->EEC_MOTSIT := "0010"
	// EEC->(MsUnlock())
Return