CREATE DATABASE easyServerMonitoramento;
USE easyServerMonitoramento;

CREATE TABLE Empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    cnpj CHAR(18) NOT NULL UNIQUE,
    senha VARCHAR (45) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    contato VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    endereco VARCHAR(45) NOT NULL,
    cep CHAR(8),
    dtCriacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Funcionario (
	idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
	fkEmpresa INT NOT NULL,
    CONSTRAINT fkEmpresaFuncionario FOREIGN KEY (fkEmpresa)	
		REFERENCES Empresa(idEmpresa),
	senha VARCHAR(45) NOT NULL,
	nome VARCHAR(45) NOT NULL,
	email VARCHAR(45) NOT NULL,
	cargo VARCHAR(45),
	dtCriacao DATETIME DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE Lugar (
	idLugar INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR (60) NOT NULL,
	tipo VARCHAR (45) NOT NULL,
	descricaoLugar VARCHAR(200),
	fkEmpresa INT NOT NULL,
	CONSTRAINT fkEmpresaLugar FOREIGN KEY (fkEmpresa)	
		REFERENCES Empresa(idEmpresa)
);

CREATE TABLE Sensor (
    idSensor INT AUTO_INCREMENT PRIMARY KEY,
    fkEmpresa INT NOT NULL,
    CONSTRAINT fkEmpresaSensor FOREIGN KEY (fkEmpresa)	
		REFERENCES Empresa(idEmpresa),
	fkLugar INT NOT NULL,
    CONSTRAINT fkLugarSensor FOREIGN KEY (fkLugar)
		REFERENCES Lugar(idLugar),
	modeloSensor VARCHAR(5),
		CONSTRAINT chkModelo CHECK (modeloSensor IN('DHT11', 'LM35')),
    statusSensor VARCHAR(30) DEFAULT 'Pendente',
    CONSTRAINT ckSensor CHECK( statusSensor IN ('Ativo', 'Inativo', 'Pendente', 'Em manutenção')),
    dtInstalacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Medicoes (
    idMedicao INT AUTO_INCREMENT PRIMARY KEY,
    fkSensor INT NOT NULL,
    CONSTRAINT fkSensorMedicoes  FOREIGN KEY (fkSensor)
		REFERENCES Sensor(idSensor),
	fkEmpresa INT NOT NULL,
    CONSTRAINT fkEmpresaMedicoes FOREIGN KEY (fkEmpresa)	
		REFERENCES Empresa(idEmpresa),
    valor DECIMAL(5,2) NOT NULL,
    unidadeDeMedida VARCHAR (15) NOT NULL,
   dtMedicao DATETIME DEFAULT CURRENT_TIMESTAMP
);


SELECT * FROM Funcionario;
-- INSERTS 
INSERT INTO Empresa (cnpj, senha, nome, contato, email, endereco, cep)
VALUES ('12.789.678/0025-90', 'SENHA321', 'ADUBE AZURE', 'AMANDA MARTINES', 'ADUBE.AZURE@GMAIL.COM.BR', 'AV. FRADIQUE COUTINHO, 1000 - SÃO PAULO', 78923546),
	  ('12.345.678/0001-90', 'SENHA123', 'TECH CORP SOLUTIONS', 'JOÃO SILVA', 'ALERTA@TECHCORP.COM.BR', 'AV. PAULISTA, 1000 - SÃO PAULO', 05688266);

INSERT INTO Funcionario (fkEmpresa, senha, nome, email, cargo)
VALUES (2, 'SENHA56988', 'MARIA MOREIRA', 'MARIA.AZURE@GMAIL.COM.BR', 'GESTORA DE PROJETOS'),
(1, 'SENHA12256', 'CARLOS ALMEIDA', 'CARLOS@TECHCORP.COM.BR', 'GERENTE DE TI');

INSERT INTO Lugar (nome, tipo, descricaoLugar, fkEmpresa)
VALUES ('Sala UPS', 'Energia', 'Sala com destribuição elétrica', 2),
('Corredor Frio', 'Climatização', 'Área de entrada e saída de ar refrigerdo', 2),
('Rack B1', 'Rack', 'Rack com banco de dados ', 1),
('Rack 01', 'Rack', 'Rack principal com servidores', 1);


INSERT INTO Sensor (modeloSensor, fkEmpresa,  fkLugar, statusSensor, dtInstalacao)
VALUES ('DHT11', 1, 1, 'Inativo', '2026-08-14'),
('DHT11',1,2,'Ativo', '2024-02-13'),
('LM35', 2, 3, 'Em Manutenção', default),
('DHT11', 2, 3, 'Ativo', default),
('DHT11', 2, 4, 'Pendente', default);


INSERT INTO Medicoes (fkSensor, fkEmpresa, valor, unidadeDeMedida, dtMedicao)
VALUES (1, 1, 27.5, 'celsius', default ),
	(1, 1, 77.10 , 'porcentagem', default),
    (2, 1, 15.2, 'celsius', default),
    (2, 1, 38, 'porcentagem', default),
    (3, 2, 22.3, 'celsius', default),
    (4, 2, 15.9, 'celsius', default),
    (4, 2, 55, 'porcentagem', default);
    
-- SELECT 
SELECT empresa.nome AS 'Nome Da Empresa', 
lugar.nome AS 'Local do Sensor', 
descricaoLugar AS 'Descrição do Local', 
modeloSensor AS 'Modelo Do Sensor', 
statusSensor AS 'Status Do Sensor', 
valor AS 'Valor Da Medida', 
unidadeDeMedida AS 'Unidade De Medida' 
FROM Empresa JOIN Lugar ON idEmpresa = fkEmpresa 
JOIN Sensor ON idLugar = fkLugar 
JOIN Medicoes ON idSensor = fkSensor;

SELECT CASE 
	WHEN valor >= 27 THEN 'Perigo - Temperatura Alta'
    WHEN valor <= 18 THEN 'Perigo - Temperatura Baixa'
END AS 'Valor de Medida',
empresa.nome AS 'Nome Da Empresa',
lugar.nome AS 'Local do Sensor',
descricaoLugar AS 'Descrição do Local', 
unidadeDeMedida AS 'Unidade De Medida'
FROM Empresa JOIN Lugar ON idEmpresa = fkEmpresa 
JOIN Sensor ON idLugar = fkLugar 
JOIN Medicoes ON idSensor = fkSensor;
 
