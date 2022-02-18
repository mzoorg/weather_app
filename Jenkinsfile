def tag = ''
def release = false
def prod = false
def delete_test = false

pipeline {
  agent {
    kubernetes {
      //idleMinutes 5  // how long the pod will live after no jobs have run on it
      namespace 'devops'
      yamlFile 'build-pod2.yaml'  // path to the pod definition relative to the root of our project 
    }
  }

  environment {
    ECR_ENDPOINT = credentials('ecr-endpoint')
    ECR_REPO = credentials('ecr-repo-url')
  }
  
  stages {
    stage('git') {
      steps {
        git 'https://github.com/mzoorg/weather_app.git'
        script { 
            def get_tag = sh(returnStdout: true, script: "git tag --points-at").trim()
            tag = get_tag ?: env.BUILD_ID
            echo "new tag is ${tag}"
            release = get_tag ? true : false
            echo "${release}"
        }
      }
    }
    
    stage('Test sonar') {
        environment {
            SCANNER_HOME = tool 'SonarQubeScanner'
            PROJECT_NAME = "Myproject1"
        }
        steps {
            withSonarQubeEnv(installationName: 'SonarQubeServer', credentialsId: 'sonarqube-secret') {
               sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=${PROJECT_NAME}"
            }
        }
    }

    stage('Build Docker Image') {
      steps {
        container('docker-cmds') {
          script {
              withDockerRegistry(credentialsId: 'ecrcreds', url: "${env.ECR_ENDPOINT}") {
                  def img = docker.build("${env.ECR_REPO}:${tag}")
                  img.push()
                  if (release) {
                    img.push("latest")
                  }
              }
          }
        }
      }
    }

    stage('Deploy in test') {
      steps {
        container('kubectl') {
          sh """sed -i "s|___K8S_IMG___|${env.ECR_REPO}:${tag}|" deploykube/app/deployment-app.yaml"""
          sh """sed -i "s|__NODEPORT__|30700|" deploykube/app/svc-app.yaml"""
          sh "kubectl apply -f deploykube/app -n test"
          echo 'Run some tests'
          script {
            if (release) {
              prod = input  message: "deploy to prod?", id: 'prodDeploy',
                    parameters: [booleanParam(name: "reviewed", defaultValue: false, description: "prod deploy")]
              println prod
            }
          }
          script {
            delete_test = input message: 'delete test env?', id: 'rmTest',
                    parameters: [booleanParam(name: 'delete', defaultValue: false, description: 'delete test env?')]
          }
        }
      }
    }
    stage ('Delete test env') {
      when {
        expression { delete_test == true }
      }
      steps {
        container('kubectl') {
          sh "kubectl delete -f deploykube/app -n test"
        }
      }
    }

    stage ('Deploy in prod') {
      when {
        expression { prod == true }
      }
      steps {
        container('kubectl') {
          sh """sed -i "s|__NODEPORT__|30900|" deploykube/app/svc-app.yaml"""
          sh "kubectl apply -f deploykube/app -n prod"
        }
     }
    }
  }
}