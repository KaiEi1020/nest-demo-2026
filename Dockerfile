# ==============================
# 阶段一：构建阶段 (命名为 builder)
# ==============================
FROM node:20-alpine AS builder

RUN npm install -g pnpm
WORKDIR /app

# 拷贝依赖配置文件并安装所有依赖（包含 devDependencies）
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# 拷贝源码并执行构建，生成 dist 目录
COPY . .
RUN pnpm run build

# ==============================
# 阶段二：生产运行阶段 (最终镜像)
# ==============================
FROM node:20-alpine

RUN npm install -g pnpm
WORKDIR /app

# 再次拷贝依赖配置文件
COPY package.json pnpm-lock.yaml ./

# 核心优化点：只安装生产环境依赖 (--prod)
RUN pnpm install --frozen-lockfile --prod

# 核心优化点：只从 builder 阶段把编译好的产物拿过来
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["pnpm", "run", "start:prod"]