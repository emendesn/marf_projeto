#ifdef SPANISH
	#define STR0001 "Declaraciones de tiempo de contribucion"
	#define STR0002 "Historial / Mantenimiento"
	#define STR0003 "Historial de las declaraciones de tiempo de contribucion"
	#define STR0004 "Declaraciones de tiempo de contribucion"
	#define STR0005 "Incluye declaracion"
	#define STR0006 "Borra declaracion"
	#define STR0007 "Declaracion de tiempo de contribucion"
	#define STR0008 "1=Tiempo para declaracion de contribucion en otros organos"
	#define STR0009 "2=Tiempo simple o el doble de Licencia - Prima Quinquenal y Vacaciones no gozadas"
	#define STR0010 "1=RGPS (INSS)"
	#define STR0011 "2=RPPS (Seguridad Social Propia)"
	#define STR0012 "1=Estatutario"
	#define STR0013 "2=CLT"
	#define STR0014 "Sucursal:"
	#define STR0015 "Matricula:"
	#define STR0016 "Tp. declaracion:"
	#define STR0017 "Fecha de declaracion"
	#define STR0018 "Tp. regimen"
	#define STR0019 "Sesion"
	#define STR0020 "Num. partida"
	#define STR0021 "Fecha partida"
	#define STR0022 "Organo Exped."
	#define STR0023 "De periodo"
	#define STR0024 "A periodo"
	#define STR0025 "Ent.Contrib."
	#define STR0026 "Tiempo bruto"
	#define STR0027 "Deducciones"
	#define STR0028 "Tiempo Net."
	#define STR0029 "Tipo de registro de informacion"
	#define STR0030 "Seleccione la modalidad"
	#define STR0031 '"N" - Nuevo'
	#define STR0032 '"H" - Historial'
	#define STR0033 "Ya hay declaracion para este periodo. Verifique las informaciones."
	#define STR0034 "�Atencion!"
	#define STR0035 "�Desea borrar la declaracion seleccionada? "
	#define STR0036 "�Borrado no autorizado! Declaracion tiene item ya publicado."
	#define STR0037 "�Borrado no autorizado! Declaraciones creadas como H-Historial no se pueden borrar."
	#define STR0038 "Por favor, informe el Tipo de Declaracion."
	#define STR0039 "Por favor, informe la fecha de declaracion."
	#define STR0040 "Por favor, informe el tipo de regimen de la declaracion."
	#define STR0041 "Por favor, informe la sesion."
	#define STR0042 "Por favor, informe el numero de la partida declarada."
	#define STR0043 "Por favor, informe la fecha de la partida declarada."
	#define STR0044 "Por favor, informe el organo de expedicion de la partida declarada."
	#define STR0045 "Por favor, informe el inicio del periodo declarado."
	#define STR0046 "Por favor, informe el fin del periodo declarado."
	#define STR0047 "Por favor, informe la entidad de contribucion."
	#define STR0048 "Por favor, informe el numero de dias brutos relativos al periodo declarado."
	#define STR0049 "Numero de dias relativos a las deducciones esta superior al tiempo bruto."
	#define STR0050 "3=Tiempo de comision antes de realizacion"
