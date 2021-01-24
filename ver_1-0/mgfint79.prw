#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH"  
#include "COLORS.CH" 
#include "FWMVCDEF.CH"
/*/
{Protheus.doc} MGFINT79
Job para processar e Lançar os processos ME de forma mais rápida e atendendo outras necessidades de gestão.Automaticamente o TXT enviado pelo Despachante.

@description
Protheus - EXP - Rotina para o input das informações dos processos ME ( telas "EXP" e "Manutenção" no sistema Protheus ) 
de forma diária, onde será lido um arquivo .CSV de uma planilha em Excel gravado pelo setor de Logistica ME ( Marcelo e Lucas )
todos arquivos da pasta especificada, serão validados pela rotina do Protheus gerando logs dessas validações. 
Na atualização deverá considerar a Data de Processamento de Embarque, para que seja gerado a atualização da EXP ou da Manutenção.
As arquivos serão movidos da pasta Recebidos para a pasta de Processados ou Erros. 
Todos itens com ou sem erros deverão gerar logs sendo e enviados aos e-mails dos usuários definidos em parâmetros.
A rotina tambem terá a opção de gerar o processo de forma manual na Tela EXP em outras ações - Importação EXP(ZB8)-Manutenção(EEC).

Exemplo de como montar o JOB:
;
[OnStart]
jobs=MGFINT79,...,....,...,...
RefreshRate=1800
;
[MGFINT79]
Environment=HML/PROD
Main=U_MGFINT79

@author Antonio Florêncio
@since 18/09/2020

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	EEC - Embarque
	ZB8 - CABECALHO EXP                 
@param
@return

@menu
@history 
/*/

