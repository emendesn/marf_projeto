#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH'                                        
/*
=====================================================================================
Programa.:              MGFINT51 - RELATORIO DE CONTROLE DE ACERTOS
Autor....:              Antonio Carlos        
Data.....:              18/12/2017                                                                                                            
Descricao / Objetivo:   Relatório de CONTROLE DE ACERTOS                           
Doc. Origem:            Contrato - GAP MGFINT51
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relatório de CONTROLE DE ACERTOS  
=====================================================================================
*/
User Function MGFINT51()
Private _cEnter := CHR(13)+Chr(10)
Private titulo  := "Relatorio de Controle de Acertos "
Private cDesc1  := "Relatorio de Controle de Acertos "
Private cDesc2  := " "
Private cDesc3  := " "                           
Private Cabec1  := " "
Private Cabec2  := " "
Private cQry    := " "
Private cString := "ZZM"
Private wnrel       := "RINT051"
Private nomeprog    := "RINT051"
Private cArqTmp     := " "
Private nLastKey    := 0
Private aDadosR     := {}
Private cMvpar	    := " "
Private tamanho     := "G"
Private lAbortPrint := .F.
Private _lTemDados  := .T.
Private lFirst 		:= .T.
Private oReport
Private oSection1
Private _nTotCab := 0 
Private _nTotKg  := 0
Private _nTotAr  := 0
Private _nTotVl  := 0
Private _nPesMed := 0
Private nCont    := 0
Private _cNComp  := SPACE(06) 
Private _cPerg   := "MGFI51"
Private mv_par01 := SPACE(06) 
Private mv_par02 := SPACE(06)                                    
Private cFILNFE  := GetMV('MGF_TAE17',.F.,"")
Private cFILDUPL := GetMV('MGF_TAE15A',.F.,"")
Private bEmite   := IIF(ZZM->ZZM_FILIAL $ cFILDUPL,IIF(ZZM->ZZM_EMITE=='S',.T.,.F.),IIF(ZZM->ZZM_FILIAL $ cFILNFE ,.F.,.T.)) //IIF(ZZM->ZZM_EMITE=='S',.T.,.F.)
                       
SF1->(dbSetOrder(1))
SF2->(dbSetOrder(1))
	
IF bEmite 
   IF Empty(ZZM->ZZM_DOC+ZZM->ZZM_SERIE)
    	msgAlert('Nota fiscal ainda emitida !!')
    	Return
   EndIF
EndIF
IF Select("TRBACER") > 0
	TRBACER->(DBCLOSEAREA())
