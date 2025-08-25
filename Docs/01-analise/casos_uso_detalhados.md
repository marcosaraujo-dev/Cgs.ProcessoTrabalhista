# Casos de Uso Detalhados - Sistema eSocial Processos Trabalhistas

## Visão Geral

Este documento apresenta os casos de uso detalhados do sistema de processos trabalhistas do eSocial, organizados por atores e funcionalidades principais.

## Atores do Sistema

### Ator Primário: Usuário Operacional
- **Descrição**: Responsável pelo cadastro diário dos processos e tributos
- **Responsabilidades**: 
  - Cadastrar processos judiciais
  - Vincular trabalhadores aos processos
  - Registrar tributos decorrentes
  - Gerar XMLs preliminares

### Ator Secundário: Supervisor/Coordenador
- **Descrição**: Responsável pela validação e aprovação dos dados
- **Responsabilidades**:
  - Validar dados antes do envio
  - Aprovar transmissões para eSocial
  - Gerenciar usuários do sistema
  - Acompanhar status dos processos

### Ator Secundário: Auditor/Consultor
- **Descrição**: Responsável pela análise e conferência dos dados
- **Responsabilidades**:
  - Analisar histórico de alterações
  - Conferir cálculos de tributos
  - Gerar relatórios de controle
  - Identificar inconsistências

### Ator Externo: eSocial
- **Descrição**: Sistema governamental receptor dos eventos
- **Responsabilidades**:
  - Receber eventos XML
  - Validar informações
  - Retornar protocolo de recebimento
  - Processar dados no ambiente governamental

## Casos de Uso Principais

### UC001 - Cadastrar Processo Judicial

**Ator Principal**: Usuário Operacional  
**Objetivo**: Registrar informações básicas de um processo judicial trabalhista

#### Pré-condições:
- Usuário autenticado no sistema
- Possui permissão para cadastro de processos
- Dados da sentença judicial disponíveis

#### Fluxo Principal:
1. Usuário acessa funcionalidade "Cadastro de Processo Judicial"
2. Sistema exibe formulário de cadastro
3. Usuário informa número do processo (formato judicial)
4. Sistema valida formato e unicidade do número
5. Usuário informa dados do empregador (CNPJ/CPF)
6. Sistema oferece busca automática ou cadastro manual
7. Usuário informa dados específicos da sentença:
   - Data da sentença
   - UF da Vara
   - Código do município (IBGE)
   - Identificação da Vara
8. Usuário informa dados do responsável indireto (se aplicável)
9. Usuário adiciona observações relevantes
10. Sistema valida todas as informações
11. Usuário confirma cadastro
12. Sistema gera ID único e salva processo
13. Sistema exibe confirmação com ID gerado

#### Fluxos Alternativos:

**FA001 - Processo já existente**
- No passo 4, se número já existe:
  - Sistema exibe mensagem de erro
  - Oferece opção de consultar processo existente
  - Retorna ao passo 3

**FA002 - Busca empresa por CNPJ**
- No passo 6, se usuário opta por busca:
  - Sistema abre modal de busca
  - Usuário informa CNPJ
  - Sistema busca na base integrada
  - Se encontrado, preenche dados automaticamente
  - Se não encontrado, permite cadastro manual

**FA003 - Dados de município inválidos**  
- No passo 7, se código IBGE inválido:
  - Sistema exibe erro de validação
  - Oferece busca por nome do município
  - Permite seleção da lista
  - Retorna ao passo 7

#### Pós-condições:
- Processo cadastrado com status "Ativo"
- ID único gerado e disponível para vinculação
- Log de auditoria registrado
- Processo disponível para vinculação de trabalhadores

---

### UC002 - Vincular Trabalhador ao Processo

**Ator Principal**: Usuário Operacional  
**Objetivo**: Associar trabalhador ao processo e definir informações contratuais

#### Pré-condições:
- Processo judicial cadastrado e ativo
- Dados do trabalhador disponíveis (CPF mínimo)
- Informações do contrato de trabalho conhecidas

