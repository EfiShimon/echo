pipeline
{
    agent any
    stages
    {             
        stage('Build')
        {        
            steps
            {
                 echo "current branch: ${env.BRANCH_NAME}"
                 echo "building project"
                 sh "docker build --tag echo ."                 
                 echo "Finished building on branch: ${env.BRANCH_NAME} "
            } 
        }
        
         stage('Test')
        {
            steps 
            {
                 echo "current branch: ${env.BRANCH_NAME}"                 
                 echo "runing docker image"
                 sh "docker run --rm --name echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER} -p 3000:3000 echoapp"
                 sh "chmod +x sanitycheck.sh"
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