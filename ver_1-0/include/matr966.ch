#ifdef SPANISH
	#define STR0001 "Form. de Informacion de Operaciones y Prestacion Inteprovinciales - GI-ICMS"
	#define STR0002 "Iprime formulario de Informacion de Operaciones y Prestaciones"
	#define STR0003 "Interprovinciales- GI-ICMS de acuerdo con lo informado"
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "( Continua... )"
	#define STR0007 "|    Entradas de Mercaderias, Bienes o Adquisicion de Servicios                                                                   |"
	#define STR0008 "|    |                        |                        |                        |                ICMS Cobrado por                 |"
	#define STR0009 "|    |                        |                        |                        |              Sustitucion Tributaria             |"
	#define STR0010 "|PROV|         Valor          |        Base de         |          Otras         +------------------------+------------------------+"
	#define STR0011 "|    |        Contable        |        Calculo         |                        |          Petroleo      |         Otros          |"
	#define STR0012 "|    |                        |                        |                        |          Energia       |        Productos       |"
	#define STR0013 "ANULADO POR EL OPERADOR"
	#define STR0014 "|TOTAL"
	#define STR0015 "|    Salidas de Mercaderias o Prestacion de Servicios                                                                              |"
	#define STR0016 "|    |            Valor Contable               |                Base de Calculo          |                    |       ICMS         |"
	#define STR0017 "|PROV|                                         |                                         |       Otras        |    Cobrado por     |"
	#define STR0018 "|    +--------------------+--------------------+--------------------+--------------------+                    |   Sust. Tributaria |"
	#define STR0019 "|    |   No Contribuyente |     Contribuyente  |   No Contribuyente |     Contribuyente  |                    |                    |"
#else
	#ifdef ENGLISH
		#define STR0001 "Interstate Operations and Installm. Information Form - GI-ICMS"
		#define STR0002 "It will print the Interstate Operations and Installments"
		#define STR0003 "Information Form (GI-ICMS) according to selected parameters"
		#define STR0004 "Z.Form"
		#define STR0005 "Management"
		#define STR0006 "( To be continued... )"
		#define STR0007 "|    Inflow of Goods, Assets or Service Acquisition                                                                               |"
		#define STR0008 "|    |                        |                        |                        |                ICMS Collected by                |"
		#define STR0009 "|    |                        |                        |                        |             Tributary Replacement               |"
		#define STR0010 "| ST |       Accounting       |      Calculation       |         Other          +------------------------+------------------------+"
		#define STR0011 "|    |         Value          |         Basis          |                        |         Petroleum      |        Other           |"
		#define STR0012 "|    |                        |                        |                        |          Energy        |        Products        |"
		#define STR0013 "CANCELLED BY THE OPERATOR"
		#define STR0014 "|TOTAL"
		#define STR0015 "|    Outflow of Goods and/or Rendering of Service                                                                              |"
		#define STR0016 "|    |             Accouting Value             |            Calculation Basis            |                    |       ICMS         |"
		#define STR0017 "| ST |                                         |                                         |       Other        |    Collected by    |"
		#define STR0018 "|    +--------------------+--------------------+--------------------+--------------------+                    |  Trib.Replacement  |"
		#define STR0019 "|    |   Non-Contributor  |       Contributor  |   Non-Contributor  |       Contributor  |                    |                    |"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Guia De Informa��o Das Opera��es E Presta��es Interestaduais - Gi-icms", "Guia de Informacao das Operacoes e Prestacoes Interestaduais - GI-ICMS" )
		#define STR0002 "Ir� imprimir Guia de Informa��o das Opera�oes e Prestacoes"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Interestaduais - gi-icms conforme os par�metro s informados", "Interestaduais - GI-ICMS conforme os parametros informados" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "( continua... )", "( Continua... )" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "|    entradas de mercadorias, bens ou aquisi��es de servi�o  s                                                                      |", "|    Entradas de Mercadorias, Bens ou Aquisicoes de Servicos                                                                      |" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "|    |                        |                        |                        |                icms cobrado por                 |", "|    |                        |                        |                        |                ICMS Cobrado por                 |" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "|    |                        |                        |                        |             substitui��o tributaria             |", "|    |                        |                        |                        |             Substituicao Tributaria             |" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "| uf |         valor          |        base de         |         outras         +------------------------+------------------------+", "| UF |         Valor          |        Base de         |         Outras         +------------------------+------------------------+" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "|    |        contabil        |        c�lculo         |                        |          petroleo      |        outros          |", "|    |        Contabil        |        Calculo         |                        |          Petroleo      |        Outros          |" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "|    |                        |                        |                        |          energia       |        produtos        |", "|    |                        |                        |                        |          Energia       |        Produtos        |" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "|total", "|TOTAL" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "|    saidas de mercadorias e/ou presta��o de servi�o  s                                                                              |", "|    Saidas de Mercadorias e/ou Prestacao de Servicos                                                                              |" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "|    |            valor contabil               |                base de c�lculo          |                    |       icms         |", "|    |            Valor Contabil               |                Base de Calculo          |                    |       ICMS         |" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "| uf |                                         |                                         |      outras        |    cobrado por     |", "| UF |                                         |                                         |      Outras        |    Cobrado por     |" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "|    +--------------------+--------------------+--------------------+--------------------+                    |  subst. tributaria |", "|    +--------------------+--------------------+--------------------+--------------------+                    |  Subst. Tributaria |" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "|    |   n�o contribuinte |       contribuinte |   n�o contribuinte |       contribuinte |                    |                    |", "|    |   Nao Contribuinte |       Contribuinte |   Nao Contribuinte |       Contribuinte |                    |                    |" )
	#endif
#endif
