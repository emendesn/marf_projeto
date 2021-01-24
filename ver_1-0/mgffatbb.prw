#include "totvs.ch"
#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFATBB
Autor...............: Claudio Alves
Data................: 26/09/2019
Descricao / Objetivo: 
    Identificação Protheus - Dev – Fiscal – RITM0021453 – Bloqueio de pedido de venda transferência
    • Analista Responsável TI: Carlos Eduardo Amorim
    • Nome da funcionalidade: Pedido de Venda
    • Programas/Tela/Funções: Pedido de Venda
Doc. Origem.........: RITM0021453
Solicitante.........: Pedro Ribeiro
Uso.................: Marfrig
Obs.................: Foi criado o campo ZBU_CNPJVT 
=====================================================================================
*/


user function MGFFATBB(xlEntra)
    local cnpjOrigem    :=  left(SM0->M0_CGC,8)
    local cnpjDestino   :=  ''
    local xlRet         :=  .T.
    local xcValRaiz     :=  ''
    local varLocal      :=  ''
    local msgIgual      :=  ''
    local msgdif        :=  ''

    //eliminar warning de variavel não declarada
    varLocal    :=  M->C5_TIPO
    varLocal    :=  M->C5_ZTIPPED
    varLocal    :=  M->C5_ZTPOPER

    //Pega a validação do cadastro de TP Operação X Especie PV
    DbSelectArea('ZBU')
    ZBU->(dbSetOrder(1)) //FILIAL COD LOJA
    if ZBU->(dbSeek(xFilial('ZBU') + M->C5_ZTPOPER + M->C5_ZTIPPED ))
        xcValRaiz := ZBU->ZBU_CNPJVT
        if !(xcValRaiz $ 'S|N')
            return .T.
        endif
    endif


    //pega o cnpj de acordo com o tipo de operação
    if M->C5_TIPO $ 'NCPI'
        DbSelectArea('SA1')
        SA1->(dbSetOrder(1)) //FILIAL COD LOJA
        SA1->(dbSeek(xFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI))

        cnpjDestino := left(SA1->A1_CGC,8)
    else
        dbSelectArea('SA2')
        SA2->(dbSetOrder(1)) //FILIAL COD LOJA
        SA2->(dbSeek(xFilial('SA2') + M->C5_CLIENTE + M->C5_LOJACLI))

        cnpjDestino := left(SA2->A2_CGC,8)
    endif

    msgIgual := 'Aviso Fiscal – Operação de Venda não permitida para este Cliente/Fornecedor mesma raiz de CNPJ'
    msgDif := 'Aviso Fiscal – Operação de Transferência não Permitida para este Cliente/Forncedor raiz de CNPJ diferente'

    //valida a informação para o digitador do pedido
    if xcValRaiz == "N" .AND. cnpjOrigem == cnpjDestino
        if xlEntra
            alert(msgIgual)
        else
            ConOut('Funcao Origem: ' + FunName() + ' ' + msgIgual)
        endif
        xlRet := .f.
    elseif xcValRaiz $ "S" .AND. cnpjOrigem != cnpjDestino
        if xlEntra
            alert(msgDif)
        else
            ConOut('Funcao Origem: ' + FunName() + ' ' + msgDif)
        endif
        xlRet := .f.
    endif

return xlRet