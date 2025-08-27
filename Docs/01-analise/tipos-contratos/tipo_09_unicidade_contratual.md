# Tipo 09 - Unicidade Contratual - Requisitos Específicos

## Definição

**Tipo de Contrato 9**: Unicidade contratual - Trabalhador cujos contratos foram unificados.

Este tipo contempla situações onde o processo trabalhista determina a unificação de múltiplos contratos/vínculos de um mesmo trabalhador com o mesmo empregador, reconhecendo que na realidade existiu apenas um contrato contínuo, eliminando soluções artificiais de continuidade.

## Conceito de Unicidade Contratual

### Definição Jurídica
Princípio trabalhista que reconhece como único e contínuo o contrato de trabalho quando há:
- **Mesmo empregador e mesmo empregado**
- **Mesma função ou funções conexas**
- **Intervalos artificiais entre contratos**
- **Continuidade da prestação de serviços**
- **Tentativa de burla à legislação trabalhista**

### Fundamentos Legais
- Art. 3º da CLT (continuidade da relação)
- Princípio da primazia da realidade
- Súmula 212 do TST (despedimento obstativo)
- Art. 452 da CLT (contrato por prazo determinado)

## Cenários de Aplicação

### Cenário Principal - Contratos Sucessivos
Trabalhador teve múltiplos contratos com intervalos artificiais:
- Contrato 1: 01/01/2020 a 30/06/2020
- Intervalo: 01/07/2020 a 15/07/2020 (15 dias)
- Contrato 2: 16/07/2020 a 31/12/2020
- Processo reconhece contrato único: 01/01/2020 a 31/12/2020

### Cenário Burla de Estabilidade
Contratos interrompidos para evitar direitos:
- Tentativa de evitar estabilidade pré-aposentadoria
- Burla à garantia de emprego da gestante
- Fraude aos limites de contrato determinado
- Elisão de direitos por tempo de serviço

### Cenário Terceirização Sucessiva
Trabalhador alternando entre tomadora e terceirizada:
- Período na empresa terceirizada
- Período contratado diretamente pela tomadora  
- Retorno à terceirizada
- Justiça reconhece vínculo único com tomadora

### Exemplos Práticos
- Professor com contratos semestrais sucessivos
- Trabalhador rural com contratos por safra
- Funcionário com intervalos para burlar estabilidade
- Terceirizado que alternou entre empresas do grupo
- Contratado como PJ e depois como CLT no mesmo período
- Múltiplas matrículas para mesma função

## Requisitos Específicos

### RF901 - Identificação dos Contratos a Unificar
**Como** sistema  
**Quero** identificar todos os contratos que serão unificados  
**Para que** seja possível criar vínculo único correto

#### Critérios de Aceite:
- **CA901.1** - Sistema deve permitir selecionar múltiplos contratos do trabalhador
- **CA901.2** - Deve validar que contratos são do mesmo empregador
- **CA901.3** - Deve verificar que há continuidade temporal ou proximidade
- **CA901.4** - Deve identificar intervalos entre contratos
- **CA901.5** - Deve validar que funções são compatíveis/conexas
- **CA901.6** - Sistema deve validar que contratos são cronologicamente consecutivos
- **CA901.7** - Deve calcular gaps temporais entre todos os contratos
- **CA901.8** - Deve alertar se algum contrato não é elegível para unificação

### RF902 - Definição do Contrato Unificado
**Como** usuário do sistema  
**Quero** definir características do contrato único resultante  
**Para que** sejam estabelecidos parâmetros corretos da unificação

#### Critérios de Aceite:
- **CA902.1** - Campo tpContr deve ser fixo = 9
- **CA902.2** - Campo indContr depende se já existe vínculo único
- **CA902.3** - Data admissão é a do primeiro contrato da série
- **CA902.4** - Data desligamento é a do último contrato (se encerrado)
- **CA902.5** - Matrícula unificada deve ser informada/gerada
- **CA902.6** - Categoria profissional predominante ou final
- **CA902.7** - Sistema deve validar sobreposição temporal entre contratos selecionados
- **CA902.8** - Deve calcular período total unificado automaticamente
- **CA902.9** - Deve validar que nova data fim ≥ nova data início

