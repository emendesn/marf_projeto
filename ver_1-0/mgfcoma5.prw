#include 'protheus.ch'
// #include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCOMA5
Autor...............: Odair Ferraz - Totvs
Data................: 31/10/2018 
Descricao / Objetivo: Incluir nova Legenda no Pedido de Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT120LEG
=====================================================================================
*/

User Function MGFCOMA5()

Local aLegenda  := Paramixb[1]
Local a_LegUser := {}   
Local nCnt := 0

For nCnt:=1 To Len(aLegenda)
	aAdd(a_LegUser,aLegenda[nCnt])
Next


aAdd(a_LegUser,{'BR_PINK',"AE em Recebimento (Pré-nota)"}) 
aAdd(a_LegUser,{'BR_MARRON_OCEAN',"AE Recebida Parcialmente"})       //'BR_VERDE_ESCURO'
aAdd(a_LegUser,{'BR_MARRON',"AE Recebida"}) 

If IsInCallStack("MATA121")
	aAdd(a_LegUser,{'BR_PRETO',"AE Pendente"}) 
EndIf
aAdd(a_LegUser,{'BR_VIOLETA',"Rejeitado pelo aprovador"}) 

Return(a_LegUser)


