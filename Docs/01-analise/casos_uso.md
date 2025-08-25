# 📋 CASOS DE USO DETALHADOS
## Diferenças entre os 8 Tipos de Contrato - eSocial Processo Trabalhista

> **Foco:** Cenários específicos e diferenças entre os tipos de contrato  
> **Base:** Manual eSocial Web + Análise dos arquivos fornecidos  
> **Versão:** 1.0 - Agosto 2025

---

## 🎯 **VISÃO GERAL DOS CASOS DE USO**

### **Casos de Uso por Prioridade de Desenvolvimento:**

**🟢 FASE 1 (Desenvolvimento Imediato):**
- **UC001:** Cadastrar Processo Tipo 1 (Vínculo sem alteração)
- **UC002:** Cadastrar Processo Tipo 2 (Alteração admissão)  
- **UC003:** Cadastrar Processo Tipo 3 (Inclusão desligamento)
- **UC010:** Cadastrar Tributos S-2501
- **UC011:** Validar e Gerar XML

**🟡 FASE 2 (Desenvolvimento Futuro):**
- **UC004:** Cadastrar Processo Tipo 4 (Alteração ambas datas)
- **UC005:** Cadastrar Processo Tipo 5 (Reconhecimento vínculo)
- **UC006:** Cadastrar Processo Tipo 6 (TSVE sem reconhecimento)
- **UC007:** Cadastrar Processo Tipo 7 (Período pré-eSocial)
- **UC008:** Cadastrar Processo Tipo 8 (Responsabilidade indireta)
- **UC009:** Cadastrar Processo Tipo 9 (Unicidade contratual)

---

## 🟢 **UC001 - CADASTRAR PROCESSO TIPO 1**
### *Trabalhador com vínculo formalizado, sem alteração de datas*

### **Ator Principal:** Usuário operador
### **Objetivo:** Cadastrar processo trabalhista para trabalhador já vinculado sem alterar datas de admissão/desligamento

### **Pré-condições:**
- ✅ Usuário autenticado no sistema base
- ✅ Trabalhador possui cadastro no eSocial
- ✅ Vínculo empregatício declarado e ativo
- ✅ CPF do trabalhador disponível

### **Fluxo Principal:**

#### **Etapa 1: Identificação do Trabalhador**
1. Sistema exibe tela "Novo Processo Trabalhista"
2. Usuário informa **CPF do trabalhador** (000.000.000-00)
3. Sistema **valida formato** do CPF
4. Sistema **consulta base externa** de trabalhadores
5. Sistema **localiza trabalhador** e exibe dados básicos:
   - Nome completo
   - Data de nascimento  
   - Situação no eSocial

#### **Etapa 2: Seleção de Matrícula**
6. Sistema exibe **lista de matrículas ativas** do trabalhador
7. Usuário **seleciona matrícula** específica para o processo
8. Sistema **carrega dados do contrato**:
   - Categoria do trabalhador (readonly)
   - Data de admissão original (readonly)
   - CBO (readonly)
   - Natureza da atividade (readonly)
   - Regime trabalhista (readonly)
   - Regime previdenciário (readonly)

#### **Etapa 3: Dados do Processo**
9. Sistema exibe **Aba "Dados do Processo"**
10. Usuário preenche:
    - **Número do processo** (validação formato)
    - **Origem** (Judicial/CCP/Ninter)
    - **Data da sentença/acordo**
    - **CNPJ/CPF empregador** (autopreenchido se disponível)
11. Sistema **valida campos obrigatórios** por origem
12. Usuário clica **"Próximo"**

#### **Etapa 4: Informações da Decisão**
13. Sistema exibe **Aba "Informações da Decisão ou Acordo"**
14. Sistema **predefine Tipo 1** no dropdown
15. Sistema exibe **campos readonly** com dados do vínculo:
    - Categoria: Empregado (101) ← exemplo
    - Matrícula: 12345 ← da seleção anterior
    - Data Admissão Original: 01/01/2020 ← readonly
    - CBO: 252515 ← readonly
    - Natureza: Trabalho urbano ← readonly
16. **Seção "Informações de Desligamento"** (OPCIONAL):
    - Data de desligamento (opcional)
    - Motivo desligamento (condicional)

