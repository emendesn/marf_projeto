#ifdef SPANISH
	#define STR0001 "Segmentos - "
	#define STR0002 "Visualizar"
	#define STR0003 "Modificar"
	#define STR0004 "Segmentos - "
	#define STR0005 "Atenci�n"
	#define STR0006 "�Solo desea visualizar los subsegmentos vinculados al segmento primario?"
	#define STR0007 "No"
	#define STR0008 "S�"
	#define STR0009 "�C�digo del segmento primario no informado!"
	#define STR0010 "Segmentos"
	#define STR0011 "Segmento primario"
	#define STR0012 "Subsegmentos"
	#define STR0013 "Segmento principal no puede ser igual al c�digo del segmento."
	#define STR0014 "Segmento principal no registrado."
	#define STR0015 "C�digo del segmento inv�lido."
	#define STR0016 "C�digo del segmento diferente del segmento en el archivo de la vinculaci�n."
	#define STR0017 "C�digo del segmento inv�lido."
	#define STR0018 "Atenci�n"
#else
	#ifdef ENGLISH
		#define STR0001 "Segments - "
		#define STR0002 "View"
		#define STR0003 "Edit"
		#define STR0004 "Segments - "
		#define STR0005 "Attention"
		#define STR0006 "View only subsegments related to the primary segment?"
		#define STR0007 "No"
		#define STR0008 "Yes"
		#define STR0009 "Primary segment code not entered!"
		#define STR0010 "Segments"
		#define STR0011 "Primary Segment"
		#define STR0012 "Subsegments"
		#define STR0013 "Parent segment cannot be equal to Segment Code."
		#define STR0014 "Parent segment not registered."
		#define STR0015 "Invalid Segment Code."
		#define STR0016 "Segment code different than the segment in binding register."
		#define STR0017 "Invalid segment code!"
		#define STR0018 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Segmentos - " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Segmentos - " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Deseja visualizar somente os subsegmentos relacionados ao segmento prim�rio?" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "N�o" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Sim" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "C�digo do segmento prim�rio n�o informado!" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Segmentos" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Segmento Prim�rio" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Subsegmentos" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Segmento pai n�o pode ser igual ao c�digo do segmento." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Segmento pai n�o cadastrado." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "C�digo do Segmento invalido." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "C�digo do segmento diferente do segmento no cadastro da amarra��o." )
		#define STR0017 "C�digo do segmento inv�lido!"
		#define STR0018 "Aten��o"
	#endif
#endif
