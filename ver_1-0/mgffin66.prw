#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSGRAPHI.CH"  

#define CRLF chr(13) + chr(10)             
#DEFINE LINHAS 999

/*
==================================================================================
Programa............: MGFFIN66
Autor...............: Marcelo Carneiro
Data................: 10/10/2017
Descricao / Objetivo: Baixa por Lote - Contas a Receber
Doc. Origem ........: MIT044 - GAP CRE38
Solicitante.........: 
Uso.................: Financeiro
==================================================================================

@alteracoes 09/12/2019 - Henrique Vidal
	RTASK0010483 - Baixar de titulos em lote por importacao de arquivo.
	Criado novo botao onde possibilita baixar titulos em lote a partir da importacao de um arquivo .csv

	- As funcoes antigas permaneceram inalteradas, somente consumindo a tela para gravacao de pedidos existentes, e 
	  desenvolvendo as novas funcoes:
	1 FIN66_CSV - Tela para impotar o .csv e prerar baixas
	2 MGFIMPCSV - Trata as premissas e regras para validar as baixas
	3 TrtBxRa   - Realiza baixa de t�titulo e geracao do R.A (caso exista)
*/

User Function MGFFIN66()


Local oBtn
Local oCbx        
Local nI         := 0 
Local nUltLin    := 0
Local nCol       := 0
Local aDescMotbx := {}    
Local aMotBx	 := ReadMotBx()

Private oDlgMain             
Private cMotBx	   := CriaVar("E5_MOTBX")
Private oAgencia   := Nil
Private oBanco     := Nil
Private oConta     := Nil            
Private oDtCredito := Nil           
Private oDtBaixa   := Nil           
Private oCapa      := Nil
Private cBBanco    := CriaVar("E1_PORTADO",.F.)
Private cBAgencia  := CriaVar("E1_AGEDEP" ,.F.)
Private cBConta	   := CriaVar("E1_CONTA"  ,.F.)
Private dBaixa	   := dDataBase
Private dDtCredito := dDataBase
Private nCapa      := 0

For nI := 1 to len( aMotBx )
	If SubStr(aMotBx[nI],34,01) == "A" .or. SubStr(aMotBx[nI],34,01) =="R"
		If !(substr(aMotBx[nI],01,03) $ "FAT|LOJ|LIQ|CEC|CMP|STP")
			AADD( aDescMotbx,SubStr(aMotBx[nI],07,10))
		EndIf                                  
	EndIf
Next nI

cMotBx		:= aDescMotBx[1] 	

