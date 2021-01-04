#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH'                                        
/*
=====================================================================================
Programa.:              MGFEST22 - RELATORIO AR
Autor....:              Antonio Carlos        
Data.....:              09/11/2016                                                                                                            
Descricao / Objetivo:   Relatorio de Aviso de Recebimento                        
Doc. Origem:            Contrato - GAP MGFEST07
Solicitante:            Cliente
Uso......:              
Obs......:              Relatorio de Aviso de Recebimento Especifico
=====================================================================================
*/

User Function MGFEST22()

Private titulo  := "Relatorio de Aviso de Recebimento"
Private cDesc1  := "Relatorio de Aviso de Recebimento"
Private cDesc2  := ""
Private cDesc3  := ""
Private Cabec1  := " "
Private Cabec2  := ""
Private cQry    := ""
Private cString := "ZZH"
Private wnrel       := "RCOM001"
Private nomeprog    := "RCOM001"
Private cArqTmp     := ""
Private nLastKey    := 0
Private aDadosR     := {}
Private cMvpar	    := ""
Private tamanho     := "G"
Private lAbortPrint := .F.
Private _lTemDados  := .T.
Private lFirst 		:= .T.
Private oReport
Private oSection1
Private _nTQTD := 0
Private _nTPCU := 0
Private _nTPCT := 0
Private _cNComp  := SPACE(06) 
Private _cPerg   := "MGFE22"
/*Private mv_par01 := dDataBase
Private mv_par02 := dDataBase
Private mv_par03 := " "
Private mv_par04 := " "
Private mv_par05 := " "
Private mv_par06 := " "
  
ValidPerg(_cPerg)

if !Pergunte(_cPerg,.T.)
	Return
endif
  */
// adiciona zeros antes do numero do documento
//mv_par05 := Repl("0",TamSX3("F1_DOC")[1]-Len(Alltrim(mv_par05)))+mv_par05
//mv_par07 := Repl("0",TamSX3("F1_DOC")[1]-Len(Alltrim(mv_par07)))+mv_par07

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

if Select("TRBAR") > 0
	TRBAR->(DBCLOSEAREA())
