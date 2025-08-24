# 📚 GLOSSÁRIO DE TERMOS DO DOMÍNIO
## eSocial - Processo Trabalhista

> **Base:** Manual eSocial Web + Documentação Senior + Leiautes v1.3  
> **Data:** Agosto 2025  
> **Versão:** 1.0

---

## 🎯 **EVENTOS eSocial**

### **S-2500 - Processo Trabalhista**
Evento que registra as informações decorrentes de processos trabalhistas perante a Justiça do Trabalho e de acordos celebrados no âmbito das Comissões de Conciliação Prévia (CCP) e dos Núcleos Intersindicais (Ninter).

### **S-2501 - Informações dos Tributos Decorrentes de Processo Trabalhista**
Evento utilizado para informar os valores das contribuições sociais previdenciárias, destinadas a terceiros e/ou o imposto sobre a renda retido da pessoa física das verbas constantes das decisões condenatórias e homologatórias de acordo proferidas nos processos trabalhistas.

### **S-2555 - Solicitação de Consolidação das Informações de Tributos**
Evento utilizado para solicitar a totalização no caso de envio de eventos S-2501 múltiplos para o mesmo processo e mesmo período de apuração.

### **S-3500 - Exclusão de Eventos – Processo Trabalhista**
Evento utilizado para tornar sem efeito um evento S-2500 ou S-2501 enviado indevidamente.

---

## 🏢 **ESTRUTURAS ORGANIZACIONAIS**

### **CCP - Comissão de Conciliação Prévia**
Órgão de composição paritária, com representantes dos empregados e dos empregadores, criado por meio de negociação coletiva, com a atribuição de tentar conciliar os conflitos individuais do trabalho.

### **Ninter - Núcleo Intersindical**
Estrutura de negociação coletiva entre sindicatos de trabalhadores e empregadores para resolver conflitos trabalhistas.

### **Estabelecimento Pagador**
Identificação do estabelecimento do empregador responsável pelo pagamento ao trabalhador dos valores constantes no processo trabalhista.

---

## 👥 **TIPOS DE TRABALHADORES**

### **Trabalhador com Vínculo Formalizado**
Trabalhador que já possui cadastro no eSocial com vínculo empregatício regularmente declarado.

### **TSVE - Trabalhador Sem Vínculo de Emprego**
Trabalhador que prestou serviços sem reconhecimento de vínculo empregatício, podendo ser: sem cadastro no eSocial, com cadastro mas sem reconhecimento de vínculo, ou com cadastro e contrato encerrado.

### **Empregado com Reconhecimento de Vínculo**
Situação onde o processo trabalhista reconhece a existência de vínculo empregatício não formalizado anteriormente.

### **Responsabilidade Indireta**
Casos em que o empregador tem responsabilidade pelos encargos trabalhistas de trabalhador que prestou serviços a terceiros.

---

## 📋 **CATEGORIAS DE TRABALHADORES**

### **Categoria 101**
Empregado - Geral, inclusive o empregado público da administração direta ou indireta contratado pela CLT.

### **Categoria 102**
Empregado - Trabalhador rural por pequeno prazo da Lei 11.718/2008.

### **Categoria 103**
Empregado - Aprendiz.

### **Categoria 104**
Empregado - Doméstico.

### **Categoria 105**
Empregado - Contrato a termo firmado nos termos da Lei 9.601/1998.

### **Categoria 106**
Trabalhador temporário - Contrato nos termos da Lei 6.019/1974.

### **Categoria 111**
Empregado - Contrato de trabalho intermitente.

---

## 🔧 **TIPOS DE CONTRATO E REGIMES**

### **Tipos de Contrato de Trabalho**
- **Tipo 1:** Prazo indeterminado
- **Tipo 2:** Prazo determinado, definido em dias
- **Tipo 3:** Prazo determinado, vinculado à ocorrência de um fato

### **Natureza da Atividade**
- **1 - Trabalho urbano:** Para categorias como empregado doméstico (104)
- **2 - Trabalho rural:** Para trabalhador rural por pequeno prazo (102)

### **Tipo de Regime Trabalhista**
- **1 - CLT:** Consolidação das Leis de Trabalho e legislações trabalhistas específicas

### **Tipo de Regime Previdenciário**
- **1 - RGPS:** Regime Geral de Previdência Social
- **2 - RPPS:** Regime Próprio de Previdência Social

---

## 📊 **FLUXO DE PROCESSO TRABALHISTA**

### **Informações do Contrato**
Primeira etapa do wizard onde são definidos os dados básicos do contrato de trabalho relacionado ao processo.

### **Consolidação dos Valores do Contrato**
Segunda etapa onde são informados:
- Estabelecimento responsável pelo pagamento
- Período do processo (início e fim)
- Repercussão do processo trabalhista
- Indicativos de indenização

### **Discriminação das Bases de Cálculo Mês a Mês**
Terceira etapa onde são detalhadas as bases de cálculo para cada competência dentro do período do processo.

### **Unicidade Contratual**
Declaração da continuidade do contrato de trabalho, considerando como único dois ou mais vínculos sucessivos informados no eSocial.

---

## 💰 **BASES DE CÁLCULO E TRIBUTOS**

