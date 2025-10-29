# Tipo 04 - Alteração em Ambas as Datas - Requisitos Específicos

## Definição

**Tipo de Contrato 4**: Trabalhador com vínculo formalizado, com alteração nas datas de admissão e de desligamento.

Este tipo contempla situações onde o processo trabalhista reconhece que tanto a data de início quanto a data de término do trabalho são diferentes das registradas oficialmente no eSocial, exigindo correção simultânea de ambas as datas.

## Cenários de Aplicação

### Cenário Principal
Trabalhador possui vínculo já cadastrado no eSocial onde:
- Data de admissão original está incorreta
- Data de desligamento original também está incorreta
- Processo judicial reconhece período diferente de trabalho
- Necessário alterar ambas as datas simultaneamente

### Exemplos Práticos
- Contrato informal anterior à formalização com término diferente
- Erros sistemáticos nos registros de admissão e desligamento
- Reconhecimento de período de trabalho completamente diferente
- Correção de registros administrativos com múltiplos erros
- Períodos de experiência com datas incorretas no início e fim
- Reconhecimento judicial de período de trabalho divergente
- Unificação de contratos com datas originais incorretas

## Requisitos Específicos

### RF401 - Validação de Alterações Simultâneas
**Como** sistema  
**Quero** validar que ambas as alterações são necessárias e consistentes  
**Para que** seja confirmada a necessidade de mudança das duas datas

#### Critérios de Aceite:
- **CA401.1** - Sistema deve verificar vínculo existente no eSocial
- **CA401.2** - Deve validar que nova admissão é diferente da original
- **CA401.3** - Deve validar que novo desligamento é diferente do original
- **CA401.4** - Deve verificar consistência entre as duas novas datas
- **CA401.5** - Deve calcular novo período de trabalho efetivo

### RF402 - Campos para Nova Admissão
**Como** usuário do sistema  
**Quero** informar nova data de admissão e dados relacionados  
**Para que** seja registrado corretamente o início real do trabalho

#### Critérios de Aceite:
- **CA402.1** - Campo tpContr deve ser fixo = 4
- **CA402.2** - Campo indContr deve ser "S" (vínculo já cadastrado)
- **CA402.3** - Nova data admissão é obrigatória
- **CA402.4** - Deve exibir data original para comparação
- **CA402.5** - Categoria profissional pode ser diferente para nova data
- **CA402.6** - CBO pode ser adequado ao período real de início

### RF403 - Campos para Novo Desligamento
**Como** usuário do sistema  
**Quero** informar nova data de desligamento e dados relacionados  
**Para que** seja registrado corretamente o término real do trabalho

#### Critérios de Aceite:
- **CA403.1** - Nova data desligamento é obrigatória
- **CA403.2** - Novo motivo desligamento pode ser diferente
- **CA403.3** - Deve exibir dados originais para comparação
- **CA403.4** - Nova data deve ser posterior à nova admissão
- **CA403.5** - Informações de aviso prévio podem ser alteradas

### RF404 - Cálculos de Diferenças e Impactos
**Como** sistema  
**Quero** calcular todos os impactos das alterações simultâneas  
**Para que** sejam apresentadas informações completas ao usuário

#### Critérios de Aceite:
- **CA404.1** - Calcular diferença na data de admissão (dias/meses)
- **CA404.2** - Calcular diferença na data de desligamento (dias/meses)
- **CA404.3** - Calcular diferença no tempo total de serviço
- **CA404.4** - Comparar períodos: original vs novo
- **CA404.5** - Identificar sobreposições ou lacunas temporais
- **CA404.6** - Calcular impactos em verbas e tributos

### RF405 - Validações de Consistência Temporal
**Como** sistema  
**Quero** garantir consistência entre todas as datas informadas  
**Para que** sejam evitadas inconsistências lógicas

#### Critérios de Aceite:
- **CA405.1** - Nova admissão deve ser anterior ao novo desligamento
- **CA405.2** - Nova admissão deve ser posterior à data de nascimento
- **CA405.3** - Novo desligamento não pode ser futuro (exceto casos específicos)
- **CA405.4** - Período alterado não pode conflitar com outros vínculos
- **CA405.5** - Validar se empresa estava ativa em todo o novo período

## Regras de Negócio Específicas

### RN401 - Validação do Novo Período
- Nova data admissão DEVE ser anterior à nova data desligamento
- Período resultante deve ser logicamente consistente
- Não pode haver sobreposição com outros vínculos do trabalhador
- Empresa deve ter estado ativa durante todo o novo período

### RN402 - Impacto em Cálculos
- Alterações podem aumentar ou diminuir tempo de serviço
- Verbas rescisórias devem ser recalculadas integralmente
- Contribuições previdenciárias podem ser impactadas
- Período para cálculo de médias pode ser alterado

### RN403 - Consistência com Legislação
- Categoria e salário devem ser válidos em todo o novo período
- Regras trabalhistas vigentes devem ser respeitadas
- Alterações constitucionais no período devem ser consideradas
- Limites de idade para trabalho devem ser observados

### RN404 - Documentação Obrigatória
- Decisão judicial deve ser clara sobre ambas as datas
- Justificativas devem ser específicas para cada alteração
- Documentação probatória deve ser anexada
- Impactos calculados devem ser documentados

## Interface Específica

### Seção Comparativa de Datas
- **Período Original**: Admissão e desligamento do eSocial
- **Novo Período**: Datas determinadas judicialmente
- **Visualização Timeline**: Gráfico comparativo dos períodos
- **Diferenças Calculadas**: Resumo de alterações em dias/meses