Endif                                                  
cQry  := "SELECT * " +CHR(10)
cQry += "FROM "+RetSqlName("SF1") + " SF1 " +CHR(10)
cQry += "JOIN "+RetSqlName("SD1") + " SD1 " +CHR(10)
cQry += "ON D1_FILIAL = F1_FILIAL " +CHR(10)
cQry += "AND D1_DOC = F1_DOC " +CHR(10)
cQry += "AND D1_SERIE = F1_SERIE " +CHR(10)
cQry += "AND D1_FORNECE = F1_FORNECE " +CHR(10)
cQry += "AND D1_LOJA = F1_LOJA " +CHR(10)
cQry += "AND SD1.D_E_L_E_T_= ' ' " +CHR(10)
cQry += "LEFT JOIN "+RetSqlName("SC7") + " SC7 " +CHR(10)                                           
cQry += "ON D1_FILIAL = C7_FILIAL " +CHR(10)
cQry += "AND D1_PEDIDO = C7_NUM " +CHR(10)
cQry += "AND D1_ITEMPC = C7_ITEM " +CHR(10)
cQry += "AND D1_FORNECE = C7_FORNECE " +CHR(10)
cQry += "AND D1_LOJA = C7_LOJA " +CHR(10)
cQry += "AND SC7.D_E_L_E_T_= ' ' " +CHR(10) 
cQry += "JOIN "+RetSqlName("SB1") + " SB1 " +CHR(10)                                           
cQry += "ON B1_FILIAL = '" +xFilial("SB1") +"' " +CHR(10)
cQry += "AND D1_COD = B1_COD " +CHR(10)
cQry += "AND SB1.D_E_L_E_T_= ' ' " +CHR(10) 
cQry += "LEFT JOIN "+RetSqlName("SB5") + " SB5 " +CHR(10)                                           
cQry += "ON B5_FILIAL = '" +xFilial("SB5") +"' " +CHR(10)
cQry += "AND D1_COD = B5_COD " +CHR(10)
cQry += "AND SB5.D_E_L_E_T_= ' ' " +CHR(10) 
cQry += "JOIN "+RetSqlName("SA2") + " SA2 " +CHR(10)                                           
cQry += "ON A2_FILIAL = '" + xFilial("SA2") + "' " +CHR(10)
cQry += "AND F1_FORNECE = A2_COD " +CHR(10)
cQry += "AND F1_LOJA = A2_LOJA " +CHR(10)
cQry += "AND SA2.D_E_L_E_T_= ' ' " +CHR(10)  
cQry += "LEFT JOIN "+RetSqlName("SA4") + " SA4 " +CHR(10)                                           
cQry += "ON A4_FILIAL = '" + xFilial("SA4") + "' " +CHR(10)
cQry += "AND F1_TRANSP = A4_COD " +CHR(10)
cQry += "AND SA4.D_E_L_E_T_= ' ' " +CHR(10) 
cQry += "WHERE " +CHR(10) 
cQry += "SF1.D_E_L_E_T_= ' ' " +CHR(10)    
//cQry += "AND F1_DTDIGIT >= '" +DTOS(MV_PAR01) + "'" +CHR(10)
//cQry += "AND F1_DTDIGIT <= '" +DTOS(MV_PAR02) + "'" +CHR(10)
//cQry += "AND F1_TRANSP >= '" +MV_PAR03 + "'" +CHR(10)
//cQry += "AND F1_TRANSP <= '" +MV_PAR04 + "'" +CHR(10)
//cQry += "AND F1_DOC >= '" +MV_PAR05 + "'" +CHR(10)
//cQry += "AND F1_DOC <= '" +MV_PAR07 + "'" +CHR(10)
//cQry += "AND F1_SERIE >= '" +MV_PAR06 + "'" +CHR(10)
//cQry += "AND F1_SERIE <= '" +MV_PAR08 + "'" +CHR(10)
//cQry += "AND F1_FORNECE >= '" +MV_PAR09 + "'" +CHR(10)
//cQry += "AND F1_LOJA >= '" +MV_PAR10 + "'" +CHR(10)
//cQry += "AND F1_FORNECE <= '" +MV_PAR11 + "'" +CHR(10)
//cQry += "AND F1_LOJA <= '" +MV_PAR12 + "'" +CHR(10)
//cQry += "AND F1_FILIAL = '" + XFILIAL("SF1") + "'" 
cQry += "AND F1_FILIAL   = '" +SF1->F1_FILIAL  + "'" 
cQry += "AND F1_DOC      = '" +SF1->F1_DOC     + "'" +CHR(10)
cQry += "AND F1_SERIE    = '" +SF1->F1_SERIE   + "'" +CHR(10)
cQry += "AND F1_FORNECE  = '" +SF1->F1_FORNECE + "'" +CHR(10)
cQry += "AND F1_LOJA     = '" +SF1->F1_LOJA    + "'" +CHR(10)
cQry += "AND F1_TIPO NOT IN ('D','B') "
cQry += " ORDER BY D1_ITEM "
//cQry += "AND F1_STATUS = ' ' " // somente pre-nota 

cQry  := ChangeQuery(cQry)
//MemoWrite("C:\TEMP\EST007.SQL",cQry) 
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBAR",.F.,.t.)

Processa({|| ImpRel()},,"Imprimindo...")

TRBAR->(dbCloseArea())
Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPREL    �Autor  � A.Carlos     o     � Data �  09/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de pedido de compra             		          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpRel()

Local cQry      := ""

