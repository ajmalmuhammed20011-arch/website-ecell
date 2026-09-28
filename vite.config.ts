import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
export default defineConfig({
  plugins: [react(), tailwindcss()],
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('/node_modules/three/')) return 'three';
          if (id.includes('/node_modules/@react-three/fiber/')) return 'fiber';
          if (id.includes('/node_modules/@react-three/drei/')) return 'drei';
          if (id.includes('/node_modules/framer-motion/')) return 'motion';
          if (id.includes('/node_modules/gsap/')) return 'gsap';
          if (id.includes('/node_modules/lenis/')) return 'lenis';
        },
      },
    },
  },
});