#else
	#ifdef ENGLISH
		#define STR0001 "Contribution Time Annotations"
		#define STR0002 "History / Maintenance"
		#define STR0003 "Contribution Time Annotations History"
		#define STR0004 "Contribution Time Annotations"
		#define STR0005 "Add Annotation"
		#define STR0006 "Delete Annotation"
		#define STR0007 "Contribution Time Annotation"
		#define STR0008 "1=Time for Annotation of Contribution in Other Bodies"
		#define STR0009 "2=Simple Time or Doubled for License-Bonus and Vacations Not Taken"
		#define STR0010 "1=RGPS (INSS)"
		#define STR0011 "2=RPPS (Own Social Security)"
		#define STR0012 "1=Statutory"
		#define STR0013 "2=CLT"
		#define STR0014 "Branch:"
		#define STR0015 "Registration:"
		#define STR0016 "Annotation Tp.:"
		#define STR0017 "Annotation Date"
		#define STR0018 "Regime Tp."
		#define STR0019 "Session"
		#define STR0020 "Certificate No."
		#define STR0021 "Certificate Date"
		#define STR0022 "Issuing Body"
		#define STR0023 "Period from"
		#define STR0024 "Period to"
		#define STR0025 "Contrib.Ent."
		#define STR0026 "Gross Time"
		#define STR0027 "Deductions"
		#define STR0028 "Net Time"
		#define STR0029 "Information Record Type"
		#define STR0030 "Select Modality"
		#define STR0031 ''N' - New'
		#define STR0032 '"H" - Hist�rico'
		#define STR0033 "Annotation already exists for this period. Check the information."
		#define STR0034 "Attention!"
		#define STR0035 "Do you wish to delete the annotation selected? "
		#define STR0036 "Deletion not authorized! Annotation has item already published."
		#define STR0037 "Deletion not authorized! Annotations created as H-Historical cannot be deleted."
		#define STR0038 "Please enter Annotation Type."
		#define STR0039 "Please enter Annotation Date."
		#define STR0040 "Please enter Annotation System Type."
		#define STR0041 "Please enter Session."
		#define STR0042 "Please enter Annotated Certificate Number."
		#define STR0043 "Please enter Annotated Certificate Date."
		#define STR0044 "Please enter Issuing Body of Annotated Certificate."
		#define STR0045 "Please enter Annotated Period Beginning."
		#define STR0046 "Please enter Annotated Period End."
		#define STR0047 "Please enter the Contribution Entity."
		#define STR0048 "Please enter the Number of Gross Days Relative to Annotated Period."
		#define STR0049 "Number of Days Relative to Deductions higher than Gross Time."
		#define STR0050 "3=Commission time before effectivation"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Averba��es de Tempo de Contribui��o" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Hist�rico / Manuten��o" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Hist�rico das Averba��es de Tempo de Contribui��o" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Averba��es de Tempo de Contribui��o" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Inclui Averba��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Exclui Averba��o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Averba��o de Tempo de Contribui��o" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "1=Tempo para Averba��o de Contribui��o em Outros �rg�os" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "2=Tempo Simples ou em Dobro de Licen�a-Pr�mio e F�rias N�o Gozadas" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "1=RGPS (INSS)" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "2=RPPS (Previd�ncia Pr�pria)" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "1=Estatut�rio" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "2=CLT" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Filial:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Matr�cula:" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Tp.Averba��o:" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Data da Averba��o" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Tp.Regime" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Sess�o" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Num.Certid�o" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Data Certid�o" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "�rg�o Exped." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Per�odo De" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Per�odo At�" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Ent.Contrib." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Tempo Bruto" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Dedu��es" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Tempo Liq." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Tipo de Registro da Informa��o" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Selecione a Modalidade" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , '"N" - Novo' )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , '"H" - Hist�rico' )
		#define STR0033 "J� existe averba��o para este per�odo. Verifique as informa��es."
		#define STR0034 "Aten��o!"
		#define STR0035 "Deseja excluir a averba��o selecionada ? "
		#define STR0036 "Exclus�o n�o autorizada! Averba��o possui item j� publicado."
		#define STR0037 "Exclus�o n�o autorizada! Averba��es criadas como H-Historico n�o podem ser exclu�das."
		#define STR0038 "Favor informar o Tipo da Averba��o."
		#define STR0039 "Favor informar a Data da Averba��o."
		#define STR0040 "Favor informar o Tipo do Regime da Averba��o."
		#define STR0041 "Favor informar a Sess�o."
		#define STR0042 "Favor informar o N�mero da Certid�o Averbada."
		#define STR0043 "Favor informar a Data da Certid�o Averbada."
		#define STR0044 "Favor informar o �rg�o Expedidor da Certid�o Averbada."
		#define STR0045 "Favor informar o In�cio do Per�odo Averbado."
		#define STR0046 "Favor informar o Fim do Per�odo Averbado."
		#define STR0047 "Favor informar a Entidade de Contribui��o."
		#define STR0048 "Favor informar o N�mero de Dias Brutos Relativos ao Per�odo Averbado."
		#define STR0049 "N�mero de Dias Relativos �s Dedu��es esta superior ao Tempo Bruto."
		#define STR0050 "3=Tempo de comissionado antes da efetiva��o"
	#endif
#endif
