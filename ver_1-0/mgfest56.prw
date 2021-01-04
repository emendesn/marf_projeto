#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFEST56
Autor...............: Tarcisio Galeano
Data................: 12/2018
Descricao / Objetivo: Bloqueio solicitante gravado x solicitante atual
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
user function MGFEST56()

	local cSolicit  	:= RETCODUSR()
	local cSolicitg 	:= SC1->C1_SOLICIT
	local cCodusr 		:=  ""  
	local lRet	 		:= .T.



        //acha o codigo do usuario
	    cNextAlias := GetNextAlias()

		BeginSql Alias cNextAlias

			SELECT
				USR_CODIGO
			FROM
				SYS_USR USR
			WHERE
				USR.D_E_L_E_T_ =' ' and
				USR.USR_ID = %exp:cSolicit%
		EndSql

		(cNextAlias)->(dbGoTop())

		While (cNextAlias)->(!EOF())
			cCodusr := (cNextAlias)->USR_CODIGO
			Exit
			(cNextAlias)->(dbSkip())
		EndDo
	
	IF cCodusr <> cSolicitG
		msgalert("Nao � permitido alteracao/exclusao de S.C. de outros solicitantes. ")
    	lRet := .F.
	endif
    

return lRet
                                                                                     