Private oFontC1:= TFont():New( "Arial",16,16,,.F.,,,,.T.,.F. )
Private oFont1:= TFont():New( "Arial",12,12,,.F.,,,,.T.,.F. )
Private oFontN:= TFont():New( "Arial",19,19,,.T.,,,,.T.,.F. )
Private oFontL:= TFont():New( "Arial",13,13,,.F.,,,,.T.,.F. )
Private oFont3:= TFont():New( "Arial",10,10,,.F.,,,,.T.,.F. )
Private oFont4:= TFont():New( "Arial",12,12,,.T.,,,,.T.,.F. )
Private oFont5:= TFont():New( "Arial",18,18,,.T.,,,,.T.,.F. )
Private oFont6:= TFont():New( "Arial",22,22,,.T.,,,,.T.,.F. )
Private oFont7:= TFont():New( "Arial",14,14,,.T.,,,,.T.,.F. )
Private oFont8:= TFont():New( "Arial",16,16,,.T.,,,,.T.,.F. )
Private oFonte01  := TFont():New('Courier New',,12,,.T.,,,,,.F.,.F.) 
Private oFonte02  := TFont():New('Courier New',,11,,.T.,,,,,.F.,.F.) 
//Private oFonte03  := TFont():New('Courier New',,09,,.F.,,,,,.F.,.F.) 


Private _dEntrega:= ""
Private _nSaldo  := 0
Private _nPag    := 0
Private _nTotPg  := 3

Private oPrn
Private _nLin:=150

oPrn:=FWMSPrinter():New(alltrim(TRBAR->F1_DOC),6,,,.T.,) //imprime direto em PDF e inibi a tela de setup
oPrn:SetPortrait()
//oPrn:SetLandScape()
oPrn:StartPage()

TRBAR->(DBGOTOP())
IF TRBAR->(EOF())
	Aviso("Aviso","Nao h� dados a serem impressos  !!!",{"Ok"})
   Return
ENDIF


ImpItens("P")


//oPrn:EndPage()
//oPrn:End()
oPrn:Preview()

Return        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CabecMarf �Autor  � A.Carlos           � Data �  09/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cabeaalho do relatorio 		             		          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CabecMarf(_nPag,_nTotpg,_cTipo)
	
cGrpCompany	:= AllTrim(FWGrpCompany())
cCodEmpGrp	:= AllTrim(FWCodEmp())
cUnitGrp	:= AllTrim(FWUnitBusiness())
cFilGrp		:= AllTrim(FWFilial())

cLogoD	:= GetSrvProfString("Startpath","") + "LGMID" + ".PNG"
If !File(cLogoD)
	lMv_Logod := .F.
EndIf
oPrn:SayBitmap(050,0100,cLogoD,300,200)
	
