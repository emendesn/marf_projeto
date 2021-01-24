#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"   
/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MTA105COR   ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦O objetivo deste fonte é mudar o status da SA               ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA MARFRIG			                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR      ¦ DATA       ¦ MOTIVO DA ALTERACAO                    ¦
+-----------------------------------------------------------------------¦
¦                 ¦            ¦ 				                        ¦
+-----------------------------------------------------------------------+
*/
User Function MT105COR()
Local aCores := ParamIXB[1]
Local aRet   := { { "Trim(CP_ZSTATUS)$'00' .And. CP_STATSA='B'", "BR_AMARELO" },;       // Aguardando Aprovação EPI
                  { "Trim(CP_ZSTATUS)='01' .And. CP_STATSA='B'", "BR_BRANCO" },;        // Aprovado Adm
                  { "Trim(CP_ZSTATUS)='04' .And. CP_STATSA='B'", "BR_AZUL" },;          // Rejeitado Tec  
                  { "Trim(CP_ZSTATUS)='03' .And. CP_STATSA='B'", "BR_MARROM" },;        // Rejeitado Adm
                  { "Trim(CP_ZSTATUS)='02' .And. CP_STATSA='B'", "BR_PRETO_0" },;       // Aprovou Tecnico e Aguardando Aprovação de Funcionário
                  { "Trim(CP_ZSTATUS)='07' .And. CP_STATSA='B'", "BR_LARANJA" },;        // Aguardando Aprovação Gerente SA Embalagem
                  { "Trim(CP_ZSTATUS)='08' .And. CP_STATSA='B'", "BR_AZUL_CLARO" },;    // SA de embalagem aprovado pelo gerente
                  { "Trim(CP_ZSTATUS)='09' .And. CP_STATSA='B'", "BR_VIOLETA" },;       // SA de embalagem reprovada pelo gerente                                   
                  { "Trim(CP_ZSTATUS)='05' .And. CP_STATSA='L'", "BR_VERDE_ESCURO" }}  // Aprovado RH e Liberado

aEval( aCores, { |x| aAdd( aRet, x ) } )
Return aRet
