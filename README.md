# San Francisco Food Truck Info Service

This is a REST API for searching nearby food trucks in San Francisco. You can search for food trucks by providing your location and a search radius, and optionally by food type. The API returns a list of food trucks within the specified search radius, sorted by distance from the specified location.

## Getting started


### Setup Application

To download & compile project dependency
```sh
$ mix deps.get 
$ mix deps.compile
```

### Environment variables

You can refer to this `.env.sample` file and make a duplicate file and set values as per local setup 

To load enviornment values in current terminal
```sh
$ source .env
```

### Running Untit Test

```sh
$ mix test
```


### Running

```sh
$ mix phx.server
```
or in an IEx:

```sh
$ iex -S mix phx.server
```

## API Endpoints

The API has the following endpoints:

`GET /api/food_trucks/near_by`

Searches for nearby food trucks based on the provided input parameters.

## Request Parameters
1. `food_type`(**optional**): The type of food to search for (e.g. "Taco", "Pizza", etc.). If not provided, all food types are searched.
2. `latitude`(**required**) : The latitude of the location to search from.
3. `longitude`(**required**): The longitude of the location to search from.
4. `radius` (**optional**): The search radius in meters (default: 5 miles).
5. `limit`(**optional**) : The maximum number of food trucks to return (default: 5 miles)


## Response

The API returns a JSON array of food trucks matching the search criteria, sorted by distance from the specified location.

1. `address`: Address of Food Truck
2. `available_food_items`: List of Food Items available
3. `direction_link`: Google Map link to start direction to the this food truck
4. `facility_type`: Type of Truck
5. `business_hours`: Business hours of Food Truck
6. `schedule`: Link of Schedule PDF 

If no food trucks match the search criteria, the API returns an empty JSON array.



```sh
curl --location --request GET 'localhost:4000/api/food_trucks/near_by?latitude=37.799375&longitude=-122.399972&radius=3&food_type=taco'
```
Example Response:
```json
{
    "data": [
        {
            "address": "BROADWAY: DAVIS ST to FRONT ST (50 - 99)",
            "available_food_items": [
                "Senor Sisig",
                "Filipino fusion food",
                "tacos",
                "burritos",
                "nachos",
                "rice plates. Various beverages.Chairman Bao",
                "Vegetable and meat sandwiches filled with Asian-flavored meats and vegetables."
            ],
            "business_hours": "",
            "direction_link": "https://www.google.com/maps/place/37.799260113502285,-122.39961794865545",
            "facility_type": "Truck",
            "schedule": "http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=21MFF-00099&ExportPDF=1&Filename=21MFF-00099_schedule.pdf"
        }
      ]
}

```



## Contributing

We use the following tools to ensure constantly high quality of code

- [credo](https://github.com/rrrene/credo) for linting
- [mix format](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html) for automatical code formatting and consistent code style


