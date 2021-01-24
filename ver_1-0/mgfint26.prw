#include 'protheus.ch'
#include 'avprint.ch'
#define DMPAPER_A4 9
#define CRLF chr(13) + chr(10)
/*
============================================================================================
Programa.:              MGFINT26
Autor....:              Leonardo Kume        
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relatório de Boletim de Abate
=============================================================================================
*/
User Function MGFINT26()

Local abkRotina    := aRotina
Local abkCadastro  := cCadastro
Private cCadastro := "Boletim de Abate - Relatorio"
Private aRotina   := { {"Pesquisar"      ,"AxPesqui"        ,0, 1} ,;       
					   {"Visualizar"	 ,"U_INT26_MAN"     ,0, 2, 0, NIL},;
		               {"Gerar"	         ,"U_INT26_MAN"     ,0, 3, 0, NIL},;
		               {"Alterar"   	 ,"U_INT26_MAN"     ,0, 4, 0, NIL},;
		               {"Excluir"   	 ,"U_INT26_MAN"     ,0, 5, 0, NIL},;
		               {"Imprimir"  	 ,"U_INT26_IMP"     ,0, 2} } 		

CHKFILE('ZD9')
CHKFILE('ZD0')
dbSelectArea("ZD0")
dbSetOrder(1)

dbSelectArea("ZD9")
dbSetOrder(1)

mBrowse( 6,1,22,75,"ZD9",,,,,,)

aRotina    := abkRotina   
cCadastro  := abkCadastro 

Return
*************************************************************************************************
User Function INT26_MAN( cAlias, nReg, nOpc )

Local nI        := 0
Local nOpcA     := 0
Local bEncerra  := .F.

Private aHeader := {}
Private aCols   := {}
Private aREG    := {}
Private bCampo  := { | nField | FieldName(nField) }
Private aSize   := {}
Private aOBJ    := {}
Private aInfo   := {}
Private aPObj   := {}      
Private nPosCred := 0 
Private aAlter  := {'ZD0_NC'}
Private oDlg
Private oGet
Private aButtons :={}                  
Private aCpos    :={}                
Private aRecZD0  :={}

IF nOpc == 3
  Inc_BOL()
  Return
EndIF
IF nOpc == 4 //Alteração
	aCpos :={"ZD9_SALDO","ZD9_RESP","ZD9_OBS",'ZD9_SANT','ZD9_EUF','ZD9_DUF','ZD9_EFE','ZD9_DFE','ZD9_SA','ZD9_SP'}
    AAdd(aButtons , {"Informações NF Produtor", {|| U_INT26_IT() }    ,"Informações NF Produtor","Informações NF Produtor",{|| .T.}})        
EndIF
aSize := MsAdvSize()
AAdd(aOBJ,{100,120,.T.,.F.})
AAdd(aOBJ,{100,50,.T.,.T.})  //75
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
aPObj := MsObjSize( aInfo, aObj )

//Montando o cabeçalho
dbSelectArea( cAlias )
dbSetOrder(1)
For nI := 1 To FCount()
	M->&( Eval( bCampo, nI ) ) := FieldGet( nI )
Next nI   

//Montando o Header do Itens
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZD0"))
While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "ZD0"
	If X3Uso(SX3->X3_USADO) .AND. ;
	   Alltrim(SX3->X3_CAMPO)<>'ZD0_FILIAL' .AND. ;
	   Alltrim(SX3->X3_CAMPO)<>'ZD0_NUM' .AND. ; 
	   Alltrim(SX3->X3_CAMPO)<> 'ZD0_ABLOJA' .AND. ;	
	   Alltrim(SX3->X3_CAMPO)<> 'ZD0_ABATE' .AND. ;	
	   Alltrim(SX3->X3_CAMPO)<> 'ZD0_ANO' .AND. ;
	   Alltrim(SX3->X3_CAMPO)<> 'ZD0_REC' 
	   	AADD( aHeader, { Trim( X3Titulo() ),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT})
	Endif
	SX3->(dbSkip())
EndDo

dbSelectArea('ZD0')
dbSetOrder(1)
ZD0->(dbSeek( ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO    ))
While ZD0->(!EOF()) .And. ZD0->ZD0_FILIAL+ZD0->ZD0_NUM+ZD0->ZD0_ANO == ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO
	AAdd( aREG, ZD0->( RecNo() ) )
	AAdd( aCols, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
	Next nI                                      
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	AAdd(aRecZD0, ZD0->(Recno()) )
    ZD0->(dbSkip())
End

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd Pixel

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1],aCpos)
	oGet := MsNewGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],GD_UPDATE ,"AllwaysTrue","AllwaysTrue",,aAlter,0,999 ,"AllwaysTrue","","AllwaysTrue",oDlg,aHeader,aCols)
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
					  {||  nOpcA := 1, oDlg:End() ,NIL  },;
	                  {|| oDlg:End() },,@aButtons)
If nOpcA == 1 .And. ( nOpc == 5 .Or. nOpc == 4 )
	If nOpc == 4 //Alteração
		RecLock("ZD9", .F. )
		ZD9->ZD9_OBS   := M->ZD9_OBS
		ZD9->ZD9_RESP  := M->ZD9_RESP 
		ZD9->ZD9_SANT  := M->ZD9_SANT 
		ZD9->ZD9_EUF   := M->ZD9_EUF 
		ZD9->ZD9_DUF   := M->ZD9_DUF 
		ZD9->ZD9_EFE   := M->ZD9_EFE 
		ZD9->ZD9_DFE   := M->ZD9_DFE 
		ZD9->ZD9_SA    := M->ZD9_SA 
		ZD9->ZD9_SP    := M->ZD9_SP 
		ZD9->ZD9_SALDO := M->ZD9_SALDO 
		ZD9->(MsUnLock())              
		
		nPosCred := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZD0_NC' }) 
		dbSelectArea("ZZN")
		ZD0->(dbSetOrder(1))
		For nX := 1 To Len( oGet:aCols )
			If nX <= Len( aREG )
				ZD0->(dbGoto( aREG[nX] ))
				RecLock("ZD0",.F.) 
				ZD0->ZD0_NC  := oGet:aCols[nX,nPosCred]
				ZD0->(MsUnLock())
			Endif
		Next nX
		
	Endif
	If nOpc == 5 //Exclusão
		ZD0->(dbSeek( ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO    ))
		While ZD0->(!EOF()) .And. ZD0->ZD0_FILIAL+ZD0->ZD0_NUM+ZD0->ZD0_ANO == ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO
			Reclock("ZD0",.F.)
			ZD0->(dbDelete())
			ZD0->(MsUnlock())
			ZD0->(dbSeek( ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO    ))
		EndDo
		RecLock("ZD9", .F. )
		ZD9->(dbDelete())
		ZD9->(MsUnLock())
	Endif
Endif

Return
************************************************************************************************************************************************************
User Function INT26_IMP
	
Private nPagina
Private oPrn, oFont1, oFont2, oFont3, oFont4, oFont5, oBrush, aFontes, cAliasZZM
  
//oPrn:=FWMSPrinter():New(alltrim(ZD9->ZD9_FILIAL+'_'+ZD9->ZD9_NUM),6,,,.T.,) //imprime direto em PDF e inibi a tela de setup
AVPRINT oPrn NAME "avprint"
oPrn:lDelete := .T.
oPrn:SetLandscape()  //- impressao modo paisagem
oPrn:SetPaperSize(DMPAPER_A4) 


//                           Font                W  H  Bold          Underline Device
oFont1  := oSend(TFont(),"New","Verdana"          ,0,11,,.T.,,,,,,,,,,,oPrn)  //13
oFont2  := oSend(TFont(),"New","Verdana"          ,0,09,,.T.,,,,,,,,,,,oPrn)  //10
oFont3  := oSend(TFont(),"New","Verdana"          ,0,10,,.F.,,,,,,,,,,,oPrn)  //10
oFont4  := oSend(TFont(),"New","Verdana"          ,0,20,,.T.,,,,,,,,,,,oPrn)  //20
oFont5  := oSend(TFont(),"New","Verdana"          ,0,14,,.F.,,,,,,,,,,,oPrn)  //16
oFont6  := oSend(TFont(),"New","Verdana"          ,0,13,,.T.,,,,,,,,,,,oPrn)  //13
oFont7  := oSend(TFont(),"New","Verdana"          ,0,08,,.F.,,,,,,,,,,,oPrn)  //10
oFont8  := oSend(TFont(),"New",'Courier New'      ,0,10,,.F.,,,,,,,,,,,oPrn)  //

