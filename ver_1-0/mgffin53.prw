#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              MGFFIN53
Autor....:              Leonardo Kume        
Data.....:              14/03/2017
Descricao / Objetivo:   Chamada da posição do cliente 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFI53A()

	aAdd(aRotina,{"Posição Cliente","u_MGFFIN53", 0 , 2 , 0 , NIL})

Return

User Function MGFFIN53()
	Local nRecSA1	:= 0
	DbSelectArea("SA1")
	If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		nRecSA1 := SA1->(Recno())
		
		Pergunte("FIC010",.T.)
		
		Fc010Con("SA1",nRecSA1,2)
	EndIf

Return