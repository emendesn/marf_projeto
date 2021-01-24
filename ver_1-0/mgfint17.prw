#include 'totvs.ch'

/*
=====================================================================================
Programa.:              MGFINT17
Autor....:              Francis Oliveira
Data.....:              26/09/2016
Descricao / Objetivo:   Integraçao RoadNet
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Inclui Codigo de Roteirização e Altera o Status de Integrado 
=====================================================================================
*/

User Function MGFINT17()

Local aArea    := Getarea()
Local aAreaSA1 := SA1->(Getarea())
Local cCodRoad := GETMV("MGF_CODROT")
Local cNewRoad := ""
Local cNullRoad := ""
Local nOpc := PARAMIXB

If Inclui .AND. nOpc = 0
	If SA1->A1_ZITROAD == "S"
		If cCodRoad = SA1->A1_ZCROAD
			cNewRoad := Soma1(cCodRoad)
			PUTMV("MGF_CODROT",cNewRoad)
		Else
			DbSelectArea("SA1")
			RecLock("SA1",.F.)
				SA1->A1_ZCROAD := cCodRoad
			MsUnLock()
			cNewRoad := Soma1(cCodRoad)
			PUTMV("MGF_CODROT",cNewRoad)
		EndIf
	Else
		DbSelectArea("SA1")
		RecLock("SA1",.F.)
			SA1->A1_ZCROAD := cNullRoad
		MsUnLock()
	EndIf
ElseIf Altera
		If (SA1->A1_ZCROAD <> SA1->A1_XALTZCR) .OR.;
          (SA1->A1_NOME <> SA1->A1_XALTNOM) .OR. ;
		   (SA1->A1_END <> SA1->A1_XALTEND) .OR. ;
		   (SA1->A1_BAIRRO <> SA1->A1_XALTBAI) .OR. ;
		   (SA1->A1_MUN <> SA1->A1_XALTMUN) .OR. ;
		   (SA1->A1_EST <> SA1->A1_XALTEST)
			
		   RecLock("SA1",.F.)
		   SA1->A1_ZALTROA := "N"
		   MsUnLock()
		EndIf
		If SA1->A1_ZITROAD == "S"
			If Empty(SA1->A1_ZCROAD)
				RecLock("SA1",.F.)
				SA1->A1_ZCROAD := cCodRoad
				MsUnLock()
				cNewRoad := Soma1(cCodRoad)
				PUTMV("MGF_CODROT",cNewRoad)
				
				RecLock("SA1",.F.)
		        SA1->A1_ZALTROA := "N"
		        MsUnLock()
			EndIf
		EndIf 		
	EndIf

RestArea(aAreaSA1)
RestArea(aArea)

Return