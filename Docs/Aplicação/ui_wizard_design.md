# Design de Interface - Sistema Wizard eSocial
## Protótipo de Navegação e Experiência do Usuário

### 1. CONCEITO GERAL DE NAVEGAÇÃO

#### 1.1 Estrutura Principal
O sistema seguirá o conceito de **Progressive Disclosure** (Revelação Progressiva), onde:
- Informações básicas são coletadas primeiro
- Campos condicionais aparecem dinamicamente
- Relacionamentos complexos são gerenciados em sub-wizards
- Validação ocorre em tempo real e ao final de cada etapa

#### 1.2 Padrão Visual
- **Clean Design** com fundo neutro (branco/cinza claro)
- **Barra de progresso** sempre visível no topo
- **Breadcrumbs** para navegação entre etapas
- **Área de validação** dedicada no rodapé
- **Botões de ação** padronizados (Anterior, Próximo, Cancelar, Salvar)

### 2. WIZARD PRINCIPAL - CADASTRO DE PROCESSO TRABALHISTA (S-2500)

#### 2.1 Estrutura de Navegação
```
Processo Trabalhista
├── 1. Dados Básicos do Processo
├── 2. Dados do Empregador
├── 3. Responsável Indireto (Condicional)
├── 4. Informações Judiciais/CCP (Condicional)
├── 5. Trabalhadores (Sub-wizard)
│   ├── 5.1 Dados Pessoais
│   ├── 5.2 Informações Contratuais
│   ├── 5.3 Remunerações (Sub-wizard Modal)
│   └── 5.4 Vínculos (Sub-wizard Modal)
├── 6. Revisão e Validação
└── 7. Confirmação
```

#### 2.2 Etapa 1: Dados Básicos do Processo

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Cadastro de Processo Trabalhista    [1/7] ▓▓░░░░░ │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DADOS BÁSICOS DO PROCESSO                                  │
│                                                             │
│  Número do Processo *                                       │
│  ┌─────────────────────────────────────────┐                │
│  │ 0000107-17.2018.5.02.0461               │ [Validar]     │
│  └─────────────────────────────────────────┘                │
│  ✓ Formato válido                                           │
│                                                             │
│  Origem do Processo *                                       │
│  ○ Processo Judicial    ○ Processo CCP/NINTER               │
│                                                             │
│  [Campos dinâmicos baseados na origem selecionada]         │
│                                                             │
│  ┌─ JUDICIAL (se selecionado) ──────────────────────────────┐│
│  │ UF da Vara Trabalhista *  ID da Vara                    ││
│  │ ┌──┐                    ┌─────────────────────────────┐ ││
│  │ │SP│                    │ 461                         │ ││
│  │ └──┘                    └─────────────────────────────┘ ││
│  │                                                        ││
│  │ Código do Município *                                  ││
│  │ ┌─────────────────────────────────────────────────────┐ ││
│  │ │ 50308 - São Paulo                                   │ ││
│  │ └─────────────────────────────────────────────────────┘ ││
│  │                                                        ││
│  │ Tipo de Tributo *                                      ││
│  │ ○ IRRF  ○ Contribuições  ○ FGTS  ○ Todos               ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│  Observações                                                │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                                                         ││
│  │                                                         ││
│  └─────────────────────────────────────────────────────────┘│
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ⚠️  Validações: 0 erros, 0 avisos                          │
│                                                             │
│            [Cancelar]              [Próximo] ►             │
└─────────────────────────────────────────────────────────────┘
```

#### 2.3 Etapa 2: Dados do Empregador

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Cadastro de Processo Trabalhista    [2/7] ▓▓▓░░░░ │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DADOS DO EMPREGADOR                                        │
│                                                             │
│  Tipo de Inscrição *                                        │
│  ○ CNPJ    ○ CPF    ○ CAEPF    ○ CNO                        │
│                                                             │
│  Número da Inscrição *                                      │
│  ┌─────────────────────────────┐ [🔍 Consultar Sistema]     │
│  │ 12.345.678/0001-95          │                           │
│  └─────────────────────────────┘                           │
│  ✓ CNPJ válido                                              │
│                                                             │
│  ┌─ DADOS PREENCHIDOS AUTOMATICAMENTE ──────────────────────┐│
│  │                                                        ││
│  │ Razão Social                                           ││
│  │ ┌────────────────────────────────────────────────────┐ ││
│  │ │ EMPRESA EXEMPLO LTDA                               │ ││
│  │ └────────────────────────────────────────────────────┘ ││
│  │                                                        ││
│  │ ✓ Dados preenchidos via integração                    ││
│  │                                                        ││
│  │ [Editar Manualmente] se necessário                    ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│                                                             │
│  MODAL DE CONSULTA EXTERNA:                                 │
│  ┌─ Consulta de Empresa ─────────────────────┐              │
│  │                                           │              │
│  │ Código da Empresa                         │              │
│  │ ┌─────────────────┐ [Pesquisar]           │              │
│  │ │ EMP001          │                       │              │
│  │ └─────────────────┘                       │              │
│  │                                           │              │
│  │ Resultados:                               │              │
│  │ ┌───────────────────────────────────────┐ │              │
│  │ │ EMP001 - Empresa Exemplo Ltda         │ │              │
│  │ │ CNPJ: 12.345.678/0001-95              │ │              │
│  │ └───────────────────────────────────────┘ │              │
│  │                                           │              │
│  │        [Cancelar]    [Selecionar]         │              │
│  └───────────────────────────────────────────┘              │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ✓  Validações: 0 erros, 0 avisos                           │
│                                                             │
│     ◄ [Anterior]      [Cancelar]      [Próximo] ►          │
└─────────────────────────────────────────────────────────────┘
```

