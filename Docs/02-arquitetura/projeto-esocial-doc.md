# Sistema eSocial - Processos Trabalhistas
## Documentação Técnica Completa

### 1. VISÃO GERAL DO PROJETO

**Objetivo**: Desenvolver um sistema desktop integrado para gestão completa de Processos Trabalhistas eSocial, incluindo cadastro, validação e geração dos eventos S-2500, S-2501, S-2555 e S-3500.

**Meta de Qualidade**: Sistema de referência que supere as expectativas dos usuários acostumados ao eSocial Web oficial.

### 2. ARQUITETURA DO SISTEMA

#### 2.1 Arquitetura Clean Architecture

```
┌─────────────────────────┐
│       UI Layer          │ ← Windows Forms/WPF
├─────────────────────────┤
│   Application Layer     │ ← Services, Validators, DTOs
├─────────────────────────┤
│     Domain Layer        │ ← Entities, Domain Services
├─────────────────────────┤
│  Infrastructure Layer   │ ← Repositories, External APIs
└─────────────────────────┘
```

#### 2.2 Estrutura de Pastas do Projeto

```
Cgs.ProcessoTrabalhista/
├── src/
│   ├── Cgs.ProcessoTrabalhista.Domain/
│   │   ├── Entities/
│   │   ├── Enums/
│   │   ├── Interfaces/
│   │   ├── Services/
│   │   └── ValueObjects/
│   ├── Cgs.ProcessoTrabalhista.Application/
│   │   ├── DTOs/
│   │   ├── Services/
│   │   ├── Validators/
│   │   ├── Interfaces/
│   │   └── Factories/
│   ├── Cgs.ProcessoTrabalhista.Infrastructure/
│   │   ├── Data/
│   │   │   ├── Repositories/
│   │   │   ├── Configurations/
│   │   │   └── Migrations/
│   │   ├── ExternalServices/
│   │   └── XmlGeneration/
│   └── Cgs.ProcessoTrabalhista.UI.Desktop/
│       ├── Forms/
│       ├── Controls/
│       ├── Services/
│       └── Helpers/
├── tests/
├── docs/
└── database/
```

### 3. MODELAGEM DO BANCO DE DADOS POSTGRESQL

#### 3.1 Tabelas Principais (com Auditoria)

**Padrão de Auditoria para Todas as Tabelas:**
```sql
-- Campos de auditoria obrigatórios em todas as tabelas
data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
usuario_criacao VARCHAR(100) NOT NULL,
data_alteracao TIMESTAMP,
usuario_alteracao VARCHAR(100),
ativo BOOLEAN DEFAULT TRUE
```

#### 3.2 Estrutura de Tabelas Principais

```sql
-- =============================================
-- TABELA: tb_processo_trabalhista
-- DESCRIÇÃO: Dados essenciais do processo (S-2500)
-- =============================================
CREATE TABLE tb_processo_trabalhista (
    id_processo SERIAL PRIMARY KEY,
    numero_processo VARCHAR(50) NOT NULL UNIQUE,
    codigo_tribunal INTEGER NOT NULL,
    vara_origem VARCHAR(100),
    tipo_vara INTEGER,
    descricao_vara VARCHAR(100),
    data_sentenca DATE,
    tipo_decisao INTEGER,
    data_transito_julgado DATE,
    tipo_processo INTEGER NOT NULL, -- 1=Administrativo, 2=Judicial
    status_processo INTEGER DEFAULT 1, -- 1=Ativo, 2=Cancelado, 3=Enviado
    observacoes TEXT,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_empresa
-- DESCRIÇÃO: Dados da empresa (integração externa)
-- =============================================
CREATE TABLE tb_empresa (
    id_empresa SERIAL PRIMARY KEY,
    codigo_empresa VARCHAR(20) NOT NULL UNIQUE,
    razao_social VARCHAR(200) NOT NULL,
    cnpj VARCHAR(14) NOT NULL,
    origem_dados INTEGER DEFAULT 1, -- 1=Manual, 2=Integração
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_trabalhador
-- DESCRIÇÃO: Dados do trabalhador (integração externa)
-- =============================================
CREATE TABLE tb_trabalhador (
    id_trabalhador SERIAL PRIMARY KEY,
    codigo_trabalhador VARCHAR(20),
    nome_trabalhador VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    origem_dados INTEGER DEFAULT 1, -- 1=Manual, 2=Integração
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_processo_trabalhador
-- DESCRIÇÃO: Vínculo processo x trabalhador (S-2500)
-- =============================================
CREATE TABLE tb_processo_trabalhador (
    id_processo_trabalhador SERIAL PRIMARY KEY,
    id_processo INTEGER NOT NULL REFERENCES tb_processo_trabalhista(id_processo),
    id_empresa INTEGER NOT NULL REFERENCES tb_empresa(id_empresa),
    id_trabalhador INTEGER NOT NULL REFERENCES tb_trabalhador(id_trabalhador),
    sequencial_trabalhador INTEGER NOT NULL, -- Para múltiplos trabalhadores no mesmo processo
    tipo_contrato INTEGER NOT NULL, -- 1 a 9 (tipos definidos)
    status_envio INTEGER DEFAULT 1, -- 1=Pendente, 2=Enviado, 3=Erro, 4=Cancelado
    numero_recibo VARCHAR(50), -- Recibo do eSocial após envio
    data_envio TIMESTAMP,
    xml_gerado TEXT,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    UNIQUE(id_processo, sequencial_trabalhador)
);

-- =============================================
-- TABELA: tb_dados_contratuais
-- DESCRIÇÃO: Informações contratuais por tipo
-- =============================================
CREATE TABLE tb_dados_contratuais (
    id_dados_contratuais SERIAL PRIMARY KEY,
    id_processo_trabalhador INTEGER NOT NULL REFERENCES tb_processo_trabalhador(id_processo_trabalhador),
    data_admissao DATE,
    data_admissao_anterior DATE, -- Para tipos que alteram admissão
    data_desligamento DATE,
    data_desligamento_anterior DATE, -- Para tipos que alteram desligamento
    motivo_desligamento INTEGER,
    categoria_trabalhador INTEGER NOT NULL,
    codigo_cargo VARCHAR(10),
    descricao_cargo VARCHAR(100),
    codigo_funcao VARCHAR(10),
    descricao_funcao VARCHAR(100),
    nacionalidade INTEGER DEFAULT 105, -- Brasil
    indica_vinculo_anterior BOOLEAN DEFAULT FALSE,
    indica_reconhecimento_vinculo BOOLEAN DEFAULT FALSE,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_valores_contratuais
-- DESCRIÇÃO: Valores e bases de cálculo
-- =============================================
CREATE TABLE tb_valores_contratuais (
    id_valores_contratuais SERIAL PRIMARY KEY,
    id_dados_contratuais INTEGER NOT NULL REFERENCES tb_dados_contratuais(id_dados_contratuais),
    periodo_apuracao VARCHAR(7) NOT NULL, -- AAAA-MM
    valor_remuneracao DECIMAL(15,2),
    base_calculo_fgts DECIMAL(15,2),
    base_calculo_previdencia DECIMAL(15,2),
    valor_fgts DECIMAL(15,2),
    valor_contribuicao_previdenciaria DECIMAL(15,2),
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_tributos_processo (S-2501)
-- DESCRIÇÃO: Tributos decorrentes do processo
-- =============================================
CREATE TABLE tb_tributos_processo (
    id_tributos_processo SERIAL PRIMARY KEY,
    id_processo_trabalhador INTEGER NOT NULL REFERENCES tb_processo_trabalhador(id_processo_trabalhador),
    periodo_apuração VARCHAR(7) NOT NULL, -- AAAA-MM
    sequencial_processo INTEGER NOT NULL,
    codigo_receita INTEGER NOT NULL,
    valor_tributo DECIMAL(15,2) NOT NULL,
    valor_juros DECIMAL(15,2),
    valor_multa DECIMAL(15,2),
    indicativo_suspensao VARCHAR(2),
    status_envio INTEGER DEFAULT 1, -- 1=Pendente, 2=Enviado, 3=Erro, 4=Cancelado
    numero_recibo VARCHAR(50),
    data_envio TIMESTAMP,
    xml_gerado TEXT,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_consolidacao_tributos (S-2555)
-- DESCRIÇÃO: Solicitações de consolidação - Fase 2
-- =============================================
CREATE TABLE tb_consolidacao_tributos (
    id_consolidacao SERIAL PRIMARY KEY,
    id_processo_trabalhador INTEGER NOT NULL REFERENCES tb_processo_trabalhador(id_processo_trabalhador),
    periodo_consolidacao VARCHAR(7) NOT NULL,
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_consolidacao INTEGER DEFAULT 1, -- 1=Solicitado, 2=Processado, 3=Erro
    numero_recibo VARCHAR(50),
    data_processamento TIMESTAMP,
    xml_gerado TEXT,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELA: tb_exclusao_eventos (S-3500)
-- DESCRIÇÃO: Solicitações de exclusão - Fase 2
-- =============================================
CREATE TABLE tb_exclusao_eventos (
    id_exclusao SERIAL PRIMARY KEY,
    tipo_evento VARCHAR(6) NOT NULL, -- S-2500, S-2501, S-2555
    numero_recibo_original VARCHAR(50) NOT NULL,
    id_processo_trabalhador INTEGER REFERENCES tb_processo_trabalhador(id_processo_trabalhador),
    id_tributos_processo INTEGER REFERENCES tb_tributos_processo(id_tributos_processo),
    id_consolidacao INTEGER REFERENCES tb_consolidacao_tributos(id_consolidacao),
    periodo_apuracao VARCHAR(7),
    sequencial_processo INTEGER,
    cpf_trabalhador VARCHAR(11),
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_exclusao INTEGER DEFAULT 1, -- 1=Solicitado, 2=Processado, 3=Erro
    numero_recibo_exclusao VARCHAR(50),
    data_processamento TIMESTAMP,
    xml_gerado TEXT,
    motivo_exclusao TEXT,
    -- Auditoria
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao VARCHAR(100) NOT NULL,
    data_alteracao TIMESTAMP,
    usuario_alteracao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);
```

