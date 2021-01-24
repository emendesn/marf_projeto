#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN47
Autor....:              Atilio Amarilla
Data.....:              08/01/2017
Descricao / Objetivo:   Baixa CNAB - Alteração de valores de recebimento para FIDC
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Transações referentes a Banco/Carteira FIDC
=====================================================================================
*/

User Function MGFFIN47()

Local cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
Local aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
Local cAgeFIDC, cCtaFIDC
Local cMotBxFIDC	:= GetMv("MGF_FIN47A",,"DAC")	// Motivo da Baixa FIDC - Sem Movimento Bancário

// GDN - 28/08/2018 - Ajuste para tratar o Banco e 
// definir qual parametro considerar para FIDC
do Case
	Case cBanco = '237'
		cBcoFIDC	:= GetMv("MGF_FIN44A",,"237/123/12345/001")		// Banco FIDC
		cMotBxFIDC	:= GetMv("MGF_FIN48A",,"FIB")	// Motivo da Baixa FIDC Bradesco - Sem Movimento Bancário
	OtherWise
		cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
		cMotBxFIDC	:= GetMv("MGF_FIN47A",,"FID")	// Motivo da Baixa FIDC - Sem Movimento Bancário
EndCase
aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")

cBcoFIDC	:= aBcoFIDC[1]
cAgeFIDC	:= Stuff( Space( TamSX3("E1_AGEDEP")[1] ) , 1 , Len(AllTrim(aBcoFIDC[2])) , Alltrim(aBcoFIDC[2]) )
cCtaFIDC	:= Stuff( Space( TamSX3("E1_CONTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[3])) , Alltrim(aBcoFIDC[3]) )
cSubFIDC	:= Stuff( Space( TamSX3("EE_SUBCTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[4])) , Alltrim(aBcoFIDC[4]) )

/*
FIDC - Baixa pelo valor do título, sem considerar valores de desconto, juros,...
*/
//If SE1->( E1_PORTADO + E1_AGEDEP + E1_CONTA ) == cBcoFIDC + cAgeFIDC + cCtaFIDC
If cBanco + cAgencia + cConta == cBcoFIDC + cAgeFIDC + cCtaFIDC

	cMotBx	:= cMotBxFIDC

Else
	
	cMotBx := "NOR"
	
EndIf

If SE1->( E1_PORTADO + E1_AGEDEP + E1_CONTA ) <> cBanco + cAgencia + cConta
	
	RecLock("SE1",.F.)
	SE1->E1_PORTADO	:= cBanco
	SE1->E1_AGEDEP	:= cAgencia
	SE1->E1_CONTA	:= cConta
	SE1->( msUnlock() )

/*	If SE1->( E1_PORTADO + E1_AGEDEP + E1_CONTA ) <> cBcoFIDC + cAgeFIDC + cCtaFIDC
		RecLock("SE1",.F.)
		SE1->E1_PORTADO	:= cBcoFIDC
		SE1->E1_AGEDEP	:= cAgeFIDC
		SE1->E1_CONTA	:= cCtaFIDC
		SE1->( msUnlock() )
	EndIf
*/	
	/*
	If nJuros + nMulta > 0
		nValRec -= nJuros + nMulta
		nJuros	:= 0
		nMulta	:= 0
		nAcresc	:= 0
	EndIf

	If nDescont + nAbatim > 0
		nValRec += nDescont + nAbatim
		nDescont	:= 0
		nDecresc	:= 0
	EndIf
	*/
EndIf

Return