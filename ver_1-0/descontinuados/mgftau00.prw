#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAU00
Autor....:              Marcelo Carneiro         
Data.....:              09/03/2016 
Descricao / Objetivo:   TAURA - Definição de Parametros
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              Atualiza todos os Parametros do Taura.
==========================================================================================================
*/

User Function MGFTAU00            
Local aParametros := {}                

Local cURL        := 'http://spdwvapl203:8081/'                                         
Local cURL2       := 'http://spdwvapl203:8090'
Local bBarramento := .T.
//Local cURL        := 'http://SPDWVAPL200:8081/' 
//Local cURL2       := 'http://SPDWVAPL200:8090'
RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )


//ConOut("## PROCESSANDO RPO 22222222#")

//cQuery := " Update "+RetSqlName('SX1')+" Set X1_VALID='U_xMGFTAS05()' Where X1_GRUPO='MTA410' and X1_ORDEM='01' "
//IF (TcSQLExec(cQuery) < 0)
//    MemoWrite("c:\temp\Erro"+StrTran(Time(),":","")+".txt",TcSQLError())
//EndIF                         
///X31UPDTABLE('ZZI') 	


//Parametros de Integracao
/*
aAdd(aParametros, {"MGF_MONI01", "","C", "Monitor Integração Tipo Taura"      ,"001"} )
aAdd(aParametros, {"MGF_MONT01", "","C", "Monitor Integracao Fornecedor"      ,"001"} )
aAdd(aParametros, {"MGF_MONT02", "","C", "Monitor Integracao Transportadora"  ,"002"} )
aAdd(aParametros, {"MGF_MONT03", "","C", "Monitor Integracao Produto"         ,"003"} )
aAdd(aParametros, {"MGF_MONT04", "","C", "Monitor Integracao Motorista"       ,"004"} )
aAdd(aParametros, {"MGF_MONT05", "","C", "Monitor Integracao Veiculo"         ,"005"} )
aAdd(aParametros, {"MGF_MONT06", "","C", "Monitor Integracao Cliente"         ,"006"} )
aAdd(aParametros, {"MGF_MONT07", "","C", "Monitor Integracao Aviso Chegada"   ,"007"} )
aAdd(aParametros, {"MGF_MONT08", "","C", "Monitor Integracao Pedido de Venda" ,"008"} )
aAdd(aParametros, {"MGF_MONT09", "","C", "Monitor Integracao Nota Saida"      ,"009"} )
aAdd(aParametros, {"MGF_MONT10", "","C", "Retorno da Integração Produção"     ,"010"} )
aAdd(aParametros, {"MGF_MONT11", "","C", "Monitor Integracao Endereco Entrega","011"} )
aAdd(aParametros, {"MGF_MONT12", "","C", "Monitor Integracao Retorno Mov AR"  ,"012"} )
 */

//Parametros de Entrada                         
aAdd(aParametros, {"MGF_TPTAU", "","C", "Tipos de Produto que exporta Taura" ,"'ME','MP','EM','PP','PA','SP','PI','OI'"} )
aAdd(aParametros, {"MGF_TAE01", "","C", "TM para Ajuste Positivo do AR" ,"100"} )
aAdd(aParametros, {"MGF_TAE02", "","C", "TM para Ajuste Negativo do AR" ,"501"} )
aAdd(aParametros, {"MGF_TAE03", "","C", "TM para devolucao do  AR"      ,"100"} )
aAdd(aParametros, {"MGF_TAE04", "","C", "TM para Requisicao do AR"      ,"501"} )
aAdd(aParametros, {"MGF_TAE05", "","C", "Codigo de Produto Carcaca"     ,"000004"} )
aAdd(aParametros, {"MGF_TAE06", "","C", "TM para Requisicao Boi Taura"  ,"501"} )
aAdd(aParametros, {"MGF_TAE07", "","C", "TM para producao Boi Carcaca"  ,"110"} )
aAdd(aParametros, {"MGF_TAE08", "","C", 'OPERACAO do doc Entrada Compra Boi' ,"03"} )
aAdd(aParametros, {"MGF_TAE12", "","C", "Grupo de Estoque de Gado"      ,"001"} )
aAdd(aParametros, {"MGF_AE6LOC","","C", "Almox indisponivel do AR"      ,"02"} ) 
aAdd(aParametros, {"MGF_TAE16", "","C", "Natureza Financeira para Adiantamento Ped Compra Gado"      ,"30110"} )        
                                                                                        
