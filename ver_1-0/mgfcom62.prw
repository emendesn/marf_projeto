#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              MGFCOM62 
Autor....:              Tarcisio Galeano        
Data.....:              11/01/2018                                                                                                            
Descricao / Objetivo:   Evitar cadastro de contratos para o mesmo produto
Doc. Origem:            Compras 
Solicitante:            Cliente
Uso......:              
Obs......:              Gatilho para os campos C3_PRODUTO e C3_DATPRF
============================================================================================================================
*/ 
user function MGFCOM62()
	Local cProd		:= ""
	Local cProdq	:= ""
	Local msgx 		:= ""
	Local cFil      := ""
	Local cPosfil   := ""
 
// verifica se existe o produto em outro contrato
   	cProd := M->C3_PRODUTO
	cContrato := SC3->C3_NUM	
	cFil := ""	
    _cPosfil := Ascan(aHeader,{|x| AllTrim(x[2])=="C3_FILENT"})
	cFil 		:= aCols[n][_cPosFIL]
	
	
IF INCLUI

	cQuery =  " SELECT C3_PRODUTO,C3_FILENT "
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
	cfili :=0
	
	While TEMP1->(!Eof())
        cProdq := TEMP1->C3_PRODUTO
        cFil   := TEMP1->C3_FILENT
			cglob ++
        	if cFil<>"      "
				cfili ++
        	endif

	    TEMP1->(dbSKIP())
	EndDo
    
    IF !empty(cProdq)
    	msgx :="ATENCAO JA EXITE CONTRATO "
    ENDIF
    
    IF cglob <> cfili .and. cFili=0 .and. !empty(msgx)
        msgx :=msgx+"GLOBAL "
    ENDIF

    IF cFili<>0  
       msgx  :=msgx+"DE FILIAL "
    ENDIF

    IF !empty(msgx)
       msgx  :=msgx+"VIGENTE PARA ESTE PRODUTO, FAVOR DIRECIONAR O CONTRATO PARA UMA FILIAL "
       MSGALERT (""+msgx+"")
     ENDIF

ENDIF
    
return(cProd)

