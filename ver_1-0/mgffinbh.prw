#include 'protheus.ch'
#include 'Totvs.ch'
#include "topconn.ch"

#define CRLF CHR(13) + CHR(10)
 
/*/{Protheus.doc} MGFFINBH
Gatilho de Automação do processo do Cadastro de Segmento

@author Paulo da Mata
@since 20/02/2020
@version P12.1.17
@return Nil
/*/

User Function MGFFINBH

    Local aArea   := GetArea()
    Local cCodVnd := M->A1_VEND
    Local cCodSeg := "000000"
    Local cQryZBH := ""

    If Select("CQRYZBH") > 0
	    CQRYZBH->(dbClosearea())
    Endif

    If INCLUI .Or. ALTERA

        // Verifica se existe o registro na ZBH
        cQryZBH := "SELECT DISTINCT B.ZBH_CODIGO,B.ZBH_DESCRI,B.ZBH_REPRES,B.R_E_C_N_O_ REGISTRO "+CRLF
        cQryZBH += "FROM "+RetSqlName("ZBI")+" A "+CRLF
        cQryZBH += "JOIN "+RetSqlName("ZBH")+" B "+CRLF
        cQryZBH += "ON  B.ZBH_CODIGO = A.ZBI_SUPERV "+CRLF
        cQryZBH += "AND B.ZBH_DIRETO = A.ZBI_DIRETO "+CRLF
        cQryZBH += "AND B.ZBH_REGION = A.ZBI_REGION "+CRLF
        cQryZBH += "AND B.ZBH_TATICA = A.ZBI_TATICA "+CRLF
        cQryZBH += "AND B.ZBH_NACION = A.ZBI_NACION "+CRLF
        cQryZBH += "WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' "+CRLF
        cQryZBH += "AND A.ZBI_REPRES = '"+cCodVnd+"' "+CRLF

        TcQuery cQryZBH New Alias "CQRYZBH"

        /* 
        Verifica se, na tabela AOV (Cadastro de Segmentos), existe o segmanto cadastrado 
        e não bloqueado
        */
        
        AOV->(dbSetOrder(1))

        If AOV->(dbSeek(xFilial("AOV")+StrZero(CQRYZBH->REGISTRO,6)))

            If AOV->AOV_MSBLQL == "1"
                ApMsgAlert(OemToAnsi("Este registro foi excluido do Nivel 5"),OemToAnsi("ATENÇÃO"))
            Else
                cCodSeg      := StrZero(CQRYZBH->REGISTRO,6)
                M->A1_DESSEG := AOV->AOV_DESSEG 
            EndIf

        Else
           
           M->A1_CODSEG := cCodSeg    
           M->A1_DESSEG := Posicione("AOV",1,xFilial("AOV")+cCodSeg,"AOV_DESSEG")
        
        EndIf

    EndIf

    RestArea(aArea)

Return(cCodSeg)