#### Fluxo Principal:
1. Usuário acessa "Cadastro de Processo Trabalhista"
2. Sistema exibe lista de processos ativos
3. Usuário seleciona processo judicial
4. Sistema carrega dados do processo selecionado
5. Sistema exibe opção "Adicionar Trabalhador"
6. Usuário informa CPF do trabalhador
7. Sistema valida CPF e busca na base integrada
8. Sistema exibe dados encontrados ou permite cadastro manual
9. Usuário seleciona tipo de contrato aplicável (1 a 9)
10. Sistema exibe campos específicos do tipo escolhido
11. Usuário preenche informações contratuais obrigatórias:
    - Matrícula
    - Categoria profissional
    - Data de admissão original
    - CBO
    - Regime trabalhista
12. Usuário preenche informações específicas conforme tipo:
    - Alterações de datas (tipos 2, 3, 4)
    - Dados de reconhecimento (tipo 5)
    - Informações TSVE (tipo 6)
    - Dados período pré-eSocial (tipo 7)
    - Sucessão/unicidade (tipos 8, 9)
13. Sistema valida consistência dos dados
14. Usuário confirma vinculação
15. Sistema salva trabalhador vinculado ao processo
16. Sistema exibe opção de adicionar outro trabalhador

#### Fluxos Alternativos:

**FA001 - CPF já vinculado ao processo**
- No passo 7, se CPF já existe no processo:
  - Sistema exibe erro "Trabalhador já vinculado"
  - Oferece opção de editar dados existentes
  - Retorna ao passo 6

**FA002 - Trabalhador não encontrado na base**
- No passo 8, se busca não retorna resultado:
  - Sistema solicita cadastro manual
  - Usuário informa nome completo
  - Usuário informa data de nascimento
  - Sistema valida dados básicos
  - Prossegue para passo 9

**FA003 - Validação de tipo de contrato**
- No passo 13, se dados inconsistentes com tipo:
  - Sistema exibe erros específicos
  - Destaca campos problemáticos
  - Oferece sugestões de correção
  - Retorna ao passo apropriado

#### Pós-condições:
- Trabalhador vinculado ao processo
- Dados contratuais registrados
- Processo pronto para cadastro de tributos
- Log de auditoria atualizado

---

### UC003 - Cadastrar Tributos Decorrentes

**Ator Principal**: Usuário Operacional  
**Objetivo**: Registrar tributos e contribuições decorrentes do processo trabalhista

#### Pré-condições:
- Processo com trabalhador(es) vinculado(s)
- Informações de remuneração e bases disponíveis
- Período de apuração definido

#### Fluxo Principal:
1. Usuário acessa "Cadastro de Tributos"
2. Sistema exibe processos com trabalhadores vinculados
3. Usuário seleciona processo e trabalhador específico
4. Sistema carrega dados contratuais do trabalhador
5. Usuário informa período de apuração (AAAA-MM)
6. Sistema valida se período está dentro do contrato
7. Usuário informa valores de remuneração:
   - Remuneração fixa
   - Remuneração variável
   - 13º salário
   - Férias e rescisórias
8. Sistema calcula bases de cálculo automaticamente
9. Usuário confirma ou ajusta bases calculadas:
   - Base INSS empregado/empregador
   - Base FGTS (8% + multas)
   - Base IRRF
   - Base contribuições terceiros
10. Sistema aplica alíquotas vigentes no período
11. Sistema calcula valores de tributos
12. Usuário revisa cálculos apresentados
13. Sistema permite ajustes manuais se necessário
14. Usuário informa códigos de receita específicos
15. Usuário adiciona observações sobre cálculos
16. Sistema valida consistência geral
17. Usuário confirma cadastro dos tributos
18. Sistema salva informações com versionamento

#### Fluxos Alternativos:

**FA001 - Período já possui tributos**
- No passo 6, se período já cadastrado:
  - Sistema exibe alerta
  - Oferece opção de editar existente
  - Permite criar nova versão
  - Usuário decide como proceder