User Function MGFINT79()
	Local cJob			:= ""		// Nome do semaforo que sera criado
	Local oLocker		:= Nil		// Objeto que ira criar um semaforo
	
	Private _aMatriz  	:= {"01","010001"}  
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"    
	Private _lJob		:= .T.                 

	IF _lIsBlind

		RpcSetType(3)
		RpcSetEnv(_aMatriz[1],_aMatriz[2])    

		cJob := "MGFINT79"
		oLocker := LJCGlobalLocker():New()

		If !oLocker:GetLock( cJob )
			u_MFConOut("JOB já em Execução: " + DTOC(dDataBase) + " - " + TIME() )
			RpcClearEnv()
			Return
		EndIf       

		u_MFConOut("********************************************************************************************************************"		)       
		u_MFConOut('------- Inicio da Importação de Processos ME - ' + DTOC(dDataBase) + " - " + TIME()						)
		u_MFConOut("********************************************************************************************************************"+ CRLF	)  

		//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
		If !ExisteSx6("MGF_INT79A")
			CriarSX6("MGF_INT79A", "C", "Caminho onde estarão os .CSV dos Processos ME", "\PROCESSOSME\" )	
		EndIf     

		If _lJob
			U_INT79B()
		Else
			U_INT79A()
		EndIf		
		
		u_MFConOut("********************************************************************************************************************"		)       
		u_MFConOut("------- Fim da Importação de Processos ME - " + DTOC(dDataBase) + " - " + TIME()  				  		)
		u_MFConOut("********************************************************************************************************************"+ CRLF	)       

		oLocker:ReleaseLock( cJob )
		RpcClearEnv()

	EndIF
Return()

/*/
{Protheus.doc} MONINT79
Inicializador via Monitor.

@author Antonio Florêncio Domingos Filho
@since 18/09/2020

@type Function
@param	
@return
/*/
User Function MONINT79()
	Local _cPermUsu
	Private oFont1  := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	Private oFont2  := TFont():New("MS Sans Serif",,012,,.T.,,,,,.F.,.F.)
	Private _lJob   := .F.
	
	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_INT79A")
		CriarSX6("MGF_INT79A", "C", "Caminho onde estarão os .CSV Processos ME", "\PROCESSOSME\" )	
	EndIf

	If !ExisteSx6("MGF_INT79D")
		CriarSX6("MGF_INT79D", "C", "Codigos dos usuarios que podem executar a rotina Importar Processos ME manualmente !" , "000000/005679" )	
	EndIf
	
	If !ExisteSx6("MGF_INT79G")
		CriarSX6("MGF_INT79G", "C", "Caminho Padrão onde estarão os .CSV Processos ME para enviar como anexo", "\PROCESSOSME\" )	
	EndIf

	_cPermUsu   := SUPERGETMV("MGF_INT79D",.F.,'005679')

	If FunName() = "MGFEEC24" .And. !(__cUserId $ _cPermUsu)
		MsgInfo("Usuario sem permissão para executar a rotina!")
		Return	
	EndIf


	DEFINE MSDIALOG Dlg_ExtExec TITLE "Importação - Processos ME" From 000, 000  TO 620, 1350 PIXEL

		Public _cMemLog := ""
		Public oMemLog

		oSInfCli:= tSay():New(020,007,{||"MONITOR DE MENSAGENS"},Dlg_ExtExec,,oFont1,,,,.T.,CLR_HBLUE,,120,20)

		oButton := tButton():New(007,520,"Executar"	,Dlg_ExtExec, {|| INT79A() 			} ,65,17,,oFont2,,.T.)
		oButton := tButton():New(007,600,"Sair"		,Dlg_ExtExec, {|| Dlg_ExtExec:End()	} ,65,17,,oFont2,,.T.)

		@ 30,05 GET oMemLog VAR _cMemLog MEMO SIZE 665,270 OF Dlg_ExtExec PIXEL	
		oMemLog:lReadOnly := .T.

	ACTIVATE MSDIALOG Dlg_ExtExec CENTERED
Return



/*/
{Protheus.doc} INT79A
Inicializando processos para barras de processamento.

@author Antonio Florêncio Domingos Filho
@since 18/09/2020

@type Function
@param	
@return
/*/
Static Function INT79A()
	Private oProcess
    oProcess := MsNewProcess():New( { || U_INT79B() } , "Importando arquivos Proc.ME" , "Aguarde..." , .F. )
    oProcess:Activate()
Return



/*/
{Protheus.doc} INT79B
Leitura dos arquivos e execução de rotina automática.

@author Antonio Florêncio Domingos Filho
@since 18/09/2020

@type Function
@param	
@return
/*/
User Function INT79B()
	Local _cCpo := " "
	Local _nOpen
	Local _cFilial
	Local _cNroExp 
	Local _cAnoExp 
	Local _cSubExp 
	Local _cOrigem 
	Local _nFretePre 
	Local _cArmadorP 
	Local _cNumReser 
	Local _cNavioTra 
	Local _dDtDeadLi 
	Local _cViagemTr 
	Local _cHorario 
	Local _dDeadLCar 
	Local _cHorDeadL 
	Local _dETAOrige 
	Local _dPrevEstu 
	Local _dETS      
	Local _nVlCapata
	Local _cMoedaCap
	Local _cDespacha 
	Local _nFreteInt 
	Local _cTerminal
	Local _cCodInlan 
	Local _dSegDtDea 
	Local _dSegDeadC 
	Local _dSegETAOr 

	Local _aFilesZip	:= {}
	Local _aCab			:= {}
	Local _nModExec 	:= nModulo
	Local _cModExec 	:= cModulo
	Local _lProcess 	:= .F.
	Local _lRet			:= .F.
	Local _cMens 		:= "" 
	Local _cStatus		:= ""
	Local _cArqEmail	:= ""
	Local _lEnvMail		:= .T.
	Local _cDesMail 	:= "" 
	Local _cNameArq 	:= ""
	Local _cNameRen		:= ""
	Local _cLogFile		:= ""
	Local _cDirErr		:= ALLTRIM(SuperGetMV("MGF_INT79A",.F.,"\PROCESSOSME\"))+"Erro\"	// Pasta de gravação dos arquivos de erros.
	Local _cDirLog		:= ALLTRIM(SuperGetMV("MGF_INT79A",.F.,"\PROCESSOSME\"))+"Log\"		// Pasta de gravação dos arquivos de Logs
	Local _cDirProc 	:= ALLTRIM(SuperGetMV("MGF_INT79A",.F.,"\PROCESSOSME\"))+"Process\"	// Pasta de gravação dos arquivos processados
	Local _cPath		:= ALLTRIM(SuperGetMV("MGF_INT79A",.F.,"\PROCESSOSME\"))
	Local _cPathPad     := ALLTRIM(SuperGetMV("MGF_INT79G",.F.,"\PROCESSOSME\"))
	Local _aFiles[ADIR(_cPath+"*.CSV")]
	Private lEE7Auto 	:= .T.
	Private lMsErroAuto := .F.
	Private _aPrcOff 	:= {}
	Private _lAtualZB8 	:= .F.
    Private _lAtuaLEEC  := .F.
	Private _lAchouZB8 	:= .F.
    Private _lAchouEEC  := .F.
	Private _cArqIndEEC := CriaTrab( Nil,.F. )
	Private	_cKeyIndEEC := "RTRIM(EEC_ZEXP)+EEC_ZANOEX+EEC_ZSUBEX" //Criado indice temporario - Tabela ZB8 Compartilhada X Tabela EEC Exclusiva.
	Private	_nIndexEEC 	:= EEC->(RetIndex("EEC"))
	Private _NTAMSUBEXP := TAMSX3("ZB8_SUBEXP")[1]
	Private _NTAMANOEXP := TAMSX3("ZB8_ANOEXP")[1]
	Private _NTAMEECEXP := TAMSX3("EEC_ZEXP")[1]
	Private _nTamNroExp  
	Private _cEECNroExp
	Private _cLogWrt  := ""
	Private _cArqLog  := _cDirLog+"ArqLog_"+DTOS(ddatabase)+Left(Time(),2)+Substr(time(),4,2)+Right(Time(),2)+".csv"
	Private _cCpo := " "
	Private _nHdl
	Private _cEol := "CHR(13)+CHR(10)"
    Private cAliasZB8 := " "
	Private _cAliasAtu := Alias()
	
	If Empty(_cEol)
		_cEol := CHR(13)+CHR(10)
	Else
		_cEol := Trim(_cEol)
		_cEol := &_cEol
	EndIf
	
	If _nHdl = -1
		If FunName() = "MGFEEC24"
			If !_lJob
				MsgAlert("O Arquivo de nome "+_cArqCsv+" não pode ser criado! Verifique os parametros.","Atenção!")
			Else
				u_MFConOut("O Arquivo de nome "+_cArqCsv+" não pode ser criado! Verifique os parametros.","Atenção!")
			EndIf
		EndIf
	EndIf

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_INT79B")
		CriarSX6("MGF_INT79B", "L", "Habilita envio de e-mail dos erros das Importacoes" , ".T." )	
	EndIf

	If !ExisteSx6("MGF_INT79C")
		CriarSX6("MGF_INT79C", "C", "Endereco de e-mail de quem recebera notificacoes " , "antonio.filho2@marfrig.com.br" )	
	EndIf
	
	_lEnvMail	:= SUPERGETMV("MGF_INT79B",.F., '.T.' )
	_cDesMail	:= Lower(ALLTRIM(SuperGetMV("MGF_INT79C",.F.,"antonio.filho2@marfrig.com.br")))

	// Forço a criação das pastas para que as mesmas na primeira vez, do usuario, a linha abaixo retorne.T. se criou com sucesso. 
	If !ExistDir(_cPath)
		MakeDir( _cPath )
	EndIf
	
	If !ExistDir(_cPathPad)
		MakeDir( _cPathPad)
	EndIf

	If !ExistDir(_cDirErr)
		MakeDir( _cDirErr )
	EndIf

	If !ExistDir(_cDirLog)
		MakeDir( _cDirLog)
	EndIf

	If !ExistDir(_cDirProc)
		MakeDir( _cDirProc )
	EndIf

	_nHdl := FCreate(_cArqLog)


	//Grava Cabeçalho do Arquivo de Log
	_cCpo := "NroEXP;AnoEXP;SubEXP;Origem;FretePre;ArmadorP;NumReser;NavioTra;DtDeadLi;ViagemTr;DeadLCar;ETAOrige;PrevEstu;ETS;VlCapata;MoedaCap;Despacha;"
	_cCpo += "FreteInt;Terminal;CodInlan;SegDtDea;SegDeadC;SegETAOr;Status EEC;Status ZB8;Cod.Usu.Imp;Nome_Usu.Imp;Hora_Imp.;Data_Imp;Rotina_Imp"

	U_FINT79F(_cCpo)

	ADIR(_cPath+"*.CSV",_aFiles)

	If nModulo <> 29
        nModulo := 29
        cModulo := "EEC"
    EndIf

	_cMemLog := "******************************************************************************************************************************"+Chr(10)+Chr(13)       
	_cMemLog += "             Inicio da Importação - MGFINT79 - Importação de Processos ME - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)
	
	If !_lJob
		oMemLog:Refresh()

		oProcess:SetRegua1( Len(_aFiles) ) //Alimenta a primeira barra de progresso
	Else
		u_MFConOut(_cMemLog)
	EndIf

	BEGIN TRANSACTION

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Indice Temporario para Importação.	                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(_aFiles) > 0
			_cArqIndEEC := CriaTrab( Nil,.F. )
			dbSelectArea("EEC")
			_cKeyIndEEC := "EEC_ZEXP+EEC_ZANOEX+EEC_ZSUBEX" //Criado indice temporario - Tabela EEC Compartilhada X Tabela ZB8 Exclusiva.
			IndRegua( "EEC",_cArqIndEEC,_cKeyIndEEC,,,OemToAnsi("Selecionando Registros...") )
			dbSelectArea("EEC")
			_nIndexEEC := RetIndex("EEC")
			dbSetOrder(_nIndexEEC+1)
			dbGoTop()
		EndIf
		
		For I:=1 To Len(_aFiles)
			//processamento da primeira barra de progresso
			If !_lJob
				oProcess:IncRegua1("Proc Arq: "+ _aFiles[I])
			EndIf
			_nOpen := FT_FUSE(ALLTRIM(_cPath+_aFiles[I]))	
			If _nOpen > 0
				u_MFConOut("------- Importando arquivo - " + _aFiles[I]	)
				If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
					_cMemLog += "- Importando arquivo - " + _aFiles[I]+Chr(10)+Chr(13)
					If !_lJob
						oMemLog:Refresh() 
					Else
						u_MFConOut(_cMemLog)
					EndIf
				EndIf

				_lProcess 	:= .F.	// Se processou o arquivo

				If !_lJob
					oProcess:SetRegua2( FT_fLastRec() ) //Alimenta a segunda barra de progresso
				EndIf

				FT_FGoTop()
				While !FT_FEOF() 

					_cAliasAtu := Alias()

					//Pré-Validações da Importação
					_lAchouEEC := .F.
					_lAchouEEC := .F.
					_lAtualEEC := .F.
					_lAtualZB8 := .F.
					_cStatusZB8 := " "
					_cStatusZB8 := " "

					_aCab		:= {}
					_aPrcOff	:= {} 

					_cLinha 	:= FT_FREADLN()
					
					_nPosFim 	:= AT( ";", _cLinha ) 
					_cNroExp	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Processo
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha ) 
					_cAnoExp	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Processo
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha ) 
					_cSubExp	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				// Processo
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))
					
					_nTamNroExp := Len(alltrim(_cNroExp))
					_cEECNroExp	:= _cNroExp+Space(_nTamEECEXP-_nTamNroExp)  //Acrescento o tamanho do campo porque na EEC o campo EEC_ZEXP o tamanho é 13 E na tabela ZB8 o campo ZB8_EXP é 9

					If Empty(_cSubExp)
						_cSubExp := Space(_nTamSubExp)				
					EndIf

					If Empty(_cAnoExp)
						_cAnoExp := Space(_nTamAnoExp)				
					EndIf

					_cFilial := cFilAnt
					
					//processamento da segunda barra de progresso 
					If !_lJob
						oProcess:IncRegua2("Processando Processos: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp )
					Else
						u_MFConOut("------- Processo -> " +_cNroExp+"-"+_cAnoExp+"-"+_cSubExp  )
					EndIf
					If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
						_cMemLog += Chr(10)+Chr(13)+"- Processo -> " + _cNroExp+"-"+_cAnoExp+"-"+_cSubExp +Chr(10)+Chr(13)
						If !_lJob
							oMemLog:Refresh() 
						Else
							u_MFConOut(_cMemLog)
						EndIf
					EndIf
				
					//Verifica se o arquivo veio com a primeira linha com Informações de Cabeçalho
					If Upper(Alltrim(_cNroExp)) == "NROEXP"
						FT_FSKIP()
						Loop
					EndIf
					
					_nPosFim 	:= AT( ";", _cLinha )
					_cOrigem	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_nFretePre	:= VAL(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cArmadorP	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cNumReser  := ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cNavioTra	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dDtDeadLi	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cViagemTr	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dDeadLCar	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dETAOrige	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dPrevEstu	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dETS	    := CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_nVlCapata	:= VAL(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cMoedaCap	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cDespacha	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_nFreteInt	:= VAL(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cTerminal	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_cCodInlan	:= ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dSegDtDea	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dSegDeadC	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,_nPosFim - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))

					_nPosFim 	:= AT( ";", _cLinha )
					_dSegETAOr	:= CTOD(ALLTRIM(SUBSTR(_cLinha,1,If(_nPosFim=0,Len(_clinha)+1,_nPosFim) - 1)))				
					_cLinha 	:= ALLTRIM(SUBSTR(_cLinha,_nPosFim+1,LEN(_cLinha)))
			
					cFilAnt 	:= _cFilial
					
					//Armazena os itens importados para log de registros
					_cCpo := _cNroExp+";"
					_cCpo += _cAnoExp+";"
					_cCpo += _cSubExp+";"
					_cCpo += _cOrigem+";"
					_cCpo += STR(_nFretePre,17,2)+";"
					_cCpo += _cArmadorP+";"
					_cCpo += _cNumReser+";"					
					_cCpo += _cNavioTra+";"
					_cCpo += DTOC(_dDtDeadLi)+";"
					_cCpo += _cViagemTr+";"
					_cCpo += DTOC(_dDeadLCar)+";"
					_cCpo += DTOC(_dETAOrige)+";"
					_cCpo += DTOC(_dPrevEstu)+";"
					_cCpo += DTOC(_dETS)+";"
					_cCpo += STR(_nVlCapata,17,2)+";"
					_cCpo += _cMoedaCap+";"
					_cCpo += _cDespacha+";"					
					_cCpo += STR(_nFreteInt,17,2)+";"
					_cCpo += _cTerminal+";"
					_cCpo += _cCodInlan+";"
					_cCpo += DTOC(_dSegDtDea)+";"
					_cCpo += DTOC(_dSegDeadC)+";"
					_cCpo += DTOC(_dSegETAOr)+";"
					
						//Pesquisa o Exp na EEC para processamento inicial dos dados
					dbSelectArea("EEC")
					dbSetOrder(_nIndexEEC+1)
					dbGoTop()
					If EEC->(dbSeek(_cEECNroExp+_cAnoExp+_cSubExp))
						_lAchouEEC := .T.
						_cStatusEEC := "Encontrado"
					Else
						_lAchouEEC := .F.
						_cStatusEEC := "Não Encontrado"
						_cStatus	:= "3"
						_cMens 		:= "- Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na EEC "  
							//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
						_cLogWrt	+= "Arquivo: "+ _aFiles[I]+" - Erro: Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na EEC."+Chr(10)+Chr(13)
						u_MFConOut("Error: "+ _cMens)
						If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
							_cMemLog += "- Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na EEC."+Chr(10)+Chr(13)
							If !_lJob
								oMemLog:Refresh() 
							Else
								u_MFConOut(_cMemLog)
							EndIf
						EndIf				
					EndIf	

					cQuery := " SELECT ZB8_FILIAL CFILIAL, ZB8_EXP CEXP, ZB8_ANOEXP CANOEXP, ZB8_SUBEXP CSUBEXP, R_E_C_N_O_ RECNO " + CRLF
					cQuery += " FROM " + RetSqlName("ZB8")+ " ZB8 " + CRLF  
					cQuery += " WHERE ZB8_EXP = '" + _cNroExp + "' " + CRLF
					cQuery += " AND ZB8_ANOEXP = '" +_cAnoExp + "'" + CRLF
					cQuery += " AND ZB8_SUBEXP = '" + _cSubExp + "'" + CRLF
					cQuery += " AND ZB8.D_E_L_E_T_<>'*' " + CRLF

					cQuery := ChangeQuery(cQuery)

					cAliasZB8 := GetNextAlias()

					If SELECT(cAliasZB8) <> 0
						(cAliasZB8)->(dbCloseArea())
					EndIf
					
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasZB8, .F., .T.)

					If (cAliasZB8)->(!eof())
						_nRecno     :=  (cAliasZB8)->RECNO				
						_cFilialZB8 :=  (cAliasZB8)->CFILIAL
						_lAchouZB8  := .T.
						_cStatusZB8 := "Encontrado"
					Else
						_lAchouZB8  := .F.						
						_cStatusZB8 := "Não Encontrado"
						_cStatus	:= "3"
						_cMens 		:= "- Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na ZB8"
							//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
						_cLogWrt	+= " Arquivo: "+ _aFiles[I]+" - Erro: Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na ZB8."+Chr(10)+Chr(13)
						u_MFConOut("Error: "+ _cMens)
						If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
							_cMemLog += "- Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" não encontrado na ZB8"+Chr(10)+Chr(13)
							If !_lJob
								oMemLog:Refresh() 
							Else
								u_MFConOut(_cMemLog)
							EndIf
						EndIf					
					EndIf
					
					(cAliasZB8)->(dbCloseArea())

					If _lAchouEEC .And. _lAchouZB8 ////Se tiver informações nas duas tabelas, importar somente para a EEC;
						_lAtualEEC  := .T.
						_cStatusEEC := " Atualizar somente EEC - informações nas duas tabelas "
						_lAtualZB8  := .F.
						_cStatusZB8 := " Não Atualizar ZB8 - informações nas duas tabelas"
					ElseIf !_lAchouEEC .And. !_lAchouZB8 //Se não tiver informações em nenhuma das duas, não importa;
						_lAtualEEC  := .F.
						_cStatusEEC := " Não Achou EEC - informações em nenhuma das duas"
						_lAtualZB8  := .F.
						_cStatusZB8 := " Não Achou ZB8 - informações em nenhuma das duas"
					ElseIf !_lAchouEEC .And. _lAchouZB8 //Se tiver informação somente na ZB8, importar para a ZB8;
						_lAtualEEC  := .F.
						_cStatusEEC := " Não Achou EEC Informação somente na ZB8"
						_lAtualZB8  := .T.
						_cStatusZB8 := " Atualizar Informação somente na ZB8"
					ElseIf _lAchouEEC .And. !_lAchouZB8 //Não vai acontecer de ter informações na EEC se não tiver informações na ZB8;
						_lAtualEEC  := .F.
						_cStatusEEC := " Achou EEC - Não Atualizar - Não terá informações na EEC se não tiver informações na ZB8 "
						_lAtualZB8  := .F.
						_cStatusZB8 := " Não Achou ZB8 - Não terá informações na EEC se não tiver informações na ZB8 "
					EndIf

					If _lAtualEEC
						
						If !Empty(EEC->EEC_DTEMBA)  //Se data de Embarque preenchida

							_lAtualZB8  := .F.
							_cStatusZB8 := "Rejeitado - Data de Embarque preenchida na EEC"
							_lAtualEEC  := .F.
							_cStatusEEC := "Rejeitado - Data de Embarque preenchida na EEC"

						Else // Verificar O campo EEC_DTEMBA

							If !EMPTY(EEC->EEC_DTPROC) //O Campo EEC_DTPROC estiver preeenchido Atualizar EEC

								_lAtualZB8  := .F.
								_cStatusZB8 := "Rejeitado - Data de processo preenchida na EEC"

								//Valida campo a campo as informações do arquivo csv com os dados da tabela a ser atualizada
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ORIGEM,_cOrigem,"EEC_ORIGEM")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZFRPRE,_nFretePre,"EEC_ZFRPRE")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZARMAD,_cArmadorP,"EEC_ZARMAD")								
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZNUMRE,_cNumReser,"EEC_ZNUMRE")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZNTRAN,_cNavioTra,"EEC_ZNTRAN")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZDELDR,_dDtDeadLi,"EEC_ZDELDR")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZVTRAN,_cViagemTr,"EEC_ZVTRAN")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZDTDEC,_dDeadLCar,"EEC_ZDTDEC")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZETAOR,_dETAOrige,"EEC_ZETAOR")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZVLCAP,_nVlCapata,"EEC_ZVLCAP")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZMDCAP,_cMoedaCap,"EEC_ZMDCAP")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_XAGEMB,_cDespacha,"EEC_XAGEMB")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZFRETE,_nFreteInt,"EEC_ZFRETE")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_TERMIN,_cTerminal,"EEC_TERMIN")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZINLAN,_cCodInlan,"EEC_ZINLAN")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZDTDE2,_dSegDtDea,"EEC_ZDTDE2")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZDELD2,_dSegDeadC,"EEC_ZDELD2")
								_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"EEC",EEC->EEC_ZETAO2,_dSegETAOr,"EEC_ZETAO2")
								
								_cLogWrt += _cMemLog

								dbSelectArea("EEC")
								EEC->(Reclock("EEC",.F.))
									EEC->EEC_ORIGEM := _cOrigem
									EEC->EEC_XAGEMB := _cDespacha
									EEC->EEC_ZARMAD := _cArmadorP
									EEC->EEC_ZDELDR := _dDtDeadLi
									EEC->EEC_ZDTDEC := _dDeadLCar
									EEC->EEC_ZETAOR := _dETAOrige
									EEC->EEC_ZMDCAP := _cMoedaCap
									EEC->EEC_ZNTRAN := _cNavioTra
									EEC->EEC_ZNUMRE := _cNumReser
									EEC->EEC_ZVLCAP := _nVlCapata
									EEC->EEC_ZVTRAN := _cViagemTr
									EEC->EEC_ZFRPRE := _nFretePre
									EEC->EEC_ZFRETE := _nFreteInt
									EEC->EEC_ZINLAN := _cCodInlan
									EEC->EEC_ZETAO2 := _dSegETAOr
									EEC->EEC_ZDTDE2 := _dSegDtDea
									EEC->EEC_ZDELD2 := _dSegDeadC
									EEC->EEC_TERMIN := _cTerminal
									EEC->EEC_ZUSIMP := RetCodUsr()
									EEC->EEC_ZNUIMP := Substr(cUsuario,7,15)
									EEC->EEC_ZHIMME := TIME()
									EEC->EEC_ZDTIMP := dDataBase
									EEC->EEC_ZROTIM := alltrim(FUNNAME())
								EEC->(MsUnLock())
								_lAtualEEC  := .T.
								_cStatusEEC := "Atualizada com sucesso"
			
								u_MFConOut("------- Processo ME realizado com sucesso: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+Chr(10)+Chr(13))
								If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
									_cMemLog += "- Atualização do Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" realizado com sucesso na EEC."+Chr(10)+Chr(13)
									If !_lJob
										oMemLog:Refresh() 
									Else
										u_MFConOut(_cMemLog)
									EndIf
								EndIf
								_cStatus	:= "1"
								_cMens 		:= "- Atualização do Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" realizado com sucesso na EEC."+Chr(10)+Chr(13)
							Else	// Se a data de embarque foi preenchido, os dados não serão importados
								_lAtualEEC  := .F.
								_cStatusEEC := "Não Atualizada - Data de Embarque vazia na EEC"
								_lAtualZB8  := .T.
								_cStatusZB8 := "Atualizar ZB8"

								_cStatus	:= "2"
								_cMens 		:= "Processo ME com data de embarque preenchida não será importado! Processo: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp 

								//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
								_cLogWrt	+= " Processo: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp +" - Arquivo: "+ _aFiles[I]+" - Erro: Processo com data de Embarque preenchida no Protheus não será importado."+Chr(10)+Chr(13)

								u_MFConOut("Error: "+ _cMens)
								If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
									_cMemLog += "- Processo com data de Embarque preenchida no Protheus não será importado: Processo: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp +Chr(10)+Chr(13)
									If !_lJob
										oMemLog:Refresh() 
									Else
										u_MFConOut(_cMemLog)
									EndIf
								EndIf
							EndIf
						Endif
					EndIf
					If _lAtualZB8
						If !EMPTY(ZB8->ZB8_DTEMBA)	// Se data de embarque estiver preenchida os dados não serão importados
							//Gerar Erro de Log
							_cStatus	:= "2"
							_cMens 		:= "Processo ME com data de Embarque preenchida no Protheus não será importado: Processo: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" - Data de Embarque "+DTOC(ZB8->ZB8_DTEMBA) 

							//-----| Grava log de erros para envio por e-mail e gravação de arquivo de erro |-----\\
							_cLogWrt	+= " Processo: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" - Data de Embarque "+DTOC(ZB8->ZB8_DTEMBA)+" - Arquivo: "+ _aFiles[I]+" - Erro: Processo ME com data de Embarque preenchida no Protheus não será importado."+Chr(10)+Chr(13)

							u_MFConOut("Error: "+ _cMens)
							If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
								_cMemLog += _cMens+Chr(10)+Chr(13)
								If !_lJob
									oMemLog:Refresh() 
								Else
									u_MFConOut(_cMemLog)
								EndIf
							EndIf
								
							_cStatusZB8 := "Rejeitada - Data de Embarque preenchida na ZB8"

						Else
								If _lAchouZB8

									//Valida campo a campo as informações do arquivo csv com os dados da tabela a ser atualizada
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ORIGEM,_cOrigem,"ZB8_ORIGEM")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_FRPREV,_nFretePre,"ZB8_FRPREV")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZARMAD,_cArmadorP,"ZB8_ZARMAD")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZNUMRE,_cNumReser,"ZB8_ZNUMRE")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZNTRAN,_cNavioTra,"ZB8_ZNTRAN")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDELDR,_dDtDeadLi,"ZB8_ZDELDR")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZVTRAN,_cViagemTr,"ZB8_ZVTRAN")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDTDEC,_dDeadLCar,"ZB8_ZDTDEC")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZETAOR,_dETAOrige,"ZB8_ZETAOR")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDTPES,_dPrevEstu,"ZB8_ZDTPES")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDAEST,_dETS,"ZB8_ZDAEST")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZVLCAP,_nVlCapata,"ZB8_ZVLCAP")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZMDCAP,_cMoedaCap,"ZB8_ZMDCAP")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_XAGEMB,_cDespacha,"ZB8_XAGEMB")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZFRETE,_nFreteInt,"ZB8_ZFRETE")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_TERMIN,_cTerminal,"ZB8_TERMIN")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_INLAND,_cCodInlan,"ZB8_INLAND")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDELD2,_dSegDtDea,"ZB8_ZDELD2")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZDTDE2,_dSegDeadC,"ZB8_ZDTDE2")
									_cMemLog += FINT79E(_cNroExp,_cAnoExp,_cSubExp,"ZB8",ZB8->ZB8_ZETAO2,_dSegETAOr,"ZB8_ZETAO2")
									
									_cLogWrt += _cMemLog

									dbSelectArea("ZB8")
									dbSEtOrder(3)
									If dbSeek(_cFilialZB8+_cNroExp+_cAnoExp+_cSubExp)
										ZB8->(RecLock("ZB8",.F.))
											ZB8->ZB8_ORIGEM := _cOrigem
											ZB8->ZB8_FRPREV := _nFretePre
											ZB8->ZB8_ZARMAD := _cArmadorP
											ZB8->ZB8_ZNUMRE := _cNumReser
											ZB8->ZB8_ZNTRAN := _cNavioTra
											ZB8->ZB8_ZDELDR := _dDtDeadLi
											ZB8->ZB8_ZVTRAN := _cViagemTr
											ZB8->ZB8_ZDTDEC := _dDeadLCar
											ZB8->ZB8_ZETAOR := _dETAOrige
											ZB8->ZB8_ZDTPES := _dPrevEstu
											ZB8->ZB8_ZDAEST := _dETS
											ZB8->ZB8_ZVLCAP := _nVlCapata
											ZB8->ZB8_ZMDCAP := _cMoedaCap
											ZB8->ZB8_XAGEMB := _cDespacha
											ZB8->ZB8_ZFRETE := _nFreteInt
											ZB8->ZB8_TERMIN := _cTerminal
											ZB8->ZB8_INLAND := _cCodInlan
											ZB8->ZB8_ZDELD2 := _dSegDtDea
											ZB8->ZB8_ZDTDE2 := _dSegDeadC
											ZB8->ZB8_ZETAO2 := _dSegETAOr
											ZB8->ZB8_ZUSIMP := RetCodUsr()
											ZB8->ZB8_ZNUIMP := Substr(cUsuario,7,15)
											ZB8->ZB8_ZHIMME := TIME()
											ZB8->ZB8_ZDTIMP := dDataBase
											ZB8->ZB8_ZROTIM := alltrim(FUNNAME())
										ZB8->(MsUNLock())
									
										u_MFConOut("------- Tab ZB8 Atualização de Processos ME realizado com sucesso: "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+Chr(10)+Chr(13))
										If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
											_cMemLog += "- Atualização do Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" realizado com sucesso na ZB8."+Chr(10)+Chr(13)
											If !_lJob
												oMemLog:Refresh() 
											Else
												u_MFConOut(_cMemLog)
											EndIf
										EndIf
										_cStatus	:= "1"
										_cMens 		:= "- Atualização do Processo ME "+_cNroExp+"-"+_cAnoExp+"-"+_cSubExp+" realizado com sucesso na ZB8."+Chr(10)+Chr(13)
										_cStatusZB8 := "Atualizada - Com sucesso"
									Else
										_cStatusZB8 := "Não Encontrada"									
									EndIf
								Else
									_cStatusZB8 := "Não Encontrada"
								EndIf
						EndIf
					Endif
					_lProcess := .T.
					If !_lJob
						//-----| Gera log de processamento para consulta no Monitor de Integrações |-----\\
						U_MGFMONITOR(	_cFilial 		,;
										_cStatus		,;
										"009"			,; 
										"001" 			,;
										_cMens			,;
										"Proc.: "+_cNroExp+_cAnoExp+_cSubExp +" - "+_aFiles[I]	,; 
										"0" 			,;
										""				,;
										0	)
					EndIf
					
					FT_FSKIP()
			
					_cCpo += _cStatusEEC+";"
					_cCpo += _cStatusZB8+";"
					_cCpo += alltrim(RetCodUsr())+";"
					_cCpo += Substr(cUsuario,7,15)+";"
					_cCpo += TIME()+";"
					_cCpo += DTOC(dDataBase)+";"
					_cCpo += alltrim(FUNNAME())

					//Grava Registro do Item com Log de Validação
					U_FINT79F(_cCpo)
					
					dbSelectArea(_cAliasAtu)

				EndDo

				FClose(_aFiles[I])
				fClose(_nHdl)				
				
				If  _lProcess
					If !Empty(_cLogWrt)
						_cNameArq	:= SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-4)+"_"+Dtos(dDataBAse)+"_"+StrTran(Time(),":","")
						_cLogFile	:= _cDirErr+"Err_"+_cNameArq+".LOG"
						nHandle   	:= MSFCreate(_cLogFile,0)
						FWrite(nHandle,_cLogWrt)
						FClose(nHandle)

						u_MFConOut("------- LOG de erro gerado em "+_cLogFile+Chr(10)+Chr(13) )
						If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
							_cMemLog += "- LOG de erro gerado em "+_cLogFile+Chr(10)+Chr(13)
							If _lJob
								oMemLog:Refresh() 
							Else
								u_MFConOut(_cMemLog)
							EndIf
						EndIf
						FT_FUSE()

						If _lEnvMail	// Se envia e-mail com os erros.						
							_cArqEmail	:= _cPath+_cNameArq+".ZIP"
							_aFilesZip	:= {_cLogFile,_cPath+_aFiles[I],_cArqLog}
							_nRetZip	:= FZip(_cArqEmail,_aFilesZip,_cPath)

							If _nRetZip != 0 // Se não gerou arquivo .ZIP, envio apenas o arq. de Log.
								_cArqEmail := _cLogFile 
								__CopyFile(_cArqEmail , _cPathPad+_cLogFile )
								_cArqAnexo := _cPathPad+_cLogFile
								FErase(_cArqEmail)
							Else
								__CopyFile(_cArqEmail , _cPathPad+_cNameArq+".ZIP")
								_cArqAnexo := _cPathPad+_cNameArq+".ZIP"
								FErase(_cArqEmail)
							EndIf

							U_IT79ENVM(_cDesMail,_cArqAnexo,_aFiles[I])

							If _nRetZip = 0		// Se gerou arquivo .ZIP, apago depois do envio.
								FErase(_cArqAnexo)
							EndIf
						EndIF
					EndIf
					
					If __CopyFile(ALLTRIM(_cPath+_aFiles[I]) , _cDirProc+"Process_"+_aFiles[I])
						u_MFConOut("------- Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+_cDirProc+"Process_"+_aFiles[I]+Chr(10)+Chr(13) )
						If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
							_cMemLog += "- Arquivo: "+ALLTRIM(_cPath+_aFiles[I])+" copiado com sucesso para "+_cDirProc+"Process_"+_aFiles[I]+Chr(10)+Chr(13) 
							If !_lJob
								oMemLog:Refresh() 
							Else
								u_MFConOut(_cMemLog)
							EndIf
						EndIf

						If FErase(ALLTRIM(_cPath+_aFiles[I])) == -1
							u_MFConOut("------- Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13) )
							If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
								_cMemLog += "- Falha ao tentar apagar o arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13) 
								If !_lJob
									oMemLog:Refresh() 
								Else
									u_MFConOut(_cMemLog)
								EndIf
							EndIf
							_cNameRen := SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-3)+"err"
							FRename(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPath+_cNameRen) )
							u_MFConOut("------- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13) )
							If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
								_cMemLog += "- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13)
								If !_lJob
									oMemLog:Refresh() 
								Else
									u_MFConOut(_cMemLog)
								EndIf
							EndIf
						Endif
					Else
						_cNameRen := SUBSTR(_aFiles[I],1,LEN(_aFiles[I])-3)+"err"
						FRename(ALLTRIM(_cPath+_aFiles[I]) , ALLTRIM(_cPath+_cNameRen) )
						u_MFConOut("------- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13) )
						If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
							_cMemLog += "- Arquivo foi renomeado de: "+ALLTRIM(_cPath+_aFiles[I])+" Para: "+ALLTRIM(_cPath+_cNameRen)+Chr(10)+Chr(13)
							If !_lJob
								oMemLog:Refresh() 
							Else
								u_MFConOut(_cMemLog)
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				u_MFConOut("Falha na abertura do arquivo: "+ALLTRIM(_cPath+_aFiles[I]) )
				If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
					_cMemLog += "- Falha na abertura do arquivo: "+ALLTRIM(_cPath+_aFiles[I])+Chr(10)+Chr(13)
					If !_lJob
						oMemLog:Refresh() 
					Else
						u_MFConOut(_cMemLog)
					EndIf
				EndIf
			EndIf
		Next

	END TRANSACTION

	If Len(_aFiles) = 0
		u_MFConOut("Não há arquivos para importação.")
		If FunName() = "MONINT79" .OR. FunName() = "MGFEEC24"
			_cMemLog += "- Não há arquivos para importação."+Chr(10)+Chr(13)
			If !_lJob
				oMemLog:Refresh() 
			Else
				u_MFConOut(_cMemLog)
			EndIf
		EndIf
	EndIf

	If nModulo <> _nModExec
        nModulo := _nModExec
        cModulo := _cModExec
    EndIf

	dbSelectArea("EEC")
	RetIndex("EEC")
	dbSetOrder(1)
	Ferase(_cArqIndEEC +OrdBagExt())

	dbSelectArea("ZB8")
	dbSetOrder(1)
	
	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)       
	_cMemLog += "             Fim da Importação - MGFINT79 - Importação de Processos ME - " + DTOC(dDataBase) + " - " + TIME()+Chr(10)+Chr(13)
	_cMemLog += "******************************************************************************************************************************"+Chr(10)+Chr(13)
	
	If !_lJob
		oMemLog:Refresh() 
		MsgInfo("Importação finalizada.")
	Else
		u_MFConOut(_cMemLog)
	EndIf
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
User Function IT79ENVM(_cPara,_cAnexo,_cArqProc)

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

	_cHist := "Segue arquivo de log da importação de Processos ME."

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
	_cHtml += "<P><font face = 'verdana' size='5'><strong>LOG DA IMPORTACAO AUTOMATICA PROCESSOS ME</strong></font></p>"+CRLF
	_cHtml += CRLF+"<P><font face = 'verdana' size='3'>ARQUIVO: "+_cArqProc+"</font></p>"
	_cHtml += "<P><font face = 'verdana' size='3' color='blue'><strong>[MGFINT79] Importacao de Processos ME</strong></font></p>"
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
		u_MFConOut(_cErrMail)

		oMail:SMTPDisconnect()
		_lRetMail := .F.
		Return (_lRetMail)
	Endif

	If 	_nParSmtpP != 25
		_nErro := oMail:SmtpAuth(_cCtMail, _cPwdMail)
		If _nErro != 0
			_cErrMail :=("ERROR:" + oMail:GetErrorString(_nErro))
			u_MFConOut(_cErrMail)
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
	oMessage:cSubject               := "[MARFRIG] Aviso de LOG na Importação de arquivos Processos (ME)"
	oMessage:cBody                  := _cHtml	
	oMessage:AttachFile( _cAnexo )

	_nErro := oMessage:Send( oMail )

	if _nErro != 0
		_cErrMail :=("ERROR:" + oMail:GetErrorString(_nErro))
		u_MFConOut(_cErrMail)
		//Alert(_cErrMail)
		oMail:SMTPDisconnect()
		_lRetMail := .F.
		Return (_lRetMail)
	Endif

	u_MFConOut('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return

/*/
{Protheus.doc} INT79E

Comparação de Conteudo

@description
Comparar Conteudo do arquivo com o conteudo da tabela que será atualizada

@author Antonio Florêncio
@since 18/09/2020

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
	EEC - Embarque
	ZB8 - CABECALHO EXP                 
@param
_cNroExp,_cAnoExp,_cSubExp,_cTabela,_cCampoTab,_cCampoArq

@return

@menu
@history 
/*/

Static Function FINT79E(_cNroExp,_cAnoExp,_cSubExp,_cTabela,_cCampoTab,_cCampoArq,_cNomeCpo)

	Local _cChkint	:= ''
	If Valtype((_cTabela)->(_cCampoTab)) == "D"
		_cCampoTab := DTOC((_cTabela)->(_cCampoTab))
		_cCampoArq := DTOC(_cCampoArq)
	ElseIf Valtype((_cTabela)->(_cCampoTab)) == "N"
		_cCampoTab := STR((_cTabela)->(_cCampoTab),TAMSX3(_cNomeCpo)[1],TAMSX3(_cNomeCpo)[2])
		_cCampoArq := STR(_cCampoArq,TAMSX3(_cNomeCpo)[1],TAMSX3(_cNomeCpo)[2])
	EndIf		
	If Alltrim(_cCampoArq) <> Alltrim((_cTabela)->(_cCampoTab)) 
		_cChkint += 'Exp: '+_cNroExp+" - Ano: "+_cAnoExp+" - Sub: "+_cSubExp 
		_cChkint += " Na Tabela "+_cTabela+" o conteudo do Campo "+alltrim(Posicione("SX3",2,_cNomeCpo,"X3_TITULO"))+" : "+Alltrim((_cTabela)->(_cCampoTab))+" difere do Conteudo "+Alltrim(_cCampoArq)+" informado no arquivo, por favor rever!!"+ Chr(10)+Chr(13)
	EndIf						
	If !Empty(_cChkint)
	 	_cChkint := 'Erros de verificação: ' + alltrim(_cChkint)
	EndIf 

Return _cChkint


/*/
{Protheus.doc} INT79E

Gravação de Linha em Arquivo Textp

@description
Grava conteudo das linhas processadas na rotina em arquivo texto

@author Antonio Florêncio
@since 01/10/2020

@version P12.1.017
@country Brasil
@language Português

@type Function 
@table 
@param
_cCpo

@return

@menu
@history 
/*/
User Function FINT79F(_cCpo)

	Local _nTamLin
	Local _cLin

	_nTamLin := 300
	_cLin := Space(_nTamLin)+_cEol // Variavel para criacao da linha dos registros para gravação
	_cLin := Stuff(_cLin,01,300,_cCpo)
	
	fWrite(_nHdl,_cLin,Len(_cLin))

Return
