# Palestras coletivas

Um ambiente para você organizar suas palestras, eventos e compartilhar conhecimento.

## Status do código

[![Code Climate](https://codeclimate.com/github/tasafo/palestras-coletivas/badges/gpa.svg)](https://codeclimate.com/github/tasafo/palestras-coletivas) [![Test Coverage](https://codeclimate.com/github/tasafo/palestras-coletivas/badges/coverage.svg)](https://codeclimate.com/github/tasafo/palestras-coletivas) [![Build Status](https://travis-ci.org/tasafo/palestras-coletivas.svg?branch=master)](https://travis-ci.org/tasafo/palestras-coletivas)

## E como eu instalo isso no meu Ubuntu?

### Aconselhamos você a usar o gerenciador de versões Ruby (http://rvm.io)

    curl -sSL https://get.rvm.io | bash -s stable

### Vamos usar a versão 2 do Ruby

    rvm install 2.3.0

### Usamos o MongoDB, então instala ele lá!

    sudo apt-get install mongodb

### Aproveita e instala a biblioteca para gerenciar o mongo (http://genghisapp.com/)

    gem install genghisapp

### Usamos o Redis-Server, então instala ele lá!

    sudo apt-get install redis-server

### Instala também a biblioteca webkit, que é uma dependência do capybara-webkit

    sudo apt-get install qt5-default libqt5webkit5-dev

### MailCatcher (http://mailcatcher.me)

#### Instale o MailCatcher para testar o envio de e-mails localmente.

    gem install mailcatcher

#### Execute ele para ficar recebendo seus e-mails locais

    mailcatcher

### Baixa as dependências do projeto

    bundle install

Agora espera...

### Depois roda esse comando para adicionar uns dados no banco

    rake db:seed

### Em um terminal, execute o sidekiq para executar as tarefas de segundo plano

    sidekiq

### Se você estiver executando outra aplicação que utilize o sidekiq, é melhor rodar o comando

    redis-cli flushall

### Agora é só rodar e brincar!

    rails server

### Em seu navegador, abra o endereço abaixo para testar a aplicação

    localhost:3000

### Em seu navegador, abra o endereço abaixo para analisar as tarefas em segundo plano

    localhost:3000/sidekiq

### Em seu navegador, abra o endereço abaixo para analisar os e-mails recebidos localmente

    localhost:1080

### Executar os testes com a geração do relatório de cobertura, que será gravado na pasta coverage.

    rake spec:coverage

### Em produção, você deve gerar o token de segurança da aplicação

    echo "SECRET_TOKEN=`bundle exec rake secret`" > .env

## Licença

O Palestras Coletivas é liberado sob a [MIT License](http://www.opensource.org/licenses/MIT).
