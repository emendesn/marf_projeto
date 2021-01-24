#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
=====================================================================================
Programa............: MGFCOMA1
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descrição / Objetivo: Tratamento para produtos nao movimentados a mais de 90 dias
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
user function MGFCOMA1()

	local cRetu 	:= M->C1_PRODUTO
	local cProd 	:= M->C1_PRODUTO
    local cQuery 	:= ""
	local nDias 	:=	GetMv("MGF_TRVEST") 
	local cFilblq 	:=	GetMv("MGF_FLBLQ") 

	if inclui .or. altera
	                              
	 
	 
	 // Estas filiais consideram notas as outras só consumo
	IF xfilial("SC1") $ cFilblq //"010041|010045|020003"
	 
		cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU), "
		cQuery += " (SELECT MAX(D1_DTDIGIT) FROM " + RetSqlName("SD1") + " WHERE D1_COD=B2_COD AND D1_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD1, "
		cQuery += " (SELECT MAX(D2_EMISSAO) FROM " + RetSqlName("SD2") + " WHERE D2_COD=B2_COD AND D2_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD2, "
		cQuery += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
		cQuery += " AND D3_CF IN ('RE1','RE5','RE0') ) AS DT_SD3 "
		cQuery += " From " + RetSqlName("SB2") + " "
		cQuery += " WHERE B2_QATU<>0 AND B2_COD='"+cProd+"' AND B2_FILIAL='"+xFilial("SC1")+"' "	
		cQuery += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
	 ELSE	         
		cQuery =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU), "
		cQuery += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
		cQuery += " AND D3_CF IN ('RE1','RE5','RE0') ) AS DT_SD3 "
		cQuery += " From " + RetSqlName("SB2") + " "
		cQuery += " WHERE B2_QATU<>0 AND B2_COD='"+cProd+"' AND B2_FILIAL='"+xFilial("SC1")+"' "	
		cQuery += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
	 ENDIF	
		
		If Select("TEMP1") > 0
			TEMP1->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
		dbSelectArea("TEMP1")    
		TEMP1->(dbGoTop())
    
		cNum := 0
		cNumd1 := 0
		cNumd2 := 0
		cNumd3 := 0
		
		While TEMP1->(!Eof())
        
        
			IF xfilial("SC1") $ cFilblq //"010041|010045|020003"
        		If !empty(TEMP1->DT_SD1)
        	  	//msgalert("data "+TEMP1->DT_SD1)           
        	    cNumd1 := ddatabase - Ctod(Substr(TEMP1->DT_SD1,7,2)+"/"+Substr(TEMP1->DT_SD1,5,2)+"/"+Substr(TEMP1->DT_SD1,1,4))
        		Endif
        		If !empty(TEMP1->DT_SD2)
        		//msgalert("data "+TEMP1->DT_SD2)
        	    cNumd2 := ddatabase - Ctod(Substr(TEMP1->DT_SD2,7,2)+"/"+Substr(TEMP1->DT_SD2,5,2)+"/"+Substr(TEMP1->DT_SD2,1,4))
        	    
        		Endif
        		If !empty(TEMP1->DT_SD3)
        		//msgalert("data "+TEMP1->DT_SD3)
        	    cNumd3 := ddatabase - Ctod(Substr(TEMP1->DT_SD3,7,2)+"/"+Substr(TEMP1->DT_SD3,5,2)+"/"+Substr(TEMP1->DT_SD3,1,4))
        		Endif
            

            	//compara os numeros
           
           		cNum := cNumd1
            
            	if cNumd2 < cNumd1
            		cNum := cNumd2
            	endif
            
            	if cNumd3 < cNumd2
            		cNum := cNumd3
            	endif


            ELSE
        		If !empty(TEMP1->DT_SD3)
        		//msgalert("data "+TEMP1->DT_SD3)
        	    cNumd3 := ddatabase - Ctod(Substr(TEMP1->DT_SD3,7,2)+"/"+Substr(TEMP1->DT_SD3,5,2)+"/"+Substr(TEMP1->DT_SD3,1,4))
        		Endif
            
            	//compara os numeros
           
           		cNum := cNumd3
            
            ENDIF
            
            //faz o tratamento para bloquear
            if cNum > nDias
        		msgalert("Produto nesta filial não movimentado a mais de 90 dias, solicitação recusada. ")
            	cRetu := " "
            //Else
        	//	msgalert("Produto não movimentado a "+trans(cNum,"999999")+" dias ")
            Endif

	    	TEMP1->(dbSKIP())
		EndDo
        
        
    IF	cNum < nDias        
