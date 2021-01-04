#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              MGFFIN20 - PE
Autor....:              Antonio Carlos        
Data.....:              06/10/2016
Descricao / Objetivo:   selecionar somente titulos vencidos 
Doc. Origem:          ///  Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              titulos em aberto selecionar somente os vencidos   Botao
=====================================================================================
*/
User Function MGFFIN20()

	Local aAlias	:= {} 
	Local aParam 	:= {}
	Local aGet      := {"","","",""}
	LOCAL cQuery    := '' 
	LOCAL dDtVenc   := DTOS(dDataBase)
	Local nCont		:= 0
	Local nSaldo	:= 0 
	Local nAcres	:= 0 
	Local nAbat		:= 0 
	Local nDescres	:= 0 
	Local nJuros	:= 0 
	Local aAreaTRB  := '' 
	Local bAberto   := .F.
	

	//
	Private _xFilC  := " " 

	IF Select ("FC010QRY01") > 0
		aAreaTRB  := GetArea('FC010QRY01') 
		bAberto   := .T.     
		ChkFile("FC010QRY01",,'TRBFIN20')
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
	
	aEval(aAlias,{|x| (x[1])->(dbCloseArea()),Ferase(x[2]+GetDBExtension()),Ferase(x[2]+OrdBagExt())})

	IF bAberto
		ChkFile('TRBFIN20',,"FC010QRY01")
		RestArea( aAreaTRB) 
    EndIF


Return()