## Architecture

Here, I am showing the architecture of iOS Viary.

## Concepts

First of all, let's understand the concept of viary architecture.

- SwiftUI based app.
- Aware of testing.
- Modularized app.
- App loving pointfree.


### SwiftUI based app

Viary is developed as a personal application. this is why I can settle high iOS version requirement (above iOS15).
In my opinion, if app can only be published to above iOS 15, we can develop almost all simple applications with SwiftUI (and less UIKit).

I think SwiftUI benefits
- easy to create UI
- easy to manage State
- easy to fulfill the common ui usecasae

are very worth.

so Viary is based on SwiftUI :)

### Aware of testing

If we are aware of testing and try to make codes testable, our code will definetely becomes clean and far from fragile.

Here are some child concepts to be aware of testing.

- Dependency Injection
- Scheduler
- Mocking

Hopefully, thanks to great working by pointfree and uber, we don't have to think of them so much :)

- https://github.com/pointfreeco/swift-dependencies
- https://github.com/pointfreeco/swift-composable-architecture
- https://github.com/uber/mockolo


### Modularized App

### App loving pointfree

## Characters