oBrush := TBrush():New( , CLR_HGRAY )

aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8}

PROCESSA({|| Imprime()},"Imprimindo.......")

Return
************************************************************************************************************************************************************
Static Function Imprime()
	
Local nI        := 1
Local nQtCab1   :=0
Local nVlTot1   := 0
Local nVlKg1    := 0
Local nValCre1  := 0
Local nQtCab2   :=0
Local nVlTot2   := 0
Local nVlKg2    := 0
Local nValCre2  := 0
Local lForn     := .T.
Local cDtEmissa := DTOC(ZD9->ZD9_DATA)
Local cPedido 	:= ZD9->ZD9_NUM+"/"+ZD9->ZD9_ANO
Local aNotasEst := {}
Local aNotasFed := {}
Local nICMS     := 0
Local nDesc     := 0
Local nAcr      := 0
Local nPADL     := 0
Local aICMS     := {}                      
Local cDMes     := ''
Local cEspecie  := ''
Local cMun      :=  ''
Local cEsT      := ''        
Local aREC      := {}
Local nVBrut    := 0
Local nVICMS    := 0                        
Local nTotICMS  := 0 
Local aInfo     := {}


//oPrn:StartPage()


AVNEWPAGE
nPagina++
_nLen := 0

li := 50
liant := li
oPrn:Say(li+5,1550,"BOLETIM DE ABATE", aFontes[6],,,,3)
oPrn:Say(li+5,2710,"Nr.", aFontes[2],,,,3)
oPrn:Say(li+5,2800,cPedido, aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Box(liant,2700,li,3400) //80

liant := li
oPrn:Say(li+5,1500,"ESTABELECIMENTO EMITENTE", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
liant := li
oPrn:Say(li+5,0070,"Titular: "+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL, aFontes[2],,,,3)
oPrn:Say(li+5,2500,"Inscrição Estadual: "+SM0->M0_INSC, aFontes[2],,,,3)
li += 70

oPrn:Say(li+5,0070,"Endereço: "+SM0->M0_ENDCOB, aFontes[2],,,,3)
oPrn:Say(li+5,2500,"Inscrição no CNPJ: "+Transform(Substr(SM0->M0_CGC,1,9),"@R 999.999.999")+"/"+Transform(Substr(SM0->M0_CGC,9,6),"@R 9999-99"), aFontes[2],,,,3)
li += 70

oPrn:Say(li+5,0070,"Município: "+ALLTRIM(SM0->M0_CIDENT)+"/"+SM0->M0_ESTENT, aFontes[2],,,,3)
oPrn:Say(li+5,2500,"CNAE: "+Transform(SM0->M0_CNAE,"@R 9999-9/99"), aFontes[2],,,,3)
li += 70
oPrn:Box(liAnt,0050,li,3400) //80

liant := li
oPrn:Say(li+5,1500,"GADO ABATIDO - ESPECIE BOVINO", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80


// Se Terceiro
If !Empty(ZD9->ZD9_ABATE) .and. !Empty(ZD9->ZD9_ABLOJA)
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+Padr(ZD9->ZD9_ABATE,TamSX3("ZD9_ABATE")[1])+PADR(ZD9->ZD9_ABLOJA,TamSX3("ZD9_ABLOJA")[1])))
	lForn := .F.
Endif


liant := li
oPrn:Say(li+5,0070,"ABATE", aFontes[2],,,,3)
oPrn:Say(li+5,0500,"LOCAL", aFontes[2],,,,3)
oPrn:Say(li+5,1000,"( "+iif(lForn,"x"," ")+" ) Próprio", aFontes[3],,,,3)
oPrn:Say(li+5,2000,"( "+iif(lForn," ","x")+" ) De Terceiro", aFontes[3],,,,3)
oPrn:Say(li+5,2800,"Data:" + dtoc(ZD9->ZD9_DATA), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
If !lForn
	oPrn:Say(li+5,0070,"Local do Abate: "+SA2->A2_NOME, aFontes[2],,,,3)
	oPrn:Say(li+5,2500,"Inscrição Estadual: "+SA2->A2_INSCR, aFontes[2],,,,3)
	li += 70
	
	oPrn:Say(li+5,0070,"Endereço: "+Alltrim(SA2->A2_END)+" ,"+SA2->A2_NR_END, aFontes[2],,,,3)
	oPrn:Say(li+5,2500,"Inscrição no CNPJ: "+Transform(Substr(SA2->A2_CGC,1,9),"@R 999.999.999")+"/"+Transform(Substr(SA2->A2_CGC,9,6),"@R 9999-99"), aFontes[2],,,,3)
	li += 70
	
	oPrn:Say(li+5,0070,"Município: "+SA2->A2_EST+"/"+SA2->A2_MUN, aFontes[2],,,,3)
	li += 70
	
EndIf
	
li += 140
oPrn:Box(liAnt,0050,li,3400) //80
liant := li
oPrn:Say(li+5,0070,"PAUTA FISCAL", aFontes[2],,,,3)
oPrn:Say(li+5,0500,"PORT.CAT NRO", aFontes[2],,,,3)    
oPrn:Say(li+5,1000,'CAT = 080/07 ', aFontes[3],,,,3)

oPrn:Say(li+5,2000,"ALIQUOTA APLICÁVEL : 0 %", aFontes[2],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
	

liant := li
oPrn:Say(li+5,0500,"Devido", aFontes[2],,,,3)
oPrn:Say(li+5,1200,"Creditos Utilizados", aFontes[2],,,,3)
oPrn:Say(li+5,2000,"Aliquota Aplicável", aFontes[2],,,,3)
li += 70

dbSelectArea('ZZM')
dbSetOrder(1)
dbSelectArea('ZZP')
dbSetOrder(1)
dbSelectArea('ZD0')
dbSetOrder(1)
ZD0->(dbSeek( ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO    ))
While ZD0->(!EOF()) .And. ZD0->ZD0_FILIAL+ZD0->ZD0_NUM+ZD0->ZD0_ANO == ZD9->ZD9_FILIAL+ZD9->ZD9_NUM+ZD9->ZD9_ANO
	IF ZD0->ZD0_VCRED > 0 
	    IF aScan( aICMS, { |x| x[1] == ZD0->ZD0_REC }) == 0 
	    
		        ZZM->(dbGoTo(ZD0->ZD0_REC))
		        cDMes     := DTOS(ZD9->ZD9_DATA)
	    		cDMes     := SUBSTR(cDMes,7,2)+'/'+SUBSTR(cDMes,5,2)
	    		IF !Empty(ZD0->ZD0_INFO)
	    		     aInfo    := StrTokArr(ZD0->ZD0_INFO,';')
				Else
				     aInfo:= {'','',''}
	    		EndIF
	    		cEsT      := ''
	    		IF SF1->(dbSeek(ZZM->ZZM_FILIAL+;
	    		                PADR(ALLTRIM(ZZM->ZZM_DOC),TamSX3("F1_DOC")[1])+;
	    		                PADR(ALLTRIM(ZZM->ZZM_SERIE),TamSX3("F1_SERIE")[1])+;
	    		                PADR(ALLTRIM(Alltrim(ZZM->ZZM_FORNEC)),TamSX3("A2_COD")[1])+ZZM->ZZM_LOJA))
					cDMes     := DTOS(SF1->F1_EMISSAO)
	    		    cDMes     := SUBSTR(cDMes,7,2)+'/'+SUBSTR(cDMes,5,2)
	    		    //cEspecie  := SF1->F1_ESPECIE
	    		    cEsT      := SF1->F1_EST
	    		EndIF       
			    cMun := GetAdvFVal( "SA2", "A2_MUN", xFilial('SA2')+PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1])+PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]), 1, "" )     
			    aRec := {} 
			    AADD(aRec,ZD0->ZD0_REC)             //1
			    AADD(aRec,cDMes)                    //2
			    AADD(aRec,aInfo[01])                 //3
			    AADD(aRec,aInfo[02])      //4
			    AADD(aRec,aInfo[03])        //5
			    AADD(aRec,cMun)                     //6
			    AADD(aRec,cEsT)                     //7
	 		    AADD(aRec,ZZM->ZZM_VNFP)            //8
				AADD(aRec,ZZM->ZZM_ICMSNP)          //9
			    //AADD(aRec,ZD0->ZD0_VCRED)           //10
			    AADD(aRec,ZZM->ZZM_VICMS)           //10
			    nVBrut  := 0
				nVICMS  := 0
			    IF SF1->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_DOC+ZZM->ZZM_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
					nVBrut  := SF1->F1_VALBRUT
					nVICMS  := SF1->F1_VALICM
	    		EndIF                        
	    		AADD(aRec,ZZM->ZZM_DOC)            //11
	    		AADD(aRec,ZZM->ZZM_SERIE)          //12
	    		AADD(aRec,nVBrut)                  //13
	    		AADD(aRec,nVICMS)                  //14
			    AADD(aICMS,aRec)
		EndIF	    
		    /*cQuery := " SELECT ZZP_DOC,ZZP_SERIE, ZZP_QTD, R_E_C_N_O_ As REGATU  "
		    cQuery += " FROM "+RetSQLName("ZZP") 
			cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' " 
			cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' " 
			cQuery += "   AND ZZP_PRODUT = '" + ZD0->ZD0_ITEM + "' " 
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY ZZP_DOC, ZZP_SERIE "
			If Select("QRY_PROD") > 0
				QRY_PROD->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PROD",.T.,.F.)
			dbSelectArea('SF1')
			SF1->(dbSetOrder(1))
			dbSelectArea("QRY_PROD")
			QRY_PROD->(dbGoTop())
			While !QRY_PROD->(EOF()) 
	    		cDMes     := DTOS(ZD9->ZD9_DATA)
	    		cDMes     := SUBSTR(cDMes,7,2)+'/'+SUBSTR(cDMes,5,2)
	    		cEspecie  := ''        
	    		cEsT      := ''
	    		IF SF1->(dbSeek(ZZM->ZZM_FILIAL+;
	    		                PADR(ALLTRIM(QRY_PROD->ZZP_DOC),TamSX3("F1_DOC")[1])+;
	    		                PADR(ALLTRIM(QRY_PROD->ZZP_SERIE),TamSX3("F1_SERIE")[1])+;
	    		                PADR(ALLTRIM(Alltrim(ZZM->ZZM_FORNEC)),TamSX3("A2_COD")[1])+ZZM->ZZM_LOJA))
					cDMes     := DTOS(SF1->F1_EMISSAO)
	    		    cDMes     := SUBSTR(cDMes,7,2)+'/'+SUBSTR(cDMes,5,2)
	    		    cEspecie  := SF1->F1_ESPECIE
	    		    cEsT      := SF1->F1_EST
	    		EndIF
			    cMun := GetAdvFVal( "SA2", "A2_MUN", xFilial('SA2')+PADR(ALLTRIM(ZZM->ZZM_FORNEC),TamSX3("A2_COD")[1])+PADR(ALLTRIM(ZZM->ZZM_LOJA),TamSX3("A2_LOJA")[1]), 1, "" )     
			    aRec := {} 
			    AADD(aRec,ZD0->ZD0_REC)             //1
			    AADD(aRec,cDMes)                    //2
			    AADD(aRec,cEspecie)                 //3
			    AADD(aRec,QRY_PROD->ZZP_SERIE)      //4
			    AADD(aRec,QRY_PROD->ZZP_DOC)        //5
			    AADD(aRec,cMun)                     //6
			    AADD(aRec,cEsT)                     //7
	 		    AADD(aRec,ZZM->ZZM_VNFP)            //8
				AADD(aRec,ZZM->ZZM_ICMSNP)          //9
			    AADD(aRec,ZD0->ZD0_VCRED)           //10
			    nVBrut  := 0
				nVICMS  := 0
			    IF SF1->(dbSeek(ZZM->ZZM_FILIAL+ZZM->ZZM_DOC+ZZM->ZZM_SERIE+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
					nVBrut  := SF1->F1_VALBRUT
					nVICMS  := SF1->F1_VALICM
	    		EndIF                        
	    		AADD(aRec,ZZM->ZZM_DOC)            //11
	    		AADD(aRec,ZZM->ZZM_SERIE)          //12
	    		AADD(aRec,nVBrut)                  //13
	    		AADD(aRec,nVICMS)                  //14
			    AADD(aICMS,aRec)
			    QRY_PROD->(dbSkip())
			EndDo    
		EndIF   */
	EndIF	
	If ZD0->ZD0_UF == 'S'
		aAdd(aNotasEst,{ZD0->ZD0_DESC,;
		ZD0->ZD0_QTCAB ,;
		ZD0->ZD0_PUNIT ,;
		ZD0->ZD0_TRIBUT,;
		ZD0->ZD0_PE    ,;
		ZD0->ZD0_NC    ,;
		ZD0->ZD0_VCRED ,;
		ZD0->ZD0_NF  })
		
	Else
		aAdd(aNotasFed,{ZD0->ZD0_DESC,;
		ZD0->ZD0_QTCAB ,;
		ZD0->ZD0_PUNIT ,;
		ZD0->ZD0_TRIBUT,;
		ZD0->ZD0_PE    ,;
		ZD0->ZD0_NC    ,;
		ZD0->ZD0_VCRED ,;
		ZD0->ZD0_NF  })
	EndIf
	nICMS += ZD0->ZD0_VCRED
	ZD0->(DbSkip())
