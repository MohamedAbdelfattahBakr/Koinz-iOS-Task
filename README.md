# Koinz Image App

This application retrieves a list of images using the Flickr API. It's designed with best practices in mind, using the MVVM-C architecture and SOLID design principles.

## Features

- **Flickr API Integration**: The app fetches images from the Flickr API
- **MVVM-C and SOLID**: The app is developed using the Model-View-ViewModel-Coordinator (MVVM-C) pattern, ensuring a clean architecture and easy maintenance. It also adheres to SOLID design principles for better scalability and testability.
- **Caching with Realm**: To provide a smoother user experience, the app caches images using Realm. This allows for quicker load times and less data usage over time.
user able to explore the application offline and continue scroll to fetch next page if it's not loaded before and fetch new data 

- **Pagination Support**: The app supports pagination, ensuring efficient loading and displaying of the images. This makes it easy to handle large sets of images without affecting app performance
