#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN49
Autor....:              Atilio Amarilla
Data.....:              22/05/2017
Descricao / Objetivo:   Baixa CNAB - Busca de Chave ID CNAB
Doc. Origem:            Contrato - GAP CNAB Receber
Solicitante:            Cliente
Uso......:              
Obs......:              Titulos importados possuem chave com 24 posicoes (Logix)
=====================================================================================
*/

User Function MGFFIN49()
	
Local nTamIdCNAB	:= TamSX3("E1_IDCNAB")[1]
local aArea		:= getArea()
local aAreaSE1	:= SE1->( getArea() )
	
/*
CNAB - Verifica se possui E1_ZIDCNAB, 24 posicoes (titulo importado, chave/Id CNAB com origem no Logix)
*/
	

If !Empty( cNumTit ) .And. !Empty( Subs(cNumTit,nTamIdCNAB+1) )


	SE1->(DbOrderNickName("MGFXIDCNAB"))
	If SE1->( dbSeek( cNumTit ) )
		cFilAnt	:= SE1->E1_FILIAL
		
		If !Empty(SE1->E1_IDCNAB)
			//MsgStop("IDCNAB")
			cNumTit	:= SE1->E1_IDCNAB
		EndIf
	EndIf

EndIf
restArea(aAreaSE1)
restArea(aArea)
Return
