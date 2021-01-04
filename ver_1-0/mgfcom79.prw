#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              MGFCOM79 
Autor....:              Tarcisio Galeano        
Data.....:              11/01/2018                                                                                                            
Descricao / Objetivo:   Evitar cadastro de contratos para o mesmo produto
Doc. Origem:            Compras 
Solicitante:            Cliente
Uso......:              
Obs......:              Gatilho para o ponto de entrada M125LOK
============================================================================================================================
*/ 
user function MGFCOM79()
	Local cProd		:= ""
	Local cContrato	:= ""
	Local cFil		:= ""

	Local msgx 		:= ""
    Local lret      := .T.

    Local cFili     := ""
    Local cFiliz    := ""
    
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
	cQuery += " AND SC3010.D_E_L_E_T_<>'*' "
	If Select("TEMP1") > 0
		TEMP1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
	dbSelectArea("TEMP1")    
	TEMP1->(dbGoTop())
    
	cglob :=0
	cfilia :=0
	While TEMP1->(!Eof())
        cProdq := TEMP1->C3_PRODUTO
        cFili   := TEMP1->C3_FILENT
        	cglob ++
        	if cFili<>"      "  
				cfilia ++
        	endif	        
	    TEMP1->(dbSKIP())
	EndDo
    
    IF cglob <> 0 .and. cglob<>cfilia
    	msgalert("S� sera permitida a inclusao se for um Contrato  para uma Filial.")
        lret := .F.
    ENDIF

// verifica se existe para esta filial

	
	cQuery1 = " SELECT ZD5_FILENT  "
	cQuery1 += "  From ZD5010 "
	cQuery1 += "  WHERE ZD5_CONTRA = '"+cContrato+"' AND ZD5_FILENT='"+cFil+"' " 
	cQuery1 += "  AND ZD5010.D_E_L_E_T_<>'*' "
	If Select("TEMP2") > 0
		TEMP2->(dbCloseArea())
	EndIf
	cQuery1  := ChangeQuery(cQuery1)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2",.T.,.F.)
	dbSelectArea("TEMP2")    
	TEMP2->(dbGoTop())
    
	cfilia :=0
	cfili :="" 
	While TEMP2->(!Eof())
        cFili   := TEMP2->ZD5_FILENT
        	if cFili<>"      "  
				cfilia ++
        	endif	        
	    TEMP2->(dbSKIP())
	EndDo

    //IF cfilia <> 0  
    	//msgalert("ATENCAO JA EXITE CONTRATO PARA ESTA FILIAL, FAVOR INDICAR UMA FILIAL ")
        //lret := .F.
    //ENDIF

 
return(lret)

