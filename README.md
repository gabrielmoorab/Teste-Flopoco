# MIPS32 Processor (single-cycle)

Implementação didática de um processador MIPS de 32 bits (single-cycle) em VHDL, com extensão simples de ponto flutuante (FP32) usando operadores do FloPoCo.

## O que foi adicionado (FP32)

- Integração de ULA de ponto flutuante (IEEE-754 single precision) via FloPoCo:
	- Soma: `FPAdd_8_23_F400_uid2` (latência 8 ciclos)
	- Multiplicação: `FPMult_8_23_8_23_8_23_uid2_F400_uid3` (latência 1 ciclo)
- Wrappers para adaptar interface (32-bit IEEE ↔ 34-bit do FloPoCo) com handshake Start/Ready:
	- `Single-Cycle-MIPS/fpu/FPAdd32_wrapper.vhd`
	- `Single-Cycle-MIPS/fpu/FPMult32_wrapper.vhd`
- Pequena extensão de ISA para instruções FP:
	- opcode = 0x1F (`011111`)
	- funct = 0x00 → `fadd.s rd, rs, rt`
	- funct = 0x02 → `fmul.s rd, rs, rt`
	- Observação: os registradores inteiros são reutilizados para armazenar os bit patterns IEEE-754 (sem registradores separados de FP).
- O processador “trava” o PC enquanto uma operação FP está em execução e faz o write-back quando `Ready` fica alto.

Arquivos principais desta integração:

- `Single-Cycle-MIPS/MIPSProcessor.vhd` (top) — integra os módulos e as UFs de FP
- `Single-Cycle-MIPS/InstructionMemory.vhd` — programa de demonstração com `fadd.s` e `fmul.s`
- `Single-Cycle-MIPS/DataMemory.vhd` — inicializa constantes 1.5f e 2.0f
- `Single-Cycle-MIPS/fpu/FPAdd32_wrapper.vhd`, `Single-Cycle-MIPS/fpu/FPMult32_wrapper.vhd`
- `Single-Cycle-MIPS/fpu/FPAdd_8_23_F400_uid2.vhd`, `Single-Cycle-MIPS/fpu/FPMult_8_23_8_23_8_23_uid2_F400_uid3.vhd`
- Testbench: `Single-Cycle-MIPS/tb_MIPSProcessor_FP.vhd`

## Como simular

Você pode simular com ModelSim/Questa, GHDL ou até no EDA Playground. O testbench recomendado para FP é `tb_MIPSProcessor_FP.vhd` (ele encerra automaticamente com PASS/FAIL).

### Conjunto mínimo de arquivos

Inclua estes arquivos (ordem típica; a maioria dos simuladores aceita fora de ordem):

- `Single-Cycle-MIPS/ProgramCounter.vhd`
- `Single-Cycle-MIPS/ProgramCounterAdder.vhd`
- `Single-Cycle-MIPS/InstructionMemory.vhd`
- `Single-Cycle-MIPS/ControlUnit.vhd`
- `Single-Cycle-MIPS/Multiplexer.vhd`
- `Single-Cycle-MIPS/RegisterFile.vhd`
- `Single-Cycle-MIPS/SignExtender.vhd`
- `Single-Cycle-MIPS/ArithmeticLogicUnitControl.vhd`
- `Single-Cycle-MIPS/ArithmeticLogicUnit.vhd`
- `Single-Cycle-MIPS/DataMemory.vhd`
- `Single-Cycle-MIPS/fpu/FPAdd_8_23_F400_uid2.vhd`
- `Single-Cycle-MIPS/fpu/FPMult_8_23_8_23_8_23_uid2_F400_uid3.vhd`
- `Single-Cycle-MIPS/fpu/FPAdd32_wrapper.vhd`
- `Single-Cycle-MIPS/fpu/FPMult32_wrapper.vhd`
- `Single-Cycle-MIPS/MIPSProcessor.vhd` (top do DUT)
- `Single-Cycle-MIPS/tb_MIPSProcessor_FP.vhd` (top da simulação)

Top-level de simulação: `tb_MIPSProcessor_FP`

### O que esperar

O programa de demonstração faz:

1. `lw $1, 0($0)` → carrega 1.5f (0x3FC00000)
2. `lw $2, 1($0)` → carrega 2.0f (0x40000000)
3. `fadd.s $3, $1, $2` → resultado esperado: 3.5f (0x40600000)
4. `sw $3, 2($0)`
5. `fmul.s $4, $1, $2` → resultado esperado: 3.0f (0x40400000)
6. `sw $4, 3($0)`

O testbench checa os write-backs e finaliza com a mensagem:

- PASS: `FP test passed (add=3.5, mul=3.0)`
- FAIL: Mensagem indicando o valor obtido vs esperado.

### Exemplo (GHDL)

Opcional: comandos para GHDL — rode na pasta do projeto ajustando caminhos conforme necessário.

```powershell
# Análise (compile)
ghdl -a Single-Cycle-MIPS/ProgramCounter.vhd
ghdl -a Single-Cycle-MIPS/ProgramCounterAdder.vhd
ghdl -a Single-Cycle-MIPS/InstructionMemory.vhd
ghdl -a Single-Cycle-MIPS/ControlUnit.vhd
ghdl -a Single-Cycle-MIPS/Multiplexer.vhd
ghdl -a Single-Cycle-MIPS/RegisterFile.vhd
ghdl -a Single-Cycle-MIPS/SignExtender.vhd
ghdl -a Single-Cycle-MIPS/ArithmeticLogicUnitControl.vhd
ghdl -a Single-Cycle-MIPS/ArithmeticLogicUnit.vhd
ghdl -a Single-Cycle-MIPS/DataMemory.vhd
ghdl -a Single-Cycle-MIPS/fpu/FPAdd_8_23_F400_uid2.vhd
ghdl -a Single-Cycle-MIPS/fpu/FPMult_8_23_8_23_8_23_uid2_F400_uid3.vhd
ghdl -a Single-Cycle-MIPS/fpu/FPAdd32_wrapper.vhd
ghdl -a Single-Cycle-MIPS/fpu/FPMult32_wrapper.vhd
ghdl -a Single-Cycle-MIPS/MIPSProcessor.vhd
ghdl -a Single-Cycle-MIPS/tb_MIPSProcessor_FP.vhd

# Elaboração
essa linha cria o executável de simulação
ghdl -e tb_MIPSProcessor_FP

# Execução (vai terminar sozinho com PASS/FAIL)
ghdl -r tb_MIPSProcessor_FP --stop-time=2us
```

### Exemplo (ModelSim/Questa)

Adicione os mesmos arquivos ao projeto, defina `tb_MIPSProcessor_FP` como top e rode `run -all`. A simulação finaliza automaticamente com PASS/FAIL.

## Notas e dicas

- O arquivo `Single-Cycle-MIPS/tb_MIPSProcessor.vhd` (legado) foi mantido e ajustado para as novas saídas de debug, mas o teste de FP usa `tb_MIPSProcessor_FP.vhd`.
- A memória de instruções indexa por palavra (Address/4). A memória de dados usa endereços por palavra diretamente (0,1,2,3,...). O programa fornecido usa offsets 0–3 para simplificar.
- As UFs de FP do FloPoCo estão versionadas no repositório em `Single-Cycle-MIPS/fpu/`, dispensando build externo para simular.

## CI (FloPoCo)

Existe um workflow em `.github/workflows/generate-flopoco.yml` que compila o FloPoCo e gera os operadores. Isso não é necessário para simulação local, pois os `.vhd` já estão no repo — serve apenas para re-gerar/atualizar IPs no futuro.

