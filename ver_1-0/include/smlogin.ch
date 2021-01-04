#ifdef SPANISH 
	#DEFINE STR0001 "Atendimento On-line"
	#DEFINE STR0002 "Fechar"
	#DEFINE STR0003 "http://cloud.aloweb.com.br/website/?cl=46483200&dp=205632000"
	#DEFINE STR0004 "'manufatura', 'Manufatura', 'MANUFATURA'"
	#DEFINE STR0005 "Compartilhar em: "
#else
	#ifdef ENGLISH
		#DEFINE STR0001 "Atendimento On-line"
		#DEFINE STR0002 "Fechar"
		#DEFINE STR0003 "http://cloud.aloweb.com.br/website/?cl=46483200&dp=205632000"
		#DEFINE STR0004 "'manufatura', 'Manufatura', 'MANUFATURA'"
		#DEFINE STR0005 "Compartilhar em: "
	#else
		#DEFINE STR0001 "Atendimento On-line"
		#DEFINE STR0002 "Fechar"
		#DEFINE STR0003 "http://cloud.aloweb.com.br/website/?cl=46483200&dp=205632000"
		#DEFINE STR0004 "'manufatura', 'Manufatura', 'MANUFATURA'"
		#DEFINE STR0005 "Compartilhar em: "
	#endif
#endif

#xTranslate FOR EACH <Element> IN <Array> DO <Code,...> ;
					=> ForEach(<Array>, {|<Element>| <Code> })