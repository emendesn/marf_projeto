#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include "tbiconn.ch"

#Define   ENTER Chr( 13 ) + Chr( 10 )

/*===================================================================================+
|  Programa............:   MGFCRM52                                                  |
|  Autor...............:   johnny.osugi@totvspartners.com.br                         |
|  Data................:   22/08/2018                                                |
|  Descricao / Objetivo:   Selecao de RAMI (markbrowse)                              |
|  Doc. Origem.........:   GAP CRM                                                   |
|  Solicitante.........:   Cliente                                                   |
|  Uso.................:                                                      |
|  Obs.................:                                                             |
+===================================================================================*/
User Function MGFCRM52()
Local aArea      :=  GetArea()
Local aRet       :=  {}
Local aMVParBkp  :=  MV_PAR01
Local cQryZAV    :=  ""
Local aCoors     :=  FWGetDialogSize( oMainWnd )
Local oDlg       :=  NIL
Local aSeek      :=  {}
Local bMark      :=  { || iIf( aZAV[oMark:nAt][1], 'LBOK', 'LBNO' ) }
Local bDblClick  :=  { || ClickMark( oMark, aZAV ) }
Local bMarkAll   :=  { || MarkAll( oMark, aZAV ) }
Local bOk        :=  { || RetMark( oMark, aZAV, aZAVMark ), LoadItens( aZAV ), oDlg:End() }
Local bClose     :=  { || iIf( .T., oDlg:End(), ) }

Private oZAV     :=  NIL
Private oMark
Private aZAV     :=  {}
Private aZAVMark

MV_PAR01 := Space( 6 )

If !MAFISFOUND( "NF" )
   Help( '', 1, 'A103CAB' )
   Return( Nil )
EndIf

If M->cTipo <> "D"
   Return( Nil )
EndIf

If cFormul == "S"
   If Empty( cA100For  ) .or.;
      Empty( cLoja     ) .or.;
      Empty( cUfOrig   ) .or.;
      Empty( cEspecie  ) .or.;
      Empty( dDEmissao )
      MsgAlert( OEMToANSI( "Para trazer os RAMI deste cliente � necessario preencher o cabecalho." ) )
      Return( Nil )
   EndIf
ElseIf cFormul == "N"
       If Empty( cA100For  ) .or.;
          Empty( cLoja     ) .or.;
          Empty( cUfOrig   ) .or.;
          Empty( cEspecie  ) .or.;
          Empty( dDEmissao ) .or.;
          Empty( cNFiscal  ) .or.;
          Empty( cSerie    )
          MsgAlert( OEMToANSI( "Para trazer os RAMI deste cliente � necessario preencher o cabecalho." ) )
          Return( Nil )
       EndIf
EndIf

/*------------------------------------+
| Montagem da query                   |
+------------------------------------*/
cQryZAV  :=  "SELECT *"                                             + ENTER
cQryZAV  +=  " FROM " + RetSQLName( "ZAV" ) + " ZAV"                + ENTER
cQryZAV  +=  " INNER JOIN "	+ RetSQLName( "SF2" ) + " SF2"          + ENTER
cQryZAV  +=  " ON"                                                  + ENTER
cQryZAV  +=  "      ZAV.ZAV_SERIE   =   SF2.F2_SERIE"               + ENTER
cQryZAV  +=  "  AND ZAV.ZAV_NOTA    =   SF2.F2_DOC"                 + ENTER
cQryZAV  +=  ""                                                     + ENTER
cQryZAV  +=  " WHERE"                                               + ENTER
cQryZAV  +=  "      SF2.F2_LOJA     =   '" + cLoja  + "'"           + ENTER
cQryZAV  +=  "  AND SF2.F2_CLIENTE  =   '" + cA100For + "'"         + ENTER
cQryZAV  +=  "  AND ZAV.ZAV_STATUS  =   '0'"                        + ENTER  // Em Andamento
cQryZAV  +=  "  AND SF2.F2_FILIAL   =   '" + xFilial( "SF2" ) + "'" + ENTER
cQryZAV  +=  "  AND ZAV.ZAV_FILIAL  =   '" + xFilial( "ZAV" ) + "'" + ENTER
cQryZAV  +=  "  AND SF2.D_E_L_E_T_  <>  '*'"                        + ENTER
cQryZAV  +=  "  AND ZAV.D_E_L_E_T_  <>  '*'"                        + ENTER

If Select( "QRYZAV" ) > 0
   QRYZAV->( DbCloseArea() )
EndIf

TCQuery cQryZAV New Alias "QRYZAV"

SM0->( DbSetOrder( 1 ) )

