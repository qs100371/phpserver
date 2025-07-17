FROM php:7.3-fpm-alpine3.11

# 1. 使用国内镜像源加速（可选）
RUN echo "https://mirrors.aliyun.com/alpine/v3.11/main" > /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v3.11/community" >> /etc/apk/repositories

# 2. 仅安装必要软件（Nginx，删除所有编译工具）
RUN apk update && \
    apk add --no-cache nginx && \
    mkdir /run/nginx

# 3. 直接使用默认配置（删除不必要的扩展和自定义配置）
# 注：默认 php.ini 已足够，无需覆盖

# 4. 添加最小化文件
COPY index.php /var/www/html/
COPY default.conf /etc/nginx/conf.d/
COPY run.sh /

# 5. 设置权限并清理
RUN chmod +x /run.sh && \
    rm -rf /var/cache/apk/*

# 6. 暴露端口
EXPOSE 80

# 7. 启动命令
ENTRYPOINT ["/run.sh"]