DEFINE MSDIALOG oDlgMain TITLE "Baixa por Lote" FROM 000, 000  TO 230, 500 COLORS 0, 16777215 PIXEL

	nUltLin    := 15
	nCol       := 15
	@ nUltLin,nCol SAY "Valor Capa Lote" SIZE 65, 07 OF oDlgMain  PIXEL 
	@ nUltLin-4,nCol+50 MSGET oCapa VAR nCapa         PICTURE '@E 99,999,999.99' SIZE 65, 08 OF oDlgMain  PIXEL
	
	nUltLin += 12

	@ nUltLin,nCol SAY "Mot.Baixa" SIZE 32, 07 OF oDlgMain PIXEL //
	@ nUltLin-4,nCol+50 MSCOMBOBOX oCbx Var cMotBx ITEMS aDescMotBx SIZE 65, 47 OF oDlgMain PIXEL ON CHANGE Val_Banco()

	nUltLin += 18
	@ nUltLin,nCol SAY "Banco" SIZE 32, 07 OF oDlgMain PIXEL 
	@ nUltLin-4,nCol+50 MSGET oBanco Var cBBanco  SIZE 65, 08 OF oDlgMain PIXEL F3 "SA6" ;
				    	Valid ( !MovBcobx(cMotBx, .T.) .And. Empty(cBBanco) ) .Or. F070VldBco(cBBanco,@cBAgencia,@cBConta,.T.,.T.) ;
						WHEN MovBcoBx(cMotBx, .T.) 
	nUltLin += 12
	@ nUltLin,nCol SAY "Agencia" SIZE 32, 07 OF oDlgMain  PIXEL 
	@ nUltLin-4,nCol+50 MSGET oAgencia var cBAgencia  SIZE 65, 08 OF oDlgMain  PIXEL ;
						Valid F070VldBco(cBBanco,cBAgencia,@cBConta,.T.,.T.,cBAgencia)  ;
						WHEN MovBcoBx(cMotBx, .T.) 
	nUltLin += 12
	@ nUltLin,nCol SAY "Conta" SIZE 28, 07 OF oDlgMain  PIXEL 
	@ nUltLin-4,nCol+50 MSGET oConta var cBConta  SIZE 65, 08 OF oDlgMain  PIXEL ;
						Valid F070VldBco(cBBanco,cBAgencia,cBConta,.T.,.T.,cBAgencia+cBConta) ;
						WHEN MovBcoBx(cMotBx, .T.) 
	nUltLin += 12
	@ nUltLin,nCol SAY "Data Receb." SIZE 39, 07 OF oDlgMain PIXEL
	@ nUltLin-4,nCol+50 MSGET oDtBaixa VAR dBaixa SIZE 65, 08 OF oDlgMain PIXEL HASBUTTON When F070DtRe()
							    
	nUltLin += 12
	@ nUltLin,nCol SAY "Data Credito" SIZE 32, 07 OF oDlgMain PIXEL 
	@ nUltLin-4,nCol+50 MSGET oDtCredito VAR dDtCredito SIZE 65, 08 OF oDlgMain PIXEL HASBUTTON ;
						Valid (dDtCredito >= dBaixa  .and. Iif(SuperGetMv("MV_BXDTFIN",,"1") == "2", DtMovFin(dDtCredito,,"2"), .T.) ) .or. GetMv("MV_ANTCRED")
	
	oBtn := TButton():New( 010, 186 ,"Gerar lote"     , oDlgMain,{|| FIN66_MAIN() 	},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
	oBtn := TButton():New( 025, 186 ,"Excluir lote"   , oDlgMain,{|| FIN66_EXCL() 	},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
	oBtn := TButton():New( 055, 186 ,"Sair"           , oDlgMain,{|| oDlgMain:End() },50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
	oBtn := TButton():New( 040, 186 ,"Importar Csv"   , oDlgMain,{|| FIN66_CSV() 	},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. ) 

ACTIVATE MSDIALOG oDlgMain CENTERED


Return
*****************************************************************************************************************************
Static Function FIN66_MAIN

Local aSizeAut    := MsAdvSize(,.F.,400)
Local oBtn
Local oBold
Local nI          := 0 

Private oDlg                    
Private aBrowse    := {} 
Private aHeader    := {{' ','@!','LEFT',1,.T.}}
Private oOK        := LoadBitmap(GetResources(),'LBOK')
Private oNO        := LoadBitmap(GetResources(),'LBNO')
Private aObjects
Private aInfo
Private aPosObj
Private aCampSX3   := {'E1_FILIAL','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_NATUREZ','E1_CLIENTE','E1_LOJA','E1_NOMCLI','E1_EMISSAO','E1_VENCTO','E1_VENCREA','E1_VALOR','E1_SALDO','E1_DECRESC','E1_ACRESC','E1_DESCONT','E1_MULTA','E1_JUROS','E1_JUROS'}
Private nColOrder  := 1
Private nTipoOrder := 1
Private cDescAg    := Alltrim(cBAgencia)+' / '+Alltrim(cBConta)
Private cMotivo    := cMotBx
Private nTotal     := 0 
Private oTotal
Private aAltSE1    := {}
Private cLote      := ''
Private bSair      := .F.                                                                                           


DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

cLote := GetSXENum("SE5","E5_ZLOTEBX","E5_ZLOTEBX"+cEmpAnt)
aObjects := {}
AAdd( aObjects, { 0,    65, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
         
dbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nI := 1 to Len(aCampSX3) 
		IF SX3->(dbSeek(aCampSX3[nI]))   
		    AAdd(aHeader,{SX3->X3_TITULO,SX3->X3_TAMANHO})
        EndIF
Next nI
aHeader[len(aHeader),01] := 'V. Recebido'
    
IF !Fil_SE1()
     RollbackSX8()
     Return
EndIF

DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Baixas Contas Receber em Lote"  PIXEL
          
	oBrowseDados := TWBrowse():New( 50,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
							  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowseDados:SetArray(aBrowse)                                    
	oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }
	oBrowseDados:bLDblClick  := {|| aBrowse[oBrowseDados:nAt][1] := IIF(aBrowse[oBrowseDados:nAt][1]==oOK,oNO,oOK),Define_Valores() ,oBrowseDados:DrawSelect()}
	oBrowseDados:bChange     := {||AtualizaBrowse()}                   
	oBrowseDados:bHeaderClick:= {|oBrw,nCol| OrdenaCab(nCol,.T.)}
	oBrowseDados:addColumn(TCColumn():new(aHeader[01,01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"    ,1,.T.,.F.,,,,,))            
	oBrowseDados:addColumn(TCColumn():new(aHeader[02,01],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"   ,aHeader[02,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[03,01],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"   ,aHeader[03,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[04,01],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"   ,aHeader[04,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[05,01],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"LEFT"   ,aHeader[05,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[06,01],{||aBrowse[oBrowseDados:nAt][06]},"@!"             ,,,"LEFT"   ,aHeader[06,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[07,01],{||aBrowse[oBrowseDados:nAt][07]},"@!"             ,,,"LEFT"   ,aHeader[07,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[08,01],{||aBrowse[oBrowseDados:nAt][08]},"@!"             ,,,"LEFT"   ,aHeader[08,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[09,01],{||aBrowse[oBrowseDados:nAt][09]},"@!"             ,,,"LEFT"   ,aHeader[09,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[10,01],{||aBrowse[oBrowseDados:nAt][10]},"@!"             ,,,"LEFT"   ,aHeader[10,02]+30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new('Emissao'     ,{||aBrowse[oBrowseDados:nAt][11]},"@!"             ,,,"LEFT"   ,aHeader[11,02]+18,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new('Venc.'       ,{||aBrowse[oBrowseDados:nAt][12]},"@!"             ,,,"LEFT"   ,aHeader[12,02]+18,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new('Venc.Real'   ,{||aBrowse[oBrowseDados:nAt][13]},"@!"             ,,,"LEFT"   ,aHeader[13,02]+18,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[14,01],{||aBrowse[oBrowseDados:nAt][14]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[15,01],{||aBrowse[oBrowseDados:nAt][15]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[16,01],{||aBrowse[oBrowseDados:nAt][16]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[17,01],{||aBrowse[oBrowseDados:nAt][17]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[18,01],{||aBrowse[oBrowseDados:nAt][18]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[19,01],{||aBrowse[oBrowseDados:nAt][19]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[20,01],{||aBrowse[oBrowseDados:nAt][20]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[21,01],{||aBrowse[oBrowseDados:nAt][21]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:Setfocus() 
		
	DEFINE FONT oBold NAME "Arial" SIZE 0, -14 BOLD
		
	@ 004, 004 SAY "LOTE : "+cLote       SIZE 369, 009 OF oDlg FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE

	@ 020, 004 SAY "Motivo :"            SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 030 MSGET cMotivo             SIZE 060, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	@ 035, 004 SAY "Banco : "            SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 031, 030 MSGET cBBanco              SIZE 030, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL

	@ 020, 095 SAY "Data Receb.:"        SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 130 MSGET dBaixa              SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	@ 035, 095 SAY "Ag./Conta :"         SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 031, 130 MSGET cDescAg             SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	                                                      
	@ 020, 185 SAY "Data Credito :"      SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 225 MSGET dDtCredito          SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL

	@ 020, 280 SAY "Capa do Lote :"      		 SIZE 050, 007 OF oDlg COLORS 0, 16777215         PIXEL        
	@ 016, 340 MSGET nCapa                       SIZE 070, 010 OF oDlg WHEN .F. WHEN .F. PICTURE "@E 99,999,999.99"  COLORS CLR_BLUE PIXEL
	@ 035, 280 SAY "Total Selecionado :"		 SIZE 050, 007 OF oDlg COLORS 0, 16777215         PIXEL
	@ 031, 340 MSGET oTotal  VAR nTotal          SIZE 070, 010 OF oDlg WHEN .F. PICTURE "@E 99,999,999.99"  COLORS CLR_RED PIXEL
	    
	oBtn := TButton():New( aSizeAut[4]-15, 004 ,'Marcar/Desmarcar', oDlg,{|| MarcaDesmarca(1) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( aSizeAut[4]-15, 059 ,'Marcar Todas'    , oDlg,{|| MarcaDesmarca(2) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( aSizeAut[4]-15, 114 ,'Desmarcar Todas' , oDlg,{|| MarcaDesmarca(3) }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. ) 

	oBtn := TButton():New( 016				, 450,'Baixa'		, oDlg,{|| Processa( {|| FIN66_BAIXA() },'Aguarde...', 'Efetivando as Baixas',.F. ),IIF(bSair,oDlg:End(),bSair := .F.)  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
	oBtn := TButton():New( 031 				, 450,'Cancela'		, oDlg,{|| RollbackSX8(),oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn := TButton():New( aSizeAut[4]-15	, 275,'Excel'		, oDlg,{|| GeraExcel(1)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
	oBtn := TButton():New( aSizeAut[4]-15	, 320,'Visualizar'	, oDlg,{|| FIN66_VISUAL(1)       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

Return 
******************************************************************************************************************           
Static Function Carrega_Dados(bResult)

Local cQuery  := ''
Local cQuery2 := ''
Local aReg    := {}    
Local cCab    := ''
Local cNTipo  := GetMV('MGF_FIN66',.F.,'')
Local nTotReg := 0

cCab    := " Select Count(*) TOTAL"
cQuery  := " From "+RetSqlName("SE1")+" A, "+RetSqlName("SA1")+" B"
cQuery  += " Where A.D_E_L_E_T_  = ''"
cQuery  += "   AND B.D_E_L_E_T_  = ''"
cQuery  += "   AND E1_CLIENTE	 = A1_COD"
cQuery  += "   AND E1_LOJA       = A1_LOJA"
cQuery  += "   AND E1_SALDO  >  0 "
cQuery  += "   AND E1_ORIGEM <> 'SIGAEEC'"
IF !Empty(cNTipo)
	 cNTipo := StrTran(cNTipo,';',"','")
	 cQuery  += "   AND E1_TIPO not in ('"+cNTipo+"')"
EndIF
IF !Empty(MV_PAR01)
	 cQuery  += "   AND E1_FILIAL >='"+MV_PAR01+"'"
EndIF
IF !Empty(MV_PAR02)
	 cQuery  += "   AND E1_FILIAL <='"+MV_PAR02+"'"
EndIF
IF !Empty(MV_PAR03)
	 cQuery  += "   AND A1_CGC >='"+MV_PAR03+"'"
EndIF
IF !Empty(MV_PAR04)
	 cQuery  += "   AND A1_CGC <='"+MV_PAR04+"'"
EndIF
IF !Empty(MV_PAR05)
	 cQuery  += "   AND A1_COD >='"+MV_PAR05+"'"
EndIF
IF !Empty(MV_PAR06)
	 cQuery  += "   AND A1_COD <='"+MV_PAR06+"'"
EndIF
IF !Empty(MV_PAR07)
	 cQuery  += "   AND A1_LOJA >='"+MV_PAR07+"'"
EndIF
IF !Empty(MV_PAR08)
	 cQuery  += "   AND A1_LOJA <='"+MV_PAR08+"'"
EndIF
IF !Empty(MV_PAR09)
	 cQuery  += "   AND A1_ZREDE ='"+MV_PAR09+"'"
EndIF
IF !Empty(MV_PAR10)
	 cQuery  += "   AND E1_EMISSAO >='"+DTOS(MV_PAR10)+"'"
EndIF
IF !Empty(MV_PAR11)
	 cQuery  += "   AND E1_EMISSAO <='"+DTOS(MV_PAR11)+"'"
EndIF
IF !Empty(MV_PAR12)
	 cQuery  += "   AND E1_VENCREA >='"+DTOS(MV_PAR12)+"'"
EndIF
IF !Empty(MV_PAR13)
	 cQuery  += "   AND E1_VENCREA <='"+DTOS(MV_PAR13)+"'"
EndIF
IF !Empty(MV_PAR14)
	 cQuery  += "   AND E1_NATUREZ >='"+MV_PAR14+"'"
EndIF
IF !Empty(MV_PAR15)
	 cQuery  += "   AND E1_NATUREZ <='"+MV_PAR15+"'"
EndIF
IF !Empty(MV_PAR16)
	 cQuery  += "   AND E1_PORTADO >='"+MV_PAR16+"'"
EndIF
IF !Empty(MV_PAR17)
	 cQuery  += "   AND E1_PORTADO <='"+MV_PAR17+"'"
EndIF
IF !Empty(MV_PAR18)
	 cQuery  += "   AND E1_AGEDEP >='"+MV_PAR18+"'"
EndIF
IF !Empty(MV_PAR19)
	 cQuery  += "   AND E1_AGEDEP <='"+MV_PAR19+"'"
EndIF
IF !Empty(MV_PAR20)
	 cQuery  += "   AND E1_CONTA >='"+MV_PAR20+"'"
EndIF
IF !Empty(MV_PAR21)
	 cQuery  += "   AND E1_CONTA <='"+MV_PAR21+"'"
EndIF
cQuery  += " Order by E1_FILIAL,E1_NUM, E1_PARCELA"

If Select("QRY_DADOS") > 0
	QRY_DADOS->(dbCloseArea())
EndIf
cQuery2  := ChangeQuery(cCab+cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRY_DADOS",.T.,.F.)
dbSelectArea("QRY_DADOS")
QRY_DADOS->(dbGoTop())
IF QRY_DADOS->(!Eof())
     nTotReg := QRY_DADOS->TOTAL
     IF QRY_DADOS->TOTAL >= 32700
         bResult := .F.
         Return      
     EndIF
EndIF
cCab    := " Select A.R_E_C_N_O_ RECSE1, A.*"
If Select("QRY_DADOS") > 0
	QRY_DADOS->(dbCloseArea())
EndIf
cQuery2  := ChangeQuery(cCab+cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"QRY_DADOS",.T.,.F.)
dbSelectArea("QRY_DADOS")
QRY_DADOS->(dbGoTop())
ProcRegua( nTotReg )
While QRY_DADOS->(!Eof())
    IncProc('Selcionando Registros')
    aReg    := {}      
    AADD(aReg,oNO)                      
    AADD(aReg,QRY_DADOS->E1_FILIAL)	
	AADD(aReg,QRY_DADOS->E1_PREFIXO)	
	AADD(aReg,QRY_DADOS->E1_NUM)	
	AADD(aReg,QRY_DADOS->E1_PARCELA)	
	AADD(aReg,QRY_DADOS->E1_TIPO)	
	AADD(aReg,QRY_DADOS->E1_NATUREZ)	
	AADD(aReg,QRY_DADOS->E1_CLIENTE)	
	AADD(aReg,QRY_DADOS->E1_LOJA)	
	AADD(aReg,QRY_DADOS->E1_NOMCLI)	
	AADD(aReg,DTOC(STOD(QRY_DADOS->E1_EMISSAO)))	
	AADD(aReg,DTOC(STOD(QRY_DADOS->E1_VENCTO)))	
	AADD(aReg,DTOC(STOD(QRY_DADOS->E1_VENCREA)))	
	AADD(aReg,QRY_DADOS->E1_VALOR)	
	AADD(aReg,QRY_DADOS->E1_SALDO)
	AADD(aReg,QRY_DADOS->E1_DECRESC)
	AADD(aReg,QRY_DADOS->E1_ACRESC)
	AADD(aReg,0)
	AADD(aReg,0)
	AADD(aReg,0)
    AADD(aReg,0) 
    AADD(aReg,QRY_DADOS->RECSE1) 
    AADD(aBrowse ,aReg)
    QRY_DADOS->(dbSkip())
End                  
bResult := .T.
Return 
********************************************************************************************************
Static Function OrdenaCab(nCol,bMudaOrder)
Local aOrdena := {}       

				   
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
*********************************************************************************************************************************
Static Function AtualizaBrowse

oBrowseDados:SetFocus()

Return
****************************************************************************************************************
Static Function MarcaDesmarca(pTipo)            

Local nI := 0

IF pTipo == 1 // Somente uma Linha
	Define_Valores()
	//aBrowse[oBrowseDados:nAt][1] := IIF(aBrowse[oBrowseDados:nAt][1]==oOK,oNO,oOK)
	//oBrowseDados:DrawSelect()
	//oBrowseDados:SetFocus()
ELSE         
	nTotal := 0
	For nI:= 1 TO LEN(aBrowse)
		aBrowse[nI][1] := IIF(pTipo==2,oOK, oNO)
		IF pTipo == 2
		    IF aBrowse[nI][21] == 0                                          
		    	aBrowse[nI][21] := aBrowse[nI][15] - aBrowse[nI][16] + aBrowse[nI][17] -;
		    	 				   aBrowse[nI][18] + aBrowse[nI][19] + aBrowse[nI][20]
		    EndIF
			nTotal += aBrowse[nI][21]
		EndiF
	Next
	oTotal:Refresh()
	oBrowseDados:DrawSelect()
	oBrowseDados:SetFocus()
ENDIF
Return

****************************************************************************************************************
Static Function  Define_Valores() 

Local oSay
Local oGrp1
Local oDlg2
Local oBtn                                              
Local bConfirma := .F.
Local nVRbk     := aBrowse[oBrowseDados:nAt][21]

 
Private nVOriginal   := aBrowse[oBrowseDados:nAt][14]
Private nVSaldo      := aBrowse[oBrowseDados:nAt][15]
Private nDecrescimo  := aBrowse[oBrowseDados:nAt][16]
Private nAcrescimo   := aBrowse[oBrowseDados:nAt][17]
Private nDescontos   := aBrowse[oBrowseDados:nAt][18]
Private nMultas      := aBrowse[oBrowseDados:nAt][19]
Private nJuros       := aBrowse[oBrowseDados:nAt][20]
Private nVRecebido   := aBrowse[oBrowseDados:nAt][21]   
Private nVBaixa      := 0

IF nVRecebido  == 0 
	nVBaixa := aBrowse[oBrowseDados:nAt][15]
Else
   nVBaixa  := nVRecebido + nDecrescimo - nAcrescimo + nDescontos - nMultas - nJuros
   IF nVRecebido <= 0                       
        nVBaixa := aBrowse[oBrowseDados:nAt][15]
   EndIF
EndIF

oDlg2      := MSDialog():New( 092,232,488,581,"Entre com os Valores",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 005,005,188,168,"Valores da Baixa",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay := TSay():New( 020,020,{||"Valor Original R$"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 036,020,{||"Saldo Atual"}      ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 052,020,{||"Valor Recebido"}   ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 066,020,{||" - Decrescimo"}    ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 084,020,{||"+ Acrescimo"}      ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 100,020,{||"- Descontos"}      ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 116,020,{||"+ Multas"}         ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 132,020,{||"+ Juros"}          ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)
oSay := TSay():New( 148,020,{||"Valor Baixa"}      ,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,007)

@ 017,076 MSGET nVOriginal    SIZE 060,008 OF oGrp1 WHEN .F. PICTURE '@E 99,999,999.99'  PIXEL 
@ 033,076 MSGET nVSaldo       SIZE 060,008 OF oGrp1 WHEN .F. PICTURE '@E 99,999,999.99'  PIXEL 
@ 049,076 MSGET nVBaixa       SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL()
@ 065,076 MSGET nDecrescimo   SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL() .And. AT_DESC()
@ 081,076 MSGET nAcrescimo    SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL() 
@ 097,076 MSGET nDescontos    SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL()
@ 113,076 MSGET nMultas       SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL()
@ 129,076 MSGET nJuros        SIZE 060,008 OF oGrp1 PICTURE '@E 99,999,999.99'  PIXEL VALID AT_TOTAL()
@ 145,076 MSGET nVRecebido    SIZE 060,008 OF oGrp1 WHEN .F. PICTURE '@E 99,999,999.99'  PIXEL 

oBtn := TButton():New( 160, 034 ,'Cancela'  , oDlg2,{|| oDlg2:End()   }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
oBtn := TButton():New( 160, 089 ,'Confirma' , oDlg2,{|| bConfirma := .T., oDlg2:End()   }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            

oDlg2:Activate(,,,.T.)
IF bConfirma  
    IF nTotal == 0                          
    	nTotal += nVRecebido //- nDecrescimo + nAcrescimo - nDescontos + nMultas + nJuros//nVRecebido
    Else
		nTotal := nTotal - nVRbk + nVRecebido //- nDecrescimo + nAcrescimo - nDescontos + nMultas + nJuros
	EndIF
	oTotal:Refresh()
	aBrowse[oBrowseDados:nAt][16] := nDecrescimo
	aBrowse[oBrowseDados:nAt][17] := nAcrescimo
	aBrowse[oBrowseDados:nAt][18] := nDescontos
	aBrowse[oBrowseDados:nAt][19] := nMultas
	aBrowse[oBrowseDados:nAt][20] := nJuros
	aBrowse[oBrowseDados:nAt][21] := nVRecebido
	aBrowse[oBrowseDados:nAt][01] := oOK
	oBrowseDados:DrawSelect()
	oBrowseDados:Refresh()
	IF  nDecrescimo > 0 .OR. nAcrescimo > 0 
		nPos  := aScan( aAltSE1, { |x| x[1] == aBrowse[oBrowseDados:nAt][Len(aHeader)+1] })
		IF nPos  == 0 
			AAdd(aAltSE1,{aBrowse[oBrowseDados:nAt][Len(aHeader)+1],nDecrescimo,nAcrescimo,cTpdes})
		Else
			aAltSE1[nPos][02] := nDecrescimo
			aAltSE1[nPos][03] := nAcrescimo
		EndIF
	EndIF
Else
	aBrowse[oBrowseDados:nAt][01] := oNO
	aBrowse[oBrowseDados:nAt][21] := 0
	nTotal := nTotal - nVRbk
	oTotal:Refresh()                  
	oBrowseDados:DrawSelect()
	oBrowseDados:Refresh()
EndIF
Return
***************************************************************************************************************
Static Function AT_TOTAL

// Verifica se o valor da Baixa � maior que o valor do Saldo. Se �, vale o valor do saldo a pagar.
// Paulo Mata - Fev/2020

If nVBaixa > nVSaldo
   ApMsgAlert(OemToAnsi("Valor Recebido Maior que o Saldo a Receber"),OemToAnsi("ATENCAO"))
   nVBaixa := nVSaldo
EndIf

nVRecebido  := nVBaixa - nDecrescimo + nAcrescimo - nDescontos + nMultas + nJuros
IF nVRecebido < 0 
    nVRecebido  :=  0
EndIF
nPos  := aScan( aAltSE1, { |x| x[1] == aBrowse[oBrowseDados:nAt][Len(aHeader)+1] })
IF nPos  == 0
    AAdd(aAltSE1,{aBrowse[oBrowseDados:nAt][Len(aHeader)+1],nDecrescimo,nAcrescimo,'   '})
Else
	aAltSE1[nPos][02] := nDecrescimo
	aAltSE1[nPos][03] := nAcrescimo
EndIF

Return .T.
***************************************************************************************************************
Static Function FIN66_VISUAL(nTipo)

Local cbkFil  := cFilAnt
Local cFilTab := IIF(nTipo==1,'E1_FILIAL','E5_FILIAL')                                                           

Private nOpcx     := 2                                
Private cAlias    := IIF(nTipo==1,'SE1','SE5')                                                           
Private nReg      := aBrowse[oBrowseDados:nAt][Len(aHeader)+1]
Private cCadastro := IIF(nTipo==1,'Titulo a Receber','Baixa')
Private aRotina := {{"","", 0 , 3},{"","", 0 , 3}}


       
dbSelectArea(cAlias)
&(cAlias)->(dbGoTo(nReg))

cFilAnt := &(cAlias+'->'+cFilTab)

AxVisual(cAlias,nReg,nOpcx)

cFilAnt := cbkFil  

Return
*****************************************************************************************************************
Static Function AT_DESC()

IF nDecrescimo > 0 
   ALTTPDES()
EndIF

Return .T.
*****************************************************************************************************************
Static Function ALTTPDES()

Local cTpdes  := ''
Local oDLG2
Local lOk     := .F.
Local nPos    := 0
Local _lRet := .T. 
                
dbSelectArea('SE1')
SE1->(DbGoTo(aBrowse[oBrowseDados:nAt][Len(aHeader)+1]) )
cTpdes := SE1->E1_ZTPDESC
IF Empty(cTpdes)
	nPos  := aScan( aAltSE1, { |x| x[1] == aBrowse[oBrowseDados:nAt][Len(aHeader)+1] })
	IF nPos  <> 0
		cTpdes := aAltSE1[nPos][04]
	EndIF
EndIF
DEFINE DIALOG oDLG2 TITLE "Alterando Tp de desconto" FROM 180,180 TO 300,450 PIXEL
@ 15,05 SAY "Tipo de desconto:"       SIZE  50,10 OF oDlg2 PIXEL
//@ 15,50 MSGET cTpdes                  SIZE  50,10 OF oDlg2 PIXEL F3 "ZZ4" VALID (Vazio(cTpdes) .or. ExistCpo("ZZ4",cTpdes)) PICTURE '@!'
//@ 15,50 MSGET oTpdes var cTpdes       SIZE  50,10 OF oDlg2 PIXEL F3 "ZZ4" VALID (ExistCpo("ZZ4",cTpdes)) PICTURE '@!'
@ 15,50 MSGET oTpdes var cTpdes       SIZE  50,10 OF oDlg2 PIXEL F3 "ZZ4" PICTURE '@!'
oTButton := TButton():New( 35, 30, "&OK"      ,oDlg2	,{|| lOk:= .T.    , oDlg2:End() }	,40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
oTButton := TButton():New( 35, 80, "&Cancelar",oDlg2	,{|| lOk:= .F. ,oDlg2:End() }	,40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE DIALOG oDlg2 CENTERED

If lOk 
	nPos  := aScan( aAltSE1, { |x| x[1] == aBrowse[oBrowseDados:nAt][Len(aHeader)+1] })
	if Select("TRBZZ8") > 0
		TRBZZ8->(DBCLOSEAREA())
	Endif
	cQuery := "SELECT ZZ4_ZCOD AS TPDESC FROM "+RETSQLNAME('ZZ4')+" WHERE ZZ4_FILIAL='"+xFilial("ZZ4")+"' AND ZZ4_ZCOD='"+cTpdes+"' AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZZ8",.F.,.T.)

	if !Empty(cTpDes) .and. !Empty(TRBZZ8->TPDESC) 
		IF nPos  == 0
			AAdd(aAltSE1,{aBrowse[oBrowseDados:nAt][Len(aHeader)+1],nDecrescimo,nAcrescimo,cTpdes})
		Else
			aAltSE1[nPos][04] := cTpdes
		EndIF
	Else
		nDecrescimo := 0
	    MsgAlert("Este tipo de desconto nao existe","Atencao Processo Cancelado")
	Endif
Endif
If !lOk
	nDecrescimo := 0
    MsgAlert("Campo Descrescimo zerado ","Atencao Processo Cancelado")	
EndIf

Return

***************************************************************************************************************
Static Function GeraExcel(nTipo)            

Local aCabExcel   := {}
Local aDadosExcel := {}
Local nI          := 0 
Local nC          := 0 
Local nL          := 0 

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel nao instalado!")
	Return
EndIf
  
For nI := 1 To Len(aHeader)
  Aadd(aCabExcel,aHeader[nI][01] )
Next            
If nTipo == 1
   aCabExcel[01] := 'Marcado'
EndIF
For nL := 1 To Len(aBrowse) 
  aAux := {}
  For nC := 1 To Len(aHeader)
      Aadd(aAux, aBrowse[nL,nC])
  Next      
  IF nTipo == 1
	  IF aAux[01] ==  oOK
	      aAux[01] := 'X'
	  Else                 
	  	  aAux[01] := ' '
	  EndIF              
//	  aAux[02] := CHR(160)+aAux[03]
//	  aAux[04] := CHR(160)+aAux[03]
//	  aAux[05] := CHR(160)+aAux[04]
//	  aAux[08] := CHR(160)+aAux[07]
//	  aAux[09] := CHR(160)+aAux[08]
  Else
	  aAux[01] := CHR(160)+aAux[03]
	  aAux[03] := CHR(160)+aAux[03]
	  aAux[04] := CHR(160)+aAux[04]
	  aAux[07] := CHR(160)+aAux[07]
	  aAux[08] := CHR(160)+aAux[08]
  EndIF

  Aadd(aDadosExcel, aAux)
Next         

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({ {"ARRAY", cLote, aCabExcel, aDadosExcel} }) })                                          
       
Return
******************************************************************************************************************************
Static Function FIN66_Baixa(lbxparc)
Local nI      := 0                                                                   
Local nPos    := 0 
Local nTotReg := 0                               
Local bRet    := .T.    
Local cbkFil  := cFilAnt       
Local aRegOK  := {}

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.

Default lbxparc	:= .F.

IF MsgYESNO('Deseja efetuar a baixa dos Titulos marcados ?')
	IF nTotal <> nCapa .and. !lbxparc
		msgAlert('Valor selecionado � diferente da Capa de Lote !!')
		Return .F.
	EndIF
	For nI := 1 To Len(aBrowse)
		IF aBrowse[nI][01] ==  oOK
			IF aBrowse[nI][21] <= 0
				msgAlert('Existe titulo marcado com valor recebido igual a zero')
				Return .F.
			EndIF
			AAdd(aRegOK,nI)
		EndIF
	Next nI
	ConfirmSX8()                            
	ProcRegua( Len(aRegOK) )                      
	DbSelectArea("SE1")
	BEGIN TRANSACTION                    
		For nI := 1 To Len(aRegOK)
			IncProc('Processando a Baixa')
			SE1->(DbGoTo(aBrowse[aRegOK[nI]][Len(aHeader)+1]) )
			nPOS := aScan( aAltSE1, { |x| x[1] == aBrowse[aRegOK[nI]][Len(aHeader)+1] })
			IF nPOS <> 0
				SE1->(Reclock("SE1",.F.))
				SE1->E1_ACRESC  := aAltSE1[nPos][03]
				SE1->E1_SDACRES	:= aAltSE1[nPos][03]
				SE1->E1_DECRESC	:= aAltSE1[nPos][02]
				SE1->E1_SDDECRE := aAltSE1[nPos][02]
				SE1->E1_ZTPDESC := aAltSE1[nPos][04]
				SE1->(MsUnlock())
			EndIF

			cFilAnt := SE1->E1_FILIAL
			aBaixa := { ;
						{"E1_FILIAL"   ,SE1->E1_FILIAL,Nil},;
						{"E1_PREFIXO"  ,SE1->E1_PREFIXO,Nil},;
						{"E1_NUM"      ,SE1->E1_NUM             ,Nil},;
						{"E1_TIPO"     ,SE1->E1_TIPO            ,Nil},;
						{"E1_PARCELA"  ,SE1->E1_PARCELA         ,Nil},;
						{"E1_CLIENTE"  ,SE1->E1_CLIENTE         ,Nil},;
						{"E1_LOJA"     ,SE1->E1_LOJA            ,Nil},;
						{"AUTMOTBX"    ,cMotivo                 ,Nil},;
						{"AUTBANCO"    ,cBBanco                 ,Nil},;
						{"AUTAGENCIA"  ,cBAgencia               ,Nil},;
						{"AUTCONTA"    ,cBConta                 ,Nil},;
						{"AUTDTBAIXA"  ,dBaixa                  ,Nil},;
						{"AUTDTCREDITO",dDtCredito              ,Nil},; //dDatabase
						{"AUTHIST"     ,"BAIXA EM LOTE No.: "+cLote,Nil},;
						{"AUTDESCONT"  ,aBrowse[aRegOK[nI]][18] 	   ,Nil,.T.},;
						{"AUTMULTA"    ,aBrowse[aRegOK[nI]][19]        ,Nil,.T.},;
						{"AUTJUROS"    ,aBrowse[aRegOK[nI]][20]        ,Nil,.T.},;
						{"AUTVALREC"   ,aBrowse[aRegOK[nI]][21]	  	   ,Nil}}
			lMsErroAuto := .F.
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
			If lMsErroAuto
				DISARMTRANSACTION()
				aErro := GetAutoGRLog()
				cErro := 'Prefixo: '+SE1->E1_PREFIXO+' - '+Alltrim(SE1->E1_NUM)+'/'+Alltrim(SE1->E1_PARCELA)+CRLF
				For nI := 1 to Len(aErro)
					cErro += aErro[nI] + CRLF
				Next nI
				msgAlert(cErro)
				cFilAnt := cbkFil
				Return .F.
			EndIF
		Next nI
	END TRANSACTION
	MsgAlert('Titulos Baixados com sucesso!!')
	bSair      := .T.                                                                                           
Endif
cFilAnt := cbkFil  
Return .T.

*************************************************************************************************************************************************
Static Function Val_Banco
IF !MovBcobx(cMotBx, .T.)
	cBBanco    := CriaVar("E1_PORTADO",.F.)
	cBAgencia  := CriaVar("E1_AGEDEP" ,.F.)
	cBConta	   := CriaVar("E1_CONTA"  ,.F.)
EndIF

Return 

***************************************************************************************************************************************************
Static Function Fil_SE1
      
Local aRet		  := {}
Local aParambox	  := {}                 
Local bResult     := .F.

AAdd(aParamBox, {1, "Filial de:"       	,Space(tamSx3("A1_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Filial Ate:"      	,Space(tamSx3("A1_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
AAdd(aParamBox, {1, "CNPJ de:"         	,Space(tamSx3("A1_CGC")[1])           , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "CNPJ Ate:"      	,Space(tamSx3("A1_CGC")[1])           , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Cod. Cliente de:"  ,Space(tamSx3("A1_COD")[1])           , "@!",                           ,"SA1" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Cod. Cliente Ate:" ,Space(tamSx3("A1_COD")[1])           , "@!",                           ,"SA1" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Loja de:"			,Space(tamSx3("A1_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Loja Ate:"      	,Space(tamSx3("A1_LOJA")[1])          , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Codigo Rede :"     ,Space(tamSx3("A1_ZREDE")[1])         , "@!",                           ,"SZQ" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Dt. Emissao de:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Dt. Emissao Ate:"  ,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Vencimento de:" 	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Vencimento Ate:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Natureza de:"      ,Space(tamSx3("A1_NATUREZ")[1])       , "@!",                           ,"SED" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Natureza Ate:"     ,Space(tamSx3("A1_NATUREZ")[1])       , "@!",                           ,"SED" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Banco de:"      	,Space(tamSx3("A6_COD")[1])           , "@!",                           ,"BC8" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Banco Ate:"     	,Space(tamSx3("A6_COD")[1])           , "@!",                           ,"BC8" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Agencia de:"    	,Space(tamSx3("A6_AGENCIA")[1])       , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Agencia Ate:"   	,Space(tamSx3("A6_AGENCIA")[1])       , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Cta Corrente de:"  ,Space(tamSx3("A6_NUMCON")[1])        , "@!",                           ,      ,, 070	, .F.	})
AAdd(aParamBox, {1, "Cta Corrente Ate:"	,Space(tamSx3("A6_NUMCON")[1])        , "@!",                           ,      ,, 070	, .F.	})
IF ParamBox(aParambox, "Filtro para Selecionar os Titulos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	Processa( {|| Carrega_Dados(@bResult)  },'Aguarde...', 'Selecionando Registros',.F. )
	IF !bResult
		 msgAlert('A Quantidade maxima de registros sao 32700, favor refazer o Filtro !') 
	Else	
		IF Len(aBrowse) > 0 
			Return .T.
		Else
			msgAlert('Nao foram encontrados titulos com o filtro selecionado !')
		EndIF
	EndIF
EndIF
Return .F.
*****************************************************************************************************************************
Static Function FIN66_EXCL

Local aSizeAut    := MsAdvSize(,.F.,400)
Local oBtn
Local oBold
Local nI          := 0 

Private oDlg                    
Private aBrowse    := {} 
Private aHeader    := {}
Private aObjects
Private aInfo
Private aPosObj
Private aCampSX3   := {'E1_FILIAL','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_NATUREZ','E1_CLIENTE','E1_LOJA','E1_NOMCLI','E1_EMISSAO','E5_VALOR','E5_TIPODOC','E5_HISTOR'}
Private nColOrder  := 1
Private nTipoOrder := 1
Private cDescAg    := ''
Private cMotivo    := ''
Private aAltSE1    := {}
Private cLote      := ''                     
Private cDescBanco := ''
Private dEBaixa	   := ''
Private dEDtCredito:= ''
Private nCapaE     := 0            
Private nTotReg    := 0 

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

aObjects := {}
AAdd( aObjects, { 0,    65, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
         
dbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nI := 1 to Len(aCampSX3) 
		IF SX3->(dbSeek(aCampSX3[nI]))   
		    AAdd(aHeader,{SX3->X3_TITULO,SX3->X3_TAMANHO})
        EndIF
Next nI
    
IF !Fil_SE5()
     Return
EndIF

DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Exclui Lote Contas a Receber"  PIXEL
          
	oBrowseDados := TWBrowse():New( 50,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
							  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowseDados:SetArray(aBrowse)                                    
	oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }
	oBrowseDados:bHeaderClick:= {|oBrw,nCol| OrdenaCab(nCol,.T.)}
	oBrowseDados:addColumn(TCColumn():new(aHeader[01,01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"   ,aHeader[02,01],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[02,01],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"   ,aHeader[02,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[03,01],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"   ,aHeader[03,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[04,01],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"   ,aHeader[04,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[05,01],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"LEFT"   ,aHeader[05,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[06,01],{||aBrowse[oBrowseDados:nAt][06]},"@!"             ,,,"LEFT"   ,aHeader[06,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[07,01],{||aBrowse[oBrowseDados:nAt][07]},"@!"             ,,,"LEFT"   ,aHeader[07,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[08,01],{||aBrowse[oBrowseDados:nAt][08]},"@!"             ,,,"LEFT"   ,aHeader[08,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[09,01],{||aBrowse[oBrowseDados:nAt][09]},"@!"             ,,,"LEFT"   ,aHeader[09,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new('Emissao'     ,{||aBrowse[oBrowseDados:nAt][10]},"@!"             ,,,"LEFT"   ,aHeader[10,02]+18,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[11,01],{||aBrowse[oBrowseDados:nAt][11]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[12,01],{||aBrowse[oBrowseDados:nAt][12]},"@!"             ,,,"LEFT"   ,aHeader[12,02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[13,01],{||aBrowse[oBrowseDados:nAt][13]},"@!"             ,,,"LEFT"   ,aHeader[13,02],.F.,.F.,,,,,))
	oBrowseDados:Setfocus() 
		
	DEFINE FONT oBold NAME "Arial" SIZE 0, -14 BOLD
		
	@ 004, 004 SAY "LOTE : "+cLote       SIZE 369, 009 OF oDlg FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE

	@ 020, 004 SAY "Motivo :"            SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 030 MSGET cMotivo             SIZE 060, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	@ 035, 004 SAY "Banco : "            SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 031, 030 MSGET cDescBanco          SIZE 030, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL

	@ 020, 095 SAY "Data Receb.:"        SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 130 MSGET dEBaixa             SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	@ 035, 095 SAY "Ag./Conta :"         SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 031, 130 MSGET cDescAg             SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	                                                      
	@ 020, 185 SAY "Data Credito :"      SIZE 040, 009 OF oDlg  PIXEL                                     
	@ 016, 225 MSGET dEDtCredito         SIZE 050, 010 OF oDlg WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL

	
	@ 020, 400 SAY "Capa do Lote :"      		 SIZE 050, 007 OF oDlg COLORS 0, 16777215         PIXEL        
	@ 016, 450 MSGET nCapaE                       SIZE 070, 010 OF oDlg WHEN .F. WHEN .F. PICTURE "@E 99,999,999.99"  COLORS CLR_BLUE PIXEL
	    
	oBtn := TButton():New( 004, 620 ,'Cancela Lote'     , oDlg,{|| Processa( {|| EX_BAIXA() },'Aguarde...', 'Efetivando a exclusao',.F. ),oDlg:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
	oBtn := TButton():New( 019 ,620 ,'Sair'            , oDlg,{|| oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn := TButton():New( aSizeAut[4]-15, 565 ,'Excel'     , oDlg,{|| GeraExcel(2)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
	oBtn := TButton():New( aSizeAut[4]-15, 620 ,'Visualizar', oDlg,{|| FIN66_VISUAL(2)       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
ACTIVATE MSDIALOG oDlg CENTERED

Return 
***************************************************************************************************************************************************
Static Function Fil_SE5
      
Local aRet			:= {}
Local aParambox		:= {}                 

AAdd(aParamBox, {1, "Lote "         	,Space(10)           , "@!",                           ,      ,, 070	, .F.	})
IF ParamBox(aParambox, "Seleciona o Lote a Cancelar"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	Carrega_SE5()                 
	IF Len(aBrowse) > 0 
		Return .T.
	Else
		msgAlert('Nao foram encontrados recebimentos com este Lote ou Lote j� cancelado !')
	EndIF
EndIF
Return .F.
******************************************************************************************************************           
Static Function Carrega_SE5()                                       

Local cQuery  := ''
Local aReg    := {} 
Local nCancel := .F.

cLote   := PADL(AllTrim(MV_PAR01),10,'0')
cQuery  := " Select A.R_E_C_N_O_ RECSE5, B.R_E_C_N_O_ RECSE1, A.*,B.*"
cQuery  += " From "+RetSqlName("SE5")+" A, "+RetSqlName("SE1")+" B"
cQuery  += " Where A.D_E_L_E_T_  = ''"
cQuery  += "   AND B.D_E_L_E_T_  = ''"
cQuery  += "   AND E5_ZLOTEBX    = '"+cLote+"'"
cQuery  += "   AND E5_CLIFOR	 = E1_CLIENTE"
cQuery  += "   AND E5_LOJA       = E1_LOJA"
cQuery  += "   AND E5_PREFIXO	 = E1_PREFIXO"
cQuery  += "   AND E5_NUMERO     = E1_NUM"
cQuery  += "   AND E5_PARCELA	 = E1_PARCELA"
cQuery  += "   AND E5_TIPO       = E1_TIPO"
cQuery  += " Order by E1_NUM, E1_PARCELA"

If Select("QRY_DADOS") > 0
	QRY_DADOS->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_DADOS",.T.,.F.)
dbSelectArea("QRY_DADOS")
QRY_DADOS->(dbGoTop())
IF QRY_DADOS->(!Eof())               
	cDescAg    := Alltrim(QRY_DADOS->E5_AGENCIA)+' / '+Alltrim(QRY_DADOS->E5_CONTA)
	cMotivo    := QRY_DADOS->E5_MOTBX
	cDescBanco := QRY_DADOS->E5_BANCO
	dEBaixa	   := STOD(QRY_DADOS->E5_DATA)
	dEDtCredito:= STOD(QRY_DADOS->E5_DTDISPO)
EndIF
While QRY_DADOS->(!Eof())
    aReg    := {}                       
    AADD(aReg,QRY_DADOS->E5_FILIAL)	
	AADD(aReg,QRY_DADOS->E5_PREFIXO)	
	AADD(aReg,QRY_DADOS->E5_NUMERO)	
	AADD(aReg,QRY_DADOS->E5_PARCELA)	
	AADD(aReg,QRY_DADOS->E1_TIPO)	
	AADD(aReg,QRY_DADOS->E5_NATUREZ)	
	AADD(aReg,QRY_DADOS->E1_CLIENTE)	
	AADD(aReg,QRY_DADOS->E1_LOJA)	
	AADD(aReg,QRY_DADOS->E1_NOMCLI)	
	AADD(aReg,DTOC(STOD(QRY_DADOS->E1_EMISSAO)))	
	AADD(aReg,QRY_DADOS->E5_VALOR)	
	AADD(aReg,QRY_DADOS->E5_TIPODOC)	
	AADD(aReg,QRY_DADOS->E5_HISTOR)	
    AADD(aReg,QRY_DADOS->RECSE5) 
    AADD(aReg,QRY_DADOS->RECSE1) 
    AADD(aBrowse ,aReg)
    IF QRY_DADOS->E5_TIPODOC=='VL'
         nCapaE += QRY_DADOS->E5_VALOR
    EndIF                         
    IF QRY_DADOS->E5_TIPODOC=='ES'
         nCancel := .T.
    EndIF
    QRY_DADOS->(dbSkip())
End                  
IF nCancel 
    aBrowse := {}
EndIF
Return
******************************************************************************************************************************
Static Function EX_BAIXA()
Local nI      := 0                                                                   
Local nPos    := 0 
Local bRet    := .T.
Local aRec    := {}
Local cbkFil  := cFilAnt


Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.

IF MsgYESNO('Deseja efetuar a exclusao do Lote?')
	ProcRegua( Len(aBrowse) )
	DbSelectArea("SE1")
	DbSelectArea("SE5")
	BEGIN TRANSACTION
		For nI := 1 To Len(aBrowse)
			IncProc('Efetuando Baixa')
			IF aBrowse[nI][12] =='VL'
				SE1->(DbGoTo(aBrowse[nI][Len(aHeader)+2]) )
				cFilAnt := SE1->E1_FILIAL
				nSaldo    := 0
          		aBaixa    := {}
          		aBaixaSE5 := {}
          
          		aBaixa := Sel070Baixa( "VL /V2 /BA /RA /CP /LJ /"+MV_CRNEG,SE1->E1_PREFIXO, ;
          							   SE1->E1_NUM, SE1->E1_PARCELA,SE1->E1_TIPO,,,SE1->E1_CLIENTE,SE1->E1_LOJA,@nSaldo,,,)
				aSort(aBaixaSE5,,, { |x,y| x[9] < y[9] } ) // Ordeno por seq
				
				SE5->(DbGoTo(aBrowse[nI][Len(aHeader)+1]) )
				
				nPos := aScan( aBaixaSE5, { |x| x[9] == SE5->E5_SEQ })
				SE1->(DbGoTo(aBrowse[nI][Len(aHeader)+2]) )
				aRec  := { ;
							{"E1_FILIAL"   ,SE1->E1_FILIAL   ,Nil},;
							{"E1_PREFIXO"  ,SE1->E1_PREFIXO  ,Nil},;
							{"E1_NUM"      ,SE1->E1_NUM      ,Nil},;
							{"E1_TIPO"     ,SE1->E1_TIPO     ,Nil},;
							{"E1_PARCELA"  ,SE1->E1_PARCELA  ,Nil},;
							{"E1_CLIENTE"  ,SE1->E1_CLIENTE  ,Nil},;
							{"E1_LOJA"     ,SE1->E1_LOJA     ,Nil}}
				lMsErroAuto := .F.
				MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aRec,5,,nPos) //Cancelamento baixa
				If lMsErroAuto
					DISARMTRANSACTION()
					aErro := GetAutoGRLog()
					cErro := 'Prefixo: '+SE1->E1_PREFIXO+' - '+Alltrim(SE1->E1_NUM)+'/'+Alltrim(SE1->E1_PARCELA)+CRLF
					For nI := 1 to Len(aErro)
						cErro += aErro[nI] + CRLF
					Next nI
					msgAlert(cErro)
					cFilAnt := cbkFil  
					Return
				Endif 
			EndIF
		Next nI
	END TRANSACTION
	MsgAlert('Baixas canceladas com sucesso!!')
	cFilAnt := cbkFil  
Endif

Return

Static Function FIN66_CSV()

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oBtn
	Local oBold
	Local nI          := 0 
	
	Private oDlcsv                    
	Private aBrowse    := {} 
	Private aHeader    := {{' ','@!','LEFT',1,.T.}}
	Private oOK        := LoadBitmap(GetResources(),'LBOK')
	Private oNO        := LoadBitmap(GetResources(),'LBNO')
	Private aObjects
	Private aInfo
	Private aPosObj
	Private aCampSX3   := {'E1_FILIAL','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_NATUREZ','E1_CLIENTE','E1_LOJA','E1_NOMCLI','E1_EMISSAO','E1_VENCTO','E1_VENCREA','E1_VALOR','E1_SALDO','E1_DECRESC','E1_ACRESC','E1_DESCONT','E1_MULTA','E1_JUROS','E1_JUROS'}
	Private nColOrder  := 1
	Private nTipoOrder := 1
	Private cDescAg    := Alltrim(cBAgencia)+' / '+Alltrim(cBConta)
	Private cMotivo    := cMotBx
	Private nTotal     := 0 
	Private oTotal
	Private aAltSE1    := {}
	Private cLote      := ''
	Private bSair      := .F.     
	Private cClichv	          
	Private cEmpcsv
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	
	cLote := GetSXENum("SE5","E5_ZLOTEBX","E5_ZLOTEBX"+cEmpAnt)
	aObjects := {}
	AAdd( aObjects, { 0,    65, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
			 
	dbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nI := 1 to Len(aCampSX3) 
			IF SX3->(dbSeek(aCampSX3[nI]))   
				AAdd(aHeader,{SX3->X3_TITULO,SX3->X3_TAMANHO})
			EndIF
	Next nI
	aHeader[len(aHeader),01] := 'V. Recebido'
		
	IF !MGFIMPCSV()
		 RollbackSX8()  
		 Return
	EndIF
	
	DEFINE MSDIALOG oDlcsv FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Baixa Titulos via Arquivo"  PIXEL
			  
		oBrowseDados := TWBrowse():New( 50,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlcsv, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowseDados:SetArray(aBrowse)                                    
		oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }
		
		//oBrowseDados:bLDblClick  := {|| aBrowse[oBrowseDados:nAt][1] := IIF(aBrowse[oBrowseDados:nAt][1]==oOK,oNO,oOK),Define_Valores() ,oBrowseDados:DrawSelect()}
		          
		oBrowseDados:bHeaderClick:= {|oBrw,nCol| OrdenaCab(nCol,.T.)}
		oBrowseDados:bChange     := {||AtualizaBrowse()} 
		oBrowseDados:addColumn(TCColumn():new(aHeader[01,01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"    ,1,.T.,.F.,,,,,))            
		oBrowseDados:addColumn(TCColumn():new(aHeader[02,01],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"   ,aHeader[02,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[03,01],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"   ,aHeader[03,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[04,01],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"   ,aHeader[04,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[05,01],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"LEFT"   ,aHeader[05,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[06,01],{||aBrowse[oBrowseDados:nAt][06]},"@!"             ,,,"LEFT"   ,aHeader[06,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[07,01],{||aBrowse[oBrowseDados:nAt][07]},"@!"             ,,,"LEFT"   ,aHeader[07,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[08,01],{||aBrowse[oBrowseDados:nAt][08]},"@!"             ,,,"LEFT"   ,aHeader[08,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[09,01],{||aBrowse[oBrowseDados:nAt][09]},"@!"             ,,,"LEFT"   ,aHeader[09,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[10,01],{||aBrowse[oBrowseDados:nAt][10]},"@!"             ,,,"LEFT"   ,aHeader[10,02]+30,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Emissao'     ,{||aBrowse[oBrowseDados:nAt][11]},"@!"             ,,,"LEFT"   ,aHeader[11,02]+18,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Venc.'       ,{||aBrowse[oBrowseDados:nAt][12]},"@!"             ,,,"LEFT"   ,aHeader[12,02]+18,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Venc.Real'   ,{||aBrowse[oBrowseDados:nAt][13]},"@!"             ,,,"LEFT"   ,aHeader[13,02]+18,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[14,01],{||aBrowse[oBrowseDados:nAt][14]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[15,01],{||aBrowse[oBrowseDados:nAt][15]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[16,01],{||aBrowse[oBrowseDados:nAt][16]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[17,01],{||aBrowse[oBrowseDados:nAt][17]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[18,01],{||aBrowse[oBrowseDados:nAt][18]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[19,01],{||aBrowse[oBrowseDados:nAt][19]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[20,01],{||aBrowse[oBrowseDados:nAt][20]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[21,01],{||aBrowse[oBrowseDados:nAt][21]},"@E 99,999,999.99",,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:Setfocus() 

		DEFINE FONT oBold NAME "Arial" SIZE 0, -14 BOLD
			
		@ 004, 004 SAY "LOTE : "+cLote       SIZE 369, 009 OF oDlcsv FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE
	
		@ 020, 004 SAY "Motivo :"            SIZE 040, 009 OF oDlcsv  PIXEL                                     
		@ 016, 030 MSGET cMotivo             SIZE 060, 010 OF oDlcsv WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
		@ 035, 004 SAY "Banco : "            SIZE 040, 009 OF oDlcsv  PIXEL                                     
		@ 031, 030 MSGET cBBanco              SIZE 030, 010 OF oDlcsv WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	
		@ 020, 095 SAY "Data Receb.:"        SIZE 040, 009 OF oDlcsv  PIXEL                                     
		@ 016, 130 MSGET dBaixa              SIZE 050, 010 OF oDlcsv WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
		@ 035, 095 SAY "Ag./Conta :"         SIZE 040, 009 OF oDlcsv  PIXEL                                     
		@ 031, 130 MSGET cDescAg             SIZE 050, 010 OF oDlcsv WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
															  
		@ 020, 185 SAY "Data Credito :"      SIZE 040, 009 OF oDlcsv  PIXEL                                     
		@ 016, 225 MSGET dDtCredito          SIZE 050, 010 OF oDlcsv WHEN .F.  WHEN .F. COLORS 0, 16777215 PIXEL
	
		@ 020, 280 SAY "Capa do Lote :"      		 SIZE 050, 007 OF oDlcsv COLORS 0, 16777215         PIXEL        
		@ 016, 340 MSGET nCapa                       SIZE 070, 010 OF oDlcsv WHEN .F. WHEN .F. PICTURE "@E 99,999,999.99"  COLORS CLR_BLUE PIXEL
		@ 035, 280 SAY "Total Selecionado :"		 SIZE 050, 007 OF oDlcsv COLORS 0, 16777215         PIXEL
		@ 031, 340 MSGET oTotal  VAR nTotal          SIZE 070, 010 OF oDlcsv WHEN .F. PICTURE "@E 99,999,999.99"  COLORS CLR_RED PIXEL

		oBtn := TButton():New( 016				, 450,'Baixa'		, oDlcsv,{|| Processa( {|| TrtBxRa() , oDlcsv:End()  },'Aguarde...', 'Efetivando as Baixas',.F. ),IIF(bSair,oDlcsv:End(),bSair := .F.)  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtn := TButton():New( 031 				, 450,'Cancela'		, oDlcsv,{|| RollbackSX8(),oDlcsv:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( aSizeAut[4]-15	, 275,'Excel'		, oDlcsv,{|| GeraExcel(1)}   			  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
		
	ACTIVATE MSDIALOG oDlcsv CENTERED
	
Return 
	

Static Function MGFIMPCSV()

	Local cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretorio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	Local lContinua	:= .T.
	Local lFirst	:= .T.
	Local nColunas	:= 9
	Local aDados	:= {}
	Local aErros	:= {}
	Local cLinha

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " nao foi selecionado. A importacao sera abortada!","ATENCAO")
		Return
	EndIf

	If Empty(cBBanco) .or. Empty(cBAgencia) .or. Empty(cBConta) 
		MsgAlert('Dados bancarios nao informado para baixa! Favor revisar.')
		Return .F.
	EndIf 

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha := FT_FREADLN()

	FT_FGOTOP()
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			If lFirst
				aCampos := Separa(cLinha,";",.T.)
				lFirst 	:= .F.
				If Len(aCampos) < nColunas
					lContinua := .F.
				Endif
			Else
				aAdd(aDados,Separa(cLinha,";",.T.))
				If Len(aDados[Len(aDados)]) < nColunas
					lContinua := .F.
				Endif
			EndIf
			FT_FSKIP()
		EndDo
	FT_FUSE()
	
	If !lContinua
		APMsgStop(	"Estrutura do arquivo .CSV inv�lido, cada linha deve ter 9 colunas, conforme abaixo:"+CRLF+CRLF+;
					"Filial;Cliente;Loja;Nr Titulo;Prefixo;Parc;Juros;Descontos;Vr Pago " )
		Return(lContinua)
	Endif

	For _n := 1 to Len(aDados)

		aDados[_n] 		:= Asize(aDados[_n],10) 
		aDados[_n][7]	:= Val(Replace( Replace(aDados[_n][7] ,'.',''), ',' , '.')) 
		aDados[_n][8]	:= Val(Replace( Replace(aDados[_n][8] ,'.',''), ',' , '.')) 
		aDados[_n][9]	:= Val(Replace( Replace(aDados[_n][9] ,'.',''), ',' , '.')) 

		If Empty( aDados[_n][1] )   
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],; 
							aDados[_n][7], aDados[_n][8], aDados[_n][9] , "Filial nao informada para o Titulo."} )	
			lContinua	:= .F.
		EndIf
		
		If Empty( aDados[_n][2] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] , "Cliente nao informado para o Titulo."} )	
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][3] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Loja nao informada para o Titulo."	} )	
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][4] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Numero nao informado para o Titulo."} )		
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][5] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Prefixo nao informado para o Titulo."} )		
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][6] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Parcela nao informada para o Titulo."} )		
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][7] )
			aDados[_n][7] := 0
		ElseIf 	aDados[_n][7] < 0
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] , "Juros nao pode ser menor que zero."	} )	
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][8] )
			aDados[_n][8] := 0
		ElseIf 	aDados[_n][8] < 0
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Desconto nao pode ser menor que zero."	} )	
			lContinua	:= .F.
		EndIf

		If Empty( aDados[_n][9] )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Valor Pago nao informado para o Titulo."} )		
			lContinua	:= .F.
		ElseIf 	aDados[_n][9] < 0
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 			aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Valor Pago nao pode ser menor ou igual a zero."} )		
			lContinua	:= .F.
		EndIf

		If !Empty(Substr(aDados[_n][1],1,2) ) .And. ( Substr(aDados[1][1],1,2)  <> Substr(aDados[_n][1],1,2) )
			AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
							aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Titulo de empresa diferente da empresa do primeiro titulo informado."} )		
			lContinua	:= .F.
		EndIf

		cChave	:= aDados[_n][1] + aDados[_n][2] + aDados[_n][3] + aDados[_n][5] + aDados[_n][4] + aDados[_n][6] + "NF "

		//If lContinua
			dbSelectArea("SE1")
			dbSetOrder(2)
			If dbSeek(cChave)
				If E1_SALDO > 0
					If (E1_VALOR + aDados[_n][7]) < aDados[_n][9]  // Valor recebeido deve ser igual ou menor que saldo principal do titulo + juros
						AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
						aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Valor principal do titulo insuficiente para realizar a baixa!"} )
						lContinua	:= .F.	
					ElseIf aDados[_n][7] > aDados[_n][9] // Juros tem que estar composto no valor recebido
						AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
						aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Juros tem que estar composto no valor recebido! O valor recebido nao pode ser menor que o juros."} )
						lContinua	:= .F.	
					ElseIf E1_SALDO < (aDados[_n][8] + aDados[_n][9] - aDados[_n][7] ) // Possui saldo para baixar (desconto + vlr recebido )
						AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
						aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Saldo do titulo insuficiente para baixar desconto e valor recebido!"} )
						lContinua	:= .F.	
					Else 
						aadd(aBrowse,{oOK,E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_SALDO,E1_DECRESC,E1_ACRESC,aDados[_n][8],E1_MULTA,aDados[_n][7],aDados[_n][9]  , Recno() })  
						nTotal += aDados[_n][9] 
						cClichv	:= aDados[1][2]
						cEmpcsv	:= Substr(aDados[1][1] ,1,2)
					EndIf
				Else
					AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
					aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Titulo sem saldo!"} ) 
					lContinua	:= .F.	
				EndIf
			Else
				AADD(aErros , { aDados[_n][1] , aDados[_n][2] , aDados[_n][3], aDados[_n][4] , aDados[_n][5] , aDados[_n][6],;
				 				aDados[_n][7], aDados[_n][8], aDados[_n][9] ,  "Titulo nao encontrado!"} )		
				lContinua	:= .F.	
			EndIf 
		//EndIf

	Next _n

	If !lContinua 
		FIN66_ERR(aErros)
		Return(lContinua)
	EndIf

Return(lContinua)

Static Function FIN66_ERR(aDados)

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oBtn
	Local oBold
	Local nI          := 0 
	
	Local oDlg                    
	Local aBrowse    := aDados 
	Local aHeader    := {}
	Local aObjects
	Local aInfo
	Local aPosObj
	Local aCampSX3   := {'E1_FILIAL','E1_CLIENTE','E1_LOJA','E1_NUM','E1_PREFIXO','E1_PARCELA','E1_JUROS','E1_DESCONT','E1_VALOR','E1_HIST'}
	Local nColOrder  := 1
	Local nTipoOrder := 1
	Local cDescAg    := Alltrim(cBAgencia)+' / '+Alltrim(cBConta)
	Local cMotivo    := cMotBx
	Local nTotal     := 0 
	Local oTotal
	Local aAltSE1    := {}
	Local cLote      := ''
	Local bSair      := .F.                                                                                           
	
	aObjects := {}
	AAdd( aObjects, { 0		,  20, .T., .F. } )
	AAdd( aObjects, { 100	, 100, .T., .T. } )
	AAdd( aObjects, { 0		,  20, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects ,.T. )

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD	
			 
	dbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nI := 1 to Len(aCampSX3) 
			IF SX3->(dbSeek(aCampSX3[nI]))   
				AAdd(aHeader,{SX3->X3_TITULO,SX3->X3_TAMANHO})
			EndIF
	Next nI

	
	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Log: Leitura de erros no arquivo"  PIXEL
			  
		oBrowseDados := TWBrowse():New( 004,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowseDados:SetArray(aBrowse)                                    
		oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }
		
		//oBrowseDados:bLDblClick  := {|| aBrowse[oBrowseDados:nAt][1] := IIF(aBrowse[oBrowseDados:nAt][1]==oOK,oNO,oOK),Define_Valores() ,oBrowseDados:DrawSelect()}
		          
		oBrowseDados:bHeaderClick:= {|oBrw,nCol| OrdenaCab(nCol,.T.)}
		oBrowseDados:bChange     := {||AtualizaBrowse()} 
		
		oBrowseDados:addColumn(TCColumn():new(aHeader[01,01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"   ,aHeader[01,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[02,01],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"   ,aHeader[02,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[03,01],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"   ,aHeader[03,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[04,01],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"   ,aHeader[04,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[05,01],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"LEFT"   ,aHeader[05,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[06,01],{||aBrowse[oBrowseDados:nAt][06]},"@!"             ,,,"LEFT"   ,aHeader[06,02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[07,01],{||aBrowse[oBrowseDados:nAt][07]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aHeader[08,01],{||aBrowse[oBrowseDados:nAt][08]},"@E 99,999,999.99",,,"RIGHT" ,30,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Valor Pago'	,{||aBrowse[oBrowseDados:nAt][09]},'@E 99,999,999.99',,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Error log'	,{||aBrowse[oBrowseDados:nAt][10]},"@!"              ,,,"LEFT"   ,aHeader[10,02],.F.,.F.,,,,,))
		oBrowseDados:Setfocus() 

		oBtn := TButton():New( aSizeAut[4]-25	, 300,'Ok'			, oDlg,{|| oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return() 

Static Function TrtBxRa()
Local oDlgTrt
Local lRet := .F.
Local oLoja 	:= Nil
Local cCliente	:= cClichv
Local cLoja		:= '01' 
Local cNat		:= GetNewpar('MGF_F66X','30108')
Local cHist		:= CriaVar("E1_HIST")
Local cFilRa	:= cEmpcsv+"0001"
Local cFilBkp	:= cFilAnt 
 
Do Case
Case nTotal > nCapa 
	msgAlert('Valor selecionado dos titulos � maior da Capa de Lote !!')
	Return .F.

Case nTotal == nCapa 
	FIN66_BAIXA(.F.)

Case nTotal < nCapa 
	IF MsgYESNO('Total pago dos titulos � menor que o valor informado na capa do lote. Deseja gerar um RA com o saldo?')

		DEFINE MSDIALOG oDlgTrt TITLE "Par�metros para gerar RA" FROM 000, 000  TO 230, 400 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME

			nUltLin    := 15
			nCol       := 15
			@ nUltLin,nCol SAY "Cliente" 		SIZE 65, 07 OF oDlgTrt  PIXEL 
			@ nUltLin,nCol+50 MSGET cCliente 	SIZE 35, 07 OF oDlgTrt  PIXEL F3 "SA1" VALID ExistCpo("SA1",cCliente) 
			
			nUltLin += 12
			@ nUltLin,nCol SAY "Loja" 					SIZE 32, 07 OF oDlgTrt PIXEL 
			@ nUltLin,nCol+50 MSGET oLoja Var cLoja 	SIZE 30, 07 OF oDlgTrt PIXEL 
			oLoja:Disable()
			

			nUltLin += 12
			@ nUltLin,nCol SAY "Natureza"	SIZE 32, 07 OF oDlgTrt PIXEL 
			@ nUltLin,nCol+50 MSGET cNat  	SIZE 65, 08 OF oDlgTrt PIXEL F3 "SED" VALID ExistCpo("SED",cNat) 

			nUltLin += 12
			@ nUltLin,nCol SAY "Historico" 	SIZE 32, 07 OF oDlgTrt PIXEL 
			@ nUltLin,nCol+50 MSGET cHist 	SIZE 65, 08 OF oDlgTrt PIXEL

			nUltLin += 30
			oTButton := TButton():New( nUltLin, 15, "&Processar",oDlgTrt	,{|| lOk:= .T.	,oDlgTrt:End() }	,32,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oTButton := TButton():New( nUltLin, 55, "&Cancelar"	,oDlgTrt	,{|| lOk:= .F. 	,oDlgTrt:End() }	,32,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oDlgTrt:lEscClose   := .F.
		
		ACTIVATE MSDIALOG oDlgTrt CENTERED

		If lOk
			lRet	:= FIN66_BAIXA(.T.)
			IF lRet
				IncProc('Gerando titulo Ra')
				cFilAnt := cFilRa
				cNumRa	:= GETSXENUM("SE1","E1_NUM") 	
				ConfirmSX8()  
				Begin Transaction
					aTitulo := {{ "E1_FILIAL", cFilRa				, NIL },;
					{ "E1_NUM"     	, cNumRa						, NIL },;
					{ "E1_PREFIXO"	, GetNewpar('MGF_F66PRE','MAN')	, NIL },;
					{ "E1_PARCELA"  , GetNewpar('MGF_F66PAR','01')  , NIL },;
					{ "E1_TIPO"     , GetNewpar('MGF_F66TIP','RA ') , NIL },;
					{ "E1_PORTADO" 	, cBBanco			, Nil },;
					{ "E1_AGEDEP"  	, cBAgencia			, Nil },;
					{ "E1_CONTA"   	, cBConta			, Nil },;
					{ "E1_NATUREZ"  , cNat       		, NIL },;
					{ "E1_CLIENTE"  , cCliente    		, NIL },;
					{ "E1_LOJA"     , cLoja 			, NIL },;
					{ "E1_EMISSAO"  , dBaixa     		, NIL },;
					{ "E1_VENCTO"   , dBaixa	     	, NIL },;
					{ "E1_HIST"   	, cHist        		, NIL },;
					{ "E1_VALOR"    , nCapa - nTotal   	, NIL }}
					
					lMsErroAuto := .F.
					MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, 3)  
					If lMsErroAuto
						msgAlert('Erro na geracao do titulo (RA). As baixas dos titulos nao serao estornadas.','MGFFIN66')
						If (!IsBlind()) 
							 MostraErro()
						Else 
							cError := MostraErro("/dirdoc", "error.log") 
							ConOut("Error: "+ cError)
						EndIf
						RollBackSx8()
						DisarmTransaction()
						Break
					Else
						MsgInfo('RA ' + SE1->E1_NUM + ' gerada com sucesso.', 'MGFFIN66')
					EndIf
				End Transaction
				cFilAnt := cFilBkp
			Else
				Alert("Nao foi possivel gerar o RA devido a problema com a baixa dos titulos.")	
			EndIF
		EndIf
	EndIf 
EndCase

Return() 