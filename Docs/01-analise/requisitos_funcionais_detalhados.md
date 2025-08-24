# 📋 REQUISITOS FUNCIONAIS DETALHADOS
## Sistema eSocial - Processo Trabalhista

> **Projeto:** Sistema de Gestão de Processos Trabalhistas eSocial  
> **Versão:** 1.0  
> **Data:** Agosto 2025  
> **Base:** Manual eSocial Web + Análise de Arquivos + Documentação Senior

---

## 🎯 **VISÃO GERAL DO SISTEMA**

### **Objetivo**
Desenvolver sistema desktop para cadastro, validação e geração de eventos eSocial relacionados a processos trabalhistas (S-2500, S-2501, S-2555, S-3500), seguindo rigorosamente os padrões estabelecidos no eSocial Web oficial.

### **Escopo da Fase 1**
- Cadastro completo de Processos Trabalhistas (S-2500)
- Cadastro de Tributos Decorrentes (S-2501)
- Geração e validação de XMLs
- Interface idêntica aos padrões eSocial Web

### **Escopo da Fase 2** (Futuro)
- Consolidação de Tributos (S-2555)
- Exclusão de Eventos (S-3500)
- Funcionalidades avançadas de relatórios

---

## 📱 **RF001 - INTERFACE PRINCIPAL E NAVEGAÇÃO**

### **RF001.1 - Tela Inicial de Processos**
**Descrição:** Tela principal para visualização e gestão de processos trabalhistas

**Funcionalidades:**
- Lista de processos com colunas: Número Processo, CPF Trabalhador, Empresa, Status, Data Criação
- Filtros de busca:
  - Por número do processo
  - Por CPF do trabalhador  
  - Por CNPJ da empresa
  - Por status do processo
  - Por período de criação
- Controle de acesso por empresa (baseado na autenticação do sistema base)
- Paginação para listas grandes
- Botões de ação: Novo, Editar, Visualizar, Excluir, Gerar XML

**Critérios de Aceite:**
- ✅ Deve carregar apenas processos das empresas autorizadas para o usuário
- ✅ Filtros devem funcionar em tempo real
- ✅ Double-click no processo abre para edição
- ✅ Status deve ser visualmente diferenciado (cores/ícones)

### **RF001.2 - Integração com Sistema Base**
**Descrição:** Aproveitamento da autenticação e controle de acesso do sistema existente

**Funcionalidades:**
- Utiliza autenticação do sistema base (sem login próprio)
- Herda permissões de empresa do sistema principal
- Mantém contexto do usuário logado
- Log de ações integrado ao sistema base

---

## 🧙‍♂️ **RF002 - WIZARD DE CADASTRO DE PROCESSO (S-2500)**

