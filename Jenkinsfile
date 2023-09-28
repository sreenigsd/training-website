pipeline {
    agent any 

    stages {
        stage('Build') {
            steps {
                echo "Build Process"
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') { 
                    script {
                        def scannerHome = tool 'sonar';
                        withEnv(["PATH+SONAR=${scannerHome}/bin"]) {
                            sh 'sonar-scanner -Dsonar.projectKey=IT2_API -Dsonar.sources=. -Dsonar.host.url=http://172.28.12.3 -Dsonar.login=squ_ebb01c277845e44f2905715368e656d090da3c31'
                        }
                    }
                }
            }
        }

        stage('Package') {
            steps {
                // Package both the HTML file and the images folder
                sh 'tar -czf my-html-project.tar.gz index.html images/'
            }
        }

        stage('Create Docker Image') {
            steps {
                sh 'docker build -t my-html-app:latest .'
            }
        }

        stage('Deploy Docker Image') {
            steps {
                sshagent(['my-ssh-key-id']) { // replace 'my-ssh-key-id' with your actual credential ID
                    sh 'docker save my-html-app:latest | ssh user@server_address "docker load"'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sshagent(['my-ssh-key-id']) { // replace 'my-ssh-key-id' with your actual credential ID
                    sh '''
                        ssh user@server_address 'docker run -d -p 80:80 my-html-app:latest'
                    '''
                }
            }
        }
    }
}
