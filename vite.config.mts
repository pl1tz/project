import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import RubyPlugin from 'vite-plugin-ruby';
import viteTsconfigPaths from 'vite-tsconfig-paths';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    react(),
    viteTsconfigPaths()
  ]
});
