#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSGRAPHI.CH"  


#DEFINE LINHAS 999
#define CRLF chr(13) + chr(10)             


/*
==================================================================================
Programa............: MGFTAP18
Autor...............: Marcelo Carneiro
Data................: 20/09/2016
Descricao / Objetivo: Painel de Gestão de Produção Taura x Protheus.
Doc. Origem ........: MIT044 - GAP Monitor Integração - Frente Shape. 
Solicitante.........: Marfrig - Euzivanio
Uso.................: Gestão de Estoques 
==================================================================================
*/

User Function MGFTAP18()
Local aSizeAut    := MsAdvSize(,.F.,400)
Local  nI      := 0 

Private cbLine  := ''
Private oDlg    
Private oBold
Private aObjects
Private aInfo
Private aPosObj
Private aBrowse      := {}
Private aOperacao    := {}
Private aHeader      := {"Operação",'Data','OP','Produto','Deescrição','UM',;
						 "TAURA"+CRLF+'Entada',"TAURA"+CRLF+'Saída',"TAURA"+CRLF+'Saldo',;
						 "PROTHEUS"+CRLF+'Entada',"PROTHEUS"+CRLF+'Saída',"PROTHEUS"+CRLF+'Saldo',;
						 "DIFERENÇA"+CRLF+'Entada',"DIFERENÇA"+CRLF+'Saída',"DIFERENÇA"+CRLF+'Saldo'}
Private aTam         := {80        ,30    ,30   ,40      ,80          ,15   ,30,30,30,30,30,30,30,30,30} 
Private aCabDados    := AClone(aHeader)
Private oBrowseDados
Private aGeral       := {}
Private oCmb1    
Private oCmb2    
Private oCmb3    
Private oCmb4    
Private oCmb5                       
Private nComboBo1 := ''
Private nComboBo2 := ''
Private nComboBo3 := ''
Private nComboBo4 := ''
Private nComboBo5 := ''
Private aCmb01    := {}
Private aCmb02    := {}
Private aCmb03    := {}
Private aCmb04    := {}
Private aCmb05    := {'Todos','Com Diferença'}


dbSelectArea('ZZE')
Define_Parametros(1)
IF Len(aBrowse) = 0 
     MsgAlert('Não há dados para o filtro selecionado !')
     Return
ENDIF                                                         


DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

