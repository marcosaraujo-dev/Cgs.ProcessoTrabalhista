# 🔢 TIPOS DE CONTRATO - PROCESSOS TRABALHISTAS
## Especificações Técnicas Individualizadas

> **Base:** Manual eSocial Web v12/03/2024 + Análise Detalhada  
> **Total:** 9 tipos de contrato mapeados  
> **Desenvolvimento:** Incremental por prioridade

---

## 📊 **VISÃO GERAL DOS TIPOS**

| Tipo | Nome | Complexidade | Prioridade | % Casos Reais | Status |
|------|------|-------------|-----------|--------------|--------|
| **1** | [Processo Trabalhista Padrão](tipo-01-vinculo-sem-alteracao.md) | 🟢 Baixa | Alta | 50% | ✅ Especificado |
| **2** | [Reconhecimento de Vínculo](tipo-02-alteracao-admissao.md) | 🟡 Média | Alta | 20% | ✅ Especificado |
| **3** | [Alteração de Desligamento](tipo-03-inclusao-desligamento.md) | 🟡 Média | Alta | 10% | ✅ Especificado |
| **4** | [Alteração ambas datas](tipo-04-alteracao-ambas-datas.md) | 🟠 Alta | Média | 8% | 📋 Base criada |
| **5** | [Reconhecimento vínculo](tipo-05-reconhecimento-vinculo.md) | 🟠 Alta | Média | 5% | 📋 Base criada |
| **6** | [TSVE sem reconhecimento](tipo-06-tsve-sem-reconhecimento.md) | 🟠 Alta | Média | 4% | 📋 Base criada |
| **7** | [Período pré-eSocial](tipo-07-periodo-pre-esocial.md) | 🔴 Muito Alta | Baixa | 2% | 📝 Estrutura |
| **8** | [Responsabilidade indireta](tipo-08-responsabilidade-indireta.md) | 🔴 Muito Alta | Baixa | 1% | 📝 Estrutura |
| **9** | [Unicidade contratual](tipo-09-unicidade-contratual.md) | 🔴 Muito Alta | Baixa | <1% | 📝 Estrutura |

**Total Cobertura Fase 1 (Tipos 1-3):** **80% dos casos reais**

---

## 🎯 **ESTRATÉGIA DE DESENVOLVIMENTO**

### **🟢 FASE 1 - DESENVOLVIMENTO IMEDIATO**
**Tipos 1, 2, 3 - Cobertura: 80% dos casos reais**

#### **🔥 TIPO 1: Processo Trabalhista Padrão** 
- **Cenário:** Processo judicial/CCP com trabalhador empregado comum
- **Complexidade:** Baixa (cadastro direto de todos os dados)
- **Interface:** Wizard padrão com todos campos manuais
- **XML:** S-2500 direto
- **Desenvolvimento:** 3 semanas

#### **🔥 TIPO 2: Reconhecimento de Vínculo**
- **Cenário:** Processo reconhece vínculo empregatício não formalizado
- **Complexidade:** Média (envolve reconhecimento retroativo)
- **Interface:** Campos específicos para reconhecimento
- **XML:** S-2500 com dados de reconhecimento
- **Desenvolvimento:** 4 semanas

#### **🔥 TIPO 3: Alteração de Desligamento**
- **Cenário:** Processo altera ou inclui data/motivo de desligamento  
- **Complexidade:** Média (validações específicas desligamento)
- **Interface:** Seção desligamento com regras especiais
- **XML:** S-2500 com informações de desligamento
- **Desenvolvimento:** 3 semanas

### **🟡 FASE 2 - DESENVOLVIMENTO FUTURO **
**Tipos 4, 5, 6 - Cenários complexos**

#### **📋 TIPO 4: Alteração Ambas Datas**
- **Cenário:** Combina tipos 2+3 (admissão + desligamento)
- **Complexidade:** Alta (múltiplas retificações coordenadas)
- **Interface:** Wizard complexo com validações cruzadas
- **XML:** Múltiplos eventos coordenados

#### **📋 TIPO 5: Reconhecimento de Vínculo**
- **Cenário:** Cria vínculo não declarado anteriormente
- **Complexidade:** Alta (gera S-2200 + S-2299 + S-2500)
- **Interface:** Cadastro completo do trabalhador + contrato
- **XML:** Triplo evento automático