#### 2.4 Etapa 5: Trabalhadores (Sub-Wizard Principal)

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Cadastro de Processo Trabalhista    [5/7] ▓▓▓▓▓░░ │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TRABALHADORES DO PROCESSO                                  │
│                                                             │
│  ┌─ TRABALHADORES CADASTRADOS ────────────────────────────┐ │
│  │                                                        │ │
│  │ ┌────────────────────────────────────────────────────┐ │ │
│  │ │ ✓ João Silva Santos                                │ │ │
│  │ │   CPF: 123.456.789-01                             │ │ │
│  │ │   Matrícula: 12345                                 │ │ │
│  │ │   Status: Completo                                 │ │ │
│  │ │                        [Editar] [Excluir] [Ver]    │ │ │
│  │ └────────────────────────────────────────────────────┘ │ │
│  │                                                        │ │
│  │ ┌────────────────────────────────────────────────────┐ │ │
│  │ │ ⚠️  Maria Oliveira Costa                            │ │ │
│  │ │   CPF: 987.654.321-00                             │ │ │
│  │ │   Matrícula: 12346                                 │ │ │
│  │ │   Status: Remunerações Pendentes                   │ │ │
│  │ │                        [Editar] [Excluir] [Ver]    │ │ │
│  │ └────────────────────────────────────────────────────┘ │ │
│  │                                                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│           [+ Adicionar Novo Trabalhador]                    │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ⚠️  Validações: 0 erros, 1 aviso - Maria sem remuneração   │
│                                                             │
│     ◄ [Anterior]      [Cancelar]      [Próximo] ►          │
└─────────────────────────────────────────────────────────────┘
```

### 3. SUB-WIZARD - CADASTRO DE TRABALHADOR

#### 3.1 Estrutura de Navegação
```
Trabalhador no Processo
├── 1. Dados Pessoais
├── 2. Informações Contratuais
├── 3. Remunerações (Sub-modal)
├── 4. Informações de Vínculo
├── 5. Revisão
└── 6. Salvar/Vincular
```

#### 3.2 Sub-Wizard Etapa 1: Dados Pessoais

```
┌─────────────────────────────────────────────────────────────┐
│ Cadastro de Trabalhador                    [1/6] ▓░░░░░     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DADOS PESSOAIS DO TRABALHADOR                              │
│                                                             │
│  CPF do Trabalhador *                                       │
│  ┌─────────────────────────────┐ [🔍 Consultar Sistema]     │
│  │ 123.456.789-01              │                           │
│  └─────────────────────────────┘                           │
│  ✓ CPF válido                                               │
│                                                             │
│  ┌─ DADOS PREENCHIDOS AUTOMATICAMENTE ──────────────────────┐│
│  │                                                        ││
│  │ Nome Completo *                                        ││
│  │ ┌────────────────────────────────────────────────────┐ ││
│  │ │ JOÃO SILVA SANTOS                                  │ ││
│  │ └────────────────────────────────────────────────────┘ ││
│  │                                                        ││
│  │ Data de Nascimento *                                   ││
│  │ ┌──────────────┐                                       ││
│  │ │ 15/03/1985   │                                       ││
│  │ └──────────────┘                                       ││
│  │                                                        ││
│  │ ✓ Dados preenchidos via integração                    ││
│  │                                                        ││
│  │ [Editar Manualmente] se necessário                    ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│  Matrícula                                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ 12345                                                   ││
│  └─────────────────────────────────────────────────────────┘│
│                                                             │
│  Indica Contrato *                                          │
│  ○ Sim - Possui contrato de trabalho                        │
│  ○ Não - Sem contrato (situação especial)                  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ✓  Validações: 0 erros, 0 avisos                           │
│                                                             │
│     [Cancelar]                        [Próximo] ►          │
└─────────────────────────────────────────────────────────────┘
```

#### 3.3 Sub-Wizard Etapa 3: Remunerações (Interface Complexa)

```
┌─────────────────────────────────────────────────────────────┐
│ Cadastro de Trabalhador                    [3/6] ▓▓▓░░░     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  REMUNERAÇÕES DO TRABALHADOR                                │
│                                                             │
│  ┌─ REMUNERAÇÕES CADASTRADAS ─────────────────────────────┐ │
│  │                                                        │ │
│  │ ┌────────────────────────────────────────────────────┐ │ │
│  │ │ 📅 01/01/2024                                       │ │ │
│  │ │ 💰 R$ 3.000,00 (Por Mês)                           │ │ │
│  │ │ 📝 Salário Base                                     │ │ │
│  │ │                        [Editar] [Excluir]          │ │ │
│  │ └────────────────────────────────────────────────────┘ │ │
│  │                                                        │ │
│  │ ┌────────────────────────────────────────────────────┐ │ │
│  │ │ 📅 01/03/2024                                       │ │ │
│  │ │ 💰 R$ 500,00 (Por Mês)                             │ │ │
│  │ │ 📝 Adicional Insalubridade                          │ │ │
│  │ │                        [Editar] [Excluir]          │ │ │
│  │ └────────────────────────────────────────────────────┘ │ │
│  │                                                        │ │
│  │ Total: R$ 3.500,00                                     │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│           [+ Adicionar Nova Remuneração]                    │
│                                                             │
│                                                             │
│  MODAL - NOVA REMUNERAÇÃO:                                  │
│  ┌─ Cadastro de Remuneração ─────────────────┐              │
│  │                                           │              │
│  │ Data da Remuneração *                     │              │
│  │ ┌──────────────┐                          │              │
│  │ │ 01/01/2024   │                          │              │
│  │ └──────────────┘                          │              │
│  │                                           │              │
│  │ Valor do Salário Fixo                     │              │
│  │ ┌─────────────────┐                       │              │
│  │ │ 3.000,00        │                       │              │
│  │ └─────────────────┘                       │              │
│  │                                           │              │
│  │ Unidade do Salário Fixo                   │              │
│  │ ┌─────────────────────────────────────┐   │              │
│  │ │ Por Mês                         ▼  │   │              │
│  │ └─────────────────────────────────────┘   │              │
│  │ Por Hora | Por Dia | Por Mês | ...        │              │
│  │                                           │              │
│  │ Descrição Salário Variável                │              │
│  │ ┌─────────────────────────────────────┐   │              │
│  │ │ Comissões sobre vendas          ▼  │   │              │
│  │ └─────────────────────────────────────┘   │              │
│  │                                           │              │
│  │        [Cancelar]    [Adicionar]          │              │
│  └───────────────────────────────────────────┘              │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ✓  Validações: 0 erros, 0 avisos                           │
│                                                             │
│     ◄ [Anterior]      [Cancelar]      [Próximo] ►          │
└─────────────────────────────────────────────────────────────┘
```

### 4. WIZARD DE TRIBUTOS (S-2501)

#### 4.1 Estrutura de Navegação
```
Tributos do Processo
├── 1. Seleção do Trabalhador
├── 2. Período de Apuração
├── 3. Cálculos Básicos
├── 4. Contribuições Sociais
├── 5. Imposto de Renda
├── 6. Códigos de Receita (Sub-modal)
├── 7. Revisão e Validação
└── 8. Salvar
```

#### 4.2 Etapa 3: Cálculos Básicos

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Cadastro de Tributos                 [3/8] ▓▓▓░░░░░│
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CÁLCULOS BÁSICOS DOS TRIBUTOS                              │
│                                                             │
│  Trabalhador Selecionado: João Silva Santos (123.456.789-01)│
│  Período de Apuração: 01/2024                               │
│                                                             │
│  ┌─ COMPETÊNCIA DO CÁLCULO ─────────────────────────────────┐│
│  │                                                        ││
│  │ Competência Inicial *     Competência Final *          ││
│  │ ┌──────────────┐          ┌──────────────┐              ││
│  │ │ 01/2024      │          │ 01/2024      │              ││
│  │ └──────────────┘          └──────────────┘              ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│  ┌─ BASES DE CÁLCULO ──────────────────────────────────────┐│
│  │                                                        ││
│  │ Valor Base CP (Previdência) *                          ││
│  │ ┌─────────────────┐                                    ││
│  │ │ 3.500,00        │                                    ││
│  │ └─────────────────┘                                    ││
│  │                                                        ││
│  │ Valor Base IRRF *                                      ││
│  │ ┌─────────────────┐                                    ││
│  │ │ 3.500,00        │                                    ││
│  │ └─────────────────┘                                    ││
│  │                                                        ││
│  │ Valor Base FGTS *                                      ││
│  │ ┌─────────────────┐                                    ││
│  │ │ 3.500,00        │                                    ││
│  │ └─────────────────┘                                    ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│  ┌─ VALORES CALCULADOS ────────────────────────────────────┐│
│  │                                                        ││
│  │ Contribuição Previdenciária (8%)                       ││
│  │ ┌─────────────────┐ [Calcular Automaticamente]         ││
│  │ │ 280,00          │                                    ││
│  │ └─────────────────┘                                    ││
│  │                                                        ││
│  │ Contribuição do Segurado (11%)                         ││
│  │ ┌─────────────────┐ [Calcular Automaticamente]         ││
│  │ │ 385,00          │                                    ││
│  │ └─────────────────┘                                    ││
│  │                                                        ││
│  │ FGTS (8%)                                              ││
│  │ ┌─────────────────┐ [Calcular Automaticamente]         ││
│  │ │ 280,00          │                                    ││
│  │ └─────────────────┘                                    ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ⚠️  Validações: 0 erros, 1 aviso - Verificar cálculos      │
│                                                             │
│     ◄ [Anterior]      [Cancelar]      [Próximo] ►          │
└─────────────────────────────────────────────────────────────┘
```

