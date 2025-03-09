import { sveltekit } from '@sveltejs/kit/vite';
import { enhancedImages } from '@sveltejs/enhanced-img';
import tailwindcss from '@tailwindcss/vite';
import yaml from '@rollup/plugin-yaml';

import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [yaml(), enhancedImages(), sveltekit(), tailwindcss()],
});