#### **📋 TIPO 6: TSVE sem Reconhecimento**
- **Cenário:** Trabalhador sem vínculo, apenas tributos
- **Complexidade:** Alta (lógica TSVE + múltiplos subcenários)
- **Interface:** Wizard específico TSVE
- **XML:** S-2500 TSVE + referencias S-2300

### **🔴 FASE 3 - CASOS ESPECIAIS (conforme demanda)**
**Tipos 7, 8, 9 - Cenários raros (<3% dos casos)**

- **Desenvolvimento sob demanda** baseado em necessidade real
- **ROI analisado** caso a caso
- **Complexidade muito alta** - requer análise específica

---

## 📋 **ESTRUTURA PADRÃO DE CADA ARQUIVO**

Todos os arquivos `tipo-XX-nome.md` seguem a mesma estrutura organizacional:

```markdown
# 🔢 TIPO X: NOME DO TIPO

## 📋 VISÃO GERAL
## 🎯 PRÉ-REQUISITOS  
## 🔄 FLUXO DE TELAS ESPECÍFICO
## 📱 INTERFACE E CAMPOS ÚNICOS
## ⚙️ REGRAS DE NEGÓCIO ESPECÍFICAS
## ✅ VALIDAÇÕES OBRIGATÓRIAS
## 🧪 CENÁRIOS DE TESTE
## 🏗️ IMPACTOS TÉCNICOS
## 📊 EVENTOS XML GERADOS
## 🔗 RELACIONAMENTOS
## ✅ CRITÉRIOS DE ACEITE
## 📈 MÉTRICAS DE SUCESSO
```

---

## 🧭 **NAVEGAÇÃO RÁPIDA**

### **Por Prioridade de Desenvolvimento:**
1. **[TIPO 1](tipo-01-vinculo-sem-alteracao.md)** - Começar aqui (mais simples)
2. **[TIPO 2](tipo-02-alteracao-admissao.md)** - Segundo passo (validações temporais)
3. **[TIPO 3](tipo-03-inclusao-desligamento.md)** - Terceiro passo (múltiplos eventos)

### **Por Complexidade Técnica:**
- **🟢 Simples:** [Tipo 1](tipo-01-vinculo-sem-alteracao.md)
- **🟡 Média:** [Tipo 2](tipo-02-alteracao-admissao.md), [Tipo 3](tipo-03-inclusao-desligamento.md)
- **🟠 Alta:** [Tipo 4](tipo-04-alteracao-ambas-datas.md), [Tipo 5](tipo-05-reconhecimento-vinculo.md), [Tipo 6](tipo-06-tsve-sem-reconhecimento.md)
- **🔴 Muito Alta:** [Tipo 7](tipo-07-periodo-pre-esocial.md), [Tipo 8](tipo-08-responsabilidade-indireta.md), [Tipo 9](tipo-09-unicidade-contratual.md)

### **Por Frequência de Uso:**
- **Muito Comum (50%+):** [Tipo 1](tipo-01-vinculo-sem-alteracao.md)
- **Comum (10-20%):** [Tipo 2](tipo-02-alteracao-admissao.md), [Tipo 3](tipo-03-inclusao-desligamento.md)
- **Ocasional (5-10%):** [Tipo 4](tipo-04-alteracao-ambas-datas.md), [Tipo 5](tipo-05-reconhecimento-vinculo.md), [Tipo 6](tipo-06-tsve-sem-reconhecimento.md)
- **Raro (<5%):** [Tipo 7](tipo-07-periodo-pre-esocial.md), [Tipo 8](tipo-08-responsabilidade-indireta.md), [Tipo 9](tipo-09-unicidade-contratual.md)

---

## 🔄 **RELACIONAMENTOS ENTRE TIPOS**

### **Dependências de Desenvolvimento:**
- **Tipo 4** depende de **Tipos 2+3** (combina funcionalidades)
- **Tipo 5** independente (cria tudo do zero)
- **Tipo 6** independente (lógica TSVE específica)
- **Tipos 7-9** independentes (casos especiais isolados)

### **Componentes Compartilhados:**
- **Wizard Framework** - base para todos os tipos
- **Engine de Validações** - regras comuns + específicas
- **Factory XML** - padrão base + customizações por tipo
- **Repository Pattern** - acesso dados comum

