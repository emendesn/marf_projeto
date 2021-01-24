#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              OS010END
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6091350
=====================================================================================
*/
user function OS010GRV()

	If FindFunction("U_MGFINT31")
		U_MGFINT31()
	Endif

	If FindFunction("U_MGFFAT19")
		U_MGFFAT19()
	Endif
	/*If FindFunction("u_T03GrvAux") // FAT05
		u_T03GrvAux()
	Endif*/
	//-----------------------------------------------------
	//Na copia da tabela deve gravar as tabelas auxiliares
	//-----------------------------------------------------
	//u_T03GrvAux()
return
