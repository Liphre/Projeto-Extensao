-- CRIANDO BANCO DE DADOS
CREATE DATABASE sistema_escola;

-- ACESSAR O BANCO DE DADOS sistema_escola
USE sistema_escola;

-- CRIAR TABELAS

CREATE TABLE pais_cadastrados(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_P VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(100) NOT NULL,  
    telefone CHAR(11),            
    senha VARCHAR(50) NOT NULL,
    cpf CHAR(11) NOT NULL,
    sexo ENUM('Masculino', 'Feminino') NOT NULL,        
    CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'),
    CHECK (cpf REGEXP '^[0-9]{11}$'),
    CHECK (telefone REGEXP '^[0-9]{11}$'),
    UNIQUE (email, telefone, cpf)
);


CREATE TABLE alunos ( 
 id INT PRIMARY KEY AUTO_INCREMENT,  
 nome_A VARCHAR(100) NOT NULL,  
 data_nascimento DATE NOT NULL,  
 cpf CHAR(11) NOT NULL,  
 sexo ENUM('Masculino', 'Feminino') NOT NULL,
 CHECK (cpf REGEXP '^[0-9]{11}$'),
 UNIQUE (cpf)
); 

CREATE TABLE turmas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    serie VARCHAR(20) NOT NULL
);

CREATE TABLE filhos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pai INT NOT NULL,
    id_alunos INT NOT NULL,
    FOREIGN KEY (id_pai) REFERENCES pais_cadastrados(id),  
    FOREIGN KEY (id_alunos) REFERENCES alunos(id)  
);


CREATE TABLE alunos_turmas(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_alunos INT NOT NULL,
    id_turmas INT NOT NULL, 
    FOREIGN KEY (id_alunos) REFERENCES alunos(id),  
    FOREIGN KEY (id_turmas) REFERENCES turmas(id) 
);


CREATE TABLE materias(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_M VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE materias_turmas(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_materias INT NOT NULL,
    id_turmas INT NOT NULL,
    FOREIGN KEY (id_materias) REFERENCES materias(id),
    FOREIGN KEY (id_turmas)   REFERENCES turmas(id)
);

CREATE TABLE calendario(
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_evento DATE NOT NULL,
    evento VARCHAR(50) NOT NULL
);


CREATE TABLE calendario_turmas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_calendario INT NOT NULL,
    id_turmas INT NOT NULL,
    FOREIGN KEY (id_calendario) REFERENCES calendario(id),
    FOREIGN KEY (id_turmas) REFERENCES turmas(id)
);

CREATE TABLE horario ( 
 id INT PRIMARY KEY AUTO_INCREMENT,  
 horario_aula ENUM('07:15', '08:30','09:30','09:45','10:45') NOT NULL,  
 id_turmas INT NOT NULL,  
 dia_semana ENUM('Segunda-Feira', 'Terça-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira') NOT NULL,  
 id_materias INT NOT NULL,  
 FOREIGN KEY (id_turmas) REFERENCES turmas(id),
 FOREIGN KEY (id_materias) REFERENCES materias(id)
); 


-- INSERÇÃO TABELA pais_cadastrados
INSERT INTO pais_cadastrados (nome_P, data_nascimento, email, telefone, senha, cpf)
VALUES  ('João Silva',      '1980-05-15', 'joao.silva@example.com',     '11987654321', 'senha123', '12345678901'), 
        ('Layene Rodrigues',  '1975-10-30', 'layene@linda.com', '21987654321', 'senha456', '10987654321');

-- INSERÇÃO TABELA alunos
INSERT INTO alunos (nome_A, data_nascimento, cpf, sexo)
VALUES  ('Evangeline Barbosa Silva',     '2007-01-01', '12345678901', 'Feminino'),
        ('Julia Martins',   '2005-12-10', '11223344556', 'Feminino');

-- INSERÇÃO TABELA filhos
INSERT INTO filhos (id_pai, id_alunos)
VALUES  (1, 2),
        (2, 1);

-- INSERÇÃO TABELA turma
INSERT INTO turmas (serie)
VALUES  ('1º Ano'),
        ('2º Ano'),
        ('3º Ano'),
        ('4º Ano');

-- INSERÇÃO TABLE alunos_tumas
INSERT INTO alunos_turmas (id_alunos, id_turmas) VALUES (1,1);
INSERT INTO alunos_turmas (id_alunos, id_turmas) VALUES (2,2);

-- INSERÇÃO MATERIAS
insert into materias (nome_M) values ('ciencias');
insert into materias (nome_M) values ('matematica');
insert into materias (nome_M) values ('portugues');
insert into materias (nome_M) values ('geografia');
insert into materias (nome_M) values ('intervalo');

-- INSERÇÃO DE MATERIAS NAS TURMAS
insert into materias_turmas (id_materias, id_turmas) values (1, 1);
insert into materias_turmas (id_materias, id_turmas) values (2, 1);
insert into materias_turmas (id_materias, id_turmas) values (3, 1);
insert into materias_turmas (id_materias, id_turmas) values (4, 1);
insert into materias_turmas (id_materias, id_turmas) values (5, 1);

insert into materias_turmas (id_materias, id_turmas) values (1, 2);
insert into materias_turmas (id_materias, id_turmas) values (2, 2);
insert into materias_turmas (id_materias, id_turmas) values (3, 2);
insert into materias_turmas (id_materias, id_turmas) values (4, 2);
insert into materias_turmas (id_materias, id_turmas) values (5, 2);

