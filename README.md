# Yakports

A demonstration of how to use [Yaks](https://github.com/plexus/yaks) to build a hypermedia API. It also contains some helpful snippets that might make it into Yaks proper, such as how to set up integration with Grape, or how to handle pagination in a CollectionMapper.

You can browse the API using the [HAL browser](http://yaks-airports.herokuapp.com/browser.html)

or try it on the command line with curl.

Some example URLs

```
http://yaks-airports.herokuapp.com/countries/DE
http://yaks-airports.herokuapp.com/airports/TXL
http://yaks-airports.herokuapp.com/countries/DE/airports
http://yaks-airports.herokuapp.com/countries/DE/airlines
```

Use the `Accept` header to request different formats.

The data is taken from [OpenFlights](http://openflights.org/data.html)

### HAL

```
$ curl -H 'Accept: application/hal+json' http://yaks-airports.herokuapp.com/countries/DE
```

```json
{
  "id": "DE",
  "name": "Germany",
  "iso3166_1_alpha_2": "DE",
  "dst_type": "E",
  "_links": {
    "airports": {
      "href": "/countries/DE/airports"
    },
    "airlines": {
      "href": "/countries/DE/airlines"
    }
  }
```

### Collection+JSON

```
$ curl -H 'Accept: application/vnd.collection+json' http://yaks-airports.herokuapp.com/countries/DE
```

```json

{
  "collection": {
    "version": "1.0",
    "items": [
      {
        "data": [
          {
            "name": "id",
            "value": "DE"
          },
          {
            "name": "name",
            "value": "Germany"
          },
          {
            "name": "iso3166_1_alpha_2",
            "value": "DE"
          },
          {
            "name": "dst_type",
            "value": "E"
          }
        ],
        "links": [
          {
            "rel": "airports",
            "href": "/countries/DE/airports"
          },
          {
            "rel": "airlines",
            "href": "/countries/DE/airlines"
          }
        ]
      }
    ]
  }
}
```

### JSON-API

```
$ curl -H 'Accept: application/vnd.api+json' http://yaks-airports.herokuapp.com/countries/DE
```

```json
{
  "countries": [
    {
      "id": "DE",
      "name": "Germany",
      "iso3166_1_alpha_2": "DE",
      "dst_type": "E"
    }
  ],
  "linked": {
  }
}
```