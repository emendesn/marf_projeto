#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH'                                        
/*
=====================================================================================
Programa.:              MGFINT50 - RELATORIO DE OUF
Autor....:              Antonio Carlos        
Data.....:              12/12/2017                                                                                                            
Descricao / Objetivo:   Relatório de Operações Mensais                           
Doc. Origem:            Contrato - GAP MGFINT50
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relatório de de Operações Mensais  
=====================================================================================
*/
User Function MGFINT50()
Local aRet		  := {}
Local aParambox	  := {}       

Private _cEnter := CHR(13)+Chr(10)
Private titulo  := "Relatorio de Operações Mensais "
Private cDesc1  := "Relatorio de Operações Mensais "
Private cDesc2  := " "
Private cDesc3  := " "
Private Cabec1  := " "
Private Cabec2  := " "
Private cQry    := " "
Private cString := "ZZM"
Private wnrel       := "RINT050"
Private nomeprog    := "RINT050"
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
Private _nQtdBoi := 0
Private _nTvalPB := 0
Private _nTvEPB  := 0
Private _nTvalPV := 0
Private _nQtdVac := 0
Private _nTvEPV  := 0
Private _cNComp  := SPACE(06) 
Private _cPerg   := "MGFI50"
Private _nQBoi   := 0
Private _nTvB    := 0
Private _nTICP   := 0
Private _nQVac   := 0
Private _nTvV    := 0
Private _nTICV   := 0
Private _nTtlVl  := 0
Private _cCodMac := Alltrim( SuperGetMV("MGF_CODBOI", ,"627233") )
Private _cCodFem := Alltrim( SuperGetMV("MGF_CODVAC", ,"627234") )
Private MV_PAR01 := SPACE(6)
Private MV_PAR02 := SPACE(2)
Private aDados   := {}
Private aRec     := {}     
Private nCont    := 0 


