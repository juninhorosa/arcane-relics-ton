# 🗡️ Sistema de Skills - Documentação Completa

## 📋 Visão Geral

O sistema de skills permite que cada classe tenha habilidades únicas com:
- **Requisitos de nível** para aprender
- **Escalamento com nível** (skills ficam mais fortes)
- **Evolução de skills** (aumentar nível da skill)
- **Árvore de progressão** (skills desbloqueadas sequencialmente)
- **Tipos de skills** (ativa, passiva, buff, debuff)
- **Raridade** (common → legendary)

## 🎯 5 Classes × 5-6 Skills = 25-30 Skills

### ⚔️ PALADINO (5 skills)

| Skill | Tipo | Nível | Custo | Efeito |
|-------|------|-------|-------|--------|
| Convicção Divina | Passiva | 1 | 0 | +15% DEF permanente |
| Golpe Sagrado | Ativa | 1 | 10 | 1.5x ATK, ignora 20% DEF |
| Escudo Divino | Buff | 3 | 15 | +50% DEF por 10s |
| Ira Sagrada | Ativa | 6 | 20 | 2.0x ATK, acumula 3 stacks |
| Redenção | Ativa | 10 | 25 | Cura 40% HP máximo |

### 🗡️ GUERREIRO (5 skills)

| Skill | Tipo | Nível | Custo | Efeito |
|-------|------|-------|-------|--------|
| Sede de Sangue | Passiva | 1 | 0 | +20% ATK em combate |
| Golpe Duplo | Ativa | 1 | 12 | 1.8x ATK, atinge área |
| Execução | Ativa | 5 | 20 | 3.0x ATK, dano x2 vs <30% HP |
| Quebrador de Escudos | Ativa | 8 | 18 | 2.5x ATK, ignora 50% DEF |
| Resistência de Aço | Passiva | 10 | 0 | +25% HP máximo |

### 🔮 MAGO (5 skills)

| Skill | Tipo | Nível | Custo | Efeito |
|-------|------|-------|-------|--------|
| Domínio Arcano | Passiva | 1 | 0 | +10% dano por nível |
| Bola de Fogo | Ativa | 1 | 15 | 2.0x ATK, 30% splash |
| Escudo de Mana | Buff | 4 | 12 | 30% redução dano |
| Tempestade de Gelo | Ativa | 6 | 20 | 1.5x ATK, -50% movimento |
| Fratura Temporal | Ativa | 12 | 30 | Desfaz último ataque |

### 🏹 ARQUEIRO (5 skills)

| Skill | Tipo | Nível | Custo | Efeito |
|-------|------|-------|-------|--------|
| Precisão Mortal | Passiva | 1 | 0 | +20% taxa crítico |
| Tiro Perfurante | Ativa | 1 | 8 | 1.6x ATK, ignora 40% DEF |
| Tiro Múltiplo | Ativa | 4 | 12 | Ataque x3 com crítico |
| Esquiva Expert | Passiva | 7 | 0 | +15% chance esquivar |
| Tiro Certeiro | Ativa | 11 | 25 | 3.5x ATK, crítico 100% |

### ✨ CLÉRIGO (5 skills)

| Skill | Tipo | Nível | Custo | Efeito |
|-------|------|-------|-------|--------|
| Aura Sagrada | Passiva | 1 | 0 | +20% DEF aliados |
| Cura | Ativa | 1 | 10 | Restaura 35% HP |
| Proteção Divina | Buff | 6 | 15 | Escudo +40% DEF |
| Justiça Divina | Ativa | 5 | 12 | 1.8x ATK vs maligno |
| Ressurreição | Ativa | 15 | 50 | Revive com 50% HP |

## 🔧 Sistema de Tipos

### Skill Types

```typescript
type SkillType = 'active' | 'passive' | 'buff' | 'debuff'
```

- **Active:** Deve ser ativada em combate (custo energia/cooldown)
- **Passive:** Sempre ativa (sem custo)
- **Buff:** Aumenta stats aliado (temporário)
- **Debuff:** Diminui stats inimigo (temporário)

### Rarity

```typescript
type SkillRarity = 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'
```

## 🎮 Mecânicas de Progressão

### 1. Aprender Skill

```typescript
// Requisitos:
- player_level >= skill.required_level
- skill_points >= skill.required_skill_points

// Ao aprender:
- player_skills INSERT nova linha
- skill_level = 1
- learned_at = agora
```

### 2. Evoluir Skill

```typescript
// Requisitos:
- skill_level < max_level
- skill_points disponíveis

// Escalamento:
- Dano: skill.attack_multiplier * (1 + (skill_level - 1) * scaling_per_level)
- Cooldown: diminui 10% por nível
- Efeitos especiais melhoram
```

### 3. Usar Skill em Combate

```typescript
// Registro:
- times_used ++
- last_used_at = agora
- Valida cooldown
- Desconta energia
```

## 📊 Fórmulas de Cálculo

### Dano de Skill
```
dano_skill = ataque_base * skill.attack_multiplier * (1 + (skill_level - 1) * scaling_per_level)
dano_final = dano_skill * (0.8 + random(0.4))  // RNG normal
se (random < 0.05) dano_final *= 2  // 5% crítico
```

### Cura de Skill
```
cura = max_hp * skill.hp_multiplier * (1 + (skill_level - 1) * scaling_per_level)
```

### Cooldown Reduzido
```
cooldown_ativo = base_cooldown * (1 - (skill_level - 1) * 0.1)
cooldown_mínimo = 0s (não pode ir negativo)
```

## 🌳 Árvore de Skills

