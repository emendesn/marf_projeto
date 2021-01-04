#Include "totvs.ch"
#Include "Protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

/*/{Protheus.doc} MGFNfeTrans
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cPar1, characters, descricao
@type function
/*/
User Function MGFNfeTrans(cPar1)

	RPCSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif
	MV_PAR01 := cPar1
	autoNfeTrans()
	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return

User Function MGFAUTONFEMON(cPar1)

	RPCSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif
	MV_PAR01 := cPar1
	AUTONFEMON()
	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return

User Function MGFGFEA118SCH()
	aParam := {"01", "010001"}
	GFEA118SCH(aParam)

Return

User Function MGFGFEA115PRO()
	RPCSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif
	GFEA115PRO()
	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif
Return
