#ifdef SPANISH
	#define STR0001 "�N� O.S. seguimiento?"
	#define STR0002 "Informe una orden de seguimiento finalizada."
#else
	#ifdef ENGLISH
		#define STR0001 "Follow-up S.O. number?"
		#define STR0002 "Enter a finished follow-up order. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N� Os Acompanhamento?", "Num. O.s Acompanhamento?" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Indique uma ordem de acompanhamento conclu�da.", "Informe uma ordem de acompanhamento finalizada." )
	#endif
#endif
