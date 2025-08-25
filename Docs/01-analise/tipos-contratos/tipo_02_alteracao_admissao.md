# Tipo 02 - Alteração na Data de Admissão - Requisitos Específicos

## Definição

**Tipo de Contrato 2**: Trabalhador com vínculo formalizado, com alteração na data de admissão.

Este tipo contempla situações onde o processo trabalhista reconhece que a data real de início do trabalho é anterior à data oficialmente registrada no eSocial, mantendo a data de desligamento inalterada.

## Cenários de Aplicação

### Cenário Principal
Trabalhador possui vínculo já cadastrado no eSocial onde:
- Data de admissão original está incorreta (posterior à real)
- Processo judicial reconhece início anterior do trabalho  
- Data de desligamento permanece inalterada
- Necessário retroagir data de admissão

### Exemplos Práticos
- Período de experiência não registrado adequadamente
- Trabalho iniciado antes da formalização contratual
- Erro na data de admissão original
- Reconhecimento de período probatório anterior
- Antecipação da data de início por decisão judicial
- Correção de registros administrativos incorretos

## Requisitos Específicos

### RF201 - Validação de Vínculo com Alteração de Admissão
**Como** sistema  
**Quero** validar que alteração de admissão é procedente  
**Para que** seja confirmada necessidade e viabilidade da alteração

#### Critérios de Aceite:
- **CA201.1** - Sistema deve verificar existência de evento S-2200 original
- **CA201.2** - Nova data admissão deve ser anterior à original
- **CA201.3** - Nova data deve ser posterior à data de nascimento
- **CA201.4** - Nova data não pode ser posterior à data atual
- **CA201.5** - Deve validar se nova data não conflita com outros vínculos do trabalhador

### RF202 - Campos Específicos para Alteração de Admissão
**Como** usuário do sistema  
**Quero** informar nova data de admissão e dados relacionados  
**Para que** seja registrada corretamente a alteração determinada

#### Critérios de Aceite:
- **CA202.1** - Campo tpContr deve ser fixo = 2
- **CA202.2** - Campo indContr deve ser "S" (vínculo já cadastrado)
- **CA202.3** - Campo dtAdm (nova data admissão) é obrigatório
- **CA202.4** - Deve exibir data original para comparação
- **CA202.5** - Deve calcular e exibir diferença em dias/meses
- **CA202.6** - Campo matricula deve corresponder ao eSocial original

### RF203 - Informações Contratuais da Nova Admissão
**Como** usuário do sistema  
**Quero** informar dados contratuais válidos para nova data  
**Para que** sejam registradas informações consistentes com período anterior

#### Critérios de Aceite:
- **CA203.1** - Categoria profissional pode ser diferente da original
- **CA203.2** - Salário inicial pode ser informado para nova data
- **CA203.3** - CBO pode ser diferente do período posterior
- **CA203.4** - Regime trabalhista pode ser alterado se necessário
- **CA203.5** - Natureza da atividade (urbano/rural) pode ser diferente
- **CA203.6** - Tipo de contrato (determinado/indeterminado) pode ser alterado

### RF204 - Validações Específicas de Período
**Como** sistema  
**Quero** validar consistência temporal dos dados  
**Para que** sejam evitadas inconsistências entre períodos

#### Critérios de Aceite:
- **CA204.1** - Nova admissão não pode ser posterior à original
- **CA204.2** - Período adicionado não pode sobrepor outros vínculos
- **CA204.3** - Deve validar se empresa estava ativa na nova data
- **CA204.4** - Deve verificar se categorias eram válidas no período
- **CA204.5** - Deve validar legislação trabalhista vigente na época

### RF205 - Cálculo de Diferenças e Impactos
**Como** sistema  
**Quero** calcular impactos da alteração de data  
**Para que** sejam apresentadas informações relevantes ao usuário

#### Critérios de Aceite:
- **CA205.1** - Deve calcular diferença em dias corridos
- **CA205.2** - Deve calcular diferença em dias úteis
- **CA205.3** - Deve identificar feriados no período adicionado
- **CA205.4** - Deve calcular impacto em tempo de serviço
- **CA205.5** - Deve alertar sobre possíveis impactos tributários
- **CA205.6** - Deve sugerir revisão de eventos periódicos afetados

## Regras de Negócio Específicas

### RN201 - Validação Temporal
- Nova data de admissão DEVE ser anterior à data original
- Diferença máxima não pode exceder limites regulamentares
- Nova data não pode coincidir com outros vínculos ativos
- Período adicionado deve ser justificável juridicamente

### RN202 - Consistência Contratual
- Dados contratuais da nova data podem diferir dos originais
- Alterações devem ser consistentes com prática da época
- Categoria e salário devem ser compatíveis com mercado do período
- Regime trabalhista deve obedecer legislação vigente

### RN203 - Impacto em Outros Eventos
- Alteração pode impactar eventos S-1200 (folha)
- Pode afetar cálculo de FGTS e INSS retroativo
- Pode gerar necessidade de retificação de eventos periódicos
- Sistema deve alertar sobre possíveis impactos

