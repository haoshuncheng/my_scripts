#!/bin/sh

case $2 in 
	server )
	 /bin/sh server.sh $1
	 ;;

	client )
	 /bin/sh client.sh $1
	 ;;

	 * )
	 echo 'Pls specify the role, server|client'
	 ;;
esac