### 5. TELA DE VALIDAÇÃO FINAL

#### 5.1 Interface de Validação Completa

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Validação Final                  [6/7] ▓▓▓▓▓▓░   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  VALIDAÇÃO COMPLETA DO PROCESSO                             │
│                                                             │
│  ┌─ RESUMO DO PROCESSO ───────────────────────────────────┐ │
│  │                                                        │ │
│  │ Processo: 0000107-17.2018.5.02.0461                   │ │
│  │ Empregador: EMPRESA EXEMPLO LTDA (12.345.678/0001-95) │ │
│  │ Origem: Processo Judicial                              │ │
│  │ Trabalhadores: 2                                       │ │
│  │ Tributos: 2 períodos                                   │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  📋 [Executar Validação Completa]                           │
│                                                             │
│  ┌─ RESULTADO DA VALIDAÇÃO ──────────────────────────────┐  │
│  │                                                       │  │
│  │ ✅ VALIDAÇÕES DE FORMATO                              │  │
│  │   ✓ Número do processo válido                         │  │
│  │   ✓ CNPJ empregador válido                            │  │
│  │   ✓ CPFs trabalhadores válidos                        │  │
│  │                                                       │  │
│  │ ✅ VALIDAÇÕES DE OBRIGATORIEDADE                       │  │
│  │   ✓ Todos os campos obrigatórios preenchidos          │  │
│  │   ✓ Trabalhadores possuem contratos                   │  │
│  │   ✓ Remunerações cadastradas                          │  │
│  │                                                       │  │
│  │ ⚠️  VALIDAÇÕES DE REGRAS ESOCIAL                       │  │
│  │   ⚠️  João Silva: Falta código CBO                    │  │
│  │   ✓ Maria Oliveira: Todos os dados OK                 │  │
│  │                                                       │  │
│  │ ❌ VALIDAÇÕES CRÍTICAS                                │  │
│  │   ❌ Período tributo inválido para João Silva         │  │
│  │   ❌ Base de cálculo FGTS zerada                      │  │
│  │                                                       │  │
│  │ RESUMO: 2 erros críticos, 1 aviso                     │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─ AÇÕES CORRETIVAS ────────────────────────────────────┐  │
│  │                                                       │  │
│  │ • Ir para João Silva → Contratos → Código CBO         │  │
│  │ • Ir para João Silva → Tributos → Período             │  │
│  │ • Ir para Tributos → Bases de Cálculo                 │  │
│  │                                                       │  │
│  │ [Corrigir Automaticamente]  [Ir para Erro]            │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ❌ BLOQUEADO: Corrija os erros antes de continuar           │
│                                                             │
│     ◄ [Anterior]      [Cancelar]      [Corrigir] 🔧        │
└─────────────────────────────────────────────────────────────┘
```

### 6. GERAÇÃO DE XML

#### 6.1 Interface de Geração e Prévia

```
┌─────────────────────────────────────────────────────────────┐
│ eSocial - Geração de XML                   [7/7] ▓▓▓▓▓▓▓   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GERAÇÃO DOS XMLS ESOCIAL                                   │
│                                                             │
│  ✅ Processo Validado e Pronto para Envio                   │
│                                                             │
│  📄 [Gerar XMLs]                                            │
│                                                             │
│  ┌─ XMLS GERADOS ──────────────────────────────────────────┐│
│  │                                                        ││
│  │ ✅ S-2500 - Processo Trabalhista                       ││
│  │    ID: ID1234567800019520250115143022000001           ││
│  │    Tamanho: 2.3 KB                                    ││
│  │    [👁️ Visualizar] [💾 Salvar] [📋 Copiar]              ││
│  │                                                        ││
│  │ ✅ S-2501 - Tributos (João Silva)                      ││
│  │    ID: ID1234567800019520250115143025000002           ││
│  │    Tamanho: 1.8 KB                                    ││
│  │    [👁️ Visualizar] [💾 Salvar] [📋 Copiar]              ││
│  │                                                        ││
│  │ ✅ S-2501 - Tributos (Maria Oliveira)                  ││
│  │    ID: ID1234567800019520250115143028000003           ││
│  │    Tamanho: 1.9 KB                                    ││
│  │    [👁️ Visualizar] [💾 Salvar] [📋 Copiar]              ││
│  └────────────────────────────────────────────────────────┘│
│                                                             │
│  📤 ENVIO PARA ESOCIAL                                      │
│  ○ Salvar apenas (não enviar)                              │
│  ○ Salvar e enviar imediatamente                           │
│  ○ Agendar envio para: [___/___/____] às [__:__]           │
│                                                             │
│  📊 RELATÓRIO DE GERAÇÃO                                    │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Data/Hora: 15/01/2025 14:30:22                         ││
│  │ Usuário: admin.sistema                                 ││
│  │ Total XMLs: 3                                          ││
│  │ Total Trabalhadores: 2                                 ││
│  │ Status: Pronto para Envio                              ││
│  └─────────────────────────────────────────────────────────┘│
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ ✅ Processo finalizado com sucesso!                         │
│                                                             │
│     ◄ [Anterior]      [Finalizar]      [Enviar] 📤         │
└─────────────────────────────────────────────────────────────┘
```

### 7. DESIGN PATTERNS E COMPONENTES REUTILIZÁVEIS

#### 7.1 Componente Wizard Genérico
```csharp
public partial class WizardControl : UserControl
{
    public int TotalSteps { get; set; }
    public int CurrentStep { get; set; }
    public List<WizardStep> Steps { get; set; }
    
