#include 'protheus.ch'
#include 'totvs.ch'
#INCLUDE 'FIVEWIN.CH'


/*
==================================================================================
Programa............: M110EXIT
Autor...............: Juscelino Alves dos Santos
Data................: 26/11/2018
Descricao / Objetivo: Gatilho Executado no Bot�o Cancelar da Solicita��o de Compras 
Doc. Origem ........: MIT680 - GAP EST16
Solicitante.........: Marfrig
Uso.................: Gest�o de Compras 
==================================================================================
*/

User function M110EXIT()
Local  lret:=.T.

If INCLUI
  Set Key VK_F4 to
EndIf
   
return lret