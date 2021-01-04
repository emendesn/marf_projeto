#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH"   
/*/
{Protheus.doc} MGFFIS49
Job para sincronização e manifestação automática.

@description
Este Job irá sincronizar com o SEFAZ e gravar todas as NFs geradas para a empresa.
Após receber e gravá-las na tabela C00, serão filtradas as NFs que estão sem Manifestação(C00_STATUS=0)
e serão manifestadas com o Status de "Ciência da Operação" automaticamente.
Exemplo de como montar o JOB:
;
[OnStart]
jobs=MGFFIS49,...,....,...,...
RefreshRate=300
;
[MGFFIS49]
Environment=HML/PROD
Main=U_MGFFIS49

@author Marcos Cesar Donizeti Vieira
@since 14/08/2019

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	SM0 - Empresas
	C00 - Manifesto do Destinatário
@param
@return

@menu
@history 
/*/
User Function MGFFIS49()
	Local cJob			:= ""	// Nome do semaforo que sera criado
	Local oLocker		:= Nil	// Objeto que ira criar um semaforo
	
	Private _aMatriz  	:= {"01","010001"}  
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"    
	Private _lJob		:= .T.                 

	IF _lIsBlind

		RpcSetType(3)
		RpcSetEnv(_aMatriz[1],_aMatriz[2])    

		cJob := "MGFFIS49"
		oLocker := LJCGlobalLocker():New()

		If !oLocker:GetLock( cJob )
			Conout("JOB já em Execução: MGFFIS49 " + DTOC(dDataBase) + " - " + TIME() )
			RpcClearEnv()
			Return
		EndIf       

		conOut("********************************************************************************************************************"+ CRLF	)       
		conOut('------- Inicio do processamento - MGFFIS49 - Sincronização/Manifesto Automático - ' + DTOC(dDataBase) + " - " + TIME()		)
		conOut("********************************************************************************************************************"+ CRLF	)       

		U_FIS49A()
		
		conOut("********************************************************************************************************************"+ CRLF	)       
		conOut("------- Fim  - MGFFIS49 - Sincronização/Manifesto Automático - " + DTOC(dDataBase) + " - " + TIME()  				  		)
		conOut("********************************************************************************************************************"+ CRLF	)       

		oLocker:ReleaseLock( cJob )
		RpcClearEnv()

	EndIF
Return()



/*/
{Protheus.doc} JOBFIS49
Iniciaizador do JOB para Sinconização/Manifestação no SEFAZ via Monitor.

@author Marcos Cesar Donizeti Vieira
@since 14/08/2019

@type Function
@param	
@return
/*/
User Function JOBFIS49()

	Private oFont1  := TFont():New("MS Sans Serif",,009,,.F.,,,,,.F.,.F.)
	DEFINE MSDIALOG Dlg_ExtExec TITLE "Manifesto - Sincronização e Manifesto automático" From 000, 000  TO 300, 590 PIXEL

		Public _cMemLog := ""
		Public oMemLog

		oSInfCli:= tSay():New(020,005,{||'LOG'},Dlg_ExtExec,,oFont1,,,,.T.,CLR_HBLUE,,120,20)

		oButton := tButton():New(005,228,'Executar',Dlg_ExtExec,{|| MsgRun("Executando job Sincronização/Manifesto Automático.",,{|| U_FIS49A() }) },65,17,,oFont1,,.T.)

		@ 30,05 GET oMemLog VAR _cMemLog MEMO SIZE 287,110 PIXEL OF Dlg_ExtExec
		oMemLog:lReadOnly := .T.

	ACTIVATE MSDIALOG Dlg_ExtExec CENTERED

Return