    public event EventHandler<WizardStepEventArgs> StepChanged;
    public event EventHandler<WizardValidationEventArgs> StepValidating;
    
    private void UpdateProgressBar()
    {
        progressBar.Value = (CurrentStep * 100) / TotalSteps;
        lblProgress.Text = $"{CurrentStep}/{TotalSteps}";
    }
}

public class WizardStep
{
    public string Title { get; set; }
    public UserControl Content { get; set; }
    public bool IsValid { get; set; }
    public List<string> ValidationMessages { get; set; }
}
```

#### 7.2 Componente Validation Panel
```csharp
public partial class ValidationPanel : UserControl
{
    public ValidationLevel Level { get; set; } // Error, Warning, Success
    public List<ValidationMessage> Messages { get; set; }
    
    public void AddMessage(ValidationLevel level, string message, string field = null)
    {
        Messages.Add(new ValidationMessage 
        { 
            Level = level, 
            Message = message, 
            Field = field 
        });
        RefreshDisplay();
    }
    
    private void RefreshDisplay()
    {
        // Atualizar cores, ícones e contadores baseado no nível
        var errorCount = Messages.Count(m => m.Level == ValidationLevel.Error);
        var warningCount = Messages.Count(m => m.Level == ValidationLevel.Warning);
        
        lblStatus.Text = $"{errorCount} erros, {warningCount} avisos";
        
        // Definir cor do painel
        BackColor = errorCount > 0 ? Color.FromArgb(255, 245, 245) : 
                   warningCount > 0 ? Color.FromArgb(255, 252, 245) : 
                   Color.FromArgb(245, 255, 245);
    }
}
```

#### 7.3 Componente Search Integration
```csharp
public partial class ExternalSearchControl : UserControl
{
    public string SearchType { get; set; } // "Empresa", "Trabalhador"
    public event EventHandler<SearchResultEventArgs> ResultSelected;
    
