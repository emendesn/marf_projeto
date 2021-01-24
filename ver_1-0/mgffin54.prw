#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              MGFFIN53
Autor....:              Leonardo Kume        
Data.....:              14/03/2017
Descricao / Objetivo:   Chamada da posição do cliente 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/


User Function MGFFIN54()
	Local aAlias	:= {} 
	Local aParam 	:= {}
	Local aGet      := {"","","",""}
	LOCAL cQuery    := '' 
	LOCAL dDtVenc   := DTOS(dDataBase)
	Local TRB    	:= GetNextAlias()
	Local nCont		:= 0
	Local nSaldo	:= 0 
	Local nAcres	:= 0 
	Local nAbat		:= 0 
	Local nDescres	:= 0 
	Local nJuros	:= 0 

	//
	Private _xFilC  := " " 

	IF Select (TRB) > 0
		(TRB)->(dbCloseArea())  
	ENDIF

	IF Select ("FC010QRY01") > 0
		("FC010QRY01")->(dbCloseArea())
	ENDIF

	_xFilC := "9" 
	aadd(aParam,MV_PAR01)
	aadd(aParam,MV_PAR02)
	aadd(aParam,MV_PAR03)
	aadd(aParam,MV_PAR04)
	aadd(aParam,MV_PAR05)
	aadd(aParam,MV_PAR06)
	aadd(aParam,MV_PAR07)
	aadd(aParam,MV_PAR08)
	aadd(aParam,MV_PAR09)
	aadd(aParam,MV_PAR10)
	aadd(aParam,MV_PAR11)
	aadd(aParam,MV_PAR12)
	aadd(aParam,MV_PAR13)
	aadd(aParam,MV_PAR14)
	aadd(aParam,MV_PAR15)
	aadd(aParam,MV_PAR16)
	aadd(aParam,MV_PAR17)
	aadd(aParam,MV_PAR18)	  


	Fc010Brow(1,@aAlias,aParam,.T.,aGet)

	IF Select (TRB) > 0
		(TRB)->(dbCloseArea())  
	ENDIF

Return