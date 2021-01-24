#INCLUDE "rwMake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA103OK    ³ Grava Faturas a pagar      ³ Data ³ 26/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³	                                                                      ³±±
±±³	Descrição ³ : Ponto de Entrada MTA103OK na função A103LinOk() Rotina  ³±±
±±³		de validacao da LinhaOk. Esse ponto permite a alterar o resultado ³±±
±±³		da validação padrão para inclusão/alteração de registros de       ³±±
±±³		entrada, por customizações do cliente.                            ³±±
±±³		                                                                  ³±±
±±³	Programa Fonte                                                        ³±±
±±³	Mata103.PRW                                                           ³±±
±±³	Sintaxe                                                               ³±±
±±³	MTA103OK - Altera o resultado da validação padrão para                ³±±
±±³		inclusão/alteração de registros de entrada,                       ³±±
±±³		por customizações do cliente ( ) --> L                     		  ³±±
±±³	          ³ da fatura no SE2 e antes da contabilização.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA103OK()

	Local lRet	:= .T.

	//Natanael Filho - 26/Abril/2019
	//Rotina para validação dos campos D1_CLASFIS,D1_BASNDES,D1_ALQNDES e D1_ICMNDES 
	If lRet .AND. FindFunction("U_MGFFIS48")
		lRet := U_MGFFIS48()
	EndIf
	If lRet .AND. FindFunction("U_MGFFIS51") //Rafael 01/10/2019  - tratativa tes inteligente
		lRet := U_MGFFIS51()
	EndIf



Return lRet