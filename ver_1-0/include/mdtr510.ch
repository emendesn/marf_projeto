#ifdef SPANISH
	#define STR0001 "Certificado Medico"
	#define STR0002 "De Ficha Medica    ?"
	#define STR0003 "A Ficha Medica     ?"
	#define STR0004 "�De Fecha          ?"
	#define STR0005 "�A  Fecha          ?"
	#define STR0006 "�De CID            ?"
	#define STR0007 "�A  CID            ?"
	#define STR0008 "PROGRAMA DE CONTROL MEDICO DE SALUD OCUPACIONAL"
	#define STR0009 "COMUNICACION INTERNA DE CERTIFICADOS POR FALTA AL TRABAJO"
	#define STR0010 "Unidad:"
	#define STR0011 "Fecha:"
	#define STR0012 "Doc.Id."
	#define STR0013 "NOMBRE"
	#define STR0014 "PERIODO DE LICENCIA"
	#define STR0015 "OBSERVACIONES"
	#define STR0016 "MEDICO"
	#define STR0017 "AUXILIAR DE ENFERMERIA"
	#define STR0018 "MATRICULA"
	#define STR0019 "�De Cliente?"
	#define STR0020 "Codigo del cliente. El campo puede permanecer vacio para considerar desde el primer codigo."
	#define STR0021 "Tienda"
	#define STR0022 "Codigo de la tienda del cliente. El campo puede permanecer vacio para considerar desde el primer codigo."
	#define STR0023 "�A Cliente?"
	#define STR0024 "Codigo del cliente. El campo puede rellenarse con la letra Z hasta el final para considerar el ultimo codigo."
	#define STR0025 "Codigo de la tienda del cliente. El campo puede rellenarse con la letra Z hasta el final para considerar el ultimo codigo."
	#define STR0026 "�A CID ?"
	#define STR0027 "�De  CID ?"
	#define STR0028 "�A Fecha    ?"
	#define STR0029 "�De Fecha ?"
	#define STR0030 "�A Ficha Medica?"
	#define STR0031 "�De Ficha Medica ?"
	#define STR0032 "COMUNICACION  INTERNA  DE CERTIFICADOS  POR  FALTA  AL  TRABAJO"
	#define STR0033 "Informe de que centro de costo desea filtrar. El campo puede permanecer vacio para que se tenga en cuenta desde el primer c�digo."
	#define STR0034 "Informe hasta cual centro de costo desea filtrar. El campo puede rellenarse con la letra Z hasta el final para considerar el ultimo codigo."
	#define STR0035 "�De Centro de Costo?"
	#define STR0036 "�A Centro de Costo?"
	#define STR0037 "�De Funcion?"
	#define STR0038 "�A Funcion?"
	#define STR0039 "Informe de que funcion desea filtrar. El campo puede permanecer vacio para que se tenga en cuenta desde el primer c�digo."
	#define STR0040 "Informe hasta que funcion desea filtrar. El campo puede rellenarse con la letra Z hasta el final para considerar el ultimo codigo."
	#define STR0041 "Considera Cert. o Lic."
	#define STR0042 "Certificado"
	#define STR0043 "Licencia"
	#define STR0044 "Determina si se considerara la fecha del Certificado Medico o la fecha de las Licencias."
