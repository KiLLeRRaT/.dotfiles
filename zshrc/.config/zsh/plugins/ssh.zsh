ssh-remove-and-connect(){
	# $1 is in the form of username@hostname
	username=$(cut -d'@' -f1 <<< $1)
	hostname=$(cut -d'@' -f2 <<< $1)
	sed -i.bak "/^$hostname /d" ~/.ssh/known_hosts
	# ssh $username@$hostname
	ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o PasswordAuthentication=yes $username@$hostname
}

ssh-with-password(){
	username=$(cut -d'@' -f1 <<< $1)
	hostname=$(cut -d'@' -f2 <<< $1)
	ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o PasswordAuthentication=yes $username@$hostname
}

