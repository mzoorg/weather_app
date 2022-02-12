def tag = ''
def ECR = ''
def release = false
def prod = false

withFolderProperties{ 
    ECR_ENDPOINT = "${env.ECR_ENDPOINT}"
}

println "ECR_ENDPOINT = ${ECR_ENDPOINT}"

if (ECR_ENDPOINT == '' || ECR_ENDPOINT == null || ECR_ENDPOINT == 'null') {
    currentBuild.result = 'ABORTED'
    error('Not defined ECR_ENDPOINT in Folder properies plugin!')
}

pipeline {
  agent {
    kubernetes {
      //idleMinutes 5  // how long the pod will live after no jobs have run on it
      namespace 'devops-tools'
      yamlFile 'build-pod2.yaml'  // path to the pod definition relative to the root of our project 
    }
  }

  environment {
    ECR_ENDPOINT = "${ECR_ENDPOINT}"
    ECR_REPO = "${ECR_ENDPOINT}/weatherapp"
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
              withDockerRegistry(credentialsId: 'ecrcreds', url: '${env.ECR_ENDPOINT}') {
                  tag = env.TAG_NAME ?: env.BUILD_ID
                  release = env.TAG_NAME ? true : false
                  def img = docker.build("${env.ECR_REPO}:${tag}")
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
          sh """sed -i "s|___K8S_IMG___|${env.ECR_REPO}:${tag}|" deploykube/app/deployment-app.yaml"""
          sh """sed -i "s|weather-app-secret|weather-app-secret-test|" deploykube/app/deployment-app.yaml"""
          sh "kubectl apply -f deploykube/app -n test"
          script {
              if (release) {
                prod = input  message: "deploy to prod?", id: 'prodDeploy',
                      parameters: [booleanParam(name: "reviewed", defaultValue: false, description: "prod deploy")]
                println prod
              }
          }
        }
      }
    }
    stage ('Deploy in prod') {
     when {
      expression { prod == true }
     }
     steps {
        container('kubectl') {
          sh "kubectl version"
          sh """sed -i "s|weather-app-secret-test|weather-app-secret-prod|" deploykube/app/deployment-app.yaml"""
          sh "kubectl apply -f deploykube/app -n prod"
       }
     }
    }
  }
}