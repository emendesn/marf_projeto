#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA050TTS
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Transportadora
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de transportadora
=====================================================================================
@alterações 21/10/2019 - Henrique Vidal
	Chamada da função MGFCOM88
	RTASK0010137 - Apagar cadastro com pendência na Grade de aprovação.
*/

User Function MA050TTS(nOpc)
	If IsInCallStack('AXCADINC')  .OR. INCLUI
		IF findfunction("U_MGFINT39") 
			U_MGFINT39(2,'SA4','A4_MSBLQL')          
		ENDIF 
	EndIF         

	// valida campos para integracao do Taura
	If FindFunction("U_TAC02MA050TTS")
		U_TAC02MA050TTS()
	Endif		

	If FindFunction("U_MGFINT49")
		If ALTERA
			U_MGFINT49(4)
		Endif       
	Endif
	
	// gravacao de dados GFE
	If FindFunction("U_MGFGFE26")
		U_MGFGFE26(.T.)
	Endif		
	
	If FindFunction("U_MGFCOM88") 
		U_MGFCOM88('SA4')
	Endif	

Return .T.