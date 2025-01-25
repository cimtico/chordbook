just := "just"

default:
    @{{ just }} --list

bootstrap:
    {{ just }} start backend:*
    {{ just }} setup
    {{ just }} start chordbook:*
    @{{ just }} status && echo " Ready! " || echo " There was a problem, please check the logs "
    @echo "Visit your local stack at:"
    @echo -e "  http://localhost:3000"

clean:
    rm -rf ./vendor/nix ./public/vite-dev ./public/vite-test ./tmp/cache/* ./log/*
    find {{ justfile_directory() }} --name node_modules -type d -prune | xargs -t rm -rf

destroy:
    @{{ just }} shutdown && sleep 10 && {{ just }} clean

prune:
    nix-collect-garbage -d
    bundle clean
    for l in log/*.log ; do truncate -s 0 $1 ; done

ps:
    @ps --ppid $(supervisorctl pid) -o pid,%cpu,bsdtime,%mem,rss,size,cmd

setup:
    bundle install && yarn install && {{ just }} setup_db

supervisord:
    @./bin/services/supervisord

reload:
    kill -HUP $(supervisorctl pid)

start *args="all": supervisord
    supervisorctl start {{ args }}
    
stop *args="all": supervisord
    supervisorctl stop {{ args }}

restart *args="all": supervisord
    supervisorctl restart {{ args }}

shutdown:
    supervisorctl shutdown

status *args:
    supervisorctl status {{ args }}

logs:
    tail -f log/*.log

console:
    bin/rails c

test:
    bin/rails test

rails *args:
    ./bin/rails {{ args }}

_pg_ready:
    @./bin/wait-for-it.sh localhost 5432

setup_db: _pg_ready
    bin/rake db:setup

migrate: _pg_ready
    bin/rails db:migrate

replant:
    @{{ just }} stop chordbook:* && sleep 10
    ./bin/rake db db:reset db:setup db:migrate
    @{{ just }} start chordbook:*

db_regen:
    @{{ just }} stop chordbook:* && sleep 10
    ./bin/rake db db:drop db:create db:migrate db:setup
    @{{ just }} start chordbook:*

pry app="chordbook:puma":
    supervisorctl fg {{ app }}

psql args="chordbook_development": _pg_ready
    psql -U postgres -h localhost -p 5432 -w {{ args }}

rake *args:
    ./bin/rake {{ args }}
