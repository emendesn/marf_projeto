#include 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MGFEEC43
//TODO Gravar numero do pedido ao gerar pedido de venda atraves da EXP
@author leonardo.kume
@since 26/01/2018
@version 6
@return boolean, se retornou o saldo

@type function
/*/
user function MGFEEC43()

	Local cAliasZB8 := GetNextAlias()

	BeginSql Alias cAliasZB8 
	SELECT R_E_C_N_O_ REC
	FROM %Table:ZB8% ZB8 
	WHERE 	ZB8.D_E_L_E_T_ = ' ' AND 
	ZB8.ZB8_FILIAL = %xFilial:ZB8% AND 
	ZB8.ZB8_PEDFAT = %Exp:SC5->C5_NUM% AND
	ZB8.ZB8_MOTEXP = '7'
	EndSql
	
	If !(cAliasZB8)->(Eof())
		DbSelectArea("ZB8")
		ZB8->(DbGoTo((cAliasZB8)->REC))
		DbSelectArea("ZB9")
		ZB9->(DbSetOrder(2))
		If ZB9->(DbSeek(ZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)))
			While !ZB9->(Eof())
				RecLock("ZB9",.F.)
				ZB9->ZB9_FATIT := ""
				ZB9->(DbSkip())
			EndDo
		EndIf
		RecLock("ZB8",.F.)
    		ZB8->ZB8_PEDFAT := ""
    		ZB8->ZB8_MOTEXP	:= "6"
		ZB8->(MsUnlock())
	EndIf
	
	
return .T.