Endif
        
	cQry  := " SELECT " +_cEnter
	cQry  += "    ZZM_FILIAL, M0_FILIAL, M0_NOMECOM, A2_NOME, ZZM_DTPROD, ZZM_DOC, " +_cEnter
	cQry  += "    ZZM_SERIE, ZZM_VENCE, ZZN_PRODUT, ZZN_QTCAB, ZZN_VLARRO, " +_cEnter
	cQry  += "    ZZN_VLTOT, ZZN_QTKG, ZZN_QTCAB, ZZM_PEDIDO, " +_cEnter
	cQry  += "    ZZM_VLACR, ZZM_DESPEC, ZZM_DESPEC, ZZM_ICMSNP, " +_cEnter
	cQry  += "    ZZM_ICMSFR, ZZM_VLDESC, ZZM_OBS, ZZM_BANCO, " +_cEnter
	cQry  += "    ZZM_AGENCI, ZZM_CONTA " +_cEnter
	IF bEmite
		cQry  += "    ,F1_VALFUND, F1_DOC, F1_FILIAL, F1_SERIE, F1_FORNECE, F1_LOJA, F1_CONTSOC, F1_VALBRUT, " +_cEnter
		cQry  += "    F1_DESPESA, F1_VALICM, F1_VLSENAR " +_cEnter
		cQry  += " FROM " + RetSqlName("ZZM") + " a, " + RetSqlName("SF1") + " b ," + RetSqlName("SA2") + " c ," + RetSqlName("ZZN") + " d, SYS_COMPANY E " +_cEnter
		cQry  += " WHERE a.D_E_L_E_T_ = ' '  "               +_cEnter
		cQry  += "   AND b.D_E_L_E_T_ = ' ' "            +_cEnter
		cQry  += "   AND E.D_E_L_E_T_ = ' ' "            +_cEnter
		cQry  += "   AND ZZM_FILIAL  = M0_CODFIL " +_cEnter
		cQry  += "   AND ZZM_FILIAL  = F1_FILIAL " +_cEnter
		cQry  += "   AND ZZM_DOC     = F1_DOC " +_cEnter
		cQry  += "   AND ZZM_SERIE   = F1_SERIE " +_cEnter
		cQry  += "   AND ZZM_FORNEC  = F1_FORNECE " +_cEnter
		cQry  += "   AND ZZM_LOJA    = F1_LOJA " +_cEnter
	Else
		cQry  += " FROM " + RetSqlName("ZZM") + " a," + RetSqlName("SA2") + " c ," + RetSqlName("ZZN") + " d, SYS_COMPANY E " +_cEnter
		cQry  += " WHERE a.D_E_L_E_T_ = ' '  "               +_cEnter
	EndIF
	cQry  += "   AND c.D_E_L_E_T_ = ' ' " +_cEnter
	cQry  += "   AND d.D_E_L_E_T_ = ' ' " +_cEnter
	cQry  += "   AND E.D_E_L_E_T_ = ' ' " +_cEnter
	cQry  += "   AND A2_FILIAL   = '" + xFilial('SA2') + "' " +_cEnter
	cQry  += "   AND A2_COD      = ZZM_FORNEC  "         +_cEnter
	cQry  += "   AND A2_LOJA     = ZZM_LOJA"        +_cEnter
	cQry  += "   AND ZZN_FILIAL  = ZZM_FILIAL " +_cEnter
	cQry  += "   AND ZZN_PEDIDO  = ZZM_PEDIDO " +_cEnter
	cQry  += "   AND ZZM_FILIAL  = M0_CODFIL " +_cEnter
	cQry  += "   AND ZZM_FILIAL  = '" + ZZM->ZZM_FILIAL + "' " +_cEnter
	cQry  += "   AND ZZM_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' " +_cEnter
	cQry  := ChangeQuery(cQry)

	// MemoWrite("C:\totvs\sql\IMP050.SQL",cQry)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBACER",.F.,.t.)
	Processa({|| ImpRel()},,"Imprimindo...")

	TRBACER->(dbCloseArea())
Return( .T. )
*********************************************************************************************************************************
Static Function ImpRel()

Local cQry := ""

Private oFontC1:= TFont():New( "Arial",18,18,,.F.,,,,.T.,.F. )
Private oFont1:= TFont():New( "Arial",14,14,,.F.,,,,.T.,.F. )
//Private oFont1:= TFont():New( "Arial",15,15,,.F.,,,,.T.,.F. )
Private oFontN:= TFont():New( "Arial",21,21,,.T.,,,,.T.,.F. )
Private oFontL:= TFont():New( "Arial",15,15,,.F.,,,,.T.,.F. )
//Private oFont3:= TFont():New( "Arial",8,8,,.F.,,,,.T.,.F. )
Private oFont3:= TFont():New( "Arial",12,12,,.F.,,,,.T.,.F. )
Private oFont4:= TFont():New( "Arial",14,14,,.T.,,,,.T.,.F. )
Private oFont5:= TFont():New( "Arial",16,16,,.T.,,,,.T.,.F. )
Private oFont6:= TFont():New( "Arial",24,24,,.T.,,,,.T.,.F. )
Private oFont7:= TFont():New( "Arial",16,16,,.T.,,,,.T.,.F. )
Private oFont8:= TFont():New( "Arial",18,18,,.T.,,,,.T.,.F. )

Private oPrn
Private _nPag := 0 
Private _nLin := 150                                        
Private nCol  := 50

oPrn:=FWMSPrinter():New(alltrim(SUBSTR(TRBACER->ZZM_PEDIDO,1,6)),6,,,.T.,) //imprime direto em PDF e inibi a tela de setup
oPrn:SetPortrait()
//oPrn:SetLandScape()
oPrn:StartPage()

TRBACER->(DBGOTOP())
IF TRBACER->(EOF())
	Aviso("Aviso","Não há dados a serem impressos  !!!",{"Ok"})
   Return
ENDIF

_nPag++
CabecMarf(_nPag,_nPag,"P")

ImpItens()

Imptot()  

IF bEmite
	ImpFin()  
Else 
    ImpNotas()
EndIF

