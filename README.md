# Flutter Weather Data Retrieval App

**Overview**

This is a Flutter application that allows users to retrieve real-time weather data based on city names using the OpenWeather API. It stores user-searched cities and provides an intuitive UI to check weather conditions.


**Tech Stack**

- Frontend: Flutter (Dart)

- API Services: OpenWeather API (weather package)

- Local Storage: SharedPreferences

**Setup Instructions**

***Prerequisites***

- Install Flutter by following the official Flutter installation guide.

- Obtain an API key from OpenWeather.

***Installation Steps***

- Clone the repository
```git clone <repository-url>```

- Navigate to the project directory
```cd <flutter_weather_app_directory>```

- Get the dependencies
```flutter pub get```

- Run the application
```flutter run```

**Usage**

- Open the app.

- Enter a city name in the input field.

- Click the See Weather Report button.

- The app retrieves and displays weather data.

- Previously searched cities are stored and displayed for quick access.

**API Integration**

- The app makes API requests to OpenWeather using the weather package.

- The retrieved data includes temperature, humidity, wind speed, and other weather details.

##### Note: Ensure you replace ```OPENWEATHER_API_KEY``` in the code with your actual API key.
