#INCLUDE 'Protheus.ch'

#IFDEF SPANISH
	#DEFINE STR0001 "O objeto nao � um xml de rss v�lido!"
	#DEFINE STR0002 "Tag rss inexistente."
	#DEFINE STR0003 "Sem informa��o de vers�o."
	#DEFINE STR0004 "Vers�o n�o suportada."
	#DEFINE STR0005 "Tag channel inexistente."
	#DEFINE STR0006 "Arquivo n�o foi criado!"
	#DEFINE STR0007 "Reinicialize o programa para visualiza��es html serem habilitadas!"
	#DEFINE STR0008 "N�o foi poss�vel acessar o rss!"
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 "O objeto nao � um xml de rss v�lido!"
		#DEFINE STR0002 "Tag rss inexistente."
		#DEFINE STR0003 "Sem informa��o de vers�o."
		#DEFINE STR0004 "Vers�o n�o suportada."
		#DEFINE STR0005 "Tag channel inexistente."
		#DEFINE STR0006 "Arquivo n�o foi criado!"
		#DEFINE STR0007 "Reinicialize o programa para visualiza��es html serem habilitadas!"
		#DEFINE STR0008 "N�o foi poss�vel acessar o rss!"
	#ELSE
		#DEFINE STR0001 "O objeto nao � um xml de rss v�lido!"
		#DEFINE STR0002 "Tag rss inexistente."
		#DEFINE STR0003 "Sem informa��o de vers�o."
		#DEFINE STR0004 "Vers�o n�o suportada."
		#DEFINE STR0005 "Tag channel inexistente."
		#DEFINE STR0006 "Arquivo n�o foi criado!"
		#DEFINE STR0007 "Reinicialize o programa para visualiza��es html serem habilitadas!"
		#DEFINE STR0008 "N�o foi poss�vel acessar o rss!"
	#ENDIF
#ENDIF

#xTranslate PropType(<bBlock>[, <lExecute>]) => TypeProp(<{bBlock}>[, <lExecute>])