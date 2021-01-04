#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "protheus.ch"


User Function GFEXFB15()
	Local lRet := .F.
	Local GWU_CDTPDC    := PARAMIXB[1]
	Local GWU_EMISDC    := PARAMIXB[2]
	Local GWU_SERDC     := PARAMIXB[3]
	Local GWU_NRDC      := PARAMIXB[4]
	Local GWU_SEQ       := PARAMIXB[5]
	Local cAgrup        := PARAMIXB[6]
	Local aAreaGWU       := GWU->( GetArea() )
	Public _xOE


	//Tratativa apenas será realizada para os segundos trechos de transporte
	If GWU_SEQ = '02'
		
		GWU->(DbSetOrder(1))
		If GWU->(DbSeek(xFilial('GWU') + GWU_CDTPDC + GWU_EMISDC + GWU_SERDC + GWU_NRDC + GWU_SEQ))
			
			If _xOE <> GWU->GWU_ZORDEM
				_xOE := GWU->GWU_ZORDEM
				lRet := .T.
			Else
				lRet := .F.
			EndIf
		EndIf
	Else
		lRet :=.F.
	EndIf
	
	_xOE := GWU->GWU_ZORDEM
	cAgrup := GWU->GWU_ZORDEM
	RestArea(aAreaGWU)

Return {lRet,cAgrup}

