# encoding: UTF-8
#
# Cookbook Name:: openstack-identity
# Recipe:: default
#
# Copyright 2012-2013, AT&T Services, Inc.
# Copyright 2013, Opscode, Inc.
# Copyright 2013, IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default['openstack']['identity']['custom_template_banner'] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

# Adding these as blank
# this needs to be here for the initial deep-merge to work
default['credentials']['EC2']['admin']['access'] = ''
default['credentials']['EC2']['admin']['secret'] = ''

default['openstack']['identity']['verbose'] = 'False'
default['openstack']['identity']['debug'] = 'False'

# Specify a location to retrieve keystone-paste.ini from
# which can either be a remote url using http:// or a
# local path to a file using file:// which would generally
# be a distribution file - if this option is left nil then
# the templated version distributed with this cookbook
# will be used (keystone-paste.ini.erb)
default['openstack']['identity']['pastefile_url'] = nil

# array of lines to add to templated version of keystone-paste.ini
default['openstack']['identity']['misc_paste'] = []

# This specify the pipeline of the keystone public API,
# all Identity public API requests will be processed by the order of the pipeline.
# this value will be used in the templated version of keystone-paste.ini
# The last item in this pipeline must be public_service or an equivalent
# application. It cannot be a filter.
default['openstack']['identity']['pipeline']['public_api'] = 'sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension user_crud_extension public_service'
# This specify the pipeline of the keystone admin API,
# all Identity admin API requests will be processed by the order of the pipeline.
# this value will be used in the templated version of keystone-paste.ini
# The last item in this pipeline must be admin_service or an equivalent
# application. It cannot be a filter.
default['openstack']['identity']['pipeline']['admin_api'] = 'sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension s3_extension crud_extension admin_service'
# This specify the pipeline of the keystone V3 API,
# all Identity V3 API requests will be processed by the order of the pipeline.
# this value will be used in the templated version of keystone-paste.ini
# The last item in this pipeline must be service_v3 or an equivalent
# application. It cannot be a filter.
default['openstack']['identity']['pipeline']['api_v3'] = 'sizelimit url_normalize request_id build_auth_context token_auth admin_token_auth json_body ec2_extension_v3 s3_extension simple_cert_extension revoke_extension federation_extension oauth1_extension endpoint_filter_extension endpoint_policy_extension service_v3'

default['openstack']['identity']['region'] = node['openstack']['region']
# Amount of time a token should remain valid in seconds)
default['openstack']['identity']['token']['expiration'] = '3600'
default['openstack']['identity']['token']['hash_algorithm'] = 'md5'

# Logging stuff
default['openstack']['identity']['syslog']['use'] = false
default['openstack']['identity']['syslog']['facility'] = 'LOG_LOCAL2'
default['openstack']['identity']['syslog']['config_facility'] = 'local2'

# Number of Workers
default['openstack']['identity']['admin_workers'] = nil
default['openstack']['identity']['public_workers'] = nil

# RPC attributes
default['openstack']['identity']['control_exchange'] = 'openstack'
default['openstack']['identity']['notification_driver'] = 'messaging'
default['openstack']['identity']['rpc_thread_pool_size'] = 64
default['openstack']['identity']['rpc_conn_pool_size'] = 30
default['openstack']['identity']['rpc_response_timeout'] = 60
case node['openstack']['mq']['service_type']
when 'rabbitmq'
  default['openstack']['identity']['rpc_backend'] = 'rabbit'
when 'qpid'
  default['openstack']['identity']['rpc_backend'] = 'qpid'
end

# This references the domain to use for all Identity API v2
# requests (which are not aware of domains). A domain with
# this ID will be created for you by keystone-manage db_sync
# in migration 008. The domain referenced by this ID cannot be
# deleted on the v3 API, to prevent accidentally breaking the
# v2 API. There is nothing special about this domain, other
# than the fact that it must exist to order to maintain
# support for your v2 clients. (string value)
default['openstack']['identity']['identity']['default_domain_id'] = 'default'

# A subset (or all) of domains can have their own identity
# driver, each with their own partial configuration file in a
# domain configuration directory. Only values specific to the
# domain need to be placed in the domain specific
# configuration file. This feature is disabled by default; set
# to true to enable. (boolean value)
default['openstack']['identity']['identity']['domain_specific_drivers_enabled'] = false

# Path for Keystone to locate the domain specific identity
# configuration files if domain_specific_drivers_enabled is
# set to true. (string value)
default['openstack']['identity']['identity']['domain_config_dir'] = '/etc/keystone/domains'

default['openstack']['identity']['admin_user'] = 'admin'
default['openstack']['identity']['admin_tenant_name'] = 'admin'

