#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH"  
#include "COLORS.CH" 
#include "FWMVCDEF.CH"
/*/
{Protheus.doc} MGFINT72
Job para processar Automaticamente o TXT enviado pelo Despachante.

@description
Protheus - EXP - Rotina para processar automaticamente o arquivo .TXT enviado pelo despachante,  a rotina deverá ler 
todos arquivos da pasta especificada, gerando validações necessárias para a atualização da Capa do Embarque. 
Na atualização deverá considerar a Data de Saída do Navio também como a Data de Embarque, para que seja gerado os 
títulos no financeiro, obedecendo regras para geração dos títulos, tais como bloqueio de operacoes financeiras no Período.
As arquivos serão movidos para a pasta de Processados ou Erros.
Os itens com erros deverão gerar logs de erros e envio de e-mails a usuários definidos em parâmetros.

Exemplo de como montar o JOB:
;
[OnStart]
jobs=MGFINT72,...,....,...,...
RefreshRate=1800
;
[MGFINT72]
Environment=HML/PROD
Main=U_MGFINT72

@author Marcos Cesar Donizeti Vieira
@since 26/11/2019

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	EEC - Embarque
	
@param
@return

@menu
@history 
/*/

/*
@ Alterações: Tratamento para contornar erro na gravação do execauto. 
PRB MARFRIG	: PRB0040826
FNC Totvs	: 8828093 / 8806722
 a. Remover pontos comentados como FNC após correção da Totvs
 b. Remover programa MGFEEC80 após correção da Totvs.

@ Autor Henrique Vidal 
/*
@ Alterações: Tratamento para inibir tela de peso que fica apresentando no execauto.
            : Susbstítuido o PutMV( "MV_AVG0004", ".F." ) , pelo  tratamento no paramibx 'GETPESOS'.
			: No tratamento testa se for job, não mostra tela evitando pumv no parâmetro e, consequentemente  
			: impedindo processo manual. 
PRB MARFRIG	: PRB0040878
FNC Totvs	: 8828093 / 8806722
 a. Remover pontos comentados como FNC após correção da Totvs
 b. Remover programa GETPESOS no P.E. EECAP100_PE qdo a totvs corrigir execauto.

@ Autor Henrique Vidal 
/*/