#### 3.3 Tabelas de Domínio (Seed Data)

```sql
-- =============================================
-- TABELAS DE DOMÍNIO BASEADAS NO ESOCIAL
-- =============================================

-- Categorias de Trabalhadores (Tabela 01 - eSocial)
CREATE TABLE tb_categoria_trabalhador (
    codigo INTEGER PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    grupo VARCHAR(100),
    data_inicio DATE NOT NULL,
    data_fim DATE
);

-- Motivos de Desligamento (Tabela 19 - eSocial)
CREATE TABLE tb_motivo_desligamento (
    codigo INTEGER PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    categorias_aplicaveis VARCHAR(50) DEFAULT 'Todos',
    data_inicio DATE NOT NULL,
    data_fim DATE
);

-- Códigos de Receita - Reclamatória Trabalhista (Tabela 29 - eSocial)
CREATE TABLE tb_codigo_receita (
    codigo INTEGER PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    aliquota VARCHAR(20),
    data_inicio DATE NOT NULL,
    data_fim DATE
);

-- Tipos de Tribunal
CREATE TABLE tb_tipo_tribunal (
    codigo INTEGER PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    sigla VARCHAR(10)
);

-- Indicativo de Suspensão
CREATE TABLE tb_indicativo_suspensao (
    codigo VARCHAR(2) PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL
);

-- Tipos de Contrato (Processo Trabalhista)
CREATE TABLE tb_tipo_contrato (
    codigo INTEGER PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    descricao_detalhada TEXT,
    observacoes TEXT
);
```

### 4. CAMADA DE DOMÍNIO (DOMAIN LAYER)

#### 4.1 Entidades Principais

```csharp
// Domain/Entities/ProcessoTrabalhista.cs
public class ProcessoTrabalhista : BaseEntity
{
    public string NumeroProcesso { get; private set; }
    public int CodigoTribunal { get; private set; }
    public string VaraOrigem { get; private set; }
    public int? TipoVara { get; private set; }
    public DateTime? DataSentenca { get; private set; }
    public DateTime? DataTransitoJulgado { get; private set; }
    public TipoProcesso TipoProcesso { get; private set; }
    public StatusProcesso Status { get; private set; }
    public string Observacoes { get; private set; }

    private readonly List<ProcessoTrabalhador> _trabalhadoresProcesso;
    public IReadOnlyList<ProcessoTrabalhador> TrabalhadoresToProcesso => _trabalhadoresProcesso.AsReadOnly();

    public ProcessoTrabalhista(string numeroProcesso, int codigoTribunal, TipoProcesso tipoProcesso)
    {
        ValidarNumeroProcesso(numeroProcesso);
        ValidarCodigoTribunal(codigoTribunal);

        NumeroProcesso = numeroProcesso;
        CodigoTribunal = codigoTribunal;
        TipoProcesso = tipoProcesso;
        Status = StatusProcesso.Ativo;
        _trabalhadoresProcesso = new List<ProcessoTrabalhador>();
    }

    public void AdicionarTrabalhador(ProcessoTrabalhador processoTrabalhador)
    {
        ValidarTrabalhadorJaExiste(processoTrabalhador);
        _trabalhadoresProcesso.Add(processoTrabalhador);
    }

    public void AlterarStatus(StatusProcesso novoStatus)
    {
        ValidarMudancaStatus(novoStatus);
        Status = novoStatus;
    }

    private void ValidarNumeroProcesso(string numeroProcesso)
    {
        if (string.IsNullOrWhiteSpace(numeroProcesso))
            throw new DomainException("Número do processo é obrigatório");

        if (numeroProcesso.Length > 50)
            throw new DomainException("Número do processo não pode exceder 50 caracteres");
    }

    private void ValidarCodigoTribunal(int codigoTribunal)
    {
        if (codigoTribunal <= 0)
            throw new DomainException("Código do tribunal deve ser maior que zero");
    }

    private void ValidarTrabalhadorJaExiste(ProcessoTrabalhador processoTrabalhador)
    {
        var existe = _trabalhadoresProcesso.Any(pt => 
            pt.IdTrabalhador == processoTrabalhador.IdTrabalhador &&
            pt.SequencialTrabalhador == processoTrabalhador.SequencialTrabalhador);

        if (existe)
            throw new DomainException("Trabalhador já cadastrado neste processo com o mesmo sequencial");
    }

    private void ValidarMudancaStatus(StatusProcesso novoStatus)
    {
        if (Status == StatusProcesso.Enviado && novoStatus == StatusProcesso.Ativo)
            throw new DomainException("Não é possível reativar um processo já enviado");
    }
}

// Domain/Entities/BaseEntity.cs
public abstract class BaseEntity
{
    public int Id { get; protected set; }
    public DateTime DataCriacao { get; private set; }
    public string UsuarioCriacao { get; private set; }
    public DateTime? DataAlteracao { get; private set; }
    public string UsuarioAlteracao { get; private set; }
    public bool Ativo { get; private set; }

    protected BaseEntity()
    {
        DataCriacao = DateTime.Now;
        Ativo = true;
    }

    public void DefinirUsuarioCriacao(string usuario)
    {
        if (string.IsNullOrWhiteSpace(usuario))
            throw new DomainException("Usuário de criação é obrigatório");
        
        UsuarioCriacao = usuario;
    }

    public void Alterar(string usuarioAlteracao)
    {
        if (string.IsNullOrWhiteSpace(usuarioAlteracao))
            throw new DomainException("Usuário de alteração é obrigatório");
        
        DataAlteracao = DateTime.Now;
        UsuarioAlteracao = usuarioAlteracao;
    }

    public void Inativar()
    {
        Ativo = false;
    }

    public void Ativar()
    {
        Ativo = true;
    }
}
```

#### 4.2 Value Objects

```csharp
// Domain/ValueObjects/Cpf.cs
public class Cpf : ValueObject
{
    public string Numero { get; private set; }

    public Cpf(string numero)
    {
        ValidarCpf(numero);
        Numero = LimparCpf(numero);
    }

    private void ValidarCpf(string cpf)
    {
        if (string.IsNullOrWhiteSpace(cpf))
            throw new DomainException("CPF é obrigatório");

        var cpfLimpo = LimparCpf(cpf);
        
        if (!EhCpfValido(cpfLimpo))
            throw new DomainException("CPF inválido");
    }

    private string LimparCpf(string cpf)
    {
        return Regex.Replace(cpf, @"[^\d]", "");
    }

    private bool EhCpfValido(string cpf)
    {
        if (cpf.Length != 11) return false;
        if (cpf.All(c => c == cpf[0])) return false;

        // Algoritmo de validação do CPF
        var digitos = cpf.Select(c => int.Parse(c.ToString())).ToArray();
        
        var soma1 = 0;
        for (int i = 0; i < 9; i++)
            soma1 += digitos[i] * (10 - i);

        var resto1 = soma1 % 11;
        var digito1 = resto1 < 2 ? 0 : 11 - resto1;

        if (digitos[9] != digito1) return false;

        var soma2 = 0;
        for (int i = 0; i < 10; i++)
            soma2 += digitos[i] * (11 - i);

        var resto2 = soma2 % 11;
        var digito2 = resto2 < 2 ? 0 : 11 - resto2;

        return digitos[10] == digito2;
    }

    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Numero;
    }
}

// Domain/ValueObjects/Cnpj.cs
public class Cnpj : ValueObject
{
    public string Numero { get; private set; }

    public Cnpj(string numero)
    {
        ValidarCnpj(numero);
        Numero = LimparCnpj(numero);
    }

    private void ValidarCnpj(string cnpj)
    {
        if (string.IsNullOrWhiteSpace(cnpj))
            throw new DomainException("CNPJ é obrigatório");

        var cnpjLimpo = LimparCnpj(cnpj);
        
        if (!EhCnpjValido(cnpjLimpo))
            throw new DomainException("CNPJ inválido");
    }

    private string LimparCnpj(string cnpj)
    {
        return Regex.Replace(cnpj, @"[^\d]", "");
    }

    private bool EhCnpjValido(string cnpj)
    {
        if (cnpj.Length != 14) return false;
        if (cnpj.All(c => c == cnpj[0])) return false;

        // Algoritmo de validação do CNPJ
        var digitos = cnpj.Select(c => int.Parse(c.ToString())).ToArray();
        
        // Primeiro dígito verificador
        var soma1 = 0;
        var multiplicador1 = new[] { 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
        
        for (int i = 0; i < 12; i++)
            soma1 += digitos[i] * multiplicador1[i];

        var resto1 = soma1 % 11;
        var digito1 = resto1 < 2 ? 0 : 11 - resto1;

        if (digitos[12] != digito1) return false;

        // Segundo dígito verificador
        var soma2 = 0;
        var multiplicador2 = new[] { 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
        
        for (int i = 0; i < 13; i++)
            soma2 += digitos[i] * multiplicador2[i];

        var resto2 = soma2 % 11;
        var digito2 = resto2 < 2 ? 0 : 11 - resto2;

        return digitos[13] == digito2;
    }

    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Numero;
    }
}
```