**FA002 - Valores excedem limites legais**
- No passo 11, se cálculo excede tetos:
  - Sistema aplica limitação automaticamente
  - Exibe alerta sobre aplicação do teto
  - Mostra valores antes/depois da limitação
  - Prossegue normalmente

**FA003 - Múltiplos períodos**
- Após passo 18, usuário pode:
  - Adicionar outro período
  - Copiar dados do período atual
  - Sistema sugere ajustes por período
  - Processo se repete para novo período

#### Pós-condições:
- Tributos cadastrados e calculados
- Bases validadas e consistentes
- Processo pronto para geração XML
- Histórico de cálculos preservado

---

### UC004 - Gerar XML para Envio

**Ator Principal**: Usuário Operacional  
**Objetivo**: Gerar arquivos XML dos eventos eSocial para envio

#### Pré-condições:
- Processo completo (judicial + trabalhador + tributos)
- Dados validados e consistentes
- Sistema configurado com certificados

#### Fluxo Principal:
1. Usuário acessa "Geração de XMLs"
2. Sistema exibe processos prontos para envio
3. Usuário seleciona processo(s) desejado(s)
4. Sistema exibe resumo dos dados a serem enviados
5. Usuário escolhe tipos de evento a gerar:
   - S-2500 (Processo Trabalhista)
   - S-2501 (Tributos Decorrentes)
6. Sistema executa validações finais pré-envio:
   - Regras de negócio eSocial
   - Consistência entre eventos
   - Campos obrigatórios
   - Formatos e tamanhos
7. Sistema exibe resultado das validações
8. Se válido, usuário confirma geração
9. Sistema gera XMLs conforme leiaute eSocial
10. Sistema aplica assinatura digital
11. Sistema salva XMLs em diretório configurado
12. Sistema atualiza status do processo
13. Sistema exibe confirmação com localização dos arquivos

#### Fluxos Alternativos:

**FA001 - Validações com erro**
- No passo 7, se validação falha:
  - Sistema exibe lista detalhada de erros
  - Oferece navegação direta aos campos problemáticos
  - Usuário corrige dados
  - Retorna ao passo 6 para nova validação

**FA002 - Geração de XML único**
- No passo 5, se selecionado apenas um tipo:
  - Sistema gera apenas evento selecionado
  - Aplica validações específicas do evento
  - Prossegue normalmente

**FA003 - Problema na assinatura**
- No passo 10, se certificado inválido:
  - Sistema exibe erro de certificado
  - Oferece reconfiguração
  - Permite geração sem assinatura (teste)
  - Usuário decide como proceder

#### Pós-condições:
- XMLs gerados e validados
- Arquivos salvos em local adequado
- Status atualizado para "Pronto para Envio"
- Log de geração registrado

---

### UC005 - Validar Dados Completos

**Ator Principal**: Supervisor/Coordenador  
**Objetivo**: Executar validação final antes do envio aos órgãos

#### Pré-condições:
- Processo com XMLs gerados
- Usuário com perfil de supervisor
- Dados ainda não transmitidos

#### Fluxo Principal:
1. Supervisor acessa "Validação Final"
2. Sistema exibe processos aguardando validação
3. Supervisor seleciona processo para análise
4. Sistema exibe painel completo com:
   - Dados do processo judicial
   - Trabalhadores vinculados
   - Tributos calculados
   - XMLs gerados
5. Supervisor executa validação automática completa
6. Sistema executa bateria de testes:
   - Regras específicas por tipo de contrato
   - Consistência entre dados e cálculos
   - Validação cruzada entre eventos
   - Conformidade com leiautes eSocial
7. Sistema apresenta relatório de validação
8. Supervisor analisa manualmente dados críticos
9. Supervisor pode solicitar correções se necessário
10. Supervisor aprova ou rejeita para envio
11. Sistema atualiza status conforme decisão
12. Se aprovado, libera para transmissão

#### Fluxos Alternativos:

**FA001 - Validação com pendências**
- No passo 7, se existem pendências:
  - Sistema destaca itens problemáticos
  - Oferece relatório detalhado
  - Supervisor pode aprovar com ressalvas
  - Ou pode rejeitar para correção

