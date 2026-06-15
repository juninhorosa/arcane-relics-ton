# Sistema de Classes Arcane Relics

## Visão Geral

O sistema de classes define arquétipos de heróis com atributos, bônus e habilidades únicas. Existem 5 classes disponíveis:

## Classes Disponíveis

### ⚔️ Paladino
- **Emoji:** ⚔️
- **Descrição:** Guerreiro sagrado que equilibra força e defesa
- **Bônus:**
  - Ataque: +8
  - Defesa: +15
  - Vida: +20
- **Habilidade Especial:** Proteção Divina: +30% de defesa em combates contra classes sombrias

### 🗡️ Guerreiro
- **Emoji:** 🗡️
- **Descrição:** Mestre da luta corpo a corpo com poder devastador
- **Bônus:**
  - Ataque: +20
  - Defesa: +5
  - Vida: +15
- **Habilidade Especial:** Grito de Guerra: +25% de ataque contra inimigos únicos

### 🔮 Mago
- **Emoji:** 🔮
- **Descrição:** Manipulador de magia arcana com poderes místicos
- **Bônus:**
  - Ataque: +15
  - Defesa: +8
  - Vida: +10
- **Habilidade Especial:** Explosão Arcana: Pode fazer dano splash (20% do dano a inimigos próximos)

### 🏹 Arqueiro
- **Emoji:** 🏹
- **Descrição:** Atirador preciso que evita confrontos diretos
- **Bônus:**
  - Ataque: +12
  - Defesa: +10
  - Vida: +8
- **Habilidade Especial:** Tiro Crítico: 15% de chance de acerto crítico (dano x2)

### ✨ Clérigo
- **Emoji:** ✨
- **Descrição:** Curador e suporte que oferece bênçãos divinas
- **Bônus:**
  - Ataque: +5
  - Defesa: +12
  - Vida: +25
- **Habilidade Especial:** Bênção Curadora: Recupera 10% de HP ao vencer combate

## Uso no Código

### Importações

```typescript
import {
  CHARACTER_CLASSES,
  type CharacterClassCode,
  getClassByCode,
  getAllClasses,
  isValidClassCode,
  getClassBonuses,
  formatClassName
} from '@/lib/character-classes'

import { ClassSelector, ClassDisplay, ClassGrid } from '@/components/ClassSelector'
import { usePlayerClass, useCharacterClasses } from '@/hooks/use-character-class'
```

### Componente de Seleção de Classe

```tsx
import { ClassSelector } from '@/components/ClassSelector'
import { usePlayerClass } from '@/hooks/use-character-class'

export function SelectClassScreen({ playerId }: { playerId: string }) {
  const { updatePlayerClass } = usePlayerClass(playerId)
  const [selected, setSelected] = useState<CharacterClassCode | null>(null)

  const handleSelect = async (classCode: CharacterClassCode) => {
    setSelected(classCode)
    const success = await updatePlayerClass(classCode)
    if (success) {
      // Navegar para próxima tela
    }
  }

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Escolha sua Classe</h1>
      <ClassSelector 
        selected={selected} 
        onSelect={handleSelect}
        showDescription={true}
      />
    </div>
  )
}
```

### Exibir Classe do Jogador

```tsx
import { ClassDisplay } from '@/components/ClassSelector'
import { usePlayerClass } from '@/hooks/use-character-class'

export function PlayerClassDisplay({ playerId }: { playerId: string }) {
  const { playerClass } = usePlayerClass(playerId)

  return (
    <div>
      <h2>Classe do Jogador</h2>
      <ClassDisplay classCode={playerClass?.code} />
    </div>
  )
}
```

### Usar Valores em Hooks

```tsx
import { usePlayerClass } from '@/hooks/use-character-class'

export function PlayerStats({ playerId }: { playerId: string }) {
  const { playerClass } = usePlayerClass(playerId)

  const baseAttack = 10
  const baseDef = 10
  const baseHp = 100

  const totalAttack = baseAttack + (playerClass?.attack_bonus ?? 0)
  const totalDef = baseDef + (playerClass?.defense_bonus ?? 0)
  const totalHp = baseHp + (playerClass?.hp_bonus ?? 0)

  return (
    <div>
      <p>Ataque: {totalAttack}</p>
      <p>Defesa: {totalDef}</p>
      <p>Vida: {totalHp}</p>
    </div>
  )
}
```

### Funções Utilitárias

```typescript
// Obter todas as classes
const allClasses = getAllClasses()

// Obter uma classe específica
const paladino = getClassByCode('paladin')

// Validar código de classe
if (isValidClassCode('mago')) {
  // é válido
}

// Obter bônus de uma classe
const bonuses = getClassBonuses('guerreiro')
console.log(bonuses) // { attack: 20, defense: 5, hp: 15 }

// Formatar nome da classe
console.log(formatClassName('archer')) // "🏹 Arqueiro"
```

## Banco de Dados

### Tabela `character_classes`

```sql
CREATE TABLE character_classes (
  id UUID PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  description TEXT,
  attack_bonus INT NOT NULL DEFAULT 0,
  defense_bonus INT NOT NULL DEFAULT 0,
  hp_bonus INT NOT NULL DEFAULT 0,
  ability TEXT NOT NULL,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

### Campo adicionado em `players`

```sql
ALTER TABLE players ADD COLUMN class_id UUID REFERENCES character_classes(id)
```

## Integração em Fluxos Existentes

### Seleção de Nação (index.tsx)

A tela de seleção de nação poderia ter uma etapa anterior ou posterior para seleção de classe:

```tsx
// No fluxo de setup do jogador
1. Selecionar Nação
2. Selecionar Classe
3. Começar jogo
```

### Cálculo de Poder

Os bônus de classe devem ser integrados no cálculo de poder do jogador:

```sql
-- RPC: calculate_player_power
-- Adicionar: + class_bonuses.attack + class_bonuses.defense + (class_bonuses.hp / 10)
```

### Combate

As habilidades especiais de classe devem ser aplicadas durante combates:

```typescript
// Durante battaglia:
// - Paladino: +30% defesa contra sombra
// - Guerreiro: +25% ataque
// - Mago: dano splash
// - Arqueiro: 15% crítico
// - Clérigo: recuperar 10% HP ao vencer
```

## Próximos Passos

1. **Integrar em combate:** Adicionar lógica das habilidades especiais
2. **Visuais:** Criar arte/ícones para cada classe
3. **Rebalancear:** Ajustar bônus conforme testes
4. **Skills adicionais:** Implementar mais habilidades por classe
5. **Upgrade de classe:** Sistema para evoluir/mudar de classe

## Arquivos Criados

- `src/lib/character-classes.ts` - Definições e tipos de classes
- `src/components/ClassSelector.tsx` - Componentes UI de seleção
- `src/hooks/use-character-class.tsx` - Hooks para gerenciar classes
- `.lovable/20260615000003_character_classes.sql` - Migração do banco de dados
