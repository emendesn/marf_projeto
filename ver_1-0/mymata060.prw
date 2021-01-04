#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

User Function MyMata060()
	Local PARAMIXB1 := {}
	Local PARAMIXB2 := 3
	local cArq      :="C:\TOTVS\Clientes\Marfrig\item_fornecedor\fornec_item.txt"
	Private lMsHelpAuto     := .T.
	Private lMsErroAuto     := .F.
	Private lAutoErrNoFile  := .T.


	If (.F. );CallProc( "RpcSetEnv", "01", "020001",,, "EST",, { "SA5" } ); Else; RpcSetEnv( "01", "020001",,, "EST",, { "SA5" } ); endif







	dbSelectArea("SB1")
	DbSetOrder(1)

	dbSelectArea("SA2")
	DbSetOrder(1)

	dbSelectArea("SA5")
	DbSetOrder(1)

	SA5->(dbGoTop())
	While !SA5->(EOF())
		IF SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
			IF SA2->(dbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA))
				Reclock("SA5", .F. )
				SA5->A5_NOMEFOR := SA2->A2_NOME
				SA5->A5_NOMPROD := SB1->B1_DESC
				SA5->A5_UMNFE   := "1"
				SA5->(MsUnlock())
			EndIF
		EndIF
		SA5->(dbSkip())
	End


































	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return Nil
