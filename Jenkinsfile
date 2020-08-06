pipeline {
    agent any
    stages {
        stage('Linting HTML files') {
            steps {
                sh 'tidy -q -e *.html hello i am a mistake'
            }
        }

        stage('Building Docker Image') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                    sh '''
                        docker build -t goyococoloco/johnscapstone .
                    '''
                }
            }
        }

        stage('Pushing Image To Dockerhub') {
            steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                    sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push goyococoloco/johnscapstone
                    '''
                }
            }
        }

        stage('Set current kubectl context') {
            steps {
                withAWS(region:'us-west-2', credentials:'ekszugang') {
                    sh '''
                        kubectl config use-context arn:aws:eks:us-west-2:213046224480:cluster/theekscluster
                    '''
                }
            }
        }

        stage('Deploy blue container') {
            steps{
                withAWS(region:'us-west-2', credentials:'ekszugang') {
                    sh '''
                        kubectl apply -f ./blue-controller.json
                    '''
                }
            }
        }

        stage('Deploy green container') {
            steps{
                withAWS(region:'us-west-2', credentials:'ekszugang') {
                    sh '''
                        kubectl apply -f ./green-controller.json
                    '''
                }
            }
        }

        stage('Create the service in the cluster, redirect to the blue container') {
            steps {
                withAWS(region:'us-west-2', credentials:'ekszugang') {
                    sh '''
                        kubectl apply -f ./blue-service.json
                    '''
                }
            }
        }

        stage('User approvement') {
            steps {
                input "Is the service ready to redirect traffic to green?"
            }
        }

        stage('Create the service in the cluster, redirect to the green container') {
            steps {
                withAWS(region:'us-west-2', credentials:'ekszugang') {
                    sh '''
                        kubectl apply -f ./green-service.json
                    '''
                }
            }
        }
    }
}
