#Include 'Protheus.ch'
#include 'parmtype.ch'

/*
============================================================================================
Programa.:              MT120LEG
Autor....:              Odair Ferraz - Totvs
Data.....:              Out/2018 
Descricao / Objetivo:   Incluir Legenda no Pedido de Compras
Doc. Origem:            Compras
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada para alterar a legenda da tela de Pedido de Compras
============================================================================================
*/                                                            '

User Function MT120LEG()

Local aLegenda 	:= Paramixb[1] 
Local nPos 		:= 0

If (nPos := aScan(aLegenda,{|x| Alltrim(x[2])=="Rejeitado pelo aprovador"})) > 0 
	aDel(aLegenda,nPos)
	aLegenda := asize(aLegenda,Len(aLegenda)-1)
Endif

IF FindFunction("U_MGFCOMA5")
	aLegenda := U_MGFCOMA5()
EndIF

If (nPos := aScan(aLegenda,{|x| Alltrim(x[2])=="Autorização de Entrega"})) > 0 
	aDel(aLegenda,nPos)
	aLegenda := asize(aLegenda,Len(aLegenda)-1)
Endif	

Return(aLegenda)



/*  
//BKP ANTERIOR, COMO ESTAVA.  



User Function MT120LEG()
	
Local aLeg := PARAMIXB

aLeg := { {'BR_AZUL' ,"Em Aprovação"},;
{'BR_AZUL_CLARO' ,"Rejeitado pelo aprovador"},;
{'BR_VERDE',"Liberado" },;
{'PMSEDT2' ,"Aguardando aceito do fornecedor (marketplace)"},;
{'BR_LARANJA',"Em recebimento (pre-nota)" },;
{'BR_AMARELO',"Recebido Parcialmente" },;
{'DISABLE',"Recebido" },;
{'BR_CINZA',"Com resíduo eliminado" },;
{'BR_PRETO',"Autorização de entrega" },;
{'BR_BRANCO',"Pedido de contrato" },;
	{'BR_CANCEL',"Cancelado por usuario" },;
	{'BR_VIOLETA',"Pedido rejeitado" } }//Customização


Return aLeg

*/





