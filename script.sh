mysql_user="$1"
mysql_password="$2"
mysql_host="$3"
mysql_userfile="$4"
# Read CSV file and create MySQL users
while IFS=',' read -r username password; do
	echo $username $password
    if [ -n "$username" ] && [ -n "$password" ]; then
        # Use MySQL commands to create users
        mysql -h $mysql_host -u"$mysql_user" -p"$mysql_password" -e "CREATE USER '$username'@'%' IDENTIFIED WITH mysql_native_password BY '$password';"
        mysql -h $mysql_host -u"$mysql_user" -p"$mysql_password" -e "show databases;"
        echo "User '$username' created in MySQL."
    else
        echo "Invalid entry in CSV file: username and password are required."
    fi
done < "mysql_userfile"