/*/
{Protheus.doc} FIS49A
Seleção de Filiais para Sinconização/Manifestação no SEFAZ.

@author Marcos Cesar Donizeti Vieira
@since 14/08/2019

@type Function
@param	
@return
/*/
User Function FIS49A()
	Local _aAreaSM0	:= SM0->(GetArea())
	Local _lProcAll := .T.		//Sincronizar até finalizar todos os documentos.
	Local _lRefSinc	:= .F.		//Refaz a sincronização de todos documentos.

	Private _aChvMonit := {}	
	
	If _lJob
		SM0->(DbGoTop())
		While !SM0->(EOF()) .And. SM0->M0_CODIGO = _aMatriz[1]
			cEmpAnt 	:= SM0->M0_CODIGO
			cFilAnt 	:= SM0->M0_CODFIL 
			_aChvMonit 	:= {}
			FIS49B(_lProcAll,_lRefSinc)		// Faz a Sincronização das NFs da Empresa
			FIS49C()						// Faz o Manifesto para todas as NFs que estão sem Manifestação.
			If Len(_aChvMonit) > 0
				FIS49G()					// Faz o Monitoramento das NFs Manifestada. 
			EndIF
			SM0->(DBSkip())
		EndDo
		SM0->(restArea(_aAreaSM0))
	Else
		_cMemLog := ""
		oMemLog:Refresh() 

		_cMemLog += "*** Inicio do processamento - MGFFIS49 - Sincronização/Manifesto Automático - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
		oMemLog:Refresh() 

		FIS49B(_lProcAll,_lRefSinc)	// Faz a Sincronização das NFs da Empresa
		FIS49C()					// Faz o Manifesto para todas as NFs que estão sem Manifestação.
		If Len(_aChvMonit) > 0
			FIS49G()				// Faz o Monitoramento das NFs Manifestada. 
		EndIF
	EndIf
Return()



