## Template for testing Ansible playbooks in a Centos 7 Docker container

Clone into a new folder name matching whatever Ansible role you'd like to create.

`git@github.com:sacreman/docker-centos7-ansible.git my-ansible-role`

Use the `make` commands mentioned in the section below to build and interact with the container.

Don't edit the `Makefile` or `Rockerfile` unless you know what you're doing.

Add Ansible roles into `roles/` and reference them in `playbook.yaml` so they run.

Pass in extra variables to the roles in `extra_vars.yaml`.

Add inspec test files into `test/inspec`.


## Building and Testing

You'll need the following dependencies:
 
- Make
- [Docker](https://store.docker.com/editions/community/docker-ce-desktop-mac)
- [Rocker](https://github.com/grammarly/rocker)

If you're in a hurry you can run all of the below with a single command.

`make`

Otherwise it may be best to run the individual commands below to get a feel for the workflow.

Build the testing image. You should only need to do this the first time.

`make build`

Now you have an image you can start it in the background. Leave it running forever if you're lazy like me.

`make run`

You can now work on Ansible by changing the files and running.

`make config`

A typical workflow will usually involve running his over and over again while making incremental Ansible changes.

Or work on tests by running.

`make test`

Again, this can be done iteratively. You can add or change a test and run this over and over again until it passes.

The tests usually depend on the `make config` having run to completion so you may want to ensure that was run first.

To wipe the config just restart the container or run `make clean` and you're instantly back to a fresh image you can
apply `make config` to. It's generally a good idea to do this as a final test before raising a PR.

For when it all goes wrong.

`make mrproper`

This will stop and remove all container images related to this module. You'll then need to `make` to recreate 
everything.

If you want to have a poke around inside the container to debug you can use `make ssh`. Then ctrl+d to exit when 