default['openstack']['identity']['users'] = {
  default['openstack']['identity']['admin_user'] => {
    'default_tenant' => default['openstack']['identity']['admin_tenant_name'],
    'roles' => {
      'admin' => ['admin'],
      'service' => ['admin']
    }
  }
}

# SSL Options
# Specify whether to enable SSL for Keystone API endpoint
default['openstack']['identity']['ssl']['enabled'] = false
# Specify server whether to enforce client certificate requirement
default['openstack']['identity']['ssl']['cert_required'] = false
# SSL certificate, keyfile and CA certficate file locations
default['openstack']['identity']['ssl']['basedir'] = '/etc/keystone/ssl'
# Path of the cert file for SSL.
default['openstack']['identity']['ssl']['certfile'] = "#{node['openstack']['identity']['ssl']['basedir']}/certs/sslcert.pem"
# Path of the keyfile for SSL.
default['openstack']['identity']['ssl']['keyfile'] = "#{node['openstack']['identity']['ssl']['basedir']}/private/sslkey.pem"
# Path of the CA cert file for SSL.
default['openstack']['identity']['ssl']['ca_certs'] = "#{node['openstack']['identity']['ssl']['basedir']}/certs/sslca.pem"

# Security Assertion Markup Language (SAML)

# Default TTL, in seconds, for any generated SAML assertion
# created by Keystone. (integer value)
default['openstack']['identity']['saml']['assertion_expiration_time'] = 3600

# Binary to be called for XML signing. Install the appropriate
# package, specify absolute path or adjust your PATH
# environment variable if the binary cannot be found. (string
# value)
# xmlsec1_binary=xmlsec1
default['openstack']['identity']['saml']['xmlsec1_binary'] = 'xmlsec1'

# Path of the certfile for SAML signing. For non-production
# environments, you may be interested in using `keystone-
# manage pki_setup` to generate self-signed certificates.
# Note, the path cannot contain a comma. (string value)
# certfile=/etc/keystone/ssl/certs/signing_cert.pem
default['openstack']['identity']['saml']['certfile'] = nil

# Path of the keyfile for SAML signing. Note, the path cannot
# contain a comma. (string value)
# keyfile=/etc/keystone/ssl/private/signing_key.pem
default['openstack']['identity']['saml']['keyfile'] = nil

# Entity ID value for unique Identity Provider identification.
# Usually FQDN is set with a suffix. A value is required to
# generate IDP Metadata. For example:
# https://keystone.example.com/v3/OS-FEDERATION/saml2/idp
# (string value)
default['openstack']['identity']['saml']['idp_entity_id'] = nil

# Identity Provider Single-Sign-On service value, required in
# the Identity Provider's metadata. A value is required to
# generate IDP Metadata. For example:
# https://keystone.example.com/v3/OS-FEDERATION/saml2/sso
# (string value)
default['openstack']['identity']['saml']['idp_sso_endpoint'] = nil

# Language used by the organization. (string value)
default['openstack']['identity']['saml']['idp_lang'] = nil

# Organization name the installation belongs to. (string
# value)
default['openstack']['identity']['saml']['idp_organization_name'] = nil

# Organization name to be displayed. (string value)
default['openstack']['identity']['saml']['idp_organization_display_name'] = nil

# URL of the organization. (string value)
default['openstack']['identity']['saml']['idp_organization_url'] = nil

# Company of contact person. (string value)
default['openstack']['identity']['saml']['idp_contact_company'] = nil

# Given name of contact person (string value)
default['openstack']['identity']['saml']['idp_contact_name'] = nil

# Surname of contact person. (string value)
default['openstack']['identity']['saml']['idp_contact_surname'] = nil

# Email address of contact person. (string value)
default['openstack']['identity']['saml']['idp_contact_email'] = nil

# Telephone number of contact person. (string value)
default['openstack']['identity']['saml']['idp_contact_telephone'] = nil

# Contact type. Allowed values are: technical, support,
# administrative billing, and other (string value)
default['openstack']['identity']['saml']['idp_contact_type'] = nil

# Path to the Identity Provider Metadata file. This file
# should be generated with the keystone-manage
# saml_idp_metadata command. (string value)
# idp_metadata_path=/etc/keystone/saml2_idp_metadata.xml
default['openstack']['identity']['saml']['idp_metadata_path'] = nil

