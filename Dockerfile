FROM alpine:latest

RUN apk update && apk add nginx apache2 apache2-proxy python3 py3-pip supervisor
RUN python3 -m venv /venv
RUN source /venv/bin/activate

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN /venv/bin/pip install --no-cache-dir -r /app/requirements.txt

COPY app.py /app/

RUN /venv/bin/pip install gunicorn

COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i 's/#LoadModule\ proxy_module/LoadModule\ proxy_module/' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule\ proxy_http_module/LoadModule\ proxy_http_module/' /etc/apache2/httpd.conf && \
    sed -i 's/^Listen 80/Listen 8080/' /etc/apache2/httpd.conf && \
    echo "<VirtualHost *:8080>" >> /etc/apache2/httpd.conf && \
    echo "ProxyPass / http://localhost:8000/" >> /etc/apache2/httpd.conf && \
    echo "ProxyPassReverse / http://localhost:8000/" >> /etc/apache2/httpd.conf && \
    echo "</VirtualHost>" >> /etc/apache2/httpd.conf

COPY supervisord.conf /etc/supervisord.conf    

EXPOSE 80 

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]