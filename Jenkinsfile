pipeline
{
    agent any
    stages
    {             
        stage('Build')
        {        
            steps
            {
                script
                {
                    echo "current branch: ${env.BRANCH_NAME} "
                    echo "building project"
                    sh "docker build --tag echoapp ."
                    echo "Finished building on branch: ${env.BRANCH_NAME} "
                }                
            } 
        }
        
         stage('Test')
        {
            steps 
            {
                echo "current branch: ${env.BRANCH_NAME}"                 
                echo "runing docker image"
                sh "docker run --rm -d --name echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER} -p 300${env.BUILD_NUMBER}:3000 echoapp"                                               
                sh "chmod 777 sanitycheck.sh"
                sh "./sanitycheck.sh ${env.BUILD_NUMBER}"
                echo "Finished building on branch: ${env.BRANCH_NAME} "
            } 
        }
        
        stage("Publish")
        {
            steps 
            {            
                script
                {
                    if(env.BRANCH_NAME.contains("master"))
                    {
                        sh "docker tag echoapp gcr.io/echo-app-final/echo:1.0.${env.BUILD_NUMBER}"
                    }
                    else if(env.BRANCH_NAME.contains("dev"))
                    {
                        sh "docker tag echoapp gcr.io/echo-app-final/echo:dev-${env.GIT_COMMIT}"
                    }
                    else if(env.BRANCH_NAME.contains("staging"))
                    {
                        sh "docker tag echoapp gcr.io/echo-app-final/echo:staging-${env.GIT_COMMIT}"
                    }

                }

            } 
        }
        
        stage('Deploy')
        {
            steps {
                script
                {
                    withCredentials([ file( credentialsId: 'echo-app-final', variable: 'GCR')]) 
                    {
                        sh "docker logout"
                        sh(returnStdout: true, script: "cat ${GCR}") 
                        sh "docker login -u _json_key --password-stdin https://gcr.io"
                            
                        if(env.BRANCH_NAME.contains("master"))
                        {
                            sh "docker push gcr.io/echo-app-final/echo:1.0.${env.BUILD_NUMBER}"
                        }
                        else if(env.BRANCH_NAME.contains("dev"))
                        {
                            sh "docker push gcr.io/echo-app-final/echo:dev-${env.GIT_COMMIT}"
                        }
                        else if(env.BRANCH_NAME.contains("staging"))
                        {
                            sh "docker push gcr.io/echo-app-final/echo:staging-${env.GIT_COMMIT}"
                        }
                    }
                }
            } 
        }
    }    

    post
    {
        always
        {                                                                  
            sh "docker stop echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        }
    }
}    