dbSelectArea("SM0")
dbSetOrder(1)
If dbSeek(cEmpAnt + TRBAR->F1_FILIAL)
	oPrn:Say( _nLin, 0500,"Cod.Empresa/Filial: "+Alltrim(SM0->M0_CODIGO)+" / "+Alltrim(SM0->M0_CODFIL)+"  -  "+Alltrim(SM0->M0_NOMECOM), oFontN )
	//	   _cMesEmi := Substr(MesExtenso(Month(StoD(TRBPC->EMISSAO))),1,3) //CMonth(StoD(TRBPC->EMISSAO))
	_nLin+=100
	oPrn:Line (_nLin,100,_nLin,2300)
	_nLin+=075
	oPrn:Say( _nLin, 0300,'Num. DOC: '+ALLTRIM(TRBAR->F1_DOC))
	_nLin+=050
	oPrn:Line (_nLin,100,_nLin,2300)
	_nLin+=050
	oPrn:Say( _nLin, 0300,'Num. NF: '+ALLTRIM(TRBAR->F1_DOC)+"       Serie: "+ALLTRIM(TRBAR->F1_SERIE) , oFontC1 )
	_nLin+=050
	oPrn:Say( _nLin, 0300,'Data Emissao: '+Substr(TRBAR->F1_EMISSAO,7,2)+"/"+Substr(TRBAR->F1_EMISSAO,5,2)+"/"+Substr(TRBAR->F1_EMISSAO,1,4) , oFontC1 )
	oPrn:Say( _nLin, 1500,'Data Recebto: '+Substr(TRBAR->F1_DTDIGIT,7,2)+"/"+Substr(TRBAR->F1_DTDIGIT,5,2)+"/"+Substr(TRBAR->F1_DTDIGIT,1,4) , oFontC1 )
	oPrn:Say( _nLin, 2000,'Pag: '+Alltrim(Str(_nPag)) , oFontC1 )
	_nLin+=050
	oPrn:Say( _nLin, 0300,"Fornecedor: "+TRBAR->A2_COD+"/"+TRBAR->A2_LOJA+" "+TRBAR->A2_NOME, oFont3 )
	oPrn:Say( _nLin, 1500,"CNPJ: "+Transform(TRBAR->A2_CGC,PesqPict("SA2","A2_CGC")), oFont3 )
	_nLin+=050
	oPrn:Say( _nLin, 0300,"Transportador: "+TRBAR->F1_TRANSP+'  '+TRBAR->A4_NOME, oFont3 )
	oPrn:Say( _nLin, 1500,"CNPJ: "+Transform(TRBAR->A4_CGC,PesqPict("SA4","A4_CGC")) , oFont3 )
	//oPrn:Say( _nLin, 2000,"Conhecimento: "+TRBAR->DB1_ZCONHE , oFont3 ) //+"   Serie: "
	_nLin+=050
	oPrn:Say( _nLin, 0300,"Usuario: "+ __cUserId + ' ' + cUserName , oFont3 )
	oPrn:Say( _nLin, 1500,'Data Inclusao: '+Substr(TRBAR->F1_DTDIGIT,7,2)+"/"+Substr(TRBAR->F1_DTDIGIT,5,2)+"/"+Substr(TRBAR->F1_DTDIGIT,1,4) , oFont3 )
	//oPrn:Say( _nLin, 2000,"Val.Total: "+Transform(TRBAR->F1_VALBRUT, "@E 99,999,999,999.99" ) , oFont3 )
	_nLin+=050
	oPrn:Line (_nLin,100,_nLin,2300)
	_nLin+=050
	oPrn:Say( _nLin, 0100,"Seq."  ,oFonte01)
	oPrn:Say( _nLin, 0180,"Pedido",oFonte01)
	oPrn:Say( _nLin, 0300,"S.C."  ,oFonte01)
	oPrn:Say( _nLin, 0520,"Cod. Item"  ,oFonte01)
	oPrn:Say( _nLin, 2000,"UM"      ,oFonte01) //1350
	oPrn:Say( _nLin, 2100,"Tipo",oFonte01)     //1440     
	//oPrn:Say( _nLin, 1480,"Entrega" ,oFonte01)
	//oPrn:Say( _nLin, 1670,"Marca" ,oFonte01)
	//oPrn:Say( _nLin, 2000,"Lote" ,oFonte01)
	//oPrn:Say( _nLin, 2150,"Validade" ,oFonte01)
	_nLin+=050
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpItens  �Autor  � A.Carlos           � Data �  10/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime Itens			o 		             		          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpItens(_cTipo)

Local _nBegin := 0
Local _cDoc   := ""
Local _cSerie := ""
Local _nQtde  := ""
Local _nVezes := 0
Local cLote   := ""

TRBAR->(dbGotop())
While TRBAR->(!EOF())
        cQry1 := " SELECT Y1.Y1_NOME COMPRADOR " +CHR(10)
        cQry1 += " FROM "+RetSqlName("SY1")+" Y1 " +CHR(10)
        cQry1 += " WHERE Y1.D_E_L_E_T_= ' ' " +CHR(10)
        cQry1 += " AND Y1.Y1_COD = '"+TRBAR->C7_COMPRA+"'" +CHR(10)

        cQry1 := ChangeQuery(cQry1)

        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry1),"TRBCOMP",.F.,.t.)

        While TRBCOMP->(!EOF())
	       _cNComp := TRBCOMP->COMPRADOR
           TRBCOMP->(Dbskip())
        Enddo        
        DbCloseArea()
        FErase("TRBCOMP"+GetDBExtension()) 
        _nVezes++   
        IF _nVezes == 1  .Or. _nLin >= 2800
           IF _nVezes <> 1
           		oPrn:EndPage()
           		oPrn:StartPage()
           EndIF
           _nVezes  := 1    
           _nPag++  
           _nLin   := 150
           CabecMarf(_nPag,_nPag,"P")
        EndIF
        
