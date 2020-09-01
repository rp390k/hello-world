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
		bat "/bin/docker build -t raviprakash60/dtr.nagarro.com:443/sample_app:${BUILD_NUMBER} --no-cache - Dockerfile ."
            }
        }
	stage ('Pust_To_DTR') {
            steps {
		bat "/bin/docker docker push raviprakash60/dtr.nagarro.com:443/sample_app:${BUILD_NUMBER}"
            }
        }
	stage ('Stop_Running_Container') {
            steps {
		bat '''
			ContainerID=$(docker ps | grep 7000| cut -d -- .f l)
			if [ $ContainerID ]
			then 
				docker stop $ContainerID
				docker rm -f $ContainerID
			fi
		'''
            }
        }
	stage ('Docker_Deployment') {
            steps {
		bat "docker run --name sample_app -d -p 7000:8080 raviprakash60/dtr.nagarro.com:443/sample_app:${BUILD_NUMBER}"
            }
        }
    }
}