// Saidas
aAdd(aParametros, {"MGF_ROTA"  , "","C", "Rota para integração Taura - Ordem de Embarque"            , "999999"} )
aAdd(aParametros, {"MGF_ZONA"  , "","C", "Zona para integração Taura - Ordem de Embarque"            , "999999"} )
aAdd(aParametros, {"MGF_SETOR" , "","C", "Setor para integração Taura - Ordem de Embarque"           , "999999"} )
aAdd(aParametros, {"MGF_ESPSC5", "","C", "Especie Cadastrada na SC5"            , "CAIXAS"} )


//Produção          
aAdd(aParametros, {"MGF_TAP02T","","C", "Int. Taura Prod - Endereço Padrão "                         ,"01"} )
aAdd(aParametros, {"MGF_TAP02A","","N", "Int. Taura Prod - Numero Maximo de Threads"                 ,"40"} )
aAdd(aParametros, {"MGF_TAP02B","","C", "Int. Taura Prod - TM de Produçao"                           ,"110"} ) // Deve existir cadastro na tabela SF5
aAdd(aParametros, {"MGF_TAP02C","","C", "Int. Taura Prod - TM de Devolucao - Integração TAURA"       ,"001"} ) // Deve existir cadastro na tabela SF5
aAdd(aParametros, {"MGF_TAP02D","","C", "Int. Taura Prod - TM de Requisiçao - Integração TAURA"      ,"510"} ) // Deve existir cadastro na tabela SF5
aAdd(aParametros, {"MGF_TAP02E","","C", "Int. Taura Prod - Tp Mov Apontamento Prod"                  ,"01/"} )
aAdd(aParametros, {"MGF_TAP02F","","C", "Int. Taura Prod - Tp Mov Requisicao Prod"                   ,"02/"} )
aAdd(aParametros, {"MGF_TAP02G","","L", "Int. Taura Prod - Aglutina movimentações .T./.F."           ,".T."} ) // Desativado 
aAdd(aParametros, {"MGF_TAP02H","","C", "Int. Taura Prod - Path de gravação de logs"                 ,"\TAURA\PRD\LOG\"} )
aAdd(aParametros, {"MGF_TAP02I","","N", "Int. Taura Prod - Num de Operacoes x Thread"                ,"40"} )
aAdd(aParametros, {"MGF_TAP02K","","C", "Int. Taura Prod - Tp Mov Encerramento Prod"                 ,"04/"} )
aAdd(aParametros, {"MGF_TAP02L","","C", "Int. Taura Prod - Tp Mov Devolução-Apont Subprod"           ,"03/"} )
aAdd(aParametros, {"MGF_TAP02M","","C", "Int. Taura Prod - Tipo OP Subproduto (Miudos)"              ,"02/"} )
aAdd(aParametros, {"MGF_TAP02N","","C", "Int. Taura Prod - Tipo OP Transf Cabeca em Kg"              ,"04"} )
aAdd(aParametros, {"MGF_TAP02O","","L", "Int. Taura Prod - Habilita .T. process como job"            ,".T."} )
aAdd(aParametros, {"MGF_TAP02P","","C", "Int. Taura Prod - Tipo OP Industrializados"                 ,"11/12/"} )
aAdd(aParametros, {"MGF_TAP02Q","","C", "Int. Taura Prod - Tipo OP Abate"                            ,"01/"} )
aAdd(aParametros, {"MGF_TAP11A","","C", "Int. Taura Prod - Relacao de Armazens Produtivos"           ,"21/22/23/24/25/26/27/28/29"} ) // Necessário definir. Valores usados em teste.
aAdd(aParametros, {"MGF_TAP11C","","C", "Int. Taura Prod - Codigo Integracao (Monitor)"              ,"001"} ) // Cadastro SZ2
aAdd(aParametros, {"MGF_TAP11D","","C", "Int. Taura Prod - Tipo Integracao (Monitor) "               ,"001"} ) // Cadastro SZ3
aAdd(aParametros, {"MGF_TAPBLQ","","C", "Armazem Bloqueio Taura"                                     ,"90"} ) // Cadastro SZ3
aAdd(aParametros, {"MGF_TAP13D","","C", "Retorno de Producao Status"                                 ,"'1','2','4','5'"} ) // Cadastro SZ3
aAdd(aParametros, {"MGF_TAP12C","","C", "Int. Taura Prod - TM Dev - Metodo Geracao estoque"              ,"001"} ) // Cadastro SZ2
aAdd(aParametros, {"MGF_TAP12D","","C", "Int. Taura Prod - TM REQ - Metodo Baixa Estoque"                ,"510"} ) // Cadastro SZ3
aAdd(aParametros, {"MGF_TAP13B","","C", "Int. Taura Prod - Codigo Integracao (Monitor)"              ,"001"} ) // Cadastro SZ2
aAdd(aParametros, {"MGF_TAP13C","","C", "Int. Taura Prod - Tipo Integracao (Monitor) "               ,"002"} ) // Cadastro SZ3
//Clientes
aAdd(aParametros, {"MGF_SFA02T","","C","Tipo de Integracao SFA - Clientes Gerais          ","001"})

IF !bBarramento
	//URLS
	//Entrada
	aAdd(aParametros, {"MGF_TAE09", "","C", "URL Metodo AvisodeChegada"     ,cURL+"AvisoChegada/AvisoChegada"} )
	aAdd(aParametros, {"MGF_TAE10", "","C", "URL Metodo StatusPedidoAbate"  ,cURL+"Faturamento/StatusPedidoAbate"} )
	aAdd(aParametros, {"MGF_TAE11", "","C", "URL Metodo StatusAR"           ,cURL+"pedido/StatusAR"} )
	aAdd(aParametros, {"MGF_TAE13", "","C", "URL Metodo EstoqueValidade"    ,cURL+"situacaoestoque/consultaestoqueValidade"} )
	aAdd(aParametros, {"MGF_TAE14", "","C", "URL Metodo SituaçãoEstoque"    ,cURL+"situacaoestoque/consultaestoqueFEFO"} )
	aAdd(aParametros, {"MGF_TAE15", "","C", "URL Metodo SituaçãoEstoque"    ,cURL+"situacaoestoque/consultaestoque"} )

	//Saidas
	aAdd(aParametros, {"MGF_URLCAN", "","C", "URL para processo Taura envio Nota de Saida - Cancelamento", cURL+"Faturamento/CancelarNotaSaida"} )
	aAdd(aParametros, {"MGF_URLTFO", "","C", "URL para processo Taura envio cadastro Fornecedor"         , cURL+"Fornecedor"} )
	aAdd(aParametros, {"MGF_URLTMO", "","C", "URL para processo Taura envio cadastro Motorista"          , cURL+"Motorista"} )
	aAdd(aParametros, {"MGF_URLTNF", "","C", "URL para processo Taura envio Nota de Saida"               , cURL+"faturamento/GravarNotaSaida"} )
	aAdd(aParametros, {"MGF_URLTPR", "","C", "URL para processo Taura envio cadastro Produto"            , cURL+"Produto"} )
	aAdd(aParametros, {"MGF_URLTPV", "","C", "URL para processo Taura envio Pedido de Venda"             , cURL+"pedido/PedidoVenda"} )
	aAdd(aParametros, {"MGF_URLTSP", "","C", "URL para processo Taura envio Status de Pedido de Venda"   , cURL+"Pedido/VerificarPodeAlterarExcluirPedidoVenda"} )
	aAdd(aParametros, {"MGF_URLTTR", "","C", "URL para processo Taura envio cadastro Transportadora"     , cURL+"Transportadora"} )
	aAdd(aParametros, {"MGF_URLTVE", "","C", "URL para processo Taura envio cadastro Veiculo"            , cURL+"Veiculo"} )
	//Produção 
	aAdd(aParametros, {"MGF_TAP11B","","C", "Int. Taura Prod - URL Metodo RequisicaoEstoque"             ,cURL+"RequisicaoEstoque"} )
	aAdd(aParametros, {"MGF_TAP13A","","C", "Int. Taura Prod - URL Metodo Integracao"                    ,cURL+"Integracao"} )
	//Clientes
	aAdd(aParametros, {"MGF_SFA02","","C","Client - URL Integracao SFA metodo Clientes Gerais",cURL2+"ClientesGerais     "})
	aAdd(aParametros, {"MGF_SFA02T","","C","Tipo de Integracao SFA - Clientes Gerais          ","001                                            "})
Else
	//Com Barramento
	//entrada
	aAdd(aParametros, {"MGF_TAE09", "","C", "URL Metodo AvisodeChegada"     ,cURL+"taura-aviso-chegada"} )
	aAdd(aParametros, {"MGF_TAE10", "","C", "URL Metodo StatusPedidoAbate"  ,cURL+"taura-status-abate"} )
	aAdd(aParametros, {"MGF_TAE11", "","C", "URL Metodo StatusAR"           ,cURL+"taura-status-recebimento"} )
	aAdd(aParametros, {"MGF_TAE13", "","C", "URL Metodo EstoqueValidade"    ,cURL+"taura-consulta-estoque-validade"} )
	aAdd(aParametros, {"MGF_TAE14", "","C", "URL Metodo SituaçãoEstoque FEFO",cURL+"taura-consulta-estoque-fefo"} )
	aAdd(aParametros, {"MGF_TAE15", "","C", "URL Metodo SituaçãoEstoque"    ,cURL+"taura-consulta-estoque"} )

	//Saidas
	aAdd(aParametros, {"MGF_URLCAN", "","C", "URL para processo Taura envio Nota de Saida - Cancelamento", cURL+"taura-cancela-nota-saida"} )
	aAdd(aParametros, {"MGF_URLTFO", "","C", "URL para processo Taura envio cadastro Fornecedor"         , cURL+"taura-grava-fornecedor"} )
	aAdd(aParametros, {"MGF_URLTMO", "","C", "URL para processo Taura envio cadastro Motorista"          , cURL+"taura-grava-motorista"} )
	aAdd(aParametros, {"MGF_URLTNF", "","C", "URL para processo Taura envio Nota de Saida"               , cURL+"taura-nota-saida"} )
	aAdd(aParametros, {"MGF_URLTPR", "","C", "URL para processo Taura envio cadastro Produto"            , cURL2+"/protheus/produtos"} )
	aAdd(aParametros, {"MGF_URLTPV", "","C", "URL para processo Taura envio Pedido de Venda"             , cURL+"taura-pedido-venda"} )
	aAdd(aParametros, {"MGF_URLTSP", "","C", "URL para processo Taura envio Status de Pedido de Venda"   , cURL+"taura-verifica-alterar-pedido-venda"} )
	aAdd(aParametros, {"MGF_URLTTR", "","C", "URL para processo Taura envio cadastro Transportadora"     , cURL+"taura-grava-transportadora"} )
	aAdd(aParametros, {"MGF_URLTVE", "","C", "URL para processo Taura envio cadastro Veiculo"            , cURL+"taura-grava-veiculo"} )
	//Produção
	aAdd(aParametros, {"MGF_TAP11B","","C", "Int. Taura Prod - URL Metodo RequisicaoEstoque"             ,cURL+"taura-requisicao-estoque"} )
	aAdd(aParametros, {"MGF_TAP13A","","C", "Int. Taura Prod - URL Metodo Integracao"                    ,cURL+"taura-retorno-integracao"} )
	//Clientes
	aAdd(aParametros, {"MGF_SFA02 ","","C","Client - URL Integracao SFA metodo Clientes Gerais"          ,cURL2+"/protheus/clientesGerais"})
EndIF                              

SetParTaura(aParametros)

Return     
****************************************************************************************************************************    
Static Function SetParTaura(aPars)
Local nI        := 0
Local aArea     := GetArea()
Local aAreaX6   := SX6->(GetArea())

DbSelectArea("SX6")
SX6->(dbSetOrder(1))
SX6->(DbGoTop())
For nI := 1 To Len(aPars)
	If !(SX6->(DbSeek(xFilial("SX6")+aPars[nI][1])))
		RecLock("SX6",.T.)
		SX6->X6_FIL      := aPars[nI][2]
		SX6->X6_VAR      := aPars[nI][1]
		SX6->X6_TIPO     := aPars[nI][3]
		SX6->X6_PROPRI   := "U"
		SX6->X6_DESCRIC  := aPars[nI][4]
		SX6->X6_DSCSPA   := aPars[nI][4]
		SX6->X6_DSCENG   := aPars[nI][4]
		SX6->X6_CONTEUD  := aPars[nI][5]
		SX6->X6_CONTSPA  := aPars[nI][5]
		SX6->X6_CONTENG  := aPars[nI][5]
		SX6->(MsUnlock())
	Else
	    cFilAnt := aPars[nI][2]
	    PutMv(aPars[nI][1],aPars[nI][5])
	EndIf
Next

RestArea(aAreaX6)
RestArea(aArea)

Return