oPrn:Preview()

Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabecMarf ºAutor  ³ A.Carlos           º Data ³  18/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabeçalho do relatório 		             		          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Marfrig	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecMarf(_nPag,_nTotpg,_cTipo)
    LOCAL _cPag := Alltrim(STR(_nPag))
    LOCAL _cAno := Alltrim(str(YEAR(dDatabase)))
    LOCAL lMv_Logod := .T.
	cGrpCompany	:= AllTrim(FWGrpCompany())
	cCodEmpGrp	:= AllTrim(FWCodEmp())
	cUnitGrp	:= AllTrim(FWUnitBusiness())
	cFilGrp		:= AllTrim(FWFilial())

    cLogoD	:= GetSrvProfString("Startpath","") + "LGMID" + ".PNG"
	If !File(cLogoD)
		lMv_Logod := .F.
	EndIf
		
	dbSelectArea("SM0")
	dbSetOrder(1)
	If dbSeek(cEmpAnt + TRBACER->ZZM_FILIAL)
	   
	   IF lMv_Logod 
	        oPrn:SayBitmap(060,060,cLogoD,300,200)
       EndIF
	   oPrn:Say( 200, 1000,'Controle de Acertos', oFontN)  
	   oPrn:Say( 200, 2100,'Pag: '+_cPag, oFont3)  
       oPrn:Line (300,050,300,2200)  

		oPrn:Say( 340, 100,'Unidade: ' + TRBACER->ZZM_FILIAL + ' - ' + TRBACER->M0_FILIAL, oFont4)
		oPrn:Say( 385, 100,'Pecuarista: ' + TRBACER->A2_NOME, oFont4)
		oPrn:Say( 430, 100,"Comprador: " + TRBACER->M0_NOMECOM, oFont4)
	   
	   oPrn:Say( 350 , 1800,"Abate: "  + DTOC(STOD(TRBACER->ZZM_DTPROD)), oFont4)
	   oPrn:Say( 400 , 1800,"Pedido: " + Ret_Pedido() , oFont4)	   
	    IF bEmite
	   		oPrn:Say( 450 , 1800," N.F.E: " + TRBACER->ZZM_DOC+'-'+TRBACER->ZZM_SERIE, oFont4)
	    Else
	    	oPrn:Say( 450 , 1800," Vencimento: " + DTOC(STOD(TRBACER->ZZM_VENCE)), oFont4)
	    EndIF
        nCol  := 250                            
		oPrn:Box(500,nCol,580,nCol+1600)  
		oPrn:Line (500,nCol+200,580,nCol+200)  
		oPrn:Line (500,nCol+700,580,nCol+700)  
		oPrn:Line (500,nCol+0900,580,nCol+0900)  
		oPrn:Line (500,nCol+1100,580,nCol+1100)  
		oPrn:Line (500,nCol+1300,580,nCol+1300)  
	   _nLin := 565
	   
	   oPrn:Say( _nLin, nCol+10,"Tipo",         oFont5 )			
	   oPrn:Say( _nLin, nCol+210,"Boi/Vaca",     oFont5 )
	   oPrn:Say( _nLin, nCol+760,"Qtde",         oFont5 ) 
	   oPrn:Say( _nLin, nCol+930,"Kg",           oFont5 )			
	   oPrn:Say( _nLin, nCol+1110,"Valor @",      oFont5 )
	   oPrn:Say( _nLin, nCol+1310,"Valor Total",  oFont5 ) 
   
	   _nLin:=580
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpItens  ºAutor  ³ A.Carlos           º Data ³  10/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Itens			o 		             		          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Marfrig                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpItens()

Local _nBegin := 0
Local _nQtde  := ""
Local _nVezes := 0
Local _nOrdem := 0
Local nPadL   := 0 

