#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC11
Autor...............: Roberto Sidney
Data................: 03/11/2016
Descricao / Objetivo: Aprovadores de orcamentos
Doc. Origem.........: EEC05 - GAP EEC05
Solicitante.........: Cliente
Uso.................: 
Obs.................: P
=====================================================================================
*/
User Function MGFEEC11()
PRIVATE cCadastro := "Aprovadores de Orcamentos"
PRIVATE aRotina     := { }
//Private aCampos := DefCpos() // Define campos a serem exibidos

cString := "ZZF"

_cAreaZZF := ZZF->(GetArea())


//======================================================================
//MsFilter("Z9_ZCLIENT = cCodCli and Z9_ZLOJA = cLojaCli")
//======================================================================
//aAcho := aclone(aCampos)
//_cFilSZ9 := "Z9_ZCLIENT ='"+cCodCli+"' and Z9_ZLOJA ='"+cLojaCli+"'"

AADD(aRotina, { "Pesquisar" , "AxPesqui"  , 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual" , 0, 2 })
AADD(aRotina, { "Incluir"   , "AxInclui", 0, 3 })
AADD(aRotina, { "Alterar"   , "AxAltera", 0, 4 })
AADD(aRotina, { "Excluir"   , "AxDeleta" , 0, 5 })

dbSelectArea("ZZF")
dbSetOrder(1)

//mBrowse(6, 1, 22, 75, "ZZF",,,,,,,,,,,,,,_cFilSZ9,,,)
mBrowse(6, 1, 22, 75, "ZZF",,,,,,,,,,,,,,,,,)

RestArea(_cAreaZZF)

Return(.T.)