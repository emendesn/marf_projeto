#ifdef SPANISH
	#define STR0001 "e-NFC LjNfceGera: No localizo registro en la tabla SL1. L1_FILIAL:"
	#define STR0002 " - L1_NUM:"
	#define STR0003 "Atencion"
	#define STR0004 "e-FactC: No fue posible transmitir e-FactC (Conexion TSS)"
	#define STR0005 "¿Desea intentarlo nuevamente?"
	#define STR0006 "SI"
	#define STR0007 "NO"
	#define STR0008 "e-FactC: No fue posible transmitir e-FactC  (Rechazo TSS)"
	#define STR0009 "OK"
	#define STR0010 "ID"
	#define STR0011 "e-FactC: No fue posible transmitir e-FactC (Sin Objeto oWSNOTAS)"
	#define STR0012 "e-FactC: Aviso al Convertir XML"
	#define STR0013 "e-FactC: No conformidad al Convertir XML"
	#define STR0014 "e-FactC: Tipo de Impresion incompatible: "
	#define STR0015 "e-FactC: No fue posible transmitir e-FactC (Capturar Codigo Ente)"
	#define STR0016 "¿Desea intentarlo nuevamente?"
	#define STR0017 "SI"
	#define STR0018 "NO"
	#define STR0019 "e-FactC: No se puede anular"
	#define STR0020 "sobrepaso el plazo para anulacion"
	#define STR0021 "e-FactC: No fue posible transmitir anulacion de la e-FactC (Conexion TSS)"
	#define STR0022 "e-FactC: No fue posible recuperar XML(Conexion TSS)"
	#define STR0023 "TSS (TOTVS Service Sped) no retorno la propiedad LSUCESSO. Verifique si la version del TSS es 2.28 o superior."
	#define STR0024 "ID enviado e diferente do ID retornado: "
	#define STR0025 "ID nao retornado pelo TSS"
	#define STR0026 "Por favor, atualize o fonte: "
	#define STR0027 "Version '"
	#define STR0028 "' de eFactC fue descontinuada por la SEFAZ. Efectue la configuracion para version '"
	#define STR0029 "' o superior."
#else
	#ifdef ENGLISH
		#define STR0001 "NFC-e LjNfceGera: Did not find records in SL1 table. L1_FILIAL:"
		#define STR0002 " - L1_NUM:"
		#define STR0003 "Attention"
		#define STR0004 "NFC-e: Could not transmit NFC-e (TSS Connection)"
		#define STR0005 "Try again?"
		#define STR0006 "YES"
		#define STR0007 "NO"
		#define STR0008 "NFC-e: Could not transmit NFC-e (TSS Rejection)"
		#define STR0009 "OK"
		#define STR0010 "ID:"
		#define STR0011 "NFC-e: Could not transmit NFC-e (No Object oWSNOTAS)"
		#define STR0012 "NFC-e: Warning while Converting XML"
		#define STR0013 "NFC-e: Non-conformance while Converting XML"
		#define STR0014 "Nfc-e: Incompatible print type: "
		#define STR0015 "NFC-e: Could not transmit NFC-e (Capture Entity Code)"
		#define STR0016 "Try again?"
		#define STR0017 "YES"
		#define STR0018 "NO"
		#define STR0019 "NFC-e: Cannot be canceled"
		#define STR0020 "Exceeded the term for cancellation"
		#define STR0021 "NFC-e: Could not transmit NFC-e cancellation (TSS Connection)"
		#define STR0022 "NFC-e: Could not recover XML (TSS Connection)"
		#define STR0023 "TSS (TOTVS Service Sped) does not return LSUCESSO property. Verify if TSS version is 2.28 or more."
		#define STR0024 "ID send and different from returned ID: "
		#define STR0025 "ID not returned by TSS"
		#define STR0026 "Please, update source: "
		#define STR0027 "Version '"
		#define STR0028 "' of the e-Invoice was discontinued by SEFAZ. Configure for version '"
		#define STR0029 "' or greater."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "FC-e LjNfceGera: Não foi localizado registo na tabela SL1. L1_FILIAL:", "NFC-e LjNfceGera: Nao localizou registro na tabela SL1. L1_FILIAL:" )
		#define STR0002 " - L1_NUM:"
		#define STR0003 "Atenção"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível transmitir FC-e(Conexão TSS)", "NFC-e: Não foi possível transmitir NFC-e(Conexão TSS)" )
		#define STR0005 "Deseja tentar novamente?"
		#define STR0006 "SIM"
		#define STR0007 "NÃO"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível transmitir FC-e (Rejeição TSS)", "NFC-e: Não foi possível transmitir NFC-e (Rejeição TSS)" )
		#define STR0009 "OK"
		#define STR0010 "ID:"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível transmitir FC-e (Sem objeto oWSNOTAS)", "NFC-e: Não foi possível transmitir NFC-e (Sem Objeto oWSNOTAS)" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "FC-e: Aviso ao converter XML", "NFC-e: Aviso ao Converter XML" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "FC-e: Não conformidade ao converter XML", "NFC-e: Não conformidade ao Converter XML" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "FC-e: Tipo de impressão incompatível: ", "Nfc-e: Tipo de Impressão incompatível: " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível transmitir FC-e (Capturar Código entidade)", "NFC-e: Não foi possível transmitir NFC-e (Capturar Código Entidade)" )
		#define STR0016 "Deseja tentar novamente?"
		#define STR0017 "SIM"
		#define STR0018 "NÃO"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "FC-e: Não não pode ser cancelada", "NFC-e: Não não pode ser cancelada" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Prazo para cancelamento ultrapassado", "Ultrapassou o prazo para cancelamento" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível transmitir cancelamento da FC-e(Conexão TSS)", "NFC-e: Não foi possível transmitir cancelamento da NFC-e(Conexão TSS)" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "FC-e: Não foi possível recuperar XML(Conexão TSS)", "NFC-e: Não foi possível recuperar XML(Conexão TSS)" )
		#define STR0023 "TSS (TOTVS Service Sped) não retornou a propriedade LSUCESSO. Verifique se a versão do TSS é 2.28 ou superior."
		#define STR0024 "ID enviado e diferente do ID retornado: "
		#define STR0025 "ID nao retornado pelo TSS"
		#define STR0026 "Por favor, atualize o fonte: "
		#define STR0027 "Versão '"
		#define STR0028 "' da NFC-e foi descontinuada pela SEFAZ. Efetue a configuração para versão '"
		#define STR0029 "' ou superior."
	#endif
#endif