### 5. CAMADA DE APLICAÇÃO (APPLICATION LAYER)

#### 5.1 DTOs para Transferência de Dados

```csharp
// Application/DTOs/ProcessoTrabalhistaDto.cs
public class ProcessoTrabalhistaDto
{
    public int Id { get; set; }
    public string NumeroProcesso { get; set; }
    public int CodigoTribunal { get; set; }
    public string DescricaoTribunal { get; set; }
    public string VaraOrigem { get; set; }
    public int? TipoVara { get; set; }
    public DateTime? DataSentenca { get; set; }
    public DateTime? DataTransitoJulgado { get; set; }
    public int TipoProcesso { get; set; }
    public string DescricaoTipoProcesso { get; set; }
    public int Status { get; set; }
    public string DescricaoStatus { get; set; }
    public string Observacoes { get; set; }
    public List<ProcessoTrabalhadorDto> Trabalhadores { get; set; }
    public DateTime DataCriacao { get; set; }
    public string UsuarioCriacao { get; set; }
}

// Application/DTOs/ProcessoTrabalhadorDto.cs
public class ProcessoTrabalhadorDto
{
    public int Id { get; set; }
    public int IdProcesso { get; set; }
    public int IdEmpresa { get; set; }
    public string RazaoSocialEmpresa { get; set; }
    public string CnpjEmpresa { get; set; }
    public int IdTrabalhador { get; set; }
    public string NomeTrabalhador { get; set; }
    public string CpfTrabalhador { get; set; }
    public DateTime DataNascimentoTrabalhador { get; set; }
    public int SequencialTrabalhador { get; set; }
    public int TipoContrato { get; set; }
    public string DescricaoTipoContrato { get; set; }
    public int StatusEnvio { get; set; }
    public string DescricaoStatusEnvio { get; set; }
    public string NumeroRecibo { get; set; }
    public DateTime? DataEnvio { get; set; }
    public DadosContratuaisDto DadosContratuais { get; set; }
    public List<TributosProcessoDto> Tributos { get; set; }
}

// Application/DTOs/DadosContratuaisDto.cs
public class DadosContratuaisDto
{
    public int Id { get; set; }
    public int IdProcessoTrabalhador { get; set; }
    public DateTime? DataAdmissao { get; set; }
    public DateTime? DataAdmissaoAnterior { get; set; }
    public DateTime? DataDesligamento { get; set; }
    public DateTime? DataDesligamentoAnterior { get; set; }
    public int? MotivoDesligamento { get; set; }
    public string DescricaoMotivoDesligamento { get; set; }
    public int CategoriaTrabalhador { get; set; }
    public string DescricaoCategoria { get; set; }
    public string CodigoCargo { get; set; }
    public string DescricaoCargo { get; set; }
    public string CodigoFuncao { get; set; }
    public string DescricaoFuncao { get; set; }
    public int Nacionalidade { get; set; }
    public bool IndicaVinculoAnterior { get; set; }
    public bool IndicaReconhecimentoVinculo { get; set; }
    public List<ValoresContratuaisDto> Valores { get; set; }
}
```

#### 5.2 Services da Camada de Aplicação

```csharp
// Application/Services/ProcessoTrabalhistaService.cs
public class ProcessoTrabalhistaService : IProcessoTrabalhistaService
{
    private readonly IProcessoTrabalhistaRepository _processoRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly IValidadorProcessoTrabalhista _validador;
    private readonly ILogService _logService;

    public ProcessoTrabalhistaService(
        IProcessoTrabalhistaRepository processoRepository,
        IUnitOfWork unitOfWork,
        IValidadorProcessoTrabalhista validador,
        ILogService logService)
    {
        _processoRepository = processoRepository;
        _unitOfWork = unitOfWork;
        _validador = validador;
        _logService = logService;
    }

    public async Task<ResultadoOperacao<int>> CriarProcessoAsync(CriarProcessoCommand comando)
    {
        try
        {
            // Validação de entrada
            var resultadoValidacao = _validador.ValidarCriacao(comando);
            if (!resultadoValidacao.Sucesso)
                return ResultadoOperacao<int>.Falha(resultadoValidacao.Erros);

            // Verificar se processo já existe
            var processoExistente = await _processoRepository
                .BuscarPorNumeroProcessoAsync(comando.NumeroProcesso);
            
            if (processoExistente != null)
                return ResultadoOperacao<int>.Falha("Processo já existe com este número");

            // Criar entidade de domínio
            var processo = new ProcessoTrabalhista(
                comando.NumeroProcesso,
                comando.CodigoTribunal,
                comando.TipoProcesso);

            processo.DefinirUsuarioCriacao(comando.UsuarioLogado);

            // Definir propriedades opcionais
            if (!string.IsNullOrWhiteSpace(comando.VaraOrigem))
                processo.DefinirVaraOrigem(comando.VaraOrigem);

            if (comando.DataSentenca.HasValue)
                processo.DefinirDataSentenca(comando.DataSentenca.Value);

            // Salvar no banco
            await _processoRepository.AdicionarAsync(processo);
            await _unitOfWork.CommitAsync();

            // Log da operação
            _logService.LogInformacao($"Processo {comando.NumeroProcesso} criado com sucesso");

            return ResultadoOperacao<int>.Sucesso(processo.Id);
        }
        catch (DomainException ex)
        {
            _logService.LogErro($"Erro de domínio ao criar processo: {ex.Message}");
            return ResultadoOperacao<int>.Falha(ex.Message);
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro inesperado ao criar processo: {ex}");
            return ResultadoOperacao<int>.Falha("Erro interno do sistema");
        }
    }

    public async Task<ResultadoOperacao<ProcessoTrabalhistaDto>> BuscarPorIdAsync(int id)
    {
        try
        {
            var processo = await _processoRepository.BuscarPorIdCompletoAsync(id);
            
            if (processo == null)
                return ResultadoOperacao<ProcessoTrabalhistaDto>.Falha("Processo não encontrado");

            var dto = MapearParaDto(processo);
            
            return ResultadoOperacao<ProcessoTrabalhistaDto>.Sucesso(dto);
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao buscar processo ID {id}: {ex}");
            return ResultadoOperacao<ProcessoTrabalhistaDto>.Falha("Erro interno do sistema");
        }
    }

    public async Task<ResultadoPaginado<ProcessoTrabalhistaDto>> ListarProcessosAsync(
        FiltroProcessoTrabalhista filtro)
    {
        try
        {
            var processos = await _processoRepository.ListarComFiltroAsync(filtro);
            
            var dtos = processos.Items.Select(MapearParaDto).ToList();
            
            return new ResultadoPaginado<ProcessoTrabalhistaDto>
            {
                Items = dtos,
                TotalItems = processos.TotalItems,
                PaginaAtual = processos.PaginaAtual,
                TamanhoPagina = processos.TamanhoPagina
            };
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao listar processos: {ex}");
            return new ResultadoPaginado<ProcessoTrabalhistaDto>();
        }
    }

    private ProcessoTrabalhistaDto MapearParaDto(ProcessoTrabalhista processo)
    {
        return new ProcessoTrabalhistaDto
        {
            Id = processo.Id,
            NumeroProcesso = processo.NumeroProcesso,
            CodigoTribunal = processo.CodigoTribunal,
            VaraOrigem = processo.VaraOrigem,
            TipoVara = processo.TipoVara,
            DataSentenca = processo.DataSentenca,
            DataTransitoJulgado = processo.DataTransitoJulgado,
            TipoProcesso = (int)processo.TipoProcesso,
            Status = (int)processo.Status,
            Observacoes = processo.Observacoes,
            DataCriacao = processo.DataCriacao,
            UsuarioCriacao = processo.UsuarioCriacao,
            Trabalhadores = processo.TrabalhadoresToProcesso
                .Select(MapearProcessoTrabalhadorParaDto)
                .ToList()
        };
    }

    private ProcessoTrabalhadorDto MapearProcessoTrabalhadorParaDto(ProcessoTrabalhador pt)
    {
        // Implementar mapeamento...
        return new ProcessoTrabalhadorDto();
    }
}
```

### 6. PADRÕES DE DESIGN IMPLEMENTADOS

#### 6.1 Repository Pattern

