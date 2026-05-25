# Atividade - Trigger para impedir múltiplas atribuições

## 📚 Descrição

Esta atividade consiste na criação de uma trigger que impede que um instrutor receba mais de 2 atribuições de aulas no mesmo ano.

## 🎯 Objetivo

Criar a trigger `trigger_prevent_assignment_teaches` que:
- É acionada em operações de INSERT e UPDATE na tabela `teaches`
- Verifica se o instrutor já possui 2 ou mais atribuições no ano da nova inserção
- Bloqueia a operação e exibe mensagem de erro caso a regra seja violada

## 📝 Regra de negócio

Um instrutor **NÃO** pode ministrar mais de **2 aulas** no mesmo ano.

## 🔧 Comportamento da trigger

| Situação | Resultado |
|----------|-----------|
| Instrutor tem 0 ou 1 aula no ano | ✅ Inserção/atualização permitida |
| Instrutor já tem 2 ou mais aulas no ano | ❌ Inserção/atualização bloqueada |

## 📊 Exemplo

### Situação válida:
```sql
-- Instrutor 10101 tem 1 aula em 2024
INSERT INTO teaches VALUES ('10101', 'CS101', '1', 'Spring', 2024);
-- ✅ Funciona - agora ele tem 1 aula
```

### Situação inválida (já tem 2 aulas):
```sql
-- Instrutor 10101 já tem 2 aulas em 2024
INSERT INTO teaches VALUES ('10101', 'CS102', '2', 'Fall', 2024);
-- ❌ Erro: "Não é permitido atribuir mais de 2 aulas ao mesmo instrutor no mesmo ano!"
```

## ▶️ Como executar

1. Conecte-se ao banco de dados
2. Execute o script para criar a trigger
3. Teste com inserções válidas e inválidas

## 📁 Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `atividade_trigger.sql` | Script com a trigger e testes |

## 👩‍💻 Autora
Letícia Brondi Carvalheiro

## 📅 Data
25/05/2026
