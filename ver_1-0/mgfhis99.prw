#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MGFHIS99   ºAutor  ³Microsiga           º Data ³  01/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  GRAVA O HISTORICO DO PEDIDO                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MGFHIS99(_cFil,cNum,cHist,lInt)  // Grava Historico do Pedido

	DEFAULT lInt 	  := .F.

	aArea:=GetArea()

	_cEmpOld:=""

	//GUARDA as empresas
	_cEmpOld:=cEmpAnt     

	RecLock("ZVH",.T.)
	ZVH->ZVH_FILIAL	:= _cFil
	ZVH->ZVH_NUM	:= cNum
	ZVH->ZVH_DATA	:= Date()
	If lpRP
		ZVH->ZVH_HORA	:= ""
	ELSE
		ZVH->ZVH_HORA	:= substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
	ENDIF
	ZVH->ZVH_USUPRO	:= iif(lInt,"JOB",CUSERNAME)
	ZVH->ZVH_USUWIN	:= LogUserName()
	ZVH->ZVH_MICRO	:= iif(lInt,"Server",ComputerName())
	ZVH->ZVH_HIST	:= cHist
	ZVH->(MsUnlock("ZVH"))

	RestArea( aArea )

Return