If .not. QRYZAV->( EoF() )
   Do While .not. QRYZAV->( EoF() )
      aAdd( aZAV, { .F., QRYZAV->ZAV_CODIGO, QRYZAV->ZAV_DTABER, QRYZAV->ZAV_NOTA, QRYZAV->ZAV_SERIE, QRYZAV->ZAV_NFEMIS } )
      QRYZAV->( DBSkip() )
   EndDo

   /*------------------------------------+
   | Pesquisa que sera exibido           |
   +------------------------------------*/
   aAdd( aSeek, { "Senha", { { "", "C", TamSX3( "ZAV_CODIGO" )[1], 0, "Senha"   ,,} } } )
   aAdd( aSeek, { "Nota",  { { "", "C", TamSX3( "ZAV_NOTA"   )[1], 0, "N�vel 1" ,,} } } )

   DEFINE MSDIALOG oDlg TITLE 'Relacao RAMI Cliente' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL STYLE DS_MODALFRAME
        oMark := fwBrowse():New()
        oMark:SetDataArray()
        oMark:SetArray( aZAV )
        oMark:DisableConfig()
        oMark:DisableReport()
        oMark:SetOwner( oDlg )
        oMark:SetSeek(, aSeek )
        oMark:AddMarkColumns( bMark, bDblClick, bMarkAll )

        oMark:AddColumn( { "Senha",        { || aZAV[oMark:nAt,2] },         "C", , 1, TamSX3( "ZAV_CODIGO" )[1],, .F.} )
        oMark:AddColumn( { "Dt. Abertura", { || StoD( aZAV[oMark:nAt,3] ) }, "D", , 1, 10,, .F.} )
        oMark:AddColumn( { "Nota",         { || aZAV[oMark:nAt,4] },         "C", , 1, TamSX3( "ZAV_NOTA"   )[1],, .F.} )
        oMark:AddColumn( { "Serie",        { || aZAV[oMark:nAt,5] },         "C", , 1, TamSX3( "ZAV_SERIE"  )[1],, .F.} )
        oMark:AddColumn( { "Emissao NF",   { || StoD( aZAV[oMark:nAt,6] ) }, "D", , 1, 10,, .F.} )

		oMark:Activate( .T. )

		EnchoiceBar( oDlg, bOk , bClose )
   ACTIVATE MSDIALOG oDlg CENTER

Else
    MsgAlert( OEMToANSI( "Nao  foi encontrado nenhum RAMI para este cliente." ) )
EndIf

QRYZAV->( DBCloseArea() )
RestArea( aArea )
Return( .T. )

/*===================================================================================+
|  Funcao Estatica ....:   SetNFRAMI                                                 |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   Montagem da query dos itens da RAMI                       |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function SetNFRAMI( oMarkx, aZAVx, aZAVMrk )
Local aArea    := GetArea()
Local cQryZAV1 := ""

cQryZAV  :=  "SELECT F2_CLIENTE, F2_LOJA, A1_COD, A1_LOJA, A1_EST, F2_CHVNFE " + ENTER
cQryZAV  +=  " FROM " + RetSQLName( "ZAV" ) + " ZAV"                           + ENTER
cQryZAV  +=  " INNER JOIN " + RetSQLName( "SF2" ) + " SF2"                     + ENTER
cQryZAV  +=  " ON" + ENTER
cQryZAV  +=  "      ZAV_NFEMIS  =   SF2.F2_EMISSAO"                            + ENTER
cQryZAV  +=  " 	AND	ZAV_SERIE   =   SF2.F2_SERIE"                              + ENTER
cQryZAV  +=  " 	AND	ZAV_NOTA    =   SF2.F2_DOC"                                + ENTER

cQryZAV  +=  " INNER JOIN " + RetSQLName( "SA1" ) + " SA1"                     + ENTER
cQryZAV  +=  " ON"   + ENTER
cQryZAV  +=  "      SA1.A1_COD      =	SF2.F2_CLIENTE"                        + ENTER
cQryZAV  +=  "  AND SA1.A1_LOJA     =	SF2.F2_LOJA"                           + ENTER
cQryZAV  +=  "  AND SA1.A1_FILIAL   =	'" + xFilial( "SA1" ) + "'"            + ENTER
cQryZAV  +=  "  AND SA1.D_E_L_E_T_	<>	'*'"                                   + ENTER

cQryZAV  += " WHERE"                                                           + ENTER
cQryZAV  += "        ZAV.ZAV_CODIGO  =   '" + cCodRAMI         + "'"           + ENTER
cQryZAV  += "    AND SF2.F2_FILIAL   =   '" + xFilial( "SF2" ) + "'"           + ENTER
cQryZAV  += "    AND ZAV.ZAV_FILIAL  =   '" + xFilial( "ZAV" ) + "'"           + ENTER
cQryZAV  += "    AND SF2.D_E_L_E_T_  <>  '*'"                                  + ENTER
cQryZAV  += "    AND ZAV.D_E_L_E_T_  <>  '*'"                                  + ENTER

MemoWrite( "C:\TEMP\MGFCRM12.SQL", cQryZAV )

TcQuery cQryZAV New Alias "QRYZAV1"

If .not. QRYZAV->( EoF() )
   /*
   If GetNewPar( "MV_DCHVNFE", .F. ) .and. cFormul == "N" .and. AllTrim( cEspecie )$"|SPED|CTE|NFA|"
      M->F1_CHVNFE := QRYZAV->F2_CHVNFE
   Else
      M->F1_CHVNFE := Space( 44 )
   EndIf
   */
aNFEDanfe[13] := Space( 44 ) //M->F1_CHVNFE
   If bRefresh <> Nil
      Eval( bRefresh, 9, 9 )
   EndIf
endif

QRYZAV->( DBCloseArea() )

RestArea( aArea )
Return( Nil )

