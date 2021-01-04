#include 'protheus.ch'

#define CRLF chr(13) + chr(10)


/*/{Protheus.doc} MGFFAT25
	Tratamento do cadastro de clientes após a exclusão do cliente.

	@type  Function
	@author Gustavo Ananias Afonso
	@since 26/10/2016
	@version version
	@param  
	@return  
	@example
	@see  
	/*/

user function MGFFAT25(_cFunc)
	recLock("SA1", .F.)
	if SA1->A1_PESSOA == "J" .and. !empty( SA1->A1_CGC )
		SA1->A1_XINTSFO	:= "P" // STATUS PARA O CLIENTE SER ENVIADO AO SALESFORCE
		SA1->A1_XENVSFO	:= "S"
	endif
	SA1->A1_XINTECO	:= "0" // STATUS PARA O CLIENTE SER ENVIADO AO E-COMMERCE
	SA1->A1_XINTEGX	:= "P" // STATUS PARA O CLIENTE SER ENVIADO AO SFA
	SA1->A1_XINTEGR	:= "P" // STATUS PARA O CLIENTE SER ENVIADO AO TAURA
	SA1->A1_ZTAUVEZ := 0
	SA1->(msUnLock())

	If _cFunc == "E"
		delCliente()
	Endif	

return


/*/{Protheus.doc} delCliente
	função para deletar o registro na ZBJ quando o cliente é excluído
	@type  Static Function
	@author Cláudio Alves
	@since 10/03/2020
	@version 
	@param 
	@return
	@example
	@see (links_or_references)
/*/
static function delCliente()
	local updQry := ''
	updQry += "UPDATE " + CRLF
	updQry += "	" + retSQLName("ZBJ") + " " + CRLF
	updQry += "SET " + CRLF
	updQry += "	D_E_L_E_T_ = '*', " + CRLF
	updQry += "	R_E_C_D_E_L_ = R_E_C_N_O_  " + CRLF
	updQry += "WHERE " + CRLF
	updQry += "	ZBJ_CLIENT = '" + SA1->A1_COD + "' AND " + CRLF
	updQry += "	ZBJ_LOJA = '" + SA1->A1_LOJA + "' "
	tcSqlExec(updQry)
Return