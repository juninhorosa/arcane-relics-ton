import React from 'react';
import { cn } from '@/lib/utils';

interface NationCrestProps {
  nationCode: string;
  className?: string;
  size?: number;
}

/**
 * Componente que renderiza o brasão SVG de uma nação baseado no código.
 * Utiliza as cores do Design System (Arcane Gold, Blood Red, Void Slate).
 */
export const NationCrest: React.FC<NationCrestProps> = ({ nationCode, className, size = 100 }) => {
  const colors = {
    gold: '#D4AF37',
    slate: '#020617',
    blood: '#7F1D1D',
    silver: '#94a3b8',
  };

  // Renderiza o símbolo interno baseado na nação
  const renderSymbol = (code: string) => {
    switch (code.toUpperCase()) {
      case 'BLOOD':
        return (
          <path 
            d="M50 30 L60 50 L50 70 L40 50 Z M50 20 L50 80 M30 50 L70 50" 
            stroke={colors.gold} strokeWidth="3" fill="none" 
          />
        );
      case 'VOID':
        return (
          <circle cx="50" cy="50" r="15" stroke={colors.gold} strokeWidth="2" fill="none">
            <animate attributeName="r" values="12;16;12" dur="3s" repeatCount="indefinite" />
          </circle>
        );
      case 'GOLD':
        return (
          <path 
            d="M50 25 L58 45 L78 45 L62 58 L68 78 L50 65 L32 78 L38 58 L22 45 L42 45 Z" 
            fill={colors.gold} 
          />
        );
      case 'IRON':
        return (
          <rect x="35" y="35" width="30" height="30" stroke={colors.gold} strokeWidth="4" fill="none" transform="rotate(45 50 50)" />
        );
      case 'SHADOW':
        return (
          <path 
            d="M40 30 Q50 50 40 70 Q70 50 40 30" 
            fill={colors.gold} 
          />
        );
      default:
        return <circle cx="50" cy="50" r="10" fill={colors.gold} />;
    }
  };

  const getNationColor = (code: string) => {
    if (code.toUpperCase() === 'BLOOD') return colors.blood;
    if (code.toUpperCase() === 'VOID') return colors.slate;
    return '#1e293b'; // Fallback
  };

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      className={cn("drop-shadow-lg", className)}
      xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <linearGradient id={`grad-${nationCode}`} x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style={{ stopColor: colors.gold, stopOpacity: 1 }} />
          <stop offset="50%" style={{ stopColor: '#B8860B', stopOpacity: 1 }} />
          <stop offset="100%" style={{ stopColor: colors.gold, stopOpacity: 1 }} />
        </linearGradient>
        <filter id="f1" x="0" y="0" width="200%" height="200%">
          <feOffset result="offOut" in="SourceAlpha" dx="2" dy="2" />
          <feGaussianBlur result="blurOut" in="offOut" stdDeviation="2" />
          <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
        </filter>
      </defs>

      {/* Corpo do Escudo */}
      <path
        d="M10 20 Q10 10 20 10 L80 10 Q90 10 90 20 L90 50 Q90 90 50 95 Q10 90 10 50 Z"
        fill={getNationColor(nationCode)}
        stroke={`url(#grad-${nationCode})`}
        strokeWidth="4"
      />

      {/* Detalhe de Borda Interna */}
      <path
        d="M20 20 L80 20 L80 50 Q80 80 50 85 Q20 80 20 50 Z"
        fill="none"
        stroke={colors.gold}
        strokeWidth="1"
        opacity="0.3"
      />

      {/* Símbolo Central */}
      <g filter="url(#f1)">
        {renderSymbol(nationCode)}
      </g>

      {/* Brilho Superior */}
      <path d="M25 15 L75 15" stroke="white" strokeWidth="0.5" opacity="0.2" />
    </svg>
  );
};