### **RF002.1 - Estrutura de Navegação**
**Descrição:** Interface wizard com abas e etapas sequenciais

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ [Dados do Processo] [Informações da Decisão ou Acordo] │
├─────────────────────────────────────────────────────────┤
│ ○ 1              ○ 2                                   │
│ Etapa Atual      Próxima Etapa                         │
│                                                         │
│ [Conteúdo da Etapa]                                     │
│                                                         │
│ [Cancelar]  [Anterior]  [Próximo]  [Salvar]            │
└─────────────────────────────────────────────────────────┘
```

**Funcionalidades:**
- Progress indicator com círculos numerados
- Navegação entre abas somente após validação
- Breadcrumb visual das etapas
- Salvamento automático por etapa
- Validação em tempo real

### **RF002.2 - Aba "Dados do Processo"**

#### **RF002.2.1 - Etapa 1: Informações Básicas**
**Campos Obrigatórios:**
- Número do Processo (validação de formato)
- Tipo de Origem (Judicial/CCP/Ninter)
- Data da Sentença/Acordo
- CNPJ/CPF do Empregador (com validação)

**Campos Condicionais:**
- Se Origem = "Judicial": UF da Vara, Código do Município
- Se Origem = "CCP/Ninter": Data da CCP, Tipo de CCP

**Validações:**
- Número processo: formato específico (20 dígitos para judicial)
- CNPJ: 14 dígitos + algoritmo de validação
- CPF: 11 dígitos + algoritmo de validação
- Data sentença: não pode ser futura

#### **RF002.2.2 - Etapa 2: Dados do Empregador**
**Campos:**
- Razão Social (autocomplete baseado no CNPJ)
- Tipo de Inscrição (CNPJ/CPF/CAEPF)
- Número de Inscrição
- Checkbox "Empregador Doméstico"

**Funcionalidades:**
- Integração com base externa para busca automática
- Se empregador doméstico: CAEPF = 9 dígitos CPF + 00000
- Validação específica por tipo de inscrição

#### **RF002.2.3 - Etapa 3: Responsável (Opcional)**
**Campos:**
- Nome do Responsável
- CPF do Responsável  
- Contatos (telefone, email)

### **RF002.3 - Aba "Informações da Decisão ou Acordo"**

#### **RF002.3.1 - Etapa 1: Informações do Contrato**
**Funcionalidades:**
- Dropdown "Selecionar um tipo de contrato" (8 opções)
- Campos dinâmicos baseados no tipo selecionado
- Seções condicionais por tipo de trabalhador

**Campos Base:**
- Categoria do Trabalhador (dropdown com tabela de categorias)
- Matrícula (validação: não pode conter 'eSocial')
- Data de Admissão Original (date picker)
- CBO (autocomplete com 6 dígitos)
- Natureza da Atividade (radio: Urbano/Rural)
- Tipo de Regime Trabalhista
- Tipo de Regime Previdenciário
- Data de Admissão (se alterada)

**Seção "Informações de Desligamento"** (condicional):
- Data de Desligamento
- Código do Motivo de Desligamento
- Data Projetada para Término do API

**Validações Especiais:**
- Se Categoria = 104 (doméstico): Natureza = Urbano (automático)
- Se Categoria = 102 (rural): Natureza = Rural (automático)
- Data admissão deve ser posterior ao nascimento

#### **RF002.3.2 - Etapa 2: Consolidação dos Valores**
**Seção "Estabelecimento Pagador":**
- Tipo de Inscrição (CNPJ/CPF/CAEPF)
- Número de Inscrição (validação por tipo)

**Seção "Período do Processo":**
- Início do Processo (mês/ano: MM/YYYY)
- Fim do Processo (mês/ano: MM/YYYY)
- Repercussão do Processo Trabalhista (dropdown)

**Checkboxes:**
- ☐ Indicativo de indenização substitutiva do seguro-desemprego
- ☐ Indicativo de indenização substitutiva de abono salarial

**Validação Especial:**
- Empregador doméstico: deve usar CAEPF automaticamente

#### **RF002.3.3 - Etapa 3: Discriminação das Bases de Cálculo**
**Funcionalidades:**
- Grid mensal gerado automaticamente baseado no período
- Colunas: Competência (YYYY-MM), Base CP, Base FGTS, Observações
- Botões: "+Incluir Competência", "Remover Selecionado"
- Totalizadores automáticos por coluna
- Validação de valores (não negativos)

**Grid Layout:**
```
┌────────────┬──────────────┬──────────────┬─────────────┐
│ Competência│ Base CP (R$) │ Base FGTS(R$)│ Observações │
├────────────┼──────────────┼──────────────┼─────────────┤
│ 2024-01    │ 1.500,00     │ 1.500,00     │             │
│ 2024-02    │ 1.500,00     │ 1.500,00     │             │
│ ...        │ ...          │ ...          │ ...         │
├────────────┼──────────────┼──────────────┼─────────────┤
│ TOTAL      │ 15.000,00    │ 15.000,00    │             │
└────────────┴──────────────┴──────────────┴─────────────┘
```

---

## 👥 **RF003 - GESTÃO DE TRABALHADORES**

### **RF003.1 - Busca de Trabalhador por CPF**
**Descrição:** Sistema de busca e vinculação de trabalhadores ao processo

**Funcionalidades:**
- Campo de busca CPF com máscara (000.000.000-00)
- Validação algoritmo CPF em tempo real
- Integração com base externa para consulta
- Popup de resultado da busca

**Cenários:**
1. **CPF encontrado:** Preenche dados automaticamente (Nome, Data Nascimento)
2. **CPF não encontrado:** Exibe popup "Cadastrar trabalhador manualmente"
3. **Erro na consulta:** Permite cadastro manual com alerta

### **RF003.2 - Cadastro Manual de Trabalhador**
**Campos:**
- CPF (obrigatório, 11 dígitos)
- Nome Completo (obrigatório, máximo 70 caracteres)
- Data de Nascimento (obrigatório)

**Validações:**
- CPF único no sistema
- Nome sem caracteres especiais
- Data nascimento coerente (não futura, não muito antiga)

### **RF003.3 - Múltiplos Trabalhadores por Processo**
**Funcionalidades:**
- Lista de trabalhadores vinculados ao processo
- Botão "Adicionar Trabalhador" 
- Cada trabalhador gera um evento S-2500 independente
- Status individual por trabalhador
- Sequencial automático (ideSeqProc)

---

## ✅ **RF004 - SISTEMA DE VALIDAÇÕES**

### **RF004.1 - Validações em Tempo Real**
**Tipos:**
- **Formato:** CPF, CNPJ, datas, números
- **Obrigatório:** Campos marcados como required
- **Consistência:** Datas lógicas, valores não negativos
- **Domínio:** Valores válidos em dropdowns

**Feedback Visual:**
- ✅ Verde: Campo válido
- ❌ Vermelho: Campo inválido com mensagem
- ⚠️ Amarelo: Campo com alerta/sugestão

### **RF004.2 - Validações por Tipo de Contrato**
**Regras Dinâmicas:**
- Campos obrigatórios variam por tipo
- Seções condicionais aparecem/desaparecem
- Validações cruzadas específicas

**Exemplos:**
- Tipo 1: Data desligamento não obrigatória
- Tipo 3: Data desligamento obrigatória
- Tipo 5: Seção "Reconhecimento de Vínculo" obrigatória

### **RF004.3 - Validação Final Pré-Transmissão**
**Funcionalidades:**
- Checklist visual de validações
- Relatório de inconsistências
- Bloqueio de transmissão se houver erros
- Sugestões de correção

**Tela de Validação:**
```
┌─── VALIDAÇÃO FINAL ───┐
│ ✅ Dados básicos      │
│ ✅ Trabalhadores      │
│ ❌ Bases de cálculo   │
│   └─ Competência     │
│      2024-03 zerada  │
│ ⚠️  Alertas (2)       │
│                       │
│ [Corrigir] [Ignorar]  │
└───────────────────────┘
```

---

## 💰 **RF005 - CADASTRO DE TRIBUTOS (S-2501)**

### **RF005.1 - Seleção de Processo Base**
**Funcionalidades:**
- Lista de processos S-2500 transmitidos
- Filtro por trabalhador CPF
- Validação: só permite S-2501 após S-2500 aceito
- Múltiplos S-2501 por processo/trabalhador

### **RF005.2 - Wizard de Tributos**
**Etapa 1 - Identificação:**
- Processo base (readonly)
- Trabalhador (readonly)
- Estabelecimento pagador
- Período de apuração (YYYY-MM)

**Etapa 2 - Valores:**
- Base de cálculo previdenciária
- Base de cálculo FGTS
- Valor IRRF
- Contribuições sociais
- Contribuições a terceiros

**Etapa 3 - Confirmação:**
- Resumo dos valores
- Preview do XML
- Validações finais

---

## 🔧 **RF006 - GERAÇÃO E GESTÃO DE XML**

### **RF006.1 - Geração de XML S-2500**
**Funcionalidades:**
- Factory pattern por tipo de contrato
- Validação XSD automática
- Assinatura digital (se configurada)
- Numeração sequencial automática

### **RF006.2 - Preview de XML**
**Funcionalidades:**
- Visualização formatada do XML
- Highlight de syntax
- Validação em tempo real
- Opção de salvar arquivo

### **RF006.3 - Controle de Status**
**Estados:**
- **Rascunho:** Em edição
- **Validado:** Pronto para transmissão
- **Transmitido:** Enviado ao eSocial
- **Aceito:** Processado com sucesso
- **Rejeitado:** Com erros, precisa correção

### **RF006.4 - Log de Transmissões**
**Informações:**
- Data/hora da transmissão
- Usuário responsável
- Número do recibo
- Status de retorno
- Mensagens de erro (se houver)

---

## 🔍 **RF007 - CONSULTAS E RELATÓRIOS**

### **RF007.1 - Consulta de Processos**
**Filtros:**
- Por período de criação
- Por status
- Por empresa
- Por trabalhador (CPF)
- Por usuário responsável

### **RF007.2 - Relatórios Básicos**
- **Processos por Status:** Quantidade por situação
- **Processos por Período:** Timeline de criação
- **Trabalhadores por Processo:** Lista de vinculações
- **Log de Ações:** Auditoria completa

### **RF007.3 - Dashboard**
**Indicadores:**
- Total de processos cadastrados
- Processos transmitidos hoje
- Processos com erro
- Próximos vencimentos

---

## 🔐 **RF008 - AUDITORIA E LOGS**

### **RF008.1 - Log de Auditoria Integrado**
**Registros Automáticos:**
- Criação, alteração, exclusão de processos
- Transmissões de XML
- Acessos às funcionalidades (integrado ao sistema base)
- Tentativas de acesso negado

**Campos do Log:**
- Data/hora (timestamp)
- Usuário (obtido do sistema base)
- Ação realizada
- Registro afetado (processo/trabalhador)
- IP de origem (se disponível no sistema base)
- Dados alterados (before/after)

### **RF008.2 - Backup e Recuperação**
**Funcionalidades:**
- Backup automático diário
- Backup manual sob demanda
- Restauração por data específica
- Verificação de integridade

---

## 📊 **RF009 - INTEGRAÇÃO EXTERNA**

### **RF009.1 - Consulta de Empresa**
**Funcionalidades:**
- Busca por CNPJ/CPF
- Retorno: Razão Social, Nome Fantasia, Situação
- Cache de resultados (performance)
- Timeout configurável

### **RF009.2 - Consulta de Trabalhador**
**Funcionalidades:**
- Busca por CPF
- Retorno: Nome, Data Nascimento, Situação
- Validação CPF ativo
- Log de consultas

### **RF009.3 - Tratamento de Erros**
**Cenários:**
- Serviço indisponível: Permite cadastro manual
- CPF/CNPJ inválido: Exibe mensagem específica
- Timeout: Retry automático (3 tentativas)
- Dados inconsistentes: Alert ao usuário

---

## 📱 **RF010 - USABILIDADE E INTERFACE**

### **RF010.1 - Padrões Visuais**
**Baseado no eSocial Web:**
- Cores: Azul primário (#184194), cinzas (#6C767D)
- Tipografia: Sans-serif, tamanhos padronizados
- Ícones: Consistentes com tema governamental
- Espaçamento: Grid de 8px

### **RF010.2 - Responsividade**
**Considerações:**
- Telas mínimas: 1024x768
- Componentes redimensionáveis
- Scroll quando necessário
- Manter usabilidade em telas menores

### **RF010.3 - Acessibilidade**
**Funcionalidades:**
- Navegação por teclado (Tab order)
- Labels descritivos em todos campos
- Alto contraste disponível
- Mensagens de erro claras e específicas

### **RF010.4 - Performance**
**Requisitos:**
- Carregamento de tela < 3 segundos
- Salvamento de dados < 2 segundos
- Consultas externas < 5 segundos
- Interface responsiva sempre

---

## 🔄 **RF011 - CONFIGURAÇÕES DO SISTEMA**

### **RF011.1 - Configurações Gerais**
- URL do serviço de consulta externa
- Timeout das consultas
- Diretório de backup
- Certificado digital (para assinatura)
- Integração com sistema base (parâmetros de conexão)

### **RF011.2 - Configurações por Empresa**
- CNPJ/CPF padrão
- Estabelecimentos autorizados
- Responsáveis padrão
- Prefixos de numeração

### **RF011.3 - Preferências Herdadas**
- Permissões herdadas do sistema base
- Empresas com acesso (obtidas do sistema principal)
- Configurações de interface (quando aplicável)

---

## ✅ **CRITÉRIOS DE ACEITE GERAIS**

### **Performance**
- ✅ Tempo de resposta da interface < 2 segundos
- ✅ Carregamento de listas < 3 segundos
- ✅ Geração de XML < 5 segundos
- ✅ Consultas externas < 10 segundos

### **Usabilidade**
- ✅ Interface intuitiva para usuários do eSocial Web
- ✅ Máximo 3 cliques para funções principais
- ✅ Mensagens de erro claras e acionáveis
- ✅ Navegação consistente em todo sistema

### **Confiabilidade**
- ✅ XMLs gerados válidos 100% das vezes
- ✅ Dados gravados sem perda
- ✅ Backup automático funcionando
- ✅ Log de auditoria completo

### **Conformidade**
- ✅ XMLs aderentes ao leiaute eSocial v1.3
- ✅ Validações idênticas ao eSocial Web
- ✅ Terminologia oficial respeitada
- ✅ Fluxos de trabalho consistentes

---

## 📋 **PRIORIZAÇÃO DE DESENVOLVIMENTO**

### **ALTA PRIORIDADE (Fase 1)**
1. RF002 - Wizard S-2500 (Tipos 1, 2, 3)
2. RF003 - Gestão de Trabalhadores  
3. RF004 - Sistema de Validações
4. RF006 - Geração XML S-2500
5. RF005 - Cadastro S-2501 básico

### **MÉDIA PRIORIDADE (Fase 1)**
6. RF001 - Interface Principal
7. RF007 - Consultas básicas
8. RF008 - Auditoria essencial
9. RF009 - Integração externa

### **BAIXA PRIORIDADE (Fase 2)**
10. RF002 - Tipos de contrato 4-9
11. RF005 - S-2501 avançado  
12. RF007 - Relatórios completos
13. RF010 - Melhorias de UX
14. RF011 - Configurações avançadas

---

**📋 Documento:** Requisitos Funcionais v1.0  
**📅 Data:** Agosto 2025  
**👥 Responsável:** Equipe de Desenvolvimento  
**🔄 Status:** Aprovação Pendente