EndDo
	
oPrn:Say(li+5,0070,"ICMS:", aFontes[2],,,,3)
oPrn:Say(li+5,0500,"R$ 0.00", aFontes[3],,,,3) //+Str(nICMS,12,2)
oPrn:Say(li+5,1200,"R$ 0.00", aFontes[3],,,,3) //+Str(nDesc,12,2)
oPrn:Say(li+5,2000,"R$ 0.00", aFontes[3],,,,3) //+Str(nAcr,12,2)
li += 70
		
oPrn:Say(li+5,0070,"RECOLHIMENTO:", aFontes[2],,,,3)
oPrn:Say(li+5,0500,"Prazo até: "+DTOC(ZD9->ZD9_DATA), aFontes[3],,,,3)
oPrn:Say(li+5,2000,"efetuado em   ____/____/______", aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
	
	
liant := li
oPrn:Say(li+5,0070,"I. GADO RECEBIDO DE ESTABELECIMENTO SITUADO NESTE ESTADO", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,01500,"DADOS DO ABATE", aFontes[1],,,,3)
oPrn:Say(li+5,02600,"II. CREDITO UTILIZADO", aFontes[1],,,,3)
li += 70
oPrn:Line(liant,2590,li,2590) //80
oPrn:Box(liant,0050,li,3400) //80
	
liant := li
oPrn:Say(li+5,0070,"Discriminação do Gado", aFontes[7],,,,3)
oPrn:Say(li+5,0500,"Qtde. de Cabeças", aFontes[7],,,,3)
oPrn:Say(li+5,0800,"Valor Unitário da Pauta Fiscal", aFontes[7],,,,3)
oPrn:Say(li+5,1300,"Valor Tributado (Base de Cálculo)", aFontes[7],,,,3)
oPrn:Say(li+5,1900,"Peso das Peças Inteiras (Carne e Osso) KG", aFontes[7],,,,3)
oPrn:Say(li+5,2600,"Certificado Número", aFontes[7],,,,3)
oPrn:Say(li+5,3000,"Valor do Crédito", aFontes[7],,,,3)
li += 70
oPrn:Box(liant,0050,li,0490) //80
oPrn:Box(liant,0490,li,0790) //80
oPrn:Box(liant,0790,li,1290) //80
oPrn:Box(liant,1290,li,1890) //80
oPrn:Box(liant,1890,li,2590) //80
oPrn:Box(liant,2590,li,2990) //80
oPrn:Box(liant,2990,li,3400) //80

For nI := 1 To Len(aNotasEst)
	liant := li
	
	If nI % 2 == 1
		oPrn:FillRect( {liAnt, 0050, li+70, 3400}, oBrush )
	EndIf
	
	oPrn:Say(li+5,0070,aNotasEst[nI][1], aFontes[7],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasEst[nI][2])),aFontes[3])
	oPrn:Say(li+5,790-nPadL,Alltrim(Str(aNotasEst[nI][2])), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasEst[nI][3],12,2)),aFontes[3])
	oPrn:Say(li+5,1290-nPadL,Alltrim(Str(aNotasEst[nI][3],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasEst[nI][4],12,2)),aFontes[3])
	oPrn:Say(li+5,1890-nPadL,Alltrim(Str(aNotasEst[nI][4],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasEst[nI][5],12,2)),aFontes[3])
	oPrn:Say(li+5,2590-nPadL,Alltrim(Str(aNotasEst[nI][5],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(aNotasEst[nI][6],aFontes[3])
	oPrn:Say(li+5,2610,aNotasEst[nI][6], aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasEst[nI][7],12,2)),aFontes[3])
	oPrn:Say(li+5,3400-nPadL,Alltrim(Str(aNotasEst[nI][7],12,2)), aFontes[3],,,,3)
	
	
	nQtCab1 += aNotasEst[nI][2]
	nVlKg1  += aNotasEst[nI][5]
	nVlTot1 += aNotasEst[nI][4]
	nValCre1 += aNotasEst[nI][7]
	li += 70
	oPrn:Box(liant,0050,li,0490) //80
	oPrn:Box(liant,0490,li,0790) //80
	oPrn:Box(liant,0790,li,1290) //80
	oPrn:Box(liant,1290,li,1890) //80
	oPrn:Box(liant,1890,li,2590) //80
	oPrn:Box(liant,2590,li,2990) //80
	oPrn:Box(liant,2990,li,3400) //80
	Quebra()
	//(cAliasZZM)->(DbSkip())
Next nI

liant := li
oPrn:Say(li+5,0100,"SOMA:", aFontes[2],,,,3)
oPrn:Say(li+5,3000,"SOMA:", aFontes[2],,,,3)
	
nPadL := Ret_Tam(cValToCHar(nQtCab1),aFontes[2])
oPrn:Say(li+5,0790-nPadL,cValToCHar(nQtCab1), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nVlTot1,12,2)),aFontes[2])
oPrn:Say(li+5,1890-nPadL,Alltrim(Str(nVlTot1,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nVlKg1,12,2)),aFontes[2])
oPrn:Say(li+5,2590-nPadL,Alltrim(Str(nVlKg1,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nValCre1,12,2)),aFontes[2])
oPrn:Say(li+5,3400-nPadL,Alltrim(Str(nValCre1,12,2)), aFontes[2],,,,3)
li += 70
oPrn:Box(liant,0050,li,0490) //80
oPrn:Box(liant,0490,li,0790) //80
oPrn:Box(liant,0790,li,1290) //80
oPrn:Box(liant,1290,li,1890) //80
oPrn:Box(liant,1890,li,2590) //80
oPrn:Box(liant,2590,li,2990) //80
oPrn:Box(liant,2990,li,3400) //80

