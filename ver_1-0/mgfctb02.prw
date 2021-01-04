#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFCTB02
Autor...............: Joni Lima
Data................: 09/11/2016
Descricao / Objetivo: Validacao para os itens da consulta padrao. 
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Utilizado na Conulsta Padr�o 'CTJ'
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
Descricao / Objetivo: Validacao para o Campo CTJ_ZFILDES 
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: So aceita ser preenhido informacoes na rotina CTBA120 e faz validacao para verificar se a Filial Existe
=====================================================================================
*/
User Function xMC02VlFD()

	Local lRet := Vazio()
	
	If !lRet
		If ALLTRIM(UPPER(FUNNAME())) == 'CTBA120'
			lRet := ExistCpo("SM0",cEmpAnt + FwFldGet('CTJ_ZFILDE'))
		Else
			Alert('Campo s� pode ser utilizado, nas rotinas referentes a ')	
		EndIf
	EndIf
                                                                  
Return lRet