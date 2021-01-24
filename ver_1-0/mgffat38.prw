#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFFAT38
Autor....:              Marcelo Carneiro         
Data.....:              06/06/2017 
Descricao / Objetivo:   ALTERACAO DE CAMPOS PEDIDO DE VENA
Doc. Origem:            MIT044 - feito no Go
Solicitante:            José W.
Uso......:              Marfrig
Obs......:              
=============================================================================================
*/


User Function MGFFAT38

Local oButton1
Local oMultiGe1
Local _lret:=.T.
Private bSel := .T.
Private bTaura      := .F.
Private cMenNota1   := Space(tamSx3("C5_MENNOTA")[1]) 
Private cMenNota2   := Space(tamSx3("C5_ZMENNOT")[1]) 
Private nFrete      := 0
Private nPsol       := 0
Private nPBruto     := 0
Private cVolume1    := Space(tamSx3("C5_VOLUME1")[1]) 
Private cEspeci1    := Space(tamSx3("C5_ESPECI1")[1])
Private cMenExp     := Space(tamSx3("C5_ZMENEXP")[1]) //Natanael Filho
Private cTransp		:= Space(tamSx3("C5_TRANSP")[1]) 
Private cVeicul		:= Space(tamSx3("C5_VEICULO")[1])
Private oDlg,lOk,lCancel

//Local oButton1

bTaura      := .F.


IF !Empty(SC5->C5_NOTA)
    msgAlert('Nota fiscal já emitida , não é possivel alterar !!')
    Return
EndIF    


// Altertado para informar em todas as situacoes 

cMenNota1   := SC5->C5_MENNOTA
cMenNota2   := SC5->C5_ZMENNOT
nFrete      := SC5->C5_FRETE
nPsol       := SC5->C5_PESOL
nPBruto     := SC5->C5_PBRUTO
cVolume1    := SC5->C5_VOLUME1
cEspeci1    := SC5->C5_ESPECI1 
cMenExp     := SC5->C5_ZMENEXP
cTransp     := SC5->C5_TRANSP
cVeicul     := SC5->C5_VEICULO

//
//------------------------------------------------------------
nLinDlg := 10   //Primeira linha
nLesp   := 16   //Espaçamento
	DEFINE DIALOG oDlg TITLE "Informações sobre o frete da carga" FROM 0,0 TO 450,600 PIXEL
	
	@ nLinDlg,08 SAY "Mensagem Nota 1:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,58 MSGET cMenNota1 SIZE 150/*TamSX3("C5_MENNOTA")[1]*/,10 OF oDlg PIXEL PICTURE '@!'
	nLinDlg += nLesp
		
	@ nLinDlg,08 SAY "Mensagem Nota 2:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,58 MSGET cMenNota2 SIZE 150/*TamSX3("C5_ZMENNOT")[1]*/,10 OF oDlg PIXEL PICTURE '@!'
	nLinDlg += nLesp
	
	@ nLinDlg,08 SAY "Frete:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,58 MSGET nFrete SIZE 90,10 OF oDlg PIXEL PICTURE PesqPict("SC5","C5_FRETE") VALID Positivo(nFrete)
	nLinDlg += nLesp
	
	@ nLinDlg,08 SAY "Especie:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,58 MSGET cEspeci1 SIZE 90,10 OF oDlg PICTURE '@!' PIXEL
	nLinDlg += nLesp
	
	IF !bTaura
		@ nLinDlg,08 SAY "Peso Liquido:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET nPsol SIZE 90,10 OF oDlg PIXEL PICTURE PesqPict("SC5","C5_PESOL") VALID Positivo(nFrete)
		nLinDlg += nLesp
		
		@ nLinDlg,08 SAY "Peso Bruto:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET nPBruto SIZE 90,10 OF oDlg PIXEL PICTURE PesqPict("SC5","C5_PBRUTO") VALID Positivo(nFrete)
		nLinDlg += nLesp
		
		@ nLinDlg,08 SAY "Volume:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET cVolume1 SIZE 90,10 OF oDlg PICTURE PesqPict("SC5","C5_VOLUME1") PIXEL
		nLinDlg += nLesp
		
		@ nLinDlg,08 SAY "Transportadora:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET cTransp SIZE 90,10 OF oDlg PICTURE PesqPict("SC5","C5_TRANSP") F3 "SA4" PIXEL
		nLinDlg += nLesp
		
		@ nLinDlg,08 SAY "Veiculo:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 MSGET cVeicul SIZE 90,10 OF oDlg PICTURE PesqPict("SC5","C5_VEICULO") F3 "DA3" PIXEL
		nLinDlg += nLesp
	EndIF
	
//	If !Empty(SC5->C5_PEDEXP)
		@ nLinDlg,08 SAY "Mens. Exp:" SIZE  50,10 OF oDlg PIXEL
		@ nLinDlg,58 GET oMultiGe1 VAR cMenExp OF oDlg MULTILINE SIZE 150,30 PIXEL VALID (LEN(cMenExp)<800)
		
		nLinDlg += 46
//	EndIf
	
	@ nLinDlg, 108 BUTTON oButton1 PROMPT "OK" SIZE 40, 10 OF oDlg ACTION {_lret:=Gravar(_lret),Iif(_lret,oDlg:End(),oDlg:Refresh())} PIXEL


ACTIVATE DIALOG oDlg CENTERED

return

// Grava o formulário na Tabela
Static Function Gravar(_lret)

lRet := U_MGFFATAL(cMenNota1,cMenNota2,cMenExp,41)

If lRet
   Reclock("SC5",.F.)
   SC5->C5_MENNOTA := cMenNota1
   SC5->C5_ZMENNOT := cMenNota2
   SC5->C5_FRETE   := nFrete
   SC5->C5_ESPECI1 := cEspeci1
   IF !bTaura
	  SC5->C5_PESOL   := nPsol
	  SC5->C5_PBRUTO  := nPBruto
	  SC5->C5_VOLUME1 := cVolume1
	  SC5->C5_TRANSP := cTransp
	  SC5->C5_VEICULO := cVeicul
  EndIF
  //If !EMPTY(SC5->C5_PEDEXP)
  SC5->C5_ZMENEXP := cMenExp
  //EndIf
  SC5->(MsUnlock())
EndIf  
	
Return lRet