liant := li
oPrn:Say(li+5,0070,"III. GADO RECEBIDO DIRETAMENTE DE OUTRA UNIDADE DA FEDERAÇÃO", aFontes[1],,,,3)
oPrn:Say(li+5,02600,"IV. CRED.A UTIL.NA CTA GRÁFICA", aFontes[1],,,,3)
li += 70
oPrn:Line(liant,2590,li,2590) //80
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0070,"Di?scriminação do Gado", aFontes[7],,,,3)
oPrn:Say(li+5,0500,"Qtde. de Cabeças", aFontes[7],,,,3)
oPrn:Say(li+5,0800,"Valor Unitário da Pauta Fiscal", aFontes[7],,,,3)
oPrn:Say(li+5,1300,"Valor Tributado (Base de Cálculo)", aFontes[7],,,,3)
oPrn:Say(li+5,1900,"Peso das Peças Inteiras (Carne e Osso) KG", aFontes[7],,,,3)
oPrn:Say(li+5,2600,"Certificado Número", aFontes[7],,,,3)
oPrn:Say(li+5,3000,"Valor do Crédito", aFontes[7],,,,3)
li += 70
oPrn:Box(liant,0050,li,0490) //80
oPrn:Box(liant,0490,li,0790) //80
oPrn:Box(liant,0790,li,1290) //80
oPrn:Box(liant,1290,li,1890) //80
oPrn:Box(liant,1890,li,2590) //80
oPrn:Box(liant,2590,li,2990) //80
oPrn:Box(liant,2990,li,3400) //80

For nI := 1 To Len(aNotasFed)
	liant := li
	
	If nI % 2 == 1
		oPrn:FillRect( {liAnt, 0050, li+70, 3400}, oBrush )
	EndIf
	
	oPrn:Say(li+5,0070,aNotasFed[nI][1], aFontes[7],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasFed[nI][2])),aFontes[3])
	oPrn:Say(li+5,790-nPadL,Alltrim(Str(aNotasFed[nI][2])), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasFed[nI][3],12,2)),aFontes[3])
	oPrn:Say(li+5,1290-nPadL,Alltrim(Str(aNotasFed[nI][3],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasFed[nI][4],12,2)),aFontes[3])
	oPrn:Say(li+5,1890-nPadL,Alltrim(Str(aNotasFed[nI][4],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasFed[nI][5],12,2)),aFontes[3])
	oPrn:Say(li+5,2590-nPadL,Alltrim(Str(aNotasFed[nI][5],12,2)), aFontes[3],,,,3)
	
	nPadL := Ret_Tam(aNotasFed[nI][6],aFontes[3])
	oPrn:Say(li+5,2610,aNotasFed[nI][6], aFontes[3],,,,3)
	
	nPadL := Ret_Tam(Alltrim(Str(aNotasFed[nI][7],12,2)),aFontes[3])
	oPrn:Say(li+5,3400-nPadL,Alltrim(Str(aNotasFed[nI][7],12,2)), aFontes[3],,,,3)
	
	
	nQtCab2 += aNotasFed[nI][2]
	nVlTot2 += aNotasFed[nI][4]
	nVlKg2 += aNotasFed[nI][5]
	nValCre2 += aNotasFed[nI][7]
	li += 70
	oPrn:Box(liant,0050,li,0490) //80
	oPrn:Box(liant,0490,li,0790) //80
	oPrn:Box(liant,0790,li,1290) //80
	oPrn:Box(liant,1290,li,1890) //80
	oPrn:Box(liant,1890,li,2590) //80
	oPrn:Box(liant,2590,li,2990) //80
	oPrn:Box(liant,2990,li,3400) //80
	Quebra()
	//(cAliasZZM)->(DbSkip())
Next nI
liant := li

oPrn:Say(li+5,0100,"SOMA:", aFontes[2],,,,3)
oPrn:Say(li+5,2610,"SOMA:", aFontes[2],,,,3)

nPadL := Ret_Tam(cValToCHar(nQtCab2),aFontes[2])
oPrn:Say(li+5,0790-nPadL,cValToCHar(nQtCab2), aFontes[2],,,,3)

nPadL := Ret_Tam(Alltrim(Str(nVlTot2,12,2)),aFontes[2])
oPrn:Say(li+5,1890-nPadL,Alltrim(Str(nVlTot2,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nVlKg2,12,2)),aFontes[2])
oPrn:Say(li+5,2590-nPadL,Alltrim(Str(nVlKg2,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nValCre2,12,2)),aFontes[2])
oPrn:Say(li+5,3400-nPadL,Alltrim(Str(nValCre2,12,2)), aFontes[2],,,,3)

li += 70
oPrn:Box(liant,0050,li,0490) //80
oPrn:Box(liant,0490,li,0790) //80
oPrn:Box(liant,0790,li,1290) //80
oPrn:Box(liant,1290,li,1890) //80
oPrn:Box(liant,1890,li,2590) //80
oPrn:Box(liant,2590,li,2990) //80
oPrn:Box(liant,2990,li,3400) //80

liant := li
oPrn:Say(li+5,0100,"TOTAL:", aFontes[2],,,,3)
oPrn:Say(li+5,2610,"TOTAL:", aFontes[2],,,,3)

nPadL := Ret_Tam(cValToCHar(nQtCab1+nQtCab2),aFontes[2])
oPrn:Say(li+5,0790-nPadL,cValToCHar(nQtCab1+nQtCab2), aFontes[2],,,,3)

