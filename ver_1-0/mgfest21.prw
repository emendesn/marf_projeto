#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSGRAPHI.CH"  


#DEFINE LINHAS 999

/*

==================================================================================
Programa............: MGFEST21
Autor...............: Marcelo Carneiro
Data................: 20/09/2016
Descricao / Objetivo: Painel de Gestão de Estoque
Doc. Origem ........: MIT044 - GAP EST16
Solicitante.........: Marfrig
Uso.................: Gestão de Estoques 
==================================================================================

*/

User Function MGFEST21(_cquery)
Local aSizeAut    := MsAdvSize(,.F.,400)
Local nCol1    := 7
Local nCol2    := 0
Local nCol3    := 0                                       
Local nCol4    := 0
Local nLin     := 04
Local  nI      := 0 

Private aRotina := {{'ok', "msgalert('ok')", 0 , 6, 0, .F.}}
Private oListPV
Private oListSA
Private cbLine  := ''
Private oDlg2    
Private oBold
Private aObjects
Private aInfo
Private aPosObj
Private aTitles := {"Estoques","SAs","Ped.Venda","Ped.Compra","Solic.Compra","Empenho"}
Private aBrowse      := {}
Private aHeader      := {"Código Material ",'Descrição','UM','Tipo','Grupo','Saldo','SAs','Ped.Venda','Ped.Compra','Solic.Compra','Empenho','Bloqueio'}
Private aTam         := {70,120,10,15,20,60,60,60,60,60,60,60} 
Private nColOrder    := 1
Private nTipoOrder   := 1
Private oBrowseDados
Private oDadosEst01
Private oDadosEst02
Private oDadosEst03
Private oDadosEst04
Private oDadosEst05
Private oDadosEst06
Private oDadosEst07
Private oDadosEst08
Private oDadosEst09
Private oDadosEst10
Private oDadosEst11
Private oDadosEst12 
Private oDadosEmp01
Private aEstCab :={"",;
                   "Filial",;
				   "Armazem",;
				   "Qtde. Disponivel",;
				   "Qtde. Empenhada",;
				   "Saldo Atual",;
				   "Qtd.Prev.Entrada",;
				   "Qtd. Ped. Venda",;
				   "Qtd. Reservada",;
				   "Qtd. de Terc.",;
				   "Qtd. em Terc.",;
				   "Saldo Poder 3.",;
				   "Qtd. Emp. NF",;
				   "Qtd. a Endereçar",;
				   "Qtd. Empenhada SA"}
Private aSumEstDados := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}		
Private aEstDados    := {}
Private oListEmp
Private aEmpCab :={"Filial",;
				   "Armazem",;
				   "OP",;
				   "Produto",;                                      
				   "Descrição",;
				   "Fam.Tec.",;
				   "Quant. Total",;
				   "Quant. Faltante",;
				   "Data OP",;
				   "Status"}
Private aEmpDados      := {{0,0,0,0,0,0,0,0,0}}
Private aPedDados      := {{0,0,0,0,0,0,0,0,0,0,0}}
Private aPVDados       := {{0,0,0,0,0,0,0,0,0,0,0}}
Private aSADados       := {{0,0,0,0,0,0,0,0,0,0,0,0,0}}
Private aPVCab :={ "",;
				   "Filial",;
				   "Armazem",;
				   "Pedido",;
				   "Cliente",;
				   "Loja",;
				   "Razão Social",;
				   "Quant. Vendida",;
				   "Saldo",;
				   "Data Entrega",;
				   "Item"}
Private aPedCab :={"",;
				   "Filial",;
				   "Armazem",;
				   "Pedido",;
				   "Fornecedor",;
				   "Loja",;
				   "Razão Social",;
				   "Quant. Original",;
				   "Saldo",;
				   "Data Entrega",;
				   "Origem"}
Private aSACab :=  {"",;
				   "Filial",;
				   "Armazem",;
				   "SA",;
				   "Item",;
				   "UM",;
				   "Solicitante",;
				   "Quant.",;
				   "V.Unitario",;
				   "V.Total",;
				   "Saldo",;
				   "Necessidade",;
				   "Observação"}
Private oDadosPed01     
Private oListPed
Private oListSolic
Private aSolicDados      := {{"",0,0,0,0,0,0,0,0,0,0}}
Private oDadosSol01     
Private aSolCab :={"",;
				   "Filial",;
				   "Armazem",;
				   "Num.Solic.",;
				   "Fornecedor",;
				   "Loja",;
				   "Razão Social",;
				   "Quant. Original",;
				   "Saldo",;
				   "Data Entrega",;
				   "Status"}
Private cFilCD  := GetMV('MGF_FILCD',.F.,"'010001','010002','010003','010005'")
Private cPerg   := 'MGFEST21'

Default _cquery:=" "  
Private __cquery:=_cquery 

If Empty(_cquery)
   If !Pergunte(cPerg,.T.)
	  lContinua	:= .F.
	  Return
   EndIf
EndIf   


DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

