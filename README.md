# Palestras coletivas

[![Maintainability](https://api.codeclimate.com/v1/badges/cf2793af7e6bceef3b92/maintainability)](https://codeclimate.com/github/tasafo/palestras-coletivas/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/cf2793af7e6bceef3b92/test_coverage)](https://codeclimate.com/github/tasafo/palestras-coletivas/test_coverage) [![Build Status](https://travis-ci.org/tasafo/palestras-coletivas.svg?branch=master)](https://travis-ci.org/tasafo/palestras-coletivas) [![security](https://hakiri.io/github/tasafo/palestras-coletivas/master.svg)](https://hakiri.io/github/tasafo/palestras-coletivas/master)

Um ambiente para você organizar suas palestras, eventos e compartilhar conhecimento

## Sistemas Operacionais [Debian](https://www.debian.org/) ou [Ubuntu](https://www.ubuntu.com/) Linux

### Ambiente de desenvolvimento

#### Instalação

Linguagem Ruby com [RVM](http://rvm.io)

    curl -sSL https://get.rvm.io | bash -s stable

    rvm install 2.5.0

Bancos de dados [MongoDB](https://www.mongodb.com/) e [Redis](https://redis.io/)

    sudo apt-get install mongodb redis-server

Bibliotecas para executar testes de aceitação com [Capybara](https://github.com/thoughtbot/capybara-webkit)

    sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

O [Genghisapp](http://genghisapp.com/) gerencia os bancos do MongoDB

    gem install genghisapp

O [MailCatcher](http://mailcatcher.me) visualiza o envio de e-mails locais

    gem install mailcatcher

O [Foreman](https://github.com/ddollar/foreman) gerencia a aplicação

    gem install foreman

#### Configuração

Faz o download das bibliotecas requeridas pelo projeto

    bundle install

Copie o exemplo e depois edite o arquivo de configurações

    cp .env.example .env

Insere registros do arquivo db/seed.rb no banco de dados

    rails db:seed

#### Execução

Permite visualizar os e-mails locais em http://localhost:1080

    mailcatcher

Executa a aplicação no endereço http://localhost:5000

    foreman start

Para visualizar as tarefas do sidekiq, acesse http://localhost:5000/sidekiq e informe as credenciais de acesso

Se você estiver executando outra aplicação que utilize o sidekiq, é melhor executar

    redis-cli flushall

### Ambiente de teste

Executa a bateria de testes com a geração do relatório de cobertura, gravado na pasta coverage

    rails spec:coverage

### Ambiente de produção

Deve ser gerado o token de segurança

    echo "SECRET_KEY_BASE=`bundle exec rails secret`" >> .env

## Licença

O Palestras Coletivas é liberado sob a [MIT License](http://www.opensource.org/licenses/MIT).