### RF903 - Mapeamento dos Contratos Originais
**Como** usuário do sistema  
**Quero** registrar detalhes de cada contrato original  
**Para que** seja preservado histórico completo da situação

#### Critérios de Aceite:
- **CA903.1** - Listar todos os contratos que estão sendo unificados
- **CA903.2** - Para cada contrato: matrícula, período, função, salário
- **CA903.3** - Identificar intervalos entre contratos e suas durações
- **CA903.4** - Registrar motivos de desligamento originais
- **CA903.5** - Documentar tentativas de burla identificadas
- **CA903.6** - Manter referência aos eventos eSocial originais
- **CA903.7** - Sistema deve calcular automaticamente duração de cada intervalo
- **CA903.8** - Deve identificar contratos com sobreposição temporal
- **CA903.9** - Deve mapear todas as matrículas envolvidas

### RF904 - Análise de Intervalos e Continuidade
**Como** sistema  
**Quero** analisar intervalos entre contratos para validar unificação  
**Para que** seja confirmada artificialidade das interrupções

#### Critérios de Aceite:
- **CA904.1** - Calcular duração de cada intervalo entre contratos
- **CA904.2** - Identificar padrões suspeitos (intervalos muito curtos)
- **CA904.3** - Verificar se houve prestação de serviços nos intervalos
- **CA904.4** - Analisar compatibilidade de funções entre contratos
- **CA904.5** - Detectar tentativas de elisão de direitos
- **CA904.6** - Alertar para situações que sugerem fraude
- **CA904.7** - Sistema deve validar que intervalos são ≤ 90 dias (configurável)
- **CA904.8** - Deve alertar se intervalo muito longo questiona continuidade
- **CA904.9** - Deve sugerir exclusão de contratos com gaps muito grandes

### RF905 - Validação de Sobreposição Temporal
**Como** sistema
**Quero** verificar sobreposições temporais inadequadas
**Para** que seja garantida lógica temporal da unificação

#### Critérios de Aceite:

**CA905.1** - Sistema deve detectar automaticamente sobreposições entre contratos
**CA905.2** - Deve alertar se dois contratos têm períodos simultâneos
**CA905.3** - Deve impedir unificação se há conflitos temporais não justificados
**CA905.4** - Deve permitir ajuste de datas para resolver conflitos
**CA905.5** - Deve validar que trabalhador não tinha outros vínculos simultâneos
**CA905.6** - Deve calcular período efetivo considerando todas as sobreposições

### RF906 - Cálculo de Direitos Unificados
**Como** sistema  
**Quero** calcular direitos considerando contrato único  
**Para que** sejam corrigidos valores com base na continuidade

#### Critérios de Aceite:
- **CA906.1** - Calcular tempo de serviço total (sem descontar intervalos)
- **CA906.2** - Recalcular férias considerando período único
- **CA906.3** - Ajustar 13º salário para período contínuo
- **CA906.4** - Corrigir FGTS eliminando rescisões intermediárias
- **CA906.5** - Recalcular verbas rescisórias se aplicável
- **CA906.6** - Identificar direitos adicionais por tempo de serviço
- **CA906.7** - Sistema deve recalcular automaticamente tempo total unificado
- **CA906.8** - Deve mostrar comparativo: tempo original vs tempo unificado
- **CA906.9** - Deve calcular diferenças financeiras da unificação

### RF907 - Validações de Consistência Temporal
**Como** sistema
**Quero** aplicar validações rigorosas de consistência temporal
**Para** que seja garantida lógica da unificação

#### Critérios de Aceite:

- **CA907.1** - Todos os contratos devem ser do mesmo empregador (CNPJ)
- **CA907.2** - Sequência cronológica deve fazer sentido
- **CA907.3** - Intervalos não podem ser maiores que limite configurável
- **CA907.4** - Funções devem ser compatíveis entre contratos
- **CA907.5** - Não pode haver contratos simultâneos não justificados
- **CA907.6** - Sistema deve alertar sobre inconsistências encontradas

## Regras de Negócio Específicas

