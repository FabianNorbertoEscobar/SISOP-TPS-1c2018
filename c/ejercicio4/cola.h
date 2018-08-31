#ifndef NEWQUEUE_QUEUE_H
#define NEWQUEUE_QUEUE_H
#define TAM 3
typedef struct {
    int nro_pregunta,op_correcta;
    char pregunta[200],opciones[200];
}t_dato;

typedef struct s_nodo{
    t_dato dato;
    struct s_nodo *psig;
}t_nodo;
typedef struct {
    t_nodo *fte,*fdo;
}t_cola;

void crear_cola(t_cola * pc);
int poner_en_cola(t_cola * pc,const t_dato* cd);
int sacar_de_cola(t_cola * pc,t_dato * cd);
int frente_cola(const t_cola * pc,t_dato * cd);
int cola_llena(const t_cola * pc);
int cola_vacia(const t_cola * pc);
void vaciar_cola(t_cola * pc);

#endif //NEWQUEUE_QUEUE_H
