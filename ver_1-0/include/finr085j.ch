#ifdef SPANISH
	#define STR0001 " Certif. de Retenc. del IVA en la Fuente - Ecuador"
	#define STR0002 "RUC:  "
	#define STR0003 "  COMPROBANTE DE RETENCION "
	#define STR0004 " N�   "
	#define STR0005 " MATRIZ: "
	#define STR0006 "  N�  de Autorizacion  "
	#define STR0007 " Sr.(es): "
	#define STR0008 " Fch. de Emis.  : "
	#define STR0009 " RUC: "
	#define STR0010 " Tipo de Comprobante: "
	#define STR0011 " Direcc. : "
	#define STR0012 " N�  de Comprobante: "
	#define STR0013 " Ejercicio Fiscal    Base imponible                       Codigo del  "
	#define STR0014 " para la retenc.      Impuesto         impuesto         % Retencion       Valor Retenido"
	#define STR0015 "Firma del agente de retencion   "
	#define STR0016 "Val. para emision hasta "
	#define STR0017 "Original: Asunto pasivo de retencion  "
	#define STR0018 "Copia: Agente de retencion "
#else
	#ifdef ENGLISH
		#define STR0001 " Certificate of Withholding IVA - Ecuador"
		#define STR0002 "RUC:  "
		#define STR0003 "  WITHHOLDING RECEIPT  "
		#define STR0004 " Nr.  "
		#define STR0005 " HEAD OFFICE: "
		#define STR0006 "  Authorization Nr.   "
		#define STR0007 " Mr.(s): "
		#define STR0008 " Issue Date: "
		#define STR0009 " RUC: "
		#define STR0010 " Receipt Type: "
		#define STR0011 " Address: "
		#define STR0012 " Receipt Nr.: "
		#define STR0013 " Fiscal Year         Tax Base                             Code of     "
		#define STR0014 " for withholding        Tax               tax               % Withholding      Withheld Value  "
		#define STR0015 "Withholding agent signature"
		#define STR0016 "Valid to issue until "
		#define STR0017 "Original: Matter subject to withholding "
		#define STR0018 "Copy: Withholding agent  "
	#else
		#define STR0001 " Certificado de Reten��o do IVA na Fonte - Equador"
		#define STR0002 "RUC:  "
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "  COMPROVANTE DE RETEN��O  ", "  COMPROVANTE DE RETENC�O  " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", " Nr.  ", " No.  " )
		#define STR0005 " MATRIZ: "
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "  Nr. de Autoriza��o   ", "  No. de Autoriza��o   " )
		#define STR0007 " Sr.(es): "
		#define STR0008 " Data de Emiss�o: "
		#define STR0009 " RUC: "
		#define STR0010 " Tipo de Comprovante: "
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " Morada: ", " Endereco: " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", " Nr. de Comprovante: ", " No. de Comprovante: " )
		#define STR0013 " Exerc�cio Fiscal    Base c�lculo                         C�digo do   "
		#define STR0014 " para a reten��o      Imposto          imposto          % Reten��o        Valor Retido  "
		#define STR0015 "Assinatura do agente de reten��o"
		#define STR0016 "V�lido para emiss�o at� "
		#define STR0017 "Original: Assunto passivo de reten��o "
		#define STR0018 "C�pia: Agente de reten��o  "
	#endif
#endif
