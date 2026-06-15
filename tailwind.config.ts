import type { Config } from 'tailwindcss'

export default {
  darkMode: ['class'],
  content: [
    './src/**/*.{ts,tsx}',
    './.lovable/**/*.{ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        // Semantic Arcane Aliases
        'arcane-gold': '#D4AF37',
        'void-slate': '#020617',
        'blood-red': '#7F1D1D',
      },
      fontFamily: {
        cinzel: ['Cinzel', 'serif'],
        sans: ['Inter', 'sans-serif'],
      },
      boxShadow: {
        'gold-glow': '0 0 15px rgba(212, 175, 55, 0.3)',
        'blood-glow': '0 0 15px rgba(127, 29, 29, 0.5)',
      }
    },
  },
  plugins: [require('tailwindcss-animate')],
} satisfies Config