#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fwmvcdef.ch'
#include "topconn.ch"

User Function MGFFIN75()
	
	Local oMBrowse := nil	

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZZ8")
	oMBrowse:SetDescription("AmarraÁ„o de Usuario x Segmento")

	oMBrowse:Activate()
	
Return

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFFIN75" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFFIN75" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFFIN75" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFFIN75" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

Static Function ModelDef()
	
	Local oModel	:= Nil
	
	// arquivos
	Local oStrZZ8 	:= FWFormStruct(1,"ZZ8")
	Local oStrZDM 	:= FWFormStruct(1,"ZDM")
	Local oStrZDN 	:= FWFormStruct(1,"ZDN")
    //apos a gravacao
	Local bCommit	:= {||xCommits(oModel)}
	
	// omodel sempre com um x + nome
//	oModel := MPFormModel():New("XMGFFIN75",/*bPreValidacao*/,{|a,b,c,d|xMGF75val(a,b,c,d)}/*bPosValid*/,/*bCommit*/,/*bCancel*/)
	oModel := MPFormModel():New("XMGFFIN75",/*bPreValidacao*/,/*{||xVldModel(oModel)}bPosValid*/,{||xCommits(oModel)}/*bCommit*/,/*bCancel*/)
	
	//{|oModel| U_Est12VPos(oModel)}
	//tabela principal
	oModel:AddFields("ZZ8MASTER",/*cOwner*/,oStrZZ8, /*bPreValid*/, /*bPosValid*/, /*bCarga*/)	
	
	oModel:AddGrid("ZDMDETAIL","ZZ8MASTER",oStrZDM,/*{|a,b,c,d,e| xvldseg(a,b,c,d,e)} bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/,/*bCarga*/ )
	oModel:AddGrid("ZDNDETAIL","ZZ8MASTER",oStrZDN,/*{|a,b,c,d,e| xvldred(a,b,c,d,e)} bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
	
	//tabelas secundarias da amarracao
	oModel:SetRelation("ZDMDETAIL",{{"ZDM_FILIAL","xFilial('ZDM')"},{"ZDM_USUARI","ZZ8_USUARI"}},ZDM->(IndexKey(1)))
	oModel:SetRelation("ZDNDETAIL",{{"ZDN_FILIAL","xFilial('ZDN')"},{"ZDN_USUARI","ZZ8_USUARI"}},ZDN->(IndexKey(1)))
		
	oModel:SetDescription("Amarracao")
	oModel:SetPrimaryKey({"ZZ8_FILIAL","ZZ8_USUARI"})
	
	oModel:GetModel('ZDMDETAIL'):SetOptional(.T.)
	oModel:GetModel('ZDNDETAIL'):SetOptional(.T.)

	oModel:GetModel('ZDMDETAIL'):SetUniqueLine({'ZDM_CODSEG'})
	oModel:GetModel('ZDNDETAIL'):SetUniqueLine({'ZDN_CODRED'})

Return oModel

Static Function ViewDef()
	
	Local oView := nil
	
	Local oModel  	:= FWLoadModel('MGFFIN75')	
	
	Local oStrZZ8 	:= FWFormStruct( 2, "ZZ8")
	Local oStrZDM 	:= FWFormStruct( 2, "ZDM",{|x| AllTrim(x) $ 'ZDM_CODSEG,ZDM_DESCSE,R_E_C_N_O_'})
	Local oStrZDN 	:= FWFormStruct( 2, "ZDN",{|x| AllTrim(x) $ 'ZDN_CODRED,ZDN_DESRED,R_E_C_N_O_'})                       
	
	oView := FWFormView():New()
	oView:SetModel(oModel)	

	oView:AddField( 'VIEW_ZZ8' , oStrZZ8, 'ZZ8MASTER' )	

	oView:AddGrid( 'VIEW_ZDM' , oStrZDM, 'ZDMDETAIL' )
	oView:AddGrid( 'VIEW_ZDN' , oStrZDN, 'ZDNDETAIL' )

	//percentual da tela que sera usado
	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )            
	
	oView:CreateHorizontalBox( 'MEIO' 	  , 40 )
	oView:CreateHorizontalBox( 'INFERIOR' , 40 )
	
	oView:SetOwnerView( 'VIEW_ZZ8', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZDM', 'MEIO' 	   )
	oView:SetOwnerView( 'VIEW_ZDN', 'INFERIOR' )
	
return oView

/*
=====================================================================================
Programa............: xMGF75seg
Autor...............: TARCISIO GALEANO
Data................: 22/01/2018
Descri√ß√£o / Objetivo: Nao permitir regras iguais para atendententes distintos - segmento
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static Function xvldseg(oModel, nLin, cPonto, cCpo, e)
	Local xRet			:= .T.
	local oModel 		:= FWModelActive()
	local oMdlZZ8		:= oModel:GetModel("ZZ8MASTER")
	local oMdlZDM		:= oModel:GetModel("ZDMDETAIL")
	local oMdlZDN		:= oModel:GetModel("ZDNDETAIL")
	local aSaveLines	:= FWSaveRows()

	if cPonto == 'DELETE'
		//oMdlZDM:goLine( nLin )
		//oMdlZDM:deleteLine()
	elseif cPonto == "UNDELETE"
		//oMdlZDM:goLine( nLin )
		//oMdlZDM:unDeleteLine()
	else
			if cPonto == 'SETVALUE'
			   	if cCpo == 'ZDM_CODSEG'
                    if !EMPTY(e)
						// Checa o usuario para o codigo do segmento
						cQuery1 = " SELECT ZDM_USUARI,ZDM_CODSEG "
						cQuery1 += " FROM " + RetSqlName("ZDM")   "
						cQuery1 += " WHERE D_E_L_E_T_<>'*' AND ZDM_CODSEG='" + E + "' AND ZDM_USUARI<>'" + M->ZZ8_USUARI + "' "
						If Select("TEMP2") > 0
							TEMP2->(dbCloseArea())
						EndIf
						cQuery1  := ChangeQuery(cQuery1)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2",.T.,.F.)
						dbSelectArea("TEMP2")    
						TEMP2->(dbGoTop())
            
						While TEMP2->(!Eof())
                            //SE ACHOU OUTRO USUARIO
                            //MSGALERT("ACHOU "+TEMP2->ZDM_USUARI)
								cQuery1 =  " SELECT ZDN_USUARI FROM ZDN010 WHERE ZDN_CODRED = "
								cQuery1 += "(SELECT ZDNX.ZDN_CODRED "
								cQuery1 += "   FROM ZDN010 ZDNX "
								cQuery1 += "  WHERE ZDNX.D_E_L_E_T_<>'*' AND ZDNX.ZDN_USUARI='" + M->ZZ8_USUARI + "' )" 
								cQuery1 += "    AND  ZDN010.D_E_L_E_T_<>'*' AND ZDN010.ZDN_USUARI<>'" + M->ZZ8_USUARI + "' " 
								If Select("TEMP3") > 0
									TEMP3->(dbCloseArea())
								EndIf
								cQuery1  := ChangeQuery(cQuery1)
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP3",.T.,.F.)
								dbSelectArea("TEMP3")    
								TEMP3->(dbGoTop())
            
								While TEMP3->(!Eof())
                                   //IF TEMP3->ZDN_USUARI = M->ZZ8_USUARI  
                                   //   xRet :=.T.
                                   //ELSE
                                      xRet :=.F.
                                   
                                   //ENDIF
		        				TEMP3->(dbSKIP())
								EndDo


        				TEMP2->(dbSKIP())
						EndDo
                        
                        if !xRet 
                           Help( ,, 'AtenÁ„o !!!!',, "J· existe segmento x rede para outro atendente.", 1, 0 )
                        endif


                    ENDIF
                endif
            ENDIF

	endif
	FWRestRows( aSaveLines )
Return xRet
                                                                                     
/*
=====================================================================================
Programa............: xMGF75red
Autor...............: TARCISIO GALEANO
Data................: 22/01/2018
Descri√ß√£o / Objetivo: Nao permitir regras iguais para atendententes distintos - redes
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static Function xvldred(oModel, nLin, cPonto, cCpo, e)
	Local xRet			:= .T.
	local oModel 		:= FWModelActive()
	local oMdlZZ8		:= oModel:GetModel("ZZ8MASTER")
	local oMdlZDM		:= oModel:GetModel("ZDMDETAIL")
	local oMdlZDN		:= oModel:GetModel("ZDNDETAIL")
	local aSaveLines	:= FWSaveRows()

	if cPonto == 'DELETE'
		//oMdlZDN:goLine( nLin )
		//oMdlZDN:deleteLine()
	elseif cPonto == "UNDELETE"
		//oMdlZDN:goLine( nLin )
		//oMdlZDN:unDeleteLine()
	else
		if cPonto == 'SETVALUE'
		   	if cCpo == 'ZDN_CODRED'
                 if !EMPTY(e)
					if altera
						// Checa o usuario para o codigo da rede
						cQuery1 =  " SELECT ZDN_USUARI,ZDN_CODRED "
						cQuery1 += "   FROM ZDN010   "
						cQuery1 += "  WHERE ZDN010.D_E_L_E_T_<>'*' AND ZDN_CODRED='" + E + "' AND ZDN_USUARI<>'" + M->ZZ8_USUARI + "' "
						If Select("TEMP2") > 0
							TEMP2->(dbCloseArea())
						EndIf
						cQuery1  := ChangeQuery(cQuery1)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2",.T.,.F.)
						dbSelectArea("TEMP2")    
						TEMP2->(dbGoTop())
	            
						While TEMP2->(!Eof())
	                        //SE ACHOU OUTRO USUARIO
	                        //MSGALERT("ACHOU "+TEMP2->ZDN_USUARI)
							cQuery1 =  " SELECT ZDM_USUARI FROM ZDM010 WHERE ZDM_CODSEG = "
							cQuery1 += " (SELECT ZDMX.ZDM_CODSEG " 
							cQuery1 += "    FROM ZDM010 ZDMX "
							cQuery1 += "   WHERE ZDMX.D_E_L_E_T_<>'*' AND ZDMX.ZDM_USUARI='" + M->ZZ8_USUARI + "' )" 
							cQuery1 += "     AND ZDM010.D_E_L_E_T_<>'*' AND ZDM010.ZDM_USUARI<>'" + M->ZZ8_USUARI + "' " 
							If Select("TEMP3") > 0
								TEMP3->(dbCloseArea())
							EndIf
							cQuery1  := ChangeQuery(cQuery1)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP3",.T.,.F.)
							dbSelectArea("TEMP3")    
							TEMP3->(dbGoTop())
	            
							While TEMP3->(!Eof())
	       						xRet :=.F.
	                                  
			        			TEMP3->(dbSKIP())
							EndDo
	
	
	       			 		TEMP2->(dbSKIP())
						EndDo
	                endif
	                        
                        
                 	//se for inclus„o
	                if inclui
	                   	_codred := ""
	                  	_codred := e
							
						// Checa o usuario para o codigo da rede
						cQuery1 = " SELECT ZDN_USUARI,ZDN_CODRED "
						cQuery1 += "  FROM ZDN010   "
						cQuery1 += " WHERE ZDN010.D_E_L_E_T_<>'*' AND ZDN_CODRED='" + E + "' "
						If Select("TEMP2") > 0
							TEMP2->(dbCloseArea())
						EndIf
						cQuery1  := ChangeQuery(cQuery1)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP2",.T.,.F.)
						dbSelectArea("TEMP2")    
						TEMP2->(dbGoTop())
	            
						While TEMP2->(!Eof())
							cQuery1 = " SELECT ZDM_USUARI FROM ZDM010 WHERE ZDM_USUARI = '"+TEMP2->ZDN_USUARI+"' "
							cQuery1 += "   AND  ZDM010.D_E_L_E_T_<>'*'" 
							If Select("TEMP3") > 0
								TEMP3->(dbCloseArea())
							EndIf
							cQuery1  := ChangeQuery(cQuery1)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TEMP3",.T.,.F.)
							dbSelectArea("TEMP3")    
							TEMP3->(dbGoTop())
	            
							While TEMP3->(!Eof())
	                            xRet :=.F.
	                                   
			        			TEMP3->(dbSKIP())
							EndDo
	
	
	       					TEMP2->(dbSKIP())
						EndDo                            
	                endif
	                 // fim da inclusao
	

	                 if !xRet 
	                     Help( ,, 'AtenÁ„o !!!!',, "J· existe segmento x rede para outro atendente.", 1, 0 )
	                 endif
				 ENDIF
	        endif
   		ENDIF
	endif
	
	FWRestRows( aSaveLines )

Return xRet

Static Function xCommits(oModel)
	Local aArea			:= GetArea()
	Local oModelZDM		:= oModel:GetModel("ZDMDETAIL")
	Local oModelZDN		:= oModel:GetModel("ZDNDETAIL")
	Local nLinhaZDM		:= oModelZDM:GetLine()
	Local nLinhaZDN		:= oModelZDN:GetLine()
	Local aSaveLines	:= FWSaveRows()
    Local _OLDUSR 		:= ""
    Local _NUSR 		:= "" 
	Local _OldNUsr 		:= ""
	Local nOperation	:= oModel:GetOperation()
	Local aZDMOldGrid	:= oModelZDM:GetOldData()
	Local aZDNOldGrid	:= oModelZDM:GetOldData()
	Local nI			:= 0
	Local cAliasSE1		:= GetNextAlias()
	Local lRet 			:= .T.
	    
    _OLDUSR := ZZ8->ZZ8_USUARI
    _NUSR   :=UsrFullName(M->ZZ8_USUARI)
    _OldNUsr:=UsrFullName(ZZ8->ZZ8_USUARI)                                                                           
	
	//AQUI GRAVA INFORMA«√O NOS TITULOS EM ABERTO   --msgalert("bbbbbb"+ZDM->ZDM_USUARI)
                                               
	If nOperation == 4					// ALTERA«√O DE CADASTRO
		If ZZ8->ZZ8_USUARI <> M->ZZ8_USUARI
			BeginSql Alias cAliasSE1
				SELECT SE1.R_E_C_N_O_ AS SE1RECNO
				  FROM %TABLE:SE1% SE1
				 WHERE E1_ZATEND = %EXP:AllTrim(_OldNUsr)%    
				   AND E1_SALDO <> 0   
				   AND D_E_L_E_T_ = ''
			EndSql
			TcSetField(cAliasSE1,"SE1RECNO","N",10,0)
			(cAliasSE1)->(dbGoTop())
					
			dbSelectArea("SE1")
			dbSetOrder(1)
			While (cAliasSE1)->(!EOF())
				SE1->(dbGoTo((cAliasSE1)->SE1RECNO))
						
				RecLock("SE1",.F.)
				SE1->E1_ZATEND  := _NUSR
				SE1->(MsUnLock())
						
				(cAliasSE1)->(dbSkip())
			End
			(cAliasSE1)->(dbCloseArea())
			
			cQuery1	:= "UPDATE " + RetSqlName("ZDM") + " SET ZDM_USUARI='"+UPPER(M->ZZ8_USUARI)+"' "
			cQuery1	+= "WHERE ZDM_USUARI = '"+_OLDUSR+"' AND ZDM010.D_E_L_E_T_<>'*' "
			TcSqlExec(cQuery1)
	
			cQuery1	:= "UPDATE " + RetSqlName("ZDN") + " SET ZDN_USUARI='"+UPPER(M->ZZ8_USUARI)+"' "
			cQuery1	+= "WHERE ZDN_USUARI = '"+_OLDUSR+"' AND ZDN010.D_E_L_E_T_<>'*' "
			TcSqlExec(cQuery1)
		Endif 
		For nI := 1 To oModelZDM:Length()
			oModelZDM:GoLine(nI)
			If oModelZDM:IsDeleted()						// trata linha excluÌda
				BeginSql Alias cAliasSE1
					SELECT SE1.R_E_C_N_O_ AS SE1RECNO, AOV_DESSEG
					  FROM %TABLE:SE1% SE1
					 INNER JOIN %TABLE:SA1% SA1
					    ON (A1_FILIAL = %XFILIAL:SA1%
					   AND A1_COD = E1_CLIENTE
					   AND A1_LOJA = E1_LOJA
					   AND A1_CODSEG = %EXP:oModelZDM:GetValue("ZDM_CODSEG",nI)%
					   AND SA1.%NOTDEL%)
					 INNER JOIN %TABLE:AOV% AOV
					    ON (AOV_FILIAL = %XFILIAL:AOV%
					   AND AOV_CODSEG = A1_CODSEG
					   AND AOV.%NOTDEL%)
					 WHERE SE1.%NOTDEL%
					   AND SE1.E1_SALDO > 0
					   AND NOT EXISTS (SELECT 1 
					                     FROM %TABLE:ZDN% ZDN
					                    WHERE ZDN_FILIAL = %XFILIAL:ZDN% 
					                      AND ZDN_CODRED = A1_ZREDE
					                      AND ZDN_USUARI <> %EXP:M->ZZ8_USUARI%
										  AND ZDN.%NOTDEL%)                      
				EndSql
				TcSetField(cAliasSE1,"SE1RECNO","N",10,0)
				(cAliasSE1)->(dbGoTop())
					
				dbSelectArea("SE1")
				dbSetOrder(1)
				While (cAliasSE1)->(!EOF())
					SE1->(dbGoTo((cAliasSE1)->SE1RECNO))
					SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
					aInfSegm := MGQryRed(SA1->A1_ZREDE)
					
					RecLock("SE1",.F.)
					SE1->E1_ZATEND  := aInfSegm[1]
					SE1->E1_ZDESRED := aInfSegm[2]
					SE1->E1_ZSEGMEN := ""
					SE1->(MsUnLock())
						
					(cAliasSE1)->(dbSkip())
				End
				(cAliasSE1)->(dbCloseArea())
		  	EndIf
		Next
		For nI := 1 To oModelZDN:Length()
			oModelZDN:GoLine(nI)
			If oModelZDN:IsDeleted()						// trata linha excluÌda
				BeginSql Alias cAliasSE1
					SELECT SE1.R_E_C_N_O_ AS SE1RECNO, SZQ.ZQ_DESCR
					  FROM %TABLE:SE1% SE1
					 INNER JOIN %TABLE:SA1% SA1
					    ON (A1_FILIAL = %XFILIAL:SA1%
					   AND A1_COD = E1_CLIENTE
					   AND A1_LOJA = E1_LOJA
					   AND A1_ZREDE = %EXP:oModelZDN:GetValue("ZDN_CODRED",nI)%
					   AND SA1.%NOTDEL%)
					 INNER JOIN %TABLE:SZQ% SZQ
					    ON (ZQ_FILIAL = %XFILIAL:SZQ%
					   AND ZQ_COD = A1_ZREDE
					   AND SZQ.%NOTDEL%)
					 WHERE SE1.%NOTDEL%
					   AND SE1.E1_SALDO > 0
					   AND NOT EXISTS (SELECT 1 
					                     FROM %TABLE:ZDN% ZDN
					                    WHERE ZDN_FILIAL = %XFILIAL:ZDN% 
					                      AND ZDN_CODRED = A1_ZREDE
					                      AND ZDN_USUARI <> %EXP:M->ZZ8_USUARI%
										  AND ZDN.%NOTDEL%)                      
				EndSql
				TcSetField(cAliasSE1,"SE1RECNO","N",10,0)
				(cAliasSE1)->(dbGoTop())
					
				dbSelectArea("SE1")
				dbSetOrder(1)
				While (cAliasSE1)->(!EOF())
					SE1->(dbGoTo((cAliasSE1)->SE1RECNO))
					SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
					aInfSegm := MGQrySeg(SA1->A1_CODSEG)
					
					RecLock("SE1",.F.)
					SE1->E1_ZATEND  := aInfSegm[1]
					SE1->E1_ZDESRED := ""
					SE1->E1_ZSEGMEN := aInfSegm[2]
					SE1->(MsUnLock())
						
					(cAliasSE1)->(dbSkip())
				End
				(cAliasSE1)->(dbCloseArea())
			EndIf
		Next
	Endif
	If nOperation <> 5
		For nI := 1 To oModelZDM:Length()
			oModelZDM:GoLine(nI)
			If !oModelZDM:IsDeleted()
				If (nOperation == 3 .And. oModelZDM:IsInserted()) .Or. (nOperation == 4 .And. oModelZDM:IsUpDated())
					BeginSql Alias cAliasSE1
						SELECT SE1.R_E_C_N_O_ AS SE1RECNO, AOV.AOV_DESSEG
						  FROM %TABLE:SE1% SE1
						 INNER JOIN %TABLE:SA1% SA1
						    ON (A1_FILIAL = %XFILIAL:SA1%
						   AND A1_COD = E1_CLIENTE
						   AND A1_LOJA = E1_LOJA
						   AND A1_CODSEG = %EXP:oModelZDM:GetValue("ZDM_CODSEG",nI)%
						   AND SA1.%NOTDEL%)
						 INNER JOIN %TABLE:AOV% AOV
						    ON (AOV_FILIAL = %XFILIAL:AOV%
						   AND AOV_CODSEG = A1_CODSEG
						   AND AOV.%NOTDEL%)
						 WHERE SE1.%NOTDEL%
						   AND SE1.E1_SALDO > 0
						   AND NOT EXISTS (SELECT 1 
						                     FROM %TABLE:ZDN% ZDN
						                    WHERE ZDN_FILIAL = %XFILIAL:ZDN% 
						                      AND ZDN_CODRED = A1_ZREDE
						                      AND ZDN_USUARI <> %EXP:M->ZZ8_USUARI%
											  AND ZDN.%NOTDEL%)    
					EndSql
					                  
					TcSetField(cAliasSE1,"SE1RECNO","N",10,0)
					(cAliasSE1)->(dbGoTop())
					
					dbSelectArea("SE1")
					dbSetOrder(1)
					While (cAliasSE1)->(!EOF())
						SE1->(dbGoTo((cAliasSE1)->SE1RECNO))
						
						RecLock("SE1",.F.)
						SE1->E1_ZATEND  := _NUSR
						SE1->E1_ZSEGMEN := (cAliasSE1)->AOV_DESSEG
						SE1->E1_ZDESRED := ""
						SE1->(MsUnLock())
						
						(cAliasSE1)->(dbSkip())
					End
					(cAliasSE1)->(dbCloseArea())
				Endif
			Endif
		Next

		// seleciona tÌtulos da rede inserida ou alterada
		For nI := 1 To oModelZDN:Length()
			oModelZDn:GoLine(nI)
			If !oModelZDn:IsDeleted()
				If (nOperation == 3 .And. oModelZDN:IsInserted()) .Or. (nOperation == 4 .And. oModelZDN:IsUpDated())
					BeginSql Alias cAliasSE1
						SELECT SE1.R_E_C_N_O_ AS SE1RECNO, SZQ.ZQ_DESCR
						  FROM %TABLE:SE1% SE1
						 INNER JOIN %TABLE:SA1% SA1
						    ON (A1_FILIAL = %XFILIAL:SA1%
						   AND A1_COD = E1_CLIENTE
						   AND A1_LOJA = E1_LOJA
						   AND A1_ZREDE = %EXP:oModelZDN:GetValue("ZDN_CODRED",nI)%
						   AND SA1.%NOTDEL%)
						 INNER JOIN %TABLE:SZQ% SZQ
						    ON (ZQ_FILIAL = %XFILIAL:SZQ%
						   AND ZQ_COD = A1_ZREDE
						   AND SZQ.%NOTDEL%)
						 WHERE SE1.%NOTDEL%
						   AND SE1.E1_SALDO > 0
						   AND NOT EXISTS (SELECT 1 
						                     FROM %TABLE:ZDN% ZDN
						                    WHERE ZDN_FILIAL = %XFILIAL:ZDN% 
						                      AND ZDN_CODRED = A1_ZREDE
						                      AND ZDN_USUARI <> %EXP:M->ZZ8_USUARI%
											  AND ZDN.%NOTDEL%)                      
					EndSql
					TcSetField(cAliasSE1,"SE1RECNO","N",10,0)
					(cAliasSE1)->(dbGoTop())
					
					dbSelectArea("SE1")
					dbSetOrder(1)
					While (cAliasSE1)->(!EOF())
						SE1->(dbGoTo((cAliasSE1)->SE1RECNO))
						
						RecLock("SE1",.F.)
						SE1->E1_ZATEND  := _NUSR
						SE1->E1_ZDESRED := (cAliasSE1)->ZQ_DESCR
						SE1->E1_ZSEGMEN := ""
						SE1->(MsUnLock())
						
						(cAliasSE1)->(dbSkip())
					End
					(cAliasSE1)->(dbCloseArea())
				Endif
			Endif
		Next
	Endif	   
	dbSelectArea("ZZ8")
    // grava inclus„o / alteraÁ„o.
	If oModel:VldData()
		FwFormCommit(oModel)
		oModel:DeActivate()
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()	
	EndIf	
RestArea(aArea)

return lRet
/*
=====================================================================================
Programa............: MGQrySeg
Autor...............: PAULO FERNANDES
Data................: 17/05/2018
Descri√ß√£o / Objetivo: Validar Usu·rio x Segmento
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static Function MGQrySeg(cCodSeg)
Local aArea			:= GetArea()
Local cAliasZDM		:= GetNextAlias()
Local aDadosSeg		:= {"",""}
Local cNameUsr		:= ""

BeginSql Alias cAliasZDM
	SELECT ZDM.*,AOV.AOV_DESSEG
	  FROM %TABLE:ZDM% ZDM
	 INNER JOIN %TABLE:AOV% AOV
	    ON (AOV_FILIAL = %XFILIAL:AOV%
	   AND AOV_CODSEG = ZDM_CODSEG
	   AND AOV.%NOTDEL%)
	 WHERE ZDM_FILIAL = %XFILIAL:ZDM%
	   AND ZDM_CODSEG = %EXP:cCodSeg%
	   AND ZDM.%NOTDEL%
EndSql
(cAliasZDM)->(dbGoTop())
If (cAliasZDM)->(!EOF())
	PswOrder(1)
	If PswSeek((cAliasZDM)->ZDM_USUARI)
		cNameUsr := PswRet(1)[1][4]
	Else
	   	cNameUsr := Space(15)
	EndIf
Endif
aDadosSeg[1] := cNameUsr
aDadosSeg[2] := (cAliasZDM)->AOV_DESSEG

(cAliasZDM)->(dbCloseArea())

RestArea(aArea)

Return(aDadosSeg)
/*
=====================================================================================
Programa............: MGQryRed
Autor...............: PAULO FERNANDES
Data................: 17/05/2018
Descri√ß√£o / Objetivo: Validar Usu·rio x Rede
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static Function MGQryRed(cCodRed)
Local aArea			:= GetArea()
Local cAliasZDN		:= GetNextAlias()
Local aDadosRed		:= {"",""}
Local cNameUsr		:= ""

BeginSql Alias cAliasZDN
	SELECT ZDN.*,SZQ.ZQ_DESCR
	  FROM %TABLE:ZDN% ZDN
	 INNER JOIN %TABLE:SZQ% SZQ
	    ON (ZQ_FILIAL = %XFILIAL:SZQ%
	   AND ZQ_COD = ZDN_CODRED 
	   AND SZQ.%NOTDEL%)
	 WHERE ZDN_FILIAL = %XFILIAL:ZDN%
	   AND ZDN_CODRED = %EXP:cCodRed%
	   AND ZDN.%NOTDEL%
EndSql

(cAliasZDN)->(dbGoTop())

If (cAliasZDN)->(!EOF())
	PswOrder(1)
	If PswSeek((cAliasZDN)->ZDN_USUARI)
		cNameUsr := PswRet(1)[1][4]
	Else
	   	cNameUsr := Space(15)
	EndIf
Endif
aDadosRed[1] := cNameUsr
aDadosRed[2] := (cAliasZDN)->ZQ_DESCR

(cAliasZDN)->(dbCloseArea())

RestArea(aArea)

Return(aDadosRed)
/*
=====================================================================================
Programa............: xVldSegm
Autor...............: TARCISIO GALEANO
Data................: 22/01/2018
Descri√ß√£o / Objetivo: Validar Usu·rio x Segmento x Rede
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function xVldSegm(cCodSeg)
Local oModel 		:= FWModelActive()
Local oModelZDM		:= oModel:GetModel("ZDMDETAIL")
Local oModelZDN		:= oModel:GetModel("ZDNDETAIL")
Local nLinhaZDM		:= oModelZDM:GetLine()
Local nLinhaZDN		:= oModelZDN:GetLine()
Local aSaveLines	:= FWSaveRows()
Local nOperation	:= oModel:GetOperation()
Local aZDMOldGrid	:= oModelZDM:GetOldData()
Local aZDNOldGrid	:= oModelZDN:GetOldData()
Local nI			:= 0
Local cAliasZDx		:= GetNextAlias()
Local cMsgAviso		:= ""
Local lRet 			:= .T.

If nOperation <> 5
	cMsgAviso := ""
	If !oModelZDM:IsDeleted()
		BeginSql Alias cAliasZDx
			SELECT ZDM_USUARI, ZDM.ZDM_CODSEG,ZDM.ZDM_DESCSE
			  FROM %TABLE:ZDM% ZDM
			 WHERE ZDM.%NOTDEL%
			   AND ZDM_USUARI <> %EXP:M->ZZ8_USUARI%  
			   AND ZDM_CODSEG = %EXP:cCodSeg%                     
		EndSql
		(cAliasZDx)->(dbGoTop())
		While (cAliasZDx)->(!EOF())
			cMsgAviso += IIF(Empty(cMsgAviso),"Encontrado duplicidade no(s) segmento(s) abaixo :" + CRLF + "Segmento                    Usu·rio","") + CRLF
			cMsgAviso += (cAliasZDx)->ZDM_CODSEG + "-" + AllTrim((cAliasZDx)->ZDM_DESCSE) + Space(10) + UsrFullName((cAliasZDx)->ZDM_USUARI) + CRLF
	
			(cAliasZDx)->(dbSkip())
		End
		
		(cAliasZDx)->(dbCloseArea())
	Endif
	
	If !Empty(cMsgAviso)
		Aviso("Segmento",cMsgAviso,{"Ok"})
		lRet := .F.
	Endif
Endif

//oModelZDM:GoLine(nLinhaZDM)

Return(lRet)

/*
=====================================================================================
Programa............: xVldRede
Autor...............: TARCISIO GALEANO
Data................: 22/01/2018
Descri√ß√£o / Objetivo: Validar Usu·rio x Segmento x Rede
Doc. Origem.........: GAP FIN_CRE025
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function xVldRede(cCodRede)
Local oModel 		:= FWModelActive()
Local oModelZDM		:= oModel:GetModel("ZDMDETAIL")
Local oModelZDN		:= oModel:GetModel("ZDNDETAIL")
Local nLinhaZDM		:= oModelZDM:GetLine()
Local nLinhaZDN		:= oModelZDN:GetLine()
Local aSaveLines	:= FWSaveRows()
Local nOperation	:= oModel:GetOperation()
Local aZDMOldGrid	:= oModelZDM:GetOldData()
Local aZDNOldGrid	:= oModelZDN:GetOldData()
Local nI			:= 0
Local cAliasZDx		:= GetNextAlias()
Local cMsgAviso		:= ""
Local lRet 			:= .T.

If nOperation <> 5
	cMsgAviso := ""
	If !oModelZDn:IsDeleted()
		BeginSql Alias cAliasZDx
			SELECT ZDN_USUARI, ZDN.ZDN_CODRED,ZDN.ZDN_DESRED
			  FROM %TABLE:ZDN% ZDN
			 WHERE ZDN.%NOTDEL%
			   AND ZDN_USUARI <> %EXP:M->ZZ8_USUARI% 
			   AND ZDN_CODRED = %EXP:cCodRede%                     
		EndSql
		(cAliasZDx)->(dbGoTop())
		While (cAliasZDx)->(!EOF())
			cMsgAviso += IIF(Empty(cMsgAviso),"Encontrado duplicidade na(s) rede(s) abaixo :" + CRLF + "Rede                    Usu·rio","") + CRLF
			cMsgAviso += (cAliasZDx)->ZDN_CODRED + "-" + AllTrim((cAliasZDx)->ZDN_DESRED) + Space(10) + UsrFullName((cAliasZDx)->ZDN_USUARI) + CRLF
				
			(cAliasZDx)->(dbSkip())
		End
			
		(cAliasZDx)->(dbCloseArea())
	Endif

	If !Empty(cMsgAviso)
		Aviso("Rede",cMsgAviso,{"Ok"})
		lRet := .F.
	Endif

Endif

//oModelZDN:GoLine(nLinhaZDN)

Return(lRet)
