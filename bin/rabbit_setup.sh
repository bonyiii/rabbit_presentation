rabbitmqctl add_user boni password
rabbitmqctl add_vhost demo
rabbitmqctl set_permissions -p demo boni ".*" ".*" ".*"
