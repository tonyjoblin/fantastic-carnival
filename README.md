# README

## Reservations

This is a Ruby on Rails API that exposes a single reservations endpoint. This endpoint
is able to create or update reservations.

github: https://github.com/tonyjoblin/fantastic-carnival

The API currently accepts reservation documents in one of two formats (dubbed xyz and abc). Examples of the two formats can be found in `test/fixtures/files/reservations`.

## Setup

Note: this project was developed using the VSCode devcontainers. If you are using VSCode
and have the dev containers extension enabled you will have the option to reopen this project in dev container (basically a docker container).

Prerequisites:
* ruby 3.1.x
* bundler 2.3.x
* curl (optional, for testing)

Setting Up:
1. Clone the project using the github url above
2. To setup run `bin/setup`
3. To run the server run the command `bin/rails server`

## Endpoints

* POST http://localhost:3000/reservations, dual purpose create and update
* GET http://localhost:3000/reservations/{id}, where id can be a reservation code or an id

## Models

* Guest has many Phone
* Guest has many Reservation

Guest looks like this:
* first name (required)
* last name (required)
* phones
* email (unique, required)

Reservation looks like:
* code (required, must be unique)
* start_date (required)
* end_date (required)
* nights
* guests
* adults
* children
* infants
* status
* currency
* security_deposit
* total_paid
* payout_amount
* guest (required)

## How to extend for new reservation formats

The core reservation handling is performed by `Reservations::ReservationService` in
`app/lib/reservations`. This class is configurable and requires the following parameters:
* required_keys
* reservation_transform
* guest_transform
* service_code

The ReservationService can perform very generic transformations on the shape of the reservation payload to build the reservation and guest. At present the transforms only affect the shape of the data, eg key transforms. No value
transforms are supported at present. See discussion below on how to implement this.

The general recipe to add a new data source is:
1. Create a new service class, eg `Reservations::AcmeReservationService`
2. In your new service class configure ReservationService with your transforms
3. Add your new service class to `Reservations::ServiceMatcher`

***required_keys*** these are fields in the reservation payload that a service class needs to identify it's format. These are used by the `Reservations::ReservationService#accepts?`.

For example, "acmehotels.com" uses an 'acme_id' field to hold its reservation code, so 'acme_id' should be a required key. If the field is deeply nested you can use a format like this 'foo.bar'.

***reservation_transform*** This is a hash that specifies how to transform keys from the
payload into a hash that can be used to create or update a Reservation. This transforms keys in the hashes only, not values. The format of the transform can handle deeply nested hashes with a format like 'abc.xyz'.

Example:

```
{
  'reservation.acme_id' => 'code'
}
```

The values in this hash are the attribute names in the Reservations model. The keys
are the location in the reservation payload.

***guest_transform*** This is a hash that specifies how to transform the data in the
reservation payload into a hash that can be used to create or update a Guest. This transforms keys in the hashes only, not values. The format of the transform can handle deeply nested hashes with a format like 'abc.xyz'.

Example:

```
{
  'guest.email' => 'email'
}
```
The values in this hash are the attribute names in the Guest model. The keys
are the location in the reservation payload.

***service_code*** A string to identify where this data came from, eg ABNB, XYZ, ACME etc.

### Example: Adding a new data source

The general recipe to add a new data source is:
1. Create a new service class, eg `Reservations::AcmeReservationService`
2. In your new service class configure ReservationService with your transforms
3. Add your new service class to `Reservations::ServiceMatcher`

### Value transforms

Let us say that Acme uses the following date format 'DD/MM/YYYY', and maybe the data looks
like this:
```
{
  reservation: {
    first_night: '16/04/2023'
  }
}
```

Our current code has only been tested to work with dates like 'YYYY-MM-DD'. Assuming our
date parser won't handle 'DD/MM/YYYY' (I haven't checked) we would want to transform that
value to either 'YYYY-MM-DD' or to an actual Date object.

The current implementation only supports key transforms to change the shape of the data, not
value transforms. What we really want to do is something like this

```
{
  'reservation.first_night' => lambda { |output, value| ...transform code goes here ... }
}
```
This is not supported at present. You would need to make a change to `HashUtils.transform_hash`.

## Testing

### `bin/rails test`

This command runs the unit tests.

### `bin/test`

Prerequisites:
* `curl`
* The server must be running

This script will use "curl" to post requests to the server and write the responses to the
tmp folder. The requests can be found in `test/fixtures/files/reservations`. You need
to manually inspect the response files. All requests should execute successfully (codes 2xx).


