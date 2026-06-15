import React from 'react';
import { cn } from '../lib/utils';

interface ItemIconProps {
  slot: string;
  itemClass: number;
  isRelic?: boolean;
  className?: string;
  size?: number;
}

/**
 * Renderiza ícones SVG heráldicos baseados no tipo e poder do item.
 * Substitui os emojis da Phase 1 por ativos vetoriais dinâmicos.
 */
export const ItemIcon: React.FC<ItemIconProps> = ({ slot, itemClass, isRelic, className, size = 32 }) => {
  const isHighClass = itemClass >= 15;
  const isMythic = itemClass >= 20 || isRelic;

  // Cores do Design System Arcane
  const colors = {
    gold: '#D4AF37',
    slate: '#94a3b8',
    blood: '#7F1D1D',
    dark: '#1e293b'
  };

  const primaryColor = isMythic ? colors.gold : isHighClass ? colors.gold : colors.slate;
  const strokeWidth = isMythic ? "3" : "2";

  const renderShape = () => {
    switch (slot.toLowerCase()) {
      case 'weapon':
        return (
          <path
            d="M35 85 L45 75 L85 25 Q90 15 80 10 Q70 5 65 15 L15 65 L5 75 L15 85 Z M20 60 L40 80"
            fill="none"
            stroke={primaryColor}
            strokeWidth={strokeWidth}
            strokeLinejoin="round"
          />
        );
      case 'armor':
        return (
          <path
            d="M20 20 Q50 10 80 20 L85 50 Q85 85 50 95 Q15 85 15 50 Z M20 40 L80 40 M50 20 L50 95"
            fill="none"
            stroke={primaryColor}
            strokeWidth={strokeWidth}
          />
        );
      case 'helmet':
        return (
          <path
            d="M25 50 Q25 15 50 15 Q75 15 75 50 L75 80 Q50 90 25 80 Z M35 35 L65 35 M30 55 L70 55"
            fill="none"
            stroke={primaryColor}
            strokeWidth={strokeWidth}
          />
        );
      case 'boots':
        return (
          <path
            d="M30 20 L30 65 L20 85 L50 85 L80 85 L70 65 L70 20 Z"
            fill="none"
            stroke={primaryColor}
            strokeWidth={strokeWidth}
            strokeLinecap="round"
          />
        );
      case 'gloves':
        return (
          <g>
            <path
              d="M20 40 Q20 20 40 20 L60 20 Q80 20 80 40 L80 70 Q80 85 60 85 L40 85 Q20 85 20 70 Z"
              fill="none"
              stroke={primaryColor}
              strokeWidth={strokeWidth}
              strokeLinejoin="round"
            />
            <path
              d="M35 20 L35 45 M50 20 L50 45 M65 20 L65 45"
              stroke={primaryColor}
              strokeWidth={strokeWidth}
              strokeLinecap="round"
            />
          </g>
        );
      default:
        return <rect x="30" y="30" width="40" height="40" rx="4" fill="none" stroke={primaryColor} strokeWidth={strokeWidth} />;
    }
  };

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      className={cn(
        "drop-shadow-sm transition-all duration-500",
        isMythic && "animate-supreme-glow",
        className
      )}
      xmlns="http://www.w3.org/2000/svg"
    >
      {renderShape()}
    </svg>
  );
};