Cada classe tem uma árvore de progressão:

```
PALADINO:
  Convicção (Passiva L1)
       ↓
  Golpe Sagrado (Ativa L1)
       ↓
  Escudo Divino (Buff L3)
       ↓
  Ira Sagrada (Ativa L6)
       ↓
  Redenção (Ativa L10)
```

### Requisitos de Pré-requisito

Algumas skills requerem aprender a anterior:

```typescript
const skillTree = {
  'PALADIN_HOLY_STRIKE': ['PALADIN_CONVICTION'],  // precisa dela primeiro
  'PALADIN_DIVINE_SHIELD': ['PALADIN_HOLY_STRIKE'],
  // ...
}
```

## 💻 Uso no Código

### Carregar Skills da Classe

```typescript
import { useClassSkills } from '@/hooks/use-skills'

function SkillsComponent() {
  const { skills, loading } = useClassSkills('paladin')
  
  return <SkillGrid skills={skills} />
}
```

### Gerenciar Skills do Player

```typescript
import { usePlayerSkills } from '@/hooks/use-skills'

function PlayerSkillsComponent() {
  const { playerSkills, learnSkill, upgradeSkill } = usePlayerSkills(playerId)
  
  const handleLearn = async (skillId) => {
    const success = await learnSkill(skillId)
  }
}
```

### Exibir Árvore

```tsx
import { SkillTree } from '@/components/SkillCard'

<SkillTree 
  skills={allSkills}
  learnedSkills={playerSkillsMap}
  playerLevel={player.level}
/>
```

### Usar Skill em Combate

```typescript
// Durante attack():
const skill = playerSkills.get('PALADIN_HOLY_STRIKE')
if (skill && !skill.on_cooldown) {
  const damage = calculateSkillValue(
    skill.attack_multiplier * player.attack,
    skill.skill_level,
    skill.scaling_per_level
  )
  defender.take_damage(damage)
  skill.on_cooldown = true
  skill.last_used_at = Date.now()
}
```

## 📈 Skill Points

Players ganham skill points ao evoluir de nível:

```sql
-- Ao fazer level up:
UPDATE players 
SET skill_points = skill_points + 1
WHERE id = player_id

-- Ao aprender skill:
UPDATE players 
SET skill_points_used = skill_points_used + skill.required_skill_points
WHERE id = player_id
```

## 🎨 UI Components

### `<SkillCard />`
Exibe uma skill com:
- Emoji
- Nome e raridade
- Descrição
- Estatísticas
- Botão de aprender/evoluir

### `<SkillTree />`
Mostra árvore com:
- Skills organizadas por nível
- Progresso de aprendizado
- Prerequisitos

### `<SkillGrid />`
Grid de skills com:
- Cards em grid
- Modo compacto/expandido
- Filtros por tipo

## 🔄 Integração em Combate

Quando jogador ataca, verifica skills:

```typescript
function playerAttack(attacker, defender) {
  // 1. Buscar skills ativas aprendidas
  const activeSkills = getActiveSkills(attacker)
  
  // 2. Escolher skill ou ataque base
  const skill = selectSkill(activeSkills)
  
  // 3. Calcular dano com bônus de skill
  const damage = calculateDamage(attacker, defender, skill)
  
  // 4. Aplicar efeitos especiais
  applySkillEffects(attacker, defender, skill)
  
  // 5. Atualizar cooldown
  skill.cooldown = Date.now() + skill.cooldown_seconds * 1000
  
  // 6. Registrar uso
  recordSkillUse(attacker, skill)
}
```

## 📝 Banco de Dados

### Tabelas

```sql
-- Skills disponíveis
CREATE TABLE skills (
  id UUID PRIMARY KEY,
  code TEXT UNIQUE,
  name TEXT,
  class_id UUID REFERENCES character_classes,
  skill_type skill_type,
  rarity skill_rarity,
  required_level INT,
  attack_multiplier FLOAT,
  max_level INT,
  scaling_per_level FLOAT,
  ...
)

-- Skills do player
CREATE TABLE player_skills (
  id UUID PRIMARY KEY,
  player_id UUID REFERENCES players,
  skill_id UUID REFERENCES skills,
  skill_level INT,
  learned_at TIMESTAMP,
  times_used INT,
  UNIQUE(player_id, skill_id)
)
```

## ✨ Recursos Futuros

- [ ] Skill combinations (2+ skills = combo especial)
- [ ] Skill mastery (100+ usos = bônus permanente)
- [ ] Skill fusion (juntar 2 skills = nova skill)
- [ ] Skill talents (customização de skill)
- [ ] Skill cooldown reduction items
- [ ] Skill duels (1v1 só com skills)
- [ ] Skill achievements

## 🎓 Próximos Passos

1. ✅ Criar schema e migrate no Supabase
2. ✅ Criar types e utilities
3. ✅ Criar components React
4. ✅ Criar hooks
5. ✅ Criar página de skill tree
6. ⏳ Testar sistema
7. ⏳ Integrar em combate
8. ⏳ Balancear skills
9. ⏳ Criar UI de combate mostrando skills

## 📌 Notas Importantes

- Cada skill tem **max_level** (não infinito)
- **Cooldown diminui** 10% por nível (até 0)
- **Dano aumenta** 10-30% por nível (scaling_per_level)
- **Passivas sempre ativas**, sem cooldown
- **Ativas requerem energia** e têm cooldown
- **Skills são exclusivas por classe**
- **Skill tree é linear** (progressão natural)

---

**Status:** ✅ Sistema criado e pronto para testes!