#### **Etapa 5: Consolidação de Valores**
17. Sistema avança para **"Consolidação dos Valores"**
18. Usuário preenche:
    - **Estabelecimento pagador** (CNPJ/CPF/CAEPF)
    - **Início do processo** (MM/YYYY)
    - **Fim do processo** (MM/YYYY)
    - **Repercussão** (dropdown)
    - Checkboxes indenizações (opcional)

#### **Etapa 6: Discriminação Mensal**
19. Sistema **gera automaticamente** competências baseadas no período
20. Sistema exibe **grid mensal** com:
    - Coluna 1: Competência (YYYY-MM)
    - Coluna 2: Base CP (R$)
    - Coluna 3: Base FGTS (R$)
    - Coluna 4: Observações
21. Usuário **preenche valores** por competência
22. Sistema **totaliza automaticamente**

#### **Etapa 7: Finalização**
23. Usuário clica **"Finalizar"**
24. Sistema **executa validações finais**
25. Sistema **salva processo** com status "Cadastrado"
26. Sistema **exibe confirmação** com número sequencial

### **Fluxos Alternativos:**

#### **FA001 - CPF não encontrado**
- **No passo 4:** Sistema não localiza CPF na base externa
- Sistema exibe popup: **"CPF não encontrado. Deseja cadastrar manualmente?"**
- Se usuário confirma: abre tela cadastro manual (nome, data nascimento)
- Se usuário cancela: retorna ao campo CPF

#### **FA002 - Trabalhador sem vínculo ativo**  
- **No passo 6:** Sistema não encontra matrículas ativas
- Sistema exibe: **"Trabalhador não possui vínculos ativos. Verificar tipo de contrato."**
- Sistema sugere **Tipo 5 ou 6** como alternativa
- Usuário deve cancelar e reiniciar com tipo correto

#### **FA003 - Data de desligamento informada**
- **No passo 16:** Usuário preenche data de desligamento
- Sistema **torna obrigatório** o motivo de desligamento
- Sistema **valida** data posterior à admissão
- Sistema **ajusta automaticamente** fim do processo para data desligamento

### **Pós-condições:**
- ✅ Processo cadastrado no banco com todos os dados
- ✅ Status "Cadastrado" atribuído
- ✅ Logs de auditoria registrados
- ✅ Processo disponível para edição/transmissão

### **Regras de Negócio Específicas:**
- **RN001:** Todos os dados contratuais são readonly (vêm do eSocial)
- **RN002:** Data desligamento é opcional, mas se informada, motivo é obrigatório
- **RN003:** Período do processo deve sobrepor com período do contrato
- **RN004:** Matrícula deve estar ativa na data da sentença

---

## 🟢 **UC002 - CADASTRAR PROCESSO TIPO 2**
### *Trabalhador com vínculo formalizado, com alteração na data de admissão*

### **Diferenças em relação ao UC001:**

#### **Etapa 4 - Informações da Decisão (MODIFICADA):**
14. Sistema **predefine Tipo 2** no dropdown
15. Sistema exibe campos **EDITÁVEIS** específicos:
    - **Data de Admissão Original:** 01/01/2020 (readonly - referência)
    - **Data de Admissão:** ________ (**OBRIGATÓRIO** - nova data)
    - **CBO:** Campo **editável** (pode ter mudado)
    - **Natureza da Atividade:** Campo **editável**

#### **Validações Específicas:**
- **Nova data admissão** deve ser **ANTERIOR** à data original
- **CBO** deve ser válido na tabela oficial
- **Mudança categoria** obrigatória se categoria diferir

#### **Seção Adicional - Mudança de Categoria:**
16. Sistema exibe seção **"Mudança de Categoria/Atividade"**:
    - **Data da mudança:** (preenchida automaticamente = nova data admissão)
    - **Nova categoria:** (se aplicável)
    - **Nova natureza:** (se aplicável)
    - Botão **"+ Incluir mudança"** (para múltiplas mudanças)

#### **Impactos Automáticos:**
- Sistema **marca para retificação** o S-2200 original
- **Período do processo** inicia na nova data de admissão
- **Base de cálculo** deve considerar período ampliado

### **Regras de Negócio Específicas:**
- **RN005:** Nova data admissão obrigatória e anterior à original
- **RN006:** Sistema deve retificar S-2200 automaticamente após transmissão
- **RN007:** FGTS deve ser recalculado desde nova data