### **Fluxos de Interface:**
- **Seleção de Tipo** - tela inicial comum para todos
- **Dados do Processo** - aba base igual para todos
- **Informações da Decisão** - aba específica por tipo
- **Consolidação de Valores** - comum com pequenas variações
- **Discriminação Mensal** - idêntica para todos

---

## 📊 **MATRIZ DE FEATURES POR TIPO**

| Feature | T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 |
|---------|----|----|----|----|----|----|----|----|----| 
| **Consulta CPF Opcional** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | ✅ |
| **Todos Campos Manuais** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 🔄 |
| **Reconhecimento Vínculo** | ❌ | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | 🔄 | ✅ |
| **Desligamento Específico** | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | 🔄 | 🔄 |
| **Validações Especiais** | ❌ | 🔄 | 🔄 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Interface Simples** | ✅ | ❌ | 🔄 | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **XML Direto S-2500** | ✅ | ✅ | ✅ | 🔄 | 🔄 | ✅ | 🔄 | 🔄 | 🔄 |

**Legenda:** ✅ Sim | ❌ Não | 🔄 Parcial/Condicional

---

## 🎯 **GUIDELINES DE DESENVOLVIMENTO**

### **Ordem de Implementação Recomendada:**
1. **Base Framework** - Wizard + Validações + Repository (2 semanas)
2. **Tipo 1** - Implementação completa (3 semanas)
3. **Tipo 2** - Adiciona funcionalidades (4 semanas)  
4. **Tipo 3** - Complementa funcionalidades (3 semanas)
5. **Refatoração** - Otimizações + testes (2 semanas)

### **Padrões de Qualidade:**
- **Documentação** atualizada antes de cada implementação
- **Testes unitários** para cada regra específica
- **Validação XML** contra XSD oficial
- **Interface** idêntica aos padrões eSocial Web

### **Critérios de Aceite Gerais:**
- ✅ **Fluxo completo** funcional do início ao fim
- ✅ **Validações específicas** do tipo implementadas
- ✅ **XML válido** gerado conforme leiaute v1.3
- ✅ **Performance** adequada (< 5s para operações)
- ✅ **Interface intuitiva** seguindo padrões estabelecidos

---

## 📚 **DOCUMENTAÇÃO RELACIONADA**

### **Análise de Negócio:**
- **[Glossário de Termos](../glossario-termos-dominio.md)** - Terminologia base
- **[Requisitos Funcionais](../requisitos-funcionais-detalhados.md)** - RF001-RF011
- **[Casos de Uso](../casos-de-uso-detalhados.md)** - UC001-UC011

### **Arquitetura Técnica:**
- **[Arquitetura do Sistema](../../02-arquitetura/arquitetura-sistema.md)** - Estrutura geral
- **[Modelo de Dados](../../02-arquitetura/modelo-dados-postgresql.md)** - PostgreSQL schema
- **[Padrões de Desenvolvimento](../../02-arquitetura/padroes-desenvolvimento.md)** - Guidelines C#

### **Validações e Testes:**
- **[Regras de Negócio](../../05-validacoes/regras-negocio-consolidadas.md)** - RN gerais
- **[Validações por Tipo](../../05-validacoes/por-tipo/)** - Regras específicas
- **[Cenários de Teste](../../05-validacoes/cenarios-teste/)** - Casos por tipo

---

## 📈 **ROADMAP DE ATUALIZAÇÕES**

### **Próximas Iterações:**
- **v1.0** - Tipos 1-3 implementados e testados
- **v1.1** - Otimizações baseadas no uso real  
- **v2.0** - Tipos 4-6 implementados
- **v2.1** - Funcionalidades avançadas (S-2555, S-3500)
- **v3.0** - Tipos 7-9 (se demanda justificar)

### **Melhorias Contínuas:**
- **Performance** - otimizações baseadas em métricas reais
- **Usabilidade** - ajustes baseados em feedback dos usuários
- **Conformidade** - atualizações conforme mudanças eSocial
- **Integração** - melhorias na conexão com sistema base

---

**📋 Documento:** README Tipos de Contrato v1.0  
**📅 Data:** Agosto 2025  
**🎯 Status:** Índice organizacional completo - pronto para desenvolvimento incremental