/*===================================================================================+
|  Funcao Estatica ....:   LoadItens                                                 |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   Carrega os itens da RAMI                                  |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function LoadItens( aZAVIt )
Local nPosItem    :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ITEM"    } )
Local nPosCod     :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_COD"     } )
Local nPosDes     :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_PRODESC" } )
Local nPosUM      :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_UM"      } )
Local nPosQuant   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_QUANT"   } )
Local nPosVUnit   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VUNIT"   } )
Local nPosTotal   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_TOTAL"   } )
Local nPosLocal   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_LOCAL"   } )
Local nPosNFOri   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_NFORI"   } )
Local nPosSerOri  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_SERIORI" } )
Local nPosItOri   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ITEMORI" } )
Local nPosQtDev   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_QTDEDEV" } )
Local nPosVlDev   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VALDEV"  } )
Local nPosRAMI    :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ZRAMI"   } )
Local nPosTES     :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_TES"     } )
Local nPosCF      :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_CF"      } )

Local nPosIpi     :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_IPI"     } )
Local nPosValIpi  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VALIPI"  } )
Local nPosBasIpi  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_BASEIPI" } )
Local nPosICM     :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_PICM"    } )
Local nPosValICM  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VALICM"  } )
Local nPosBasICM  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_BASEICM" } )

Local nPosValDe   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_VALDESC" } )
Local nPosDescZ   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_DESCZFR" } )

Local nPosCodMot  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ZCODMOT"	} )
Local nPosDesMot  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ZDESCMO"	} )
Local nPosCodJus  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ZCODJUS"	} )
Local nPosDesJus  :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "D1_ZDESCJU"	} )

Local cLastItem   :=  aTail( aCols )[nPosItem]
Local lFirstLine  :=  .T.
Local cLocalDev   :=  AllTrim( SuperGetMv( "MGF_ARMDEV", .F., "99" ) )
Local aArea       :=  { SF4->( GetArea() ), SD2->( GetArea() ), GetArea() }
Local aTransp     :=  { "", "" }
Local nTotal      :=  0
Local lContinua   :=  .T.
Local cQuery      :=  ""
Local cRelRAMI    :=  ""
Local nI, nY

/*-----------------------------------------------------+
| Monta a query com os itens selecionados pelo usuario |
+-----------------------------------------------------*/
For n := 1 to Len( aZAVIt )
    If aZAVIt[n][1]
       If Len( cRelRAMI ) == 0
          cRelRAMI := "      (ZAV.ZAV_CODIGO  =   '" + aZAVIt[n][2] + "'" + ENTER
       Else
          cRelRAMI += "    OR ZAV.ZAV_CODIGO  =   '" + aZAVIt[n][2] + "'" + ENTER
       EndIf
    EndIf
NexT

If Len( cRelRAMI ) > 0
   cRelRAMI += ")" + ENTER
Else
   LmpAcols() // >>>-----> Funcao estatica LmpAcols() que limpa a array aCols
   aEval( aArea, { |x| RestArea( x ) } )
   Return( Nil )
EndIf

ItensRAMI( cRelRAMI ) //  >>>-----> Funcao que carrega os itens dos RAMI na aCols do MATA103.

SD2->( DbSetOrder( 3 ) ) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SF4->( DbSetOrder( 1 ) ) // F4_FILIAL + F4_CODIGO

/*----------------------------------------------+
| Verifica se TES de devolucao esta' preenchido |
+----------------------------------------------*/
Do While .not. QRYZAW->( EoF() )
   SF4->( DBGoTop() )
   If SF4->( DbSeek( xFilial( "SF4" ) + QRYZAW->D2_TES ) )
      If Empty( QRYZAW->F4_TESDV ) .or. Empty( QRYZAW->F4_ZTESDE1 )
         APMsgStop("Tes de Devolucao nao informado para o TES de saida: " + QRYZAW->D2_TES + "." + ENTER + ;
         "Verifique o cadastro do TES (Campos F4_TESDV e F4_ZTESDE1)." + ENTER + ;
         "Nao  sera possivel incluir a Nota de Devolucao.")

         lContinua := .F.
         Exit
      EndIf
   EndIf
   QRYZAW->( DbSkip() )
EndDo

QRYZAW->( DbGoTop() )

If .not. lContinua
   QRYZAW->( DBCloseArea() )
   aEval( aArea,{ |x| RestArea( x ) } )
   RestArea( aArea )
   Return( Nil )
EndIf

If cLastItem == "0001" .and. Empty( aTail( aCols )[nPosCod] )
   lFirstLine := .T.
EndIf

LmpAcols()// >>>-----> Funcao estatica LmpAcols() que limpa a array aCols

