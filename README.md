# F5-OpenStack-LBaaSv2 Plugin System Test

This is a project holding f5-openstack-lbaasv2 plugin's system test: environment info/processes/scripts.

## Code Directory Layouts:

* `conf.d/`: 
  * `kps/`: Certificate, keys or ssh keypairs for tls testing.
  * `patches/`: Some cusmization codes to neutron/neutron_lbaas framework. The code changes are organized in another repository: https://github.com/zongzw/neutron_lbaas_pike-devops-bed.
  * `templates/`: Templates for lbaasv2 configurations, generally we have i.e. 2 providers configured during setting up neutron_lbaas/f5-openstack-agent services.
  * `group_and_hosts-*`: Environment information. Find more details about the specific environment from each file, we call it environment_file.
  * `vars-*`: Versions and testcases information, we call it variable_file.
* `logs/`: In the system test processes, we call ansible scripts within ansible script(See: [./playbooks/run-testcases-in-parallel.yml "run test_cases in parallel."](./playbooks/run-testcases-in-parallel.yml)), so we need to output all test cases' details to files. 

  One folder for one run. Each of them is named as '**<time_string>--<environment_file>--<variable_file>**'.

* `playbooks/`: The most inmport folder placing all test scripts/tasks.

  They can be separated into two sets:

  `Files starts with 'task-'`: They are a bundle of tasks which can be reused, usually for a standard procedure, can be **import_tasks** elsewhere.

  `Files without 'task-' prefix`: They are standalone scripts callable via **ansible-playbook** command line. See Session 'Test Commands' part.

* `scripts/`: They are kinds of shell/python/sql scripts called in playbook yamls, aiming for a easier way to handle test works rather than ansible scripts. In a long perspective, some of them needs to be rewrited in ansible way for consistence.

   Not all the scripts are in use.

* `testcases/`: All test cases. Each subfolder contains `test.yml` file. Beside this file, the test execution is self-organized within the folder.

## Test Commands and Examples

Running the tests via the following command line template:

```
$ ansible-playbook -i conf.d/<environment_file> -e @conf.d/<variable_file> playbooks/<playbook_name> [some extra arguments]
```

* `playbook_name` is the `Files witout 'task-' prefix` mentioned above.
* `[some extra arguments]`: currently, we have three situations:

  * `-t <tag>`: Run only a subset of tasks defined in ansible scripts with `tags:`. Find details from test case implementation under `testcases/`.
  * `-e nogit=yes`: Don't git clone from https://github.com/zongzw/neutron_lbaas_pike-devops-bed when running `setup-neutron-lbaas.yml`. This aims to eliminate the github access issues. 
  * `-e nodelete=yes`: Don't delete resources after tests. By default, deletion is the part of a test.

The `playbook_name`s can be grouped as following:

### 1. Developing/Debugging

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/ansible-tests.yml`

  This script is used for test/debug/verify some yaml code piece. Comment old codes and paste your code and run it for validation.

### 2. Clean up Resources

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/clean-bigip-partitions.yml`

  This script is used clean up all bigip configurations under partitions except 'Common'(Removing partition itself as well).

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/clean-neutron-resources.yml` 

  This script is used to remove all resources from neutron side.

### 3. Setup Environment

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/ensure-local-env.yml` 

  This script is used to setup localhost, since we need passwordless access to hosts defined in `conf.d/group_and_hosts-*`.

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/prepare-keypairs.yml`

  This script is used to create necessary key pairs under `conf.d/kps` for later tests.

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/setup-barbican.yml`

  This script is used to setup barbican component for non-`osp` type environments. `osp` type environments are set up by RedHat and KDDI, which are container-based environments, comparing to `rdo` type environments which are set up via `packstack`.

  Currently, in `conf.d/group_and_hosts-*`, `lab` and `kddi` are `osp` environments, see `[neutron_servers:vars] test_env = osp` in `conf.d/group_and_hosts-*`.

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/setup-neutron-lbaas.yml`

  This script is used to setup/refresh neutron/neutron_lbaas installation/configuration, with f5-* installation/configuration included.

  This is an important script to use **frequently** when deploying new versions of plugins or switching versions.

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/setup-clients.yml`

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/setup-servers.yml`

  These scripts are used to setup test clients and test servers(defined as `[clients]` and `[servers]` in `conf.d/group_and_hosts-*`).

  Furthermore, take a look at the `clients and backend_servers fix layout!` session in `conf.d/group_and_hosts-*` when we you add one more environment.

  ```
    # ============ clients and backend_servers fix layout! ============
    #
    #                      clients
    #                         |
    #                         +-- clients_ipv4
    #                         |
    #                         \-- clients_ipv6
    #
    #                       backend_servers
    #                         |
    #                         +-- backend_servers_ipv4
    #                         |       |
    #                         |       +-- pool1
    #                         |       |
    #                         |       \-- pool2
    #                         |
    #                         \-- backend_servers_ipv6
    #
    # =================================================================
  ```

### 4. Running Tests

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/run-testcases-in-parallel.yml`

* `$ ansible-playbook -i conf.d/group_and_hosts-dev -e @conf.d/vars-zte-private.yml playbooks/run-testcases.yml`

  This script is used to run tests in parallel mode, which is much faster than `run-testcasts.yml` which is in serial mode.

  Some tests may fails because of variable reasons. We need to trace the failure case by case:

  * Because of environment setup issues: 
    
    * f5-openstack-agent is not setup correctly.
    * dependable environment is not available: network change, no compute space.. etc.

  * Because of code bugs:
    
    * code problems to be found in new release/version.
    * neutron_lbaas code customization code should be applied.

  * Because of ansible system test script:

    * system test scripts should be upgraded/fixed to compat code changes.

  * may be more ...