//      _nQtde := Str(TRBAR->DB3_QUANT) 
		oPrn:Say( _nLin, 0100,TRBAR->D1_ITEM,oFonte02)
		oPrn:Say( _nLin, 0180,TRBAR->D1_PEDIDO,oFonte02)
		oPrn:Say( _nLin, 0300,Alltrim(TRBAR->C7_NUMSC)+'/'+Alltrim(TRBAR->C7_ITEMSC),oFonte02)
		oPrn:Say( _nLin, 0520,Alltrim(TRBAR->D1_COD)+'-'+Alltrim(TRBAR->B1_DESC),oFonte02)
		//oPrn:Say( _nLin, 0520,TRBAR->B1_DESC,oFonte02)
		oPrn:Say( _nLin, 2000,TRBAR->B1_UM       ,oFonte02)
		oPrn:Say( _nLin, 2100,TRBAR->B1_TIPO,oFonte02)          
		/*
		oPrn:Say( _nLin, 1480,DTOC(STOD(TRBAR->F1_DTDIGIT)),oFonte02)
		oPrn:Say( _nLin, 1670,POSICIONE("ZZU",1,XFILIAL("ZZU")+TRBAR->B1_ZMARCA,"ZZU_DESCRI"),oFonte03)
		oPrn:Say( _nLin, 2000, TRBAR->D1_LOTECTL, oFonte02 )
		oPrn:Say( _nLin, 2150, dToC( sToD( TRBAR->D1_DTVALID ) ), oFonte02 )
		 */
		IF !Empty(TRBAR->B5_CEME )
			_nLin+=050	
			oPrn:Say( _nLin, 100,'Especifica��o : '+TRBAR->B5_CEME , oFonte02 ) 		 		
		EndIF
		cOBS := Posicione("SC1",1,xFilial("SC1")+TRBAR->C7_NUMSC+TRBAR->C7_ITEMSC,"C1_OBS")
		IF !Empty(cOBS )
			_nLin+=050				  
			oPrn:Say( _nLin, 0100,'Observacao Solicita��o : '+cOBS, oFonte02 ) 
        EndIF                                          
        cOBS := TRBAR->C7_OBS		
        IF !Empty(cOBS )
			_nLin+=050				  
			oPrn:Say( _nLin, 0100,'Observacao Pedido : '+cOBS, oFonte02 ) 
        EndIF                                                  
        IF !Empty(TRBAR->C7_COMPRA)
			_nLin+=050
		    oPrn:Say( _nLin, 0100,"Compradores : "+Alltrim(TRBAR->C7_COMPRA)+'-'+Alltrim(_cNComp), oFonte02  )
	    EndIF                                                                                                 
	    //oPrn:Say( _nLin, 010,Alltrim(STR(_nLin)), oFonte02  )
	    _nLin+=040                        
        oPrn:Line (_nLin,100,_nLin,2300)
	    _nLin+=040    
	TRBAR->(DBSKIP())
Enddo               

_nLin+=100
oPrn:Say( _nLin, 0400,"Ass. Recep��o NF: " , oFont3 )	    	
oPrn:Say( _nLin, 1400,"Ass. Confer�ncia: " , oFont3 )	

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpComp   �Autor  � A.Carlos           � Data �  10/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime Compradores QUERY PARA ACHAR NOME COMPRADORES       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpComp(_cTipo)
Local _nLinRod := 0
             
cQry1 := " SELECT Y1.Y1_NOME COMPRADOR " +CHR(10)
cQry1 += " FROM "+RetSqlName("SY1")+" Y1 " +CHR(10)
cQry1 += " WHERE Y1.D_E_L_E_T_= ' ' " +CHR(10)
cQry1 += " AND Y1.Y1_COD = '"+TRBAR->C7_COMPRA+"'" +CHR(10)
//cQry += " AND SAL.AL_FILIAL='"+cfilant+"'"

