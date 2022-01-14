pipeline {
  agent {
    kubernetes {
      //idleMinutes 5  // how long the pod will live after no jobs have run on it
      namespace 'devops-tools'
      yamlFile 'build-pod2.yaml'  // path to the pod definition relative to the root of our project 
    }
  }
  stages {
    stage('Build Docker Image') {
      steps {
        container('docker-cmds') {  
          sh "docker build -t weatherapp:1.0 -t mzoorg/weatherapp ."  // when we run docker in this step, we're running it via a shell on the docker build-pod container, 
          withCredentials([usernamePassword(credentialsId: '0ee33d5f-c0d3-4f77-af0e-feb05c3a2f2f', passwordVariable: 'password', usernameVariable: 'username')]) {
            sh "docker login -u $username -p $password"
          }
          sh "docker push mzoorg/weatherapp"     // which is just connecting to the host docker deaemon
        }
      }
    }
  }
}