### **Base de Cálculo de FGTS**
Valor da remuneração considerada para fins de cálculo do Fundo de Garantia do Tempo de Serviço.

### **Base de Cálculo Previdenciária**
Valor da remuneração considerada para fins de contribuição previdenciária.

### **Período de Apuração**
Mês/ano de referência para cálculo das contribuições (formato YYYY-MM).

### **Repercussão do Processo Trabalhista**
Indicativo que define como o processo impacta nas obrigações tributárias.

### **Indenização Substitutiva de Seguro-Desemprego**
Indicativo se houve pagamento de indenização em substituição ao seguro-desemprego.

### **Indenização Substitutiva de Abono Salarial**
Indicativo se houve pagamento de indenização em substituição ao abono salarial.

---

## 🏠 **EMPREGADOR DOMÉSTICO**

### **CAEPF - Cadastro de Atividade Econômica da Pessoa Física**
Número de inscrição do empregador doméstico formado pelos 9 primeiros dígitos do CPF seguidos de 5 zeros (00000).

**Exemplo:** CPF 111111111-99 → CAEPF 11111111100000

---

## 📅 **DATAS E PERÍODOS**

### **Data de Admissão Original**
Data original de admissão do trabalhador, podendo ser alterada em decorrência de processo trabalhista.

### **Data de Desligamento**
Data de término do contrato de trabalho, podendo ser incluída ou alterada por processo trabalhista.

### **Competência**
Período mensal de referência no formato YYYY-MM (ex: 2024-03).

### **Data de Trânsito em Julgado**
Data em que a decisão judicial não cabe mais recurso, definindo o prazo para envio do evento.

---

## 🔍 **IDENTIFICADORES**

### **CPF - Cadastro de Pessoas Físicas**
Número de identificação do trabalhador com 11 dígitos, usado para busca e vinculação.

### **CNPJ - Cadastro Nacional da Pessoa Jurídica**
Número de identificação do empregador pessoa jurídica com 14 dígitos.

### **Matrícula**
Código atribuído pela empresa ao trabalhador, não podendo conter 'eSocial' nas 7 primeiras posições.

### **CBO - Classificação Brasileira de Ocupações**
Código de 6 dígitos que identifica a função exercida pelo trabalhador.

### **Número do Processo**
Identificação única do processo trabalhista na Justiça ou CCP/Ninter.

---

## 📋 **VALIDAÇÕES E REGRAS**

### **Regras de Validação**
Conjunto de verificações automáticas aplicadas conforme o tipo de contrato e categoria do trabalhador.

### **Campos Obrigatórios**
Campos que devem ser preenchidos obrigatoriamente, podendo variar conforme o contexto.

### **Campos Condicionais**
Campos que se tornam obrigatórios ou opcionais dependendo do preenchimento de outros campos.

### **Validação Cruzada**
Verificação de consistência entre múltiplos campos para garantir a integridade dos dados.

---

## 🔄 **STATUS E CONTROLE**

### **Status do Evento**
- **Cadastrado:** Evento criado mas não transmitido
- **Em Elaboração:** Evento em processo de preenchimento
- **Pendente de Envio:** Evento pronto mas aguardando transmissão
- **Enviado:** Evento transmitido ao eSocial
- **Processado:** Evento aceito pelos órgãos competentes
- **Erro:** Evento rejeitado com inconsistências
- **Cancelado:** Evento cancelado pelo usuário

### **Retificação**
Processo de correção de evento já transmitido através de novo envio com indicador de retificação.

### **Exclusão**
Processo de cancelamento de evento transmitido através do evento S-3500.

---

## 🎯 **INTERFACE E NAVEGAÇÃO**

### **Wizard**
Interface sequencial dividida em etapas para guiar o usuário no preenchimento dos dados.

### **Progress Indicator**
Indicador visual mostrando a etapa atual e as próximas no processo de cadastro.

### **Abas de Navegação**
- **"Dados do Processo":** Informações básicas do processo trabalhista
- **"Informações da Decisão ou Acordo":** Dados específicos do contrato e valores

### **Botões de Ação**
- **Anterior:** Volta para etapa anterior
- **Próximo:** Avança para próxima etapa  
- **Salvar:** Grava dados da etapa atual
- **Cancelar:** Cancela a operação atual
- **Finalizar:** Conclui o cadastro do processo

---

## 📝 **OBSERVAÇÕES IMPORTANTES**

### **Integração Externa**
Sistema de consulta a base externa para busca automática de dados de empresa e trabalhador via CNPJ/CPF.

### **Preview XML**
Funcionalidade que permite visualizar o XML que será gerado antes da transmissão.

### **Log de Auditoria**
Registro automático de todas as operações (criação, alteração, exclusão) com usuário, data e ação.

### **Múltiplos Trabalhadores**
Um processo pode ter vários trabalhadores, sendo gerado um evento S-2500 para cada trabalhador.

### **Sequencial do Processo (ideSeqProc)**
Número sequencial atribuído pela empresa quando necessário enviar o mesmo processo em múltiplos eventos.

---

**📋 Versão:** 1.0  
**📅 Data:** Agosto 2025  
**👥 Revisado:** Baseado no Manual eSocial Web v12/03/2024