### RN901 - Validação para Unificação
- Contratos DEVEM ser do mesmo empregador e mesmo trabalhador
- Funções devem ser idênticas ou conexas
- Intervalos devem ser artificiais (normalmente até 90 dias)
- Deve haver evidência de tentativa de burla à legislação

### RN902 - Período Unificado
- Data início é sempre do primeiro contrato da série
- Data fim é do último contrato (se houver desligamento final)
- Intervalos são "preenchidos" automaticamente
- Tempo de serviço considera período total sem interrupções

### RN903 - Características do Contrato Único
- Categoria profissional é a predominante ou a final
- Salário segue evolução natural dos contratos
- Regime trabalhista mantém-se consistente
- Matrícula pode ser nova ou de um dos contratos originais

### RN904 - Correção de Direitos
- Recalcular todos os direitos com base no contrato único
- Eliminar rescisões intermediárias artificiais
- Corrigir contribuições e depósitos indevidos
- Reconhecer estabilidades que foram burladas

### RN905 - Validação de Intervalos
- Intervalos entre contratos não podem exceder limite configurável (padrão: 90 dias)
- Sistema deve alertar se intervalo questiona continuidade
- Gaps muito grandes devem ser justificados especificamente
- Usuário pode ajustar limite para casos especiais

### RN906 - Sobreposição Temporal
- Não podem existir contratos com períodos sobrepostos
- Sistema deve detectar e alertar sobre conflitos temporais
- Sobreposições devem ser resolvidas antes da unificação
- Contratos simultâneos indicam possível erro nos dados

### RN907 - Sequência Cronológica
- Contratos devem estar em ordem cronológica lógica
- Próximo contrato deve iniciar após fim do anterior (respeitando gap)
- Sistema deve reordenar contratos automaticamente se necessário
- Sequência incorreta impede unificação

### RN908 - Cálculo Automático
- Sistema deve calcular automaticamente período total unificado
- Deve mostrar diferença entre tempo original e tempo unificado
- Deve calcular impactos financeiros da unificação
- Todos os cálculos devem ser transparentes ao usuário


## Interface Específica

### Seção Seleção de Contratos
- **Lista contratos**: Todos os vínculos do trabalhador com empregador
- **Período análise**: Faixa temporal para busca
- **Contratos selecionados**: Múltipla seleção dos contratos a unificar
- **Visualização timeline**: Gráfico temporal dos contratos e intervalos

### Seção Análise de Continuidade
- **Mapa temporal**: Visualização de contratos e intervalos
- **Duração intervalos**: Tempo entre cada contrato
- **Análise suspeição**: Indicadores de artificialidade
- **Funções exercidas**: CBO e descrição em cada contrato
- **Salários praticados**: Evolução salarial entre contratos

### Seção Validações Temporais

- **Sobreposições detectadas:** Lista automática de conflitos
- **Gaps encontrados:** Intervalos e análise de adequação
- **Sequência cronológica:** Validação da ordem temporal
- **Sugestões de ajuste:** Recomendações automáticas

### Seção Configuração Unificação
- **Data admissão única**: Início do primeiro contrato
- **Data desligamento única**: Fim do último contrato (se houver)
- **Matrícula unificada**: Nova ou aproveitada de contrato existente
- **Categoria profissional**: Predominante ou mais recente
- **Regime trabalhista**: Consistente entre contratos

### Seção Cálculos Automáticos

- **Período original total:** Soma contratos sem intervalos
- **Período unificado:** Tempo contínuo total
- **Diferença calculada:** Impacto da unificação
- **Direitos recalculados:** Comparativo antes/depois

### Seção Impactos da Unificação
- **Tempo serviço original**: Soma períodos sem intervalos
- **Tempo serviço unificado**: Período total contínuo
- **Direitos originais**: Cálculo com rescisões intermediárias
- **Direitos unificados**: Recálculo como contrato único
- **Diferenças identificadas**: Valores a maior/menor

### Seção Justificativas e Documentação
- **Fundamento legal**: Base jurídica para unificação
- **Evidências fraude**: Comprovação de artificialidade
- **Decisão judicial**: Número e data do processo
- **Documentação**: Anexos comprobatórios
- **Observações**: Campo livre para detalhes