### RN204 - Documentação Obrigatória
- Alteração deve ser sempre justificada legalmente
- Processo judicial deve determinar explicitamente a nova data
- Documentação de suporte deve ser preservada
- Histórico da alteração deve ser mantido permanentemente

## Interface Específica

### Seção Principal - Alteração de Admissão
- **Data original**: Campo somente leitura com data do eSocial
- **Nova data admissão**: Campo obrigatório, anterior à original
- **Diferença**: Cálculo automático em dias/meses
- **Justificativa**: Campo texto obrigatório para fundamentação legal

### Seção Dados Contratuais da Nova Data
- **Categoria profissional**: Lista ajustada ao período
- **CBO**: Código válido na época da nova admissão  
- **Salário**: Valor compatível com mercado da época
- **Regime trabalhista**: Conforme legislação vigente
- **Tipo contrato**: Determinado/indeterminado
- **Natureza atividade**: Urbano/rural

### Seção Validações e Alertas
- **Status de validação**: Indicadores visuais
- **Conflitos identificados**: Lista de possíveis problemas
- **Impactos calculados**: Resumo de consequências
- **Sugestões de ação**: Recomendações automáticas

### Seção Comparativa
- **Linha do tempo**: Visualização gráfica das datas
- **Tabela comparativa**: Antes vs depois da alteração
- **Período adicionado**: Destaque do tempo acrescentado

## Cenários de Teste Específicos

### CT201 - Alteração Válida de Admissão
**Dado que** trabalhador tem admissão original em "01/06/2023"  
**E** processo determina início real em "01/04/2023"  
**Quando** seleciono tipo "2 - Alteração admissão"  
**E** informo nova data "01/04/2023"  
**Então** sistema deve aceitar alteração  
**E** deve calcular diferença de 61 dias  
**E** deve permitir informar dados contratuais do período anterior

### CT202 - Nova Data Posterior à Original
**Dado que** data original é "01/06/2023"  
**Quando** tento informar nova data "01/07/2023" (posterior)  
**Então** sistema deve exibir erro "Nova admissão deve ser anterior à original"  
**E** deve impedir prosseguimento  
**E** deve manter foco no campo de data

### CT203 - Conflito com Outro Vínculo
**Dado que** trabalhador teve vínculo anterior encerrado em "31/03/2023"  
**Quando** informo nova admissão "15/03/2023"  
**Então** sistema deve alertar "Possível sobreposição com vínculo anterior"  
**E** deve solicitar confirmação  
**E** deve permitir prosseguir após confirmação

### CT204 - Validação de Categoria por Período
**Dado que** categoria "Menor Aprendiz" só era válida após 2022  
**Quando** informo nova admissão em "01/01/2021"  
**E** seleciono categoria "Menor Aprendiz"  
**Então** sistema deve alertar "Categoria não era válida neste período"  
**E** deve sugerir categorias válidas para a data

### CT205 - Cálculo de Impactos
**Dado que** alterei admissão antecipando 90 dias  
**Quando** sistema processa a alteração  
**Então** deve calcular: "90 dias corridos adicionados"  
**E** deve mostrar: "Aproximadamente 3 meses de diferença"  
**E** deve alertar: "Possível impacto em FGTS e INSS retroativo"  
**E** deve sugerir: "Revisar eventos de folha do período"

## Validações Avançadas

### Validação de Legislação por Período
- Verificar se categoria era permitida na data
- Validar salário mínimo vigente na época
- Confirmar regras trabalhistas aplicáveis
- Checar alterações constitucionais relevantes

### Validação de Empresa por Período
- Confirmar se empresa estava ativa na nova data
- Verificar se CNAE permitia a atividade
- Validar se estabelecimento existia
- Checar registros na Junta Comercial

### Validação de Trabalhador por Período
- Confirmar idade mínima para trabalho
- Verificar se poderia exercer a função
- Validar situação de menor (se aplicável)
- Checar restrições específicas da categoria

## Integração com eSocial

### Consultas Adicionais Necessárias
- Histórico completo de vínculos do trabalhador
- Eventos relacionados no período original
- Tabelas vigentes na nova data de admissão
- Validações específicas por competência

### Impactos em Outros Eventos
- **S-1200**: Possível necessidade de retificação
- **S-1210**: Ajustes em pagamentos retroativos
- **S-2220**: Possível impacto em afastamentos
- **S-2230**: Verificação de afastamentos no novo período

### Alertas para Usuário
- Listagem de eventos que podem precisar retificação
- Sugestão de ordem para correções
- Identificação de prazos legais a observar
- Recomendações de documentação adicional

## Considerações Especiais

### Aspectos Legais
- Alteração deve sempre ter fundamentação judicial
- Documentos de suporte devem ser arquivados
- Prescrição de direitos deve ser considerada
- Efeitos fiscais devem ser avaliados

### Aspectos Técnicos
- Recálculo automático de médias e proporções
- Ajuste em totalizadores acumulados
- Reprocessamento de cálculos dependentes
- Sincronização com sistemas integrados

### Aspectos Operacionais
- Treinamento específico para usuários
- Procedimentos de aprovação diferenciados
- Controles adicionais de auditoria
- Documentação obrigatória de processos
