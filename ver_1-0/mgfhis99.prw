#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGFHIS99   �Autor  �Microsiga           � Data �  01/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  GRAVA O HISTORICO DO PEDIDO                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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