Do While .not. QRYZAW->( EoF() )
   SD2->( DbSeek( xFilial( "SD2" ) + QRYZAW->ZAW_NOTA + QRYZAW->ZAW_SERIE + cA100For + cLoja + QRYZAW->ZAW_CDPROD ) )

   If .not. ( QRYZAW->QTD > xQtdZAX( xFilial( "ZAW" ), QRYZAW->ZAW_CDRAMI, QRYZAW->ZAW_ITEMNF ) )
      QRYZAW->( DbSkip() )
      Loop
   EndIf

   If lFirstLine
      lFirstLine := .F.
   Else
      oGetDados:addLine()
   EndIf

   cLastItem  :=  aCols[ Len( aCols ), nPosItem ]
   aLineAux   :=  {}

   For nI := 1 to Len( aHeader )
       if nI == nPosItem
          aAdd( aLineAux, cLastItem )
       ElseIf nI == nPosCod
              aAdd( aLineAux, QRYZAW->ZAW_CDPROD )
       ElseIf nI == nPosDes
              aAdd( aLineAux, Posicione( "SB1", 1, xFilial( "SB1" ) + QRYZAW->ZAW_CDPROD, "B1_DESC" ) )
       ElseIf nI == nPosUM
              aAdd( aLineAux, QRYZAW->B1_UM )
       ElseIf nI == nPosQuant
              aAdd( aLineAux, QRYZAW->QTD - xQtdZAX( xFilial( "ZAW" ), QRYZAW->ZAW_CDRAMI, QRYZAW->ZAW_ITEMNF ) )
       ElseIf nI == nPosVUnit
              If QRYZAW->D2_DESCZFR > 0 .and. CUFORIG == "AP"
                 aAdd( aLineAux, (QRYZAW->TOTAL + QRYZAW->D2_DESCZFR) / QRYZAW->QTDD2  )
              ElseIf QRYZAW->D2_DESCZFR > 0 .and. CUFORIG == "AM" // Acrescido a condicional para atender a situacao de desconto (Zona Franca) para clientes do "AM"azonas.
                     aAdd( aLineAux, (QRYZAW->TOTAL + QRYZAW->D2_DESCZFR) / QRYZAW->QTD )
              Else
                 aAdd( aLineAux, QRYZAW->TOTAL / QRYZAW->QTDD2  )
              EndIf
       ElseIf nI == nPosTotal
              If QRYZAW->D2_DESCZFR > 0  .and. (CUFORIG == "AP" .or. CUFORIG == "AM") // Acrescido a condicional para atender a situacao de desconto (Zona Franca) para clientes do "AM"azonas ou "A"ma"P"a.
                 aAdd( aLineAux, QRYZAW->TOTAL + QRYZAW->D2_DESCZFR )
              Else
                 aAdd( aLineAux, QRYZAW->TOTAL )
              EndIf
       ElseIf nI == nPosLocal
              If QRYZAW->ZAV_REVEND == "S"
                 aAdd( aLineAux, cLocalDev )
              Else
                 aAdd( aLineAux, Posicione( "SB1", 1, xFilial( "SB1" ) + QRYZAW->ZAW_CDPROD, "B1_LOCPAD" ) )
              EndIf
       ElseIf nI == nPosNFOri
              aAdd( aLineAux, QRYZAW->ZAV_NOTA )
       ElseIf nI == nPosSerOri
              aAdd( aLineAux, QRYZAW->ZAV_SERIE )
       ElseIf nI == nPosItOri
              aAdd( aLineAux, QRYZAW->ZAW_ITEMNF )
       ElseIf nI == nPosValDe
              aAdd( aLineAux, QRYZAW->D2_DESCZFR )
       ElseIf nI == nPosRAMI
              aAdd( aLineAux, QRYZAW->ZAW_CDRAMI )
       ElseIf nI == nPosTES
              If M->cFormul == "S"
                 aAdd( aLineAux, QRYZAW->F4_ZTESDE1 )
              ElseIf M->cFormul == "N"
                     aAdd( aLineAux, QRYZAW->F4_TESDV )
              EndIf
       ElseIf nI == nPosCF
              If M->cFormul == "S"
                 aAdd( aLineAux, getCFTes( QRYZAW->F4_ZTESDE1 ) )
              ElseIf M->cFormul == "N"
                     aAdd( aLineAux, getCFTes( QRYZAW->F4_TESDV ) )
              EndIf
       ElseIf Trim( aHeader[nI][2] ) == "D1_ITEM"
              aAdd( aLineAux, StrZero( 1, 4 ) )
       ElseIf nI == nPosCodMot
              aAdd( aLineAux, QRYZAW->ZAS_CODIGO )
       ElseIf nI == nPosDesMot
              aAdd( aLineAux, QRYZAW->ZAS_DESCRI )
       ElseIf nI == nPosCodJus
              aAdd( aLineAux, QRYZAW->ZAT_CODIGO )
       ElseIf nI == nPosDesJus
              aAdd( aLineAux, QRYZAW->ZAT_DESCRI )
       Else
         If AllTrim( aHeader[nI,2] ) == "D1_ALI_WT"
            aAdd( aLineAux, "SD1" )
         ElseIf AllTrim( aHeader[nI,2] ) == "D1_REC_WT"
                aAdd( aLineAux, 0 )
         Else
            aAdd( aLineAux, CriaVar( aHeader[nI][2] ) )
         EndIf
       EndIf
   NexT

   aAdd( aLineAux, .F.)

   aCols[Len( aCols )] := aClone( aLineAux )

   n := Len( aCols )

   If ExistTrigger( "D1_COD" ) // verifica se existe trigger para este campo
      RunTrigger( 2, n, NIL,, "D1_COD" )
   Endif
   oGetDados:Refresh()

   If ExistTrigger( "D1_QUANT" ) // verifica se existe trigger para este campo
      RunTrigger( 2, n, NIL , , "D1_QUANT" )
   Endif
   oGetDados:Refresh()

   If ExistTrigger( "D1_VUNIT" ) // verifica se existe trigger para este campo
      RunTrigger( 2, n, NIL,, "D1_VUNIT" )
   EndIf
   oGetDados:Refresh()

   If ExistTrigger( "D1_TOTAL" ) // verifica se existe trigger para este campo
      RunTrigger( 2, n, NIL,, "D1_TOTAL")
   EndIf
   oGetDados:Refresh()

   nItem := n

   If isInCallStack( "MATA103" )
      If MaFisFound()
         A103VldNFO( Len( aCols ) ) // Verifica Notas de Complemento/Devolucao vinculadas a NFE
      EndIf
   EndIf

   QRYZAW->( DBSkip() )

