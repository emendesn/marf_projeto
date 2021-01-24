#INCLUDE 'PARMTYPE.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH'

/*/
{Protheus.doc} MANIEVEN
	Ponto de entrada na Manifestação do destinatário.

@description
	Logar usuário que está manisfestando.
	
@author Marcos Cesar Donizeti Vieira
@since 15/07/2020

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	C00 - Manifesto do destinatário

@param
@return

@menu
@history 
/*/

User Function MANIEVEN()

	Local _cTpEvento 	:= PARAMIXB[1]
	Local _cChaveNf		:= PARAMIXB[2]
	Local _cAliasUSR	:= GetNextAlias()

	Local _cStat := ""

	BeginSQL Alias _cAliasUSR

		SELECT USR_NOME
		FROM SYS_USR USR
		WHERE 
		USR.%NotDel% AND
		USR.USR_ID = %Exp:__CUSERID%

	EndSQL

	If _cTpEvento $ "210200"
		_cStat := "CONFIRMADA OPERACAO"
	ElseIf _cTpEvento $ "210220"
		_cStat := "DESCONHECIMENTO OPERACAO"
	ElseIf _cTpEvento $ "210240"
		_cStat := "OPERACAO NAO REALIZADA"		 
	ElseIf _cTpEvento $ "210210"
		_cStat := "CIENCIA DA OPERACAO"
	EndIf

	C00->( dbSetOrder(1) )
	If C00->( dbSeek(xFilial("C00")+_cChaveNf ) )
		RecLock("C00", .F.)
			C00->C00_NOMUSU := _cStat+" - "+( _cAliasUSR )->USR_NOME
		MsUnlock()
	EndIf

	(_cAliasUSR )->( DbCloseArea() )

Return _cTpEvento