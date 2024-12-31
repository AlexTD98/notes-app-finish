FROM ruby:3.0.1-buster

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_8.x | sh -
    
# Instalar dependencias del sistema y Node.js
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs

RUN npm install --global yarn

# Copia Gemfile y Gemfile.lock para instalar dependencias
COPY Gemfile Gemfile.lock ./

RUN bundle install


COPY . .

RUN rails webpacker:install

# Expone el puerto de la aplicación
EXPOSE 3000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]