TRBACER->(dbGotop())
While TRBACER->(!EOF())
	
	_nTotCab += IIF(TRBACER->ZZN_PRODUT > '500000',0,TRBACER->ZZN_QTCAB)
	_nTotKg  += IIF(TRBACER->ZZN_PRODUT > '500000',0,TRBACER->ZZN_QTKG)
	_nTotAr  += TRBACER->ZZN_VLARRO
	_nTotVl  += TRBACER->ZZN_VLTOT
	_nPesMed += TRBACER->ZZN_QTKG/TRBACER->ZZN_QTCAB
	nCont++

	_cQtCab := IIF(TRBACER->ZZN_PRODUT > '500000', '0',Alltrim(Str(TRBACER->ZZN_QTCAB)))
	_cQtKg  := IIF(TRBACER->ZZN_PRODUT > '500000', '0',Alltrim(TRANSFORM(TRBACER->ZZN_QTKG,PesqPict('ZZN','ZZN_QTKG'))))
	_cValAr := Alltrim(TRANSFORM(TRBACER->ZZN_VLARRO,PesqPict('ZZN','ZZN_VLARRO')))
	_cValTtl:= Alltrim(TRANSFORM(TRBACER->ZZN_VLTOT,PesqPict('ZZN','ZZN_VLTOT')))
	
	
	oPrn:Box(_nLin,nCol,_nLin+60,nCol+1600)
	oPrn:Line (_nLin,nCol+200,_nLin+60,nCol+200)
	oPrn:Line (_nLin,nCol+700,_nLin+60,nCol+700)
	oPrn:Line (_nLin,nCol+0900,_nLin+60,nCol+0900)
	oPrn:Line (_nLin,nCol+1100,_nLin+60,nCol+1100)
	oPrn:Line (_nLin,nCol+1300,_nLin+60,nCol+1300)
	
	_nLin+=035
	oPrn:Say( _nLin, nCol+10,Substr(TRBACER->ZZN_PRODUT,1,TAMSX3("ZZN_PRODUT")[1]), oFont3 )
	oPrn:Say( _nLin, nCol+210,Substr(GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+TRBACER->ZZN_PRODUT, 1, "" ),1,TAMSX3("B1_DESC")[1]), oFont3 )
	oPrn:Say( _nLin, nCol+805,_cQtCab , oFont3 )
	
	nPadL := Ret_Tam(_cQtKg,oFont3)
	oPrn:Say( _nLin,nCol+1100-nPadL,_cQtKg, oFont3 )
	
	nPadL := Ret_Tam(_cValAr,oFont3)
	oPrn:Say( _nLin,nCol+1300-nPadL,_cValAr, oFont3 )
	
	nPadL := Ret_Tam(_cValTtl,oFont3)
	oPrn:Say( _nLin,nCol+1500-nPadL,_cValTtl, oFont3 )
	
	_nLin+=025
	
	TRBACER->(DBSKIP())
Enddo


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpTot    ºAutor  ³ A.Carlos           º Data ³  12/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Totais                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Marfrig	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imptot()
Local cText := ''

_nLin+=035
oPrn:Say( _nLin, nCol+600,"Total: ", oFont3 )

cText := Alltrim(STR(_nTotCab))  
oPrn:Say( _nLin, nCol+805,cText , oFont3 )

cText := Alltrim(TRANSFORM(_nTotKg,PesqPict('ZZN','ZZN_QTKG')))  
nPadL := Ret_Tam(cText,oFont3)
oPrn:Say( _nLin,nCol+1100-nPadL,cText, oFont3 )

cText := Alltrim(TRANSFORM(_nTotVl,PesqPict('ZZN','ZZN_VLTOT')))  
nPadL := Ret_Tam(cText,oFont3)
oPrn:Say( _nLin,nCol+1500-nPadL,cText, oFont3 )

_nLin+=50
oPrn:Line (_nLin,050,_nLin,2200)                                  
cText := Alltrim(TRANSFORM(_nTotAr/nCont,PesqPict('ZZN','ZZN_VLTOT')))  
oPrn:Say( _nLin+30, 100,"@ Média: " + cText, oFont3 )

cText := Alltrim(TRANSFORM(_nPesMed/nCont,PesqPict('ZZN','ZZN_VLTOT')))  
oPrn:Say( _nLin+30, 800,"Peso Médio: " + cText, oFont3 )
_nLin+=050
oPrn:Line (_nLin,050,_nLin,2200)


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpFin    ºAutor  ³ A.Carlos           º Data ³  19/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Financeiro                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Marfrig	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpFin()            
Local cQuery   := ''                
Local cTexto   := ''
Local nFator   := _nTotVl / (_nTotAr/nCont)
Local nMarrAcr := 0
Local nICMS1   := 0 
Local nICMS2   := 0 
Local nICMS3   := 0
Local xFundP   := 0 


TRBACER->(dbGoTop())
xFundP   := xFUNDEPEC(TRBACER->F1_FILIAL,TRBACER->F1_DOC,TRBACER->F1_SERIE,TRBACER->F1_FORNECE,TRBACER->F1_LOJA)
_cVlAcr  := TRBACER->ZZM_VLACR
nMarrAcr := (_cVlAcr + _nTotVl)/nFator
_cDesc   := TRBACER->F1_CONTSOC + xFundP + TRBACER->F1_VALFUND + TRBACER->F1_VLSENAR
_cValBru := TRBACER->F1_VALBRUT 
_cICMSNP := TRBACER->ZZM_VLACR
_cDespec := TRBACER->ZZM_DESPEC
_cValLiq := TRBACER->F1_VALBRUT -  TRBACER->ZZM_DESPEC - _cDesc
_cOutAcr := TRBACER->F1_DESPESA
nICMS1   := TRBACER->ZZM_ICMSNP	
nICMS2   := TRBACER->F1_VALICM
nICMS3   := TRBACER->ZZM_ICMSFR


