def build_env_file = '.env'

node {
    stage 'Build'
    git url: 'http://github.com/karlkfi/minitwit', branch: 'ci'

    withEnv(["OUT_FILE=${build_env_file}"]) {
        sh 'ci/build.sh'
    }

    def build_props = readProperties file: build_env_file

    stash name: 'build-output', includes: "${build_env_file},${build_props['DOCKER_IMG_TAR']}"
}

// checkpoint 'Completed Build'

node {
    stage 'Test'
    git url: 'http://github.com/karlkfi/minitwit', branch: 'ci'

    unstash name: 'build-output'

    def build_env = new ArrayList()
    build_env.add "OUT_FILE=${build_env_file}"
    build_env.addAll Arrays.asList(readFile(build_env_file).split('\n'))

    try {
        withEnv(build_env) {
            sh 'ci/run.sh'
        }
    } finally {
        build_env.clear()
        build_env.addAll Arrays.asList(readFile(build_env_file).split('\n'))
        withEnv(build_env) {
            sh 'ci/cleanup.sh'
        }
    }
}