/*/
{Protheus.doc} FIS49B()
Executa a funcionalidade de sincronizar com o SEFAZ.

@author Marcos Vieira
@since 04/07/2019

@type Function 
@param	lProcAll	Define se será realizado a sincronização até finalizar
					os documentos disponíveis na SEFAZ.
		lRefazSinc	Define se refaz a sincronização dos Documento.

/*/
Static Function FIS49B(lProcAll,lRefazSinc)
	Local aChave	:= {}
	Local aDocs		:= {}
	Local aProc		:= {}
	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	local lUsaColab	:= UsaColaboracao("4")
	Local cIdEnt	:= RetIdEnti(lUsaColab)
	Local cChave	:= ""
	Local cCancNSU	:= ""
	Local cAlert	:= ""
	Local cSitConf	:= ""
	Local cCodEvento:= ""
	Local cAmbiente	:= "" 
	Local lContinua	:= .T.
	Local dData		:= CtoD("  /  /    ")
	Local lOk		:= .F.
	Local lDestcnpj	:= .T.
	Local nX		:= 0                 
	Local nZ		:= 0

	Private oWs		:= Nil
	Private oInfdoc	:= Nil

	Default lProcAll 	:= .F.
	Default lRefazSinc	:= .F.

	conout("=| INICIO DA SINCRONIZAÇÃO - MGFFIS49 |==============================| Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "=| INICIO DA SINCRONIZAÇÃO - MGFFIS49 |==============================| Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf

	If ReadyTSS()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cINDNFE		 := "0"
		oWs:cINDEMI      := "0"
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
		cAmbiente		 := getAmbMde() 

		// Refaz a sincronização de todos os documentos disponiveis na SEFAZ
		If lRefazSinc 
			oWs:cUltNSU	:= "0"
			oWs:CONFIGURARPARAMETROS()
		Endif
			
		//Tratamento para solicitar a sincronização enaquanto o IDCONT não retornar zero.
		While lContinua
		
			lOk		:= .F.
			aChave	:= {}
			aProc	:= {}
			
			If oWs:SINCRONIZARDOCUMENTOS()
				If Type ("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO") <> "U"
					If Type("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO")=="A"
						aDocs := oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO                  
					Else
						aDocs := {oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO}
					EndIf
				
					For nX := 1 To Len(aDocs)
						lDestcnpj:=.T.
						oInfdoc := aDocs[nx]
						If Type("oInfdoc:CCHAVE") <> "U" .and. Type("oInfdoc:CSITCONF") <> "U" 
							cSitConf  := oInfdoc:CSITCONF
							cChave    := oInfdoc:CCHAVE  
							cCancNSU  := oInfdoc:CCANCNSU
							If Type("oInfdoc:CCODEVENTO") <> "U"
								cCodEvento:= oInfdoc:CCODEVENTO
							Else
								CodEvento:= ""
							EndIf
							If Type("oInfdoc:cDESTCNPJ") <> "U" .AND. !empty(oInfdoc:cDESTCNPJ)
								If SM0->M0_CGC <> oInfdoc:cDESTCNPJ
										lDestcnpj:= .F.
								EndIf
							EndIf
							
							// Caso o doc sincronizado tenha TPEVENTO não deve ir pra tabela C00
							If !cCodEvento $ "411500|411501|411502|411503" .and. lDestcnpj
								if SincAtuDados(cChave,cSitConf,cCancNSU)
									aadd(aChave, cChave)
									lOk := .T.

									ConOut("Sincronização: C00 Criado com sucesso: "+cChave)
									If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
										_cMemLog += "Sincronização: C00 Criado com sucesso: "+cChave+Chr(10)+Chr(13)
										oMemLog:Refresh() 
									EndIf

								endif
							EndIf
						EndIf	
					Next                   
					
					If lOk
						For nZ := 1 To Len( aChave )
							AADD( aProc, aChave[nZ] )                     
							If Len( aProc ) >= 30
								MonitoraManif(aProc,cAmbiente,cIdEnt,cUrl)
								aProc := {}
							Endif
						Next
						If Len( aProc ) > 0
							MonitoraManif(aProc,cAmbiente,cIdEnt,cUrl)
						Endif
					EndIf						
					
					If Type("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:CINDCONT") <> "U"	
						If oWs:OWSSINCRONIZARDOCUMENTOSRESULT:CINDCONT == "0"
							lContinua := .F.						               
						endif	
					else
						lContinua := .F.				
					endif
					
					If Empty(aDocs) .And. !lContinua .And. !lOk
						cAlert := "Não há documentos para serem sincronizados"
						ConOut("Sincronização: "+cAlert)
						If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
							_cMemLog += "Sincronização: "+cAlert+Chr(10)+Chr(13)
							oMemLog:Refresh() 
						EndIf
					EndIF

					if lContinua .And. !lProcAll .And. !lRefazSinc
						lContinua := .F.
					endif
					Sleep(4000)	// Para não execeder limite de evento para o SEFAZ
				EndIf	
			Else
				ConOut("SPED: "+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
				If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
					_cMemLog += "SPED: "+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+Chr(10)+Chr(13)
					oMemLog:Refresh() 
				EndIf
				lContinua := .F.
			EndIf
		EndDo	
	Else
		ConOut("SPED (!ReadyTSS): Antes de utilizar esta opção, execute o módulo de configuração do serviço.")
		If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
			_cMemLog += "SPED (!ReadyTSS): Antes de utilizar esta opção, execute o módulo de configuração do serviço."+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf
	EndIf

	oWs 	:= Nil
	oInfdoc := Nil
	aDocs 	:= Nil
	DelClassIntf()

	Sleep(4000)	// Para não execeder limite de evento para o SEFAZ

	conout("=================================| FIM DA SINCRONIZAÇÃO - MGFFIS49 - Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "=================================| FIM DA SINCRONIZAÇÃO - MGFFIS49 - Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf

Return



/*/
{Protheus.doc} ReadyTSS()
Verifica se a conexao com o TSS pode ser estabelecida

@author Marcos Vieira
@since 16/08/19

@type Function 
/*/
Static Function ReadyTSS(cURL,nTipo,lHelp)
	Local lUsaColab := UsaColaboracao("4")
Return (CTIsReady(cURL,nTipo,lHelp,lUsaColab))



/*/{Protheus.doc} getAmbMde()
retorna ambiente de configuração do Md-e

@param	

@return cAmbiente		Ambiente 
/*/
Static Function getAmbMde()
	
	local cAmbiente := ""
	local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)	
	local oWs
	local lUsacolab := UsaColaboracao("4")
	
	if !lUsacolab .and. ReadyTSS()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := retIdEnti(lUsacolab)
		oWs:cAMBIENTE	 := ""
		oWs:cVERSAO      := ""
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw" 
		oWs:CONFIGURARPARAMETROS()
		cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE
	
		freeObj(oWs)
		oWs := nil 	

	endif

return cAmbiente



/*/
{Protheus.doc} FIS49C
Seleção das NFs a manisfestar no SEFAZ.

@author Marcos Cesar Donizeti Vieira
@since 14/08/2019

@type Function
@param	
@return
/*/
Static Function FIS49C()
	Local _aListBox	:= {}
	Local _aItensCb	:= {}
	Local _aMontXml	:= {}
	Local _cRetorno	:= ""

	Local _cJustific	:= ""
	Local _oOkx			:= LoadBitmap( GetResources(), "LBOK" )
	Local _cOpcManif	:= "210210"
	Local _cAliasC00	:= GetNextAlias()

	BeginSql Alias _cAliasC00

		COLUMN C00_DTEMI AS DATE
		COLUMN C00_DTREC AS DATE
		
		SELECT 
			C00_CHVNFE,C00_SERNFE,C00_NUMNFE,C00_VLDOC,C00_CNPJEM,C00_NOEMIT,C00_IEEMIT,C00_DTEMI,C00_DTREC,C00_STATUS,C00_CODEVE,R_E_C_N_O_
		FROM 
			%Table:C00% C00
		WHERE 
			C00.%notdel% 						AND
			C00.C00_FILIAL	=  %Exp:cFilAnt%	AND
			C00.C00_DTREC	=  %Exp:dDataBase%	AND
			C00.C00_STATUS	=  '0'				AND
			C00.C00_SITDOC	=  '1'				AND
			C00.C00_CODEVE	=  '1'
		ORDER BY C00_NUMNFE

	EndSql

	While (_cAliasC00)->(!Eof())
		aadd(_aMontXml,{_oOkx,(_cAliasC00)->C00_CHVNFE,(_cAliasC00)->C00_SERNFE,(_cAliasC00)->C00_NUMNFE,(_cAliasC00)->C00_VLDOC,(_cAliasC00)->C00_CNPJEM,(_cAliasC00)->C00_NOEMIT,(_cAliasC00)->C00_IEEMIT,(_cAliasC00)->C00_DTEMI,(_cAliasC00)->C00_DTREC,.T.,(_cAliasC00)->C00_STATUS,(_cAliasC00)->C00_CODEVE})
		aadd(_aChvMonit, (_cAliasC00)->C00_CHVNFE )
		(_cAliasC00)->(dbSkip())
	EndDo

	If Len(_aMontXml) > 0
		U_FIS49D(_cOpcManif,_aMontXml,@_cRetorno,_cJustific)
	EndIF

	//---Fechando area de trabalho
	(_cAliasC00)->(dbcloseArea())

Return



/*/
{Protheus.doc} FIS49D()
Monta xml para transmissão da manifestação

@author Marcos Vieira
@since 16/08/2019

@param 	cCbCpo     - Evento Selecionado no listbox
		aMontXml   - Dados da nota que deve ser transmitida
		cRetorno   - Chaves de acesso das notas transmitidas
		cJustific  - Justificativa da Operação não realizada

@Return lRetOk	   - Se a transmissão foi concluída ou não		
/*/ 
User Function FIS49D(cCbCpo,aMontXml,cRetorno,cJustific) 
	Local aRet			:= {}
	Local cAmbiente		:= "" 
	Local cXml			:= ""
	Local cTpEvento		:= SubStr(cCbCpo,1,6)
	Local lUsaColab		:= UsaColaboracao("4")
	Local cIdEnt		:= RetIdEnti(lUsaColab)
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cChavesMsg	:= ""
	Local cMsgManif		:= ""
	Local cIdEven		:= ""
	Local cErro			:= ""
	Local cRetPE		:= ""
	Local aNfe			:= {}
	Local lRetOk		:= .T. 
	Local lManiEven		:= ExistBlock("MANIEVEN")
	Local lMata103		:= IIf(FunName()$"MATA103",.T.,.F.)
	Local nX 			:= 0
	Local nZ 			:= 0

	Private oWs			:= Nil

	Default cJustific 	:= ""

	conout("=| INICIO DA MANIFESTAÇÃO - MGFFIS49 |===============================| Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "=| INICIO DA MANIFESTAÇÃO - MGFFIS49 |===============================| Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf

	If ReadyTSS()
		If lUsaColab	
			cAmbiente := ColGetPar("MV_AMBIENT")
			lRetOk := .F.
			
			For nX:=1 To Len(aMontXml)
				aNfe := {}
				aNfe := {aMontXml[nX][2],"","",""}
				cIdEven := ""
				cXML	 := ""
				cXml := SpedCCeXml(aNfe,cJustific,cTpEvento)		
				//Adiciona a CHAVE da nota para solicitar o envio.
						
				If ColEnvEvento("MDE",aNfe,cXml,@cIdEven,@cErro)
					lRetOk := .T.
					aadd(aRet,cIdEven)
				else
					ConOut("MD-e TOTVS Colaboração 2.0"+cErro)
					If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
						_cMemLog += "MD-e TOTVS Colaboração 2.0"+cErro+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf
				EndIf
			Next
		else
			oWs :=WSMANIFESTACAODESTINATARIO():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cIDENT	     := cIdEnt
			oWs:cAMBIENTE	 := ""
			oWs:cVERSAO      := ""
			oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw" 
			
			If oWs:CONFIGURARPARAMETROS()
				cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE
				
				cXml+='<envEvento>'
				cXml+='<eventos>'
				
				For nX:=1 To Len(aMontXml)
					cXml+='<detEvento>'
					If lManiEven
						cRetPE := ExecBlock("MANIEVEN",.F.,.F.,{cTpEvento,aMontXml[nX][2]})
						If cRetPE <> Nil .And. !Empty(cRetPE)
							cTpEvento := cRetPE
						EndIf
					EndIf
					cXml+='<tpEvento>'+cTpEvento+'</tpEvento>'
					cXml+='<chNFe>'+Alltrim(aMontXml[nX][2])+'</chNFe>'
					cXml+='<ambiente>'+cAmbiente+'</ambiente>'
					If '210240' $ cTpEvento .and. !Empty(cJustific)
						cXml+='<xJust>'+Alltrim(cJustific)+'</xJust>'
					EndIf		
					cXml+='</detEvento>'
				Next
				cXml+='</eventos>'
				cXml+='</envEvento>'
				
				lRetOk:= FIS49E(cXml,cIdEnt,cUrl,@aRet)
			
			Else  
				ConOut("SPED"+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))  
				If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
					_cMemLog += "SPED"+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+Chr(10)+Chr(13)
					oMemLog:Refresh() 
				EndIf                                                                           
			endif	
		endif
				
		If lRetOk .And. Len(aRet) > 0
			For nZ:=1 to Len(aRet)
				aRet[nZ]:= Substr(aRet[nZ],9,44)
				cChavesMsg += aRet[nZ] + Chr(10) + Chr(13)	    	    
			Next
			cMsgManif := "Transmissão da Manifestação concluída com sucesso!"+ Chr(10) + Chr(13)
			cMsgManif += cCbCpo + Chr(10) + Chr(13)
			cMsgManif += "Chave(s): "+ Chr(10) + Chr(13)
			cMsgManif += cChavesMsg
			cRetorno := Alltrim(cMsgManif)
			ConOut(cRetorno)
			If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
				_cMemLog += cRetorno+Chr(10)+Chr(13)
				oMemLog:Refresh() 
			EndIf 
			
		EndIf	
		FIS49F(aRet,cTpEvento)			
	Else
		ConOut("SPED: Executar o módulo de configuração do serviço, antes de utilizar esta opção!!!")
		If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
			_cMemLog += "SPED: Executar o módulo de configuração do serviço, antes de utilizar esta opção!!!"+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf
	EndIf

	Sleep(4000)	// Para não execeder limite de evento para o SEFAZ

	conout("==================================| FIM DA MANIFESTAÇÃO - MGFFIS49 - Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "==================================| FIM DA MANIFESTAÇÃO - MGFFIS49 - Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf

Return lRetOk 



/*/{Protheus.doc} FIS49E()
Envia o xml para transmissão da manifestação

@author Marcos Vieira
@since 16/08/2019

@param 	cXmlReceb  - String com o XML a ser transmitido
		cIdEnt	   - Codigo da Entidade
		cUrl	   - URL
		aRetorno   - Retorno do RemessaEvento

@Return lRetOk	   - Se a transmissão foi concluída ou não		
/*/
Static Function FIS49E(cXmlReceb,cIdEnt,cUrl,aRetorno,cModel)

	Local lRetOk		:= .T.

	Default cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)  
	Default cIdEnt		:= RetIdEnti(lUsaColab)
	Default aRetorno	:= {}
	Default cModel		:= ""

	If ReadyTSS() .And. !(UsaColaboracao("4"))
		// Chamada do metodo e envio
		oWs:= WsNFeSBra():New()
		oWs:cUserToken	:= "TOTVS"
		oWs:cID_ENT		:= cIdEnt
		oWs:cXML_LOTE	:= cXmlReceb
		oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
		If !Empty(cModel)
			oWS:cModelo := cModel
		EndIf
		
		If oWs:RemessaEvento()
			If Type("oWS:oWsRemessaEventoResult:cString") <> "U"
				If Type("oWS:oWsRemessaEventoResult:cString") <> "A"
					aRetorno:={oWS:oWsRemessaEventoResult:cString}
				Else
					aRetorno:=oWS:oWsRemessaEventoResult:cString
				EndIf
			EndIf
		Else
			lRetOk := .F.	
			ConOut("SPED"+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
				_cMemLog += "SPED"+IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+Chr(10)+Chr(13)
				oMemLog:Refresh() 
			EndIf
		Endif
	Else
		ConOut("SPED: Executar o módulo de configuração do serviço, antes de utilizar esta opção!!!")
		If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
			_cMemLog += "SPED: Executar o módulo de configuração do serviço, antes de utilizar esta opção!!!"+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf
	EndIf

Return lRetOk



/*/{Protheus.doc} FIS49F()
Atualiza o Status da Manifestação de acordo com o Tipo de Evento

@author Marcos Vieira
@since 16/08/2019

@param 	aRet   	   - Chaves de acesso das notas transmitidas
		cTpEvento  - Tipo do Evento em que a nota foi transmitida
	
/*/
Static Function FIS49F(aRet,cTpEvento)
	Local aAreas	:= {}
	Local cStat		:= "0"
	Local nX		:= 0

	If cTpEvento $ '210200'
		cStat:= "1"  //Confirmada operação
	ElseIf cTpEvento $ '210220'
		cStat:= "2"  //Desconhecimento da Operação
	ElseIf cTpEvento $ '210240' 
		cStat:= "3"  //Operação não Realizada		 
	ElseIf cTpEvento $ '210210' 
		cStat:= "4"  //Ciência da operação
	EndIf

	If Len(aRet) > 0
		aAreas := GetArea()
		For nX:=1 to Len(aRet)
			C00->(DbSetOrder(1))
			If C00->(DBSEEK(xFilial("C00")+aRet[nX]))
				RecLock("C00")
				C00->C00_STATUS := cStat
				C00->C00_CODEVE := "3"
				MsUnlock()
			EndIf
		Next
		RestArea(aAreas)

		ConOut("Manifesto: Status atualizado!!!")
		If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
			_cMemLog += "Manifesto: Status atualizado!!!"+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf

	EndIf	

Return 



/*/{Protheus.doc} FIS49G()
Montagem inicial para Monitorar as manifestações

@author Marcos Vieira
@since 29/08/2019
/*/
Static Function FIS49G()
	Local _cChvIni		:= ""
	Local _cChvFin		:= ""
	Local _cCodEve		:= "210210" 	
	Local _aListBox		:= {}
	Local _lUsaColab	:= .F.
	Local _n 			:= 0
	Local _cChvMsg		:= ""
	Local _cMsgMonit	:= ""
	
	conout("=| INICIO DO MONITORAMENTO - MGFFIS49 |===============================| Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "=| INICIO DO MONITORAMENTO - MGFFIS49 |===============================| Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf

	//-- verifica se usa Totvs colaboracao
	_lUsaColab := UsaColaboracao("4")

	If ReadyTSS()
		If Len(_aChvMonit) > 0
			_aListBox := GETFIS49G(_cChvIni,_cChvFin,_cCodEve,_aChvMonit,_lUsaColab)
		EndIf
	EndIf

	For _n:=1 to Len(_aChvMonit)
		_cChvMsg += _aChvMonit[_n]+Chr(10)+Chr(13)	    	    
	Next
	_cMsgMonit := "Monitoração das manifestações concluída com sucesso!"+ Chr(10) + Chr(13)
	_cMsgMonit += _cCodEve + Chr(10) + Chr(13)
	_cMsgMonit += "Chave(s): "+ Chr(10) + Chr(13)
	_cMsgMonit += _cChvMsg
	ConOut(_cMsgMonit)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += _cMsgMonit+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf 
	
	conout("==================================| FIM DO MONITORAMENTO - MGFFIS49 - Filial: "+cFilAnt+"|====="	)
	If FunName() = "JOBFIS49" .OR. FunName() = "CTBA080"
		_cMemLog += "==================================| FIM DO MONITORAMENTO - MGFFIS49 - Filial: "+cFilAnt+"|====="+Chr(10)+Chr(13)
		oMemLog:Refresh() 
	EndIf
Return 



/*/{Protheus.doc} GETFIS49G
Montagem da Lista de Eventos para monitorar

@author Marcos Vieira
@since 29/08/19

@param cChvIni, cChvFin, cCodEve, aChaves
/*/
static function GETFIS49G(cChvIni, cChvFin, cCodEve, aChaves, lUsaColab)
	local nW		:= 0
	local nY		:= 0
	local cEventMon	:= "MonitEven"
	local aListChv	:= {}
	local aListBox	:= {}
	local cChaves	:= ""
	local nCont		:= 0

	if lUsaColab
		cEventMon	:= "ColEveMonit"
		bBloco		:= "{|| " + cEventMon + "(aChaves, cCodEve) }"
		aListBox	:= Eval(&bBloco)
	else
		cEventMon	:= "MonitEven"
		aListChv	:= {}
		aListBox	:= {}
		cChaves		:= ""
		nCont		:= 0

		For nW := 1 To Len( aChaves )
			++nCont
			cChaves += IIf(!Empty(cChaves),",","") + "'" + aChaves[nW] + "'" 				

			If nCont >= 50
				aListChv := MonitEven(cChvIni,cChvFin,cCodEve,,cChaves, lUsacolab)

				For nY := 1 To Len( aListChv )
					AADD( aListBox, aListChv[nY] )
				Next

				nCont		:= 0
				cChaves		:= ""
				aListChv	:= {}						
			Endif
		Next nW

		If nCont > 0
			aListChv := MonitEven(cChvIni,cChvFin,cCodEve,,cChaves, lUsacolab)
			
			For nY := 1 To Len( aListChv )
				AADD( aListBox, aListChv[nY] )
			Next
			
			cChaves := ""						
		Endif
	endif
return aListBox


/*/{Protheus.doc} MonitEven
Realiza o monitoramento do Evento

@author Marcos Vieira
@since 30/08/19 

@param		cChvIni   - Chave inicial a ser monitorada
			cChvFin   - Chave final a ser monitorada		    
			cCodEve	  - Codigo de Evento utilizado na busca
/*/
Static Function MonitEven(cChvIni,cChvFin,cCodEve,cModelo,cChaves,lUsaColab)
	Local aListBox		:= {}
	Local oOk			:= LoadBitMap(GetResources(), "ENABLE")
	Local oNo			:= LoadBitMap(GetResources(), "DISABLE")
	Local cURL   		:= PadR(GetNewPar("MV_SPEDURL","http://"),250) 
	Local cOpcUpd		:= ""
	Local cIdEnt		:= RetIdEnti(lUsaColab)
	Local nX			:= 0
	Local lOk      		:= .T.

	Private oXmlCCe
	Private oDados
	Private oWS			:= Nil	

	Default cModelo 	:= ""
	Default cChaves	    := ""

	If ReadyTss()

		// Executa o metodo NfeRetornaEvento()
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt 
		oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cEVENTO		:= cCodEve
		oWS:cCHVINICIAL	:= cChvIni
		oWS:cCHVFINAL	:= cChvFin
		oWS:cCHAVES		:= cChaves
		lOk:=oWS:NFEMONITORLOTEEVENTO()
		
		If lOk
			// Tratamento do retorno do evento
			If Type("oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento") <> "U" 
				
				If Valtype(oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento) <> "A"
					aMonitor := {oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento}
				Else
					aMonitor := oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento
				EndIF

				For nX:=1 To Len(aMonitor)                                          					
					AADD( aListBox, {	If(aMonitor[nX]:nStatus <> 6 .And. aMonitor[nX]:nStatus <> 7 ,oNo,oOk),;
										If(aMonitor[nX]:nProtocolo <> 0 ,Alltrim(Str(aMonitor[nX]:nProtocolo)),""),;
										aMonitor[nX]:cId_Evento,;
										Alltrim(Str(aMonitor[nX]:nAmbiente)),;	
										Alltrim(Str(aMonitor[nX]:nStatus)),;
										If(!Empty(aMonitor[nX]:cCMotEven),Alltrim(aMonitor[nX]:cCMotEven),Alltrim(aMonitor[nX]:cMensagem)),;
										"" }) //XML manter devido ao TOTVS Colaboração.
										
					//Atualizacao do Status do registro de saida
					cOpcUpd := "3"					
					If aListBox[nX][5]	== "3" .Or. aListBox[nX][5] == "5"					
						cOpcUpd :=	"4"  //Evento rejeitado +msg rejeiçao					
					ElseIf aListBox[nX][5] == "6"  
						cOpcUpd := "3"  //Evento vinculado com sucesso
					ElseIf aListBox[nX][5] == "1"
						cOpcUpd := "2"  //Envio de Evento realizado - Aguardando processamento
					EndIF

					cChave:= Substr(aMonitor[nX]:cId_Evento,9,44)
					
					AtuCodeEve( cChave, cOpcUpd, cCodEve, cModelo, aListBox[nX][4], cIdEnt, cUrl )
				Next       
			EndIF
		EndIf
	EndIf

Return aListBox