EndDo

QRYZAW->( DBCloseArea() )

aEval( aArea, { |x| RestArea( x ) } )

Return( Nil )

/*===================================================================================+
|  Funcao Estatica ....:   ItensRAMI                                                 |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   Itens da RAMI                                             |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function ItensRAMI( cRelRAMI )
Local cQryZAW  :=  ""

cQryZAW := " SELECT ZAW_CDPROD, B1_UM, ZAW_QTD AS QTD, D2_PRCVEN AS PRECO, D2_TOTAL AS TOTAL, " + ENTER
cQryZAW += " ZAV_NOTA, ZAV_SERIE, ZAW_CDRAMI, ZAW_ITEMNF, ZAW_ID, ZAW_NOTA, ZAW_SERIE,  "       + ENTER
cQryZAW += " D2_DESCZFR, D2_TES, D2_QUANT QTDD2, F4_CODIGO, F4_TESDV, F4_ZTESDE1, ZAV_REVEND,"  + ENTER
cQryZAW += " ZAS_CODIGO, ZAS_DESCRI, ZAT_CODIGO, ZAT_DESCRI"        + ENTER
cQryZAW += " FROM " + retSQLName( "ZAV" ) + " ZAV"                  + ENTER
cQryZAW += " INNER JOIN " + retSQLName( "ZAW" ) + " ZAW"            + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAV.ZAV_CODIGO  =   ZAW.ZAW_CDRAMI"             + ENTER
cQryZAW += " INNER JOIN " + retSQLName( "SB1" ) + " SB1"            + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAW.ZAW_CDPROD  =   SB1.B1_COD"                 + ENTER

cQryZAW += " INNER JOIN " + retSQLName( "SD2" ) + " SD2"            + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAW.ZAW_ITEMNF  =   SD2.D2_ITEM"                + ENTER
cQryZAW += "    AND ZAW.ZAW_SERIE   =   SD2.D2_SERIE"               + ENTER
cQryZAW += "    AND ZAW.ZAW_NOTA    =   SD2.D2_DOC"                 + ENTER
cQryZAW += "    AND SD2.D2_FILIAL   =   '" + xFilial( "SD2" ) + "'" + ENTER
cQryZAW += "    AND SD2.D_E_L_E_T_  <>  '*'"                        + ENTER

cQryZAW += " INNER JOIN " + retSQLName( "SF4" ) + " SF4"            + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        SF4.F4_CODIGO   =   SD2.D2_TES"                 + ENTER
cQryZAW += "    AND SF4.F4_FILIAL   =   '" + xFilial( "SF4" ) + "'" + ENTER
cQryZAW += "    AND SF4.D_E_L_E_T_  <>  '*'"                        + ENTER

/*----------------------------------------------+
| ZAU - MOTIVO X JUSTIFICATIVA                  |
+----------------------------------------------*/
cQryZAW += " LEFT JOIN " + retSQLName( "ZAU" ) + " ZAU"             + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAW.ZAW_DIRECI  =   ZAU.ZAU_CODIGO"             + ENTER
cQryZAW += "    AND ZAU.ZAU_FILIAL  =   '" + xFilial( "ZAU" ) + "'" + ENTER
cQryZAW += "    AND ZAU.D_E_L_E_T_  <>  '*'"                        + ENTER

/*----------------------------------------------+
| ZAS - MOTIVO                                  |
+----------------------------------------------*/
cQryZAW += " LEFT JOIN " + retSQLName( "ZAS" ) + " ZAS"             + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAU.ZAU_CODMOT  =   ZAS.ZAS_CODIGO"             + ENTER
cQryZAW += "    AND ZAS.ZAS_FILIAL  =   '" + xFilial( "ZAS" ) + "'" + ENTER
cQryZAW += "    AND ZAS.D_E_L_E_T_  <>  '*'"                        + ENTER

/*----------------------------------------------+
| ZAT - JUSTIFICATIVA                           |
+----------------------------------------------*/
cQryZAW += " LEFT JOIN " + retSQLName( "ZAT" ) + " ZAT"             + ENTER
cQryZAW += " ON"                                                    + ENTER
cQryZAW += "        ZAU.ZAU_CODJUS  =   ZAT.ZAT_CODIGO"             + ENTER
cQryZAW += "    AND ZAT.ZAT_FILIAL  =   '" + xFilial( "ZAT" ) + "'" + ENTER
cQryZAW += "    AND ZAT.D_E_L_E_T_  <>  '*'"                        + ENTER

cQryZAW += " WHERE"                                                 + ENTER
cQryZAW += cRelRAMI  // >>>-----> Relacao de RAMI do cliente.

cQryZAW += "    AND SB1.B1_FILIAL   =   '" + xFilial( "SB1" ) + "'" + ENTER
cQryZAW += "    AND ZAW.ZAW_FILIAL  =   '" + xFilial( "ZAW" ) + "'" + ENTER
cQryZAW += "    AND ZAV.ZAV_FILIAL  =   '" + xFilial( "ZAV" ) + "'" + ENTER
cQryZAW += "    AND SB1.D_E_L_E_T_  <>  '*'"                        + ENTER
cQryZAW += "    AND ZAW.D_E_L_E_T_  <>  '*'"                        + ENTER
cQryZAW += "    AND ZAV.D_E_L_E_T_  <>  '*'"                        + ENTER
cQryZAW += "    ORDER BY ZAW.ZAW_CDRAMI, ZAW.ZAW_ID, ZAW.ZAW_ITEMNF"+ ENTER