#else
	#ifdef ENGLISH
		#define STR0001 "Health Certificate"
		#define STR0002 "From Medical Rep.  ?"
		#define STR0003 "To Medical Rep.    ?"
		#define STR0004 "From Date          ?"
		#define STR0005 "To Date            ?"
		#define STR0006 "From CID             ?"
		#define STR0007 "To CID            ?"
		#define STR0008 "OCCUPATIONAL HEALTH MEDICAL CONTROL PROGRAM"
		#define STR0009 "MEDICAL REPORTS INTERNAL COMMUNICATION FOR WORK ABSENCE"
		#define STR0010 "Unit:"
		#define STR0011 "Date:"
		#define STR0012 "I.D."
		#define STR0013 "NAME"
		#define STR0014 "ABSENCE PERIOD"
		#define STR0015 "NOTES"
		#define STR0016 "DOCTOR"
		#define STR0017 "NURSING ASSISTANT"
		#define STR0018 "REGISTRAT"
		#define STR0019 "From Customer ?"
		#define STR0020 "Customer Code. Leave the field blank to consider since the first code."
		#define STR0021 "Unit"
		#define STR0022 "Customer code unit. Leave the field blank to consider since the first code."
		#define STR0023 "To Customer ?"
		#define STR0024 "Customer code. Fill in the field with Z up to its limit to consider the last code."
		#define STR0025 "Customer unit code. Fill in the field with Z up to its limit to consider the last code."
		#define STR0026 "To ICD?"
		#define STR0027 "From ICD?"
		#define STR0028 "To Date?"
		#define STR0029 "From Date?"
		#define STR0030 "To Medical Record?"
		#define STR0031 "From Medical Record?"
		#define STR0032 "INTERNAL COMMUNICATION OF CERTIFICATES DUE TO LACK OF WORK"
		#define STR0033 "Indicate from which cost center you want to filter. The field can remain empty to consider from the first code."
		#define STR0034 "Indicate until which cost center you want to filter. The field can be filled in with the letter Z until the end in order to consider the last code."
		#define STR0035 "From Cost Center?"
		#define STR0036 "To Cost Center?"
		#define STR0037 "From Function?"
		#define STR0038 "To Function ?"
		#define STR0039 "Enter until which Function you want to filter. The field can remain empty to consider from the first code."
		#define STR0040 "Select until which Function you want to filter. The field can be filled in with the letter Z until the end in order to consider the last code."
		#define STR0041 "Consider Certif or Leave"
		#define STR0042 "Certificate"
		#define STR0043 "Leave"
		#define STR0044 "Set to consider the Date of Medical Certificate or Leave Date."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Atestado M�dico", "Atestado Medico" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "De ficha m�dica    ?", "De Ficha Medica    ?" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "At� ficha m�dica   ?", "Ate Ficha Medica   ?" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Da data            ?", "De Data            ?" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "At� data           ?", "Ate Data           ?" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "De cid             ?", "De CID             ?" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "At� cid            ?", "Ate CID            ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Programa De Controlo M�dico De Sa�de Ocupacional", "PROGRAMA DE CONTROLE MEDICO DE SAUDE OCUPACIONAL" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Comunica��o Interna De Atestados Por Falta Ao Trabalho", "COMUNICACAO INTERNA DE ATESTADOS POR FALTA AO TRABALHO" )
		#define STR0010 "Unidade:"
		#define STR0011 "Data:"
		#define STR0012 "R. G."
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Nome", "NOME" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Per�odo De Afastamento", "PERIODO DE AFASTAMENTO" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Observa��es", "OBSERVACOES" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "M�dico", "MEDICO" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Auxiliar De Enfermagem", "RESPONS�VEL DE SA�DE" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Matr�cula", "MATRICULA" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "De cliente ?", "De Cliente ?" )
		#define STR0020 "C�digo do cliente. O campo pode permanecer vazio para considerar desde o primeiro c�digo."
		#define STR0021 "Loja"
		#define STR0022 "C�digo da loja do cliente. O campo pode permanecer vazio para considerar desde o primeiro c�digo."
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "At� cliente ?", "At� Cliente ?" )
		#define STR0024 "C�digo do cliente. O campo pode ser preenchido com a letra Z at� o final para considerar o �ltimo c�digo."
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "C�digo  da loja do cliente. o campo pode ser preenchido com a letra z at�  o final para considerar o �ltimo c�digo.", "C�digo da loja do cliente. O campo pode ser preenchido com a letra Z at� o final para considerar o �ltimo c�digo." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "At� CID ?", "Ate CID ?" )
		#define STR0027 "De CID ?"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "At� Data ?", "Ate Data ?" )
		#define STR0029 "De Data ?"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "At� Ficha M�dica ?", "Ate Ficha Medica ?" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "De Ficha M�dica ?", "De Ficha Medica ?" )
		#define STR0032 "COMUNICACAO  INTERNA  DE  ATESTADOS  POR  FALTA  AO  TRABALHO"
		#define STR0033 "Informe de qual centro de custo deseja filtrar. O campo pode permanecer vazio para considerar desde o primeiro c�digo."
		#define STR0034 "Informe at� qual centro de custo deseja filtrar. O campo pode ser preenchido com a letra Z at� o final para considerar at� o �ltimo c�digo."
		#define STR0035 "De Centro de Custo ?"
		#define STR0036 "At� Centro de Custo ?"
		#define STR0037 "De Fun��o ?"
		#define STR0038 "At� Fun��o ?"
		#define STR0039 "Informe de qual fun��o deseja filtrar. O campo pode permanecer vazio para considerar desde o primeiro c�digo."
		#define STR0040 "Informe at� qual fun��o deseja filtrar. O campo pode ser preenchido com a letra Z at� o final para considerar at� o �ltimo c�digo."
		#define STR0041 "Considerar Atest. ou Afast."
		#define STR0042 "Atestado"
		#define STR0043 "Afastamento"
		#define STR0044 "Determina se ser� considerado a Data do Atestado M�dico ou a Data dos Afastamentos."
	#endif
#endif
