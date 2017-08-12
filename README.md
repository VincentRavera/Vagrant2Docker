# Vagrant2Docker

A straight forward Virtual machine with a docker set-up.

Why should i use this ?

* Easy to use
* Exportable
* No worries if i mess up my install.

Also see the older version : https://github.com/VincentRavera/VagrantVM

## Installation - Pre-requisite

What we need :
1. Virtual Box
2. Vagrant

### Virtual Box

You better install it manually by downloading from the official website.
Why ? If you happen to update it Vagrant might cry later on.

### Vagrant

Install it the way you want.

## Installation

Just checkout this project with :

```shell
git clone https://github.com/VincentRavera/Vagrant2Docker
```

## Start the Virtual machine

To start the machine, go to the project directory and run :
```shell
vagrant up # might take some time 
```

## Make yourself at home

Run the following to go inside your VM
```shell
vagrant ssh
```

Since the box has a prvate Network you can ssh it.

```shell
ssh vagrant@192.168.50.4
```

## I messed up !

To reset your vm use this :

```shell
vagrant destroy
```

## I use a proxy !

Warning I did not test this yet !
But you can edit 'box_setup.sh' and change 'USE_PROXY' to yes.
Then edit the proxy settings.

## I want to add cool apps !

Help yourself, but remember if you mess up your applications won't be installed by default !

for that in the file 'box_setup.sh' change 'APPS' to yes.
Then at the end of the file where '$APPS' is checked add and delete the application that you want.
The file contains enough examples already.


