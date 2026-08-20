# CI/CD Config for Flutter

1. [Jenkins](#jenkins)
2. [Project Config](#project-config)
3. [Fastlane](#fastlane)
4. [Usage](#usage)

For more information, please read [this document](https://docs.google.com/document/d/1IwaZqjTrthwRDg1i8Co1NzqSGgT5Rvg0kLKBF7mm5Uw/edit?usp=drive_link)

## Jenkins
### Setup on Jenkins Server
1. Create a new job
2. Select `Pipeline` type
3. In `Pipeline` section, select `Pipeline script from SCM` in `Definition` field
4. In `SCM` section, select `Git` in `SCM` field
5. In `Repository URL` field, put your git repository url - use SSH url
6. In `Credentials` field, select 'hoannv' credential
7. In `Script Path` field, put `Jenkinsfile`
8. Click `Save` button
9. Add firebase_distribution_service_account to Jenkins credential
### Edit Jenkinsfile 
You need to edit some variables in `Jenkinsfile` file to match your project
```groovy
environment {
        // Replace with your own credentials
        GOOGLE_APPLICATION_CREDENTIALS = credentials('{your_project_name}-firebase_distribution_service_account')
        WEBHOOK_GOOGLE_CHAT_URL = '' // Replace with your own webhook url

        // Don't change these variables if you don't know what you're doing
        PROJECT_CONFIG_FOLDER = 'ci-cd-config'
        PROJECT_CONFIG_FILE = "$PROJECT_CONFIG_FOLDER/project-config.yaml"
        scannerHome = tool 'Rikkei SonarQube'
        flutterSDKCacheDirectory = '/Users/servermac-d1-m/fvm/versions'
        DEPLOYGATE_API_TOKEN = credentials('Deploygate-token')
        DEPLOYGATE_USER = 'rikkei_mobile'
    }
```

## project-config
Declare your project config in `./ci-cd-config/project_config.yaml` file

```yaml
# Change the flutter version to the one you want to use
flutter_version=3.13.7

#for firebase
firebase_android_staging_app_id=<put your app id here>
firebase_android_production_app_id=<put your app id here>
firebase_ios_staging_app_id=<put your app id here>
firebase_ios_production_app_id=<put your app id here>

#for deploygate
deploygate_android_staging_distribution_key=<put your distribution key here>
deploygate_android_production_distribution_key=<put your distribution key here>
deploygate_ios_staging_distribution_key=<put your distribution key here>
deploygate_ios_production_distribution_key=<put your distribution key here>

```

## Fastlane
### Setup
1. Create ./android/fastlane/Fastfile
```ruby
default_platform(:android)
platform :android do
  lane :deploy_to_firebase do |options|
        release_note = options[:release_note]
        flavor = options[:flavor]
        firebase_app_id = options[:firebase_app_id]
        firebase_app_distribution(
             app: firebase_app_id,
             release_notes: release_note,
             android_artifact_type: "APK",
             groups: "Rikkei",
             android_artifact_path: "../build/app/outputs/flutter-apk/app-#{flavor}-release.apk",
          )
  end
end
```
2. Create ./ios/fastlane/Fastfile
```ruby
default_platform(:ios)

platform :ios do
  lane :deploy_to_firebase do |options|
        release_note = options[:release_note]
        firebase_app_id = options[:firebase_app_id]
        firebase_app_distribution(
             app: firebase_app_id,
             release_notes: release_note,
             groups: "Rikkei",
             ipa_path: "../build/ios/ipa/<app_name>.ipa",
          )
  end

end
```
Note: You can add more lanes to deploy to other platforms like deploy to deploygate, testflight, ...

## Usage
### Release to firebase
1. Checkout to your branch that you want to release
```bash
git checkout <branch_name>
```
2. Create a tag for your release with format: ${distribution_platform}_${flavor}_${version_name}+${version_code}
Example: firebase_staging_dev_1.0.0+1
```bash
git tag <tag_name>
```
=> Ex: `git tag firebase_staging_dev_1.0.0+1`
3. Push your tag to remote
```bash
git push origin <tag_name>
```
=> Ex: `git push origin firebase_staging_dev_1.0.0+1`

