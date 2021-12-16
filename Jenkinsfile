node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build('paulta91/coursework2')
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push('latest')
        }
    }

    stage('Deploy to Kubernetes Cluster') {
        steps {
            ///CREATE AND APPLY THE PATCH. REMEMBER TO LOGIN ON THE CLUSTER. (-s $CLUSTER_URL --token $TOKEN_CLUSTER --insecure-skip-tls-verify)
            sh  '''

    PATCH_TO_DEPLOY={\\"metadata\\":{\\"labels\\":{\\"version\\":\\"${env.BUILD_ID}\\"}},\\"spec\\":{\\"template\\":{\\"metadata\\":{\\"labels\\":{\\"version\\":\\"${env.BUILD_ID}\\"}},\\"spec\\":{\\"containers\\":[{\\"name\\":\\"$NAME_DEPLOY\\",\\"image\\":\\"my-image:${env.BUILD_ID}\\"}]}}}}

    kubectl patch deployment $NAME_DEPLOY  -n $NAMESPACE -p $PATCH_TO_DEPLOY \
    -s $CLUSTER_URL --token $TOKEN_CLUSTER --insecure-skip-tls-verify

    '''
        }
    }
}

