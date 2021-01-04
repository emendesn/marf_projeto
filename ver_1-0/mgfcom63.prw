#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              MGFCOM63 
Autor....:              Tarcisio Galeano        
Data.....:              11/01/2018                                                                                                            
Descricao / Objetivo:   Evitar cadastro de contratos para o mesmo produto
Doc. Origem:            Compras 
Solicitante:            Cliente
Uso......:              
Obs......:              Gatilho para os campos C3_DATPRF
============================================================================================================================
*/ 
user function MGFCOM63()
	Local cProdx 	:= ""
	Local cProdqx 	:= ""
	Local cFil      := ""
	Local cPosfil   := ""
    
    _cPosProd := Ascan(aHeader,{|x| AllTrim(x[2])=="C3_PRODUTO"})  //aCols[n][2]
    cProdx	  := aCols[n][_cPosProd]

	_cDat 	:= Ascan(aHeader,{|x| AllTrim(x[2])=="C3_DATPRF"})
    cDat  	:= SC3->C3_DATPRF
    _cContrato := SC3->C3_NUM

    _cPosfil := Ascan(aHeader,{|x| AllTrim(x[2])=="C3_FILENT"})
	cFil 		:= aCols[n][_cPosFIL]
	
	cQuery = " SELECT DISTINCT C3_PRODUTO "
	cQuery += " From " + RetSqlName("SC3") + " "
	cQuery += " WHERE C3_DATPRF >= '"+dtos(dDataBase)+"' AND C3_PRODUTO='"+cProdx+"' AND C3_NUM<>'"+_cContrato+"' AND C3_FILENT='"+cFil+"' "	
	cQuery += " AND D_E_L_E_T_<>'*' "
	If Select("TEMP15") > 0
		TEMP15->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP15",.T.,.F.)
	dbSelectArea("TEMP15")    
	TEMP15->(dbGoTop())
    
	ncont :=0
	While TEMP15->(!Eof())
        ncont := ncont+1
 	    TEMP15->(dbSKIP())
	EndDo
                                              
    IF ncont >0 //!empty(cProdqx)
       msgalert ("JA EXISTE CONTRATO VIGENTE PARA ESTE PRODUTO, FAVOR VERIFICAR ")
       cDat := M->C3_DATPRF
    else
       cDat := M->C3_DATPRF
    
    ENDIF
    
return(cDat)
//checa filial

