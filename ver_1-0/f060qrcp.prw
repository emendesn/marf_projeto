#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              F060QRCP 
Autor....:              Paulo Fernandes
Data.....:              04/2018                                                                                                            
Descricao / Objetivo:   Altera a query de selecao de titulos para o bordero, tratando o campo de outra tabela(SF2).
                        Se o campo F2_CHVNFE nao preenchido o titulo nao pode ser selecionado
Doc. Origem:            Financeiro 
Solicitante:            Cliente
Uso......:              
Obs......:              PE FINA061
============================================================================================================================
*/ 
User Function F060QRCP()           
Local cSQL		:= PARAMIXB[1]
Local cSql_1:=cSql_2:=cSql_3:=cSql_Inner:=""
Local cSqlRet	:= ""

/* Nova Expressao SQL de filtro para a rotina FINA061.
============================================================================================================================
Motivo: Acrescentar uma condicao na clausula WHERE para nao selecionar titulos gerados por NF_e que ainda nao foi autorizada
Descritivo : Neste P.E recebe a query completa da rotina FINA061. Necessario incluir um JOIN com a tabela SF2, para isso �
necessario alterar as colunas R_E_C_N_O_ e D_E_L_E_T_ para incluir o prefixo SE1, assim nao ocorre ambiguidade de colunas com
a tabela SF2. Em seguida particiona a query em duas. A primeira parte � o conteudo ate a clausula WHERE e a segunda a partir
da clausula WHERE. A variavel "cSql_Inner" contem o INNER JOIN. O resultado � a concatenacao da primeira parte com o INNER e 
a segunda parte. A condicao F2_CHVNFE <> '' foi incluida no P.E FA060QRY.
============================================================================================================================
*/
cSql_1:=StrTran(cSql,"R_E_C_N_O_","SE1.R_E_C_N_O_")
cSql_1:=StrTran(cSql_1,"D_E_L_E_T_","SE1.D_E_L_E_T_")
nAtWhere:=AT("WHERE",cSql_1)
cSql_2:=SubStr(cSql_1,1,nAtWhere - 1)
cSql_3:=SubStr(cSql_1,nAtWhere)
cSql_Inner:="LEFT JOIN " + RetSqlName('SF2') + " SF2 ON (SF2.F2_FILIAL = SE1.E1_FILIAL AND SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA AND SF2.D_E_L_E_T_ = '') "
cSqlRet:=cSql_2 + cSql_Inner + cSql_3

Return(cSqlRet)


