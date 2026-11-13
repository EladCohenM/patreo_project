# Bet You Can't

A native SwiftUI iOS app for creating challenges with friends, predicting outcomes, and climbing a group leaderboard.

## Run

1. Open `BetYouCant.xcodeproj` in Xcode.
2. Select an iPhone simulator.
3. Build and run (`⌘R`).

The current app uses an in-memory `AppStore` with preview data. It requires iOS 17 or newer and has no third-party dependencies.

## Structure

- `App`: app entry point and tab navigation
- `Domain/Models`: core product entities
- `Domain/Services`: app state and, later, API/repository implementations
- `Features`: screens grouped by product feature
- `DesignSystem`: shared visual tokens and components
- `Resources`: asset catalog

## Suggested next milestones

1. Define challenge resolution and scoring rules.
2. Add authentication and persistent storage.
3. Add group invites and membership.
4. Add challenge detail, predictions, and proof submission.
5. Add notifications and moderation/reporting.
