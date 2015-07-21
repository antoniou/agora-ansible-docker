# Agora Authority Server Deployment
This document describes how to get an Authority Server of the Agora Voting System up and running, and how to verify that it is running correctly and communicating with the rest of the Authority Servers that need to be part of an election.

 
### Deploying an Authority Server <a name="deploy"></a>

In order to launch a VM box running an authority server:

1. Clone this repository, containing the Ansible playbook that is used for the deployment of the Authority server. You can place the repository into a directory named after your authority server:
  ```
  $ git clone git@github.com:antoniou/agora-ansible-docker.git authority1 
  ```
  
1. Chdir into the cloned repository:
  ```
  $ cd authority1
  ```

1. Create a environment configuration file. A sample configuration file is provided as *eo_env.yml.sample*. 
  ```
  $ cp eo_env.yml.sample eo_env.yml
  ```
  
 You can provide your own configuration by editing the file. For testing purposes, you will only need to change the HOST variable: 
  
 (For Linux) 
 ```
 $ sed -i 's/\(HOST:\).*/\1 auth1/' eo_env.yml
 ```
 
 (For Mac OS) 
 ```
 $ sed -i.bu 's/\(HOST:\).*/\1 auth1/' eo_env.yml && rm eo_env.yml.bu
 ```
  
1. **(Optional)** If you want your authority server to initiate a test election in order to verify the correct operation of the Authority Server Cluster, you need to specify the amount of authority servers inside the environment configuration file. **Only one of the authority servers should initiate the test**, therefore make sure that this step is only performed on only one member of the authority server member set:
  ```
  echo "AUTH_MEMBERS: 2" >> eo_env.yml
  ```
  
1. Launch the authority server by using the run_auth script. Optionally you can use the '-t' option, in order to tail the logs after the server has been launched:
  ```
  $ ./run_auth.sh -t
  ```
  
1. Once the authority server has been launched, you will need to exchange your authority server package with the rest of the authority servers that will participate in the election. Your authority server will expose its package under **certs/my_auth.pkg**. **You will need to provide that package file to all the other servers**:
  ```
  $ cp certs/my_auth.pkg /path/to/other/auth_servers/keys/authority1.pkg
  ```

1. Copy the packages (\*.pkg) that you have received from the rest of the Authority servers into the keys directory. If your authority server is the one that will initiate the tests, then **make sure that you add the packages after all other authority servers have their packages installed**. Otherwise, the test election will begin without all the election members being ready:
    ```
  $ cp /path/to/provided/keys/*.pkg keys
  ``` 


### Performing a test election:

If you haven't completed the deployment process, you need to follow the steps listed  [above](#deploy). As mentioned in step 7 above, the server that initiates the test election needs to be provided with the peer packages last.

As soon as the last package is provided to the test initiator, an election will automatically start. To observe if the election is properly conducted, you can tail the logs:
``` 
$ tail -f logs/*
```

The results of the election process will be provided in the test directory.
