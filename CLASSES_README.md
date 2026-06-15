# ⚔️ Sistema de Classes - Arcane Relics

## 🎉 O que foi criado?

Um sistema completo de **5 classes de personagem** para o seu jogo RPG no Telegram!

## 🏆 As 5 Classes

| Classe | Emoji | Ataque | Defesa | Vida | Especialidade |
|--------|-------|--------|--------|------|---|
| **Paladino** | ⚔️ | +8 | +15 | +20 | Defesa contra magia sombria |
| **Guerreiro** | 🗡️ | +20 | +5 | +15 | Ataque puro e devastador |
| **Mago** | 🔮 | +15 | +8 | +10 | Dano splash com magia |
| **Arqueiro** | 🏹 | +12 | +10 | +8 | Críticos precisos |
| **Clérigo** | ✨ | +5 | +12 | +25 | Cura e suporte |

## 📦 O que foi criado?

### 1. **Banco de Dados**
- Tabela `character_classes` com 5 classes
- Campo `class_id` adicionado à tabela `players`
- Enum `character_class` para tipo seguro

### 2. **TypeScript/JavaScript**
- Tipos e interfaces totalmente tipadas
- Dicionário de classes com constantes
- Funções utilitárias prontas

### 3. **Componentes React**
- `ClassSelector` - Botões para seleção
- `ClassDisplay` - Exibir classe atual
- `ClassGrid` - Grade compacta de classes

### 4. **Hooks React**
- `usePlayerClass()` - Gerenciar classe do jogador
- `useCharacterClasses()` - Carregar classes

### 5. **Página de Seleção**
- Rota `/select-class` completa e funcional
- Interface limpa com Telegram
- Auto-redirect após seleção

### 6. **Documentação**
- Guia de implementação
- Exemplos de código
- Troubleshooting
- Checklist de ativação

## 🚀 Como ativar?

### Passo 1: Executar a Migração SQL
1. Abra o arquivo `.lovable/20260615000003_character_classes.sql`
2. Copie todo o conteúdo
3. Vá para [Supabase Studio](https://app.supabase.com)
4. Abra SQL Editor > New Query
5. Cole e clique em "Run"

### Passo 2: Adicionar a Rota
Edite `src/router.tsx`:
```typescript
import { Route as SelectClassRoute } from './routes/select-class'

// Adicione a rota no seu router
```

### Passo 3: Integrar na Home
Edite `src/routes/index.tsx`:
```tsx
import { ClassDisplay } from '../components/ClassSelector'
import { usePlayerClass } from '../hooks/use-character-class'

// No componente:
const { playerClass } = usePlayerClass(player?.id)
return <ClassDisplay classCode={playerClass?.code} />
```

### Passo 4: Testar
Acesse: `http://localhost:5173/select-class`

## 📚 Documentação Disponível

- **CLASSES_IMPLEMENTATION_GUIDE.md** - Guia completo de ativação
- **src/routes/CLASS_SYSTEM.md** - Exemplos de código
- **CLASS_SYSTEM_SUMMARY.txt** - Resumo visual ASCII
- **QUICK_CHECKLIST.md** - Checklist de implementação

## 💻 Arquivos Criados

```
src/
├── lib/character-classes.ts          ← Types e utilities
├── components/ClassSelector.tsx      ← Componentes UI
├── hooks/use-character-class.tsx     ← Hooks
├── routes/select-class.tsx           ← Página de seleção
└── routes/CLASS_SYSTEM.md            ← Documentação

.lovable/
└── 20260615000003_character_classes.sql  ← Migração BD

root/
├── CLASSES_IMPLEMENTATION_GUIDE.md   ← Guia
├── CLASS_SYSTEM_SUMMARY.txt          ← Resumo visual
└── QUICK_CHECKLIST.md                ← Checklist
```

## 🎮 Exemplo de Uso Rápido

### Componente para Selecionar Classe
```tsx
import { ClassSelector } from '@/components/ClassSelector'
import { useState } from 'react'

export function MyClassSelector() {
  const [selectedClass, setSelectedClass] = useState(null)
  
  return (
    <ClassSelector 
      selected={selectedClass}
      onSelect={(classCode) => {
        setSelectedClass(classCode)
        // Salvar no banco
      }}
    />
  )
}
```

### Exibir Classe do Jogador
```tsx
import { ClassDisplay } from '@/components/ClassSelector'

export function PlayerInfo({ classCode }) {
  return <ClassDisplay classCode={classCode} />
}
```

### Usar Bônus em Cálculos
```tsx
import { getClassBonuses } from '@/lib/character-classes'

const bonuses = getClassBonuses('guerreiro')
const totalAttack = baseAttack + bonuses.attack
const totalDef = baseDefense + bonuses.defense
```

## 🔧 Integração com Combate

As habilidades especiais podem ser aplicadas assim:

```typescript
// Durante combate
const defender = playerDefender.character_classes?.code

// Paladino: +30% defesa vs dark
if (defender === 'paladin' && attacker.nation === 'SHADOW') {
  defenderPower *= 1.3
}

// Clérigo: recupera HP ao vencer
if (attacker === 'clerigo' && attacker_wins) {
  recover_hp = attacker_max_hp * 0.1
}
```

## ✨ Características

✅ 5 classes balanceadas  
✅ Atributos e habilidades únicas  
✅ Totalmente tipado em TypeScript  
✅ Componentes React reutilizáveis  
✅ Integração com Supabase  
✅ Página de seleção completa  
✅ Documentação extensiva  
✅ Pronto para produção  

## 🎯 Próximos Passos Sugeridos

1. Integrar habilidades em combate
2. Criar visuais únicos por classe
3. Adicionar quests específicas da classe
4. Sistema de evolução de classe
5. Rebalancear conforme testes
6. Arena PvP por classe

## 📞 Suporte

Dúvidas? Veja:
- `CLASS_SYSTEM_SUMMARY.txt` - Visão geral rápida
- `CLASSES_IMPLEMENTATION_GUIDE.md` - Troubleshooting
- `src/routes/CLASS_SYSTEM.md` - Exemplos de código

---

**Status:** ✅ Pronto para ativar no Supabase!

Cada arquivo está documentado e pronto para uso.
