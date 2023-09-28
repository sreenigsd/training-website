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
                            sh 'sonar-scanner -Dsonar.projectKey=Website-Demo -Dsonar.sources=. -Dsonar.host.url=http://172.28.12.3 -Dsonar.login=squ_ebb01c277845e44f2905715368e656d090da3c31'
                        }
                    }
                }
            }
        }

        stage('Package') {
            steps {
               // Package both the HTML file and the images folder
                sh 'tar -czf my-html-project.tar.gz index.html images/'

                // Archive the artifact for download from Jenkins UI
                archiveArtifacts artifacts: 'my-html-project.tar.gz', allowEmptyArchive: false
            }
        }

        stage('Create Docker Image') {
            steps {
                sh 'docker build -t my-html-app:latest .'
            }
        }

        stage('Deploy Docker Image') {
            steps {
                sshagent(['deploy_key']) { // replace 'my-ssh-key-id' with your actual credential ID
                    sh 'docker save my-html-app:latest | ssh trgadmin1@172.28.12.4 "docker load"'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sshagent(['deploy_key']) { // replace 'my-ssh-key-id' with your actual credential ID
                    sh '''
                        ssh trgadmin1@172.28.12.4 'docker run -d -p 82:80 my-html-app:latest'
                    '''
                }
            }
        }
    }
}
