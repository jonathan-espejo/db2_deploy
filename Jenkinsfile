pipeline {
    environment {
       BUILD_HOME='/var/lib/jenkins/workspace/db2_deploy'
    }
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh "chmod u+x $BUILD_HOME/build.sh"
                sh "./build.sh"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