TcQuery cQryZAW New Alias "QRYZAW"

_aAreaSC7 := GetArea( "SD2" )

DbSelectArea( "SD2" )
DbSetOrder( 3 ) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
SD2->( DbGoTop() )
DbSeek( xFilial( "SD2" ) + QRYZAW->ZAW_NOTA + QRYZAW->ZAW_SERIE )
Do While .not. SD2->( EoF() ) .and. SD2->D2_DOC == QRYZAW->ZAW_NOTA .and. SD2->D2_SERIE == QRYZAW->ZAW_SERIE

   Reclock( "SD2", .F. )
   Replace SD2->D2_QTDEDEV with 0
   Replace SD2->D2_VALDEV  with 0
   MsUnLock()

   DbSelectArea( "SD2" )
   SD2->( DbSkip() )
EndDo

RestArea( _aAreaSC7 )
Return( Nil )

/*===================================================================================+
|  Funcao Estatica ....:   GetCFTES                                                  |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   .                                                         |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function GetCFTES( cTESDevol )
Local  aArea      :=  GetArea()
Local  cQrySF4    :=  ""
Local  cRetCF     :=  ""
Local  aDadosCFO  :=  {}

cQrySF4 := "SELECT F4_CF"                                           + ENTER
cQrySF4 += " FROM " + RetSQLName( "SF4" ) + " SF4"                  + ENTER
cQrySF4 += " WHERE"                                                 + ENTER
cQrySF4 += "        SF4.F4_CODIGO   =   '" + cTESDevol        + "'"	+ ENTER
cQrySF4 += "    AND SF4.F4_FILIAL   =   '" + xFilial( "SF4" ) + "'"	+ ENTER
cQrySF4 += "    AND SF4.D_E_L_E_T_  <>  '*'"                        + ENTER

TcQuery cQrySF4 New Alias "QRYSF4"

If .not. QRYSF4->( EoF() )
   cRetCF := QRYSF4->F4_CF
   aDadosCFO := {}
   aAdd( aDadosCFO, { "OPERNF",   "E" } )
   aAdd( aDadosCFO, { "TPCLIFOR", GetAdvFVal( "SA1", "A1_TIPO", xFilial( "SA1" ) + cA100For+cLoja, 1, "" ) } )
   aAdd( aDadosCFO, { "UFDEST",   GetAdvFVal( "SA1", "A1_EST",  xFilial( "SA1" ) + cA100For+cLoja, 1, "" ) } )
   cRetCF := MaFisCFO( , cRetCF, aDadosCfo )
EndIf

QRYSF4->( DBCloseArea() )
RestArea( aArea )
Return( cRetCF )

/*===================================================================================+
|  Funcao Estatica ....:   ChkRAMI                                                   |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   Verifica se RAMI digitada j� foi utilizada anteriormente. |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function ChkRAMI()
Local  aArea    :=  GetArea()
Local  lRet     :=  .T.
Local  cQrySD1  :=  ""

cQrySD1  :=  " SELECT D1_ZRAMI"                                          + ENTER
cQrySD1  +=  " FROM " + RetSQLName( "SD1" ) + " SUBSD1"                  + ENTER
cQrySD1  +=  " WHERE"                                                    + ENTER
cQrySD1  +=  "      SUBSD1.D1_ZRAMI     =   '" + MV_PAR01 + "'"          + ENTER
cQrySD1  +=  "  AND SUBSD1.D1_FILIAL    =   '" + xFilial( "SD1" ) + "'"  + ENTER
cQrySD1  +=  "  AND SUBSD1.D_E_L_E_T_  <>   '*'"                         + ENTER

TCQuery cQrySD1 New Alias "QRYSD1"

If .not. QRYSD1->( EoF() )
   MsgAlert( OEMToANSI( "RAMI " + AllTrim( MV_PAR01 ) + " j� utilizada em outra devolucao." ) )
   lRet := .F.
EndIf

QRYSD1->( DBCloseArea() )
RestArea( aArea )
Return( lRet )

/*===================================================================================+
|  Funcao Estatica ....:   xQtdZAX                                                   |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   22/08/2018                                                |
|  Descricao / Objetivo:   .                                                         |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function xQtdZAX( cxFil, cCodRAM, cItemNF )

Local aArea      :=  GetArea()
Local aAreaZAV   :=  ZAV->( GetArea() )
Local aAreaZAW   :=  ZAW->( GetArea() )
Local aAreaZAX   :=  ZAX->( GetArea() )
Local cNextAlias :=  GetNextAlias()
Local nTotZAX    :=  0

If Select(cNextAlias) > 0
   ( cNextAlias )->( DbCloseArea() )
EndIf

BeginSQL Alias cNextAlias

   SELECT
      SUM( ZAX.ZAX_QTD ) ZAX_QTD
   FROM %Table:ZAX% ZAX
   WHERE
           ZAX.%NotDel%
   AND ZAX.ZAX_FILIAL = %Exp:cxFil%
   AND ZAX.ZAX_CDRAMI = %Exp:cCodRam%
   AND ZAX.ZAX_ITEMNF = %Exp:cItemNf%

EndSQL

( cNextAlias )->( DbGoTop() )

Do While ( cNextAlias )->( !EoF() )
   nTotZAX += ( cNextAlias )->ZAX_QTD
   ( cNextAlias )->( DbSkip() )
EndDo

( cNextAlias )->( DbCloseArea() )

RestArea( aAreaZAX )
RestArea( aAreaZAW )
RestArea( aAreaZAV )
RestArea( aArea )

Return( nTotZAX )

/*===================================================================================+
|  Funcao Estatica ....:   ClickMark                                                 |  
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   23/08/2018                                                |
|  Descricao / Objetivo:   Marcacao no markbrowse.                                   |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function ClickMark(oBrowse, aDados)
Local aArea  :=  GetArea()
Local lRet   :=  !aDados[oBrowse:At(),1]

aDados[oBrowse:At(),1] := lRet

RestArea( aArea )
Return( lRet )

/*===================================================================================+
|  Funcao Estatica ....:   RetMark                                                   |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   23/08/2018                                                |
|  Descricao / Objetivo:   Retorno da marcacao do markbrowse.                        |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function RetMark( oBrowse, aDados, aMark )
Local  aArea  :=  GetArea()
Local  nI     :=  0
Local  aMark  :=  {}

For nI := 1 to Len( aDados )
    If aDados[nI, 1]
       aAdd( aMark, aDados[nI] )
    EndIf
NexT

RestArea( aArea )
Return( Nil )

/*===================================================================================+
|  Funcao Estatica ....:   MarkAll                                                   |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                         |
|  Data ...............:   23/08/2018                                                |
|  Descricao / Objetivo:   Marca todos os itens do markbrowse.                       |
|  Observacao .........:                                                             |
+===================================================================================*/
Static Function MarkAll( oBrowse, aDados )
Local nI := 0
For nI := 1 to Len( aDados )
    If .not. aDados[nI, 1]
       aDados[nI, 1] := .T.
    Else
       aDados[nI, 1] := .F.
    EndIf