    private async void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            loadingIndicator.Visible = true;
            
            var service = ServiceLocator.GetService<IConsultaExternaService>();
            var results = SearchType == "Empresa" 
                ? await service.ConsultarEmpresaPorCodigoAsync(txtCode.Text)
                : await service.ConsultarTrabalhadorPorCodigoAsync(txtCode.Text);
                
            DisplayResults(results);
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Erro na consulta: {ex.Message}");
        }
        finally
        {
            loadingIndicator.Visible = false;
        }
    }
}
```

### 8. RESPONSIVIDADE E ACESSIBILIDADE

#### 8.1 Padrões de Design Responsivo
- **Largura mínima:** 1024px para wizards complexos
- **Alturas dinâmicas:** Baseadas no conteúdo
- **Scroll vertical:** Quando necessário
- **Fontes escaláveis:** Sistema padrão do Windows

#### 8.2 Acessibilidade
- **Tab Order:** Sequencial e lógico
- **Atalhos de teclado:** Enter para próximo, Esc para cancelar
- **Screen Reader:** Labels descritivas
- **Alto contraste:** Suporte nativo do Windows

### 9. FLUXO DE VALIDAÇÃO EM DUAS CAMADAS

#### 9.1 Validação Imediata (UI)
- **Trigger:** OnBlur, OnValueChanged
- **Escopo:** Formato, obrigatoriedade básica
- **Feedback:** Imediato, próximo ao campo

#### 9.2 Validação Completa (Business Rules)
- **Trigger:** Botão "Validar" ou "Finalizar Etapa"
- **Escopo:** Regras de negócio, interdependências
- **Feedback:** Painel dedicado com ações corretivas

### 10. CONTROLE DE ESTADO E NAVEGAÇÃO

#### 10.1 State Management
```csharp
public class ProcessoTrabalhistaState
{
    public ProcessoTrabalhista Processo { get; set; }
    public Dictionary<Guid, TrabalhadorProcesso> Trabalhadores { get; set; }
    public Dictionary<Guid, List<TributoProcesso>> Tributos { get; set; }
    public ValidationResult ValidationResult { get; set; }
    public bool IsDirty { get; set; }
    
    public void MarkAsChanged()
    {
        IsDirty = true;
        LastModified = DateTime.Now;
    }
}
```

#### 10.2 Navigation Guard
```csharp
public bool CanNavigateToStep(int targetStep)
{
    // Verificar se todos os steps anteriores estão válidos
    for (int i = 1; i < targetStep; i++)
    {
        if (!Steps[i-1].IsValid)
        {
            MessageBox.Show($"Complete a etapa {i} antes de continuar");
            return false;
        }
    }
    return true;
}
```

---

**Este design de interface garante uma experiência de usuário fluida, intuitiva e em conformidade com as melhores práticas de UX para sistemas corporativos complexos, especificamente adaptado para as complexidades dos dados eSocial.**