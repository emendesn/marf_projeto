#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH"   
#include 'DIRECTRY.CH'

/*/
{Protheus.doc} MGFGFE61
Job para validação dos XML´s de CTe´s.

@description
Este Job irá ler todos os XML´s disponibilizados pela Inventti em uma pasta pré definida, onde fará a leitura de todos, 
e os que tiverem Ordem de Embarque serão movidos para a pasta de importação do Protheus..
Exemplo de como montar o JOB:
;
[OnStart]
jobs=MGFGFE61,...,....,...,...
RefreshRate=300
;
[MGFGFE61]
Environment=HML/PROD
Main=U_MGFGFE61

@author Marcos Cesar Donizeti Vieira
@since 12/02/2020

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	
@param
@return

@menu
@history 
/*/
User Function MGFGFE61()
	Local cJob			:= ""	// Nome do semaforo que sera criado
	Local oLocker		:= Nil	// Objeto que ira criar um semaforo
	
	Private _aMatriz  	:= {"01","010001"}  
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"    
	Private _lJob		:= .T.                 

	IF _lIsBlind

		U_MFCONOUT('Inicio do processamento verificação de status dos xmls de ctes...'		)

		cJob := "MGFGFE61"
		oLocker := LJCGlobalLocker():New()

		If !oLocker:GetLock( cJob )
			U_MFCONOUT("JOB já em Execução: MGFGFE61 " + DTOC(dDataBase) + " - " + TIME() )
			Return
		EndIf       

		//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
		If !ExisteSx6("MGF_GFE61A")
			CriarSX6("MGF_GFE61A", "C", "Caminho onde estarão os XML´s Inventti", "\INVENTTI\" )	
		EndIf   

		If !ExisteSx6("MGF_GFE61B")
			CriarSX6("MGF_GFE61B", "C", "Caminho onde gravar os XML´s em transito", "\INVENTTI\EMTRASITO\" )	
		EndIf

		GFE61A() //Processamento de xmls
		
		U_MFCONOUT("Completou o processamento verificação de status dos xmls de ctes."	  		)

		oLocker:ReleaseLock( cJob )

	EndIF
Return()



/*/
{Protheus.doc} JOBGFE61
Iniciaizador do JOB em tela, monitorando as mensagens.

@author Marcos Cesar Donizeti Vieira
@since 12/02/2020

@type Function
@param	
@return
/*/
User Function JOBGFE61()

	Private oFont1  := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	Private oFont2  := TFont():New("MS Sans Serif",,012,,.T.,,,,,.F.,.F.)

	//-----| Verifica existência de parâmetros e caso não exista cria. |-----\\
	If !ExisteSx6("MGF_GFE61A")
		CriarSX6("MGF_GFE61A", "C", "Caminho onde estarão os XML´s Inventti", "\INVENTTI\" )	
	EndIf

	If !ExisteSx6("MGF_GFE61B")
		CriarSX6("MGF_GFE61B", "C", "Caminho onde gravar os XML´s em transito", "\INVENTTI\EMTRANSITO\" )	
	EndIf

	DEFINE MSDIALOG Dlg_ExtExec TITLE "XML Inventti" From 000, 000  TO 620, 1350 PIXEL

		Public _cMemLog := ""
		Public oMemLog

		oSInfCli:= tSay():New(020,007,{||"MONITOR DE MENSAGENS"},Dlg_ExtExec,,oFont1,,,,.T.,CLR_HBLUE,,200,20)

		oButton := tButton():New(007,520,"Executar"	,Dlg_ExtExec, {|| GFE61Z() 			} ,65,17,,oFont2,,.T.)
		oButton := tButton():New(007,600,"Sair"		,Dlg_ExtExec, {|| Dlg_ExtExec:End()	} ,65,17,,oFont2,,.T.)

		@ 30,05 GET oMemLog VAR _cMemLog MEMO SIZE 665,270 OF Dlg_ExtExec PIXEL	
		oMemLog:lReadOnly := .T.

	ACTIVATE MSDIALOG Dlg_ExtExec CENTERED

Return



/*/
{Protheus.doc} GFE61Z
Inicializando processos para barras de processamento.

@author Marcos Cesar Donizeti Vieira
@since 12/02/2020

@type Function
@param	
@return
/*/
Static Function GFE61Z()
	Private oProcess
    oProcess := MsNewProcess():New( { || GFE61A() } , "Importando arquivos XMLs" , "Aguarde..." , .F. )
    oProcess:Activate()
Return



/*/
{Protheus.doc} GFE61A
Leitura dos arquivos XML´s.

@author Marcos Cesar Donizeti Vieira
@since 13/02/2020

@type Function
@param	
@return
/*/

/*/
{Protheus.doc} GFE61A
@Alterações: Adicionado tratamento para erro de estrutura. 
             Leitura a partir da variavel _lErroest
@author Henrique Vidal - PRB0040780
/*/

Static Function GFE61A()
	Local _cAliasDAI
	Local _cChvNfe
	Local _cNomArq
	Local _cCNPJ 
	Local _cTpNF
	Local _cSerie
	Local _cNFiscal
	Local _cCteComp

	Local _cFilial 
	Local _cOrdEmb
	Local _cCliente
	Local _cLoja

	Local _cJson
	Local _cRetHttp
	Local _nStatuHttp
	
	Local _aHeadStr 	:= {}
	Local _cHeaderRet	:= ""

	Local _aCarga		:= {}
	Local _lCopia		:= .T.
	Local _cStatus		:= "OK"
	Local _cError 		:= ""
	Local _cWarning		:= ""
	Local _lerroEst 	:= .F.

	Local _nY1	   := 1
	Local _nCount  := 0 
	Local _dDtFile := CtoD(Space(08))

	// Paulo da Mata - PRB0040795 - 07/04/2020 - Cria array com os XML espirados e com mais de 30 dias 
	Local _aXmlExc := {}
	
	// Paulo da Mata - PRB0040795 - 07/04/2020 - Parâmetro para XML com datas mais antigas
	Local _nQtdExc  := SuperGetMV("MGF_GFE61G",.F.,30) 
	Local _cPath	:= ALLTRIM(SuperGetMV("MGF_GFE61A",.F.,"\INVENTTI\"))
	Local _cPathTrs	:= ALLTRIM(SuperGetMV("MGF_GFE61B",.F.,"\INVENTTI\EMTRANSITO\"))
	Local _cPathexp	:= ALLTRIM(SuperGetMV("MGF_GFE61E",.F.,"\INVENTTI\EXPIRADO\"))
		
	Local _aFiles[ADIR(_cPath+"*.XML")] 

	Private _cProtoco := ""
	Private _cUrlPost := ""
	Private oObjRet   := nil
	Private oCarga 	  := nil
	Private oWSGFE61  := nil

	ADIR(_cPath+"*.XML",_aFiles)

	/*
	Paulo da Mata - PRB0040795 - 07/04/2020 - Antes de Processar os XML atuais, 
	                                          exclui os XML espirados com mais de 30 dias
	*/
	_aXmlExc := Directory(_cPathexp+"35200917216489000136573000000016941000169493.XML")
	_nCount  := Len(_aXmlExc)

	For _nY1 := 1 to _nCount

	    _dDtFile := _aXmlExc[_nY1][3] 

		If _dDtFile <= Date()-_nQtdExc

			If 	fErase(AllTrim(_cPathexp+_aXmlExc[_nY1][1])) == -1	// Apaga o arquivo na origem.
				U_MFCONOUT("Falha ao tentar apagar o arquivo: "+AllTrim(_cPathexp+_aXmlExc[_nY1][1]))
			Else	   
				U_MFCONOUT("Arquivo : "+AllTrim(_cPathexp+_aXmlExc[_nY1][1])+" excluido !")
			EndIf

		EndIf	
	
	Next

	//-----| Verifica existência de parâmetros e caso não exista cria. |-----\\
	If !ExisteSx6("MGF_GFE61C")
		CriarSX6("MGF_GFE61C", "C", "API Status da carga no Multi Embarcador"	, "http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga" )	
	EndIf

	If !ExisteSx6("MGF_GFE61D")
		CriarSX6("MGF_GFE61D", "C", "Situacao da carga no Multi Embarcador"		, "EmTransporte|Encerrada" )	
	EndIf

	_cURLPost := GetMV('MGF_GFE61C',.F.,"http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga")

	If FunName() == "JOBGFE61" .OR. FunName() == "CTBA080"
		_cMemLog := "******************************************************************************************************************************"+Chr(10)+Chr(13)       
		_cMemLog += "             Inicio do processamento - MGFGFE61 - XML Inventti - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
		_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)

		oMemLog:Refresh() 
		oProcess:SetRegua1( Len(_aFiles) ) //Alimenta a primeira barra de progresso
	EndIf

	// Efetua o processamento normalmente, após a exclusão dos expirados de 30 dias ou mais
	For I := 1 To Len(_aFiles)

		U_MFCONOUT("- Processando arquivo - " + _aFiles[I] + " - " + strzero(i,6) + " de " + strzero(len(_afiles),6) + "..." )

		_lok := .F.

		If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
			//processamento da primeira barra de progresso
        	oProcess:IncRegua1("Processando Arquivo: "+ _aFiles[I])

			_cMemLog += "- Processando arquivo - " + _aFiles[I]+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf

		_cCteComp 	:= ""
		_aCarga		:= {}

		oXml 		:= XmlParserFile(_cPath+_aFiles[I], "_", @_cError, @_cWarning)
		_cTpCte		:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT

		If _cTpCte = "0" .and. TYPE('oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:TEXT') == 'U' .AND.;
				TYPE('oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[1]:_CHAVE:TEXT') == 'U'
			_cStatus := "- ERRO - arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" com erro de estrutura. Não localizado estrutura para o numero de nota " + ;
			               " Tag - oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:TEXT" + ;
						   " será copiado para "+ALLTRIM(_cPathexp+_aFiles[I])
			U_MFCONOUT(_cStatus)

			_lerroEst := .T.

		EndIf 
		
		If _cTpCte = "0" .and. !_lerroEst  	// Tipo de CTe: 0=CTe/1=Complemento
			_cTpChvs := VALTYPE(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE)
			If _cTpChvs = "O"	//Se é objeto existe apenas uma NF(Chave).
				_nQtdCHV := 1
			ElseIf _cTpChvs = "A"	//Se é array existe mais de uma NF (Chave) - Percorrer todos. 
				_nQtdCHV := LEN(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE)
			EndIf

			For N:=1 To _nQtdCHV
				If _cTpChvs = "O"
					_cChvNfe := RTRIM(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT)
				Else
					_cChvNfe := RTRIM(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[N]:_CHAVE:TEXT)
				EndIf

				U_MFCONOUT("- Analisando Chave da NFe: "+ _cChvNfe + " - " + STRZERO(N,6) + " de " + strzero(_nQtdCHV,6) + "..." )
				If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
					_cMemLog += "- Analisando Chave da NFe: "+ _cChvNfe + " - " + STRZERO(N,6) + " de " + strzero(_nQtdCHV,6) + "..."+Chr(10)+Chr(13)
					oMemLog:Refresh() 
				EndIf

				_cAliasSF2	:= GetNextAlias()

				BeginSql Alias _cAliasSF2

					SELECT  
     					F2_EMISSAO EMISSAO, F2_FILIAL FILIAL, F2_DOC NFISCAL, F2_SERIE SERIE, F2_CLIENTE CLIENTE, F2_LOJA LOJA
					FROM
						%Table:SF2% SF2
					WHERE
	    				SF2.F2_CHVNFE = %Exp:_cChvNfe%
						AND SF2.D_E_L_E_T_= ' ' 

				EndSql

				If (_cAliasSF2)->( !EOF() )	//Encontrei NFiscal de saida

					_cFilial	:= (_cAliasSF2)->FILIAL 
					_cNFiscal	:= (_cAliasSF2)->NFISCAL
					_cSerie		:= (_cAliasSF2)->SERIE
					_cCliente	:= (_cAliasSF2)->CLIENTE
					_cLoja		:= (_cAliasSF2)->LOJA
					_demissao   := stod((_cAliasSF2)->EMISSAO)
				
					//-----| Fechando area de trabalho |-----\\
					(_cAliasSF2)->(dbcloseArea())

					DAI->(dbSetOrder(3))
         			IF DAI->(dbSeek(_cFilial+_cNFiscal+_cSerie+_cCliente+_cLoja))

						If empty(alltrim(DAI->DAI_XPROTO))
							_cProtoco	:= ALLTRIM(DAI->DAI_XRETWS) 
						Else
							_cProtoco	:= ALLTRIM(DAI->DAI_XPROTO)
						Endif
						
						_cOrdEmb	:= ALLTRIM(DAI->DAI_COD)

						//-----| Fazendo a comunicação com o Barramento para validar cargas canceladas e expiradas|-----\\
						oObjRet 	:= nil
						oCarga 		:= nil
						oWSGFE61 	:= nil
						_cURLPost := GetMV('MGF_GFE61C',.F.,"http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga")

						ocarga := GFE61CARGA():new()
						ocarga:setDados()

						oWSGFE61 := MGFINT23():new(_cURLPost, ocarga,0, "", "", "", "","","", .T. )
						oWSGFE61:lLogInCons := .T.

						_cSavcInt	:= Nil
						_cSavcInt	:= __cInternet    
						__cInternet	:= "AUTOMATICO"
						oWSGFE61:SendByHttpPost()
						__cInternet := _cSavcInt
						_lvalido := .T.

						
						If oWSGFE61:lOk
							If fwJsonDeserialize(oWSGFE61:cPostRet , @oObjRet)	//Deserealiza gerando um objeto
								//Valida se carga está cancelada
								If "SituacaoCarga" $ oWSGFE61:cPostRet .AND.  VALTYPE(oObjRet:SituacaoCarga) == "C"	
								    //Verifica se retorno é válido.
									_cSitCarg := oObjRet:SituacaoCarga	//Guardo o retorno em variavel.
									If _cSitCarg $ ALLTRIM(SuperGetMV("MGF_GFE6F",.F.,"Cancelada"))
										
										_cStatus := "- Carga cancelada, chave:"+ALLTRIM(_cChvNfe)
										U_MFCONOUT(_cStatus)
										If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
											_cMemLog += _cStatus+Chr(10)+Chr(13)
											oMemLog:Refresh() 
										EndIf	

										aAdd(_aCarga, {2,_cFilial,_cProtoco,_cOrdEmb,_cCliente,_cLoja,_cSerie,_cNFiscal,_cStatus})
										_lvalido := .F.

									Elseif _demissao < date()- SuperGetMV("MGF_GFE61G",.F.,10)
										
										_cStatus := "- Carga expirada, chave:"+ALLTRIM(_cChvNfe)
										U_MFCONOUT(_cStatus)
										If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
											_cMemLog += _cStatus+Chr(10)+Chr(13)
											oMemLog:Refresh() 
										EndIf	

										aAdd(_aCarga, {3,_cFilial,_cProtoco,_cOrdEmb,_cCliente,_cLoja,_cSerie,_cNFiscal,_cStatus})
										_lvalido := .F.

									EndIf
								EndIf
							EndIf
						Endif

						//Fazendo nova comunicação com barramento para validar data de inicio de viagem
						If _lvalido

							_cURLPost := GetMV('MGF_GFE61H',.F.,"http://spdwvapl203:1672/multiembarcador/api/v1/verificainicioviagem")
							oObjRet 	:= nil
							oCarga 		:= nil
							oWSGFE61 	:= nil

							ocarga := GFE61CARGA():new()
							ocarga:setDados()

							oWSGFE61 := MGFINT23():new(_cURLPost, ocarga,0, "", "", "", "","","", .T. )
							oWSGFE61:lLogInCons := .T.

							_cSavcInt	:= Nil
							_cSavcInt	:= __cInternet    
							__cInternet	:= "AUTOMATICO"
							oWSGFE61:SendByHttpPost()
							__cInternet := _cSavcInt
							_lvalido := .F.

							If oWSGFE61:lOk
								If fwJsonDeserialize(oWSGFE61:cPostRet , @oObjRet)	//Deserealiza gerando um objeto
									If "Inicioviagem" $ oWSGFE61:cPostRet .AND.  VALTYPE(oObjRet:Inicioviagem) == "C"	
									    //Verifica se retorno é válido.
										_cInicio := oObjRet:Inicioviagem	//Guardo o retorno em variavel.
										_DINICIO := CTOD(SUBSTR(_CINICIO,1,10)) //Data de inicio de viagem
										_chorai := substr(_cinicio,12,8) //Hora de inicio de viagem
										If _dinicio > (date() - 90 ) .and. _dinicio <= date() .and. _chorai >= '00:00:00';
														 .and. (_chorai <= time() .or. _dinicio < date())
											//-----| Dados da Carga |-----\\
											_cStatus := "- Com inicio de viagem valido, chave:"+ALLTRIM(_cChvNfe) + " - " + _cInicio
											U_MFCONOUT(_cStatus)
											If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
												_cMemLog += _cStatus+Chr(10)+Chr(13)
												oMemLog:Refresh() 
											EndIf
											//-----| Array para guardar Status e dados de cada NF |-----\\
											aAdd(_aCarga, {1,_cFilial,_cProtoco,_cOrdEmb,_cCliente,_cLoja,_cSerie,_cNFiscal, _cStatus})
											_lvalido := .T.
										Endif
									Endif
								Endif
							Endif

							If !_lvalido
								_cStatus := "- FALHA NO FORMATO DO INICIO DE VIAGEM. ARQUIVO: "+ALLTRIM(_aFiles[I])+" NAO SERA MOVIDO."
								U_MFCONOUT(_cStatus)
								If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
									_cMemLog += _cStatus+Chr(10)+Chr(13)
									oMemLog:Refresh() 
								EndIf

								aAdd(_aCarga, {0,_cFilial,_cProtoco,_cOrdEmb,_cCliente,_cLoja,_cSerie,_cNFiscal,_cStatus})
							Endif

						Endif

					Else
						_cStatus := "- ERRO... NAO ENCONTRADA A NF: "+_cNFiscal+"-"+_cSerie+" NO ITENS DA CARGA(DAI)"
						U_MFCONOUT(_cStatus)
						If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
							_cMemLog += _cStatus+Chr(10)+Chr(13)
							oMemLog:Refresh() 
						EndIf	
						_lOk := .F.
						aAdd(_aCarga, {0,"","","",_cCliente,_cLoja,_cSerie,_cNFiscal,_cStatus})
					EndIf
				
				Else
					_cStatus := "- ERRO... NAO ENCONTRADA CHAVE DA NFe: "+_cChvNfe+"- XML: "+ALLTRIM(_aFiles[I])
					U_MFCONOUT(_cStatus)
					If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
						_cMemLog += _cStatus+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf	
					_lOk := .F.
					aAdd(_aCarga, {0,"","","","","",_cSerie,_cNFiscal,_cStatus})
				EndIf

			Next N

			_lCopia := .T. 	//Se pode copiar
			_lerro := .T. //Se copia para cancelado 
			_lexpirada := .F.
			For Y:=1 To LEN(_aCarga)
				If _aCarga[Y,1] != 1	//Se alguma nota não está ok no multiembarcador.
					_lCopia := .F.
				EndIf
				If _aCarga[Y,1] != 2	//Se alguma nota não está expirada ou com carga cancelada
					_lerro := .F.
				EndIf
				If _aCarga[Y,1] == 3	//Se carga está expirada
					_lexpirada := .T.
				EndIf
			Next Y

			_cPathTrs	:= ALLTRIM(SuperGetMV("MGF_GFE61B",.F.,"\INVENTTI\EMTRANSITO\"))

			If _lCopia
				_cPathTrs := _cPathTrs
			Endif

			If _lerro .or. _lexpirada
				_cPathTrs := _cPathexp
			Endif

			

			If _lCopia .or. _lerro .or. _lexpirada
				_lOk := .F.
				If __CopyFile(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPathTrs+_aFiles[I]))
					_cStatus := "- Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+ALLTRIM(_cPathTrs+_aFiles[I])
					U_MFCONOUT(_cStatus )
					If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
						_cMemLog += _cStatus+Chr(10)+Chr(13)
						oMemLog:Refresh() 
						_lOk := .T.
					EndIf

					If FILE(ALLTRIM(_cPathTrs+_aFiles[I]))	//Verifico se arquivo foi movido com sucesso.
						If FErase(ALLTRIM(_cPath+_aFiles[I])) == -1	//Apaga o arquivo na origem.
							_cStatus := "- Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I]) 
							U_MFCONOUT(_cStatus)
							If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
								_cMemLog += _cStatus+Chr(10)+Chr(13)
								oMemLog:Refresh() 
								_lOk := .F.
							EndIf
						Endif
					Else
						_cStatus := "- Falha ao mover o arquivo: "+ALLTRIM(_cPath+_aFiles[I]) 
						U_MFCONOUT(_cStatus)
						If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
							_cMemLog += _cStatus+Chr(10)+Chr(13)
							oMemLog:Refresh() 
							_lOk := .F.
						EndIf
					EndIf
				Else
					_cStatus := "- ERRO - arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" não foi copiado para "+ALLTRIM(_cPathTrs+_aFiles[I])
					U_MFCONOUT(_cStatus)
					If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
						_cMemLog += _cStatus+Chr(10)+Chr(13)
						oMemLog:Refresh() 
						_lOk := .F.
					EndIf
				EndIf
				If _lOk
					_cStatus := "- OK... CTe.: "+ALLTRIM(_aFiles[I])+" COM INICIO DE VIAGEM E LIBERADO."
					U_MFCONOUT(_cStatus)
					If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
						_cMemLog += _cStatus+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf
				EndIf
			EndIf
		Else
			_lOk := .F.

			If _lerroEst 
				_cPathTrs := _cPathexp
			Else
				U_MFCONOUT("CTE de complemento, será copiado automaticamente!")
			EndIf 

			If __CopyFile(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPathTrs+_aFiles[I]))
				If !_lerroEst 
					_cStatus := "- Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+ALLTRIM(_cPathTrs+_aFiles[I])
				EndIf

				U_MFCONOUT(_cStatus )
				If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
					_cMemLog += _cStatus+Chr(10)+Chr(13)
					oMemLog:Refresh() 
					_lOk := .T.
				EndIf

				If FILE(ALLTRIM(_cPathTrs+_aFiles[I]))	//Verifico se arquivo foi movido com sucesso.
					If FErase(ALLTRIM(_cPath+_aFiles[I])) == -1	//Apaga o arquivo na origem.
						_cStatus := "- Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I]) 
						U_MFCONOUT(_cStatus)
						If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
							_cMemLog += _cStatus+Chr(10)+Chr(13)
							oMemLog:Refresh() 
							_lOk := .F.
						EndIf
					Endif
				Else
					_cStatus := "- Falha ao mover o arquivo: "+ALLTRIM(_cPath+_aFiles[I]) 
					U_MFCONOUT(_cStatus)
					If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
						_cMemLog += _cStatus+Chr(10)+Chr(13)
						oMemLog:Refresh() 
						_lOk := .F.
					EndIf
				EndIf
			Else
				_cStatus := "- ERRO - arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" não foi copiado para "+ALLTRIM(_cPathTrs+_aFiles[I])
				U_MFCONOUT(_cStatus)
				If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
					_cMemLog += _cStatus+Chr(10)+Chr(13)
					oMemLog:Refresh() 
					_lOk := .F.
				EndIf
			EndIf
			If _lOk
				_cStatus := "- OK... CTe.: "+ALLTRIM(_aFiles[I])+" COMPLEMENTO DE FRETE EM TRANSITO E LIBERADO.""
				U_MFCONOUT(_cStatus)
				If FunName() = "JOBGFE61" .OR. FunName() = "CTBA080"
					_cMemLog += _cStatus+Chr(10)+Chr(13)
					oMemLog:Refresh() 
				EndIf
			EndIf

			_cFilial	:= ""
			_cProtoco	:= ""
			_cOrdEmb	:= ""
			_cCliente	:= ""
			_cLoja		:= ""
			_cNomArq 	:= RetFileName(_aFiles[I])
			_cSerie		:= SUBSTR(_cNomArq,23,03)
			_cNFiscal	:= SUBSTR(_cNomArq,26,09)
			_lOk 		:= .T.

			aAdd(_aCarga, {.F.,_cFilial,_cProtoco,_cOrdEmb,_cCliente,_cLoja,_cSerie,_cNFiscal,_cStatus})
		EndIf

		For Z:=1 To LEN(_aCarga)
			ZFV->(Reclock("ZFV",.T.))
				ZFV->ZFV_FILIAL := _aCarga[Z,2]
				ZFV->ZFV_PROTOC := _aCarga[Z,3]
				ZFV->ZFV_ORDEMB := _aCarga[Z,4]
				ZFV->ZFV_CLIENT := _aCarga[Z,5]
				ZFV->ZFV_LOJA   := _aCarga[Z,6]
				ZFV->ZFV_SERIE  := _aCarga[Z,7]
				ZFV->ZFV_NFISCA := _aCarga[Z,8]
				ZFV->ZFV_ARQXML := _aFiles[I] 
				
				If !(_cTpCte = "0" .and. !_lerroEst)
					ZFV->ZFV_STATUS :=  _cStatus
				Elseif _lCopia .or. _lerro .or. _lexpirada
					ZFV->ZFV_STATUS := _aCarga[Z,9] + _cStatus
				Else
					ZFV->ZFV_STATUS := _aCarga[Z,9]
				Endif

				ZFV->ZFV_DATA   := DATE()
				ZFV->ZFV_HORA   := TIME()
			ZFV->(MsUnLock())
		Next Z

	Next I

Return()

/*/
{Protheus.doc} GFE61CARGA
Faz comunicação com o Barramento via HTTP Post.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Class
@param	
@return
/*/
Class GFE61CARGA
	Data applicationArea   			as ApplicationArea
	Data ProtocoloIntegracaoCarga   as String

	Method New()
	Method setDados()
EndClass



/*/
{Protheus.doc} GFE61CARGA->new
Contrutor de Classe.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method new() Class GFE61CARGA
	self:applicationArea := ApplicationArea():new()
return

/*/
{Protheus.doc} GFE61CARGA->setDados
Metodo para pegar Protocolo de integração de carga.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method SetDados() Class GFE61CARGA
	Self:ProtocoloIntegracaoCarga := Alltrim(_cProtoco)
Return