nPadL := Ret_Tam(Alltrim(Str(nVlTot1+nVlTot2,12,2)),aFontes[2])
oPrn:Say(li+5,1890-nPadL,Alltrim(Str(nVlTot1+nVlTot2,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nVlKg1+nVlKg2,12,2)),aFontes[2])
oPrn:Say(li+5,2590-nPadL,Alltrim(Str(nVlKg1+nVlKg2,12,2)), aFontes[2],,,,3)
nPadL := Ret_Tam(Alltrim(Str(nValCre1+nValCre2,12,2)),aFontes[2])
oPrn:Say(li+5,3400-nPadL,Alltrim(Str(nValCre1+nValCre2,12,2)), aFontes[2],,,,3)


li += 70
oPrn:Box(liant,0050,li,0490) //80
oPrn:Box(liant,0490,li,0790) //80
oPrn:Box(liant,0790,li,1290) //80
oPrn:Box(liant,1290,li,1890) //80
oPrn:Box(liant,1890,li,2590) //80
oPrn:Box(liant,2590,li,2990) //80
oPrn:Box(liant,2990,li,3400) //80

liant := li
oPrn:Say(li+5,0100,"1ª Via: Posto Fiscal: / 2ª Via: Emitente", aFontes[2],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

oprn:EndPage()
//oPrn:StartPage()
	
LI := 50
liant := li
oPrn:Say(li+5,0070,"V. DEMONSTRATIVO DA MOVIMENTAÇÃO DO GADO", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0200,"SALDO DO BOLETIM Nr. "+ZD9->ZD9_BOLANT+" DE "+DTOC(ZD9->ZD9_EMISAN), aFontes[1],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SANT)),10), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+80,0070,"Entradas", aFontes[4],,,,3)
oPrn:Say(li+5,0520,PadL("Deste Estado:",40)+Replicate("-",130), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_EUF+ZD9->ZD9_DUF)),10), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,0520,PadL("De Outra Unidade da Federação:",30)+Replicate("-",130), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_EFE+ZD9->ZD9_DFE)),10), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,0520,PadL("Soma:",42)+Replicate("-",130), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_EFE+ZD9->ZD9_DFE+ZD9->ZD9_EUF+ZD9->ZD9_DUF)),10), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,0500) //80
oPrn:Box(liant,0500,li,3400) //80

liant := li
oPrn:Say(li+5,2800,"Subtotal:", aFontes[2],,,,3)                                                               
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SANT+ZD9->ZD9_EFE+ZD9->ZD9_DFE+ZD9->ZD9_EUF+ZD9->ZD9_DUF)),10), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
	
	
liant := li
oPrn:Say(li+80,0070,"Saída", aFontes[4],,,,3)
oPrn:Say(li+5,0520,PadL("Abate:",20)+Replicate("-",150), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SA)),10), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,0520,PadL("Saídas em Pé:",15)+Replicate("-",150), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SP)),10), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,0520,PadL("Soma:",19)+Replicate("-",150), aFontes[3],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SP+ZD9->ZD9_SA)),10), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,0500) //80
oPrn:Box(liant,0500,li,3400) //80

liant := li
oPrn:Say(li+5,2400,"Saldo que passa para o boletim seguinte:", aFontes[2],,,,3)
oPrn:Say(li+5,3200,PadL(Alltrim(Str(ZD9->ZD9_SALDO)),10), aFontes[3],,,,3)

li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0070,"OBS:", aFontes[4],,,,3)
oPrn:Say(li+50,0300,ZD9->ZD9_OBS, aFontes[3],,,,3)
li += 100
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0070,"VI. CONTROLADORES MECANICOS", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0400,"DADOS", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liAnt,2400,li,2400)
oPrn:Line(liAnt,2900,li,2900)

liant := li
oPrn:Say(li+5,0070,"Número do Aparelho:", aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liAnt,2400,li,2400)
oPrn:Line(liAnt,2900,li,2900)

liant := li
oPrn:Say(li+5,0070,"Leitura após as passagens:", aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liAnt,2400,li,2400)
oPrn:Line(liAnt,2900,li,2900)

liant := li
oPrn:Say(li+5,0070,"Leitura Anterior:", aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liAnt,2400,li,2400)
oPrn:Line(liAnt,2900,li,2900)

liant := li
oPrn:Say(li+5,0070,"Passagens Relativas a este:", aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liAnt,2400,li,2400)
oPrn:Line(liAnt,2900,li,2900)
		