oPrn:Line (_nLin,0980,_nLin+270,0980)
oPrn:Line (_nLin,1680,_nLin+270,1680)
_nLin+=050

IMP_COL(01,01,'Acréscimo:'           ,_cVlAcr)
IMP_COL(02,01,'@ Média C/Acréscimo: ',nMarrAcr )
IMP_COL(03,01,'Outros Acréscimo: '   ,0 )
IMP_COL(04,01,'Quebras: '            ,0 )
IMP_COL(05,01,"Total: "              ,_nTotVl+_cVlAcr )
IMP_COL(01,02,'Desconto: '           ,_cDesc)
IMP_COL(02,02,'Sobra ICM: '          ,0)
IMP_COL(03,02,'Desconto Especial: '  ,_cDespec)
IMP_COL(04,02,'Outros Descontos: '   ,TRBACER->ZZM_VLDESC)
IMP_COL(01,03,'Valor Total NFE: '    ,_cValBru)
IMP_COL(02,03,'Valor Liquido Pagar: ',_cValLiq)


_nLin+=220
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=050

//Parcela valor vencimento
/*
cQuery := " Select * "
cQuery += " From  "+RetSqlName("SE2")
cQuery += " Where E2_FILIAL  = '"+TRBACER->ZZM_FILIAL+"'"
cQuery += "   AND E2_PREFIXO = '"+TRBACER->F1_PREFIXO+"'"
cQuery += "   AND E2_NUM     = '"+Alltrim(TRBACER->ZZM_DOC)+"'"
cQuery += "   AND E2_TIPO    = 'NF'"
cQuery += "   AND E2_FORNECE = '"+Alltrim(TRBACER->ZZM_FORNEC)+"'"
cQuery += "   AND E2_LOJA    = '"+TRBACER->ZZM_LOJA+"'"
*/
cQuery := " Select * "
cQuery += " From  "+RetSqlName("ZDH")
cQuery += " Where ZDH_FILIAL = '"+ZZM->ZZM_FILIAL + "' " +_cEnter                      
cQuery += "   AND ZDH_PEDIDO = '"+ZZM->ZZM_PEDIDO + "' " +_cEnter
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += "   ORDER BY ZDH_PARC "


If Select("QRY_SE2") > 0
	QRY_SE2->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCOtNN",TcGenQry(,,cQuery),"QRY_SE2",.T.,.F.)
dbSelectArea("QRY_SE2")
QRY_SE2->(dbGoTop())
While !QRY_SE2->(EOF()) 
    cTexto := 'Parcela Nº '+Alltrim(QRY_SE2->ZDH_PARC)
    oPrn:Say( _nLin, 600,cTexto,oFont3 )                           
    oPrn:Say( _nLin, 800,'Valor : '+Alltrim(TRANSFORM(QRY_SE2->ZDH_VALOR,PesqPict('SE2','E2_VALOR'))),oFont3 )
    oPrn:Say( _nLin, 1100,'Vencimento : '+DTOC(STOD(QRY_SE2->ZDH_DATA)),oFont3 )
	_nLin+=030
    QRY_SE2->(dbSkip())
EndDo       
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=050
IMP_COL(01,02,'ICMS Enviado:',nICMS1)
IMP_COL(02,02,'ICMS Gado:'   ,nICMS2)
IMP_COL(03,02,'ICMS Frete:'  ,nICMS3)
_nLin+=150
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=030
oPrn:Say( _nLin, 0100,'Observação: '+TRBACER->ZZM_OBS,oFont3 )
_nLin+=050
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=030
oPrn:Say( _nLin, 0100,'C/C: Banco:' +TRBACER->ZZM_BANCO+'      AG.: ' +TRBACER->ZZM_AGENCI+'     C.C: ' +TRBACER->ZZM_CONTA,oFont3 )
oPrn:Say( _nLin, 1900, DTOC(dDataBase)+' '+Time(),oFont3 )

Return

*************************************************************************************************
Static Function Ret_Tam(cTexto,oFontText)
//Local x := oPrn:nLogPixelx()
//Local y := oPrn:GetTextWidth(cTexto, oFontText ) * 0.3937 
Local nRet := 0//ROUND(y * x,0) 

nRet:= ROUND(oPrn:GetTextWidth(cTexto, oFontText )+10 ,0)