## Cenários de Teste Específicos

### CT901 - Unificação Contratos Sucessivos
**Dado que** trabalhador teve 3 contratos sucessivos:  
- "01/01/2020 a 30/06/2020"
- "16/07/2020 a 31/12/2020" (15 dias intervalo)
- "16/01/2021 a 31/06/2021" (15 dias intervalo)  
**Quando** seleciono tipo "9 - Unicidade contratual"  
**E** seleciono os 3 contratos para unificar  
**Então** sistema deve criar contrato único "01/01/2020 a 31/06/2021"  
**E** deve calcular tempo serviço como 18 meses contínuos  
**E** deve recalcular direitos eliminando rescisões intermediárias

### CT902 - Validação Sobreposição Temporal
**Dado que** tenho contratos com períodos sobrepostos:
Contrato 1: "01/01/2020 a 30/06/2020"
Contrato 2: "15/06/2020 a 31/12/2020" (sobreposição)
**Quando** tento unificar contratos
**Então** sistema deve detectar sobreposição de 15 dias
**E** deve alertar "Contratos com períodos sobrepostos detectados"
**E** deve impedir unificação até resolução

### CT903 - Validação Intervalo Muito Longo
**Dado que** intervalo entre contratos é 6 meses
**Quando** tento unificar contratos
**Então** sistema deve alertar "Intervalo de 180 dias excede limite padrão de 90 dias"
**E** deve questionar se realmente caracteriza continuidade
**E** deve permitir prosseguir apenas com justificativa específica

### CT904 - Contratos com Funções Diferentes
**Dado que** trabalhador teve contratos com CBOs diferentes:
- Contrato 1: CBO "Auxiliar Administrativo"  
- Contrato 2: CBO "Assistente Administrativo"  
**Quando** tento unificar contratos  
**Então** sistema deve aceitar por serem funções conexas  
**E** deve usar CBO mais recente ou predominante  
**E** deve documentar evolução funcional

### CT905 - Cálculo Automático Período Unificado
**Dado que** contratos originais somavam 15 meses efetivos
**E** intervalos totalizavam 2 meses
**Quando** sistema calcula unificação
**Então** período unificado deve ser 17 meses (período total)
**E** deve mostrar: "Tempo original: 15 meses, Unificado: 17 meses, Ganho: +2 meses"
**E** deve recalcular proporcionais automaticamente

### CT906 - Validação Sequência Cronológica
**Dado que** contratos estão fora de ordem cronológica:
Contrato A: "01/06/2020 a 31/12/2020"
Contrato B: "01/01/2020 a 31/05/2020"
**Quando** seleciono para unificar
**Então** sistema deve reordenar automaticamente: B depois A
**E** deve mostrar sequência corrigida na timeline
**E** deve calcular período como "01/01/2020 a 31/12/2020"

### CT907 - Funções Incompatíveis 
**Dado que** contratos têm funções muito diferentes:
Contrato 1: "Auxiliar Administrativo"
Contrato 2: "Operador de Máquinas"
**Quando** tento unificar
**Então** sistema deve alertar "Funções podem não ser conexas"
**E** deve solicitar justificativa sobre compatibilidade
**E** deve permitir prosseguir com justificativa

### CT908 - Intervalos Muito Longos
**Dado que** intervalo entre contratos foi de 6 meses  
**Quando** tento unificar contratos  
**Então** sistema deve alertar "Intervalo longo pode não caracterizar continuidade"  
**E** deve solicitar justificativa específica  
**E** deve permitir prosseguir com fundamentação

### CT909 - Contratos de Empregadores Diferentes  
**Dado que** tento unificar contratos de CNPJs diferentes  
**Quando** seleciono contratos  
**Então** sistema deve exibir erro "Contratos devem ser do mesmo empregador"  
**E** deve impedir seleção de CNPJs diferentes  
**E** deve sugerir verificação dos dados