# PKI signing. Corresponds to the [signing] section of keystone.conf
# Note this section is only written if node['openstack']['auth']['strategy'] == 'pki'
default['openstack']['identity']['signing']['basedir'] = '/etc/keystone/ssl'
default['openstack']['identity']['signing']['certfile'] = "#{node['openstack']['identity']['signing']['basedir']}/certs/signing_cert.pem"
default['openstack']['identity']['signing']['keyfile'] = "#{node['openstack']['identity']['signing']['basedir']}/private/signing_key.pem"
default['openstack']['identity']['signing']['ca_certs'] = "#{node['openstack']['identity']['signing']['basedir']}/certs/ca.pem"
default['openstack']['identity']['signing']['certfile_url'] = nil
default['openstack']['identity']['signing']['keyfile_url'] = nil
default['openstack']['identity']['signing']['ca_certs_url'] = nil
default['openstack']['identity']['signing']['key_size'] = '2048'
default['openstack']['identity']['signing']['valid_days'] = '3650'
default['openstack']['identity']['signing']['ca_password'] = nil

# These switches set the various drivers for the different Keystone components
default['openstack']['identity']['identity']['backend'] = 'sql'
default['openstack']['identity']['assignment']['backend'] = 'sql'
default['openstack']['identity']['token']['backend'] = 'sql'
default['openstack']['identity']['catalog']['backend'] = 'sql'
default['openstack']['identity']['policy']['backend'] = 'sql'

# The maximum number of entities that will be returned in a
# collection, with no limit set by default. This global limit
# may be then overridden for a specific driver, by specifying
# a list_limit in the appropriate section (identity, assignment,
# catalog or policy). (integer value)
default['openstack']['identity']['list_limit'] = nil
# The maximum number of entities that will be returned in an
# identity collection. (integer value)
default['openstack']['identity']['identity']['list_limit'] = nil
# Maximum number of entities that will be returned in an
# assignment collection.
default['openstack']['identity']['assignment']['list_limit'] = nil
# Maximum number of entities that will be returned in a
# catalog collection. (integer value)
default['openstack']['identity']['catalog']['list_limit'] = nil
# The maximum number of entities that will be returned in an
# policy collection. (integer value)
default['openstack']['identity']['policy']['list_limit'] = nil

# LDAP backend general settings
default['openstack']['identity']['ldap']['url'] = 'ldap://localhost'
default['openstack']['identity']['ldap']['user'] = 'dc=Manager,dc=example,dc=com'
default['openstack']['identity']['ldap']['password'] = nil
default['openstack']['identity']['ldap']['suffix'] = 'cn=example,cn=com'
default['openstack']['identity']['ldap']['use_dumb_member'] = false
default['openstack']['identity']['ldap']['allow_subtree_delete'] = false
default['openstack']['identity']['ldap']['dumb_member'] = 'cn=dumb,dc=example,dc=com'
default['openstack']['identity']['ldap']['page_size'] = 0
default['openstack']['identity']['ldap']['alias_dereferencing'] = 'default'
default['openstack']['identity']['ldap']['query_scope'] = 'one'
default['openstack']['identity']['ldap']['use_tls'] = false
# If both tls_cacertfile and tls_cacertdir are set, then the cacertfile takes precedence and tls_cacertdir is not used
default['openstack']['identity']['ldap']['tls_cacertfile'] = nil
default['openstack']['identity']['ldap']['tls_cacertdir'] = nil
default['openstack']['identity']['ldap']['tls_req_cert'] = 'demand'

# LDAP backend user related settings
default['openstack']['identity']['ldap']['user_tree_dn'] = nil
default['openstack']['identity']['ldap']['user_filter'] = nil
default['openstack']['identity']['ldap']['user_objectclass'] = 'inetOrgPerson'
default['openstack']['identity']['ldap']['user_id_attribute'] = 'cn'
default['openstack']['identity']['ldap']['user_name_attribute'] = 'sn'
default['openstack']['identity']['ldap']['user_mail_attribute'] = 'email'
default['openstack']['identity']['ldap']['user_pass_attribute'] = 'userPassword'
default['openstack']['identity']['ldap']['user_enabled_attribute'] = 'enabled'
default['openstack']['identity']['ldap']['user_enabled_mask'] = 0
default['openstack']['identity']['ldap']['user_enabled_default'] = 'true'
default['openstack']['identity']['ldap']['user_attribute_ignore'] = 'tenant_id,tenants'
default['openstack']['identity']['ldap']['user_allow_create'] = true
default['openstack']['identity']['ldap']['user_allow_update'] = true
default['openstack']['identity']['ldap']['user_allow_delete'] = true
default['openstack']['identity']['ldap']['user_enabled_emulation'] = false
default['openstack']['identity']['ldap']['user_enabled_emulation_dn'] = nil

