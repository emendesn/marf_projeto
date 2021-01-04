#Include 'Protheus.ch'
#Include "FWMVCDEF.CH"


/*/{Protheus.doc} MGFFATB7 (nome da Fun��o)
	Breve descri��o... Cadastro de motivos de exclus�o de pedidos de vendas 

	@description
	Cadastro de motivos de exclus�o de pedidos de vendas 

	@author Fabio Costa
	@since 22/08/2019

	@version P12.1.017
	@country Brasil
	@language Portugu�s

	@menu
	Faturamento-Atualiza��es-Especificos-Mot Exc PV

	@history
	Referente ao problema PRB0040212 - Paulo Henrique - TOTVS - 11/09/2019.
/*/


User Function MGFFATB7()
	
Local _cTitulo := "Cadastro de Motivos de Exclus�o de Pedidos"

AxCadastro("ZEJ",_cTitulo)

Return