liant := li
oPrn:Say(li+5,0100,"OBS: ABATE DE GADO DO DIA : "+DTOC(ZD9->ZD9_DATA), aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80
		
For nI := 1 to Len(aNotasEst)
	liant := li
	oPrn:Say(li+5,0070,"N.F.E.:", aFontes[2],,,,3)
	oPrn:Say(li+5,0200,aNotasEst[nI][8], aFontes[3],,,,3)
	oPrn:Say(li+5,1500,PadR(Str(aNotasEst[nI][2]),30), aFontes[3],,,,3)
	oPrn:Say(li+5,2000,aNotasEst[nI][1], aFontes[3],,,,3)
	li += 70
	oPrn:Box(liant,0050,li,3400) //80        
	Quebra()
Next nI
For nI := 1 to Len(aNotasFed)
	liant := li
	oPrn:Say(li+5,0070,"N.F.E.:", aFontes[2],,,,3)
	oPrn:Say(li+5,0200,aNotasFed[nI][8], aFontes[3],,,,3)
	oPrn:Say(li+5,1500,PadR(Str(aNotasFed[nI][2]),30), aFontes[3],,,,3)
	oPrn:Say(li+5,2000,aNotasFed[nI][1], aFontes[3],,,,3)
	li += 70
	oPrn:Box(liant,0050,li,3400) //80
	Quebra()
Next nI
		
liant := li
oPrn:Say(li+15,0070,"Declaramos sob as penas da lei que os dados do presente boletim são a expressão da verdade", aFontes[3],,,,3)
oPrn:Say(li+20,2400,Alltrim(SM0->M0_CODFIL)+" - "+SM0->M0_FILIAL, aFontes[5],,,,3)
li += 100
oPrn:Say(li+5,0070,"Em: "+DtoC(dDataBase), aFontes[3],,,,3)
oPrn:Say(li+15,2300,Replicate("_",60), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,02400,ZD9->ZD9_RESP , aFontes[3],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,1500,"VISTO DO POSTO FISCAL", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,3400) //80

liant := li
oPrn:Say(li+5,0070,"1º", aFontes[1],,,,3)
oPrn:Say(li+5,1750,"2º", aFontes[1],,,,3)
li += 150
oPrn:Line(liant,1740,li,1740) //80
oPrn:Box(liant,0050,li,3400) //80


liant := li
oPrn:Say(li+5,0070,"1ª Via: Posto Fiscal / 2ª Via: Emitente", aFontes[1],,,,3)
li += 70
	
oprn:EndPage()
//oPrn:StartPage()

LI := 50

liant := li
oPrn:Say(li+5,0400,"COMPROVANTE DO ICM PAGO A OUTRA UNIDADE DA FEDERAÇÃO", aFontes[1],,,,3)
oPrn:Say(li+5,2200,"NOTA FISCAL DE ENTRADA", aFontes[1],,,,3)
oPrn:Say(li+5,3005,"CREDITO A", aFontes[1],,,,3)
oPrn:Say(li+75,3005,"UTILIZAR", aFontes[1],,,,3)
oPrn:Say(li+145,3005,"NA CONTA", aFontes[1],,,,3)
oPrn:Say(li+215,3005,"GRÁFICA-R$", aFontes[1],,,,3)
li += 70
oPrn:Box(liant,0050,li,2900) //80
oPrn:Line(liAnt,2000,li,2000)
oPrn:Box(liAnt,2900,liAnt+280,3400)

liant := li
oPrn:Say(li+55,0070,"ANO:XX", aFontes[2],,,,3)
oPrn:Say(li+125,0070,"DIA/MES", aFontes[2],,,,3)
oPrn:Say(li+85,0275,"ESPECIE", aFontes[2],,,,3)
oPrn:Say(li+85,0475,"SR", aFontes[2],,,,3)
oPrn:Say(li+85,0620,"NUMERO", aFontes[2],,,,3)
oPrn:Say(li+85,0870,"MUNICIPIO", aFontes[2],,,,3)
oPrn:Say(li+85,1270,"UF", aFontes[2],,,,3)
oPrn:Say(li+55,1370,"BASE CALCULO", aFontes[2],,,,3)
oPrn:Say(li+125,1470,"R$", aFontes[2],,,,3)
oPrn:Say(li+55,1670,"ALIQ", aFontes[2],,,,3)
oPrn:Say(li+125,1700,"%", aFontes[2],,,,3)
oPrn:Say(li+55,1810,"ICMS", aFontes[2],,,,3)
oPrn:Say(li+125,1810,"PAGO R$", aFontes[2],,,,3)
oPrn:Say(li+85,2030,"NUMERO", aFontes[2],,,,3)
oPrn:Say(li+85,2250,"SERIE", aFontes[2],,,,3)
oPrn:Say(li+55,2500,"VALOR", aFontes[2],,,,3)
oPrn:Say(li+125,2400,"OPERACAO-R$", aFontes[2],,,,3)
oPrn:Say(li+55,2750,"ICMS", aFontes[2],,,,3)
oPrn:Say(li+125,2700,"INCI-R$", aFontes[2],,,,3)
li += 210
oPrn:Box(liant,0050,li,2900) //80
oPrn:Line(liant,0265,li,0265)
oPrn:Line(liant,0465,li,0465)
oPrn:Line(liant,0615,li,0615)
oPrn:Line(liant,0865,li,0865)
oPrn:Line(liant,1265,li,1265)
oPrn:Line(liant,1365,li,1365)
oPrn:Line(liant,1665,li,1665)
oPrn:Line(liant,1790,li,1790)
oPrn:Line(liant,2000,li,2000)
oPrn:Line(liant,2200,li,2200)
oPrn:Line(liant,2390,li,2390)
oPrn:Line(liant,2690,li,2690)                                                    
	
For nI := 1 to Len(aICMS)
	liant := li
	oPrn:Say(li+5,0070,aICMS[nI,02], aFontes[3],,,,3) //ANO
	oPrn:Say(li+5,0275,aICMS[nI,03], aFontes[3],,,,3) //Especie
	oPrn:Say(li+5,0475,aICMS[nI,04], aFontes[3],,,,3) //SR 
	oPrn:Say(li+5,0620,aICMS[nI,05], aFontes[3],,,,3) //Numero
	oPrn:Say(li+5,0870,aICMS[nI,06], aFontes[7],,,,3) //Municipio
	oPrn:Say(li+5,1270,aICMS[nI,07], aFontes[3],,,,3)  //UF
	oPrn:Say(li+5,1390,cValToCHar(aICMS[nI,08]), aFontes[8],,,,3)  //Base Calculo
	oPrn:Say(li+5,1680,Alltrim(Str(aICMS[nI,09],5)), aFontes[3],,,,3)           //Aliq %
	oPrn:Say(li+5,1820,cValToCHar(aICMS[nI,10]), aFontes[8],,,,3) //ICMS PAGO 
	oPrn:Say(li+5,2005,aICMS[nI,11], aFontes[7],,,,3) //Numero
	oPrn:Say(li+5,2250,aICMS[nI,12], aFontes[7],,,,3) //ICMS
	oPrn:Say(li+5,2420,cValToCHar(aICMS[nI,13]), aFontes[8],,,,3) //Valor Operacao
	oPrn:Say(li+5,2720,Alltrim(Str(aICMS[nI,14],8,2)), aFontes[8],,,,3) //ICMS
	li += 70
	oPrn:Box(liant,0050,li,3400) //80
	oPrn:Line(liant,0265,li,0265)
	oPrn:Line(liant,0465,li,0465)
	oPrn:Line(liant,0615,li,0615)
	oPrn:Line(liant,0865,li,0865)
	oPrn:Line(liant,1265,li,1265)
	oPrn:Line(liant,1365,li,1365)
	oPrn:Line(liant,1665,li,1665)
	oPrn:Line(liant,1790,li,1790)
	oPrn:Line(liant,2000,li,2000)
	oPrn:Line(liant,2200,li,2200)
	oPrn:Line(liant,2390,li,2390)
	oPrn:Line(liant,2690,li,2690)
	oPrn:Line(liant,2900,li,2900)
	nTotICMS  +=  aICMS[nI,10]
Next nI

liant := li
oPrn:Say(li+5,2460,"Total ou Transporte =>", aFontes[2],,,,3)
oPrn:Say(li+5,2920,Alltrim(Str(nTotICMS,17,2)), aFontes[3],,,,3)

li += 70
oPrn:Box(liant,0050,li,3400) //80
oPrn:Line(liant,2900,li,2900)

li += 70
liant := li
oPrn:Say(li+5,0200,"ANEXO AO BOLETIM DE ABATE", aFontes[1],,,,3)
li += 60
oPrn:Say(li+5,200,"Número", aFontes[2],,,,3)
oPrn:Say(li+5,750,"De", aFontes[2],,,,3)
li += 60
oPrn:Line(li,0100,li,1000)
oPrn:Say(li+5,160,cPedido, aFontes[3],,,,3)
oPrn:Say(li+5,690,dtoc(dDatabase), aFontes[3],,,,3)
li += 60
oPrn:Line(li,0100,li,1000)
oPrn:Box(liant,0100,li,1000) //80
oPrn:Line(liant+70,0550,li,0550)

li := liant
oPrn:Say(li+5,1200,"CONTRIBUINTE EMITENTE", aFontes[1],,,,3)
li += 70
oPrn:Line(li,1050,li,2050)
oPrn:Say(li+5,1100,"Nome:", aFontes[2],,,,3)
oPrn:Say(li+5,1250,SM0->M0_CODFIL+" - "+SM0->M0_FILIAL, aFontes[3],,,,3)
li += 70
oPrn:Line(li,1050,li,2050)
oPrn:Say(li+5,1100,"Endereço:", aFontes[2],,,,3)
oPrn:Say(li+5,1300,SM0->M0_ENDCOB, aFontes[7],,,,3)
li += 70
oPrn:Line(li,1050,li,2050)
oPrn:Say(li+5,1100,"Município:", aFontes[2],,,,3)
oPrn:Say(li+5,1300,ALLTRIM(SM0->M0_CIDENT), aFontes[7],,,,3)
oPrn:Say(li+5,1500,"UF:", aFontes[2],,,,3)
oPrn:Say(li+5,1600,SM0->M0_ESTENT, aFontes[7],,,,3)
oPrn:Say(li+5,1700,"CNAE:", aFontes[2],,,,3)
oPrn:Say(li+5,1815,Transform(SM0->M0_CNAE,"@R 9999-9/99"), aFontes[7],,,,3)
li += 70
oPrn:Say(li+5,1100,"CGC:", aFontes[2],,,,3)
oPrn:Say(li+5,1200,Transform(Substr(SM0->M0_CGC,1,9),"@R 999.999.999")+"/"+Transform(Substr(SM0->M0_CGC,9,6),"@R 9999-99"), aFontes[7],,,,3)
oPrn:Say(li+5,1605,"I.E.:", aFontes[2],,,,3)
oPrn:Say(li+5,1700,SM0->M0_INSC, aFontes[7],,,,3)
li += 70
oPrn:Line(li,1050,li,2050)
oPrn:Box(liant,1050,li,2050) //80

li := liant
oPrn:Say(li+5,2500,"VISTO DO POSTO FISCAL", aFontes[1],,,,3)
oPrn:Line(li+70,2100,li+70,3350)
li += 350
oPrn:Box(liant,2100,li,3350) //80

li := liant
li += 230
liant := li
oPrn:Say(li+5,0200,"DEMONSTRATIVO DE CREDITO DO", aFontes[1],,,,3)
li += 60
oPrn:Say(li+5,0400,"ICM - GADO", aFontes[1],,,,3)
li += 60
oPrn:Box(liant,0100,li,1000) //80

li += 70
oPrn:Box(li-490,0050,li,3400) //80

oPrn:Say(li+5,0100,"GOVERNO DO ESTADO DE SÃO PAULO", aFontes[3],,,,3)
oPrn:Say(li+5,2800,"PORTARIA CAT = 080/07", aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,0100,"SECRETARIA DE ESTADO DOS NEGOCIOS DA FAZENDA", aFontes[3],,,,3)

li += 140
oPrn:Say(li+5,01300,Alltrim(SM0->M0_CODFIL)+" - "+SM0->M0_FILIAL, aFontes[3],,,,3)
li += 140
oPrn:Say(li+5,01300,Replicate("_",50), aFontes[3],,,,3)
li += 70
oPrn:Say(li+5,01300,ZD9->ZD9_RESP, aFontes[3],,,,3)

oPrn:Preview()


Return
*************************************************************************************************
Static Function Quebra()
	If li > 2300
		oprn:EndPage()
		LI := 50
		//oPrn:StartPage()
	EndIf
Return
*************************************************************************************************
Static Function Ret_Tam(cTexto,oFontText)
//Local x := oPrn:nLogPixelx()
//Local y := oPrn:GetTextWidth(cTexto, oFontText ) * 0.3937 
Local nRet := 0//ROUND(y * x,0) 

nRet:= ROUND(oPrn:GetTextWidth(cTexto, oFontText )+10 ,0)

Return nRet
*************************************************************************************************************
Static Function Inc_BOL
Local bRet       := .F.
Local aRet		 := {}
Local aParambox	 := {}                 
Local cBol       := ''
Local cQuery     := ''
Local aCred      := {}
Local nPos       :=  0            
Local nI         := 0  
Local nL         := 0 
Local aAux       := 0 
Local nTotalUF   := 0 
Local nTotalFora := 0 
local nTot		 := 0

Private nSaldoAnt := 0 
Private cBolAnt   := ''
Private dDataAnt  := CTOD('  /  /  ')

AAdd(aParamBox, {1, "Dt. Emissão :"	,CTOD('  /  /  '),"@!",,,, 070,.F.})
AAdd(aParamBox, {1, "Abatedouro  :"	,SPACE(6),"@!","EMPTY(MV_PAR02) .OR. ExistCPO('SA2',MV_PAR02,1)","SA2",, 060,.F.})
AAdd(aParamBox, {1, "Loja Abat.  :"	,SPACE(2),"@!",,,, 030,.F.})
IF ParamBox(aParambox, "Gerar Boletim de Abate"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	ZD9->(dbSetOrder(2))
	IF ZD9->(dbSeek(xFilial('ZD9')+DTOS(MV_PAR01)))
		IF Empty(MV_PAR02)
			MsgAlert('Já existe Boletim nesta Data !!')
			Return
		Else
			While ZD9->(!Eof()) .And. ZD9->ZD9_DATA == MV_PAR01
				IF ZD9->(ZD9_ABATE+ZD9_ABLOJA) == MV_PAR02+MV_PAR03
					MsgAlert('Já existe Boletim nesta Data e Abatedouro !!')
					Return
				EndIF
				ZD9->(dbSkip())
			End
		EndIF
	EndIF
	bRet  := .T.
	//'  NVL((saldo_anterior + (ent_estado+qtd_devol_uf+ent_fora_est+qt' +
	//                              'd_devol_fora_uf)) - (sai_abate + sai_em_pe),0) saldo'
	cQuery := " Select B1_COD,                                             " +CRLF
	cQuery += "        a.R_E_C_N_O_ REC,	   							     " +CRLF
	cQuery += "        e.F1_EMISSAO,										 " +CRLF
	cQuery += "        B1_DESC,                                            " +CRLF
	cQuery += "        SUM(ZZN_QTCAB+ ZZN_QTPE) QTD_CAB,                     " +CRLF//alterado Rafael, não pode somar quantidade de perda
	cQuery += "        SUM(ZZN_QTKG) QTD_KG,                                 " +CRLF
	cQuery += "        ZZM_DOC,                                              " +CRLF
	cQuery += "        ZZM_SERIE,                                            " +CRLF
	cQuery += "        ZZM_FORNEC,                                           " +CRLF
	cQuery += "        ZZM_LOJA,                                             " +CRLF
	cQuery += "        CASE WHEN F1_EST = 'SP' THEN 'S' ELSE 'N' END NOUF,    " +CRLF
	cQuery += "        F1_ZICMS                                             " +CRLF
	cQuery += " From "+RetSQLName("ZZM")+" a, "+RetSQLName("ZZN")+" b, "+RetSQLName("SB1")+" c, "+RetSQLName("SF1")+" e        " +CRLF
	cQuery += " Where a.D_E_L_E_T_ = ' '                                     " +CRLF
	cQuery += "   AND b.D_E_L_E_T_ = ' '                                     " +CRLF
	cQuery += "   AND c.D_E_L_E_T_ = ' '                                     " +CRLF
	cQuery += "   AND e.D_E_L_E_T_ = ' '                                     " +CRLF
	cQuery += "   AND ZZM_FILIAL   = ZZN_FILIAL                              " +CRLF
	cQuery += "   AND ZZM_PEDIDO   = ZZN_PEDIDO                              " +CRLF
//	cQuery += "   AND ZZM_EMITE    = 'S'                                     " +CRLF
	cQuery += "   AND ZZM_AGRUP    = ' '                                     " +CRLF
	cQuery += "   AND c.B1_FILIAL  = '"+xFilial('SB1')+"'                    " +CRLF
	cQuery += "   AND ZZN_CODAGR  = c.B1_COD                                 " +CRLF
	cQuery += "   AND ZZN_VLTOT<>0		                                     " +CRLF //alterado Rafael 12/11/18
	cQuery += "   AND ZZM_DOC      <> ' '                                    " +CRLF
	cQuery += "   AND ZZM_FILIAL   = F1_FILIAL                               " +CRLF
	cQuery += "   AND ZZM_DOC      = F1_DOC                                  " +CRLF
	cQuery += "   AND ZZM_SERIE    = F1_SERIE                                " +CRLF
	cQuery += "   AND ZZM_FORNEC   = F1_FORNECE                              " +CRLF
	cQuery += "   AND ZZM_LOJA     = F1_LOJA                                 " +CRLF
	IF !Empty(MV_PAR02)
		cQuery += "   AND ZZM_ABATE  = '"+MV_PAR02+"' "+CRLF
		cQuery += "   AND ZZM_ABLOJA = '"+MV_PAR03+"' "+CRLF
	Else
		cQuery += "   AND ZZM_ABATE  = ' ' "+CRLF
		cQuery += "   AND ZZM_ABLOJA = ' ' "+CRLF
	EndIF
	cQuery += "   AND ZZM_FILIAL   = '"+xFilial('ZZM')+"' "+CRLF
	cQuery += "   AND e.F1_EMISSAO = '"+DTOS(MV_PAR01)+"' "+CRLF
	cQuery += " GROUP BY B1_COD,                                           " +CRLF
	cQuery += "        a.R_E_C_N_O_ ,  	   							         " +CRLF
	cQuery += "        e.F1_EMISSAO,										 " +CRLF
	cQuery += "        B1_DESC,                                            " +CRLF
	cQuery += "        ZZM_DOC,                                              " +CRLF
	cQuery += "        ZZM_SERIE,                                            " +CRLF
	cQuery += "        ZZM_FORNEC,                                           " +CRLF
	cQuery += "        ZZM_LOJA,                                             " +CRLF
	cQuery += "        CASE WHEN F1_EST = 'SP' THEN 'S' ELSE 'N' END,        " +CRLF
	cQuery += "        F1_ZICMS                                              " +CRLF
	If Select("QRY_ITENS") > 0
		QRY_ITENS->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)                        
	memowrite('C:\temp\abate.sql',cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ITENS",.T.,.F.)
	dbSelectArea('SD1')
	SD1->(dbSetOrder(1))
	dbSelectArea("QRY_ITENS")
	QRY_ITENS->(dbGoTop())
	IF QRY_ITENS->(EOF())                                                       
	    MsgAlert('Não há registros de Abate neste dia/Abatedouro !')
	    Return
	EndIF
	cBol  := GeraNUM()
	RecLock('ZD9',.T.)
	ZD9->ZD9_FILIAL  := xFilial('ZD9')
	ZD9->ZD9_NUM     := cBol
	ZD9->ZD9_ANO     := SubStr(DTOS(dDataBase),1,4)
	ZD9->ZD9_DATA    := MV_PAR01
	ZD9->ZD9_SANT    := nSaldoAnt
	ZD9->ZD9_BOLANT  := cBolAnt
	ZD9->ZD9_EMISAN  := dDataAnt
	ZD9->ZD9_USER    := RetCodUsr()
	ZD9->ZD9_ABATE   := MV_PAR02
	ZD9->ZD9_ABLOJA  := MV_PAR03
	ZD9->(MsUnlock())
	While !QRY_ITENS->(EOF())
		RecLock('ZD0',.T.)
		ZD0->ZD0_FILIAL := xFilial('ZD0')
		ZD0->ZD0_NUM    := cBol
		ZD0->ZD0_ANO    := SubStr(DTOS(dDataBase),1,4)
		ZD0->ZD0_ITEM   := QRY_ITENS->B1_COD
		ZD0->ZD0_DESC   := QRY_ITENS->B1_DESC
		ZD0->ZD0_QTCAB  := QRY_ITENS->QTD_CAB
		ZD0->ZD0_PE     := QRY_ITENS->QTD_KG
		ZD0->ZD0_NF     := QRY_ITENS->ZZM_DOC
		ZD0->ZD0_UF     := QRY_ITENS->NOUF
		ZD0->ZD0_SERIE  := QRY_ITENS->ZZM_SERIE
		ZD0->ZD0_FORNEC := QRY_ITENS->ZZM_FORNEC
		ZD0->ZD0_LOJA   := QRY_ITENS->ZZM_LOJA
		ZD0->ZD0_NC     := QRY_ITENS->ZZM_DOC
		ZD0->ZD0_REC    := QRY_ITENS->REC
		//ZD0->ZD0_ABATE   := MV_PAR02
		//ZD0->ZD0_ABLOJA  := MV_PAR03

		IF SD1->(dbSeek(xFilial('ZD0')+;
			PADR(QRY_ITENS->ZZM_DOC,TamSx3('D1_DOC')[01])+;
			PADR(QRY_ITENS->ZZM_SERIE,TamSx3('D1_SERIE')[01])+;
			PADR(Alltrim(QRY_ITENS->ZZM_FORNEC),TamSx3('D1_FORNECE')[01])+;
			PADR(QRY_ITENS->ZZM_LOJA,TamSx3('D1_LOJA')[01])+;
			QRY_ITENS->B1_COD))
			ZD0->ZD0_PUNIT  := SD1->D1_VUNIT
	//		ZD0->ZD0_TRIBUT := SD1->D1_TOTAL Alterado para pegar demais itens da nota Rafael 09/10/18
			while SD1->(!eof()) .and. ALLTRIM(xFilial('ZD0'))== ALLTRIM(SD1->D1_FILIAL) .AND. ALLTRIM(QRY_ITENS->ZZM_DOC)== ALLTRIM(SD1->D1_DOC) .AND.;
			ALLTRIM(QRY_ITENS->ZZM_SERIE)==ALLTRIM(SD1->D1_SERIE) .AND. Alltrim(QRY_ITENS->ZZM_FORNEC)== ALLTRIM(SD1->D1_FORNECE) .AND. ;
			ALLTRIM(QRY_ITENS->ZZM_LOJA)==ALLTRIM(SD1->D1_LOJA) .AND. ALLTRIM(QRY_ITENS->B1_COD)==ALLTRIM(SD1->D1_COD)
				nTot := nTot+SD1->D1_TOTAL
				SD1->(DBSKIP())
			enddo
			ZD0->ZD0_TRIBUT := nTot
			nTot:=0
		EndIF
		ZD0->(MsUnlock())
		
		IF QRY_ITENS->NOUF =='S'
			nTotalUF   += QRY_ITENS->QTD_CAB
		Else
			nTotalFora += QRY_ITENS->QTD_CAB
		EndIF
		IF QRY_ITENS->F1_ZICMS > 0 
			nPos :=  aScan( aCred, { |x| x[1] == QRY_ITENS->ZZM_DOC+QRY_ITENS->ZZM_SERIE+QRY_ITENS->ZZM_FORNEC+QRY_ITENS->ZZM_LOJA })
			IF nPOS == 0
				AAdd(aCred,{QRY_ITENS->ZZM_DOC+QRY_ITENS->ZZM_SERIE+QRY_ITENS->ZZM_FORNEC+QRY_ITENS->ZZM_LOJA,QRY_ITENS->QTD_CAB,QRY_ITENS->F1_ZICMS,{ZD0->(Recno())}})
			Else
				aCred[nPos,2] += QRY_ITENS->QTD_CAB
				aAux          := aCred[nPos,4]
				AAdd(aAux,ZD0->(Recno()))
				aCred[nPos,4] := aAux
			EndIF
		EndIF
		QRY_ITENS->(dbSkip())
	EndDo
	RecLock('ZD9',.F.)
	ZD9->ZD9_EUF    := nTotalUF
	ZD9->ZD9_EFE    := nTotalFora
	ZD9->ZD9_SA     := nTotalUF +nTotalFora
	ZD9->ZD9_SALDO  := ZD9->ZD9_SANT + ZD9->ZD9_EUF + ZD9->ZD9_DUF + ZD9->ZD9_EFE + ZD9->ZD9_DFE - ZD9->ZD9_SA -ZD9->ZD9_SP
	ZD9->(MsUnlock())
	For nI := 1 To Len(aCred)
		For nL := 1 To Len(aCred[nI][04])
			ZD0->(dbGoTO(aCred[nI][04][nL]))
			RecLock('ZD0',.F.)
			ZD0->ZD0_VCRED := Round(ZD0->ZD0_QTCAB * aCred[nI][03]/aCred[nI][02],2)
			ZD0->(MsUnlock())
		Next nL
	Next nI
	ZD9->(dbSetOrder(1))
EndIF

Return bRet

**********************************************************************************************************************************
Static Function GeraNUM
Local cQuery := ''
Local cBOL    := '00001'

cQuery  := " SELECT ZD9_NUM, R_E_C_N_O_ RECZD9 "
cQuery  += " FROM "+RetSqlName("ZD9")
cQuery  += " WHERE D_E_L_E_T_ = ' ' "
cQuery  += "  AND ZD9_FILIAL  = '"+xFilial('ZD9')+"'"
cQuery  += "  AND ZD9_ANO     = '"+SubStr(DTOS(dDataBase),1,4)+"'"
//IF !Empty(MV_PAR02)
//	cQuery += "   AND ZD9_ABATE  = '"+MV_PAR02+"' "+CRLF
//	cQuery += "   AND ZD9_ABLOJA = '"+MV_PAR03+"' "+CRLF
//EndIF
cQuery  += " ORDER BY ZD9_NUM desc "

If Select("QRY_BOL") > 0
	QRY_BOL->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_BOL",.T.,.F.)
dbSelectArea("QRY_BOL")
QRY_BOL->(dbGoTop())
IF !QRY_BOL->(EOF()) 
	ZD9->(dbGoto(QRY_BOL->RECZD9)) 
	nSaldoAnt := ZD9->ZD9_SALDO 
	cBolAnt   := ZD9->ZD9_NUM+'/'+ ZD9->ZD9_ANO
	dDataAnt  := ZD9->ZD9_DATA 
	cBOL      := SOMA1(QRY_BOL->ZD9_NUM)
EndIF

Return cBOL
**************************************************************************************************************************************************
User Function INT26_Calc()

IF ALTERA
   M->ZD9_SALDO := M->ZD9_SANT + M->ZD9_EUF + M->ZD9_DUF + M->ZD9_EFE + M->ZD9_DFE - M->ZD9_SA -M->ZD9_SP 
EndIF

Return .T.
******************************************************************************************************************************************
User Function INT26_IT
                
Local aAux := {}
Local nI   := 0 
Private aParamBox := {} 
Private aRet      := {}         
Private nPosCred  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZD0_VCRED' }) 
Private nPosNF    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZD0_INFO' }) 
            
            
IF oGet:aCols[oGet:nAt][nPosCred] == 0 
     MsgAltert('A Nota fiscal não possui Creditos !!')
Else
	AAdd(aParamBox, {1, "Especie :"         ,Space(5) , "@!",                           ,      ,, 050	, .T.	})
	AAdd(aParamBox, {1, "Serie :"           ,Space(3) , "@!",                           ,      ,, 050	, .T.	})
	AAdd(aParamBox, {1, "Número :"          ,Space(20) , "@!",                           ,      ,, 050	, .T.	})
	IF ParamBox(aParambox, "Inclui Informações Sobre NF Produtor"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		ZD0->(dbGoTo(aRecZD0[oGet:nAt]))
		Reclock("ZD0",.F.)
		ZD0->ZD0_INFO := MV_PAR01+';'+MV_PAR02+';'+MV_PAR03
		ZD0->(MsUnlock())           
		aCols[oGet:nAt][nPosNF] := ZD0->ZD0_INFO
		oGet:SetArray(aCols,.T.)
		oGet:ForceRefresh()
	EndIF
EndIF
	
Return