# LDAP backend tenant related settings
default['openstack']['identity']['ldap']['project_tree_dn'] = nil
default['openstack']['identity']['ldap']['project_filter'] = nil
default['openstack']['identity']['ldap']['project_objectclass'] = 'groupOfNames'
default['openstack']['identity']['ldap']['project_id_attribute'] = 'cn'
default['openstack']['identity']['ldap']['project_member_attribute'] = 'member'
default['openstack']['identity']['ldap']['project_name_attribute'] = 'ou'
default['openstack']['identity']['ldap']['project_desc_attribute'] = 'description'
default['openstack']['identity']['ldap']['project_enabled_attribute'] = 'enabled'
default['openstack']['identity']['ldap']['project_domain_id_attribute'] = 'businessCategory'
default['openstack']['identity']['ldap']['project_attribute_ignore'] = nil
default['openstack']['identity']['ldap']['project_allow_create'] = true
default['openstack']['identity']['ldap']['project_allow_update'] = true
default['openstack']['identity']['ldap']['project_allow_delete'] = true
default['openstack']['identity']['ldap']['project_enabled_emulation'] = false
default['openstack']['identity']['ldap']['project_enabled_emulation_dn'] = nil

# LDAP backend role related settings
default['openstack']['identity']['ldap']['role_tree_dn'] = nil
default['openstack']['identity']['ldap']['role_filter'] = nil
default['openstack']['identity']['ldap']['role_objectclass'] = 'organizationalRole'
default['openstack']['identity']['ldap']['role_id_attribute'] = 'cn'
default['openstack']['identity']['ldap']['role_name_attribute'] = 'ou'
default['openstack']['identity']['ldap']['role_member_attribute'] = 'roleOccupant'
default['openstack']['identity']['ldap']['role_attribute_ignore'] = nil
default['openstack']['identity']['ldap']['role_allow_create'] = true
default['openstack']['identity']['ldap']['role_allow_update'] = true
default['openstack']['identity']['ldap']['role_allow_delete'] = true

# LDAP backend group related settings
default['openstack']['identity']['ldap']['group_tree_dn'] = nil
default['openstack']['identity']['ldap']['group_filter'] = nil
default['openstack']['identity']['ldap']['group_objectclass'] = 'groupOfNames'
default['openstack']['identity']['ldap']['group_id_attribute'] = 'cn'
default['openstack']['identity']['ldap']['group_name_attribute'] = 'ou'
default['openstack']['identity']['ldap']['group_member_attribute'] = 'member'
default['openstack']['identity']['ldap']['group_desc_attribute'] = 'description'
default['openstack']['identity']['ldap']['group_attribute_ignore'] = nil
default['openstack']['identity']['ldap']['group_allow_create'] = true
default['openstack']['identity']['ldap']['group_allow_update'] = true
default['openstack']['identity']['ldap']['group_allow_delete'] = true

# Token flushing cronjob
default['openstack']['identity']['token_flush_cron']['enabled'] = node['openstack']['identity']['token']['backend'] == 'sql'
default['openstack']['identity']['token_flush_cron']['log_file'] = '/var/log/keystone/token-flush.log'
default['openstack']['identity']['token_flush_cron']['hour'] = '*'
default['openstack']['identity']['token_flush_cron']['minute'] = '0'
default['openstack']['identity']['token_flush_cron']['day'] = '*'
default['openstack']['identity']['token_flush_cron']['weekday'] = '*'

# Misc option support
# Allow additional strings to be added to keystone.conf
# For example:  ['# Comment', 'key=value']
default['openstack']['identity']['misc_keystone'] = []

# platform defaults
case platform_family
when 'fedora', 'rhel' # :pragma-foodcritic: ~FC024 - won't fix this
  default['openstack']['identity']['user'] = 'keystone'
  default['openstack']['identity']['group'] = 'keystone'
  default['openstack']['identity']['platform'] = {
    'memcache_python_packages' => ['python-memcached'],
    'keystone_packages' => ['openstack-keystone'],
    'keystone_client_packages' => ['python-keystoneclient'],
    'keystone_service' => 'openstack-keystone',
    'keystone_process_name' => 'keystone-all',
    'package_options' => ''
  }
when 'suse'
  default['openstack']['identity']['user'] = 'openstack-keystone'
  default['openstack']['identity']['group'] = 'openstack-keystone'
  default['openstack']['identity']['platform'] = {
    'memcache_python_packages' => ['python-python-memcached'],
    'keystone_packages' => ['openstack-keystone'],
    'keystone_client_packages' => ['python-keystoneclient'],
    'keystone_service' => 'openstack-keystone',
    'keystone_process_name' => 'keystone-all',
    'package_options' => ''
  }
when 'debian'
  default['openstack']['identity']['user'] = 'keystone'
  default['openstack']['identity']['group'] = 'keystone'
  default['openstack']['identity']['platform'] = {
    'memcache_python_packages' => ['python-memcache'],
    'keystone_packages' => ['keystone'],
    'keystone_client_packages' => ['python-keystoneclient'],
    'keystone_service' => 'keystone',
    'keystone_process_name' => 'keystone-all',
    'package_options' => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
