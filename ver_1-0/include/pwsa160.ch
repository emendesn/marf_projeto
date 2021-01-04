#ifdef SPANISH
	#define STR0001 "Justificaciones de Horario"
	#define STR0002 "Justificativas abono previo"
	#define STR0003 "Error"
	#define STR0004 "�Aprobacion grabada con exito!"
	#define STR0005 "�Reprobacion grabada con exito!"
	#define STR0006 "Atenci�n"
	#define STR0007 "Entre en contacto con el administrador para aplicar el compatibilizador 05 - Creaci�n del �ndice de rutina en la tabla AI8 del compatibilizador del m�dulo SIGATCF."
#else
	#ifdef ENGLISH
		#define STR0001 "Hours Justification"
		#define STR0002 "Pre-waiver Justifications"
		#define STR0003 "Error"
		#define STR0004 "Approval saved successfully"
		#define STR0005 "Reproval saved successfully"
		#define STR0006 "Attention"
		#define STR0007 "Contact administrator to apply compatibility program 05 - Creation of Index from routine in AI8 table of SIGATCF module compatibility program."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Justificativas de Hor�rio", "Erro" )
		#define STR0002 "Justificativas pr�-abono"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Erro", "Operacao realizada com sucesso" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Aprova��o Gravada com successo.", "Aprovacao Gravada com sucesso" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Reprova��o gravada com successo.", "Reprovacao Gravada com sucesso" )
		#define STR0006 "Aten��o"
		#define STR0007 "Contate o administrador para aplicar o compatibilizador 05 - Cria��o do �ndice de rotina na tabela AI8 do compatibilizador do m�dulo SIGATCF."
	#endif
#endif
