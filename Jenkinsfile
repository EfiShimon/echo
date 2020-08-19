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
                    Img = docker.build("echo-app-final/echo-app","-f Dockerfile .")
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
                sh "docker run --rm -d --name echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER} -p 300${env.BUILD_NUMBER}:3000 echo-app"                                               
                sh "chmod 777 sanitycheck.sh"
                sh "./sanitycheck.sh ${env.BUILD_NUMBER}"
                echo "Finished building on branch: ${env.BRANCH_NAME} "
            } 
        }
      /*  
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
        */
        stage('Deploy')
        {
            steps 
            {
                script
                {
                    docker.withRegistry('https://gcr.io', "gcr:echo")
                    {
                        Img.push("1.0.${env.BUILD_NUMBER}") 
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