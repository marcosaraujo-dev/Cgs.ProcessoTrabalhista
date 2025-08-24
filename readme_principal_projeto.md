# eSocial Processo Trabalhista

> Sistema desktop para cadastro, validação e geração de eventos eSocial relacionados a processos trabalhistas

[![C#](https://img.shields.io/badge/C%23-.NET%20Framework%204.8-blue.svg)](https://dotnet.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://postgresql.org/)
[![eSocial](https://img.shields.io/badge/eSocial-v1.3-green.svg)](https://www.gov.br/esocial/)

## 🎯 **Objetivo**

Desenvolver sistema desktop integrado ao sistema base existente para gestão completa de **Processos Trabalhistas eSocial**, incluindo cadastro, validação e geração dos eventos S-2500, S-2501, S-2555 e S-3500, seguindo rigorosamente os padrões estabelecidos no eSocial Web oficial.

## 📋 **Eventos Suportados**

| Evento | Descrição | Status |
|--------|-----------|--------|
| **S-2500** | Processo Trabalhista | 🟢 Fase 1 |
| **S-2501** | Informações dos Tributos Decorrentes | 🟢 Fase 1 |
| **S-2555** | Solicitação de Consolidação | 🟡 Fase 2 |
| **S-3500** | Exclusão de Eventos | 🟡 Fase 2 |

## 🔢 **Tipos de Contrato Suportados**

### 🟢 **Fase 1 - Desenvolvimento Imediato (80% dos casos)**
- **[Tipo 1](docs/01-analise/tipos-contrato/tipo-01-vinculo-sem-alteracao.md)** - Trabalhador com vínculo formalizado, sem alteração de datas
- **[Tipo 2](docs/01-analise/tipos-contrato/tipo-02-alteracao-admissao.md)** - Com alteração na data de admissão
- **[Tipo 3](docs/01-analise/tipos-contrato/tipo-03-inclusao-desligamento.md)** - Com inclusão ou alteração de data de desligamento

### 🟡 **Fase 2 - Desenvolvimento Futuro (cenários complexos)**
- **[Tipo 4](docs/01-analise/tipos-contrato/tipo-04-alteracao-ambas-datas.md)** - Alteração nas datas de admissão E desligamento
- **[Tipo 5](docs/01-analise/tipos-contrato/tipo-05-reconhecimento-vinculo.md)** - Empregado com reconhecimento de vínculo
- **[Tipo 6](docs/01-analise/tipos-contrato/tipo-06-tsve-sem-reconhecimento.md)** - TSVE sem reconhecimento de vínculo
- **[Tipo 7](docs/01-analise/tipos-contrato/tipo-07-periodo-pre-esocial.md)** - Vínculo em período anterior ao eSocial
- **[Tipo 8](docs/01-analise/tipos-contrato/tipo-08-responsabilidade-indireta.md)** - Responsabilidade indireta
- **[Tipo 9](docs/01-analise/tipos-contrato/tipo-09-unicidade-contratual.md)** - Contratos unificados (unicidade)

## 🏗️ **Tecnologias**

### **Backend**
- **C# .NET Framework 4.8** - Linguagem principal
- **Dapper** - Micro ORM para acesso ao banco
- **PostgreSQL** - Banco de dados principal
- **Clean Architecture** - Organização em camadas (Domain, Application, Infrastructure, UI)

### **Frontend**
- **Windows Forms/WPF** - Interface desktop (decisão pendente)
- **Design System** baseado no eSocial Web oficial
- **Wizard Pattern** - Navegação em etapas sequenciais

### **Padrões Arquiteturais**
- **SOLID Principles** - Design de classes consistente
- **Repository Pattern** - Abstração de acesso aos dados
- **Factory Pattern** - Geração de XMLs por tipo
- **Strategy Pattern** - Validações específicas por tipo

### **Restrições Técnicas**
- ❌ **Entity Framework** - Não utilizar
- ❌ **MediatR** - Não utilizar
- ❌ **AutoMapper** - Não utilizar
- ✅ **Dapper** - ORM aprovado
- ✅ **Clean Code** - Práticas obrigatórias

## 📚 **Documentação**

### **📊 Análise de Negócio**
- **[Glossário de Termos](docs/01-analise/glossario-termos-dominio.md)** - Base terminológica do projeto
- **[Requisitos Funcionais](docs/01-analise/requisitos-funcionais-detalhados.md)** - RF001-RF011 completos
- **[Casos de Uso](docs/01-analise/casos-de-uso-detalhados.md)** - UC001-UC011 com fluxos
- **[Tipos de Contrato](docs/01-analise/tipos-contrato/)** - Especificações individuais por tipo

### **🏗️ Arquitetura Técnica**
- **[Arquitetura do Sistema](docs/02-arquitetura/arquitetura-sistema.md)** - Estrutura em camadas
- **[Modelo de Dados](docs/02-arquitetura/modelo-dados-postgresql.md)** - PostgreSQL schema
- **[Padrões de Desenvolvimento](docs/02-arquitetura/padroes-desenvolvimento.md)** - Guidelines C#

### **🎨 Interface do Usuário**
- **[Design System](docs/03-interface/design-system.md)** - Padrões visuais baseados no eSocial Web
- **[Wireframes](docs/03-interface/wireframes.md)** - Layout das telas principais
- **[Protótipos](docs/03-interface/prototypes/)** - HTML interativo das telas

### **🔄 Fluxos de Processo**
- **[Fluxo Completo](docs/04-fluxos/fluxo-processo-completo.md)** - BPMN geral do sistema
- **[Fluxos por Tipo](docs/04-fluxos/por-tipo/)** - Processos específicos por tipo de contrato
- **[Validações](docs/04-fluxos/fluxo-validacoes.md)** - Engine de validação

### **✅ Validações e Testes**
- **[Regras de Negócio](docs/05-validacoes/regras-negocio-consolidadas.md)** - RN001-RN099
- **[Validações por Tipo](docs/05-validacoes/por-tipo/)** - Regras específicas por contrato
- **[Cenários de Teste](docs/05-validacoes/cenarios-teste/)** - Casos de teste por tipo

### **🔌 Integração**
- **[API Externa](docs/06-integracao/api-consulta-externa.md)** - Consulta CPF/CNPJ
- **[Especificação XML](docs/06-integracao/especificacao-xml-esocial.md)** - Leiautes v1.3
- **[Exemplos XML](docs/06-integracao/exemplos-xml/)** - Templates por tipo de contrato

## 🚀 **Roadmap de Desenvolvimento**

### **Sprint 1-4 (Fase 1) - 12 semanas**
- ✅ **Análise e documentação** completa
- 🔄 **Arquitetura e modelo de dados** PostgreSQL
- 🔄 **Interface base** - tela principal + wizard framework
- 🔄 **Tipos 1-3** implementação completa
- 🔄 **Geração XML S-2500** e **S-2501** básico
- 🔄 **Sistema de validações** core

### **Sprint 5-8 (Fase 2) - 10 semanas**
- 📋 **Tipos 4-6** implementação
- 📋 **S-2555** consolidação de tributos
- 📋 **S-3500** exclusão de eventos
- 📋 **Relatórios** e consultas avançadas
- 📋 **Otimizações** de performance

### **Sprint 9+ (Futuro) - Conforme demanda**
- 📝 **Tipos 7-9** (cenários raros)
- 📝 **Funcionalidades avançadas**
- 📝 **Integrações** adicionais

## ⚙️ **Setup do Ambiente de Desenvolvimento**

### **Pré-requisitos**
- **Visual Studio 2019/2022** com .NET Framework 4.8
- **PostgreSQL 13+** instalado e configurado
- **Git** para versionamento
- **Draw.io** (opcional - para diagramas)

### **Banco de Dados**
```sql
-- Executar scripts na ordem:
database/scripts/01-create-database.sql
database/scripts/02-create-tables.sql
database/scripts/03-create-indexes.sql
database/scripts/04-create-constraints.sql
database/scripts/05-seed-data.sql
```

### **Configuração**
1. **Clone do repositório**
   ```bash
   git clone [URL_DO_REPOSITORIO]
   cd eSocialProcessoTrabalhista
   ```

2. **Configuração do banco**
   - Atualizar connection string no `app.config`
   - Executar scripts SQL da pasta `database/scripts/`

3. **Build da solução**
   ```bash
   dotnet restore
   dotnet build
   ```

## 🔐 **Integração com Sistema Base**

### **Autenticação**
- ✅ **Sem login próprio** - utiliza autenticação do sistema base existente
- ✅ **Controle de acesso** herdado por empresa
- ✅ **Logs integrados** ao sistema principal

### **Dados Compartilhados**
- 🔌 **Consulta de empresas** via integração
- 🔌 **Consulta de trabalhadores** via API externa
- 🔌 **Auditoria unificada** com sistema base

## 📊 **Métricas de Qualidade**

### **Performance**
- ⚡ **Tempo resposta interface:** < 2 segundos
- ⚡ **Geração de XML:** < 5 segundos
- ⚡ **Consultas externas:** < 10 segundos

### **Conformidade**
- ✅ **XMLs aderentes** ao leiaute eSocial v1.3
- ✅ **Validações idênticas** ao eSocial Web
- ✅ **Terminologia oficial** respeitada
- ✅ **Fluxos consistentes** com padrão governamental

### **Cobertura**
- 🎯 **Tipos 1-3:** 80% dos casos reais
- 🎯 **Validações:** 100% das regras eSocial v1.3
- 🎯 **Testes unitários:** Meta 80% cobertura
- 🎯 **Testes integração:** Cenários críticos

## 🤝 **Como Contribuir**

### **Fluxo de Desenvolvimento**
1. **Criar branch** a partir de `develop`
   ```bash
   git checkout -b feature/tipo-01-implementacao
   ```

2. **Seguir padrões** de código estabelecidos
   - [Padrões C#](docs/02-arquitetura/padroes-desenvolvimento.md)
   - [Convenções de nomenclatura](docs/02-arquitetura/padroes-desenvolvimento.md#nomenclatura)

3. **Testes obrigatórios** para novas funcionalidades
   - Testes unitários no padrão AAA (Arrange, Act, Assert)
   - Casos de teste conforme documentação

4. **Pull Request** com template preenchido
   - Descrição clara das mudanças
   - Referência aos requisitos atendidos
   - Evidências de teste

### **Estrutura de Commits**
```
feat: implementa cadastro processo tipo 1
docs: atualiza especificação tipo 2 
fix: corrige validação CPF tipo 3
test: adiciona cenários tipo 1
arch: ajusta estrutura repository pattern
```

### **Revisão de Código**
- ✅ **2 aprovações** obrigatórias
- ✅ **Build successful** no CI
- ✅ **Testes passando** 100%
- ✅ **Documentação** atualizada

## 📞 **Suporte e Contato**

### **Documentação Oficial**
- **[eSocial v1.3](https://www.gov.br/esocial/pt-br)** - Leiautes oficiais
- **[Manual eSocial Web](https://www.gov.br/esocial/pt-br/documentacao-tecnica)** - Interface de referência
- **[Senior Documentação](https://documentacao.senior.com.br/gestao-de-pessoas-hcm/esocial/)** - Referência técnica

### **Wiki do Projeto**
- **[FAQ](../../wiki/FAQ)** - Perguntas frequentes
- **[Troubleshooting](../../wiki/Troubleshooting)** - Solução de problemas
- **[Releases](../../wiki/Releases)** - Notas de versão

### **Issues e Sugestões**
- **[Bug Report](../../issues/new?template=bug_report.md)** - Relatar problemas
- **[Feature Request](../../issues/new?template=feature_request.md)** - Sugerir melhorias
- **[Documentation](../../issues/new?template=documentation.md)** - Melhorias na documentação

---

## 📋 **Status do Projeto**

**📊 Progresso Geral:** 📋 Análise Completa → 🔄 Desenvolvimento Iniciando

**🎯 Fase Atual:** Implementação dos Tipos 1-3 (Prioridade 1)

**📅 Última Atualização:** Agosto 2025

**👥 Equipe:** Tech Lead + Desenvolvedores + Analista de Negócio

---

**🏆 Objetivo:** Sistema de referência para processos trabalhistas eSocial, com qualidade e usabilidade que superem as expectativas dos usuários acostumados ao eSocial Web oficial.