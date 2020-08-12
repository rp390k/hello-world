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
                dat "mvn install"
            }
        }
	stage ('unit_testing') {
            steps {
                echo "unit test"
                dat "mvn test"
            }
        }
	stage ('sonar_analysis') {
            steps {
		withSonarQubeEnv("LocalSonar") {
                    dat "mvn sonar:sonar"
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
    }
}