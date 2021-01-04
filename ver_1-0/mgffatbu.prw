#Include 'PROTHEUS.CH'
#Include "TOTVS.CH"

/*/{Protheus.doc} MGFFATBU
Função para cadastro de Espécie de Pedidos (ZG1)
@author Paulo Henrique Rodrigues da Mata
@since 23/03/2020
@version 1.0
@return Nil
/*/
User Function MGFFATBU()

Private cString := "ZG1"

dbSelectArea("ZG1")

AxCadastro(cString,"Manutencao Espécie de Pedidos")

Return