from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from typing import List, Optional

from app.models.usuario import Base, Usuario

# Configuração do banco de dados
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/IBSAUDE"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Criar tabelas
Base.metadata.create_all(bind=engine)

# Criar router
router = APIRouter(prefix="/api/usuarios", tags=["usuarios"])


def get_db():
    """Dependência para obter sessão do banco de dados"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Schema para requisições (Pydantic)
class UsuarioCreate:
    def __init__(self, nome: str, email: str, cpf: str, senha: str):
        self.nome = nome
        self.email = email
        self.cpf = cpf
        self.senha = senha


class UsuarioUpdate:
    def __init__(self, nome: Optional[str] = None, email: Optional[str] = None, ativo: Optional[bool] = None):
        self.nome = nome
        self.email = email
        self.ativo = ativo


# ROTAS CRUD

@router.post("/", response_model=dict)
def criar_usuario(usuario_data: dict, db: Session = Depends(get_db)):
    """Criar novo usuário"""
    # Verificar se email já existe
    usuario_existente = db.query(Usuario).filter(Usuario.email == usuario_data["email"]).first()
    if usuario_existente:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Verificar se CPF já existe
    cpf_existente = db.query(Usuario).filter(Usuario.cpf == usuario_data["cpf"]).first()
    if cpf_existente:
        raise HTTPException(status_code=400, detail="CPF já cadastrado")
    
    # Criar novo usuário
    novo_usuario = Usuario(
        nome=usuario_data["nome"],
        email=usuario_data["email"],
        cpf=usuario_data["cpf"],
        senha=usuario_data["senha"]
    )
    
    db.add(novo_usuario)
    db.commit()
    db.refresh(novo_usuario)
    
    return {
        "id": novo_usuario.id,
        "nome": novo_usuario.nome,
        "email": novo_usuario.email,
        "cpf": novo_usuario.cpf,
        "ativo": novo_usuario.ativo,
        "data_criacao": novo_usuario.data_criacao
    }


@router.get("/")
def listar_usuarios(db: Session = Depends(get_db)):
    """Listar todos os usuários"""
    usuarios = db.query(Usuario).all()
    return [
        {
            "id": u.id,
            "nome": u.nome,
            "email": u.email,
            "cpf": u.cpf,
            "ativo": u.ativo,
            "data_criacao": u.data_criacao
        }
        for u in usuarios
    ]


@router.get("/{usuario_id}")
def obter_usuario(usuario_id: int, db: Session = Depends(get_db)):
    """Obter usuário por ID"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    return {
        "id": usuario.id,
        "nome": usuario.nome,
        "email": usuario.email,
        "cpf": usuario.cpf,
        "ativo": usuario.ativo,
        "data_criacao": usuario.data_criacao,
        "data_atualizacao": usuario.data_atualizacao
    }


@router.put("/{usuario_id}")
def atualizar_usuario(usuario_id: int, usuario_data: dict, db: Session = Depends(get_db)):
    """Atualizar usuário"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    # Atualizar campos se fornecidos
    if "nome" in usuario_data:
        usuario.nome = usuario_data["nome"]
    if "email" in usuario_data:
        usuario.email = usuario_data["email"]
    if "ativo" in usuario_data:
        usuario.ativo = usuario_data["ativo"]
    
    usuario.data_atualizacao = datetime.utcnow()
    
    db.commit()
    db.refresh(usuario)
    
    return {
        "id": usuario.id,
        "nome": usuario.nome,
        "email": usuario.email,
        "cpf": usuario.cpf,
        "ativo": usuario.ativo,
        "data_atualizacao": usuario.data_atualizacao
    }


@router.delete("/{usuario_id}")
def deletar_usuario(usuario_id: int, db: Session = Depends(get_db)):
    """Deletar usuário"""
    usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
    
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    db.delete(usuario)
    db.commit()
    
    return {"mensagem": f"Usuário {usuario_id} deletado com sucesso"}