```csharp
// Infrastructure/Data/Repositories/ProcessoTrabalhistaRepository.cs
public class ProcessoTrabalhistaRepository : IProcessoTrabalhistaRepository
{
    private readonly IDbConnection _connection;
    private readonly ILogService _logService;

    public ProcessoTrabalhistaRepository(IDbConnection connection, ILogService logService)
    {
        _connection = connection;
        _logService = logService;
    }

    public async Task<ProcessoTrabalhista> BuscarPorIdAsync(int id)
    {
        const string sql = @"
            SELECT 
                id_processo as Id,
                numero_processo as NumeroProcesso,
                codigo_tribunal as CodigoTribunal,
                vara_origem as VaraOrigem,
                tipo_vara as TipoVara,
                data_sentenca as DataSentenca,
                data_transito_julgado as DataTransitoJulgado,
                tipo_processo as TipoProcesso,
                status_processo as Status,
                observacoes as Observacoes,
                data_criacao as DataCriacao,
                usuario_criacao as UsuarioCriacao,
                data_alteracao as DataAlteracao,
                usuario_alteracao as UsuarioAlteracao,
                ativo as Ativo
            FROM tb_processo_trabalhista 
            WHERE id_processo = @id AND ativo = true";

        try
        {
            var resultado = await _connection.QueryFirstOrDefaultAsync<ProcessoTrabalhistaDados>(sql, new { id });
            
            return resultado?.ToEntity();
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao buscar processo ID {id}: {ex}");
            throw;
        }
    }

    public async Task<ProcessoTrabalhista> BuscarPorIdCompletoAsync(int id)
    {
        const string sqlProcesso = @"
            SELECT 
                p.id_processo as Id,
                p.numero_processo as NumeroProcesso,
                p.codigo_tribunal as CodigoTribunal,
                p.vara_origem as VaraOrigem,
                p.tipo_vara as TipoVara,
                p.data_sentenca as DataSentenca,
                p.data_transito_julgado as DataTransitoJulgado,
                p.tipo_processo as TipoProcesso,
                p.status_processo as Status,
                p.observacoes as Observacoes,
                p.data_criacao as DataCriacao,
                p.usuario_criacao as UsuarioCriacao,
                p.data_alteracao as DataAlteracao,
                p.usuario_alteracao as UsuarioAlteracao,
                p.ativo as Ativo
            FROM tb_processo_trabalhista p
            WHERE p.id_processo = @id AND p.ativo = true";

        const string sqlTrabalhadores = @"
            SELECT 
                pt.id_processo_trabalhador as Id,
                pt.id_processo as IdProcesso,
                pt.id_empresa as IdEmpresa,
                pt.id_trabalhador as IdTrabalhador,
                pt.sequencial_trabalhador as SequencialTrabalhador,
                pt.tipo_contrato as TipoContrato,
                pt.status_envio as StatusEnvio,
                pt.numero_recibo as NumeroRecibo,
                pt.data_envio as DataEnvio,
                e.razao_social as RazaoSocialEmpresa,
                e.cnpj as CnpjEmpresa,
                t.nome_trabalhador as NomeTrabalhador,
                t.cpf as CpfTrabalhador,
                t.data_nascimento as DataNascimentoTrabalhador
            FROM tb_processo_trabalhador pt
            INNER JOIN tb_empresa e ON pt.id_empresa = e.id_empresa
            INNER JOIN tb_trabalhador t ON pt.id_trabalhador = t.id_trabalhador
            WHERE pt.id_processo = @id AND pt.ativo = true";

        try
        {
            var processo = await _connection.QueryFirstOrDefaultAsync<ProcessoTrabalhistaDados>(
                sqlProcesso, new { id });
            
            if (processo == null) return null;

            var trabalhadores = await _connection.QueryAsync<ProcessoTrabalhadorDados>(
                sqlTrabalhadores, new { id });

            var entidadeProcesso = processo.ToEntity();
            
            foreach (var trabalhador in trabalhadores)
            {
                entidadeProcesso.AdicionarTrabalhador(trabalhador.ToEntity());
            }

            return entidadeProcesso;
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao buscar processo completo ID {id}: {ex}");
            throw;
        }
    }

    public async Task AdicionarAsync(ProcessoTrabalhista processo)
    {
        const string sql = @"
            INSERT INTO tb_processo_trabalhista (
                numero_processo, codigo_tribunal, vara_origem, tipo_vara,
                data_sentenca, data_transito_julgado, tipo_processo,
                status_processo, observacoes, data_criacao, usuario_criacao, ativo
            ) VALUES (
                @NumeroProcesso, @CodigoTribunal, @VaraOrigem, @TipoVara,
                @DataSentenca, @DataTransitoJulgado, @TipoProcesso,
                @StatusProcesso, @Observacoes, @DataCriacao, @UsuarioCriacao, @Ativo
            ) RETURNING id_processo";

        try
        {
            var id = await _connection.QuerySingleAsync<int>(sql, new
            {
                NumeroProcesso = processo.NumeroProcesso,
                CodigoTribunal = processo.CodigoTribunal,
                VaraOrigem = processo.VaraOrigem,
                TipoVara = processo.TipoVara,
                DataSentenca = processo.DataSentenca,
                DataTransitoJulgado = processo.DataTransitoJulgado,
                TipoProcesso = (int)processo.TipoProcesso,
                StatusProcesso = (int)processo.Status,
                Observacoes = processo.Observacoes,
                DataCriacao = processo.DataCriacao,
                UsuarioCriacao = processo.UsuarioCriacao,
                Ativo = processo.Ativo
            });

            // Usar reflection para definir o ID (necessário por causa do encapsulamento)
            var propriedadeId = typeof(BaseEntity).GetProperty("Id", BindingFlags.NonPublic | BindingFlags.Instance);
            propriedadeId?.SetValue(processo, id);

            _logService.LogInformacao($"Processo {processo.NumeroProcesso} inserido com ID {id}");
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao adicionar processo {processo.NumeroProcesso}: {ex}");
            throw;
        }
    }

    public async Task AtualizarAsync(ProcessoTrabalhista processo)
    {
        const string sql = @"
            UPDATE tb_processo_trabalhista SET
                vara_origem = @VaraOrigem,
                tipo_vara = @TipoVara,
                data_sentenca = @DataSentenca,
                data_transito_julgado = @DataTransitoJulgado,
                status_processo = @StatusProcesso,
                observacoes = @Observacoes,
                data_alteracao = @DataAlteracao,
                usuario_alteracao = @UsuarioAlteracao
            WHERE id_processo = @Id AND ativo = true";

        try
        {
            var linhasAfetadas = await _connection.ExecuteAsync(sql, new
            {
                Id = processo.Id,
                VaraOrigem = processo.VaraOrigem,
                TipoVara = processo.TipoVara,
                DataSentenca = processo.DataSentenca,
                DataTransitoJulgado = processo.DataTransitoJulgado,
                StatusProcesso = (int)processo.Status,
                Observacoes = processo.Observacoes,
                DataAlteracao = processo.DataAlteracao,
                UsuarioAlteracao = processo.UsuarioAlteracao
            });

            if (linhasAfetadas == 0)
                throw new InvalidOperationException($"Processo ID {processo.Id} não foi encontrado ou não está ativo");

            _logService.LogInformacao($"Processo ID {processo.Id} atualizado com sucesso");
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao atualizar processo ID {processo.Id}: {ex}");
            throw;
        }
    }
}
```

#### 6.2 Factory Pattern para Geração de XML

