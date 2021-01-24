#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MT20FOPOS
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Fornecedor
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Fornecedor
=====================================================================================
*/
User Function MT20FOPOS

Local nOpc := PARAMIXB[1] 

// envia fornecedor para Taura
If FindFunction("U_TAC01MT20FOPOS")
	U_TAC01MT20FOPOS(ParamIxb)
Endif

If     nOpc == 3 // Incluisão de registro. 3 = Incluir / 4 = Alterar / 5 = Excluir

	   // GAP387 - Criar inteligencia no campo Cnae do cliente x Grupo de Tributação - 25/OUT/2018 - Natanael Filho
	   // Essa função deve ser chamada antes das funções de grade de aprovação (U_MGFINT39). 
	
	   If findFunction("U_MGFFIS40") 
			U_MGFFIS40(1) //1: Fornecedor / 2:Cliente
	   EndIf		
 
	   IF findfunction("U_MGFINT39") 
		  U_MGFINT39(2,'SA2','A2_MSBLQL')           
	   EndIF

ElseIf nOpc == 4 // Alteração de registros (FORNECEDORES)
	   IF findfunction("U_MGFINT39") 
		  U_MGFINT39(3,'SA2','A2_MSBLQL')           
	   EndIF
EndIF         

// gravacao de dados GFE
If FindFunction("U_MGFGFE26")
	U_MGFGFE26(.T.)
Endif		

Return .T.