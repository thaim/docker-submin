# docker-submin

web gui for svn running on docker

See [Submin](https://supermind.nl/submin/) for more details.

See [Docker hub](https://hub.docker.com/r/thaim/submin/) for tags list and build details.

quick start
If you want to run submin container on server "http://example.com" with port "8080",

    docker run -d -p "8080:80" -e "SUBMIN_HOSTNAME=example.com" -e "SUBMIN_EXTERNAL_PORT=8080" thaim/submin

After initialization done, container print URL on logs to reset password as below:

    access http://example.com:8080/submin/password/admin/NX6UIpOvlab0B8QYQTKE1d4xQQ9qNl0XG1pkeUV8xg9bbcj1q4 to reset password

## Notes

* Git feature is disabled.
* Email feature is not working now.