User Function MGFINT72()
	Local cJob			:= ""		// Nome do semaforo que sera criado
	Local oLocker		:= Nil		// Objeto que ira criar um semaforo
	
	Private _aMatriz  	:= {"01","010001"}  
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"    
	Private _lJob		:= .T.                 

	IF _lIsBlind

		RpcSetType(3)
		RpcSetEnv(_aMatriz[1],_aMatriz[2])    

		cJob := "MGFINT72"
		oLocker := LJCGlobalLocker():New()

		If !oLocker:GetLock( cJob )
			Conout("JOB já em Execução: MGFINT72 " + DTOC(dDataBase) + " - " + TIME() )
			RpcClearEnv()
			Return
		EndIf       

		conOut("********************************************************************************************************************"		)       
		conOut('------- Inicio da Importação - MGFINT72 - Importação de Embarque - ' + DTOC(dDataBase) + " - " + TIME()						)
		conOut("********************************************************************************************************************"+ CRLF	)  

		//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
		If !ExisteSx6("MGF_INT72A")
			CriarSX6("MGF_INT72A", "C", "Caminho onde estarão os .TXT dos Despachantes", "\DESPACHANTE\" )	
		EndIf     

		U_INT72A()
		
		conOut("********************************************************************************************************************"		)       
		conOut("------- Fim da Importação - MGFINT72 - Importação de Embarque - " + DTOC(dDataBase) + " - " + TIME()  				  		)
		conOut("********************************************************************************************************************"+ CRLF	)       

		oLocker:ReleaseLock( cJob )
		RpcClearEnv()

	EndIF
Return()



/*/
{Protheus.doc} MONINT72
Inicializador via Monitor.

@author Marcos Cesar Donizeti Vieira
@since 26/11/2019

@type Function
@param	
@return
/*/
User Function MONINT72()
	Private oFont1  := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	Private oFont2  := TFont():New("MS Sans Serif",,012,,.T.,,,,,.F.,.F.)

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_INT72A")
		CriarSX6("MGF_INT72A", "C", "Caminho onde estarão os .TXT dos Despachantes", "\DESPACHANTE\" )	
	EndIf

	DEFINE MSDIALOG Dlg_ExtExec TITLE "Importação - Despachantes (DU-e)" From 000, 000  TO 620, 1350 PIXEL

		Public _cMemLog := ""
		Public oMemLog

		oSInfCli:= tSay():New(020,007,{||"MONITOR DE MENSAGENS"},Dlg_ExtExec,,oFont1,,,,.T.,CLR_HBLUE,,120,20)

		oButton := tButton():New(007,520,"Executar"	,Dlg_ExtExec, {|| INT72A() 			} ,65,17,,oFont2,,.T.)
		oButton := tButton():New(007,600,"Sair"		,Dlg_ExtExec, {|| Dlg_ExtExec:End()	} ,65,17,,oFont2,,.T.)

		@ 30,05 GET oMemLog VAR _cMemLog MEMO SIZE 665,270 OF Dlg_ExtExec PIXEL	
		oMemLog:lReadOnly := .T.

	ACTIVATE MSDIALOG Dlg_ExtExec CENTERED
Return



/*/
{Protheus.doc} INT72A
Inicializando processos para barras de processamento.

@author Marcos Cesar Donizeti Vieira
@since 16/12/2019

@type Function
@param	
@return
/*/
Static Function INT72A()
	Private oProcess
    oProcess := MsNewProcess():New( { || INT72B() } , "Importando arquivos DU-e" , "Aguarde..." , .F. )
    oProcess:Activate()
Return



/*/
{Protheus.doc} INT72B
Leitura dos arquivos e execução de rotina automática.

@author Marcos Cesar Donizeti Vieira
@since 26/11/2019

@type Function
@param	
@return
/*/
Static Function INT72B()
	Local _nOpen
	Local _cFilial
	Local _cPreemb
	Local _cUrfdsp
	Local _cUrfent
	Local _cNrodue
	Local _dDtdue
	Local _cChvdue
	Local _cNroruc
	Local _cNrconh
	Local _dDtconh
	Local _dDueavr
	Local _dZdtsna
	Local _nRetZip
	Local _dFechto
	
	Local _aFilesZip	:= {}
	Local _aCab			:= {}
	Local _nModExec 	:= nModulo
	Local _cModExec 	:= cModulo
	Local _lProcess 	:= .F.
	Local _lRet			:= .F.
	Local _cMens 		:= "" 
	Local _cStatus		:= ""
	Local _cLogWrt		:= ""
	Local _cArqEmail	:= ""
	Local _lEnvMail		:= .T.
	Local _cDesMail 	:= "" 
	Local _cNameArq 	:= ""
	Local _cNameRen		:= ""
	Local _cLogFile		:= ""
	Local _lOffShore 	:= .F.

	Local _cDirErr	:= ALLTRIM(SuperGetMV("MGF_INT72A",.F.,"\DESPACHANTE\"))+"Erro\"		// Pasta de gravação dos arquivos de erros.
	Local _cDirProc := ALLTRIM(SuperGetMV("MGF_INT72A",.F.,"\DESPACHANTE\"))+"Process\"		// Pasta de gravação dos arquivos processados
	Local _lContPar	:= SuperGetMV("MV_AVG0004")		// Parâmetro que habilita ou não a tela de solicitação dos Pesos.
		
	Local _cPath	:= ALLTRIM(SuperGetMV("MGF_INT72A",.F.,"\DESPACHANTE\"))
	Local _aFiles[ADIR(_cPath+"*.TXT")] 

	Private lEE7Auto 	:= .T.
	Private lMsErroAuto := .F.
	Private _aPrcOff := {}
	Private _nTamPEmb := TamSx3("EEC_PREEMB")[1]
	
	//PutMV( "MV_AVG0004", ".F." )		// Altera para Falso o conteúdo do parâmetro de conferência de pesos liquido e bruto na gravação.  

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_INT72B")
		CriarSX6("MGF_INT72B", "L", "Habilita envio de e-mail dos erros das Importacoes" , ".T." )	
	EndIf

	If !ExisteSx6("MGF_INT72C")
		CriarSX6("MGF_INT72C", "C", "Endereco de e-mail de quem recebera notificacoes " , "marcos.vieira@marfrig.com.br" )	
	EndIf

	_lEnvMail	:= SUPERGETMV("MGF_INT72B",.F., '.T.' )
	_cDesMail	:= Lower(ALLTRIM(SuperGetMV("MGF_INT72C",.F.,"marcos.vieira@marfrig.com.br")))

	ADIR(_cPath+"*.TXT",_aFiles)

	If nModulo <> 29
        nModulo := 29
        cModulo := "EEC"
    EndIf

	_cMemLog := "******************************************************************************************************************************"+Chr(10)+Chr(13)       
	_cMemLog += "             Inicio da Importação - MGFINT72 - Importação de Embarque - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)
	oMemLog:Refresh()

	oProcess:SetRegua1( Len(_aFiles) ) //Alimenta a primeira barra de progresso
	For I:=1 To Len(_aFiles)
		//processamento da primeira barra de progresso
        oProcess:IncRegua1("Processando Arquivo: "+ _aFiles[I])

		_nOpen := FT_FUSE(ALLTRIM(_cPath+_aFiles[I]))	
		If _nOpen > 0
			conOut("------- MGFINT72 - Importando arquivo - " + _aFiles[I]	)
			If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
				_cMemLog += "- Importando arquivo - " + _aFiles[I]+Chr(10)+Chr(13)
				oMemLog:Refresh() 
			EndIf

			_lProcess 	:= .F.	// Se processou o arquivo
			_cLogWrt	:= ""

			oProcess:SetRegua2( FT_fLastRec() ) //Alimenta a segunda barra de progresso
			FT_FGoTop()
			While !FT_FEOF() 
				_aCab		:= {}
				_aPrcOff	:= {} 

				_cLinha 	:= FT_FREADLN()
				
				_nPosFim 	:= AT( ";", _cLinha ) 
				_cFilial	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha ) 
				_cPreemb	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Processo
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				//processamento da segunda barra de progresso 
            	oProcess:IncRegua2("Processando Embarque: "+_cFilial+" - "+_cPreemb)

				conOut("------- MGFINT72 - Embarque -> " +_cFilial+" - "+_cPreemb )
				If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
					_cMemLog += "- Embarque -> " + _cFilial+" - "+_cPreemb+Chr(10)+Chr(13)
					oMemLog:Refresh() 
				EndIf

				_nPosFim 	:= AT( ";", _cLinha )
				_cUrfdsp	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// U.R.F. Despacho
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha )
				_cUrfent	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// U.R.F. Entrega
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha ) 
				_cNrodue	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Nro. da DUE
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha ) 
				_dDtdue		:= STOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))		// Dt. DUE
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha )
				_cChvdue	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Chave DUE
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha )
				_cNroruc	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Nro. RUC
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha ) 
				_cNrconh	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Nr.Conhecimento
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha ) 
				_dDtconh	:= STOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))		// Data Conhecimento
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha )
				_dDueavr	:= STOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))		// Data da Averbacao DUE
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

				_nPosFim 	:= AT( ";", _cLinha )
				_dZdtsna	:= STOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))		// Data Saida Navio
				_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))
				
				cFilAnt 	:= _cFilial
				_dFechto	:= SuperGetMV("MV_DATAFIN") 	// Data limite para realizacao de operacoes financeiras.
				
				If !Empty(_dZdtsna) 
					If _dFechto >= _dZdtsna			// Verifica se o período esta fechado para realização de operações financeiras,
						_dZdtsna := _dFechto + 1 	// caso esteja, pega próximo dia ao período fechado.
					EndIf 
				EndIf 

				//Dados da Capa do Embarque
				_aCab := {	{"EEC_FILIAL"   , _cFilial					, NIL	},;
							{"EEC_PREEMB"   , Padr(_cPreemb,_nTamPEmb)	, NIL	},;
							{"EEC_URFDSP"   , _cUrfdsp					, NIL	},;
							{"EEC_URFENT"   , _cUrfent					, NIL	},;
							{"EEC_NRODUE"   , _cNrodue					, NIL	},;
							{"EEC_DTDUE"    , _dDtdue					, NIL	},;
							{"EEC_CHVDUE"   , _cChvdue					, NIL	},;
							{"EEC_NRORUC"   , _cNroruc					, NIL	},;
							{"EEC_NRCONH"   , _cNrconh					, NIL	},;
							{"EEC_DTCONH"   , _dDtconh					, NIL	},;
							{"EEC_DUEAVR"   , _dDueavr					, NIL	},;
							{"EEC_DTEMBA"   , _dZdtsna					, NIL	},;
							{"EEC_ZDTSNA"   , _dZdtsna					, NIL	}}

				EEC->(dbSetOrder(1))
      			If EEC->(dbSeek(_cFilial+Padr(_cPreemb,_nTamPEmb),.F.))	
					If EMPTY(EEC->EEC_DTENDC)	// Se não houver aprovação dos Documentos, preencho com a data de saida do navio.
						EEC->(Reclock("EEC",.F.))
						EEC->EEC_DTENDC := _dZdtsna
						EEC->(MsUnLock())
					EndIf	

					If EEC->EEC_INTERM = "1"
						_lOffShore := .T.    
					EndIf

					/*Bloco para voltar valores dos campos listados abaixo, o padrão totvs está zerando os campos erroneamente após executar o MsExecAuto. 
					FNC 8828093 / 8806722 . Remover após correção da FNC.*/ 
					_c0Cli 		:= EEC->EEC_CLIENT 
					_c0Export 	:= EEC->EEC_EXPORT
					_c0Interm	:= EEC->EEC_INTERM
					_c0Cond2 	:= EEC->EEC_COND2
					_c0CliLj 	:= EEC->EEC_CLLOJA
					_c0Dias2 	:= EEC->EEC_DIAS2
					_c0Inc02 	:= EEC->EEC_INCO2
					_c0ExLj 	:= EEC->EEC_EXLOJA
					_c0Perc 	:= EEC->EEC_PERC
					_c0Zseg 	:= EEC->EEC_ZSEGUR
					_c0ZFrete 	:= EEC->EEC_ZFRETE
					_c0Incote 	:= EEC->EEC_INCOTE

					If EMPTY(EEC->EEC_DTEMBA)	// Se o embarque não foi preenchido, atualiza com MSEXECAUTO.
						MsExecAuto({|x,y| EECAE100(,x,y)} , 4, {{"EEC", _aCab}} )	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão	
											
						/*FNC 8828093 / 8806722 - Remover após correção da Totvs */ 
						EEC->(Reclock("EEC",.F.))
							EEC->EEC_CLIENT := _c0Cli 
							EEC->EEC_EXPORT	:= _c0Export
							EEC->EEC_INTERM := _c0Interm
							EEC->EEC_COND2  := _c0Cond2 
							EEC->EEC_CLLOJA := _c0CliLj 
							EEC->EEC_DIAS2  := _c0Dias2 	
							EEC->EEC_INCO2  := _c0Inc02 
							EEC->EEC_EXLOJA := _c0ExLj 	
							EEC->EEC_PERC	:= _c0Perc
							EEC->EEC_ZSEGUR := _c0Zseg 	
							EEC->EEC_ZFRETE := _c0ZFrete 
							EEC->EEC_INCOTE	:= _c0Incote 
						EEC->(MsUnLock())

						If lMsErroAuto  // Com novo patch, está gravando e retornando erro em branco aberto FNC XXX
							_cMens := MostraErro("/dirdoc", "error.log")
							If Empty(_cMens)
								lMsErroAuto := .F.
							EndIf
						EndIf

						If lMsErroAuto
							If (!IsBlind())	// Com interface gráfica.
								//MostraErro()
								_cMens := MostraErro("/dirdoc", "error.log")
							Else // EM ESTADO DE JOB
								_cMens := MostraErro("/dirdoc", "error.log")	// Armazena a mensagem de erro.
						
								ConOut(PadC("Automatic routine ended with error", 80))
								ConOut("Erro: "+ _cMens)
							EndIf
							_cStatus	:= "2"

							//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
							_cLogWrt	+= "Filial: "+_cFilial+" - Processo: "+_cPreemb+" - Arquivo: "+ _aFiles[I]+" - Erro: "+ _cMens+Chr(10)+Chr(13)
					
						Else
							conOut("------- MGFINT72 - Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13) )
							If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
								_cMemLog += "- Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13)
								oMemLog:Refresh() 
							EndIf
							_cStatus	:= "1"
							_cMens 		:= "Atualização de Embarque realizado com sucesso." 

							If _lOffShore	//Aplica atualizações para OffShore
								//processamento da segunda barra de progresso 
								oProcess:IncRegua2("Processando Embarque OffShore: "+"900001"+" - "+_cPreemb)

								conOut("------- MGFINT72 - Atualizando OffShore - Embarque -> " +"900001"+" - "+_cPreemb )
								If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
									_cMemLog += "- Atualizando OffShore - Embarque -> " +"900001"+" - "+_cPreemb+Chr(10)+Chr(13)
									oMemLog:Refresh() 
								EndIf

								EEC->(dbSetOrder(1))
								If EEC->(dbSeek("900001"+Padr(_cPreemb,_nTamPEmb),.F.))	
									If EMPTY(EEC->EEC_DTENDC)	// Se não houver aprovação dos Documentos, preencho com a data de saida do navio.
										EEC->(Reclock("EEC",.F.))
										EEC->EEC_DTENDC := _dZdtsna
										EEC->(MsUnLock())
									EndIf

									If EMPTY(EEC->EEC_DTEMBA)	// Se o embarque não foi preenchido, atualiza com MSEXECAUTO.

										_c0Cli 		:= EEC->EEC_CLIENT /*FNC 8828093 / 8806722 - Remover após correção da Totvs */ 
										_c0Export 	:= EEC->EEC_EXPORT
										_c0Interm	:= EEC->EEC_INTERM
										_c0Cond2 	:= EEC->EEC_COND2
										_c0CliLj 	:= EEC->EEC_CLLOJA
										_c0Dias2 	:= EEC->EEC_DIAS2
										_c0Inc02 	:= EEC->EEC_INCO2
										_c0ExLj 	:= EEC->EEC_EXLOJA
										_c0Perc 	:= EEC->EEC_PERC
										_c0Zseg 	:= EEC->EEC_ZSEGUR
										_c0ZFrete 	:= EEC->EEC_ZFRETE
										_c0Incote 	:= EEC->EEC_INCOTE

										//Dados da Capa do Embarque
										_aCab := {	{"EEC_FILIAL"   , "900001"					, NIL	},;
													{"EEC_PREEMB"   , Padr(_cPreemb,_nTamPEmb)	, NIL	},;
													{"EEC_URFDSP"   , _cUrfdsp					, NIL	},;
													{"EEC_URFENT"   , _cUrfent					, NIL	},;
													{"EEC_NRODUE"   , _cNrodue					, NIL	},;
													{"EEC_DTDUE"    , _dDtdue					, NIL	},;
													{"EEC_CHVDUE"   , _cChvdue					, NIL	},;
													{"EEC_NRORUC"   , _cNroruc					, NIL	},;
													{"EEC_NRCONH"   , _cNrconh					, NIL	},;
													{"EEC_DTCONH"   , _dDtconh					, NIL	},;
													{"EEC_DUEAVR"   , _dDueavr					, NIL	},;
													{"EEC_DTEMBA"   , _dZdtsna					, NIL	},;
													{"EEC_ZDTSNA"   , _dZdtsna					, NIL	}}

										cFilAnt := "900001"
										
										MsExecAuto({|x,y| EECAE100(,x,y)} , 4, {{"EEC", _aCab}} )	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão	

										EEC->(Reclock("EEC",.F.)) /*FNC 8828093 / 8806722 - Remover após correção da Totvs */ 
											EEC->EEC_CLIENT := _c0Cli 
											EEC->EEC_EXPORT	:= _c0Export
											EEC->EEC_INTERM := _c0Interm
											EEC->EEC_COND2  := _c0Cond2 
											EEC->EEC_CLLOJA := _c0CliLj 
											EEC->EEC_DIAS2  := _c0Dias2 	
											EEC->EEC_INCO2  := _c0Inc02 
											EEC->EEC_EXLOJA := _c0ExLj 	
											EEC->EEC_PERC	:= _c0Perc
											EEC->EEC_ZSEGUR := _c0Zseg 	
											EEC->EEC_ZFRETE := _c0ZFrete 
											EEC->EEC_INCOTE	:= _c0Incote 
										EEC->(MsUnLock())

										If lMsErroAuto  // Com novo patch, está gravando e retornando erro em branco aberto FNC XXX
											_cMens := MostraErro("/dirdoc", "error.log")
											If Empty(_cMens)
												lMsErroAuto := .F.
											EndIf
										EndIf
										
										If lMsErroAuto
											If (!IsBlind())	// Com interface gráfica.
												//MostraErro()
												_cMens := MostraErro("/dirdoc", "error.log")
											Else // EM ESTADO DE JOB
												_cMens := MostraErro("/dirdoc", "error.log")	// Armazena a mensagem de erro.
										
												ConOut(PadC("Automatic routine ended with error", 80))
												ConOut("Erro: "+ _cMens)
											EndIf
											_cStatus	:= "2"

											//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
											_cLogWrt	+= "Filial: "+"900001"+" - Processo OffShore: "+_cPreemb+" - Arquivo: "+ _aFiles[I]+" - Erro: "+ _cMens+Chr(10)+Chr(13)
									
										Else
											conOut("------- MGFINT72 - Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13) )
											If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
												_cMemLog += "- Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13)
												oMemLog:Refresh() 
											EndIf
											_cStatus	:= "1"
											_cMens 		:= "Atualização de Embarque OffShore realizado com sucesso." 

										EndIf
										
									Else	// Se o embarque foi preenchido, atualiza campos com RECLOCK, pois com MSEXECAUTO é validado e deixa alterar apenas com confirmação.
										EEC->(Reclock("EEC",.F.))
											If EMPTY(EEC->EEC_DTCONH) .AND. !EMPTY(_dDtconh)
												EEC->EEC_DTCONH := _dDtconh
											EndIf

											If EMPTY(EEC->EEC_NRCONH) .AND. !EMPTY(_cNrconh)
												EEC->EEC_NRCONH := _cNrconh
											EndIf

											If EMPTY(EEC->EEC_DUEAVR) .AND. !EMPTY(_dDueavr)
												EEC->EEC_DUEAVR := _dDueavr
											EndIf	

											If EMPTY(EEC->EEC_URFENT) .AND. !EMPTY(_cUrfent)
												EEC->EEC_URFENT := _cUrfent
											EndIf

											If EMPTY(EEC->EEC_NRODUE) .AND. !EMPTY(_cNrodue)						
												EEC->EEC_NRODUE := _cNrodue
											EndIf

											If EMPTY(EEC->EEC_DTDUE) .AND. !EMPTY(_dDtdue)
												EEC->EEC_DTDUE := _dDtdue
											EndIf

											If EMPTY(EEC->EEC_CHVDUE) .AND. !EMPTY(_cChvdue)
												EEC->EEC_CHVDUE := _cChvdue
											EndIf

											If EMPTY(EEC->EEC_NRORUC) .AND. !EMPTY(_cNroruc)
												EEC->EEC_NRORUC := _cNroruc						
											EndIf
										EEC->(MsUnLock())

										conOut("------- MGFINT72 - Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13) )
										If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
											_cMemLog += "- Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13)
											oMemLog:Refresh() 
										EndIf
										_cStatus	:= "1"
										_cMens 		:= "Atualização de Embarque realizado com sucesso." 
									EndIf
								EndIf
							EndIf

						EndIf		
					Else	// Se o embarque foi preenchido, atualiza campos com RECLOCK, pois com MSEXECAUTO é validado e deixa alterar apenas com confirmação.
						EEC->(Reclock("EEC",.F.))
							If EMPTY(EEC->EEC_DTCONH) .AND. !EMPTY(_dDtconh)
								EEC->EEC_DTCONH := _dDtconh
							EndIf

							If EMPTY(EEC->EEC_NRCONH) .AND. !EMPTY(_cNrconh)
								EEC->EEC_NRCONH := _cNrconh
							EndIf

							If EMPTY(EEC->EEC_DUEAVR) .AND. !EMPTY(_dDueavr)
								EEC->EEC_DUEAVR := _dDueavr
							EndIf	

							If EMPTY(EEC->EEC_URFENT) .AND. !EMPTY(_cUrfent)
								EEC->EEC_URFENT := _cUrfent
							EndIf

							If EMPTY(EEC->EEC_NRODUE) .AND. !EMPTY(_cNrodue)						
								EEC->EEC_NRODUE := _cNrodue
							EndIf

							If EMPTY(EEC->EEC_DTDUE) .AND. !EMPTY(_dDtdue)
								EEC->EEC_DTDUE := _dDtdue
							EndIf

							If EMPTY(EEC->EEC_CHVDUE) .AND. !EMPTY(_cChvdue)
								EEC->EEC_CHVDUE := _cChvdue
							EndIf

							If EMPTY(EEC->EEC_NRORUC) .AND. !EMPTY(_cNroruc)
								EEC->EEC_NRORUC := _cNroruc						
							EndIf
						EEC->(MsUnLock())

						If _lOffShore	//Aplica atualizações para OffShore
							//processamento da segunda barra de progresso 
            				oProcess:IncRegua2("Processando Embarque OffShore: "+"900001"+" - "+_cPreemb)
							conOut("------- MGFINT72 - Atualizando OffShore - Embarque -> " +"900001"+" - "+_cPreemb )
							If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
								_cMemLog += "- Atualizando OffShore - Embarque -> " +"900001"+" - "+_cPreemb+Chr(10)+Chr(13)
								oMemLog:Refresh() 
							EndIf

							EEC->(dbSetOrder(1))
							If EEC->(dbSeek("900001"+Padr(_cPreemb,_nTamPEmb),.F.))	
								If EMPTY(EEC->EEC_DTENDC)	// Se não houver aprovação dos Documentos, preencho com a data de saida do navio.
									EEC->(Reclock("EEC",.F.))
									EEC->EEC_DTENDC := _dZdtsna
									EEC->(MsUnLock())
								EndIf

								If EMPTY(EEC->EEC_DTEMBA)	// Se o embarque não foi preenchido, atualiza com MSEXECAUTO.

									_c0Cli 		:= EEC->EEC_CLIENT /*FNC 8828093 / 8806722 - Remover após correção da Totvs */ 
									_c0Export 	:= EEC->EEC_EXPORT
									_c0Interm	:= EEC->EEC_INTERM
									_c0Cond2 	:= EEC->EEC_COND2
									_c0CliLj 	:= EEC->EEC_CLLOJA
									_c0Dias2 	:= EEC->EEC_DIAS2
									_c0Inc02 	:= EEC->EEC_INCO2
									_c0ExLj 	:= EEC->EEC_EXLOJA
									_c0Perc 	:= EEC->EEC_PERC
									_c0Zseg 	:= EEC->EEC_ZSEGUR
									_c0ZFrete 	:= EEC->EEC_ZFRETE
									_c0Incote 	:= EEC->EEC_INCOTE

									//Dados da Capa do Embarque
									_aCab := {	{"EEC_FILIAL"   , "900001"					, NIL	},;
												{"EEC_PREEMB"   , Padr(_cPreemb,_nTamPEmb)	, NIL	},;
												{"EEC_URFDSP"   , _cUrfdsp					, NIL	},;
												{"EEC_URFENT"   , _cUrfent					, NIL	},;
												{"EEC_NRODUE"   , _cNrodue					, NIL	},;
												{"EEC_DTDUE"    , _dDtdue					, NIL	},;
												{"EEC_CHVDUE"   , _cChvdue					, NIL	},;
												{"EEC_NRORUC"   , _cNroruc					, NIL	},;
												{"EEC_NRCONH"   , _cNrconh					, NIL	},;
												{"EEC_DTCONH"   , _dDtconh					, NIL	},;
												{"EEC_DUEAVR"   , _dDueavr					, NIL	},;
												{"EEC_DTEMBA"   , _dZdtsna					, NIL	},;
												{"EEC_ZDTSNA"   , _dZdtsna					, NIL	}}

									cFilAnt := "900001"
									
									MsExecAuto({|x,y| EECAE100(,x,y)} , 4, {{"EEC", _aCab}} )	// 3 - Inclusao, 4 - Alteração, 5 - Exclusão	
									
									EEC->(Reclock("EEC",.F.)) /*FNC 8828093 / 8806722- Remover após correção da Totvs */ 
										EEC->EEC_CLIENT := _c0Cli 
										EEC->EEC_EXPORT	:= _c0Export
										EEC->EEC_INTERM := _c0Interm
										EEC->EEC_COND2  := _c0Cond2 
										EEC->EEC_CLLOJA := _c0CliLj 
										EEC->EEC_DIAS2  := _c0Dias2 	
										EEC->EEC_INCO2  := _c0Inc02 
										EEC->EEC_EXLOJA := _c0ExLj 	
										EEC->EEC_PERC	:= _c0Perc
										EEC->EEC_ZSEGUR := _c0Zseg 	
										EEC->EEC_ZFRETE := _c0ZFrete 
										EEC->EEC_INCOTE	:= _c0Incote 
									EEC->(MsUnLock())
									
									If lMsErroAuto
										If (!IsBlind())	// Com interface gráfica.
											//MostraErro()
											_cMens := MostraErro("/dirdoc", "error.log")
										Else // EM ESTADO DE JOB
											_cMens := MostraErro("/dirdoc", "error.log")	// Armazena a mensagem de erro.
									
											ConOut(PadC("Automatic routine ended with error", 80))
											ConOut("Erro: "+ _cMens)
										EndIf
										_cStatus	:= "2"

										//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
										_cLogWrt	+= "Filial: "+"900001"+" - Processo OffShore: "+_cPreemb+" - Arquivo: "+ _aFiles[I]+" - Erro: "+ _cMens+Chr(10)+Chr(13)
								
									Else
										conOut("------- MGFINT72 - Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13) )
										If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
											_cMemLog += "- Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13)
											oMemLog:Refresh() 
										EndIf
										_cStatus	:= "1"
										_cMens 		:= "Atualização de Embarque OffShore realizado com sucesso." 

									EndIf
									
								Else	// Se o embarque foi preenchido, atualiza campos com RECLOCK, pois com MSEXECAUTO é validado e deixa alterar apenas com confirmação.
									EEC->(Reclock("EEC",.F.))
										If EMPTY(EEC->EEC_DTCONH) .AND. !EMPTY(_dDtconh)
											EEC->EEC_DTCONH := _dDtconh
										EndIf

										If EMPTY(EEC->EEC_NRCONH) .AND. !EMPTY(_cNrconh)
											EEC->EEC_NRCONH := _cNrconh
										EndIf

										If EMPTY(EEC->EEC_DUEAVR) .AND. !EMPTY(_dDueavr)
											EEC->EEC_DUEAVR := _dDueavr
										EndIf	

										If EMPTY(EEC->EEC_URFENT) .AND. !EMPTY(_cUrfent)
											EEC->EEC_URFENT := _cUrfent
										EndIf

										If EMPTY(EEC->EEC_NRODUE) .AND. !EMPTY(_cNrodue)						
											EEC->EEC_NRODUE := _cNrodue
										EndIf

										If EMPTY(EEC->EEC_DTDUE) .AND. !EMPTY(_dDtdue)
											EEC->EEC_DTDUE := _dDtdue
										EndIf

										If EMPTY(EEC->EEC_CHVDUE) .AND. !EMPTY(_cChvdue)
											EEC->EEC_CHVDUE := _cChvdue
										EndIf

										If EMPTY(EEC->EEC_NRORUC) .AND. !EMPTY(_cNroruc)
											EEC->EEC_NRORUC := _cNroruc						
										EndIf
									EEC->(MsUnLock())

									conOut("------- MGFINT72 - Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13) )
									If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
										_cMemLog += "- Atualização de Embarque OffShore realizado com sucesso: "+Chr(10)+Chr(13)
										oMemLog:Refresh() 
									EndIf
									 
								EndIf
							EndIf
						EndIf

						conOut("------- MGFINT72 - Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13) )
						If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
							_cMemLog += "- Atualização de Embarque realizado com sucesso: "+Chr(10)+Chr(13)
							oMemLog:Refresh() 
						EndIf
						_cStatus	:= "1"
						_cMens 		:= "Atualização de Embarque realizado com sucesso." 
					EndIf
				Else
					_cStatus	:= "2"
					_cMens 		:= "Processo de Embarque não encontrado no Protheus: Filial: "+_cFilial+" - Processo: "+_cPreemb+" 

					//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
					_cLogWrt	+= "Filial: "+_cFilial+" - Processo: "+_cPreemb+" - Arquivo: "+ _aFiles[I]+" - Erro: Processo de Embarque não encontrado no Protheus."+Chr(10)+Chr(13)

					ConOut("Error: "+ _cMens)
					If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
						_cMemLog += "- Processo de Embarque não encontrado no Protheus: Filial: "+_cFilial+" - Processo: "+_cPreemb+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf
				EndIf

				_lProcess := .T.

				//

				//-----| Gera log de processamento para consulta no Monitor de Integrações |-----\\
				U_MGFMONITOR(	_cFilial 		,;
								_cStatus		,;
								"009"			,; 
								"001" 			,;
								_cMens			,;
								"Proc.: "+_cPreemb+" - "+_aFiles[I]	,; 
								"0" 			,;
								""				,;
								0	)

				FT_FSKIP()
			EndDo
			
			FT_FGoTop()
			While !FT_FEOF()
				_cLichk := FT_FREADLN()
				_cMemLog += xValidInt()
				FT_FSKIP()
			EndDo 

			FClose(_aFiles[I])
			
			If  _lProcess
				If !Empty(_cLogWrt)
					_cNameArq	:= SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-4)
					_cLogFile	:= _cDirErr+"Err_"+_cNameArq+".LOG"
					nHandle   	:= MSFCreate(_cLogFile,0)
					FWrite(nHandle,_cLogWrt)
					FClose(nHandle)

					conOut("------- MGFINT72 - LOG de erro gerado em "+_cLogFile+Chr(10)+Chr(13) )
					If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
						_cMemLog += "- LOG de erro gerado em "+_cLogFile+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf
					FT_FUSE()

					If _lEnvMail	// Se envia e-mail com os erros.						
						_cArqEmail	:= _cPath+"DespArq_"+Dtos(dDataBAse)+"_"+StrTran(Time(),":","") + ".ZIP"
						_aFilesZip	:= {_cLogFile,_cPath+_aFiles[I]}
						_nRetZip	:= FZip(_cArqEmail,_aFilesZip,_cPath)

						If _nRetZip != 0	// Se não gerou arquivo .ZIP, envio apenas o arq. de Log.
							_cArqEmail := _cLogFile 
						EndIf
						
						U_MGFENVMAIL(_cDesMail,_cArqEmail,_aFiles[I])

						If _nRetZip = 0		// Se gerou arquivo .ZIP, apago depois do envio.
							FErase(_cArqEmail)
						EndIf
					EndIF
				EndIf
				
				If __CopyFile(ALLTRIM(_cPath+_aFiles[I]) , _cDirProc+"Process_"+_aFiles[I])
					conOut("------- MGFINT72 - Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+_cDirProc+"Process_"+_aFiles[I]+Chr(10)+Chr(13) )
					If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
						_cMemLog += "- Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+_cDirProc+"Process_"+_aFiles[I]+Chr(10)+Chr(13) 
						oMemLog:Refresh() 
					EndIf

					If FErase(ALLTRIM(_cPath+_aFiles[I])) == -1
						conOut("------- MGFINT72 - Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13) )
						If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
							_cMemLog += "- Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13) 
							oMemLog:Refresh() 
						EndIf
						_cNameRen := SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-3)+"err"
						FRename(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPath+_cNameRen) )
						conOut("------- MGFINT72 - Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13) )
						If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
							_cMemLog += "- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13)
							oMemLog:Refresh() 
						EndIf
					Endif
				Else
					_cNameRen := SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-3)+"err"
					FRename(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPath+_cNameRen) )
					conOut("------- MGFINT72 - Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13) )
					If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
						_cMemLog += "- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13)
						oMemLog:Refresh() 
					EndIf
				EndIf
			EndIf
		Else
			conOut("Falha na abertura do arquivo: "+ALLTRIM(_cPath+_aFiles[I]) )
			If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
				_cMemLog += "- Falha na abertura do arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13)
				oMemLog:Refresh() 
			EndIf
		EndIf
	Next

	If Len(_aFiles) = 0
		conOut("Não há arquivos para importação.")
		If FunName() = "MONINT72" .OR. FunName() = "CTBA080"
			_cMemLog += "- Não há arquivos para importação."+Chr(10)+Chr(13)
			oMemLog:Refresh() 
		EndIf
	EndIf

	If nModulo <> _nModExec
        nModulo := _nModExec
        cModulo := _cModExec
    EndIf

	//PutMV( "MV_AVG0004", _lContPar )	// Volta conteudo anterior para o parâmetro de conferência de pesos liquido e bruto na gravação.  

	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)       
	_cMemLog += "             Fim da Importação - MGFINT72 - Importação de Embarque - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)
	
	oMemLog:Refresh() 

	MsgInfo("Importação finalizada.")

Return NIL



/*/
{Protheus.doc} MGFENVMAIL
Envia e-mail com erros do arquivo Importado.

@author Marcos Cesar Donizeti Vieira
@since 04/11/2019

@type Function
@param 
	_cPara 		- Destinatários do e-mail
	_cAnexo		- Arquivo que será enviado como anexo
	_cArqProc	- Arquivo que esta sendo processado.
@return
/*/
User Function MGFENVMAIL(_cPara,_cAnexo,_cArqProc)

	Local oMail, oMessage
	Local _nErro		:= 0
	Local _lRetMail		:= .T.
	Local _cSmtpSrv		:= GETMV("MGF_SMTPSV")
	Local _cCtMail  	:= GETMV("MGF_CTMAIL")
	Local _cPwdMail 	:= GETMV("MGF_PWMAIL")
	Local _nMailPort 	:= GETMV("MGF_PTMAIL")
	Local _nParSmtpP 	:= GETMV("MGF_PTSMTP")
	Local _nTimeOut  	:= GETMV("MGF_TMOUT")
	Local _cEmail    	:= GETMV("MGF_EMAIL")
	Local _nSmtpPort
	Local _cErrMail
	Local _cHtml
	Local _cHist

	_cHist := "Segue arquivo com erros identificados na importação do arquivo disponibilizado pelo Despachante."

	_cHtml := ""
	_cHtml += "<HTML>"
	_cHtml += "<HEAD>"
	_cHtml += "	<META HTTP-EQUIV='CONTENT-TYPE' CONTENT='text/html; charset=utf-8'>"
	_cHtml += "	<TITLE></TITLE>"
	_cHtml += "	<META NAME='GENERATOR' CONTENT='Marfrig Food'>"
	_cHtml += "	<META NAME='CREATED' CONTENT='0;0'>"
	_cHtml += "	<META NAME='CHANGED' CONTENT='0;0'>"
	_cHtml += "	<STYLE TYPE='text/html'>"
	_cHtml += "	<!--"
	_cHtml += "		@page { margin: 0.79in }"
	_cHtml += "		P { margin-bottom: 0.08in }"
	_cHtml += "		PRE.ctl { font-family: 'arial black', 'avant garde'; font-size: medium; color: #ff0000 }"
	_cHtml += "	-->"
	_cHtml += "	</STYLE>"
	_cHtml += "</HEAD>"
	_cHtml += "<BODY LANG='pt-BR' DIR='LTR'>"
	_cHtml += "<P><font face = 'verdana' size='5'><strong>ERRO NA IMPORTACAO AUTOMATICA DU-E</strong></font></p>"+CRLF
	_cHtml += CRLF+"<P><font face = 'verdana' size='3'>ARQUIVO: "+_cArqProc+"</font></p>"
	_cHtml += "<P><font face = 'verdana' size='3' color='blue'><strong>[MGFINT72] Importacao de DUE</strong></font></p>"
	_cHtml += CRLF+"<P><font face = 'verdana' size='3' color='blue'><strong>"+_cHist+"</strong></font></p>"
	_cHtml += CRLF+"<P><font face = 'verdana' size='3'>E-mail apenas informativo.</font></p>"
	_cHtml += "</BODY>"
	_cHtml += "</HTML>"

	oMail := TMailManager():New()

	if _nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", _cSmtpSrv, _cCtMail, _cPwdMail,, _nParSmtpP)
	elseif _nParSmtpP == 465
		_nSmtpPort := _nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", _cSmtpSrv, _cCtMail, _cPwdMail,, _nSmtpPort)
	else
		_nParSmtpP == 587
		_nSmtpPort := _nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", _cSmtpSrv, _cCtMail, _cPwdMail,, _nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( _nTimeOut )
	_nErro := oMail:SmtpConnect()

	If _nErro != 0
		_cErrMail :=("ERROR:" + oMail:GetErrorString(_nErro))
		conout(_cErrMail)
		//Alert(_cErrMail)
		oMail:SMTPDisconnect()
		_lRetMail := .F.
		Return (_lRetMail)
	Endif

	If 	_nParSmtpP != 25
		_nErro := oMail:SmtpAuth(_cCtMail, _cPwdMail)
		If _nErro != 0
			_cErrMail :=("ERROR:" + oMail:GetErrorString(_nErro))
			conout(_cErrMail)
			oMail:SMTPDisconnect()
			_lRetMail := .F.
			Return (_lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := _cEmail
	oMessage:cTo                    := _cPara
	oMessage:cCc                    := ""
	oMessage:cSubject               := "[MARFRIG] Aviso de erros na Importação de arquivos de Despachante (DUE)"
	oMessage:cBody                  := _cHtml	
	oMessage:AttachFile( _cAnexo )

	_nErro := oMessage:Send( oMail )

	if _nErro != 0
		_cErrMail :=("ERROR:" + oMail:GetErrorString(_nErro))
		conout(_cErrMail)
		//Alert(_cErrMail)
		oMail:SMTPDisconnect()
		_lRetMail := .F.
		Return (_lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return

Static Function xValidInt()

	Local cChkInt	:= ''

	Local nPURFDSP := 3   //Posição Urfdsp no txt
	Local nPURFENT := 4	  //Posição Urfent no txt	
	Local nPNRODUE := 5   //Posição NroDue no txt
	Local nPDTDUE  := 6   //Posição DtDue no txt
	Local nPCHVDUE := 7   //Posição ChvDue no txt
	Local nPNRORUC := 8   //Posição NroRuc no txt
	Local nPDUEAVR := 11  //Posição DueAvr no txt
	Local nPNRCONH := 9   //Posição NrConh no txt
	Local nPDTCONH := 10  //Posição Dtconh no txt
	Local nPZDTSNA := 12  //Posição Dtsna no txt
	
	Private aCampos := Separa(_cLichk,";",.T.)

	If !Empty(aCampos)
		
		dbSelectArea('EEC')
		EEC->(dbSetOrder(1))
      	If EEC->(dbSeek(aCampos[1]+Padr(aCampos[2],_nTamPEmb)))	

			If 	Alltrim(aCampos[nPURFDSP ] )  <> Alltrim(EEC_URFDSP)
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da U.R.F. Despacho  difere do valor informado no arquivo, por favor rever!!"	+ Chr(10)+Chr(13)
			EndIf

			If Alltrim(aCampos[nPURFENT ] ) <> Alltrim(EEC_URFENT)
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da U.R.F. Entrega difere do valor informado no arquivo, por favor rever!!" 	+ Chr(10)+Chr(13)
			EndIf 
			
			If Alltrim(aCampos[nPNRODUE ] ) <> Alltrim(EEC_NRODUE)
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor do Nro. da DUE difere do valor informado no arquivo, por favor rever!!" 		+ Chr(10)+Chr(13)
			EndIf 
			
			If Stod(Alltrim(aCampos[nPDTDUE	] )) <> EEC_DTDUE
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da Data DUE difere do valor informado no arquivo, por favor rever!!" 			+ Chr(10)+Chr(13)
			EndIf 
			
			If Alltrim(aCampos[nPCHVDUE ] )  <> Alltrim(EEC_CHVDUE)
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da Chave DUE difere do valor informado no arquivo, por favor rever!!" 		+ Chr(10)+Chr(13)
			EndIf 
			
			If Alltrim(aCampos[nPNRORUC ] ) <> Alltrim(EEC_NRORUC)
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor do Nro. RUC difere do valor informado no arquivo, por favor rever!!" 			+ Chr(10)+Chr(13)
			EndIf 
			
			If Stod(Alltrim(aCampos[nPDUEAVR ] )) <> EEC_DUEAVR
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da Data da Averbacao DUE difere do valor informado no arquivo, por favor rever!!" + Chr(10)+Chr(13)
			EndIf 
			
			If Alltrim(aCampos[nPNRCONH ] )  <> Alltrim(EEC_NRCONH) 
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor do Nr.Conhecimento difere do valor informado no arquivo, por favor rever!!" 	+ Chr(10)+Chr(13)
			EndIf 
			
			If Stod(Alltrim(aCampos[nPDTCONH ] )) <> EEC_DTCONH
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da Data Conhecimento difere do valor informado no arquivo, por favor rever!!" + Chr(10)+Chr(13)
			EndIf 
			
			If Stod(Alltrim(aCampos[nPZDTSNA ] ))  <> EEC_ZDTSNA
				cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
				cChkInt += "Valor da Data Saida Navio difere do valor informado no arquivo, por favor rever!!" + Chr(10)+Chr(13)
			EndIf 

		EndIf 

	EndIf 

	dbSelectArea('EEQ')
	EEQ->(dbSetOrder(16))
	If EEC->EEC_INTERM == '1' .and. !Empty(EEC->EEC_DTEMBA)
		If !EEQ->(dbSeek('900001'+Padr(aCampos[2],_nTamPEmb)+'133'))	
			cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
			cChkInt += 'Não localizado evento 133' + Chr(10)+Chr(13)
		EndIf
	EndIf

	If !Empty(EEC->EEC_ZAGENT) .and. !Empty(EEC->EEC_DTEMBA)
		If !EEQ->(dbSeek(aCampos[1]+Padr(aCampos[2],_nTamPEmb)+'120'))	
			cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
			cChkInt += 'Não localizado evento 120' + Chr(10)+Chr(13)
		EndIf
	EndIF

	If !Empty(EEC->EEC_DTEMBA)
		If !EEQ->(dbSeek(aCampos[1]+Padr(aCampos[2],_nTamPEmb)+'101'))	
			cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
			cChkInt += 'Não localizado evento 101' + Chr(10)+Chr(13)
		EndIf
	EndIF

	If !Empty(EEC->EEC_DTEMBA)
		_cTit	:= RetField("EEM",1,aCampos[1]+Padr(aCampos[2],_nTamPEmb),"EEM_NRNF")
		_cPrfx	:= RetField("EEM",1,aCampos[1]+Padr(aCampos[2],_nTamPEmb),"EEM_SDOC")

		If !Empty(_cTit) 
			dbSelectArea('SE1')
			SE1->(dbSetOrder(1))
				If SE1->(dbSeek(aCampos[1]+ _cPrfx +_cTit))	
					If E1_SALDO == E1_VALOR
						lBxTit := Int72bxf()
						If lBxTit
							cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
							cChkInt += 'Título financeiro baixado via execauto: ' + _cTit + Chr(10)+Chr(13)
						Else
							cChkInt += 'Exp: ' + aCampos[1]+Padr(aCampos[2],_nTamPEmb) + ' '
							cChkInt += 'Título financeiro não baixado: ' + _cTit + Chr(10)+Chr(13)
						EndIf
					EndIf 
				EndIf
		EndIf 
	EndIf 

	
	If !Empty(cChkInt)
	 	cChkInt := Chr(10)+Chr(13) + 'Erros de verificação:' + Chr(10)+Chr(13) + cChkInt + Chr(10)+Chr(13)
	EndIf 
Return cChkInt

/* PRB0040921 : Criado função para baixar títulos financeiros */
Static Function Int72bxf()

Local _lProcFin := .T.
	aBaixa := { ;
				{"E1_FILIAL"   ,SE1->E1_FILIAL			,Nil},;
				{"E1_PREFIXO"  ,SE1->E1_PREFIXO			,Nil},;
				{"E1_NUM"      ,SE1->E1_NUM             ,Nil},;
				{"E1_TIPO"     ,SE1->E1_TIPO            ,Nil},;
				{"E1_PARCELA"  ,SE1->E1_PARCELA         ,Nil},;
				{"E1_CLIENTE"  ,SE1->E1_CLIENTE         ,Nil},;
				{"E1_LOJA"     ,SE1->E1_LOJA            ,Nil},;
				{"AUTMOTBX"    ,'EEC'                	,Nil},;
				{"AUTDTBAIXA"  ,EEC->EEC_DTEMBA         ,Nil},;
				{"AUTDTCREDITO",EEC->EEC_DTEMBA         ,Nil},; 
				{"AUTHIST"     ,'Emb.:' + Alltrim(Padr(aCampos[2],_nTamPEmb)) ,Nil},;
				{"AUTDESCONT"  ,0 	  					,Nil,.T.},;
				{"AUTMULTA"    ,0       				,Nil,.T.},;
				{"AUTJUROS"    ,0       			    ,Nil,.T.},;
				{"AUTVALREC"   ,SE1->E1_VALOR 	  	    ,Nil}}
	lMsErroAuto := .F.
	MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
	If lMsErroAuto
		_lProcFin := .F.
		aErro := GetAutoGRLog()
		cErro := 'Prefixo: '+SE1->E1_PREFIXO+' - '+Alltrim(SE1->E1_NUM)+'/'+Alltrim(SE1->E1_PARCELA) +Chr(10)+Chr(13)
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
	EndIF
Return _lProcFin
