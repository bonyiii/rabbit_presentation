rabbitmqctl add_user demo_user password
rabbitmqctl add_vhost demo_vhost
rabbitmqctl set_permissions -p demo_vhost demo_user ".*" ".*" ".*"