```csharp
// Application/Factories/IXmlEsocialFactory.cs
public interface IXmlEsocialFactory
{
    Task<XmlResultado> GerarXmlS2500Async(ProcessoTrabalhadorDto dadosProcesso);
    Task<XmlResultado> GerarXmlS2501Async(TributosProcessoDto dadosTributos);
    Task<XmlResultado> GerarXmlS2555Async(ConsolidacaoTributosDto dadosConsolidacao);
    Task<XmlResultado> GerarXmlS3500Async(ExclusaoEventoDto dadosExclusao);
}

// Application/Factories/XmlEsocialFactory.cs
public class XmlEsocialFactory : IXmlEsocialFactory
{
    private readonly IXmlS2500Generator _s2500Generator;
    private readonly IXmlS2501Generator _s2501Generator;
    private readonly IXmlS2555Generator _s2555Generator;
    private readonly IXmlS3500Generator _s3500Generator;
    private readonly ILogService _logService;

    public XmlEsocialFactory(
        IXmlS2500Generator s2500Generator,
        IXmlS2501Generator s2501Generator,
        IXmlS2555Generator s2555Generator,
        IXmlS3500Generator s3500Generator,
        ILogService logService)
    {
        _s2500Generator = s2500Generator;
        _s2501Generator = s2501Generator;
        _s2555Generator = s2555Generator;
        _s3500Generator = s3500Generator;
        _logService = logService;
    }

    public async Task<XmlResultado> GerarXmlS2500Async(ProcessoTrabalhadorDto dadosProcesso)
    {
        try
        {
            _logService.LogInformacao($"Iniciando geração XML S-2500 para processo {dadosProcesso.IdProcesso}");
            
            var resultado = await _s2500Generator.GerarAsync(dadosProcesso);
            
            if (resultado.Sucesso)
                _logService.LogInformacao($"XML S-2500 gerado com sucesso para processo {dadosProcesso.IdProcesso}");
            else
                _logService.LogErro($"Falha ao gerar XML S-2500: {string.Join(", ", resultado.Erros)}");
            
            return resultado;
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro inesperado ao gerar XML S-2500: {ex}");
            return XmlResultado.Falha("Erro interno na geração do XML");
        }
    }

    // Implementar métodos similares para outros eventos...
}

// Infrastructure/XmlGeneration/XmlS2500Generator.cs
public class XmlS2500Generator : IXmlS2500Generator
{
    private readonly IValidadorEsocial _validador;
    private readonly ILogService _logService;

    public XmlS2500Generator(IValidadorEsocial validador, ILogService logService)
    {
        _validador = validador;
        _logService = logService;
    }

    public async Task<XmlResultado> GerarAsync(ProcessoTrabalhadorDto dados)
    {
        try
        {
            // Validar dados de entrada
            var resultadoValidacao = await _validador.ValidarDadosS2500Async(dados);
            if (!resultadoValidacao.Sucesso)
                return XmlResultado.Falha(resultadoValidacao.Erros);

            // Gerar XML baseado no template
            var xml = GerarXmlS2500(dados);

            // Validar XML gerado contra XSD
            var resultadoValidacaoXml = ValidarXmlContraSchema(xml);
            if (!resultadoValidacaoXml.Sucesso)
                return XmlResultado.Falha(resultadoValidacaoXml.Erros);

            return XmlResultado.Sucesso(xml, ObterIdEventoUnico());
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao gerar XML S-2500: {ex}");
            return XmlResultado.Falha("Erro na geração do XML");
        }
    }

    private string GerarXmlS2500(ProcessoTrabalhadorDto dados)
    {
        var xml = new XDocument(
            new XDeclaration("1.0", "UTF-8", null),
            new XElement("eSocial",
                new XAttribute("xmlns", "http://www.esocial.gov.br/schema/evt/evtProcTrab/v_S_01_03_00"),
                new XElement("evtProcTrab",
                    new XAttribute("Id", ObterIdEventoUnico()),
                    CriarElementoIdeEvento(),
                    CriarElementoIdeEmpregador(dados),
                    CriarElementoInfoProcesso(dados)
                )
            )
        );

        return xml.ToString();
    }

    private XElement CriarElementoIdeEvento()
    {
        return new XElement("ideEvento",
            new XElement("tpAmb", "1"), // Produção = 1, Teste = 2
            new XElement("procEmi", "1"), // Aplicativo do empregador = 1
            new XElement("verProc", "1.0.0") // Versão do aplicativo emissor
        );
    }

    private XElement CriarElementoIdeEmpregador(ProcessoTrabalhadorDto dados)
    {
        return new XElement("ideEmpregador",
            new XElement("tpInsc", "1"), // CNPJ = 1
            new XElement("nrInsc", dados.CnpjEmpresa.Replace(".", "").Replace("/", "").Replace("-", ""))
        );
    }

    private XElement CriarElementoInfoProcesso(ProcessoTrabalhadorDto dados)
    {
        var infoProcesso = new XElement("infoProcesso",
            new XElement("dadosCompl",
                new XElement("infoProcTrab",
                    new XElement("nrProcTrab", dados.NumeroProcesso),
                    new XElement("classTrib", ObterClassificacaoTributaria(dados.TipoContrato)),
                    CriarElementoDadosTrabalhador(dados)
                )
            )
        );

        return infoProcesso;
    }

    private XElement CriarElementoDadosTrabalhador(ProcessoTrabalhadorDto dados)
    {
        return new XElement("dadosTrab",
            new XElement("cpfTrab", dados.CpfTrabalhador.Replace(".", "").Replace("-", "")),
            new XElement("nmTrab", dados.NomeTrabalhador),
            new XElement("dtNascto", dados.DataNascimentoTrabalhador.ToString("yyyy-MM-dd")),
            CriarElementoInfoContrato(dados)
        );
    }

    private XElement CriarElementoInfoContrato(ProcessoTrabalhadorDto dados)
    {
        var infoContrato = new XElement("infoContr",
            new XElement("tpContr", dados.TipoContrato)
        );

        // Adicionar elementos específicos baseado no tipo de contrato
        switch (dados.TipoContrato)
        {
            case 1: // Vínculo sem alteração
                AdicionarElementosContratoTipo1(infoContrato, dados);
                break;
            case 2: // Alteração na admissão
                AdicionarElementosContratoTipo2(infoContrato, dados);
                break;
            // Implementar outros tipos...
        }

        return infoContrato;
    }

    private void AdicionarElementosContratoTipo1(XElement infoContrato, ProcessoTrabalhadorDto dados)
    {
        if (dados.DadosContratuais?.DataAdmissao != null)
        {
            infoContrato.Add(new XElement("dtAdm", dados.DadosContratuais.DataAdmissao.Value.ToString("yyyy-MM-dd")));
        }

        if (dados.DadosContratuais?.DataDesligamento != null)
        {
            infoContrato.Add(new XElement("dtDeslig", dados.DadosContratuais.DataDesligamento.Value.ToString("yyyy-MM-dd")));
        }

        infoContrato.Add(new XElement("codCateg", dados.DadosContratuais.CategoriaTrabalhador));
    }

    private void AdicionarElementosContratoTipo2(XElement infoContrato, ProcessoTrabalhadorDto dados)
    {
        // Implementar lógica específica para tipo 2
        AdicionarElementosContratoTipo1(infoContrato, dados);

        // Adicionar elementos específicos do tipo 2
        if (dados.DadosContratuais?.DataAdmissaoAnterior != null)
        {
            infoContrato.Add(new XElement("dtAdmOrig", dados.DadosContratuais.DataAdmissaoAnterior.Value.ToString("yyyy-MM-dd")));
        }
    }

    private string ObterClassificacaoTributaria(int tipoContrato)
    {
        // Retornar classificação tributária baseada no tipo de contrato
        return tipoContrato switch
        {
            1 or 2 or 3 or 4 => "01", // Empregado
            5 => "02", // Reconhecimento de vínculo
            6 => "03", // TSVE
            7 => "04", // Período anterior ao eSocial
            8 => "05", // Responsabilidade indireta
            9 => "06", // Unicidade
            _ => "01"
        };
    }

    private string ObterIdEventoUnico()
    {
        // Gerar ID único no formato: ID{EMPRESA}{SEQUENCIAL}{TIMESTAMP}
        var timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
        var sequencial = Random.Shared.Next(1000, 9999);
        return $"ID{sequencial}{timestamp}";
    }

    private ResultadoValidacao ValidarXmlContraSchema(string xml)
    {
        try
        {
            // Implementar validação XSD
            var xmlDoc = XDocument.Parse(xml);
            
            // Aqui seria feita a validação contra o schema XSD do eSocial
            // Por enquanto, validação básica
            var root = xmlDoc.Root;
            if (root?.Name.LocalName != "eSocial")
                return ResultadoValidacao.Falha("XML deve ter elemento raiz 'eSocial'");

            var evtProcTrab = root.Element(root.GetDefaultNamespace() + "evtProcTrab");
            if (evtProcTrab == null)
                return ResultadoValidacao.Falha("Elemento 'evtProcTrab' é obrigatório");

            return ResultadoValidacao.Sucesso();
        }
        catch (Exception ex)
        {
            return ResultadoValidacao.Falha($"Erro na validação XML: {ex.Message}");
        }
    }
}
```

### 7. CAMADA DE UI (USER INTERFACE)

#### 7.1 Estrutura de Telas Wizard

**Recomendação**: Utilizar **WPF** ao invés de Windows Forms para melhor experiência visual e recursos mais modernos.

