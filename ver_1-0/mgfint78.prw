#INCLUDE "TOTVS.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "AP5MAIL.CH"

#DEFINE CRLF chr(13)+chr(10) 

/*/
{Protheus.doc} MGFINT78
	Job para importar o TXT enviado pelo Despachante.

@description
    Este Job irá importar autmaticamente os anexos dos e-mails enviados pelos despachantes referente a DUE.
    Irá baixar os anexos para a pasta contida no parâmetro "MGF_INT72A" e que deve estar dentro da Protheus_data

@author Marcos Cesar Donizeti Vieira
@since 17/09/2020

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table                    
@param
@return
@menu
/*/

User Function MGFINT78(_lJob)
    Local _cArqSem  := ""
    
    Default _lJob := .T.

    u_MFConOut("Inicio............: " + time() + " - " + DtoC( dDataBase )  )
    
    _cArqSem := AllTrim(SuperGetMV("MGF_INT72A",.F.,"\DESPACHANTE\"))+"semaforo_email.lck"
        
    If File(_cArqSem)   //Se existir o semáforo.
        If _lJob
            u_MFConOut("Semáforo existente (Processo iniciado em "+MemoRead(_cArqSem)+")"  )
        Else
            u_MGFmsg("Semáforo existente (Processo iniciado em "+MemoRead(_cArqSem)+")","MENSAGEM - MGFINT78")
        EndIf
    Else
        If _lJob
            INT78Proc(_lJob)
        Else
            Processa({|| INT78Proc(_lJob) }, "Conectando a caixa de e-mail e Processando...")
        EndIf
        
        If _lJob
            u_MFConOut("Final.............: " + time() + " - " + DtoC( dDataBase )  )
        Else
            u_MGFmsg("Importação finalizada, verifique a pasta parametrizada","MENSAGEM - MGFINT78")
        EndIf
            
        FErase(_cArqSem)
    EndIf
Return




/*/
{Protheus.doc} INT78Proc
	Função de processamento inicial.

@description
    Definições de Pastas de gravação e dados da conta de email a Conectar. 

@author Marcos Cesar Donizeti Vieira
@since 17/09/2020

@version P12.1.017
@country Brasil
@language Português
/*/
Static Function INT78Proc(_lJob)
    Private _cDirBase   := GetSrvProfString("RootPath", "")
    Private _cDirPad    := AllTrim(SuperGetMV("MGF_INT72A",.F.,"\DESPACHANTE\"))
    Private _cDirFull   := ""
    Private _cConta     := ""
    Private _cSenha     := ""
    Private _cSrvFull   := ""
    Private _cServer    := ""
    Private _nPort      := 0

    //--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
	If !ExisteSx6("MGF_INT78A")
		CriarSX6("MGF_INT78A", "C", "Caixa de e-mail dos Despachantes."	                , 'despachantes@marfrig.com.br' )	
	EndIf

    If !ExisteSx6("MGF_INT78B")
		CriarSX6("MGF_INT78B", "C", "Senha da Caixa de e-mail dos Despachantes."	    , 'UMrUyPW?' )	
	EndIf

    If !ExisteSx6("MGF_INT78C")
		CriarSX6("MGF_INT78C", "C", "Server e Porta da caixa e-mail dos Despachantes."  , 'outlook.office365.com:993' )	
	EndIf

    If !ExisteSx6("MGF_INT78D")
		CriarSX6("MGF_INT78D","L", "Habilita rotina Importar E-mails Despachantes?"		, '.F.' )	
	EndIf

    If SuperGetMV("MGF_INT78D",.F., '.T.' ) //Executa a rotina
        //-----| Definindo dados da conta |-----\
        _cConta    := AllTrim(SuperGetMV("MGF_INT78A",.F.,"despachantes@marfrig.com.br"))    
        _cSenha    := AllTrim(SuperGetMV("MGF_INT78B",.F.,"UMrUyPW?"))     
        _cSrvFull  := AllTrim(SuperGetMV("MGF_INT78C",.F.,"outlook.office365.com:993" ))
        _cServer   := Iif(':' $ _cSrvFull, SubStr(_cSrvFull, 1, At(':', _cSrvFull)-1), _cSrvFull)               
        _nPort     := Iif(':' $ _cSrvFull, Val(SubStr(_cSrvFull, At(':', _cSrvFull)+1, Len(_cSrvFull))), 110)   
        
        If SubStr(_cDirBase, Len(_cDirBase), 1) == '\'      //Se o último caracter for barra, retira.
            _cDirBase := SubStr(_cDirBase, 1, Len(_cDirBase)-1)
        EndIf
        
        _cDirFull := _cDirBase + _cDirPad       //Pasta onde serão gravados os arquivos (RootPath+conteúdo do parâmetro MGF_INT72A)
        
        INT78Imp(_lJob)      //Faz a importação dos arquivos
    EndIf

Return




/*/
{Protheus.doc} INT78Imp
	Função de importação.

@description
    Conectar a caixa de e-mail, ler e-mails contido nas caixa de entrada, verificar arquivos .TXT, 
    baixar arquivos para pasta Protheus e mover da caixa de entrada para uma pasta de importados no emails alvo. 

@author Marcos Cesar Donizeti Vieira
@since 17/09/2020

@version P12.1.017
@country Brasil
@language Português
/*/
Static Function INT78Imp(_lJob)
    Local _aArea := GetArea()
    Local _cArqINI
    Local _cBkpConf
    Local _nRet
    Local _nNumMsg
    Local _nMsgAtu
    Local _nAnxAtu
    Local _nTotAnx
    Local _aInfAnx
    Local _cMensBx
    Local _lImport  := .F. 
    Local _lErroImp := .F.

    Local oManager
    Local oMessage
     
    //-----| Altera o arquivo appserver.ini para IMAP |-----\\
    _cArqINI  := GetSrvIniName()
    _cBkpConf := GetPvProfString( "MAIL", "Protocol", "", _cArqINI )
    WritePProString('MAIL', 'PROTOCOL', 'IMAP', _cArqINI)

    //-----| Criar a conexão |-----\\
    oManager := tMailManager():New()
    oManager:SetUseSSL(.T.)
    oManager:SetUseTLS(.T.)
    oManager:Init(_cServer, "", _cConta, _cSenha, _nPort, 0)
     
    If oManager:SetPopTimeOut(120) != 0     //TimeOut em 02 minutos
        If _lJob
            u_MFConOut("Falha ao setar, timeout"  )
        Else
            u_MGFmsg("Falha ao setar, timeout","MENSAGEM - MGFINT78")
        EndIf
    Else  
        
        _nRet := oManager:IMAPConnect()     //Faz a conexão com IMAP, se conectar com sucesso retorna 0.
         
        If _nRet != 0
            If _lJob
                u_MFConOut("Falha ao conectar, Error - "+StrZero(_nRet,6), oManager:GetErrorString(_nRet)  )
            Else
                u_MGFmsg("Falha ao conectar, Error - "+StrZero(_nRet,6), oManager:GetErrorString(_nRet),"MENSAGEM - MGFINT78")
            EndIf             
        Else
            If _lJob
                u_MFConOut("Conectado com sucesso")
            EndIf

            _nNumMsg := 0
            oManager:GetNumMsgs(@_nNumMsg)      //Busca o número de mensagens na caixa de entrada.
             
            If _nNumMsg > 0     //Se houver mensagens a serem processadas
                If _lJob
                    u_MFConOut("Iniciando importação de arquivos .TXT"  )
                Else
                    ProcRegua(_nNumMsg)
                EndIf 
                
                For _nMsgAtu := 1 To 3 //_nNumMsg       //Percorre o número de mensagens
                    If _lJob
                        u_MFConOut("Baixando e-Mail "+cValToChar(_nMsgAtu)+" de "+cValToChar(_nNumMsg)+"..."  )
                    Else
                        IncProc("Baixando e-Mail "+cValToChar(_nMsgAtu)+" de "+cValToChar(_nNumMsg)+"...")
                    EndIf

                    oMessage := tMailMessage():new()        //Buscando a mensagem atual
                    oMessage:Clear()
                    oMessage:Receive(oManager, _nMsgAtu)

                    _nTotAnx := oMessage:GetAttachCount()   //Busca o total de Anexos no e-mail
                    _lImport := .F. 
                    _lErroImp:= .F.

                    For _nAnxAtu := 1 To _nTotAnx       //Percorre todos os anexos do e-mail
                        _aInfAnx := oMessage:GetAttachInfo(_nAnxAtu)

                        If _lJob
                            u_MFConOut("Processando mensagem "+oMessage:cSubject )
                        Else
                            IncProc("MGFINT78 - Processando mensagem "+oMessage:cSubject+"...")
                        EndIf
                         
                        If !Empty(_aInfAnx[1]) .And. Upper(Right(AllTrim(_aInfAnx[1]),4)) == '.TXT'    //Se tiver conteúdo, e for do tipo TXT.
                            
                            If oMessage:SaveAttach(_nAnxAtu, _cDirFull + _aInfAnx[1])   //Salva o arquivo na pasta, retorna .T. caso baixe.
                                _cMensBx := " [MGFINT78] * * * * * Email lido e Anexo importado * * * * *"+CRLF
                                _cMensBx += " [MGFINT78] Conta de e-mail Origem...: "+_cConta+CRLF
                                _cMensBx += " [MGFINT78] Numero da mensagem.......: "+cValToChar(_nMsgAtu)+CRLF
                                _cMensBx += " [MGFINT78] Assunto..................: "+oMessage:cSubject+CRLF
                                _cMensBx += " [MGFINT78] Recebido de..............: "+oMessage:cFrom+CRLF
                                _cMensBx += " [MGFINT78] Anexo baixado............: "+StrZero(_nAnxAtu,3)+" - "+_aInfAnx[1]+CRLF
                                _cMensBx += " [MGFINT78] * * * * * * * * * * * * * * * * * * * * * * * * *"

                                If _lJob
                                    u_MFConOut(_cMensBx)
                                EndIf    

                                _lImport := .T.                              
                            Else
                                If _lJob
                                    u_MFConOut("Erro ao salvar o anexo "+cValToChar(_nAnxAtu)+" - "+_aInfAnx[1])
                                Else
                                    u_MGFmsg("Erro ao salvar o anexo "+cValToChar(_nAnxAtu)+" - "+_aInfAnx[1],"MENSAGEM - MGFINT78")
                                EndIf
                                _lErroImp := .T.
                            EndIf
                        EndIf
                    Next _nAnxAtu

                    If _lImport // Se importou para pasta parametrizada, mover e-mail para pasta de Importados da caixa de e-mail.
                        If (oManager:MoveMsg(_nMsgAtu, "Importados"))
                            If _lJob
                                u_MFConOut("Mensagem movida para pasta Importados da caixa de e-mail: "+_cConta)
                            EndIf
                        Else
                            If _lJob
                                u_MFConOut("Não foi possível mover a mensagem para a pasta Importados da caixa de e-mail: "+_cConta)
                            Else
                                u_MGFmsg("Não foi possível mover a mensagem Importados da caixa de e-mail: "+_cConta,"MENSAGEM - MGFINT78")
                            EndIf
                        EndIf
                    ElseIf !_lErroImp   //Se ocorreu erro na importação do TXT, mover para pasta Erros 
                        If (oManager:MoveMsg(_nMsgAtu, "Erros"))
                            If _lJob
                                u_MFConOut("Mensagem movida para pasta Erros da caixa de e-mail: "+_cConta)
                            EndIf
                        Else
                            If _lJob
                                u_MFConOut("Não foi possível mover a mensagem para a pasta Erros da caixa de e-mail: "+_cConta)
                            Else
                                u_MGFmsg("Não foi possível mover a mensagem para a pasta Erros da caixa de e-mail: "+_cConta,"MENSAGEM - MGFINT78")
                            EndIf
                        EndIf
                    Else    //Se não foi importado para pasta parametrizada, mover para pasta processados da caixa de e-mail.
                        If (oManager:MoveMsg(_nMsgAtu, "Processados"))
                            If _lJob
                                u_MFConOut("Mensagem movida para pasta Processados da caixa de e-mail: "+_cConta)
                            EndIf
                        Else
                            If _lJob
                                u_MFConOut("Não foi possível mover a mensagem para a pasta Processados da caixa de e-mail: "+_cConta)
                            Else
                                u_MGFmsg("Não foi possível mover a mensagem para a pasta Processados da caixa de e-mail: "+_cConta,"MENSAGEM - MGFINT78")
                            EndIf
                        EndIf
                    EndIf
                Next _nMsgAtu
            Else
                If _lJob
                    u_MFConOut("Não existem mensagens para processamento na Caixa de e-mail: "+_cConta)
                Else
                    u_MGFmsg("Não existem mensagens para processamento na Caixa de e-mail: "+_cConta,"MENSAGEM - MGFINT78")
                EndIf
            EndIf

            oManager:IMAPDisconnect()   //Desconecta do servidor IMAP
        EndIf
    EndIf
     
    WritePProString('MAIL', 'PROTOCOL', _cBkpConf, _cArqINI)    //Volta a configuração de Protocol no arquivo appserver.ini
     
    RestArea(_aArea)
Return