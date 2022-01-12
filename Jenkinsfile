pipeline {
  agent {
    kubernetes {
      //idleMinutes 5  // how long the pod will live after no jobs have run on it
      yamlFile 'build-pod.yaml'  // path to the pod definition relative to the root of our project 
      defaultContainer 'docker'  // define a default container if more than a few stages use it, will default to jnlp container
    }
  }
  stages {
    stage('Build Docker Image') {
      steps {
        container('docker') {  
          sh "docker build -t weatherapp:1.0 -t mzoorg/weatherapp ."  // when we run docker in this step, we're running it via a shell on the docker build-pod container, 
          withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
            sh "docker login -u $username -p $password"
            }
          sh "docker push mzoorg/weatherapp"     // which is just connecting to the host docker deaemon
        }
      }
    }
  }
}