```csharp
// UI.Desktop/Views/ProcessoTrabalhista/ProcessoTrabalhistaWizardWindow.xaml.cs
public partial class ProcessoTrabalhistaWizardWindow : Window
{
    private readonly ProcessoTrabalhistaWizardViewModel _viewModel;

    public ProcessoTrabalhistaWizardWindow(ProcessoTrabalhistaWizardViewModel viewModel)
    {
        InitializeComponent();
        _viewModel = viewModel;
        DataContext = _viewModel;
        
        CarregarEstiloEsocial();
    }

    private void CarregarEstiloEsocial()
    {
        // Aplicar tema baseado no eSocial Web
        var dicionarioRecursos = new ResourceDictionary
        {
            Source = new Uri("pack://application:,,,/Styles/EsocialTheme.xaml")
        };
        Resources.MergedDictionaries.Add(dicionarioRecursos);
    }

    private void BtnProximo_Click(object sender, RoutedEventArgs e)
    {
        if (_viewModel.ValidarEtapaAtual())
        {
            _viewModel.ProximaEtapa();
        }
    }

    private void BtnAnterior_Click(object sender, RoutedEventArgs e)
    {
        _viewModel.EtapaAnterior();
    }

    private void BtnFinalizar_Click(object sender, RoutedEventArgs e)
    {
        if (_viewModel.ValidarTodosOsDados())
        {
            _viewModel.FinalizarWizard();
        }
    }
}

// UI.Desktop/ViewModels/ProcessoTrabalhistaWizardViewModel.cs
public class ProcessoTrabalhistaWizardViewModel : ViewModelBase
{
    private readonly IProcessoTrabalhistaService _processoService;
    private readonly IEmpresaConsultaService _empresaService;
    private readonly ITrabalhadorConsultaService _trabalhadorService;
    private readonly ILogService _logService;

    private int _etapaAtual;
    private ProcessoTrabalhistaDto _processoEmEdicao;
    private ObservableCollection<ProcessoTrabalhadorDto> _trabalhadoresProcesso;

    public ProcessoTrabalhistaWizardViewModel(
        IProcessoTrabalhistaService processoService,
        IEmpresaConsultaService empresaService,
        ITrabalhadorConsultaService trabalhadorService,
        ILogService logService)
    {
        _processoService = processoService;
        _empresaService = empresaService;
        _trabalhadorService = trabalhadorService;
        _logService = logService;

        InicializarCommands();
        InicializarDados();
    }

    #region Propriedades

    public int EtapaAtual
    {
        get => _etapaAtual;
        set
        {
            _etapaAtual = value;
            OnPropertyChanged();
            OnPropertyChanged(nameof(EhEtapaProcesso));
            OnPropertyChanged(nameof(EhEtapaTrabalhador));
            OnPropertyChanged(nameof(EhEtapaContrato));
            OnPropertyChanged(nameof(EhEtapaRevisao));
            OnPropertyChanged(nameof(PodeProximo));
            OnPropertyChanged(nameof(PodeAnterior));
            OnPropertyChanged(nameof(PodeFinalizar));
        }
    }

    public ProcessoTrabalhistaDto ProcessoEmEdicao
    {
        get => _processoEmEdicao;
        set
        {
            _processoEmEdicao = value;
            OnPropertyChanged();
        }
    }

    public ObservableCollection<ProcessoTrabalhadorDto> TrabalhadoresToProcesso
    {
        get => _trabalhadoresProcesso;
        set
        {
            _trabalhadoresProcesso = value;
            OnPropertyChanged();
        }
    }

    public bool EhEtapaProcesso => EtapaAtual == 1;
    public bool EhEtapaTrabalhador => EtapaAtual == 2;
    public bool EhEtapaContrato => EtapaAtual == 3;
    public bool EhEtapaRevisao => EtapaAtual == 4;

    public bool PodeProximo => EtapaAtual < 4;
    public bool PodeAnterior => EtapaAtual > 1;
    public bool PodeFinalizar => EtapaAtual == 4;

    #endregion

    #region Commands

    public ICommand ConsultarEmpresaCommand { get; private set; }
    public ICommand ConsultarTrabalhadorCommand { get; private set; }
    public ICommand AdicionarTrabalhadorCommand { get; private set; }
    public ICommand RemoverTrabalhadorCommand { get; private set; }
    public ICommand ProximaEtapaCommand { get; private set; }
    public ICommand EtapaAnteriorCommand { get; private set; }
    public ICommand FinalizarWizardCommand { get; private set; }

    #endregion

    #region Métodos Públicos

    public bool ValidarEtapaAtual()
    {
        return EtapaAtual switch
        {
            1 => ValidarDadosProcesso(),
            2 => ValidarDadosTrabalhador(),
            3 => ValidarDadosContrato(),
            4 => ValidarTodosOsDados(),
            _ => false
        };
    }

    public void ProximaEtapa()
    {
        if (EtapaAtual < 4)
        {
            EtapaAtual++;
        }
    }

    public void EtapaAnterior()
    {
        if (EtapaAtual > 1)
        {
            EtapaAtual--;
        }
    }

    public async Task<bool> FinalizarWizard()
    {
        try
        {
            if (!ValidarTodosOsDados())
                return false;

            // Salvar processo
            var resultadoProcesso = await _processoService.CriarProcessoAsync(
                CriarComandoCriacaoProcesso());

            if (!resultadoProcesso.Sucesso)
            {
                ExibirErros("Erro ao salvar processo", resultadoProcesso.Erros);
                return false;
            }

            // Salvar trabalhadores
            foreach (var trabalhador in TrabalhadoresToProcesso)
            {
                trabalhador.IdProcesso = resultadoProcesso.Dados;
                
                var resultadoTrabalhador = await _processoService.AdicionarTrabalhadorAsync(
                    CriarComandoTrabalhador(trabalhador));

                if (!resultadoTrabalhador.Sucesso)
                {
                    ExibirErros($"Erro ao salvar trabalhador {trabalhador.NomeTrabalhador}", 
                        resultadoTrabalhador.Erros);
                    return false;
                }
            }

            ExibirSucesso("Processo cadastrado com sucesso!");
            return true;
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao finalizar wizard: {ex}");
            ExibirErro("Erro interno", "Ocorreu um erro inesperado. Tente novamente.");
            return false;
        }
    }

    #endregion

    #region Métodos Privados

    private void InicializarCommands()
    {
        ConsultarEmpresaCommand = new RelayCommand(async () => await ConsultarEmpresa());
        ConsultarTrabalhadorCommand = new RelayCommand(async () => await ConsultarTrabalhador());
        AdicionarTrabalhadorCommand = new RelayCommand(AdicionarTrabalhador);
        RemoverTrabalhadorCommand = new RelayCommand<ProcessoTrabalhadorDto>(RemoverTrabalhador);
        ProximaEtapaCommand = new RelayCommand(() => {
            if (ValidarEtapaAtual()) ProximaEtapa();
        });
        EtapaAnteriorCommand = new RelayCommand(EtapaAnterior);
        FinalizarWizardCommand = new RelayCommand(async () => await FinalizarWizard());
    }

    private void InicializarDados()
    {
        EtapaAtual = 1;
        ProcessoEmEdicao = new ProcessoTrabalhistaDto();
        TrabalhadoresToProcesso = new ObservableCollection<ProcessoTrabalhadorDto>();
    }

    private bool ValidarDadosProcesso()
    {
        var erros = new List<string>();

        if (string.IsNullOrWhiteSpace(ProcessoEmEdicao.NumeroProcesso))
            erros.Add("Número do processo é obrigatório");

        if (ProcessoEmEdicao.CodigoTribunal <= 0)
            erros.Add("Código do tribunal é obrigatório");

        if (ProcessoEmEdicao.TipoProcesso <= 0)
            erros.Add("Tipo do processo é obrigatório");

        if (erros.Any())
        {
            ExibirErros("Dados do processo inválidos", erros);
            return false;
        }

        return true;
    }

    private bool ValidarDadosTrabalhador()
    {
        if (!TrabalhadoresToProcesso.Any())
        {
            ExibirErro("Trabalhadores obrigatórios", "É necessário adicionar pelo menos um trabalhador");
            return false;
        }

        return true;
    }

    private bool ValidarDadosContrato()
    {
        var erros = new List<string>();

        foreach (var trabalhador in TrabalhadoresToProcesso)
        {
            if (trabalhador.TipoContrato <= 0)
                erros.Add($"Tipo de contrato obrigatório para {trabalhador.NomeTrabalhador}");

            if (trabalhador.DadosContratuais?.CategoriaTrabalhador <= 0)
                erros.Add($"Categoria obrigatória para {trabalhador.NomeTrabalhador}");
        }

        if (erros.Any())
        {
            ExibirErros("Dados contratuais inválidos", erros);
            return false;
        }

        return true;
    }

    private bool ValidarTodosOsDados()
    {
        return ValidarDadosProcesso() && ValidarDadosTrabalhador() && ValidarDadosContrato();
    }

    private async Task ConsultarEmpresa()
    {
        var dialog = new ConsultaEmpresaDialog();
        var resultado = dialog.ShowDialog();
        
        if (resultado == true && dialog.EmpresaSelecionada != null)
        {
            // Preencher dados da empresa selecionada
            foreach (var trabalhador in TrabalhadoresToProcesso)
            {
                trabalhador.IdEmpresa = dialog.EmpresaSelecionada.Id;
                trabalhador.RazaoSocialEmpresa = dialog.EmpresaSelecionada.RazaoSocial;
                trabalhador.CnpjEmpresa = dialog.EmpresaSelecionada.Cnpj;
            }
        }
    }

    private async Task ConsultarTrabalhador()
    {
        var dialog = new ConsultaTrabalhadorDialog();
        var resultado = dialog.ShowDialog();
        
        if (resultado == true && dialog.TrabalhadorSelecionado != null)
        {
            var novoTrabalhador = new ProcessoTrabalhadorDto
            {
                IdTrabalhador = dialog.TrabalhadorSelecionado.Id,
                NomeTrabalhador = dialog.TrabalhadorSelecionado.Nome,
                CpfTrabalhador = dialog.TrabalhadorSelecionado.Cpf,
                DataNascimentoTrabalhador = dialog.TrabalhadorSelecionado.DataNascimento,
                SequencialTrabalhador = ObterProximoSequencial(),
                DadosContratuais = new DadosContratuaisDto()
            };

            TrabalhadoresToProcesso.Add(novoTrabalhador);
        }
    }

    private void AdicionarTrabalhador()
    {
        var dialog = new CadastroTrabalhadorDialog();
        var resultado = dialog.ShowDialog();
        
        if (resultado == true)
        {
            var novoTrabalhador = new ProcessoTrabalhadorDto
            {
                NomeTrabalhador = dialog.NomeTrabalhador,
                CpfTrabalhador = dialog.CpfTrabalhador,
                DataNascimentoTrabalhador = dialog.DataNascimento,
                SequencialTrabalhador = ObterProximoSequencial(),
                DadosContratuais = new DadosContratuaisDto()
            };

            TrabalhadoresToProcesso.Add(novoTrabalhador);
        }
    }

    private void RemoverTrabalhador(ProcessoTrabalhadorDto trabalhador)
    {
        if (trabalhador != null)
        {
            TrabalhadoresToProcesso.Remove(trabalhador);
            ReorganizarSequenciais();
        }
    }

    private int ObterProximoSequencial()
    {
        return TrabalhadoresToProcesso.Any() ? TrabalhadoresToProcesso.Max(t => t.SequencialTrabalhador) + 1 : 1;
    }

    private void ReorganizarSequenciais()
    {
        for (int i = 0; i < TrabalhadoresToProcesso.Count; i++)
        {
            TrabalhadoresToProcesso[i].SequencialTrabalhador = i + 1;
        }
    }

    private CriarProcessoCommand CriarComandoCriacaoProcesso()
    {
        return new CriarProcessoCommand
        {
            NumeroProcesso = ProcessoEmEdicao.NumeroProcesso,
            CodigoTribunal = ProcessoEmEdicao.CodigoTribunal,
            VaraOrigem = ProcessoEmEdicao.VaraOrigem,
            TipoVara = ProcessoEmEdicao.TipoVara,
            DataSentenca = ProcessoEmEdicao.DataSentenca,
            DataTransitoJulgado = ProcessoEmEdicao.DataTransitoJulgado,
            TipoProcesso = (TipoProcesso)ProcessoEmEdicao.TipoProcesso,
            Observacoes = ProcessoEmEdicao.Observacoes,
            UsuarioLogado = ObterUsuarioLogado()
        };
    }

    private AdicionarTrabalhadorCommand CriarComandoTrabalhador(ProcessoTrabalhadorDto trabalhador)
    {
        return new AdicionarTrabalhadorCommand
        {
            IdProcesso = trabalhador.IdProcesso,
            IdEmpresa = trabalhador.IdEmpresa,
            IdTrabalhador = trabalhador.IdTrabalhador,
            SequencialTrabalhador = trabalhador.SequencialTrabalhador,
            TipoContrato = trabalhador.TipoContrato,
            DadosContratuais = trabalhador.DadosContratuais,
            UsuarioLogado = ObterUsuarioLogado()
        };
    }

    private string ObterUsuarioLogado()
    {
        // Integração com sistema base para obter usuário logado
        return Environment.UserName; // Temporário
    }

    private void ExibirErros(string titulo, IList<string> erros)
    {
        var mensagem = string.Join("\n", erros);
        MessageBox.Show(mensagem, titulo, MessageBoxButton.OK, MessageBoxImage.Warning);
    }

    private void ExibirErro(string titulo, string mensagem)
    {
        MessageBox.Show(mensagem, titulo, MessageBoxButton.OK, MessageBoxImage.Error);
    }

    private void ExibirSucesso(string mensagem)
    {
        MessageBox.Show(mensagem, "Sucesso", MessageBoxButton.OK, MessageBoxImage.Information);
    }

    #endregion
}
```

