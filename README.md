# Flask_Project-Dockerfile-Nginx-Apache-Gunicorn
Hosting a basic Flask Application using Dockerfile along with Dual Layer of Nginx and Apache web server with Gunicorn and Alpine image.

In this project I have structured the application in following way:
- Firstly user interacts with the browser to send request.
- Now that browser will send request to Nginx web server listening on Port 80, and I've set Nginx's Pass Proxy Port to 8080
- Then I've set Apache's listen port on 8080, hence it recieves request from Nginx. And I've set Apache's Pass Proxy to 8000
- And by default Gunicorn listens on port 8000, which then interacts with the application and recieves the resposne for user's request.
