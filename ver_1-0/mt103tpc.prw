#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MT103TPC
GAP126 - Exceções para Documento de Entrada sem Pedido de Compra
Precisa também do ponto de entrada MFGFIS30


@author Natanael Simões
@since 05/03/2018
@version P12.1.17
/*/
//-------------------------------------------------------------------


user function MT103TPC()

Local aArea := GetArea()
Local cTESPar := PARAMIXB[1]
Local cUser := __cuserid
Local cTipoDoc := ''
Local lPCNFe := SuperGetMV("MV_PCNFE",.T.,.F.) 							//Nota Fiscal tem que ser amarrada a um Pedido de Compra ?
Local nPTES := 0														//Posição da TES no aCols
Local nPOP 	:= 0 														//Posição da Operação no aCols
Local nPC 	:= 0														//Posição do Pedido de Compra na aCols
Local cTES 	:= ''                       								//TES
Local cOP 	:= ''														//Operação
Local cPC	:= ''														//Pedido de Compra
Local aExcRotina := Separa(SuperGetMV("MGF_FIS30R",.T.,''),',',.F.)		//Rotina que geram Documentos de entrada e não devem exigir pedido de Compra

nPTES 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_TES'})
nPOP 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_OPER'})
nPC		:= Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_PEDIDO'})

cTES	:= aCols[n][nPTES]
cOP		:= aCols[n][nPOP]
cPC		:= aCols[n][nPC]

//Verifica se o Documento de Entrada está sendo gerado por alguma rotina que não necessita de Pedido de Compra, como a rotinas de Abate
For nCount := 1 to len(aExcRotina)
	If IsInCallStack(aExcRotina[nCount])
		cTESPar := cTES
		Return cTESPar
	EndIf
Next


If	lPCNFe;										//Verifica se o parâmtro está Habilitado
	.AND. Vazio(cPC);  							//Campo de Pedido está vazio
	.AND.!(aCols[n,len(aHeader)+1]);  			//Se a linha não está deletada
	.AND.!(cTipo$'D/I')							//Tipo da Nota Fiscal não é devolução nem Complemento de ICMS.

	cTesPar := ""	//Deve ser desconsiderado as informações do parâmetro e utilizar apenas a tabela ZDO
	
	DBSelectArea("ZDO")
	
	// Procurando a partir do usuário
	DBSetOrder(2) //ZDO_FILIAL+ZDO_USER+ZDO_TIPOP+ZDO_TES
	If DBSEEK(xFilial("ZDO")+cUser)
		If ZDO_USER = cUser .AND. VAZIO(ZDO_TES) .AND. VAZIO(ZDO_TIPOP)
			cTESPar := cTES
			return cTESPar		
		EndIf
		While(ZDO_USER = cUser .AND. ZDO_TIPOP <= cOP .AND. ZDO_TES <= cTES)
			If (ZDO_TIPOP == cOP .OR. VAZIO(ZDO_TIPOP)) .AND. (ZDO_TES == cTES .OR. VAZIO(ZDO_TES))
				cTESPar := cTES
				return cTESPar
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	// Procurando a partir da OP
	DBGoTop()
	DBSetOrder(3)//ZDO_FILIAL+ZDO_TIPOP+ZDO_TES+ZDO_USER
	If !VAZIO(cOp) .AND. DBSeek(xFilial("ZDO")+cOP)
		If ZDO_TIPOP = cOP .AND. VAZIO(ZDO_USER) .AND. VAZIO(ZDO_TES) 
			cTESPar := cTES
			return cTESPar		
		EndIf	
		While(ZDO_TIPOP = cOP .AND. ZDO_TES <= cTES .AND. ZDO_USER <= cUSER)
			If (ZDO_USER == cUSER .OR. VAZIO(ZDO_USER)) .AND. (ZDO_TES == cTES .OR. VAZIO(ZDO_TES))
				cTESPar := cTES
				return cTESPar
			EndIf
			dbSkip()
		EndDo	
	EndIf
	
	// Procurando a partir do TE (Tipo de Entrada)
	DBGoTop()
	DBSetOrder(4) //ZDO_FILIAL+ZDO_TES+ZDO_USER+ZDO_TIPOP
	If !VAZIO(cTES) .AND. DBSeek(xFilial("ZDO")+cTES)
		If ZDO_TES = cTES .AND. VAZIO(ZDO_USER) .AND. VAZIO(ZDO_TIPOP) 
			cTESPar := cTES
			return cTESPar		
		EndIf
		While(ZDO_TES = cTES .AND. ZDO_TIPOP <= cOP .AND. ZDO_USER <= cUSER)
			If (ZDO_TIPOP == cOP .OR. VAZIO(ZDO_TIPOP)) .AND. (ZDO_USER == cUser .OR. VAZIO(ZDO_USER))
				cTESPar := cTES
				return cTESPar
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	DBCloseArea("ZDO")
	restArea(aArea)
	
	If Vazio(cTESPar)
		Help( ,, 'MT103TPC',, 'Informe o pedido de compra ou atualize as exceções (MFGFIS30)', 1, 0)
	EndIf

EndIf

return cTESPar