aObjects := {}
AAdd( aObjects, { 0,    65, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

ZeraArray()
MontaCab()
IF Len(aBrowse) = 0 
     MsgAlert('Não há dados para o filtro selecionado !')
     Return
ENDIF
DEFINE MSDIALOG oDlg2 FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Painel de Gestão de Estoque Multi Filiais"  OF oMainWnd PIXEL
                                            
oBrowseDados := TWBrowse():New( 5,aPosObj[2,2],aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-50,;
						  ,,,oDlg2, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
oBrowseDados:SetArray(aBrowse)                                    
cbLine := "{||{ aBrowse[oBrowseDados:nAt,01] "

For nI := 2 To Len(aHeader)
 cbLine += ",aBrowse[oBrowseDados:nAt,"+STRZERO(nI,2)+"]"
Next nI         
cbLine +="  } }"
oBrowseDados:bLine      := &cbLine          
oBrowseDados:bChange     := {||AtualizaBrowse()}                   
oBrowseDados:bHeaderClick  := {|oBrw,nCol| OrdenaCab(nCol,.T.)}
oBrowseDados:addColumn(TCColumn():new(aHeader[01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"  ,aTam[01],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[02],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"  ,aTam[02],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[03],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"  ,aTam[03],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[04],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"  ,aTam[04],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[05],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"RIGHT" ,aTam[05],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[06],{||aBrowse[oBrowseDados:nAt][06]},"@E 9,999,999.99",,,"RIGHT" ,aTam[06],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[07],{||aBrowse[oBrowseDados:nAt][07]},"@E 9,999,999.99",,,"RIGHT" ,aTam[07],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[08],{||aBrowse[oBrowseDados:nAt][08]},"@E 9,999,999.99",,,"RIGHT" ,aTam[08],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[09],{||aBrowse[oBrowseDados:nAt][09]},"@E 9,999,999.99",,,"RIGHT" ,aTam[09],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[10],{||aBrowse[oBrowseDados:nAt][10]},"@E 9,999,999.99",,,"RIGHT" ,aTam[10],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[11],{||aBrowse[oBrowseDados:nAt][11]},"@E 9,999,999.99",,,"RIGHT" ,aTam[11],.F.,.F.,,,,,))
oBrowseDados:addColumn(TCColumn():new(aHeader[12],{||aBrowse[oBrowseDados:nAt][12]},"@E 9,999,999.99",,,"RIGHT" ,aTam[12],.F.,.F.,,,,,))


oBrowseDados:Setfocus() 
oBtn := TButton():New( aPosObj[3,1]-45, aPosObj[3,4]-105,'Refresh'         , oDlg2,{|| EST21_Refresh() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
oBtn := TButton():New( aPosObj[3,1]-45, aPosObj[3,4]-050,'Sair'            , oDlg2,{|| oDlg2:End()}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
oFolder := TFolder():New(aPosObj[3,1]-35,aPosObj[3,2],aTitles,{"HEADER"},oDlg2,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1]+35)
oFont2:= TFont():New('Courier New',,-12,.T.)

// FOLDER ESTOQUE 
nCol1 := 7
nCol3 := 062
nCol2 := 140
nCol4 := 195
nLin := 15
																					  
@ 006,aPosObj[3,4]-65  BUTTON "Mais Informações"  SIZE 050,011  FONT oDlg2:oFont ACTION MaComView(aBrowse[oBrowseDados:nAt][01]) OF oFolder:aDialogs[1] PIXEL 
@ 006,aPosObj[3,4]-120 BUTTON "Legenda"           SIZE 050,011  FONT oDlg2:oFont ACTION EST21_Legenda(1)                         OF oFolder:aDialogs[1] PIXEL 




@ nLin   ,nCol1 SAY aEstCab[04] OF  oFolder:aDialogs[1] PIXEL 
@ nLin   ,nCol2 SAY aEstCab[05] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+13,nCol1 SAY aEstCab[06] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+13,nCol2 SAY aEstCab[07] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+26,nCol1 SAY aEstCab[08] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+26,nCol2 SAY aEstCab[09] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+39,nCol1 SAY aEstCab[10] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+39,nCol2 SAY aEstCab[11] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+52,nCol1 SAY aEstCab[12] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+52,nCol2 SAY aEstCab[13] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+65,nCol1 SAY aEstCab[14] OF  oFolder:aDialogs[1] PIXEL 
@ nLin+65,nCol2 SAY aEstCab[15] OF  oFolder:aDialogs[1] PIXEL 

@ nLin-01,nCol3 MSGET oDadosEst01 VAR aSumEstDados[01] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin-01,nCol4 MSGET oDadosEst02 VAR aSumEstDados[02] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+12,nCol3 MSGET oDadosEst03 VAR aSumEstDados[03] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+12,nCol4 MSGET oDadosEst04 VAR aSumEstDados[04] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+25,nCol3 MSGET oDadosEst05 VAR aSumEstDados[05] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+25,nCol4 MSGET oDadosEst06 VAR aSumEstDados[06] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+38,nCol3 MSGET oDadosEst07 VAR aSumEstDados[07] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+38,nCol4 MSGET oDadosEst08 VAR aSumEstDados[08] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+51,nCol3 MSGET oDadosEst09 VAR aSumEstDados[09] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+51,nCol4 MSGET oDadosEst10 VAR aSumEstDados[10] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+64,nCol3 MSGET oDadosEst11 VAR aSumEstDados[11] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009
@ nLin+64,nCol4 MSGET oDadosEst12 VAR aSumEstDados[12] PICTURE PesqPict("SB2","B2_QATU") OF oFolder:aDialogs[1] PIXEL READONLY SIZE 050,009

@ 010,250 SAY 'Saldo Analitico do Estoque' OF oFolder:aDialogs[1] PIXEL FONT oBold COLOR CLR_RED     
@ 018,250 TO 019,aPosObj[3,4]-15           OF oFolder:aDialogs[1] PIXEL


oListEst := TWBrowse():New( 021,250, aPosObj[3,4]-265,aPosObj[3,3]-aPosObj[3,1]-8 ,;
						  ,,,oFolder:aDialogs[1], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )                       
oListEst:addColumn(TCColumn():new(aEstCab[01],{||aEstDados[oListEst:nAt][01]},"@!" ,,,"LEFT" , 1,.T.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[02],{||aEstDados[oListEst:nAt][02]},"@!" ,,,"LEFT"  ,80,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[03],{||aEstDados[oListEst:nAt][03]},"@!" ,,,"LEFT"  ,30,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[04],{||aEstDados[oListEst:nAt][04]},"@!" ,,,"RIGHT" ,Len(aEstCab[04])+10,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[05],{||aEstDados[oListEst:nAt][05]},"@!" ,,,"RIGHT" ,Len(aEstCab[05])+10,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[06],{||aEstDados[oListEst:nAt][06]},"@!" ,,,"RIGHT" ,Len(aEstCab[06])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[07],{||aEstDados[oListEst:nAt][07]},"@!" ,,,"RIGHT" ,Len(aEstCab[07])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[08],{||aEstDados[oListEst:nAt][08]},"@!" ,,,"RIGHT" ,Len(aEstCab[08])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[09],{||aEstDados[oListEst:nAt][09]},"@!" ,,,"RIGHT" ,Len(aEstCab[09])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[10],{||aEstDados[oListEst:nAt][10]},"@!" ,,,"RIGHT" ,Len(aEstCab[10])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[11],{||aEstDados[oListEst:nAt][11]},"@!" ,,,"RIGHT" ,Len(aEstCab[11])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[12],{||aEstDados[oListEst:nAt][12]},"@!" ,,,"RIGHT" ,Len(aEstCab[12])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[13],{||aEstDados[oListEst:nAt][13]},"@!" ,,,"RIGHT" ,Len(aEstCab[13])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[14],{||aEstDados[oListEst:nAt][14]},"@!" ,,,"RIGHT" ,Len(aEstCab[14])+20,.F.,.F.,,,,,))
oListEst:addColumn(TCColumn():new(aEstCab[15],{||aEstDados[oListEst:nAt][15]},"@!" ,,,"RIGHT" ,Len(aEstCab[15])+20,.F.,.F.,,,,,))
oListEst:SetArray(aEstDados)                                    
oListEst:aHeaders := aEstCab        
cbLine := "{||{ aEstDados[oListEst:nAt,01] "
For nI := 2 To Len(aEstCab)
 cbLine += ",aEstDados[oListEst:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListEst:bLine := &cbLine    

//FOLDER SA

@ 003,005 SAY 'Solicitações ao Armazem' OF oFolder:aDialogs[2] PIXEL FONT oBold COLOR CLR_RED     
@ 011,005 TO 012,aPosObj[3,4]-15  OF oFolder:aDialogs[2] PIXEL

					 
cbLine := "{||{ aSADados[oListSA:nAt,01] "
For nI := 2 To Len(aSACab)
 cbLine += ",aSADados[oListSA:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          

oListSA := TWBrowse():New( 014,005, aPosObj[3,4]-15,aPosObj[3,3]-aPosObj[3,1]-10,;
							 ,,,oFolder:aDialogs[2], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )

oListSA:addColumn(TCColumn():new(aSACab[01],{||aSADados[oListPed:nAt][01]},"@!",,,"LEFT" , 1,.T.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[02],{||aSADados[oListPed:nAt][02]},"@!",,,"LEFT" , Len(aSACab[02])+60,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[03],{||aSADados[oListPed:nAt][03]},"@!",,,"LEFT" , Len(aSACab[03])+20,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[04],{||aSADados[oListPed:nAt][04]},"@!",,,"LEFT" , Len(aSACab[04])+25,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[05],{||aSADados[oListPed:nAt][05]},"@!",,,"LEFT" , Len(aSACab[05])+25,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[06],{||aSADados[oListPed:nAt][06]},"@!",,,"LEFT" , Len(aSACab[06])+25,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[07],{||aSADados[oListPed:nAt][07]},"@!",,,"LEFT" , Len(aSACab[07])+60,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[08],{||aSADados[oListPed:nAt][08]},"@!",,,"RIGHT" ,Len(aSACab[08])+30,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[09],{||aSADados[oListPed:nAt][09]},"@!",,,"RIGHT" ,Len(aSACab[09])+30,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[10],{||aSADados[oListPed:nAt][10]},"@!",,,"RIGHT" ,Len(aSACab[10])+30,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[11],{||aSADados[oListPed:nAt][11]},"@!",,,"RIGHT" ,Len(aSACab[11])+30,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[12],{||aSADados[oListPed:nAt][12]},"@!",,,"LEFT" , Len(aSACab[12])+25,.F.,.F.,,,,,))
oListSA:addColumn(TCColumn():new(aSACab[13],{||aSADados[oListPed:nAt][13]},"@!",,,"LEFT" , Len(aSACab[13])+20,.F.,.F.,,,,,))

oListSA:aHeaders := aSACab                             
oListSA:SetArray(aSADados)                  
oListSA:bLine := &cbLine                   

@ nLin+65,005 BUTTON "Legenda"          SIZE 050,011  FONT oDlg2:oFont ACTION EST21_Legenda(2) OF oFolder:aDialogs[2] PIXEL 


//FOLDER PV

@ 003,005 SAY 'Pedidos de Venda' OF oFolder:aDialogs[3] PIXEL FONT oBold COLOR CLR_RED     
@ 011,005 TO 012,aPosObj[3,4]-15  OF oFolder:aDialogs[3] PIXEL

					 
cbLine := "{||{ aPVDados[oListPV:nAt,01] "
For nI := 2 To Len(aPVCab)
 cbLine += ",aPVDados[oListPV:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          

oListPV := TWBrowse():New( 014,005, aPosObj[3,4]-15,aPosObj[3,3]-aPosObj[3,1]-10,;
							 ,,,oFolder:aDialogs[3], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )

oListPV:addColumn(TCColumn():new(aPVCab[01],{||aPVDados[oListPed:nAt][01]},"@!",,,"LEFT" , 1,.T.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[02],{||aPVDados[oListPed:nAt][02]},"@!",,,"LEFT" , Len(aPVCab[02])+60,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[03],{||aPVDados[oListPed:nAt][03]},"@!",,,"LEFT" , Len(aPVCab[03])+20,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[04],{||aPVDados[oListPed:nAt][04]},"@!",,,"LEFT" , Len(aPVCab[04])+25,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[05],{||aPVDados[oListPed:nAt][05]},"@!",,,"LEFT" , Len(aPVCab[05])+25,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[06],{||aPVDados[oListPed:nAt][06]},"@!",,,"LEFT" , Len(aPVCab[06])+25,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[07],{||aPvDados[oListPed:nAt][07]},"@!",,,"LEFT" , Len(aPVCab[07])+60,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[08],{||aPVDados[oListPed:nAt][08]},"@!",,,"RIGHT" ,Len(aPVCab[08])+30,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[09],{||aPVDados[oListPed:nAt][09]},"@!",,,"RIGHT" ,Len(aPVCab[09])+30,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[10],{||aPVDados[oListPed:nAt][10]},"@!",,,"LEFT" , Len(aPVCab[10])+25,.F.,.F.,,,,,))
oListPV:addColumn(TCColumn():new(aPVCab[11],{||aPVDados[oListPed:nAt][11]},"@!",,,"LEFT" , Len(aPVCab[11])+20,.F.,.F.,,,,,))

oListPV:aHeaders := aPVCab                             
oListPV:SetArray(aPVDados)                  
oListPV:bLine := &cbLine                   

@ nLin+65,005 BUTTON "Legenda"          SIZE 050,011  FONT oDlg2:oFont ACTION EST21_Legenda(3) OF oFolder:aDialogs[3] PIXEL 


//FOLDER PEDIDOS 

@ 003,005 SAY 'Pedidos de Compra' OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED     
@ 011,005 TO 012,aPosObj[3,4]-15  OF oFolder:aDialogs[4] PIXEL

					 
cbLine := "{||{ aPedDados[oListPed:nAt,01] "
For nI := 2 To Len(aPedCab)
 cbLine += ",aPedDados[oListPed:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          

oListPed := TWBrowse():New( 014,005, aPosObj[3,4]-15,aPosObj[3,3]-aPosObj[3,1]-10,;
							 ,,,oFolder:aDialogs[4], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )

oListPed:addColumn(TCColumn():new(aPedCab[01],{||aPedDados[oListPed:nAt][01]},"@!",,,"LEFT" , 1,.T.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[02],{||aPedDados[oListPed:nAt][02]},"@!",,,"LEFT" , Len(aPedCab[02])+60,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[03],{||aPedDados[oListPed:nAt][03]},"@!",,,"LEFT" , Len(aPedCab[03])+20,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[04],{||aPedDados[oListPed:nAt][04]},"@!",,,"LEFT" , Len(aPedCab[04])+25,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[05],{||aPedDados[oListPed:nAt][05]},"@!",,,"LEFT" , Len(aPedCab[05])+25,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[06],{||aPedDados[oListPed:nAt][06]},"@!",,,"LEFT" , Len(aPedCab[06])+25,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[07],{||aPedDados[oListPed:nAt][07]},"@!",,,"LEFT" , Len(aPedCab[07])+60,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[08],{||aPedDados[oListPed:nAt][08]},"@!",,,"RIGHT" ,Len(aPedCab[08])+30,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[09],{||aPedDados[oListPed:nAt][09]},"@!",,,"RIGHT" ,Len(aPedCab[09])+30,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[10],{||aPedDados[oListPed:nAt][10]},"@!",,,"LEFT" , Len(aPedCab[10])+25,.F.,.F.,,,,,))
oListPed:addColumn(TCColumn():new(aPedCab[11],{||aPedDados[oListPed:nAt][11]},"@!",,,"LEFT" , Len(aPedCab[11])+20,.F.,.F.,,,,,))

oListPed:aHeaders := aPedCab                             
oListPed:SetArray(aPedDados)                  
oListPed:bLine := 	&cbLine                   


@ nLin+65,005 BUTTON "Legenda"          SIZE 050,011  FONT oDlg2:oFont ACTION EST21_Legenda(4) OF oFolder:aDialogs[4] PIXEL 

//FOLDER SOLICITACOES 

@ 003,005 SAY 'Solicitações de Compra ' OF oFolder:aDialogs[5] PIXEL FONT oBold COLOR CLR_RED     
@ 011,005 TO 012,aPosObj[3,4]-15        OF oFolder:aDialogs[5] PIXEL

cbLine := "{||{ aSolicDados[oListSolic:nAt,01] "            
For nI := 2 To Len(aSolCab)
 cbLine += ",aSolicDados[oListSolic:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          

oListSolic := TWBrowse():New( 014,005, aPosObj[3,4]-15,aPosObj[3,3]-aPosObj[3,1]-10,;
							 ,,,oFolder:aDialogs[5], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
oListSolic:addColumn(TCColumn():new(aSolCab[01],{||aSolicDados[oListSolic:nAt][01]},"@!",,,"LEFT" , 1,.T.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[02],{||aSolicDados[oListSolic:nAt][02]},"@!",,,"LEFT" , Len(aSolCab[02])+60,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[03],{||aSolicDados[oListSolic:nAt][03]},"@!",,,"LEFT" , Len(aSolCab[03])+25,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[04],{||aSolicDados[oListSolic:nAt][04]},"@!",,,"LEFT" , Len(aSolCab[04])+20,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[05],{||aSolicDados[oListSolic:nAt][05]},"@!",,,"LEFT" , Len(aSolCab[05])+20,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[06],{||aSolicDados[oListSolic:nAt][06]},"@!",,,"LEFT" , Len(aSolCab[06])+20,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[07],{||aSolicDados[oListSolic:nAt][07]},"@!",,,"LEFT" , Len(aSolCab[07])+50,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[08],{||aSolicDados[oListSolic:nAt][08]},"@!",,,"RIGHT" ,Len(aSolCab[08])+30,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[09],{||aSolicDados[oListSolic:nAt][09]},"@!",,,"RIGHT" ,Len(aSolCab[09])+30,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[10],{||aSolicDados[oListSolic:nAt][10]},"@!",,,"LEFT" , Len(aSolCab[10])+25,.F.,.F.,,,,,))
oListSolic:addColumn(TCColumn():new(aSolCab[11],{||aSolicDados[oListSolic:nAt][11]},"@!",,,"LEFT" , Len(aSolCab[11])+20,.F.,.F.,,,,,)) 
oListSolic:aHeaders := aSolCab
oListSolic:SetArray(aSolicDados)                  
oListSolic:bLine := 	&cbLine                   

@ nLin+65,005 BUTTON "Legenda"     SIZE 050,011  FONT oDlg2:oFont ACTION EST21_Legenda(5) OF oFolder:aDialogs[5] PIXEL 

//FOLDER EMPENHO
@ 003,005 SAY 'Empenhos '        OF oFolder:aDialogs[6] PIXEL FONT oBold COLOR CLR_RED     
@ 011,005 TO 012,aPosObj[3,4]-15 OF oFolder:aDialogs[6] PIXEL

					 
oListEmp := TWBrowse():New( 014,005, aPosObj[3,4]-15,aPosObj[3,3]-aPosObj[3,1]-10,;
							 ,,,oFolder:aDialogs[6], , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
oListEmp:addColumn(TCColumn():new(aEmpCab[01],{||aEmpDados[oListEmp:nAt][01]},"@!",,,"LEFT"  ,TamSx3("D4_FILIAL")[01]+60 ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[02],{||aEmpDados[oListEmp:nAt][02]},"@!",,,"LEFT"  ,Len(aEmpCab[02])+25 ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[03],{||aEmpDados[oListEmp:nAt][03]},"@!",,,"LEFT"  ,TamSx3("D4_OP")[01]+25     ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[04],{||aEmpDados[oListEmp:nAt][04]},"@!",,,"LEFT"  ,TamSx3("B1_COD")[01]+40    ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[05],{||aEmpDados[oListEmp:nAt][05]},"@!",,,"LEFT"  ,TamSx3("B1_DESC")[01]+50   ,.F.,.F.,,,,,)) //
oListEmp:addColumn(TCColumn():new(aEmpCab[06],{||aEmpDados[oListEmp:nAt][06]},"@!",,,"LEFT"  ,TamSx3("B1_COD")[01]+20 ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[07],{||aEmpDados[oListEmp:nAt][07]},"@!",,,"RIGHT" ,TamSx3("B1_COD")[01]+30    ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[08],{||aEmpDados[oListEmp:nAt][08]},"@!",,,"RIGHT" ,TamSx3("B1_COD")[01]+30    ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[09],{||aEmpDados[oListEmp:nAt][09]},"@!",,,"LEFT"  ,TamSx3("D4_DATA")[01]+30    ,.F.,.F.,,,,,))
oListEmp:addColumn(TCColumn():new(aEmpCab[10],{||aEmpDados[oListEmp:nAt][10]},"@!",,,"LEFT"  ,Len(aEmpCab[10])+20,.F.,.F.,,,,,))
oListEmp:aHeaders := aEmpCab                            
oListEmp:SetArray(aEmpDados)                  
cbLine := "{||{ aEmpDados[oListEmp:nAt,01] "
For nI := 2 To Len(aEmpCab)
 cbLine += ",aEmpDados[oListEmp:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListEmp:bLine := 	&cbLine

ACTIVATE MSDIALOG oDlg2 

Return 
******************************************************************************************************************************
Static Function MontaCab()            

Local cQuery      := ""
Local aReg        := {}                    
				 
// Selecionando os Produtos 
cQuery  := "SELECT B1_COD, "
cQuery  +="        B1_DESC,"	
cQuery  +="        B1_TIPO,"       
cQuery  +="        B1_GRUPO,"       
cQuery  +="        B1_UM,  "
cQuery  +="       to_number(trim( ( Select SUM(SB2.B2_QATU) "
cQuery  +="  	     From "+RetSqlName("SB2")+"  SB2"
cQuery  +="			 Where SB2.B2_STATUS   <> '2' "
cQuery  +="			 AND SB2.B2_COD      =  B1_COD "

If Empty(__cquery)
   cQuery  += "         AND B2_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND B2_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND B2_FILIAL >= '' "          
   cQuery  += "         AND B2_FILIAL <= 'ZZ' "
EndIf
             
cQuery  +="		     AND SB2.D_E_L_E_T_  = ' ' ) ))As SALDO,"
cQuery  +="        ( Select SUM(SB2.B2_QATU) "
cQuery  +="  	     From "+RetSqlName("SB2")+"  SB2"
cQuery  +="			 Where SB2.B2_STATUS   <> '2' "

If Empty(__cquery)
   cQuery  += "         AND B2_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND B2_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND B2_FILIAL >= '' "          
   cQuery  += "         AND B2_FILIAL <= 'ZZ' "
EndIf             
cQuery  +="			 AND SB2.B2_COD      =  B1_COD "
cQuery  +="			 AND '"+DTOS(dDatabase)+"' BETWEEN B2_DTINV AND B2_DINVFIM"
cQuery  +="		     AND SB2.D_E_L_E_T_  = ' ' ) As BLOQUEIO,"
cQuery  +="       to_number(trim( ( Select SUM(SD4.D4_QUANT)"
cQuery += "          From "+RetSqlName("SD4")+" SD4, "+RetSqlName("SC2")+" SC2 "
cQuery += "          Where SD4.D4_FILIAL  = SC2.C2_FILIAL "
cQuery += "                 AND SD4.D4_OP      =  SC2.C2_NUM+ SC2.C2_ITEM+ SC2.C2_SEQUEN"
cQuery  +="		            AND SC2.D_E_L_E_T_  = ' ' "

If Empty(__cquery) 
   cQuery  += "                AND D4_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "                AND D4_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "                AND D4_FILIAL >= '' "          
   cQuery  += "                AND D4_FILIAL <= 'ZZ' "
EndIf
             
cQuery  +="		            AND SD4.D4_COD      = B1_COD  "
cQuery  +="		            AND SD4.D_E_L_E_T_  = ' ' ) ))As EMPENHO, "
cQuery  +="        to_number(trim(( Select SUM(SCP.CP_QUANT - SCP.CP_QUJE)"
cQuery  +="	         From "+RetSqlName("SCP")+"  SCP"
cQuery  +="		     Where SCP.CP_PRODUTO    = B1_COD  "

If Empty(__cquery)
   cQuery  += "         AND CP_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND CP_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND CP_FILIAL >= '' "          
   cQuery  += "         AND CP_FILIAL <= 'ZZ' "
EndIf             
cQuery  +="		     AND SCP.D_E_L_E_T_  = ' ' "
cQuery  +="		     AND SCP.CP_QUJE       < SCP.CP_QUANT ))) As SARMAZEN , "
cQuery  +="       to_number(trim( ( Select SUM( CASE WHEN C6_BLQ='R' THEN 0 ELSE SC6.C6_QTDVEN - SC6.C6_QTDENT END)"
cQuery  +="	         From "+RetSqlName("SC6")+"  SC6,"+RetSqlName("SF4")+"  SF4"
cQuery  +="		     Where SC6.C6_PRODUTO    = B1_COD  "
cQuery += "          AND C6_TES = F4_CODIGO"

If Empty(__cquery) 
   cQuery  += "         AND C6_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND C6_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND C6_FILIAL  >= '' "          
   cQuery  += "         AND C6_FILIAL <= 'ZZ' "
Endif

cQuery += "          AND F4_ESTOQUE='S' "   
cQuery  +="		     AND SC6.D_E_L_E_T_  = ' ' "
cQuery  +="		     AND SF4.D_E_L_E_T_  = ' ' "

	cQuery  += "  AND C6_NOTA	=	'         '"
	cQuery  += "  AND C6_BLQ	<>	'R'"

	dDataMin		:= CTOD("  /  /  ")
	dDataMax		:= CTOD("  /  /  ")    

	if empty( dDataMin )
		dDataMin := ( dDataBase - 10000 )
	endif

	if empty( dDataMax )
		dDataMax := ( dDataBase + 10000 )
	endif

	cQuery  += " AND"
	cQuery  += "     ("
	cQuery  += "         SC6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
	cQuery  += "         OR"
	cQuery  += "         SC6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
	cQuery  += "     )"



cQuery  +="		     ))) As PV , "
//cQuery  +="		     AND C6_QTDENT < C6_QTDVEN    ) As PV , "


cQuery  +="       to_number(trim( ( Select SUM(SC7.C7_QUANT - SC7.C7_QUJE)"
cQuery  +="	         From "+RetSqlName("SC7")+"  SC7"
cQuery  +="		     Where SC7.C7_PRODUTO    = B1_COD  "
cQuery  +="		     AND C7_RESIDUO = ' '  "

If Empty(__cquery) 
   cQuery  += "         AND C7_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND C7_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND C7_FILIAL  >= '' "          
   cQuery  += "         AND C7_FILIAL <= 'ZZ' "
EndIf             
cQuery  +="		     AND SC7.D_E_L_E_T_  = ' ' "
cQuery  +="		     AND SC7.C7_QUJE       < SC7.C7_QUANT ))) As PEDIDO , "
cQuery  +="        to_number(trim(( Select SUM(SC1.C1_QUANT - SC1.C1_QUJE)"
cQuery  +="	         From "+RetSqlName("SC1")+" SC1"
cQuery  +="		     Where SC1.C1_PRODUTO    = B1_COD  "
cQuery  +="		     AND C1_RESIDUO = ' '  "

If Empty(__cquery)
   cQuery  += "         AND C1_FILIAL >= '"+MV_PAR07+"' "          
   cQuery  += "         AND C1_FILIAL <= '"+MV_PAR08+"' "
Else
   cQuery  += "         AND C1_FILIAL  >= '' "          
   cQuery  += "         AND C1_FILIAL <= 'ZZ' "
EndIf             
cQuery  +="		     AND SC1.D_E_L_E_T_  = ' ' "
cQuery  +="		     AND SC1.C1_QUJE       < SC1.C1_QUANT ))) As SOLICITACAO "
cQuery  += "FROM "+RetSqlName("SB1")
cQuery  += "  WHERE B1_FILIAL='"+xFilial("SB1")+"'"
cQuery  += "  AND D_E_L_E_T_ = ' ' "

If !Empty(__cquery) 
   cQuery  += "  AND ("+__cquery+")"
   cQuery  += "  AND B1_GRUPO >= '' "          
   cQuery  += "  AND B1_GRUPO <= 'ZZZZZZ' "
   cQuery  += "  AND B1_TIPO >= '' "          
   cQuery  += "  AND B1_TIPO <= 'ZZZZZZZZZZ' "
 Else         
   cQuery  += "  AND B1_COD >= '"+MV_PAR01+"' "          
   cQuery  += "  AND B1_COD <= '"+MV_PAR02+"' "          
   cQuery  += "  AND B1_GRUPO >= '"+MV_PAR03+"' "          
   cQuery  += "  AND B1_GRUPO <= '"+MV_PAR04+"' "
   cQuery  += "  AND B1_TIPO >= '"+MV_PAR05+"' "          
   cQuery  += "  AND B1_TIPO <= '"+MV_PAR06+"' "          
   cQuery  += "  ORDER BY B1_COD"          
EndIf

If Select("SLD_CAB") > 0
	SLD_CAB->(dbCloseArea())
EndIf

//Memowrite("C:\TEMP\MGFest21.sql",cQuery)

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLD_CAB",.T.,.F.)
dbSelectArea("SLD_CAB")    

aBrowse    := {}

SLD_CAB->(dbGoTop())
While SLD_CAB->(!Eof())   
	aReg := {}
	AADD(aReg,SLD_CAB->B1_COD)
	AADD(aReg,SLD_CAB->B1_DESC) 
	AADD(aReg,SLD_CAB->B1_UM)
	AADD(aReg,SLD_CAB->B1_TIPO)
    AADD(aReg,SLD_CAB->B1_GRUPO)
    AADD(aReg,SLD_CAB->SALDO)
	AADD(aReg,SLD_CAB->SARMAZEN)
	AADD(aReg,SLD_CAB->PV)
	AADD(aReg,SLD_CAB->PEDIDO)
	AADD(aReg,SLD_CAB->SOLICITACAO)
	AADD(aReg,SLD_CAB->EMPENHO)
	AADD(aReg,SLD_CAB->BLOQUEIO)
	AADD(aBrowse,aReg)    
	SLD_CAB->(dbSKIP())     
END 

RETURN

********************************************************************************************************
Static Function OrdenaCab(nCol,bMudaOrder)
Local aOrdena := {}       
Local aTotal  := {}
				   
aOrdena := AClone(aBrowse)                                         
IF nTipoOrder == 1                              
   IF bMudaOrder
        nTipoOrder := 2
   ENDIF                                                           
   aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] < y[nCol]})                    
Else              
   IF bMudaOrder
        nTipoOrder := 1
   ENDIF                                                                                               
   aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] > y[nCol]})                    
ENDIF     
aBrowse    := aOrdena
nColOrder  := nCol
oBrowseDados:DrawSelect()
oBrowseDados:Refresh()          
AtualizaBrowse()

Return
******************************************************************************************************************************
Static Function EST21_Refresh
Local cCodMat  :=''
Local nI       := 0

If !Pergunte(cPerg,.T.)
	lContinua	:= .F.
	Return
EndIf
MontaCab()
oBrowseDados:SetArray(aBrowse)                                    
cbLine := "{||{ aBrowse[oBrowseDados:nAt,01] "
For nI := 2 To Len(aHeader)
 cbLine += ",aBrowse[oBrowseDados:nAt,"+STRZERO(nI,2)+"]"
Next nI         
cbLine +="  } }"
oBrowseDados:bLine      := &cbLine          
oBrowseDados:DrawSelect()
oBrowseDados:Refresh()   
oBrowseDados:SetFocus()     

AtualizaBrowse()


RETURN

*********************************************************************************************************************************
Static Function AtualizaBrowse

ZeraArray()

AtualizaEst(aBrowse[oBrowseDados:nAt][01])
AtualizaSolic()
AtualizaPedido()
AtualizaEmpenho()        
AtualizaPV()
AtualizaSA()

oBrowseDados:SetFocus()

Return
****************************************************************************************************************
Static Function AtualizaEst(cProdEst)

Local cQuery      := ""
Local nI          := 0 

Local aBrancos    := {}    
Local nSaldo      := 0              
Local nB2_QATU    := 0
Local nB2_QPEDVEN := 0
Local nB2_QEMP    := 0
Local nB2_SALPEDI := 0
Local nB2_QEMPSA  := 0
Local nB2_RESERVA := 0
Local nB2_QTNP    := 0
Local nB2_QNPT    := 0
Local nB2_QTER    := 0
Local nB2_QEMPN   := 0
Local nB2_QACLASS := 0
Local nB2_QPRJ 	  := 0
Local nB2_QPRE 	  := 0         
Local aReg        :={}
Local oVerde  	  := LoadBitmap(GetResources(),'BR_VERDE') 
Local oRed    	  := LoadBitmap(GetResources(),'BR_VERMELHO') 

aEstDados      := {}
aSumEstDados   := {}

cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SB2")
cQuery += " WHERE B2_COD='"+cProdEst+"'"
cQuery += " AND B2_STATUS  <> '2' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND B2_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND B2_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY B2_FILIAL,B2_LOCAL "        

If Select("EST") > 0
	EST->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EST",.T.,.F.)
dbSelectArea("EST")
EST->(dbGoTop())
While EST->(!Eof())   
	aReg        :={}                  
	nB2_QATU    += EST->B2_QATU      //Disponivel
	nB2_QEMP    += EST->B2_QEMP      //Empenhada
	nSaldo      += SaldoSB2(,,,,,"EST")  // Saldo Atual
	nB2_SALPEDI += EST->B2_SALPEDI   //"Qtd. Entrada Prevista"
	nB2_QPEDVEN += EST->B2_QPEDVEN   //"Qtd. Pedido de Vendas  "
	nB2_RESERVA += EST->B2_RESERVA   //"Qtd. Reservada  "
	nB2_QTNP    += EST->B2_QTNP      // de terc
	nB2_QNPT    += EST->B2_QNPT      // em Terc
	nB2_QTER    += EST->B2_QTER      // Saldo terc
	nB2_QEMPN   += EST->B2_QEMPN     // Quant Emp NF
	nB2_QACLASS += EST->B2_QACLASS   // Qtd a Classificar
	nB2_QEMPSA  += EST->B2_QEMPSA    //"Qtd. Empenhada S.A."   
	//
	cFilial :=  EST->B2_FILIAL 
	IF !Empty(EST->B2_DTINV) .And. !Empty(EST->B2_DINVFIM) .And. DTOS(dDatabase)>= EST->B2_DTINV   .AND.  DTOS(dDatabase) <= EST->B2_DINVFIM 
		AADD(aReg , oRed )
	Else                  
	    AADD(aReg , oVerde )
	EndIF
	
	AADD(aReg , EST->B2_FILIAL+'-'+Alltrim(FWFilialName(,EST->B2_FILIAL)))
	AADD(aReg , EST->B2_LOCAL)
	AADD(aReg , TRANSFORM(EST->B2_QATU,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QEMP,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(SaldoSB2(,,,,,"EST"),"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_SALPEDI,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QPEDVEN,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_RESERVA,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QTNP,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QNPT,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QTER,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QEMPN,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QACLASS,"@E 99,999,999.99  "))
	AADD(aReg , TRANSFORM(EST->B2_QEMPSA,"@E 99,999,999.99  "))
	AADD(aEstDados ,aReg )
	EST->(dbSkip())
END

Aadd(aSumEstDados, nB2_QATU)
AADD(aSumEstDados, nB2_QEMP)
AADD(aSumEstDados, nSaldo)
AADD(aSumEstDados, nB2_SALPEDI)
AADD(aSumEstDados, nB2_QPEDVEN)
AADD(aSumEstDados, nB2_RESERVA)
AADD(aSumEstDados, nB2_QTNP)
AADD(aSumEstDados, nB2_QNPT)
AADD(aSumEstDados, nB2_QTER)
AADD(aSumEstDados, nB2_QEMPN)
AADD(aSumEstDados, nB2_QACLASS)
AADD(aSumEstDados, nB2_QEMPSA)
IF LEN(aEstDados)==0
	aBrancos := {}
	For nI := 1 To Len(aEstCab)
		AADD(aBrancos,' ')
	Next
	AADD(aEstDados,aBrancos)
ENDIF

oListEst:SetArray(aEstDados)                                    
cbLine := "{||{ aEstDados[oListEst:nAt,01] "
For nI := 2 To Len(aEstCab)
 cbLine += ",aEstDados[oListEst:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListEst:bLine := &cbLine                
oListEst:DrawSelect()
oListEst:Refresh()   
oDadosEst01:Setfocus() 
oDadosEst01:Refresh() 

	   

Return 

****************************************************************************************************************
Static Function AtualizaEmpenho

Local cQuery      := ""
Local nTotal      := 0 
Local cProdutoMae := ''             
Local  nI         := 0 

aEmpDados      := {}
cQuery := " SELECT D4_OP,D4_FILIAL,D4_LOCAL,D4_QTDEORI,D4_QUANT,C2_DATPRF,C2_TPOP "
cQuery += " FROM "+RetSqlName("SD4")+" SD4, "+RetSqlName("SC2")+"  SC2 "
cQuery += " WHERE SD4.D4_COD='"+aBrowse[oBrowseDados:nAt][01]+"'"
cQuery += " AND SD4.D4_FILIAL  = SC2.C2_FILIAL "
cQuery += " AND SD4.D4_OP      =  SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN"
cQuery += " AND SD4.D4_QUANT   > 0 "
cQuery += " AND SD4.D_E_L_E_T_ <> '*' " 
cQuery += " AND SC2.D_E_L_E_T_ <> '*' "
cQuery += " AND D4_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND D4_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY SC2.C2_DATPRF "        

If Select("EMP") > 0
	EMP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EMP",.T.,.F.)
dbSelectArea("EMP")
EMP->(dbGoTop())
While EMP->(!Eof())   
	aReg        :={}                  
	AADD(aReg , EMP->D4_FILIAL+'-'+Alltrim(FWFilialName(,EMP->D4_FILIAL)))
	AADD(aReg , EMP->D4_LOCAL)
	AADD(aReg , EMP->D4_OP)                  
	//Produto da OP Mãe
	cProdutoMae := GetAdvFVal("SC2","C2_PRODUTO",EMP->D4_FILIAL+EMP->D4_OP,1,"") 
	AADD(aReg , cProdutoMae)
	AADD(aReg , GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cProdutoMae,1,"") )
	AADD(aReg , GetAdvFVal("SB5","B5_CDFATD",xFilial("SB5")+cProdutoMae,1,"") )
	AADD(aReg , TRANSFORM(EMP->D4_QTDEORI,"@E 9,999,999.99  "))
	AADD(aReg , TRANSFORM(EMP->D4_QUANT,"@E 9,999,999.99  "))
	AADD(aReg , STOD(EMP->C2_DATPRF))
	AADD(aReg , IIF(EMP->C2_TPOP=="P","Prevista","Firme"))
	AADD(aEmpDados ,aReg )
	EMP->(dbSkip())
END

IF LEN(aEMPDados)==0
	aBrancos := {}
	For nI := 1 To Len(aEMPCab)
		AADD(aBrancos,' ')
	Next
	AADD(aEMPDados,aBrancos)
ENDIF

oListEmp:SetArray(aEmpDados)                  
cbLine := "{||{ aEmpDados[oListEmp:nAt,01] "
For nI := 2 To Len(aEmpCab)
 cbLine += ",aEmpDados[oListEmp:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListEmp:bLine := 	&cbLine
oListEmp:DrawSelect()
oListEmp:Refresh()   


Return 
****************************************************************************************************************
Static Function AtualizaPedido
Local cQuery  := ""
Local  nI     := 0 
Local oVerde  := LoadBitmap(GetResources(),'BR_VERDE') 
Local oCinza  := LoadBitmap(GetResources(),'BR_CINZA') 
Local oRed    := LoadBitmap(GetResources(),'BR_VERMELHO') 


aPedDados      := {}
cQuery := " SELECT C7_TPOP,SC7.R_E_C_N_O_ As C7_REC_WT, C7_ITEM,C7_FILIAL,C7_CONAPRO,C7_FILENT, A2_NOME, C7_LOCAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_QUANT,C7_QUJE, C7_DATPRF,C7_TIPO "
cQuery += " FROM "+RetSqlName("SC7")+"  SC7, "+RetSqlName("SA2")+"  SA2 "
cQuery += " WHERE SC7.C7_PRODUTO='"+aBrowse[oBrowseDados:nAt][01]+"'"
cQuery += " AND SC7.C7_FORNECE = SA2.A2_COD"
cQuery += " AND SC7.C7_LOJA    = SA2.A2_LOJA"
cQuery += " AND SC7.C7_QUJE    < SC7.C7_QUANT "
cQuery += " AND SC7.C7_RESIDUO = ' ' " 
cQuery += " AND SC7.D_E_L_E_T_ <> '*' " 
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " AND C7_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND C7_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY SC7.C7_DATPRF "        

If Select("PED") > 0
	PED->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PED",.T.,.F.)
dbSelectArea("PED")
PED->(dbGoTop())
While PED->(!Eof())   
	aReg        :={}         
	IF PED->C7_TPOP=="P"
	    AADD(aReg , oRed)
	ELSEIF PED->C7_CONAPRO=="B"
		AADD(aReg , oCinza)
	Else                   
		AADD(aReg , oVerde)
	ENDIF         
	AADD(aReg , PED->C7_FILIAL+'-'+Alltrim(FWFilialName(,PED->C7_FILIAL)))
	AADD(aReg , PED->C7_LOCAL) 
	AADD(aReg , PED->C7_NUM)
	AADD(aReg , PED->C7_FORNECE)
	AADD(aReg , PED->C7_LOJA)
	AADD(aReg , PED->A2_NOME )
	AADD(aReg , TRANSFORM(PED->C7_QUANT,"@E 9,999,999.99  "))
	AADD(aReg , TRANSFORM(PED->C7_QUANT - PED->C7_QUJE,"@E 9,999,999.99  "))
	AADD(aReg , STOD(PED->C7_DATPRF))
	IF PED->C7_TPOP=="P"
	    AADD(aReg , IIF(PED->C7_TIPO==1,"Pedido","A/E Prevista"))
	ELSE
	    AADD(aReg , IIF(PED->C7_TIPO==1,"Pedido","A/E Firme"))
	ENDIF
	AADD(aReg , PED->C7_FILIAL) 
	AADD(aReg , PED->C7_ITEM)  
	AADD(aReg , PED->C7_REC_WT)
	//AADD(aReg , IIF(PED->C7_TPOP=="P",'Prevista','Firme'))
	AADD(aPedDados ,aReg )
	PED->(dbSkip())
END

IF LEN(aPedDados)==0
	aBrancos := {}
	For nI := 1 To Len(aPedCab)
		AADD(aBrancos,' ')
	Next
	AADD(aPedDados,aBrancos)
ENDIF

cbLine := "{||{ aPedDados[oListPed:nAt,01] "
For nI := 2 To Len(aPedCab)
 cbLine += ",aPedDados[oListPed:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListPed:SetArray(aPedDados)                  
oListPed:bLine := 	&cbLine                   
oListPed:DrawSelect()
oListPed:Refresh()   

Return 
****************************************************************************************************************
Static Function AtualizaPV
Local cQuery  := ""
Local  nI     := 0 
Local oVerde  := LoadBitmap(GetResources(),'BR_VERDE') 
Local oCinza  := LoadBitmap(GetResources(),'BR_CINZA') 
Local oRed    := LoadBitmap(GetResources(),'BR_VERMELHO') 
Local oAmarelo:= LoadBitmap(GetResources(),'BR_AMARELO')


aPVDados      := {}
cQuery := " Select  C5_NOTA, C5_BLQ, C5_LIBEROK,C6_FILIAL, C6_NUM, C6_LOCAL, C6_BLQ, A1_COD, A1_LOJA, A1_NOME, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_ITEM, C6_TES "
cQuery += " FROM "+RetSqlName("SC6")+"  SC6, "+RetSqlName("SC5")+"  SC5, "+RetSqlName("SA1")+"  SA1, "+RetSqlName("SF4")+"  SF4 "
cQuery += " WHERE C6_PRODUTO='"+aBrowse[oBrowseDados:nAt][01]+"'"
cQuery += " AND SC5.C5_NUM = C6_NUM"
cQuery += " AND C5_FILIAL = C6_FILIAL"
cQuery += " AND C5_CLIENTE = A1_COD"
cQuery += " AND C5_LOJACLI = A1_LOJA" 
cQuery += " AND C6_TES = F4_CODIGO" 
cQuery += " AND F4_ESTOQUE='S'"   
cQuery += " AND C6_QTDENT < C6_QTDVEN "
cQuery += " AND SC5.D_E_L_E_T_ <> '*' " 
cQuery += " AND SC6.D_E_L_E_T_ <> '*' " 
cQuery += " AND SF4.D_E_L_E_T_ <> '*' " 
cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
cQuery += " AND C6_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND C6_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY C6_NUM "        

If Select("PED") > 0
	PED->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PED",.T.,.F.)
dbSelectArea("PED")
PED->(dbGoTop())
While PED->(!Eof())
	IF PED->C5_BLQ <> 'R'
		aReg        :={}
		IF Empty(PED->C5_LIBEROK).And.Empty(PED->C5_NOTA) .And. Empty(PED->C5_BLQ)
			AADD(aReg , oVerde)
		ELSEIF !Empty(PED->C5_NOTA) .Or. PED->C5_LIBEROK=='E' .And. Empty(PED->C5_BLQ)
			AADD(aReg , oRed)
		ELSEIF !Empty(PED->C5_LIBEROK) .And. Empty(PED->C5_NOTA) .And. Empty(PED->C5_BLQ)
			AADD(aReg , oAmarelo )
		ELSEIF PED->C5_BLQ == '1' .OR. PED->C5_BLQ == '2'
			AADD(aReg , oCinza)
		ELSE
			AADD(aReg , oVerde)
		ENDIF
		AADD(aReg , PED->C6_FILIAL+'-'+Alltrim(FWFilialName(,PED->C6_FILIAL)))
		AADD(aReg , PED->C6_LOCAL)
		AADD(aReg , PED->C6_NUM)
		AADD(aReg , PED->A1_COD)
		AADD(aReg , PED->A1_LOJA)
		AADD(aReg , PED->A1_NOME )
		AADD(aReg , TRANSFORM(PED->C6_QTDVEN,"@E 9,999,999.99  "))
		AADD(aReg , TRANSFORM(PED->C6_QTDVEN - PED->C6_QTDENT,"@E 9,999,999.99  "))
		AADD(aReg , STOD(PED->C6_ENTREG))
		AADD(aReg , PED->C6_ITEM)
		AADD(aPVDados ,aReg )
	EndIF
	PED->(dbSkip())
END

IF LEN(aPVDados)==0
	aBrancos := {}
	For nI := 1 To Len(aPVCab)
		AADD(aBrancos,' ')
	Next
	AADD(aPVDados,aBrancos)
ENDIF

cbLine := "{||{ aPVDados[oListPV:nAt,01] "
For nI := 2 To Len(aPedCab)
 cbLine += ",aPVDados[oListPV:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListPV:SetArray(aPVDados)                  
oListPV:bLine := 	&cbLine                   
oListPV:DrawSelect()
oListPV:Refresh()   

Return 
****************************************************************************************************************
Static Function AtualizaSA
Local cQuery  := ""
Local  nI     := 0 
Local oVerde  := LoadBitmap(GetResources(),'BR_VERDE') 
Local oCinza  := LoadBitmap(GetResources(),'BR_CINZA') 
Local oRed    := LoadBitmap(GetResources(),'BR_VERMELHO') 
Local oAmarelo:= LoadBitmap(GetResources(),'BR_AMARELO')


aSADados      := {}
cQuery := " Select * "
cQuery += " FROM "+RetSqlName("SCP")+"  SCP "
cQuery += " WHERE CP_PRODUTO='"+aBrowse[oBrowseDados:nAt][01]+"'"
cQuery += " AND CP_QUJE < CP_QUANT "
cQuery += " AND SCP.D_E_L_E_T_ <> '*' " 
cQuery += " AND CP_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND CP_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY CP_NUM, CP_ITEM "        

If Select("QRYSA") > 0
	QRYSA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSA",.T.,.F.)
dbSelectArea("QRYSA")
QRYSA->(dbGoTop())
While QRYSA->(!Eof())
	aReg        :={}
	IF !Empty(QRYSA->CP_PREREQU) .And. QRYSA->CP_STATSA <> 'B'  
		AADD(aReg , oRed)
	ELSEIF Empty(QRYSA->CP_PREREQU) .And. QRYSA->CP_STATSA <> 'B'  
		AADD(aReg , oVerde)
	ELSEIF QRYSA->CP_STATSA == 'B'  
		AADD(aReg , oCinza)
	ELSE
		AADD(aReg , oVerde)
	ENDIF
	AADD(aReg , QRYSA->CP_FILIAL+'-'+Alltrim(FWFilialName(,QRYSA->CP_FILIAL)))
	AADD(aReg , QRYSA->CP_LOCAL)
	AADD(aReg , QRYSA->CP_NUM)
	AADD(aReg , QRYSA->CP_ITEM)
	AADD(aReg , QRYSA->CP_UM) 
	AADD(aReg , UsrFullName(QRYSA->CP_CODSOLI)) //QRYSA->CP_SOLICIT)
	AADD(aReg , TRANSFORM(QRYSA->CP_QUANT,"@E 9,999,999.99  "))
	AADD(aReg , TRANSFORM(QRYSA->CP_VUNIT,"@E 999,999,999.99"))
	AADD(aReg , TRANSFORM(QRYSA->CP_QUANT*QRYSA->CP_VUNIT,"@E 999,999,999.99  "))
	AADD(aReg , TRANSFORM(QRYSA->CP_QUANT - QRYSA->CP_QUJE,"@E 9,999,999.99  "))
	AADD(aReg , STOD(QRYSA->CP_DATPRF))
    AADD(aReg , QRYSA->CP_OBS )
	AADD(aSADados ,aReg )
	QRYSA->(dbSkip())
END


IF LEN(aSADados)==0
	aBrancos := {}
	For nI := 1 To Len(aSACab)
		AADD(aBrancos,' ')
	Next
	AADD(aSADados,aBrancos)
ENDIF

cbLine := "{||{ aSADados[oListSA:nAt,01] "
For nI := 2 To Len(aSACab)
 cbLine += ",aSADados[oListSA:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListSA:SetArray(aSADados)                  
oListSA:bLine := &cbLine                   
oListSA:DrawSelect()
oListSA:Refresh()   

Return 
**************************************************************************************************************************************
Static Function EST21_Legenda(nTipo)
Local aLegenda      := {}                        
Local cTexto        := ''
Local cParBloqueio  := 'Bloqueio por '+Alltrim(Str(GetMV('MGF_EST18A',.F.,90)))+' dias sem movimentação'

IF nTipo == 1 //Estoque
    cTexto := 'Estoque'
	aLegenda := { {"BR_VERDE"    ,"Disponível para Uso"},;
				  {"BR_VERMELHO" ,cParBloqueio}}
ENDIF

IF nTipo == 2 // Solicitação Armazem
   cTexto := 'Solic. Armazem'
   aLegenda := {{"BR_VERDE"    ,"Pendente"},;
                {"BR_VERMELHO" ,"Gerada Pré Requisição"},;
				{'BR_CINZA'    ,"Bloqueado"} }
EndIF

IF nTipo == 3 // Pedido de Venda
   cTexto := 'Pedido Venda'
   aLegenda := {{"BR_VERDE"    ,"Pedido em Aberto"},;
                {"BR_VERMELHO" ,"Pedido Encerrado"},;
                {"BR_AMARELO"  ,"Pedido Liberado"},;
				{'BR_CINZA'    ,"Bloqueado"} }
EndIF

IF nTipo == 4 // Pedido de Compra
   cTexto := 'Pedido Compra'
   aLegenda := {{"BR_VERDE"    ,"Pedido ou A/E liberado"},;
                {"BR_VERMELHO" ,"A/E Prevista"},;
				{'BR_CINZA'    ,"Aguardando Aprovação Compra "} }
EndIF

IF nTipo == 5 //Solicitação de Compra
    cTexto := 'Solic. Compra'
	aLegenda := { {"BR_VERDE"   ,"Solicitação em Aberto"},;
					{'BR_LARANJA' ,"Solicitação Rejeitada"},;
					{'BR_CINZA'   ,"Solicitação Bloqueada"},;
					{'BR_AMARELO' ,"Solicitação com Pedido Colocado Parcial"},;
					{'BR_AZUL'    ,"Solicitação em Processo de Cotação"}}
					
ENDIF

BrwLegenda( 'Painel de Gestão - '+cTexto, 'Legenda', aLegenda  ) 

Return(.T.)                     

**************************************************************************************************************************************
Static Function AtualizaSolic

Local cQuery   := ""
Local  nI      := 0 
Local oVerde   := LoadBitmap(GetResources(),'BR_VERDE') 
Local oCinza   := LoadBitmap(GetResources(),'BR_CINZA') 
Local oLaranja := LoadBitmap(GetResources(),'BR_LARANJA') 
Local oAmarelo := LoadBitmap(GetResources(),'BR_AMARELO') 
Local oAzul    := LoadBitmap(GetResources(),'BR_AZUL')    

aSolicDados      := {}
cQuery := " SELECT C1_FILIAL,C1_TPOP,C1_FILENT, C1_COTACAO, C1_LOCAL,C1_NUM,C1_FORNECE,C1_LOJA,C1_APROV,C1_QUANT,C1_QUJE, C1_DATPRF,C1_TIPO "
cQuery += " FROM "+RetSqlName("SC1")+"  SC1"
cQuery += " WHERE SC1.C1_PRODUTO='"+aBrowse[oBrowseDados:nAt][01]+"'"
cQuery += " AND SC1.C1_QUJE    < SC1.C1_QUANT "
cQuery += " AND SC1.C1_RESIDUO = ' ' " 
cQuery += " AND SC1.D_E_L_E_T_ <> '*' " 
cQuery += " AND C1_FILIAL >= '"+MV_PAR07+"' "          
cQuery += " AND C1_FILIAL <= '"+MV_PAR08+"' "          
cQuery += " ORDER BY SC1.C1_DATPRF "        
If Select("SOL") > 0
	SOL->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SOL",.T.,.F.)
dbSelectArea("SOL")
SOL->(dbGoTop())
While SOL->(!Eof())   
	aReg        :={}         
	IF SOL->C1_QUJE == 0 .And. SOL->C1_COTACAO == Space(Len(SOL->C1_COTACAO)) .And. SOL->C1_APROV $ " ,L"    //SC em Aberto
		AADD(aReg , oVerde)
	ELSEIF SOL->C1_QUJE == 0 .And. SOL->C1_COTACAO == Space(Len(SOL->C1_COTACAO)) .And. SOL->C1_APROV == "R"     //SC Rejeitada
			AADD(aReg , oLaranja)                                                                           
	ELSEIF SOL->C1_QUJE == 0 .And. SOL->C1_COTACAO == Space(Len(SOL->C1_COTACAO)) .And. SOL->C1_APROV == "B"   //SC Bloqueada
			AADD(aReg , oCinza)
	ELSEIF SOL->C1_QUJE > 0  //SC com Pedido Colocado Parcial
			AADD(aReg , oAmarelo)                                                                                           
	ELSEIF SOL->C1_QUJE == 0 .And. SOL->C1_COTACAO <> Space(Len(SOL->C1_COTACAO)) //SC em Processo de Cotacao                                                     
			AADD(aReg , oAzul)                                                                            
	ENDIF         
	AADD(aReg , SOL->C1_FILIAL+'-'+Alltrim(FWFilialName(,SOL->C1_FILIAL)))
	AADD(aReg , SOL->C1_LOCAL) 
	AADD(aReg , SOL->C1_NUM)
	AADD(aReg , SOL->C1_FORNECE)
	AADD(aReg , SOL->C1_LOJA)
	AADD(aReg , GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+SOL->C1_FORNECE+SOL->C1_LOJA,1,"") )
	AADD(aReg , TRANSFORM(SOL->C1_QUANT,"@E 9,999,999.99  "))
	AADD(aReg , TRANSFORM(SOL->C1_QUANT - SOL->C1_QUJE,"@E 9,999,999.99  "))
	AADD(aReg , STOD(SOL->C1_DATPRF))
	AADD(aReg , IIF(SOL->C1_TPOP=="P","Prevista","Firme"))
	AADD(aReg , SOL->C1_FILIAL)
	AADD(aSolicDados ,aReg )
	SOL->(dbSkip())
END

IF LEN(aSolicDados)==0
	aBrancos := {}
	For nI := 1 To Len(aSolCab)
		AADD(aBrancos,' ')
	Next
	AADD(aSolicDados,aBrancos)
ENDIF
cbLine := "{||{ aSolicDados[oListSolic:nAt,01] "            
For nI := 2 To Len(aSolCab)
 cbLine += ",aSolicDados[oListSolic:nAt,"+STRZERO(nI,2)+"] "
Next         
cbLine +="  } }"                          
oListSolic:aHeaders := aSolCab
oListSolic:SetArray(aSolicDados)                  
oListSolic:bLine := &cbLine                   
oListSolic:DrawSelect()
oListSolic:Refresh()                             

Return 
************************************************************************************************************************************************
Static Function ZeraArray

Local aBrancos := {}
Local nI       := 0 
     
aEstDados := {}
For nI := 1 To Len(aEstCab)
	AADD(aBrancos,' ')
Next
AADD(aEstDados,aBrancos)

aBrancos  := {}
aEMPDados := {}
For nI := 1 To Len(aEMPCab)
	AADD(aBrancos,' ')
Next
AADD(aEMPDados,aBrancos)

aBrancos  := {}
aPedDados := {}
For nI := 1 To Len(aPedCab)
	AADD(aBrancos,' ')
Next
AADD(aPedDados,aBrancos)

aBrancos    := {}
aSolicDados :={}
For nI := 1 To Len(aSolCab)
	AADD(aBrancos,' ')
Next
AADD(aSolicDados,aBrancos)

aBrancos  := {}
aPVDados := {}
For nI := 1 To Len(aPVCab)
	AADD(aBrancos,' ')
Next
AADD(aPVDados,aBrancos)

aBrancos  := {}
aSADados := {}
For nI := 1 To Len(aSACab)
	AADD(aBrancos,' ')
Next
AADD(aSADados,aBrancos)


Return