Return nRet
*****************************************************************************************************
Static Function IMP_COL(nL,nC,cTexto,nValor)
Local nLinha  := _nLin+((nL-1)*50) 
Local nColN := 0 
Local nColT := 0                               

IF nC == 1
    nColT := 100
	nColN := 600
ElseIF nC == 2
    nColT := 1000
	nColN := 1500
ElseIF nC == 3
    nColT := 1700
	nColN := 2150
EndIF           

oPrn:Say( nLinha , nColT,cTexto,oFont3 )

cText := Alltrim(TRANSFORM(nValor,PesqPict('ZZN','ZZN_VLTOT')))  
nPadL := Ret_Tam(cText,oFont3)
oPrn:Say( nLinha , nColN-nPadL,cText,oFont3 )


Return

************************************************************************************************************
Static Function Ret_Pedido() 

Local cPedido := ''
Local cQuery  := ''
                                                                      
IF SUBSTR(ZZM->ZZM_PEDIDO,1,1)  == 'T'
    cPedido := ZZM->ZZM_PEDIDO
ELSEIF SUBSTR(ZZM->ZZM_PEDIDO,1,1)  <> 'A'
    cPedido := SUBSTR(ZZM->ZZM_PEDIDO,1, AT('-',ZZM->ZZM_PEDIDO)-1)   
Else
	cQuery := " SELECT ZZM_PEDIDO  "
	cQuery += " FROM   "+RetSqlName("ZZM")
	cQuery += " Where ZZM_FILIAL = '"+ZZM->ZZM_FILIAL+"'"
	cQuery += "   AND ZZM_AGRUP  = '"+ZZM->ZZM_PEDIDO+"'"
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += "   Order by ZZM_PEDIDO "
	If Select("QRY_AGR") > 0
		QRY_AGR->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AGR",.T.,.F.)
	dbSelectArea("QRY_AGR")
	QRY_AGR->(dbGoTop())
	IF QRY_AGR->(!EOF())
	     cPedido := SUBSTR(QRY_AGR->ZZM_PEDIDO,1, AT('-',QRY_AGR->ZZM_PEDIDO)-1)
	End
	QRY_AGR->(dbCloseArea())
EndIF

Return cPedido

Static Function xFUNDEPEC(cxFil,cDoc,cSerie,cFornec,cLoja)
	
	Local aArea	:= GetArea()
	
	Local cNextAlias 	:= GetNextAlias()	
	Local nRet 	  := 0
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias	
		
	SELECT D1_VALIMPF
		FROM %Table:SD1% D1
    WHERE
	    D1.%NotDel% AND
	    D1.D1_FILIAL = %Exp:cxFil% AND
	    D1.D1_DOC = %Exp:cDoc% AND
	    D1.D1_SERIE = %Exp:cSerie% AND
	    D1.D1_FORNECE = %Exp:cFornec% AND
	    D1.D1_LOJA = %Exp:cLoja%
			
	EndSql

	(cNextAlias)->(dbGoTop())
	
	While (cNextAlias)->(!EOF())
		
		nRet += (cNextAlias)->D1_VALIMPF
		
		(cNextAlias)->(dbSkip())
	EndDo
	
	(cNextAlias)->(DbClosearea())	
	
	RestArea(aArea)
	
return nRet
******************************************************************************************************************************************************
Static Function ImpNotas()            
Local cQuery    := ''                
Local cTexto    := ''
Local nFator    := _nTotVl / (_nTotAr/nCont)
Local nMarrAcr  := 0
Local nICMS1    := 0 
Local nICMS2    := 0 
Local nICMS3    := 0
Local xFundP    := 0 
Local aZDU      := {}
Local nI        := 0 
Local nTotNF    := 0
Local nImpostos := 0
Local nGeral1   := 0 
Local nGeral2   := 0
Local nGeral3   := 0 
Local nGeral4   := 0
Local nNFPI     := 0
Local nNFP      := 0
Local cNotas    := ''
Local aNotas    := {} 

TRBACER->(dbGoTop())
//xFundP   := xFUNDEPEC(TRBACER->F1_FILIAL,TRBACER->F1_DOC,TRBACER->F1_SERIE,TRBACER->F1_FORNECE,TRBACER->F1_LOJA)

aNotas := Ret_Notas()
nNFP  := RetornaValor()
nNFPI := U_TAE15_IM()

_nLin+=050
oPrn:Say( _nLin, 100,'Notas do Produtor :',oFont4 )                           
_nLin+=030
cTexto := 'Doc./Série :'
oPrn:Say( _nLin, 600,cTexto,oFont3 )                        
For nI := 1 To Len(aNotas)  
	oPrn:Say( _nLin, 800,aNotas[nI],oFont3 )   
	_nLin+=030
