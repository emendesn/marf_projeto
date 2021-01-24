#define ENCH_COL1SAY        (2)    /* coordenada X do say da primeira coluna */
#define ENCH_COL1GET        (38)   /* coordenada X do get da primeira coluna 42 */
#define ENCH_COL2SAY        (157)  /* coordenada X do say da segunda coluna  157 */
#define ENCH_COL2GET        (193)  /* coordenada X do get da segunda coluna  197 */

// Atenção: o valor abaixo tem que corresponder a:
// ENCH_COL2SAY - ENCH_COL1GET - ENCH_FOLGAESQUERDA
#define ENCH_TAM1GET        (113)
#define ENCH_TAM2GET        (113)

#ifdef SPANISH
	#define STR0001 "Otros"
	#define STR0002 "Imagen..."
#else
	#ifdef ENGLISH
		#define STR0001 "Others"
		#define STR0002 "Image..."
	#else
		#define STR0001 "Outros"
		#define STR0002 "Imagem..."
	#endif
#endif