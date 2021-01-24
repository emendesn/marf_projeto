// ------------------------------------------------------------
/*{Protheus.doc} START()
Funcao executada quando a thread Ã© iniciada, deve ser utilizada
para abertura de ambiente.

@author TOTVS
@since 24/03/2020
*/
// ------------------------------------------------------------
User Function START(cSessionKey)
    
    Conout(i18n("Inicio da thread #1", {ThreadID()}))
    VarInfo("cSessionKey", cSessionKey)

	RpcSetType(3)
	
	If len (&cSessionKey) == 3

		RpcSetEnv(&cSessionKey[1],&cSessionKey[2],,,&cSessionKey[3])

	else
		
		RpcSetEnv(&cSessionKey[1],&cSessionKey[2])

	endif


    Conout(i18n("Aberto a thread #1", {ThreadID()}))

Return .T.

// ------------------------------------------------------------
/*{Protheus.doc} FINISH()
Funcao executada quando a thread Ã© finalizada, nao Ã© obrigatorio 
o uso. Pode ser usada pra limpar o ambiente, por exemplo.

A thread Ã© finalizada quando o timeout Ã© atingido.

@author TOTVS
@since 24/03/2020
*/
// ------------------------------------------------------------
User Function FINISH()
    Conout(i18n("Fim da thread #1", {ThreadID()}))
Return .T.
