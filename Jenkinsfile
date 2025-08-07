pipeline {
    agent any

    tools {
        nodejs 'node'
    }

    environment {
        IMAGE_NAME = 'angular-jenkins'
        IMAGE_TAG = 'latest'
        DIST_DIR = 'dist' 
    }

    stages {
        stage('Checkout sur la branche master') {
            steps {
                deleteDir()
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CleanBeforeCheckout']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/Astray63/Jenkins-CICD.git']]
                ])
            }
        }

        stage('Install dependencies') {
            steps {
                dir('mon-projet-angular') {
                    sh 'npm install'
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Skipping tests for now - Chrome not available in Jenkins container'
                // dir('mon-projet-angular') {
                //     sh 'npm run test -- --watch=false --browsers=ChromeHeadless'
                // }
            }
        }

        stage('Build') {
            steps {
                dir('mon-projet-angular') {
                    sh 'npm run build -- --configuration=production'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh """
                docker stop ${IMAGE_NAME} || true
                docker rm ${IMAGE_NAME} || true
                docker run -d --name ${IMAGE_NAME} -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Archive Build Artifacts') {
            steps {
                archiveArtifacts artifacts: 'mon-projet-angular/${DIST_DIR}/**/*'
            }
        }
    }
}
