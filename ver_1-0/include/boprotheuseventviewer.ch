#Include "Protheus.ch"
#Include "Ap5mail.CH"
#Include "Style.CH"
                          
#Define PROFILE_PROG 'EVENTVIEW' // P_PROG no profile.usr
        
// Categorias (tabela interna)
#Define CAT_001 'Entrada no sistema'
#Define CAT_002 'Relatorio iniciado'
#Define CAT_003 'Termino processo'

#ifdef SPANISH
	#define STR0001 'n�o preenchido'
	#define STR0002 'Categoria inv�lida'
	#define STR0003 'Evento inv�lido'  
	#define STR0004 'Usu�rio sem acesso a inscri�ao de eventos'  
	#define STR0005 'Pesquisar'
	#define STR0006 'Visualizar'
	#define STR0007 'Incluir'
	#define STR0008 'Alterar'
	#define STR0009 'Excluir'
	#define STR0010 'Sair'
	#define STR0011 'Canal'
	#define STR0012 'Categoria'
	#define STR0013 'Evento'
	#define STR0014 'C�digo'
	#define STR0015 'Descri��o'
	#define STR0016 'E-mail'
	#define STR0017 'RSS'
	#define STR0018 'Usu�rio'
	#define STR0019 'Inscri��o no Evento'
	#define STR0020 'Consulta Categoria'
	#define STR0021 'Evento n�o cadastrado'
	#define STR0022 'Sequencia'
	#define STR0023 'Eventos pendentes de leitura'
	#define STR0024 'Id do usu�rio'
	#define STR0025 'Id do Evento'
	#define STR0026 'Rotina'
	#define STR0027 'Inscri��o'
	#define STR0028 'Meio de Comunica�ao'
	#define STR0029 'N�o existem eventos para leitura'
	#define STR0030 'Canal, Categoria ou Evento inv�lidos'
	#define STR0031 'EventViewer JOB - Numero m�ximo de loops alcan�ado: '
	#define STR0032 'Clique no link para se inscrever no RSS'
	#define STR0033 'Empresa'
	#define STR0034 'Filial'
#else
	#ifdef ENGLISH
		#define STR0001 'n�o preenchido'
		#define STR0002 'Categoria inv�lida'
		#define STR0003 'Evento inv�lido'  
		#define STR0004 'Usu�rio sem acesso a inscri�ao de eventos'  
		#define STR0005 'Pesquisar'
		#define STR0006 'Visualizar'
		#define STR0007 'Incluir'
		#define STR0008 'Alterar'
		#define STR0009 'Excluir'
		#define STR0010 'Sair'
		#define STR0011 'Canal'
		#define STR0012 'Categoria'
		#define STR0013 'Evento'
		#define STR0014 'C�digo'
		#define STR0015 'Descri��o'
		#define STR0016 'E-mail'
		#define STR0017 'RSS'
		#define STR0018 'Usu�rio'
		#define STR0019 'Inscri��o no Evento'
		#define STR0020 'Consulta Categoria'
		#define STR0021 'Evento n�o cadastrado'
		#define STR0022 'Sequencia'
		#define STR0023 'Eventos pendentes de leitura'
		#define STR0024 'Id do usu�rio'
		#define STR0025 'Id do Evento'
		#define STR0026 'Rotina'
		#define STR0027 'Inscri��o'
		#define STR0028 'Meio de Comunica�ao'
		#define STR0029 'N�o existem eventos para leitura'
		#define STR0030 'Canal, Categoria ou Evento inv�lidos'
		#define STR0031 'EventViewer JOB - Numero m�ximo de loops alcan�ado: '
		#define STR0032 'Clique no link para se inscrever no RSS'
		#define STR0033 'Empresa'
		#define STR0034 'Filial'
	#else
		Static STR0001 := 'n�o preenchido'
		Static STR0002 := 'Categoria inv�lida'
		Static STR0003 := 'Evento inv�lido'  
		Static STR0004 := 'Usu�rio sem acesso a inscri�ao de eventos'  
		Static STR0005 := 'Pesquisar'
		Static STR0006 := 'Visualizar'
		Static STR0007 := 'Incluir'
		Static STR0008 := 'Alterar'
		Static STR0009 := 'Excluir'
		Static STR0010 := 'Sair'
		Static STR0011 := 'Canal'
		Static STR0012 := 'Categoria'
		Static STR0013 := 'Evento'
		Static STR0014 := 'C�digo'
		Static STR0015 := 'Descri��o'
		Static STR0016 := 'E-mail'
		Static STR0017 := 'RSS'
		Static STR0018 := 'Usu�rio'
		Static STR0019 := 'Inscri��o no Evento'
		Static STR0020 := 'Consulta Categoria'
		Static STR0021 := 'Evento n�o cadastrado'
		Static STR0022 := 'Sequencia'
		Static STR0023 := 'Eventos pendentes de leitura'
		Static STR0024 := 'Id do usu�rio'
		Static STR0025 := 'Id do Evento'
		Static STR0026 := 'Rotina'
		Static STR0027 := 'Inscri��o'
		Static STR0028 := 'Meio de Comunica�ao'
		Static STR0029 := 'N�o existem eventos para leitura'
		Static STR0030 := 'Canal, Categoria ou Evento inv�lidos'
		Static STR0031 := 'EventViewer JOB - Numero m�ximo de loops alcan�ado: '
		Static STR0032 := 'Clique no link para se inscrever no RSS'
		Static STR0033 := 'Empresa'
		Static STR0034 := 'Filial'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := ""
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
