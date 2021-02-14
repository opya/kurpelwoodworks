system "roda-parse_routes -pf routes.json config.ru #{Dir["routes/*.rb"].join(' ')}"
