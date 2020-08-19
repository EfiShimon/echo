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
                 sh "docker run --rm -d --name echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER} -p 3000${BUILD_NUMBER}:3000 echoapp"
                 sh "chmod +x sanitycheck.sh ${env.BUILD_NUMBER}"
                 sh "./sanitycheck.sh"
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
                        sh "docker tag echoapp gcr.io/echo-app-final/echo:dev-${}"
                    }
                    else if(env.BRANCH_NAME.contains("staging"))
                    {
                        sh "docker tag echoapp gcr.io/echo-app-final/echo:staging-${}"
                    }

                }

            } 
        }
        
        stage('Deploy')
        {
            steps {
                script
                {
                    if(env.BRANCH_NAME.contains("master"))
                    {
                        sh "docker push echoapp gcr.io/echo-app-final/echo:1.0.${env.BUILD_NUMBER}"
                    }
                    else if(env.BRANCH_NAME.contains("dev"))
                    {
                        sh "docker push echoapp gcr.io/echo-app-final/echo:dev-${env.GIT_COMMIT}"
                    }
                    else if(env.BRANCH_NAME.contains("staging"))
                    {
                        sh "docker push echoapp gcr.io/echo-app-final/echo:staging-${env.GIT_COMMIT}"
                    }
                }
            } 
        }
    }    
}    