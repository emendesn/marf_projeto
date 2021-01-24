#include "protheus.ch"

/*
============================================================================================
Programa.:              MT125GRV
Autor....:              Tarcisio Galeano
Data.....:              Março/2018 
Descricao / Objetivo:   
Doc. Origem:            Marfrig
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada antes de gravar o contrato de parceria
.........: 				gravar filial quando ja existir contrato global
=============================================================================================
*/
User Function MT125GRV()

	Local cProd		:= ""
	Local cContrato	:= ""
	Local cFil		:= ""

	Local msgx 		:= ""
    Local lret      := .T.
 
// verifica se existe o produto em outro contrato
    _cPosProd := Ascan(aHeader,{|x| AllTrim(x[2])=="C3_PRODUTO"})  //aCols[n][2]
    cProd	  := aCols[n][_cPosProd]

   	//cProd 		:= M->C3_PRODUTO
	cContrato 	:= ca125num
    _cPosfil := Ascan(aHeader,{|x| AllTrim(x[2])=="C3_FILENT"})
	cFil 		:= aCols[n][_cPosFIL]
	
	cQuery = " SELECT C3_PRODUTO,C3_FILENT "
	cQuery += " From " + RetSqlName("SC3") + " "
	cQuery += " WHERE C3_DATPRF >= '"+dtos(dDataBase)+"' AND C3_PRODUTO='"+cProd+"' AND C3_NUM<>'"+cContrato+"' AND C3_FILENT='"+cFil+"' "	
	cQuery += " AND D_E_L_E_T_<>'*' "
	If Select("TEMP1") > 0
		TEMP1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
	dbSelectArea("TEMP1")    
	TEMP1->(dbGoTop())
    
	cglob :=0
	While TEMP1->(!Eof())
        cProdq := TEMP1->C3_PRODUTO
        	cglob ++
	    TEMP1->(dbSKIP())
	EndDo
    
    IF cglob <> 0 
    	msgalert("ATENÇÃO JA EXITE CONTRATO PARA ESTA FILIAL, FAVOR INDICAR UMA NOVA FILIAL ")
        lret := .F.
    ELSE
          if !empty(cfil) //.AND. inclui
          DbSelectArea("ZD5") 
   	      ZD5->(dbSetOrder(1))   
          ZD5->(dBGotop())
          IF !DbSeek(xFilial("ZD5")+SC3->C3_NUM+cFil+SC3->C3_FORNECE+SC3->C3_LOJA)
                   
                   RecLock("ZD5",.T.)
                   ZD5->ZD5_CONTRA := SC3->C3_NUM   
                   ZD5->ZD5_FORNEC := SC3->C3_FORNECE   
                   ZD5->ZD5_LOJA   := SC3->C3_LOJA
                   //ZD5->ZD5_PROD   := SC3->C3_PRODUTO  
                   ZD5->ZD5_ITEM   := "0001"                               
                   ZD5->ZD5_FILENT := cFil
                   MsUnLock() 
                   RecLock("SC3",.F.)
                   	SC3->C3_FILENT := cFil
                   MsUnLock()
          ENDIF
          endif 
          
    ENDIF
    
    //verifica se existe filial e grava
	cQuery1 = " SELECT ZD5_FILENT  "
	cQuery1 += "  From ZD5010 "
	cQuery1 += "  WHERE ZD5_CONTRA = '"+cContrato+"' " 
	cQuery1 += "  AND ZD5010.D_E_L_E_T_<>'*' "
	If Select("TEMP2") > 0
		TEMP2->(dbCloseArea())
	EndIf
	cQuery1  := ChangeQuery(cQuery1)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2",.T.,.F.)
	dbSelectArea("TEMP2")    
	TEMP2->(dbGoTop())
    
	cfili :=" " 
	While TEMP2->(!Eof())
        cFili   := TEMP2->ZD5_FILENT
	    TEMP2->(dbSKIP())
	EndDo

    IF !empty(cFili)  
    	_cQry	:= " "
    	_cQry	:= " UPDATE " + RetSqlName("SC3") + " SET C3_FILENT ='"+alltrim(cFili)+"' "
		_cQry	+= " WHERE C3_NUM = '"+alltrim(cContrato)+"'  AND D_E_L_E_T_<>'*' "
		TcSqlExec(_cQry)
    ENDIF


    //grava comprador
	RecLock("SC3",.F.)
		SC3->C3_ZCODCOM := cCodCompr
	SC3->(MsUnLock())            


Return(lRet)