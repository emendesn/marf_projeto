#include "rwmake.ch"
#include "topconn.ch"             
#INCLUDE "PROTHEUS.CH"
#DEFINE LQBR CHR(13)+CHR(10)

/*
=====================================================================================
Programa.:              M460FIM
Autor....:              Luis Artuso / Mauricio Gresele / Atilio / Flavio
Data.....:              05/10/2016
Descricao / Objetivo:   Chamada do P.E. M460FIM
Doc. Origem:            GAP VEN05 / FAT19 / CPA998 / CRE29
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function M460FIM()

	If FindFunction("U_MGFFIN82")
		U_MGFFIN82()
	Endif      

	//Natanael Filho - FUNRURAL - Devolucao de compra
	If FindFunction("U_MGFFINA2")
		//Verifica se � uma devolucao de compras e se houve o calculo do FUNDESA
		If SF2->F2_TIPO = 'D' .AND. (SF2->F2_CONTSOC > 0 .OR. SF2->F2_VLSENAR > 0)
			U_MGFFINA2(1) // 1 - Inclusao; 2 - Exclusao
		EndIf
	Endif

	If FindFunction("U_MGFGCT04") // VEN05
		U_MGFGCT04()
	Endif
	
	// marca itens nao entregues como residuo
	If FindFunction("U_MGFFAT11") // FAT19
		U_MGFFAT11()
	Endif
	
	
	If FindFunction("U_MGFFIN04") // CPA998
		U_MGFFIN04()
	Endif
	If FindFunction("U_CRE2901") // CRE29
		U_CRE2901()
	Endif 
	If FindFunction("U_MGFINT32")
		U_MGFINT32()
	Endif 

	If FindFunction("U_MGFEEC31")
		U_MGFEEC31()
	Endif
	//RAMI
	If FindFunction("U_MGFCRM47")
		U_MGFCRM47()
	Endif         
	//Copia do Peso Bruto na nota Fiscal com valor do Pedido de venda
	If FindFunction("U_MGFFAT71")
		U_MGFFAT71()
	Endif   

	If FindFunction("U_MGFFAT78")
		U_MGFFAT78()
	Endif
	
	// gravacao de campo de peso bruto - GFE
	If FindFunction("U_MGFFAT88")
		U_MGFFAT88()
	Endif

	If FindFunction("U_MGFFAT91")
		U_MGFFAT91()
	Endif

	If FindFunction("U_MGFFATAG")
		U_MGFFATAG()
	Endif
	
	/* PAULO HENRIQUE - TOTVS - 19/08/2019
	CHAMADA DE FUNCAO PARA ATUALIZA��O DA TABELA CDG, QUNADO HOUVER A INCLUSAO DAS TAGS nProc E indProc
	*/
	If FindFunction("U_MGFFATB5")
		U_MGFFATB5()
	Endif

	// Atualiza cidade de divisa em Trechos do itiner�rio GWU para os pedidos de Exportacao
	If FindFunction("U_MGFFATBK")
		If SF2->F2_EST = "EX" //Verifica se � Exportacao
			U_MGFFATBK()
		EndIf 
	Endif

	//Na emissao de venda interestadual com um dos grupos tribut�rios listados na 
	//rotina MGFFATBL, carregar� os dados do fornecedor, natureza, centro de custo 
	//e conta contabil p/ criar titulo a pagar de ICMS pr�prio (F2_VALICM calculado) 
	If FindFunction("U_MGFFATBN")
		If SF2->F2_VALICM > 0 //ICMS calculado
			U_MGFFATBN()
		EndIf 
	Endif	

Return()