Next nI   
oPrn:Say( _nLin, 600,'Total  : '+Alltrim(TRANSFORM(nNFP,PesqPict('SE2','E2_VALOR')))+' Impostos : '+Alltrim(TRANSFORM(nNFPI,PesqPict('SE2','E2_VALOR'))),oFont3 )
_nLin+=030
oPrn:Say( _nLin, 600,'Acrescimo  : '+Alltrim(TRANSFORM(ZZM->ZZM_VLACR,PesqPict('SE2','E2_VALOR')))+' Desconto : '+Alltrim(TRANSFORM(ZZM->ZZM_VLDESC,PesqPict('SE2','E2_VALOR'))),oFont3 )
_nLin+=030
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=050

nNFP := nNFP  - nNFPI //+ ZZM->ZZM_VLACR - ZZM->ZZM_VLDESC

cQuery := " Select * "
cQuery += " From  "+RetSqlName("ZDU")
cQuery += " Where ZDU_FILIAL = '"+ZZM->ZZM_FILIAL + "' " +_cEnter                      
cQuery += "   AND ZDU_PEDIDO = '"+ZZM->ZZM_PEDIDO + "' " +_cEnter
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += "   ORDER BY ZDU_TIPO,ZDU_DOC "
If Select("QRY_ZDU") > 0
	QRY_ZDU->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCOtNN",TcGenQry(,,cQuery),"QRY_ZDU",.T.,.F.)
dbSelectArea("QRY_ZDU")
QRY_ZDU->(dbGoTop())
While !QRY_ZDU->(EOF()) 
    AAdd(aZDU,{QRY_ZDU->ZDU_DOC,QRY_ZDU->ZDU_SERIE,QRY_ZDU->ZDU_TIPO}) 
    QRY_ZDU->(dbSkip())
