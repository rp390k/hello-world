pipeline {
    agent any
    tools {
        maven 'Maven 3.6'
    }
environment {
	registry = "raviprakash60/dtr.nagarro.com"
	registryCredential = 'dockerhub'
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
		bat "docker.exe build -t raviprakash60/dtr.nagarro.com:${BUILD_NUMBER} --no-cache ."
            }
        }
	stage ('Pust_To_DTR') {
		steps{
           		 	bat "docker.exe push raviprakash60/dtr.nagarro.com:${BUILD_NUMBER}"
        	}
	}

	stage ('Docker_Deployment') {
            steps {
		bat "docker.exe run --name sample_app -d -p 8080 raviprakash60/dtr.nagarro.com:${BUILD_NUMBER}"
            }
        }
    }
}