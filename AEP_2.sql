--1) Criar uma tabela produto com os campos codigo, nome, UF, cidade, valor, percentual 
--ICMS e percentual de IPI, inserir 5 registros na tabela e mostrar com uso de cursor todos 
--os produtos da UF SP, PR, SC o nome o valor e os percentuais de ICMS e IPI, bem como 
--os respectivos valores (valor multiplicado pelo percentual de ICMS e IPI). No final 
--apresentar o valor total dos produtos e os valores totais de ICMS e IPI.

create database db_AEPII
use db_AEPII

create table Produto(
CODIGO int primary key,
NOME varchar(50),
UF varchar(2),
CIDADE varchar(50),
VALOR float,
PERCENTUAL_ICMS int,
PERCENTUAL_IPI int
)
select * from Produto
insert into Produto values (1, 'Produto A', 'SP', 'São Paulo', 10.50, 18, 5)
insert into Produto values (2, 'Produto B', 'MT', 'Cuiaba', 15.75, 12, 2)
insert into Produto values (3, 'Produto C', 'SP', 'Campinas', 20.00, 18, 5)
insert into Produto values (4, 'Produto D', 'SC', 'Florianópolis', 12.30, 10, 2)
insert into Produto values (5, 'Produto E', 'PR', 'Londrina', 8.90, 12, 6)


declare produto_cursor CURSOR FOR
select codigo, nome, uf, cidade, valor, percentual_icms, percentual_ipi from Produto 
where UF in ('SP', 'PR', 'SC')

OPEN produto_cursor;
DECLARE @codigo int
DECLARE @nome VARCHAR(50)
DECLARE @uf VARCHAR(2)
DECLARE @cidade VARCHAR(50)
DECLARE @valor numeric(10, 2)
DECLARE @percentual_ICMS numeric(10, 2)
DECLARE @percentual_IPI numeric(10, 2)
DECLARE @valor_ICMS numeric(10, 2)
DECLARE @valor_IPI numeric(10, 2)
DECLARE @valorTotal NUMERIC(10, 2);
DECLARE @valorTotalICMS NUMERIC(10, 2);
DECLARE @valorTotalIPI NUMERIC(10, 2);
FETCH NEXT FROM produto_cursor into @codigo, @nome, @uf, @cidade, @valor, @percentual_icms, @percentual_ipi

while @@FETCH_STATUS = 0
BEGIN
	set @valorTotal = 0
	set @valorTotalICMS = 0
	set @valorTotalIPI = 0

	set @valor_ICMS = @valor * (@percentual_icms/100)
	set @valor_IPI = @valor * (@percentual_ipi / 100)
	set @valorTotal = @valorTotal + @valor
	set @valorTotalICMS = @valorTotalICMS + @valor_ICMS
	set @valorTotalIPI = @valorTotalIPI + @valor_IPI

	PRINT 'Nome: ' + @NOME
	PRINT 'Valor: ' + cast(@valor as varchar(10))
	PRINT 'Percentual de ICMS: ' + cast(@percentual_icms as varchar)
	PRINT 'Percentual de IPI: ' + cast(@percentual_ipi as varchar)
	PRINT 'valor multiplicado pelo percentual de ICMS: ' + cast(@valor_icms as varchar(10))
	PRINT 'valor multiplicado pelo percentual de IPI: ' + cast(@valor_ipi as varchar(10))
	PRINT '------------------------------------------------'


FETCH NEXT FROM produto_cursor INTO @codigo, @nome, @uf, @cidade, @valor, @percentual_ICMS, @percentual_IPI;
END
	
	print'Valor total dos produtos: ' + cast(@valorTotal as varchar)
	print'Valor total de ICMS: ' + cast(@valorTotalICMS as varchar)
	print 'valor total de IPI: ' + cast(@valorTotalIPI as varchar)

close produto_cursor
deallocate produto_cursor


--2) Criar uma tabela aluno com os campos codigo, nome, sexo, UF, cidade, nota1, nota2,
--curso, mensalidade inserir 5 registros na tabela e mostrar com uso de cursor quantos alunos
--são de cada curso e quantos são mulheres e homens, bem como o valor total das
--mensalidades dos alunos por curso. Para os alunos que tem média acima 8 conceder um
--desconto de 10% na mensalidade.

CREATE TABLE alunoAEP (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100),
    sexo CHAR(1),
    UF CHAR(2),
    cidade VARCHAR(100),
    nota1 DECIMAL(4,2),
    nota2 DECIMAL(4,2),
    curso VARCHAR(50),
    mensalidade DECIMAL(8,2)
);

