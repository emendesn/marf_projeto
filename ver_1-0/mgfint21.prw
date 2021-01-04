#Include 'Protheus.ch'

/*
==============================================================================================
Programa.:              MGFINT21
Autor....:              Francis Oliveira
Data.....:              26/09/2016
Descricao / Objetivo:   Integraçao RoadNet
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Replica as informaçoes de alguns campos para comparação nas alteraões
===============================================================================================
*/

User Function MGFINT21()

Local aArea    := Getarea()
Local aAreaSA1 := SA1->(Getarea())

RecLock("SA1",.F.)
	SA1->A1_XALTZCR := SA1->A1_ZCROAD
	SA1->A1_XALTNOM := SA1->A1_NOME
	SA1->A1_XALTEND := SA1->A1_END
	SA1->A1_XALTBAI := SA1->A1_BAIRRO
	SA1->A1_XALTMUN := SA1->A1_MUN
	SA1->A1_XALTEST := SA1->A1_EST
MsUnLock()

RestArea(aAreaSA1)
RestArea(aArea)

Return

