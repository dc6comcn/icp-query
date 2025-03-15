# 构建阶段
FROM node:16 as build-stage

# 设置工作目录
WORKDIR /app

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装依赖项，确保全局安装vite
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

# 构建应用
RUN npm run build || (echo "Build failed, checking if vite.config.js exists" && ls -la)

# 生产阶段
FROM nginx:stable-alpine as production-stage

# 复制构建产物到Nginx服务目录
COPY --from=build-stage /app/dist/ /usr/share/nginx/html/

# 复制Nginx配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露80端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"] 