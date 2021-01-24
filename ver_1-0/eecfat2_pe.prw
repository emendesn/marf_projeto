#Include "Protheus.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH" 
#INCLUDE "RWMAKE.CH" 
#include "tbiconn.ch"
#include "topconn.ch"                                                 
#INCLUDE "ap5Mail.ch"
#INCLUDE "FILEIO.CH" 

/*
==========================================================================================
Programa.:              EECFAT2
Autor....:              Leonardo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada geral para Pedido de Exportação 
Pedido Exportacao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================
*/


User Function EECFAT2()

Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
Local nPos := 0

	If cParam == "PE_GRVCAPA"
		If (nPos:=aScan(aCab,{|x| Alltrim(x[1]) == "C5_PESOL"})) > 0
			If aCab[nPos][2] < 0
				aCab[nPos][2] := 0
				M->EE7_PESLIQ := 0
			Endif	
		Endif	

		If (nPos:=aScan(aCab,{|x| Alltrim(x[1]) == "C5_PBRUTO"})) > 0
			If aCab[nPos][2] < 0
				aCab[nPos][2] := 0
				M->EE7_PESBRU := 0
			Endif	
		Endif	

		// chamado RITM0014775 - incluir no Vendedor do Pedido de Venda o codigo do Trade da Exportação
		aAdd(aCab,{"C5_VEND1",M->EE7_ZTRADE,nil})

	Endif	

Return 