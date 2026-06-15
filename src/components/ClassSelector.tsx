import { CHARACTER_CLASSES, type CharacterClassCode, formatClassName } from '../lib/character-classes'
import { cn } from '../lib/utils'

interface ClassSelectorProps {
  selected?: CharacterClassCode | null
  onSelect: (classCode: CharacterClassCode) => void
  disabled?: boolean
  showDescription?: boolean
}

export function ClassSelector({ selected, onSelect, disabled = false, showDescription = true }: ClassSelectorProps) {
  return (
    <div className="grid grid-cols-1 gap-3 w-full">
      {Object.entries(CHARACTER_CLASSES).map(([code, playerClass]) => (
        <button
          key={code}
          onClick={() => onSelect(code as CharacterClassCode)}
          disabled={disabled}
          className={cn(
            'p-4 rounded-lg border-2 transition-all text-left',
            'hover:border-arcane-gold/50 disabled:opacity-50 disabled:cursor-not-allowed',
            selected === code
              ? 'border-arcane-gold bg-arcane-gold/10 shadow-lg shadow-arcane-gold/30'
              : 'border-slate-700 bg-slate-900 hover:bg-slate-800'
          )}
        >
          <div className="flex items-center justify-between mb-2">
            <h3 className="text-lg font-bold">
              {playerClass.emoji} {playerClass.name}
            </h3>
            <div className="text-xs font-mono text-slate-400 bg-slate-800 px-2 py-1 rounded">
              ATK +{playerClass.attack_bonus} | DEF +{playerClass.defense_bonus} | HP +{playerClass.hp_bonus}
            </div>
          </div>
          
          {showDescription && (
            <>
              <p className="text-sm text-slate-300 mb-2">{playerClass.description}</p>
              <p className="text-xs text-amber-400 italic border-l-2 border-amber-400 pl-2">
                ✨ {playerClass.ability}
              </p>
            </>
          )}
        </button>
      ))}
    </div>
  )
}

interface ClassDisplayProps {
  classCode: CharacterClassCode | null
  compact?: boolean
}

export function ClassDisplay({ classCode, compact = false }: ClassDisplayProps) {
  if (!classCode) {
    return <span className="text-slate-400">Sem classe</span>
  }

  const playerClass = CHARACTER_CLASSES[classCode]

  if (compact) {
    return <span className="font-bold text-arcane-gold">{formatClassName(classCode)}</span>
  }

  return (
    <div className="bg-slate-900 border border-slate-700 rounded-lg p-3">
      <div className="flex items-center justify-between mb-2">
        <h4 className="font-bold text-lg">{formatClassName(classCode)}</h4>
        <div className="text-xs text-slate-400">
          ATK +{playerClass.attack_bonus} | DEF +{playerClass.defense_bonus} | HP +{playerClass.hp_bonus}
        </div>
      </div>
      <p className="text-sm text-slate-300 mb-2">{playerClass.description}</p>
      <p className="text-xs text-amber-400 italic">✨ {playerClass.ability}</p>
    </div>
  )
}

interface ClassGridProps {
  selectedClasses?: Set<CharacterClassCode>
  onToggle?: (classCode: CharacterClassCode) => void
  compact?: boolean
}

export function ClassGrid({ selectedClasses = new Set(), onToggle, compact = false }: ClassGridProps) {
  return (
    <div className={`grid gap-3 ${compact ? 'grid-cols-2' : 'grid-cols-1'}`}>
      {Object.entries(CHARACTER_CLASSES).map(([code, playerClass]) => {
        const isSelected = selectedClasses.has(code as CharacterClassCode)
        return (
          <div
            key={code}
            onClick={() => onToggle?.(code as CharacterClassCode)}
            className={cn(
              'p-3 rounded-lg border-2 cursor-pointer transition-all',
              isSelected
                ? 'border-arcane-gold bg-arcane-gold/10'
                : 'border-slate-700 bg-slate-900'
            )}
          >
            <div className="flex items-center gap-2">
              <span className="text-2xl">{playerClass.emoji}</span>
              <div>
                <p className="font-bold text-sm">{playerClass.name}</p>
                {!compact && <p className="text-xs text-slate-400">{playerClass.description}</p>}
              </div>
            </div>
          </div>
        )
      })}
    </div>
  )
}
