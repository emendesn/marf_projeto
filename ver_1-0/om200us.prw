#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "FONT.CH"


User Function OM200US()

Local lMGFFIS34 := SuperGetMV('MGF_FIS34L',.T.,.F.)	//Habilita a rotina de valor do frete no pedido ou carga


	If findfunction ("U_ALTFRE")
		AADD(aRotina,{	OemtoAnsi("Alteração Tipo de Operação GFE") ,'U_ALTFRE', 0 ,4 })  
	Endif
	
	If findfunction ("U_MGFOMS02")
		AADD(aRotina,{	OemtoAnsi("Incluir Mensagem para as Notas da Carga") ,'U_MGFOMS02', 0 ,4 })  
	Endif

	If findfunction ("U_MGFOMS05")
		AADD(aRotina,{	OemtoAnsi("Incluir Mensagem para cada Nota") ,'U_MGFOMS05', 0 ,4 })  
	Endif
	
	If findfunction ("U_VLFRETE") .AND. lMGFFIS34
		AADD(aRotina,{	OemtoAnsi("Incluir valor do Frete para Carga") ,'U_VLFRETE', 0 ,4 })  
	Endif
	
	If findfunction ("U_MGFGFE50")
		AADD(aRotina,{	OemtoAnsi("Reenviar Carga para obter CTe e MDFe ") ,'U_MGFGFE50', 0 ,4 })  
	Endif

	If findfunction ("U_MGFOMS09")
		AADD(aRotina,{	OemtoAnsi("Integrar CTes e NFSe Emitidos") ,'U_MGFOMS09', 0 ,4 })  
	Endif

	If findfunction ("U_MGFOMS07")
		AADD(aRotina,{	OemtoAnsi("Origem/Destino ") ,'U_MGFOMS07', 0 ,4 })  
	Endif

	If findfunction ("U_MGFOMS08")
		AADD(aRotina,{	OemtoAnsi("Historico Origem/Destino") ,'U_MGFOMS08', 0 ,4 }) 
	EndIf		
	
	// Cancelar carga no MultiEmbarcador - Paulo da Mata - 21/01/2020
	If findfunction ("U_MGFGFE58")
		AADD(aRotina,{	OemtoAnsi("Cancelar carga no Multiembarcador") ,'U_MGFGFE58', 0 ,4 }) 
	EndIf		

Return aRotina
