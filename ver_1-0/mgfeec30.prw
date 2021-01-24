#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} MGFEEC29
//TODO Ponto de entrada para alterar o Contas a Receber do Comex quando OffShore
@author leonardo.kume
@since 03/06/2017
@version 6

@type function
/*/
user function MGFEEC30()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If Alltrim(cParam) == "ANTES_TELA_MANUT_PARC"
		aAdd(aAltera, IncSpace("EEQ_ZREFBC"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZORDNT"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZDESP"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZBANCO"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZAGENC"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZCONTA"  , Len(SX3->X3_CAMPO), .F.))
		aAdd(aAltera, IncSpace("EEQ_ZOBS"  , Len(SX3->X3_CAMPO), .F.))
	EndIf
	
return .T.