cQry1 := ChangeQuery(cQry1)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry1),"TRBCOMP",.F.,.t.)

oPrn:Box(_nLin,100,_nLin+1300,2799)
_nLin+=050
oPrn:Say( _nLin, 1300,"Comprador", oFont5 )
_nLin+=040
oPrn:Line (_nLin,100,_nLin,2300)
_nLin+=150
While TRBCOMP->(!EOF())
	oPrn:Line (_nLin,600,_nLin,1100)
	_nLin+=020
	oPrn:Say( _nLin, 0650,TRBCOMP->COMPRADOR, oFont1 )		
	_nLin+=150
    TRBCOMP->(Dbskip())
Enddo
DbCloseArea()
FErase("TRBCOMP"+GetDBExtension())

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Eugenio Arcanjo     � Data �  30/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria as perguntas do programa no dicionario de perguntas    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg( _cPerg )
	Local _nLaco := 0
	Local aArea  := GetArea()
	Local aPerg  := {}

	aAdd(aPerg,{_cPerg,"01","Emissao De ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"02","Emissao Ate ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"03","Transportadora De ?","mv_ch3","C",06,0,1,"G","","mv_par03","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"04","Transportadora Ate ?","mv_ch4","C",06,0,1,"G","","mv_par04","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{_cPerg,"05","Documento De ?","mv_ch5","C",09,0,1,"G","","mv_par05","","","","","","","","","","","","","","","SF1ZZZ",})
	aAdd(aPerg,{_cPerg,"06","Serie De ?","mv_ch6","C",03,0,1,"G","","mv_par06","","","","","","","","","","","","","","","",})
	aAdd(aPerg,{_cPerg,"07","Documento Ate ?","mv_ch7","C",09,0,1,"G","","mv_par07","","","","","","","","","","","","","","","SF1ZZZ",})
	aAdd(aPerg,{_cPerg,"08","Serie Ate ?"		,"mv_ch8","C",03,0,1,"G","","mv_par08","","","","","","","","","","","","","","","",})
	aAdd(aPerg,{_cPerg,"09","Fornecedor De ?"	,"mv_ch9","C",tamSx3("A2_COD")[1]	,0,1,"G","","mv_par09","","","","","","","","","","","","","","","SA2A",})
	aAdd(aPerg,{_cPerg,"10","Loja De ?"			,"mv_ch10","C",tamSx3("A2_LOJA")[1]	,0,1,"G","","mv_par10","","","","","","","","","","","","","","","",})
	aAdd(aPerg,{_cPerg,"11","Fornecedor Ate ?"	,"mv_ch11","C",tamSx3("A2_COD")[1]	,0,1,"G","","mv_par11","","","","","","","","","","","","","","","SA2A",})
	aAdd(aPerg,{_cPerg,"12","Loja Ate ?"		,"mv_ch12","C",tamSx3("A2_LOJA")[1]	,0,1,"G","","mv_par12","","","","","","","","","","","","","","","",})
	//aAdd(aPerg,{_cPerg,"07","Descricao Produto ?","mv_ch7","N",01,0,1,"C","","mv_par07","Produto","Produto","Produto","","","Cientifica","Cientifica","Cientifica","","","","","","","  ",})
		
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


// cria opcao no menu da rotina de pre-nota de entrada, para impressao do relatorio de recebimento de aviso de recebimento 
User Function ImpRelAR()

Local aBotao := {}
 
aAdd(aBotao,{"Relatorio de Aviso de Recebimento","U_MGFEST22",0,4,0,.F.})

Return(aBotao)
*************************************************************************************************
Static Function Ret_Tam(cTexto,oFontText)
Local nRet := 0

nRet:= ROUND(oPrn:GetTextWidth(cTexto, oFontText )+10 ,0)

Return nRet
**************************************************************************************************
                                                         


