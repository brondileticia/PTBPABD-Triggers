-- ============================================================================
-- ATIVIDADE DE BANCO DE DADOS - TRIGGER
-- Disciplina: Programação e Administração de Banco de Dados
-- Autor: [SEU NOME]
-- Data: [DATA ATUAL]
-- ============================================================================

USE NomeDoSeuBanco;
GO

-- ============================================================================
-- QUESTÃO 01: Criar trigger para impedir mais de 2 atribuições por ano
-- ============================================================================
--
-- DESCRIÇÃO: Impede que um instrutor receba mais de 2 atribuições de aulas
--            no mesmo ano. Se um instrutor já tiver 2 ou mais registros na
--            tabela teaches no ano da nova inserção, a trigger cancela a
--            operação e exibe uma mensagem de erro.
--
-- TABELA AFETADA: teaches (INSERT e UPDATE)
-- ============================================================================

CREATE TRIGGER trigger_prevent_assignment_teaches
ON teaches
AFTER INSERT, UPDATE
AS
BEGIN
    -- Declara variáveis para controle de erro
    DECLARE @ErroMensagem NVARCHAR(200);
    DECLARE @ErroSeveridade INT = 16;
    DECLARE @ErroEstado INT = 1;
    
    -- Verifica se há alguma inserção ou atualização que resulte em
    -- um instrutor com mais de 2 atribuições no ano
    IF EXISTS (
        SELECT 
            t.ID,
            t.year,
            COUNT(*) AS total_aulas
        FROM teaches t
        INNER JOIN inserted i ON t.ID = i.ID AND t.year = i.year
        GROUP BY t.ID, t.year
        HAVING COUNT(*) > 2
    )
    BEGIN
        -- Mensagem de erro informando a violação
        SET @ErroMensagem = 'Não é permitido atribuir mais de 2 aulas ao mesmo instrutor no mesmo ano!';
        
        -- Cancela a operação (INSERT ou UPDATE) e exibe erro
        RAISERROR(@ErroMensagem, @ErroSeveridade, @ErroEstado);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ============================================================================
-- TESTES DA TRIGGER (execute os blocos separadamente)
-- ============================================================================

-- ============================================================================
-- TESTE 1: Verificar situação atual do instrutor (opcional)
-- ============================================================================
SELECT ID, year, COUNT(*) AS total_aulas
FROM teaches
GROUP BY ID, year
ORDER BY ID, year;
GO

-- ============================================================================
-- TESTE 2: Inserção válida (menos de 2 atribuições no ano)
-- ============================================================================
-- Supondo que o instrutor 10101 ainda não tenha 2 aulas em 2024
-- INSERT INTO teaches VALUES ('10101', 'CS101', '1', 'Spring', 2024);
-- Deve funcionar normalmente
-- GO

-- ============================================================================
-- TESTE 3: Inserção inválida (já tem 2 ou mais atribuições no ano)
-- ============================================================================
-- Se o instrutor já tiver 2 aulas em 2024, esta inserção será bloqueada
-- INSERT INTO teaches VALUES ('10101', 'CS102', '2', 'Fall', 2024);
-- Deve gerar erro: "Não é permitido atribuir mais de 2 aulas ao mesmo instrutor no mesmo ano!"
-- GO

-- ============================================================================
-- TESTE 4: Update inválido (tentando mudar para um ano com muitas atribuições)
-- ============================================================================
-- UPDATE teaches SET year = 2024 WHERE ID = '10101' AND course_id = 'CS201';
-- Se o instrutor já tiver 2 aulas em 2024, esta atualização será bloqueada
-- GO
