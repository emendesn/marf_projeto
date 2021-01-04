#Include "Protheus.ch"

/*
================================================================================================
Programa............: A440STK
Autor...............: Marcos Andrade         
Data................: 14/10/2016 
Descricao / Objetivo: Ponto de entrada para trocar a chamada da tela de saldo
Doc. Origem.........: FAT08
Solicitante.........: Cliente
Uso.................: 
Obs.................:  
=================================================================================================
*/
                                                                       
User Function A440STK()

Local aArea	:= GetArea()
//Aplicar desconto progressivo

If Findfunction("u_MGFFAT13")
	u_MGFFAT13()
Endif
                        
RestArea(aArea)

Return()             
  