from pydantic import BaseModel


class Medicamento(BaseModel):
	id: int = 0
	nome: str = ""
	classificacao_id: int = 0
	codigo_interno: str = ""
	codigo_oficial: str = ""
	uso_especifico: str = ""
	apresentacao: str = ""
	fabricante_id: int = 0
	estoque_minimo: float = 0.0
	dias_alerta_vencimento: int = 90
	ativo: bool = True
	criado_em: str = ""