---

## 🟢 **UC003 - CADASTRAR PROCESSO TIPO 3**  
### *Trabalhador com vínculo formalizado, com inclusão/alteração de desligamento*

### **Diferenças em relação ao UC001:**

#### **Etapa 4 - Informações da Decisão (MODIFICADA):**
14. Sistema **predefine Tipo 3** no dropdown
15. Todos os dados contratuais permanecem **readonly**

#### **Seção "Informações de Desligamento" (OBRIGATÓRIA):**
16. Sistema exibe seção **obrigatória**:
    - **Data de Desligamento:** ________ (**OBRIGATÓRIO**)
    - **Código Motivo Desligamento:** ________ (**OBRIGATÓRIO**)  
    - **Data Projetada Término API:** ________ (condicional por motivo)

#### **Validações Específicas:**
- **Data desligamento** obrigatória e posterior à admissão
- **Motivo** deve ser código válido da tabela oficial
- **API** obrigatório para motivos específicos (ex: demissão sem justa causa)

#### **Cenários Específicos:**
- **C1:** Vínculo ativo → Primeira vez incluindo desligamento
- **C2:** Vínculo já desligado → Alterando data de desligamento
- **C3:** Reintegração → Cancelando desligamento anterior

### **Impactos Automáticos:**
- Sistema **ajusta fim do processo** para data de desligamento
- Se alteração: sistema **retifica S-2299** existente
- Se inclusão: sistema **gera novo S-2299**

### **Regras de Negócio Específicas:**
- **RN008:** Data e motivo de desligamento sempre obrigatórios
- **RN009:** Fim do processo não pode ser posterior ao desligamento
- **RN010:** Sistema gera/retifica S-2299 automaticamente

---

## 🟡 **UC004 - CADASTRAR PROCESSO TIPO 4**
### *Trabalhador com alteração nas datas de admissão E desligamento*

### **Complexidade:** ALTA - Combina UC002 + UC003

### **Etapa 4 - Informações da Decisão (COMPLEXA):**
- **Combina** todas as funcionalidades dos Tipos 2 e 3
- **Data admissão** editável (como Tipo 2)
- **Seção desligamento** obrigatória (como Tipo 3)
- **Seção mudança categoria** obrigatória

### **Validações Complexas:**
- **Sequência temporal:** Nova admissão < Desligamento < Admissão original
- **Múltiplas retificações:** S-2200 + S-2299
- **Período consistente:** Todo período reconhecido deve ser válido

### **Impactos no Sistema:**
- **Múltiplos XMLs:** Pode gerar até 3 eventos (S-2200, S-2299, S-2500)
- **Cálculos complexos:** Bases para período completo reconhecido
- **Validações cruzadas:** Entre múltiplas datas

---

## 🟡 **UC005 - CADASTRAR PROCESSO TIPO 5**
### *Empregado com reconhecimento de vínculo*

### **Diferenças Fundamentais:**

#### **Etapa 1 - Identificação (MODIFICADA):**
- Sistema **pode não encontrar** trabalhador na base eSocial
- **Cadastro manual** pode ser necessário
- **Não há vínculo anterior** para referenciar

#### **Etapa 2 - Dados do Trabalhador:**
- **Nome completo** (obrigatório, manual)
- **Data nascimento** (obrigatório, manual)
- **Dados pessoais** básicos (endereço, etc.)

#### **Etapa 4 - Informações da Decisão (COMPLETAMENTE DIFERENTE):**
14. Sistema **predefine Tipo 5**
15. **TODOS os campos são editáveis** (não há dados de referência):
    - **Categoria trabalhador:** Dropdown (apenas [1XX])
    - **Matrícula:** Campo livre (**deve começar com 'eSocial-JUD-'**)
    - **Data de Admissão:** Data reconhecida pelo processo
    - **CBO:** Seleção manual obrigatória
    - **Salário base:** Valor obrigatório
    - **Natureza atividade:** Manual (com auto-preenchimento por categoria)
    - **Tipo contrato:** Seleção obrigatória
    - **Regime trabalhista:** Seleção obrigatória
    - **Regime previdenciário:** Seleção obrigatória

#### **Seção Desligamento (OBRIGATÓRIA):**
- Como não há vínculo ativo, **desligamento é sempre obrigatório**
- **Data desligamento:** Obrigatório
- **Motivo:** Obrigatório