### CT910 - Cálculo Tempo Serviço Unificado
**Dado que** contratos originais somavam 15 meses efetivos  
**E** intervalos totalizavam 2 meses  
**Quando** sistema calcula unificação  
**Então** tempo serviço deve ser 17 meses (período total)  
**E** deve mostrar diferença: "+2 meses por unificação"  
**E** deve recalcular proporcionais com novo tempo

## Validações Avançadas Específicas

### Validação de Continuidade Real
- Analisar se houve prestação de serviços nos intervalos
- Verificar compatibilidade de funções entre contratos
- Confirmar identidade de empregador em todos os períodos
- Detectar padrões que evidenciem fraude

### Validação de Artificialidade
- Identificar intervalos suspeitamente curtos
- Verificar coincidência com datas de aquisição de estabilidade
- Analisar histórico de outros trabalhadores similares
- Detectar padrões sistemáticos de burla

### Validação Temporal Automática

- Detectar automaticamente sobreposições entre contratos
- Calcular gaps e alertar se excedem limites
- Validar sequência cronológica dos contratos
- Sugerir correções para inconsistências temporais

### Validação de Impactos
- Calcular diferenças em verbas rescisórias
- Verificar impacto em contribuições previdenciárias
- Analisar reflexos em FGTS e multas
- Estimar correções necessárias em obrigações

### Validação Legal
- Confirmar aplicabilidade do princípio da continuidade
- Verificar limites temporais para reconhecimento
- Validar se situação configura fraude à lei
- Checar jurisprudência aplicável

## Integração com eSocial

### Impactos nos Eventos Originais
- Contratos originais podem precisar ser retificados
- Eventos S-2299 intermediários podem ser cancelados
- Novo S-2200 unificado pode ser necessário
- Recálculo de eventos S-1200 do período

### Novos Registros Necessários
- S-2500 indicando unicidade contratual
- Possível S-2200 com matrícula unificada
- S-2501 com tributos recalculados
- Eventuais correções em eventos periódicos

### Complexidade Sistêmica
- Múltiplos eventos podem ser afetados
- Recálculos em cadeia podem ser necessários
- Ordem de processamento é crítica
- Validações cruzadas mais rigorosas

## Considerações Especiais

### Aspectos Jurídicos Complexos
- Princípio da primazia da realidade
- Análise caso a caso necessária
- Jurisprudência específica por situação
- Prova da artificialidade dos intervalos

### Aspectos Tributários Intrincados
- Recálculo completo de contribuições
- Eliminação de rescisões fictícias
- Correção de recolhimentos indevidos
- Possível necessidade de restituições

### Aspectos Operacionais Desafiadores
- Processo mais complexo de todos os tipos
- Requer análise detalhada de múltiplos contratos
- Impactos sistêmicos significativos
- Necessidade de expertise jurídica avançada

### Limitações e Riscos
- Sistema não valida automaticamente artificialidade dos intervalos
- Análise de continuidade requer expertise humana significativa
- Recálculos automáticos podem ser muito complexos
- Alto risco de inconsistências em cascata se mal executado
- Validações temporais automáticas não substituem análise jurídica

### Limitações e Riscos
- Sistema não valida automaticamente artificialidade
- Análise de continuidade requer expertise humana
- Recálculos podem ser muito complexos
- Riscos de inconsistências em cascata

### Fluxo Crítico Obrigatório
- Análise jurídica especializada obrigatória
- Validação contábil/fiscal rigorosa
- Aprovação de alta gerência/diretoria  
- Documentação extensiva e comprobatória
- Acompanhamento pós-processamento obrigatório

### Controles Especiais
- Validação automática de sobreposições temporais
- Controle rigoroso de intervalos entre contratos
- Cálculos automáticos com dupla verificação
- Alertas automáticos para situações de risco
- Log detalhado de todas as validações executadas
- Auditoria diferenciada para este tipo
- Logs detalhados de todas as alterações
- Backup obrigatório antes de processar
- Plano de rollback em caso de problemas
- Monitoramento contínuo pós-unificação

### Impactos de Longo Prazo
- Pode afetar estatísticas históricas
- Requer ajustes em relatórios gerenciais
- Necessita comunicação a sistemas integrados
- Demanda acompanhamento jurídico permanente