NexT

oBrowse:Refresh( .F. )

Return( Nil )

/*==================================================================================+
|  Funcao Estatica ....:   LmpAcols()                                               |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                        |
|  Data ...............:   08/10/2018                                               |
|  Descricao / Objetivo:   Funcao estatica que realiza a llimpeza do aCols.         |
|  Observacao .........:                                                            |
+==================================================================================*/
Static Function LmpAcols()
Local  aArea     :=  GetArea()
Local  aLineAux  :=  {}

For nY := 1 To Len( aHeader )
    If Trim( aHeader[nY][2] ) == "D1_ITEM"
       aAdd( aLineAux, StrZero( 1, 4 ) )
    Else
       If AllTrim( aHeader[nY,2] ) == "D1_ALI_WT"
          aAdd( aLineAux, "SD1" )
       ElseIf AllTrim( aHeader[nY,2] ) == "D1_REC_WT"
              aAdd( aLineAux, 0 )
       Else
          aAdd( aLineAux, CriaVar( aHeader[nY][2] ) )
       EndIf
    EndIf
NexT nY

aAdd( aLineAux, .F. )
aCols := {}
aAdd( aCols, aLineAux )
n     := Len( aCols )
oGetDados:Refresh()

RestArea( aArea )
Return( Nil )

/*==================================================================================+
|  Funcao de Usuario ..:   MGFChkDup()                                              |
|  Autor ..............:   johnny.osugi@totvspartners.com.br                        |
|  Data ...............:   28/09/2018                                               |
|  Descricao / Objetivo:   Funcao que checa se ha' duplicidade de NFE devolucao.    |
|  Observacao .........:   Funcao chamado a partir do ponto de entrada MT103ok.prw  |
+==================================================================================*/
User Function MGFChkDup()
Local aArea  :=  GetArea()
Local lRet   :=  .F.

If .not. u_VlSerie()
   lRet := .T.
EndIf

Return( lRet )

/*==================================================================================+
|  Funcao de Usuario ..: VlSerie( cSerie )                                          |
|  Autor ..............: johnny.osugi@totvspartners.com.br                          |
|  Data ...............: 08/11/2018                                                 |
|  Descricao / Objetivo: Valida a variavel cSerie da rotina MATA140|MATA103.        |
|  Observacao .........: Funcao localizada no X3_VLDUSER do campo F1_ESPECIE.       |
+==================================================================================*/
User Function VlSerie()
Local   aArea    :=  GetArea()
Local   lRet     :=  .T.
Private lNum     :=  .T.

If FunName() # "U_EST01GERNF" // Funcao usada no processo de Triangulacao, mais especificamente "Automacao de Venda Transfer�ncia/Gera NFS/NFE"
   If cFormul == "N" .and. ( FunName()=="MATA140" .or. FunName()=="MATA103" )
      If ChkSF1() .and. .not. Empty( cSerie ) // Checa se existe a NF no SF1 e a variavel cSerie preenchida.
         MsgAlert( OEMToANSI( "A Nota Fiscal " + AllTrim( cNFiscal ) + " / Serie " + AllTrim( cSerie ) + " j� cadastrado no Documento de Entrada. Favor verificar." ) )
         lRet := .F.
      ElseIf .not. ChkSF1() .and. Empty( cSerie ) // Checa se existe a NF no SF1 e a variavel cSerie nao preenchida.
             /*----------------------------------------------------------------------+
             | Campo Serie (cSerie) em branco - verifica a existencia de documentos  |
             | com o mesmo fornecedor/loja e numeracao da NF (se encontrado, nao     |
             | permitir a inclusao.                                                  |
             +----------------------------------------------------------------------*/
             MsgAlert( OEMToANSI( "Numero de Nota Fiscal j� cadastrado para o mesmo Fornecedor. Favor verificar." ) )
             lRet := .F.
      EndIf
   EndIf
