import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  // 添加以下选项以解决构建问题
  build: {
    // 确保输出到dist目录
    outDir: 'dist',
    // 添加更多构建选项以提高兼容性
    commonjsOptions: {
      transformMixedEsModules: true,
    },
    // 构建失败时抛出错误
    emptyOutDir: true,
    // 生成源码映射文件
    sourcemap: false,
  },
  // 设置环境变量
  define: {
    'process.env': {}
  },
  // 开发服务器配置
  server: {
    port: 3000,
    proxy: {
      // 如果需要代理API请求，可以取消注释下面的配置
      // '/api': {
      //   target: 'http://your-backend-api-url',
      //   changeOrigin: true,
      //   rewrite: (path) => path.replace(/^\/api/, '')
      // }
    }
  }
}) 