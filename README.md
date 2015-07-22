# Agora Authority Server Deployment
This document describes the deployment process of Authority Servers for the Agora Voting System.

An Agora Voting System requires **two or more Authority Servers** to operate. The authority servers of a voting system communicate during elections, but they first need to be able to discover each other and establish a trust relationship. To accomplish this, **each Authority Server needs to exchange an automatically generated package with every other server in the Agora Voting System**. This package (.pkg) describes where the authority server is running and also provides the certificate that uniquely identifies the authority.

After communication and trust between the authority servers is established, **an election can be initiated from one of the authority servers**. This document describes how a test election can be performed, so that it is verified that the Authorities are running correctly and can conduct elections.

 
### 1. Deploying a single Authority Server <a name="deploy"></a>

This section describes the steps that need to be performed in order to launch a single authority server that will connect to one or more peers. You will need to use this guide if you want to deploy your own Authority Server that will connect to an existing cluster of servers, or you intend to launch your own Authority Server cluster, one by one.

To launch a single authority server:

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
  
  
  
 **(For Linux)**
 <pre>
 $ sed -i 's/\(HOST:\).*/\1 <b>auth1</b>/' eo_env.yml
 </pre>
 
 **(For Mac OS)**
 <pre>
 $ sed -i.bu 's/\(HOST:\).*/\1 <b>auth1</b>/' eo_env.yml && rm eo_env.yml.bu
 </pre>
  
1. **(Optional)** If you want your authority server to initiate a test election in order to verify the correct operation of the Authority Server Cluster, you need to specify the amount of authority servers inside the environment configuration file. **Only one of the authority servers should initiate the test**, therefore make sure that this step is only performed on only one member of the authority server member set:
  ```
  echo "AUTH_MEMBERS: 2" >> eo_env.yml
  ```
  
1. Launch the authority server by using the run_auth script. Optionally you can use the '-t' option, in order to tail the logs after the server has been launched:
  <pre>
  $ ./run_auth.sh -t
  </pre>
  
1. Once the authority server has been launched, you will need to exchange your authority server package with the rest of the authority servers that will participate in the election. Your authority server will expose its package under **certs/my_auth.pkg**. You will need to provide that package file to all the other servers:
  <pre>
  $ cp <b>certs/my_auth.pkg</b> /path_to_other_auth_server/<b>keys/authority1.pkg</b>
  </pre>

1. Copy the packages (\*.pkg) that you have received from the rest of the Authority servers into the keys directory. If your authority server is the one that will initiate the tests, then **make sure that you add the packages after all other authority servers have their packages installed**. Otherwise, the test election will begin without all the election members being ready:
  <pre>
  $ cp /path_to_provided_keys/*.pkg keys
  </pre>

### 2. Launching an Authority Server Demo Cluster
  Using the provided run script, you can deploy a cluster of Authority Servers in Demo mode. Use this mode when you want to launch a complete Authority Server cluster from scratch.
  ```
  $ ./run_auth.sh -d
  ```
  
  This mode performs the following actions:
  1. Two authority servers, **auth1 and auth2** are setup, with auth1 configured to initiate a test election when both servers are up and running.
  2. The keys are exchanged between auth1 and auth2
  3. The logs of auth1 (test initiator) are presented, to show the outcome of the test election.
  4. The output files of the election are placed inside the directory **tests/demo/auth1/tests**


### Performing a test election:

If you haven't completed the deployment process, you need to follow the steps listed  [above](#deploy). As mentioned in step 7 above, the server that initiates the test election needs to be provided with the peer packages last.

As soon as the last package is provided to the test initiator, an election will automatically start. To observe if the election is properly conducted, you can tail the logs:
``` 
$ tail -f logs/*
```

The results of the election process will be provided in the test directory.