**FA002 - Solicitação de correção**
- No passo 10, se supervisor rejeita:
  - Sistema solicita justificativa
  - Status volta para "Em Correção"
  - Notifica usuário operacional
  - Processo retorna para edição

#### Pós-condições:
- Processo validado e aprovado
- Status atualizado para "Aprovado"
- Pronto para transmissão oficial
- Histórico de validação preservado

---

### UC006 - Consultar Status de Processos

**Ator Principal**: Qualquer usuário autenticado  
**Objetivo**: Acompanhar situação atual dos processos no sistema

#### Pré-condições:
- Usuário autenticado
- Processos cadastrados no sistema

#### Fluxo Principal:
1. Usuário acessa "Consulta de Processos"
2. Sistema exibe filtros disponíveis:
   - Status do processo
   - Período de cadastro
   - Número do processo
   - CNPJ do empregador
   - CPF do trabalhador
3. Usuário aplica filtros desejados
4. Sistema apresenta lista de processos
5. Para cada processo exibe:
   - Número e data
   - Empregador
   - Status atual
   - Quantidade de trabalhadores
   - Data última atualização
6. Usuário pode selecionar processo para detalhes
7. Sistema exibe informações completas:
   - Timeline de alterações
   - Dados cadastrais
   - Status de validações
   - XMLs gerados
   - Histórico de transmissões

#### Fluxos Alternativos:

**FA001 - Busca sem resultados**
- No passo 4, se filtros não retornam dados:
  - Sistema exibe mensagem apropriada
  - Oferece limpar filtros
  - Sugere ampliação dos critérios

**FA002 - Exportação de dados**
- No passo 5, usuário pode:
  - Exportar lista para Excel
  - Gerar relatório PDF
  - Sistema processa solicitação
  - Oferece download do arquivo

#### Pós-condições:
- Usuário informado sobre status
- Decisões podem ser tomadas baseadas nos dados
- Histórico consultado conforme necessidade

## Casos de Uso da Fase 2

### UC007 - Solicitar Consolidação (S-2555)

**Ator Principal**: Usuário Operacional  
**Objetivo**: Gerar evento de consolidação para múltiplos S-2501 do mesmo processo

#### Pré-condições:
- Múltiplos S-2501 enviados para mesmo processo/período
- Necessidade de totalização identificada

#### Fluxo Principal:
1. Usuário identifica necessidade de consolidação
2. Sistema lista S-2501 elegíveis para consolidação
3. Usuário seleciona eventos a consolidar
4. Sistema calcula totais consolidados
5. Sistema gera XML S-2555
6. Evento é transmitido ao eSocial

### UC008 - Solicitar Exclusão de Eventos (S-3500)

**Ator Principal**: Usuário Operacional  
**Objetivo**: Cancelar eventos S-2500 ou S-2501 enviados incorretamente

#### Pré-condições:
- Evento anteriormente enviado e processado
- Necessidade de exclusão identificada

#### Fluxo Principal:
1. Usuário identifica evento a excluir
2. Sistema valida se exclusão é possível
3. Usuário confirma exclusão com justificativa
4. Sistema gera XML S-3500
5. Status do evento original é atualizado

## Considerações Gerais

### Tratamento de Erros
- Todos os casos de uso devem tratar adequadamente situações de erro
- Mensagens devem ser claras e orientar correções
- Sistema deve manter consistência mesmo com falhas

### Auditoria e Rastreabilidade
- Todas as operações são registradas para auditoria
- Usuários e timestamps são preservados
- Histórico de alterações é mantido indefinidamente

### Performance e Usabilidade
- Interface responsiva e intuitiva
- Validações em tempo real quando possível
- Feedback visual apropriado para operações longas
- Funcionalidades de busca e filtro eficientes

### Integração e Compatibilidade
- Dados integrados com sistemas externos quando disponível
- XMLs compatíveis com versão vigente do eSocial
- Configurações flexíveis para diferentes ambientes
