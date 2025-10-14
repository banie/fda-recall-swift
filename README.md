# fda-recall-swift
iOS app that helps users stay informed about food safety by browsing FDA food recalls and enforcement actions.

# Setup instructions
Simply clone the repository, open the fdaRecall.xcodeproj and press run

# Architecture decisions
- I'm using largely MVVM, but I don't adhere to it very stricly as I'm also using interactor and repository. Interactor to encapsulate the usecase like getting recall list from network, and the Repository as the singleton where the View and ViewModel can understand about the state of the data. 
- Choosing ViewModel because I want to be able to abstract as much business logic away from the View itself, and that the code can be tested separately from the UI packages like SwiftUI.
- I'm also using SwiftData because it serves two biggest purposes: to persist data the easiest way, and to get data displayed to the View automatically. This way it's very less likely for the app to get rate limited, and we don't have to introduce anti pattern to get datamodel to be published from the ViewModel to the View via some published Array or something like that


# Known limitations
- Since the api is rate limited and I'm not any special consumer, I made the effor to ensure these are the only times where I'm hitting the backend:
    1. When there is nothing stored yet in persistence, then we'll fetch the first page of data
    2. When we've reached the last item in ModelContext persistence, then it will trigger to load more (the next page)
    3. When the current date is later than the saved date of last fetch
- I'm using pagination in fetching the data from backend, but I'm not using pagination when querying the data from persistence. So there could be some performance issue if user kept scrolling to more than a few hundred items or so. 

# Any assumptions made
- The fda endpoint to be stable and not go down or change their contract anytime soon
- In terms of is user scrolls to more than few hundred items, to be honest, I think the performance issue could be negligible since we are using SwiftData to query the models from persistence, and I think Apple is already making optimization themselves in List to handle big size data models. Plus the row size itself is static, so this is where I assume iOS will handle the row recycling properly under the hood by default 