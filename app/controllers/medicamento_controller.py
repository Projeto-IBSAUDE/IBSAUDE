from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from typing import List, Optional

from app.models.medicamento import Base, Medicamento

# Configuração do banco de dados
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/IBSAUDE"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Criar tabelas
Base.metadata.create_all(bind=engine)

# Criar router
router = APIRouter(prefix="/api/medicamentos", tags=["medicamentos"])


def get_db():
	"""Dependência para obter sessão do banco de dados"""
	db = SessionLocal()
	try:
		yield db
	finally:
		db.close()


# Schemas simples para requisições
class MedicamentoCreate:
	def __init__(self, nome: str, descricao: Optional[str] = None, fabricante: Optional[str] = None, preco: Optional[float] = None, quantidade: Optional[int] = 0):
		self.nome = nome
		self.descricao = descricao
		self.fabricante = fabricante
		self.preco = preco
		self.quantidade = quantidade


class MedicamentoUpdate:
	def __init__(self, nome: Optional[str] = None, descricao: Optional[str] = None, fabricante: Optional[str] = None, preco: Optional[float] = None, quantidade: Optional[int] = None, ativo: Optional[bool] = None):
		self.nome = nome
		self.descricao = descricao
		self.fabricante = fabricante
		self.preco = preco
		self.quantidade = quantidade
		self.ativo = ativo


# ROTAS CRUD


@router.post("/", response_model=dict)
def criar_medicamento(med_data: dict, db: Session = Depends(get_db)):
	"""Criar novo medicamento"""
	novo = Medicamento(
		nome=med_data.get("nome"),
		descricao=med_data.get("descricao"),
		fabricante=med_data.get("fabricante"),
		preco=med_data.get("preco"),
		quantidade=med_data.get("quantidade", 0)
	)

	db.add(novo)
	db.commit()
	db.refresh(novo)

	return {
		"id": novo.id,
		"nome": novo.nome,
		"descricao": novo.descricao,
		"fabricante": novo.fabricante,
		"preco": novo.preco,
		"quantidade": novo.quantidade,
		"ativo": novo.ativo,
		"data_criacao": novo.data_criacao
	}


@router.get("/")
def listar_medicamentos(db: Session = Depends(get_db)):
	"""Listar todos os medicamentos"""
	meds = db.query(Medicamento).all()
	return [
		{
			"id": m.id,
			"nome": m.nome,
			"descricao": m.descricao,
			"fabricante": m.fabricante,
			"preco": m.preco,
			"quantidade": m.quantidade,
			"ativo": m.ativo,
			"data_criacao": m.data_criacao
		}
		for m in meds
	]


@router.get("/{medicamento_id}")
def obter_medicamento(medicamento_id: int, db: Session = Depends(get_db)):
	"""Obter medicamento por ID"""
	med = db.query(Medicamento).filter(Medicamento.id == medicamento_id).first()
	if not med:
		raise HTTPException(status_code=404, detail="Medicamento não encontrado")

	return {
		"id": med.id,
		"nome": med.nome,
		"descricao": med.descricao,
		"fabricante": med.fabricante,
		"preco": med.preco,
		"quantidade": med.quantidade,
		"ativo": med.ativo,
		"data_criacao": med.data_criacao,
		"data_atualizacao": med.data_atualizacao
	}


@router.put("/{medicamento_id}")
def atualizar_medicamento(medicamento_id: int, med_data: dict, db: Session = Depends(get_db)):
	"""Atualizar medicamento"""
	med = db.query(Medicamento).filter(Medicamento.id == medicamento_id).first()
	if not med:
		raise HTTPException(status_code=404, detail="Medicamento não encontrado")

	if "nome" in med_data:
		med.nome = med_data["nome"]
	if "descricao" in med_data:
		med.descricao = med_data["descricao"]
	if "fabricante" in med_data:
		med.fabricante = med_data["fabricante"]
	if "preco" in med_data:
		med.preco = med_data["preco"]
	if "quantidade" in med_data:
		med.quantidade = med_data["quantidade"]
	if "ativo" in med_data:
		med.ativo = med_data["ativo"]

	med.data_atualizacao = datetime.utcnow()

	db.commit()
	db.refresh(med)

	return {
		"id": med.id,
		"nome": med.nome,
		"descricao": med.descricao,
		"fabricante": med.fabricante,
		"preco": med.preco,
		"quantidade": med.quantidade,
		"ativo": med.ativo,
		"data_atualizacao": med.data_atualizacao
	}


@router.delete("/{medicamento_id}")
def deletar_medicamento(medicamento_id: int, db: Session = Depends(get_db)):
	"""Deletar medicamento"""
	med = db.query(Medicamento).filter(Medicamento.id == medicamento_id).first()
	if not med:
		raise HTTPException(status_code=404, detail="Medicamento não encontrado")

	db.delete(med)
	db.commit()

	return {"mensagem": f"Medicamento {medicamento_id} deletado com sucesso"}