### **Fluxo de Geração Automática:**
23. Após finalizar, sistema **gera automaticamente**:
    - **S-2200:** Admissão retroativa
    - **S-2299:** Desligamento 
    - **S-2500:** Processo trabalhista principal

### **Regras Específicas:**
- **RN011:** Matrícula deve começar com 'eSocial-JUD-'
- **RN012:** Categoria deve ser [1XX] (empregado)
- **RN013:** Sistema gera 3 eventos coordenados
- **RN014:** Natureza auto-preenchida: Cat 104→Urbano, Cat 102→Rural

---

## 🟡 **UC006 - CADASTRAR PROCESSO TIPO 6**
### *TSVE - Trabalhador sem vínculo, sem reconhecimento*

### **Características Únicas:**
- **NÃO reconhece vínculo empregatício**
- **Apenas obrigações tributárias**
- **Pode ter ou não cadastro S-2300** anterior

### **Subcenários:**
- **UC006A:** TSVE sem cadastro no eSocial
- **UC006B:** TSVE com cadastro ativo
- **UC006C:** TSVE com cadastro encerrado

#### **Etapa 4 - Informações da Decisão (ESPECÍFICA TSVE):**
15. Campos específicos para TSVE:
    - **Categoria:** Restrita a categorias TSVE válidas
    - **Data início serviços:** Campo obrigatório
    - **Data término serviços:** Campo obrigatório  
    - **Valor dos serviços:** Campo obrigatório
    - **Matrícula TSVE:** Opcional (se já cadastrado)

### **Impactos:**
- **NÃO gera S-2200** (sem reconhecimento vínculo)
- **Pode referenciar S-2300** existente
- **Foco nos tributos** sobre valores pagos

---

## 🟡 **UC007 - CADASTRAR PROCESSO TIPO 7**
### *Trabalhador com vínculo em período anterior ao eSocial*

### **Complexidade:** MUITO ALTA

### **Cenário:**
- Vínculo existiu **antes da obrigatoriedade** eSocial
- Empresa **não declarou na época** 
- Processo se refere ao **período anterior**

### **Campos Específicos:**
- **Período de referência:** Anterior à obrigatoriedade
- **Justificativa:** Motivo da não declaração na época
- **Documentação:** Referências comprobatórias
- **Legislação aplicável:** Vigente no período

### **Validações Temporais:**
- Datas devem ser **anteriores** à obrigatoriedade eSocial
- Cálculos conforme **legislação da época**
- Documentação **comprobatória** obrigatória

---

## 🟡 **UC008 - CADASTRAR PROCESSO TIPO 8**
### *Responsabilidade indireta*

### **Complexidade:** MUITO ALTA

### **Cenário:**
- Trabalhador prestou serviço para **terceiro**
- Empregador tem **responsabilidade indireta** (solidária/subsidiária)
- **Múltiplos empregadores** envolvidos

### **Campos Específicos:**
- **Empregador direto:** Quem contratou originalmente
- **Empregador responsável:** Quem pagará (solidário/subsidiário)
- **Tipo responsabilidade:** Dropdown (solidária/subsidiária/sucessão)
- **Percentual:** Se responsabilidade parcial
- **Período específico:** Datas da responsabilidade

### **Relacionamentos Complexos:**
- **Múltiplas empresas** no mesmo processo
- **Cálculos proporcionais** de valores
- **Validações específicas** de responsabilidade

---

## 🟡 **UC009 - CADASTRAR PROCESSO TIPO 9**  
### *Trabalhador com contratos unificados (unicidade contratual)*

### **Complexidade:** MUITO ALTA

### **Cenário:**
- **Múltiplos contratos sucessivos** no eSocial
- Processo **reconhece continuidade** (contrato único)
- **Unificação de vínculos** em período único

#### **Etapa Específica - Seleção de Contratos:**
- Sistema lista **todos os contratos** do trabalhador
- Usuário **seleciona quais unificar**
- Sistema **valida sequência temporal**
- Sistema **calcula período unificado**

#### **Campos Específicos:**
- **Lista contratos:** Multiple selection
- **Período unificado:** Data início (primeiro) + Data fim (último)  
- **Categoria final:** Categoria resultante da unificação
- **Justificativa:** Motivo legal da unificação

