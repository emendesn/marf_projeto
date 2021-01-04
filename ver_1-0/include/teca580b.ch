#ifdef SPANISH
	#define STR0001 "Gestion de turnos"
	#define STR0002 "Gestion de turnos"
	#define STR0003 "Cargo vs. Calendario"
	#define STR0004 "Cargo vs. Turno"
	#define STR0005 "Cargo vs. Empleado"
	#define STR0006 "Vinculo Feriado vs. Cargo"
	#define STR0007 "Vinculo Cargo vs. Turno"
	#define STR0008 "Vinculo Cargo vs. Empleado"
	#define STR0009 "Asignacion por turno"
	#define STR0010 "Asignacion automatica"
	#define STR0011 "Atencion"
	#define STR0012 "Para que sea posible ejecutar esta rutina, aplique el patch para las configuraciones del RR.HH."
	#define STR0013 "Memorandum"
	#define STR0014 "No es posible generar el memorandum para revisiones anteriores"
	#define STR0015 "¿Desea realmente generar los memorandums?"
	#define STR0016 "Permitido solamente para contratos vigentes"
	#define STR0017 "Contrato no ubicado."
	#define STR0018 "No existe contrato generado"
#else
	#ifdef ENGLISH
		#define STR0001 "Scale Management"
		#define STR0002 "Scale Management"
		#define STR0003 "Station x Calendar"
		#define STR0004 "Station x Schedule"
		#define STR0005 "Station x Employee"
		#define STR0006 "Relationship Holiday x Station"
		#define STR0007 "Relationship Station x Schedule"
		#define STR0008 "Relationship Station x Employee"
		#define STR0009 "Allocation by Scale"
		#define STR0010 "Automatic Allocation"
		#define STR0011 "Attention"
		#define STR0012 "To be able to run this routine, apply the patch for HR configurations!"
		#define STR0013 "Memorandum"
		#define STR0014 "Cannot create the memorandum for previous revisions"
		#define STR0015 "Do you really wish to create the memoranda?"
		#define STR0016 "For valid contracts only"
		#define STR0017 "Contract not found"
		#define STR0018 "No created contract exists"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Gestão de Escalas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Gestão de Escalas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Posto x Calendario" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Posto x Escala" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Posto x Funcionario" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Relacionamento FeriadoxPosto" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Relacionamento PostoXEscala" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Relacionamento PostoXFuncionario" )
		#define STR0009 "Alocação por escala"
		#define STR0010 "Alocação automatica"
		#define STR0011 "Atenção"
		#define STR0012 "Para que seja possivel executar essa rotina, aplique o patch para as configurações do RH!"
		#define STR0013 "Memorando"
		#define STR0014 "Não é possível gerar o memorando para revisões anteriores"
		#define STR0015 "Deseja realmente gerar os memorandos?"
		#define STR0016 "Permitido somente para contratos vigentes"
		#define STR0017 "Contrato não localizado"
		#define STR0018 "Não existe contrato gerado"
	#endif
#endif