### Seção Nova Admissão
- **Data nova admissão**: Campo obrigatório com validações
- **Diferença admissão**: Cálculo automático vs original
- **Categoria na admissão**: Pode diferir da registrada originalmente
- **CBO inicial**: Adequado ao período real de início
- **Salário inicial**: Conforme prática da época real

### Seção Novo Desligamento
- **Data novo desligamento**: Campo obrigatório
- **Diferença desligamento**: Cálculo automático vs original  
- **Novo motivo**: Pode diferir do motivo original
- **Aviso prévio**: Recalculado conforme nova situação
- **Circunstâncias**: Detalhes do término real

### Seção Análise de Impactos
- **Tempo de serviço**: Original vs novo período
- **Impacto financeiro**: Estimativa de diferenças em verbas
- **Eventos afetados**: Lista de possíveis conflitos
- **Recomendações**: Ações sugeridas pelo sistema

### Seção Justificativas
- **Fundamentação admissão**: Razões para alterar data inicial
- **Fundamentação desligamento**: Razões para alterar data final
- **Documentos anexos**: Comprovações das alterações
- **Observações gerais**: Campo livre para detalhes

## Cenários de Teste Específicos

### CT401 - Alteração Válida de Ambas Datas
**Dado que** vínculo original é "01/06/2023 a 31/12/2023"  
**E** processo determina período real "01/04/2023 a 15/01/2024"  
**Quando** seleciono tipo "4 - Alteração ambas datas"  
**E** informo nova admissão "01/04/2023" e novo desligamento "15/01/2024"  
**Então** sistema deve aceitar alterações  
**E** deve calcular: "+61 dias no início, +15 dias no final"  
**E** deve mostrar: "Período ampliado em 76 dias totais"

### CT402 - Nova Admissão Posterior ao Novo Desligamento
**Dado que** informei nova admissão "01/07/2023"  
**Quando** informo novo desligamento "30/06/2023" (anterior)  
**Então** sistema deve exibir erro "Desligamento deve ser posterior à admissão"  
**E** deve impedir prosseguimento  
**E** deve destacar inconsistência temporal

### CT403 - Redução Significativa de Período
**Dado que** período original era "01/01/2023 a 31/12/2023" (12 meses)  
**Quando** informo novo período "01/06/2023 a 31/07/2023" (2 meses)  
**Então** sistema deve calcular: "Redução de 10 meses"  
**E** deve alertar: "Redução significativa no tempo de serviço"  
**E** deve solicitar confirmação das datas

### CT404 - Conflito com Outro Vínculo
**Dado que** trabalhador teve outro vínculo "01/02/2023 a 31/05/2023"  
**Quando** informo nova admissão "15/04/2023" (sobrepõe)  
**Então** sistema deve alertar "Sobreposição com vínculo anterior"  
**E** deve mostrar período conflitante  
**E** deve solicitar confirmação ou correção

### CT405 - Empresa Inativa no Período
**Dado que** empresa esteve inativa entre "01/03/2023 e 30/04/2023"  
**Quando** informo nova admissão "15/03/2023"  
**Então** sistema deve alertar "Empresa estava inativa neste período"  
**E** deve sugerir verificação da data  
**E** deve permitir prosseguir com justificativa

## Validações Avançadas Específicas

### Validação Cruzada de Datas
- Verificar lógica temporal entre todas as datas
- Validar se alterações são mutuamente consistentes
- Checar se novo período é plausível
- Confirmar que justificativas cobrem ambas alterações

### Validação de Legislação por Todo Período
- Verificar regras trabalhistas no período completo
- Validar categorias profissionais em toda duração
- Checar alterações de salário mínimo
- Confirmar legislação previdenciária aplicável

### Validação de Empresa por Período Completo
- Confirmar atividade da empresa em todo período
- Verificar alterações de CNAE relevantes
- Validar existência de estabelecimentos
- Checar registros administrativos da época

### Cálculo de Impactos Complexos
- Recalcular verbas rescisórias integralmente
- Ajustar contribuições previdenciárias de todo período
- Recalcular médias salariais afetadas
- Estimar impactos fiscais das alterações

## Integração com eSocial

### Consultas Complexas Necessárias
- Histórico completo do trabalhador
- Todos os eventos relacionados ao vínculo
- Validação de períodos sobrepostos
- Verificação de eventos dependentes

### Impactos em Múltiplos Eventos
- **S-2200**: Dados originais de admissão
- **S-2299**: Dados originais de desligamento  
- **S-1200**: Todas as folhas do período
- **S-1210**: Pagamentos que podem ser afetados
- **S-2220/S-2230**: Afastamentos no período

### Recálculos Necessários
- Reprocessar todos os cálculos do período
- Ajustar totalizadores acumulados
- Recalcular médias e proporcionais
- Atualizar bases de cálculo de tributos

## Considerações Especiais

### Complexidade Operacional
- Alterações simultâneas têm maior risco de erro
- Requer validação mais rigorosa
- Necessita aprovação de nível superior
- Demanda documentação mais detalhada

### Aspectos Legais Específicos
- Decisão judicial deve ser expressa sobre ambas datas
- Fundamentação legal deve ser robusta
- Efeitos retroativos devem ser considerados
- Prazos prescricionais são críticos

### Aspectos Técnicos Avançados
- Reprocessamento completo de cálculos
- Verificação de dependências complexas
- Sincronização com múltiplos sistemas
- Backup de dados antes das alterações

### Fluxo de Aprovação Diferenciado
- Validação jurídica obrigatória para ambas alterações
- Aprovação de gerência/diretoria
- Revisão de impactos financeiros
- Comunicação formal a todos interessados

### Monitoramento Pós-Alteração
- Acompanhar processamento no eSocial
- Verificar retornos governamentais
- Monitorar impactos em sistemas integrados
- Validar correção de cálculos dependentes
