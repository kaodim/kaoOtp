# kaodimDesignIos
Design Component for iOS

KAODESIGN STEP
1. make sure all changes is done and comitted
2. Bump s.version under kaoDesign.podspec file, then commit push
3. Go to kaoDesign github repo and create release note with the same version number as the previous s.version under podspec file
4. publish the release note
5. execute `pod repo push kaococoapods --swift-version=4.0 --allow-warnings KaoDesign.podspec` on terminal

KAONOTIFICATION STEP
1. switch to kaoNotification repo, Bump s.version under kaoNotification.podspec file, 
2. Bump s.dependency for kaoDesign to be equals to the latest version then commit push
3. Go to kaoNotification github repo and create release note with the same version number as the previous s.version under podspec file
4. publish the release note
5. execute `pod repo push kaococoapods --swift-version=4.0 --allow-warnings KaoNotification.podspec`