EndIf

RestArea( aArea )
Return( lRet )

/*==================================================================================+
|  Funcao Estatica ....: ChkSF1()                                                   |
|  Autor ..............: johnny.osugi@totvspartners.com.br                          |
|  Data ...............: 08/11/2018                                                 |
|  Descricao / Objetivo: Valida a variavel cSerie da rotina MATA140|MATA103.        |
|  Observacao .........:                                                            |
+==================================================================================*/
Static Function ChkSF1()
Local aArea    :=  GetArea()
Local cQuery   :=  ""
Local lRet     :=  .F.
Local cS_      :=  ""

/*-------------------------------------------------------------------------+
| Montagem da query para verificacao se nao ha' duplicidade no SF1/SD1     |
+-------------------------------------------------------------------------*/
cQuery  :=  "SELECT F1_FILIAL UNIDADE, F1_FORNECE CLIENTE, F1_LOJA LOJA, F1_DOC NF, F1_SERIE SERIE, F1_CHVNFE CHAVE_NFE " + ENTER
cQuery  +=  " FROM " + RetSQLName( "SF1" ) + " SF1 "                  + ENTER
cQuery  +=  " WHERE  SF1.F1_FILIAL   =   '" + xFilial( "SF1" ) + "' " + ENTER
cQuery  +=  "    AND SF1.F1_FORNECE     =   '" + cA100For        + "' " + ENTER
cQuery  +=  "    AND SF1.F1_LOJA        =   '" + cLoja           + "' " + ENTER
cQuery  +=  "    AND SF1.F1_DOC         =   '" + cNFiscal        + "' " + ENTER
cQuery  +=  "    AND SF1.F1_ESPECIE     =   '" + cEspecie        + "' " + ENTER
cQuery  +=  "    AND SF1.D_E_L_E_T_  <>  '*' "                        + ENTER

TCQuery cQuery New Alias "QRYSF1"
QRYSF1->( DbGoTop() )

If .not. QrySF1->( EoF() )
   /*---------------------------------------------------------------------------+
   | Campo Serie (cSerie) preenchido - portanto deve passar pela consistencia.  |
   +---------------------------------------------------------------------------*/
   If .not. Empty( cSerie ) // Campo Serie (cSerie) preenchido - portanto deve passar pela consistencia.
      cS_ := CnvSer( cSerie )
      Do While QRYSF1->( .not. EoF() )

         If .not. lNum
            If cS_ == CnvSer( QRYSF1->SERIE )
               lRet := .T.
               ExiT
            EndIf
         Else
            If cS_ == StrZero( Val( QRYSF1->SERIE ), 3 )
               lRet := .T.
               ExiT
            EndIf
         EndIf
         QRYSF1->( DbSkip() )
      EndDo
   Else
      /*----------------------------------------------------------------------+
      | Campo Serie (cSerie) em branco - verifica a existencia de documentos  |
      | com o mesmo fornecedor/loja e numeracao da NF (se encontrado, nao     |
      | permitir a inclusao.                                                  |
      +----------------------------------------------------------------------*/
      lRet := .F.
   EndIf
EndIf

QRYSF1->( DbCloseArea() )

RestArea( aArea )
Return( lRet )

/*==================================================================================+
|  Funcao Estatica ....: CnvSer()                                                   |
|  Autor ..............: johnny.osugi@totvspartners.com.br                          |
|  Data ...............: 08/11/2018                                                 |
|  Descricao / Objetivo:                                                            |
|  Observacao .........:                                                            |
+==================================================================================*/
Static Function CnvSer( cS )
Local aArea := GetArea()
Local cS_   := ""

/*------------------------------------------------------+
| Laco For|Next para checar se todos os caracteres sao  |
| numericos ou nao.                                     |
+------------------------------------------------------*/
For nX := 1 To Len( AllTrim( cS ) )
    If .not. IsDigit( SubStr( cS, nX, 1 ) )
       lNum := .F.
       ExiT
    EndIf
NexT

/*------------------------------------------------------+
| Caso todos os caracteres sao numericos, converte a    |
| variavel cSer_ para numerico e converte para caracter |
| para tirar os zeros 'a esquerda.                      |
+------------------------------------------------------*/
If .not. lNum 
   /*------------------------------------------------------+
   | Laco que trata os caracteres da variavel cS para obter|
   | a parte significativa da serie da NF.                 |
   | Exemplos: 0A1  -  A1                                  |
   |           0B2  -  B2                                  |
   |           01A  -  1A                                  |
   |           10A  -  10A                                 |
   +------------------------------------------------------*/
   For nX := 1 To Len( AllTrim( cS ) )
       If IsDigit( SubStr( cS, nX, 1 ) )
          If SubStr( cS, nX, 1 ) == "0" .and. cS_ == ""
             LooP
          Else
             cS_ := cS_ + SubStr( cS, nX, 1 )
          EndIf
       Else
          cS_ := cS_ + SubStr( cS, nX, 1 )
       EndIf
   NexT
Else
   cS_ := StrZero( Val( cS ), 3 )
EndIf

RestArea( aArea )
Return( AllTrim( cS_ ) )