// tratamento para localizar o produto em outras filiais
        cQueryn :=" "
	 IF xfilial("SC1") $ cFilblq //"010041|010045|020003"
	 	cQueryn =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU) as SALDO, "
		cQueryn += " (SELECT MAX(D1_DTDIGIT) FROM " + RetSqlName("SD1") + " WHERE D1_COD=B2_COD AND D1_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD1, "
		cQueryn += " (SELECT MAX(D2_EMISSAO) FROM " + RetSqlName("SD2") + " WHERE D2_COD=B2_COD AND D2_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ') AS DT_SD2, "
		cQueryn += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
		cQueryn += " AND D3_CF IN ('RE1','RE5','RE0')) AS DT_SD3 "
		cQueryn += " From " + RetSqlName("SB2") + " "
		cQueryn += " WHERE B2_QATU<>0 AND B2_COD='"+cProd+"' AND B2_FILIAL NOT IN ('"+cFilblq+"' ) " //010041','010045','020003') "	
		cQueryn += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD "
	 else
	 	cQueryn =  " SELECT B2_FILIAL,B2_COD,SUM(B2_QATU) as SALDO, "
		cQueryn += " (SELECT MAX(D3_EMISSAO) FROM " + RetSqlName("SD3") + " WHERE D3_COD=B2_COD AND D3_FILIAL=B2_FILIAL AND D_E_L_E_T_=' ' AND D3_ESTORNO=' ' "
		cQueryn += " AND D3_CF IN ('RE1','RE5','RE0')) AS DT_SD3 "
		cQueryn += " From " + RetSqlName("SB2") + " "
		cQueryn += " WHERE B2_QATU<>0 AND B2_COD='"+cProd+"' AND B2_FILIAL<>'"+xFilial("SC1")+"' "	
		cQueryn += " AND D_E_L_E_T_<>'*' GROUP BY B2_FILIAL,B2_COD ORDER BY B2_FILIAL"
	 Endif
	 	
		If Select("TEMP2") > 0
			TEMP2->(dbCloseArea())
		EndIf
		cQueryn  := ChangeQuery(cQueryn)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryn),"TEMP2",.T.,.F.)
		dbSelectArea("TEMP2")    
		TEMP2->(dbGoTop())
    
		cNumf := 0 
		cNumf1 := 0 
		cNumf2 := 0 
		cNumf3 := 0 
		cFil := "" 
		cMsg := ""
		While TEMP2->(!Eof())
        
        //aqui verifica se o produto foi comprado entre 90 dias e a seu saldo
        // se saldo <= saldo comprado no periodo não apresentar como disponivel.
        
		cQuantd1 := 0 

        cQueryx :=" "
	 	cQueryx =  " SELECT SUM(D1_QUANT) AS QTDED1"
		cQueryx += " FROM " + RetSqlName("SD12") + " " 
		cQueryx += " WHERE D1_DTDIGIT >=  TO_CHAR(SYSDATE-90,'YYYYMMDD') "
		cQueryx += " AND D1_COD='"+TEMP2->B2_COD+"' AND D1_FILIAL='"+TEMP2->B2_FILIAL+"' AND D1_QUANT <> 0 "
		cQueryx += " ORDER BY D1_COD "

			If Select("TEMP3") > 0
				TEMP3->(dbCloseArea())
			EndIf
			cQueryx  := ChangeQuery(cQueryx)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryx),"TEMP3",.T.,.F.)
			dbSelectArea("TEMP3")    
			TEMP3->(dbGoTop())
    
			cQuantd1 := 0 

			While TEMP3->(!Eof())
        
                cQuantd1 :=  TEMP3->QTDED1
                
	    	TEMP3->(dbSKIP())
			EndDo
        
        
           //MSGALERT("AQUI "+TRANS(cQuantd1,"999"))
        
           
   IF CQUANTD1 <= TEMP2->SALDO
        
        
		IF xfilial("SC1") $ cFilblq //"010041|010045|020003"
        	If !empty(TEMP2->DT_SD1)
        	  	//msgalert("data "+TEMP1->DT_SD1)           
        	    cNumf1 := ddatabase - Ctod(Substr(TEMP2->DT_SD1,7,2)+"/"+Substr(TEMP2->DT_SD1,5,2)+"/"+Substr(TEMP2->DT_SD1,1,4))
        	Endif
        	If !empty(TEMP2->DT_SD2)
        		//msgalert("data "+TEMP1->DT_SD2)
        	    cNumf2 := ddatabase - Ctod(Substr(TEMP2->DT_SD2,7,2)+"/"+Substr(TEMP2->DT_SD2,5,2)+"/"+Substr(TEMP2->DT_SD2,1,4))
        	    
        	Endif
        	If !empty(TEMP2->DT_SD3)
        		//msgalert("data "+TEMP1->DT_SD3)
        	    cNumf3 := ddatabase - Ctod(Substr(TEMP2->DT_SD3,7,2)+"/"+Substr(TEMP2->DT_SD3,5,2)+"/"+Substr(TEMP2->DT_SD3,1,4))
        	Endif

            //compara os numeros
            	cNumf := cNumf1
            
            if cNumf2 < cNumf1
            	cNumf := cNumf2
            endif
            
            if cNumf3 < cNumf2
            	cNumf := cNumf3
            endif

		ELSE
        	If !empty(TEMP2->DT_SD3)
        		//msgalert("data "+TEMP1->DT_SD3)
        	    cNumf3 := ddatabase - Ctod(Substr(TEMP2->DT_SD3,7,2)+"/"+Substr(TEMP2->DT_SD3,5,2)+"/"+Substr(TEMP2->DT_SD3,1,4))
        	Endif
            //compara os numeros
            	cNumf := cNumf3

    	ENDIF
            
            //faz o tratamento para bloquear
            if cNumf > nDias
        		cMsg := cMsg+" "+TEMP2->B2_FILIAL+" ["+TRANS(TEMP2->SALDO,"999999")+"]   " 
            Endif
        
   ENDIF         
   
        
	    TEMP2->(dbSKIP())
		EndDo
    

     	if !empty(cMsg)
     		msgalert("Produto disponível sem movimentação nas seguintes filiais => "+cMsg)
        //else
     	//	msgalert("Produto sem disponibilidade em outras filiais")
        Endif
        
       GdFieldPut( "C1_ZOBSEST" , cMsg)
       
     Endif

    Endif
    
return cRetu




