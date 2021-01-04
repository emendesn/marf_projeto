#ifdef SPANISH
	#define STR0001 "Empresa No autorizada para el Template -> "
	#define STR0002 "Uso autorizado por la contrasena de emergencia"
	#define STR0003 "Uso por el Servidor Microsiga, se utilizara el Senhap"
	#define STR0004 'Uso del TOPConnect autorizado por contrasena de emergencia'
	#define STR0005 "La licencia actual y de la version: "
	#define STR0006 "Empresa sin CNPJ para aprobacion corporativa"
	#define STR0007 "CNPJ "
	#define STR0008 " no autorizado para aprobacion corporativa"
	#define STR0009 "El Protheus se esta utilizando en el modo Corporativo,"
	#define STR0010 "sin embargo el CNPJ de alguna(s) empresa(s) no esta(n) autorizado(s)."
	#define STR0011 "Contactese con el Departamento de Aprobacion de Conrasenas para regularizar el CNPJ de estas empresas."
	#define STR0012 "La autorizacion del CNPJ vencera en "
	#define STR0013 " dia(s)."
	#define STR0014 "Hardlock sin CNPJ para aprobacion corporativa"
	#define STR0015 "pero el Hardlock no contiene ningun CNPJ."
	#define STR0016 "Entre en contacto con el Departamento de Aprobacion de Contrasenas para regularizar los CNPJ."
	#define STR0017 "Problemas al leer el archivo de control SPECIAL.KEY"
	#define STR0018 "¡Problemas en la configuracion de la clave SpecialKey, entre en contacto con el Administrador!"
	#define STR0019 "Acceso autorizado por clave de inicio."
	#define STR0020 "El acceso sera valido por mas "
	#define STR0021 " dia(s)."
	#define STR0022 "Contacte TOTVS para obter a chave definitiva."
#else
	#ifdef ENGLISH
		#define STR0001 "Company Not authorized for Template -> "
		#define STR0002 "Utilization granted by emergency password"
		#define STR0003 "Utilization through Microsiga Server, Senhap must be used"
		#define STR0004 'TOPConnect usage authorized by the emergency password'
		#define STR0005 "Current and version license  :  "
		#define STR0006 "Company without CNPJ for corporate release "
		#define STR0007 "CNPJ "
		#define STR0008 " not authorized for corporate release "
		#define STR0009 "Protheus is being used in corporate mode, "
		#define STR0010 "however, some company(ies)' CNPJ is(are) not authorized. "
		#define STR0011 "Contact the Password Release Department to regularize these companies' CNPJ. "
		#define STR0012 "CNPJ authorization will expire in"
		#define STR0013 " day(s)."
		#define STR0014 "Hardlock without CNPJ for corporate release"
		#define STR0015 "however Hardlock does not contain any CNPJ."
		#define STR0016 "Contact the Password Release Department to regularize the CNPJ's."
		#define STR0017 "Problems while reading the control file SPECIAL.KEY"
		#define STR0018 "Problems in configuring the key SpecialKey, contact the Administrator!"
		#define STR0019 "Access authorized through start password."
		#define STR0020 "Access is valid for more "
		#define STR0021 " day(s)."
		#define STR0022 "Contact TOTVS to get the definitive password."
	#else
		Static STR0001 := "Empresa Nao autorizada para o Template -> "
		Static STR0002 := "Uso autorizado pela senha de emergencia"
		Static STR0003 := "Uso pelo Servidor Microsiga, Senhap será utilizado"
		Static STR0004 := 'Uso do TOPConnect autorizado pela senha de emergencia'
		Static STR0005 := "A licenca atual e da versäo : "
		Static STR0006 := "Empresa sem CNPJ para liberacao corporativa"
		Static STR0007 := "CNPJ "
		Static STR0008 := " não autorizado para liberacao corporativa"
		Static STR0009 := "O Protheus esta sendo utilizado no modo Corporativo,"
		Static STR0010 := "porem o CNPJ de alguma(s) empresa(s) nao esta(ao) autorizado(s)."
		Static STR0011 := "Entre em contato com o Departamento de Liberacao de Senhas para regularizar o CNPJ dessas empresas."
		Static STR0012 := "A autorizacao do CNPJ ira vencer em "
		#define STR0013  " dia(s)."
		Static STR0014 := "Hardlock sem CNPJ para liberacao corporativa"
		Static STR0015 := "porem o Hardlock nao contem nenhum CNPJ."
		Static STR0016 := "Entre em contato com o Departamento de Liberacao de Senhas para regularizar os CNPJ's."
		Static STR0017 := "Problemas ao ler arquivo de controle SPECIAL.KEY"
		Static STR0018 := "Problemas na configuração da chave SpecialKey, entre em contato com o Administrador!"
		#define STR0019  "Acesso autorizado por chave de inicialização."
		#define STR0020  "O acesso será válido por mais "
		#define STR0021  " dia(s)."
		#define STR0022  "Contate a TOTVS para obter a chave definitiva."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Empresa não autorizada para o template -> "
			STR0002 := "Utilização autorizado pela palavra-passe de emergência"
			STR0003 := "Utilização pelo servidor Microsiga, Senhap será utilizado"
			STR0004 := 'Utilização do topconnect autorizado pela palavra-passe de emergência'
			STR0005 := "A licença actual é da versão : "
			STR0006 := "Empresa sem nr contribuinte para autorização corporativa"
			STR0007 := "Cnpj "
			STR0008 := " não autorizado para autorização corporativa"
			STR0009 := "O Protheus Está A Ser Utilizado No Modo Corporativo,"
			STR0010 := "Porém o nr contribuinte de alguma(s) empresa(s) não está(ão) autorizado(s)."
			STR0011 := "Entre em contacto com o departamento de autorização de pal.-passe para regularizar o nr contribuinte dessas empresas."
			STR0012 := "A autorização do nr contribuinte irá vencer em "
			STR0014 := "Hardlock sem nr. contribuinte para autorização corporativa"
			STR0015 := "Porém O Hardlock Não Contem Nenhum Nr. Contribuinte."
			STR0016 := "Entre em contacto com o departamento de autorização de palavras-passe para regularizar os nrs. contribuinte."
			STR0017 := "Problemas Ao Ler Ficheiro De Controlo Special.key"
			STR0018 := "Problemas na configuração da chave specialkey, entre em contacto com o administrador!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
