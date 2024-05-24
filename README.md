# ShakeItApp
An iOS App that shows a list of cocktails, a filter page and a detail view.

The app is written using Swift and with iOS 14 as development target.

In the main page of the app you can see the current available and selected filters and a list of cocktails based on filters selected.

The app lists the cocktails by alphabetical order, thanks to the [TheCocktailDB](https://www.thecocktaildb.com/) API.

UI is designed without XIBs or Storyboards.
Only the Error popup and the detail header are written using XIBs, to prove flexibility.
The app support iPhones and iPads with all screen orientations.

## The app
- Since the APIs doesn't guarantee to have all elements by using their endpoint filters (for example: [FilterByCategoryAPI](https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink)), return only few items for each filter and it hasn't the possibility to pass multiples query parameters in the URL request, I decided to move as followed:

- During the first load, the app loads, stores and shows the first cocktails that begins with the letter "a" ([FilterByFirstLetter](https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a)).

- In parallel it requests the filters available to the API by the 4 API available for listing the filters (all in concurrency):
    [ListAllCategoryAPI](https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list)
    [ListAllGlassesAPI](https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list)
    [ListAllIngredientsAPI](https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list)
    [ListAllAlcoholic_NonAlcoholicAPI](https://www.thecocktaildb.com/api/json/v1/1/list.php?a=list)
    
    - This requests are not mandatory for the app for using. If no or some filters come from server, the app will continue to work with the remaining filters, in this case a popup will inform you.
    - This fields are some of the fields available in the base drink model.
    
- The app filters locally with the selected filters and shows the filtered drinks to the main page. (By default all elements from the filters from the API are selected)
- By scrolling down, the app will load other drinks by the followed letter with a visible loader thanks to pagination.

- If the app is not able to load cocktail items because of an API error, a popup will be shown, in this case you can retry the request.

- By filtering, if the drinks stored so far are no conforms to filters, other elements will be loaded from API.

- If all alphabetical data are retrieved (basically if all letters and numbers was requested), the app hides the bottom loader when scrolling and stops trying to load other elements.

- If no drinks are conformed to filters and all data are loaded from API, a "no items" view is showed into the page.

- When the user taps on an element from the list, a detail page is showed.

<b>The detail page is ready to view only when the image of the cocktail is retrieved from the TheCocktailDB server</b> (by using the image url in the model), for avoiding the image download time waiting. In this case the image and the right arrow will be show to the user.

In the detail page the user can see the instructions, the ingredients and the measures of the cocktails.

When the user taps on "Filter by" button, the app shows all filters available and selected.

It's mandatory to select at least one filter for each type, to continue the filtering.

## Additional features
- <b>Settings</b>
    - The app supports both light and dark mode and you can choose automatic mode (the system one) or your favourite mode from the "gear" icon on top-right of the home page
    
    - The app supports english and italian language. You can choose the automatic mode (the system language) or your favourite language from the "gear" icon on top-right in the home page.
    
Both settings will be stored in the UserDefaults if not set to the system settings (A "UserDefault" "propertyWrapper is created to easy store and get data from User Defaults)

- Popups and loaders improve the user's experience thanks to Lottie animations:
    - A loader will be shown on the bottom of the cocktails list when data are loading from API.
    - A popup will be shown if some errors occurred while loading data from API.

## Architecture
The app is written with the MVVM Architecture using async-await and Combine to observe value changes. Dependency Injection initializers are used to create ViewModels.
There are some base classes (BaseView, BaseViewController, BaseViewModel, ecc..) to inherit from to simplify the syntax and to have a common behavior.

- There are two basic providers ("NetworkProvider" and "ImageProvider") to retrieve data and image from API. 
  This providers are injected in the NetworkViewModel's classes (those ViewModels that needs to call APIs).

- The "APIElement" protocol provides a standard set of property for each API endpoint (scheme, host, path and query parameters).
    - Each API should at least specify the Output data set, the path and the query parameters, if any.
    - The "BaseResponse" class contains the "drinks" payload, which is the common JSON structure that comes from all the API of the TheCocktailDB server.
    - The "NetworkProvider" contains the "fetchData" method in which is declared a generic parameter of "APIElement" and it can return a "Result" of "APIElement.Output" or an "ErrorData" (an enum that defines errors).
    - The real "NetworkManager" is conformed to the "NetworkProvider" protocol and take the APIElement property to make the real API call.
    
- The app contains a shared instance (singleton) of the AppPreferences in which data (like language and current theme) are specified.
- The "Palette" is a protocol that defines a list of color useful for the app.
    - The structs "LightPalette" and "DarkPalette" implement it and definies their own color for the relative theme. 
      Some color are common for both Palette, so the "Palette" protocol extension is created to define them.
    
## Views
- The BaseViewController class wraps a generic ViewModel and initialize it from the inititializer method.
    - Since all of the ViewControllers contains a Table View, I created a TableViewController that inherit from the BaseViewController class and contains a TableView property.
      By using this TableViewController, the layout setup and the creation of the tableView is assigned to the TableViewController.
      If a ViewController doesn't like the layout setup of the standard TableViewController and want to add elements or something more different, it's free to override the methods (like the FiltersViewController does for adding the bottom button).
      
- Each Views and Cells (table and collection view cells) can inherit from the BaseView, BaseTableViewCell, BaseHeaderView and BaseCollectionViewCell classes and are designed to have a ViewModel instance for providing data. It is useful to have a standard configuration for initializing views in a centralized place.
    
    - The "CellReusable" is a simple protocol that generates a "reuseIdentifier" (simply the name of the class) used for TableViewCells, CollectionViewCells and reusable Header Views.
    - There are some utils method for both UITableView and UICollectionView to register a CellReusable cell and dequeuing it.

I created also a branch, called "feature/dispatch_queue", in which I removed all async-await and replacing them with closures and Dispatchers (DispatchGroups for concurrency requests), to prove the Combine flexibility, without touching any of View implementations.

## External Libs
I added Lottie using Swift Package Manager to show how is its usage.

I used only native classes and libraries, such as Combine, UIKit and URLComponents, URLSession for API web calls.

## Unit tests
I wrote some unit test to test some part of MainViewModel behavior. 
Thanks to the dependency injection I tested the API handling by injecting spy network classes to the View Model.

## Future implementations
I like to create a simple SwiftUI view to search cocktails by name, using the search API of the "TheCocktailDB". I started in the branch "feature/search_swift_ui"

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
<img src="./screenshots/detail_light.png?raw=true" width="200">
<img src="./screenshots/detail_dark.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/no_elements_light.png?raw=true" width="200">
<img src="./screenshots/no_elements_dark.png?raw=true" width="200">
</p>
<p>
<img src="./screenshots/loading_light.png?raw=true" width="200">
<img src="./screenshots/loading_dark.png?raw=true" width="200">
</p>



