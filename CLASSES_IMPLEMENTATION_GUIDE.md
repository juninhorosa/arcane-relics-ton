# Sistema de Classes - Guia de Implementação

## 📋 Resumo

Foi criado um sistema completo de 5 classes para o jogo Arcane Relics:
- **Paladino** (⚔️) - Defesa + Vida
- **Guerreiro** (🗡️) - Ataque puro
- **Mago** (🔮) - Ataque balanced + Magia
- **Arqueiro** (🏹) - Dano crítico
- **Clérigo** (✨) - Suporte + Cura

## 📁 Arquivos Criados

### 1. **Banco de Dados** 
- `.lovable/20260615000003_character_classes.sql`
  - Cria enum `character_class`
  - Cria tabela `character_classes`
  - Adiciona coluna `class_id` à tabela `players`
  - Seed de 5 classes com atributos

### 2. **TypeScript/Lógica**
- `src/lib/character-classes.ts`
  - Tipos e interfaces
  - Dicionário de classes
  - Funções utilitárias

### 3. **Componentes React**
- `src/components/ClassSelector.tsx`
  - `ClassSelector` - Seletor com descrições
  - `ClassDisplay` - Exibir classe do jogador
  - `ClassGrid` - Grade de classes (compacta)

### 4. **Hooks**
- `src/hooks/use-character-class.tsx`
  - `usePlayerClass()` - Gerenciar classe do jogador
  - `useCharacterClasses()` - Carregar classes disponíveis

### 5. **Telas**
- `src/routes/select-class.tsx` - Página para seleção de classe

### 6. **Documentação**
- `src/routes/CLASS_SYSTEM.md` - Documentação completa
- Este arquivo com instruções

## 🚀 Passos para Ativar

### 1. Aplicar Migração ao Supabase

```bash
# Opção A: Via Supabase Studio (Web)
1. Abra https://app.supabase.com
2. Vá para seu projeto
3. SQL Editor > New Query
4. Copie todo o conteúdo de: .lovable/20260615000003_character_classes.sql
5. Clique em "Run"

# Opção B: Via CLI (se configurado)
npx supabase db push
```

### 2. Adicionar Rota ao Router

Editar `src/router.tsx` para incluir a rota:

```typescript
import { RootRoute, createRoute, createBrowserHistory } from '@tanstack/react-router'

// ... outras importações

import { Route as SelectClassRoute } from './routes/select-class'

// ... resto do router

// Adicionar esta rota:
const selectClassRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/select-class',
  component: SelectClassRoute,
})
```

### 3. Integrar Fluxo de Seleção

No webhook do Telegram (`.lovable/webhook.ts`), após seleção de nação:

```typescript
// Ao criar novo jogador
if (!player || player.level < 5 || !player.nation_id) {
  // Redirecionar para seleção de classe
  return redirect('/select-class?tgWebAppStartParam=...')
}
```

### 4. Atualizar Página Inicial

Em `src/routes/index.tsx`, exibir classe do jogador:

```tsx
import { ClassDisplay } from '../components/ClassSelector'

// No componente Home:
{player && (
  <div className="mt-4">
    <ClassDisplay classCode={player.character_classes?.code} compact={true} />
  </div>
)}
```

## 🔧 Funções para Integração

### Cálculo de Poder

Atualizar a RPC `calculate_player_power` para incluir bônus de classe:

```sql
CREATE OR REPLACE FUNCTION calculate_player_power(p_player_id UUID, p_level INT, p_is_vip BOOLEAN DEFAULT false)
RETURNS INT AS $$
DECLARE
    v_atk INT := 0;
    v_def INT := 0;
    v_hp INT := 0;
    v_class_atk INT := 0;
    v_class_def INT := 0;
    v_class_hp INT := 0;
BEGIN
    -- Equipamento
    SELECT 
        COALESCE(SUM(it.attack), 0),
        COALESCE(SUM(it.defense), 0),
        COALESCE(SUM(it.hp), 0)
    INTO v_atk, v_def, v_hp
    FROM equipment eq
    JOIN inventory inv ON eq.inventory_item_id = inv.id
    JOIN item_templates it ON inv.template_id = it.id
    WHERE eq.player_id = p_player_id;

    -- Bônus de classe
    SELECT 
        COALESCE(attack_bonus, 0),
        COALESCE(defense_bonus, 0),
        COALESCE(hp_bonus, 0)
    INTO v_class_atk, v_class_def, v_class_hp
    FROM character_classes cc
    JOIN players p ON p.class_id = cc.id
    WHERE p.id = p_player_id;

    -- Aplicar VIP boost se necessário
    IF p_is_vip THEN
        v_atk := v_atk * 1.1;
        v_def := v_def * 1.1;
        v_hp := v_hp * 1.1;
    END IF;

    RETURN (p_level * 10) + (v_atk + v_class_atk) + (v_def + v_class_def) + ((v_hp + v_class_hp) / 10);
END;
$$ LANGUAGE plpgsql;
```

### Habilidades em Combate

Adicionar lógica de habilidades especiais em `calculate_battle_outcome`:

```typescript
// Aplicar bônus de classe durante combate
const defenderClassAbility = getClassAbility(defender.character_classes?.code)
const attackerClassAbility = getClassAbility(attacker.character_classes?.code)

// Paladin: +30% defesa contra shadow
if (defender.character_classes?.code === 'paladin' && attacker.nation?.code === 'SHADOW') {
  defenderPower *= 1.3
}

// Guerreiro: +25% ataque
if (attacker.character_classes?.code === 'guerreiro') {
  attackerPower *= 1.25
}
```

## 🎮 Teste Local

1. Abra a página de seleção: `http://localhost:5173/select-class`
2. Selecione uma classe
3. Verifique no Supabase se `players.class_id` foi atualizado
4. Veja a classe refletida na página inicial

## 📊 Verificações

### Verificar dados no Supabase

```sql
-- Ver todas as classes
SELECT * FROM character_classes ORDER BY code;

-- Ver classe do jogador
SELECT p.id, p.level, cc.name, cc.code 
FROM players p
LEFT JOIN character_classes cc ON p.class_id = cc.id;

-- Ver bônus de um jogador
SELECT p.id, cc.name, cc.attack_bonus, cc.defense_bonus, cc.hp_bonus
FROM players p
LEFT JOIN character_classes cc ON p.class_id = cc.id
WHERE p.id = 'seu-uuid';
```

## 🐛 Troubleshooting

**Erro: "character_class" type already exists**
- A migração foi aplicada duas vezes. Use: `DROP TYPE IF EXISTS character_class CASCADE;`

**Classe não aparece em player**
- Verificar se `class_id` está sendo salvo corretamente
- Usar: `SELECT class_id FROM players WHERE id = '...';`

**Bônus não está sendo aplicado**
- Verificar se a RPC de poder foi atualizada
- Testar RPC diretamente: `SELECT calculate_player_power('uuid-here', 10, false);`

## 📚 Próximas Features

- [ ] UI para mudar de classe (Templo de Transformação)
- [ ] Questões específicas da classe
- [ ] Skins visuais diferentes por classe
- [ ] Progressão de classe (evoluir arquétipo)
- [ ] Bonus de atributos por nível dentro da classe
- [ ] Arena de classes (duelos entre arquétipos)

## 🎓 Uso nos Componentes

Ver `src/routes/CLASS_SYSTEM.md` para exemplos completos de código.
