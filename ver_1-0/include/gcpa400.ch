#ifdef SPANISH
	#define STR0001 "El valor reservado no puede ser inferior al valor pedido"
	#define STR0002 "Valor reservado: "
	#define STR0003 "Valor pedido: "
	#define STR0004 "El valor pedido no puede ser superior al valor reservado"
	#define STR0005 "El valor consumido no puede ser superior al valor pedido"
	#define STR0006 "Valor consumido: "
	#define STR0007 "El valor liquidado no puede ser superior al valor consumido"
	#define STR0008 "Valor liquidado: "
#else
	#ifdef ENGLISH
		#define STR0001 "Allocated value cannot be lower than ordered value"
		#define STR0002 "Allocated Value: "
		#define STR0003 "Ordered Value   : "
		#define STR0004 "Ordered value cannot be greater than the allocated value"
		#define STR0005 "Value consumed cannot be greater than the ordered value"
		#define STR0006 "Value Consumed: "
		#define STR0007 "Value settled cannot be greater than the consumed value"
		#define STR0008 "Net Value: "
	#else
		#define STR0001 "O valor empenhado não pode ser menor do que o valor pedido"
		#define STR0002 "Valor Empenhado: "
		#define STR0003 "Valor Pedido   : "
		#define STR0004 "O valor pedido não pode ser maior do que o valor empenhado"
		#define STR0005 "O valor consumido não pode ser maior do que o valor pedido"
		#define STR0006 "Valor Consumido: "
		#define STR0007 "O valor liquidado não pode ser maior do que o valor consumido"
		#define STR0008 "Valor Liquidado: "
	#endif
#endif
