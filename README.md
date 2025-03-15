# ICP备案查询应用

一个现代、简洁的ICP备案查询前端应用，支持多种类型的查询和友好的用户界面。

## 功能特点

- 支持多种查询类型：网站、APP、小程序、快应用及其违规查询
- 支持导出为JSON和Excel格式
- 响应式设计，适配不同屏幕尺寸
- 分页功能，支持一键查看全部结果
- 刷新数据和清除搜索功能

## 使用Docker部署

### 使用Docker Compose（推荐）

1. 确保您已安装 [Docker](https://www.docker.com/get-started) 和 [Docker Compose](https://docs.docker.com/compose/install/)

2. 克隆本仓库到本地：
   ```bash
   git clone <repository-url>
   cd icp-query
   ```

3. 使用Docker Compose构建并启动应用：
   ```bash
   docker-compose up -d
   ```

4. 应用将在 http://localhost:8080 上运行

### 使用Docker命令行

1. 构建Docker镜像：
   ```bash
   docker build -t icp-query-app .
   ```

2. 运行容器：
   ```bash
   docker run -d -p 8080:80 --name icp-query-app icp-query-app
   ```

3. 应用将在 http://localhost:8080 上运行

### 构建问题排查

如果在构建过程中遇到以下问题，请尝试以下解决方案：

#### 错误: `crypto$2.getRandomValues is not a function`
- 已在Dockerfile中更新为使用完整的node:16镜像而非alpine版本
- 如果仍然遇到问题，可以尝试本地构建

#### 错误: `exit code: 127` (找不到命令)
- 检查package.json中的scripts部分是否正确设置了build命令
- 确保vite已正确安装：`npm install -g vite`
- 在项目根目录中确保存在vite.config.js文件

#### 错误: `No dist folder found`
- 尝试在本地先构建：
  ```bash
  npm install
  npm run build
  ```
  然后检查dist文件夹是否生成

#### 网络问题导致构建失败
如果在中国大陆构建，可能需要设置npm镜像：
```bash
# 在Dockerfile中添加
RUN npm config set registry https://registry.npmmirror.com
```

### 手动预构建方法

如果Docker构建持续失败，可以尝试以下手动步骤：

1. 本地构建前端应用：
   ```bash
   npm install
   npm run build
   ```

2. 创建一个更简单的Dockerfile，仅复制预构建的dist文件夹：
   ```dockerfile
   FROM nginx:stable-alpine
   COPY ./dist /usr/share/nginx/html
   COPY nginx.conf /etc/nginx/conf.d/default.conf
   EXPOSE 80
   CMD ["nginx", "-g", "daemon off;"]
   ```

3. 构建并运行简化版Docker镜像：
   ```bash
   docker build -t icp-query-app-simple .
   docker run -d -p 8080:80 --name icp-query-app icp-query-app-simple
   ```

## 自定义配置

### API服务器配置

如果需要连接到自定义的后端API服务，可以通过以下方式配置：

1. 修改 `.env` 文件中的API地址
2. 修改 `nginx.conf` 文件中的代理设置
3. 在docker-compose.yml中设置环境变量

### 端口配置

默认情况下，应用在容器内部使用80端口，映射到主机的8080端口。如需修改，请编辑docker-compose.yml中的端口映射：

```yaml
ports:
  - "YOUR_PORT:80"
```

## 开发指南

### 项目设置
```
npm install
```

### 开发环境编译和热重载
```
npm run serve
```

### 生产环境编译和压缩
```
npm run build
```

## 上传到GitHub

1. 创建GitHub仓库并初始化本地Git：
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. 添加远程仓库并推送：
   ```bash
   git remote add origin git@github.com:用户名/仓库名.git
   git push -u origin main
   ```

3. 如果使用SSH连接，请先设置SSH密钥：
   ```bash
   ssh-keygen -t rsa -b 4096 -C "你的邮箱"
   cat ~/.ssh/id_rsa.pub   # 复制此内容添加到GitHub的SSH keys中
   ```

## 技术栈

- Vue 3 (组合式API)
- Vue Router
- Element Plus
- Axios
- XLSX和File-Saver (用于导出功能)

## API接口说明

### GET请求

```
GET /query/{type}?search={name}&pageNum={pageNum}&pageSize={pageSize}
```

### POST请求

```
POST /query/{type}
Content-Type: application/json

{
  "search": "查询内容",
  "pageNum": 页码,
  "pageSize": 每页条数
}
```

### 参数说明

- `type`: 查询类型，可选值为web、app、miniapp、quickapp
- `search`: 查询内容，如域名、备案号或企业名称
- `pageNum`: 页码，默认为1
- `pageSize`: 每页条数，默认为10

## 开发说明

项目使用Vite作为构建工具，通过以下目录结构组织代码：

- `src/components`: 组件目录
- `src/utils`: 工具函数目录
- `src/assets`: 静态资源目录
- `public`: 公共资源目录

## 许可证

MIT 