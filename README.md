
![Launcher](./launchericon.png)

This is a library used for adding a debuggable launcher to your `iOS` application to test specific controllers, views, flows, and features.

### Reason

This is a good way to test how modular your application is by only launching the views you *need* to launch for a feature/requirement. 

### Types

#### `Launcher`

This is the main type for this framework and is what allows you to display a `UITableView` containing all of the suites you've registered to the launcher. You have 2 ways of presenting controllers: you can either push them to the navigation controller or present them modally.

### `Suite` 

This type is the heart and soul of the framework since this determines what exactly fills out the list. It's a `protocol` you conform to in your project (usually by using an `enum` to do this). It has 4 components:

1. `rawValue` - This is what's used as the label for the `LauncherCell` .
2  `presentationMethod` - Here you can define how each controller you plan on adding presents itself. There are currently only 2 values: `push` and `present`.
3. `name` - This is the name of the section for the content. 
4. `controller() -> UIViewController` - This is the actual controller you plan on presenting/pushing whenever a `LaunchCell` is tapped.

### Workflow

1. Create an instance of `Launcher` for the `SceneDelegate` and give it a scene. This will return a window with the launcher already configured.
2. Call `.register(suites:)` to register your `Suite` enums. 
3. Call `makeKeyAndVisible` on the `UIWindow` the `Launcher` object returned.
