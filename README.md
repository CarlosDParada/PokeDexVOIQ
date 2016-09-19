# README #

OkeDex_VOIQ

## Deployment Target ##

iOS 8.3

## Language ##

Objective-C

## API ##

PokeApi version 2

http://pokeapi.co/api/v2/


## Library ##

AFNetworking 
https://github.com/AFNetworking/AFNetworking

The library manages the Get and Post requests.
It facilitates the management of NSURLSession, helps standardize the API calls and manage the responses.


MBProgressHUD
https://github.com/matej/MBProgressHUD

The library facilitates the addition of a translucent HUD as an indicator while working on a thread, it helps the user to be aware of the actions of the App and this doesn't interfere with the API calls, as was in this case.
It also helps not to repeat actions in the background when the user clicks on several occasions, because it blocks the view.


## View ##

# Home #
In this view you observe the list of pokemons of the API, it shows id, image and name.
The view initially loads the first 20 pokemons according to their universal ID, then when you scroll quickly add the next 20 pokemons, saving the use of the network and the waiting time for the user.

This was done because the API contains 811 pokemons and the process of downloading all these would take longer because the API queries don't return all at once, it would have to take several calls synchronously to preserve order.

# Detail #

The view shows a Sprite Image with all the images that have the API for a particular pokemon, besides its name, universal ID, gender, weight and height.

## Structure ##

Has:
PDV_webservice unifies all queries to the API, managing the use of the session, so that can be called from any viewController.
PDV_Constans is a class that manages the constants of applications, so that for changing a value not need to change it in classes that use it. This class contains the urls needed for the project and keys to the API responses.
NSObject is used to manipulate the responses of queries and thus control errors.
CellHome.xib is used to display the desired fields in the tableView of the Home (id, image, name).
