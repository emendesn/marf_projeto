#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFEST35
Autor...............: Mauricio Gresele
Data................: Set/2017
Descri��o / Objetivo: Rotina chamada pelo ponto de entrada MT100TOK e MT140TOK
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/     
User Function MGFEST35()

Local aArea := {ZD8->(GetArea()),GetArea()}
Local lRet := .T.
//Local cUsu := Alltrim(GetMv("MGF_USUCTE"))
Local cEsp := Alltrim(GetMv("MGF_ESPTRA"))

If Alltrim(cEspecie) $ cEsp .and. cModulo != "GFE"
	//If !__cUserId $ cUsu
	ZD8->(dbSetOrder(1))
	If ZD8->(!dbSeek(xFilial("ZD8")+__cUserId))
		lRet := .F.
		ApMsgStop("Usu�rio n�o habilitado para incluir Documentos de Transporte por este m�dulo."+CRLF+;
		"Fa�a o cadastro deste usu�rio na tabela de 'Usu�rios CTE m�dulos COM/EST' ( tabela ZD8 ), ou utilize o m�dulo 'GFE' para incluir este documento.")
	Endif
Endif		

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


User Function Est35Cad()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "AllwaysTrue()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZD8"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Usu�rios para inclus�o de CTE pelos m�dulos Compras/Estoque",cVldExc,cVldAlt)

Return()