AAdd(aParamBox, {1, "Mês e Ano :"       ,Space(6)        , "@R 99/9999",           ,     ,, 070	, .T.	})
AAdd(aParamBox, {1, "Estado :"          ,Space(2)        , "@!"        ,           ,"12" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Filial :"         	,Space(tamSx3("A2_FILIAL")[1])             , "@!",                           ,"XM0" ,, 070	, .T.	})
IF ParamBox(aParambox, "Filtro para Selecionar as Notas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	
	IF !fVldMesAno(MV_PAR01, 1)
		MsgAlert('Mês/Ano Invalidos !!')
		Return
	EndIF
	IF !EMpty(MV_PAR02) .AND. !ExistCpo("SX5","12"+MV_PAR02)
		MsgAlert('Estado Invalido !!')
		Return
	EndIF
	
	if Select("TRBOUF") > 0
		TRBOUF->(DBCLOSEAREA())
	Endif
	
	cQry  := "SELECT A2_NOME,A2_INSCR,A2_MUN,A2_COD_MUN,F1_FILIAL,F1_DOC,D1_COD,D1_QUANT,F1_EMISSAO,F1_VALBRUT,F1_VALICM,F1_ZICMS,ZZM_EMISSA,ZZM_VICMS,ZZM_VNFP " +_cEnter
	cQry  += " FROM " + RetSqlName("SA2") + " c, " + RetSqlName("SD1") + " d, " + RetSqlName("SF1") + " b " +_cEnter
	cQry  += " INNER JOIN " + RetSqlName("ZZM") + " a "   +  "ON A.ZZM_DOC = F1_DOC AND A.ZZM_SERIE = B.F1_SERIE AND a.D_E_L_E_T_ = ' ' " +_cEnter
	cQry  += " AND A.ZZM_FORNEC = F1_FORNECE AND A.ZZM_LOJA = F1_LOJA " +_cEnter
	cQry  += " WHERE " +_cEnter
	cQry  += "   b.D_E_L_E_T_ = ' '  "               +_cEnter
	cQry  += "   AND c.D_E_L_E_T_ = ' ' "            +_cEnter
	cQry  += "   AND d.D_E_L_E_T_ = ' ' "            +_cEnter
	cQry  += "   AND ZZM_AGRUP    = ' ' "            +_cEnter
	cQry  += "   AND ZZM_DOC     <> ' ' "            +_cEnter
	cQry  += "   AND D1_FILIAL    = F1_FILIAL "      +_cEnter
	cQry  += "   AND D1_DOC       = F1_DOC "         +_cEnter
	cQry  += "   AND D1_SERIE     = F1_SERIE "       +_cEnter
	cQry  += "   AND D1_FORNECE   = F1_FORNECE "     +_cEnter
	cQry  += "   AND D1_LOJA      = F1_LOJA "        +_cEnter
	cQry  += "   AND A2_FILIAL    = '" + xFilial('SA2') + "' " +_cEnter
	cQry  += "   AND ZZM_FORNEC   = A2_COD "         +_cEnter
	cQry  += "   AND ZZM_LOJA     = A2_LOJA "        +_cEnter
	cQry  += "   AND ZZM_FILIAL   = '" + MV_PAR03 + "' " +_cEnter
	cQry  += "   AND SUBSTR(F1_EMISSAO,5,2) = '" + SUBSTR(MV_PAR01,1,2)+"'"
	cQry  += "   AND SUBSTR(F1_EMISSAO,1,4) = '" + SUBSTR(MV_PAR01,3,4)+"'"
	cQry  += "   AND F1_ZICMS    > 0 "                  +_cEnter
	cQry  += "   AND F1_VALICM - F1_ZICMS    > 0 "       +_cEnter
	IF !EMpty(MV_PAR02)
		cQry  += "   AND A2_EST      = '"   + MV_PAR02 + "'" +_cEnter
	EndIF
	cQry  += "   ORDER BY F1_DOC "                  +_cEnter

	cQry  := ChangeQuery(cQry)
	
	MemoWrite("C:\TEMP\IMP050.SQL",cQry)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBOUF",.F.,.t.)
	
	TRBOUF->(DBGOTOP())
	IF TRBOUF->(EOF())
		Aviso("Aviso","Não há dados a serem impressos  !!!",{"Ok"})
		Return
	ENDIF
	While TRBOUF->(!EOF())
		aRec     := {}
		nPos := AScan( aDados, { |x| x[4] == TRBOUF->F1_DOC })   
		IF nPos <> 0 
		    IF Alltrim(TRBOUF->D1_COD) == Alltrim(_cCodFem )
			    aDados[nPos,12] += TRBOUF->D1_QUANT
			ElseIF Alltrim(TRBOUF->D1_COD) == Alltrim(_cCodMac)
				aDados[nPos,05] += TRBOUF->D1_QUANT
			EndIF     
		Else
		    nCont += 1
			AAdd(aRec,nCont)             //1
			AAdd(aRec,TRBOUF->A2_NOME)   //2
			AAdd(aRec,TRBOUF->A2_INSCR)  //3
			AAdd(aRec,TRBOUF->F1_DOC)   //4
			IF Alltrim(TRBOUF->D1_COD) == Alltrim(_cCodMac)
				AAdd(aRec,TRBOUF->D1_QUANT) //5
			Else 
				AAdd(aRec,0)
			EndIF
			AAdd(aRec,TRBOUF->F1_VALBRUT) //6
			AAdd(aRec,TRBOUF->ZZM_EMISSA)  //7
			AAdd(aRec,TRBOUF->ZZM_VNFP) //8
			AAdd(aRec,TRBOUF->F1_VALICM-TRBOUF->F1_ZICMS) //9
			AAdd(aRec,TRBOUF->A2_MUN) //10    
			AAdd(aRec,TRBOUF->F1_EMISSAO)  //11
			IF Alltrim(TRBOUF->D1_COD) == Alltrim(_cCodFem ) 
				AAdd(aRec,TRBOUF->D1_QUANT) //12
			Else 
				AAdd(aRec,0)
			EndIF                 
            AAdd(aRec,TRBOUF->F1_VALICM)   //13
			AAdd(aRec,TRBOUF->F1_ZICMS) // 14            
			AAdd(aDados,aRec)
		EndIF
		TRBOUF->(DBSKIP())
	Enddo
	TRBOUF->(dbGotop())
	
	
	
	Processa({|| ImpRel()},,"Imprimindo...")
	TRBOUF->(dbCloseArea())
EndIF
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPREL    ºAutor  ³ A.Carlos     o     º Data ³  12/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Operações Mensais             		          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Marfrig	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRel()

Local cQry := ""

Private oFontC1:= TFont():New( "Arial",16,16,,.F.,,,,.T.,.F. )
Private oFont1:= TFont():New( "Arial",12,12,,.F.,,,,.T.,.F. )
//Private oFont1:= TFont():New( "Arial",15,15,,.F.,,,,.T.,.F. )
Private oFontN:= TFont():New( "Arial",19,19,,.T.,,,,.T.,.F. )
Private oFontL:= TFont():New( "Arial",13,13,,.F.,,,,.T.,.F. )
//Private oFont3:= TFont():New( "Arial",8,8,,.F.,,,,.T.,.F. )
Private oFont3:= TFont():New( "Arial",10,10,,.F.,,,,.T.,.F. )
Private oFont4:= TFont():New( "Arial",12,12,,.T.,,,,.T.,.F. )
Private oFont5:= TFont():New( "Arial",18,18,,.T.,,,,.T.,.F. )
Private oFont6:= TFont():New( "Arial",22,22,,.T.,,,,.T.,.F. )
Private oFont7:= TFont():New( "Arial",14,14,,.T.,,,,.T.,.F. )
Private oFont8:= TFont():New( "Arial",16,16,,.T.,,,,.T.,.F. )

Private oPrn
Private _nPag := 0 
Private _nLin := 150
Private cFilBk := cFilAnt
Private nTotal01 :=0 
Private nTotal02 :=0 
Private nTotal03 :=0 
Private nTotal04 :=0 
Private nTotal05 :=0 
Private nTotal06 :=0 
Private nTotal07 :=0 



cFilAnt:= MV_PAR03

oPrn:=FWMSPrinter():New(alltrim(TRBOUF->F1_DOC),6,,,.T.,) //imprime direto em PDF e inibi a tela de setup
oPrn:SetPortrait()
//oPrn:SetLandScape()
oPrn:StartPage()


_nPag++
CabecMarf(_nPag,_nPag,"P")

ImpItens()

If  _nLin > 2300
	oPrn:EndPage()
	oPrn:StartPage()
	_nLin := 0200
EndIf

//oPrn:EndPage()
//oPrn:End()
oPrn:Preview()


cFilAnt := cFilBk 

Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabecMarf ºAutor  ³ A.Carlos           º Data ³  12/12/17   º±±
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
    //LOCAL _cAno := Alltrim(str(YEAR(MV_PAR02)))
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
	If dbSeek(cEmpAnt + TRBOUF->F1_FILIAL)
	   oPrn:SayBitmap(_nLin,0100,cLogoD,400,140)
       _nLin+=020
	   oPrn:Say( _nLin, 1000,'Relatório OUF ---> Mensal', oFontN)  
	   oPrn:Say( _nLin, 2100,'Fls. '+_cPag, oFont3)  
	   _nLin+=100                        
	   _cMesEmi := MesExtenso(VAL(Substr(MV_PAR01,1,2)))+"/"+Substr(MV_PAR01,3,4)
	   oPrn:Say( _nLin, 1000,'Período: '+_cMesEmi+IIF(!EMPTY(MV_PAR02),'   Estado: '+MV_PAR02," "),oFontN)
       _nLin+=020	                           
       oPrn:Line (_nLin,100,_nLin,2800)  
       _nLin+=050        
	   oPrn:Say( _nLin, 0600,SM0->M0_CODIGO+"-"+SM0->M0_NOMECOM+SPACE(10)+ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB+SPACE(30)+SM0->M0_CGC+SPACE(30)+"IE: "+SM0->M0_INSC, oFont3 )	
       _nLin+=020      
       oPrn:Line (_nLin,100,_nLin,2800)
	   _nLin+=050
	   oPrn:Say( _nLin, 0200,"IDENTIFICAÇÃO DO CONTRIBUINTE"+SPACE(30)+"DOCUMENTO DESTINATÁRIO"+SPACE(40)+"DOCUMENTO EMITENTE", oFont3 ) 
	   _nLin+=050	   		   
       oPrn:Line (_nLin,100,_nLin,2800)
	   _nLin+=050
	   oPrn:Say( _nLin, 0100,"N   ", oFont3 )			
	   oPrn:Say( _nLin, 0150,"| Nome", oFont3 )
	   oPrn:Say( _nLin, 0550,"Inscrição ", oFont3 ) 
	   oPrn:Say( _nLin, 0750,"| N NFE", oFont3 )			
	   oPrn:Say( _nLin, 0905,"N Boi", oFont3 )
	   oPrn:Say( _nLin, 1050,"Valor Pago", oFont3 ) 
	   oPrn:Say( _nLin, 1300,"| Emissão", oFont3 )			
	   oPrn:Say( _nLin, 1600,"Valor Pago", oFont3 )  
	   oPrn:Say( _nLin, 1900,"| ", oFont3 )	   
	   oPrn:Say( _nLin, 1950,"Diferença", oFont3 ) 
	   _nLin+=030
	   oPrn:Say( _nLin, 0100,"Od. ", oFont3 )			
	   oPrn:Say( _nLin, 0150,"| Município", oFont3 )
	   oPrn:Say( _nLin, 0550,"Estadual", oFont3 ) 
	   oPrn:Say( _nLin, 0750,"| Data", oFont3 )			
	   oPrn:Say( _nLin, 0905,"N Vaca", oFont3 )
	   oPrn:Say( _nLin, 1050,"ICMS DEVIDO", oFont3 ) 
	   oPrn:Say( _nLin, 1300,"| ", oFont3 )			
	   oPrn:Say( _nLin, 1600,"ICMS RECOLHIDO", oFont3 )
	   oPrn:Say( _nLin, 1900,"| ", oFont3 )	  
	   oPrn:Say( _nLin, 1950,"a recolher", oFont3 )	    
	   _nLin+=020
       oPrn:Line (_nLin,100,_nLin,2800)  
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
Local nVal1    := 0 
Local nVal2    := 0 
local nI       := 0 



        
For nI := 1 To Len(aDados)
	
	nTotal01 += aDados[nI,05]
	nTotal02 += aDados[nI,06]
	nTotal03 += aDados[nI,08]
	nTotal04 += aDados[nI,12]
	nTotal05 += aDados[nI,13]
	nTotal06 += aDados[nI,14]
	nTotal07 += aDados[nI,09]
	
	
	_nLin+=050
	oPrn:Say( _nLin, 0100,cValToCHar(aDados[nI,01]), oFont3 )
	oPrn:Say( _nLin, 0145,"|",     oFont3 )
	oPrn:Say( _nLin, 0155,Substr(aDados[nI,02],1,24), oFont3 )
	oPrn:Say( _nLin, 0550,Substr(aDados[nI,03],1,18), oFont3 )
	oPrn:Say( _nLin, 0750,"|",     oFont3 )
	oPrn:Say( _nLin, 0755,Substr(aDados[nI,04],1,9), oFont3 )
	oPrn:Say( _nLin, 0950,cValToCHar(aDados[nI,05]),  oFont3 )    //_cBoi
	oPrn:Say( _nLin, 1100,cValToCHar(aDados[nI,06]),  oFont3 )
	oPrn:Say( _nLin, 1290,"|",     oFont3 )
	oPrn:Say( _nLin, 1300,DTOC(STOD(aDados[nI,07])),  oFont3 )
	oPrn:Say( _nLin, 1700,cValToCHar(aDados[nI,08]),oFont3 )     //_cICMSE  //_cValRec
	oPrn:Say( _nLin, 1895,"|",     oFont3 )
	oPrn:Say( _nLin, 1950,cValToCHar(aDados[nI,09]),  oFont3 )
	_nLin+=050
	oPrn:Say( _nLin, 0145,"|",     oFont3 )
	oPrn:Say( _nLin, 0155,aDados[nI,10], oFont3 )
	oPrn:Say( _nLin, 0750,"|",     oFont3 )
	oPrn:Say( _nLin, 0760,DTOC(STOD(aDados[nI,11])), oFont3 )
	oPrn:Say( _nLin, 0950,cValToCHar(aDados[nI,12]), oFont3 )     //_cVaca
	oPrn:Say( _nLin, 1100,cValToCHar(aDados[nI,13]),  oFont3 )
	oPrn:Say( _nLin, 1290,"|",     oFont3 )
	oPrn:Say( _nLin, 1700,cValToCHar(aDados[nI,14]), oFont3 )
	oPrn:Say( _nLin, 1895,"|",     oFont3 )
	_nVezes++
     If _nVezes == 24
          _nVezes := 1
          oPrn:EndPage()
          oPrn:StartPage()
          _nPag++
          _nLin := 150
          CabecMarf(_nPag,_nPag,"P")
     ENDIF
      
	
Next nI

Imptot()  //Rotina de impressao dos totais

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

     
	_nLin+=050                        
    oPrn:Line (_nLin,100,_nLin,2800)  
	_nLin+=050
	oPrn:Say( _nLin, 0900,cValToCHar(nTotal01)  ,oFont3 )       
	oPrn:Say( _nLin, 1100,cValToCHar(nTotal02),oFont3 )
	oPrn:Say( _nLin, 1700,cValToCHar(nTotal03) ,oFont3 )
	_nLin+=050      		    
	oPrn:Say( _nLin, 0900,cValToCHar(nTotal04), oFont3 )
	oPrn:Say( _nLin, 1100,cValToCHar(nTotal05),oFont3 ) 
	oPrn:Say( _nLin, 1700,cValToCHar(nTotal06), oFont3 )
	oPrn:Say( _nLin, 1950,cValToCHar(nTotal07), oFont3 )	 
    _nLin+=150

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Eugenio Arcanjo     º Data ³  30/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria as perguntas do programa no dicionario de perguntas    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg( _cPerg )
	Local _nLaco := 0
	Local aArea  := GetArea()
	Local aPerg  := {}

	aAdd(aPerg,{_cPerg,"01","Emissão De ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"02","Emissão Até ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"03","Código Cidade ?","mv_ch3","C",06,0,1,"G","","mv_par03","","","","","","","","","","","","","","","CC2",})
		
	DbSelectArea("SX1")	
    DbSetOrder(1)                            
	For _nLaco:=1 to LEN(aPerg)                                   
		If !dbSeek(PADR(aPerg[_nLaco,1],10)+aPerg[_nLaco,2])
	    	RecLock("SX1",.T.)
				SX1->X1_Grupo     := aPerg[_nLaco,01]
				SX1->X1_Ordem     := aPerg[_nLaco,02]
				SX1->X1_Pergunt   := aPerg[_nLaco,03]
				SX1->X1_PerSpa    := aPerg[_nLaco,03]
				SX1->X1_PerEng    := aPerg[_nLaco,03]				
				SX1->X1_Variavl   := aPerg[_nLaco,04]
				SX1->X1_Tipo      := aPerg[_nLaco,05]
				SX1->X1_Tamanho   := aPerg[_nLaco,06]
				SX1->X1_Decimal   := aPerg[_nLaco,07]
				SX1->X1_Presel    := aPerg[_nLaco,08]
				SX1->X1_Gsc       := aPerg[_nLaco,09]
				SX1->X1_Valid     := aPerg[_nLaco,10]
				SX1->X1_Var01     := aPerg[_nLaco,11]
				SX1->X1_Def01     := aPerg[_nLaco,12]
				SX1->X1_Cnt01     := aPerg[_nLaco,13]
				SX1->X1_Var02     := aPerg[_nLaco,14]
				SX1->X1_Def02     := aPerg[_nLaco,15]
				SX1->X1_Cnt02     := aPerg[_nLaco,16]
				SX1->X1_Var03     := aPerg[_nLaco,17]
				SX1->X1_Def03     := aPerg[_nLaco,18]
				SX1->X1_Cnt03     := aPerg[_nLaco,19]
				SX1->X1_Var04     := aPerg[_nLaco,20]
				SX1->X1_Def04     := aPerg[_nLaco,21]
				SX1->X1_Cnt04     := aPerg[_nLaco,22]
				SX1->X1_Var05     := aPerg[_nLaco,23]
				SX1->X1_Def05     := aPerg[_nLaco,24]
				SX1->X1_Cnt05     := aPerg[_nLaco,25]
				SX1->X1_F3        := aPerg[_nLaco,26]
			MsUnLock()
		EndIf
	Next
	RestArea( aArea )
Return