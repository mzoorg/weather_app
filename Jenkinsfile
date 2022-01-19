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
          docker-cmds.withRegistry("0ee33d5f-c0d3-4f77-af0e-feb05c3a2f2f") {
                sh 'printenv'
                tag = env.TAG_NAME ?: env.BUILD_ID
                release = env.TAG_NAME ? true : false
                def img = docker.build("mzoorg/weatherapp:${tag}")
                img.push()
                if (env.TAG_NAME) {
                  img.push("latest")
                }
          }      
        }
      }
    }
    
    stage('Deploy in test') {
      steps {
        container('kubectl') {
          sh "sed -i 's/___K8S_IMG___/mzoorg\\/weatherapp:${tag}' deploykube/app/deployment-app.yaml"
          sh "kubectl -f deploykube --recursive -n test"
        }
      } 
    }
  }
}