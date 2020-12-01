# ISPConfig Server With Ansible

This is an evolution from https://github.com/ruppel/SecureServerWithAnsible.

I was kind of disappointed from ISPConfig and wanted to move to something other, but came back... 'cause ISPConfig is still the best for me.

By now, this is not finished!!! It's still under construction!

# Great tutorials where the scripts here are based on

- https://www.howtoforge.com/perfect-server-debian-10-buster-apache-bind-dovecot-ispconfig-3-1/
- https://www.howtoforge.com/tutorial/how-to-install-php-7-for-ispconfig-3-from-debian-packages-on-debian-8-and-9/
- https://www.howtoforge.com/replacing-amavisd-with-rspamd-in-ispconfig/#enable-rspamd-in-ispconfig
- The book "Rootserver unter Debian/GNU Linux Jessie" from Daniel Gestl

# Setup your ansible controller machine

This is based on Debian Buster (10) minimal installation.

- Install ansible (minimum version 2.9).
  See `010-install-ansible-controller.sh` for simple script that installs ansible on debian

# Setup ansible host

- Have a non-root user on the host, who is allowed to call `sudo`
  (On Ubuntu `adduser username`, give password and data and do a `usermod -aG sudo username`)
- Copy your public ssh key to file `.ssh/authorized_keys` to use Public/Private Key SSH Connection
- Do the ssh connection to the server (to check if it works and to get the fingerprint of the server)

# Initial Setup variables

- Copy file `inventory_example.yml` to `myinventory.yml`
- Change values in `myinventory.yml` to your needs, especially `ansible_host`, `ansible_user`, `ansible_ssh_pass`, and `ansible_become_password`
- Set `ansible_port` to 22, which is the default ssh port. Or directly to the port you configured your server

# Check the ansible connection using

- `ansible-playbook -i myinventory.yml pingtest.yml`

It should return a "OK"

- Change vars in file `myinventory.yml` to your needs. Especially you are encouraged to change the ssh port to something other than 22, take 22401 for example.

# Bootstrap ansible host

- `ansible-playbook -i myinventory.yml 020-bootstrap.yml`
  This checks the ssh port and changes it if needed and ensures that en_US is the default locale.

# Check the ansible connection

- `ansible-playbook -i myinventory.yml pingtest.yml`
  This is the same test above, but it's now using the other ssh port.

# Set the stage

- `ansible-playbook -i myinventory.yml 030-set-the-stage.yml`
  This sets the hostname, enhances the sources for apt, installs required ansible tools, updates the system, does a restart, changed dash to bash and disabled sendmail

# Install the applications

- `ansible-playbook -i myinventory.yml 040-applications.yml`
  This will install ntp, ufw, automatic security updates, fail2ban, mariadb, dovecot, postfix, clamav, rspamd, apache, php-fpm, multiple php versions, lets-encrypt, mailman, pureftp, bind9, webalizer, jailkit, phpmyadmin, roundcube

# Install ISPConfig

- `ansible-playbook -i myinventory.yml 050-ispconfig.yml`

# Access to ISPConfig

- You should now be able to access your ISPConfig panel under https://(subdomain).(domain):(adminpanel.port) as given in your inventory file.
  (For my convenience in the further documentation I reference this url to https://server.example.com:8080)

# Configure the installed php versions in ispconfig

- Do the manual steps at the start of https://www.howtoforge.com/tutorial/how-to-install-php-7-for-ispconfig-3-from-debian-packages-on-debian-8-and-9/
  You only need to follow chapter 2. And we only installed PHP 7.2, 7.3 and 7.3!
- You could check the config by creating a site, set PHP to 'Fast-CGI' and a PHP version. Create an info.php file in the web folder of the site and check it using your browser.
- Be sure to remove the info.php file afterwards.

# Activate rspam in ispconfig

- The manual steps are documented here: https://www.howtoforge.com/replacing-amavisd-with-rspamd-in-ispconfig/#enable-rspamd-in-ispconfig
  But it seems that you only have to set another passwort for rspamd (because we never installed amavisd).

# Activate firewall (ufw) in the ISPConfig Web-UI

- Go to `https://server.example.com:8080` (use the FQDN from your configuration!!) and login in as admin (see above)
- Go to `System`->`Firewall`
- Click on `Add Firewall record`
- Choose your server
- Edit the TCP Ports. **WARNING Be sure to add your specified SSH Port and your ISPConfig Port**. You might want to delete some of the ports not used.
- Be sure that the state is `Active`
- Click on `Save`
- After a few seconds the firewall should be active

# Configure your servers and emails

- You should now configure your servers and email adresses using the ISPConfig Web-UI
- The mailadresses used in the `myinventory.yml` file should be present

# NOT YET FINISHED

There are some problems open:

- phpmyadmin and roundcube are not working. The php code doesn't get interpreted.
