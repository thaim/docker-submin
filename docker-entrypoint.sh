#!/bin/bash

set -x

# use command submin
hostname="${SUBMIN_HOSTNAME:-submin.local}"
external_port="${SUBMIN_EXTERNAL_PORT:-80}"
data_dir="${SUBMIN_DATA_DIR:-/var/lib/submin}"
svn_repo="${SUBMIN_SVN_DIR:-/var/lib/svn}"
admin_mail="${SUBMIN_ADMIN_MAIL:-root@submin.local}"

if [ ! -e ${data_dir} ]; then
    echo -e "svn\n${svn_repo}\n${hostname}:${external_port}\n\n\n" \
        | submin2-admin ${data_dir} initenv ${admin_mail} >/dev/null

    if [ "$SUBMIN_SMTP_HOSTNAME" ]; then
        submin2-admin /var/lib/submin config set smtp_hostname $SUBMIN_SMTP_HOSTNAME
    fi

    if [ "$SUBMIN_SMTP_PORT" ]; then
        submin2-admin /var/lib/submin config set smtp_port "$SUBMIN_SMTP_PORT"
    fi

    submin2-admin ${data_dir} apacheconf create all >/dev/null 2>&1 || true

    ln -s ${data_dir}/conf/apache-2.4-webui-cgi.conf /etc/apache2/conf-available/
    ln -s ${data_dir}/conf/apache-2.4-svn.conf /etc/apache2/conf-available/

    {
        a2enconf apache-2.4-webui-cgi
        a2enconf apache-2.4-svn
        a2enmod authn_dbd
        a2enmod rewrite
        a2enmod cgid
    } >/dev/null 2>&1

    # disable git
    submin2-admin ${data_dir} config set vcs_plugins svn || true

    key=`echo "SELECT key FROM password_reset;" | sqlite3 ${data_dir}/conf/submin.db`
    echo "access http://${hostname}:${external_port}/submin/password/admin/${key} to reset password"

else
    echo "Submin is already configured in ${data_dir}/conf"
fi
service apache2 restart

tail -f /var/log/apache2/access.log /var/log/apache2/error.log