aObjects := {}
AAdd( aObjects, { 0,    65, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )


DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Monitor de Integrações de Produção"  OF oMainWnd PIXEL
                                            
	oBrowseDados := TWBrowse():New( 80,aPosObj[2,2],aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3],,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowseDados:addColumn(TCColumn():new(aHeader[01],{||aBrowse[oBrowseDados:nAt][01]},"@!"             ,,,"LEFT"  ,aTam[01],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[02],{||aBrowse[oBrowseDados:nAt][02]},"@!"             ,,,"LEFT"  ,aTam[02],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[03],{||aBrowse[oBrowseDados:nAt][03]},"@!"             ,,,"LEFT"  ,aTam[03],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[04],{||aBrowse[oBrowseDados:nAt][04]},"@!"             ,,,"LEFT"  ,aTam[04],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[05],{||aBrowse[oBrowseDados:nAt][05]},"@!"             ,,,"LEFT"  ,aTam[05],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[06],{||aBrowse[oBrowseDados:nAt][06]},"@!"             ,,,"LEFT"  ,aTam[06],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[07],{||aBrowse[oBrowseDados:nAt][07]},"@E 9,999,999.99",,,"RIGHT" ,aTam[07],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[08],{||aBrowse[oBrowseDados:nAt][08]},"@E 9,999,999.99",,,"RIGHT" ,aTam[08],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[09],{||aBrowse[oBrowseDados:nAt][09]},"@E 9,999,999.99",,,"RIGHT" ,aTam[09],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[10],{||aBrowse[oBrowseDados:nAt][10]},"@E 9,999,999.99",,,"RIGHT" ,aTam[10],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[11],{||aBrowse[oBrowseDados:nAt][11]},"@E 9,999,999.99",,,"RIGHT" ,aTam[11],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[12],{||aBrowse[oBrowseDados:nAt][12]},"@E 9,999,999.99",,,"RIGHT" ,aTam[12],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[13],{||aBrowse[oBrowseDados:nAt][13]},"@E 9,999,999.99",,,"RIGHT" ,aTam[13],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[14],{||aBrowse[oBrowseDados:nAt][14]},"@E 9,999,999.99",,,"RIGHT" ,aTam[14],.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new(aHeader[15],{||aBrowse[oBrowseDados:nAt][15]},"@E 9,999,999.99",,,"RIGHT" ,aTam[15],.F.,.F.,,,,,))       
	oBrowseDados:SetArray(aBrowse)                                    
	cbLine := "{||{ aBrowse[oBrowseDados:nAt,01] "                      
	For nI := 2 To Len(aHeader)
	 cbLine += ",aBrowse[oBrowseDados:nAt,"+STRZERO(nI,2)+"]"
	Next nI         
	cbLine +="  } }"
	oBrowseDados:bLine      := &cbLine          
	oBrowseDados:lUseDefaultColors := .F.                
	oBrowseDados:SetBlkBackColor({|| Get_Cor_Grid(oBrowseDados::nAt,1)})
	oBrowseDados:SetBlkColor({|| Get_Cor_Grid(oBrowseDados::nAt),2})

	                     
	@ 013, 007 SAY   "Filial:"      SIZE 061, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 010, 030 MSGET  MV_PAR01      SIZE 048, 010 OF oDLG When .F. PICTURE '@!' COLORS 0, 16777215 PIXEL
    @ 013, 080 SAY    "Data Produção :" SIZE 100, 010 OF oDlg  									 COLORS 0, 16777215 PIXEL
    @ 010, 123 MSGET  MV_PAR02      SIZE 048, 010 OF oDLG When .F. PICTURE '@!' COLORS 0, 16777215 PIXEL
    @ 013, 174 SAY    "a" 	        SIZE 012, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 010, 183 MSGET  MV_PAR03      SIZE 048, 010 OF oDLG When .F. PICTURE '@!' COLORS 0, 16777215 PIXEL


    @ 025, 008 GROUP oGroup1 TO 077, 400 PROMPT "Filtro" OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 035, 052 SAY "Data" SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 032, 086 MSCOMBOBOX oCmb1 VAR nComboBo1 ITEMS aCmb01 SIZE 072, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    
	@ 050, 052 SAY  "OP" SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 047, 086 MSCOMBOBOX oCmb2 VAR nComboBo2 ITEMS aCmb02 SIZE 072, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    
	@ 065, 052 SAY "Operação" SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ 062, 086 MSCOMBOBOX oCmb3 VAR nComboBo3 ITEMS aCmb03 SIZE 072, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    
    @ 035, 170 SAY "Produto" SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 032, 203 MSCOMBOBOX oCmb4 VAR nComboBo4 ITEMS aCmb04 SIZE 072, 010 OF oGroup1 COLORS 0, 16777215 PIXEL

    @ 050, 170 SAY "Diferença" SIZE 025, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 047, 203 MSCOMBOBOX oCmb5 VAR nComboBo5 ITEMS aCmb05 SIZE 072, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
    
	oBtn := TButton():New( 060, 320,'Filtro', oGroup1,{|| Filtra_Dados(2) }     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            

	oBrowseDados:Setfocus() 
	oBtn := TButton():New( 005, aPosObj[3,4]-050,'Sair'            , oDlg,{|| oDlg:End()}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( 019, aPosObj[3,4]-050,'Refresh'         , oDlg,{|| Define_Parametros(2) } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( 033, aPosObj[3,4]-050,'Integrações'     , oDlg,{|| Con_Integr()}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	oBtn := TButton():New( 047, aPosObj[3,4]-050,'Excel'           , oDlg,{|| GeraExcel()      }     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )                                                                                            
	
ACTIVATE MSDIALOG oDlg 

Return 
******************************************************************************************************************************
Static Function MontaCab(nTipo)            

Local cQuery      := ""
Local aReg        := {}                    
Local nI          := 0 
Local aMontaArq   := {}
Local aQuant      := {}  

aMontaArq := Ret_Taura()
aGeral    := {}
aBrowse   := {}
aOperacao := {}
nComboBo1 := 'Todos'
nComboBo2 := 'Todos'
nComboBo3 := 'Todos'
nComboBo4 := 'Todos'
nComboBo5 := 'Todos'
aCmb01    := {} //Data
aCmb02    := {} //OP
aCmb03    := {} //Operação
aCmb04    := {} // Produto

IF Len(aMontaArq) <>  0
	SB1->(dbSetOrder(1))
	For nI:= 1 To Len(aMontaArq)
		IF aScan( aCmb01, { |x| x == DTOC(STOD(aMontaArq[nI,03])) }) == 0 
             AADD(aCmb01, DTOC(STOD(aMontaArq[nI,03])))      
		EndIF
		IF aScan( aCmb02, { |x| x == aMontaArq[nI,04] }) == 0 
             AADD(aCmb02, aMontaArq[nI,04])      
		EndIF
		IF aScan( aCmb03, { |x| x == aMontaArq[nI,02] }) == 0 
             AADD(aCmb03, aMontaArq[nI,02])      
		EndIF
		IF aScan( aCmb04, { |x| x == aMontaArq[nI,05] }) == 0 
             AADD(aCmb04, aMontaArq[nI,05])      
		EndIF
		SB1->(dbSeek(xFilial('SB1')+Alltrim(aMontaArq[nI,05])))
		aQuant := CON_PROTHEUS(MV_PAR01,aMontaArq[nI,04],aMontaArq[nI,05])
		AAdd(AGeral,{aMontaArq[nI,02],; //OPeração
 					 STOD(aMontaArq[nI,03]),; //Data
 					 aMontaArq[nI,04],; //OP
 					 aMontaArq[nI,05],; //Produto
 					 SB1->B1_DESC,; //Descrição
 					 SB1->B1_UM,; //UM
 					 aMontaArq[nI,06],; //Entrada T
 					 aMontaArq[nI,07],; //Saida T
 					 aMontaArq[nI,06] - aMontaArq[nI,07],; //Saldo T
 					 aQuant[01],; //P
 					 aQuant[02],; //P
 					 aQuant[01]-aQuant[02],; //P
 					 aMontaArq[nI,06] - aQuant[01],; //D
 					 aMontaArq[nI,07] - aQuant[02],; //D
 					 (aMontaArq[nI,06] - aMontaArq[nI,07]) - (aQuant[01]-aQuant[02] ) }) //D
					
	Next nI                 
	aCmb01:= Ordena(aCmb01)
	aCmb02:= Ordena(aCmb02)
	aCmb03:= Ordena(aCmb03)
	aCmb04:= Ordena(aCmb04)
EndIF
Filtra_Dados(nTipo)


RETURN

********************************************************************************************************************************
Static Function Define_Parametros(nTipo)
Local aRet		  := {}
Local aParambox	  := {}                 
Local bResult     := .F.

AAdd(aParamBox, {1, "Filial:"       	,Space(tamSx3("A1_FILIAL")[1])      , "@!",                           ,"XM0" ,, 070	, .T.	})
AAdd(aParamBox, {1, "Dt. Produção de:"	,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .T.	})
AAdd(aParamBox, {1, "Dt. Produção Até:"  ,CTOD('  /  /  ')                     , "@!",                           ,      ,, 070	, .T.	})
IF ParamBox(aParambox, "Filtro para Selecionar os Dados"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	Processa( {|| MontaCab(nTipo) },'Aguarde...', 'Selecionando Registros',.F. )
EndIF

Return 

*******************************************************************************************************************************************************
Static Function Ordena(aAux)
Local nI   := 0
Local aRet := {'Todos'}

aSort(aAux,,,{|x,y| x < y })                                 
For nI := 1 To Len(aAux)
   AAdd(aRet,aAux[nI])
Next

Return aRet 
*******************************************************************************************************************************************************
Static Function Filtra_Dados(nTipo)
 
Local nI      := 0 

aBrowse  := {}
aOperacao := {}
For nI := 1 To Len (AGeral)
     IF Ativa_Filtro(nI,nTipo)
         nPos := aScan( aBrowse, { |x| x[1] == AGeral[nI,01] }) 
    	 IF nPos == 0       
    	     AAdd(aBrowse,{AGeral[nI,01],; //OPeração
 					       '',; //Data
 					       '',; //OP
 					       '',; //Produto
 					       '',; //Descrição
 					       '',; //UM
 					       0,; //Entrada T
 					       0,; //Saida T
 					       0,; //Saldo T
 					 0,; //P
 					 0,; //P
 					 0,; //P
 					 0,; //D
 					 0,; //D
 					 0}) //D         
 			 AAdd(aOperacao,'')
    	 EndIF
    	 nPos     := aScan( aBrowse, { |x| x[1] == AGeral[nI,01] }) 
         aBrowse[nPos,07] +=  AGeral[nI,07]
         aBrowse[nPos,08] +=  AGeral[nI,08]
         aBrowse[nPos,09] +=  AGeral[nI,09]
         aBrowse[nPos,10] +=  AGeral[nI,10]
         aBrowse[nPos,11] +=  AGeral[nI,11]
         aBrowse[nPos,12] +=  AGeral[nI,12]
         aBrowse[nPos,13] +=  AGeral[nI,13]
         aBrowse[nPos,14] +=  AGeral[nI,14]
         aBrowse[nPos,15] +=  AGeral[nI,15]
         AAdd(aBrowse,{'',; //OPeração
 					   AGeral[nI,02],;
 					   AGeral[nI,03],;
 					   AGeral[nI,04],;
 					   AGeral[nI,05],;
 					   AGeral[nI,06],;
 					   AGeral[nI,07],;
 					   AGeral[nI,08],;
 					   AGeral[nI,09],;
 					   AGeral[nI,10],;
 					   AGeral[nI,11],;
 					   AGeral[nI,12],;
 					   AGeral[nI,13],;
 					   AGeral[nI,14],;
 					   AGeral[nI,15]} )
 		AAdd(aOperacao,SUBSTR(AGeral[nI,01],1,2) )	 
     EndIF
Next nI

AAdd(aBrowse,{'Total Geral',; //OPeração
				'',; //Data
				'',; //OP
				'',; //Produto
				'',; //Descrição
				'',; //UM
				0,; //Entrada T
				0,; //Saida T
				0,; //Saldo T
				0,; //P
				0,; //P
				0,; //P
				0,; //D
				0,; //D
				0}) //D     
AAdd(aOperacao,'')				
nPos := Len(aBrowse)
For nI := 1 To Len(aBrowse)-1
	IF !Empty(aBrowse[nI,01])
		aBrowse[nPos,07] +=  aBrowse[nI,07]
		aBrowse[nPos,08] +=  aBrowse[nI,08]
		aBrowse[nPos,09] +=  aBrowse[nI,09]
		aBrowse[nPos,10] +=  aBrowse[nI,10]
		aBrowse[nPos,11] +=  aBrowse[nI,11]
		aBrowse[nPos,12] +=  aBrowse[nI,12]
		aBrowse[nPos,13] +=  aBrowse[nI,13]
		aBrowse[nPos,14] +=  aBrowse[nI,14]
		aBrowse[nPos,15] +=  aBrowse[nI,15]
	EndIF
Next nI
IF nTipo == 2 
    oBrowseDados:SetArray(aBrowse)                                    
	cbLine := "{||{ aBrowse[oBrowseDados:nAt,01] "                      
	For nI := 2 To Len(aHeader)
	 cbLine += ",aBrowse[oBrowseDados:nAt,"+STRZERO(nI,2)+"]"
	Next nI         
	cbLine +="  } }"
	oBrowseDados:bLine      := &cbLine          
	oBrowseDados:DrawSelect()
	oBrowseDados:Refresh()   
EndIF
Return
***********************************************************************************************************************
Static Function Ativa_Filtro(nI,nTipo)
Local bRet  := .T.            

IF nTipo == 2         
	IF Alltrim(nComboBo1) <> 'Todos'
	    IF DTOC(AGeral[nI,02]) <> nComboBo1
	        bRet :=.F.
	    EndIF
	EndIF
	IF bRet .AND. Alltrim(nComboBo2) <> 'Todos'
	    IF  AGeral[nI,03] <> nComboBo2
	        bRet :=.F.
	    EndIF
	EndIF
	IF bRet .AND. Alltrim(nComboBo3) <> 'Todos'
	    IF  AGeral[nI,01] <> nComboBo3
	        bRet :=.F.
	    EndIF
	EndIF
	IF bRet .AND. Alltrim(nComboBo4) <> 'Todos'
	    IF  AGeral[nI,04] <> nComboBo4
	        bRet :=.F.
	    EndIF
	EndIF
	IF bRet .AND. Alltrim(nComboBo5) <> 'Todos'
	    IF  AGeral[nI,15] == 0
	        bRet :=.F.
		EndIF
	EndIF
EndIF
            
Return bRet 




******************************************************************************************************************************
Static Function Get_Cor_Grid(nLinha,nTipoCor)
Local nRet := 16777215

IF nTipoCor == 1
	nRet := CLR_WHITE
	IF !Empty(aBrowse[nLinha,1])
		nRet := CLR_HGRAY
	EndIF
ELSEIF nTipoCor == 2
	nRet := CLR_BLACK
	IF !Empty(aBrowse[nLinha,1])
		nRet := CLR_BLACK
	EndIF
EndIF
	
Return nRet
***************************************************************************************************************
Static Function GeraExcel()            

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf         


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({ {"ARRAY", 'Monitor', aCabDados, aBrowse} }) })                                          
       
Return
********************************************************************************************************************************************
Static Function CON_PROTHEUS(cFilSaldo,cOP,cProduto)

Local cQuery    := ''     
Local aRetorno  := {} 
Local aRec      := {}
Private cTMDev2		:= GetMv("MGF_TAP02U",,"001")
                      

cQuery  := " SELECT CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN 'CS'"
cQuery  += "             WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "             WHEN  D3_TM >= '500' THEN 'CS' "
cQuery  += "        END TIPO, "
cQuery  += "        Sum(CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN -1"
cQuery  += "            ELSE 1  END * D3_QUANT)  TOTAL "
cQuery  += " FROM "+RetSqlName('SD3')
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND D3_FILIAL   = '"+cFilSaldo+"'"
cQuery  += "   AND D3_ZOPTAUR  = '"+cOP+"'"
cQuery  += "   AND D3_COD      = '"+cProduto+"'"
cQuery  += "   AND D3_ESTORNO <> 'S' "   
cQuery  += "   AND D3_OP       = ' ' "   
cQuery  += " GROUP BY CASE WHEN  D3_TM  ='001'  THEN 'CS'"
cQuery  += "          	   WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "               WHEN  D3_TM >= '500' THEN 'CS' END"
If Select("QRY_OP") > 0
	QRY_OP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_OP",.T.,.F.)
dbSelectArea("QRY_OP")
QRY_OP->(dbGoTop())
aRetorno := {0,0}
While !QRY_OP->(EOF())
	IF QRY_OP->TIPO == 'CS'
		aRetorno[02] := QRY_OP->TOTAL
	Else
		aRetorno[01] := QRY_OP->TOTAL                                                
	EndIF
	QRY_OP->(dbSkip())
End                            
IF aRetorno[01] > aRetorno[02]
      aRetorno[01] := aRetorno[01] - aRetorno[02]
      aRetorno[02] := 0 
ElseIF aRetorno[01] < aRetorno[02]
      aRetorno[02] := aRetorno[02] - aRetorno[01]
      aRetorno[01] := 0 
Else
    aRetorno[02] := 0  
    aRetorno[01] := 0 
EndIF
cQuery  := " SELECT CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN 'CS'"
cQuery  += "             WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "             WHEN  D3_TM >= '500' THEN 'CS' "
cQuery  += "        END TIPO, "
cQuery  += "        Sum(CASE WHEN  D3_TM  ='"+cTMDev2+"'  THEN -1"
cQuery  += "            ELSE 1  END * D3_QUANT)  TOTAL "
cQuery  += " FROM "+RetSqlName('SD3')
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND D3_FILIAL   = '"+cFilSaldo+"'"
cQuery  += "   AND D3_ZOPTAUR  = '"+cOP+"'"
cQuery  += "   AND D3_COD      = '"+cProduto+"'"
cQuery  += "   AND D3_ESTORNO <> 'S' "   
cQuery  += "   AND D3_OP       <> ' ' "   
cQuery  += " GROUP BY CASE WHEN  D3_TM  ='001'  THEN 'CS'"
cQuery  += "          	   WHEN  D3_TM < '500'  THEN 'PR'"
cQuery  += "               WHEN  D3_TM >= '500' THEN 'CS' END"
If Select("QRY_OP") > 0
	QRY_OP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_OP",.T.,.F.)
dbSelectArea("QRY_OP")
QRY_OP->(dbGoTop())
While !QRY_OP->(EOF())
	IF QRY_OP->TIPO == 'CS'
		aRetorno[02] += QRY_OP->TOTAL
	Else
		aRetorno[01] += QRY_OP->TOTAL                                                
	EndIF
	QRY_OP->(dbSkip())
End




Return aRetorno
******************************************************************************************************************************************************************
Static Function Con_Integr()
Local oBtn
Local oDlg1            
Local oRed    := LoadBitmap(GetResources(),'BR_VERMELHO') 
Local oVerde  := LoadBitmap(GetResources(),'BR_VERDE') 
Local oAmarelo:= LoadBitmap(GetResources(),'BR_AMARELO') 
Private aRecno     := {}
Private aZZE       := {}
Private oListZZE   := {}	                       
Private aCabZZE    := {}
Private nTipoOrder := 1

IF Empty(aOperacao[oBrowseDados:nAt])
    MsgAlert('Não é possivel analisar os movimentos do cabeçalho')
    Return
EndIF

Dados_ZZE()
IF Len(aZZE) == 0 
    MsgAlert('Sem dados de Integração')
    Return
EndIF

DEFINE MSDIALOG oDlg1 TITLE "Lista Integrações" FROM 000, 000  TO 400, 1000 COLORS 0, 16777215 PIXEL

	//@ 005, 005 LISTBOX oListZZE	 Fields HEADER aCabZZE SIZE 490,190 OF oDlg1 COLORS 0, 16777215 PIXEL  
	oListZZE := TWBrowse():New( 005, 005,490,190   ,,aCabZZE,,oDlg1, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oListZZE:SetArray(aZZE)
	cbLine := "{||{ IIF(aZZE[oListZZE:nAt,01]=='2',oRed,IIF(aZZE[oListZZE:nAt,01]=='1',oVerde,oAmarelo)) "                      
	//cbLine := "{||{ aZZE[oListZZE:nAt,01]  "                      
	For nI := 2 To Len(aCabZZE)
	 cbLine += ",aZZE[oListZZE:nAt,"+STRZERO(nI,2)+"]"
	Next nI         
	cbLine +="  } }"	
	oListZZE:bLine := &cbLine
	oListZZE:bHeaderClick  := {|oBrw,nCol| OrdenaCab(nCol,.T.)}
    oListZZE:DrawSelect()           
    oListZZE:bLDblClick := {|| Mostra_Erro()}       
      

ACTIVATE MSDIALOG oDlg1 CENTERED

Return
*********************************************************************************************************************************************
Static Function Dados_ZZE

Local cQuery  := ''
Local aCampos :={}
Local nI      := 0 
Local aRec    := {}



aZZE     :={}       
aCabZZE  :={' '}

//Montando o Header do Itens
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZE"))
While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "ZZE" 
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. Alltrim(SX3->X3_CAMPO) <>'ZZE_MSGERR'
	   	AADD( aCabZZE, AllTrim( X3Titulo() ))
	   	AAdd(aCampos, SX3->X3_CAMPO)
	Endif
	SX3->(dbSkip())                          
EndDo

cQuery := " SELECT a.*, R_E_C_N_O_ RECZZE "
cQuery += " FROM "+RetSQLName("ZZE")+" a " 
cQuery += " WHERE ZZE_FILIAL = '" + MV_PAR01 + "' " 
cQuery += "   AND ZZE_COD    = '" + aBrowse[oBrowseDados:nAt][04] + "' " 
cQuery += "   AND ZZE_OPTAUR = '" + aBrowse[oBrowseDados:nAt][03] + "' " 
cQuery += "   AND ZZE_TPOP   = '" + aOperacao[oBrowseDados:nAt] + "' " 
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_ZZE") > 0
	QRY_ZZE->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZE",.T.,.F.)
dbSelectArea("QRY_ZZE")
QRY_ZZE->(dbGoTop())
While !QRY_ZZE->(EOF())        
    aRec := {}                   
    AAdd(aRec,QRY_ZZE->ZZE_STATUS)
    For nI := 1 To Len(aCampos)
    	AAdd(aRec, &('QRY_ZZE->'+aCampos[nI]) )
    Next
    AADD(aZZE,aRec)
    AAdd(aRecno,QRY_ZZE->RECZZE)
    QRY_ZZE->(dbSkip())
EndDo       

Return
*********************************************************************************************************************************************
Static Function OrdenaCab(nCol,bMudaOrder)
Local aOrdena := {}       
Local aTotal  := {}
				   
aOrdena := AClone(aZZE)                                         
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
aZZE    := aOrdena
nColOrder  := nCol
oListZZE:DrawSelect()
oListZZE:Refresh()          

Return
************************************************************************************************************************
Static Function Mostra_Erro
Private cERRO := ''
Private oDLG3
Private oMGet1
Private nRecno := aRecno[oListZZE:nAt]
        
dbSelectArea('ZZE')
ZZE->(dbGoTo(nRecno))
cERRO  := ZZE->ZZE_MSGERR
oDLG3  := MSDialog():New( 075,297,575,759,"Erro da Integração",,,.F.,,,,,,.T.,,,.T. )
oMGet1 := TMultiGet():New( 004,004,{|u| If(PCount()>0,cERRO:=u,cERRO)},oDLG3,216,232,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oDLG3:Activate(,,,.T.)

Return


Return
*******************************************************************************************************************************************
Static Function Ret_Cod_Correto(cCodPro, cOperacao, cTPMOV)
Local cCod      := cCodPro
Local lCodAgr	:= GetMV("MGF_TAP01A",,.F.) // ExistField("SB1","B1_ZCODAGR")
Local cCodRep	:= GetMV("MGF_TAP01B",,"XX/")
Local cCodDes	:= GetMV("MGF_TAP01C",,"05/06/07/08/09/")

dbSelectArea("SB1")
If lCodAgr .AND. SB1->( dbSeek( xFilial("SB1")+Alltrim(cCodPro) ) )
	IF cTPMOV == 'PRD'
		If !Empty( SB1->B1_ZCODAGR ) .And. cTPMOV $ cCodRep
			cCod      := SB1->B1_ZCODAGR
		EndIF
	Else
		If !Empty( SB1->B1_ZCODAGR ) .And. cTPMOV $ cCodDes
			cCod      := SB1->B1_ZCODAGR
		EndIF
	EndiF
EndIF

Return cCod

/*
Local aDados := {}
Local aRec   := {}     
Local cChave := ''
Local nPos   := ''
                  
cQuery  := " Select ZZE_TPOP,ZZE_GERACA, ZZE_OPTAUR,ZZE_COD,CASE WHEN ZZE_TPMOV ='02' THEN 'CSN' ELSE 'PRD' END TIPO,SUM(ZZE_QUANT) QUANT"
cQuery  += " from ZZE010 Where ZZE_FILIAL = '010003' AND ZZE_DTREC >= '20180309' "
cQuery  += " Group by ZZE_TPOP,ZZE_GERACA, ZZE_OPTAUR,ZZE_COD,CASE WHEN ZZE_TPMOV ='02' THEN 'CSN' ELSE 'PRD' END "

If Select("QRY_TAU") > 0
	QRY_TAU->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_TAU",.T.,.F.)
dbSelectArea("QRY_TAU")
QRY_TAU->(dbGoTop())
While QRY_TAU->(!Eof())
    aRec   := {}  
    nPos := aScan( aDados, { |x| x[1] == QRY_TAU->ZZE_TPOP+QRY_TAU->ZZE_GERACA+QRY_TAU->ZZE_OPTAUR+QRY_TAU->ZZE_COD }) 
    IF nPos == 0                    
    	AAdd(aRec,QRY_TAU->ZZE_TPOP+QRY_TAU->ZZE_GERACA+QRY_TAU->ZZE_OPTAUR+QRY_TAU->ZZE_COD)
	    AAdd(aRec,QRY_TAU->ZZE_TPOP)
	    AAdd(aRec,QRY_TAU->ZZE_GERACA)	
	    AAdd(aRec,QRY_TAU->ZZE_OPTAUR)	
	    AAdd(aRec,QRY_TAU->ZZE_COD)	
	    IF QRY_TAU->TIPO == 'PRD'
	       AAdd(aRec,QRY_TAU->QUANT)
	       AAdd(aRec,0)          
	    Else
	       AAdd(aRec,0)          
	       AAdd(aRec,QRY_TAU->QUANT)
		EndIF    
		AAdd(aDados,aRec)
	Else 
	    IF QRY_TAU->TIPO == 'PRD'
	    	 aDados[nPos,06] += QRY_TAU->QUANT
	    Else                                  
	    	aDados[nPos,07] += QRY_TAU->QUANT
	    endIF
	EndIF
	QRY_TAU->(dbSkip())
End
             
aSort(aDados,,,{|x,y| x[1] < y[1]})                 
  

Return aDados
*/
************************************************************************************************************************************
Static Function Ret_Taura                              

Local nI            := ''
Local aDados        := {}
Local aRec          := {}     
Local cChave        := ''
Local nPos          := ''
Local cURLPost		:= GetMV('MGF_TAP18A',.F.,"")
Local oWSTAP18		:= Nil
Local lRet          := .F.
Local cCodOper      := ''
Local cDtOper       := ''
Local cOperacao     := ''
Local cOpTaura      := ''
Local cProduto      := ''
Local nQuant        := 0  
Local cTM           := ''  

Private oSaldo	    := Nil
Private oObjRet

oSaldo := nil
oSaldo := TAP18_ESTOQUE():new()
oSaldo:setDados()

oWSTAP18 := nil
oWSTAP18 := MGFINT23():new(cURLPost, oSaldo,0, "", "", "", "","","", .T. )
StaticCall(MGFTAC01,ForcaIsBlind,oWSTAP18)
//MemoWrite("c:\temp\MGFTAE20"+StrTran(Time(),":","")+".txt",oWSTAP18:cJson)
//MemoWrite("c:\temp\MGFTAE"+StrTran(Time(),":","")+".txt",oWSTAP18:cPostRet)
IF oWSTAP18:lOk
	IF fwJsonDeserialize(oWSTAP18:cPostRet, @oObjRet)
		IF VALTYPE(oObjRet) == 'C'
			fwJsonDeserialize(oObjRet, @oObjRet)
		EndIF
		IF VALTYPE(oObjRet) == 'A'
			For nI := 1 To Len(oObjRet)

				cCodOper      := Alltrim(IIF(VALTYPE(oObjRet[nI]:CODIGOOPERACAO) == 'C',oObjRet[nI]:CODIGOOPERACAO,''))				
				cDtOper       := IIF(VALTYPE(oObjRet[nI]:DATAOPERACAO) == 'C' ,oObjRet[nI]:DATAOPERACAO,'')
				cOperacao     := IIF(VALTYPE(oObjRet[nI]:OPERACAO) == 'C'     ,oObjRet[nI]:OPERACAO,'')
				cOpTaura      := IIF(VALTYPE(oObjRet[nI]:OPTAURA) == 'N'      ,Alltrim(STR(oObjRet[nI]:OPTAURA)),'')
				cProduto      := IIF(VALTYPE(oObjRet[nI]:PRODUTO) == 'N'      ,oObjRet[nI]:PRODUTO,0)
				nQuant        := IIF(VALTYPE(oObjRet[nI]:QUANTIDADE) == 'N'   ,oObjRet[nI]:QUANTIDADE,'')  
				cTM           := IIF(VALTYPE(oObjRet[nI]:TIPOMOVIMENTO) == 'C',Alltrim(oObjRet[nI]:TIPOMOVIMENTO),'')  
				cDtOper       := strTran(SubStr(cDtOper,1,10),"-")
				cCodOper      := Alltrim(cCodOper)+'-'+Alltrim(cOperacao)
				cProduto      := STRZERO(cProduto,6)
				
				cProduto      := Ret_Cod_Correto(cProduto, SUBSTR(cCodOper,1,2), cTM)
				aRec   := {}
				nPos := aScan( aDados, { |x| x[1] == cCodOper+cDtOper+cOpTaura+cProduto })
				IF nPos == 0
					AAdd(aRec,cCodOper+cDtOper+cOpTaura+cProduto )
					AAdd(aRec,cCodOper)
					AAdd(aRec,cDtOper)
					AAdd(aRec,cOpTaura)
					AAdd(aRec,cProduto)
					IF cTM == 'PRD'
						AAdd(aRec,nQuant)
						AAdd(aRec,0)
					Else
						AAdd(aRec,0)
						AAdd(aRec,nQuant)
					EndIF
					AAdd(aDados,aRec)
				Else
					IF cTM == 'PRD'
						aDados[nPos,06] += nQuant
					Else
						aDados[nPos,07] += nQuant
					EndIF
				EndIF
			Next nI
		EndIF
	EndIF
EndIF  

aSort(aDados,,,{|x,y| x[1] < y[1]})                 

Return aDados 

******************************************************************************************************************
CLASS TAP18_ESTOQUE
Data applicationArea   as ApplicationArea
Data Filial		       as String
Data DataInicio        as String
Data DataFinal	       as String


Method New()
Method setDados()

Return
******************************************************************************************************************
Method new() Class TAP18_ESTOQUE

self:applicationArea	:= ApplicationArea():new()

Return
******************************************************************************************************************
Method setDados() Class TAP18_ESTOQUE

Self:Filial		   := MV_PAR01
Self:DataInicio    := Subs(dTos(MV_PAR02),1,4)+"-"+Subs(dTos(MV_PAR02),5,2)+"-"+Subs(dTos(MV_PAR02),7,2)
Self:DataFinal	   := Subs(dTos(MV_PAR03),1,4)+"-"+Subs(dTos(MV_PAR03),5,2)+"-"+Subs(dTos(MV_PAR03),7,2)

Return




