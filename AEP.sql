--1) Elabore um exercício em PL/SQL com declaração de variável que mostre os números de 1 a 100 quais são múltiplos do quarto digito do seu RA, bem como a soma e a quantidade de todos os múltiplos.
use db_API
DECLARE @ra int;
DECLARE @soma int;
DECLARE @qtde int;
DECLARE @quarto varchar(50)
declare @cont int

set @cont = 1
set @ra = '222642052';
set @soma = 0
set @qtde = 0
set @quarto = (select substring(@ra, 4, 1));

while @cont <= 100
begin

if (@cont%@quarto)=0 BEGIN
	select @cont, 'multiplos'
set @soma = @soma+@cont
set @qtde += 1
end
set @cont +=1
END

select 'A soma e:', @soma, 'a quantidade e: ', @qtde
-------------------------------------------------------------


--2) Crie um exercício em PL/SQL com declaração de variável que mostre a soma de todos os números de seu RA.

declare @ra VARCHAR(9), @soma int, @count int

set @ra = '222642052'
set @count = 1
set @soma = 0

while  @count <= LEN(@ra)
BEGIN
	set @soma += cast(SUBSTRING(@ra, @count ,1) as int)
	
	set @count +=  1
END

select @soma as 'SOMA'
--------------------------------------------------------------


--3) Construa um exercício em PL/SQL com declaração de variável que mostre a partir dos dois últimos dígitos do seu RA e mostre se acima de 50 mostre maior que meu RA senão mostrar abaixo do meu RA.

declare @ra VARCHAR(9), @ultimos int

set @ra = '222642052'
set @ultimos = CAST(RIGHT(@ra,2) as int)

if @ultimos > 50 BEGIN
	print 'Maior que 50'
END

else if @ultimos < 50 BEGIN
	print 'Menor que 50'
END

else 
print 'Igual a 50'
---------------------------------------------------------------

--4) Desenvolva um script em PL/SQL que mostre o mês por extenso a partir do quinto digito do seu RA (usar case) caso seja zero mostrar mês não existe.

declare @ra varchar(9), @ultimos int

set @ra = '222642052'
set @ultimos = (select SUBSTRING (@ra, 5, 1))

select @ultimos as Mes,

case

when @ultimos = 0 then 'Mes nao existe'
when @ultimos = 1 then 'Janeiro'
when @ultimos = 2 then 'Fevereiro'
when @ultimos = 3 then 'Março'
when @ultimos = 4 then 'Abril'
when @ultimos = 5 then 'Maio'
when @ultimos = 6 then 'Junho'
when @ultimos = 7 then 'Julho'
when @ultimos = 8 then 'Agosto'
when @ultimos = 9 then 'Setembro'
when @ultimos = 10 then 'Outubro'
when @ultimos = 11 then 'Novembro'
when @ultimos = 12 then 'Dezembro'

END as 'Meses'
--------------------------------------------------


--5) Relacione todas as tabelas cliente, produto, transportadora e liste todos os campos em uma stored procedure.

create table CLIENTE
(CODIGO int primary key,
NOME varchar(50),
ICMS int,
FK_cliente_produto int foreign key references produto (CODIGO),
FK_cliente_transportadora int foreign key references transportadora (CODIGO)
);

INSERT INTO CLIENTE values(5050, 'MASTER CORP', 15, 48, 34)
INSERT INTO CLIENTE values(5067, 'IBM DO BRASIL', 16, 49, 35)


create table PRODUTO
(CODIGO int primary key,
NOME varchar(50),
VALOR numeric(7,2),
IPI int
);

INSERT INTO PRODUTO values(48, 'MONITOR', 895.00, 10)
INSERT INTO PRODUTO values(49, 'HD SSD', 425.00, 15)


create table TRANSPORTADORA
(CODIGO int primary key,
NOME varchar(50),
COFINS int,
EMAIL varchar(50)
);

INSERT INTO TRANSPORTADORA values(34, 'TRANSNORTE', 5, '')
INSERT INTO TRANSPORTADORA values(35, 'TRANSPAULA', 7, '')


create or alter procedure sp_relacionamento
as

select * from CLIENTE cli
inner join PRODUTO pro
on cli.FK_cliente_produto = pro.CODIGO
inner join TRANSPORTADORA tra
on cli.FK_cliente_transportadora = tra.CODIGO

execute sp_relacionamento
----------------------------------------------------------------


--6) Crie um script em PL/SQL que liste a partir da stored procedure qual o valor do ICMS, regra: VALOR do produto * ICMS do cliente.

create or alter procedure sp_Liste
as

select pro.VALOR * cli.ICMS from CLIENTE cli
inner join PRODUTO pro
on cli.FK_cliente_produto = pro.CODIGO

execute sp_Liste
----------------------------------------------------------------


--7) Elabore uma procedure que atualize a tabela transportadora o campo email, conforme regra: nome do cliente + nome do produto+ @ + nome da transportadora +.com.br.

create or alter procedure sp_Atualize
as

update TRANSPORTADORA set EMAIL = TRIM(cli.nome) + TRIM(pro.nome) + '@' + TRIM(tra.nome) + '.com.br'
from TRANSPORTADORA tra
inner join CLIENTE cli
on cli.FK_cliente_transportadora = tra.CODIGO
inner join PRODUTO pro
on cli.FK_cliente_produto = pro.CODIGO

execute sp_Atualize
---------------------------------------------------------------


--8) Desenvolva uma procedure com declaração de variáveis que liste o produto com maior valor e mostre o campo nome de todas as tabelas e o valor do IPI (VALOR do produto * IPI), valor do ICMS (VALOR do produto * ICMS) e valor do Cofins (VALOR do produto * Cofins).

create or alter procedure sp_MaiorValor
as

declare @valorMaior int

set @valorMaior = (select MAX(valor) from PRODUTO)

select cli.nome, (pro.valor * pro.IPI) as 'valor do IPI', (cli.ICMS * pro.valor) as 'valor do ICMS', (pro.valor * tra.cofins) as 'valor do Cofins' from CLIENTE cli
inner join PRODUTO pro
on cli.FK_cliente_produto = pro.CODIGO
inner join TRANSPORTADORA tra
on cli.FK_cliente_transportadora = tra.CODIGO

execute sp_MaiorValor
-------------------------------------------------------------


--9) Elabore um script em PL/SQL que mostre por parâmetro do código do cliente e aplique 10% de aumento no valor do produto de 500,00 caso seja menor aplique 15%. Após atualize a tabela produto com o novo valor.


create or alter procedure sp_Aumento
@codigo int
as


update PRODUTO set VALOR = IIF(@codigo > 500, pro.valor * 1.15, pro.valor * 1.10)  from PRODUTO pro
inner join CLIENTE cli
on cli.FK_cliente_produto = pro.CODIGO


execute sp_Aumento @codigo = 5067
------------------------------------------------------------


--10) Crie um script em PL/SQL com declaração de variáveis que mostre a partir da nota 1 (sendo
--o seu primeiro digito do RA) e a nota 2 (sendo o último digito do seu RA), mostrar a media
--(nota1+nota2)/2 caso a média foi menor que 4 mostrar reprovado, maior ou igual a 6 aprovado
--senão em recuperação. 

declare @ra varchar(9), @nota1 int, @nota2 int, @media float

set @ra = '222642052'
set @nota1 = LEFT(@ra,1)
set @nota2 = RIGHT(@ra,1)
set @media = (@nota1 + @nota2)/2

if(@media < 4) begin
	select @media, 'Reprovado'
end

else if(@media >= 6) begin
	select @media, 'Aproado'
end

else
	select @media, 'Recuperacao'


