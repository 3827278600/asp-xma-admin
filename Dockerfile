# 使用 Node.js 镜像来构建应用
FROM node:18 AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 设置淘宝镜像源
RUN npm config set registry https://registry.npmmirror.com

# 安装 pnpm
RUN npm install -g pnpm

# 设置 pnpm 的淘宝镜像源
RUN pnpm config set registry https://registry.npmmirror.com

# 安装依赖
RUN pnpm install

# 复制应用源代码
COPY . .

# 构建应用
RUN pnpm run build

# 使用 Nginx 镜像来服务构建的应用
FROM nginx:latest

# 复制构建输出到 Nginx 的 html 目录
COPY --from=builder /app/build /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"] 