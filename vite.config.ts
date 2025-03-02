import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import yaml from '@rollup/plugin-yaml';

import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [yaml(), sveltekit(), tailwindcss()],
});
