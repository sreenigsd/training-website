# Choose base Ubuntu image from DockerHub
FROM ubuntu:latest

# Update and install necessary libraries and tools
RUN apt-get update && apt-get install -y apache2

# Configure Apache to serve content from /var/www/html and listen on port 80
WORKDIR /var/www/html

# Copy the HTML file and the images folder to the Apache directory
COPY ./index.html .
COPY ./images/ images/

# Expose port 80
EXPOSE 80

# Start Apache2 in the foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
