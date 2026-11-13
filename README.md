# Bet You Can't

Friends create small challenges, predict outcomes, and maintain a leaderboard. No real-money betting.

## iOS prototype

A native SwiftUI app for iPhone, targeting iOS 17 or later. The prototype runs entirely on the device and saves challenges between launches.

- Create a challenge for yourself or a sample friend and set a deadline.
- Make or change a yes/no prediction until the deadline or a result is recorded.
- Record a result and earn 10 points for each correct prediction.
- View completed challenges and the group leaderboard. Tied scores share a rank.

The sample friends and their initial predictions are demo data. Accounts, invitations, shared challenges across devices, and result verification are not implemented yet. In this prototype, the local user can record any challenge's result, including before its deadline; results cannot be undone.

## Run

1. Open `BetYouCant.xcodeproj` in Xcode.
2. Select the `BetYouCant` scheme and an iPhone simulator.
3. Run with **⌘R**.

For a physical iPhone, select your development team under **Signing & Capabilities** and use a unique bundle identifier if needed.

## Build check

```sh
xcodebuild -project BetYouCant.xcodeproj -scheme BetYouCant \
  -sdk iphonesimulator -configuration Debug \
  -derivedDataPath /tmp/bet-you-cant-build CODE_SIGNING_ALLOWED=NO build
```

## Manual walkthrough

Create a challenge, open it, choose a prediction, change your prediction, and record a result. Check that the leaderboard awards 10 points only for a correct prediction, and that the completed challenge no longer accepts predictions. Relaunch the app to check saved progress. For deadline behavior, create a challenge with a near-term deadline and leave its details open until predictions close.
