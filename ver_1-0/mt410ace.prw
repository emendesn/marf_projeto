#Include "Protheus.ch"

/*
================================================================================================
Programa............: MT410ACE
Autor...............: Marcos Andrade         
Data................: 06/10/2016 
Descricao / Objetivo: Ponto de entrada antes de chamar a tela do pedido
Doc. Origem.........: FAT01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=================================================================================================
*/  
User Function MT410ACE()
	Local lRet := .T.
	Local aArea	:= GetArea()
	Local _nOpc	:= PARAMIXB[1]
	
	If lRet .AND. findfunction("u_MGFFAT89");
		 .AND. _nOpc = 3 //Copia 
		lRet := u_MGFFAT89()
	Endif

	If lRet .AND. findfunction("u_T06UPDC6")
		u_T06UPDC6(_nOpc)
	Endif
	


	RestArea(aArea)

Return lRet