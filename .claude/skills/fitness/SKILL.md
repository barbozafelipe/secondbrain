# Skill: /fitness — Checar Progresso Físico e Metas

## O que fazer

1. Carregar contexto físico atual lendo:
   - `Sync Files/Pessoal/Academia.md` (metas, divisão de treino, restrições)
   - `Sync Files/Pessoal/Saúde.md` (sono, refluxo, derma, cirurgia nasal — afetam o físico)
   - `Sync Files/Pessoal/Medidas.md` (log de peso/medidas, se existir)
2. Ler as daily notes recentes em `Sync Files/Diário/` para extrair `peso::` e `treino::` registrados.
3. Calcular e exibir o delta real vs metas — **sem suavização**:

### Metas do Felipe
- **Massa magra**: 80 kg (meta principal)
- **Índice de Adonis**: razão ombro/cintura de ~1.618 (Golden Ratio). Ombros ~47–48" / cintura ~29–30".
- **Pele/acne**: protocolo ativo — rastrear progresso sem relativização.

### Output esperado

```
## Status Físico — [data]

Peso atual: __ kg
Massa magra estimada: __ kg (falta __ kg para meta)
BF% estimado: __%

Índice de Adonis atual: __ (meta: ~1.618)
  Ombros: __ cm | Cintura: __ cm

Pele/Acne: [status brutal — melhorou/piorou/igual, o quê mudou]

Treinos últimos 7 dias: __/3 esperados (seg/qua/sex)
Consistência 30 dias: __%

Próxima ação prioritária (baseada em dados):
→ 
```

4. **Se não houver dados suficientes** (hoje o `Academia.md` ainda tem `TODO: registrar peso, altura e % de gordura`) → **não estimar no chute**. Dizer claramente que faltam dados-base e pedir que o Felipe registre **agora** peso, altura, cintura e ombros. Anexar os valores em `Sync Files/Pessoal/Medidas.md` (criar a partir do template lá) e logar o `peso::` no daily de hoje.
5. Considerar o fator confounder do **sono** (déficit de N3 / cirurgia nasal pendente) ao avaliar estagnação — está documentado em [[Saúde]] e impacta reparo muscular (GH no sono profundo).
6. Recomendar ajustes apenas com base em estudos/protocolos com referência citada.

## Fontes de referência aceitas
- PubMed / estudos peer-reviewed
- Documentação oficial de suplementos/protocolos (bulas, guidelines clínicos)
- Lyle McDonald, Eric Helms, ou equivalente com citação
- Psicologia evolucionista: David Buss, Robert Trivers (para metas de composição corporal no contexto de atratividade)
