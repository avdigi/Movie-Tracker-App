Movie Tracker App - Final Project for ISTE-454\n
A personal movie tracker that allows you to view, manage, and add movies to your list for future viewing or keeping track of which movie you have watched.

Features Implemented:
•	Obtain popular movies list from an API
•	Obtain detailed information from a selected movie
•	Seamless infinite scrolling via lazy loading implementation
•	Async loading from API so nothing gets frozen/laggy
•	Dynamically download movie posters & images from external server
•	Add/remove movies to watchlist using plist storage
•	View list of saved movies in watchlist
•	Uses storage in Document directory for seamless plist editing/access

Classes Structure:
	FirstViewController
•	Make an API call to the URL
•	Populate main movies tableview with API information
•	Forwards the user to the DetailViewController when user clicks on any of the movie titles.
	SecondViewController
•	Retrieve saved movies from MyList.plist which is stored in the Documents Directory and populate tableview with stored information
•	Forwards the user to the DetailViewController when user clicks on any of the movie titles.
•	Allows the user to remove movies from their watchlist by swiping to delete using SwiftyPlistManager
	DetailViewController
•	Takes in movieId to retrieve detailed information about the movie
•	Makes another API call to server to retrieve details of the movie
•	Downloads poster from server for movie
•	Allows the user to add movies to their watchlist using SwiftyPlistManager

The classes are interconnected primarily through the DetailViewController since it is
interchangeable and both movie browser & my list uses the exact same controller & even
the same storyboard. Very modular.

Wishlist of Features for V2.0: 
•	Functional search bar connected to API
•	Prettier tableview cells
•	Implement star-based rating
•	Play trailer upon opening description

Self-Evaluation: 
I think the most incredible thing I did for this project is the fact it uses lazy loading, 
with almost no lag (depending on internet). I feel it is well-optimized especially when
handing large amount of data from the API. This application is something that I could use
in real life if the UI was a bit more polished because I love watching movies and I always
want to discover new and latest movies. This application provides an efficient solution to
a real problem. Sure, this application doesn’t have all of the bell & whistles, but this
application is pretty fast in what it really needs to do, retrieve movies.

Third Party Information:
Frameworks: 
•SwiftyPlistManager Developed by Rebeloper https://github.com/rebeloper/SwiftyPlistManager

