#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT24
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
user function MGFINT31(cAlias)
	Default cAlias := "DA0"
	if &(cAlias+"->"+iif(Substr(cAlias,1,1)=="S",Substr(cAlias,2,2),cAlias)+"_XSFA") == "S"
		recLock(cAlias, .F.)
			&(cAlias+"->"+iif(Substr(cAlias,1,1)=="S",Substr(cAlias,2,2)+"_XINTEGR",cAlias+"_XINTEG")) := "P"
		(cAlias)->(msUnLock())
	endif

	if cAlias == "DA0"
		recLock( cAlias , .F. )
			DA0->DA0_XINTSF := "P"
		( cAlias )->( msUnLock() )
	endif
return