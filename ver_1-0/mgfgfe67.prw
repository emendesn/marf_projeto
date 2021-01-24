#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
/*/
=====================================================================================
{Protheus.doc} MGFGFE67
Atualizar “Documento de Frete com Ocorrencias”

@description
Ao Incluir “Documento de Frete” Atualizar diversos campos da Ocorrencia

CAMPO OCORENCIA	-> CAMPO DO DOCUMENTO DE FRETE
GWD_NROCO  -> GW3_ZNROCO	-	Numero da Ocorrência
GWD_CDMOT  -> GW3_ZCDMOT 	-	Código do Motivo
GWD_DTOCOR -> GW3_ZDTOCOR	-	Data da Ocorrência
GWD_USUCRI -> GW3_ZUSUCRI	-	Usuário de Criação
GWD_ZOCMUL -> GW3_ZOCMUL	-	Ocorr. Multi Embarque

@autor Antonio Florêncio
@since 14/09/2019
@type user function 
@table
 GWD - Ocorrencias
 GW3 - Documento de Frete
 GW4 - DOCTOS CARGA DOS DOCTOS FRETE 
 GWL - OCORRENCIA X DOCTO CARGA      
@menu
 =====================================================================================
/*/
User Function MGFGFE67()

	Local _aGetArea	   := Getarea()
	Local _cGW3_FILIAL := GW3->GW3_FILIAL
	Local _cGW3_EMISDF := GW3->GW3_EMISDF
	Local _cGW3_CDESP  := GW3->GW3_CDESP
	Local _cGW3_SERDF  := GW3->GW3_SERDF
	Local _cGW3_NRDF   := GW3->GW3_NRDF
	Local _cGW3_DTEMIS := GW3->GW3_DTEMIS
	Local _nGW3_Recno  := GW3->(Recno())
    Local _cAliasGW3   := GetNextAlias()

    If Select(_cAliasGW3) > 0
	    (_cAliasGW3)->(DbClosearea())
	Endif

       BeginSql Alias _cAliasGW3

		Select 
                   GW3_ZNROCO,GWD_NROCO,
                   GW3_ZCDMOT,GWD_CDMOT,
                   GW3_ZDTOCO,GWD_DTOCOR,
                   GW3_ZUSUCR,GWD_USUCRI,
                   GW3_ZOCMUL,GWD_ZOCMUL
					
                   From %table:GW3% GW3
                       LEFT JOIN %table:GW4% GW4
                       ON GW4.GW4_FILIAL = GW3.GW3_FILIAL
                       AND GW4.GW4_EMISDF = GW3.GW3_EMISDF
                       AND GW4.GW4_CDESP = GW3.GW3_CDESP
                       AND GW4.GW4_SERDF = GW3.GW3_SERDF
                       AND GW4.GW4_NRDF = GW3.GW3_NRDF
                       AND GW4.GW4_DTEMIS  = GW3.GW3_DTEMIS
                       AND GW4.D_E_L_E_T_ =' '
                       LEFT JOIN %table:GWL% GWL
                       ON GWL.GWL_FILIAL = GW4.GW4_FILIAL
                       AND GWL.GWL_NRDC = GW4.GW4_NRDC
                       AND GWL.GWL_SERDC = GW4.GW4_SERDC
                       AND GWL.GWL_TPDC = GW4.GW4_TPDC
                       AND GWL.D_E_L_E_T_ = ' '
                       LEFT JOIN %table:GWD% GWD
                       ON GWD.GWD_FILIAL = GWL.GWL_FILIAL
                       AND GWD.GWD_NROCO = GWL.GWL_NROCO
                       AND GWD.D_E_L_E_T_ =' '
				Where
                           GW3.GW3_FILIAL = %EXP:_cGW3_FILIAL%
                       AND GW3.GW3_EMISDF = %EXP:_cGW3_EMISDF%
                       AND GW3.GW3_CDESP  = %EXP:_cGW3_CDESP%
                       AND GW3.GW3_SERDF  = %EXP:_cGW3_SERDF%
                       AND GW3.GW3_NRDF   = %EXP:_cGW3_NRDF%
                       AND GW3.GW3_DTEMIS = %EXP:_cGW3_DTEMIS%
	        		   AND GW3.%NotDel%


        EndSql

        TcSetField(_cAliasGW3,"GWD_DTOCOR","D",8,0)

        (_cAliasGW3)->(dbGoTop())
        IF !(_cAliasGW3)->(EOF()) 
            
            //Atualiza somente aqueles que tem ocorrência.
            If !Empty((_cAliasGW3)->GWD_DTOCOR)
            
                dbSelectArea('GW3')
                RecLock('GW3',.F.)
                GW3_ZNROCO  := (_cAliasGW3)->GWD_NROCO  //Numero da Ocorrência
                GW3_ZCDMOT  := (_cAliasGW3)->GWD_CDMOT  //Código do Motivo
                GW3_ZDTOCOR := (_cAliasGW3)->GWD_DTOCOR //Data da Ocorrência
                GW3_ZUSUCRI := (_cAliasGW3)->GWD_USUCRI //Usuário de Criação
                GW3_ZOCMUL  := (_cAliasGW3)->GWD_ZOCMUL //Ocorr. Multi Embarque
                MsUnLock()	 
                
            EndIf

        EndIf

        (_cAliasGW3)->(dbClosearea())
    
	Restarea(_aGetArea)

Return
