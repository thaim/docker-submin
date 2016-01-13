#!/bin/bash

set -e

# use command submin
if [[ "$1" == -* ]]; then
	set -- submin "$@"
fi

if [ "$1" = 'submin' ]; then
    data_dir="${SUBMIN_DATA_DIR:-/var/lib/submin}"
    admin_mail="${SUBMIN_ADMIN_MAIL:-root@submin.local}"
    svn_repo="/var/lib/svn"
    hostname="${SUBMIN_HOSTNAME:-submin.local}"

    echo -e "svn\n${svn_repo}\n${hostname}\n\n\n" \
        | submin2-admin ${data_dir} initenv ${admin_mail}
    chown www-data:www-data ${svn_repo}

    set +e
    echo -e "\nstart to create apacheconf with data dir=${data_dir}"
    submin2-admin ${data_dir} apacheconf create all
    set -e

    ln -s ${data_dir}/conf/apache-2.4-webui-cgi.conf /etc/apache2/conf-available/
    ln -s ${data_dir}/conf/apache-2.4-svn.conf /etc/apache2/conf-available/

    a2enconf apache-2.4-webui-cgi
    a2enconf apache-2.4-svn
    a2enmod authn_dbd
    a2enmod rewrite
    a2enmod cgid

    submin2-admin ${data_dir} config set vcs_plugins svn

    service apache2 stop
    /usr/sbin/apache2ctl -D FOREGROUND
fi

exec "$@"
