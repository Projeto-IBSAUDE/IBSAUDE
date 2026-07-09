from sqlalchemy import create_engine, text


#usar env ao invés do hardcode
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/IBSAUDE"
engine = create_engine(DATABASE_URL)


with open('install.sql') as arquivo:
    installSQl = arquivo.read()


with open('data.sql') as arquivo:
    dataSQL = arquivo.read()


with engine.begin() as conexao:
    conexao.execute(text('drop schema public; create schema public;'))
    conexao.execute(text(installSQl))
    conexao.execute(text(dataSQL))