#### **Validações Complexas:**
- Contratos devem ser **sequenciais ou sobrepostos**
- **Sem lacunas temporais** significativas
- **Mesmo empregador** em todos contratos
- **Categoria consistente** com último período

#### **Impactos no Sistema:**
- **Múltiplos S-2299:** Cancela desligamentos intermediários
- **S-2200 retificado:** Unifica todos os períodos
- **Recálculos:** FGTS e contribuições período total
- **Coordenação:** Múltiplas retificações simultâneas

---

## 📋 **UC010 - CADASTRAR TRIBUTOS S-2501**
### *Informações de tributos decorrentes de processo*

### **Pré-condições:**
- ✅ Processo S-2500 **transmitido e aceito**
- ✅ Trabalhador vinculado ao processo
- ✅ Período de apuração válido

### **Fluxo Principal:**

#### **Etapa 1: Seleção do Processo Base**
1. Sistema lista **processos S-2500 transmitidos**
2. Usuário **seleciona processo** específico
3. Sistema lista **trabalhadores** do processo
4. Usuário **seleciona trabalhador** para tributos

#### **Etapa 2: Períodos de Apuração**  
5. Sistema exibe **período do processo** (referência)
6. Usuário informa **período de apuração** (YYYY-MM)
7. Sistema **valida período** dentro do range do processo
8. Sistema permite **múltiplos períodos**

#### **Etapa 3: Valores dos Tributos**
9. Para cada período, usuário informa:
   - **Base cálculo previdenciária** (R$)
   - **Base cálculo FGTS** (R$) 
   - **Valor IRRF** (R$)
   - **Contribuições sociais** (R$)
   - **Contribuições terceiros** (R$)

#### **Etapa 4: Validação e Confirmação**
10. Sistema **valida valores** (não negativos, formato)
11. Sistema **calcula totais** por tipo
12. Sistema **exibe resumo** para confirmação
13. Sistema **salva S-2501** com status "Cadastrado"

### **Regras Específicas:**
- **RN015:** Só permite criar S-2501 após S-2500 aceito
- **RN016:** Período deve estar dentro do range do processo
- **RN017:** Valores devem ser não negativos
- **RN018:** Múltiplos S-2501 para mesmo processo/trabalhador permitidos

---

## 📋 **UC011 - VALIDAR E GERAR XML**
### *Validação final e geração dos XMLs dos eventos*

### **Pré-condições:**
- ✅ Processo cadastrado completo
- ✅ Todos os dados obrigatórios preenchidos
- ✅ Status "Cadastrado" ou "Validado"

### **Fluxo Principal:**

#### **Etapa 1: Validação Pré-Transmissão**
1. Sistema executa **engine de validação completa**
2. Sistema verifica **regras por tipo de contrato**
3. Sistema valida **consistência cruzada** de campos
4. Sistema gera **relatório de validação**:
   - ✅ **Itens válidos** (verde)
   - ❌ **Erros bloqueantes** (vermelho)
   - ⚠️ **Alertas** (amarelo)

#### **Etapa 2: Correção de Inconsistências**
5. Se houver erros: sistema **bloqueia prosseguimento**
6. Sistema exibe **detalhes dos erros** com sugestões
7. Usuário **corrige inconsistências**
8. Sistema **re-valida automaticamente**

#### **Etapa 3: Preview do XML**
9. Sistema **gera XML preview** conforme tipo
10. Sistema aplica **Factory pattern** específico
11. Sistema **valida contra XSD** oficial
12. Sistema exibe **XML formatado** para revisão

#### **Etapa 4: Confirmação e Geração**
13. Usuário confirma **geração definitiva**
14. Sistema **gera XML final** com numeração sequencial
15. Sistema **salva XML** no diretório configurado
16. Sistema **altera status** para "Pronto para Transmissão"
17. Sistema **registra log** de geração

### **Validações por Tipo:**
- **Tipo 1:** Validações básicas + consistência vínculo
- **Tipo 2:** + Validação data admissão anterior
- **Tipo 3:** + Validação desligamento obrigatório
- **Tipos 4-9:** Validações específicas complexas

---

## 📊 **MATRIZ DE DIFERENÇAS ENTRE TIPOS**