### 8. ESTRATÉGIA DE VALIDAÇÃO

#### 8.1 Engine de Validação por Tipo de Contrato (Strategy Pattern)

```csharp
// Application/Validators/IValidadorTipoContrato.cs
public interface IValidadorTipoContrato
{
    int TipoContrato { get; }
    Task<ResultadoValidacao> ValidarAsync(ProcessoTrabalhadorDto dados);
    Task<ResultadoValidacao> ValidarParaEnvioAsync(ProcessoTrabalhadorDto dados);
}

// Application/Validators/ValidadorTipoContrato01.cs (Vínculo sem alteração)
public class ValidadorTipoContrato01 : IValidadorTipoContrato
{
    public int TipoContrato => 1;

    public async Task<ResultadoValidacao> ValidarAsync(ProcessoTrabalhadorDto dados)
    {
        var erros = new List<string>();

        // Validações específicas do Tipo 1
        if (dados.DadosContratuais?.DataAdmissao == null)
            erros.Add("Data de admissão é obrigatória para vínculo sem alteração");

        if (dados.DadosContratuais?.CategoriaTrabalhador <= 0)
            erros.Add("Categoria do trabalhador é obrigatória");

        // Regra específica: não deve haver alteração em datas
        if (dados.DadosContratuais?.DataAdmissaoAnterior != null)
            erros.Add("Não deve haver data de admissão anterior para vínculo sem alteração");

        if (dados.DadosContratuais?.DataDesligamentoAnterior != null)
            erros.Add("Não deve haver data de desligamento anterior para vínculo sem alteração");

        return erros.Any() 
            ? ResultadoValidacao.Falha(erros) 
            : ResultadoValidacao.Sucesso();
    }

    public async Task<ResultadoValidacao> ValidarParaEnvioAsync(ProcessoTrabalhadorDto dados)
    {
        var erros = new List<string>();

        // Validações adicionais para envio
        var resultadoValidacaoBasica = await ValidarAsync(dados);
        if (!resultadoValidacaoBasica.Sucesso)
            erros.AddRange(resultadoValidacaoBasica.Erros);

        // Validar se todos os valores obrigatórios estão preenchidos
        if (!dados.DadosContratuais?.Valores?.Any() == true)
            erros.Add("Valores contratuais são obrigatórios para envio");

        // Validar consistência de datas
        if (dados.DadosContratuais?.DataDesligamento != null && 
            dados.DadosContratuais.DataDesligamento <= dados.DadosContratuais.DataAdmissao)
            erros.Add("Data de desligamento deve ser posterior à data de admissão");

        return erros.Any() 
            ? ResultadoValidacao.Falha(erros) 
            : ResultadoValidacao.Sucesso();
    }
}

// Application/Validators/ValidadorTipoContrato02.cs (Alteração na admissão)
public class ValidadorTipoContrato02 : IValidadorTipoContrato
{
    public int TipoContrato => 2;

    public async Task<ResultadoValidacao> ValidarAsync(ProcessoTrabalhadorDto dados)
    {
        var erros = new List<string>();

        // Validações específicas do Tipo 2
        if (dados.DadosContratuais?.DataAdmissao == null)
            erros.Add("Nova data de admissão é obrigatória");

        if (dados.DadosContratuais?.DataAdmissaoAnterior == null)
            erros.Add("Data de admissão anterior é obrigatória para tipo com alteração");

        if (dados.DadosContratuais?.DataAdmissao != null && 
            dados.DadosContratuais?.DataAdmissaoAnterior != null &&
            dados.DadosContratuais.DataAdmissao == dados.DadosContratuais.DataAdmissaoAnterior)
            erros.Add("Nova data de admissão deve ser diferente da anterior");

        if (dados.DadosContratuais?.CategoriaTrabalhador <= 0)
            erros.Add("Categoria do trabalhador é obrigatória");

        return erros.Any() 
            ? ResultadoValidacao.Falha(erros) 
            : ResultadoValidacao.Sucesso();
    }

    public async Task<ResultadoValidacao> ValidarParaEnvioAsync(ProcessoTrabalhadorDto dados)
    {
        var erros = new List<string>();

        // Validação básica
        var resultadoValidacaoBasica = await ValidarAsync(dados);
        if (!resultadoValidacaoBasica.Sucesso)
            erros.AddRange(resultadoValidacaoBasica.Erros);

        // Validações específicas para envio
        if (!dados.DadosContratuais?.Valores?.Any() == true)
            erros.Add("Valores contratuais são obrigatórios para envio");

        // Validar motivo da alteração
        if (string.IsNullOrWhiteSpace(dados.Observacoes))
            erros.Add("Observações explicando o motivo da alteração são obrigatórias");

        return erros.Any() 
            ? ResultadoValidacao.Falha(erros) 
            : ResultadoValidacao.Sucesso();
    }
}

// Application/Validators/ValidadorProcessoTrabalhista.cs (Context do Strategy Pattern)
public class ValidadorProcessoTrabalhista : IValidadorProcessoTrabalhista
{
    private readonly Dictionary<int, IValidadorTipoContrato> _validadores;
    private readonly ILogService _logService;

    public ValidadorProcessoTrabalhista(
        IEnumerable<IValidadorTipoContrato> validadores, 
        ILogService logService)
    {
        _validadores = validadores.ToDictionary(v => v.TipoContrato);
        _logService = logService;
    }

    public async Task<ResultadoValidacao> ValidarAsync(ProcessoTrabalhadorDto dados)
    {
        try
        {
            if (!_validadores.ContainsKey(dados.TipoContrato))
                return ResultadoValidacao.Falha($"Validador não encontrado para tipo de contrato {dados.TipoContrato}");

            var validador = _validadores[dados.TipoContrato];
            return await validador.ValidarAsync(dados);
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro na validação do tipo {dados.TipoContrato}: {ex}");
            return ResultadoValidacao.Falha("Erro interno na validação");
        }
    }

    public async Task<ResultadoValidacao> ValidarParaEnvioAsync(ProcessoTrabalhadorDto dados)
    {
        try
        {
            if (!_validadores.ContainsKey(dados.TipoContrato))
                return ResultadoValidacao.Falha($"Validador não encontrado para tipo de contrato {dados.TipoContrato}");

            var validador = _validadores[dados.TipoContrato];
            return await validador.ValidarParaEnvioAsync(dados);
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro na validação para envio do tipo {dados.TipoContrato}: {ex}");
            return ResultadoValidacao.Falha("Erro interno na validação");
        }
    }

    public ResultadoValidacao ValidarCriacao(CriarProcessoCommand comando)
    {
        var erros = new List<string>();

        if (string.IsNullOrWhiteSpace(comando.NumeroProcesso))
            erros.Add("Número do processo é obrigatório");

        if (comando.CodigoTribunal <= 0)
            erros.Add("Código do tribunal é obrigatório");

        if (string.IsNullOrWhiteSpace(comando.UsuarioLogado))
            erros.Add("Usuário logado é obrigatório");

        // Validar formato do número do processo
        if (!string.IsNullOrWhiteSpace(comando.NumeroProcesso) && 
            !ValidarFormatoNumeroProcesso(comando.NumeroProcesso))
            erros.Add("Formato do número do processo é inválido");

        return erros.Any() 
            ? ResultadoValidacao.Falha(erros) 
            : ResultadoValidacao.Sucesso();
    }

    private bool ValidarFormatoNumeroProcesso(string numeroProcesso)
    {
        // Implementar validação do formato padrão de processo trabalhista
        // Exemplo: 0000000-00.0000.0.00.0000
        var regex = new Regex(@"^\d{7}-\d{2}\.\d{4}\.\d\.\d{2}\.\d{4}$");
        return regex.IsMatch(numeroProcesso);
    }
}
```