-- Inserir registros na tabela aluno
INSERT INTO alunoAEP (codigo, nome, sexo, UF, cidade, nota1, nota2, curso, mensalidade)
VALUES
    (1, 'João', 'M', 'SP', 'São Paulo', 7.5, 8.0, 'Engenharia', 1500.00),
    (2, 'Maria', 'F', 'RJ', 'Rio de Janeiro', 9.0, 8.5, 'Medicina', 2000.00),
    (3, 'Pedro', 'M', 'RS', 'Porto Alegre', 6.0, 7.5, 'Direito', 1200.00),
    (4, 'Ana', 'F', 'SP', 'São Paulo', 8.5, 9.0, 'Engenharia', 1800.00),
    (5, 'Carlos', 'M', 'MG', 'Belo Horizonte', 7.0, 8.0, 'Administração', 1000.00);



DECLARE curso_cursor CURSOR FOR
    SELECT curso
    FROM alunoAEP;

OPEN curso_cursor;

DECLARE @curso VARCHAR(50);
DECLARE @alunosCurso INT;
DECLARE @homens INT;
DECLARE @mulheres INT;
DECLARE @mensalidadeTotal DECIMAL(10,2);


FETCH NEXT FROM curso_cursor INTO @curso;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT
        @alunosCurso = COUNT(*) FROM alunoAEP WHERE curso = @curso;
    SELECT
        @homens = COUNT(*) FROM alunoAEP WHERE curso = @curso AND sexo = 'M';
    SELECT
        @mulheres = COUNT(*) FROM alunoAEP WHERE curso = @curso AND sexo = 'F';
    SELECT
        @mensalidadeTotal = SUM(mensalidade) FROM alunoAEP WHERE curso = @curso;

	IF @curso IN ('Engenharia', 'Medicina', 'Direito', 'Administração')
    BEGIN
        UPDATE alunoAEP
        SET mensalidade = mensalidade * 0.9 -- Aplica o desconto de 10% na mensalidade
        WHERE codigo IN (
            SELECT codigo
            FROM alunoAEP
            WHERE curso = @curso AND ((nota1 + nota2) / 2) > 8
        );
    END;
	

    PRINT 'Curso: ' + @curso;
    PRINT 'Total de alunos: ' + CAST(@alunosCurso AS VARCHAR);
    PRINT 'Homens: ' + CAST(@homens AS VARCHAR);
    PRINT 'Mulheres: ' + CAST(@mulheres AS VARCHAR);
    PRINT 'Valor total das mensalidades: R$ ' + CAST(@mensalidadeTotal AS VARCHAR);
	PRINT '------------------------------------------'

    FETCH NEXT FROM curso_cursor INTO @curso;
END;

CLOSE curso_cursor;
DEALLOCATE curso_cursor;




--3) A partir das tabelas departamento e funcionário faça o relacionamento e desenvolva 
--usando cursor em programa em SQL que mostre o nome do funcionário, departamento, 
--salário total, valor de FGTS e Valor do INSS, no final apresentar o total geral do salário, do 
--FGTS e INSS, apenas dos departamentos 3 e 2, cuja a quantidade de horas seja maior que 
--200 e menor que 360 e o mês referente a data seja 2 e 4 apenas.

create table Funcionario(
CODIGO int primary key,
NOME varchar(50),
SALARIO numeric(10,2),
FGTS int,
INSS int
)

insert into Funcionario values(10, 'MARCONDES', 3850.45, 8, 12)
insert into Funcionario values(20, 'MARCIA LUZ', 4800.00, 5, 10)

create table Departamento(
CODIGO int primary key,
NOME varchar(50),
QTDE_HORAS int,
DATAA date,
CodFun int FOREIGN KEY  REFERENCES Funcionario(CODIGO)
)

insert into Departamento values(2, 'Financeiro', 220, '2023-04-28', 10)
insert into Departamento values(3, 'Qualidade', 260, '2023-02-23', 20)




DECLARE departamento_cursor CURSOR FOR
  SELECT f.NOME, d.NOME, f.SALARIO, f.FGTS, f.INSS
  FROM Departamento d
  INNER JOIN Funcionario f ON d.CodFun = f.CODIGO
  WHERE d.QTDE_HORAS > 200 AND d.QTDE_HORAS < 360 AND MONTH(d.DATAA) IN (2, 4) AND d.CODIGO IN (2, 3);

