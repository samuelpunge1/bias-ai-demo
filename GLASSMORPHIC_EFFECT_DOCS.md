# Glassmorphic Letter Effect Documentation

## Visual Design

Each letter in "Bias AI" is rendered as an **individual glass container** with the following properties:

### Glass Effect Components (Per Letter):

```
┌─────────────────────────────┐
│  Top gradient shine (0.8)   │  ← White gradient like CSS ::before
├─────────────────────────────┤
│ ╔═══════════════════════╗   │
│ ║                       ║   │  ← Left gradient shine (0.8 → 0 → 0.3)
│ ║    Glass Container    ║   │     like CSS ::after
│ ║                       ║   │
│ ║  Background: rgba     ║   │  ← Semi-transparent white (0.1)
│ ║  (255,255,255,0.1)    ║   │
│ ║                       ║   │
│ ║  Backdrop Blur: 20px  ║   │  ← Blurs background behind letter
│ ║                       ║   │
│ ║  Border: rgba         ║   │  ← White border (0.3 opacity)
│ ║  (255,255,255,0.3)    ║   │
│ ║                       ║   │
│ ║     [LETTER]          ║   │  ← Actual letter with gradient
│ ║                       ║   │
│ ╚═══════════════════════╝   │
│                             │
│ Purple accent (top-left)    │  ← Radial gradient accent
│ Blue accent (bottom-right)  │  ← Radial gradient accent
└─────────────────────────────┘
```

## CSS-Inspired Implementation

The Flutter implementation recreates these CSS properties:

### CSS Glass Card:
```css
background: rgba(255, 255, 255, 0.1);       → Container color with 0.1 opacity
backdrop-filter: blur(20px);                → BackdropFilter with 20px blur
border: 1px solid rgba(255, 255, 255, 0.3); → Border with 0.3 opacity
box-shadow: multiple shadows                → Multiple BoxShadow widgets
inset shadows                               → Inner glow effects
::before (top gradient)                     → Positioned gradient container
::after (left gradient)                     → Positioned gradient container
```

## Letter Properties:

1. **Container Size**: 
   - Width: fontSize × 0.85
   - Height: fontSize × 1.1
   - Border radius: fontSize × 0.15

2. **Glass Effects**:
   - Background: White at 10% opacity
   - Backdrop blur: 20px (blurs content behind)
   - Border: White at 30% opacity
   - Multiple shadows for depth

3. **Gradient Overlays**:
   - Top shine: Transparent → White (0.8) → Transparent
   - Left shine: White (0.8) → Transparent → White (0.3)
   - Inner radial glow: White (0.15) → White (0.05) → Transparent

4. **Accent Colors**:
   - Top-left corner: Purple radial gradient (20% opacity)
   - Bottom-right corner: Blue radial gradient (20% opacity)

5. **Letter Rendering**:
   - ShaderMask with gradient: White → Blue → Purple → White
   - Blue shadow offset (2, 2)
   - Purple shadow offset (-2, -2)
   - White glow for visibility

6. **Animation**:
   - Shimmer effect sliding across each letter
   - Floating motion (±8px vertical)
   - Glow pulsing (0.4 → 1.0 opacity)

## Visual Result:

```
 ┌───┐ ┌───┐ ┌───┐ ┌───┐   ┌───┐ ┌───┐
 │ B │ │ i │ │ a │ │ s │   │ A │ │ I │
 └───┘ └───┘ └───┘ └───┘   └───┘ └───┘
   ↑     ↑     ↑     ↑       ↑     ↑
   │     │     │     │       │     │
Individual glass containers with blur, shine, and accents
```

Each letter appears as a frosted glass panel with:
- Depth and dimension from shadows
- Transparency showing content behind
- Glossy shine on top and left edges
- Blue and purple color accents
- Subtle shimmer animation

## Font Settings:
- Size: 90px (bigger than before)
- Weight: Bold (700)
- Letter spacing: 12px between glass containers
- Text color: White with blue/purple gradient overlay

The overall effect creates text that appears to be made from individual pieces of frosted glass with colored lighting, floating on a pure black background.