| Aspecto | T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 |
|---------|----|----|----|----|----|----|----|----|----| 
| **Busca Trabalhador** | eSocial | eSocial | eSocial | eSocial | Manual | Manual | Manual | Complexa | eSocial |
| **Dados Contratuais** | Readonly | Editáveis | Readonly | Editáveis | Manuais | Manuais | Manuais | Múltiplos | Múltiplos |
| **Data Admissão** | Readonly | **Editável** | Readonly | **Editável** | **Manual** | Manual | Manual | Complexa | **Unificada** |
| **Desligamento** | Opcional | Opcional | **Obrigatório** | **Obrigatório** | **Obrigatório** | **Obrigatório** | **Obrigatório** | Complexo | Complexo |
| **Eventos Gerados** | S-2500 | S-2500 + Ret | S-2500 + S-2299 | Múltiplos | S-2200+2299+2500 | S-2500 | S-2200+2299+2500 | Múltiplos | Múltiplos |
| **Complexidade UI** | Simples | Média | Média | Alta | Alta | Alta | Muito Alta | Muito Alta | Muito Alta |
| **Validações** | Básicas | Temporais | Desligamento | Múltiplas | Reconhecimento | TSVE | Históricas | Responsabilidade | Unificação |

---

## ⚙️ **REGRAS DE NEGÓCIO CONSOLIDADAS**

### **Regras Gerais (Todos os Tipos):**
- **RN001:** CPF deve ser válido (algoritmo + formato)
- **RN002:** Período processo deve ser consistente (início ≤ fim)
- **RN003:** Valores monetários não negativos
- **RN004:** Datas devem seguir sequência lógica
- **RN005:** Categoria trabalhador deve ser válida na tabela oficial

### **Regras por Tipo:**
- **RN010-RN019:** Tipo 1 (readonly, desligamento opcional)
- **RN020-RN029:** Tipo 2 (data admissão anterior, retificação)
- **RN030-RN039:** Tipo 3 (desligamento obrigatório)
- **RN040-RN049:** Tipo 4 (múltiplas validações temporais)
- **RN050-RN059:** Tipo 5 (matrícula eSocial-JUD-, categoria [1XX])
- **RN060-RN069:** Tipo 6 (TSVE, sem reconhecimento vínculo)
- **RN070-RN079:** Tipo 7 (período pré-eSocial, documentação)
- **RN080-RN089:** Tipo 8 (responsabilidade indireta, múltiplos empregadores)
- **RN090-RN099:** Tipo 9 (unicidade, contratos sequenciais)

---

## 🎯 **PRIORIZAÇÃO DE IMPLEMENTAÇÃO DOS CASOS DE USO**

### **Sprint 1 (4 semanas):** 
- **UC001:** Tipo 1 completo (cenário mais comum)
- **UC010:** S-2501 básico
- **UC011:** Validação e XML básico

### **Sprint 2 (3 semanas):**
- **UC002:** Tipo 2 (alteração admissão)
- **UC003:** Tipo 3 (inclusão desligamento)

### **Sprint 3 (3 semanas):**
- **UC004:** Tipo 4 (combinação T2+T3)
- Refinamentos e otimizações

### **Sprints Futuros:**
- **UC005-UC009:** Tipos complexos conforme demanda real
- Funcionalidades avançadas (S-2555, S-3500)

---

## ✅ **CRITÉRIOS DE ACEITE POR UC**

### **Para UC001-UC003 (Críticos):**
- ✅ Interface idêntica aos padrões eSocial Web
- ✅ Validações específicas funcionando 100%
- ✅ XML gerado válido contra XSD oficial
- ✅ Fluxos alternativos implementados
- ✅ Logs de auditoria completos

### **Para UC004-UC006 (Importantes):**
- ✅ Funcionalidade conforme especificação
- ✅ Integração com tipos básicos
- ✅ Testes automatizados completos
- ✅ Performance adequada (< 5s por operação)

### **Para UC007-UC009 (Futuros):**
- ✅ Análise detalhada caso a caso
- ✅ ROI positivo comprovado
- ✅ Demanda real identificada

---

**📋 Documento:** Casos de Uso Detalhados v1.0  
**🎯 Foco:** Diferenças específicas entre os 8 tipos de contrato  
**📅 Data:** Agosto 2025  
**✅ Status:** Especificação completa para desenvolvimento