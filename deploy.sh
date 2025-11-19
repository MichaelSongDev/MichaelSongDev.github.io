#!/bin/bash

# =======================================================
# 博客自动化部署脚本 (deploy.sh)
# =======================================================

# 检查是否传入了 Commit Message
if [ -z "$1" ]; then
    echo "🚨 错误：请提供 Git 提交信息。"
    echo "用法: ./deploy.sh \"你的提交信息\""
    exit 1
fi

COMMIT_MESSAGE="$1"
HUGO_OUTPUT_DIR="docs" # 根据你的 publishDir 设置

echo "========================================"
echo "🚀 启动博客自动化部署流程..."
echo "========================================"

# --- 1. 静态编译 Hugo ---
echo "⚙️ (1/4) 正在运行 Hugo 静态编译，生成索引文件..."
# 使用 --cleanDestinationDir 确保彻底清除旧文件
hugo --cleanDestinationDir
hugo

if [ $? -ne 0 ]; then
    echo "❌ 错误：Hugo 编译失败。请检查您的文章或配置。"
    exit 1
fi

echo "✅ Hugo 编译完成。静态文件已生成至 /$HUGO_OUTPUT_DIR 文件夹。"

# --- 2. 运行 Algolia 索引脚本 ---
echo "🔍 (2/4) 正在运行 Algolia 索引脚本，上传搜索数据..."
# 假设你的 Algolia 脚本已配置为查找 docs/index.json
npm run algolia

if [ $? -ne 0 ]; then
    echo "⚠️ 警告：Algolia 索引上传失败。这可能是由于网络问题或配置错误。"
fi

echo "✅ Algolia 索引上传完成。"

# --- 3. 提交代码到 Git ---
echo "📤 (3/4) 正在提交代码到 Git..."
git add .
git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo "❌ 错误：Git 提交失败。请检查你的本地 Git 状态。"
    exit 1
fi

echo "✅ Git 提交完成。"

# --- 4. 推送到 GitHub ---
echo "🌐 (4/4) 正在推送代码到 GitHub (main 分支)..."
git push origin main

if [ $? -ne 0 ]; then
    echo "❌ 错误：Git 推送失败。请检查你的网络连接或权限。"
    exit 1
fi

echo "========================================"
echo "🎉 部署完成！"
echo "您的提交信息: $COMMIT_MESSAGE"
echo "GitHub Pages 将在几分钟内更新。"
echo "========================================"