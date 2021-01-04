#INCLUDE 'Protheus.ch'

#IFDEF SPANISH
	#DEFINE STR0001 "O objeto nao é um xml de rss válido!"
	#DEFINE STR0002 "Tag rss inexistente."
	#DEFINE STR0003 "Sem informação de versão."
	#DEFINE STR0004 "Versão não suportada."
	#DEFINE STR0005 "Tag channel inexistente."
	#DEFINE STR0006 "Arquivo não foi criado!"
	#DEFINE STR0007 "Reinicialize o programa para visualizações html serem habilitadas!"
	#DEFINE STR0008 "Não foi possível acessar o rss!"
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 "O objeto nao é um xml de rss válido!"
		#DEFINE STR0002 "Tag rss inexistente."
		#DEFINE STR0003 "Sem informação de versão."
		#DEFINE STR0004 "Versão não suportada."
		#DEFINE STR0005 "Tag channel inexistente."
		#DEFINE STR0006 "Arquivo não foi criado!"
		#DEFINE STR0007 "Reinicialize o programa para visualizações html serem habilitadas!"
		#DEFINE STR0008 "Não foi possível acessar o rss!"
	#ELSE
		#DEFINE STR0001 "O objeto nao é um xml de rss válido!"
		#DEFINE STR0002 "Tag rss inexistente."
		#DEFINE STR0003 "Sem informação de versão."
		#DEFINE STR0004 "Versão não suportada."
		#DEFINE STR0005 "Tag channel inexistente."
		#DEFINE STR0006 "Arquivo não foi criado!"
		#DEFINE STR0007 "Reinicialize o programa para visualizações html serem habilitadas!"
		#DEFINE STR0008 "Não foi possível acessar o rss!"
	#ENDIF
#ENDIF

#xTranslate PropType(<bBlock>[, <lExecute>]) => TypeProp(<{bBlock}>[, <lExecute>])