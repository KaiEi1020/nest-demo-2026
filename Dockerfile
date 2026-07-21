# 1. 基础镜像
FROM node:20-alpine

# 2. 全局安装 pnpm
RUN npm install -g pnpm

# 3. 设置工作目录
WORKDIR /app

# 4. 复制 pnpm 的依赖锁文件与配置
COPY package.json pnpm-lock.yaml ./

# 5. 安装项目依赖
RUN pnpm install --frozen-lockfile

# 6. 复制源码并执行 NestJS 构建
COPY . .
RUN pnpm run build

# 7. 暴露 3000 端口
EXPOSE 3000

# 8. 启动应用
CMD ["pnpm", "run", "start:prod"]
