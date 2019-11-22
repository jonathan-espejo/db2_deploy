pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building..packer build stage'
                sh "chmod 777 ./shared_libs/*"
                sh "sudo -i -u ec2-user touch /var/lib/jenkins/workspace/deploydb2/file1.txt"
                sh "sudo -i -u jenkins touch /var/lib/jenkins/workspace/deploydb2/file2.txt"
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
