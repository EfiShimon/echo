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
                sh "docker run --rm -d --name echo-${env.BRANCH_NAME}-${env.BUILD_NUMBER} -p 300${env.BUILD_NUMBER}:3000 echo-app-final/echo-app:latest"                                               
                sh "chmod 777 sanitycheck.sh"
                sh "./sanitycheck.sh ${env.BUILD_NUMBER}"
                echo "Finished building on branch: ${env.BRANCH_NAME} "
            } 
        }
  
        stage('Deploy')
        {
            steps 
            {
                script
                {                                    
                    if(env.BRANCH_NAME.contains("master"))
                    {
                        docker.withRegistry('https://gcr.io', "gcr:echo")
                        {
                            Img.push("1.0.${env.BUILD_NUMBER}") 
                        }                    
                    }
                    else if(env.BRANCH_NAME.contains("dev"))
                    {
                        docker.withRegistry('https://gcr.io', "gcr:echo")
                        {
                            Img.push("dev-${env.GIT_COMMIT}") 
                        }                    
                    }
                    else if(env.BRANCH_NAME.contains("staging"))
                    {
                        docker.withRegistry('https://gcr.io', "gcr:echo")
                        {
                            Img.push("staging:${env.GIT_COMMIT}") 
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