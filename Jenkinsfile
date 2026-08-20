pipeline {
    agent any
    tools{
        jdk 'jdk-17'
    }

    environment {
        // Replace with your own credentials
        GOOGLE_APPLICATION_CREDENTIALS = credentials('{your_project_name}-firebase_distribution_service_account')
        WEBHOOK_GOOGLE_CHAT_URL = ''

        // Don't change these variables if you don't know what you're doing
        PROJECT_CONFIG_FOLDER = 'ci-cd-config'
        PROJECT_CONFIG_FILE = "$PROJECT_CONFIG_FOLDER/project-config.yaml"
        scannerHome = tool 'Rikkei SonarQube'
        flutterSDKCacheDirectory = '/Users/servermac-d1-m/fvm/versions'
        DEPLOYGATE_API_TOKEN = credentials('Deploygate-token')
        DEPLOYGATE_USER = 'rikkei_mobile'
    }

    options {
        gitLabConnection('Rikkei GitLab')
        gitlabBuilds(builds: ['Prepare Flutter'])
    }

    stages {
        stage('Check Git Tag') {
            steps {
                script {
                    env.BUILD_FLAG = 'false'
                    def tagName = sh(script: "git describe --tags --exact-match &> /dev/null && git describe --tags --exact-match || echo '-1'", returnStdout: true).trim()
                    echo "tagname=${tagName}"

                    if (tagName!='-1') {
                        echo "Found Git tag: ${tagName}"

                        // Define a regular expression to match the expected tag format
                        // Rule: firebase|deploygate_(dev|staging|uat|production)_1.0.0 or firebase|deploygate_(dev|staging|uat|production)_1.0.0+1
                        // Example: firebase_dev_1.0.0+1

                        def distributeAppTagPattern = ~/^(firebase|deploygate)_(dev|staging|uat|production)_\d+\.\d+\.\d+(\+\d+)?$/

                        if (tagName && tagName =~ distributeAppTagPattern) {

                            // Extract flavor and version from the tag
                            def (targetUpload, flavor, versionAndBuild) = tagName.tokenize('_')
                            def (version, buildNumber) = versionAndBuild.tokenize('\\+')
                            buildNumber = buildNumber ?: '1'
                            // Set environment variables for the build
                            env.BUILD_FLAG = 'true'
                            env.TAG_NAME = tagName
                            env.TARGET_UPLOAD = targetUpload
                            env.FLAVOR = flavor
                            env.VERSION = version
                            env.BUILD_NUMBER = buildNumber
                            env.EXPORT_OPTIONS_PLIST_FILE = "${env.PROJECT_CONFIG_FOLDER}/ExportOptions-${env.FLAVOR}.plist"
                            echo "Build flavor: ${FLAVOR}"
                            echo "Build version:: ${VERSION}"
                            echo "Build number: ${BUILD_NUMBER}"
                            echo "EXPORT_OPTIONS_PLIST_FILE: ${env.EXPORT_OPTIONS_PLIST_FILE}"
                        } else {
                            sendGoogleChatNotification(buildErrorMessage(STAGE_NAME, "Invalid Git tag format: ${tagName}<br>Please check again."))
                            error "Invalid Git tag format"
                            currentBuild.result = 'ABORTED'
                        }
                    } else {
                        echo "No Git tag found."
                    }
                }
            }
        }
        stage('Prepare Flutter') {
            stages {
                stage('Check Flutter SDK') {
                    steps {
                        script {
                            try {
                                updateGitlabCommitStatus name: 'Prepare Flutter', state: 'running'

                                def projectConfigProps = readProperties file: "${PROJECT_CONFIG_FILE}"
                                env.FLUTTER_VERSION = projectConfigProps['flutter_version']
                                def OS_TYPE = sh(script: 'uname -s', returnStdout: true).trim()
                                def folderExists = false
                                def flutterSDKFile
                                if (OS_TYPE == 'Linux' || OS_TYPE == 'Darwin') {
                                    TARGET_FOLDER = "${flutterSDKCacheDirectory}/${env.FLUTTER_VERSION}"
                                    def checkCommand = "test -d ${TARGET_FOLDER} && echo 'true' || echo 'false'"
                                    folderExists = sh(script: checkCommand, returnStdout: true).trim() == 'true'
                                } else {
                                    error "Unsupported operating system: ${OS_TYPE}"
                                }

                                if (folderExists) {
                                    echo "Folder '${TARGET_FOLDER}' exists."
                                } else {
                                    echo "Folder '${TARGET_FOLDER}' does not exist."

                                    echo 'Downloading Flutter SDK...'
                                    def downloadUrl
                                    if (OS_TYPE == 'Linux') {
                                        flutterSDKFile = "flutter_linux_${env.FLUTTER_VERSION}-stable.tar.xz"
                                        downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${flutterSDKFile}"
                                    } else if (OS_TYPE == 'Darwin') {
                                        flutterSDKFile = "flutter_macos_${env.FLUTTER_VERSION}-stable.zip"
                                        downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/${flutterSDKFile}"
                                    } else {
                                        error "Unsupported operating system: ${OS_TYPE}"
                                    }
                                    echo 'Check SDK was downloaded'

                                    def exists = fileExists "${flutterSDKFile}"

                                    if (exists) {
                                        echo "Yes, ${flutterSDKFile} exists."
                                    } else {
                                        echo "No, ${flutterSDKFile} does not exist."
                                        sh "curl -O ${downloadUrl}"
                                    }

                                    echo 'Extracting Flutter SDK.....'
                                    sh 'mkdir -p ${flutterSDKCacheDirectory}/'
                                    if (OS_TYPE == 'Linux') {
                                        sh "apt-get install xz-utils"
                                        sh "tar xf ${flutterSDKFile}"
                                    } else if (OS_TYPE == 'Darwin') {
                                        sh "unzip -q ${flutterSDKFile} -d ./"
                                    }
                                    // Rename extracted flutter directory to $env.FLUTTER_VERSION
                                    sh "mv ./flutter ${flutterSDKCacheDirectory}/${env.FLUTTER_VERSION}"
                                }
                                // Get Absolute path of Flutter SDK
                                def flutterSdkDirCommand = "echo ${flutterSDKCacheDirectory}/${env.FLUTTER_VERSION}/bin"
                                env.FLUTTER_SDK_DIR = sh(script: flutterSdkDirCommand, returnStdout: true).trim()
                                sh "git config --global --add safe.directory ${flutterSDKCacheDirectory}/${env.FLUTTER_VERSION}"

                                env.PATH = "${env.FLUTTER_SDK_DIR}:${env.PATH}"
                            } catch (e) {
                                echo "Error: ${e}"
                                updateGitlabCommitStatus name: 'Prepare Flutter', state: 'failed'
                            }
                        }
                    }
                }
                stage('Flutter Generate') {
                    steps {
                        script {
                            try {
                                echo 'Running Flutter Generate'
                                sh "flutter --version"
                                sh 'flutter clean'
                                sh 'flutter pub get'
                                sh 'flutter pub run build_runner build --delete-conflicting-outputs'
                                updateGitlabCommitStatus name: 'Prepare Flutter', state: 'success'
                            } catch (e) {
                                echo "Error: ${e}"
                                updateGitlabCommitStatus name: 'Prepare Flutter', state: 'failed'
                            }
                        }
                    }
                }
            }
        }
        stage('Build and Distribute') {
            when {
                expression { return env.BUILD_FLAG == 'true' }
            }
            parallel {
                stage('Build and Distribute Android') {
                    stages{
                        stage('Build Android'){
                            steps {
                                script {
                                    updateGitlabCommitStatus name: 'Build Android', state: 'running'
                                    echo "Building Android APK..."
                                    sh "flutter build apk --release --flavor ${env.FLAVOR} --dart-define=flavor=${env.FLAVOR} --build-name=${env.VERSION} --build-number=${env.BUILD_NUMBER}"
                                    echo "Build apk Finished"
                                    updateGitlabCommitStatus name: 'Build Android', state: 'success'
                                    env.BUILD_ANDROID_SUCCESS='1'
                                }
                            }
                        }
                        stage('Distribute Android'){
                            steps {
                                script {
                                    updateGitlabCommitStatus name: 'Distribute Android', state: 'running'
                                    echo "Distributing Application....."
                                    def lane = "deploy_to_${env.TARGET_UPLOAD}"
                                    def projectConfigProps = readProperties file: "${PROJECT_CONFIG_FILE}"
                                    def firebaseAppId = projectConfigProps["firebase_android_${env.FLAVOR}_app_id"]
                                    sh "cd ${WORKSPACE}/android && bundle exec fastlane $lane release_note:${env.TAG_NAME} flavor:${env.FLAVOR} firebase_app_id:${firebaseAppId}"
                                    sendGoogleChatNotification(buildResultBodyMessage('Success', 'Android'))
                                    updateGitlabCommitStatus name: 'Distribute Android', state: 'success'
                                }
                            }
                        }
                    }
                    post {
                        aborted {
                            script {
                                sendGoogleChatNotification(buildResultBodyMessage('Failed', 'Android'))
                                if (env.BUILD_IOS_SUCCESS != '1') {
                                    updateGitlabCommitStatus name: 'Build Android', state: 'failed'
                                }
                                updateGitlabCommitStatus name: 'Distribute Android', state: 'failed'
                            }
                        }
                    }
                }
                stage('Build and Release iOs') {
                    stages{
                        stage('Build iOS'){
                            steps {
                                script {
                                    updateGitlabCommitStatus name: 'Build iOS', state: 'running'
                                    echo "Building iOS..."
                                    sh "flutter build ipa --release --flavor ${env.FLAVOR} --dart-define=flavor=${env.FLAVOR} --export-options-plist=${env.EXPORT_OPTIONS_PLIST_FILE} --build-name=${env.VERSION} --build-number=${env.BUILD_NUMBER}"
                                    echo "Build ios Finished"
                                    env.BUILD_IOS_SUCCESS='1'
                                    updateGitlabCommitStatus name: 'Build iOS', state: 'success'
                                }
                            }
                        }
                        stage('Distribute iOS'){
                            steps {
                                script {
                                    updateGitlabCommitStatus name: 'Distribute iOS', state: 'running'
                                    echo "Distributing Application...."
                                    def lane = "deploy_to_${env.TARGET_UPLOAD}"
                                    def projectConfigProps = readProperties file: "${PROJECT_CONFIG_FILE}"
                                    def firebaseAppId = projectConfigProps["firebase_ios_${env.FLAVOR}_app_id"]
                                    sh "cd ${WORKSPACE}/ios && bundle exec fastlane $lane release_note:${env.TAG_NAME} flavor:${env.FLAVOR} firebase_app_id:${firebaseAppId}"
                                    sendGoogleChatNotification(buildResultBodyMessage('Success', 'iOS'))
                                    updateGitlabCommitStatus name: 'Distribute iOS', state: 'success'
                                }
                            }
                        }
                    }
                    post {
                        aborted {
                            script {
                                sendGoogleChatNotification(buildResultBodyMessage('Failed', 'iOS'))
                                if (env.BUILD_IOS_SUCCESS != '1') {
                                    updateGitlabCommitStatus name: 'Build iOS', state: 'failed'
                                }
                                updateGitlabCommitStatus name: 'Distribute iOS', state: 'failed'
                            }
                        }
                    }
                }
            }
        }
        stage('Sonar Scanner And Quality Gate') {
            when {
                not {
                    expression { return env.BUILD_FLAG == 'true' }
                }
            }
            stages{
                stage('SonarScanner'){
                    steps {
                        updateGitlabCommitStatus name: 'SonarScanner', state: 'running'
                        script {
                            echo "Workspace: ${WORKSPACE}"
                            try {
                                withSonarQubeEnv(installationName: 'Rikkei SonarQube') {
                                    echo 'Running Flutter Analyze'
                                    sh "flutter analyze --fatal-infos --fatal-warnings"
                                    echo 'Running SonarQube analysis'
                                    sh '${scannerHome}/bin/sonar-scanner'
                                    env.sonarScannerIsRunned = '1'
                                }
                            } catch (e) {
                                echo "Error: ${e}"
                                updateGitlabCommitStatus name: 'SonarScanner', state: 'failed'
                            }
                        }

                    }
                }
                stage('Quality Gate') {
                    when {
                        expression { return env.sonarScannerIsRunned == '1' }
                    }
                    steps {
                        timeout(time: 30, unit: 'MINUTES') {
                            script {
                                def qg = waitForQualityGate()
                                if (qg.status != 'OK') {
                                    updateGitlabCommitStatus name: 'SonarScanner', state: 'failed'
                                } else {
                                    updateGitlabCommitStatus name: 'SonarScanner', state: 'success'
                                }
                            }
                        }
                    }

                    post {
                        always {
                            script {
                                def taskInfo = readProperties file: '.scannerwork/report-task.txt'
                                def dashboardUrl = taskInfo['dashboardUrl']
                                addGitLabMRComment(comment: "Results of Jenkins build available at: <a href='${BUILD_URL}'>${BUILD_URL}</a><br />The SonarQube analyze completed, you can find the results at: <a href='${dashboardUrl}'>${dashboardUrl}</a>")
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
        }

        success {
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed!'
        }

        aborted {
            echo 'Pipeline aborted!'
        }
    }
}

def buildResultBodyMessage(String status, String platform) {
    // Send notification to Google Chat
    ///status: Success, Failed, Skipped, Canceled, Unknown
    def color = ""
    if (status == 'Success') {
        color = "#008000"
    } else if (status == 'Failed' || status == 'Canceled') {
        color = "#FF0000"
    } else if (status == 'Skipped') {
        color = "#FFA500"
    } else {
        color = "#000000"
    }

    def body = """
        {
                    "header": "Build Info",
                    "widgets": [{
                        "textParagraph": {
                            "text": "Platform: <b>${platform}</b>"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Distribution status: <b><font color='${color}'>${status}</font></b>"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Version: ${env.VERSION}+${env.BUILD_NUMBER}"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Distributed to: ${env.TARGET_UPLOAD}"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Flavor: ${env.FLAVOR}"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Triggered by tag: ${env.TAG_NAME}"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Commit Hash: ${GIT_COMMIT}"
                        },
                        "horizontalAlignment": "START"
                    }
                ],
                "collapsible": true,
                "uncollapsibleWidgetsCount": 3
            }
    """
    return body
}

def buildErrorMessage(String stageName, String message) {
    // Send notification to Google Chat
    ///status: Success, Failed, Skipped, Canceled, Unknown
    def color = "#FF0000"

    def body = """
        {
                    "header": "Build Info",
                    "widgets": [{
                        "textParagraph": {
                            "text": "Stage: <b>${STAGE_NAME}</b>"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Stage status: <b><font color='${color}'>ERROR!</font></b>"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Reason: ${message}"
                        },
                        "horizontalAlignment": "START"
                    },
                    {
                        "textParagraph": {
                            "text": "Commit Hash: ${GIT_COMMIT}"
                        },
                        "horizontalAlignment": "START"
                    }
                ],
                "collapsible": true,
                "uncollapsibleWidgetsCount": 3
            }
    """
    return body
}

def sendGoogleChatNotification(String body) {
    if (env.WEBHOOK_GOOGLE_CHAT_URL.isEmpty()) {
        echo "WEBHOOK_GOOGLE_CHAT_URL is empty, skip sending notification to Google Chat!"
        return
    }
    if (body.isEmpty()) {
        echo "Body message is empty, skip sending notification to Google Chat!"
        return
    }
    def distributeMessage = """
    {
        "cardsV2": [{
            "cardId": "card1",
            "card": {
                "header": {
                    "title": "Jenkins Notification",
                    "subtitle": "${env.JOB_NAME}",
                    "imageUrl": "https://www.jenkins.io/images/logos/googly/256.png",
                    "imageType": "CIRCLE"
                },
                "sections": [
                $body,
            {
                "widgets": [{
                    "buttonList": {
                        "buttons": [{
                            "text": "View details",
                            "onClick": {
                                "openLink": {
                                    "url": "${env.BUILD_URL}"
                                }
                            }
                        }]
                    },
                    "horizontalAlignment": "CENTER"
                }]
            }
        ]
    }
    }]
    }
    """
    googlechatnotification(
            url: env.WEBHOOK_GOOGLE_CHAT_URL,
            message: "${distributeMessage}",
            messageFormat: "card"
    )
}
