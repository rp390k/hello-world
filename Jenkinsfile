pipeline {
    agent any
    tools {
        maven 'Maven 3.6'
    }
    options {
	timestamps()
	disableConcurrentBuilds()
    }
    stages {
	stage ('checkout') {
            steps {
                echo "build in dev branch - 1"
                checkout scm
            }
        }
        stage ('build') {
            steps {
                echo "build in dev branch - 2"
                bat "mvn install"
            }
        }
	stage ('unit_testing') {
            steps {
                echo "unit test"
                bat "mvn test"
            }
        }
	stage ('sonar_analysis') {
            steps {
		withSonarQubeEnv("LocalSonar") {
                    bat "mvn sonar:sonar"
		}
            }
        }
        stage ('Upload_to_artifactory') {
            steps {
		rtMavenDeployer (
                    id: 'deployer',
		    serverId: 'jfrog-art-1',
		    releaseRepo: 'ravi_3149871',
		    snapshotRepo: 'ravi_3149871'
		)
		rtMavenRun (
		    pom: 'pom.xml',
		    goals: 'clean install',
		    deployerId: 'deployer'
		)
		rtPublishBuildInfo (
		    serverId: 'jfrog-art-1'
		)
            }
        }
	stage ('Docker_Image') {
            steps {
		bat "docker.exe build -t raviprakash60/dtr.nagarro.com/sample_app:${BUILD_NUMBER} --no-cache ."
            }
        }
	stage ('Pust_To_DTR') {
		withCredentials([usernamePassword( credentialsId: 'docker-hub-credentials', usernameVariable: 'raviprakash60', passwordVariable: 'Relectronics92@')]) {
        		def registry_url = "registry.hub.docker.com/"
        		bat "docker login -u $USER -p $PASSWORD ${registry_url}"
        		docker.withRegistry("http://${registry_url}", "docker-hub-credentials") {
            			// Push your image now
           		 	bat "docker.exe push raviprakash60/dtr.nagarro.com/sample_app:${BUILD_NUMBER}"
        		}
		}
	}

	stage ('Stop_Running_Container') {
            steps {
		bat '''
			ContainerID=$(docker ps | grep 7000| cut -d -- .f l)
			if [ $ContainerID ]
			then 
				docker.exe stop $ContainerID
				docker.exe rm -f $ContainerID
			fi
		'''
            }
        }
	stage ('Docker_Deployment') {
            steps {
		bat "docker.exe run --name sample_app -d -p 7000:8080 raviprakash60/dtr.nagarro.com/sample_app:${BUILD_NUMBER}"
            }
        }
    }
}