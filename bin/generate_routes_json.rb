system "roda-parse_routes -pf ./web/routes.json config.ru #{Dir["./web/routes/*.rb"].join(' ')}"