-- INSERÇÃO DE TABELA calendario
INSERT INTO calendario (data_evento, evento) VALUES
('2024-10-15', 'Prova de Matemática - 1º Bimestre'),
('2024-11-10', 'Prova de Portugues - 1º Bimestre'),
('2024-12-05', 'Prova de Ciências - 1º Bimestre');


-- INSERÇÃO A TABELA calendario_turmas
INSERT INTO calendario_turmas (id_calendario, id_turmas) values (1,1);
INSERT INTO calendario_turmas (id_calendario, id_turmas) values (2,1);
INSERT INTO calendario_turmas (id_calendario, id_turmas) values (3,2);
INSERT INTO calendario_turmas (id_calendario, id_turmas) values (2,2);
INSERT INTO calendario_turmas (id_calendario, id_turmas) values (1,2);

-- INSERÇÃO A TABELA horarios

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 1, 'Segunda-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 2, 'Segunda-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 5, 'Segunda-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 3, 'Segunda-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 4, 'Segunda-Feira','10:45');

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 3, 'Terça-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 1, 'Terça-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 5, 'Terça-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 4, 'Terça-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 2, 'Terça-Feira','10:45');

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 2, 'Quarta-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 4, 'Quarta-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 5, 'Quarta-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 1, 'Quarta-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (1, 3, 'Quarta-Feira','10:45');

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 3, 'Segunda-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 2, 'Segunda-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 5, 'Segunda-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 1, 'Segunda-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 4, 'Segunda-Feira','10:45');

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 4, 'Terça-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 1, 'Terça-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 5, 'Terça-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 2, 'Terça-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 3, 'Terça-Feira','10:45');

INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 3, 'Quarta-Feira','07:15');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 3, 'Quarta-Feira','08:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 5, 'Quarta-Feira','09:30');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 1, 'Quarta-Feira','09:45');
INSERT INTO horario(id_turmas, id_materias,dia_semana, horario_aula) VALUES (2, 1, 'Quarta-Feira','10:45');


-- retornar calendario
SELECT DATE_FORMAT(C.data_evento, '%d/%m/%Y') AS "Data", 
       C.evento AS Evento
FROM calendario C
JOIN calendario_turmas CT ON C.id = CT.id_calendario
JOIN turmas T ON CT.id_turmas = T.id
JOIN alunos_turmas A_T ON T.id = A_T.id_turmas
JOIN alunos A ON A_T.id_alunos = A.id
WHERE A.id = %s
ORDER BY Data DESC;

SELECT
    horario_aula AS 'horario',
    MAX(CASE WHEN H.dia_semana = 'Segunda-Feira' THEN M.nome_M END) AS 'Segunda-Feira',
    MAX(CASE WHEN H.dia_semana = 'Terça-Feira'   THEN M.nome_M END) AS 'Terça-Feira'  ,
    MAX(CASE WHEN H.dia_semana = 'Quarta-Feira'  THEN M.nome_M END) AS 'Quarta-Feira'
FROM
    horario H
JOIN 
    materias M       ON H.id_materias = M.id
JOIN
    turmas T         ON H.id_turmas   = T.id
JOIN
    alunos_turmas AL ON T.id          = AL.id_turmas
JOIN
    alunos A         ON AL.id_alunos  = A.id
WHERE a.id = 1
GROUP BY
    horario_aula
ORDER BY
    FIELD(horario_aula, '07:15', '08:30', '09:30', '09:45', '10:45');


--CRIANDO A TABELA BOLETIM
CREATE TABLE boletim (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_materias_turmas INT NOT NULL,
    id_alunos INT NOT NULL,
    periodo_letivo VARCHAR(11) NOT NULL,
    nota_prova1 DECIMAL(4,2),
    nota_prova2 DECIMAL(4,2),
    nota_trabalho DECIMAL(4,2),
    FOREIGN KEY (id_alunos) REFERENCES alunos(id),
    FOREIGN KEY (id_materias_turmas) REFERENCES materias_turmas(id),
    UNIQUE (id_alunos, id_materias_turmas, periodo_letivo)
);

--INSERINDO DADOS A TABELA BOLETIM
INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (1, 1, '1º Semestre', 8.50, 7.75, 8.00);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (2, 1, '1º Semestre', 9.00, 8.25, 7.50);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (3, 1, '1º Semestre', 7.25, 7.50, 8.25);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (3, 1, '2º Semestre', 3.25, 9.50, 10.00);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (1, 2, '1º Semestre', 7.50, 8.00, 8.50);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (2, 2, '1º Semestre', 8.25, 7.75, 8.00);

INSERT INTO boletim (id_materias_turmas, id_alunos, periodo_letivo, nota_prova1, nota_prova2, nota_trabalho)
VALUES (3, 2, '1º Semestre', 7.00, 8.25, 7.75);


-- comando
SELECT B.periodo_letivo, M.nome_M, B.nota_prova1, B.nota_prova2, B.nota_trabalho, ROUND((B.nota_prova1 + B.nota_prova2 + B.nota_trabalho)/3.0, 2) AS nota_final
FROM boletim B 
JOIN materias_turmas MT ON MT.id = B.id_materias_turmas
JOIN materias M         ON M.id  = MT.id_materias 
JOIN alunos   A         ON A.id  = B.id_alunos
WHERE A.id = 1
ORDER BY B.periodo_letivo;