export OS_USERNAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_BAREMETAL_API_VERSION=1.34
export NOVA_VERSION=1.1
export OS_PROJECT_NAME=admin
export OS_PASSWORD=fPGXnUptccRWGyMKGAUjcWXJs
export OS_NO_CACHE=True
export COMPUTE_API_VERSION=1.1
export no_proxy=,10.250.23.52,10.250.11.39
export OS_VOLUME_API_VERSION=3
export OS_CLOUDNAME=overcloud
export OS_AUTH_URL=http://10.250.23.52:5000/v3
export IRONIC_API_VERSION=1.34
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_AUTH_TYPE=password
export PYTHONWARNINGS="ignore:Certificate has no, ignore:A true SSLContext object is not available"

# Add OS_CLOUDNAME to PS1
if [ -z "${CLOUDPROMPT_ENABLED:-}" ]; then
    export PS1=${PS1:-""}
    export PS1=\${OS_CLOUDNAME:+"(\$OS_CLOUDNAME)"}\ $PS1
    export CLOUDPROMPT_ENABLED=1
fi