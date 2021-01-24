#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFCTB02
Autor...............: Joni Lima
Data................: 09/11/2016
Descrição / Objetivo: Validação para os itens da consulta padrão. 
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Utilizado na Conulsta Padrão 'CTJ'
=====================================================================================
*/
User Function MGFCTB02()
	Local lRet := .T.
	
	If ( Alltrim(UPPER(FunName())) $ 'MATA110|MATA121|MATA103' )
		lRet := .T.
	Else
		lRet := Empty(CTJ->CTJ_ZFILDES)
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xMC02VlFD
Autor...............: Joni Lima
Data................: 09/11/2016
Descrição / Objetivo: Validação para o Campo CTJ_ZFILDES 
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: So aceita ser preenhido informações na rotina CTBA120 e faz validação para verificar se a Filial Existe
=====================================================================================
*/
User Function xMC02VlFD()

	Local lRet := Vazio()
	
	If !lRet
		If ALLTRIM(UPPER(FUNNAME())) == 'CTBA120'
			lRet := ExistCpo("SM0",cEmpAnt + FwFldGet('CTJ_ZFILDE'))
		Else
			Alert('Campo só pode ser utilizado, nas rotinas referentes a ')	
		EndIf
	EndIf
                                                                  
Return lRet