### 9. INTEGRAÇÃO COM SISTEMAS EXTERNOS

#### 9.1 Consulta de Empresa e Trabalhador

```csharp
// Application/Services/EmpresaConsultaService.cs
public class EmpresaConsultaService : IEmpresaConsultaService
{
    private readonly IHttpClient _httpClient;
    private readonly IConfiguration _configuration;
    private readonly ILogService _logService;

    public EmpresaConsultaService(IHttpClient httpClient, IConfiguration configuration, ILogService logService)
    {
        _httpClient = httpClient;
        _configuration = configuration;
        _logService = logService;
    }

    public async Task<ResultadoOperacao<EmpresaDto>> ConsultarPorCodigoAsync(string codigoEmpresa)
    {
        try
        {
            var url = _configuration.GetValue<string>("IntegracaoExterna:UrlConsultaEmpresa");
            var response = await _httpClient.GetAsync($"{url}/empresa/{codigoEmpresa}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var empresa = JsonSerializer.Deserialize<EmpresaDto>(json);
                return ResultadoOperacao<EmpresaDto>.Sucesso(empresa);
            }
            else if (response.StatusCode == HttpStatusCode.NotFound)
            {
                return ResultadoOperacao<EmpresaDto>.Falha("Empresa não encontrada");
            }
            else
            {
                return ResultadoOperacao<EmpresaDto>.Falha("Erro na consulta externa");
            }
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao consultar empresa {codigoEmpresa}: {ex}");
            return ResultadoOperacao<EmpresaDto>.Falha("Erro na integração externa");
        }
    }

    public async Task<ResultadoOperacao<List<EmpresaDto>>> BuscarPorNomeAsync(string nome)
    {
        try
        {
            var url = _configuration.GetValue<string>("IntegracaoExterna:UrlConsultaEmpresa");
            var response = await _httpClient.GetAsync($"{url}/empresa/buscar?nome={Uri.EscapeDataString(nome)}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var empresas = JsonSerializer.Deserialize<List<EmpresaDto>>(json);
                return ResultadoOperacao<List<EmpresaDto>>.Sucesso(empresas);
            }
            else
            {
                return ResultadoOperacao<List<EmpresaDto>>.Falha("Erro na busca por nome");
            }
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao buscar empresas por nome {nome}: {ex}");
            return ResultadoOperacao<List<EmpresaDto>>.Falha("Erro na integração externa");
        }
    }
}

// Application/Services/TrabalhadorConsultaService.cs
public class TrabalhadorConsultaService : ITrabalhadorConsultaService
{
    private readonly IHttpClient _httpClient;
    private readonly IConfiguration _configuration;
    private readonly ILogService _logService;

    public TrabalhadorConsultaService(IHttpClient httpClient, IConfiguration configuration, ILogService logService)
    {
        _httpClient = httpClient;
        _configuration = configuration;
        _logService = logService;
    }

    public async Task<ResultadoOperacao<TrabalhadorDto>> ConsultarPorCodigoAsync(string codigoTrabalhador)
    {
        try
        {
            var url = _configuration.GetValue<string>("IntegracaoExterna:UrlConsultaTrabalhador");
            var response = await _httpClient.GetAsync($"{url}/trabalhador/{codigoTrabalhador}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var trabalhador = JsonSerializer.Deserialize<TrabalhadorDto>(json);
                return ResultadoOperacao<TrabalhadorDto>.Sucesso(trabalhador);
            }
            else if (response.StatusCode == HttpStatusCode.NotFound)
            {
                return ResultadoOperacao<TrabalhadorDto>.Falha("Trabalhador não encontrado");
            }
            else
            {
                return ResultadoOperacao<TrabalhadorDto>.Falha("Erro na consulta externa");
            }
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao consultar trabalhador {codigoTrabalhador}: {ex}");
            return ResultadoOperacao<TrabalhadorDto>.Falha("Erro na integração externa");
        }
    }

    public async Task<ResultadoOperacao<TrabalhadorDto>> ConsultarPorCpfAsync(string cpf)
    {
        try
        {
            var cpfLimpo = Regex.Replace(cpf, @"[^\d]", "");
            var url = _configuration.GetValue<string>("IntegracaoExterna:UrlConsultaTrabalhador");
            var response = await _httpClient.GetAsync($"{url}/trabalhador/cpf/{cpfLimpo}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var trabalhador = JsonSerializer.Deserialize<TrabalhadorDto>(json);
                return ResultadoOperacao<TrabalhadorDto>.Sucesso(trabalhador);
            }
            else if (response.StatusCode == HttpStatusCode.NotFound)
            {
                return ResultadoOperacao<TrabalhadorDto>.Falha("Trabalhador não encontrado");
            }
            else
            {
                return ResultadoOperacao<TrabalhadorDto>.Falha("Erro na consulta por CPF");
            }
        }
        catch (Exception ex)
        {
            _logService.LogErro($"Erro ao consultar trabalhador por CPF {cpf}: {ex}");
            return ResultadoOperacao<TrabalhadorDto>.Falha("Erro na integração externa");
        }
    }
}
```

### 10. CONFIGURAÇÃO E INJEÇÃO DE DEPENDÊNCIA

```csharp
// Infrastructure/DependencyInjection/ServiceCollectionExtensions.cs
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AdicionarInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        // Configurar conexão com banco
        services.AddScoped<IDbConnection>(provider =>
        {
            var connectionString = configuration.GetConnectionString("DefaultConnection");
            return new NpgsqlConnection(connectionString);
        });

        // Repositories
        services.AddScoped<IProcessoTrabalhistaRepository, ProcessoTrabalhistaRepository>();
        services.AddScoped<IEmpresaRepository, EmpresaRepository>();
        services.AddScoped<ITrabalhadorRepository, TrabalhadorRepository>();
        services.AddScoped<ITributosProcessoRepository, TributosProcessoRepository>();

        // Unit of Work
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        // HTTP Client para integrações
        services.AddHttpClient<IEmpresaConsultaService, EmpresaConsultaService>();
        services.AddHttpClient<ITrabalhadorConsultaService, TrabalhadorConsultaService>();

        return services;
    }

    public static IServiceCollection AdicionarApplication(this IServiceCollection services)
    {
        // Services
        services.AddScoped<IProcessoTrabalhistaService, ProcessoTrabalhistaService>();
        services.AddScoped<ITributosProcessoService, TributosProcessoService>();
        services.AddScoped<IXmlEsocialService, XmlEsocialService>();

        // Validators (Strategy Pattern)
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato01>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato02>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato03>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato04>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato05>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato06>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato07>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato08>();
        services.AddScoped<IValidadorTipoContrato, ValidadorTipoContrato09>();
        
        services.AddScoped<IValidadorProcessoTrabalhista, ValidadorProcessoTrabalhista>();

        // XML Generators (Factory Pattern)
        services.AddScoped<IXmlS2500Generator, XmlS2500Generator>();
        services.AddScoped<IXmlS2501Generator, XmlS2501Generator>();
        services.AddScoped<IXmlS2555Generator, XmlS2555Generator>();
        services.AddScoped<IXmlS3500Generator, XmlS3500Generator>();
        services.AddScoped<IXmlEsocialFactory, XmlEsocialFactory>();

        // Log Service
        services.AddSingleton<ILogService, LogService>();

        return services;
    }

    public static IServiceCollection AdicionarUI(this IServiceCollection services)
    {
        // ViewModels
        services.AddTransient<ProcessoTrabalhistaWizardViewModel>();
        services.AddTransient<ListagemProcessosViewModel>();
        services.AddTransient<TributosProcessoViewModel>();

        // Views
        services.AddTransient<ProcessoTrabalhistaWizardWindow>();
        services.AddTransient<ListagemProcessosWindow>();
        services.AddTransient<TributosProcessoWindow>();

        return services;
    }
}

// Program.cs (Entry Point)
public class Program
{
    [STAThread]
    public static void Main(string[] args)
    {
        var app = new App();
        app.InitializeComponent();

        // Configurar DI Container
        var services = new ServiceCollection();
        var configuration = CarregarConfiguracao();

        services.AdicionarInfrastructure(configuration);
        services.AdicionarApplication();
        services.AdicionarUI();

        var serviceProvider = services.BuildServiceProvider();

        // Configurar o container no App
        app.ServiceProvider = serviceProvider;

        app.Run();
    }

    private static IConfiguration CarregarConfiguracao()
    {
        return new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("AMBIENTE") ?? "Production"}.json", optional: true)
            .Build();
    }
}
```

### 11. SCRIPTS DE CRIAÇÃO DO BANCO DE DADOS

**Ordem de execução dos scripts:**

1. `01-create-database.sql`
2. `02-create-tables.sql`  
3. `03-create-indexes.sql`
4. `04-create-constraints.sql`
5. `05-seed-data.sql`

---

Esta documentação fornece uma base sólida para o desenvolvimento do sistema, seguindo as boas práticas de Clean Architecture, SOLID, Design Patterns e integração com o eSocial. 

**Próximos passos recomendados:**
1. Implementar os scripts SQL completos do banco
2. Criar os testes unitários seguindo padrão AAA
3. Desenvolver os protótipos de t