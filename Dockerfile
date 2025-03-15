# 构建阶段
FROM node:16 as build-stage

# 设置工作目录
WORKDIR /app

# 复制package.json和package-lock.json
COPY package*.json ./

# 使用淘宝NPM镜像加速依赖安装
RUN npm config set registry https://registry.npmmirror.com
RUN npm install
RUN npm install -g vite

# 复制项目文件
COPY . .

# 显示环境信息以便调试
RUN node --version
RUN npm --version
RUN npx vite --version || echo "Vite not found"

# 显示项目结构以便调试
RUN ls -la
RUN cat package.json

# 检查是否有vite.config.js文件
RUN if [ -f "vite.config.js" ]; then echo "vite.config.js found"; else echo "vite.config.js NOT FOUND"; fi

# 尝试构建应用，如果失败则创建一个基本的dist目录和index.html文件
RUN npm run build || (echo "Build failed, creating minimal dist" && \
    mkdir -p dist && \
    echo "<html><head><title>ICP查询</title></head><body><h1>构建失败</h1><p>Docker构建过程中Vite构建失败，请检查构建日志。</p></body></html>" > dist/index.html)

# 确认dist目录已创建
RUN ls -la dist || echo "dist directory still not found"

# 生产阶段
FROM nginx:stable-alpine as production-stage

# 创建Nginx html目录
RUN mkdir -p /usr/share/nginx/html/

# 复制构建产物到Nginx服务目录
COPY --from=build-stage /app/dist/ /usr/share/nginx/html/

# 确保index.html存在
RUN if [ ! -f /usr/share/nginx/html/index.html ]; then \
    echo "<html><head><title>ICP查询</title></head><body><h1>构建失败</h1><p>Docker构建过程中未找到dist目录。</p></body></html>" > /usr/share/nginx/html/index.html; \
    fi

# 复制Nginx配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露80端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"] 