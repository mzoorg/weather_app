def tag = 'latest'

pipeline {
  agent {
    kubernetes {
      //idleMinutes 5  // how long the pod will live after no jobs have run on it
      namespace 'devops-tools'
      yamlFile 'build-pod2.yaml'  // path to the pod definition relative to the root of our project 
    }
  }
  
  stages {
    stage('git') {
        steps {
            git 'https://github.com/mzoorg/weather_app.git'
        }
    }
    
    stage('Test sonar') {
        environment {
            SCANNER_HOME = tool 'SonarQubeScanner'
            PROJECT_NAME = "Myproject1"
        }
        steps {
            withSonarQubeEnv(installationName: 'mysonar', credentialsId: 'sonarqube-secret') {
               sh 'printenv'
               sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=${PROJECT_NAME}"// some block
            }
        }
    }

    // add condition to build img

    stage('Build Docker Image') {
      steps {
        container('docker-cmds') {
          script {  
            withDockerRegistry(credentialsId: 'dockerhubcreds') {
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
    }

    //add check docker img?

    stage('Deploy in test') {
      steps {
        container('kubectl') {
          sh "kubectl version"
          sh "sed -i 's/___K8S_IMG___/mzoorg\\/weatherapp:${tag}/' deploykube/app/deployment-app.yaml"
          withCredentials([
            usernamePassword(credentialsId: 'mysqlcreds', passwordVariable: 'MYSQL_PASSWORD', usernameVariable: 'MYSQL_USER'),
            string(credentialsId: 'rds-test', variable: 'rds-test')]) {
              // some block
              sh '''sed -i "s/newdbuser/$(echo ${MYSQL_USER} | base64)/" deploykube/app/secrets-app.yaml'''
              sh '''sed -i "s/newdbpass/$(echo ${MYSQL_PASSWORD} | base64)/" deploykube/app/secrets-app.yaml'''
              sh '''sed -i "s/newdbname/$(echo ${rds-test} | base64)/" deploykube/app/secrets-app.yaml'''
            }
          sh "kubectl apply -f deploykube/app -n test --recursive"
        }
      }
    }
    // add condition to deploy in prod
  }
}