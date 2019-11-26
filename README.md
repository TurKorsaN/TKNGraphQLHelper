# TKNGraphQLHelper

[![CI Status](https://img.shields.io/travis/TurKorsaN/TKNGraphQLHelper.svg?style=flat)](https://travis-ci.org/TurKorsaN/TKNGraphQLHelper)
[![Version](https://img.shields.io/cocoapods/v/TKNGraphQLHelper.svg?style=flat)](https://cocoapods.org/pods/TKNGraphQLHelper)
[![License](https://img.shields.io/cocoapods/l/TKNGraphQLHelper.svg?style=flat)](https://cocoapods.org/pods/TKNGraphQLHelper)
[![Platform](https://img.shields.io/cocoapods/p/TKNGraphQLHelper.svg?style=flat)](https://cocoapods.org/pods/TKNGraphQLHelper)

## Installation

TKNGraphQLHelper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TKNGraphQLHelper'
```

## Usage

You need to create files for your each query, mutation and fragments. Especially fragment file names needs to be same with fragment name. 

Lets say our awesome query is like this:

MyAwesomeQuery.graphql
```
query myAwesomeQuery($myAwesomeParameter: String) {
    awesomeQuery(awesomeParameter: $myAwesomeParameter) {
        awesomeId
        awesomeName
        awesomeFragment {
            ...AwesomeFragment
            }
    }
}
```

And our awesome fragment is like this:

AwesomeFragment.graphql
```
fragment AwesomeFragment {
    awesomeFragmentId
    awesomeFragmentName
}
```

TKNGraphQLHelper requires graphql url and the bundle of your query files. 
```swift
var graphql = TKNGraphQLHelper(URL(string: "<YOUR_GRAPHQL_URL>")!, bundle: Bundle.main)

graphql.request("MyAwesomeQuery", 
    variables: ["myAwesomeParameter":"awesomeParameterContent"], 
    headers:["Content-Type":"application/json"], 
    success: { (result: TKNAnyDecodable) in
            //
        }, 
    failure: { (error: String) in

            })
```

If you want to use your own implementation for http requests, you can use createQueryBody or createQuery functions to use in your request body.

```
var graphql = TKNGraphQLHelper(bundle: Bundle.main)

let queryBody = graphql.createQueryBody("MyAwesomeQuery")
//or
let queryBodyWithParams = graphql.createQueryBody("MyAwesomeQuery", variables: ["myAwesomeParameter":"awesomeParameterContent"])
//or
let query = graphql.createQuery("MyAwesomeQuery")
```

## Author

TurKorsaN, korsan.ark@gmail.com

## License

TKNGraphQLHelper is available under the MIT license. See the LICENSE file for more info.
