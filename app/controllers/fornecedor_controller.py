from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from typing import Optional

from app.models.fornecedor import Base, Fornecedor

# Configuração do banco de dados
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/IBSAUDE"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Criar tabelas
Base.metadata.create_all(bind=engine)

# Criar router
router = APIRouter(prefix="/api/fornecedores", tags=["fornecedores"])


def get_db():
    """Dependência para obter sessão do banco de dados"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Schemas simples para requisições
class FornecedorCreate:
    def __init__(self, nome: str, cnpj: str, telefone: Optional[str] = None, email: Optional[str] = None, endereco: Optional[str] = None):
        self.nome = nome
        self.cnpj = cnpj
        self.telefone = telefone
        self.email = email
        self.endereco = endereco


class FornecedorUpdate:
    def __init__(self, nome: Optional[str] = None, telefone: Optional[str] = None, email: Optional[str] = None, endereco: Optional[str] = None, ativo: Optional[bool] = None):
        self.nome = nome
        self.telefone = telefone
        self.email = email
        self.endereco = endereco
        self.ativo = ativo


# ROTAS CRUD


@router.post("/", response_model=dict)
def criar_fornecedor(fornecedor_data: dict, db: Session = Depends(get_db)):
    """Criar novo fornecedor"""
    fornecedor_existente = db.query(Fornecedor).filter(Fornecedor.cnpj == fornecedor_data["cnpj"]).first()
    if fornecedor_existente:
        raise HTTPException(status_code=400, detail="CNPJ já cadastrado")

    novo_fornecedor = Fornecedor(
        nome=fornecedor_data.get("nome"),
        cnpj=fornecedor_data.get("cnpj"),
        telefone=fornecedor_data.get("telefone"),
        email=fornecedor_data.get("email"),
        endereco=fornecedor_data.get("endereco")
    )

    db.add(novo_fornecedor)
    db.commit()
    db.refresh(novo_fornecedor)

    return {
        "id": novo_fornecedor.id,
        "nome": novo_fornecedor.nome,
        "cnpj": novo_fornecedor.cnpj,
        "telefone": novo_fornecedor.telefone,
        "email": novo_fornecedor.email,
        "endereco": novo_fornecedor.endereco,
        "ativo": novo_fornecedor.ativo,
        "data_criacao": novo_fornecedor.data_criacao
    }


@router.get("/")
def listar_fornecedores(db: Session = Depends(get_db)):
    """Listar todos os fornecedores"""
    fornecedores = db.query(Fornecedor).all()
    return [
        {
            "id": f.id,
            "nome": f.nome,
            "cnpj": f.cnpj,
            "telefone": f.telefone,
            "email": f.email,
            "endereco": f.endereco,
            "ativo": f.ativo,
            "data_criacao": f.data_criacao
        }
        for f in fornecedores
    ]


@router.get("/{fornecedor_id}")
def obter_fornecedor(fornecedor_id: int, db: Session = Depends(get_db)):
    """Obter fornecedor por ID"""
    fornecedor = db.query(Fornecedor).filter(Fornecedor.id == fornecedor_id).first()
    if not fornecedor:
        raise HTTPException(status_code=404, detail="Fornecedor não encontrado")

    return {
        "id": fornecedor.id,
        "nome": fornecedor.nome,
        "cnpj": fornecedor.cnpj,
        "telefone": fornecedor.telefone,
        "email": fornecedor.email,
        "endereco": fornecedor.endereco,
        "ativo": fornecedor.ativo,
        "data_criacao": fornecedor.data_criacao,
        "data_atualizacao": fornecedor.data_atualizacao
    }


@router.put("/{fornecedor_id}")
def atualizar_fornecedor(fornecedor_id: int, fornecedor_data: dict, db: Session = Depends(get_db)):
    """Atualizar fornecedor"""
    fornecedor = db.query(Fornecedor).filter(Fornecedor.id == fornecedor_id).first()
    if not fornecedor:
        raise HTTPException(status_code=404, detail="Fornecedor não encontrado")

    if "nome" in fornecedor_data:
        fornecedor.nome = fornecedor_data["nome"]
    if "telefone" in fornecedor_data:
        fornecedor.telefone = fornecedor_data["telefone"]
    if "email" in fornecedor_data:
        fornecedor.email = fornecedor_data["email"]
    if "endereco" in fornecedor_data:
        fornecedor.endereco = fornecedor_data["endereco"]
    if "ativo" in fornecedor_data:
        fornecedor.ativo = fornecedor_data["ativo"]

    fornecedor.data_atualizacao = datetime.utcnow()

    db.commit()
    db.refresh(fornecedor)

    return {
        "id": fornecedor.id,
        "nome": fornecedor.nome,
        "cnpj": fornecedor.cnpj,
        "telefone": fornecedor.telefone,
        "email": fornecedor.email,
        "endereco": fornecedor.endereco,
        "ativo": fornecedor.ativo,
        "data_atualizacao": fornecedor.data_atualizacao
    }


@router.delete("/{fornecedor_id}")
def deletar_fornecedor(fornecedor_id: int, db: Session = Depends(get_db)):
    """Deletar fornecedor"""
    fornecedor = db.query(Fornecedor).filter(Fornecedor.id == fornecedor_id).first()
    if not fornecedor:
        raise HTTPException(status_code=404, detail="Fornecedor não encontrado")

    db.delete(fornecedor)
    db.commit()

    return {"mensagem": f"Fornecedor {fornecedor_id} deletado com sucesso"}
