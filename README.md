# ShakeItApp
An iOS App that shows a list of cocktails, a filter page and a detail view.

The app is written using Swift and with iOS 14 as development target.

In the main page of the app you can see the current available and selected filters and a list of cocktails based on filters selected.

The app lists the cocktails by alphabetical order, thanks to the [TheCocktailDB](https://www.thecocktaildb.com/) API.

UI is designed without XIBs or Storyboards.
Only the Error popup and the detail header are written using XIBs, to prove flexibility.
The app support iPhones and iPads with all screen orientations.

## The app
During the first load, the app loads and shows the first cocktails that begins with "a".
In parallel it requests the filters available to the API by the 4 API available for filtering. This requests are not mandatory for the app for using. If no or some filters come from server, the app will continue to work with the remaining filters, in this case a popup will inform you.

By scrolling down, the app will load the other letter alphabetically with a visible loader.

If the app is not able to load cocktail items, a popup will be shown, in this case you can retry the request.
If all alphabetical data are retrieved (basically all letters and numbers was requested), the app hide the bottom loader and stops trying to load other elements.

When the user taps on an element from the list, a detail page is showed.

<b>The detail page is ready to view only when the image of the cocktail is retrieved from the TheCocktailDB server</b> (by using the image url in the model). In this case the image and the right arrow will be show to the user.

In the detail page the user can see the instructions, the ingredients and the measures of the cocktails.

When the user taps on "Filter by" button, the app shows all filters available and selected.

It's mandatory to select at least one filter for each type, to continue the filtering.

## Additional features
- The app supports both light and dark mode and you can choose automatic mode (the system one) or your favourite from the gear icon on top-right of the home page
- The app supports english and italian language. You can choose the automatic mode (the system language) or your favourite language from the gear icon on top-right in the home page.
- Popups and loaders improve the user's experience thanks to Lottie animations:
    - A Loader will be shown on the bottom of the cocktails list when data are loading from API
    - A popup will be shown if some errors occurred while loading data from API

## Architecture
The app is written with the MVVM architecture using async-await and combine to observe value changes.
There are some base classes (BaseView, BaseViewController, BaseViewModel, ecc..) to inherit from to simplify the syntax.

I created also a branch, called "feature/dispatch_queue", in which I removed all async-await and replacing them with closures and Dispatchers (DispatchGroups), to prove the Combine flexibility, without touching any of View implementations.

## External Libs
I added Lottie using Swift Package Manager to show how is its usage.

I used only native classes and libraries, such as UIKit, URLCache to store datas, URLComponents, URLRequest, URLSession and URLResponse for API web calls.

## Unit tests
I wrote some unit test to test some part of MainViewModel behavior

## App screenshots

<p>
<img src="./screenshots/main_light.png?raw=true" width="200">
<img src="./screenshots/main_dark.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/filters_light.png?raw=true" width="200">
<img src="./screenshots/filters_dark.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/detail_light.png?raw=true" width="250">
<img src="./screenshots/detail_dark.png?raw=true" width="250">
</p>
<p>
<img src="./screenshots/no_elements_light.png?raw=true" width="250">
<img src="./screenshots/no_elements_dark.png?raw=true" width="250">
</p>
<p>
<img src="./screenshots/loading_light.png?raw=true" width="250">
<img src="./screenshots/loading_dark.png?raw=true" width="250">
</p>



