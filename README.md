# Yakports

## A demo API app using Yaks

Try it in your browser : http://yaks-airports.herokuapp.com/browser.html

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