EndDo                                   
oPrn:Say( _nLin, 100,'Notas Complementares : ',oFont4 )
_nLin+=050
For nI := 1 To Len(aZDU)
    IF aZDU[nI,03] == 'E'
	    IF SF1->(dbSeek(ZZM->ZZM_FILIAL+aZDU[nI,01]+aZDU[nI,02]+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
		    nFundec := xFUNDEPEC(SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
			nTotNF    := SF1->F1_VALBRUT 
			nImpostos := SF1->F1_CONTSOC + nFundec + SF1->F1_VALFUND + SF1->F1_VLSENAR//- SF1->F1_VALFUND Já descontado no Valor Bruto
		    nGeral1 += nTotNF
			nGeral2 += nImpostos
		    
		    cTexto := 'Doc./Série : '+Alltrim(aZDU[nI,01])+'/'+Alltrim(aZDU[nI,02])
		    oPrn:Say( _nLin, 600,cTexto,oFont3 )                           
		    oPrn:Say( _nLin, 1000,'Valor : '+Alltrim(TRANSFORM(nTotNF,PesqPict('SE2','E2_VALOR'))),oFont3 )
		    oPrn:Say( _nLin, 1600,'Impostos : '+Alltrim(TRANSFORM(nImpostos,PesqPict('SE2','E2_VALOR'))),oFont3 )
			_nLin+=030
		EndIF
	EndIF
Next nI
_nLin+=050
oPrn:Say( _nLin, 100,'Devoluções : ',oFont4 )
_nLin+=050
For nI := 1 To Len(aZDU)
    IF aZDU[nI,03] == 'S'
	    IF SF2->(dbSeek(ZZM->ZZM_FILIAL+aZDU[nI,01]+aZDU[nI,02]+Alltrim(ZZM->ZZM_FORNEC)+ZZM->ZZM_LOJA))
		    nTotNF    := SF2->F2_VALBRUT 
			nImpostos := SF2->F2_CONTSOC + SF2->F2_VLSENAR

		    nGeral3 += nTotNF
			nGeral4 += nImpostos

		    cTexto := 'Doc./Série : '+Alltrim(aZDU[nI,01])+'/'+Alltrim(aZDU[nI,02])
		    oPrn:Say( _nLin, 600,cTexto,oFont3 )                           
		    oPrn:Say( _nLin, 1000,'Valor : '+Alltrim(TRANSFORM(nTotNF,PesqPict('SE2','E2_VALOR'))),oFont3 )
		    oPrn:Say( _nLin, 1600,'Impostos : '+Alltrim(TRANSFORM(nImpostos,PesqPict('SE2','E2_VALOR'))),oFont3 )
			_nLin+=030
		EndIF
	EndIF
Next nI
_nLin+=030
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=030
oPrn:Say( _nLin, 600,'Total Geral : '+Alltrim(TRANSFORM(nNFP+nGeral1-nGeral2-nGeral3+nGeral4,PesqPict('SE2','E2_VALOR'))),oFont4 )
_nLin+=030
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=050
oPrn:Say( _nLin, 100,'Vencimentos :',oFont4 )                           
_nLin+=030


//Parcela valor vencimento
cQuery := " Select * "
cQuery += " From  "+RetSqlName("ZDH")
cQuery += " Where ZDH_FILIAL = '"+ZZM->ZZM_FILIAL + "' " +_cEnter                      
cQuery += "   AND ZDH_PEDIDO = '"+ZZM->ZZM_PEDIDO + "' " +_cEnter
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += "   ORDER BY ZDH_PARC "
If Select("QRY_SE2") > 0
	QRY_SE2->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCOtNN",TcGenQry(,,cQuery),"QRY_SE2",.T.,.F.)
dbSelectArea("QRY_SE2")
QRY_SE2->(dbGoTop())
While !QRY_SE2->(EOF()) 
    cTexto := 'Parcela Nº '+Alltrim(QRY_SE2->ZDH_PARC)
    oPrn:Say( _nLin, 600,cTexto,oFont3 )                           
    oPrn:Say( _nLin, 800,'Valor : '+Alltrim(TRANSFORM(QRY_SE2->ZDH_VALOR,PesqPict('SE2','E2_VALOR'))),oFont3 )
    oPrn:Say( _nLin, 1100,'Vencimento : '+DTOC(STOD(QRY_SE2->ZDH_DATA)),oFont3 )
	_nLin+=030
    QRY_SE2->(dbSkip())
EndDo       
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=030
oPrn:Say( _nLin, 0100,'Observação: '+TRBACER->ZZM_OBS,oFont3 )
_nLin+=050
oPrn:Line (_nLin,100,_nLin,2200)
_nLin+=030
oPrn:Say( _nLin, 0100,'C/C: Banco:' +TRBACER->ZZM_BANCO+'      AG.: ' +TRBACER->ZZM_AGENCI+'     C.C: ' +TRBACER->ZZM_CONTA,oFont3 )
oPrn:Say( _nLin, 1900, DTOC(dDataBase)+' '+Time(),oFont3 )

Return
************************************************************************************************************************************************************
Static Function RetornaValor()

Local cQuery  := ''
Local nVZZP   := 0      

cQuery := " SELECT SUM(ZZP_QTD *ZZP_VALOR) As VALOR_ZZP  "
cQuery += " FROM "+RetSQLName("ZZP") 
cQuery += " WHERE ZZP_FILIAL  = '" + ZZM->ZZM_FILIAL + "' " 
cQuery += "   AND ZZP_PEDIDO  = '" + ZZM->ZZM_PEDIDO + "' " 
cQuery += "   AND D_E_L_E_T_ = ' ' "
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
IF  !QRY_ZZP->(EOF()) 
   nVZZP   := QRY_ZZP->VALOR_ZZP
EndIF       
Return nVZZP
*********************************************************************************************************************************************
Static Function Ret_Notas

Local cQuery := ''            
Local bRet   := .T.
Local cNotas := ''  
Local nCont  := 0
Local aRet   := {}

cQuery := " SELECT ZZP_DOC, ZZP_SERIE"
cQuery += " FROM "+RetSQLName("ZZP") 
cQuery += " WHERE ZZP_FILIAL = '" + ZZM->ZZM_FILIAL + "' " 
cQuery += "   AND ZZP_PEDIDO = '" + ZZM->ZZM_PEDIDO + "' " 
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY ZZP_DOC"
If Select("QRY_ZZP") > 0
	QRY_ZZP->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZP",.T.,.F.)
dbSelectArea("QRY_ZZP")
QRY_ZZP->(dbGoTop())
While !QRY_ZZP->(EOF()) 
    cNotas += ' '+Alltrim(QRY_ZZP->ZZP_DOC)+'/'+Alltrim(QRY_ZZP->ZZP_SERIE)
    nCont++
    QRY_ZZP->(dbSkip())
    IF nCont == 7 .OR. QRY_ZZP->(EOF())
       AAdd(aRet,cNotas)
       nCont  := 0 
       cNotas := ''
    EndIF
EndDo       


Return aRet