OPEN departamento_cursor;

DECLARE @nome_funcionario VARCHAR(50);
DECLARE @nome_departamento VARCHAR(50);
DECLARE @salario_total NUMERIC(10, 2);
DECLARE @valor_fgts NUMERIC(10, 2);
DECLARE @valor_inss NUMERIC(10, 2);
DECLARE @total_salario NUMERIC(10, 2);
DECLARE @total_fgts NUMERIC(10, 2);
DECLARE @total_inss NUMERIC(10, 2);

SET @total_salario = 0;
SET @total_fgts = 0;
SET @total_inss = 0;

FETCH NEXT FROM departamento_cursor INTO @nome_funcionario, @nome_departamento, @salario_total, @valor_fgts, @valor_inss;

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT 'Nome do Funcionário: ' + @nome_funcionario;
  PRINT 'Departamento: ' + @nome_departamento;
  PRINT 'Salário Total: ' + CAST(@salario_total AS VARCHAR(10));
  PRINT 'Valor FGTS: ' + CAST(@valor_fgts AS VARCHAR(10));
  PRINT 'Valor INSS: ' + CAST(@valor_inss AS VARCHAR(10));
  PRINT '';

  SET @total_salario = @total_salario + @salario_total;
  SET @total_fgts = @total_fgts + @valor_fgts;
  SET @total_inss = @total_inss + @valor_inss;

  FETCH NEXT FROM departamento_cursor INTO @nome_funcionario, @nome_departamento, @salario_total, @valor_fgts, @valor_inss;
END;

PRINT 'Total Geral do Salário: ' + CAST(@total_salario AS VARCHAR(10));
PRINT 'Total Geral do FGTS: ' + CAST(@total_fgts AS VARCHAR(10));
PRINT 'Total Geral do INSS: ' + CAST(@total_inss AS VARCHAR(10));

CLOSE departamento_cursor;
DEALLOCATE departamento_cursor;





--4) Fazer uma alteração a partir das tabelas departamento e funcionário faça o 
--relacionamento e desenvolva usando cursor em programa em SQL que altere o valor do 
--salário do funcionário para salário + valor de FGTS + Valor do INSS, apenas dos 
--departamentos ímpar, onde o dia referente a data do departamento seja maior que 10 e 
--menor de 30.




DECLARE funcionario_cursor CURSOR FOR
  SELECT f.CODIGO, (f.SALARIO + f.FGTS + f.INSS) AS NovoSalario
  FROM Departamento d
  INNER JOIN Funcionario f 
  ON d.CodFun = f.CODIGO
  WHERE d.CODIGO % 2 = 1 AND DAY(d.DATAA) > 10 AND DAY(d.DATAA) < 30;


OPEN funcionario_cursor;

DECLARE @cod_funcionario INT;
DECLARE @novo_salario NUMERIC(10, 2);

FETCH NEXT FROM funcionario_cursor INTO @cod_funcionario, @novo_salario;

WHILE @@FETCH_STATUS = 0
BEGIN

  UPDATE Funcionario
  SET SALARIO = @novo_salario
  WHERE CODIGO = @cod_funcionario;

  FETCH NEXT FROM funcionario_cursor INTO @cod_funcionario, @novo_salario;
END;

CLOSE funcionario_cursor;
DEALLOCATE funcionario_cursor;



---------------------------------

--5) Fazer uma exclusão a partir das tabelas departamento e funcionário faça o 
--relacionamento e desenvolva usando cursor em programa em SQL que exclua os 
--departamentos onde os funcionários tem salário maior que 4000 e menor de 6000 e o 
--departamento seja diferente de compras e RH



DECLARE departamento_cursor CURSOR FOR
  SELECT d.CODIGO
  FROM Departamento d
  INNER JOIN Funcionario f ON d.CodFun = f.CODIGO
  WHERE f.SALARIO > 4000 AND f.SALARIO < 6000 AND d.NOME NOT IN ('Compras', 'RH');


OPEN departamento_cursor;
DECLARE @cod_departamento INT;

FETCH NEXT FROM departamento_cursor INTO @cod_departamento;

WHILE @@FETCH_STATUS = 0
BEGIN
  DELETE FROM Departamento
  WHERE CODIGO = @cod_departamento;

  FETCH NEXT FROM departamento_cursor INTO @cod_departamento;
END;

CLOSE departamento_cursor;
DEALLOCATE departamento_cursor;
